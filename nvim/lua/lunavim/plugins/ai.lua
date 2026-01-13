-- AI prompt definitions for avante.nvim
-- This table contains predefined prompts for various AI-assisted coding tasks.
-- Each prompt is designed to work with the avante.nvim plugin's ask() function.
local prompts = {
  -- Grammar correction: Fixes English grammar while preserving code blocks
  grammar_correction = "Correct the text to standard English, but keep any code blocks inside intact.",

  -- Keyword extraction: Extracts main keywords from text
  keywords = "Extract the main keywords from the following text",

  -- Code readability analysis: Identifies and suggests fixes for readability issues
  code_readability_analysis = [[
    You must identify any readability issues in the code snippet.
    Some readability issues to consider:
    - Unclear naming
    - Unclear purpose
    - Redundant or obvious comments
    - Lack of comments
    - Long or complex one liners
    - Too much nesting
    - Long variable names
    - Inconsistent naming and code style.
    - Code repetition
    You may identify additional problems. The user submits a small section of code from a larger file.
    Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
    If there's no issues with code respond with only: <OK>
  ]],

  -- Code optimization: Suggests performance and efficiency improvements
  optimize_code = "Optimize the following code",

  -- Text summarization: Creates concise summaries of longer text
  summarize = "Summarize the following text",

  -- Translation: Translates text to Chinese while preserving code blocks
  translate = "Translate this into Chinese, but keep any code blocks inside intact",

  -- Code explanation: Provides detailed explanations of code functionality
  explain_code = "Explain the following code",

  -- Code completion: Completes partial code based on current filetype
  complete_code = function()
    return "Complete the following codes written in " .. vim.bo.filetype
  end,

  -- Documentation: Adds docstrings to code
  add_docstring = "Add docstring to the following codes",

  -- Bug fixing: Identifies and fixes bugs in code
  fix_bugs = "Fix the bugs inside the following codes if any",

  -- Test creation: Generates test cases for code
  add_tests = "Implement tests for the following code",
}

-- Get DeepSeek API key from environment or macOS keychain
-- This function attempts to retrieve the DeepSeek API key in the following order:
-- 1. First checks the DEEPSEEK_API_KEY environment variable
-- 2. If not found in environment, tries to retrieve from macOS keychain
-- 3. Returns nil if no API key is found
local function get_deepseek_api_key()
  -- Check environment variable first (most common setup)
  local env_key = os.getenv "DEEPSEEK_API_KEY"
  if env_key and env_key ~= "" then
    return env_key
  end

  -- If environment variable is not set, try macOS keychain
  -- This is useful for keeping API keys secure in the system keychain
  local cmd = "security find-generic-password -s 'deepseek-api-key' -w 2>/dev/null"
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read "*a"
    handle:close()
    if result and result ~= "" then
      -- Remove any whitespace from the keychain result
      return result:gsub("%s+", "")
    end
  end

  -- Return nil if no API key is found
  return nil
end

return {
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-mini/mini.pick",
      "ibhagwan/fzf-lua",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    init = function()
      -- Initialize DeepSeek API key from environment or macOS keychain before plugin loads
      local key = get_deepseek_api_key()
      if key then
        vim.env.DEEPSEEK_API_KEY = key
      end
    end,
    opts = {
      ---@alias Mode "agentic" | "legacy"
      ---@type Mode
      -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
      mode = "agentic",
      -- Custom instructions file for the AI assistant (contains rules and guidelines)
      instructions_file = ".airules.md",
      -- Provider for auto-suggestions (can be different from main provider)
      auto_suggestions_provider = "deepseek",
      -- Main provider for AI completions and queries
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-chat",
          api_key_name = "DEEPSEEK_API_KEY",
          extra_request_body = {
            timeout = 30000,
            max_tokens = 4096,
            temperature = 0,
          },
        },
      },

      windows = {
        -- Window position: "right", "left", "top", or "bottom"
        position = "right",
        width = 35,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          provider = "snacks",
          provider_opts = {
            title = "Avante Input", -- Title for the AI input window
            icon = " ",
          },
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
      },

      behaviour = {
        -- Automatically focus the sidebar when AI responses are generated
        auto_focus_sidebar = true,

        -- Enable/disable automatic AI suggestions (experimental feature)
        auto_suggestions = false, -- Experimental stage

        -- Whether auto-suggestions should respect ignore patterns (e.g., .gitignore)
        auto_suggestions_respect_ignore = false,

        -- Automatically set highlight groups for syntax highlighting in AI responses
        auto_set_highlight_group = true,

        -- Automatically set keymaps for AI interactions
        auto_set_keymaps = true,

        -- Automatically apply AI-generated diffs without confirmation
        auto_apply_diff_after_generation = false,

        -- Jump to the result buffer when AI generation finishes
        jump_result_buffer_on_finish = true,

        -- Enable paste from clipboard support in AI input
        support_paste_from_clipboard = false,

        -- Minimize diff output to show only changes
        minimize_diff = true,

        -- Enable token counting display (useful for monitoring API usage)
        enable_token_counting = false,

        -- Enable cursor planning mode for AI-assisted cursor movement
        enable_cursor_planning_mode = false,

        -- Enable Claude text editor tool mode for enhanced editing
        enable_claude_text_editor_tool_mode = false,

        -- Use current working directory as project root for AI context
        use_cwd_as_project_root = false,
      },

      prompt_logger = {
        -- Disable prompt logging for privacy
        enabled = false,
      },
      mappings = {
        submit = {
          -- Key mapping to submit prompts to AI
          normal = "<C-s>",
          insert = "<C-s>",
        },
      },
    },
    config = function(_, opts)
      -- Setup the avante.nvim plugin with the provided options
      require("avante").setup(opts)

      -- Register key mappings with which-key.nvim for discoverability
      -- All AI-related commands are under <leader>a prefix
      require("which-key").add {
        { "<leader>a", group = "Avante" }, -- NOTE: add for avante.nvim
        {
          mode = { "n", "v" },
          -- Grammar correction: Fix English grammar while preserving code blocks
          {
            "<leader>ag",
            function()
              require("avante.api").ask { question = prompts.grammar_correction }
            end,
            desc = "Grammar Correction(ask)",
          },
          -- Keyword extraction: Extract main keywords from text
          {
            "<leader>ak",
            function()
              require("avante.api").ask { question = prompts.keywords }
            end,
            desc = "Keywords(ask)",
          },
          -- Code readability analysis: Identify and suggest fixes for readability issues
          {
            "<leader>al",
            function()
              require("avante.api").ask { question = prompts.code_readability_analysis }
            end,
            desc = "Code Readability Analysis(ask)",
          },
          -- Code optimization: Suggest performance and efficiency improvements
          {
            "<leader>ao",
            function()
              require("avante.api").ask { question = prompts.optimize_code }
            end,
            desc = "Optimize Code(ask)",
          },
          -- Text summarization: Create concise summaries of longer text
          {
            "<leader>am",
            function()
              require("avante.api").ask { question = prompts.summarize }
            end,
            desc = "Summarize text(ask)",
          },
          -- Translation: Translate text to Chinese while preserving code blocks
          {
            "<leader>an",
            function()
              require("avante.api").ask { question = prompts.translate }
            end,
            desc = "Translate text(ask)",
          },
          -- Code explanation: Provide detailed explanations of code functionality
          {
            "<leader>ax",
            function()
              require("avante.api").ask { question = prompts.explain_code }
            end,
            desc = "Explain Code(ask)",
          },
          -- Code completion: Complete partial code based on current filetype
          {
            "<leader>ac",
            function()
              require("avante.api").ask { question = prompts.complete_code() }
            end,
            desc = "Complete Code(ask)",
          },
          -- Documentation: Add docstrings to code
          {
            "<leader>ad",
            function()
              require("avante.api").ask { question = prompts.add_docstring }
            end,
            desc = "Docstring(ask)",
          },
          -- Bug fixing: Identify and fix bugs in code
          {
            "<leader>ab",
            function()
              require("avante.api").ask { question = prompts.fix_bugs }
            end,
            desc = "Fix Bugs(ask)",
          },
          -- Test creation: Generate test cases for code
          {
            "<leader>au",
            function()
              require("avante.api").ask { question = prompts.add_tests }
            end,
            desc = "Add Tests(ask)",
          },
        },
      }
    end,
  },
}

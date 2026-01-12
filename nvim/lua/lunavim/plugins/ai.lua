local function get_macos_api_key()
  local env_key = os.getenv "DEEPSEEK_API_KEY"
  if env_key and env_key ~= "" then
    return env_key
  end
  local cmd = "security find-generic-password -s 'deepseek-api-key' -w &2>/dev/null"
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read "*a"
    handle:close()
    if result and result ~= "" then
      -- return "Bearer " .. result:gsub("%s+", "")
      return result:gsub("%s+", "")
    end
  end
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    init = function()
      local key = get_macos_api_key()
      if key then
        vim.env.DEEPSEEK_API_KEY = key
      end
    end,
    opts = {
      auto_suggestions_provider = "openai",
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-coder",
          auto_type = "api",
          api_key_name = "DEEPSEEK_API_KEY",
          extra_request_body = {
            timeout = 30000,
            max_tokens = 4096,
            temperature = 0,
          },
        },
      },

      windows = {
        position = "right",
        width = 35,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
      },

      behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}

return {
  -- CMP
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- ripgrep
      "mikavilpas/blink-ripgrep.nvim",
      -- dictionary
      "Kaiser-Yang/blink-cmp-dictionary",
      -- git
      "Kaiser-Yang/blink-cmp-git",
      -- tmux
      "mgalliou/blink-cmp-tmux",
      -- avante
      "Kaiser-Yang/blink-cmp-avante",
      -- luasnip
      { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    version = "1.*",
    opts = {
      enabled = function()
        return not vim.tbl_contains({ "oil" }, vim.bo.buftype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end,
      keymap = {
        preset = "default",
        ["<C-\\>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_signature_up", "fallback" },
        ["<C-d>"] = { "scroll_signature_down", "fallback" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        menu = {
          auto_show = true,
          border = "rounded",
        },
        documentation = { window = { border = "rounded" } },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        ghost_text = { enabled = true },
      },

      signature = { enabled = true, window = { border = "rounded" } },

      sources = {
        default = {
          "lsp",
          "avante",
          "snippets",
          "path",
          "buffer",
          "lazydev",
          "ripgrep",
        },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            opts = {},
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.labelDetails = { description = "(rg)" }
              end
              return items
            end,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            opts = {},
          },
          git = { module = "blink-cmp-git", name = "Git", opts = {} },
          tmux = {
            module = "blink-cmp-tmux",
            name = "tmux",
            opts = { all_panes = false, capture_history = false, triggered_only = false, trigger_chars = { "." } },
          },
          avante = { module = "blink-cmp-avante", name = "Avante", opts = {} },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      snippets = {
        preset = "luasnip",
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
      },
    },
  },
  -- Alignment
  {
    "nvim-mini/mini.align",
    event = "BufReadPost",
    opts = {
      mappings = LunaVim.plugin_raw "mini.align",
    },
  },
  -- Simple surround plugin
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = LunaVim.plugin_raw "mini.surround",
    },
  },
  -- Extend text object
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          -- code block
          o = ai.gen_spec.treesitter {
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          -- function
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
          -- class
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
        },
      }
    end,
  },
  {
    "Wansmer/treesj",
    keys = LunaVim.plugin_lazy "treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
      check_syntax = true,
      cursor_behavior = "hold",
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    lazy = true,
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "template_string" },
        },
        fast_wrap = {},
      }

      npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
    end,
  },
}

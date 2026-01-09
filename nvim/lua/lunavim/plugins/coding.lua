return {
  -- CMP
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },

    config = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })

      local cmp = require "cmp"
      local luasnip = require "luasnip"
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            col_offset = 3,
            side_padding = 0,
            scrollbar = true,
          },
          documentation = cmp.config.window.bordered {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        mapping = cmp.mapping.preset.insert(LunaVim.plugin_keymaps "nvim-cmp"),
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "nvim_lsp_signature_help", priority = 800 },
          { name = "luasnip", priority = 750, option = { show_autosnippets = true } },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = LunaVim.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return item
          end,
        },
      }
    end,
  },
  -- Alignment
  {
    "nvim-mini/mini.align",
    event = "InsertEnter",
    opts = {
      mappings = {
        start = "<leader>A",
        start_with_preview = "<leader>a",
      },
    },
  },
  -- Simple surround plugin
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = LunaVim.plugin_keymaps "mini.surround",
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
    keys = LunaVim.plugin_keymaps "treesj",
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
}

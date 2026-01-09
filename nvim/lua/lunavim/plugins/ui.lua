return {
  -- color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        -- Basic UI
        hl.FloatBorder = { fg = c.blue, bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }
        hl.CursorLine = { bg = c.bg_highlight }

        -- Bufferline
        -- hl.BufferLineFill = { bg = "NONE" }
        -- hl.BufferLineBackground = { bg = "NONE" }
        --
        -- hl.BufferLineTabSeparator = { fg = c.bg, bg = "NONE" }
        -- hl.BufferLineTabSeparatorVisible = { fg = c.bg, bg = "NONE" }
        -- hl.BufferLineTabSeparatorSelected = { fg = c.bg, bg = "NONE" }
        --
        -- hl.BufferLineBufferSelected = { bg = "NONE", fg = c.fg, bold = true }
        -- hl.BufferLineTabSelected = { bg = "NONE", fg = c.fg, bold = true }

        -- Treesitter context
        hl.TreesitterContext = { bg = "NONE", fg = c.blue1 }
        hl.TreesitterContextBottom = { underline = true, sp = c.blue5 }
        hl.TreesitterContextLineNumber = { bg = "NONE", fg = c.comment }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd [[colorscheme tokyonight]]
    end,
  },
  -- statue line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separator = "|",
        section_separators = { left = LunaVim.icons.ui.BoldDividerRight, right = LunaVim.icons.ui.BoldDividerLeft },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        sections = {
          lualine_b = { { "branch", icon = LunaVim.icons.git.Branch }, { "diff", symbols = LunaVim.icons.git } },
          lualine_c = { { "diagnostics", symbols = LunaVim.icons.diagnostics } },
          lualine_x = { "encoding", "fileformat", "filetype" },
        },
      },
    },
  },
  -- tab line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        show_buffer_close_icon = false,
        show_close_icon = false,
        themable = true,
        offsets = {
          { filetype = "neo-tree", text = "File Explorer", text_align = "left", separator = true },
        },
        diagnostics_indicator = function(count, level)
          local icons = LunaVim.icons.diagnostics
          local icon = level:match "error" and icons.Error or icons.Warn
          return " " .. icon .. count
        end,
        highlights = {
          background = { bg = "none" },
          fill = { bg = "none" },
          buffer_selected = { bg = "none", fg = "#fab387" },
          buffer_visible = { bg = "none", fg = "#a6adc8" },
          close_button = { bg = "none" },
          close_button_selected = { bg = "none" },
          close_button_visible = { bg = "none" },
          duplicate = { bg = "none" },
          duplicate_selected = { bg = "none" },
          duplicate_visible = { bg = "none" },
          error = { bg = "none" },
          error_selected = { bg = "none" },
          error_visible = { bg = "none" },
          hint = { bg = "none" },
          hint_selected = { bg = "none" },
          hint_visible = { bg = "none" },
          indicator_selected = { bg = "none" },
          indicator_visible = { bg = "none" },
          info = { bg = "none" },
          info_selected = { bg = "none" },
          info_visible = { bg = "none" },
          modified = { bg = "none" },
          modified_selected = { bg = "none" },
          modified_visible = { bg = "none" },
          numbers = { bg = "none" },
          numbers_selected = { bg = "none" },
          numbers_visible = { bg = "none" },
          offset_separator = { bg = "none" },
          pick = { bg = "none" },
          pick_selected = { bg = "none" },
          pick_visible = { bg = "none" },
          separator = { bg = "none" },
          separator_selected = { bg = "none" },
          separator_visible = { bg = "none" },
          tab = { bg = "none" },
          tab_close = { bg = "none" },
          tab_selected = { bg = "none" },
          tab_separator = { bg = "none" },
          tab_separator_selected = { bg = "none" },
          trunc_marker = { bg = "none" },
          warning = { bg = "none" },
          warning_selected = { bg = "none" },
          warning_visible = { bg = "none" },
        },
        options = {
          indicator = {
            icon = "",
            style = "none",
          },
          separator_style = { "", "" },
        },
      },
    },
  },
  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    lazy = true,
  },
  -- floating statusline
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local devicons = require "nvim-web-devicons"
      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
          placement = { vertical = "top", horizontal = "right" },
          zindex = 50,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          return {
            { " ", guibg = "NONE" },
            {
              { ft_icon and (" " .. ft_icon .. " ") or "", guifg = ft_color, guibg = "NONE" },
              { filename .. " ", gui = modified and "bold,italic" or "bold", guifg = "#7aa2f7", guibg = "NONE" },
            },
            { " ", guibg = "NONE" },
          }
        end,
      }
    end,
  },
  -- Lspsaga
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
  -- Notice and notify
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.set_formatting_pair"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      redirect = {
        view = "notify",
        filter = { event = "msg_show" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true, animate = { enabled = true } },
      notifier = { enabled = true, timeout = 5000 },
      input = { enabled = true },
      picker = { enabled = true },
      -- explorer = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
      statuscolumn = { enabled = true },
      scroll = { enabled = true },
      scope = { enabled = true },
      styles = {
        notification = { bg = "NONE", wo = { wrap = true } },
        picker = { border = "rounded" },
      },
    },
    keys = LunaVim.plugin_keymaps "snacks.nvim",
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LspAttach",
  },
  -- {
  --   "nvim-focus/focus.nvim",
  --   version = false,
  --   event = "WinEnter",
  --   opts = {
  --     enable = true,
  --     commands = true,
  --     autoresize = {
  --       enable = true,
  --       width = 0,
  --       height = 0,
  --       min_width = 20,
  --     },
  --     ui = {
  --       number = false,
  --       relativenumber = false,
  --       cursorline = true,
  --       signcolumn = true,
  --       winhighlight = false,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("focus").setup(opts)
  --     local ignore_filetypes = { 'neo-tree', 'TelescopePrompt', 'Trouble', 'lazy', 'mason' }
  --     local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })
  --     vim.api.nvim_create_autocmd('FileType', {
  --       group = augroup,
  --       callback = function(_)
  --         if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
  --           vim.b.focus_disable = true
  --         end
  --       end,
  --     })
  --   end,
  -- },
}

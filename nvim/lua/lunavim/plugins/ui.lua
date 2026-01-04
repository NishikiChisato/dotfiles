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
    },
    on_highlights = function(hl, c)
      hl.FloatBorder = { fg = c.blue, bg = "NONE" }
      hl.NormalFloat = { bg = "NONE" }
      hl.CursorLine = { bg = c.bg_highlight }
    end,
    config = function(_, opts)
      require "tokyonight".setup(opts)
      vim.cmd[[colorscheme tokyonight]]
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
        }
      },
    },
  },
  -- tab line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tab",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icons = LunaVim.icons.diagnostics
          local icon = level:match("error") and icons.Error or icons.Warn
          return " " .. icon .. count
        end,
        offsets = {
          { filetype = "neo-tree", text = "File Explorer", text_align = "left", separator = true }
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
          if filename == "" then filename = "[No Name]" end
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
    end
  },
  -- Lspsaga
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ui = {
        border = "rounded",
        code_action = "💡",
      },
      symbol_in_winbar = { enable = false },
    },
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
      input = { enabled = true },
      select = { enabled = true },
      notifier = { enabled = true, timeout = 3000, style = "fancy" },
      dashboard = { enabled = true },
      indent = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = { enabled = true },
      git = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>gG", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    },
  },
}

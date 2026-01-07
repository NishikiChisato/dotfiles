return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id) or {}

          local map_keys = LunaVim.plugin_keymaps("lsp") or {}
          for _, k in ipairs(map_keys) do
            vim.keymap.set("n", k[1], k[2], { buffer = bufnr, desc = "LSP: " .. k.desc })
          end

          local servers = require("lunavim.plugins.lsp.servers")
          local server_opts = servers[client.name]
          if server_opts and server_opts.keys then
            for _, k in ipairs(server_opts.keys) do
              vim.keymap.set("n", k[1], k[2], { buffer = bufnr, desc = k.desc })
            end
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local servers = require("lunavim.plugins.lsp.servers")
      require("mason").setup({ ui = { border = "rounded" } })

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local opts = servers[server_name] or {}
            opts.capabilities = vim.deepcopy(capabilities)
            require("lspconfig")[server_name].setup(opts)
          end,
        },
      })

      local icons = LunaVim.icons.diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        go = { "gofmt" },
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = LunaVim.plugin_keymaps("trouble.nvim"),
    opts = {
      auto_close = true,
      restore_window = false,
      padding = false,
      indent_lines = false,
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}

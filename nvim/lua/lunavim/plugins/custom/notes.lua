return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 4,
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰄵 " },
      },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = LunaVim.plugin_keymaps "obsidian.nvim",
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/workspace/DigitalGarden",
        },
      },
      legacy_commands = false,
      completion = { nvim_cmp = true, min_chars = 2 },
      note_id_func = function(title)
        return title
      end,
      ui = { enable = false },
    },
  },
}

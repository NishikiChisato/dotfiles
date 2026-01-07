local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapter = {
  insert_mode = "i",
  normal_mode = "n",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  term_mode = "t",
}

local mode_radapter = {}
(function()
  for k, v in pairs(mode_adapter) do
    mode_radapter[v] = k
  end
end)()

-- stylua: ignore start
local defaults = {
  normal_mode = {
    -- Cursor movement
    ["<C-H>"] = { "<C-W>h", { desc = "Move cursor left" } },
    ["<C-J>"] = { "<C-W>j", { desc = "Move cursor down" } },
    ["<C-K>"] = { "<C-W>k", { desc = "Move cursor up" } },
    ["<C-L>"] = { "<C-W>l", { desc = "Move cursor right" } },

    -- Split create
    ["<leader>sv"] = { "<C-w>v", { desc = "Split window vertically" } },
    ["<leader>sh"] = { "<C-w>s", { desc = "Split window horizontally" } },
    ["<leader>se"] = { "<C-w>=", { desc = "Make split equal size" } },
    ["<leader>sx"] = { ":close<Return>", { desc = "Close current split" } },

    -- Split resize
    ["<C-S-Up>"] = { ":resize   -2<Return>", { desc = "Expand split to top" } },
    ["<C-S-Down>"] = { ":resize   +2<Return>", { desc = "Expand split to wodn" } },
    ["<C-S-Left>"] = { ":vertical resize -2<Return>", { desc = "Expand split to left" } },
    ["<C-S-Right>"] = { ":vertical resize +2<Return>", { desc = "Expand split to right" } },

    -- Tab create
    ["<leader>to"] = { ":tabnew<Return>", { desc = "Open  a new tab" } },
    ["<leader>tx"] = { ":tabclose<Return>", { desc = "Close a new tab" } },

    -- Tab movement
    ["<A-h>"] = { "gt", { desc = "Goto next tab" } },
    ["<A-l>"] = { "gT", { desc = "Goto prev tab" } },

    -- Move tabs
    ["<A-S-h>"] = { ":tabm -1<Return>", { desc = "Move tab to left" } },
    ["<A-S-l>"] = { ":tabm +1<Return>", { desc = "Move tab to right" } },

    -- tags
    ["<C-P>"] = { "<C-I>", { desc = "Jump to next" } },
    ["<C-N>"] = { "<C-O>", { desc = "Jump to prev" } },

    ["<leader>nh"] = { ":nohl", { desc="No highlight" } },

    ["<leader>rn"] = { function() return ":IncRename " .. vim.fn.expand("<cword>") end, { desc = "Rename" } },
    ["<leader>,,"] = { function() require("conform").format({ async = true, lsp_format = "fallback" }) end, { desc = "Format Buffer" } },
  },

  insert_mode = {},

  visual_mode = {},

  visual_block_mode = {},

  term_mode = {},
}

local plugins = {
  ["snacks.nvim"] = {
    -- search
    { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
    { "<leader>ff",      function() Snacks.picker.files() end,           desc = "Find Files" },
    { "<leader>fs",      function() Snacks.picker.grep() end,            desc = "Grep Text" },
    { "<leader>fr",      function() Snacks.picker.recent() end,          desc = "Recent Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- { "<leader>e",      function() Snacks.explorer() end,               desc = "File Explorer" },
    -- lsp
    { "gr",              function() Snacks.picker.lsp_references() end,  desc = "LSP References" },
    { "gd",              function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- gh
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- util
    { "<leader>hs",      function() Snacks.notifier.show_history() end,  desc = "Notification History" },
    { "<leader>nd",      function() Snacks.notifier.hide() end,          desc = "Dismiss All Notifications" },
    { "<leader>lg",      function() Snacks.lazygit() end,                desc = "Lazygit" },
    { "<leader>tt",      function() Snacks.terminal() end,               desc = "Toggle Terminal" },
    { "<leader>z",       function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  ["nvim-cmp"] = {
    ["<C-k>"] = function(...)
      return (require("cmp").mapping.select_prev_item())(...)
    end,
    ["<C-j>"] = function(...)
      return (require("cmp").mapping.select_next_item())(...)
    end,
    ["<C-h>"] = function(...)
      return (require("cmp").mapping.complete())(...)
    end,
    ["<C-e>"] = function(...)
      return (require("cmp").mapping.abort())(...)
    end,
    ["<CR>"] = function(...)
      return (require("cmp").mapping.confirm({ select = true }))(...)
    end,
  },
  ["mini.surround"] = {
    add       = ",a", -- add:       Sa + textobj +    sign
    delete    = ",d", -- del:       Sd + sign
    replace   = ",r", -- replqce:   Sr + old     sign + new sign
    find      = ",n", -- find:      Sn + textobj
    find_left = ",p", -- rfind:     Sp + textobj
    highlight = ",h", -- highlight: Sh + textobj
  },
  ["treesj"] = {
    { "<leader>tj", "<CMD>TSJToggle<Return>", desc = "Toggle split/join code" },
  },
  ["yanky.nvim"] = {
    { "<leader>p", "<cmd>YankyRingHistory<Return>", mode = { "n", "x" }, desc = "Open Yank History" },
    { "y",         "<Plug>(YankyYank)",         mode = { "n", "x" }, desc = "Yank text" },
    { "p",         "<Plug>(YankyPutAfter)",     mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P",         "<Plug>(YankyPutBefore)",    mode = { "n", "x" }, desc = "Put yanked text before cursor" },
  },
  ["lsp"] = {
    { "K",          "<cmd>Lspsaga hover_doc<Return>",                                    desc = "Hover Documentation" },
    { "<leader>ca", "<cmd>Lspsaga code_action<Return>",                                  desc = "Code Action", mode = { "n", "v" } },
    { "<leader>rn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, expr = true,          desc = "Rename Symbol" },
    { "[d",         "<cmd>Lspsaga diagnostic_jump_prev<Return>",                         desc = "Prev Diagnostic" },
    { "]d",         "<cmd>Lspsaga diagnostic_jump_next<Return>",                         desc = "Next Diagnostic" },
  },
  ["trouble.nvim"] = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<Return>",                        desc = "Project Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<Return>",           desc = "Buffer Diagnostics" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<Return>",                desc = "Symbols (Trouble)" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<Return>", desc = "LSP Definitions" },
  },
}
-- stylua: ignore end

function M.set_keymaps(mode, key, val)
  local opts = generic_opts[mode_radapter[mode]] or generic_opts_any
  if type(val) == "table" then
    if val[2] ~= nil then
      opts = vim.tbl_deep_extend("force", opts, val[2])
    end
    val = val[1]
  end
  if val then
    vim.keymap.set(mode, key, val, opts)
  else
    vim.keymap.del(mode, key)
  end
end

function M.load_modes(mode, mapping)
  mode = mode_adapter[mode]
  for lhs, rhs in pairs(mapping) do
    M.set_keymaps(mode, lhs, rhs)
  end
end

function M.load(keymaps)
  for mode, mapping in pairs(keymaps) do
    M.load_modes(mode, mapping)
  end
end

function M.get_defaults()
  return defaults
end

function M.get_adapter()
  return mode_adapter
end

function M.load_defaults()
  M.load(M.get_defaults())
end

function M.clear_mappings(mappings)
  local default = M.get_defaults()
  for mode, mappings in pairs(mapping) do
    for key, _ in pairs(mapping) do
      if default[mode][key] ~= nil then
        M.set_keymaps(mode, key)
      end
    end
  end
end

function M.get_plguins()
  return plugins
end

function M.plugin_keymaps(plugin_name)
  local plugins = M.get_plguins()
  if plugins[plugin_name] == nil then
    error(("plugin: %s don't have keymaps"):format(plugin_name))
    return
  end
  return M.get_plguins()[plugin_name]
end

return M

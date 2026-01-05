local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode       = generic_opts_any,
  normal_mode       = generic_opts_any,
  visual_mode       = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode      = generic_opts_any,
  term_mode         = { silent = true }
}

local mode_adapter = {
  insert_mode       = "i",
  normal_mode       = "n",
  visual_mode       = "v",
  visual_block_mode = "x",
  command_mode      = "c",
  term_mode         = "t"
}

local mode_radapter = {}
(function()
  for k, v in pairs(mode_adapter) do
    mode_radapter[v] = k
  end
end
)()

local defaults = {
  normal_mode = {
    -- Cursor movement
    ["<C-H>"] = { "<C-W>h", { desc = "Move cursor left"  } },
    ["<C-J>"] = { "<C-W>j", { desc = "Move cursor down"  } },
    ["<C-K>"] = { "<C-W>k", { desc = "Move cursor up"    } },
    ["<C-L>"] = { "<C-W>l", { desc = "Move cursor right" } },

    -- Split create
    ["<leader>sv"] = { "<C-w>v"         , { desc = "Split window vertically" } },
    ["<leader>sh"] = { "<C-w>s"         , { desc = "Split window horizontally" } },
    ["<leader>se"] = { "<C-w>="         , { desc = "Make split equal size" } },
    ["<leader>sx"] = { ":close<Return>" , { desc = "Close current split" } },

    -- Split resize
    ["<C-S-Up>"]    = { ":resize   -2<Return>" , { desc = "Expand split to top" } },
    ["<C-S-Down>"]  = { ":resize   +2<Return>" , { desc = "Expand split to wodn" } },
    ["<C-S-Left>"]  = { ":vertical resize -2<Return>", { desc = "Expand split to left" } },
    ["<C-S-Right>"] = { ":vertical resize +2<Return>", { desc = "Expand split to right" } },

    -- Tab create
    ["<leader>to"] = { ":tabnew<Return>",   { desc = "Open  a new tab" } },
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
  },

  insert_mode = {
  },

  visual_mode = {
  },

  visual_block_mode = {
  },

  term_mode = {
  },
}

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

return M

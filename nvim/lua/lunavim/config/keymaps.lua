local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true }
}

local mode_adapter = {
  insert_mode = "i",
  normal_mode = "n",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  term_mode = "t"
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
    ["<C-H>"] = "<C-w>h",
    ["<C-J>"] = "<C-w>j",
    ["<C-K>"] = "<C-w>k",
    ["<C-L>"] = "<C-w>l",

    -- Split resize
    ["<C-S-Up>"] = ":resize -2<Return>",
    ["<C-S-Down>"] = ":resize +2<Return>",
    ["<C-S-Left>"] = ":vertical resize -2<Return>",
    ["<C-S-Right>"] = ":vertical resize +2<Return>",
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
    opts = val[2]
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

local M = {}

-- Keymaps
function M.inspect_global_keymaps(mode)
  local mapargs = vim.api.nvim_get_keymap(mode)
  local inspect = {}
  for _, args in ipairs(mapargs) do
    local dict = {
      ["lhs"] = args.lhs,
      ["rhs"] = args.rhs,
      ["callback"] = args.callback,
      ["desc"] = args.desc,
    }
    inspect[#inspect + 1] = dict
  end
  return inspect
end

function M.inspect_local_keymaps(mode)
  local mapargs = vim.api.nvim_buf_get_keymap(0, mode)
  local inspect = {}
  for _, args in ipairs(mapargs) do
    local dict = {
      ["lhs"] = args.lhs,
      ["rhs"] = args.rhs,
      ["callback"] = args.callback,
      ["desc"] = args.desc,
    }
    inspect[#inspect + 1] = dict
  end
  return inspect
end

function M.keymapping_exist(mode, key)
  -- check global
  local mapargs = vim.api.nvim_get_keymap(mode)
  for _, args in ipairs(mapargs) do
    if args.lhs == key or args.lhs == key:upper() then
      return true
    end
  end

  -- check local
  mapargs = vim.api.nvim_buf_get_keymap(0, mode)
  for _, args in ipairs(mapargs) do
    if args.lhs == key or args.lhs == key:upper() then
      return true
    end
  end

  return false
end

return M

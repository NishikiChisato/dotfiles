local M = {}

-- Keymaps
function M.dd(...)
  local args = { ... }
  vim.print(vim.inspect(args))
end

return M

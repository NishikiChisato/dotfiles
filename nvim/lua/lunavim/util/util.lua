local M = {}

function M.lock_table(tbl)
  local mt = getmetatable(tbl) or {}
  if mt.__newindex then
    vim.notify(("cannot lock %s, since__newindex is set"):format(tostring(tbl)), vim.log.levels.ERROR)
  end
  mt.__newindex = function()
    vim.notify(("%s is locked"):format(tostring(tbl)), vim.log.levels.ERROR)
  end
  return setmetatable(tbl, mt)
end

return M

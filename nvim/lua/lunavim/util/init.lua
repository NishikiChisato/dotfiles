local M = {}

local function load_builtin(path)
  local builtin = require(path)
  for k, v in pairs(builtin) do
    if not M[k] then
      M[k] = v
    else
      print(("key: %s has already existed, skipped"):format(k))
    end
  end
end

load_builtin "lunavim.util.modules"
load_builtin "lunavim.util.util"
load_builtin "lunavim.util.debug"

return M

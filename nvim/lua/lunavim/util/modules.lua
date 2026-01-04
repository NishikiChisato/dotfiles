local M = {}

function M.lazy_load(path)
  return setmetatable({}, {
    __index = function(_, key)
      return require(path)[key]
    end,
    __newindex = function(_, key, val)
      require(path)[key] = val
    end,
  })
end

function M.lazy_func(path)
  return setmetatable({}, {
    __index = function(_, key)
      return function(...)
        return require(path)[key](...)
      end
    end,
  })
end

return M

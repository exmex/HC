local setmetatable = setmetatable
local rawset = rawset
local error = error
local unpack = unpack
local print = print
local handler_registry = setmetatable({}, {
  __index = function(reg, _type)
    local list = {}
    rawset(reg, _type, list)
    return list
  end
})
module(...)
function new(_type, ...)
  local params = {
    ...
  }
  local list = handler_registry[_type]
  return setmetatable({}, {
    __index = function(handlers, format)
      local cb = list[format]
      if not cb then
        return nil
      end
      local handler = cb(unpack(params))
      rawset(handlers, format, handler)
      return handler
    end
  })
end
function register(_type, format, callback)
  local list = handler_registry[_type]
  list[format] = callback
end

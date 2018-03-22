local functions = {}
local tonumber_ = tonumber
local function tonumber(v, base)
  return tonumber_(v, base) or 0
end
functions.tonumber = tonumber
local function toint(v)
  return math.round(tonumber(v))
end
functions.toinit = toint
local tobool = function(v)
  return v ~= nil and v ~= false
end
functions.tobool = tobool
local totable = function(v)
  if type(v) ~= "table" then
    v = {}
  end
  return v
end
functions.totable = totable
local clone = function(object)
  local lookup_table = {}
  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for key, value in pairs(object) do
      new_table[_copy(key)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end
functions.clone = clone
local function class(classname, super)
  local superType = type(super)
  local cls
  if superType ~= "function" and superType ~= "table" then
    superType = nil
    super = nil
  end
  if superType == "function" or super and super.__ctype == 1 then
    cls = {}
    if superType == "table" then
      for k, v in pairs(super) do
        cls[k] = v
      end
      cls.__create = super.__create
      cls.super = super
    else
      cls.__create = super
      function cls.ctor()
      end
    end
    cls.__cname = classname
    cls.__ctype = 1
    function cls.new(...)
      local instance = cls.__create(...)
      for k, v in pairs(cls) do
        instance[k] = v
      end
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  else
    if super then
      cls = clone(super)
      cls.super = super
    else
      cls = {
        ctor = function()
        end
      }
    end
    cls.__cname = classname
    cls.__ctype = 2
    cls.__index = cls
    function cls.new(...)
      local instance = setmetatable({}, cls)
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  end
  return cls
end
functions.class = class
local extend = function(target, extending)
  local t = tolua.getpeer(target)
  if not t then
    t = {}
    tolua.setpeer(target, t)
  end
  extending.__index = extending
  setmetatable(t, extending)
  return target
end
functions.extend = extend
return functions

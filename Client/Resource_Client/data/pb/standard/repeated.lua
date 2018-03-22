local concat = table.concat
local setmetatable = setmetatable
local rawset = rawset
local repeated_tag = {}
local function new_message_repeated(field)
  local new = field.new
  local mt = {
    ["field"] = field,
    [repeated_tag] = field,
    ["is_repeated"] = true,
    ["__newindex"] = function(self, idx, value)
      rawset(self, idx, new(value))
    end
  }
  mt.__index = mt
  setmetatable(mt, {
    __call = function(mt, data)
      if data and data[repeated_tag] == field then
        return data
      end
      local self = setmetatable({}, mt)
      if not data then
        return self
      end
      for i = 1, #data do
        self[i] = new(data[i])
      end
      return self
    end
  })
  function mt:Add(val)
    val = val or new()
    self[#self + 1] = val
    return val
  end
  function mt:IsInitialized()
    for i = 1, #self do
      local val = self[i]
      local init, errmsg = val:IsInitialized()
      if not init then
        return init, errmsg
      end
    end
    return true
  end
  function mt:Clear()
    for i = 1, #self do
      self[i] = nil
    end
  end
  function mt:MergeFrom(src)
    local idx = #self
    for i = 1, #src do
      local msg2 = src[i]
      local val = new()
      idx = idx + 1
      self[idx] = val
      val:MergeFrom(msg2)
    end
  end
  function mt:CopyFrom(src)
    self:Clear()
    self:MergeFrom(src)
  end
  return mt
end
local function new_basic_repeated(field)
  local mt = {
    ["field"] = field,
    [repeated_tag] = field,
    ["is_repeated"] = true
  }
  mt.__index = mt
  setmetatable(mt, {
    __call = function(mt, data)
      if data and data[repeated_tag] == field then
        return data
      end
      local self = setmetatable({}, mt)
      if not data then
        return self
      end
      for i = 1, #data do
        self[i] = data[i]
      end
      return self
    end
  })
  function mt:Add(val)
    self[#self + 1] = val
    return val
  end
  function mt:IsInitialized()
    return true
  end
  function mt:Clear()
    for i = 1, #self do
      self[i] = nil
    end
  end
  function mt:MergeFrom(src)
    local idx = #self
    for i = 1, #src do
      idx = idx + 1
      self[idx] = src[i]
    end
  end
  function mt:CopyFrom(src)
    self:Clear()
    self:MergeFrom(src)
  end
  return mt
end
module(...)
function new(field)
  if field.is_message then
    return new_message_repeated(field)
  elseif field.is_group then
    return new_message_repeated(field)
  end
  return new_basic_repeated(field)
end

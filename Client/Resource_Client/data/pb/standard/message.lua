local error = error
local assert = assert
local tostring = tostring
local setmetatable = setmetatable
local rawget = rawget
local mod_path = string.match((...), ".*%.") or ""
local repeated = require(mod_path .. "repeated")
local new_repeated = repeated.new
local buffer = require(mod_path .. "buffer")
local new_buffer = buffer.new
local unknown = require(mod_path .. "unknown")
local new_unknown = unknown.new
local mod_parent_path = mod_path:match("(.*%.)[^.]*%.")
local utils = require(mod_parent_path .. "utils")
local copy = utils.copy
local _M = {}
local basic_types = {
  int32 = true,
  int64 = true,
  uint32 = true,
  uint64 = true,
  sint32 = true,
  sint64 = true,
  bool = true,
  fixed64 = true,
  sfixed64 = true,
  double = true,
  string = true,
  bytes = true,
  fixed32 = true,
  sfixed32 = true,
  float = true
}
local msg_tag = {}
local function new_message(mt, data)
  if data and data[msg_tag] == mt then
    return data
  end
  local msg = setmetatable({
    [".data"] = {}
  }, mt)
  if not data then
    return msg
  end
  local fields = mt.fields
  for i = 1, #fields do
    local field = fields[i]
    local name = field.name
    local value = data[name]
    if value then
      msg[name] = value
    end
  end
  return msg
end
_M.new = new_message
function _M.def(parent, name, ast)
  local methods = {}
  local fields = copy(ast.fields)
  local tags = {}
  local is_group = ast[".type"] == "group"
  local mt = {
    name = name,
    is_message = not is_group,
    is_group = is_group,
    fields = fields,
    methods = methods,
    tags = tags,
    extensions = copy(ast.extensions),
    __metatable = false
  }
  function mt.__index(msg, name)
    local data = rawget(msg, ".data")
    local value = data[name]
    if value then
      return value
    end
    local field = fields[name]
    if field then
      return field.default
    end
    local method = methods[name]
    if method then
      return method
    end
    if name == "unknown_fields" then
      value = new_unknown()
      data.unknown_fields = value
      return value
    end
    if name == msg_tag then
      return mt
    end
    error("Invalid field:" .. name)
  end
  function mt.__newindex(msg, name, value)
    local data = rawget(msg, ".data")
    local field = fields[name]
    if not field then
      error("Invalid field:" .. name)
    end
    if value then
      local new = field.new
      if new then
        value = new(value)
      end
    end
    data[name] = value
  end
  function mt.__tostring(msg)
    local data = rawget(msg, ".data")
    local str = tostring(data)
    return str:gsub("table", name)
  end
  local function new_msg(data)
    return new_message(mt, data)
  end
  mt.new = new_msg
  for i = 1, #fields do
    local field = fields[i]
    field["is_" .. field.rule] = true
    if basic_types[field.ftype] then
      field.is_basic = true
    else
      field.need_resolve = true
    end
  end
  if is_group then
    mt.tag = ast.tag
  else
    function methods:SerializePartial(format, depth)
      format = format or "binary"
      local encode = mt.encode[format]
      if not encode then
        return false, "Unsupported serialization format: " .. format
      end
      return encode(self, depth)
    end
    function methods:Merge(data, format, off)
      format = format or "binary"
      local decode = mt.decode[format]
      if not decode then
        return false, "Unsupported serialization format: " .. format
      end
      return decode(self, data, off or 1)
    end
    function methods:Serialize(format, depth)
      local init, errmsg = self:IsInitialized()
      if not init then
        return init, errmsg
      end
      return self:SerializePartial(format, depth)
    end
    function methods:ParsePartial(data, format, off)
      self:Clear()
      return self:Merge(data, format, off)
    end
    function methods:Parse(data, format, off)
      self:Clear()
      local msg, off_err = self:Merge(data, format, off)
      if not msg then
        return msg, off_err
      end
      local init, errmsg = self:IsInitialized()
      if not init then
        return init, errmsg
      end
      return msg, off_err
    end
  end
  function methods:Clear()
    local data = rawget(self, ".data")
    for i = 1, #fields do
      local field = fields[i]
      data[field.name] = nil
    end
  end
  function methods:IsInitialized()
    local data = rawget(self, ".data")
    for i = 1, #fields do
      local field = fields[i]
      local name = field.name
      local val = data[name]
      if val then
        if field.is_complex then
          local init, errmsg = val:IsInitialized()
          if not init then
            return init, errmsg
          end
        end
      elseif field.is_required then
        return false, "Missing required field: " .. name
      end
    end
    return true
  end
  function methods:MergeFrom(msg2)
    local data = rawget(self, ".data")
    for i = 1, #fields do
      local field = fields[i]
      local name = field.name
      local val2 = msg2[name]
      if val2 then
        if field.is_complex then
          local val = data[name]
          if not val then
            val = field.new()
            data[name] = val
          end
          val:MergeFrom(val2)
        else
          data[name] = val2
        end
      end
    end
  end
  function methods:CopyFrom(msg2)
    self:Clear()
    self:MergeFrom(msg2)
  end
  return mt
end
function _M.compile(node, mt, fields)
  local tags = mt.tags
  for i = 1, #fields do
    local field = fields[i]
    field.has_length = field.is_packed
    local tag = field.tag
    local user_type_mt = field.user_type_mt
    if user_type_mt then
      field.new = user_type_mt.new
      if field.is_group then
        field.is_complex = true
      elseif user_type_mt.is_enum then
        field.is_enum = true
      else
        field.has_length = true
        field.is_message = true
        field.is_complex = true
      end
    elseif field.is_packed then
      field.is_basic = true
    else
      field.is_basic = true
    end
    if field.is_repeated then
      field.new = new_repeated(field)
      field.is_complex = true
    end
    tags[tag] = field
  end
end
return _M

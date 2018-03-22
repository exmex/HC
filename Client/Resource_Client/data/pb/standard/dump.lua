local assert = assert
local pairs = pairs
local print = print
local error = error
local tostring = tostring
local setmetatable = setmetatable
local type = type
local sformat = string.format
local char = string.char
local mod_path = string.match((...), ".*%.") or ""
local buffer = require(mod_path .. "buffer")
local new_buffer = buffer.new
local append = function(buf, off, data)
  off = off + 1
  buf[off] = data
  return off
end
local function indent(buf, off, depth)
  return append(buf, off, ("  "):rep(depth))
end
local escapes = {}
for i = 0, 255 do
  escapes[char(i)] = sformat("\\%03o", i)
end
escapes["\""] = "\\\""
escapes["'"] = "\\'"
escapes["\\"] = "\\\\"
escapes["\r"] = "\\r"
escapes["\n"] = "\\n"
escapes["\t"] = "\\t"
local safe = "`~!@#$%^&*()_-+={}[]|:;<>,.?/"
for i = 1, #safe do
  local c = safe:sub(i, i)
  escapes[c] = c
end
local function safe_string(data)
  return data:gsub("([^%w ])", escapes)
end
module(...)
local basic = {
  int32 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  int64 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  sint32 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  sint64 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  uint32 = function(buf, off, val)
    return append(buf, off, sformat("%u", val))
  end,
  uint64 = function(buf, off, val)
    return append(buf, off, sformat("%u", val))
  end,
  bool = function(buf, off, val)
    return append(buf, off, val == 0 and "false" or "true")
  end,
  enum = function(buf, off, val)
    return append(buf, off, val)
  end,
  fixed64 = function(buf, off, val)
    return append(buf, off, sformat("%u", val))
  end,
  sfixed64 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  double = function(buf, off, val)
    return append(buf, off, tostring(val))
  end,
  string = function(buf, off, val)
    off = append(buf, off, "\"")
    off = append(buf, off, safe_string(val))
    return append(buf, off, "\"")
  end,
  bytes = function(buf, off, val)
    off = append(buf, off, "\"")
    off = append(buf, off, safe_string(val))
    return append(buf, off, "\"")
  end,
  fixed32 = function(buf, off, val)
    return append(buf, off, sformat("%u", val))
  end,
  sfixed32 = function(buf, off, val)
    return append(buf, off, sformat("%d", val))
  end,
  float = function(buf, off, val)
    return append(buf, off, sformat("%.8g", val))
  end
}
local dump_fields, dump_unknown_fields
local wire_types = {
  [0] = function(buf, off, val, depth)
    return append(buf, off, sformat(": %u", val))
  end,
  [1] = function(buf, off, val, depth)
    return append(buf, off, sformat(": 0x%016x", val))
  end,
  [2] = function(buf, off, val, depth)
    if type(val) == "table" then
      off = append(buf, off, " {\n")
      off = dump_unknown_fields(buf, off, val, depth + 1)
      off = indent(buf, off, depth)
      return append(buf, off, "}")
    end
    off = append(buf, off, ": \"")
    off = append(buf, off, safe_string(val))
    return append(buf, off, "\"")
  end,
  [3] = function(buf, off, val, depth)
    off = append(buf, off, " {\n")
    off = dump_unknown_fields(buf, off, val, depth + 1)
    off = indent(buf, off, depth)
    return append(buf, off, "}")
  end,
  [4] = nil,
  [5] = function(buf, off, val, depth)
    return append(buf, off, sformat(": 0x%08x", val))
  end
}
local function dump_field(buf, off, field, val, depth)
  off = indent(buf, off, depth)
  off = append(buf, off, field.name)
  local dump = field.dump
  if dump then
    if field.is_enum then
      off = append(buf, off, ": ")
      off = dump(buf, off, val)
    else
      off = append(buf, off, " {\n")
      off = dump(buf, off, val, depth + 1)
      off = indent(buf, off, depth)
      off = append(buf, off, "}")
    end
  else
    dump = basic[field.ftype]
    off = append(buf, off, ": ")
    off = dump(buf, off, val)
  end
  off = append(buf, off, "\n")
  return off
end
local function dump_repeated(buf, off, field, arr, depth)
  for i = 1, #arr do
    off = dump_field(buf, off, field, arr[i], depth)
  end
  return off
end
function dump_unknown_fields(buf, off, unknowns, depth)
  for i = 1, #unknowns do
    local field = unknowns[i]
    off = indent(buf, off, depth)
    off = append(buf, off, tostring(field.tag))
    local dump = wire_types[field.wire]
    if not dump then
      error("Invalid unknown field wire_type=" .. tostring(field.wire))
    end
    off = dump(buf, off, field.value, depth)
    off = append(buf, off, "\n")
  end
  return off
end
local function dump_fields(buf, off, msg, fields, depth)
  local data = msg[".data"]
  for i = 1, #fields do
    local field = fields[i]
    local val = data[field.name]
    if val then
      if field.is_repeated then
        off = dump_repeated(buf, off, field, val, depth)
      else
        off = dump_field(buf, off, field, val, depth)
      end
    end
  end
  local unknowns = data.unknown_fields
  if unknowns then
    return dump_unknown_fields(buf, off, unknowns, depth)
  end
  return off
end
local function group(buf, off, msg, fields, depth)
  return dump_fields(buf, off, msg, fields, depth)
end
local function message(buf, off, msg, fields, depth)
  return dump_fields(buf, off, msg, fields, depth)
end
local register_fields
local function get_type_dump(mt)
  local dump = mt.dump
  if not dump then
    if mt.is_enum then
      dump = basic.enum
    elseif mt.is_message then
      do
        local fields = mt.fields
        function dump(buf, off, msg, depth)
          return message(buf, off, msg, fields, depth)
        end
        register_fields(mt, fields)
      end
    elseif mt.is_group then
      do
        local fields = mt.fields
        function dump(buf, off, msg, depth)
          return group(buf, off, msg, fields, depth)
        end
        register_fields(mt, fields)
      end
    end
    mt.dump = dump
  end
  return dump
end
function register_fields(mt, fields)
  if mt.dump then
    return
  end
  for i = 1, #fields do
    local field = fields[i]
    local user_type_mt = field.user_type_mt
    if user_type_mt then
      field.dump = get_type_dump(user_type_mt)
    end
  end
end
function register_msg(mt)
  local fields = mt.fields
  get_type_dump(mt)
  return function(msg, depth)
    local buf = new_buffer()
    local off = message(buf, 0, msg, fields, depth or 0)
    local data = buf:pack(1, off, true)
    buf:release()
    return data
  end
end

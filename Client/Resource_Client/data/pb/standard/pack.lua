local assert = assert
local pairs = pairs
local print = print
local error = error
local tostring = tostring
local setmetatable = setmetatable
local type = type
local rawset = rawset
local mod_path = string.match((...), ".*%.") or ""
local buffer = require(mod_path .. "buffer")
local new_buffer = buffer.new
local struct = require("struct")
local spack = struct.pack
local bit = require("bit")
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local lshift = bit.lshift
local rshift = bit.rshift
local arshift = bit.arshift
local char = string.char
local zigzag64 = function(num)
  num = num * 2
  if num < 0 then
    num = -num - 1
  end
  return num
end
local function zigzag32(num)
  return bxor(lshift(num, 1), arshift(num, 31))
end
local function varint_next_byte(num)
  if num == nil then
    return 0
  end
  if num >= 0 and num < 128 then
    return num
  end
  local b = bor(band(num, 127), 128)
  return b, varint_next_byte(rshift(num, 7))
end
local append = function(buf, off, len, data)
  off = off + 1
  buf[off] = data
  return off, len + #data
end
module(...)
local function pack_varint64(num)
  return char(varint_next_byte(num))
end
local function pack_varint32(num)
  return char(varint_next_byte(num))
end
local basic = {
  varint64 = function(buf, off, len, num)
    return append(buf, off, len, pack_varint64(num))
  end,
  varint32 = function(buf, off, len, num)
    return append(buf, off, len, pack_varint32(num))
  end,
  svarint64 = function(buf, off, len, num)
    return append(buf, off, len, pack_varint64(zigzag64(num)))
  end,
  svarint32 = function(buf, off, len, num)
    return append(buf, off, len, pack_varint32(zigzag32(num)))
  end,
  fixed64 = function(buf, off, len, num)
    return append(buf, off, len, spack("<I8", num))
  end,
  sfixed64 = function(buf, off, len, num)
    return append(buf, off, len, spack("<i8", num))
  end,
  double = function(buf, off, len, num)
    return append(buf, off, len, spack("<d", num))
  end,
  fixed32 = function(buf, off, len, num)
    return append(buf, off, len, spack("<I4", num))
  end,
  sfixed32 = function(buf, off, len, num)
    return append(buf, off, len, spack("<i4", num))
  end,
  float = function(buf, off, len, num)
    return append(buf, off, len, spack("<f", num))
  end,
  string = function(buf, off, len, str)
    off = off + 1
    local len_data = pack_varint32(#str)
    buf[off] = len_data
    off = off + 1
    buf[off] = str
    return off, len + #len_data + #str
  end
}
local packed = setmetatable({}, {
  __index = function(tab, ftype)
    local fpack
    if type(ftype) == "string" then
      fpack = basic[ftype]
    else
      fpack = ftype
    end
    rawset(tab, ftype, function(buf, off, len, arr)
      for i = 1, #arr do
        off, len = fpack(buf, off, len, arr[i])
      end
      return off, len
    end)
  end
})
local function encode_field_tag(tag, wire_type)
  local tag_type = tag * 8 + wire_type
  return pack_varint32(tag_type)
end
_M.encode_field_tag = encode_field_tag
local pack_fields, pack_unknown_fields
local fixed64 = basic.fixed64
local fixed32 = basic.fixed32
local string = basic.string
local wire_pack = {
  [0] = function(buf, off, len, val)
    return append(buf, off, len, pack_varint64(val))
  end,
  [1] = function(buf, off, len, val)
    return fixed64(buf, off, len, val)
  end,
  [2] = function(buf, off, len, val)
    if type(val) == "table" then
      local field_len = 0
      local len_off
      off = off + 1
      len_off = off
      buf[len_off] = ""
      off, field_len = pack_unknown_fields(buf, off, 0, val)
      local len_data = pack_varint32(field_len)
      buf[len_off] = len_data
      return off, len + field_len + #len_data
    end
    return string(buf, off, len, val)
  end,
  [3] = function(buf, off, len, val)
    off, len = pack_unknown_fields(buf, off, len, val)
    return append(buf, off, len, encode_field_tag(val.tag, 4))
  end,
  [4] = nil,
  [5] = function(buf, off, len, val)
    return fixed32(buf, off, len, val)
  end
}
local function pack_length_field(buf, off, len, field, val)
  local pack = field.pack
  local field_len = 0
  local len_off
  off, len = append(buf, off, len, field.tag_type)
  off = off + 1
  len_off = off
  buf[off] = ""
  off, field_len = pack(buf, off, 0, val)
  local len_data = pack_varint32(field_len)
  buf[len_off] = len_data
  return off, len + field_len + #len_data
end
local function pack_repeated(buf, off, len, field, arr)
  local pack = field.pack
  local tag = field.tag_type
  if field.has_length then
    for i = 1, #arr do
      off, len = pack_length_field(buf, off, len, field, arr[i])
    end
  else
    for i = 1, #arr do
      off, len = append(buf, off, len, tag)
      off, len = pack(buf, off, len, arr[i])
    end
  end
  return off, len
end
function pack_unknown_fields(buf, off, len, unknowns)
  for i = 1, #unknowns do
    local field = unknowns[i]
    local wire = field.wire
    off, len = append(buf, off, len, encode_field_tag(field.tag, wire))
    local pack = wire_pack[wire]
    if not pack then
      error("Invalid unknown field wire_type=" .. tostring(wire))
    end
    off, len = pack(buf, off, len, field.value)
  end
  return off, len
end
local function pack_fields(buf, off, len, msg, fields)
  local data = msg[".data"]
  for i = 1, #fields do
    local field = fields[i]
    local val = data[field.name]
    if val and val ~= field.default then
      if field.is_repeated then
        if field.is_packed then
          off, len = pack_length_field(buf, off, len, field, val)
        else
          off, len = pack_repeated(buf, off, len, field, val)
        end
      elseif field.has_length then
        off, len = pack_length_field(buf, off, len, field, val)
      else
        off, len = append(buf, off, len, field.tag_type)
        off, len = field.pack(buf, off, len, val)
      end
    end
  end
  local unknowns = data.unknown_fields
  if unknowns then
    return pack_unknown_fields(buf, off, len, unknowns)
  end
  return off, len
end
local function group(buf, off, len, msg, fields, end_tag)
  local total = 0
  local len
  off, len = pack_fields(buf, off, len, msg, fields)
  off, len = append(buf, off, len, end_tag)
end
local function message(buf, off, len, msg, fields)
  return pack_fields(buf, off, len, msg, fields)
end
local map_types = {
  int32 = "varint32",
  uint32 = "varint32",
  bool = "varint32",
  enum = "varint32",
  int64 = "varint64",
  uint64 = "varint64",
  sint32 = "svarint32",
  sint64 = "svarint64",
  bytes = "string"
}
for k, v in pairs(map_types) do
  basic[k] = basic[v]
end
local wire_types = {
  int32 = 0,
  int64 = 0,
  uint32 = 0,
  uint64 = 0,
  sint32 = 0,
  sint64 = 0,
  bool = 0,
  enum = 0,
  fixed64 = 1,
  sfixed64 = 1,
  double = 1,
  string = 2,
  bytes = 2,
  message = 2,
  packed = 2,
  group = 3,
  group_start = 3,
  group_end = 4,
  fixed32 = 5,
  sfixed32 = 5,
  float = 5
}
_M.wire_types = wire_types
local register_fields
local function get_type_pack(mt)
  local pack = mt.pack
  if not pack then
    if mt.is_enum then
      do
        local pack_enum = basic.enum
        local values = mt.values
        function pack(buf, off, len, enum)
          return pack_enum(buf, off, len, values[enum])
        end
      end
    elseif mt.is_message then
      do
        local fields = mt.fields
        function pack(buf, off, len, msg)
          return message(buf, off, len, msg, fields)
        end
        register_fields(mt, fields)
      end
    elseif mt.is_group then
      do
        local fields = mt.fields
        local end_tag = encode_field_tag(mt.tag, wire_types.group_end)
        function pack(buf, off, len, msg)
          return group(buf, off, len, msg, fields, end_tag)
        end
        register_fields(mt, fields)
      end
    end
    mt.pack = pack
  end
  return pack
end
function register_fields(mt, fields)
  if mt.pack then
    return
  end
  local tags = mt.tags
  for i = 1, #fields do
    local field = fields[i]
    local tag = field.tag
    local ftype = field.ftype
    local wire_type = wire_types[ftype]
    local user_type_mt = field.user_type_mt
    if user_type_mt then
      field.pack = get_type_pack(user_type_mt)
      if field.is_group then
        wire_type = wire_types.group_start
      elseif user_type_mt.is_enum then
        wire_type = wire_types.enum
        if field.is_packed then
          field.pack = packed[field.pack]
        end
      else
        wire_type = wire_types.message
      end
    elseif field.is_packed then
      field.pack = packed[ftype]
    else
      field.pack = basic[ftype]
    end
    local tag_type = encode_field_tag(tag, wire_type)
    field.tag_type = tag_type
    field.wire_type = wire_type
  end
end
function register_msg(mt)
  local fields = mt.fields
  get_type_pack(mt)
  return function(msg, depth)
    local buf = new_buffer()
    local off, len = message(buf, 0, 0, msg, fields)
    local data = buf:pack(1, off, true)
    buf:release()
    assert(len == #data, "Invalid packed length.  This shouldn't happen, there is a bug in the message packing code.")
    return data
  end
end

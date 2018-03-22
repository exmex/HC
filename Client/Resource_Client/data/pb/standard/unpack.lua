local assert = assert
local pairs = pairs
local print = print
local error = error
local tostring = tostring
local setmetatable = setmetatable
local sformat = string.format
local type = type
local pcall = pcall
local rawset = rawset
local mod_path = string.match((...), ".*%.") or ""
local unknown = require(mod_path .. "unknown")
local new_unknown = unknown.new
local buffer = require(mod_path .. "buffer")
local new_buffer = buffer.new
local pack = require(mod_path .. "pack")
local encode_field_tag = pack.encode_field_tag
local wire_types = pack.wire_types
local struct = require("struct")
local sunpack = struct.unpack
local bit = require("bit")
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local lshift = bit.lshift
local rshift = bit.rshift
local arshift = bit.arshift
local char = string.char
local function unzigzag64(num)
  if band(num, 1) == 1 then
    num = -(num + 1)
  end
  return num / 2
end
local function unzigzag32(num)
  return bxor(arshift(num, 1), -band(num, 1))
end
module(...)
local function unpack_varint64(data, off)
  local b = data:byte(off)
  local num = band(b, 127)
  local boff = 7
  while b >= 128 do
    off = off + 1
    b = data:byte(off)
    num = bor(num, lshift(band(b, 127), boff))
    boff = boff + 7
  end
  return num, off + 1
end
local function unpack_varint32(data, off)
  local b = data:byte(off)
  local num = band(b, 127)
  local boff = 7
  while b >= 128 do
    off = off + 1
    b = data:byte(off)
    num = bor(num, lshift(band(b, 127), boff))
    boff = boff + 7
  end
  return num, off + 1
end
local basic = {
  varint64 = unpack_varint64,
  varint32 = unpack_varint32,
  svarint64 = function(data, off)
    local num
    num, off = unpack_varint64(data, off)
    return unzigzag64(num), off
  end,
  svarint32 = function(data, off)
    local num
    num, off = unpack_varint32(data, off)
    return unzigzag32(num), off
  end,
  fixed64 = function(data, off)
    return sunpack("<I8", data, off)
  end,
  sfixed64 = function(data, off)
    return sunpack("<i8", data, off)
  end,
  double = function(data, off)
    return sunpack("<d", data, off)
  end,
  fixed32 = function(data, off)
    return sunpack("<I4", data, off)
  end,
  sfixed32 = function(data, off)
    return sunpack("<i4", data, off)
  end,
  float = function(data, off)
    return sunpack("<f", data, off)
  end,
  string = function(data, off)
    local len
    len, off = unpack_varint32(data, off)
    local end_off = off + len
    return data:sub(off, end_off - 1), end_off
  end
}
local function decode_field_tag(data, off)
  local tag_type
  tag_type, off = unpack_varint32(data, off)
  local tag = rshift(tag_type, 3)
  local wire_type = band(tag_type, 7)
  return tag, wire_type, off
end
local unpack_unknown_field
local function try_unpack_unknown_message(data, off, len)
  local tag, wire_type, val
  local msg = new_unknown()
  while off <= len do
    tag, wire_type, off = decode_field_tag(data, off)
    val, off = unpack_unknown_field(data, off, len, tag, wire_type, msg)
  end
  if off - 1 ~= len then
    error(sformat("Malformed Message, truncated ((off:%d) - 1) ~= len:%d): %s", off, len, tostring(msg)))
  end
  return msg, off
end
local fixed64 = basic.fixed64
local fixed32 = basic.fixed32
local string = basic.string
local wire_unpack = {
  [0] = function(data, off, len, tag, unknowns)
    local val
    val, off = unpack_varint32(data, off)
    unknowns:addField(tag, 0, val)
    return val, off
  end,
  [1] = function(data, off, len, tag, unknowns)
    local val
    val, off = fixed64(data, off)
    unknowns:addField(tag, 1, val)
    return val, off
  end,
  [2] = function(data, off, len, tag, unknowns)
    local len, end_off, val
    len, off = unpack_varint32(data, off)
    end_off = off + len
    local status
    if len > 1 then
      status, val = pcall(try_unpack_unknown_message, data, off, end_off - 1)
    end
    if not status then
      val = data:sub(off, end_off - 1)
    end
    unknowns:addField(tag, 2, val)
    return val, end_off
  end,
  [3] = function(data, off, len, group_tag, unknowns)
    local tag, wire_type, val
    local group = unknowns:addGroup(group_tag)
    while off <= len do
      tag, wire_type, off = decode_field_tag(data, off)
      if wire_type == 4 then
        if tag ~= group_tag then
          error("Malformed Group, invalid 'End group' tag")
        end
        return group, off
      end
      val, off = unpack_unknown_field(data, off, len, tag, wire_type, group)
    end
    error("Malformed Group, missing 'End group' tag")
  end,
  [4] = nil,
  [5] = function(data, off, len, tag, unknowns)
    local val
    val, off = fixed32(data, off)
    unknowns:addField(tag, 5, val)
    return val, off
  end
}
function unpack_unknown_field(data, off, len, tag, wire_type, unknowns)
  local funpack = wire_unpack[wire_type]
  if funpack then
    return funpack(data, off, len, tag, unknowns)
  end
  error(sformat("Invalid wire_type=%d, for unknown field=%d, off=%d, len=%d", wire_type, tag, off, len))
end
local packed = setmetatable({}, {
  __index = function(tab, ftype)
    local funpack
    if type(ftype) == "string" then
      funpack = basic[ftype]
    else
      funpack = ftype
    end
    rawset(tab, ftype, function(data, off, len, arr)
      local i = #arr
      while off <= len do
        i = i + 1
        arr[i], off = funpack(data, off, len, nil)
      end
      return arr, off
    end)
  end
})
local unpack_field, unpack_fields
local function unpack_length_field(data, off, len, field, val)
  local field_len
  field_len, off = unpack_varint32(data, off, len)
  return field.unpack(data, off, off + field_len - 1, val)
end
local function unpack_field(data, off, len, field, mdata)
  local name = field.name
  local val
  if field.is_repeated then
    local arr = mdata[name]
    if not arr then
      arr = field.new()
      mdata[name] = arr
    end
    if field.is_packed then
      return unpack_length_field(data, off, len, field, arr)
    end
    if field.has_length then
      arr[#arr + 1], off = unpack_length_field(data, off, len, field, nil)
    else
      arr[#arr + 1], off = field.unpack(data, off, len)
    end
    return arr, off
  elseif field.has_length then
    val, off = unpack_length_field(data, off, len, field, mdata[name])
    mdata[name] = val
    return val, off
  end
  val, off = field.unpack(data, off, len)
  mdata[name] = val
  return val, off
end
local function unpack_fields(data, off, len, msg, tags, is_group)
  local tag, wire_type, field, val
  local mdata = msg[".data"]
  local unknowns
  while off <= len do
    tag, wire_type, off = decode_field_tag(data, off)
    if wire_type == 4 then
      if not is_group then
        error("Malformed Message, found extra 'End group' tag: " .. tostring(msg))
      end
      return msg, off
    end
    field = tags[tag]
    if field then
      if field.wire_type ~= wire_type then
        error(sformat("Malformed Message, wire_type of field doesn't match (%d ~= %d)!", field.wire_type, wire_type))
      end
      val, off = unpack_field(data, off, len, field, mdata)
    else
      if not unknowns then
        unknowns = mdata.unknown_fields
        if not unknowns then
          unknowns = new_unknown()
          mdata.unknown_fields = unknowns
        end
      end
      val, off = unpack_unknown_field(data, off, len, tag, wire_type, unknowns)
    end
  end
  if is_group then
    error("Malformed Group, truncated, missing 'End group' tag: " .. tostring(msg))
  end
  if off - 1 ~= len then
    error(sformat("Malformed Message, truncated ((off:%d) - 1) ~= len:%d): %s", off, len, tostring(msg)))
  end
  return msg, off
end
local function group(data, off, len, msg, tags, end_tag)
  msg, off = unpack_fields(data, off, len, msg, tags, true)
  if data:sub(off - #end_tag, off - 1) ~= end_tag then
    error("Malformed Group, invalid 'End group' tag: " .. tostring(msg))
  end
  return msg, off
end
local function message(data, off, len, msg, tags)
  return unpack_fields(data, off, len, msg, tags, false)
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
local register_fields
local function get_type_unpack(mt)
  local unpack = mt.unpack
  if not unpack then
    if mt.is_enum then
      do
        local unpack_enum = basic.enum
        local values = mt.values
        function unpack(data, off, len, enum)
          local enum
          enum, off = unpack_enum(data, off, len)
          return values[enum], off
        end
      end
    elseif mt.is_message then
      do
        local tags = mt.tags
        local new = mt.new
        function unpack(data, off, len, msg)
          msg = msg or new()
          return message(data, off, len, msg, tags)
        end
        register_fields(mt)
      end
    elseif mt.is_group then
      do
        local tags = mt.tags
        local new = mt.new
        local end_tag = encode_field_tag(mt.tag, wire_types.group_end)
        function unpack(data, off, len, msg)
          msg = msg or new()
          return group(data, off, len, msg, tags, end_tag)
        end
        register_fields(mt)
      end
    end
    mt.unpack = unpack
  end
  return unpack
end
function register_fields(mt)
  if mt.unpack then
    return
  end
  local tags = mt.tags
  local fields = mt.fields
  for i = 1, #fields do
    local field = fields[i]
    local tag = field.tag
    local ftype = field.ftype
    local wire_type = wire_types[ftype]
    local user_type_mt = field.user_type_mt
    if user_type_mt then
      field.unpack = get_type_unpack(user_type_mt)
      if field.is_group then
        wire_type = wire_types.group_start
      elseif user_type_mt.is_enum then
        wire_type = wire_types.enum
        if field.is_unpacked then
          field.unpack = packed[field.unpack]
        end
      else
        wire_type = wire_types.message
      end
    elseif field.is_unpacked then
      field.unpack = packed[ftype]
    else
      field.unpack = basic[ftype]
    end
    local tag_type = encode_field_tag(tag, wire_type)
    field.tag_type = tag_type
    field.wire_type = wire_type
  end
end
function register_msg(mt)
  local tags = mt.tags
  get_type_unpack(mt)
  return function(msg, data, off)
    return message(data, off, #data, msg, tags)
  end
end

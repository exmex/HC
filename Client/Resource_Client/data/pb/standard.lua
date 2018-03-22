local assert = assert
local error = error
local type = type
local sformat = string.format
local tsort = table.sort
local setmetatable = setmetatable
local mod_name = (...)
local mod_path = string.match(mod_name, ".*%.") or ""
local fpack = require(mod_name .. ".pack")
local funpack = require(mod_name .. ".unpack")
local fdump = require(mod_name .. ".dump")
local message = require(mod_name .. ".message")
local def_message, new_message, compile_message = message.def, message.new, message.compile
local utils = require(mod_path .. "utils")
local copy = utils.copy
local handlers = require(mod_path .. "handlers")
local new_handlers = handlers.new
local default_handler_list = {
  encode = {
    binary = fpack.register_msg,
    text = fdump.register_msg
  },
  decode = {
    binary = funpack.register_msg
  }
}
for _type, callbacks in pairs(default_handler_list) do
  for format, cb in pairs(callbacks) do
    handlers.register(_type, format, cb)
  end
end
local mt_tag = {}
local function pub_to_mt(pub)
  return pub[mt_tag]
end
local function get_root(node)
  local parent = node[".parent"]
  if parent then
    return get_root(parent)
  end
  return node
end
local find_type = function(node, name)
  local _type
  _type = node[name]
  if _type then
    return _type
  end
  for part in name:gmatch("([^.]+)") do
    _type = node[part]
    if not _type then
      return nil
    end
    node = _type
  end
  return _type
end
local check_package_prefix = function(node, name)
  local package = node[".package"]
  if package then
    package = package .. "."
    local plen = #package
    if name:sub(1, plen) == package then
      return true, name:sub(plen + 1)
    end
    return false, name
  end
  return false, name
end
local function resolve_type_internal(node, name)
  local _type = find_type(node, name)
  if _type then
    return _type
  end
  local parent = node[".parent"]
  if parent then
    return resolve_type_internal(parent, name)
  else
    local prefixed, sub_name = check_package_prefix(node, name)
    if prefixed then
      return resolve_type_internal(node, sub_name)
    end
    local imports = node[".imports"]
    if imports then
      for i = 1, #imports do
        local import = imports[i].proto
        _type = resolve_type_internal(imports[i].proto, name)
        if _type then
          return _type
        end
      end
    end
  end
  return nil
end
local function resolve_type(node, name)
  if name:sub(1, 1) == "." then
    name = name:sub(2)
    node = get_root(node)
  end
  return resolve_type_internal(node, name)
end
local function resolve_fields(node, fields)
  for i = 1, #fields do
    local field = fields[i]
    if field.need_resolve then
      local user_type = resolve_type(node, field.ftype)
      field.user_type_mt = pub_to_mt(user_type)
      field.need_resolve = nil
    end
  end
end
local function resolve_types(parent, types)
  for i = 1, #types do
    local ast = types[i]
    local node = parent[ast.name]
    local mt = pub_to_mt(node)
    if mt then
      local fields = mt.fields
      if fields then
        resolve_fields(node, fields)
      end
    end
    local types = ast.types
    if types then
      resolve_types(node, types)
    end
  end
end
local function compile_types(parent, types)
  for i = 1, #types do
    local ast = types[i]
    local node = parent[ast.name]
    local mt = pub_to_mt(node)
    if mt then
      local fields = mt.fields
      if fields then
        compile_message(node, mt, fields)
      end
    end
    local types = ast.types
    if types then
      compile_types(node, types)
    end
  end
end
local defines = {}
local function define_types(parent, types)
  if not types then
    return
  end
  for i = 1, #types do
    local ast = types[i]
    local name = ast.name
    local node_type = ast[".type"]
    local define = defines[node_type]
    if define then
      define(parent, name, ast)
    else
      error("No define function for:", node_type)
    end
  end
end
function defines.message(parent, name, ast)
  local mt = def_message(parent, name, ast)
  mt.encode = new_handlers("encode", mt)
  mt.decode = new_handlers("decode", mt)
  local pub = setmetatable({
    [".type"] = ast[".type"],
    [".parent"] = parent
  }, {
    __call = function(tab, data)
      return new_message(mt, data)
    end,
    __index = function(tab, key)
      if key == mt_tag then
        return mt
      end
    end,
    __metatable = false
  })
  define_types(pub, ast.types)
  parent[name] = pub
  return pub
end
defines.group = defines.message
function defines.enum(parent, name, ast)
  local pub = {}
  local values = copy(ast.values)
  local mt = {
    is_enum = true,
    values = values,
    new = function(val)
      if type(val) == "number" then
        val = values[val]
        assert(val, "Invalid ENUM value.")
      end
      return val
    end
  }
  local pub = setmetatable({
    [".type"] = ast[".type"]
  }, {
    __index = function(tab, key)
      local val = values[key]
      if val then
        return val
      end
      if key == mt_tag then
        return mt
      end
    end,
    __newindex = function()
      error("ENUM read-only can't add/modify ENUM values.")
    end,
    __metatable = false
  })
  parent[name] = pub
  return pub
end
local function check_extension(extensions, tag)
  for i = 1, #extensions do
    local extension = extensions[i]
    if type(extension) == "number" then
      if extension == tag then
        return true
      end
    else
      local first, last = extension[1], extension[2]
      if tag >= first and tag <= last then
        return true
      end
    end
  end
  return false
end
local sort_tags = function(f1, f2)
  return f1.tag < f2.tag
end
function defines.extend(parent, name, ast)
  local message = resolve_type(parent, name)
  assert(message, "Can't find extended 'message' " .. name)
  assert(message[".type"] == "message", "Only 'message' types can be extended.")
  local m_mt = pub_to_mt(message)
  local extensions = m_mt.extensions
  assert(extensions, "Extended 'message' type has no extensions, can't extend it.")
  local fields = ast.fields
  for i = 1, #fields do
    local field = fields[i]
    if not check_extension(extensions, field.tag) then
      error(sformat("Missing extension for field '%s' in extend '%s'", field.name, name))
    end
  end
  local extend = defines.message(parent, name, ast)
  local mt = pub_to_mt(extend)
  local m_fields = m_mt.fields
  local fields = mt.fields
  local tags = mt.tags
  local fcount = #fields
  for i = 1, #m_fields do
    local field = m_fields[i]
    local name = field.name
    fcount = fcount + 1
    fields[fcount] = field
    fields[name] = field
    tags[field.tag] = field
    tags[field.tag_type] = field
  end
  tsort(fields, sort_tags)
  return extend
end
module(...)
function compile(ast)
  local proto = {
    [".package"] = ast.package,
    [".imports"] = ast.imports
  }
  define_types(proto, ast.types)
  resolve_types(proto, ast.types)
  compile_types(proto, ast.types)
  return proto
end

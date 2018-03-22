local _G = _G
local io = io
local fopen = io.open
local assert = assert
local sformat = string.format
local print = print
local ploaders = package.loaders
local m_require = require
local dir_sep = package.config:sub(1, 1)
local path_sep = package.config:sub(3, 3)
local path_mark = package.config:sub(5, 5)
local path_match = "([^" .. path_sep .. "]*)" .. path_sep
local default_proto_path = ""
if package and package.path then
  for path in package.path:gmatch(path_match) do
    if not path:match("init.lua$") then
      path = path:gsub("%.lua$", ".proto")
      default_proto_path = default_proto_path .. path .. ";"
    end
  end
else
  default_proto_path = "." .. dir_sep .. path_mark .. ".proto;"
end
local mod_name = (...)
local backends = {}
local default_backend = "standard"
local function new_backend(name, compile, encode, decode)
  local backend = {
    compile = compile,
    encode = encode,
    decode = decode,
    cache = {}
  }
  backends[name] = backend
  return backend
end
local function get_backend(name)
  name = name or default_backend
  local backend = backends[name]
  if not backend then
    local mod = require(mod_name .. "." .. name)
    backend = new_backend(name, mod.compile, mod.encode, mod.decode)
  end
  return backend
end
get_backend(default_backend)
local function find_proto(name, search_path)
  local err_list = ""
  name = name:gsub("%.", dir_sep)
  for path in search_path:gmatch(path_match) do
    local fname = path:gsub(path_mark, name)
    local file, err = fopen(fname)
    if file then
      return file
    end
    err_list = err_list .. sformat([[

	no file %q]], fname)
  end
  return nil, err_list
end
local proto_file_to_name = function(file)
  local name = file:gsub("%.proto$", "")
  return name:gsub("/", ".")
end
module(...)
_M.path = default_proto_path
_M.new_backend = new_backend
function set_default_backend(name)
  local old = default_backend
  assert(get_backend(name) ~= nil)
  default_backend = name
  return old
end
local loading = "loading...."
function load_proto_ast(ast, name, backend, require)
  local b = get_backend(backend)
  if name then
    b.cache[name] = loading
  end
  local imports = ast.imports
  if imports then
    require = require or _M.require
    for i = 1, #imports do
      local import = imports[i]
      local name = proto_file_to_name(import.file)
      import.name = name
      import.proto = require(name, backend)
    end
  end
  local proto = b.compile(ast)
  if name then
    b.cache[name] = proto
  end
  return proto
end
local proto_parser
function load_proto(text, name, backend, require)
  if not proto_parser then
    proto_parser = m_require(mod_name .. ".proto.parser")
  end
  local ast = proto_parser.parse(text)
  return load_proto_ast(ast, name, backend, require)
end
function require(name, backend)
  local b = get_backend(backend)
  local proto = b.cache[name]
  assert(proto ~= loading, "Import loop!")
  if proto then
    return proto
  end
  local text = _G.LegendGetEncryptedFileData("data/" .. name .. ".proto")
  return load_proto(text, name, backend, require)
end
local function install_proto(mod_name, proto)
  local parent = _G
  local mod_path = mod_name:match("^(.*)%.[^.]*$")
  if mod_path then
    for part in mod_path:gmatch("([^.]+)") do
      local node = parent[part]
      if not node then
        node = {}
        parent[part] = node
      end
      parent = node
    end
    mod_name = mod_name:sub(#mod_path + 2)
  end
  parent[mod_name] = proto
  return proto
end
local function pb_loader(mod_name, ...)
  local proto = require(mod_name, ...)
  return function()
    return install_proto(proto[".package"] or mod_name, proto)
  end
end
_G.pb_loader = pb_loader
local raw
function decode_raw(...)
  if not raw then
    local proto = load_proto("message Raw {}")
    raw = proto.Raw
  end
  local msg = raw()
  return msg:Parse(...)
end
function _M.print(msg)
  io.write(msg:SerializePartial("text"))
end

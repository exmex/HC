local function serialize(writer, value, indent, proxy)
  indent = indent or ""
  local t = type(value)
  if t == "table" then
    value = value[proxy] or value
    writer:write("{\n")
    do
      local indent = indent .. "\t"
      for k, v in pairs(value) do
        writer:write(indent)
        writer:write("[")
        serialize(writer, k, indent, proxy)
        writer:write("] = ")
        serialize(writer, v, indent, proxy)
        writer:write(",\n")
      end
    end
    writer:write(indent)
    writer:write("}")
  elseif t == "string" then
    local escape = string.gsub(value, "%c", function(c)
      return string.format("\\%03o", string.byte(c))
    end)
    writer:write(string.format("%q", escape))
  elseif t == "userdata" or t == "function" then
    writer:write(string.format("%q", tostring(value)))
  elseif value == math.huge then
    writer:write("math.huge")
  elseif value == -math.huge then
    writer:write("-math.huge")
  else
    writer:write(tostring(value))
  end
end
ed.serialize = serialize
local function exportLuaModule(file, t, proxy)
  if type(file) == "string" then
    file = io.open(file, "w")
  end
  file:write("return\n")
  serialize(file, t, "", proxy)
  file:close()
  return file
end
ed.exportLuaModule = exportLuaModule

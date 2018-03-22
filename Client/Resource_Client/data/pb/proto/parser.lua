local lower = string.lower
local tremove = table.remove
local tsort = table.sort
local assert = assert
local mod_path = string.match((...), ".*%.") or ""
local lp = require("lpeg")
local scanner = require(mod_path .. "scanner")
local grammar = require(mod_path .. "grammar")
local sort_tags = function(f1, f2)
  return f1.tag < f2.tag
end
local create = function(tab, sub_tab)
  if not tab[sub_tab] then
    tab[sub_tab] = {}
  end
  return tab[sub_tab]
end
local Cap = function(...)
  return ...
end
local node_type = function(node)
  return node[".type"]
end
local make_node = function(node_type, node)
  node = node or {}
  node[".type"] = node_type
  return node
end
local function CapNode(ntype, ...)
  local fields = {
    ...
  }
  local fcount = #fields
  return function(...)
    local node = make_node(ntype, {
      ...
    })
    local idx = 0
    for i = 1, fcount do
      local name = fields[i]
      local val = tremove(node, 1)
      node[name] = val
    end
    return node
  end
end
local function message_body(...)
  local fields = {}
  local body = {
    fields = fields,
    ...
  }
  local types
  local tcount = 0
  local fcount = 0
  if #body == 1 and type(body[1]) == "string" then
    body[1] = nil
  end
  for i = 1, #body do
    local sub = body[i]
    local sub_type = node_type(sub)
    body[i] = nil
    if sub_type == "field" then
      fields[sub.name] = sub
      fcount = fcount + 1
      fields[fcount] = sub
    elseif sub_type == "extensions" then
      local list = create(body, "extensions")
      local idx = #list
      for i = 1, #sub do
        local range = sub[i]
        idx = idx + 1
        list[idx] = range
      end
    else
      if tcount == 0 then
        types = create(body, "types")
      end
      types[sub.name] = sub
      tcount = tcount + 1
      types[tcount] = sub
    end
  end
  tsort(fields, sort_tags)
  return body
end
local captures = {
  [1] = function(...)
    local types = {}
    local proto = {
      types = types,
      ...
    }
    local tcount = 0
    for i = 1, #proto do
      local sub = proto[i]
      local sub_type = node_type(sub)
      proto[i] = nil
      if sub_type == "option" then
        create(proto, "options")
        proto.options[sub.name] = sub.value
      elseif sub_type == "package" then
        proto.package = sub.name
      elseif sub_type == "import" then
        local imports = create(proto, "imports")
        imports[#imports + 1] = sub
      elseif sub_type == "service" then
        create(proto, "services")
        proto.services[sub.name] = sub
      else
        types[sub.name] = sub
        tcount = tcount + 1
        types[tcount] = sub
      end
    end
    return proto
  end,
  ["Package"] = CapNode("package", "name"),
  ["Import"] = CapNode("import", "file"),
  ["Option"] = CapNode("option", "name", "value"),
  ["Message"] = function(name, body)
    local node = make_node("message", body)
    node.name = name
    return node
  end,
  ["MessageBody"] = message_body,
  ["Extend"] = function(name, body)
    local node = make_node("extend", body)
    node.name = name
    return node
  end,
  ["ExtendBody"] = message_body,
  ["Group"] = function(rule, name, tag, body)
    local group_ftype = "group_" .. name
    local group = make_node("group", body)
    group.name = group_ftype
    group.tag = tag
    local field = make_node("field", {
      rule = rule,
      ftype = group_ftype,
      name = name,
      tag = tag,
      is_group = true
    })
    return group, field
  end,
  ["Enum"] = function(name, ...)
    local node = make_node("enum", {
      ...
    })
    local options
    local values = {}
    node.name = name
    node.values = values
    for i = 1, #node do
      local sub = node[i]
      local sub_type = node_type(sub)
      node[i] = nil
      if sub_type == "option" then
        options = options or {}
        options[sub.name] = sub.value
      else
        values[sub[1]] = sub[2]
        values[sub[2]] = sub[1]
      end
    end
    node.options = options
    return node
  end,
  ["EnumField"] = function(...)
    return {
      ...
    }
  end,
  ["Field"] = function(rule, ftype, name, tag, options)
    local field = make_node("field", {
      rule = rule,
      ftype = ftype,
      name = name,
      tag = tag,
      options = options
    })
    if options then
      field.default = options.default
      field.is_deprecated = options.deprecated
      field.is_packed = options.packed
      if field.is_packed then
        assert(field.rule == "repeated", "Only 'repeated' fields can be packed.")
      end
    end
    return field
  end,
  ["FieldOptions"] = function(...)
    local options = {
      ...
    }
    for i = 1, #options, 2 do
      local name = options[i]
      options[i] = nil
      local value = options[i + 1]
      options[i + 1] = nil
      options[name] = value
    end
    return options
  end,
  ["Extensions"] = CapNode("extensions"),
  ["Extension"] = function(first, last)
    if not last then
      return first
    end
    return {first, last}
  end,
  ["Service"] = CapNode("service", "name"),
  ["rpc"] = CapNode("rpc", "name", "request", "response"),
  ["Name"] = Cap,
  ["GroupName"] = Cap,
  ["ID"] = Cap,
  ["Constant"] = Cap,
  ["IntLit"] = tonumber,
  ["SNumLit"] = tonumber,
  ["StrLit"] = function(quoted)
    assert(quoted:sub(1, 1) == "\"")
    return quoted:sub(2, -2)
  end,
  ["BoolLit"] = function(bool)
    bool = lower(bool)
    return bool == "true"
  end,
  ["FieldRule"] = Cap,
  ["Type"] = Cap
}
local ast_patt = lp.P(grammar.apply({}, captures)) * (scanner.EOF + scanner.error("invalid character"))
module(...)
function parse(contents)
  return ast_patt:match(contents)
end

local Set = require("util.set")
local TagContainer = {
  mt = {}
}
TagContainer.mt.__index = TagContainer
function TagContainer.create()
  local container = {}
  setmetatable(container, TagContainer.mt)
  container.set = Set.create({})
  container.index = {}
  return container
end
function TagContainer.insert(container, obj, ...)
  container.set:insert(obj)
  local arg = ed.pack(...)
  for _, tagName in ipairs(arg) do
    local tagValue = obj[tagName]
    if tagValue then
      container.index[tagName] = container.index[tagName] or {}
      container.index[tagName][tagValue] = container.index[tagName][tagValue] or Set.create({})
      container.index[tagName][tagValue]:insert(obj)
    end
  end
end
function TagContainer.get(container, tagMapping)
  local resultSet
  local init = false
  for tagName, tagValue in pairs(tagMapping) do
    if not container.index[tagName] then
      return Set.create({})
    end
    if not init then
      resultSet = container.index[tagName][tagValue]
      if not resultSet then
        return Set.create({})
      end
      init = true
    else
      resultSet = Set.intersection(resultSet, container.index[tagName][tagValue])
    end
  end
  return resultSet
end
function TagContainer.removeIf(container, if_clause)
  container.set:removeIf(if_clause)
  for _, tagValueMapping in pairs(container.index) do
    if tagValueMapping then
      for _, tagSet in pairs(tagValueMapping) do
        if tagSet then
          tagSet:removeIf(if_clause)
        end
      end
    end
  end
end
return TagContainer

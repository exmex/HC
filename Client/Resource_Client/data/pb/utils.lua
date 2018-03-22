local type = type
local pairs = pairs
module(...)
local function copy_recur(seen, tab)
  if type(tab) ~= "table" then
    return tab
  end
  local new = seen[tab]
  if new then
    return new
  end
  new = {}
  seen[tab] = new
  for k, v in pairs(tab) do
    k = copy_recur(seen, k)
    v = copy_recur(seen, v)
    new[k] = v
  end
  return new
end
function copy(tab)
  if tab then
    local seen = {}
    return copy_recur(seen, tab)
  end
  return tab
end

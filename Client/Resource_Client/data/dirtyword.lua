local ed = ed
local dict
local function make_dict()
  local tab = ed.getDataTable("dirtywords")
  dict = {}
  for k, _ in pairs(tab) do
    if k ~= name then
      local node = dict
      for i, c, b in utf8.chars(k) do
        if not node[c] then
          node[c] = {}
        end
        node = node[c]
      end
      node.ending = true
    end
  end
end
local function check(array, i)
  local node = dict
  local j = i - 1
  while true do
    if not node or node.ending then
      break
    end
    j = j + 1
    local c = array[j]
    node = node[c]
  end
  if node and node.ending then
    return table.concat(array, "", i, j)
  end
end
local function dirtyword_check(text)
  if not dict then
    make_dict()
  end
  local array = {}
  for i, c, b in utf8.chars(text) do
    array[i] = c
  end
  for i = 1, #array do
    local word = check(array, i)
    if word then
      return word
    end
  end
end
ed.dirtyword_check = dirtyword_check

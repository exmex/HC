local ed = ed
local class = {
  mt = {}
}
ed.StringBuffer = class
class.mt.__index = class
local function StringBufferCreate(...)
  local self = {
    what = "StringBuffer",
    list = {}
  }
  setmetatable(self, class.mt)
  self:write(...)
  return self
end
class.create = StringBufferCreate
ed.StringBufferCreate = StringBufferCreate
local insert = table.insert
local type = type
local tostring = tostring
local select = select
local function append(self, ...)
  local n = select("#", ...)
  for i = 1, n do
    local v = select(i, ...)
    if type(v) ~= string then
      v = tostring(v)
    end
    insert(self.list, v)
  end
end
class.append = append
function class.mt:__tostring()
  if #self.list == 0 then
    return ""
  end
  if #self.list > 1 then
    self.list = {
      table.concat(self.list)
    }
  end
  return self.list[1]
end
local clear = function(self)
  self.list = {}
end
class.clear = clear
class.write = append
function class.flush()
end
function class.close()
end

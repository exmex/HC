local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.heroselectlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("heroselect")
  setmetatable(self, class.mt)
  return self
end
class.create = create

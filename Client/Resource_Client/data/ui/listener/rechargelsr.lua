local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.rechargelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("recharge")
  setmetatable(self, class.mt)
  return self
end
class.create = create

local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipdetaillsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("equipdetail")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function closeWindow(self)
  ed.playEffect(ed.sound.equipDetail.closeWindow)
end
class.closeWindow = closeWindow

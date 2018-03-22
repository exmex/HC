local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.fragmentcomposelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("fragmentcompose")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createWindow(self)
  ed.playEffect(ed.sound.fragmentCompose.openWindow)
end
class.createWindow = createWindow
local function closeWindow(self)
  ed.playEffect(ed.sound.fragmentCompose.closeWindow)
end
class.closeWindow = closeWindow

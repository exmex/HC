local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.tasklsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("task")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createWindow(self)
  ed.playEffect(ed.sound.task.createWindow)
end
class.createWindow = createWindow
local function closeWindow(self)
  ed.playEffect(ed.sound.task.closeWindow)
end
class.closeWindow = closeWindow
local function createPopWindow(self)
  ed.playEffect(ed.sound.task.createPopWindow)
end
class.createPopWindow = createPopWindow
local function closePopWindow(self)
  ed.playEffect(ed.sound.task.closePopWindow)
end
class.closePopWindow = closePopWindow
local function clickClose(self)
  ed.playEffect(ed.sound.task.clickClose)
end
class.clickClose = clickClose
local function pressTaskBoard(self)
  ed.playEffect(ed.sound.task.pressTaskBoard)
end
class.pressTaskBoard = pressTaskBoard
local function clickTaskBoard(self)
  ed.playEffect(ed.sound.task.clickTaskBoard)
end
class.clickTaskBoard = clickTaskBoard
local function clickPopWindowok(self)
  ed.playEffect(ed.sound.task.clickPopWindowok)
end
class.clickPopWindowok = clickPopWindowok
local function popWindowTitleAnim(self)
  ed.playEffect(ed.sound.task.popWindowTitleAnim)
end
class.popWindowTitleAnim = popWindowTitleAnim

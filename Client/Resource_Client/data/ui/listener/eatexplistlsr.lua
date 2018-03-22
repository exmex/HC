local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.eatexplistlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("eatexplist")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local createWindow = function(self)
end
class.createWindow = createWindow
local function closeWindow(self)
  ed.playEffect(ed.sound.eatExpList.closeWindow)
end
class.closeWindow = closeWindow
local function clickHero(self)
  ed.playEffect(ed.sound.eatExpList.clickHero)
end
class.clickHero = clickHero
local function levelupAnim(self)
  ed.playEffect(ed.sound.eatExpList.levelUp)
end
class.levelupAnim = levelupAnim

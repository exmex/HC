local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stagedetaillsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("stagedetail")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickDisabledgo(self)
  ed.playEffect(ed.sound.stageDetail.clickDisabledGo)
end
class.clickDisabledgo = clickDisabledgo
local function clickgo(self)
  ed.playEffect(ed.sound.stageDetail.clickGo)
end
class.clickgo = clickgo
local function pressEnemy(self)
  ed.playEffect(ed.sound.stageDetail.clickEnemy)
end
class.pressEnemy = pressEnemy
local function pressReward(self)
  ed.playEffect(ed.sound.stageDetail.clickReward)
end
class.pressReward = pressReward

local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stagefailedlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("stagefailed")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickMenu(self)
  ed.playEffect(ed.sound.stageFailed.nextStage)
  ed.stopEffect(ed.audioParam.effects.battleResult)
end
class.clickMenu = clickMenu
local function clickBack(self)
  ed.playEffect(ed.sound.stageFailed.replay)
  ed.stopEffect(ed.audioParam.effects.battleResult)
end
class.clickBack = clickBack

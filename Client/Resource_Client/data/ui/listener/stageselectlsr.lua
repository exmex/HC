local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stageselectlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("stageselect")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickKeyStage(self)
  ed.playEffect(ed.sound.selectStage.clickStage)
end
class.clickKeyStage = clickKeyStage
local function clickNotKeyStage(self)
  ed.playEffect(ed.sound.selectStage.clickStage)
end
class.clickNotKeyStage = clickNotKeyStage
local function clickNormalMode(self)
  ed.playEffect(ed.sound.selectStage.clickNormalMode)
end
class.clickNormalMode = clickNormalMode
local function clickEliteMode(self)
  ed.playEffect(ed.sound.selectStage.clickNormalMode)
end
class.clickEliteMode = clickEliteMode
local function clickChangeChapter(self)
  ed.playEffect(ed.sound.selectStage.clickChapter)
end
class.clickChangeChapter = clickChangeChapter

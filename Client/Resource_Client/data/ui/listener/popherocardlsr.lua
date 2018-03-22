local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.popherocardlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("popherocard")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local createStonePrompt = function(self)
  ed.playEffect(ed.sound.tavern.createStonePrompt)
end
class.createStonePrompt = createStonePrompt
local createGetNewHero = function(self)
  ed.playEffect(ed.sound.tavern.createGetNewHero)
end
class.createGetNewHero = createGetNewHero
local showCardAnim = function(self)
  ed.playEffect(ed.sound.tavern.showCardAnim)
end
class.showCardAnim = showCardAnim
local clickCardLayer = function(self)
  ed.playEffect(ed.sound.tavern.clickCardLayer)
end
class.clickCardLayer = clickCardLayer
local createCardLayer = function(self)
  ed.playEffect(ed.sound.tavern.createCardLayer)
end
class.createCardLayer = createCardLayer
local closeCardLayer = function(self)
  ed.playEffect(ed.sound.tavern.closeCardLayer)
end
class.closeCardLayer = closeCardLayer

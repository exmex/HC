local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.poptavernlootlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("poptavernloot")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createLootCard(self)
  ed.playEffect(ed.sound.tavern.createLootCard)
end
class.createLootCard = createLootCard
local function closeLootCard(self)
  ed.playEffect(ed.sound.tavern.closeLootCard)
end
class.closeLootCard = closeLootCard
local function createLootsLayer(self)
  ed.playEffect(ed.sound.tavern.createLootsLayer)
end
class.createLootsLayer = createLootsLayer
local function closeLootsLayer(self)
  ed.playEffect(ed.sound.tavern.closeLootsLayer)
end
class.closeLootsLayer = closeLootsLayer
local function clickCloseLoots(self)
  ed.playEffect(ed.sound.tavern.clickCloseLoots)
end
class.clickCloseLoots = clickCloseLoots
local function clickTavernAgain(self)
  ed.playEffect(ed.sound.tavern.clickTavernAgain)
end
class.clickTavernAgain = clickTavernAgain
local function openBoxAnim(self)
  ed.playEffect(ed.sound.tavern.openBoxAnim)
end
class.openBoxAnim = openBoxAnim
local function showLootAnim(self)
  ed.playEffect(ed.sound.tavern.showLootAnim)
end
class.showLootAnim = showLootAnim

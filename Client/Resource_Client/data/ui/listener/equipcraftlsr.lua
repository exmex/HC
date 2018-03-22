local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipcraftlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("equipcraft")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createWindow(self)
  ed.playEffect(ed.sound.equipCraft.openWindow)
end
class.createWindow = createWindow
local function closeWindow(self)
  ed.playEffect(ed.sound.equipCraft.closeWindow)
end
class.closeWindow = closeWindow
local function clickOpenCraftLayer(self)
  ed.playEffect(ed.sound.equipCraft.clickOpenCraft)
end
class.clickOpenCraftLayer = clickOpenCraftLayer
local function clickWearEquip(self)
  ed.playEffect(ed.sound.equipCraft.clickWearEquip)
end
class.clickWearEquip = clickWearEquip
local function clickCraftButton(self)
  ed.playEffect(ed.sound.equipCraft.clickCraftBackButton)
end
class.clickCraftButton = clickCraftButton
local function clickCraftButtonDisenabled(self)
  ed.playEffect(ed.sound.equipCraft.clickDisenabledCraftButton)
end
class.clickCraftButtonDisenabled = clickCraftButtonDisenabled
local function clickTreeNode(self)
  ed.playEffect(ed.sound.equipCraft.clickTreeIcon)
end
class.clickTreeNode = clickTreeNode
local function clickHistoryNode(self)
  ed.playEffect(ed.sound.equipCraft.clickTreeIcon)
end
class.clickHistoryNode = clickHistoryNode
local function upgradeFailed(self)
  ed.playEffect(ed.sound.equipCraft.upgradeFailed)
end
class.upgradeFailed = upgradeFailed
local function craftFailed(self)
  ed.playEffect(ed.sound.equipCraft.craftFailed)
end
class.upgradeFailed = upgradeFailed
local function upgradeSuccess(self)
  ed.playEffect(ed.sound.equipCraft.upgradeSuccess)
end
class.upgradeSuccess = upgradeSuccess
local craftSuccess = function(self)
end
class.craftSuccess = craftSuccess

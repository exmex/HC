local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.herodetaillsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("herodetail")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createWindow(self)
  ed.playEffect(ed.sound.heroDetail.createWindow)
end
class.createWindow = createWindow
local function closeWindow(self)
  ed.playEffect(ed.sound.heroDetail.closeWindow)
end
class.closeWindow = closeWindow
local function createSkillLayer(self)
  ed.playEffect(ed.sound.heroDetail.createSkillLayer)
end
class.createSkillLayer = createSkillLayer
local function closeSkillLayer(self)
  ed.playEffect(ed.sound.heroDetail.closeSkillLayer)
end
class.closeSkillLayer = closeSkillLayer
local function createAttLayer(self)
  ed.playEffect(ed.sound.heroDetail.createAttLayer)
end
class.createAttLayer = createAttLayer
local function closeAttLayer(self)
  ed.playEffect(ed.sound.heroDetail.closeAttLayer)
end
class.closeAttLayer = closeAttLayer
local function createCardLayer(self)
  ed.playEffect(ed.sound.heroDetail.createCardLayer)
end
class.createCardLayer = createCardLayer
local function closeCardLayer(self)
  ed.playEffect(ed.sound.heroDetail.closeCardLayer)
end
class.closeCardLayer = closeCardLayer
local function clickHeroFca(self, param)
  local function delayPlayEffect(baseScene, effect)
    count = 0
    local function handler(dt)
      count = count + dt
      if count >= 0 then
        baseScene:removeUpdateHandler("delayPlayEffect")
        ed.playEffect(effect)
      end
    end
    return handler
  end
  local tid = param.hid
  local fca = param.fca
  if not fca then
    return
  end
  local row = ed.getDataTable("Unit")[tid]
  local effect = row["Voice " .. fca]
  if effect then
    local bs = ed.getCurrentScene()
    bs:registerUpdateHandler("delayPlayEffect", delayPlayEffect(bs, effect))
  end
end
class.clickHeroFca = clickHeroFca
local function clickEquip(self)
  ed.playEffect(ed.sound.heroDetail.clickEquip)
end
class.clickEquip = clickEquip
local function clickAttButton(self)
  ed.playEffect(ed.sound.heroDetail.clickAttButton)
end
class.clickAttButton = clickAttButton
local function clickCardButton(self)
  ed.playEffect(ed.sound.heroDetail.clickCardButton)
end
class.clickCardButton = clickCardButton
local function clickSkillButton(self)
  ed.playEffect(ed.sound.heroDetail.clickSkillButton)
end
class.clickSkillButton = clickSkillButton
local function clickDisabledUpgrade(self)
  ed.playEffect(ed.sound.heroDetail.clickDisabledUpgrade)
end
class.clickDisabledUpgrade = clickDisabledUpgrade
local function clickUpgrade(self)
  ed.playEffect(ed.sound.heroDetail.clickUpgrade)
end
class.clickUpgrade = clickUpgrade
local function clickEvolve(self)
  ed.playEffect(ed.sound.heroDetail.clickEvolve)
end
class.clickEvolve = clickEvolve
local function heroAttAnim(self)
  ed.playEffect(ed.sound.heroDetail.heroAttAnim)
end
class.heroAttAnim = heroAttAnim
local function equippingAnim(self)
  ed.playEffect(ed.sound.heroDetail.equippingAnim)
end
class.equippingAnim = equippingAnim
local function evolveAnim(self)
  ed.playEffect(ed.sound.heroDetail.evolveAnim)
end
class.evolveAnim = evolveAnim
local function upgradeAnim(self)
  ed.playEffect(ed.sound.heroDetail.upgradeAnim)
end
class.upgradeAnim = upgradeAnim
local function upgradeReply(self)
  ed.playEffect(ed.sound.heroDetail.upgradeReply)
end
class.upgradeReply = upgradeReply
local function evolveReply(self)
  ed.playEffect(ed.sound.heroDetail.evolveReply)
end
class.evolveReply = evolveReply

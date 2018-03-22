ed.ui.herodetail = ed.ui.herodetail or {}
local herodetail = ed.ui.herodetail
local base = ed.ui.baselsr
local class = newclass(base.mt)
herodetail.listener = class
local function create()
  local self = base.create("herodetail")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local createWindow = function(self)
  ed.playEffect(ed.sound.heroDetail.createWindow)
end
class.createWindow = createWindow
local closeWindow = function(self)
  ed.playEffect(ed.sound.heroDetail.closeWindow)
end
class.closeWindow = closeWindow
local createSkillLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.createSkillLayer)
end
class.createSkillLayer = createSkillLayer
local closeSkillLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.closeSkillLayer)
end
class.closeSkillLayer = closeSkillLayer
local createAttLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.createAttLayer)
end
class.createAttLayer = createAttLayer
local closeAttLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.closeAttLayer)
end
class.closeAttLayer = closeAttLayer
local createCardLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.createCardLayer)
end
class.createCardLayer = createCardLayer
local closeCardLayer = function(self)
  ed.playEffect(ed.sound.heroDetail.closeCardLayer)
end
class.closeCardLayer = closeCardLayer
local clickHeroFca = function(self, param)
  local delayPlayEffect = function(baseScene, effect)
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
local clickEquip = function(self)
  ed.playEffect(ed.sound.heroDetail.clickEquip)
end
class.clickEquip = clickEquip
local clickAttButton = function(self)
  ed.playEffect(ed.sound.heroDetail.clickAttButton)
end
class.clickAttButton = clickAttButton
local clickCardButton = function(self)
  ed.playEffect(ed.sound.heroDetail.clickCardButton)
end
class.clickCardButton = clickCardButton
local clickSkillButton = function(self)
  ed.playEffect(ed.sound.heroDetail.clickSkillButton)
end
class.clickSkillButton = clickSkillButton
local clickDisabledUpgrade = function(self)
  ed.playEffect(ed.sound.heroDetail.clickDisabledUpgrade)
end
class.clickDisabledUpgrade = clickDisabledUpgrade
local clickUpgrade = function(self)
  ed.playEffect(ed.sound.heroDetail.clickUpgrade)
end
class.clickUpgrade = clickUpgrade
local clickEvolve = function(self)
  ed.playEffect(ed.sound.heroDetail.clickEvolve)
end
class.clickEvolve = clickEvolve
local heroAttAnim = function(self)
  ed.playEffect(ed.sound.heroDetail.heroAttAnim)
end
class.heroAttAnim = heroAttAnim
local equippingAnim = function(self)
  ed.playEffect(ed.sound.heroDetail.equippingAnim)
end
class.equippingAnim = equippingAnim
local evolveAnim = function(self)
  ed.playEffect(ed.sound.heroDetail.evolveAnim)
end
class.evolveAnim = evolveAnim
local upgradeAnim = function(self)
  ed.playEffect(ed.sound.heroDetail.upgradeAnim)
end
class.upgradeAnim = upgradeAnim
local upgradeReply = function(self)
  ed.playEffect(ed.sound.heroDetail.upgradeReply)
end
class.upgradeReply = upgradeReply
local evolveReply = function(self)
  ed.playEffect(ed.sound.heroDetail.evolveReply)
end
class.evolveReply = evolveReply

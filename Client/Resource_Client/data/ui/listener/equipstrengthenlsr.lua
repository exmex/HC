local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipstrengthenlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("equipstrengthen")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function createMaterialList(self)
  ed.playEffect(ed.sound.equipStrengthen.clickOpenPackage)
end
class.createMaterialList = createMaterialList
local function clickMaterial(self)
  ed.playEffect(ed.sound.equipStrengthen.clickMaterial)
end
class.clickMaterial = clickMaterial
local function clickEnhance(self)
  ed.playEffect(ed.sound.equipStrengthen.clickStren)
end
class.clickEnhance = clickEnhance
local function clickFastEnhance(self)
  ed.playEffect(ed.sound.equipStrengthen.clickFastStren)
end
class.clickFastEnhance = clickFastEnhance
local function clickEquip(self)
  ed.playEffect(ed.sound.equipStrengthen.clickEquip)
end
class.clickEquip = clickEquip
local function clickHeroHead(self)
  ed.playEffect(ed.sound.equipStrengthen.clickHeroHead)
end
class.clickHeroHead = clickHeroHead
local function clickSelectHero(self)
  ed.playEffect(ed.sound.equipStrengthen.clickSelectHero)
end
class.clickSelectHero = clickSelectHero
local function clickBack(self)
  ed.playEffect(ed.sound.common.back)
end
class.clickBack = clickBack
local function enhanceSuccess(self)
  ed.playEffect(ed.sound.equipStrengthen.strenSuccess)
end
class.enhanceSuccess = enhanceSuccess

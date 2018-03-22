local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.heropackagelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("heropackage")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickListButton(self)
  ed.playEffect(ed.sound.heroPackage.changeList)
end
class.clickListButton = clickListButton
local function clickHeroOwned(self)
  ed.playEffect(ed.sound.heroPackage.clickHero)
end
class.clickHeroOwned = clickHeroOwned
local function summonSuccess(self)
  ed.playEffect(ed.sound.heroPackage.summonHero)
end
class.summonSuccess = summonSuccess
local function summonFailed(self)
  ed.showToast(T(LSTR("HEROPACKAGELSR.SUMMON_FAILED")))
end
class.summonFailed = summonFailed

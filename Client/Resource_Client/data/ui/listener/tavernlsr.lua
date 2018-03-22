local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.tavernlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("tavern")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickBronzeBuy(self)
  ed.playEffect(ed.sound.tavern.clickBronzeBuy)
end
class.clickBronzeBuy = clickBronzeBuy
local function clickBronzeOnce(self)
  ed.playEffect(ed.sound.tavern.clickBronzeOnce)
end
class.clickBronzeOnce = clickBronzeOnce
local function clickBronzeTen(self)
  ed.playEffect(ed.sound.tavern.clickBronzeTen)
end
class.clickBronzeTen = clickBronzeTen
local function clickSilverBuy(self)
  ed.playEffect(ed.sound.tavern.clickSilverBuy)
end
class.clickSilverBuy = clickSilverBuy
local function clickSilverOnce(self)
  ed.playEffect(ed.sound.tavern.clickSilverOnce)
end
class.clickSilverOnce = clickSilverOnce
local function clickSilverTen(self)
  ed.playEffect(ed.sound.tavern.clickSilverTen)
end
class.clickSilverTen = clickSilverTen
local function clickGoldBuy(self)
  ed.playEffect(ed.sound.tavern.clickGoldBuy)
end
class.clickGoldBuy = clickGoldBuy
local function clickGoldOnce(self)
  ed.playEffect(ed.sound.tavern.clickGoldOnce)
end
class.clickGoldOnce = clickGoldOnce
local function clickGoldTen(self)
  ed.playEffect(ed.sound.tavern.clickGoldTen)
end
class.clickGoldTen = clickGoldTen
local function scrollBoardAnim(self)
  ed.playEffect(ed.sound.tavern.scrollBoardAnim)
end
class.scrollBoardAnim = scrollBoardAnim

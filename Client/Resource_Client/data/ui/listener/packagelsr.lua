local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
ed.ui.packagelsr = class
local function create()
  local self = base.create("package")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickSellButton(self)
  ed.playEffect(ed.sound.package.clickSell)
end
class.clickSellButton = clickSellButton
local function clickComposeFragment(self)
  ed.playEffect(ed.sound.package.clickCompose)
end
class.clickComposeFragment = clickComposeFragment
local function clickCheckDetail(self)
  ed.playEffect(ed.sound.package.clickDetail)
end
class.clickCheckDetail = clickCheckDetail
local function clickUseProp(self)
  ed.playEffect(ed.sound.package.clickUseEquip)
end
class.clickUseProp = clickUseProp
local function clickProp(self)
  ed.playEffect(ed.sound.package.clickElement)
end
class.clickProp = clickProp
local function clickChangeList(self)
  ed.playEffect(ed.sound.package.clickFilter)
end
class.clickChangeList = clickChangeList
local function sellPropSuccess(self)
  ed.playEffect(ed.sound.sellProp.sellProp)
end
class.sellPropSuccess = sellPropSuccess
local function sellPropFailed(self)
  ed.showToast(T(LSTR("PACKAGELSR.SELL_FAILED")))
end
class.sellPropFailed = sellPropFailed
local function composeFragmentSuccess(self)
  ed.playEffect(ed.sound.fragmentCompose.composeSuccess)
  ed.showToast(T(LSTR("PACKAGELSR.SYNTHESIS_SUCCESSFULLY")))
end
class.composeFragmentSuccess = composeFragmentSuccess
local function composeFragmentFailed(self)
  ed.playEffect(ed.sound.fragmentCompose.composeFailed)
  ed.showToast(T(LSTR("PACKAGELSR.SYNTHESIS_FAILED")))
end
class.composeFragmentFailed = composeFragmentFailed

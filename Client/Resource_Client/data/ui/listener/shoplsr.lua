local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.shoplsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("shop")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function buySuccess(self)
  ed.playEffect(ed.sound.shop.buySuccess)
end
class.buySuccess = buySuccess
local function buyFailed(self)
  ed.playEffect(ed.sound.shop.buyFailed)
end
class.buyFailed = buyFailed
local function refreshFailed(self)
  ed.playEffect(ed.sound.shop.refreshFailed)
end
class.refreshFailed = refreshFailed
local function clickRefresh(self)
  ed.playEffect(ed.sound.shop.clickRefresh)
end
class.clickRefresh = clickRefresh

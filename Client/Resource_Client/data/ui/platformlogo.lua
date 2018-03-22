local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.platformlogo = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
local function create()
  local self = base.create("platformlogo")
  setmetatable(self, class.mt)
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  local scene = self.scene
  scene:addChild(mainLayer)
  self:showFirstLogo()
  return self
end
class.create = create
local getFadeAction = function(self, handler)
  handler = handler or function()
  end
  local array = CCArray:create()
  local fi = CCFadeIn:create(0.5)
  local d = CCDelayTime:create(1)
  local fo = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(handler, EDDebug)
  end)
  local action = {
    fi,
    d,
    fo,
    func
  }
  for i = 1, #action do
    array:addObject(action[i])
  end
  local s = CCSequence:create(array)
  return s
end
class.getFadeAction = getFadeAction
local function showFirstLogo(self)
  local logo = ed.createSprite(self:getLogoRes(1))
  logo:setPosition(ccp(400, 240))
  self.mainLayer:addChild(logo)
  logo:setOpacity(0)
  logo:runAction(self:getFadeAction(function()
    self:showSecondLogo()
  end))
end
class.showFirstLogo = showFirstLogo
local function showSecondLogo(self)
  if ed.isElementInTable(LegendSDKType, {105, 106}) then
    local logo = ed.createSprite(self:getLogoRes(2))
    logo:setPosition(ccp(400, 240))
    self.mainLayer:addChild(logo)
    logo:setOpacity(0)
    logo:runAction(self:getFadeAction(function()
      self:getInGame()
    end))
  else
    self:getInGame()
  end
end
class.showSecondLogo = showSecondLogo
local function getInGame(self)
  ed.replaceScene(ed.ui.serverlogin.create())
end
class.getInGame = getInGame
local function getLogoRes(self, index)
  local r1 = "installer/team_logo.png"
  local r2 = "installer/platform_logo.png"
  local rs = {r1, r2}
  if ed.isElementInTable(LegendSDKType, {106}) then
    rs = {r2, r1}
  end
  return rs[index]
end
class.getLogoRes = getLogoRes

local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
ed.ui.popheroawake = class
local lsr = ed.ui.popherocardlsr.create()
local function showCardui(self)
  ui = self.ui
  local fi = CCFadeIn:create(0.4)
  local s = CCSequence:createWithTwoActions(fi, CCCallFunc:create(function()
    xpcall(function()
      local r = CCRotateBy:create(5, 360)
      r = CCRepeatForever:create(r)
      self.light:runAction(r)
    end, EDDebug)
  end))
  self.light:runAction(s)
  local cardui = ui.cardui
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardui:runAction(fi)
      local fb = ed.createFcaNode("eff_UI_tavern_bubble")
      fb:setPosition(ccp(400, 240))
      self.mainLayer:addChild(fb)
      self.baseScene:addFca(fb)
      fb:setScale(1.5)
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardui:runAction(s)
  lsr:report("showCardAnim")
  local fn = ed.createFcaNode("eff_UI_tavern_card_" .. self.color)
  fn:setPosition(ccp(400, 240))
  self.mainLayer:addChild(fn, 10)
  self.baseScene:addFca(fn)
  fn:setScale(1.5)
  self:registerTouchHandler()
  self:show()
end
class.showCardui = showCardui
local function doClickLayer(self)
  if self.hasShowStone then
    if self.handler then
      self.handler()
    end
    self:destroy()
    return
  end
  if self.amount > 1 then
  else
    lsr:report("createGetNewHero")
    if not tolua.isnull(self.ui.cardui) then
      self.ui.cardui:removeFromParentAndCleanup(true)
    end
    local light = self.ui.light
    if not tolua.isnull(light) then
      light:removeFromParentAndCleanup(true)
    end
    if self.handler then
      self.handler()
    end
    self:destroy()
  end
end
class.doClickLayer = doClickLayer
local function registerTouchHandler(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param)
      lsr:report("clickCardLayer")
      self:doClickLayer()
    end
  })
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.priority or self.mainTouchPriority, true)
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  param = param or {}
  param.noShade = true
  local self = base.create("popheroawake", param)
  setmetatable(self, class.mt)
  self.baseScene = ed.getCurrentScene()
  self.hid = param.id
  self.star = ed.getDataTable("Unit")[self.hid]["Initial Stars"]
  self.amount = param.amount or 0
  self.handler = param.handler
  self.index = param.index
  self.priority = param.priority
  local mainLayer = self.mainLayer
  local ui = self.ui
  self.color = ed.getDataTable("Unit")[self.hid]["Bg Color"] or "red"
  local bg_res = {
    red = "UI/alpha/HVGA/tavern_get_hero_bg_red.jpg",
    green = "UI/alpha/HVGA/tavern_get_hero_bg_green.jpg",
    blue = "UI/alpha/HVGA/tavern_get_hero_bg_blue.jpg"
  }
  local readnode = ed.readnode.create(mainLayer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = bg_res[self.color]
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/shine.png"
      },
      layout = {
        position = ccp(400, 550)
      },
      config = {opacity = 0, scale = 6}
    },
    {
      t = "CCNode",
      base = {
        name = "cardui",
        node = ed.readhero.getHeroCard(self.hid, {disableswap = true, showAwake = true}).container,
        z = 1
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {opacity = 0}
    }
  }
  readnode:addNode(ui_info)
  local bg = ui.bg
  local fi = CCFadeIn:create(0.4)
  bg:runAction(fi)
  self.light = ui.light
  self.ui = ui
  ed.announce({
    type = "HeroAwaken",
    notshade = true,
    param = {
      id = self.hid,
      handler = function()
        self:showCardui()
      end
    }
  })
  return self
end
class.create = create
local function show(self)
  lsr:report("createCardLayer")
end
class.show = show
local function destroy(self)
  lsr:report("closeCardLayer")
  self.mainLayer:removeFromParentAndCleanup(true)
end
class.destroy = destroy

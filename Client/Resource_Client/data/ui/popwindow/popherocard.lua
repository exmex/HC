local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
ed.ui.popherocard = class
local lsr = ed.ui.popherocardlsr.create()
local function showStonePrompt(self)
  lsr:report("createStonePrompt")
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  self.mainLayer:addChild(container)
  local label = ed.createttf(T(LSTR("POPHEROCARD.YOU_HAVE_ALREADY_HAS_THIS_HERO__D_STAR_CARD_TO_CONVERT_TO__D_SOUL_STONES\N"), self.star, self.amount), 20)
  label:setPosition(ccp(400, 60))
  self.mainLayer:addChild(label)
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 2)
  label = ed.createttf(T(LSTR("POPHEROCARD.SOUL_STONE_CAN_BE_USED_ON_HERO_EVOLUTION")), 20)
  label:setPosition(ccp(400, 45))
  self.mainLayer:addChild(label)
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 2)
  container:setOpacity(0)
  local f = CCFadeIn:create(0.4)
  container:runAction(f)
end
class.showStonePrompt = showStonePrompt
local function doClickLayer(self)
  if self.hasShowStone then
    if self.handler then
      self.handler()
    end
    self:destroy()
    return
  end
  if self.amount > 1 then
    lsr:report("createStonePrompt")
    self.hasShowStone = true
    local container = self.ui.cardui
    local s = CCScaleTo:create(0.2, 0.8)
    s = CCEaseSineOut:create(s)
    local m = CCMoveTo:create(0.2, ccp(400, 260))
    m = CCEaseSineOut:create(m)
    s = CCSpawn:createWithTwoActions(s, m)
    container:runAction(s)
    self:showStonePrompt()
  else
    lsr:report("createGetNewHero")
    if not tolua.isnull(self.ui.cardui) then
      self.ui.cardui:removeFromParentAndCleanup(true)
    end
    local light = self.ui.light
    if not tolua.isnull(light) then
      light:removeFromParentAndCleanup(true)
    end
    ed.announce({
      type = "getNewHero",
      notshade = true,
      param = {
        id = self.hid,
        handler = function()
          if self.handler then
            self.handler()
          end
          self:destroy()
        end
      }
    })
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
  local self = base.create("popherocard", param)
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
  local color = ed.getDataTable("Unit")[self.hid]["Bg Color"] or "red"
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
        res = bg_res[color]
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
        node = ed.readhero.getHeroCard(self.hid, {starType = "init"}).container,
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
  local light = ui.light
  fi = CCFadeIn:create(0.4)
  local s = CCSequence:createWithTwoActions(fi, CCCallFunc:create(function()
    xpcall(function()
      local r = CCRotateBy:create(5, 360)
      r = CCRepeatForever:create(r)
      light:runAction(r)
    end, EDDebug)
  end))
  light:runAction(s)
  local cardui = ui.cardui
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardui:runAction(fi)
      local fb = ed.createFcaNode("eff_UI_tavern_bubble")
      fb:setPosition(ccp(400, 240))
      mainLayer:addChild(fb)
      self.baseScene:addFca(fb)
      fb:setScale(1.5)
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardui:runAction(s)
  lsr:report("showCardAnim")
  local fn = ed.createFcaNode("eff_UI_tavern_card_" .. color)
  fn:setPosition(ccp(400, 240))
  mainLayer:addChild(fn, 10)
  self.baseScene:addFca(fn)
  fn:setScale(1.5)
  self:registerTouchHandler()
  self:show()
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

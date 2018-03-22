local herodetail = ed.ui.herodetail
local res = herodetail.res
local base = ed.ui.popwindow
local class = newclass(base.mt)
herodetail.card = class
local function doPushCard(self)
  local layer = self.cardLayer
  local card = self.card
  if card:numberOfRunningActions() > 0 then
    return
  end
  layer:setOpacity(0)
  layer:setZOrder(0)
  local array = CCArray:create()
  local sa = CCScaleTo:create(0.2, 1)
  local ma = CCMoveTo:create(0.2, ccp(400, 240))
  local ra = CCRotateTo:create(0.2, -360 * res.card_rotate_amount + 0)
  array:addObject(sa)
  array:addObject(ma)
  array:addObject(ra)
  local s = CCSpawn:create(array)
  local func = CCCallFunc:create(function()
    xpcall(function()
      layer:setTouchEnabled(false)
      self.mainLayer:setZOrder(0)
    end, EDDebug)
  end)
  card:runAction(CCSequence:createWithTwoActions(s, func))
end
class.doPushCard = doPushCard
local function doPopCard(self)
  local layer = self.cardLayer
  local card = self.card
  if card:numberOfRunningActions() > 0 then
    return
  end
  layer:setZOrder(20)
  local l, r, b, t = ed.getDisplayVertex()
  local height = r - l
  local scale = (height - 25) / card:getContentSize().height
  local x = self.container:getPositionX()
  local array = CCArray:create()
  local sa = CCScaleTo:create(0.2, scale)
  local ma = CCMoveTo:create(0.2, ccp(405 - x, 237))
  local ra = CCRotateTo:create(0.2, 360 * res.card_rotate_amount - (res.card_rotate_direction == "right" and -90 or 90))
  array:addObject(sa)
  array:addObject(ma)
  array:addObject(ra)
  local s = CCSpawn:create(array)
  local func = CCCallFunc:create(function()
    xpcall(function()
      layer:setTouchEnabled(true)
      layer:setOpacity(255)
    end, EDDebug)
  end)
  card:runAction(CCSequence:createWithTwoActions(s, func))
end
class.doPopCard = doPopCard
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      if self.closeHandler then
        self.closeHandler()
      end
    end,
    force = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.card,
    key = "card",
    clickHandler = function()
      self:doClickCard()
    end,
    force = true,
    clickInterval = 0.5,
    priority = 5
  })
end
class.registerTouchHandler = registerTouchHandler
local doClickCard = function(self)
  self.mainLayer:setZOrder(20)
  self:doPopCard()
end
class.doClickCard = doClickCard
local doCardLayerTouch = function(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "ended" then
        self:doPushCard()
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doCardLayerTouch = doCardLayerTouch
local function getInformation(self)
  local info = {}
  local hero = self.hero
  local unit = ed.getDataTable("Unit")
  info.type = unit[hero._tid]["Main Attrib"]
  info.rank = hero._rank
  local row = unit[hero._tid]
  info.typeres = res.card_type_icon[info.type]
  info.frameres = res.card_frame[info.rank]
  info.cardres = row.Art or "UI/alpha/HVGA/card/card_bg_big_45.png"
  info.name = row["Display Name"]
  info.art_name = row["Art Name"]
  local skillGroup = ed.getDataTable("SkillGroup")
  local group = skillGroup[hero._tid]
  info.skillres = {}
  for i = 1, 4 do
    info.skillres[i] = group[i].Icon
  end
  return info
end
class.getInformation = getInformation
local refreshCard = function(self)
  ed.readhero.refreshHeroCard(self.cardui, self.hero._tid)
end
class.refreshCard = refreshCard
local createCard = function(self)
  local info = self:getInformation(self.hero)
  local cardLayer = CCLayerColor:create(ccc4(0, 0, 0, 255))
  cardLayer:setContentSize(CCSizeMake(1200, 480))
  cardLayer:setOpacity(0)
  cardLayer:setTouchEnabled(false)
  cardLayer:registerScriptTouchHandler(self:doCardLayerTouch(), false, -145, true)
  local ui = ed.readhero.getHeroCard(self.hero._tid)
  ui.container:setPosition(ccp(400, 240))
  cardLayer:addChild(ui.container)
  self.cardui = ui
  return cardLayer, ui.container, ui
end
class.createCard = createCard
local function create(hero, param)
  param = param or {}
  local self = base.create("herodetailcard")
  setmetatable(self, class.mt)
  self.hero = hero
  self.parent = param.parent
  self.closeHandler = param.closeHandler
  local mainLayer = self.mainLayer
  local container = self.container
  container:setPosition(ccp(48, 0))
  container:setZOrder(10)
  self:createCard()
  self.cardLayer, self.card, self.cardui = self:createCard()
  self.container:addChild(self.cardLayer)
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png",
        z = 1
      },
      layout = {
        position = ccp(520, 430)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        z = 1
      },
      layout = {
        position = ccp(520, 430)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:registerTouchHandler()
  self.parent:addChild(self.mainLayer)
  return self
end
class.create = create
local popBack = function(self, param)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if self.mainLayer:numberOfRunningActions() > 0 then
    return
  end
  self.mainLayer:setTouchEnabled(false)
  self.mainLayer:setZOrder(0)
  local move = CCMoveTo:create(0.2, param.endPos)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        self.mainLayer:removeFromParentAndCleanup(true)
      end
      if param.callback then
        param.callback()
      end
    end, EDDebug)
  end)
  self.container:runAction(ed.readaction.create({
    t = "seq",
    move,
    func
  }))
end
class.popBack = popBack
local pop = function(self, param)
  self.mainLayer:setTouchEnabled(false)
  if not param.skipAnim then
    self.container:setPosition(param.oriPos)
    local move = CCMoveTo:create(0.2, param.endPos)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(self.mainLayer) then
          self.mainLayer:setTouchEnabled(true)
        end
      end, EDDebug)
    end)
    self.container:runAction(ed.readaction.create({
      t = "seq",
      move,
      func
    }))
  else
    self.mainLayer:setTouchEnabled(true)
    self.container:setPosition(param.endPos)
  end
end
class.pop = pop

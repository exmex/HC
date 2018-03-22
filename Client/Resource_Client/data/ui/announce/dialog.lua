local class = newclass()
ed.dialog = class
--Ray 修改 默认按钮颜色 ccc3(251, 206, 16) -> ccc3(162, 129, 11)
local normalColor = ccc3(255, 255, 255)
local bWaitTime = false
local waitTimeHandler
local pressColor = ccc3(162, 129, 11)
local destroy = function(self, bn)
  if not tolua.isnull(self.bg) and self.bg:numberOfRunningActions() == 0 then
    local action = CCScaleTo:create(0.2, 0)
	--add by xinghui
	if ed.dialog.pvpMode then
		action = CCScaleTo:create(0.12, 0)
		ed.dialog.pvpMode = nil
	end
	--	
    action = CCEaseBackIn:create(action)	
    local sequence = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
      xpcall(function()
        self.layer:removeFromParentAndCleanup(true)
        if bn == "left" and self.leftDestroyHandler then
          self.leftDestroyHandler()
        end
        if bn == "right" and self.rightDestroyHandler then
          self.rightDestroyHandler()
        end
      end, EDDebug)
    end))
    self.bg:runAction(sequence)
    ed.playEffect(ed.sound.dialog.closeWindow)
  end
end
class.destroy = destroy
local function create()
  local self = {}
  setmetatable(self, class.mt)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.layer = layer
  self.layer:setTouchEnabled(true)
  local bg = ed.createSprite("UI/alpha/HVGA/dialog_bg.png")
  bg:setPosition(ccp(400, 240))
  self.bg = bg
  self.layer:addChild(bg)
  bg:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  bg:runAction(action)
  local line = ed.createSprite("UI/alpha/HVGA/dialog_line.png")
  line:setPosition(ccp(172, 75))
  self.line = line
  bg:addChild(line)
  ed.playEffect(ed.sound.dialog.openWindow)
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.dialog
ed.alertDialog = class
setmetatable(class, base.mt)
local doMainLayerTouch = function(self)
  local buttonTouch = self:doButtonTouch()
  local function handler(event, x, y)
    xpcall(function()
      buttonTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doButtonTouch(self)
  local isPressIn
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.button, x, y) then
          isPressIn = true
          self.buttonPress:setVisible(true)
          ed.setLabelColor(self.buttonLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressIn
        isPressIn = nil
        if bp then
          self.buttonPress:setVisible(false)
          ed.setLabelColor(self.buttonLabel, normalColor)
          if ed.containsPoint(self.button, x, y) then
            ed.playEffect(ed.sound.dialog.clickAlertOK)
            if self.handler then
              self.handler()
            end
            self:destroy()
          end
        end
      end
    end, EDDebug)
  end
  return handler
end
class.doButtonTouch = doButtonTouch
local function create(info)
  local self = base.create()
  setmetatable(self, class.mt)
  self.handler = info.handler
  self.layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -800, true)
  local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade.png", CCRectMake(20, 22, 40, 23))
  self.button = button
  button:setContentSize(CCSizeMake(250, 49))
  button:setPosition(ccp(172, 44))
  self.bg:addChild(button)
  local buttonPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade-mask.png", CCRectMake(20, 22, 40, 23))
  self.buttonPress = buttonPress
  buttonPress:setContentSize(CCSizeMake(250, 49))
  buttonPress:setVisible(false)
  buttonPress:setAnchorPoint(ccp(0, 0))
  buttonPress:setPosition(ccp(0, 0))
  button:addChild(buttonPress)
  local buttonText = info.buttonText or T(LSTR("FASTSELL.GOOD"))
  local buttonLabel = ed.createttf(buttonText, 20, "arial_unicode_ms.ttf")
  ed.setLabelColor(buttonLabel, normalColor)
  ed.setLabelShadow(buttonLabel, ccc3(63, 5, 0), ccp(1, 2))

  buttonLabel:setPosition(ccp(125, 24))
  self.buttonLabel = buttonLabel
  button:addChild(buttonLabel, 1)
  return self
end
class.create = create
local function createWithText(info)
  if info == nil then
    info = {}
  end
  local text = info.text or ""
  local self = create(info)
  local alert = ed.createttf(text, 20)
  alert:setDimensions(CCSizeMake(300, 125))
  alert:setHorizontalAlignment(kCCTextAlignmentLeft)
  alert:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
  alert:setPosition(ccp(172, 135))
  ed.setLabelColor(alert, ccc3(255, 255, 255))  --67, 59, 56
  self.bg:addChild(alert)
  return self
end
class.createWithText = createWithText
local function createWithSprite(info)
  if info == nil then
    info = {}
  end
  local self = create(info)
  if info.sprite then
    info.sprite:setAnchorPoint(ccp(0, 0))
    info.sprite:setPosition(ccp(0, 0))
    self.bg:addChild(info.sprite)
  end
  if info.spriteLabel then
    local label = ed.createttf(info.spriteLabel, 20)
    label:setDimensions(CCSizeMake(300, 125))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setPosition(ccp(172, 135))
    ed.setLabelColor(label, ccc3(255, 255, 255))
    self.bg:addChild(label)
  end
  if info.sprite_x then
    self.bg:setScaleX(sprite_x / self.bg:getContentSize().width)
    info.sprite:setScaleX(self.bg:getContentSize().width / sprite_x)
  end
  return self
end
class.createWithSprite = createWithSprite
local function showDialog(info, container)
  info = info or {}
  container = container or CCDirector:sharedDirector():getRunningScene()
  local self
  if info.sprite then
    self = createWithSprite(info)
  else
    self = createWithText(info)
  end
  container:addChild(self.layer, 1000)
  return self
end
class.showDialog = showDialog
ed.showAlertDialog = showDialog
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.dialog
ed.confirmDialog = class
setmetatable(class, base.mt)
local doMainLayerTouch = function(self)
  local buttonTouch = self:doButtonTouch()
  local function handler(event, x, y)
    xpcall(function()
      buttonTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doButtonTouch(self)
  local isPressLeft, isPressRight
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.left, x, y) then
          isPressLeft = true
          self.leftPress:setVisible(true)
          ed.setLabelColor(self.leftLabel, pressColor)
        end
        if ed.containsPoint(self.right, x, y) then
          isPressRight = true
          self.rightPress:setVisible(true)
          ed.setLabelColor(self.rightLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressLeft
        isPressLeft = nil
        if bp then
          self.leftPress:setVisible(false)
          ed.setLabelColor(self.leftLabel, normalColor)
          if ed.containsPoint(self.left, x, y) then
            self.clickLeftPoint = self.clickLeftPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickLeftPoint
            if dp > 0.5 then
              ed.playEffect(ed.sound.dialog.clickConfirmLeft)
              if self.leftHandler then
                self.leftHandler()
              end
              self:destroy("left")
              self.clickLeftPoint = ed.getMillionTime()
            end
          end
        end
        bp = isPressRight
        isPressRight = nil
        if bp then
          self.rightPress:setVisible(false)
          ed.setLabelColor(self.rightLabel, normalColor)
          if ed.containsPoint(self.right, x, y) then
            self.clickRightPoint = self.clickRightPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickRightPoint
            if dp > 0.5 then
              ed.playEffect(ed.sound.dialog.clickConfirmRight)
              if self.rightHandler then
                self.rightHandler()
              end
              self:destroy("right")
              self.clickRightPoint = ed.getMillionTime()
            end
          end
        end
      end
    end, EDDebug)
  end
  return handler
end
class.doButtonTouch = doButtonTouch
local function create(info)
  local self = base.create()
  setmetatable(self, class.mt)
  self.leftHandler = info.leftHandler
  self.rightHandler = info.rightHandler
  self.leftDestroyHandler = info.leftDestroyHandler
  self.rightDestroyHandler = info.rightDestroyHandler
  local touch = self:doMainLayerTouch()
  self.layer:registerScriptTouchHandler(touch, false, -800, true)
  local left = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade.png", CCRectMake(20, 20, 40, 29))
  self.left = left
  left:setContentSize(CCSizeMake(120, 49))
  left:setPosition(ccp(100, 44))
  self.bg:addChild(left)
  local leftPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade-mask.png", CCRectMake(20, 20, 40, 29))
  self.leftPress = leftPress
  leftPress:setContentSize(CCSizeMake(120, 49))
  leftPress:setVisible(false)
  leftPress:setAnchorPoint(ccp(0, 0))
  leftPress:setPosition(ccp(0, 0))
  left:addChild(leftPress)
  local leftText = info.leftText or T(LSTR("CHATCONFIG.CANCEL"))
  local leftLabel = ed.createttf(leftText, 20, ed.selfFont)
  ed.setLabelColor(leftLabel, normalColor)
  ed.setLabelShadow(leftLabel, ccc3(63, 5, 0), ccp(1, 2))
  leftLabel:setPosition(ccp(60, 25))
  self.leftLabel = leftLabel
  left:addChild(leftLabel, 1)
  local right = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade.png", CCRectMake(20, 20, 40, 29))
  self.right = right
  right:setContentSize(CCSizeMake(120, 49))
  right:setPosition(ccp(250, 44))
  self.bg:addChild(right)
  local rightPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade-mask.png", CCRectMake(20, 20, 40, 29))
  self.rightPress = rightPress
  rightPress:setContentSize(CCSizeMake(120, 49))
  rightPress:setVisible(false)
  rightPress:setAnchorPoint(ccp(0, 0))
  rightPress:setPosition(ccp(0, 0))
  right:addChild(rightPress)
  local rightText = info.rightText or T(LSTR("FASTSELL.GOOD"))
  local rightLabel = ed.createttf(rightText, 20, ed.selfFont)
  ed.setLabelColor(rightLabel, normalColor)
  ed.setLabelShadow(rightLabel, ccc3(63, 5, 0), ccp(1, 2))
  rightLabel:setPosition(ccp(60, 25))
  self.rightLabel = rightLabel
  right:addChild(rightLabel, 1)
  return self
end
class.create = create
local function createWithText(info)
  if info == nil then
    info = {}
  end
  local textSize = 20
  if info.textSize then
    textSize = info.textSize
  end
  local text = info.text or ""
  local self = create(info)
  local confirm = ed.createttf(text, textSize)
  confirm:setDimensions(CCSizeMake(300, 125))
  confirm:setHorizontalAlignment(kCCTextAlignmentLeft)
  confirm:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
  confirm:setPosition(ccp(180, 135))
  if info.textColor then
	ed.setLabelColor(confirm, info.textColor)
  else
    ed.setLabelColor(confirm, ccc3(255, 255, 255))  --67, 59, 56
  end
  
  self.bg:addChild(confirm)
  return self
end
class.createWithText = createWithText
local function createWithSprite(info)
  if info == nil then
    info = {}
  end
  local self = create(info)
  if info.sprite then
    info.sprite:setAnchorPoint(ccp(0, 0))
    info.sprite:setPosition(ccp(0, 0))
    self.bg:addChild(info.sprite)
  end
  if info.spriteLabel then
    local label = ed.createttf(info.spriteLabel, 20)
    label:setDimensions(CCSizeMake(300, 125))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setPosition(ccp(172, 135))
    ed.setLabelColor(label, ccc3(255, 255, 255))
    self.bg:addChild(label)
  end
  if info.sprite_x then
    self.bg:setScaleX(sprite_x / self.bg:getContentSize().width)
    info.sprite:setScaleX(self.bg:getContentSize().width / sprite_x)
  end
  return self
end
class.createWithSprite = createWithSprite
--modify by xinghui:add pvpMode
local function showDialog(info, container, pvpMode)
  info = info or {}
  container = container or CCDirector:sharedDirector():getRunningScene()
  local self
  if info.sprite then
    self = createWithSprite(info)
  else
    self = createWithText(info)
  end
  if pvpMode then
    ed.dialog.pvpMode = pvpMode
  end
  container:addChild(self.layer, 1000)
  return self
end
class.showDialog = showDialog
ed.showConfirmDialog = showDialog

local class = {
  mt = {}
}
class.mt.__index = class
local handyDialog = class
local getScene = function()
  local scene = CCDirector:sharedDirector():getRunningScene()
  return scene
end
local function openMidas(config)
  local function handler()
    local callback = config.callback
    local refreshHandler = config.refreshHandler
    local ds = ed.playerlimit.getAreaUnlockPrompt("Midas")
    if ds then
      ed.showToast(ds)
      return
    end
    local scene = getScene()
    local midas = ed.ui.midas.create({callback = callback, refreshHandler = refreshHandler})
    scene:addChild(midas.mainLayer, 200)
  end
  return handler
end
class.openMidas = openMidas
local function openRecharge(config)
  local function handler()
    local scene = getScene()
    local rechargeLayer = newrecharge.create()
    scene:addChild(rechargeLayer, 200)
  end
  return handler
end
class.openRecharge = openRecharge
local function openvipPower(vip)
  local function handler()
  --[[
    local scene = getScene()
    local recharge = ed.ui.recharge.create({type = "detail", showVip = vip})
    scene:addChild(recharge.mainLayer, 200)
	--]]
	local rechargeLayer = newrecharge.create()
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		scene:addChild(rechargeLayer, 101000)
	end
  end
  return handler
end
class.openvipPower = openvipPower
local upBuyVitality = function(cost, reply)
  local function handler()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T(LSTR("dialog.1.10.1.001")))
    elseif ed.player._rmb < cost then
      ed.showHandyDialog("toRecharge")
    else
      ed.netreply.buyVitalityReply = reply
      ed.netdata.buyVitality = {isBuy = true, cost = cost}
      local msg = ed.upmsg.buy_vitality()
      ed.send(msg, "buy_vitality")
    end
  end
  return handler
end
class.upBuyVitality = upBuyVitality
local function showHandyDialog(type, param)
  param = param or {}
  local active = param.active
  local vip = param.vip
  local number = param.number
  local name = param.name
  local reply = param.reply
  local callback = param.callback
  local refreshHandler = param.refreshHandler
  local explaination = param.explaination
  local wholeText = param.wholeText
  local text
  local rightText = T(LSTR("CHATCONFIG.CONFIRM"))
  local handler, rightHandler
  if type == "useMidas" then
    text = T(LSTR("DIALOG.OUT_OF_COINS_USE_GOLDEN_HAND_NOW"))
    handler = openMidas({callback = callback, refreshHandler = refreshHandler})
  elseif type == "toRecharge" then
    text = explaination or T(LSTR("DIALOG.OUT_OF_DIAMONDS_WANT_TO_GET_SOME"))
    handler = openRecharge({callback = callback})
  elseif type == "toRecharge1" then  --充值返利
    handler = openRecharge({callback = callback})
  elseif type == "vipLocked" then
    if vip then
      text = T(LSTR("DIALOG.VIP_GRADE_LEVEL_TO_UNLOCK_THE_FUNCTION"), vip)
    else
      text = name and T(LSTR("DIALOG.PLEASE_UPGRADE_YOUR_VIP_LEVEL"), name) or T(LSTR("DIALOG.PLEASE_UPGRADE_YOUR_VIP_LEVEL_TO_UNLOCK_THE_FUNCTION"))
    end
    rightText = T(LSTR("DIALOG.VIEW_PRIVILEGES"))
    handler = openvipPower(vip)
  elseif type == "needHighervip" then
    text = ""
    if number and name then
      text = text .. T(LSTR("DIALOG._S_D_TIMES_TODAY\N"), name, number)
    end
    text = text .. T(LSTR("DIALOG.PLEASE_UPGRADE_YOUR_VIP_LEVEL_TO_GET_MORE_TIMES"), name or "")
    text = wholeText or text
    rightText = T(LSTR("DIALOG.VIEW_PRIVILEGES"))
    handler = openvipPower(ed.player:getvip() + 1)
  elseif type == "buyVitality" then
    if bWaitTime then
      return
    end
    bWaitTime =true
    waitTimeHandler = ListenTimer(Timer:Once(1), function()
      bWaitTime  = false
    end)

    if not ed.player:canBuyVitality() then
      showHandyDialog("needHighervip", {
        number = ed.player:getVitalityBuyTimes(),
        name = T(LSTR("DIALOG.BUY_STAMINA"))
      })
      return
    end
    local cost = ed.player:getBuyVitalityCost()
    text = ""
    if active then
    else
      text = T(LSTR("DIALOG.OUT_OF_STAMINA"))
    end
    text = T(LSTR("DIALOG.SPEND__D_DIAMOND_TO_PURCHASE_120_STAMINA_\N_CONTINUE_PURCHASE YOUVE_PURCHASED__D_TIMES_TODAY"), cost, ed.player:getVitalityBuyTimes())
    handler = upBuyVitality(cost, reply)
  end
  local info = {
    text = text,
    rightText = rightText,
    rightHandler = rightHandler,
    rightDestroyHandler = handler
  }
  ed.showConfirmDialog(info)
end
ed.showHandyDialog = showHandyDialog
function ed.popSuperLinkAlertDialog(text, addr)
  local buttonText = T(LSTR("TASK.HEAD_TO"))
  if addr == "" or addr == "DO NOT EXIT" then
    buttonText = T(LSTR("CHATCONFIG.CONFIRM"))
  end
  ed.showAlertDialog({
    text = text,
    buttonText = buttonText,
    handler = function()
      if addr == "" then
        LegendExit()
      elseif addr == "DO NOT EXIT" then
      else
        ed.openURL(addr)
      end
    end
  })
end

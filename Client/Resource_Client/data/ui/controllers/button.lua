local button = {}
button.__index = button
button.dataInfo = nil
button.handler = nil
button.donwHandler = nil
button.upHandler = nil
button.visible = true
button.pressed = false
button.sprite = nil
button.isEnable = true
button.arrayIndex = 1
button.scale = 1
button.handlerInner = 0.3
button.lastTime = 0
button.defaultSound = ed.sound.deo.common_click_feedback
function button:initBaseInfo(data)
  self.m_bVisible = true
  self.dataInfo = data
end
function button:setArrayIndex(index)
  self.arrayIndex = index
end
function button:isVisible()
  return self.visible
end
function button:setHandler(handler, donwHandler, upHandler)
  self.handler = handler
  if donwHandler then
    self.donwHandler = donwHandler
  end
  if upHandler then
    self.upHandler = upHandler
  end
end
function button:getSprite()
  return self.sprite
end
function button:playSound()
  local res = self.dataInfo.base.sound and self.dataInfo.base.sound or self.defaultSound
  if res then
    ed.playEffect(res)
  end
end
function button:isContainPoint(x, y)
  if nil == self.sprite then
    return false
  end
  local inside = ed.containsPoint(self.sprite, x, y)
  if self.dataInfo.base.clickPos == "outSide" then
    return not inside
  else
    return inside
  end
end
function button:checkInnerCondition()
  local year, month, day, hour, minute, second, time, million = LegendTime()
  if million - self.lastTime > self.handlerInner then
    return true
  end
  return false
end
function button:touch(event, x, y)
  if self.visible == false then
    return false
  end
  if self.isEnable == false then
    return false
  end
  if event == "began" then
    if ed.checkVisible(self.sprite) and self:isContainPoint(x, y) then
      self:enablePress(true)
      self.pressed = true
      if self.donwHandler then
        xpcall(function()
          self.donwHandler(self.dataInfo.base.arrayIndex or self.arrayIndex)
        end, EDDebug)
      end
      return true
    end
  elseif event == "ended" and self.pressed == true then
    if self.upHandler then
      xpcall(function()
        self.upHandler(self.dataInfo.base.arrayIndex or self.arrayIndex)
      end, EDDebug)
    end
    self:enablePress(false, x, y)
    if self:isContainPoint(x, y) and self.handler and self:checkInnerCondition() then
      xpcall(function()
        self.handler(self.dataInfo.base.arrayIndex or self.arrayIndex)
      end, EDDebug)
      local year, month, day, hour, minute, second, time, million = LegendTime()
      self.lastTime = million
      self:playSound()
    end
    self.pressed = false
    return true
  end
  return false
end
function button:setVisible(visible)
  self.visible = visible
  self.sprite:setVisible(visible)
end
function button:getParent()
  if self.sprite then
    return self.sprite:getParent()
  end
end
function button:setPosition(pos)
  if self.sprite and pos then
    self.sprite:setPosition(pos)
    self.dataInfo.layout.position = pos
  end
end
function button:getPosition()
  if self.sprite then
    return self.sprite:getPosition()
  end
end
function button:getControllerSize()
  if self.sprite then
    local rect = ed.getNodeSize(self.sprite)
    return rect:getMinX(), rect:getMaxX(), rect:getMinY(), rect:getMaxY()
  end
end
function button:addChild(node)
  if node == nil then
    return
  end
  if self.sprite then
    self.sprite:addChild(node)
  end
end
function button:enable(enable)
  self.isEnable = enable
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  if enable == true then
    self:initSpriteWithRes(resInfo.normal)
  else
    if resInfo.disable == nil then
      print("error: miss disable res!!!")
      return
    end
    self:initSpriteWithRes(resInfo.disable)
  end
end
spriteButton = {}
setmetatable(spriteButton, button)
spriteButton.__index = spriteButton
spriteButton.sprite = nil
function spriteButton:initSpriteWithRes(res)
  if not self.sprite then
    return
  end
  local frame = ed.getSpriteFrame(res)
  if frame then
    self.sprite:initWithSpriteFrame(frame)
  end
  ed.readnode.setLayout(nil, self.sprite, self.dataInfo)
end
function spriteButton:init(data)
  self.sprite = CCSprite:create()
  if self.dataInfo ~= nil then
    local resInfo = self.dataInfo.base.res
    if resInfo ~= nil and resInfo.normal then
      self:initSpriteWithRes(resInfo.normal)
    end
  end
  ed.readnode.setLayout(nil, self.sprite, data)
  ed.readnode.setConfig(nil, self.sprite, data)
  self.scale = self.sprite:getScale()
  self.scaleX = self.sprite:getScaleX()
  self.scaleY = self.sprite:getScaleY()
end
function spriteButton:new(data)
  local object = {}
  setmetatable(object, self)
  object:initBaseInfo(data)
  object:init(data)
  return object
end
function spriteButton:enablePress(enable)
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  if enable then
    if resInfo.press ~= nil then
      self:initSpriteWithRes(resInfo.press)
    else
      self.sprite:setScaleX(0.95 * self.scaleX)
      self.sprite:setScaleY(0.95 * self.scaleY)
    end
  elseif resInfo.press ~= nil then
    self:initSpriteWithRes(resInfo.normal)
  else
    self.sprite:setScaleX(self.scaleX)
    self.sprite:setScaleY(self.scaleY)
  end
end
checkButton = {}
setmetatable(checkButton, spriteButton)
checkButton.check = false
checkButton.__index = checkButton
function checkButton:new(data)
  local object = {}
  setmetatable(object, self)
  object:initBaseInfo(data)
  object:init(data)
  return object
end
function checkButton:enablePress(enable, x, y)
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  if enable == true then
    return
  end
  if self.check == false and self:isContainPoint(x, y) then
    self:press()
  end
end
function checkButton:cancelPress()
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  self.check = false
  if resInfo.normal ~= nil then
    self:initSpriteWithRes(resInfo.normal)
    local z = self.dataInfo.base.normalZ
    if z then
      self.sprite:setZOrder(z)
    end
  end
end
function checkButton:press()
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  self.check = true
  if resInfo.press ~= nil then
    self:initSpriteWithRes(resInfo.press)
    local z = self.dataInfo.base.pressZ
    if z then
      self.sprite:setZOrder(z)
    end
  end
end
Scale9Button = {}
setmetatable(Scale9Button, button)
Scale9Button.text = nil
Scale9Button.__index = Scale9Button
function Scale9Button:changeText(buttonName)
  if nil == buttonName then
    return
  end
  self.buttonName = buttonName
  self.sprite:removeChildByTag(1, true)
  self:createText()
end
function Scale9Button:createText()
  local buttonName = self.buttonName and self.buttonName or self.dataInfo.base.buttonName
  if buttonName ~= nil then
    local label = ed.createLabelWithFontInfo(buttonName.text, buttonName.fontInfo)
    label:setAnchorPoint(ccp(0.5, 0.5))
    local size = self.sprite:getContentSize()
    label:setPosition(ccp(size.width / 2, size.height / 2))
    self.sprite:addChild(label, 0, 1)
  end
end
function Scale9Button:initSpriteWithRes(res)
  if self.sprite and res then
    self.sprite:initWithFile(self.dataInfo.base.capInsets, res)
    ed.readnode.setLayout(nil, self.sprite, self.dataInfo)
    ed.readnode.setConfig(nil, self.sprite, self.dataInfo)
  end
  self:createText()
end
function Scale9Button:init(data)
  local resInfo = self.dataInfo.base.res
  if resInfo.normal ~= nil then
    local frame = ed.getSpriteFrame(resInfo.normal)
    if not frame then
      print("error Scale9Button with wrong res!!")
    end
    self.sprite = CCScale9Sprite:createWithSpriteFrame(frame, self.dataInfo.base.capInsets)
  else
    self.sprite = CCScale9Sprite:create()
  end
  ed.readnode.setLayout(nil, self.sprite, data)
  ed.readnode.setConfig(nil, self.sprite, data)
  self:createText()
end
function Scale9Button:new(data)
  local object = {}
  setmetatable(object, self)
  object:initBaseInfo(data)
  object:init(data)
  return object
end
function Scale9Button:enablePress(enable)
  local resInfo = self.dataInfo.base.res
  if nil == resInfo then
    return
  end
  if enable then
    if resInfo.press ~= nil then
      self:initSpriteWithRes(resInfo.press)
    end
  elseif resInfo.press ~= nil then
    self:initSpriteWithRes(resInfo.normal)
  end
end
Scale9CheckButton = {}
setmetatable(Scale9CheckButton, Scale9Button)
Scale9CheckButton.check = false
Scale9CheckButton.__index = Scale9CheckButton
function Scale9CheckButton:new(data)
  local object = {}
  setmetatable(object, self)
  object:initBaseInfo(data)
  object:init(data)
  return object
end
function Scale9CheckButton:enablePress(enable, x, y)
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  if enable == true then
    return
  end
  if self.check == false and self:isContainPoint(x, y) then
    self:press()
  end
end
function Scale9CheckButton:createText()
  local buttonName = self.dataInfo.base.buttonName
  if buttonName ~= nil then
    local fontinfo
    if self.check == false then
      fontinfo = buttonName.normalFontInfo
    else
      fontinfo = buttonName.pressFontInfo
    end
    local label = ed.createLabelWithFontInfo(buttonName.text, fontinfo)
    label:setAnchorPoint(ccp(0.5, 0.5))
    local size = self.sprite:getContentSize()
    label:setPosition(ccp(size.width / 2, size.height / 2))
    self.sprite:addChild(label)
  end
end
function Scale9CheckButton:cancelPress()
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  self.check = false
  if resInfo.normal ~= nil then
    self:initSpriteWithRes(resInfo.normal)
    local z = self.dataInfo.base.normalZ
    if z then
      self.sprite:setZOrder(z)
    end
  end
end
function Scale9CheckButton:press()
  local resInfo = self.dataInfo.base.res
  if resInfo == nil then
    return
  end
  self.check = true
  self:initSpriteWithRes(resInfo.press)
  local z = self.dataInfo.base.pressZ
  if z then
    self.sprite:setZOrder(z)
  end
end

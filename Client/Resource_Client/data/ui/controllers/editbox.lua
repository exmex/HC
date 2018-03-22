editBox = {}
editBox.__index = editBox
editBox.edit = nil
editBox.pressed = false
editBox.editState = false
editBox.visible = true
function editBox:init(info)
  if info == nil then
    return
  end
  if info.config.editSize == nil then
    print("error:editBox need editSize")
  end
  local button = ed.createScale9Sprite("UI/alpha/HVGA/chat/chat_invisible.png", CCRectMake(2, 2, 4, 4))
  self.edit = CCEditBox:create(info.config.editSize, button, nil, nil, false)
  if info.config.fontColor ~= nil then
    self.edit:setFontColor(info.config.fontColor)
  end
  if info.config.fontSize ~= nil then
    self.edit:setFont(ed.font, info.config.fontSize)
  end
  if info.config.position ~= nil then
    self.edit:setPosition(info.config.position)
  end
  if info.config.maxLength ~= nil then
    self.edit:setMaxLength(info.config.maxLength)
  end
  if info.config.visible ~= nil then
    self:setVisible(info.config.visible)
  end
end
function editBox:new(info)
  local edit = {}
  setmetatable(edit, self)
  edit:init(info)
  return edit
end
function editBox:getString()
  if self.edit then
    return self.edit:getText()
  end
  return ""
end
function editBox:setString(s)
  if nil == self.edit then
    return false
  end
  return self.edit:setText(s)
end
function editBox:setInputMode(mode)
  if nil == self.edit then
    return
  end
  return self.edit:setInputMode(mode)
end
function editBox:setInputFlag(flag)
  if nil == self.edit then
    return
  end
  return self.edit:setInputFlag(flag)
end
function editBox:setPlaceHolder(text)
  if nil == self.edit then
    return
  end
  return self.edit:setPlaceHolder(text)
end
function editBox:isContainPoint(x, y)
  if nil == self.edit then
    return false
  end
  return ed.containsPoint(self.edit, x, y)
end
function editBox:setVisible(visible)
  if nil == self.edit then
    return
  end
  self.visible = visible
  return self.edit:setVisible(visible)
end
function editBox:setConditionFunc(func)
  if nil == self.edit then
    return
  end
  self.conditionFunc = func
end
function editBox:touch(event, x, y)
  if self.visible == false then
    return false
  end
  if event == "began" then
    if ed.checkVisible(self.edit) and self:isContainPoint(x, y) then
      self.pressed = true
      return true
    end
  elseif event == "ended" and self.pressed == true then
    if self:isContainPoint(x, y) then
      if not self.conditionFunc then
        self.edit:openKeyBoard()
      elseif self.conditionFunc() == true then
        self.edit:openKeyBoard()
      end
    end
    self.pressed = false
    return true
  end
  return false
end

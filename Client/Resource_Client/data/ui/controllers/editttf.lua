editTTF = {}
editTTF.__index = editTTF
editTTF.edit = nil
editTTF.pressed = false
editTTF.editState = false
editTTF.maxLength = 0
function editTTF:setMaxLength(length)
  if self.edit and length then
    self.edit:setMaxLength(length)
  end
end
function editTTF:init(info)
  if info == nil then
    return
  end
  if info.config == nil then
    print("error:editttf need messagerect!!")
    return
  end
  if info.config.messageRect == nil then
    print("error:editttf need messagerect!!")
    return
  end
  self.edit = CCTextFieldTTF:textFieldWithPlaceHolder("", ed.font, 20)
  if info.config.maxLength ~= nil and self.edit.setMaxLength then
    self.edit:setMaxLength(info.config.maxLength)
    self.maxLength = info.config.maxLength
  end
  if info.config.maxCharCount ~= nil and self.edit.setMaxCodeNum then
    self.edit:setMaxCodeNum(info.config.maxCharCount)
  end
  self.edit:setString(info.base.text or "")
  ed.readnode.setLayout(nil, self.edit, info)
  ed.readnode.setConfig(nil, self.edit, info)
end
function editTTF:new(info)
  local edit = {}
  setmetatable(edit, self)
  edit:init(info)
  return edit
end
function editTTF:getString()
  if self.edit then
    return self.edit:getString()
  end
  return ""
end
function editTTF:isContainPoint(x, y)
  if nil == self.edit then
    return false
  end
  return ed.containsPoint(self.edit, x, y)
end
function editTTF:lostFocus()
  if nil == self.edit or false == self.editState then
    return
  end
  self.edit:detachWithIME()
end
function editTTF:setVisible(visible)
  if nil == self.edit then
    return
  end
  return self.edit:setVisible(visible)
end
function editTTF:setString(s)
  if nil == self.edit then
    return false
  end
  return self.edit:setString(s)
end
function editTTF:touch(event, x, y)
  if self.visible == false then
    return false
  end
  if event == "began" then
    if ed.checkVisible(self.edit) and self:isContainPoint(x, y) then
      self.pressed = true
      return true
    elseif self.editState == true then
      self.edit:detachWithIME()
    end
  elseif event == "ended" and self.pressed == true then
    if self:isContainPoint(x, y) then
      self.editState = true
      self.edit:attachWithIME()
    end
    self.pressed = false
    return true
  end
  return false
end
function editTTF:getExceedLength()
  if self.edit and self.maxLength > 0 then
    local contentLength = self.edit:getContentSize()
    if contentLength.width > self.maxLength then
      return contentLength.width - self.maxLength
    end
  end
  return nil
end

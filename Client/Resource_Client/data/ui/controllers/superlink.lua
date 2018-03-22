local superLink = {}
superLink.__index = superLink
superLink.label = nil
superLink.content = ""
superLink.type = ""
superLink.extraData = ""
superLink.pressed = false
function superLink:isContainPoint(x, y)
  if nil == self.label then
    return false
  end
  return ed.containsPoint(self.label, x, y)
end
function superLink:touch(event, x, y)
  if self.label == nil then
    return
  end
  if event == "began" then
    if ed.checkVisible(self.label) and ed.containsPoint(self.label, x, y) then
      self.pressed = true
      return true
    end
  elseif event == "ended" and self.pressed == true then
    if ed.containsPoint(self.label, x, y) and self.handler then
      xpcall(function()
        self:handler()
      end, EDDebug)
    end
    self.pressed = false
    return true
  end
  return false
end
function superLink:setExtraData(extra)
  self.extraData = extra
end
function superLink:setType(type)
  self.type = type
end
function superLink:getLabel()
  return self.label
end
function superLink:getSize()
  if tolua.isnull(self.label) then
    return
  end
  if not self.label.getContentSize then
    return
  end
  return self.label:getContentSize()
end
local pvpLink = {}
setmetatable(pvpLink, superLink)
pvpLink.__index = pvpLink
function pvpLink:paraseExtra(extraData)
end
function pvpLink:setString(content)
  self.content = content
  if self.label then
    ed.setString(self.label, self.content)
  else
    self.label = ed.createLabelWithFontInfo(self.content, "chat_pvp_link")
  end
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end
function pvpLink:handler()
  if self.extraData == nil then
    return
  end
  if self.extraData.channel == nil or self.extraData.chatId == nil then
    return
  end
  local msg = ed.upmsg.chat()
  msg._fetch = {}
  msg._fetch._channel = self.extraData.channel
  msg._fetch._chat_id = self.extraData.chatId
  ed.send(msg, "chat")
end
function pvpLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end
local excavateLink = {}
setmetatable(excavateLink, superLink)
excavateLink.__index = excavateLink
function excavateLink:paraseExtra(extraData)
end
function excavateLink:setString(content)
  content = tonumber(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label = ed.getExcavateNameTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, size.height, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end
function excavateLink:handler()
  if self.extraData == nil then
    return
  end
  if self.extraData.channel == nil or self.extraData.chatId == nil then
    return
  end
  local msg = ed.upmsg.chat()
  msg._fetch = {}
  msg._fetch._channel = self.extraData.channel
  msg._fetch._chat_id = self.extraData.chatId
  ed.send(msg, "chat")
end
function excavateLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end
local function createSuperLink(type, content, extraData)
  local link
  if "pvp" == type then
    link = pvpLink:new()
  end
  if type == "excavate" then
    link = excavateLink:new()
  end
  if link then
    link:setType(type)
    link:setString(content)
    link:setExtraData(extraData)
  end
  return link
end
ed.createSuperLink = createSuperLink

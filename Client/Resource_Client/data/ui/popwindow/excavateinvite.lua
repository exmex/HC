local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.excavateinvite = class
local icon
local doClickSend = function(self)
  if #ed.membershare.getTargetMember() >= 1 then
    local param, excavateId, content = self:getSetData()
    print(content)
    local data = {content = content, excavateId = excavateId}
    ed.membershare.shareToPrivate(data)
    self:destroy()
    ed.membershare.destoryData()
  else
    self:sendLink()
  end
end
class.doClickSend = doClickSend
local function setIcon(self)
  icon = CCNode:create()
  icon:setAnchorPoint(ccp(0, 0.5))
  icon:setPosition(ccp(40, 165))
  self.ui.frame:addChild(icon)
end
class.setIcon = setIcon
local function setShareTarget(self, node)
  icon:removeAllChildrenWithCleanup(true)
  if node then
    icon:addChild(node, 200)
  else
    local ui1 = ed.createLabelWithFontInfo(LSTR("membershare.1.10.002"), "dark_yellow")
    ui1:setAnchorPoint(ccp(0, 0.5))
    icon:addChild(ui1, 200)
    local ui2 = ed.createLabelWithFontInfo(LSTR("excavateinvite.1.10.001"), "normal_button")
    ui2:setAnchorPoint(ccp(0, 0.5))
    ui2:setPosition(ccp(50, 0))
    icon:addChild(ui2, 200)
  end
end
class.setShareTarget = setShareTarget
local doClickChange = function(self)
  local param = self.param
  local excavateId = param.excavateId
  local text = self.edit_box:getString()
  local content = T(LSTR("EXCAVATEINVITE.TEXT_DARK_WHITE__INVITES_YOU_TO_DEFEND__"))
  content = content .. T("<link|excavate|%s>", param.typeid)
  content = content .. "<>"
  content = content .. T("<text|dark_white|%s|400>", text)
  print(content)
  local data = {content = content, excavateId = excavateId}
  ed.membershare.shareToMembers(data)
end
class.doClickChange = doClickChange
local registerTouch = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    key = "cancel_button",
    clickHandler = function()
      self:destroy()
      ed.membershare.destoryData()
    end
  })
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:doClickSend()
    end,
    clickInterval = 1
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:btRegisterButtonClick({
    button = ui.change_button,
    press = ui.change_button_press,
    key = "change_button",
    clickHandler = function()
      self:doClickChange()
    end
  })
end
class.registerTouch = registerTouch
local getSetData = function(self)
  local param = self.param
  local excavateId = param.excavateId
  local text = self.edit_box:getString()
  local content = T(LSTR("EXCAVATEINVITE.TEXT_DARK_WHITE__INVITES_YOU_TO_DEFEND__"))
  content = content .. T("<link|excavate|%s>", param.typeid)
  content = content .. "<>"
  content = content .. T("<text|dark_white|%s|400>", text)
  return param, excavateId, content
end
class.getSetData = getSetData
local sendLink = function(self)
  local param, excavateId, content = self:getSetData()
  print(content)
  ed.ui.chat.sendExcavateDefendLink({
    content = content or "",
    excavateId = excavateId,
    callback = function(isSuccess)
      if isSuccess then
        ed.showToast(T(LSTR("EXCAVATEINVITE.LINK_HAS_BEEN_SUCCESSFULLY_SENT_TO_GUILD_CHAT_CHANNEL")))
        self:destroy()
        ed.membershare.destoryData()
      else
        ed.showToast(T(LSTR("EXCAVATEINVITE.FAILED_TO_SEND_LINKS")))
      end
    end
  })
end
class.sendLink = sendLink
local initWindow = function(self)
  local ui = self.ui
  local param = self.param
  local typeid = param.typeid
  local tagContainer = ui.excavate_name_container
  local tag = ed.getExcavateNameTag(typeid)
  tag:setAnchorPoint(ccp(0, 0))
  tag:setPosition(ccp(0, 0))
  tagContainer:addChild(tag)
  ui.name_tag = tag
  local edit_frame = ui.edit_frame
  local info = {
    config = {
      editSize = edit_frame:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setString(T(""))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_frame:addChild(edit_box.edit)
  self.edit_box = edit_box
  self:setIcon()
  self:setShareTarget()
  self:registerTouch()
end
class.initWindow = initWindow
local function create(param)
  local self = base.create("excavateinvite")
  setmetatable(self, class.mt)
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.excavateinvite)
  self:setContainer(container)
  local title = self.ui.invite_title
  ed.setLabelDimensions(title, ed.DGSizeMake(475, 0))
  title:setAnchorPoint(ccp(0, 1))
  self:show({
    callback = function()
      self:initWindow(param)
    end
  })
  return self
end
class.create = create
local function pop(param)
  local scene = CCDirector:sharedDirector():getRunningScene()
  local window = create(param)
  scene:addChild(window.mainLayer, 100)
  return window
end
class.pop = pop

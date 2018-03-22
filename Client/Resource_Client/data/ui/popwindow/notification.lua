local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
ed.ui.notification = class
local createListLayer = function(self)
  local info = {
    cliprect = ed.DGRectMake(30, 20, 635, 410),
    noshade = true,
    container = self.ui.frame,
    zorder = 5
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer

local function getFormatTimeStr(time)
	if time >= 24 then
		time = time - 24;
	end
	
	if time < 0 then
		time = time + 24;
	end
	
	if time == 0 then
		return "00:00"
	end
	
	return time..":00"
end

local function create()
  local self = base.create("notification", {isShade = true})
  setmetatable(self, class.mt)
  self.itemsNum = 7
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.setup)
  self:setContainer(container)
  local ui = self.ui
  self:createListLayer()
  local listContainer, listui = ed.editorui(ed.uieditor.setuplist)
  listContainer:setPosition(ed.DGccp(0, -180))
  self.draglist.listLayer:addChild(listContainer, 5)
  self.listui = listui
  self.draglist:initListHeight(400)
  self:initTouchHandler()
  self:refreshSoundButton()
  self:refreshSwitchButton()
  --时区时间差
  local serverZone = ed.serverTimeZone;
  local systemZone = ed.getCurrentZoneDiff();
  local diff = math.ceil((systemZone - serverZone)/(60*60));
  --21:00
  local time21 = 21+diff;
  local str = getFormatTimeStr(time21);
  listui.left_label_5_1:setString(str);
  --18:00
  local time18 = 18+diff;
  str = getFormatTimeStr(time18);
  listui.left_label_2_1:setString(str);
  --9:00
  local time9 = 9+diff;
  str = getFormatTimeStr(time9);
  listui.left_label_4_1:setString(str);
  --12:00
  local time12 = 12+diff;
  str = getFormatTimeStr(time12);
  listui.left_label_1_1:setString(str);
  return self
end
class.create = create
local refreshSwitchButton = function(self, id)
  local function refresh(i)
    local ui = self.listui
    if ui then
      local on = ui["switch_open_" .. i]
      local off = ui["switch_close_" .. i]
      local sw = self:getSwitch(i)
      if sw then
        on:setVisible(true)
        off:setVisible(false)
      else
        on:setVisible(false)
        off:setVisible(true)
      end
    end
  end
  if id then
    refresh(id)
  else
    for i = 1, self.itemsNum do
      if 9 ~= i then
        refresh(i)
      end
    end
  end
end
class.refreshSwitchButton = refreshSwitchButton
local refreshSoundButton = function(self)
  local listui = self.listui
  local onLabel = listui.sound_on
  local closeLabel = listui.sound_off
  if ed.getSoundSwitch() then
    onLabel:setVisible(true)
    closeLabel:setVisible(false)
  else
    onLabel:setVisible(false)
    closeLabel:setVisible(true)
  end
end
class.refreshSoundButton = refreshSoundButton
local setSoundLabelVisible = function(self, isVisible)
  local listui = self.listui
  local press
  if ed.getSoundSwitch() then
    press = listui.sound_on_press
  else
    press = listui.sound_off_press
  end
  press:setVisible(isVisible)
end
class.setSoundLabelVisible = setSoundLabelVisible
local doClickSoundButton = function(self)
  ed.turnSoundSwitch()
  self:refreshSoundButton()
end
class.doClickSoundButton = doClickSoundButton
local doClickCDKeyButton = function(self)
  local cw = ed.ui.cdkeywindow.create()
  self.container:addChild(cw.mainLayer, 50)
end
class.doClickCDKeyButton = doClickCDKeyButton
local doClickBlickListButton = function(self)
  ed.blacklist.getBlacklist()
end
class.doClickBlickListButton = doClickBlickListButton
local doClickSwitch = function(self, id)
  self:setSwitch(id)
  self:refreshSwitchButton(id)
end
class.doClickSwitch = doClickSwitch
local initTouchHandler = function(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  local listui = self.listui
  local area = ui.frame
  self:btRegisterOutClick({
    area = area,
    key = "outFrame",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
  local button = ui.close
  local press = ui.close_press
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "close",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
  button = listui.sound
  press = listui.sound_press
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "sound",
    pressHandler = function()
      self:setSoundLabelVisible(true)
    end,
    clickHandler = function()
      self:setSoundLabelVisible(false)
      self:doClickSoundButton()
    end
  })
  button = listui.blacklist
  press = listui.blacklist_press
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "blacklist",
    clickHandler = function()
      self:doClickBlickListButton()
    end
  })
  button = listui.cdkey
  press = listui.cdkey_press
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "cdkey",
    clickHandler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("CDKey")
      if ds then
        ed.showToast(ds)
        return
      end
      self:doClickCDKeyButton()
    end
  })
  self:btRegisterHandler({
    handler = self.draglist:getListLayerTouchHandler()
  })
  for i = 1, self.itemsNum do
    if i ~= 9 then
      button = listui["switch_open_" .. i]
      press = listui["switch_close_" .. i]
      self:btRegisterButtonClick({
        button = button,
        key = "switch_open_" .. i,
        clickHandler = function()
          self:doClickSwitch(i)
        end
      })
      self:btRegisterButtonClick({
        button = press,
        key = "switch_close_" .. i,
        clickHandler = function()
          self:doClickSwitch(i)
        end
      })
    end
  end
end
class.initTouchHandler = initTouchHandler
local getSwitch = function(self, id)
  if id >= 8 and id <= self.itemsNum then
    local isRet = true
    if not ed.localnotify.settingTable then
      ed.localnotify.settingTable = {}
    end
    local item = ed.localnotify.settingTable[id]
    if nil == item then
      ed.localnotify.settingTable[id] = true
    else
      isRet = ed.localnotify.settingTable[id]
    end
    return isRet
  else
    return ed.localnotify.getSwitch(id)
  end
end
class.getSwitch = getSwitch
local setSwitch = function(self, id)
  if id >= 8 and id <= self.itemsNum then
    if not ed.localnotify.settingTable then
      ed.localnotify.settingTable = {}
    end
    local item = ed.localnotify.settingTable[id]
    if nil == item then
      ed.localnotify.settingTable[id] = true
    elseif ed.localnotify.settingTable[id] then
      ed.localnotify.settingTable[id] = false
    else
      ed.localnotify.settingTable[id] = true
    end
    local msg = ed.upmsg.system_setting()
    msg._change = {}
    msg._change.key = tostring(id)
    if ed.localnotify.settingTable[id] then
      msg._change.value = "on"
    else
      msg._change.value = "off"
    end
    print("key " .. msg._change.key)
    print("value " .. msg._change.value)
    ed.send(msg, "system_setting")
  else
    ed.localnotify.setSwitch(id)
  end
end
class.setSwitch = setSwitch
local OnGetSettingStateSuc = function(msg)
  if msg then
    local system_setting_request = msg._request
    if system_setting_request then
      local system_setting_items = system_setting_request._system_setting_item
      for i = 1, #(system_setting_items or {}) do
        local item = system_setting_items[i]
        local key = tonumber(item.key)
        local result = item.value == "on"
        if not ed.localnotify.settingTable then
          ed.localnotify.settingTable = {}
        end
        ed.localnotify.settingTable[key] = result
      end
    end
    local system_setting_change = msg._change
    if system_setting_change then
      if system_setting_change._result == "success"then
        saveCurrentLanguage()
        if needRestart then
          needRestart = false
          ed.replaceScene(ed.ui.platformlogo.create())
        end
      end
    end
  end
end
local sendGetSettingStatusMsg = function()
  local msg = ed.upmsg.system_setting()
  msg._request = {}
  ed.send(msg, "system_setting")
end
local function OnEnterMainScene()
  sendGetSettingStatusMsg()
end
ListenEvent("SystemSettingReply", OnGetSettingStateSuc)
ListenEvent("EnterMainScene", OnEnterMainScene)

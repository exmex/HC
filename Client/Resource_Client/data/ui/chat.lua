local class = {}
ed.ui.chat = class
local base = ed.ui.chat
local chatPanel
local maxShowLength = 400
local defaultLinePos = -32
local defaultLinePos2 = -28
local defaultLinePos3 = -15
local editBoxDistance = 200
local chatYPosition = 239
local currentAccessory
local currentChannel = "world_channel"
local chatMessages = {
  world_channel = {},
  guild_channel = {},
  personal_channel = {}
}
local chatTune = false
local defaultInternal = 3
local maxInternal = 15
local refreshInternal = defaultInternal
local refreshChatEvent
local moveDistance = 800
local chatScope = {}
local dragPressX, oriChatPos
local chatMinX = -558
local chatMaxX = -10
local bFirtPay = true
local worldCost = 5
local lastWorldChatTime, moveState, targetSummary, targetUid
local function refreShFreeTime()
  local str
  local leftFreeTime = ed.player:getChatFreeTime()
  if leftFreeTime > 0 then
    str = T(LSTR("CHAT.TEXT_MAIN_NAME_FREE_D"), leftFreeTime)
  else
    str = string.format("<sprite|UI/alpha/HVGA/rmbicon.png|0.8><text|main_name|  %d>", worldCost)
  end
  chatPanel.mainLayer.leftTimes:setString(str)
end
local function refreshInputPos()
	local x, y = chatPanel.chatBg:getPosition()
	local worldEdit = chatPanel.worldEdit
	local guildEdit = chatPanel.guildEdit
	local ex , ey = worldEdit.edit:getPosition()
	if (ex == x + 200) and (ey == 380) then
		return
	end
	worldEdit.edit:setPosition(ccp(x - 80, 340))
	guildEdit.edit:setPosition(ccp(x - 50, 340))
end
local getChatTimeDes = function(data)
  local time = ed.time2China(data)
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%02d:%02d", h, m)
end
local function getContentHeight(content, type)
  if type == 1 then
    local label = ed.createLabelWithFontInfo(content, "normal_button")
    label:setDimensions(CCSizeMake(maxShowLength, 0))
    return label:getContentSize().height
  elseif type == 2 then
    local text = richText:new()
    text:setString(content)
    local width, height = text:getSize()
    return height
  end
end
local function showOnePrivateChat(channel, data)
  if nil == data then
    return
  end
  local listView = chatPanel.mainLayer.listviewPrivate
  local height = getContentHeight(data._content, data._content_type)
  local tome = data._target_uid == ed.getUserid()
  local lineInde, lineDefaultPos
  if tome == false then
    listView:changeItemConfig(2)
    lineInde = 5
    lineDefaultPos = defaultLinePos3
  else
    listView:changeItemConfig()
    lineInde = 8
    lineDefaultPos = defaultLinePos2
  end
  local itemConfig = listView:getItemConfig()
  itemConfig[lineInde].layout.position.y = lineDefaultPos - height
  local time = getChatTimeDes(data._speak_time)
  local item
  if tome == false then
  if data._content_type == 1 then
      item = listView:addItem({
        data._target_summary._name,
        time,
        data._content
      }, {
        summary = data._target_summary,
        uid = data._target_uid
    })
  elseif data._content_type == 2 then
      item = listView:addItem({
        data._target_summary._name,
        time,
        "",
        data._content
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._target_summary,
        uid = data._target_uid
      })
    end
  else
    if data._content_type == 1 then
      item = listView:addItem({
        "",
        data._speaker_summary._name,
        time,
        data._content,
        {
          scale = 0.6,
          id = data._speaker_summary._avatar,
          vip = data._speaker_summary._vip > 0,
          level = data._speaker_summary._level,
          config = {levelposition = 2}
        }
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._speaker_summary,
        uid = data._speaker_uid
      })
    elseif data._content_type == 2 then
      item = listView:addItem({
        "",
        data._speaker_summary._name,
        time,
        "",
        {
          scale = 0.6,
          id = data._speaker_summary._avatar,
          vip = data._speaker_summary._vip > 0,
          level = data._speaker_summary._level,
          config = {levelposition = 2}
        },
        data._content
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._speaker_summary,
        uid = data._speaker_uid
      })
    end
    local name = item.controllers.name
    local length = name:getContentSize().width
    item.controllers.hint:setPosition(ccp(110 + length, -2))
  end
end
local function showOneChat(channel, data)
  if channel == "personal_channel" then
    showOnePrivateChat(channel, data)
    return
  end
  local listView
  if channel == "world_channel" then
    listView = chatPanel.mainLayer.listviewWorld
  elseif channel == "guild_channel" then
    listView = chatPanel.mainLayer.listviewUnin
  end
  local height = getContentHeight(data._content, data._content_type)
  local itemConfig = listView.configData.itemConfig
  if data._content_type == 2 then
    itemConfig[1].config.visible = true
  else
    itemConfig[1].config.visible = false
  end
  itemConfig[8].layout.position.y = defaultLinePos - height
  itemConfig[1].config.scalexy.y = math.abs(defaultLinePos - height) / 60
  local speakerSummary = data._speaker_summary
  local headId = speakerSummary._avatar
  local time = getChatTimeDes(data._speak_time)
  if data._content_type == 1 then
    listView:addItem({
      "",
      "",
      "",
      time,
      data._content,
      {
        scale = 0.6,
        id = headId,
        vip = speakerSummary._vip > 0,
        level = speakerSummary._level,
        name = speakerSummary._name,
        config = {
          levelposition = 4,
          nameposition = 23,
          namefont = "chat_name"
        }
      },
      ""
    }, {
      summary = speakerSummary,
      uid = data._speaker_uid
    })
  elseif data._content_type == 2 then
    listView:addItem({
      "",
      "",
      "",
      time,
      "",
      {
        scale = 0.6,
        id = headId,
        vip = speakerSummary._vip > 0,
        level = speakerSummary._level,
        name = speakerSummary._name,
        config = {
          levelposition = 4,
          nameposition = 23,
          namefont = "chat_name"
        }
      },
      data._content
    }, {
      chatId = data._chat_id,
      channel = channel,
      summary = speakerSummary,
      uid = data._speaker_uid
    })
  end
end
local function refreshWorldState(channel)
  local leftFreeTime = ed.player:getChatFreeTime()
  if channel == "world_channel" then
    lastWorldChatTime = ed.getServerTime()
    if leftFreeTime == 0 then
      ed.player:subrmb(worldCost)
      return
    end
    ed.player:subChatFreeTime()
    refreShFreeTime()
  end
end
local function showChat(contents, channel)
  if contents == nil then
    return
  end
  for i, v in ipairs(contents) do
    showOneChat(channel, v)
  end
  local leftFreeTime = ed.player:getChatFreeTime()
  if channel == "world_channel" then
    lastWorldChatTime = ed.getServerTime()
    if leftFreeTime == 0 then
      ed.player:subrmb(worldCost)
      return
    end
    ed.player:subChatFreeTime()
    refreShFreeTime()
  end
end
local function initPlayer(player, name, level, result, heros, icon, vip)
  local sIcon = player .. "Icon"
  local sLevel = player .. "Level"
  local sName = player .. "Name"
  local sResult = player .. "Result"
  local head = ed.getHeroIconByID({
    id = icon,
    vip = vip > 0
  })
  if head then
    chatPanel.pvpLayer[sIcon]:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    chatPanel.pvpLayer[sIcon]:addChild(head)
  end
  ed.setString(chatPanel.pvpLayer[sLevel], tostring(level))
  ed.setString(chatPanel.pvpLayer[sName], name)
  local effectName = result == "victory" and "UI/alpha/HVGA/pvp/pvp_win.png" or "UI/alpha/HVGA/pvp/pvp_lose.png"
  local frame = ed.getSpriteFrame(effectName)
  if frame then
    chatPanel.pvpLayer[sResult]:initWithSpriteFrame(frame)
  end
  for i = 1, 5 do
    local hero = string.format("%sHero%d", player, i)
    chatPanel.pvpLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  if heros then
    for i, v in ipairs(heros) do
      local hero = string.format("%sHero%d", player, i)
      local heroIcon = ed.readhero.createIcon({
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars
      })
      heroIcon.icon:setScale(0.6)
      chatPanel.pvpLayer[hero]:addChild(heroIcon.icon)
    end
  end
  local wL = chatPanel.pvpLayer.leftName:getContentSize().width
  if wL > 130 then
	  chatPanel.pvpLayer.leftName:setScale(130 / chatPanel.pvpLayer.leftName:getContentSize().width)
  end
  local wR = chatPanel.pvpLayer.rightName:getContentSize().width
  if wR > 130 then
	  chatPanel.pvpLayer.rightName:setScale(130 / chatPanel.pvpLayer.rightName:getContentSize().width)
  end
end
local function showPvp(data)
  if nil == data then
    return
  end
  chatPanel.pvpLayer:setVisible(true)
  local leftResult = data._result
  local rightResult
  if leftResult == "victory" then
    rightResult = "defeat"
  elseif leftResult == "defeat" then
    rightResult = "victory"
  end
  local leftAvatar = data._avatar ~= 0 and data._avatar or 1
  local rightAvatar = data._oppo_avatar ~= 0 and data._oppo_avatar or 1
  initPlayer("left", data._username, data._level, leftResult, data._self_heroes, leftAvatar, data._vip)
  initPlayer("right", data._oppo_name, data._oppo_level, rightResult, data._oppo_heroes, rightAvatar, data._oppo_vip)
end
class.showPvp = showPvp
local showExcavate = function(data)
  if not data then
    return
  end
  local uid, eid = string.match(data, "uid:([^,]*),eid:([^,]*),")
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("Excavate")
  if ds then
    ed.showToast(ds)
  elseif tonumber(uid) == tonumber(ed.getUserid()) then
    ed.ui.excavate.initialize({
      from = "chatLink",
      initId = tonumber(eid)
    })
  else
    local msg = ed.upmsg.excavate()
    local qed = ed.upmsg.query_excavate_def()
    qed._mine_id = tonumber(eid)
    qed._applier_uid = tonumber(uid)
    msg._query_excavate_def = qed
    ed.send(msg, "excavate")
  end
end
class.showExcavate = showExcavate
local function showLink(data)
  if nil == data then
    return
  end
  local accessory = data._accessory
  if nil == accessory then
    return
  end
  if accessory._type == "pvp_replay" then
    showPvp(accessory._replay)
    currentAccessory = accessory._replay
  end
  if accessory._type == "binary" then
    local str = accessory._binary
    local mt = string.match(str, "type:([^,]*),")
    if mt == "excavatedefend" then
      showExcavate(str)
    end
  end
end
local function insertOneMessage(channel, content)
  if not ed.blacklist.isInBlacklist(content._speaker_uid) then
  table.insert(chatMessages[channel], content)
end
end
local function addMessage(channel, datas)
  if nil == datas then
    return
  end
  for i, v in ipairs(datas) do
    insertOneMessage(channel, v)
  end
end
local function reqChatMessage()
  if ed.getCurrentScene().identity == "main" then
    local msg = ed.upmsg.chat()
    msg._fresh = {}
    msg._fresh._channel = currentChannel
    ed.send(msg, "chat")
  end
end
local function OnChatRsp(data)
  if data._say then
    local handler = ed.netreply.chatSay
    if handler then
      handler(data._say._result == "success")
      ed.netreply.chatSay = nil
    end
    if data._say._result == "success" then
      addMessage(data._say._channel, data._say._contents)
      refreshWorldState(data._say._channel)
    end
  elseif data._fresh then
    if data._fresh._contents then
      if refreshInternal ~= defaultInternal then
        CloseTimer(refreshChatEvent.Name)
        refreshInternal = defaultInternal
        refreshChatEvent = ListenTimer(Timer:Always(refreshInternal), reqChatMessage, chatScope)
      end
    elseif refreshInternal < maxInternal and refreshChatEvent then
      CloseTimer(refreshChatEvent.Name)
      refreshInternal = refreshInternal + defaultInternal
      refreshChatEvent = ListenTimer(Timer:Always(refreshInternal), reqChatMessage, chatScope)
    end
    addMessage(data._fresh._channel, data._fresh._contents)
  elseif data._fetch then
    showLink(data._fetch)
  elseif data._chat_borad_say then
    local handler = ed.netreply.chatSay
    if handler then
      handler(data._chat_borad_say._result == "success")
      ed.netreply.chatSay = nil
    end
    if data._chat_borad_say._result == "success" then
      print("began")
      addMessage(data._chat_borad_say._channel, data._chat_borad_say._contents)
      refreshWorldState(data._chat_borad_say._channel)
      print("end")
    end
  end
end
local function showReplay()
  chatPanel.pvpLayer:setVisible(false)
  if currentAccessory then
    ed.showReplay(currentAccessory)
  end
end
class.showReplay = showReplay
local function hideChat()
  CloseScope(chatScope)
  chatScope = {}
  chatPanel.chatTurnBack:setVisible(false)
  chatPanel.chatTurn:setVisible(true)
  chatPanel.mainLayer.listviewWorld:setVisible(false)
  chatPanel.mainLayer.listviewUnin:setVisible(false)
  chatPanel.listviewPrivate:setVisible(false)
  chatPanel.mainLayer:setVisible(false)
end
class.hideChat = hideChat
local function refreshTargetInfo()
  if targetSummary == nil or targetUid == nil then
    chatPanel.privateHint:setString(T(LSTR("chat.1.10.1.001")))
  else
    chatPanel.privateHint:setString(T(targetSummary._name))
  end
end
local function initChannel()
  local inGuild = ed.player:getGuildId() ~= 0
  if currentChannel == "guild_channel" and inGuild == false then
    currentChannel = "world_channel"
  end
  if currentChannel == "world_channel" then
    chatPanel.mainLayer.world:setVisible(true)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(true)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(true)
    chatPanel.mainLayer.leftTimes:setVisible(true)
    chatPanel.mainLayer.worldInput:setVisible(true)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(true)
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_inactive")
  elseif currentChannel == "guild_channel" then
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(true)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(true)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(true)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(true)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_inactive")
  elseif currentChannel == "personal_channel" then
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(true)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(true)
    chatPanel.mainLayer.private:setVisible(true)
    chatPanel.mainLayer.listviewPrivate:setVisible(true)
    chatPanel.mainLayer.privateEdit:setVisible(true)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_active")
    refreshTargetInfo()
  end
end
local function refreshMessage()
  for i = 1, 5 do
    if chatMessages[currentChannel][1] then
      showOneChat(currentChannel, chatMessages[currentChannel][1])
      table.remove(chatMessages[currentChannel], 1)
    end
  end
end
local function refreshContentPos()
  if chatPanel == nil then
    return
  end
  local input = chatPanel.mainLayer.input
  local exceedLength = input:getExceedLength()
  if exceedLength then
    input.edit:setPosition(ccp(-exceedLength, 0))
  else
    input.edit:setPosition(ccp(0, 0))
  end
end
local function openChat()
  refreshInternal = defaultInternal
  ListenTimer(Timer:Once(0.5), reqChatMessage)
  refreshChatEvent = ListenTimer(Timer:Always(refreshInternal), reqChatMessage, chatScope)
  ListenTimer(Timer:Always(0.01), refreshMessage, chatScope)
  chatPanel.mainLayer:setVisible(true)
  if chatPanel.mainLayer.chatHint:isVisible() then
    currentChannel = "personal_channel"
  end
  initChannel()
  chatPanel.chatTurnBack:setVisible(true)
  chatPanel.chatTurn:setVisible(false)
  chatPanel.mainLayer.chatHint:setVisible(false)
end
class.openChat = openChat
local openBlacklist = function()
  ed.blacklist.getBlacklist()
end
class.openBlacklist = openBlacklist
local function endChat()

	 LegendLog("CCLayerColor endChat")
  chatTune = false
  hideChat()
  chatPanel.worldEdit.edit:setVisible(false)
  chatPanel.guildEdit.edit:setVisible(false)
  chatPanel.privateEdit.edit:setVisible(false)
  refreshInputPos()
end
ed.endChat=endChat

local function getchatTune()
  return chatTune
end
ed.getchatTune=getchatTune
local function startChat()
  hideChat()
  chatTune = true
  openChat()
  refreShFreeTime()
  chatPanel.worldEdit.edit:setVisible(true)
  chatPanel.guildEdit.edit:setVisible(true)
  chatPanel.privateEdit.edit:setVisible(true)
  refreshInputPos()
end
class.startChat = startChat
local function setChatOpenPosition()
  local chatbg = chatPanel.mainLayer.chatBg
  local posX = chatbg:getPosition()
  chatbg:setPosition(ccp(chatMaxX, chatYPosition))
end
class.setChatOpenPosition = setChatOpenPosition
local function closeTargetInfo()
  chatPanel.targetLayer:setVisible(false)
  targetSummary = nil
end
class.closeTargetInfo = closeTargetInfo
local function getMiddleX()
  if chatTune == false then
    return chatMinX / 1.2
  else
    return chatMinX / 4
  end
end
local function runChatAction()
  local chatbg = chatPanel.mainLayer.chatBg
  local posX = chatbg:getPosition()
  local middleX = getMiddleX()
  if posX >= middleX then
    if chatTune == false then
      startChat()
    end
	chatbg:setPosition(ccp(chatMaxX, 217))
  else
    if chatTune == true then
      endChat()
    end
	chatbg:setPosition(ccp(chatMinX, 257))
  end
end

local function chatTurn()
  if moveState then
    runChatAction()
    return
  end
  local chatbg = chatPanel.mainLayer.chatBg
  if chatTune == false then
    startChat()
	chatbg:setPosition(ccp(chatMaxX, 217))
  else
    endChat()
	chatbg:setPosition(ccp(chatMinX, 257))
  end
  refreshInputPos()
end
class.chatTurn = chatTurn
local function sendMessage(content, type, accessory, channel, targets)
  local msg = ed.upmsg.chat()
  if targets then
    msg._chat_broad_say = {}
    msg._chat_broad_say._content_type = type
    msg._chat_broad_say._target_ids = targets
    msg._chat_broad_say._channel = channel
    msg._chat_broad_say._content = content
  if accessory then
      msg._chat_broad_say._accessory = accessory
    end
  else
    msg._say = {}
    msg._say._content_type = type
    msg._say._channel = channel or currentChannel
    msg._say._content = content
    if msg._say._channel == "personal_channel" then
      msg._say._target_id = targetUid
    end
    if accessory then
    msg._say._accessory = accessory
  end
  end
  ed.send(msg, "chat")
end
local function getCurrentContent()
  if currentChannel == "world_channel" then
    return chatPanel.worldEdit:getString()
  elseif currentChannel == "guild_channel" then
    return chatPanel.guildEdit:getString()
  else
    return chatPanel.privateEdit:getString()
  end
  return ""
end
local function checkPrivateCondition()
  if currentChannel == "personal_channel" and (targetSummary == nil or targetUid == nil) then
    ed.showToast(T(LSTR("chat.1.10.1.002")))
    return false
  end
  return true
end
local function checkChatCondition()
  local content = getCurrentContent()
  if content == "" then
    return false
  end
  if ed.dirtyword_check(content) then
    ed.showToast(T(LSTR("CHAT.CONTAINING_ILLEGAL_TERMS_PLEASE_REENTER")))
    return false
  end
  if currentChannel == "world_channel" then
    if ed.player:getLevel() < 24 then
      ed.showToast(T(LSTR("CHAT.REACH_LEVEL_24_TO_USE_THE_WORLD_CHANNEL")))
      return false
    end
    local now = ed.getServerTime()
    if lastWorldChatTime ~= nil and now - lastWorldChatTime < 11 then
      ed.showToast(T(LSTR("CHAT.SPEAK_TOO_FREQUENTLY")))
      return false
    end
  elseif currentChannel == "guild_channel" and ed.player:getGuildId() == 0 then
    ed.showToast(T(LSTR("CHAT.NEED_TO_JOIN_A_GUILD_FIRST_TO_USE_THE_GUILD_CHANNEL")))
    return false
  end
  if ed.player:getName() == "" then
    local bename = ed.ui.bename.create()
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(bename.mainLayer, 250)
    end
    return false
  end
  return checkPrivateCondition()
end
local function sendCurrentContent()
  local content = getCurrentContent()
  sendMessage(content, 1)
  if currentChannel == "world_channel" then
    chatPanel.worldEdit:setString("")
  elseif currentChannel == "guild_channel" then
    chatPanel.guildEdit:setString("")
  else
    chatPanel.privateEdit:setString("")
  end
end
local function sendChat()
  if ed.blacklist.isInBlacklist(targetUid) then
    ed.showToast(T("�޷���������е��˷�����Ϣ"))
    return
  end
  local bCanSend = checkChatCondition()
  if bCanSend == false then
    return
  end
  local leftFreeTime = ed.player:getChatFreeTime()
  if leftFreeTime == 0 and currentChannel == "world_channel" and worldCost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  if bFirtPay == true and leftFreeTime == 0 and currentChannel == "world_channel" then
    local info = {
      text = T(LSTR("CHAT.COST__D_DIAMONDS_TO_SPEAK_IN_THE_WORLD_CHANNEL_CONTINUE"), worldCost),
      leftText = T(LSTR("CHATCONFIG.CANCEL")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = function()
        xpcall(function()
          bFirtPay = false
          sendCurrentContent()
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
    return
  end
  sendCurrentContent()
end
class.sendChat = sendChat
local function selectChannel(channel)
  if not channel then
    return
  end
  currentChannel = channel
  initChannel()
  reqChatMessage()
end
local function OnWorldTab()
  selectChannel("world_channel")
end
class.OnWorldTab = OnWorldTab
local function OnUninTab()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T(LSTR("CHAT.NEED_TO_JOIN_A_GUILD_FIRST_TO_USE_THE_GUILD_CHANNEL")))
    return
  end
  selectChannel("guild_channel")
end
class.OnUninTab = OnUninTab
local function getTargetSummary(item)
  if not item then
    return
  end
  if not item.extraData then
    return false
  end
  if item.extraData.uid == ed.getUserid() then
    return false
  end
  targetSummary = item.extraData.summary
  targetUid = item.extraData.uid
  return true
end
local function showTargetInfo()
  chatPanel.targetLayer:setVisible(true)
  local head = ed.getWholeHeadIcon({
    id = targetSummary._avatar,
    level = targetSummary._level,
    name = targetSummary._name,
    vip = targetSummary._vip > 0,
    scale = 0.8
  })
  local guildInfo = chatPanel.targetLayer.guildInfo
  if targetSummary._guild_name and targetSummary._guild_name ~= "" then
    guildInfo:setString(T(LSTR("chat.1.10.1.003"), targetSummary._guild_name))
  else
    guildInfo:setString(T(LSTR("chat.1.10.1.004")))
  end
  chatPanel.targetLayer.target:removeAllChildrenWithCleanup(true)
  chatPanel.targetLayer.target:addChild(head)
end
local function OnPrivateTab()
  selectChannel("personal_channel")
  refreshTargetInfo()
end
class.OnPrivateTab = OnPrivateTab
local function hitWorldHead(index)
  local item = chatPanel.listviewWorld:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end
class.hitWorldHead = hitWorldHead
local function hitUninHead(index)
  local item = chatPanel.listviewUnin:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end
class.hitUninHead = hitUninHead
local function hitPrivateHead(index)
  local item = chatPanel.listviewPrivate:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end
class.hitPrivateHead = hitPrivateHead
local function hitPrivateIndex(index, x, y)
  local item = chatPanel.listviewPrivate:getListData(index)
  if getTargetSummary(item) then
    refreshTargetInfo()
    local oldName = chatPanel.privateHint:getString()
    if targetUid and oldName ~= targetSummary._name then
      chatPanel.privateHint:setString(T(targetSummary._name))
      chatPanel.privateHint:stopAllActions()
      chatPanel.privateHint:setScale(1.1)
      local s = CCScaleTo:create(0.2, 1)
      s = CCEaseBackIn:create(s)
      chatPanel.privateHint:runAction(s)
    end
  end
end
class.hitPrivateIndex = hitPrivateIndex
local function onTargetChat()
  chatPanel.targetLayer:setVisible(false)
  OnPrivateTab()
end
class.onTargetChat = onTargetChat
local function addBlacklist()
  chatPanel.targetLayer:setVisible(false)
  ed.blacklist.setTargetUid(targetUid)
  local msg = ed.upmsg.chat()
  msg._chat_add_bl = {}
  msg._chat_add_bl._uid = targetUid
  print("up targetuid " .. targetUid)
  ed.send(msg, "chat")
  targetUid = nil
end
class.addBlacklist = addBlacklist
local function setTargetSummary(summary, uid)
  targetSummary = summary
  targetUid = uid
end
class.setTargetSummary = setTargetSummary
local function sendLink(content, accessory)
  if nil == content then
    return
  end
  local login = ed.upmsg.login()
  login._active_code = 123323
  login._old_deviceid = "xxxxxxxx"
  login._version = ed.ui.serverlogin.getClientVersion()
  local code = login:Serialize()
  local accessory = {}
  accessory._type = "pure_binary"
  accessory._binary = code
  sendMessage(content, 2, accessory)
end
class.sendLink = sendLink
local function sendPvpLink(content, recordId, channel)
  if nil == recordId then
    return
  end
  local leftFreeTime = ed.player:getChatFreeTime()
  if leftFreeTime == 0 and channel == "world_channel" and worldCost > ed.player._rmb then
    return
  end
  if bFirtPay == true and leftFreeTime == 0 and channel == "world_channel" then
    local info = {
      text = T(LSTR("CHAT.COST__D_DIAMONDS_TO_SPEAK_IN_THE_WORLD_CHANNEL_CONTINUE"), worldCost),
      leftText = T(LSTR("CHATCONFIG.CANCEL")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = function()
        xpcall(function()
          bFirtPay = false
          local accessory = {}
          accessory._type = "pvp_replay"
          accessory._record_id = recordId
          sendMessage(content, 2, accessory, channel)
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
    return
  end
  local accessory = {}
  accessory._type = "pvp_replay"
  accessory._record_id = recordId
  sendMessage(content, 2, accessory, channel)
end
class.sendPvpLink = sendPvpLink
local function closePvp()
  chatPanel.pvpLayer:setVisible(false)
end
class.closePvp = closePvp
local function sendExcavateDefendLink(param)
  local param = param or {}
  local content = param.content
  local eid = param.excavateId
  local callback = param.callback
  local targets = param.targets
  local channel = param.channel or "guild_channel"
  local accessory = {}
  accessory._type = "binary"
  accessory._binary = T("type:excavatedefend,uid:%s,eid:%s,", ed.getUserid(), eid)
  ed.netreply.chatSay = callback
  sendMessage(content, 2, accessory, channel, targets)
end
class.sendExcavateDefendLink = sendExcavateDefendLink
local function chatTurnTouch(event, x, y)
  if chatPanel == nil then
    return
  end
  local result = chatPanel.mainLayer:touch(event, x, y)
  local outside = not ed.containsPoint(chatPanel.mainLayer.chatBg, x, y)
  local turn = chatPanel.mainLayer.chatTurn
  local turnBack = chatPanel.mainLayer.chatTurnBack
  if event == "began" then
    if turn.pressed == true or turnBack.pressed == true then
      dragPressX = x
	end
  elseif event == "moved" then
    if nil == dragPressX then
      return
	end
    if math.abs(x - dragPressX) < 1 and moveState == nil then
      return
    end
    moveState = true
  elseif event == "ended" then
    if dragPressX or outside == true then
      chatTurn()
    end
    dragPressX = nil
    moveState = nil
  end
  return result
end
local function OnChatNotifyRsp(notifyData)
  if nil == notifyData then
    return
  end
  if chatPanel == nil then
    return
  end
  if notifyData > 0 and chatTune == false then
    chatPanel.mainLayer.chatHint:setVisible(true)
  end
end
local function initPanel()
  local size = chatPanel.mainLayer.chatBg:getContentSize()
  local l, r, t, b = ed.getDisplayVertex()
  chatMinX = l - 0.94 * size.width
  chatMaxX = 400

  chatPanel.mainLayer.chatBg:setPosition(ccp(chatMinX, chatYPosition))
  chatPanel.mainLayer.guildEdit:setVisible(false)
  --ListenTimer(Timer:Always(0.01), refreshInputPos)
  chatPanel.mainLayer.privateEdit:setConditionFunc(checkPrivateCondition)

  chatPanel.worldEdit.edit:setVisible(false)
  chatPanel.guildEdit.edit:setVisible(false)
  chatPanel.privateEdit.edit:setVisible(false)
end
local function createChatPanel()
  chatPanel = panelMeta:new2(class, EDTables.chatConfig.UIRes)
  chatPanel.mainLayer.mainLayer:setTouchEnabled(true)

  chatPanel.mainLayer.mainLayer:registerScriptTouchHandler(chatTurnTouch, false, -150, true)
  initPanel()
  chatPanel.mainLayer:setVisible(false)
  return chatPanel
end
function ed.getChatPanel()
  if chatPanel == nil then
    return createChatPanel()
  end
  return chatPanel
end
ListenEvent("ChatRsp", OnChatRsp)
ListenEvent("ChatNotifyData", OnChatNotifyRsp)

local notifyMsgData = {}
local function updateNotifyMsgData(data)
  if nil == data then
    return
  end
  if data._ladder_notify then
    local notify = {}
    notify._is_attacked = data._ladder_notify._is_attacked
    notifyMsgData.PvpNotifyData = notify
    FireEvent("PvpNotifyData", data._ladder_notify)
  elseif data._personal_chat then
    local chatNotify = data._personal_chat
    notifyMsgData.ChatNotifyData = chatNotify
    FireEvent("ChatNotifyData", data._personal_chat)
  elseif data._activity_notify then
    FireEvent("activityNotify", data._activity_notify)
  elseif data._guild_drop then
    notifyMsgData.GuildDropNotifyData = data._guild_drop
    FireEvent("GuildDropNotifyData", data._guild_drop)
  end
end
function ed.queryNotifyData(type)
  if nil == type then
    return
  end
  return notifyMsgData[type]
end
function ed.changeNotifyData(type, key, value)
  if nil == type or nil == value then
    return
  end
  if nil == notifyMsgData[type] then
    return
  end
  if key then
    notifyMsgData[type][key] = value
  else
    notifyMsgData[type] = value
  end
  FireEvent(type, notifyMsgData[type])
end
function ed.getNotifyDataValue(type)
  if type == nil then
    return false
  end
  local data = notifyMsgData[type]
  if nil == data then
    return false
  end
  for k, v in pairs(data) do
    if v > 0 then
      return true
    end
  end
  return false
end
ListenEvent("NotifyMsgRsp", updateNotifyMsgData)

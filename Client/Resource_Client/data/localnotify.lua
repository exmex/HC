local class = {
  mt = {}
}
class.mt.__index = class
ed.localnotify = class
local data = {
  {
    timePoint = "12:00",
    iKey = "am_vit",
    iTag = "day",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.TIME_FOR_LUNCH_SMELLS_GOOD")),
    id = 161,
    ticker = T(LSTR("LOCALNOTIFY.TIME_FOR_LUNCH_SMELLS_DELICIOUS")),
    title = T(LSTR("LOCALNOTIFY.TIME_FOR_LUNCH")),
    text = T(LSTR("LOCALNOTIFY.TIME_FOR_LUNCH_SMELLS_GOOD")),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    timePoint = "18:00",
    iKey = "pm_vit",
    iTag = "day",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.TIME_FOR_SUPPER_SMELLS_GOOD")),
    id = 162,
    ticker = T(LSTR("LOCALNOTIFY.TIME_FOR_SUPPER")),
    title = T(LSTR("LOCALNOTIFY.SUPPER")),
    text = T(LSTR("LOCALNOTIFY.TIME_FOR_SUPPER_SMELLS_DELICIOUS")),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    iKey = "vit_full",
    iTag = "",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.YOUR_HERO_IS_READY_TO_FIGHT")),
    id = 165,
    ticker = T(LSTR("LOCALNOTIFY.HEROES_ENERGY_RECOVERED")),
    title = T(LSTR("LOCALNOTIFY.HERO_ENERGY_RECOVERED")),
    text = T(LSTR("LOCALNOTIFY.YOUR_HERO_IS_READY_TO_FIGHT")),
    tag = "once",
    triggerAtMillis = nil
  },
  {
    timePoint = "9:00",
    iKey = "am_shop",
    iTag = "day",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.SINAS_SHOP_IS_RELOADED_PLEASE_COME_AND_SHOP")),
    id = 163,
    ticker = T(LSTR("LOCALNOTIFY.SINAS_SHOP_IS_RELOADED")),
    title = T(LSTR("LOCALNOTIFY.SINAS_SHOP_IS_RELOADED")),
    text = T(LSTR("LOCALNOTIFY.SINAS_SHOP_IS_RELOADED_PLEASE_COME_AND_SHOP")),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    timePoint = "21:00",
    iKey = "night_vit",
    iTag = "day",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.TIME_FOR_NIGHT_SMELLS_GOOD")),
    id = 164,
    ticker = T(LSTR("LOCALNOTIFY.TIME_FOR_NIGHT")),
    title = T(LSTR("LOCALNOTIFY.NIGHT")),
    text = T(LSTR("LOCALNOTIFY.TIME_FOR_NIGHT_SMELLS_DELICIOUS")),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    iKey = "skill_full",
    iTag = "",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.SKILL_POINTS_ARE_AVAILABLE_CHOOSE_A_HERO")),
    id = 166,
    ticker = T(LSTR("LOCALNOTIFY.SKILL_POINTS_ARE_AVAILABLE")),
    title = T(LSTR("LOCALNOTIFY.SKILL_POINTS_ARE_AVAILABLE")),
    text = T(LSTR("LOCALNOTIFY.SKILL_POINTS_ARE_AVAILABLE_CHOOSE_A_HERO")),
    tag = "once",
    triggerAtMillis = nil
  },
  {
    timePoint = "20:55",
    iKey = "pm_arena",
    iTag = "day",
    iDate = nil,
    iText = T(LSTR("LOCALNOTIFY.ARENA_REWARD_PUSH_TEXT")),
    id = 167,
    ticker = T(LSTR("LOCALNOTIFY.ARENA_REWARD_PUSH_TITLE")),
    title = T(LSTR("LOCALNOTIFY.ARENA_REWARD_PUSH_TITLE")),
    text = T(LSTR("LOCALNOTIFY.ARENA_REWARD_PUSH_TEXT")),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  }
}
local getNotifyDateByTimeString = function(str)
  local date = ed.getTimeByTodayHMS(str)
  local nt = ed.getServerTime()
  if date <= nt then
    return (date - nt + 86400)
  end
  return (date - nt)
end
class.getNotifyDateByTimeString = getNotifyDateByTimeString
local getVitalityFullDate = function()
  local max = ed.playerlimit.maxVitality()
  local current = ed.player:getVitality()
  local lack = math.max(max - current - 1, 0)
  local gap = ed.parameter.sync_vitality_gap
  local vn = ed.player:getVitalityNextUpdate()
  if max <= current then
    return 0
  end
  return gap * lack + vn + ed.getServerTime()
end
class.getVitalityFullDate = getVitalityFullDate
local getSkillFullDate = function()
  local max = ed.player:getMaxSkillChance()
  local current = ed.player:getSkillLvupChance()
  local lack = math.max(max - current - 1, 0)
  local gap = ed.parameter.skill_level_up_chance_cd
  local vn = ed.player:getSkillLvupNextCount()
  if max <= current then
    return 0
  end
  return gap * lack + vn + ed.getServerTime()
end
class.getSkillFullDate = getSkillFullDate
local function getNotifyDate(id)
  if ed.isElementInTable(id, {
    1,
    2,
    4,
    5,
    7
  }) then
    return getNotifyDateByTimeString(data[id].timePoint)
  elseif id == 3 then
    return getVitalityFullDate()
  elseif id == 6 then
    return getSkillFullDate()
  end
end
class.getNotifyDate = getNotifyDate
local function setSwitch(id)
  local data = ed.loadNotificationData()
  local isOn
  for k, v in pairs(data) do
    if v == id then
      table.remove(data, k)
      isOn = true
      break
    end
  end
  if not isOn then
    table.insert(data, id)
  end
  ed.saveNotificationData(data)
  class.refresh()
end
class.setSwitch = setSwitch
local function getSwitch(id)
  local nData, tag = ed.loadNotificationData()
  if not tag or tag == "" then
    for i = 1, #data do
      --if not ed.isElementInTable(i, {4, 6}) then
        setSwitch(i)
      --end
    end
    return true
  end
  return ed.isElementInTable(id, nData)
end
class.getSwitch = getSwitch
local function refreshAndroid()
  local nInfo = {
    data = {}
  }
  for i = 1, #data do
    local nd = data[i]
    local date = getNotifyDate(i)
    nd.iDate = date
    nd.triggerAtMillis = date
    if date > 0 and getSwitch(i) then
      table.insert(nInfo.data, nd)
    end
  end
  --LegendAndroidExtra("setAlarmData", ed.getJson(nInfo))
  
end
class.refreshAndroid = refreshAndroid
local function refreshIOSAndAndroid()
  LegendCancelNotification()
  for i = 1, #data do
    local nd = data[i]
    local date = getNotifyDate(i)
    local key = nd.iKey
    local text = nd.iText
    local tag = nd.iTag
    if date > 0 and getSwitch(i) then	
	  --LegendLog("if -->"..key)
      LegendAddNotification(key, text, tag, date)
    else
	  --LegendLog("else -->"..key)
      --LegendCancelNotification(key)
    end
  end
end
class.refreshIOSAndAndroid = refreshIOSAndAndroid
local function refresh()
  --if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
  --  refreshAndroid()
  --end
  --if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
    refreshIOSAndAndroid()
  --end
end   
class.refresh = refresh
local function init()
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
    --local ids = {
    --  piids = {}
    --}
    --for i = 1, #data do
    --  table.insert(ids.piids, data[i].id)
    --end
    --LegendAndroidExtra("clearAlarm", ed.getJson(ids))
  end
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
  end
  refresh()
end
class.init = init

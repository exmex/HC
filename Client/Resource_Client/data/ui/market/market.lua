local class = ed.Player
local config = ed.ui.marketconfig
local refreshShopData = function(self, data, state)
  local id = data._id
  local hasRefresh
  for k, v in pairs(self._shop or {}) do
    if v._id == id then
      self._shop[k] = data
      hasRefresh = true
    end
  end
  if not hasRefresh then
    self._shop = self._shop or {}
    table.insert(self._shop, data)
  end
  self.lastTriggerShopid = id
  if state == "trigger" then
    self:setTriggerShopTag()
  end
end
class.refreshShopData = refreshShopData
local refreshStarShopData = function(self, data, state)
  self._sshop = data
  self.lastTriggerShopid = "starshop"
  if state == "trigger" then
    self:setTriggerShopTag()
  end
end
class.refreshStarShopData = refreshStarShopData
local setTriggerShopTag = function(self)
  self.hasTriggerSpecialShop = true
end
class.setTriggerShopTag = setTriggerShopTag
local resetTriggerShopTag = function(self)
  self.hasTriggerSpecialShop = nil
end
class.resetTriggerShopTag = resetTriggerShopTag
local hasTriggerShop = function(self)
  local tag = self.hasTriggerSpecialShop
  self.hasTriggerSpecialShop = nil
  return tag
end
class.hasTriggerShop = hasTriggerShop
local getShopData = function(self, id)
  if id == "starshop" then
    return self._sshop
  else
    for k, v in pairs(self._shop or {}) do
      if v._id == id then
        return v
      end
    end
  end
end
class.getShopData = getShopData
local function upsetShopGoods(self, id, goods)
  local gl = {}
  local seed = 0
  local isShowHotTag = config.isShowHotTag(id)
  if isShowHotTag == true then
    for i = 1, #goods do
      gl[i] = {
        good = goods[i],
        tag = "",
        slot = i
      }
      seed = seed + goods[i]._id
    end
  elseif isShowHotTag == false then
    for i = 1, #goods do
      gl[i] = {
        good = goods[i],
        slot = i
      }
      seed = seed + goods[i]._id
    end
  else
    for i = 1, #goods do
      gl[i] = goods[i]
    end
    return gl
  end
  if not ed.isElementInTable(id, {
    4,
    5,
    7
  }) then
    math.randomseed(seed)
    for i = 1, 20 do
      local a = math.random(1, #goods)
      local b = math.random(2, #goods)
      local temp = gl[a]
      gl[a] = gl[b]
      gl[b] = temp
    end
  end
  return gl
end
class.upsetShopGoods = upsetShopGoods
local function getShopGoods(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  if config.getGoodsType(id) == "stone" then
    return self:upsetShopGoods(id, data._star_goods)
  elseif config.getGoodsType(id) == "coin" then
    return self:upsetShopGoods(id, data._current_goods)
  end
end
class.getShopGoods = getShopGoods
local function buyShopGoods(self, id, slot)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local goods
  if config.getGoodsType(id) == "stone" then
    goods = data._star_goods
  elseif config.getGoodsType(id) == "coin" then
    goods = data._current_goods
  end
  goods[slot]._amount = 0
end
class.buyShopGoods = buyShopGoods
local checkShopGoodsEmpty = function(self, id)
  local goods = self:getShopGoods(id)
  for k, v in pairs(goods) do
    if v._amount > 0 then
      return false
    end
  end
  return true
end
class.checkShopGoodsEmpty = checkShopGoodsEmpty
local getShopCountDown = function(self, id)
  local nextTime, nextPoint = self:getShopNextAutoRefreshPoint(id)
  if not nextTime then
    return
  end
  local nt = ed.getServerTime()
  return nextPoint - nt
end
class.getShopCountDown = getShopCountDown
local getShopNextAutoRefreshPoint = function(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local rt = data._last_auto_refresh_time
  if rt == 0 then
    return nil
  end
  local mts = ed.getDataTable("Shop")[id]["Refresh Times"]
  local nt = ed.getServerTime()
  local minTime, minPoint
  for i = 1, #mts do
    local te = ed.getTimeByTodayHMS(mts[i])
    minPoint = minPoint or te
    minTime = minTime or mts[i]
    if nt >= te then
      if rt < te then
        return mts[i], te, "today"
      end
    else
      return mts[i], te, "today"
    end
    if te < minPoint then
      minPoint = te
      minTime = mts[i]
    end
  end
  return minTime, minPoint + 86400, "tomorrow"
end
class.getShopNextAutoRefreshPoint = getShopNextAutoRefreshPoint
local getShopNextAutoRefreshPointDesc = function(self, id)
  local time, point, ps = self:getShopNextAutoRefreshPoint(id)
  local desc = ""
  local h, m, s = ed.hmsNString2HMS(time)
  local pre = ""
  if ps == "tomorrow" then
    pre = T(LSTR("PLAYERTOOLS.TOMORROW"))
  elseif ps == "today" then
    pre = T(LSTR("PLAYERTOOLS.TODAY"))
  end
  desc = desc .. pre .."  ".. h .. T(":")
  if m > 9 then 
    desc = desc .. m
  elseif m>0 and m<10 then
    desc = desc .."0".. m
  elseif m <=0 then
    desc = desc .."00"
  end
  return desc
end
class.getShopNextAutoRefreshPointDesc = getShopNextAutoRefreshPointDesc
local getShopExpireTime = function(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local et = data._expire_time
  if et == 0 then
    return nil
  end
  local nt = ed.getServerTime()
  return et - nt
end
class.getShopExpireTime = getShopExpireTime
local getShopShowTime = function(self, id)
  local et = self:getShopExpireTime(id)
  if et then
    return et
  end
  local rt = self:getShopCountDown(id)
  return rt
end
class.getShopShowTime = getShopShowTime
local checkShopTimeType = function(self, id)
  local et = self:getShopExpireTime(id)
  if et then
    return "expire"
  end
  local rt = self:getShopCountDown(id)
  if rt then
    return "refresh"
  end
  return "unknown"
end
class.checkShopTimeType = checkShopTimeType
local checkShopValid = function(self, id)
  if not self:getShopData(id) then
    return false
  end
  local state = self:checkShopTimeType(id)
  if state == "refresh" then
    return true
  elseif state == "expire" then
    if self:getShopExpireTime(id) < 0 then
      return false
    else
      return true
    end
  end
  return false
end
class.checkShopValid = checkShopValid
local getRefreshShopTimes = function(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local lt = data._last_manual_refresh_time
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    return 0
  else
    return data._today_times
  end
end
class.getRefreshShopTimes = getRefreshShopTimes
local getShopRefreshCost = function(self, id)
  local t = self:getRefreshShopTimes(id) + 1
  local gpt = ed.getDataTable("GradientPrice")
  local row = gpt[t]
  while not row do
    t = t - 1
    row = gpt[t]
  end
  return row[string.format("Shop %d Refresh", id)]
end
class.getShopRefreshCost = getShopRefreshCost
local getLastTriggerShopid = function(self)
  return self.lastTriggerShopid
end
class.getLastTriggerShopid = getLastTriggerShopid
local class = newclass("g")
ed.ui.market = class
setfenv(1, class)
preTalkKey = nil
preTalkID = nil
function getTalkContent(id, key)
  ed.initSeed()
  local bi, ei = 1, 6
  if ed.isElementInTable(id, {2, 3}) and ed.player:checkShopTimeType(id) == "refresh" then
    bi, ei = 7, 12
  end
  if id == "starshop" then
    id = 6
  end
  local talkInfo = ed.getDataTable("MerchantTalk")
  if not talkInfo[id] then
    return
  end
  local talks = {}
  for i = bi, ei do
    local str = talkInfo[id][key]["Talk " .. i]
    if str ~= nil then
      table.insert(talks, str)
    end
  end
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID and LegendSDKType == 104 then
    table.insert(talks, T(LSTR("SHOP.TRANSACTION_SECURED_GUARANTEED")))
  end
  local talk
  if #talks > 0 then
    math.random(#talks)
    local id = math.random(#talks)
    if key == preTalkKey and id == preTalkID and #talks > 1 then
      if id == #talks and #talks > 1 then
        id = id - 1
      else
        id = id + 1
      end
    end
    talk = talks[id]
    preTalkKey = key
    preTalkID = id
  end
  return talk
end

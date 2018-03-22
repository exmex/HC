local ed = ed
local class = {
  mt = {}
}
ed.playertools = class
class.mt.__index = class
local getPoint = function(self, name)
  for k, v in pairs(self._points) do
    if v._type == name then
      return v._value
    end
  end
  return 0
end
class.getPoint = getPoint
local function addPoint(self, name, amount)
  amount = amount or 0
  local coin_type = {
    "gold",
    "diamond",
    "crusadepoint",
    "arenapoint",
    "guildpoint"
  }
  if not ed.isElementInTable(name, coin_type) then
    print("Invalid coin type : " .. (name or "nil"))
  end
  if name == "gold" then
    self:addMoney(amount)
  elseif name == "diamond" then
    self:addrmb(amount)
  else
    for k, v in pairs(self._points) do
      if v._type == name then
        v._value = v._value + amount
      end
    end
  end
end
class.addPoint = addPoint
local getCrusadeMoney = function(self)
  return self:getPoint("crusadepoint")
end
class.getCrusadeMoney = getCrusadeMoney
local getPvpMoney = function(self)
  return self:getPoint("arenapoint")
end
class.getPvpMoney = getPvpMoney
local getGuildMoney = function(self)
  return self:getPoint("guildpoint")
end
class.getGuildMoney = getGuildMoney
local function resetDailyjobTime(self, id)
  self._dailyjob = self._dailyjob or {}
  for k, v in pairs(self._dailyjob) do
    if v._id == id then
      self._dailyjob[k]._last_rewards_time = ed.getServerTime()
      self._dailyjob[k]._task_target = 0
    end
  end
end
class.resetDailyjobTime = resetDailyjobTime
local dailyjob_login_time
local function odRefreshDailyjob(self)
  dailyjob_login_time = dailyjob_login_time or self._last_login
  local tdt = ed.getDataTable("Todolist")
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(dailyjob_login_time, nt) then
    dailyjob_login_time = nt
    for k, v in pairs(self._dailyjob or {}) do
      local id = v._id
      local row = tdt[id]
      if row then
        local ttp = row["Task Progress Type"]
        local ttt = row["Task Target"]
        if ttp == "Login" then
          self._dailyjob[k]._task_target = ttt
        else
          self._dailyjob[k]._task_target = 0
        end
      end
    end
  end
end
class.odRefreshDailyjob = odRefreshDailyjob
local function getDailyjobCount(self, id)
  self:odRefreshDailyjob()
  local key
  for k, v in pairs(self._dailyjob or {}) do
    if v._id == id then
      local row = ed.getDataTable("Todolist")[id]
      if row then
        local tp = row["Task Progress Type"]
        local ttt = row["Task Target"]
        local nt = ed.getServerTime()
        if tp == "Login" then
          if ed.checkTwoDateod(v._last_rewards_time, nt) then
            if ed.checkDailyjobTrigger(id) then
              self._dailyjob[k]._task_target = ttt
            else
              self._dailyjob[k]._task_target = 0
            end
          end
        elseif tp == "MonthlyCardPeriod" then
          if ed.checkTwoDateod(v._last_rewards_time, nt) then
            if self:isMonthCardValid(row["Task Progress ID"]) then
              self._dailyjob[k]._task_target = ttt
            end
          else
            return 0
          end
        end
      end
      return v._task_target or 0
    end
  end
  return 0
end
class.getDailyjobCount = getDailyjobCount
local function checkDailyjobCount(self)
  self:odRefreshDailyjob()
  for k, v in pairs(self._dailyjob or {}) do
    local id = v._id
    local row = ed.getDataTable("Todolist")[id]
    if row then
      local ttt = row["Task Target"]
      local lrt
      local nt = ed.getServerTime()
      if ed.checkTwoDateod(v._last_rewards_time, nt) then
        lrt = true
      end
      if ttt <= self:getDailyjobCount(id) and ed.checkDailyjobTrigger(id) and lrt then
        return true
      end
    end
  end
  return false
end
class.checkDailyjobCount = checkDailyjobCount
local function increaseDailyjobCount(self, config)
  self:odRefreshDailyjob()
  local tp = config.type
  local add = config.add or 1
  local pid = config.pid
  local tdt = ed.getDataTable("Todolist")
  local check = ed.checkDailyjobTrigger
  for k, v in pairs(self._dailyjob or {}) do
    if check(v._id) then
      local row = tdt[v._id]
      local ttp = row["Task Progress Type"]
      local progressid = row["Task Progress ID"]
      local target = row["Task Target"]
      if ttp == tp then
        if (pid or progressid) == progressid then
          local count = self._dailyjob[k]._task_target
          count = count + add
          self._dailyjob[k]._task_target = math.min(count, target)
        end
      end
    end
  end
  local lsr = ed.ui.baselsr.create("base")
  lsr:report("increaseDailyjobCount")
end
class.increaseDailyjobCount = increaseDailyjobCount
local getDailyjobData = function(self, id)
  for k, v in pairs(self._dailyjob) do
    if v._id == id then
      return v
    end
  end
  return nil
end
class.getDailyjobData = getDailyjobData
local getMonthCardData = function(self, id)
  for k, v in pairs(self._month_card or {}) do
    if v._id == id then
      return v
    end
  end
end
class.getMonthCardData = getMonthCardData
local function isMonthCardValid(self, id)
  local data = self:getMonthCardData(id)
  if not data then
    return false
  end
  local nt = ed.getServerTime()
  local mct = data._expire_time
  if nt < mct then
    return true
  end
  return false
end
class.isMonthCardValid = isMonthCardValid
local function getMonthCardDailyjobData(self, id)
  for k, v in pairs(ed.getDataTable("Todolist")) do
    if v["Task Progress Type"] == "MonthlyCardPeriod" and v["Task Progress ID"] == id then
      return self:getDailyjobData(k), k
    end
  end
end
class.getMonthCardDailyjobData = getMonthCardDailyjobData
local function getMonthCardLeftTimes(self, id)
  if not self:isMonthCardValid(id) then
    return 0
  end
  local data = self:getMonthCardDailyjobData(id)
  local lt = data._last_rewards_time
  if lt == 0 then
    lt = ed.getServerTime() - 86400
    data._last_rewards_time = lt
  end
  local et = self:getMonthCardData(id)._expire_time
  local leftTimes = math.floor((et - lt) / 86400)
  return leftTimes
end
class.getMonthCardLeftTimes = getMonthCardLeftTimes
local canMonthCardRenew = function(self, id)
  local leftTimes = self:getMonthCardLeftTimes(id)
  if not self:isMonthCardValid(id) then
    return true
  end
  if leftTimes > 3 then
    return false
  end
  return true
end
class.canMonthCardRenew = canMonthCardRenew
local refreshMonthCardData = function(self, data)
  self._month_card = self._month_card or {}
  for k, v in pairs(self._month_card) do
    if v._id == data._id then
      self._month_card[k] = data
      self:refreshMonthCardDailyjob(v._id)
      return
    end
  end
  table.insert(self._month_card, data)
  self:refreshMonthCardDailyjob(data._id)
end
class.refreshMonthCardData = refreshMonthCardData
local function refreshMonthCardDailyjob(self, id)
  local djdata, djid = self:getMonthCardDailyjobData(id)
  if djdata then
    return true
  end
  self._dailyjob = self._dailyjob or {}
  local dj = ed.downmsg.dailyjob()
  dj._id = djid
  dj._last_rewards_time = 0
  table.insert(self._dailyjob, dj)
end
class.refreshMonthCardDailyjob = refreshMonthCardDailyjob
local function releaseHeroes(self, heroes)
  for i, v in ipairs(heroes or {}) do
    ed.player.heroes[v]._state = "idle"
  end
end
class.releaseHeroes = releaseHeroes
local function sendHeroesMining(self, heroes)
  for i, v in ipairs(heroes or {}) do
    ed.player.heroes[v]._state = "mining"
  end
end
class.sendHeroesMining = sendHeroesMining
local function setExcavateHistoryAmount(self, amount)
  self.excavateHistoryAmount = amount
  ed.ui.baselsr.create():excavateBeAttacked()
end
class.setExcavateHistoryAmount = setExcavateHistoryAmount
local function readExcavateHistory(self)
  self.excavateHistoryAmount = nil
  ed.ui.baselsr.create():excavateBeAttacked()
end
class.readExcavateHistory = readExcavateHistory
local function setExcavateHistoryRewardTag(self, key)
  if not key then
    return
  end
  self.excavateHistoryTag = self.excavateHistoryTag or {}
  self.excavateHistoryTag[key] = true
  ed.ui.baselsr.create():excavateBeAttacked()
end
class.setExcavateHistoryRewardTag = setExcavateHistoryRewardTag
local function removeExcavateHistoryRewardTag(self, key)
  if not key then
    return
  end
  self.excavateHistoryTag = self.excavateHistoryTag or {}
  self.excavateHistoryTag[key] = nil
  ed.ui.baselsr.create():excavateBeAttacked()
end
class.removeExcavateHistoryRewardTag = removeExcavateHistoryRewardTag
local checkUnreadExcavateHistory = function(self)
  if 0 < (self.excavateHistoryAmount or 0) then
    return true
  end
  for k, v in pairs(self.excavateHistoryTag or {}) do
    if v == true then
      return true
    end
  end
  return false
end
class.checkUnreadExcavateHistory = checkUnreadExcavateHistory
local setSplitableHeroesTag = function(self, tag)
  if tag then
    self.hasSplitableHero = true
  end
end
class.setSplitableHeroesTag = setSplitableHeroesTag
local resetSplitableHeroesTag = function(self)
  self.hasSplitableHero = nil
end
class.resetSplitableHeroesTag = resetSplitableHeroesTag
local function getHeroAmount(self)
  local amount = 0
  for k, v in pairs(ed.player.heroes) do
    amount = amount + 1
  end
  return amount
end
class.getHeroAmount = getHeroAmount

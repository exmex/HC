local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.Record = class
local function create()
  local self = {}
  setmetatable(self, class.mt)
  self.keys = {
    "killMonster",
    "farmStage",
    "farmChapter",
    "farmpveStage",
    "farmElitepveStage",
    "pvpBattle",
    "pvpWin",
    "skillUpgradeSuccess",
    "enhanceLevelup",
    "midasUse",
    "tavernGroupUse",
    "completeCrusadeStage",
    "sendMercenary",
    "enterRaid"
  }
  self.login = {}
  self.today = {}
  return self
end
class.create = create
ed.record = create()
local function todayReset(self)
  if ed.checkTwoDateod() then
    for k, v in pairs(self.today) do
      self.today[k] = nil
    end
    self.lastResetTime = ed.getServerTime()
  end
end
class.todayReset = todayReset
local function refresh(self, ...)
  self:todayReset()
  local l = self.login
  local t = self.today
  local key = select(2, ...)
  if not ed.isElementInTable(key, self.keys) then
    print("invalid key of record:", key)
  end
  local value = select(1, ...)
  local amount = select("#", ...)
  for i = 2, amount - 1 do
    local key = select(i, ...)
    l[key] = l[key] or {}
    t[key] = t[key] or {}
    l = l[key] or {}
    t = t[key] or {}
  end
  local key = select(amount, ...)
  l[key] = (l[key] or 0) + value
  t[key] = (t[key] or 0) + value
end
class.refresh = refresh
local increase = function(self, ...)
  local a = select(1, ...)
  if type(a) == "number" then
    self:refresh(...)
  else
    self:refresh(1, ...)
  end
end
class.increase = increase
local function get(self, ...)
  local r = self.login
  local b = 1
  local k = select(1, ...)
  if ed.isElementInTable(k, {"login", "today"}) then
    if k == "today" then
      self:todayReset()
    end
    r = self[k]
    b = 2
  end
  local amount = select("#", ...)
  for i = b, amount - 1 do
    local key = select(i, ...)
    r = r[key] or {}
  end
  local key = select(amount, ...)
  return r[key] or 0
end
class.get = get
local function reset(self, ...)
  local isResetLogin, isResetToday
  local l = self.login
  local t = self.today
  local k = select(1, ...)
  if ed.isElementInTable(k, {"login", "today"}) then
    if k == "today" then
      isResetToday = true
    elseif k == "login" then
      isResetLogin = true
    else
      isResetToday = true
      isResetLogin = true
    end
  end
  local amount = select("#", ...)
  for i = 1, amount - 1 do
    local key = select(i, ...)
    l = l[key] or {}
    t = t[key] or {}
  end
  local key = select(amount, ...)
  if isResetLogin then
    l[key] = 0
  end
  if isResetToday then
    t[key] = 0
  end
end
class.reset = reset
local function refreshKillMonster(self, id)
  if not self.killMonster then
    self.killMonster = {}
  end
  local battleTable = ed.getDataTable("Battle")
  local battle = battleTable[id]
  for k, v in pairs(battle) do
    for i = 1, 5 do
      local mid = v[string.format("Monster %d ID", i)]
      if 0 < (mid or 0) then
        self:increase("killMonster", mid)
        ed.player:increaseTaskCount({
          type = "KillMonster",
          id = mid,
          add = 1
        })
      end
    end
  end
end
class.refreshKillMonster = refreshKillMonster
local function successFarmStage(self, id, times)
  times = times or 1
  local st = ed.getDataTable("Stage")
  local row = st[id]
  local chapter = row["Chapter ID"]
  ed.record:refreshKillMonster(id)
  self:increase(times, "farmStage", id)
  ed.player:increaseTaskCount({
    type = "FarmStage",
    id = id,
    add = times
  })
  self:increase(times, "farmChapter", chapter)
  ed.player:increaseDailyjobCount({
    type = "FarmChapter",
    add = times,
    pid = chapter
  })
  local st = ed.stageType(id)
  if st == "normal" then
    self:increase(times, "farmpveStage")
    ed.player:increaseDailyjobCount({
      type = "FarmPVEStage",
      add = times
    })
  elseif st == "elite" then
    self:increase(times, "farmpveStage")
    ed.player:increaseDailyjobCount({
      type = "FarmPVEStage",
      add = times
    })
    self:increase(times, "farmElitepveStage")
    ed.player:increaseDailyjobCount({
      type = "FarmElitePVEStage",
      add = times
    })
  elseif st == "pvp" then
    self:increase(times, "pvpWin")
    ed.player:increaseDailyjobCount({type = "PVPWin", add = times})
  end
end
class.successFarmStage = successFarmStage
local function chaosFarmStage(self, id, times)
  times = times or 1
  local st = ed.stageType(id)
  if st == "pvp" then
    ed.record:increase(times, "pvpBattle")
    ed.player:increaseDailyjobCount({type = "PVPBattle", add = times})
  end
end
class.chaosFarmStage = chaosFarmStage
local function refreshCommonRecord(self, type, times)
  times = times or 1
  self:increase(times, type)
  if type == "enhanceLevelup" then
    ed.player:increaseDailyjobCount({
      type = "EnhanceLevelUp",
      add = times
    })
  elseif type == "skillUpgradeSuccess" then
    ed.player:increaseDailyjobCount({
      type = "SkillUpgradeSuccess",
      add = times
    })
  elseif type == "tavernGroupUse" then
    ed.player:increaseDailyjobCount({
      type = "TavernGroupUse",
      add = times
    })
  elseif type == "midasUse" then
    ed.player:increaseDailyjobCount({type = "MidasUse", add = times})
  elseif type == "completeCrusadeStage" then
    ed.player:increaseDailyjobCount({
      type = "CompleteCrusadeStage",
      add = times
    })
  elseif type == "sendMercenary" then
    ed.player:increaseDailyjobCount({
      type = "SendMercenary",
      add = times
    })
  elseif type == "enterRaid" then
    ed.player:increaseDailyjobCount({type = "EnterRaid", add = times})
  end
end
class.refreshCommonRecord = refreshCommonRecord

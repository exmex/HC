local class = ed.Player
function class:refreshExcavateSearchTime()
  self.excavateSearchTimes = self.excavateSearchTimes + 1
  self.excavateLastSearchTime = ed.getServerTime()
end
function class:getExcavateSearchTimes()
  local times = self.excavateSearchTimes or 0
  local lastTime = self.excavateLastSearchTime or ed.getServerTime()
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lastTime, nt) then
    times = 0
    lastTime = nt
  end
  self.excavateSearchTimes = times
  self.excavateLastSearchTime = lastTime
  return times
end
function class:getExcavateSearchCost()
  local gt = ed.getDataTable("GradientPrice")
  local times = self:getExcavateSearchTimes()
  local function getMaxCost(index)
    local c = gt[index]["Excavate Search"] or 0
    if c > 0 then
      return getMaxCost(index + 1)
    else
      return gt[index - 1]["Excavate Search"]
    end
  end
  local maxCost = getMaxCost(1)
  local cost = gt[times + 1]["Excavate Search"]
  return cost <= 0 and maxCost or cost
end
-- local class = newclass("g")
local class = newclass()
ed.ui.excavate = class
class.table = table
class.print = print
class.pairs = pairs
class.ipairs = ipairs
class.tonumber = tonumber
class.T = T
class.ed = ed
class.math = math
setfenv(1, class)
local currentTeamid, currentExcavateid
max_search_time = nil
battleReward = nil
battleTeam = {}
extra_data = {}
last_occupy_excavate = nil
speed_time_unit = 60
function getBattleReward()
  local br = battleReward
  battleReward = nil
  return br
end
function setCurrentBattleid(excavateid, teamid)
  currentExcavateid = excavateid
  currentTeamid = teamid
end
function refreshExcavateBatHeroes(heroes, mercenary)
  local list = {}
  for i, v in ipairs(heroes) do
    if mercenary[i] == true then
      ed.mercenary.getExcavateMercenary():setExcavate(v)
    else
      table.insert(list, v._heroid)
      ed.player:setHeroExcavateData(v)
    end
  end
  battleTeam = list
end
function refreshTeamHeroData(heroes)
  if not heroes then
    print("-->>Why not data of heroes after battle?")
  end
  if not currentExcavateid or not currentTeamid then
    return
  end
  local teamData = getTeamData({excavateId = currentExcavateid, teamId = currentTeamid})
  local base = teamData._hero_bases
  local dyna = teamData._hero_dynas
  for i, v in ipairs(heroes) do
    dyna[i]._hp_perc = v._hp_perc
    dyna[i]._mp_perc = v._mp_perc
    dyna[i]._custom_data = v._custom_data
  end
end
function initData(data)
  class.attackTimeout = nil
  class.hireData = nil
  local data = data or {}
  local times = data._search_times
  local ts = data._last_search_ts
  local sid = data._searched_id
  local aid = data._attacking_id
  local heroes = data._bat_heroes
  local cfg = data._cfg
  local hire = data._hire
  ed.mercenary.setExcavateMercenary(hire)
  refreshHeroData(heroes)
  data = data._excavate or ed.player.excavate_data
  local excavateData = {}
  ed.player.excavate_data = excavateData
  if data then
    for k, v in pairs(data) do
      refreshData(v, "init", "invert")
    end
  end
  ed.player.excavateSearchTimes = times
  ed.player.excavateLastSearchTime = ts
  ed.player.excavateSearchId = sid
  ed.player.excavateAttackId = aid
  class.attackTimeout = cfg._attack_timeout
  class.hireData = hire
end
function refreshData(exData, from, mode)
  local data = getData()
  local state = exData._state
  local stateEndTime = exData._state_end_ts
  if exData._owner == "mine" and ed.isElementInTable(exData._state, {"battle", "prepare"}) then
    exData._state = "occupy"
  end
  if ed.isElementInTable(exData._owner, {"others", "monster"}) and ed.isElementInTable(exData._state, {"prepare"}) then
    exData._state = "revengeProtect"
  end
  local isUpdate
  for i, v in ipairs(data) do
    if v._id == exData._id then
      data[i] = exData
      isUpdate = true
    end
  end
  if not isUpdate then
    if mode == "invert" then
      table.insert(data, 1, exData)
    else
      table.insert(data, exData)
    end
  end
  extra_data[exData._id] = {
    timePoint = state == "prepare" and stateEndTime or ed.getServerTime(),
    produceSpeed = getTeamProduceSpeed(exData._id),
    resGot = 0
  }
  if from == "battle" and exData._owner == "mine" then
    ed.player:sendHeroesMining(battleTeam)
    last_occupy_excavate = exData._id
  end
end
function initHeroData()
  ed.player:clearAllExcavateData()
  ed.player:initAllExcavateData()
end
function refreshHeroData(heroes)
  initHeroData()
  if not heroes then
    return
  end
  for i, v in ipairs(heroes or {}) do
    local tid = v._hero_id
    local dyna = v._dyna
    ed.player.heroes[tid]:setExcavate(dyna)
  end
end
function checkSearching()
  if ed.player.excavateSearchId then
    local data = getData(ed.player.excavateSearchId)
    if data and data._owner ~= "mine" then
      return true
    end
  end
  return false
end
function getFightingID()
  local data = getData()
  for i, v in ipairs(data) do
    local element = data[i]
    if ed.isElementInTable(element._owner, {"others", "monster"}) then
      return i
    end
  end
  return 1
end
function getSearchedID()
  local data = getData()
  for i, v in ipairs(data) do
    local element = data[i]
    if element._id == ed.player.excavateSearchId then
      return i
    end
  end
  return 1
end
function occupyExcavate(data)
  if ed.player.excavateSearchId == data._id then
    ed.player.excavateSearchId = nil
  end
  if ed.player.excavateAttackId == data._id then
    ed.player.excavateAttackId = nil
  end
  refreshData(data, "battle")
  removeAttackData()
end
function removeExcavate(id)
  local tData = getTeamData({
    excavateId = id,
    teamId = ed.getUserid()
  })
  if tData then
    local idList = {}
    local bases = tData._hero_bases
    for i, v in ipairs(bases) do
      local tid = v._tid
      table.insert(idList, tid)
    end
    ed.player:releaseHeroes(idList)
  end
  for k, v in ipairs(ed.player.excavate_data) do
    if v._id == id then
      table.remove(ed.player.excavate_data, k)
      break
    end
  end
end
function removeSearchData()
  for k, v in ipairs(ed.player.excavate_data) do
    if ed.player.excavateSearchId == ed.player.excavateAttackId then
      ed.player:clearAllExcavateData()
      ed.player:initAllExcavateData()
    end
    if v._id == ed.player.excavateSearchId then
      table.remove(ed.player.excavate_data, k)
      break
    end
  end
end
function checkAttacking(excavateId)
  if not ed.player.excavateAttackId or excavateId == ed.player.excavateAttackId or not getData(ed.player.excavateAttackId) then
    return true
  end
  return false
end
function removeAttackData()
  for k, v in ipairs(ed.player.excavate_data) do
    if v._id == ed.player.excavateAttackId then
      table.remove(ed.player.excavate_data, k)
      ed.player:clearAllExcavateData()
      ed.player:initAllExcavateData()
      break
    end
  end
end
function doQueryExcavateDataReply(param)
  local function handler(data)
    initData(data)
    param = param or {}
    local et = param.from
    local ii = param.initId
    if et == "chatLink" then
      local d, index = getData(ii)
      if d then
        entry({from = et, initId = ii})
      else
        ed.showToast(LSTR("EXCAVATE.INVITATION_INFORMATION_IS_INVALID_"))
      end
    else
      entry()
    end
  end
  return handler
end
function initialize(param)
  ed.player.excavate_data = {}
  ed.player.excavateSearchTimes = nil
  ed.player.excavateLastSearchTime = nil
  ed.netreply.queryExcavateData = doQueryExcavateDataReply(param)
  local msg = ed.upmsg.excavate()
  msg._query_excavate_data = ed.upmsg.query_excavate_data()
  ed.send(msg, "excavate")
  --test
  entry({from = et, initId = ii})
end
function entry(param)
  if #ed.player.excavate_data > 0 then
    ed.pushScene(ed.ui.excavatemap.create(param))
  else
    ed.pushScene(ed.ui.excavatesearch.create(param))
  end
end
function doSearchExcavateReply(callback, failedCallback)
  local function handler(result, data)
    if result == "failed" then
      ed.showToast(T(LSTR("EXCAVATE.THIS_STUDY_DID_NOT_FIND_THE_TREASURE_PLEASE_TRY_AGAIN_LATER_THIS_EXPLORATION_NOT_CHARGED_")), {constant = 2})
      if failedCallback then
        failedCallback()
      end
      return
    elseif result == "lack_money" then
      ed.showToast(T(LSTR("ERRORINFO.INSUFFICIENT_COINS")))
      if failedCallback then
        failedCallback()
      end
      return
    end
    local cost = ed.player:getExcavateSearchCost()
    ed.player:addMoney(-cost)
    ed.player:refreshExcavateSearchTime()
    if data then
      removeSearchData()
      initHeroData()
      ed.player.excavateSearchId = data._id
      refreshData(data)
    end
    if callback then
      callback({
        searchOwner = data._owner,
        searchTypeid = data._type_id
      })
    end
  end
  return handler
end
function search(callback, failedCallback)
  ed.netreply.searchExcavate = doSearchExcavateReply(callback, failedCallback)
  local msg = ed.upmsg.excavate()
  msg._search_excavate = ed.upmsg.search_excavate()
  ed.send(msg, "excavate")
end
function setMonsterTeam(excavateId, teamId, data)
  local team = getTeamData({excavateId = excavateId, teamId = teamId})
  team._hero_bases = data._hero_bases
  team._hero_dynas = data._hero_dynas
end
function getTeamData(param)
  param = param or {}
  local excavateId = param.excavateId
  local teamId = param.teamId
  local data = getData()
  for i = 1, #data do
    local excavate = data[i]
    if excavate._id == excavateId then
      local teams = excavate._team or {}
      for j = 1, #teams do
        local team = teams[j]
        if team._team_id == teamId then
          return team
        end
      end
    end
  end
  return
end
function addTeamData(param)
  param = param or {}
  local excavateId = param.excavateId
  local data = param.data
  local edata = getData(excavateId)
  edata._team = edata._team or {}
  table.insert(edata._team, data)
end
function getStageEnemyData(param)
  param = param or {}
  local id = param.id
  local dynas = param.dynas
  local heroes = {}
  local stage = ed.getDataTable("Stage")
  local battle = ed.getDataTable("Battle")
  local srow = stage[id]
  local brow = battle[id][1]
  local level = srow["Monster Level"]
  local rank = ed.heroLevel2Rank(level)
  local function getHeroByIndex(index)
    if not brow["Monster " .. index .. " ID"] then
      return
    end
    local hero = {}
    if dynas[index] then
      hero.dyna = dynas[index]
    else
      local dyna = ed.downmsg.hero_dyna()
      dyna._hp_perc = 10000
      dyna._mp_perc = brow["MP " .. index]
      hero.dyna = dyna
    end
    local base = ed.downmsg.hero()
    base._tid = brow["Monster " .. index .. " ID"]
    base._rank = rank
    base._level = level
    base._stars = brow["Stars " .. index]
    base._exp = 0
    base._gs = 0
    base._skill_levels = {}
    base._items = {}
    hero.base = base
    table.insert(heroes, hero)
    getHeroByIndex(index + 1)
  end
  getHeroByIndex(1)
  return heroes
end
function getData(excavateId)
  if not excavateId then
    ed.player.excavate_data = ed.player.excavate_data or {}
    return ed.player.excavate_data
  end
  local data = getData()
  for i = 1, #data do
    local excavate = data[i]
    if excavate._id == excavateId then
      return excavate, i
    end
  end
  return nil
end
function checkMine(excavateId)
  excavateId = tonumber(excavateId)
  local data = getData(excavateId)
  if not data then
    return false
  end
  if data._owner == "mine" then
    return true
  end
  return false
end
function getTagType(excavateId)
  local data = getData(excavateId)
  if not data then
    return nil
  end
  if data._owner == "mine" then
    return "mine"
  elseif ed.player.excavateAttackId == excavateId then
    return "attack"
  elseif ed.player.excavateSearchId == excavateId then
    return "search"
  else
    return "revenge"
  end
end
function getRow(excavateId)
  local data = getData(excavateId)
  if not data then
    return
  end
  local et = ed.getDataTable("ExcavateTreasure") or {}
  return et[data._type_id]
end
function updateTeamData(excavateId, teamId)
  if teamId ~= ed.getUserid() then
    return
  end
  local extraData = extra_data[excavateId]
  local rg = extraData.resGot or 0
  local dt = ed.getServerTime() - (extraData.timePoint or ed.getServerTime())
  local rg = (getTeamProduceSpeed(excavateId, teamId) or 0) * dt / speed_time_unit + rg
  rg = math.max(rg, 0)
  extraData.resGot = rg
  extraData.timePoint = math.max(ed.getServerTime(), extraData.timePoint)
end
function getProduced(excavateId, teamId)
  local data = getData(excavateId)
  local extraData = extra_data[excavateId] or {}
  if not data then
    return
  end
  local tp = extraData.timePoint or ed.getServerTime()
  local rgFix = extraData.resGot or 0
  local dt = ed.getServerTime() - tp
  dt = math.max(dt, 0)
  local amount = 0
  local teams = data._team
  for i, v in pairs(teams or {}) do
    if teamId and v._team_id == teamId then
      local rgAmount = (v._res_got or 0) + getProduceSpeed(excavateId, teamId) * dt / speed_time_unit + rgFix
      rgAmount = math.max(rgAmount, 0)
      return rgAmount
    end
    local rg = v._res_got or 0
    amount = amount + rg
  end
  if teamId then
    return 0
  end
  local rgAmount = amount + getProduceSpeed(excavateId) * dt / speed_time_unit + rgFix
  rgAmount = math.max(rgAmount, 0)
  return rgAmount
end
function getStorage(excavateId)
  local data = getData(excavateId)
  local pAmount = getProduced(excavateId)
  local row = getRow(excavateId)
  local storage = data._storage
  storage = storage - pAmount
  storage = math.max(storage, 0)
  return storage
end
function getTeamProduceSpeed(excavateId, teamId)
  if teamId then
    return extra_data[excavateId].produceSpeed[teamId]
  end
  local data = getData(excavateId)
  local team = data._team
  local row = getRow(excavateId)
  local us = data._produce_speed / 10000
  local teampn = {}
  if data._owner == "monster" then
    local battle = ed.getDataTable("Battle")
    for i, v in pairs(team) do
      local brow = battle[v._team_id][1]
      local ma = 0
      for index = 1, 5 do
        if not brow["Monster " .. index .. " ID"] then
          break
        else
          ma = index
        end
      end
      teampn[v._team_id] = ma
    end
  else
    for i, v in pairs(team or {}) do
      teampn[v._team_id] = #(v._hero_bases or {})
    end
  end
  local teamSpeed = {}
  for k, v in pairs(teampn) do
    teamSpeed[k] = us * v
  end
  return teamSpeed
end
function getProduceSpeed(excavateId, teamId)
  local extraData = extra_data[excavateId] or {}
  extraData.produceSpeed = getTeamProduceSpeed(excavateId)
  local s = 0
  for k, v in pairs(extraData.produceSpeed) do
    if teamId and k == teamId then
      return v
    end
    s = s + v
  end
  if teamId then
    return 0
  end
  return s
end
function doClearExcavateBattle()
  local msg = ed.upmsg.excavate()
  local ceb = ed.upmsg.clear_excavate_battle()
  msg._clear_excavate_battle = ceb
  ed.send(msg, "excavate")
end
function getMineExcavateMaxAmount()
  local amount = 0
  local function getAmount(index)
    local am = getMineExcavateLimit(index)
    if not am then
    else
      amount = math.max(amount, am)
      getAmount(index + 1)
    end
  end
  getAmount(0)
  return amount
end
function getMineExcavateLimit(vip)
  vip = vip or ed.player:getvip()
  local row = ed.getDataTable("VIP")[vip] or {}
  return row["Excavate Treasure Amount"]
end
function getMineExcavateAmount()
  local data = getData()
  local count = 0
  for i, v in ipairs(data) do
    if v._owner == "mine" then
      count = count + 1
    end
  end
  return count
end
function canMineExcavateBeMore()
  if getMineExcavateLimit() == getMineExcavateMaxAmount() then
    return false
  end
  return true
end
function checkMineExcavateMax()
  local limit = getMineExcavateLimit()
  local amount = getMineExcavateAmount()
  if limit <= amount then
    return true
  end
  return false
end
function getMaxSearchTime()
  if max_search_time then
    return max_search_time
  end
  local pt = ed.getDataTable("GradientPrice")
  
  local function checkCost(i)
    if 0 < (pt[i]["Excavate Search"] or 0) then
      max_search_time = i
      checkCost(i + 1)
    end
  end
  checkCost(1)
  return max_search_time
end
function checkSearchTimeMax()
  local times = ed.player:getExcavateSearchTimes()
  local maxTime = getMaxSearchTime()
  if times >= maxTime then
    return true
  end
  return false
end
function needRevengeCheck(id)
  revengeCheckTag = revengeCheckTag or {}
  local tt = getTagType(id)
  if tt == "revenge" and not revengeCheckTag[id] then
    return true
  end
  return false
end
function revengeCheck(id)
  revengeCheckTag = revengeCheckTag or {}
  revengeCheckTag[id] = true
end
function isLastOccupy(id)
  if id == last_occupy_excavate then
    last_occupy_excavate = nil
    return true
  end
  return false
end
function doWithDrawHero(hid, callback)
  ed.netreply.withDrawExcavateHero = callback
  ed.netdata.withDrawExcavateHero = {heroid = hid}
  local msg = ed.upmsg.excavate()
  local wd = ed.upmsg.withdraw_excavate_hero()
  wd._hero_id = hid
  msg._withdraw_excavate_hero = wd
  ed.send(msg, "excavate")
end
function getRobRatio(id)
  local data = getData(id)
  local typeid = data._type_id
  local row = ed.getDataTable("ExcavateTreasure")[typeid]
  return row["Loot Ratio"]
end
function drawDefReward(id, callback)
  ed.netreply.drawExcavateDefReward = callback
  local msg = ed.upmsg.excavate()
  local ded = ed.upmsg.draw_excavate_def_rwd()
  ded._id = id
  msg._draw_excavate_def_rwd = ded
  ed.send(msg, "excavate")
end
function releaseHeroes(list)
  local data = getData()
  for i, v in ipairs(data) do
    local teams = v._team or {}
    for ti, tv in ipairs(teams) do
      if tv._team_id == ed.getUserid() then
        for hi, hv in ipairs(tv._hero_bases) do
          if ed.isElementInTable(hv._tid, list) then
            table.remove(tv._hero_bases, hi)
            if (tv._hero_dynas or {})[hi] then
              table.remove(tv._hero_dynas, hi)
            end
            releaseHeroes(list)
            break
          end
        end
      end
    end
  end
end
function doGiveup(excavateId, callback)
  ed.registerNetReply("drop_excavate", callback, {id = excavateId})
  local msg = ed.upmsg.excavate()
  local de = ed.upmsg.drop_excavate()
  de._mine_id = excavateId
  msg._drop_excavate = de
  ed.send(msg, "excavate")
end

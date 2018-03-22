require("md5")
require("bit")
local copyPbMessage = function(src, creater)
  if src == nil then
    return nil
  end
  local dest = creater()
  for k, v in pairs(src[".data"]) do
    dest[k] = v
  end
  return dest
end
local function copyPbArray(src, creater)
  if src == nil then
    return nil
  end
  local array = {}
  for i, v in ipairs(src) do
    array[i] = copyPbMessage(src[i], creater)
  end
  return array
end
local sub = string.sub
local function _setter(self, key, value)
  local delegate = rawget(self, "data")
  if delegate and sub(key, 1, 1) == "_" then
    delegate[key] = value
  else
    rawset(self, key, value)
  end
end
local function getGetter(class)
  local function _getter(self, key)
    local delegate = rawget(self, "data")
    if delegate and sub(key, 1, 1) == "_" then
      return delegate[key]
    else
      return class[key]
    end
  end
  return _getter
end
local class = {
  mt = {}
}
ed.Player = class
class.mt.__index = getGetter(class)
class.mt.__newindex = _setter
class.isGoogleLinked = false
setmetatable(class, ed.playertools.mt)
local function PlayerCreate()
  local self = {
    data = false,
    equip_order = {},
    equip_qunty = {},
    skillbook_qunty = {},
    heroes = {},
    friends = {},
    aid_list = {},
    tutorial = {},
    stage_stars = {},
    stage_limit_back_key = {},
    stage_limit = {},
    stage_reset_times = {},
    loots = {},
    hpLoots = {},
    initialized = false,
    time_diff = 0
  }
  setmetatable(self, class.mt)
  return self
end
ed.PlayerCreate = PlayerCreate
class.create = PlayerCreate
ed.player = PlayerCreate()
local function resetHeros(self, data)
  if self.heroes == nil then
    self.heroes = {}
  end
  if self._heroes then
    for k, v in pairs(self._heroes) do
      if self.heroes[v._tid] == nil then
        local hero = ed.HeroCreate()
        hero:setup(v)
        self.heroes[hero._tid] = hero
      else
        self.heroes[v._tid]:setup(v)
      end
    end
  else
    self.data._heroes = {}
  end
end
local function setup(self, data, nobackup)
  self.initialized = true
  self.data = data
  self.skillbook_qunty = {}
  self.equip_order = {}
  self.equip_qunty = {}
  if self._items then
    for k, v in pairs(self._items) do
      local item = self:getItemAt(k)
      table.insert(self.equip_order, item._id)
      self.equip_qunty[item._id] = item._amount
    end
  else
    self.data._items = {}
  end
  resetHeros(self, data)
  self:loadStageStars(self._userstage)
  self.stage_limit = {}
  self.stage_reset_times = {}
  self.stage_limit_back_key = {}
  if self._userstage._elite_daily_record then
    for k, v in pairs(self._userstage._elite_daily_record) do
      local limit = self:getStageLimitAt(k)
      self.stage_limit_back_key[limit._id] = k
      self.stage_limit[limit._id] = limit._count
      self.stage_reset_times[limit._id] = limit._reset
    end
  else
    self._userstage._elite_daily_record = {}
  end
  self:initNativeTimeDiff(self._last_login)
  ed.localnotify.init()
end
class.setup = setup
local setGlobalConfig = function(self, config)
  self.global_config = config or {}
end
class.setGlobalConfig = setGlobalConfig
local syncRechargeLimit = function(self, data)
  self._recharge_limit = data
end
class.syncRechargeLimit = syncRechargeLimit
local function getRechargeLimit(self, id)
  local rl = self._recharge_limit or {}
  for i = 1, #rl do
    local r = rl[i]
    local rid = ed.bits(r, 0, 16)
    local times = ed.bits(r, 16, 17)
    if rid == id then
      return times
    end
  end
  return 0
end
class.getRechargeLimit = getRechargeLimit
local function refreshRechargeLimit(self, id)
  local rt = ed.getDataTable("Recharge")
  local row = rt[id]
  if not row then
    return
  end
  local limit = row.Limit or 0
  if limit <= 0 then
    return
  end
  local rl = self._recharge_limit or {}
  for i = 1, #rl do
    local r = rl[i]
    local rid = ed.bits(r, 0, 10)
    local times = ed.bits(r, 10, 11)
    if rid == id then
      times = times + 1
      local nr = ed.makebits(11, times, 10, id)
      rl[i] = nr
      return
    end
  end
  self._recharge_limit = self._recharge_limit or {}
  local nr = ed.makebits(11, 1, 10, id)
  table.insert(self._recharge_limit, nr)
end
class.refreshRechargeLimit = refreshRechargeLimit
local function checkRechargeItemValid(self, id)
  if type(id) ~= "number" then
    return false;
  end

  local rt = ed.getDataTable("Recharge")
  local row = rt[id]
  if not row then
    return
  end
  local limit = row.Limit
  local count = self:getRechargeLimit(id)
  if limit > 0 and limit <= count then
    return false
  end
  local preid = row["Replace ID"] or 0
  if preid == 0 then
    return true
  end
  local preLimit = rt[preid].Limit
  local preCount = self:getRechargeLimit(preid)
  if preLimit <= preCount then
    return true
  end
  return false
end
class.checkRechargeItemValid = checkRechargeItemValid
local function initNativeTimeDiff(self, serverTime)
  serverTime = serverTime or 0
  local time = ed.getSystemTime()
  self.time_diff = serverTime - time
  if serverTime == 0 then
    self.time_diff = 0
  end
end
class.initNativeTimeDiff = initNativeTimeDiff
local function getLoginFrequency(self)
  local dl = self._daily_login
  local frq = dl._frequency
  local status = dl._status
  local lt = dl._last_login_date
  local nt = ed.getServerTime()
  if ed.checkTwoDateom(lt, nt) then
    return 1
  elseif ed.checkTwoDateod(lt, nt) then
    return frq + 1
  else
    return frq
  end
end
class.getLoginFrequency = getLoginFrequency
local function getLoginRewardStatus(self)
  local dl = self._daily_login
  local status = dl._status
  local lt = dl._last_login_date
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    return "common"
  elseif status then
    if status == "all" or status == 1 then
      return "received"
    elseif status == "nothing" or status == 3 then
      return "common"
    else
      return "vip"
    end
  else
    return "received"
  end
end
class.getLoginRewardStatus = getLoginRewardStatus
local function recievedDailyLoginReward(self, type)
  local r_type = {
    "common",
    "vip",
    "all"
  }
  if not ed.isElementInTable(type, r_type) then
    return
  end
  local dl = self._daily_login
  dl._frequency = self:getLoginFrequency()
  local nt = ed.getServerTime()
  dl._last_login_date = nt
  if type == "common" then
    dl._status = "part"
  else
    dl._status = "all"
  end
end
class.recievedDailyLoginReward = recievedDailyLoginReward
local function setNewMailAmount(self, amount)
  self.newMailAmount = amount
  ed.ui.baselsr.create():report("receiveMail")
end
class.setNewMailAmount = setNewMailAmount
local checkNewMail = function(self)
  return 0 < (self.newMailAmount or 0)
end
class.checkNewMail = checkNewMail
local resetNewMail = function(self)
  self.newMailAmount = nil
end
class.resetNewMail = resetNewMail
local checkSyncMailData = function(self)
  local data = self:getMailData()
  local hasNew = self:checkNewMail()
  if not data or hasNew then
    return true
  end
  return false
end
class.checkSyncMailData = checkSyncMailData
local getMailData = function(self)
  return self.mail_list
end
class.getMailData = getMailData
local getMailAmount = function(self)
  local amount = 0
  local data = self.mail_list or {}
  for i = 1, #data do
    local status = data[i]._status
    if status == "unread" or status == 0 then
      amount = amount + 1
    end
  end
  return amount
end
class.getMailAmount = getMailAmount
local refreshMailData = function(self, data)
  self.mail_list = data or {}
  self:resetNewMail()
end
class.refreshMailData = refreshMailData
local function readMail(self, id)
  local data = self.mail_list or {}
  for i = 1, #data do
    local d = data[i]
    if d._id == id then
      local money = d._money or 0
      local diamond = d._diamonds or 0
      local crusadeMoney = ed.getMailPoint(d, "crusadepoint")
      local pvpMoney = ed.getMailPoint(d, "arenapoint")
      local guildMoney = ed.getMailPoint(d, "guildpoint")
      local skillPoint = d._skill_point or 0
      local items = d._items or {}
      --if diamond > 1000 then
      --  ed.openEvaluate()
      --end
      d._status = "read"
      if money + diamond + crusadeMoney + pvpMoney + guildMoney + skillPoint > 0 or #items > 0 then
        ed.player:addMoney(money)
        ed.player:addrmb(diamond)
        ed.player:addCrusadeMoney(crusadeMoney)
        ed.player:addPvpMoney(pvpMoney)
        ed.player:addGuildMoney(guildMoney)
        ed.player:addSkillPoint(skillPoint)
        for i = 1, #items do
          local item = items[i]
          local id = ed.bits(item, 0, 10)
          local amount = ed.bits(item, 10, 11)
          local type = ed.itemType(id)
          if type == "hero" then
            self:addHero(id)
          elseif type == "equip" then
            self:addEquip(id, amount)
          end
        end
        table.remove(data, i)
        break
      end
    end
  end
end
class.readMail = readMail
local checkunreadMail = function(self)
  local data = self.mail_list or {}
  for i = 1, #data do
    local status = data[i]._status
    if status == "unread" or status == 0 then
      return true
    end
  end
  if self:checkNewMail() then
    return true
  end
end
class.checkunreadMail = checkunreadMail
local function getHeadIconRes(self)
  local id = self._name_card._avatar
  if (id or 0) == 0 then
    id = 1
  end
  return ed.getDataTable("Avatar")[id].Picture
end
class.getHeadIconRes = getHeadIconRes
local getAvatar = function(self)
  return self._name_card._avatar
end
class.getAvatar = getAvatar
local setAvatar = function(self, id)
  self._name_card._avatar = id
end
class.setAvatar = setAvatar
local function getName(self)
  local name = ""
  if not ed.isElementInTable(self._name_card._name, {
    "NickName",
    "gm_modified"
  }) then
    name = self._name_card._name
  end
  return name
end
class.getName = getName
local function setName(self, name)
  ed.player.preName = self:getName()
  self._name_card._name = name
end
class.setName = setName
local function refreshSetNameTime(self)
  if ed.player.preName == "" then
    self._name_card._last_set_name_time = ed.getServerTime() - 604800
  else
    self._name_card._last_set_name_time = ed.getServerTime()
  end
end
class.refreshSetNameTime = refreshSetNameTime
local function getNameCountdown(self)
  local lt = self._name_card._last_set_name_time
  local cd = 604800
  local time = ed.getServerTime()
  if cd < time - lt then
    return nil
  else
    local dt = cd - (time - lt)
    return ed.getdhmsCString(dt)
  end
end
class.getNameCountdown = getNameCountdown
local getSetNameCost = function(self)
  return 100
end
class.getSetNameCost = getSetNameCost
local function getvip(self)
  local rsum = self._recharge_sum or 0
  local vt = ed.getDataTable("VIP")
  return vt:getVipLevel(rsum)
end
class.getvip = getvip
local checkvipGiftValid = function(self, vip)
  local vgr = self._vip_gifts_draw or {}
  local cv = self:getvip()
  if vip > cv then
    return false
  end
  for i = 1, #vgr do
    if vgr[i] == vip then
      return false
    end
  end
  return true
end
class.checkvipGiftValid = checkvipGiftValid
local refreshvipGiftRecord = function(self, vip)
  local vgr = self._vip_gifts_draw or {}
  for i = 1, #vgr do
    if vip == vgr[i] then
      return
    end
  end
  self._vip_gifts_draw = self._vip_gifts_draw or {}
  table.insert(self._vip_gifts_draw, vip)
end
class.refreshvipGiftRecord = refreshvipGiftRecord
local function getvipGift(self, vip)
  if not vip then
    return
  end
  local vgt = ed.getDataTable("VIPGift")
  local row = vgt[vip]
  if not row then
    return
  end
  local gt = {}
  local index = 1
  while row[string.format("Gift Type %d", index)] do
    local type = row[string.format("Gift Type %d", index)]
    local id = row[string.format("Gift ID %d", index)]
    local amount = row[string.format("Gift Amount %d", index)]
    gt[index] = {
      type = type,
      id = id,
      amount = amount
    }
    index = index + 1
  end
  return gt
end
class.getvipGift = getvipGift
local function addvipGift(self, vip)
  local gt = self:getvipGift(vip) or {}
  for i = 1, #gt do
    local g = gt[i]
    local type = g.type
    local id = g.id
    local amount = g.amount or 1
    if ed.isElementInTable(type, {"Item", "Hero"}) then
      if id then
        local t = ed.itemType(id)
        if t == "hero" then
          self:addHero(id)
        elseif t == "equip" then
          self:addEquip(id, amount)
        end
      end
    elseif type == "Gold" then
      self:addMoney(amount)
    end
  end
  self:refreshvipGiftRecord(vip)
end
class.addvipGift = addvipGift
local addMoney = function(self, money, silent)
  money = money or 0
  self._money = math.max(self._money + money, 0)
  self.addMoneySilent = silent
  FireEvent("PlayerMoneyChange", self._money)
end
class.addMoney = addMoney
local function getChatFreeTime(self)
  local chat = ed.player._chat
  if chat == nil then
    return 0
  end
  local last = chat._last_reset_world_chat_time
  local time = ed.getServerTime()
  if ed.checkTwoDateod(last, time) then
    chat._last_reset_world_chat_time = ed.getServerTime()
    chat._world_chat_times = 10
  end
  return chat._world_chat_times or 0
end
class.getChatFreeTime = getChatFreeTime
local function subChatFreeTime(self)
  local chat = ed.player._chat
  if chat == nil then
    return
  end
  chat._world_chat_times = math.max(0, chat._world_chat_times - 1)
end
class.subChatFreeTime = subChatFreeTime
local function getMidasMaxTimes(self)
  local vip = self:getvip()
  return ed.getDataTable("VIP")[vip].Midas
end
class.getMidasMaxTimes = getMidasMaxTimes
local function getMidasTimes(self)
  local data = ed.player._usermidas
  local last = data._last_change
  local time = ed.getServerTime()
  if ed.checkTwoDateod(last, time) then
    self:resetMidasTimes(self)
  end
  return data._today_times or 0
end
class.getMidasTimes = getMidasTimes
local function useMidasTimes(self, times)
  local data = ed.player._usermidas
  data._last_change = ed.getServerTime()
  data._today_times = data._today_times + (times or 1)
end
class.useMidasTimes = useMidasTimes
local function resetMidasTimes(self)
  local data = ed.player._usermidas
  data._last_change = ed.getServerTime()
  data._today_times = 0
end
class.resetMidasTimes = resetMidasTimes
local subrmb = function(self, rmb)
  rmb = rmb or 0
  self._rmb = self._rmb - rmb
end
class.subrmb = subrmb
local addrmb = function(self, rmb)
  rmb = rmb or 0
  self._rmb = self._rmb + rmb
end
class.addrmb = addrmb
local function setRechargeSum(self, rmb)
  local previp = self:getvip()
  self._recharge_sum = rmb
  local vip = self:getvip()
  if previp < vip then
    local lsr = ed.ui.baselsr.create("base")
    lsr:report("vipLevelup", {previp = previp})
  end
end
class.setRechargeSum = setRechargeSum
local setrmb = function(self, rmb)
  self._rmb = rmb
end
class.setrmb = setrmb
local addCrusadeMoney = function(self, amount)
  amount = amount or 0
  self:addPoint("crusadepoint", amount)
end
class.addCrusadeMoney = addCrusadeMoney
local addPvpMoney = function(self, amount)
  amount = amount or 0
  self:addPoint("arenapoint", amount)
end
class.addPvpMoney = addPvpMoney
local addGuildMoney = function(self, amount)
  amount = amount or 0
  self:addPoint("guildpoint", amount)
end
class.addGuildMoney = addGuildMoney
local function addVitality(self, vit, timeAdd)
  vit = vit or 1
  local param = ed.parameter
  local vitality = self._vitality
  self:refreshVitalityTime()
  if timeAdd then
    if vitality._current < ed.playerlimit.maxVitality() then
      vitality._current = vitality._current + vit
    end
  else
    vitality._current = vitality._current + vit
  end
  if vitality._current < 0 then
    print("vitality less than zero . it's a bug!")
    vitality._current = 0
  end
  self:refreshVitalityTime(timeAdd)
end
class.addVitality = addVitality
local getVitality = function(self)
  local vitality = self._vitality
  return vitality._current
end
class.getVitality = getVitality
local function checkVitalityLimit(self)
  local vitality = self._vitality
  local param = ed.parameter
  local vit = vitality._current
  if vit >= ed.playerlimit.maxVitality() then
    return true
  end
  return false
end
class.checkVitalityLimit = checkVitalityLimit
local function refreshVitalityTime(self, timeAdd)
  local vitality = self._vitality
  if timeAdd then
    local param = ed.parameter
    local gap = param.sync_vitality_gap
    local lt = vitality._lastchange
    vitality._lastchange = lt + gap
  end
  if self:checkVitalityLimit() then
    vitality._lastchange = ed.getServerTime()
  end
end
class.refreshVitalityTime = refreshVitalityTime
local getVitalityBuyTimes = function(self)
  self:resetVitalityBuyTimes()
  local vitality = self._vitality
  return vitality._todaybuy
end
class.getVitalityBuyTimes = getVitalityBuyTimes
local function getBuyVitalityCost(self)
  local t = self:getVitalityBuyTimes()
  local gpt = ed.getDataTable("GradientPrice")
  return gpt[t + 1].Vitality
end
class.getBuyVitalityCost = getBuyVitalityCost
local function canBuyVitality(self)
  local t = self:getVitalityBuyTimes()
  local tlimit = ed.getDataTable("VIP")[self:getvip()]["Buy Vit Max"]
  if t >= tlimit then
    return false
  end
  return true
end
class.canBuyVitality = canBuyVitality
local vitality_last_login
local function resetVitalityBuyTimes(self)
  local vitality = self._vitality
  local lt = vitality._lastbuy
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    vitality._todaybuy = 0
  end
end
class.resetVitalityBuyTimes = resetVitalityBuyTimes
local function refreshVitality(self)
  local param = ed.parameter
  local gap = param.sync_vitality_gap
  local vitality = self._vitality
  local ltime = vitality._lastchange
  local stime = ed.getServerTime()
  local dt = gap - (stime - ltime)
  while dt <= 0 do
    dt = dt + gap
    self:addVitality(1, true)
  end
end
class.refreshVitality = refreshVitality
local function getVitalityNextUpdate(self)
  local param = ed.parameter
  local gap = param.sync_vitality_gap
  local vitality = self._vitality
  local ltime = vitality._lastchange
  local stime = ed.getServerTime()
  local dt = gap - (stime - ltime)
  return dt
end
class.getVitalityNextUpdate = getVitalityNextUpdate
local addSkillPoint = function(self, add)
  add = add or 0
  local slu = self._skill_level_up
  slu._skill_levelup_chance = slu._skill_levelup_chance + add
end
class.addSkillPoint = addSkillPoint
local function getSkillLvupChance(self)
  local slu = self._skill_level_up
  local chance = slu._skill_levelup_chance
  local isOverfull
  if chance >= self:getMaxSkillChance() then
    slu._skill_levelup_cd = ed.getServerTime()
    isOverfull = true
  end
  local time = slu._skill_levelup_cd
  local cd = ed.parameter.skill_level_up_chance_cd
  local nt = ed.getServerTime()
  local dt = nt - time
  dt = math.max(dt, 0)
  local addChance = math.floor(dt / cd)
  local last_refresh_time = slu._skill_levelup_cd
  if not isOverfull then
    slu._skill_levelup_chance = math.min(chance + addChance, self:getMaxSkillChance())
  end
  if self:checkSkillChanceMax() then
    last_refresh_time = ed.getServerTime()
    slu._skill_levelup_cd = last_refresh_time
  else
    last_refresh_time = nt - dt % cd
    slu._skill_levelup_cd = last_refresh_time
  end
  return slu._skill_levelup_chance, last_refresh_time
end
class.getSkillLvupChance = getSkillLvupChance
local function getSkillLvupNextCount(self)
  local chance, lrt = self:getSkillLvupChance()
  local slu = self._skill_level_up
  local time = lrt
  local cd = ed.parameter.skill_level_up_chance_cd
  local nt = ed.getServerTime()
  return cd - (nt - time)
end
class.getSkillLvupNextCount = getSkillLvupNextCount
local strenHeroSkill = function(self, id, slot, add)
  add = add or 1
  local hero = self.heroes[id]
  hero._skill_levels[slot] = hero._skill_levels[slot] + add
end
class.strenHeroSkill = strenHeroSkill
local function getMaxSkillChance(self)
  local max = ed.getDataTable("VIP")[self:getvip()]["Max Skill Points"]
  return max
end
class.getMaxSkillChance = getMaxSkillChance
local checkSkillChanceMax = function(self)
  local amount = self._skill_level_up._skill_levelup_chance
  local max = self:getMaxSkillChance()
  if amount >= max then
    return true
  else
    return false
  end
end
class.checkSkillChanceMax = checkSkillChanceMax
local function resetSkillData(self)
  local sd = self._skill_level_up
  local lt = sd._last_reset_date
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    sd._reset_times = 0
  end
end
class.resetSkillData = resetSkillData
local getSkillResetTimes = function(self)
  self:resetSkillData()
  local sd = self._skill_level_up
  return sd._reset_times
end
class.getSkillResetTimes = getSkillResetTimes
local getTutorialRecord = function(self, key)
  return (self._tutorial or {})[key]
end
class.getTutorialRecord = getTutorialRecord
local setTutorialRecord = function(self, key, value)
  self:initTutorial()
  self._tutorial[key] = value
end
class.setTutorialRecord = setTutorialRecord
local increaseTutorial = function(self, key)
  self:initTutorial()
  self._tutorial[key] = (self._tutorial[key] or 0) + 1
end
class.increaseTutorial = increaseTutorial
local initTutorialRecord = function(self, key, value)
  self._tutorial = self._tutorial or {}
  self._tutorial[key] = self._tutorial[key] or value
end
class.initTutorialRecord = initTutorialRecord
local function initTutorial(self)
  self._tutorial = self._tutorial or {}
  local res = ed.tutorialres.t_key
  for k, v in pairs(res) do
    self:initTutorialRecord(v.id, 0)
  end
end
class.initTutorial = initTutorial
local function getSweepTimes(self)
  local eid = ed.parameter.sweep_coin_id
  return self.equip_qunty[eid] or 0
end
class.getSweepTimes = getSweepTimes
local function useSweepTimes(self, times)
  local eid = ed.parameter.sweep_coin_id
  self:consumeEquip(eid, times)
end
class.useSweepTimes = useSweepTimes
local stageType = function(id)
  local type
  xpcall(function()
    if id > 0 and id < 10000 then
      type = "normal"
    elseif id > 10000 and id < 19999 then
      type = "elite"
    elseif id > 20000 and id < 30000 then
      type = "act"
    elseif id == -1 then
      type = "pvp"
    elseif id > 40000 and id < 50000 then
      type = "raid"
    end
  end, EDDebug)
  return type
end
ed.stageType = stageType
local function elite2NormalStage(id)
  local type = stageType(id)
  if type == "elite" then
    return id - 10000
  elseif type == "normal" then
    return id
  else
    return id
  end
end
ed.elite2NormalStage = elite2NormalStage
local function loadStageStars(self, data)
  local orderList = function(l)
    for i = 1, #l do
      for j = i, 2, -1 do
        if l[j] < l[j - 1] then
          local t = l[j]
          l[j] = l[j - 1]
          l[j - 1] = t
        end
      end
    end
  end
  local normal = data._normal_stage_stars or {}
  local elite = data._elite_stage_stars or {}
  local nid, eid = {}, {}
  local st = ed.getDataTable("Stage")
  for k, v in pairs(st) do
    if type(k) == "number" then
      local type = ed.stageType(k)
      if type == "normal" then
        table.insert(nid, k)
      elseif type == "elite" then
        table.insert(eid, k)
      end
    end
  end
  orderList(nid)
  orderList(eid)
  for i = 1, #nid do
    local id = nid[i]
    local index = math.floor((i - 1) / 16) + 1
    local n = (i - 1) % 16
    self.stage_stars[id] = ed.bits(normal[index] or 0, n * 2, 2)
  end
  for i = 1, #eid do
    local id = eid[i]
    local index = math.floor((i - 1) / 16) + 1
    local n = (i - 1) % 16
    self.stage_stars[id] = ed.bits(elite[index] or 0, n * 2, 2)
  end
end
class.loadStageStars = loadStageStars
local getStageStar = function(self, stage)
  if not stage then
    return 0
  end
  return self.stage_stars[stage] or 0
end
class.getStageStar = getStageStar
local function getStageProgress(self)
  local progress = 0
  for k, v in pairs(self.stage_stars) do
    local type = ed.stageType(k)
    if type == "normal" and v > 0 and k > progress then
      progress = k
    end
  end
  return self.stage_stars[progress + 1] and progress + 1 or progress
end
class.getStageProgress = getStageProgress
local function getEliteStageProgress(self)
  local progress = 0
  local st = ed.getDataTable("Stage")
  for k, v in pairs(self.stage_stars) do
    local type = ed.stageType(k)
    if type == "elite" and v > 0 and k > progress then
      local sg = st[k]["Stage Group"]
      if 0 < self.stage_stars[sg] then
        progress = k
      end
    end
  end
  progress = self.stage_stars[progress + 1] and progress + 1 or progress
  return math.max(progress, 1)
end
class.getEliteStageProgress = getEliteStageProgress
local function setStageStars(self, stage, stars)
  if stars == nil then
    return
  end
  local type = ed.stageType(stage)
  if not ed.isElementInTable(type, {"normal", "elite"}) then
    return
  end
  local old = self:getStageStar(stage) or 0
  if stars <= old then
    return
  end
  self.stage_stars[stage] = stars
  self._userstage._normal_stage_stars = self._userstage._normal_stage_stars or {}
  local record = self._userstage._normal_stage_stars
  if type == "elite" then
    stage = ed.elite2NormalStage(stage)
    record = self._userstage._elite_stage_stars or {}
  end
  local intpos = math.floor((stage - 1) / 16) + 1
  local bitpos = (stage - 1) % 16
  local num = record[intpos] or 0
  local mask = ed.makebits(2, 3, bitpos * 2, 0)
  mask = bit.bnot(mask)
  num = bit.band(num, mask)
  local mask = ed.makebits(2, stars, bitpos * 2, 0)
  num = bit.bor(num, mask)
  record[intpos] = num
end
class.setStageStars = setStageStars
local function getStageLimitAt(self, idx)
  local row = self._userstage._elite_daily_record[idx]
  return {
    _id = ed.bits(row, 8, 10),
    _count = ed.bits(row, 4, 4),
    _reset = ed.bits(row, 0, 4)
  }
end
class.getStageLimitAt = getStageLimitAt
local function setStageLimitAt(self, id)
  local idx = self.stage_limit_back_key[id]
  local count = self.stage_limit[id]
  local reset = self.stage_reset_times[id] or 0
  if idx then
    self._userstage._elite_daily_record[idx] = ed.makebits(10, id, 4, count, 4, reset)
  else
    table.insert(self._userstage._elite_daily_record, ed.makebits(10, id, 4, count, 4, reset))
    self.stage_limit_back_key[id] = #self._userstage._elite_daily_record
  end
end
class.setStageLimitAt = setStageLimitAt
local function getStageLimit(self, id)
  self.stage_limit = self.stage_limit or {}
  id = ed.elite2NormalStage(id)
  if id then
    return self.stage_limit[id] or 0
  else
    return 0
  end
end
class.getStageLimit = getStageLimit
local function checkStageLimitResetTimesMax(self, id)
  local vip = self:getvip()
  local vt = ed.getDataTable("VIP")
  local row = vt[vip]
  if not row then
    return true
  end
  local times = row["Elite Reset"]
  local nt = self:getStageLimitResetTimes(id)
  if times <= nt then
    return true
  end
  return false
end
class.checkStageLimitResetTimesMax = checkStageLimitResetTimesMax
local function getStageLimitResetTimes(self, id)
  id = ed.elite2NormalStage(id)
  return self.stage_reset_times[id] or 0
end
class.getStageLimitResetTimes = getStageLimitResetTimes
local function getResetEliteCost(self, id)
  id = ed.elite2NormalStage(id)
  local times = self:getStageLimitResetTimes(id)
  local gpt = ed.getDataTable("GradientPrice")
  local row = gpt[times + 1]
  if not row then
    return
  else
    return row["Elite Reset"]
  end
end
class.getResetEliteCost = getResetEliteCost
local function addStageLimit(self, id, amount)
  self.stage_limit = self.stage_limit or {}
  amount = amount or 1
  self.stage_limit[id] = (self.stage_limit[id] or 0) + amount
  self:setStageLimitAt(ed.elite2NormalStage(id))
end
class.addStageLimit = addStageLimit
local function refreshStageEliteLimit(self, stage)
  self.stage_limit = self.stage_limit or {}
  local stage = ed.elite2NormalStage(stage)
  self.stage_limit[stage] = 0
  self.stage_reset_times[stage] = (self.stage_reset_times[stage] or 0) + 1
  self:setStageLimitAt(stage)
end
class.refreshStageEliteLimit = refreshStageEliteLimit
local resetEliteLimit = function(self)
  for k, v in pairs(self.stage_limit) do
    self.stage_limit[k] = 0
    self.stage_reset_times[k] = 0
    self:setStageLimitAt(k)
  end
end
class.resetEliteLimit = resetEliteLimit
local getEliteResetTime = function(self)
  return self._userstage._elite_reset_time
end
class.getEliteResetTime = getEliteResetTime
local function refreshEliteResetTime(self)
  self._userstage._elite_reset_time = ed.getServerTime()
end
class.refreshEliteResetTime = refreshEliteResetTime
local function resetActRecord(self)
  local data = self._userstage._act_daily_record
  for i = 1, #(data or {}) do
    local r = data[i]
    local lt = r._last_change
    local nt = ed.getServerTime()
    if ed.checkTwoDateod(lt, nt) then
      r._frequency = 0
    end
  end
end
class.resetActRecord = resetActRecord
local getActRecord = function(self, id)
  self:resetActRecord()
  local data = self._userstage._act_daily_record
  for i = 1, #(data or {}) do
    local r = data[i]
    if r._id == id then
      return r
    end
  end
  return nil
end
class.getActRecord = getActRecord
local getActcd = function(self, id)
  local record = self:getActRecord(id) or {}
  return record._last_change or 0
end
class.getActcd = getActcd
local getActTimes = function(self, id)
  self:resetActRecord()
  local record = self:getActRecord(id) or {}
  return record._frequency or 0
end
class.getActTimes = getActTimes
local function addActTimes(self, id, times)
  self._userstage._act_daily_record = self._userstage._act_daily_record or {}
  local at = self:getActTimes(id)
  times = times or 1
  at = at + times
  local record = self:getActRecord(id)
  if record then
    record._frequency = at
    record._last_change = ed.getServerTime()
  else
    local r = ed.downmsg.act_daily_record()
    r._id = id
    r._frequency = at
    r._last_change = ed.getServerTime()
    table.insert(self._userstage._act_daily_record, r)
  end
end
class.addActTimes = addActTimes
local resetActTimes = function(self)
  self.act_times = {}
  self._userstage._act_enter_frequency = {}
end
class.resetActTimes = resetActTimes
local getActResetTime = function(self)
  local data = self._userstage
  return data._act_reset_time
end
class.getActResetTime = getActResetTime
local function refreshActResetTime(self)
  local data = self._userstage
  data._act_reset_time = ed.getServerTime()
end
class.refreshActResetTime = refreshActResetTime
local function getSkillbookAt(self, idx)
  local row = self._skillbooks[idx]
  return {
    _id = ed.bits(row, 10, 10),
    _amount = ed.bits(row, 0, 11)
  }
end
class.getSkillbookAt = getSkillbookAt
local addSkillbook = function(self, tid)
  self:addItem(self.skillbook_qunty, self._skillbooks, tid)
  LegendLog("Got book: " .. tid)
end
class.addSkillbook = addSkillbook
local getEquipAmount = function(self, id)
  return self.equip_qunty[id] or 0
end
class.getEquipAmount = getEquipAmount
local function getItemAt(self, idx)
  local row = self._items[idx]
  return {
    _id = ed.bits(row, 0, 10),
    _amount = ed.bits(row, 10, 11)
  }
end
class.getItemAt = getItemAt
local function setItemAt(self, id)
  local key
  for k, v in pairs(self._items) do
    if self:getItemAt(k)._id == id then
      key = k
      break
    end
  end
  local amount = self.equip_qunty[id] or 0
  if key then
    if amount == 0 then
      table.remove(self._items, key)
    else
      self._items[key] = ed.makebits(11, amount, 10, id)
    end
  end
end
class.setItemAt = setItemAt
local itemType = function(id)
  if not id then
    return
  end
  local itemtype
  if id < 100 then
    itemtype = "hero"
  elseif id < 600 then
    itemtype = "equip"
  else
    EDDebug("Invalid item ID: " .. id)
  end
  return itemtype
end
ed.itemType = itemType
local function addEquip(self, tid, amount)
  amount = amount or 1
  local ret = self:addItem(self.equip_qunty, self._items, tid, amount)
  local name = ed.lookupDataTable("equip", "Name", tid)
  LegendLog("Got equip: " .. tid .. "(" .. name .. ")" .. (amount > 1 and " * " .. amount or ""))
  self:refreshEquipOrder(tid, true)
  return ret
end
class.addEquip = addEquip
local function addItem(self, t, array, tid, amount)
  amount = amount or 1
  t[tid] = math.min(ed.parameter.max_item_amount, (t[tid] or 0) + amount)
  for i, v in ipairs(array) do
    local count, id = ed.splitbits(v, 11, 10)
    if id == tid then
      count = math.min(ed.parameter.max_item_amount, count + amount)
      array[i] = ed.makebits(11, count, 10, id)
      local element = array[i]
      return array[i]
    end
  end
  table.insert(array, 1, ed.makebits(11, amount, 10, tid))
  return array[#array]
end
class.addItem = addItem
local function gmAddEquip(self, tidOrName, amount)
  xpcall(function()
    local id = ed.lookupDataTable("equip", "Item_ID", tidOrName)
    local ret = self:addEquip(id, amount)
    local msg = ed.upmsg.gm_cmd()
    msg._set_items = {
      ed.makebits(11, amount, 10, id)
    }
    ed.send(msg, "gm_cmd")
  end, EDDebug)
end
class.gmAddEquip = gmAddEquip
local consumeEquip = function(self, id, amount)
  amount = amount or 1
  if amount <= (self.equip_qunty[id] or 0) then
    self.equip_qunty[id] = self.equip_qunty[id] - amount
  else
    print("Not Enough equip to consume! Input:", id, amount)
    --EDDebug()
  end
  self.refreshEquipOrder(self, id, false)
  self:setItemAt(id)
end
class.consumeEquip = consumeEquip
local refreshEquipOrder = function(self, id, isAdd)
  if isAdd then
    local isExist = false
    for i = 1, #self.equip_order do
      if self.equip_order[i] == id then
        isExist = true
        break
      end
    end
    if not isExist then
      table.insert(self.equip_order, 1, id)
    end
  elseif self.equip_qunty[id] == 0 or not self.equip_qunty[id] then
    for i = 1, #self.equip_order do
      if self.equip_order[i] == id then
        table.remove(self.equip_order, i)
      end
    end
  end
end
class.refreshEquipOrder = refreshEquipOrder
local function getStageLoots(self)
  local list = {}
  for _, lootint in ipairs(self.loots) do
    local _, __, item_id = ed.splitbits(lootint, 3, 3, 10)
    table.insert(list, {
      type = itemType(item_id),
      id = item_id
    })
  end
  for _, loot in ipairs(self.hpLoots) do
    for i, v in ipairs(loot._loots) do
      if v.geted then
        for _, item in ipairs(v._items) do
          table.insert(list, {
            type = itemType(item),
            id = item
          })
        end
      end
    end
  end
  return list
end
class.getStageLoots = getStageLoots
function class:getStageLootOfMonster(wave_idx, monster_idx)
  local list = {}
  for _, lootint in ipairs(self.loots) do
    local wave, monster, item_id = ed.splitbits(lootint, 3, 3, 10)
    if wave_idx == wave and monster_idx == monster then
      table.insert(list, {
        type = itemType(item_id),
        id = item_id
      })
    end
  end
  return list
end
function class:getHpLootOfMonster(wave_idx, monster_idx, hpPercent, oldPercent)
  local list = {}
  for _, loot in ipairs(self.hpLoots) do
    local wave, monster, item_id = ed.splitbits(loot._monster_info, 3, 3, 10)
    if wave_idx == wave and monster_idx == monster then
      if not loot._loots then
        break
      end
      for i, v in ipairs(loot._loots) do
        if oldPercent * 10 < v._per and hpPercent * 10 > v._per and not v.geted and v._items then
          v.geted = true
          for _, item in ipairs(v._items) do
            table.insert(list, {
              type = itemType(item),
              id = item
            })
          end
        end
      end
    end
  end
  return list
end
local function takeStageExp(self, stage)
  local reward = ed.lookupDataTable("Stage", nil, stage)
  self:addExp(reward["Exp Reward"], "battle")
end
class.takeStageExp = takeStageExp
local function takeStageReward(self, stage, stars, hero_list, loots)
  local reward = ed.lookupDataTable("Stage", nil, stage)
  self:addMoney(reward["Money Reward"])
  self:addExp(reward["Exp Reward"], "battle")
  local heroexp = math.floor(reward["Heroexp Reward"] / #hero_list)
  for i = 1, #hero_list do
    local hero = hero_list[i]
    if hero:getMercenaryData() == nil then
      hero:addExp(heroexp)
    end
  end
  if loots then
    for _, item in ipairs(loots) do
      local item_id = item.id
      local item_type = item.type
      if item_type == "hero" then
        self:addHero(item_id)
      elseif item_type == "equip" then
        self:addEquip(item_id)
      elseif item_type == "book" then
        self:addSkillbook(item_id)
      end
    end
  end
  self:setStageStars(stage, stars)
end
class.takeStageReward = takeStageReward
local function checkLevelMax(self, level)
  local pm = ed.parameter
  local ml = pm.team_level_max
  if level then
    if level >= ml then
      return true
    end
  else
    level = self._level
    if ml <= level then
      self._level = ml
      self._exp = self:getMaxExp();
      return true
    end
  end
  return false
end
class.checkLevelMax = checkLevelMax
local getLevel = function(self)
  self:checkLevelMax()
  return self._level
end
class.getLevel = getLevel
local getExp = function(self)
  self:checkLevelMax()
  return self._exp
end
class.getExp = getExp
local function getMaxExp(self)
  --if self:checkLevelMax() then
    --return 0
  --else
    return ed.getDataTable("PlayerLevel")[self._level].Exp
  --end
end
class.getMaxExp = getMaxExp
local function levelup(self, source)
  if self:checkLevelMax() then
    return
  end
  local plt = ed.getDataTable("PlayerLevel")
  local vr = plt[self._level]["Vitality Reward"]
  self:addVitality(vr)
  self._level = self._level + 1
  local lsr = ed.ui.baselsr.create("base")
  if ed.isElementInTable(source, {"battle"}) then
    lsr:report("happenPlayerLevelup")
  elseif ed.isElementInTable(source, {
    "sweep",
    "task",
    "else"
  }) then
    lsr:report("happenPlayerLevelup")
    lsr:report("playerLevelup")
  else
    lsr:report("happenPlayerLevelup")
    lsr:report("playerLevelup")
  end
end
class.levelup = levelup
local function addExp(self, exp, source)
  if self:checkLevelMax() then
    self.teamAlreadyMaxLevel = true
    return
  end
  source = source or "else"
  local oexp = self._exp
  local olevel = self._level
  self._exp = self._exp + exp
  local levelup_exp
  while true do
    levelup_exp = math.floor(ed.lookupDataTable("PlayerLevel", "Exp", self._level))
    if levelup_exp == 0 then
      return
    end
    if levelup_exp <= self._exp then
      self._exp = self._exp - levelup_exp
      self:levelup(source)
    else
      break
    end
  end
  print(string.format("%s\t exp +%i (%i/%i). Lv%i%s.", "*P*", exp, self._exp, levelup_exp, olevel,  (  olevel == self._level and  "")  or  (" -> Lv" .. self._level) ))
end
class.addExp = addExp
local unitType = function(id)
  if id < 100 then
    return "hero"
  elseif id > 100 then
    return "monster"
  end
end
ed.unitType = unitType
local function addHero(self, tid)
  local info = ed.lookupDataTable("Unit", nil, tid)
  if self.heroes[tid] then
    print("Got duplicated hero: " .. info.Name)
    return
  end
  local hero = ed.downmsg.hero()
  hero._tid = tid
  hero._level = 1
  hero._rank = ed.lookupDataTable("Unit", "Initial Rank", tid)
  hero._exp = 0
  hero._gs = 5
  hero._stars = ed.getDataTable("Unit")[tid]["Initial Stars"]
  hero._skill_levels = {}
  hero._items = {}
  hero._state = "idle"
  for i = 1, 6 do
    local item = ed.downmsg.hero_equip()
    item._index = i
    item._item_id = 0
    item._exp = 0
    table.insert(hero._items, item)
  end
  for i = 1, 4 do
    local level = ed.getDataTable("SkillGroup")[tid][i]["Init Level"]
    table.insert(hero._skill_levels, level)
  end
  table.insert(self._heroes, hero)
  table.sort(self._heroes, function(h1, h2)
    return h1._tid < h2._tid
  end)
  self.heroes[tid] = ed.HeroCreate()
  self.heroes[tid]:setup(hero)
  LegendLog("Got hero: " .. info.Name)
end
class.addHero = addHero
local resetHero = function(self, ht)
  if ht then
    if not self.heroes[ht._tid] then
      self:addHero(ht._tid)
    end
    local hero = self.heroes[ht._tid]
    if hero then
      hero:setup(ht)
    end
    for i, h in ipairs(self._heroes) do
      if h._tid == ht._tid then
        self._heroes[i] = ht
      end
    end
  end
end
class.resetHero = resetHero
local setHeroCrusadeData = function(self, data)
  if nil == data then
    return
  end
  local hero = self.heroes[data._tid]
  if nil == hero then
    return
  end
  local heroData = {}
  heroData._hp_perc = data._dyna._hp_perc
  heroData._mp_perc = data._dyna._mp_perc
  heroData._custom_data = data._dyna._custom_data
  hero:setCrusade(heroData)
end
class.setHeroCrusadeData = setHeroCrusadeData
local setHeroExcavateData = function(self, data)
  if not data then
    return
  end
  local hero = self.heroes[data._heroid]
  if not hero then
    return
  end
  local heroData = {}
  heroData._hp_perc = data._hp_perc
  heroData._mp_perc = data._mp_perc
  heroData._custom_data = data._custom_data
  hero:setExcavate(heroData)
end
class.setHeroExcavateData = setHeroExcavateData
local clearAllCrusadeData = function(self)
  for i, hero in pairs(self.heroes) do
    hero:setCrusade(nil)
  end
end
class.clearAllCrusadeData = clearAllCrusadeData
local initAllExcavateData = function(self)
  for i, hero in pairs(self.heroes) do
    hero:initExcavate()
  end
end
class.initAllExcavateData = initAllExcavateData
local clearAllExcavateData = function(self)
  for i, hero in pairs(self.heroes) do
    hero:setExcavate(nil)
  end
end
class.clearAllExcavateData = clearAllExcavateData
local collectCrusadeData = function(self, heros)
  local datas = {}
  for i, hero in pairs(heros) do
    if hero.crusadeData then
      datas[hero._tid] = hero.crusadeData
    end
  end
  return datas
end
class.collectCrusadeData = collectCrusadeData
local collectExcavateData = function(self, heroes)
  local datas = {}
  for i, hero in ipairs(heroes) do
    if hero.excavateData then
      datas[i] = hero.excavateData
    end
  end
  return datas
end
class.collectExcavateData = collectExcavateData
local getHero = function(self, id)
  return self.heroes[id]
end
class.getHero = getHero
local function addTask(self, chain, id)
  local ts = self._task
  for k, v in pairs(self._task or {}) do
    if v._line == chain then
      table.remove(self._task, k)
    end
  end
  local task = ed.downmsg.usertask()
  task._line = chain
  task._id = id
  task._status = "working"
  task._task_target = 0
  if not self._task then
    self._task = {}
  end
  table.insert(self._task, task)
end
class.addTask = addTask
local getTaskList = function(self)
  return self._task or {}
end
class.getTaskList = getTaskList
local getFinishedTask = function(self)
  return self._task_finished or {}
end
class.getFinishedTask = getFinishedTask
local getGuildName = function(self)
  if self._user_guild then
    return self._user_guild._name
  end
end
class.getGuildName = getGuildName
local setGuildName = function(self, name)
  if self._user_guild == nil then
    self._user_guild = {}
  end
  self._user_guild._name = name
end
class.setGuildName = setGuildName
local setGuild = function(self, guild)
  self._user_guild = guild
end
class.setGuild = setGuild
local function isMercenaryHero(self, tid)
  if ed.player.heroes[tid] and ed.player.heroes[tid]._state == "hire" then
    return true
  end
  return false
end
class.isMercenaryHero = isMercenaryHero
local cancelMercenary = function(self, tid)
  if self.heroes[tid] and self.heroes[tid]._state == "hire" then
    self.heroes[tid]._state = "idle"
  end
end
class.cancelMercenary = cancelMercenary
local function cancelAllMercenary(self)
  if not self.heroes then
    return
  end
  for i, v in pairs(self.heroes) do
    if v then
      cancelMercenary(self, v._tid)
    end
  end
end
class.cancelAllMercenary = cancelAllMercenary
local setGuildId = function(self, id)
  if self._user_guild == nil then
    self._user_guild = {}
  end
  self._user_guild._id = id
end
class.setGuildId = setGuildId
local getGuildId = function(self)
  if self._user_guild then
    return self._user_guild._id
  end
  return 0
end
class.getGuildId = getGuildId
local getTaskCount = function(self, line, id)
  for k, v in pairs(self._task) do
    if v._line == line and v._id == id then
      return v._task_target
    end
  end
  return 0
end
class.getTaskCount = getTaskCount
local function increaseTaskCount(self, config)
  local kid = config.id
  local tp = config.type
  local add = config.add or 1
  local tt = ed.getDataTable("Task")
  for k, v in pairs(self._task) do
    if v._status == "working" then
      local chain = v._line
      local id = v._id
      local row = tt[chain][id]
      if row then
        local pt = row["Task Progress Type"]
        local tid = row["Task Progress ID"]
        local target = row["Task Target"]
        if pt == tp then
          for i = 1, #tid do
            if tid[i] == kid then
              local count = v._task_target
              count = count + add
              count = math.min(count, target)
              self._task[k]._task_target = count
            end
          end
        end
      end
    end
  end
end
class.increaseTaskCount = increaseTaskCount
local box_color_table = {
  bronze = "green",
  silver = "blue",
  gold = "purple",
  magic = "magicsoul"
}
local function refreshFirstTavern(self, type, times)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == type or v._box_type == bt[type] then
      local fd = v._has_first_draw
      local of = ed.bits(fd, 16, 16)
      local tf = ed.bits(fd, 0, 16)
      if times == "one" then
        of = 1
      elseif times == "ten" then
        tf = 1
      end
      record[k]._has_first_draw = ed.makebits(16, of, 16, tf)
      break
    end
  end
end
class.refreshFirstTavern = refreshFirstTavern
local function useFreeTavern(self, type)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == type or v._box_type == bt[type] then
      record[k]._left_cnt = math.max(self:getTavernLeftTimes(type) - 1, 0)
      record[k]._last_get_time = ed.getServerTime()
    end
  end
end
class.useFreeTavern = useFreeTavern
local function getTavernRecord(self, box)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == box or v._box_type == bt[box] then
      return v
    end
  end
  local isIllegal
  for k, v in pairs(box_color_table) do
    if k == box then
      isIllegal = true
      break
    end
  end
  if isIllegal then
    local r = ed.downmsg.tavern_record()
    r._box_type = "magicsoul"
    r._left_cnt = 0
    r._last_get_time = 0
    r._has_first_draw = ed.makebits(16, 0, 16, 0)
    table.insert(record, r)
    return r
  end
end
class.getTavernRecord = getTavernRecord
local function getTavernLeftTimes(self, type)
  local tl = {
    bronze = 5,
    silver = 1,
    gold = 1,
    magic = 1
  }
  local record = self:getTavernRecord(type)
  local lt = record._last_get_time
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    return tl[type]
  else
    return record._left_cnt
  end
end
class.getTavernLeftTimes = getTavernLeftTimes
local function tomd5(self)
  local msg = ed.downmsg.important_data()
  msg._money = self._money
  msg._rmb = self._rmb
  msg._heroes = {}
  for i, h in ipairs(self._heroes) do
    msg._heroes[i] = h
  end
  table.sort(msg._heroes, function(a, b)
    return a._tid < b._tid
  end)
  local itemlist = {}
  for id, amount in pairs(self.equip_qunty) do
    if amount > 0 then
      table.insert(itemlist, {id = id, amount = amount})
    end
  end
  table.sort(itemlist, function(a, b)
    return a.id < b.id
  end)
  msg._items = {}
  for i, v in ipairs(itemlist) do
    msg._items[i] = ed.makebits(11, v.amount, 10, v.id)
  end
  local seriStr = msg:Serialize()
  local sum = ""
  if seriStr then
    sum = md5.sum(seriStr)
  end
  return (string.gsub(sum, ".", function(c)
    return string.format("%02x", string.byte(c))
  end))
end
class.tomd5 = tomd5
local class = {
  mt = {}
}
ed.Hero = class
class.mt.__index = getGetter(class)
class.mt.__newindex = _setter
local function HeroCreate()
  local self = {
    data = nil,
    excavateData = nil,
    crusadeData = nil,
    mercenaryData = nil
  }
  setmetatable(self, class.mt)
  return self
end
ed.HeroCreate = HeroCreate
class.create = HeroCreate
local function initExcavate(self)
  local data = ed.downmsg.hero_dyna()
  data._hp_perc = 10000
  data._mp_perc = 0
  self.excavateData = data
end
class.initExcavate = initExcavate
local setCrusade = function(self, data)
  if not data then
    self.crusadeData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.crusadeData = dyna
end
class.setCrusade = setCrusade
local setExcavate = function(self, data)
  if not data then
    self.excavateData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.excavateData = dyna
end
class.setExcavate = setExcavate
local setup = function(self, data)
  self.data = data
end
class.setup = setup
local hp_perc = function(self, mode)
  mode = mode or "crusade"
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._hp_perc
  end
  if mode == "excavate" and self.excavateData then
    return self.excavateData._hp_perc
  end
end
class.hp_perc = hp_perc
local mp_perc = function(self, mode)
  mode = mode or "crusade"
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._mp_perc
  end
  if mode == "excavate" and self.excavateData then
    return self.excavateData._mp_perc
  end
end
class.mp_perc = mp_perc
local custom_data = function(self, mode)
  mode = mode or "crusade"
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._custom_data
  end
  if mode == "excavate" and self.excavateData then
    return self.excavateData._custom_data
  end
end
class.custom_data = custom_data
local setMercenaryData = function(self, data)
  self.mercenaryData = data
end
class.setMercenaryData = setMercenaryData
local getMercenaryData = function(self)
  return self.mercenaryData
end
class.getMercenaryData = getMercenaryData
local hasEquipment = function(self, slot)
  if self._items and self._items[slot] then
    local equipId = self._items[slot]._item_id or 0
    return equipId > 0 and equipId or nil
  else
    return nil
  end
end
class.hasEquipment = hasEquipment
local resetgs = function(self, gs)
  self._gs = gs
end
class.resetgs = resetgs
local function equip(self, slot)
  local eid = ed.getDataTable("hero_equip")[self._tid][self._rank][string.format("Equip%d ID", slot)]
  self._items[slot]._item_id = eid
end
class.equip = equip
local getItem = function(self, slot)
  self._items = self._items or {}
  self._items[slot] = self._items[slot] or {_item_id = 0, _exp = 0}
  return self._items[slot]
end
class.getItem = getItem
local getEquipid = function(self, slot)
  local item = self:getItem(slot)
  return item._item_id
end
class.getEquipid = getEquipid
local getEquipExp = function(self, slot)
  local item = self:getItem(slot)
  return item[slot]._exp
end
class.getEquipExp = getEquipExp
local function addExp(self, exp)
  local oexp = self._exp
  local olevel = self._level
  self._exp = self._exp + exp
  local levelup_exp = ed.lookupDataTable("Levels", "Exp", self._level)
  ed.player.heroCache = ed.player.heroCache or {}
  ed.player.heroCache[self._tid] = ed.player.heroCache[self._tid] or {}
  local hc = ed.player.heroCache[self._tid]
  hc.preExp = oexp
  hc.preLevel = olevel
  hc.expIncrement = exp
  while true do
    levelup_exp = ed.lookupDataTable("Levels", "Exp", self._level)
    if levelup_exp == 0 or levelup_exp > self._exp  then
      break
    end

  if levelup_exp <= self._exp then
      local levelLimit = ed.playerlimit.heroLevelLimit()
      if levelLimit > self._level then
        self:levelup()
      --DIFF
      else
        if levelup_exp < self._exp then
          hc.expIncrement = (hc.expIncrement or 0) - (self._exp - levelup_exp)
          self._exp = levelup_exp
        end

        break

      end
       --DIFF
    else
      break
    end


   end
--  if olevel ~= self._level or not "" then
--  end
  print(string.format("%s\t exp +%i (%i/%i). Lv%i%s.%s", self:getName(), exp, self._exp, levelup_exp, olevel, olevel == self._level and "" or   (" -> Lv" .. self._level), levelup_exp <= self._exp and "(rank limited)" or ""))
end
class.addExp = addExp
local function getLevelExp(self, addExp)
  local oe = self._exp
  local ol = self._level
  local ee = oe + addExp
  local el = ol
  local levelLimit = ed.playerlimit.heroLevelLimit()
  while true do
    local lue = ed.lookupDataTable("Levels", "Exp", el)
    if not lue then
      return ol, oe
    end
    if ee >= lue then
      if el < levelLimit then
        ee = ee - lue
        el = el + 1
      else
        ee = lue
        break
      end
    else
      break
    end
  end
  return el, ee
end
class.getLevelExp = getLevelExp
local function getName(self)
  return ed.lookupDataTable("Unit", "Name", self._tid)
end
class.getName = getName
local function levelup(self)
  local levelup_exp = math.floor(ed.lookupDataTable("Levels", "Exp", self._level))
  self._exp = self._exp - levelup_exp
  self._level = self._level + 1
  local lsr = ed.ui.baselsr.create("base")
  lsr:report("heroLevelup", {
    hid = self._tid
  })
end
class.levelup = levelup
local evolve = function(self)
  self._stars = self._stars + 1
end
class.evolve = evolve
local function canUpgrade(self)
  for slot = 1, 6 do
    local requirement = ed.lookupDataTable("hero_equip", "Equip" .. slot .. " ID", self._tid, self._rank)
    if self._items[slot] ~= requirement then
      return false
    end
  end
  return self._rank < 12
end
class.canUpgrade = canUpgrade
local function upgrade(self)
  if not canUpgrade(self) then
    EDDebug("YOU SHALL NOT UPGRADE.")
  end
  self._items = {}
  for i = 1, 6 do
    table.insert(self._items, {_item_id = 0, _exp = 0})
  end
  self._rank = self._rank + 1
  for i = 1, 6 do
    local init = ed.lookupDataTable("hero_equip", "Init" .. i .. " ID", self._tid, self._rank)
    self:equip(i, init)
  end
  self:addExp(0)
end
class.upgrade = upgrade
local function getAutoAttackRange(self)
  local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", self._tid)
  return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
end
class.getAutoAttackRange = getAutoAttackRange
local frames = {
  "UI/alpha/HVGA/hero_icon_frame_1.png",
  "UI/alpha/HVGA/hero_icon_frame_2.png",
  "UI/alpha/HVGA/hero_icon_frame_3.png",
  "UI/alpha/HVGA/hero_icon_frame_4.png",
  "UI/alpha/HVGA/hero_icon_frame_5.png",
  "UI/alpha/HVGA/hero_icon_frame_6.png",
  "UI/alpha/HVGA/hero_icon_frame_7.png",
  "UI/alpha/HVGA/hero_icon_frame_8.png",
  "UI/alpha/HVGA/hero_icon_frame_9.png",
  "UI/alpha/HVGA/hero_icon_frame_10.png",
  "UI/alpha/HVGA/hero_icon_frame_11.png",
  "UI/alpha/HVGA/hero_icon_frame_12.png"
}
local function getIconFrame(self)
  return frames[self._rank]
end
class.getIconFrame = getIconFrame
local function getIconFrameByRank(rank)
  return frames[rank]
end
class.getIconFrameByRank = getIconFrameByRank
local name_frames = {
  "UI/alpha/HVGA/herodetail_name_frame_1.png",
  "UI/alpha/HVGA/herodetail_name_frame_2.png",
  "UI/alpha/HVGA/herodetail_name_frame_3.png",
  "UI/alpha/HVGA/herodetail_name_frame_4.png",
  "UI/alpha/HVGA/herodetail_name_frame_5.png",
  "UI/alpha/HVGA/herodetail_name_frame_6.png",
  "UI/alpha/HVGA/herodetail_name_frame_7.png",
  "UI/alpha/HVGA/herodetail_name_frame_8.png",
  "UI/alpha/HVGA/herodetail_name_frame_9.png",
  "UI/alpha/HVGA/herodetail_name_frame_10.png",
  "UI/alpha/HVGA/herodetail_name_frame_11.png",
  "UI/alpha/HVGA/herodetail_name_frame_12.png"
}
local function getIconNameFrame(self)
  return name_frames[self._rank]
end
class.getIconNameFrame = getIconNameFrame
local function getIconNameFrameByRank(rank)
  return name_frames[rank]
end
class.getIconNameFrameByRank = getIconNameFrameByRank
local hero_star = {
  0,
  0,
  1,
  0,
  1,
  2,
  0,
  1,
  2,
  3,
  4,
  0
}
local hero_max_star = {
  0,
  1,
  1,
  2,
  2,
  2,
  4,
  4,
  4,
  4,
  4,
  0
}
local function getHeroStarByRank(rank)
  return hero_star[rank], hero_max_star[rank]
end
class.getHeroStarByRank = getHeroStarByRank
local function getHeroStar(self)
  return hero_star[self._rank], hero_max_star[self._rank]
end
class.getHeroStar = getHeroStar
local name_color = {
  ccc3(254, 251, 241),
  ccc3(248, 255, 62),
  ccc3(96, 172, 243),
  ccc3(255, 128, 255),
  ccc3(255, 152, 72)
}
local function getHeroNameColorByRank(rank)
  if rank == 1 then
    return name_color[1]
  elseif rank >= 2 and rank <= 3 then
    return name_color[2]
  elseif rank >= 4 and rank <= 6 then
    return name_color[3]
  elseif rank >= 7 and rank <= 11 then
    return name_color[4]
  elseif rank == 12 then
    return name_color[5]
  else
    return ccc3(255, 255, 255)
  end
end
class.getHeroNameColorByRank = getHeroNameColorByRank
local function getHeroNameColor(self)
  getHeroNameColor(self._rank)
end
class.getHeroNameColor = getHeroNameColor

--副本战斗，选择英雄，战斗前的最后一个页面
local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.battleprepare = class
local lsr = ed.ui.battlepreparelsr.create()
local min_crusade_level = 20
local pvp_stage = -1
local battlePrepareScope = {}
local payPanel
local bReqMercenary = false
local currentMercenary
local currentMercenaryIndex = 0
local prepareInfo, prepareTimer
local pms = {crusade = "crusade", excavateAttack = "excavate"}
local stageType = function(self, id)
  if not id then
    return nil
  end
  if self.pvpMode then
    if self.pvpMode == "attack" then
      return "pvp"
    else
      return
    end
  end
  local st = ed.getDataTable("Stage")
  local type = ed.stageType(id)
  if ed.isElementInTable(type, {"normal", "elite"}) then
    return "common"
  elseif type == "pvp" then
    return "pvp"
  elseif type == "act" then
    local row = st[id] or {}
    local name = row["Stage Name"]
    if name == T(LSTR("ACTSTAGEGROUP.CRASHED_HILL")) then
      return "nophysical"
    elseif name == T(LSTR("ACTSTAGEGROUP.CURSED_CITY")) then
      return "nomagical"
    elseif name == T(LSTR("BATTLE.VALKYRIE_SHOWDOWN")) then
      return "female"
    else
      return "common"
    end
  else
    return "common"
  end
end
class.stageType = stageType
local fixTeamData = function(self, data)
  local fixData = {}
  for i = 1, #(data or {}) do
    local ih = false
    for j = 1, #fixData do
      if data[i] == fixData[j] then
        ih = true
      end
    end
    if not ih then
      table.insert(fixData, data[i])
    end
  end
  return fixData
end
class.fixTeamData = fixTeamData
local getTeamData = function(self)
  local id = self.stage
  local key = self:stageType(id)
  local data = {}
  if key then
    data = ed.getTeamData(key)
  end
  data = self:fixTeamData(data)
  return data
end
class.getTeamData = getTeamData
local setTeamData = function(self, data)
  local id = self.stage
  local key = self:stageType(id)
  if key then
    data = self:fixTeamData(data)
    ed.setTeamData(key, data)
  end
end
class.setTeamData = setTeamData
local getCurrentTeam = function(self)
  local ct = {}
  local useMercenary = false
  local mercenaryIndex = 0
  for i = 1, #self.team do
    ct[i] = self.team[i].heroIcon.info.id
    if self.team[i].heroIcon.info.mercenary then
      useMercenary = true
      mercenaryIndex = i
    end
  end
  return ct, useMercenary, mercenaryIndex
end
class.getCurrentTeam = getCurrentTeam
local getTeamMemberPos = function(index)
  local ox, oy = 593, 83
  local dx = 100
  return ccp(ox - dx * (index - 1), oy)
end
class.getTeamMemberPos = getTeamMemberPos
local getMercenaryInfo = function(self)
  local id = 0
  local cost = 0
  local name = ""
  if self.hireMercenary then
    return nil
  end
  local bUseMerncenary = false
  for i = 1, #self.team do
    local mercenary = self.team[i].heroIcon.info.mercenary
    if mercenary then
      cost = cost + mercenary.cost
      name = mercenary.owner
      id = self.team[i].heroIcon.info.id
      bUseMerncenary = true
    end
  end
  return bUseMerncenary and cost, name, id or nil
end
local playTeamMemberEffect = function(self, index)
  index = index or 0
  if index >= 1 and index <= 5 then
    self.ui["member_light_" .. index]:stopAllActions()
    local fadein = CCFadeIn:create(0.2)
    local fadeout = CCFadeOut:create(0.2)
    local sequence = CCSequence:createWithTwoActions(fadein, fadeout)
    self.ui["member_light_" .. index]:runAction(sequence)
  else
    for i = 1, 5 do
      self:playTeamMemberEffect(i)
    end
  end
end
class.playTeamMemberEffect = playTeamMemberEffect
local getTeamHero = function(self, index)
  if nil == self.team[index] then
    return
  end
  local mercenaryInfo = self.team[index].heroIcon.info.mercenary
  local heroId = self.team[index].heroIcon.info.id
  local hero
  if mercenaryInfo then
    hero = ed.mercenary.getMercenaryHero(mercenaryInfo.uid, heroId)
  else
    hero = ed.player.heroes[heroId]
  end
  return hero
end
local function refreshgs(self)
  local total = 0
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      total = total + hero._gs
    end
  end
  ed.setString(self.ui.gs, total)
end
class.refreshgs = refreshgs
local setMemberAmount = function(self, amount)
  self.memberIndex = amount
end
class.setMemberAmount = setMemberAmount
local setMemberIndex = function(self, add)
  if add == 1 or add == "+" then
    add = 1
  end
  if add == -1 or add == "-" then
    add = -1
  end
  local memberIndex = self.memberIndex + add
  self:setMemberAmount(memberIndex)
end
class.setMemberIndex = setMemberIndex
local function getBattleHeros(self, newHeroList)
  if newHeroList then
    for i = 1, #newHeroList do
      ed.player:resetHero(newHeroList[i])
    end
  end
  local hero_list = {}
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      table.insert(hero_list, hero)
    end
  end
  return hero_list
end
local function gotoBattle(self)
  local function handler(enemyList, isBot, selfList, enemyDyna, guildInstanceData)
    xpcall(function()
      if not self then
        return
      end
      if tolua.isnull(self.mainLayer) then
        return
      end
      local stage_id = self.stage
      if self.pvpMode == "attack" then
        stage_id = pvp_stage
      end
      ed.stopMusic()
      if stage_id > 0 or self.mode == "excavateAttack" then
        local info = {}
        local stageInfo = ed.getDataTable("Stage")
        info.power = stageInfo[stage_id]["Vitality Cost"]
        info.rpower = stageInfo[stage_id]["Vit Return"]
        ed.player:addVitality(-(info.power - info.rpower))
      end
      local hero_list = getBattleHeros(self, selfList)
      local stage = ed.lookupDataTable("Stage", nil, stage_id)
      local battle = ed.lookupDataTable("Battle", nil, stage_id, 1)
      if self.pvpMode == "attack" and enemyList then
        ed.engine:enterArena(hero_list, enemyList, false, isBot)
      elseif self.mode == "crusade" then
        local selfCrusade = ed.player:collectCrusadeData(hero_list)
        ed.engine:enterCrusade(hero_list, enemyList, isBot, selfCrusade, enemyDyna, stage_id)
      elseif self.mode == "guildInstance" then
        battle = ed.lookupDataTable("Battle", nil, stage_id, guildInstanceData._wave_index)
        ed.engine:enterGuildInstance(stage, hero_list, guildInstanceData)
        ed.popScene()
      elseif self.mode == "excavateAttack" then
        local selfHeroData = ed.player:collectExcavateData(hero_list)
        ed.engine:enterExcavate(hero_list, enemyList, isBot, selfHeroData, enemyDyna, stage_id, self.excavateTypeid)
      else
        ed.engine:enterStage(stage, hero_list)
        ed.popScene()
      end
      local extraInfo = {}
      if self.mode == "crusade" then
        extraInfo.crusadeInfo = {}
      elseif self.pvpMode then
        extraInfo.pvpInfo = {
          pvpMode = self.pvpMode
        }
      elseif self.mode == "guildInstance" then
        extraInfo.guildInstanceInfo = {}
      elseif self.mode == "excavateAttack" then
        extraInfo.excavateInfo = {}
      end
      ed.scene:reset(stage, battle, extraInfo)
      ed.replaceScene(ed.scene)
      ed.battleDataCache = {
        gwMode = self.GWMode,
        actType = self.actType,
        heroLimit = self.heroLimit
      }
    end, EDDebug)
  end
  return handler
end
class.gotoBattle = gotoBattle
local function doPvp(self)
  local function handler(force)
    lsr:report("clickgo")	
    if #(self.team or {}) == 0 then
      ed.showToast(T(LSTR("BATTLEPREPARE.PLEASE_SELECT_BATTLE_HERO")))
      return
    end
    if not force then
      self:lackHeroConfirm(function()
        handler(true)
      end)
      return
    end
    local teamData = {}
    for i = 1, #self.team do
      teamData[i] = self.team[i].heroIcon.info.id
    end
    self:setTeamData(teamData)
    local hero_list = {}
    for i = 1, #self.team do
      table.insert(hero_list, self.team[i].heroIcon.info.id)
    end
    ed.netreply.gotoPvpBattleReply = self:gotoBattle()
    local msg = ed.upmsg.ladder()
    msg._start_battle = {}
    msg._start_battle._attack_lineup = hero_list
    msg._start_battle._oppo_user_id = self.pvpEnemyId
    ed.send(msg, "ladder")
  end
  return handler
end
local function doGo(self)
  local function handler(force)
    lsr:report("clickgo")
     --add by xinghui
    if --[[ed.tutorial.checkDone("gotoBattle")== false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["gotoBattle"].id)
    end
    --
    ed.endTeach("selectHero")
       
    ed.endTeach("gotoBattle")
    local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
    if ul > ed.player:getLevel() then
      ed.showToast(T(LSTR("BATTLEPREPARE.REACH_LEVEL__D_TO_ENTER_THIS_CHAPTER"), ul))
      return
    end
    if #(self.team or {}) == 0 then
      ed.showToast(T(LSTR("BATTLEPREPARE.PLEASE_SELECT_BATTLE_HERO")))
      return
    end
    if not force then
      self:lackHeroConfirm(function()
        handler(true)
      end)
      return
    end
    local teamData = {}
    for i = 1, #self.team do
      local mercenaryData = self.team[i].heroIcon.info.mercenary
      if mercenaryData == nil then
        table.insert(teamData, self.team[i].heroIcon.info.id)
      end
    end
    self:setTeamData(teamData)
    local hero, bUseMercenary = getCurrentTeam(self)
    local stageid = self.stage
    local type = ed.stageType(stageid)
    if ed.isElementInTable(type, {"normal", "elite"}) then
      ed.netreply.enterStage = self:gotoBattle()
      local msg = ed.upmsg.enter_stage()
      msg._stage_id = stageid
      ed.delaySend(ed.player:tomd5(), "important_data_md5", true)
      ed.send(msg, "enter_stage")
    elseif type == "act" then
      ed.netreply.enterStage = self:gotoBattle()
      local msg = ed.upmsg.enter_act_stage()
      msg._stage = stageid
      msg._stage_group = ed.getDataTable("Stage")[stageid]["Stage Group"]
      ed.delaySend(ed.player:tomd5(), "important_data_md5", true)
      ed.send(msg, "enter_act_stage")
    end
  end
  return handler
end
class.doGo = doGo
local function selectDefendHeros(self)
  local function handler()
    local team = getCurrentTeam(self)
    if #team > 0 then
      local msg = ed.upmsg.ladder()
      msg._set_lineup = {}
      msg._set_lineup._lineup = team
      ed.send(msg, "ladder")
      ed.popScene()
    else
      ed.showToast(T(LSTR("BATTLEPREPARE.DEFENSIVE_TEAM_CAN_NOT_BE_EMPTY")))
    end
  end
  return handler
end
local function doCrusade(self)
  local function handler()
    local team, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    currentMercenaryIndex = mercenaryIndex
    if #team > 0 then
      ed.netreply.gotoCrusadeBattleReply = self:gotoBattle()
      local msg = ed.upmsg.tbc()
      msg._start_bat = {}
      msg._start_bat._heroids = team
      msg._start_bat._use_hire = bUseMercenary == true and 1 or 0
      ed.delaySend(ed.player:tomd5(), "important_data_md5", true)
      ed.send(msg, "tbc")
      ed.ui.battleprepare.cruadeTeam = team
    end
  end
  return handler
end
local function doGuildInstance(self)
  local function handler(force)
    local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
    if ul > ed.player:getLevel() then
      ed.showToast(string.format(T(LSTR("BATTLEPREPARE.REACH_LEVEL__D_TO_ENTER_THIS_CHAPTER")), ul))
      return
    end
    if #(self.team or {}) == 0 then
      ed.showToast(T(LSTR("BATTLEPREPARE.PLEASE_SELECT_BATTLE_HERO")))
      return
    end
    local h, m = ed.time2HMS()
    if tonumber(h) >= 5 and tonumber(h) <= 7 then
      ed.showToast(T(LSTR(LSTR("battleprepare.1.10.1.001"))))
      return
    end
    if not force then
      self:lackHeroConfirm(function()
        handler(true)
      end)
      return
    end
    ed.netreply.enterGuildInstance = self:gotoBattle()
    local hero, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    local msg = ed.upmsg.guild()
    msg._instance_start = {}
    msg._instance_start._stage_id = self.stage
    ed.delaySend(ed.player:tomd5(), "important_data_md5", true)
    ed.send(msg, "guild")
    ed.ui.battleprepare.guildInstanceTeam = hero
    ed.ui.battleprepare.guildInstanceTeam[mercenaryIndex] = nil
  end
  return handler
end
class.doGuildInstance = doGuildInstance
local lackHeroConfirm = function(self, callback)
  if ed.player:getHeroAmount() >= 5 then
    if 5 > #(self.team or {}) then
      local info = {
        text = T(LSTR("battleprepare.1.10.1.002")),
        rightHandler = callback
      }
	--modify by xinghui
	  if self.pvpMode then
		 ed.showConfirmDialog(info, nil, self.pvpMode)
	  else
	     ed.showConfirmDialog(info)
	  end		
    else
      callback()
    end
  else
    callback()
  end
end
class.lackHeroConfirm = lackHeroConfirm
local doChangeExcavateTeam = function(self)
  local function handler()
    local data = self:getCurrentTeam()
    local preData = {}
    local team = ed.ui.excavate.getTeamData({
      excavateId = self.excavateid,
      teamId = ed.getUserid()
    })
    for k, v in pairs((team or {})._hero_bases or {}) do
      table.insert(preData, v._tid)
    end
    local function handler(result)
      if result == "success" then
        ed.player:releaseHeroes(preData)
        ed.player:sendHeroesMining(data)
        if self.excavateCallback then
          self.excavateCallback(data)
        end
        ed.popScene()
      elseif result == "failed" then
        ed.showToast(T(LSTR("BATTLEPREPARE.SET_THE_DEFENSIVE_TEAM_FAILED_")))
      elseif result == "expired" then
        ed.ui.excavate.removeExcavate(self.excavateid)
        ed.showToast(T(LSTR("BATTLEPREPARE.THE_TREASURE_HAS_EXPIRED_")))
        ed.popScene()
      elseif result == "fall" then
        ed.ui.excavate.removeExcavate(self.excavateid)
        ed.showToast(T(LSTR("BATTLEPREPARE.THE_TREASURE_HAD_BEEN_LOST_")))
        ed.popScene()
      end
    end
    ed.registerNetReply("set_excavate_team", handler)
    if #data < 1 then
      ed.ui.excavategiveup.pop(self.excavateid, function()
        ed.popScene()
      end, "setteam")
      return
    end
    local msg = ed.upmsg.excavate()
    local set = ed.upmsg.set_excavate_team()
    set._excavate_id = self.excavateid
    set._tid = data
    msg._set_excavate_team = set
    ed.send(msg, "excavate")
  end
  return handler
end
class.doChangeExcavateTeam = doChangeExcavateTeam
local function doExcavateAttack(self, force)
  local herolist, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
  if #herolist < 1 then
    ed.showToast(LSTR("BATTLEPREPARE.PLEASE_SELECT_BATTLE_HERO"))
    return
  end
  if not force then
    self:lackHeroConfirm(function()
      self:doExcavateAttack(true)
    end)
    return
  end
  local enemy = self.excavateEnemy
  local enemyList, enemyDyna = {}, {}
  for i = 1, #enemy do
    local base = enemy[i].base
    local dyna = enemy[i].dyna
    table.insert(enemyList, base)
    table.insert(enemyDyna, dyna)
  end
  local handler = self:gotoBattle()
  local function replyHandler(heroes, dynas)
    ed.player.excavateAttackId = self.excavateid
    local data = ed.ui.excavate.getData(self.excavateid)
    if data._state ~= "battle" then
      data._state = "battle"
      data._state_end_ts = ed.ui.excavate.attackTimeout + ed.getServerTime()
    end
    for i, v in ipairs(heroes or {}) do
      enemyList[i] = v
    end
    if dynas then
      for i, v in ipairs(dynas or {}) do
        if dynas[i] then
          enemyDyna[i] = dynas[i]
        end
      end
    end
    handler(enemyList, self.isExcavateBot, nil, enemyDyna)
  end
  ed.registerNetReply("goto_excavate_battle", replyHandler)
  local msg = ed.upmsg.excavate()
  local esb = ed.upmsg.excavate_start_battle()
  esb._heroids = herolist
  esb._team_id = self.excavateTeamid
  esb._team_svr_id = self.excavateTeamSvrid
  esb._excavate_id = self.excavateid
  esb._use_hire = bUseMercenary == true and 1 or 0
  msg._excavate_start_battle = esb
  ed.delaySend(ed.player:tomd5(), "important_data_md5", true)
  ed.send(msg, "excavate")
  ed.ui.battleprepare.excavateTeam = herolist
  ed.ui.battleprepare.excavateTeam[mercenaryIndex] = nil
end
class.doExcavateAttack = doExcavateAttack
local function requestBattle(self)
  if self.pvpMode == "defend" then
    return selectDefendHeros(self)()
  elseif self.pvpMode == "attack" then
    return doPvp(self)()
  elseif self.mode == "crusade" then
    return doCrusade(self)()
  elseif self.mode == "guildInstance" then
    return doGuildInstance(self)()
  elseif self.mode == "excavateChange" then
    return self:doChangeExcavateTeam()()
  elseif self.mode == "excavateAttack" then
    self:doExcavateAttack()
    return
  else
    return doGo(self)()
  end
end
local function conformPay()
  if currentMercenary then
    local msg = ed.upmsg.guild()
    msg._hire_hero = {}
    msg._hire_hero._uid = currentMercenary.uid
    msg._hire_hero._heroid = currentMercenary.tid
    if prepareInfo.mode == "crusade" then
      msg._hire_hero._from = "tbc"
    elseif ed.isElementInTable(prepareInfo.mode, {
      "excavateAttack"
    }) then
      msg._hire_hero._from = "excav"
    else
      if prepareInfo.mode == "guildInstance" then
        msg._hire_hero._stage_id = prepareInfo.stage_id
      end
      msg._hire_hero._from = "stage"
    end
    ed.send(msg, "guild")
  end
  payPanel:setVisible(false)
end
class.conformPay = conformPay
local function cancelPay()
  payPanel:setVisible(false)
end
class.cancelPay = cancelPay
local function doNow(self)
  local cost, name, id = getMercenaryInfo(self)
  if cost then
    if cost > ed.player._money then
      ed.showHandyDialog("useMidas")
      return
    end
    if payPanel == nil then
      payPanel = panelMeta:new(self, EDTables.guildConfig.payUIRes)
    end
    ed.setString(payPanel.payNum, cost)
    payPanel:setVisible(true)
    payPanel.hintText:setString(T(LSTR("BATTLEPREPARE.TEXT_DARK_WHITE_YOU_CAN_NOT_HIRE_FROM_TEXT_DARK_YELLOW__S_TEXT_DARK_WHITE_OTHER_HEROES"), name))
    local heroName = ""
    local ut = ed.getDataTable("Unit")
    local row = ut[id]
    if row then
      heroName = row["Display Name"]
    end
    payPanel.hintText2:setString(T(LSTR("BATTLEPREPARE.TEXT_DARK_WHITE_HIRED_FROM_TEXT_DARK_YELLOW__S_TEXT_DARK_WHITE_HEROES_TEXT_DARK_YELLOW__S_TEXT_DARK_WHITE_NEED_TO_PAY_COMMISSION"), name, heroName))
  else
    requestBattle(self)
  end
end
local getMercenaryIcon = function(self, tid, uid)
  if tid == nil then
    return
  end
  for i, v in ipairs(self.mercenaryIcon) do
    local mercenaryInfo = self.listData.mercenary[i]:getMercenaryData()
    if self.listData.mercenary[i]._tid == tid and mercenaryInfo ~= nil and mercenaryInfo._uid == uid then
      return self.mercenaryIcon[i]
    end
  end
end
local function getHeroIcon(self, tid, bmercenary, uid)
  if bmercenary then
    return getMercenaryIcon(self, tid, uid)
  else
    return self.heroIcon[tid]
  end
end
local function getHeroIconByIndex(self, index)
  local heroInfo = self.team[index].heroIcon
  if heroInfo == nil then
    return
  end
  local mercenaryInfo = heroInfo.info.mercenary
  local uid = mercenaryInfo and mercenaryInfo.uid or nil
  local tid = heroInfo.info.id
  local bmercenary = mercenaryInfo ~= nil
  return getHeroIcon(self, tid, bmercenary, uid)
end
local function orderTeam(self, tid, isAdd, mercenary, uid)
  if isAdd == nil then
    return
  end
  if isAdd and self.memberIndex <= 5 then
    local heroIcon = getHeroIcon(self, tid, mercenary, uid)
    if heroIcon == nil then
      return
    end
    local maxRange = heroIcon.info.maxRange
    if #self.team == 0 or maxRange > self.team[#self.team].heroIcon.info.maxRange then
      local index = #self.team + 1
      table.insert(self.team, {heroIcon = heroIcon})
      heroIcon.memberid = index
      self:setMemberIndex(1)
      return index
    end
    if #self.team >= 1 and maxRange <= self.team[1].heroIcon.info.maxRange then
      table.insert(self.team, 1, {heroIcon = heroIcon})
      heroIcon.memberid = 1
      for j = #self.team, 2, -1 do
        local move = CCMoveTo:create(0.2, class.getTeamMemberPos(j))
        move = CCEaseBackInOut:create(move)
        self.team[j].icon.icon:stopAllActions()
        self.team[j].icon.icon:runAction(move)
        local teamIcon = getHeroIconByIndex(self, j)
        teamIcon.memberid = j
      end
      self:setMemberIndex(1)
      return 1
    end
    for i = #self.team, 2, -1 do
      if maxRange <= self.team[i].heroIcon.info.maxRange and maxRange >= self.team[i - 1].heroIcon.info.maxRange then
        table.insert(self.team, i, {heroIcon = heroIcon})
        heroIcon.memberid = i
        for j = #self.team, i + 1, -1 do
          local move = CCMoveTo:create(0.2, class.getTeamMemberPos(j))
          move = CCEaseBackInOut:create(move)
          self.team[j].icon.icon:stopAllActions()
          self.team[j].icon.icon:runAction(move)
          local teamIcon = getHeroIconByIndex(self, j)
          teamIcon.memberid = j
        end
        self:setMemberIndex(1)
        return i
      end
    end
  else
    local heroIcon = getHeroIcon(self, tid, mercenary, uid)
    local memberid = heroIcon.memberid
    heroIcon.memberid = nil
    table.remove(self.team, memberid)
    self:setMemberIndex(-1)
    for i = memberid, #self.team do
      local icon = self.team[i].icon.icon
      local move = CCMoveTo:create(0.2, class.getTeamMemberPos(i))
      move = CCEaseBackInOut:create(move)
      icon:stopAllActions()
      icon:runAction(move)
      self.team[i].heroIcon.memberid = i
    end
  end
end
class.orderTeam = orderTeam
local function addTeamMember(self, tid, mercenary, uid)
  if self.isDestroyTeamMember[tid] then
    return
  end
  if self.memberIndex > 5 then
    lsr:report("clickAddHeroTeamFilled")
    self:playTeamMemberEffect(0)
    return
  end
  for i = 1, #self.team do
    local id = self.team[i].heroIcon.info.id
    if id == tid then
      ed.showToast(T(LSTR("BATTLEPREPARE.HEROES_OF_THE_SAME_NAME_CAN_NOT_BE_USED_IN_ONE_FIGHT")))
      return
    end
  end
  lsr:report("clickAddHero", {hid = tid})
  local heroIcon = getHeroIcon(self, tid, mercenary, uid)
  if heroIcon == nil then
    return
  end
  if mercenary == true then
    if currentMercenary == nil then
      currentMercenary = {}
      currentMercenary.uid = uid
      currentMercenary.tid = tid
    else
      ed.showToast(T(LSTR("BATTLEPREPARE.ONLY_ONE_HERO_CAN_BE_HIRED_IN_EACH_FIGHT")))
      return
    end
  end
  local icon = heroIcon.icon
  icon:setScale(1)
  local oripos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  local orix, oriy = oripos.x, oripos.y
  local nicon
  if mercenary then
    local iconInfo = heroIcon.info
    nicon = ed.readhero.createIcon({
      id = iconInfo.id,
      rank = iconInfo.rank,
      hp = iconInfo.hp,
      mp = iconInfo.mp,
      level = iconInfo.level,
      stars = iconInfo.stars,
      maxRange = iconInfo.maxRange,
      mercenary = {}
    })
  else
    nicon = ed.readhero.createIconByID(tid, {
      hmMode = pms[self.mode],
      stateIgnoreList = self.excavateDefendTeam,
      state = not ed.isElementInTable(self.mode, {
        "excavateChange"
      }) and "idle" or nil
    })
  end
  nicon.icon:setPosition(ccp(orix, oriy))
  self.mainLayer:addChild(nicon.icon, 30)
  local index = self:orderTeam(tid, true, mercenary, uid)
  self:playTeamMemberEffect(index)
  self.team[index].icon = nicon
  local action = CCMoveTo:create(0.2, class.getTeamMemberPos(index))
  action = CCEaseSineOut:create(action)
  nicon.icon:runAction(action)
  heroIcon:showSelectTag()
  self:refreshgs()
end
class.addTeamMember = addTeamMember
local function destroyTeamMember(self, tid, skipAnim, mercenary, uid)
  local heroIcon = getHeroIcon(self, tid, mercenary, uid)
  local memberid = heroIcon.memberid
  if memberid == nil then
    return
  end
  if mercenary == true then
    currentMercenary = nil
  end
  local member = self.team[memberid].icon
  local icon = member.icon
  local licon = heroIcon.icon
  self.isDestroyTeamMember[tid] = true
  heroIcon:deleteSelectTag()
  self:orderTeam(tid, false, mercenary, uid)
  if not skipAnim then
    local posx, posy = licon:getPosition()
    local epos = licon:getParent():convertToWorldSpace(ccp(posx, posy))
    local bx, by = icon:getPosition()
    local ex, ey = epos.x, epos.y
    local action = CCMoveTo:create(0.3, ccp((bx + ex) / 2, (by + ey) / 2))
    action = CCEaseSineIn:create(action)
    local fade = CCFadeOut:create(0.3)
    local spawn = CCSpawn:createWithTwoActions(action, fade)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(icon) then
          icon:removeFromParentAndCleanup(true)
          self.isDestroyTeamMember[tid] = nil
        end
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(spawn, func)
    icon:runAction(sequence)
  else
    icon:removeFromParentAndCleanup(true)
    self.isDestroyTeamMember[tid] = nil
  end
  heroIcon.memberid = nil
  self:refreshgs()
end
class.destroyTeamMember = destroyTeamMember
local function doTeamTouch(self)
  local pressid
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.team do
        local icon = self.team[i].icon.icon
        if tolua.isnull(icon) then
          return
        end
        if icon:numberOfRunningActions() > 0 then
          return
        end
        if ed.containsPoint(icon, x, y) then
          pressid = i
          icon:setScale(0.95)
        end
      end
    elseif event == "ended" then
      local id = pressid
      pressid = nil
      if id then
        local icon = self.team[id].icon.icon
        icon:setScale(1)
        if ed.containsPoint(icon, x, y) then
          lsr:report("clickTeamRemoveHero")
          local mercenaryData = self.team[id].heroIcon.info.mercenary
          local uid = mercenaryData and mercenaryData.uid or nil
          self:destroyTeamMember(self.team[id].heroIcon.info.id, false, mercenaryData ~= nil, uid)
        end
      end
    end
  end
  return handler
end
class.doTeamTouch = doTeamTouch
local doPressInList = function(self)
  local function handler(x, y)
    if self.clid == "mercenary" then
      if self.mercenaryIcon == nil then
        return
      end
      for i = 1, #self.mercenaryIcon do
        local icon = self.mercenaryIcon[i].icon
        if not icon then
          return
        end
        if ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          return i
        end
      end
      return
    end
    for i = 1, #(self.listData[self.clid] or {}) do
      if not (self.heroIcon or {})[self.listData[self.clid][i]._tid] then
        return
      end
      if ed.containsPoint(self.heroIcon[self.listData[self.clid][i]._tid].icon, x, y) then
        self.heroIcon[self.listData[self.clid][i]._tid].icon:setScale(0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressInList = doPressInList
local cancelPressInList = function(self)
  local function handler(x, y, id)
    if self.clid == "mercenary" then
      self.mercenaryIcon[id].icon:setScale(1)
    else
      self.heroIcon[self.listData[self.clid][id]._tid].icon:setScale(1)
    end
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local cancelClickInList = function(self)
  local function handler(x, y, id)
    if self.clid == "mercenary" then
      self.mercenaryIcon[id].icon:setScale(1)
    else
      self.heroIcon[self.listData[self.clid][id]._tid].icon:setScale(1)
    end
  end
  return handler
end
class.cancelClickInList = cancelClickInList
local function checkCondition(self, hero, clid, id)
  if nil == hero then
    return false
  end
  if clid == "mercenary" then
    local hp_perc = hero:hp_perc(pms[self.mode])
    if nil ~= hp_perc and hp_perc <= 0 then
      ed.showToast(T(LSTR("BATTLEPREPARE.THIS_HERO_HAS_BEEN_KILLED_CAN_NOT_PARTICIPATE")))
      return false
    end
    local mercenaryInfo = self.listData[self.clid][id]:getMercenaryData()
    if mercenaryInfo._sort then
      if mercenaryInfo._sort == "bHired" then
        ed.showToast(T(LSTR("BATTLEPREPARE.THIS_HERO_HAS_BEEN_KILLED_CAN_NOT_PARTICIPATE")))
        return false
      end
      if mercenaryInfo._sort == "bLevel" then
        ed.showToast(T(LSTR("BATTLEPREPARE.PLEASE_SELECT_BATTLE_HERO")))
        return false
      end
    end

  else
    if self.pvpMode == "defend" then
      return true
    end
    local hp_perc = hero:hp_perc(pms[self.mode])
    if nil ~= hp_perc then
      if hp_perc <= 0 then
        ed.showToast(T(LSTR("BATTLEPREPARE.THIS_HERO_HAS_BEEN_KILLED_CAN_NOT_PARTICIPATE")))
        return false
      end
      if self.mode == "crusade" and hero._level < min_crusade_level then
        ed.showToast(T(LSTR("BATTLEPREPARE.LESS_THAN__D_LEVEL_HERO_CAN_NOT_PARTICIPATE"), min_crusade_level))
        return false
      end
    end
    if ed.isElementInTable(self.mode, {
      "excavateChange"
    }) then
    if hero._state == "hire" then
      ed.showToast(T(LSTR("BATTLEPREPARE.THE_HERO_IS_IN_GARRISON_CAMP_CAN_NOT_PARTICIPATE")))
      return false
    elseif not ed.isElementInTable(hero._tid, self.excavateDefendTeam) and hero._state == "mining" then
      local info = {
        text = LSTR("BATTLEPREPARE.THE_HEROES_ARE_MINING_THE_TREASURE_DO_YOU_WANT_TO_RECALL_NOW_"),
        rightHandler = function()
          ed.ui.excavate.doWithDrawHero(hero._tid, function()
            self.heroIcon[hero._tid]:setStateVisible(false)
          end)
        end
      }
      ed.showConfirmDialog(info)
      return false
    end
    end
    if ed.isElementInTable(self.mode, {
      "excavateChange",
      "excavateAttack"
    }) then
      local limit = ed.parameter.join_excavate_hero_level_limit
      if limit > hero._level then
        ed.showToast(T(LSTR("BATTLEPREPARE.HERO_LEVEL_IS_INSUFFICIENT_TO_PLAY_"), limit))
        return false
      end
    end
  end
  return true
end
local function doClickInList(self)
  local function handler(x, y, id)
    local tid = self.listData[self.clid][id]._tid
    if false == checkCondition(self, self.listData[self.clid][id], self.clid, id) then
      return
    end
    if self.clid == "mercenary" then
      local mercenaryInfo = self.listData[self.clid][id]:getMercenaryData()
      local uid = mercenaryInfo and mercenaryInfo._uid or nil
      if not self.mercenaryIcon[id].isSelected then
        self:addTeamMember(self.listData[self.clid][id]._tid, true, uid)
      else
        self:destroyTeamMember(self.listData[self.clid][id]._tid, false, true, uid)
      end
      return
    end
    if self.isAddHeroTutorial and tid == 4 then
      ed.endTeach("addHeroToTeam")
      self.isAddHeroTutorial = nil
    end
    if self.tutorialSelectHeroId then
      if self.clid ~= "all" then
        self:doChangeList("all")
      end
      local isCancel = false
      for i = 1, #self.tutorialSelectHeroId do
        if self.tutorialSelectHeroId[i] == id then
          table.remove(self.tutorialSelectHeroId, i)
          isCancel = true
          break
        end
        if i == #self.tutorialSelectHeroId then
            --add by xinghui:send dot info when select second and third hero
            if --[[ed.tutorial.checkDone("selectHero")== false--]] ed.tutorial.isShowTutorial then
                ed.sendDotInfoToServer(ed.tutorialres.t_key["selectHero"].id)
            end
            --
          table.insert(self.tutorialSelectHeroId, id)
        end
      end
      if #self.tutorialSelectHeroId == 0 then
        --add by xinghui:send dot info when click first hero
        if --[[ed.tutorial.checkDone("selectHero")== false--]] ed.tutorial.isShowTutorial then
            ed.sendDotInfoToServer(ed.tutorialres.t_key["selectHero"].id)
        end
        --
        table.insert(self.tutorialSelectHeroId, id)
      end
      if #self.tutorialSelectHeroId == 3 then
        ed.endTeach("selectHero")
        ed.teach("gotoBattle", self.ui.go, self.mainLayer)
      elseif not isCancel then
        for i = 1, 3 do
          local isThis = true
          for j = 1, #self.tutorialSelectHeroId do
            if i == self.tutorialSelectHeroId[j] then
              isThis = false
              break
            end
          end
          if self.listData[self.clid][i] then
            local ntid = self.listData[self.clid][i]._tid
            if isThis and not self.hasSelectHeroAmount[ntid] then
              local size = self.heroIcon[ntid].icon:getContentSize()
              ed.teach("selectHero", ccp(size.width / 2, size.height / 2), size.width / 2, self.heroIcon[ntid].icon, {
                self.heroIcon[ntid].icon,
                self.mainLayer
              }, true)
              self.hasSelectHeroAmount[ntid] = true
              break
            end
          end
        end
      end
    end
    if not self.heroIcon[self.listData[self.clid][id]._tid].isSelected then
      self:addTeamMember(self.listData[self.clid][id]._tid)
    else
      lsr:report("clickHeadRemoveHero")
      self:destroyTeamMember(self.listData[self.clid][id]._tid)
    end
  end
  return handler
end
class.doClickInList = doClickInList
local addListTitle = function(self)
  if self.listTitle then
    self.draglist.listLayer:removeChild(self.listTitle, true)
  end
  local listTitle
  if self.mode == "crusade" then
    if self.clid == "mercenary" then
      listTitle = ed.createLabelWithFontInfo(T(LSTR("BATTLEPREPARE.YOU_CAN_CHOOSE_TO_HIRE_A_HERO_DURING_EVERY_EXPEDITION")), "title_yellow")
    else
      listTitle = ed.createLabelWithFontInfo(T(LSTR("BATTLEPREPARE.LEVEL_20+_HEROES_CAN_PARTICIPATE_IN_THE_EXPEDITION")), "title_yellow")
    end
  elseif self.mode == "excavateAttack" then
    listTitle = ed.createLabelWithFontInfo(T(LSTR("BATTLEPREPARE.MORE_THAN_LEVEL_35_HEROES_CAN_PARTICIPATE_IN_THE_TREASURE_CRYPT_BATTLE_")), "title_yellow")
  elseif self.mode == "excavateChange" then
    listTitle = ed.createLabelWithFontInfo(T(LSTR("BATTLEPREPARE.MORE_THAN_LEVEL_35_HEROES_CAN_MINING_TREASURES_GARRISON_MORE_HEROES_TO_MINE_MORE_QUICKLY_")), "title_yellow")
  elseif self.mode == "guildInstance" then
    listTitle = ed.createLabelWithFontInfo(T(LSTR("battleprepare.1.10.1.003"), self.prepareTime), "title_yellow")
  elseif ed.stageType(self.stage) == "act" then
    local st = ed.getDataTable("Stage")
    local row = st[self.stage] or {}
    local name = row["Stage Name"]
    local text
    if name == T(LSTR("ACTSTAGEGROUP.CRASHED_HILL")) then
      text = T(LSTR("ACTSTAGEGROUP.RECOMMENDED_TO_CHOOSE_A_MAGIC_DAMAGE_HERO"))
    elseif name == T(LSTR("ACTSTAGEGROUP.CURSED_CITY")) then
      text = T(LSTR("ACTSTAGEGROUP.RECOMMENDED_TO_CHOOSE_A_PHYSICAL_DAMAGE_HERO"))
    elseif name == T(LSTR("BATTLE.VALKYRIE_SHOWDOWN")) then
      text = T(LSTR("ACTSTAGEGROUP.MUST_CHOOSE_A_FEMALE_HERO"))
    end
    if text then
      listTitle = ed.createLabelWithFontInfo(text, "title_yellow")
    end
  end
  if listTitle then
    listTitle:setPosition(ccp(400, 430))
    self.draglist:addItem(listTitle)
    self.listTitle = listTitle
  end
end
local sortHeroByLevel = function(mercenaryHeros)
  local levelMercenary = function(hero)
    return hero._level
  end
  table.sort(mercenaryHeros, function(a, b)
    return levelMercenary(a) > levelMercenary(b)
  end)
end
local function sortMercenaryHeros(data)
  local list, blist, mlist = {}, {}, {}
  for i, v in ipairs(data) do
    if v.mercenaryData._sort == "cHired" then
      table.insert(blist, v)
    else
      table.insert(mlist, v)
    end
  end
  sortHeroByLevel(blist)
  sortHeroByLevel(mlist)
  for i, v in ipairs(blist) do
    table.insert(list, v)
  end
  for i, v in ipairs(mlist) do
    table.insert(list, v)
  end
  return list
end
local function refreshMercenaryList(self, data)
  if nil == data then
    return
  end
  local heros = ed.readhero.getAllListWithLimit(self.heroLimit or {}, data)
  local heros = sortMercenaryHeros(heros)
  self.listData.mercenary = heros
  self:registerUpdateHandler("asyncCreateMercenary", self:asyncCreateMercenary())
end
local refreshMercenaryIcon = function(self, money)
  if self.mercenaryIcon then
    for i, v in ipairs(self.mercenaryIcon) do
      local mercenaryInfo = v.info.mercenary
      if mercenaryInfo and money > mercenaryInfo.cost and v.costLabel then
        ed.setLabelFontInfo(v.costLabel, "normal_button")
      end
    end
  end
end
local function onMercenaryList(self)
  if self.hireMercenary ~= nil then
    return
  end
  if ed.player:getGuildId() == 0 then
    return
  end
  bReqMercenary = true
  local msg = ed.upmsg.guild()
  msg._query_hires = {}
  if prepareInfo.mode == "crusade" then
    msg._query_hires._from = "tbc"
  elseif ed.isElementInTable(prepareInfo.mode, {
    "excavateAttack"
  }) then
    msg._query_hires._from = "excav"
  else
    msg._query_hires._from = "stage"
  end
  ed.send(msg, "guild")
end
local function doChangeList(self, id)
  lsr:report("clickChangeList")
  ed.breakTeach("addHeroToTeam")
  local preList = self.clid or "all"
  if id == (self.clid or "all") then
    return
  end
  self.clid = id
  self.listButtonSelect[preList]:setVisible(false)
  self.listButtonSelect[id]:setVisible(true)
  ed.setLabelColor(self.listLabel[id], ccc3(230, 190, 76))
  ed.setLabelColor(self.listLabel[preList], ccc3(196, 187, 170))
  if id == "mercenary" and bReqMercenary == false then
    onMercenaryList(self)
    if ed.player:getGuildId() ~= 0 then
      ed.endTeach("firstMercenary")
    end
  end
  addListTitle(self)
  self:createList(self.listData[id] or {})
end
class.doChangeList = doChangeList
local doChangeListTouch = function(self)
  local pressid
  local function handler(event, x, y)
    if event == "began" then
      for k, v in pairs(self.listButton) do
        if not self.listButtonSelect[k]:isVisible() and self.listButton[k]:isVisible() and ed.containsPoint(self.listButton[k], x, y) then
          pressid = k
          self.listButtonSelect[k]:setVisible(true)
          ed.setLabelColor(self.listLabel[k], ccc3(230, 190, 76))
          break
        end
      end
    elseif event == "ended" then
      local id = pressid
      pressid = nil
      if id then
        self.listButtonSelect[id]:setVisible(false)
        ed.setLabelColor(self.listLabel[id], ccc3(196, 187, 170))
        if ed.containsPoint(self.listButton[id], x, y) then
          self:doChangeList(id)
        end
      end
    end
  end
  return handler
end
class.doChangeListTouch = doChangeListTouch
local function doClickBack(self)
  lsr:report("clickBack")
  ed.popScene()
end
class.doClickBack = doClickBack
local doBackButtonTouch = function(self)
  local isPress
  local ui = self.ui
  local button = ui.back
  local press = ui.back_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        self:doClickBack()
      end
    end
  end
  return handler
end
class.doBackButtonTouch = doBackButtonTouch
local function doGoButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.go
  local press = ui.go_press
  local point
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        press:setVisible(true)
        isPress = true
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        if not point then
          doNow(self)
          point = ed.getMillionTime()
        elseif ed.getMillionTime() - point >= 0.5 then
          doNow(self)
          point = ed.getMillionTime()
        end
      end
    end
  end
  return handler
end
class.doGoButtonTouch = doGoButtonTouch
local doMainLayerTouch = function(self)
  local backTouch = self:doBackButtonTouch()
  local goTouch = self:doGoButtonTouch()
  local changeListTouch = self:doChangeListTouch()
  local teamTouch = self:doTeamTouch()
  local function handler(event, x, y)
    xpcall(function()
      if not self.hidePromt and event == "began" and ed.containsPoint(self.ui.bg, x, y) then
        local fade = CCFadeOut:create(0.2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            if self and self.ui and not tolua.isnull(self.ui.promtContainer) then
              self.ui.promtContainer:removeFromParentAndCleanup(true)
            end
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(fade, func)
        self.ui.promtContainer:runAction(sequence)
        self.hidePromt = true
      end
      backTouch(event, x, y)
      goTouch(event, x, y)
      changeListTouch(event, x, y)
      teamTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function loadMecenaryHero(self, index)
  if index < 1 then
    return
  end
  if self.mercenaryIcon == nil then
    self.mercenaryIcon = {}
  end
  if index > #self.listData.mercenary then
    self:removeUpdateHandler("asyncCreateMercenary")
    return
  end
  local data = self.listData.mercenary[index]
  local maxRange = ed.readhero.getHeroMaxRange(data._tid)
  local mercenaryData = data:getMercenaryData()
  local hero = ed.readhero.createIcon({
    id = data._tid,
    rank = data._rank,
    level = data._level,
    stars = data._stars,
    maxRange = maxRange,
    hp = data:hp_perc(pms[self.mode]),
    mp = data:mp_perc(pms[self.mode]),
    mercenary = {
      owner = mercenaryData._name,
      cost = mercenaryData._cost,
      uid = mercenaryData._uid,
      sort = mercenaryData._sort
    }
  })
  self.mercenaryIcon[index] = hero
  hero:hide()
  self.listContainer:addChild(hero.icon)
end
class.loadMecenaryHero = loadMecenaryHero
local function loadHero(self, index)
  if index < 1 then
    return
  end
  if index > #self.listData.all then
    if bReqMercenary == false then
      loadMecenaryHero(self, 1)
    end
    self:prepareLoadTeam()
    return "loadHeroEnd"
  end
  local data = self.listData.all[index]
  local hero = ed.readhero.createIconByID(data._tid, {
    hmMode = pms[self.mode],
    stateIgnoreList = self.excavateDefendTeam,
    state = not ed.isElementInTable(self.mode, {
      "excavateChange"
    }) and "idle" or nil
  })
  local heroState = ed.player:isMercenaryHero(data._tid) == true and "mercenary" or nil
  self.heroIcon[data._tid] = hero
  hero:hide()
  self.listContainer:addChild(hero.icon)
end
class.loadHero = loadHero
local function prepareLoadHero(self)
  addListTitle(self)
  self.listContainer = CCSprite:create()
  self.listContainer:setCascadeOpacityEnabled(true)
  self.listContainer:setAnchorPoint(ccp(0, 0))
  self.listContainer:setPosition(ccp(0, 0))
  self.draglist:addItem(self.listContainer)
  self.heroIcon = {}
end
class.prepareLoadHero = prepareLoadHero
local function checkOutMercenary(self, tid, index)
  local hero
  local bMercenary = index == currentMercenaryIndex
  if bMercenary then
    hero = self.listData.mercenary[1]
  else
    hero = ed.player:getHero(tid)
  end
  if nil == hero then
    return
  end
  if not hero or not hero:hp_perc(pms[self.mode]) or not (hero:hp_perc(pms[self.mode]) <= 0) then
    local t = {id = tid, bMercenary = bMercenary}
    return t
  end
end
local function resortTeam(self, lastTeam)
  local teamData = {}
  local lastteam = lastTeam or {}
  for i = 1, 5 do
    if lastteam[i] then
      local mermber = checkOutMercenary(self, lastteam[i], i)
      table.insert(teamData, mermber)
    end
  end
  return teamData
end
local function getLastTeam(self)
  local teamData = {}
  if self.pvpMode == "defend" then
    teamData = resortTeam(self, self.defandHeros) or {}
  elseif self.mode == "crusade" then
    teamData = {}
    local lastCrusadeTeam = ed.ui.battleprepare.cruadeTeam or {}
    teamData = resortTeam(self, lastCrusadeTeam) or {}
  elseif self.mode == "guildInstance" then
    teamData = resortTeam(self, ed.ui.battleprepare.guildInstanceTeam) or {}
  elseif self.mode == "excavateChange" then
    teamData = resortTeam(self, self.excavateDefendTeam) or {}
  elseif self.mode == "excavateAttack" then
    teamData = {}
    local lastExcavateTeam = resortTeam(self, ed.ui.battleprepare.excavateTeam) or {}
    for i = 1, 5 do
      local lh = lastExcavateTeam[i]
      if lh then
        local hero = ed.player:getHero(lh)
        if not hero or not hero:hp_perc(pms[self.mode]) or not (hero:hp_perc(pms[self.mode]) <= 0) then
          table.insert(teamData, lh)
        end
      end
    end
  else
    teamData = resortTeam(self, self:getTeamData())
  end
  local function fixTeam()
    for i, v in pairs(teamData) do
      if not v.bMercenarty and not ed.isElementInTable(v.id, self.excavateDefendTeam) and ed.player.heroes[v.id]._state ~= "idle" then
        table.remove(teamData, i)
        fixTeam()
        break
      end
    end
  end
  if self.pvpMode ~= "defend" then
  end
  return teamData
end
local function loadTeam(self, index, validTeam)
  if index == 1 then
    self:clearTeamData()
  end
  local teamData = getLastTeam(self)
  if index < 1 then
    return
  end
  if index > #teamData then
    if #teamData >= 1 then
      self:setMemberAmount(validTeam)
    end
    self:refreshgs()
    return "loadTeamEnd"
  end
  local data = teamData[index].id
  if teamData[index].bMercenary and self.hireMercenary and self.mercenaryIcon[1] then
    self.mercenaryIcon[1].memberid = validTeam
    self.mercenaryIcon[1]:showSelectTag()
    local hero = self.listData.mercenary[1]
    hero.mercenary = {}
    local maxRange = ed.readhero.getHeroMaxRange(self.hireMercenary._tid)
    local icon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      level = hero._level,
      maxRange = maxRange,
      stars = hero._stars,
      hp = hero:hp_perc("crusade"),
      mp = hero:mp_perc("crusade"),
      state = "idle",
      mercenary = hero.mercenary
    })
    icon.icon:setPosition(class.getTeamMemberPos(validTeam))
    self.mainLayer:addChild(icon.icon, 30)
    self.team[validTeam] = {
      icon = icon,
      heroIcon = self.mercenaryIcon[1]
    }
  else
    self.heroIcon[data].memberid = validTeam
    self.heroIcon[data]:showSelectTag()
    local icon = ed.readhero.createIconByID(data, {
      hmMode = pms[self.mode],
      stateIgnoreList = self.excavateDefendTeam,
      state = not ed.isElementInTable(self.mode, {
        "excavateChange"
      }) and "idle" or nil
    })
    icon.icon:setPosition(class.getTeamMemberPos(validTeam))
    self.mainLayer:addChild(icon.icon, 30)
    self.team[validTeam] = {
      icon = icon,
      heroIcon = self.heroIcon[data]
    }
  end
  return "loadTeam", true
end
class.loadTeam = loadTeam
local clearTeamData = function(self)
  for i = 1, 5 do
    local th = (self.team[i] or {}).heroIcon
    if th then
      local mercenary = th.info.mercenary ~= nil
      local uid = mercenary and mercenary._uid or nil
      self:destroyTeamMember(th.info.id, true, mercenary, uid)
    end
  end
end
class.clearTeamData = clearTeamData
local prepareLoadTeam = function(self)
  local teamData = self:getTeamData()
  local teamDataFix = {}
  for i = 1, #teamData do
    if self.heroIcon[teamData[i]] then
      table.insert(teamDataFix, teamData[i])
    end
  end
  self:setTeamData(teamDataFix)
end
class.prepareLoadTeam = prepareLoadTeam
local hero_icon_ori_x = 189
local hero_icon_ori_y = 400
local hero_icon_gap_x = 100
local hero_icon_gap_y = 100
local list_title_offset = 40
local function createList(self, list)
  self:refreshList(list)
  local itemHeight = 100
  local colNum = 5
  if self.clid == "mercenary" then
    itemHeight = 167
    colNum = 3
  end
  self.draglist:initListHeight(math.ceil(#list / colNum) * itemHeight + (self.listTitle and list_title_offset or 0))
end
class.createList = createList
local function refreshList(self, list)
  for k, v in pairs(self.heroIcon) do
    v:hide()
  end
  if self.mercenaryIcon then
    for i, v in ipairs(self.mercenaryIcon) do
      v:hide()
    end
  end
  if self.clid == "mercenary" and self.mercenaryIcon then
    for i, v in ipairs(self.mercenaryIcon) do
      v:show()
      local offset = self.listTitle and list_title_offset or 0
      local ox, oy = 220, 370
      local dx, dy = 160, 167
      v.icon:setPosition(ccp(ox + dx * ((i - 1) % 3), oy - offset - dy * math.floor((i - 1) / 3)))
    end
    return
  end
  local hero = self.heroIcon
  for i = 1, #list do
    local id = list[i]._tid
    if hero[id] then
      hero[id]:show()
      local offset = self.listTitle and list_title_offset or 0
      hero[id].icon:setPosition(ccp(hero_icon_ori_x + hero_icon_gap_x * ((i - 1) % 5), hero_icon_ori_y - offset - hero_icon_gap_y * math.floor((i - 1) / 5)))
      if not self.tutorialSelectHeroId then
        local size = hero[id].icon:getContentSize()
        local ist = ed.teach("selectHero", ccp(size.width / 2, size.height / 2), size.width / 2, hero[id].icon, {
          hero[id].icon,
          self.mainLayer
        })
        if ist then
          self.tutorialSelectHeroId = {}
          self.hasSelectHeroAmount = {}
          self.hasSelectHeroAmount[id] = true
        end
      end
      if id == 4 then
        self.isAddHeroTutorial = true
        ed.teach("addHeroToTeam", hero[id].icon, {
          self.draglist.listLayer,
          self.mainLayer
        })
      end
    end
  end
end
class.refreshList = refreshList
local asyncCreateList = function(self)
  local index = 1
  local step = "loadHero"
  local validTeam = 1
  local result
  self:prepareLoadHero()
  self:createList(self.listData[self.clid])
  local preid = self.clid
  local function handler(dt)
    xpcall(function()
      if step == "loadHero" then
        for i = index, index + 10 do
          step = self:loadHero(i) or "loadHero"
        end
        index = index + 11
      end
      if step == "loadHeroEnd" then
        index = 1
        step = "loadTeam"
        if ed.player:getGuildId() ~= 0 and self.pvpMode == nil then
          ed.teach("firstMercenary", self.listButton.mercenary, self.mainLayer)
        end
      end
      if step == "loadTeam" then
        for i = 1, 6 do
          step, result = self:loadTeam(i, validTeam)
          if result == true then
            validTeam = validTeam + 1
          end
        end
      end
      if step == "loadTeamEnd" then
        self:removeUpdateHandler("asyncCreateList")
      end
      if preid ~= self.clid then
        self:createList(self.listData[self.clid])
      else
        self:refreshList(self.listData[self.clid])
      end
      preid = self.clid
    end, EDDebug)
  end
  return handler
end
class.asyncCreateList = asyncCreateList
local asyncCreateMercenary = function(self)
  local mecenaryIndex = 1
  local step = "loadMercenary"
  self:createList(self.listData[self.clid])
  local preid = self.clid
  local function handler(dt)
    xpcall(function()
      if step == "loadMercenary" then
        step = self:loadMecenaryHero(mecenaryIndex) or "loadMercenary"
        mecenaryIndex = mecenaryIndex + 1
      end
      if preid ~= self.clid then
        self:createList(self.listData[self.clid])
      else
        self:refreshList(self.listData[self.clid])
      end
      preid = self.clid
    end, EDDebug)
  end
  return handler
end
class.asyncCreateMercenary = asyncCreateMercenary
local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(130, 155, 510, 295),
    container = self.mainLayer,
    zorder = 20,
    bar = {
      bglen = 270,
      bgpos = ccp(130, 295)
    },
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local getInformation = function(self, addition)
  local heroLimit = addition.heroLimit
  local all, front, middle, back
  if heroLimit then
    all, front, middle, back = ed.readhero.classify("exercise", "position", {limit = heroLimit})
  else
    all, front, middle, back = ed.readhero.classify("prepare", "position")
  end
  self.listData = {
    all = all,
    front = front,
    middle = middle,
    back = back,
    mercenary = {}
  }
  if self.hireMercenary then
    table.insert(self.listData.mercenary, self.hireMercenary)
  end
  self.clid = "all"
  self.team = {}
  self.memberIndex = 1
  self.isDestroyTeamMember = {}
end
class.getInformation = getInformation
local function create(info)
  info = info or {}
  local self = base.create("battlePrepare")
  setmetatable(self, class.mt)
  prepareInfo = info
  bReqMercenary = false
  local scene = self.scene
  self.pvpMode = info.pvpMode
  self.defandHeros = info.heros
  self.pvpEnemyId = info.enemyId
  self.stage = info.stage_id
  self.GWMode = info.GWMode
  self.actType = info.actType
  self.heroLimit = info.heroLimit
  self.excavateDefendTeam = info.excavateTeam
  self.excavateid = info.excavateid
  self.excavateCallback = info.excavateCallback
  self.excavateEnemy = info.excavateEnemy
  self.isExcavateBot = info.isExcavateBot
  self.excavateTeamid = info.excavateTeamid
  self.excavateTypeid = info.excavateTypeid
  self.excavateTeamSvrid = info.excavateTeamSvrid
  self.mode = info.mode
  local bMercenaryVisible = self.pvpMode == nil and ed.player:getGuildId() ~= 0
  if ed.isElementInTable(self.mode, {
    "excavateChange"
  }) then
    bMercenaryVisible = false
  end
  self.hireMercenary = info.hireMercenary
  self:getInformation({
    heroLimit = self.heroLimit
  })
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  self.mainScheduler = self.mainLayer:getScheduler()
  self.ui = {}
  self.listButton = {}
  self.listButtonSelect = {}
  self.listLabel = {}
  self.ui.promtContainer = CCSprite:create()
  self.ui.promtContainer:setCascadeOpacityEnabled(true)
  self.mainLayer:addChild(self.ui.promtContainer, 50)
  if self.mode == "guildInstance" then
    self.prepareTime = info.prepareTime or 60
    prepareTimer = ListenTimer(Timer:Always(1), function()
      self.prepareTime = math.max(0, self.prepareTime - 1)
      self.listTitle:setString(T(LSTR("battleprepare.1.10.1.003"), self.prepareTime))
      if self.prepareTime <= 0 then
        ed.popScene()
        if prepareTimer then
          CloseTimer(prepareTimer.Name)
          prepareTimer = nil
        end
      end
    end)
  end
  local isSpecialgb = self.pvpMode == "defend" or ed.isElementInTable(self.mode, {
    "excavateChange"
  })
  local goButton = isSpecialgb and "UI/alpha/HVGA/pvp/pvp_button_confirm_1.png" or "UI/alpha/HVGA/prepare_go_battle.png"
  local goPressButton = ( isSpecialgb and "UI/alpha/HVGA/pvp/pvp_button_confirm_2.png") or "UI/alpha/HVGA/prepare_go_battle_press.png"
  local textVisible = false
  if isSpecialgb then
    textVisible = true
  end
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/bg.jpg"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/backbtn.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(40, 465)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/HVGA/backbtn-disabled.png",
        parent = "back"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "list_frame",
        res = "UI/alpha/HVGA/herolist.png",
        z = 5
      },
      layout = {
        position = ccp(385, 300)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "all",
        res = "UI/alpha/HVGA/classbtn.png",
        array = self.listButton
      },
      layout = {
        position = ccp(708, 415)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "all",
        res = "UI/alpha/HVGA/classbtnselected.png",
        array = self.listButtonSelect,
        z = 6
      },
      layout = {
        position = ccp(705, 415)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "all",
        text = T(LSTR("BATTLEPREPARE.WHOLE")),
        size = 20,
        array = self.listLabel,
        fontinfo = "ui_normal_button",
        z = 10
      },
      layout = {
        position = ccp(710, 415)
      },
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "front",
        res = "UI/alpha/HVGA/classbtn.png",
        array = self.listButton
      },
      layout = {
        position = ccp(708, 355)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "front",
        res = "UI/alpha/HVGA/classbtnselected.png",
        array = self.listButtonSelect,
        z = 6
      },
      layout = {
        position = ccp(705, 355)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "front",
        text = T(LSTR("UNIT.FRONT_ROW")),
        size = 20,
        array = self.listLabel,
        fontinfo = "ui_normal_button",
        z = 10
      },
      layout = {
        position = ccp(710, 355)
      },
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "middle",
        res = "UI/alpha/HVGA/classbtn.png",
        array = self.listButton
      },
      layout = {
        position = ccp(708, 295)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "middle",
        res = "UI/alpha/HVGA/classbtnselected.png",
        array = self.listButtonSelect,
        z = 6
      },
      layout = {
        position = ccp(705, 295)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "middle",
        text = T(LSTR("UNIT.MIDDLE_ROW")),
        size = 20,
        array = self.listLabel,
        fontinfo = "ui_normal_button",
        z = 10
      },
      layout = {
        position = ccp(710, 295)
      },
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/classbtn.png",
        array = self.listButton
      },
      layout = {
        position = ccp(708, 235)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/classbtnselected.png",
        array = self.listButtonSelect,
        z = 6
      },
      layout = {
        position = ccp(705, 235)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "back",
        text = T(LSTR("UNIT.REAR_ROW")),
        size = 20,
        array = self.listLabel,
        fontinfo = "ui_normal_button",
        z = 10
      },
      layout = {
        position = ccp(710, 235)
      },
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "mercenary",
        res = "UI/alpha/HVGA/classbtn.png",
        array = self.listButton
      },
      layout = {
        position = ccp(708, 175)
      },
      config = {visible = bMercenaryVisible}
    },
    {
      t = "Sprite",
      base = {
        name = "mercenary",
        res = "UI/alpha/HVGA/classbtnselected.png",
        array = self.listButtonSelect,
        z = 6
      },
      layout = {
        position = ccp(705, 175)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "mercenary",
        text = T(LSTR("BATTLEPREPARE.MERCENARY")),
        size = 14,
        array = self.listLabel,
        fontinfo = "ui_normal_button",
        z = 10
      },
      layout = {
        position = ccp(710, 175)
      },
      config = {
        visible = bMercenaryVisible,
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    --[[
    {
      t = "Sprite",
      base = {
        name = "mercenaryTag",
        res = "UI/alpha/HVGA/heroselect_tag_hire.png",
        z = 20
      },
      layout = {
        position = ccp(680, 175)
      },
      config = {visible = bMercenaryVisible}
    },]]--
    {
      t = "Sprite",
      base = {
        name = "team_bg",
        res = "UI/alpha/HVGA/heroselected.png"
      },
      layout = {
        position = ccp(352, 60)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_bg_1",
        res = "UI/alpha/HVGA/herobucket.png"
      },
      layout = {
        position = ccp(192, 81)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_bg_2",
        res = "UI/alpha/HVGA/herobucket.png",
        parent = "member_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(100, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_bg_3",
        res = "UI/alpha/HVGA/herobucket.png",
        parent = "member_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(200, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_bg_4",
        res = "UI/alpha/HVGA/herobucket.png",
        parent = "member_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(300, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_bg_5",
        res = "UI/alpha/HVGA/herobucket.png",
        parent = "member_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(400, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "member_light_1",
        res = "UI/alpha/HVGA/herobucket-halo.png"
      },
      layout = {
        position = ccp(592, 83)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "member_light_2",
        res = "UI/alpha/HVGA/herobucket-halo.png",
        parent = "member_light_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-100, 0)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "member_light_3",
        res = "UI/alpha/HVGA/herobucket-halo.png",
        parent = "member_light_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-200, 0)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "member_light_4",
        res = "UI/alpha/HVGA/herobucket-halo.png",
        parent = "member_light_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-300, 0)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "member_light_5",
        res = "UI/alpha/HVGA/herobucket-halo.png",
        parent = "member_light_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-400, 0)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {name = "go", res = goButton},
      layout = {
        position = ccp(710, 62)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_press",
        res = goPressButton,
        parent = "go"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "conform",
        text = T(LSTR("CHATCONFIG.CONFIRM")),
        fontinfo = "ui_normal_button",
        size = 18
      },
      layout = {
        position = ccp(710, 60)
      },
      config = {
        visible = textVisible
      }
    },
    {
      t = "Label",
      base = {
        name = "gs_title",
        text = T(LSTR("BATTLEPREPARE.COMBAT")),
		fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(95, 75)
      },
      config = {
        --color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "gs",
        text = 0,
		fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(95, 47)
      },
      config = {
        --color = ccc3(241, 193, 113)
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createListLayer()
  self:registerUpdateHandler("asyncCreateList", self:asyncCreateList())
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self:registerOnExitHandler("exit", self:onExitHandler())
  self:registerOnPopSceneHandler("onPop", function()
    CloseScope(battlePrepareScope)
    if prepareTimer then
      CloseTimer(prepareTimer.Name)
      prepareTimer = nil
    end
    battlePrepareScope = {}
  end)
  ListenEvent("HireMercenarySuccess", function()
    requestBattle(self)
  end, battlePrepareScope)
  ListenEvent("MercenaryAlready", function(data)
    refreshMercenaryList(self, data)
  end, battlePrepareScope)
  ListenEvent("PlayerMoneyChange", function(money)
    refreshMercenaryIcon(self, money)
  end, battlePrepareScope)
  return self
end
class.create = create
local function onExitHandler(self)
  local function handler()
    lsr:report("exitScene")
    payPanel = nil
    currentMercenary = nil
    prepareInfo = nil
  end
  return handler
end
class.onExitHandler = onExitHandler

local guild = {}
guild.__index = guild
local base = ed.ui.basescene
setmetatable(guild, base.mt)
ed.ui.guild = guild
local joinPanel, guildPanel, iconPanel
local selectMemberInfo = {}
local selectMemberId
local currentIcon = 1
local guildJoinType = 1
local enableJoinTeam = 1
local guildLevelLimit = 32
local guildSlogan = ""
local selfJob = "member"
local selfMercenaryList = {}
local selfMercenaryTime = {}
local createGuildCost =500
local mecenaryScope = {}
local currentDispatchId = 0
local currentReturnIndex = 0
local memberNum = 0
local currentWorshipType = 1
local worshipTime = 0
local leaveCallback
local maxSendMercenaryNum = 4
local otherPlayerInfo = {}
local bcurrentWorshipReword = false
local guildScope = {}
local guildSettingData = {}
local currentInstanceId
local openInstanceInfo = {}
local guildMembers, guildMembersInfo, currentSelectDropIndex, selectDropIndex, rewardDetailPanel, selectInstanceId, selectInstanceIndex
local currentVitality = 0
local seflVitality = 0
local jobChange
local leftDistributeTime = 0
local convertJoinType = function(type)
  if "no_verify" == type then
    return 1
  elseif "verify" == type then
    return 2
  elseif "closed" == type then
    return 3
  end
  return 0
end
local setGuildIcon = function(avatarId, controller)
  if nil == controller or nil == avatarId then
    return
  end
  local res = ""
  local datas = ed.getDataTable("GuildAvatar")
  if datas[avatarId] then
    res = datas[avatarId].Picture
  end
  local icon = ed.createSprite(res)
  if icon then
    icon:setPosition(ccp(38, 38))
    icon:setScale(1)
  end
  controller:removeAllChildrenWithCleanup(true)
  controller:addChild(icon)
end
function guild.showInstanceDetail(index)
  local item = guildPanel.guildInstanceLayer.instanceList:getListData(index)
  if nil == item then
    return
  end
  if item.extraData == nil then
    return
  end
  local raidId = item.extraData.instanceId
  if nil == raidId then
    return
  end
  ed.showGuildInstanceReward(raidId)
end
function guild.goInstance(index)
  local index = selectInstanceIndex or index
  local item = guildPanel.guildInstanceLayer.instanceList:getListData(index)
  if item and item.extraData then
    local raidId = item.extraData.instanceId
    if raidId and raidId > 0 then
      local raidTable = ed.getDataTable("Raid")
      local chapter = raidTable[raidId]["Chapter ID"]
      local st = ed.getDataTable("Stage")
      local progress = ed.player:getStageProgress()
      local maxChapter = st[progress]["Chapter ID"]
      if chapter > maxChapter then
        ed.showToast(T(LSTR("guild.1.10.001"), chapter))
      else
        ed.pushScene(ed.ui.stageselect.create(chapter, "guild"))
      end
    end
  end
  guildPanel.instanceManagerLayer:setVisible(false)
end
function guild.closeInstance()
  guildPanel.guildInstanceLayer:setVisible(false)
end
local function initGuildPanel()
  guildPanel:setVisible(false)
  guildPanel.mainLayer:setVisible(true)
end
local function setGuildMerberNum()
  ed.setString(guildPanel.mainLayer.uiMembers, T(LSTR("GUILDCONFIG.MEMBERS_"), memberNum, EDTables.guildConfig.maxGuildMember))
  ed.setString(guildPanel.managerLayer.merberNum, T("%d/%d", memberNum, EDTables.guildConfig.maxGuildMember))
  ed.setString(guildPanel.memberManagerLayer.merberNum, T("%d/%d", memberNum, EDTables.guildConfig.maxGuildMember))
end
local function refreshWorshipTimes()
  local vipLevel = ed.player:getvip()
  local worshipTimes = ed.getDataTable("VIP")[vipLevel]["Worship Times"]
  local leftTime = math.max(0, worshipTimes - worshipTime)
  local str = string.format("%d/%d", leftTime, worshipTimes)
  ed.setString(guildPanel.worshihInfoLayer.leftTime, str)
end
local getMinDiamondWorshipLevel = function()
  local vip = ed.getDataTable("VIP")
  for i = 1, #vip do
    if vip[i] and vip[i]["Diamond Worship"] == true then
      return i
    end
  end
end
local function adjustWorshipTypePos()
  local minLevel = getMinDiamondWorshipLevel()
  local playerVip = ed.player:getvip()
  if playerVip >= minLevel - 2 then
    guildPanel.worshihTypeLayer.worship3:setVisible(true)
    guildPanel.worshihTypeLayer.worship1:setPosition(ccp(0, 40))
    guildPanel.worshihTypeLayer.worship2:setPosition(ccp(0, 40))
  else
    guildPanel.worshihTypeLayer.worship1:setPosition(ccp(50, 40))
    guildPanel.worshihTypeLayer.worship2:setPosition(ccp(100, 40))
    guildPanel.worshihTypeLayer.worship3:setVisible(false)
  end
end
local function initWorshipLayer(data)
  worshipTime = data and data._use_times or 0
  refreshWorshipTimes()
  if nil == data then
    return
  end
  if data._rewards then
    bcurrentWorshipReword = true
    guildPanel.mainLayer.worshipTag:setVisible(true)
    guildPanel.worshihInfoLayer.getRewardTag:setVisible(true)
  end
  local gold = 0
  if data._rewards then
    for i, v in ipairs(data._rewards) do
      if v._type == "gold" then
        gold = v._param1 + gold
      end
    end
  end
  ed.setString(guildPanel.worshihInfoLayer.worshTime, gold)
end
local function initChatPanel()
  local chatPanel = ed.getChatPanel()
  if chatPanel == nil then
    return
  end
  local scene = guildPanel:getScene()
  if scene then
    scene.scene:addChild(chatPanel:getRootLayer())
  end
end
local function setGuildSettingData()
  guildSettingData.icon = currentIcon
  guildSettingData.joinType = guildJoinType
  guildSettingData.limit = guildLevelLimit
--  guildSettingData.canJump = enableJoinTeam
end
local rankMemberByJobAndLevel = function(members)
  if nil == members then
    return
  end
  local jobPriority = {
    chairman = 3,
    elder = 2,
    member = 1
  }
  table.sort(members, function(a, b)
    if a._job == b._job then
      return a._summary._level > b._summary._level
    else
      return jobPriority[a._job] > jobPriority[b._job]
    end
  end)
end
local function refreshVitality()
  local vitality = guildPanel.mainLayer.vitality
  ed.setString(vitality,T("<artnum|white|%s>", ed.formatNumWithComma(currentVitality)))
  vitality:setPosition(ccp(115 - vitality:getSize(), 24))
  ed.setString(guildPanel.mainLayer.selfVitality,T(LSTR("guild.1.10.002"), seflVitality))
end
local function showGuildInfo(data, worshipData, dropData)
  if nil == data then
    return
  end
  if nil == guildPanel then
    return
  end
  guildPanel:setVisible(true)
  currentVitality = data._vitality
  seflVitality = data._self_vitality
  refreshVitality()
  leftDistributeTime = data._left_distribute_time
  ed.player:setGuildId(data._summary._id)
  ed.player:setGuildName(data._summary._name)
  local mainLayer = guildPanel.mainLayer
  mainLayer:setVisible(true)
  ed.setString(mainLayer.name, data._summary._name)
  local tmpStr = T(LSTR("GUILDCONFIG.GUILD_ID_"), data._summary._id)
  ed.setString(mainLayer.uiGuidId, tmpStr)
  if data._summary._slogan == "" then
    ed.setString(mainLayer.slogan, T(LSTR("GUILD.THE_HOST_IS_TOO_LAZY_TO_WRITE_ANYTHING_HERE")))
  else
    ed.setString(mainLayer.slogan, data._summary._slogan)
  end
  currentIcon = data._summary._avatar
  guildJoinType = convertJoinType(data._summary._join_type)
  guildLevelLimit = math.max(data._summary._join_limit, EDTables.guildConfig.guildLevelLimit.minLevel)
  guildSlogan = data._summary._slogan
  --enableJoinTeam = data._summary._can_jump or 1
  setGuildSettingData()
  setGuildIcon(currentIcon, guildPanel.mainLayer.guildIcon)
  memberNum = 0
  if data._members then
    rankMemberByJobAndLevel(data._members)
    guildMembers = data._members
    for i, v in ipairs(data._members) do
      local item = guildPanel.memberList:addItem({
        {
          id = v._summary._avatar,
          scale = 0.6,
          vip = 0 < v._summary._vip,
          level = v._summary._level,
          name = v._summary._name,
          nameWidth = 150
        }
      }, {
        id = v._summary._avatar,
        level = v._summary._level,
        name = v._summary._name,
        vip = 0 < v._summary._vip,
        playerId = v._uid,
        job = v._job
      })
      memberNum = memberNum + 1
      if v._uid == ed.getUserid() then
        selfJob = v._job
        item.controllers.worship:setVisible(false)
        item.controllers.worshipLabel:setVisible(false)
      end
      if v._summary._level < ed.player:getLevel() + EDTables.guildConfig.worshipLevelDif then
        item.controllers.worship:setVisible(false)
        item.controllers.worshipLabel:setVisible(false)
      end
      if v._job == "chairman" then
        item.controllers.job:setVisible(true)
        ed.setString(item.controllers.job,T(LSTR("GUILDCONFIG.HOST")))
      elseif v._job == "elder" then
        item.controllers.job:setVisible(true)
        ed.setString(item.controllers.job,T(LSTR("guild.1.10.003")))
	  end
	  if item.controllers.name:getContentSize().width > 140 then
		  item.controllers.name:setScale(140 / item.controllers.name:getContentSize().width)
	  end
    end
  end
  setGuildMerberNum()
  if selfJob ~= "member" then
    guildPanel.mainLayer.managerGuild:setVisible(true)
  else
    guildPanel.mainLayer.managerGuild:setVisible(false)
  end
  if data._appliers then
    if selfJob ~= "member" then
      guildPanel.mainLayer.managerTag:setVisible(true)
      guildPanel.managerLayer.applyTab:setVisible(true)
    end
    guildPanel.managerLayer.applyDesc:setVisible(false)
    for i, v in ipairs(data._appliers) do
      guildPanel.managerLayer.applyList:addItem({
        {
          id = v._user_summary._avatar,
          level = v._user_summary._level,
          name = v._user_summary._name,
          vip = 0 < v._user_summary._vip,
          scale = 0.6
        }
      }, {
        playerId = v._uid
      })
    end
  end
  if joinPanel then
    joinPanel:setVisible(false)
  end
  initGuildPanel()
  initWorshipLayer(worshipData)
end
function guild.cancelOpen()
  guildPanel.instanceConformLayer:setVisible(false)
end
function guild.conformOpen()
  local msg = ed.upmsg.guild()
  msg._instance_open = {}
  msg._instance_open._raid_id = selectInstanceId
  ed.send(msg, "guild")
  guildPanel.instanceConformLayer:setVisible(false)
end
local function showSearchInfo(data)
  if nil == data then
    ed.showToast(T(LSTR("GUILD.NO_RESULT")))
    return
  end
  if nil == joinPanel then
    return
  end
  local res = "UI/ITEM/s72.jpg"
  local datas = ed.getDataTable("GuildAvatar")
  if datas[data._avatar] then
    res = datas[data._avatar].Picture
  end
  joinPanel.joinLayer.findListView:clear()
  local levelLimit = T(LSTR("GUILD.CLAN_LEVEL_NEEDS__D"), data._join_limit)
  local joinType = convertJoinType(data._join_type)
  local sjoinType = EDTables.guildConfig.guildJoinType[joinType]
  local name = T(LSTR("GUILD.TEXT_GUILD_JOIN_LIST_GUILDNAME__STEXT_GUILD_CREATE_WORDS_YELLOW___PLAYER"), data._name, data._member_cnt)
  joinPanel.joinLayer.findListView:addItem({
    res,
    name,
    data._slogan,
    levelLimit,
    sjoinType
  }, {
    guildId = data._id
  })
end
local onEnterGuild = function()
end
local function release()
  guildPanel = nil
  joinPanel = nil
  iconPanel = nil
  rewardDetailPanel = nil
  guildMembersInfo = nil
  guildMembers = nil
  CloseScope(guildScope)
end
local onExitGuild = function()
end
local function onPopGuild()
  release()
end
local addIcon = function()
end
local function initIconList()
  if nil == iconPanel then
    iconPanel = panelMeta:new(guildPanel:getScene(), EDTables.guildConfig.GuildIconRes)
    do
      local index = 1
      ListenTimer(Timer:Always(0.01), function()
        local datas = ed.getDataTable("GuildAvatar")
        local v = datas[index]
        if v == nil then
          return
        end
        iconPanel.iconLayer.iconList:addItem({
          v.Picture
        })
        index = index + 1
      end, guildScope)
    end
  end
  iconPanel:setVisible(true)
end
function guild.fixExplain()
  local ui = guildPanel.panelLayers.mainLayer.uiControllers
  local height = 55 + ui.explain_3.height
  ui.explain_4.rootNode:setPosition(ccp(10, height))
  ui.explain_3.rootNode:setPosition(ccp(10, height-20))
  local height = height + ui.explain_2:getContentSize().height + 9
  ui.explain_2:setAnchorPoint(ccp(0, 1))
  ui.explain_2:setPosition(ccp(10, height))
  local height = height + ui.explain_1:getContentSize().height
  ui.explain_1:setAnchorPoint(ccp(0, 1))
  ui.explain_1:setPosition(ccp(10, height))
  ui.vitalityInfo:setContentSize(CCSizeMake(450, height + 20))
end
function guild.create()
  local newscene = base.create("guild")
  setmetatable(newscene, guild)
  joinPanel = panelMeta:new(newscene, EDTables.guildConfig.JoinUIRes)
  joinPanel:setVisible(false)
  guildPanel = panelMeta:new(newscene, EDTables.guildConfig.GuildRes)
  guildPanel:setVisible(false)
  guild.fixExplain()
  newscene:registerOnEnterHandler("onEnterGuild", onEnterGuild)
  newscene:registerOnExitHandler("onExitGuild", onExitGuild)
  newscene:registerOnPopSceneHandler("onPopScene", onPopGuild)
  if ed.player:getName() == "" then
    local bename = ed.ui.bename.create()
    newscene.scene:addChild(bename.mainLayer, 100)
    function bename.destroyHandler()
      ed.popScene()
    end
  end
  return newscene
end
function guild.joinGuildTab()
  if joinPanel == nil then
    return
  end
  joinPanel.joinLayer.joinTab:setVisible(true)
  joinPanel.joinLayer.createTab:setVisible(false)
  joinPanel.joinLayer.findTab:setVisible(false)
  joinPanel.joinLayer.createGuild:cancelPress()
  joinPanel.joinLayer.findGuild:cancelPress()
  joinPanel.joinLayer.buttonBg:setPosition(ccp(165, 365))
  joinPanel.joinLayer.createInput:setVisible(false)
  joinPanel.joinLayer.input:setVisible(false)
end
function guild.findGuildTab()
  if joinPanel == nil then
    return
  end
  joinPanel.joinLayer.joinTab:setVisible(false)
  joinPanel.joinLayer.createTab:setVisible(false)
  joinPanel.joinLayer.findTab:setVisible(true)
  joinPanel.joinLayer.createGuild:cancelPress()
  joinPanel.joinLayer.joinGuild:cancelPress()
  joinPanel.joinLayer.buttonBg:setPosition(ccp(565, 365))
  joinPanel.joinLayer.createInput:setVisible(false)
  joinPanel.joinLayer.input:setVisible(true)
end
function guild.createGuildTab()
  if joinPanel == nil then
    return
  end
  joinPanel.joinLayer.joinTab:setVisible(false)
  joinPanel.joinLayer.createTab:setVisible(true)
  joinPanel.joinLayer.findTab:setVisible(false)
  joinPanel.joinLayer.findGuild:cancelPress()
  joinPanel.joinLayer.joinGuild:cancelPress()
  joinPanel.joinLayer.buttonBg:setPosition(ccp(365, 365))
  joinPanel.joinLayer.createInput:setVisible(true)
  joinPanel.joinLayer.input:setVisible(false)
  ed.setString(joinPanel.joinLayer.createCost,createGuildCost)
  if ed.player._rmb < createGuildCost then
    ed.setLabelFontInfo(joinPanel.joinLayer.createCost, "dark_red")
  else
    ed.setLabelFontInfo(joinPanel.joinLayer.createCost, "normalButton")
  end
  currentIcon=1
end
function guild.manageGuild()
  guildPanel.managerLayer:setVisible(true)
  guildPanel.managerLayer.managerSelect:setVisible(true)
end
function guild.guildLog()
  local msg = ed.upmsg.request_guild_log()
  ed.send(msg, "request_guild_log")
  ed.registerNetReply("query_guildlog", function(data)
    ed.showGuildLog(data)
  end)
end
function guild.cancelManager()
  guildPanel.managerLayer:setVisible(false)
end
function guild.changeIcon()
  initIconList()
end
function guild.addType()
  guildJoinType = math.min(guildJoinType + 1, 3)
  ed.setString(guildPanel.managerLayer.guildType, EDTables.guildConfig.guildType[guildJoinType])
end
function guild.subType()
  guildJoinType = math.max(guildJoinType - 1, 1)
  ed.setString(guildPanel.managerLayer.guildType, EDTables.guildConfig.guildType[guildJoinType])
end
function guild.changeJoinTeam()
  --enableJoinTeam = enableJoinTeam == 1 and 0 or 1
  --if enableJoinTeam == 0 then
  --  guildPanel.managerLayer.enableJoin:press()
 -- else
 --   guildPanel.managerLayer.enableJoin:cancelPress()
 -- end
end
function guild.addLimit()
  guildLevelLimit = math.min(guildLevelLimit + 1, EDTables.guildConfig.guildLevelLimit.maxLevel)
  ed.setString(guildPanel.managerLayer.guildLimit, guildLevelLimit)
end
function guild.subLimit()
  guildLevelLimit = math.max(guildLevelLimit - 1, EDTables.guildConfig.guildLevelLimit.minLevel)
  ed.setString(guildPanel.managerLayer.guildLimit, guildLevelLimit)
end
function guild.createGuild()
  local name = joinPanel.createInput:getString()
  local _, count = string.gsub(name, "[^�-�]", "")
  if "" == name then
    ed.showToast(T(LSTR("GUILD.GUILD_NAME_CAN_NOT_BE_EMPTY")))
    return
  end
  if count > 10 then
    ed.showToast(T(LSTR("GUILD.GUILD_NAME_CAN_NOT_EXCEED_10_CHARACTERS")))
    return
  end
  if ed.dirtyword_check(name) then
    ed.showToast(T(LSTR("CHAT.CONTAINING_ILLEGAL_TERMS_PLEASE_REENTER")))
    return
  end
  if ed.player._rmb < createGuildCost then
    ed.showHandyDialog("toRecharge")
    return
  end
  local msg = ed.upmsg.guild()
  msg._create = {}
  msg._create._name = name
  msg._create._avatar = currentIcon
  ed.send(msg, "guild")
end
function guild.herosCamp()
  local msg = ed.upmsg.guild()
  msg._query_hires = {}
  msg._query_hires._from = "guild"
  ed.send(msg, "guild")
end
function guild.getCurrentRaidChapter()
  local raid = ed.getDataTable("Raid")
  local row = raid[currentInstanceId]
  if row then
    return row["Chapter ID"]
  end
end
function guild.selectInstance(index)
  local index = selectInstanceIndex or index
  guildPanel.instanceManagerLayer:setVisible(false)
  local item = guildPanel.guildInstanceLayer.instanceList:getListData(index)
  if item == nil then
    return
  end
  if item.extraData == nil then
    return
  end
  local instanceId = item.extraData.instanceId
  if instanceId > currentInstanceId then
    ed.showToast(T(LSTR("guild.1.10.004")))
    return
  end
  local progress = openInstanceInfo[instanceId].RaidProgress / EDTables.guildConfig.wholePercent
  if progress == 0 then
    ed.showToast(T(LSTR("guild.1.10.005")))
    return
  end
  local costVitality = ed.getDataTable("Raid")[instanceId]["Guild Active Cost"]
  if costVitality > currentVitality then
    ed.showToast(T(LSTR("guild.1.10.006"), costVitality))
    return
  end
  selectInstanceId = instanceId
  guildPanel.instanceConformLayer:setVisible(true)
  local open = T(LSTR("guild.1.10.007"), progress * 100)
  local leftTime = T(LSTR("guild.1.10.008"), costVitality)
  local time = T(LSTR("guild.1.10.009"), currentVitality)
  ed.setString(guildPanel.instanceConformLayer.opened,open)
  ed.setString(guildPanel.instanceConformLayer.leftTime,leftTime)
  ed.setString(guildPanel.instanceConformLayer.time,time)
end
function guild.guildInstance()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
  if ds then
    ed.showToast(ds)
    return
  end
  local msg = ed.upmsg.guild()
  msg._instance_query = {}
  ed.send(msg, "guild")
end
function guild.guildShop()
  local ds = ed.playerlimit.getAreaUnlockPrompt("GuildShop")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.pushScene(ed.ui.shop.create(7))
end
function guild.worship()
  if guildPanel == nil then
    return
  end
  guildPanel.worshihInfoLayer:setVisible(true)
  guildPanel.mainLayer.worshipTag:setVisible(false)
end
function guild.reqGuildById()
  local guildId = tonumber(joinPanel.joinLayer.input:getString())
  if guildId == nil then
    ed.showToast(T(LSTR("GUILD.ENTER_THE_CORRECT_GUILD_ID")))
    return
  end
  local msg = ed.upmsg.guild()
  msg._search = {}
  msg._search._guild_id = guildId
  ed.send(msg, "guild")
end
local getMemberDes = function(type, data)
  local des = ""
  if type == "time" then
    local y, m, d, h, min, sec = ed.time2YMDHMS(data._last_login)
    local nowY, nowM, nowD = ed.time2YMDHMS(ed.getServerTime())
    local passSecond = ed.getServerTime() - data._last_login
    if d == nowD and passSecond < 86400 or data._last_login == 0 then
      des = T(LSTR("guild.1.10.010"), h, min)
    else
      local days = math.ceil(passSecond / 86400)
      des = T(LSTR("guild.1.10.011"), days)
    end
  elseif type == "active" then
    des = T(LSTR("guild.2.0.0.001"), data._active or 0)
  elseif type == "instance" then
    des = T(LSTR("guild.2.0.0.002"), data._join_instance_time or 0)
  end
  return des
end
local function initMemberList(type)
  guildPanel.memberManagerLayer.membersList:clear()
  for i, v in ipairs(guildMembers) do
    local des = getMemberDes(type, v)
    local item = guildPanel.memberManagerLayer.membersList:addItem({
      {
        id = v._summary._avatar,
        scale = 0.6,
        vip = v._summary._vip > 0,
        level = v._summary._level,
        name = v._summary._name
      },
      des
    }, {
      playerId = v._uid,
      job = v._job
    })
    if v._job == "chairman" then
      item.controllers.job:setVisible(true)
      ed.setString(item.controllers.job,T(LSTR("GUILDCONFIG.HOST")))
    elseif v._job == "elder" then
      item.controllers.job:setVisible(true)
      ed.setString(item.controllers.job,T(LSTR("guild.1.10.003")))
	 end
  end
end
function guild.rankByTime()
  table.sort(guildMembers, function(a, b)
    return a._last_login > b._last_login
  end)
  initMemberList("time")
end
function guild.rankByactive()
  table.sort(guildMembers, function(a, b)
    local aActive = a._active or 0
    local bActive = b._active or 0
    return aActive > bActive
  end)
  initMemberList("active")
end
function guild.rankByGuildInstance()
  table.sort(guildMembers, function(a, b)
    local aActive = a._join_instance_time or 0
    local bActive = b._join_instance_time or 0
    return aActive > bActive
  end)
  initMemberList("instance")
end
function guild.showMemberManager()
  guildPanel.memberManagerLayer:setVisible(true)
  guildPanel.managerLayer:setVisible(false)
  guild.rankByTime()
end
function guild.closeMemberManager()
  guildPanel.memberManagerLayer:setVisible(false)
end
function guild.closeJobChange()
  guildPanel.jobChangeLayer:setVisible(false)
end
function guild.scaleDownMember(index)
  local item = guildPanel.memberManagerLayer.membersList:getListData(index)
  if nil == item then
    return
  end
  item.controllers.parent:setScale(0.98)
end
function guild.scaleUpMember(index)
  local item = guildPanel.memberManagerLayer.membersList:getListData(index)
  if nil == item then
    return
  end
  item.controllers.parent:setScale(1)
end
function guild.onMemberManager(index)
  local item = guildPanel.memberManagerLayer.membersList:getListData(index)
  if nil == item then
    return
  end
  local avatar = item.data[1].id
  local level = item.data[1].level
  local name = item.data[1].name
  local vip = item.data[1].vip
  local job = item.extraData.job
  if nil == avatar or nil == level or nil == name then
    return
  end
  selectMemberId = item.extraData.playerId
  selectMemberInfo = {}
  selectMemberInfo.level = level
  selectMemberInfo.name = name
  selectMemberInfo.job = job
  if ed.getUserid() == selectMemberId then
    return
  end
  local memberLayer = guildPanel.jobChangeLayer
  memberLayer:setVisible(true)
  if job == "member" then
    --memberLayer.job:setVisible(false)
  else
    --memberLayer.job:setVisible(true)
    if job == "chairman" then
      ed.setString(memberLayer.job,T(LSTR("GUILDCONFIG.HOST")))
    else
      ed.setString(memberLayer.job,T(LSTR("guild.1.10.003")))
	end
	if item.controllers.name and item.controllers.name:getContentSize().width > 140 then
		item.controllers.name:setScale(140 / item.controllers.name:getContentSize().width)
	end
  end
  if selfJob == "chairman" then
    if job == "elder" then
      memberLayer.disElder:setVisible(true)
      memberLayer.elder:setVisible(false)
    else
      memberLayer.disElder:setVisible(false)
      memberLayer.elder:setVisible(true)
    end
  else
    memberLayer.disElder:setVisible(false)
  end
  if selfJob == "elder" then
    memberLayer.elder:enable(false)
    memberLayer.promotion:enable(false)
    if job == "chairman" or job == "elder" then
      memberLayer.discharge:enable(false)
    else
      memberLayer.discharge:enable(true)
    end
  else
    memberLayer.elder:enable(true)
    memberLayer.promotion:enable(true)
    memberLayer.discharge:enable(true)
  end
  local param = {id = avatar, vip = vip}
  local head = ed.getHeroIconByID(param)
  if head then
    memberLayer.memberIcon:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    memberLayer.memberIcon:addChild(head)
  end
  ed.setString(memberLayer.memberLevel, level)
  ed.setString(memberLayer.memberName, name)
end
function guild.changeApply()
  guildPanel.managerLayer.managerSelect:setVisible(false)
  guildPanel.managerLayer.applyInfo:setVisible(true)
  guildPanel.mainLayer.managerTag:setVisible(false)
  guildPanel.managerLayer.applyTab:setVisible(false)
end
function guild.changeAdvertise()
  guildPanel.managerLayer.managerSelect:setVisible(false)
  guildPanel.managerLayer.adviceInfo:setVisible(true)
  guildPanel.managerLayer.sloganInput:setVisible(true)
end
function guild.changeSetting()
  guildPanel.managerLayer.managerSelect:setVisible(false)
  guildPanel.managerLayer.settingInfo:setVisible(true)
  setGuildIcon(guildSettingData.icon, guildPanel.managerLayer.guildIcon)
  ed.setString(guildPanel.managerLayer.guildLimit, guildSettingData.limit)
  ed.setString(guildPanel.managerLayer.guildType, EDTables.guildConfig.guildType[guildSettingData.joinType])
 -- if guildSettingData.canJump == 0 then
 --   guildPanel.managerLayer.enableJoin:press()
 -- else
  --  guildPanel.managerLayer.enableJoin:cancelPress()
  --end
  guildLevelLimit = guildSettingData.limit
  guildJoinType = guildSettingData.joinType
  currentIcon = guildSettingData.icon
 -- enableJoinTeam = guildSettingData.canJump
end
function guild.OnJoinListClick(itemData, x, y)
  if nil == itemData then
    return
  end
  if nil == itemData.extraData then
    return
  end
  if nil == itemData.extraData.guildId then
    return
  end
  if ed.containsPoint(itemData.controllers.join, x, y) and itemData.controllers.join:isVisible() then
    local msg = ed.upmsg.guild()
    msg._join = {}
    msg._join._guild_id = itemData.extraData.guildId
    ed.send(msg, "guild")
  end
end
function guild.showHeroPage(index)
  if index == 1 then
    guildPanel.herosCampLayer.page1:press()
    guildPanel.herosCampLayer.page2:cancelPress()
    guildPanel.herosCampLayer.selfHeros:setVisible(true)
    guildPanel.herosCampLayer.allHeros:setVisible(false)
    ed.setLabelFontInfo(guildPanel.herosCampLayer.myHero, "guild_join_tab_yellow")
    ed.setLabelFontInfo(guildPanel.herosCampLayer.allHero, "guild_join_tab_white")
  elseif index == 2 then
    guildPanel.herosCampLayer.page1:cancelPress()
    guildPanel.herosCampLayer.selfHeros:setVisible(false)
    guildPanel.herosCampLayer.allHeros:setVisible(true)
    ed.setLabelFontInfo(guildPanel.herosCampLayer.myHero, "guild_join_tab_white")
    ed.setLabelFontInfo(guildPanel.herosCampLayer.allHero, "guild_join_tab_yellow")
  end
end
function guild.closeRuleInfo()
  guildPanel.ruleLayer:setVisible(false)
end
function guild.OnMemberClick(itemData, x, y, index)
  if nil == itemData then
    return
  end
  local avatar = itemData.extraData.id
  local level = itemData.extraData.level
  local name = itemData.extraData.name
  local vip = itemData.extraData.vip
  local job = itemData.extraData.job
  if nil == avatar or nil == level or nil == name then
    return
  end
  if itemData.extraData then
    selectMemberId = itemData.extraData.playerId
  end
  selectMemberInfo = {}
  selectMemberInfo.level = level
  selectMemberInfo.name = name
  if ed.getUserid() == selectMemberId then
    return
  end
  if ed.containsPoint(itemData.controllers.worship, x, y) and itemData.controllers.worship:isVisible() then
    guild.OnWorship()
    return
  end
  local memberLayer = guildPanel.memberLayer
  memberLayer:setVisible(true)
  if job == "member" then
    memberLayer.job:setVisible(false)
  else
    memberLayer.job:setVisible(true)
    if job == "chairman" then
      ed.setString(memberLayer.job,T(LSTR("GUILDCONFIG.HOST")))
    else
      ed.setString(memberLayer.job,T(LSTR("guild.1.10.003")))
    end
  end
  local param = {id = avatar, vip = vip}
  local head = ed.getHeroIconByID(param)
  if head then
    memberLayer.memberIcon:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    memberLayer.memberIcon:addChild(head)
  end
  ed.setString(memberLayer.memberLevel, level)
  ed.setString(memberLayer.memberName, name)
end
function guild.OnSelfMercenaryClick(itemData, x, y, index)
  if ed.containsPoint(itemData.controllers.returnHero, x, y) and itemData.controllers.returnHero:isVisible() then
    if selfMercenaryTime[index] == nil then
      return
    end
    local minTime = ed.getDataTable("GuildHirePrice")[1]["Min Legal Recall Duration"]
    local passTime = ed.getServerTime() - selfMercenaryTime[index]
    if minTime > passTime then
      local h, m = ed.second2hms(minTime - passTime)
      ed.showToast(T(LSTR("GUILD.THE_HERO_STILL_HAS__D_MINUTES_TO_REJOIN"), m + 1))
      return
    end
    if selfMercenaryList[index] == nil then
      return
    end
    currentReturnIndex = index
    local msg = ed.upmsg.guild()
    msg._del_hire = {}
    msg._del_hire._heroid = selfMercenaryList[index]
    ed.send(msg, "guild")
  elseif ed.containsPoint(itemData.controllers.ui, x, y) and selfMercenaryList[index] == nil then
    guild.sendHero()
  end
end
function guild.OnMercenaryListClick(itemData, x, y, index)
  if itemData.extraData == nil then
    return
  end
  otherPlayerInfo = {}
  otherPlayerInfo.heroId = itemData.extraData.heroId
  otherPlayerInfo.level = itemData.extraData.playerLevel
  otherPlayerInfo.name = itemData.extraData.playerName
  otherPlayerInfo.icon = itemData.extraData.playerAvatar ~= 0 and itemData.extraData.playerAvatar or 1
  local msg = ed.upmsg.guild()
  msg._query_hh_detail = {}
  msg._query_hh_detail._uid = itemData.extraData.playerId
  msg._query_hh_detail._heroid = itemData.extraData.heroId
  ed.send(msg, "guild")
end
function guild.conformReward()
  guildPanel.rewardLayer:setVisible(false)
end
function guild.conformWorshipReward()
  guildPanel.worshipRewardLayer:setVisible(false)
end
function guild.OnIconClick(itemData, x, y, index)
  local res = itemData.data[1]
  if nil == res then
    return
  end
  local icon = ed.createSprite(res)
  if nil == icon then
    return
  end
  if joinPanel and joinPanel:getVisible() == true then
    setGuildIcon(index, joinPanel.joinLayer.guildIcon)
  elseif guildPanel and guildPanel.managerLayer.settingInfo:isVisible() == true then
    setGuildIcon(index, guildPanel.managerLayer.guildIcon)
  end
  currentIcon = index
  guild.closeIcon()
end
function guild.closeRewarInfoLayer()
  guildPanel.rewardInfoLayer:setVisible(false)
end
function guild.distributeReward()
  local msg = ed.upmsg.guild()
  msg._drop_info = {}
  ed.send(msg, "guild")
end
function guild.selectMember(index)
  local listItem = guildPanel.rewardDetailLayer.rewardList:getListData(index)
  if nil == listItem then
    return
  end
  local itemId = listItem.extraData.item.item
  if nil == itemId then
    return
  end
  local row = ed.getDataTable("equip")[itemId]
  if row then
    local info = {
      text = string.format(T(LSTR("guild.1.10.012")), row.Name, listItem.extraData.name),
      leftText = T(LSTR("CHATCONFIG.CANCEL")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = function()
        xpcall(function()
          currentSelectDropIndex = index
          guild.conformDistribute()
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
  end
end
function guild.distributeItem(index)
  if leftDistributeTime < 1 then
    ed.showToast(T(LSTR("guild.1.10.013")))
    return
  end
  local item = guildPanel.rewardInfoLayer.rewardList:getListData(index)
  if nil == item then
    return
  end
  currentSelectDropIndex = nil
  selectDropIndex = index
  guildPanel.rewardDetailLayer.rewardList:clear()
  local extraData = item.extraData
  guildPanel.rewardDetailLayer:setVisible(true)
  if extraData.user then
    guildPanel.rewardDetailLayer.rewardList:changeItemConfig(2)
    guildPanel.rewardDetailLayer.rewardList:addItem({
      T(LSTR("guild.1.10.014"))
    })
    guildPanel.rewardDetailLayer.rewardList:changeItemConfig()
    table.sort(extraData.user, function(a, b)
      local damage1 = extraData.record[a] or 0
      local damage2 = extraData.record[b] or 0
      return damage1 > damage2
    end)
    for i, userId in ipairs(extraData.user) do
      if guildMembersInfo and guildMembersInfo[userId] then
        local info = guildMembersInfo[userId]
        local damage = extraData.record[userId] or 0
        local temp = guildPanel.rewardDetailLayer.rewardList:addItem({
          info._summary._avatar,
          info._summary._level,
          info._summary._name,
          damage
        }, {
          item = item.extraData,
          userId = userId,
          name = info._summary._name
        })
        local oldScale = temp.controllers.percent:getScaleX()
        temp.controllers.percent:setScaleX(oldScale * damage / extraData.maxDamage)
      end
    end
  end
  if guildMembersInfo then
    local members = {}
    for i, v in pairs(guildMembersInfo) do
      if not ed.isElementInTable(v._uid, extraData.user) then
        table.insert(members, v._uid)
      end
    end
    table.sort(members, function(a, b)
      local damage1 = extraData.record[a] or 0
      local damage2 = extraData.record[b] or 0
      return damage1 > damage2
    end)
    if #members > 0 then
      guildPanel.rewardDetailLayer.rewardList:changeItemConfig(2)
      guildPanel.rewardDetailLayer.rewardList:addItem({
        T(LSTR("guild.1.10.015"))
      })
      guildPanel.rewardDetailLayer.rewardList:changeItemConfig()
    end
    for i, v in ipairs(members) do
      local damage = extraData.record[v] or 0
      local info = guildMembersInfo[v]
      local temp = guildPanel.rewardDetailLayer.rewardList:addItem({
        info._summary._avatar,
        info._summary._level,
        info._summary._name,
        damage
      }, {
        item = item.extraData,
        userId = v,
        name = info._summary._name
      })
      local oldScale = temp.controllers.percent:getScaleX()
      temp.controllers.percent:setScaleX(oldScale * damage / extraData.maxDamage)
    end
  end
end
function guild.closeRewarDetailLayer()
  guildPanel.rewardDetailLayer:setVisible(false)
end
function guild.reqRewardRecord()
  local msg = ed.upmsg.guild()
  msg._items_history = {}
  ed.send(msg, "guild")
end
function guild.showItemInfo()
  guild.hideItemInfo()
  local item = guildPanel.rewardDetailLayer.rewardList:getListData(2)
  if item and item.extraData then
    local itemId = item.extraData.item.item
    local panel = ed.readequip.getDetailCard(itemId)
    local x, y = guildPanel.rewardDetailLayer.showHint:getPosition()
    panel:setPosition(ccp(x, y))
    rewardDetailPanel = panel
    guildPanel.rewardDetailLayer.bg:addChild(panel, 20)
  end
end
function guild.hideItemInfo()
  if rewardDetailPanel then
    rewardDetailPanel:removeFromParentAndCleanup(true)
    rewardDetailPanel = nil
  end
end
function guild.conformDistribute()
  if currentSelectDropIndex == nil then
    return
  end
  local item = guildPanel.rewardDetailLayer.rewardList:getListData(currentSelectDropIndex)
  if item and item.extraData then
    local msg = ed.upmsg.guild()
    msg._drop_give = {}
    msg._drop_give._item_id = item.extraData.item.item
    msg._drop_give._raid_id = item.extraData.item.raidId
    msg._drop_give._user_id = item.extraData.userId
    msg._drop_give._time_out_end = item.extraData.item.time
    ed.send(msg, "guild")
  end
end
function guild.dismissGuild()
  if memberNum > 1 then
    ed.showToast(T(LSTR("GUILD.THERE_ARE_OTHER_CURRENT_MEMBERS_IN_THIS_GUILD_SO_IT_CAN_NOT_BE_DISBAND")))
    return
  end
  if selfJob ~= "chairman" then
    ed.showToast(T(LSTR("guild.1.10.016")))
    return
  end
  local sprite = CCSprite:create()
  local info = {
    sprite = sprite,
    spriteLabel = T(LSTR("GUILD.CONFIRM_TO_DISBAND")),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._dismiss = {}
        ed.send(msg, "guild")
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
local hideApplyControllers = function(itemData, type)
  if itemData == nil then
    return
  end
  itemData.controllers.agree:setVisible(false)
  itemData.controllers.refuse:setVisible(false)
  itemData.controllers.agreeLabel:setVisible(false)
  itemData.controllers.refuseLabel:setVisible(false)
  itemData.controllers.result:setVisible(true)
  if type == "agree" then
    ed.setString(itemData.controllers.result, T(LSTR("GUILDCONFIG.APPLICATION_APPROVED")))
  elseif type == "refuse" then
    ed.setString(itemData.controllers.result, T(LSTR("GUILD.APPLICATION_DENIED")))
  end
end
function guild.OnGuildApplyClick(itemData, x, y, index)
  if itemData == nil then
    return
  end
  if itemData.extraData == nil then
    return
  end
  if nil == itemData.extraData.playerId then
    return
  end
  if nil == itemData.controllers.agree or nil == itemData.controllers.refuse then
    return
  end
  if ed.containsPoint(itemData.controllers.agree, x, y) and itemData.controllers.agree:isVisible() then
    if memberNum >= EDTables.guildConfig.maxGuildMember then
      ed.showToast(T(LSTR("GUILD.THIS_GUILD_HAS_ALREADY_REACHED_THE_MAXIMUM_NUMBERS")))
      return
    end
    local msg = ed.upmsg.guild()
    msg._join_confirm = {}
    msg._join_confirm._type = "accept"
    msg._join_confirm._uid = itemData.extraData.playerId
    ed.send(msg, "guild")
    hideApplyControllers(itemData, "agree")
  elseif ed.containsPoint(itemData.controllers.refuse, x, y) and itemData.controllers.refuse:isVisible() then
    local msg = ed.upmsg.guild()
    msg._join_confirm = {}
    msg._join_confirm._type = "reject"
    msg._join_confirm._uid = itemData.extraData.playerId
    ed.send(msg, "guild")
    hideApplyControllers(itemData, "refuse")
  end
end
local function initWorshipTypeLayer()
  local worshipTable = ed.getDataTable("GuildWorship")
  ed.setString(guildPanel.worshihTypeLayer.goldCost, worshipTable[2]["Price Amount"])
  ed.setString(guildPanel.worshihTypeLayer.rmbCost, worshipTable[3]["Price Amount"])
  ed.setString(guildPanel.worshihTypeLayer.exp1, worshipTable[1]["Get Vitality"])
  ed.setString(guildPanel.worshihTypeLayer.exp2, worshipTable[2]["Get Vitality"])
  ed.setString(guildPanel.worshihTypeLayer.exp3, worshipTable[3]["Get Vitality"])
  ed.setString(guildPanel.worshihTypeLayer.reward1, worshipTable[1]["Get Vitality"])
  ed.setString(guildPanel.worshihTypeLayer.reward2, worshipTable[2]["Get Vitality"])
  ed.setString(guildPanel.worshihTypeLayer.reward3, worshipTable[3]["Get Vitality"])
  adjustWorshipTypePos()
end
function guild.OnWorship()
  local vipLevel = ed.player:getvip()
  local maxTimes = ed.getDataTable("VIP")[vipLevel]["Worship Times"]
  if maxTimes <= worshipTime then
    ed.showToast(T(LSTR("GUILD.WORSHIPMENT_TIMES_HAVE_ALREADY_BEEN_USED_UP_FOR_TODAY")))
    return
  end
  if selectMemberInfo and selectMemberInfo.level < ed.player:getLevel() + 5 then
    ed.showToast(T(LSTR("GUILD.YOU_CAN_ONLY_WORSHIP_5_LEVEL_HIGHER_PLAYER_THAN_YOURS")))
    return
  end
  if guildPanel then
    guildPanel.worshihTypeLayer:setVisible(true)
    guildPanel.memberLayer:setVisible(false)
  end
  initWorshipTypeLayer()
end
function guild.onChat()
  ed.ui.chat.setTargetSummary({
    _name = selectMemberInfo.name
  }, selectMemberId)
  ed.ui.chat.OnPrivateTab()
  ed.ui.chat.startChat()
  ed.ui.chat.setChatOpenPosition()
  ed.popScene()
end
function guild.onElder()
  if selectMemberInfo.job == "elder" or selectMemberInfo.job == "chairman" then
    ed.showToast(T(LSTR("guild.1.10.016")))
    return
  end
  local info = {
    text = T(LSTR("guild.1.10.017"), selectMemberInfo.name),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._set_job = {}
        msg._set_job._uid = selectMemberId
        msg._set_job._job = "elder"
        jobChange = "elder"
        ed.send(msg, "guild")
        guildPanel.jobChangeLayer:setVisible(false)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function guild.onDisElder()
  local info = {
    text = T(LSTR("guild.1.10.018"), selectMemberInfo.name),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._set_job = {}
        msg._set_job._uid = selectMemberId
        msg._set_job._job = "member"
        jobChange = "member"
        ed.send(msg, "guild")
        guildPanel.jobChangeLayer:setVisible(false)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function guild.OnPromotion()
  if selfJob ~= "chairman" then
    ed.showToast(T(LSTR("guild.1.10.016")))
    return
  end
  local info = {
    text = T(LSTR("GUILD.CONFIRM_TO_UPGRADE__S_TO_HOST"), selectMemberInfo.name),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._set_job = {}
        msg._set_job._uid = selectMemberId
        msg._set_job._job = "chairman"
        jobChange = "chairman"
        ed.send(msg, "guild")
        guildPanel.jobChangeLayer:setVisible(false)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function guild.OnDischarge()
  if selectMemberInfo.job == "elder" or selectMemberInfo.job == "chairman" then
    ed.showToast(T(LSTR("guild.1.10.016")))
    return
  end
  local info = {
    text = T(LSTR("GUILD.DETERMINE_THE__S_KICKED_GUILD_HE_WILL_NOT_BE_ABLE_TO_JOIN_ANY_GUILD_IN_1_HOUR_UNABLE_TO_RETURN_TO_THE_ASSOCIATION_WITHIN_48_HOURS"), selectMemberInfo.name),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._kick = {}
        msg._kick._uid = selectMemberId
        ed.send(msg, "guild")
        guildPanel.jobChangeLayer:setVisible(false)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
local function getEmptyIndex()
  local index = 0
  for i = 1, maxSendMercenaryNum do
    if selfMercenaryList[i] == nil then
      index = i
      break
    end
  end
  return index
end
local setItemVisible = function(item, visible)
  if nil == item then
    return
  end
  item.controllers.returnHero:setVisible(visible)
  item.controllers.back:setVisible(visible)
  item.controllers.returnDes:setVisible(visible)
  item.controllers.glodIcon:setVisible(visible)
  item.controllers.time:setVisible(visible)
  item.controllers.income:setVisible(visible)
  item.controllers.returnTime:setVisible(visible)
  item.controllers.sendHint2:setVisible(not visible)
end
local function getSelfMercenaryNum()
  local num = 0
  for i = 1, maxSendMercenaryNum do
    if selfMercenaryList[i] then
      num = num + 1
    end
  end
  return num
end
local function addHeroIcon(hero, hireTime, cost)
  if hero == nil then
    return
  end
  local index = getEmptyIndex()
  if index == 0 then
    return
  end
  local itemData = guildPanel.herosCampLayer.selfMercenaryList:getListData(index)
  if nil == itemData then
    return
  end
  setItemVisible(itemData, true)
  selfMercenaryList[index] = hero._tid
  selfMercenaryTime[index] = hireTime
  local heroIcon = ed.readhero.createIconByHero(hero)
  itemData.controllers.heroIcon:addChild(heroIcon.icon)
  local h, m = ed.second2hms(ed.getServerTime() - selfMercenaryTime[index])
  ed.setString(itemData.controllers.returnTime, T(LSTR(LSTR("GUILD.GUILD_D_HOURS__D_MINUTES")), h, m))
  ed.setString(itemData.controllers.income, cost)
  local vipLevel = ed.player:getvip()
  local dispatchLimit = ed.getDataTable("VIP")[vipLevel]["Guild Hero Dispatch Limit"]
  if dispatchLimit > getSelfMercenaryNum() and getSelfMercenaryNum() >= guildPanel.herosCampLayer.selfMercenaryList:getListDataNum() then
    guildPanel.herosCampLayer.selfMercenaryList:addItem({})
  end
end
local function DispathHero(heroId)
  if selfMercenaryList then
    for k, v in pairs(selfMercenaryList) do
      if v == heroId then
        ed.showToast(T(LSTR("GUILD.THIS_HERO_HAS_ALREADY_BEEN_SENT_OUT")))
        return
      end
    end
  end
  local info = {
    text = T(LSTR("GUILD.HEROES_SENT_OUT_HAS_TO_GUIDE_CAMPS_FOR_MINIMUM_30_MINUTES_THUS_HE_CAN_NOT_BE_SENT_TO_BATTLEFIELD_DURING_THIS_PERIOD")),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._add_hire = {}
        msg._add_hire._heroid = heroId
        ed.send(msg, "guild")
        currentDispatchId = heroId
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function guild.showRule()
  guildPanel.ruleLayer:setVisible(true)
  local list = guildPanel.ruleLayer.listview
  if list:isEmpty() then
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_1_ANY_HERO_CAN_BE_SENT_TO_MERCENARY_CAMP_BUT_NOT_ALL_HEROES_WILL_BE_HIRED"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_2_STATIONED_MERCENARIES_WILL_BE_PAID_HARD_COSTS_BY_MERCENARY_CAMP_THE_LONGER_THE_TIME_THE_MORE_REVENUE_"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_3_MERCENARIES_SENT_OUT_HAS_TO_GUIDE_CAMPS_FOR_MINIMUM_30_MINUTES_AND_THEY_CAN_NOT_BE_RECALLED_DURING_THIS_PERIOD"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_4_GUILD_MEMBERS_CAN_PAY_FOR_GOLD_TO_BORROW_MERCENARIES_FROM_THE_MERCENARY_CAMP_"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_5_YOU_CAN_ONLY_HIRE_A_MERCENARY_FROM_THE_SAME_MERCENARY_CAMP_PER_DAY"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_6_THE_PRICE_WILL_BE_VALUED_BY_MERCENARYS_POWER"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_7_PART_OF_THE_PAYMENT_TURNS_MERCENARY_CAMP_THE_REST_CAN_BE_BROUGHT_BACK"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_8_THE_HIGHER_THE_CLANS_VIP_LEVEL_IS_THE_MORE_MERCENARIES_HE_CAN_SEND_OUT"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_9_MERCENARY_CAN_PARTICIPATE_IN_THE_BATTLE_OF_MERCENARY_EXPEDITION_CAVERNS_OF_TIME_THE_HERO_OF_THE_BATTLE_TRIALS_"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_10_YOU_CAN_ONLY_HIRE_ONE_MERCENARY_FOR_EACH_BATTLE_THE_COMMISSION_WILL_NOT_BE_REFUNDED_REGARDLESS_THE_OUTCOME"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_11_YOU_CAN_ONLY_HIRE_ONE_MERCENARY_FOR_EXPEDITION_HE_WILL_FIGHT_FOR_YOU_IN_THE_END_"))
    })
    list:addItem({
      T(LSTR("GUILD.TEXT_DARK_WHITE_12_HIRED_HERO_CAN_NOT_FIGHT_TOGETHER_WITH_A_SAME_NAMED_HERO_FROM_THE_CLAN"))
    })
    list:addItem({
      "<text|normalButton| >"
    })
  end
end
function guild.closeGuildPanel()
  ed.popScene()
end
function guild.closeAdviceInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.managerLayer.adviceInfo:setVisible(false)
  guildPanel.managerLayer:setVisible(false)
  guildPanel.managerLayer.sloganInput:setVisible(false)
end
function guild.closeSettingInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.managerLayer.settingInfo:setVisible(false)
  guildPanel.managerLayer:setVisible(false)
end
function guild.closeApplyInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.managerLayer.applyInfo:setVisible(false)
  guildPanel.managerLayer:setVisible(false)
end
function guild.CloseManager()
  if guildPanel == nil then
    return
  end
  guildPanel.managerLayer:setVisible(false)
end
function guild.closeMemberInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.memberLayer:setVisible(false)
end
function guild.closeWorshInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.worshihInfoLayer:setVisible(false)
end
function guild.showVitalityInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.mainLayer.vitalityInfo:setVisible(true)
end
function guild.hideVitalityInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.mainLayer.vitalityInfo:setVisible(false)
end
function guild.closeIcon()
  if iconPanel then
    iconPanel:setVisible(false)
  end
end
function guild.closeWorshipType()
  if guildPanel == nil then
    return
  end
  guildPanel.worshihTypeLayer:setVisible(false)
end
function guild.closeCampInfo()
  if guildPanel == nil then
    return
  end
  guildPanel.herosCampLayer:setVisible(false)
  CloseScope(mecenaryScope)
end
function guild.applyIcon()
end
function guild.applyAdvice()
  local slogan = guildPanel.managerLayer.sloganInput:getString()
  if ed.dirtyword_check(slogan) then
    ed.showToast(T(LSTR("CHAT.CONTAINING_ILLEGAL_TERMS_PLEASE_REENTER")))
    return
  end
  guildPanel.managerLayer.adviceInfo:setVisible(false)
  guildPanel.managerLayer:setVisible(false)
  guildPanel.managerLayer.sloganInput:setVisible(false)
  local msg = ed.upmsg.guild()
  msg._set = {}
  msg._set._slogan = slogan
  ed.send(msg, "guild")
  guildSlogan = slogan
end
function guild.freeWorship()
  local msg = ed.upmsg.guild()
  msg._worship_req = {}
  msg._worship_req._id = 1
  msg._worship_req._uid = selectMemberId
  ed.send(msg, "guild")
  currentWorshipType = 1
  guildPanel.worshihTypeLayer:setVisible(false)
end
function guild.goldWorship()
  local cost = tonumber(guildPanel.worshihTypeLayer.goldCost:getString())
  if cost > ed.player._money then
    ed.showHandyDialog("useMidas")
    return
  else
    local msg = ed.upmsg.guild()
    msg._worship_req = {}
    msg._worship_req._id = 2
    msg._worship_req._uid = selectMemberId
    ed.send(msg, "guild")
    currentWorshipType = 2
  end
  guildPanel.worshihTypeLayer:setVisible(false)
end
function guild.rmbWorship()
  local minVipLevel = getMinDiamondWorshipLevel()
  if minVipLevel > ed.player:getvip() then
    ed.showToast(T(LSTR("GUILD.VIP_LEVEL_REACHES__D_CAN_BE_UNLOCKED"), minVipLevel))
    return
  end
  local cost = tonumber(guildPanel.worshihTypeLayer.rmbCost:getString())
  local exp = tonumber(guildPanel.worshihTypeLayer.exp3:getString())
  if cost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  local info = {
    text = T(LSTR("GUILD.SPEND__D_DIAMONDS_TO_GAIN__D_ENERGYIS_CONTINUE"), cost, exp),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.guild()
        msg._worship_req = {}
        msg._worship_req._id = 3
        msg._worship_req._uid = selectMemberId
        ed.send(msg, "guild")
        currentWorshipType = 3
        guildPanel.worshihTypeLayer:setVisible(false)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function guild.applySetting()
  guild.closeSettingInfo()
  local msg = ed.upmsg.guild()
  msg._set = {}
  msg._set._avatar = currentIcon
  msg._set._join_type = guildJoinType
  msg._set._join_limit = guildLevelLimit
  --msg._set._can_jump = enableJoinTeam
  ed.send(msg, "guild")
end
function guild.reqWorshReward()
  if bcurrentWorshipReword == false then
    ed.showToast(T(LSTR("GUILD.CURRENTLY_NO_AVAILABLE_REWARDS")))
    return
  else
    local msg = ed.upmsg.guild()
    msg._worship_withdraw = {}
    ed.send(msg, "guild")
    bcurrentWorshipReword = false
    guildPanel.mainLayer.worshipTag:setVisible(false)
    guildPanel.worshihInfoLayer.getRewardTag:setVisible(false)
  end
end
local function refreshGuildList(data, cost)
  joinPanel:setVisible(true)
  joinPanel.joinLayer.joinGuild:press()
  ed.player:setGuild(nil)
  if cost then
    createGuildCost = cost
  end
  if nil == data then
    return
  end
  joinPanel.joinLayer.noJoinGuild:setVisible(false)
  setGuildIcon(1, joinPanel.joinLayer.guildIcon)
  for i, v in ipairs(data) do
    local res = "UI/ITEM/s72.jpg"
    local datas = ed.getDataTable("GuildAvatar")
    if datas[v._avatar] then
      res = datas[v._avatar].Picture
    end
    local levelLimit = T(LSTR("GUILD.CLAN_LEVEL_NEEDS__D"), v._join_limit)
    local joinType = convertJoinType(v._join_type)
    local sjoinType = EDTables.guildConfig.guildJoinType[joinType]
    local name = T(LSTR("GUILD.TEXT_GUILD_JOIN_LIST_GUILDNAME__STEXT_GUILD_CREATE_WORDS_YELLOW___PLAYER"), v._name, v._member_cnt)
    joinPanel.joinLayer.guildListView:addItem({
      res,
      name,
      v._slogan,
      levelLimit,
      sjoinType
    }, {
      guildId = v._id
    })
  end
end
local function onJoinConfirm(data)
  if nil == data then
    return
  end
  if data._result == "fail" then
    return
  end
  local newMan = data._new_man
  if newMan then
    local item = guildPanel.memberList:addItem({
      {
        id = newMan._summary._avatar,
        scale = 0.6,
        vip = newMan._summary._vip > 0,
        level = newMan._summary._level,
        name = newMan._summary._name
      }
    }, {
      id = newMan._summary._avatar,
      level = newMan._summary._level,
      name = newMan._summary._name,
      vip = newMan._summary._vip > 0,
      playerId = newMan._uid,
      job = "member"
    })
    if newMan._summary._level < ed.player:getLevel() + EDTables.guildConfig.worshipLevelDif then
      item.controllers.worship:setVisible(false)
      item.controllers.worshipLabel:setVisible(false)
    end
    if item.controllers.name:getContentSize().width > 140 then
        item.controllers.name:setScale(140 / item.controllers.name:getContentSize().width)
      end
    memberNum = memberNum + 1
    setGuildMerberNum()
  end
end
local removeListMember = function(list, id)
  if not list or not id then
    return
  end
  local listData = list:getALLListData()
  for i, v in ipairs(listData) do
    if v.extraData and v.extraData.playerId == id then
      list:removeItem(i)
      break
    end
  end
end
local function removeMember(id)
  removeListMember(guildPanel.memberList, id)
  removeListMember(guildPanel.memberManagerLayer.membersList, id)
  for i, v in ipairs(guildMembers) do
    if v._uid == id then
      table.remove(guildMembers, i)
      break
    end
  end
end
local function onKickConfirm(data)
  if nil == data then
    return
  end
  if nil == guildPanel then
    return
  end
  if data._result == "success" then
    removeMember(selectMemberId)
    memberNum = math.max(0, memberNum - 1)
    setGuildMerberNum()
  end
end
local function onCreateGuild(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    ed.player:subrmb(createGuildCost)
    ed.showToast(T(LSTR("GUILD.CREATE_GUILD_SUCCESSFULLY")))
    ed.player:setGuildId(data._guild_info._summary._id)
    showGuildInfo(data._guild_info)
  end
end
local function onSettingChange(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    ed.showToast(T(LSTR("GUILD.MODIFY_SETTINGS_SUCCESSFULLY")))
    setGuildIcon(currentIcon, guildPanel.mainLayer.guildIcon)
    if guildSlogan == "" then
      ed.setString(guildPanel.mainLayer.slogan, T(LSTR("GUILD.THE_HOST_IS_TOO_LAZY_TO_WRITE_ANYTHING_HERE")))
    else
      ed.setString(guildPanel.mainLayer.slogan, guildSlogan)
    end
    setGuildSettingData()
  end
end
local function onAddGuild(data)
  if nil == data then
    return
  end
  if data._result == "join_enter" then
      ed.showToast(T(LSTR("GUILD.SUCCESSFULLY_JOINED_THE_GUILD")))
      showGuildInfo(data._guild_info)
  elseif data._result == "join_wait" then
    ed.showToast(T(LSTR("GUILD.APPLICATION_IS_SUCCESSFUL_AWAITING_APPROVAL")))
  elseif data._result == "join_fail" and data._cd_time then
    local str = ed.gethmsCString(data._cd_time)
    ed.showToast(T(EDTables.guildConfig.joinGuildFial[data._fail_reason], str))
  end
end
local function changeListJob(list, id, job)
  if not list then
    return
  end
  local listData = list:getALLListData()
  for i, v in ipairs(listData) do
    if v.extraData.playerId == id then
      if job == "chairman" then
        v.controllers.job:setVisible(true)
        ed.setString(v.controllers.job,T(LSTR("GUILDCONFIG.HOST")))
      elseif job == "elder" then
        v.controllers.job:setVisible(true)
        ed.setString(v.controllers.job,T(LSTR("guild.1.10.003")))
      else
        v.controllers.job:setVisible(false)
      end
      v.extraData.job = jobChange
      break
    end
  end
end
local refreshSelfJob = function()
end
local function refreshJob(id, job)
  for i, v in ipairs(guildMembers) do
    if v._uid == id then
      v._job = job
      break
    end
  end
  changeListJob(guildPanel.mainLayer.memberList, id, job)
  changeListJob(guildPanel.memberManagerLayer.membersList, id, job)
end
local function onSetJob(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    if jobChange == "chairman" then
      selfJob = "member"
      refreshJob(ed.getUserid(), selfJob)
      guildPanel.managerGuild:setVisible(false)
    end
    refreshJob(selectMemberId, jobChange)
    guildPanel.mainLayer.managerTag:setVisible(false)
    guildPanel.managerLayer.applyTab:setVisible(false)
    ed.showToast(T(LSTR("GUILD.SUCCESSFUL_OPERATION")))
  end
end
local function refreDispatchNum()
  local count = getSelfMercenaryNum()
  local vipLevel = ed.player:getvip()
  local dispatchLimit = ed.getDataTable("VIP")[vipLevel]["Guild Hero Dispatch Limit"]
  local temp = T("%d/%d", count, dispatchLimit)
  ed.setString(guildPanel.herosCampLayer.sendNum, temp)
end
function guild.openRule()
  guildPanel.instanceRuleLayer:setVisible(true)
  local list = guildPanel.instanceRuleLayer.listview
  if list:isEmpty() then
    list:addItem({
      T(LSTR("guild.1.10.019"))
    })
    list:addItem({
      T(LSTR("guild.1.10.020"))
    })
    list:addItem({
      T(LSTR("guild.1.10.021"))
    })
    list:addItem({
      T(LSTR("guild.1.10.022"))
    })
    list:addItem({
      T(LSTR("guild.1.10.023"))
    })
    list:addItem({
      T(LSTR("guild.1.10.024"))
    })
    list:addItem({
      T(LSTR("guild.1.10.025"))
    })
    list:addItem({
      T(LSTR("guild.1.10.026"))
    })
    list:addItem({
      T(LSTR("guild.1.10.027"))
    })
    list:addItem({
      T(LSTR("guild.1.10.028"))
    })
    list:addItem({
      T(LSTR("guild.1.10.029"))
    })
    list:addItem({
      T(LSTR("guild.1.10.030"))
    })
    list:addItem({
      T(LSTR("guild.1.10.031"))
    })
    list:addItem({
      T(LSTR("guild.1.10.032"))
    })
    list:addItem({
      T(LSTR("guild.1.10.033"))
    })
    list:addItem({
      T(LSTR("guild.1.10.034"))
    })
    list:addItem({
      T(LSTR("guild.1.10.035"))
    })
    list:addItem({
      T(LSTR("guild.1.10.036"))
    })
    list:addItem({
      T(LSTR("guild.1.10.037"))
    })
    list:addItem({
      T(LSTR("guild.1.10.038"))
    })
    list:addItem({
      T("<text|dark_white|>")
    })
    list:addItem({
      T("<text|dark_white| >")
    })
  end
end
function guild.closeInstanceRule()
  guildPanel.instanceRuleLayer:setVisible(false)
end
function guild.sendHero()
  local vipLevel = ed.player:getvip()
  local dispatchLimit = ed.getDataTable("VIP")[vipLevel]["Guild Hero Dispatch Limit"]
  if dispatchLimit <= getSelfMercenaryNum() then
    ed.showToast(T(LSTR("GUILD.THE_DISPATCHED_HEROES_HAVE_REACHED_THE_UPPER_LIMIT")))
    return
  end
  ed.ui.selectwindow.pop({
    name = "hero",
    noShowList = selfMercenaryList,
    withState = true,
    callback = DispathHero
  })
end
local function onShowHireHeros(data)
  if nil == data then
    return
  end
  if nil == guildPanel then
    return
  end
  local scene = ed.getCurrentScene()
  if scene.identity ~= "guild" then
    return
  end
  guildPanel.herosCampLayer:setVisible(true)
  guild.showHeroPage(1)
  guildPanel.herosCampLayer.selfHeros:setVisible(true)
  guildPanel.herosCampLayer.allHeros:setVisible(false)
  selfMercenaryList = {}
  selfMercenaryTime = {}
  guildPanel.herosCampLayer.heroList:clear()
  guildPanel.herosCampLayer.selfMercenaryList:clear()
  guildPanel.herosCampLayer.selfMercenaryList:addItem({})
  refreDispatchNum()
  if nil == data._users then
    return
  end
  for i = 1, #data._users do
    local user = data._users[i]
    if user._uid == ed.getUserid() and user._heroes then
      for i = 1, #user._heroes do
        local hero = ed.HeroCreate()
        hero:setup(user._heroes[i]._hero)
        local leftTime = user._heroes[i]._hire_ts
        local cost = user._heroes[i]._income
        addHeroIcon(hero, leftTime, cost)
      end
    end
    if user._heroes then
      for k, v in ipairs(user._heroes) do
        local heroInfo = {
          id = v._hero._tid,
          rank = v._hero._rank,
          level = v._hero._level,
          stars = v._hero._stars
        }
        local heroItemData = guildPanel.herosCampLayer.heroList:addItem({
          heroInfo,
          user._name
        }, {
          playerId = user._uid,
          playerName = user._name,
          heroId = v._hero._tid,
          playerLevel = user._level,
          playerAvatar = user._avatar
        })
        local heroItemMaxWidth = 165
        if heroItemData ~= nil then
          if heroItemData.width > heroItemMaxWidth then
            guildPanel.herosCampLayer.heroList.currentWidth =  guildPanel.herosCampLayer.heroList.currentWidth - (heroItemData.width - heroItemMaxWidth)
            guildPanel.herosCampLayer.heroList.endWidth =  guildPanel.herosCampLayer.heroList.endWidth - (heroItemData.width - heroItemMaxWidth)
            heroItemData.width = heroItemMaxWidth
          end

          if heroItemData.controllers.name:getContentSize().width > 140 then
            heroItemData.controllers.name:setScale(140 / heroItemData.controllers.name:getContentSize().width)
          end
        end
      end
    end
  end
  refreDispatchNum()
end
local function onAddHireHero(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    local hero = ed.player:getHero(currentDispatchId)
    addHeroIcon(hero, ed.getServerTime(), data._income)
    ed.record:refreshCommonRecord("sendMercenary")
  end
  refreDispatchNum()
  local hero = ed.player.heroes[currentDispatchId]
  if hero then
    hero._state = "hire"
  end
  local hero = ed.player:getHero(currentDispatchId)
  local heroInfo = {
    id = hero._tid,
    rank = hero._rank,
    level = hero._level,
    stars = hero._stars
  }
  local heroItemData = guildPanel.herosCampLayer.heroList:addItem({
    heroInfo,
    ed.player:getName()
  }, {
    playerId = ed.getUserid(),
    playerName = ed.player:getName(),
    heroId = hero._tid,
    playerLevel = ed.player:getLevel(),
    playerAvatar = ed.player:getAvatar()
  })
  local heroItemMaxWidth = 165
  if heroItemData ~= nil then
    if heroItemData.width > heroItemMaxWidth then
      guildPanel.herosCampLayer.heroList.currentWidth =  guildPanel.herosCampLayer.heroList.currentWidth - (heroItemData.width - heroItemMaxWidth)
      guildPanel.herosCampLayer.heroList.endWidth =  guildPanel.herosCampLayer.heroList.endWidth - (heroItemData.width - heroItemMaxWidth)
      heroItemData.width = heroItemMaxWidth
    end

    if heroItemData.controllers.name:getContentSize().width > 140 then
      heroItemData.controllers.name:setScale(140 / heroItemData.controllers.name:getContentSize().width)
    end
  end
end
function guild.exitGuild(callback)
  leaveCallback = callback
  local msg = ed.upmsg.guild()
  msg._leave = {}
  ed.send(msg, "guild")
end
local function onDeleteHireHero(data)
  if nil == data then
    return
  end
  if data._result ~= "success" then
    return
  end
  if selfMercenaryList[currentReturnIndex] == nil then
    return
  end
  local itemData = guildPanel.herosCampLayer.selfMercenaryList:getListData(currentReturnIndex)
  if nil == itemData then
    return
  end
  setItemVisible(itemData, false)
  selfMercenaryList[currentReturnIndex] = nil
  selfMercenaryTime[currentReturnIndex] = nil
  refreDispatchNum()
  itemData.controllers.heroIcon:removeAllChildrenWithCleanup(true)
  local goldChange = data._hire_reward + data._stay_reward
  ed.player:addMoney(goldChange)
  if goldChange > 0 then
    guildPanel.rewardLayer:setVisible(true)
    ed.setString(guildPanel.rewardLayer.income1, data._hire_reward)
    ed.setString(guildPanel.rewardLayer.income2, data._stay_reward)
  else
    ed.showToast(T(LSTR("GUILD.SUCCESSFUL_OPERATION")))
  end
  ed.player:cancelMercenary(data._heroid)
end
local function onGetWorshipReward(data)
  if nil == data then
    return
  end
  if data._rewards == nil then
    return
  end
  local items = {}
  for i, v in ipairs(data._rewards) do
    if v._type == "gold" then
      ed.player:addMoney(v._param1)
      table.insert(items, {
        type = "Gold",
        amount = v._param1,
        title = T(LSTR("GUILD.GAIN_GOLD_"))
      })
    elseif v._type == "diamond" then
      ed.player:addrmb(v._param1)
      table.insert(items, {
        type = "Diamond",
        amount = v._param1,
        title = T(LSTR("GUILD.GAIN_DIAMOND_"))
      })
    end
  end
  ed.announce({
    type = "getProp",
    param = {
      title = T(LSTR("GUILDCONFIG.WORSHIPMENT_AWARDS")),
      items = items
    }
  })
  ed.setString(guildPanel.worshihInfoLayer.worshTime, "0")
end
local function generateWorshipCost()
  if guildPanel then
    if currentWorshipType == 3 then
      local cost = tonumber(guildPanel.worshihTypeLayer.rmbCost:getString())
      ed.player:subrmb(cost)
    elseif currentWorshipType == 2 then
      local cost = tonumber(guildPanel.worshihTypeLayer.goldCost:getString())
      ed.player:addMoney(-cost)
    end
  end
end
local function onWorshipRsp(data)
  if nil == data then
    return
  end
  if data._result == "success" and guildPanel then
    guildPanel.worshipRewardLayer:setVisible(true)
    local ui = string.format("exp%d", currentWorshipType)
    local vitality = guildPanel.worshihTypeLayer[ui]:getString()
    ed.setString(guildPanel.worshipRewardLayer.income1, vitality)
    ed.player:addVitality(tonumber(vitality))
    worshipTime = worshipTime + 1
    refreshWorshipTimes()
    generateWorshipCost()
  end
end
local function onQueruHeroDetail(data)
  if nil == data then
    return
  end
  local hero = ed.HeroCreate()
  hero:setup(data._hero)
  if ed.ui.herodetail and guildPanel then
    local heroDetailLayer = ed.ui.herodetail.initWindow(hero, otherPlayerInfo)
    guildPanel:getScene().scene:addChild(heroDetailLayer.mainLayer, 120)
  end
end
local function onLeaveGuild(data)
  if data._result == "success" then
    ed.showToast(T(LSTR("GUILD.HAS_LEFT_OUT_THE_GUILD")))
    ed.player:setGuild(nil)
    ed.player:cancelAllMercenary()
    if leaveCallback then
      leaveCallback()
      leaveCallback = nil
    end
  end
end
local OnDisMiss = function(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    ed.player:setGuild(nil)
    ed.player:cancelAllMercenary()
    ed.popScene()
    ed.showToast(T(LSTR("GUILD.DISBAND_GUILD_SUCCESSFULLY")))
  end
end
function guild.isCurrentStageId(sid)
  for i, v in pairs(openInstanceInfo) do
    if v.stageId == sid then
      return true
    end
  end
  return false
end
function guild.getInstanceInfo(chapter)
  for i, v in pairs(openInstanceInfo) do
    local raidTable = ed.getDataTable("Raid")
    if raidTable[i] and raidTable[i]["Chapter ID"] == chapter then
      return v, i
    end
  end
end
local function addInstanceInfo(raidId, stageId, progress, leftTime, wholeProgress, startTime)
  local info = {}
  info.stageId = stageId
  info.progress = progress
  info.leftTime = leftTime
  info.RaidProgress = wholeProgress
  info.startTime = startTime
  openInstanceInfo[raidId] = info
end
function guild.showInstanceManager(index)
  selectInstanceIndex = index
  guildPanel.instanceManagerLayer:setVisible(true)
end
function guild.closeInstanceMangaer()
  guildPanel.instanceManagerLayer:setVisible(false)
end
function guild.openInstance(index)
  local item = guildPanel.guildInstanceLayer.instanceList:getListData(index)
  if item == nil then
    return
  end
  if item.extraData == nil then
    return
  end
  local instanceId = item.extraData.instanceId
  if instanceId > currentInstanceId then
    ed.showToast(T(LSTR("guild.1.10.004")))
    return
  end
  local row = ed.getDataTable("Raid")[instanceId]
  local costVitality = row["Guild Active Cost"]
  if costVitality > currentVitality then
    ed.showToast(T(LSTR("guild.2.0.0.003"), costVitality))
    return
  end
  selectInstanceId = instanceId
  local info = {
    text = T(LSTR("guild.2.0.0.004"), costVitality, row["Display Name"]),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        guild.conformOpen()
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
local function onInstanceQuery(data)
  if nil == data then
    return
  end
--  enableJoinTeam = data._is_can_jump == "true" and 1 or 0
  if guildPanel ~= nil then
    guildPanel.guildInstanceLayer:setVisible(true)
    guildPanel.guildInstanceLayer.instanceList:clear()
  end
  openInstanceInfo = {}
  currentInstanceId =  data._current_raid_id
  local raidTable = ed.getDataTable("Raid")
  if data._summary then
    for i, v in ipairs(data._summary) do
      addInstanceInfo(v._id, v._stage_id, v._stage_progress, v._left_time, v._progress, v._start_time)
      local name = raidTable[v._id]["Display Name"]
      local hintInfo = ""
      if v._progress == 10000 then
        hintInfo = T(LSTR("guild.1.10.040"), raidTable[v._id]["Fast Complete Extra Reward"])
      else
        local passTime = ed.getServerTime() - v._start_time
        local h, m, s = ed.second2hms(math.max(0, EDTables.guildConfig.guildInstanceTime - passTime))
        local d = math.floor(h / 24)
        h = h % 24
        if d > 0 then
          hintInfo = T(LSTR("guild.1.10.041"), d, h)
        elseif h > 0 then
          hintInfo = T(LSTR("guild.1.10.042"), h, m)
        elseif m > 0 then
          hintInfo = T(LSTR("guild.1.10.043"), m, s)
        end
      end
      local progress = string.format("<text|guild_join_list_guildname|%.2f%%>", v._progress / 100)
      local icon = string.format("<sprite|%s|0.75>", raidTable[v._id].Icon)
      if guildPanel ~= nil then
        local item = guildPanel.guildInstanceLayer.instanceList:addItem({
          icon,
          name,
          progress,
          hintInfo
        }, {
          stageId = v._stage_id,
          instanceId = v._id
        })
        local ui = item.itemPanel.controllers
        if ui.leftTime and ui.leftTime.width > 300 then
          ui.leftTime.rootNode:setScale(300 / ui.leftTime.width)
        end
        if selfJob == "member" then
          item.controllers.select:setVisible(false)
        else
          item.controllers.goInstance:setVisible(false)
        end
        local stencil = item.controllers.clippingNode:getStencil()
        stencil:setScaleX(v._progress / EDTables.guildConfig.wholePercent)
        if v._battle_user_id then
          item.controllers.battle:setVisible(true)
        end
        item.controllers.openInstance:setVisible(false)
      end
    end
  end
  if guildPanel then
    for i = 1, #raidTable do
      if openInstanceInfo[i] == nil then
        local name = raidTable[i]["Display Name"]
        local icon = string.format("<sprite|%s|0.75>", raidTable[i].Icon)
        local progress = string.format(T(LSTR("guild.1.10.044")))
        local item = guildPanel.guildInstanceLayer.instanceList:addItem({
          icon,
          name,
          progress,
          ""
        }, {instanceId = i})
        item.controllers.goInstance:setVisible(false)
        item.controllers.select:setVisible(false)
        if i > currentInstanceId then
          item.controllers.openInstance:setVisible(false)
          item.controllers.mask:setVisible(true)
        elseif selfJob ~= "member" then
          item.controllers.openInstance:setVisible(true)
          item.controllers.openCost:setVisible(true)
          local costVitality = raidTable[i]["Guild Active Cost"]
          local str = T("<sprite|UI/alpha/HVGA/guild/money_guildactive_small.png|0.8>")
          if costVitality <= currentVitality then
            str = str .. T("<text|normalButton| %d>", costVitality)
          else
            str = str .. T("<text|normal_red| %d>", costVitality)
          end
          item.controllers.openCost:setString(str)
        else
          item.controllers.openInstance:setVisible(false)
        end
      end
    end
  end
  FireEvent("GuildInstanceQuery", data._stage_pass)
  FireEvent("GuildInstanceQuery2")
end
function guild.getCanJump()
  return enableJoinTeam == 1
end
local function onInstanceOpen(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    local instanceList = guildPanel.guildInstanceLayer.instanceList
    local itemNum = instanceList:getListDataNum()
    local costVitality = ed.getDataTable("Raid")[data._raid_id]["Guild Active Cost"]
    currentVitality = currentVitality - costVitality
    refreshVitality()
    for i = 1, itemNum do
      local item = instanceList:getListData(i)
      if item and item.extraData and item.extraData.instanceId == data._raid_id then
        local raidTable = ed.getDataTable("Raid")
        local stageId = raidTable[data._raid_id]["Begin Stage ID"]
        ed.setString(item.controllers.progress,"<text|guild_join_list_guildname|0.00%>")
        ed.setString(item.controllers.leftTime,T(LSTR("guild.1.10.045")))
        item.extraData.stageId = stageId
        if selfJob ~= "member" then
          item.controllers.select:setVisible(true)
        else
          item.controllers.goInstance:setVisible(true)
        end
        local stencil = item.controllers.clippingNode:getStencil()
        stencil:setScaleX(0)
        addInstanceInfo(data._raid_id, stageId, 0, data._left_time, 0, ed.getServerTime())
        item.controllers.openInstance:setVisible(false)
        item.controllers.openCost:setVisible(false)
        break
      end
    end
  end
end
local onInstanceDetail = function(data)
  if nil == data then
    return
  end
  local guildInstanceData = {}
  guildInstanceData.step = data._wave
  guildInstanceData.hp = data._hp
  guildInstanceData.challenger = data._challenger
  guildInstanceData.stage = data._stage
  guildInstanceData.state = data._challenger_status
  local scene = ed.getCurrentScene()
  if scene.identity == "stageDetail" then
    FireEvent("GuildInstanceDetail", guildInstanceData)
  else
    ed.pushScene(ed.ui.stagedetail.create(data._stage, {guildInstanceData = guildInstanceData}, "guild"))
  end
end
local onInstanceStart = function(data)
  if nil == data then
    return
  end
  ed.record:refreshCommonRecord("enterRaid")
  ed.srand(data._rseed)
  ed.netreply.enterGuildInstance(nil, nil, nil, nil, data._instance_info)
  ed.netreply.enterGuildInstance = nil
  ed.player.loots = data._loots or {}
  ed.player.hpLoots = ed.copyProto(data._hp_drop or {}) or {}
end
local function refreshInstanceProgress()
  if nil == guildPanel then
    return
  end
  local instanceList = guildPanel.guildInstanceLayer.instanceList
  for i = 1, instanceList:getListDataNum() do
    local item = instanceList:getListData(i)
    if item and item.extraData.instanceId then
      local info = openInstanceInfo[item.extraData.instanceId]
      if info then
        local progress = string.format("<text|guild_join_list_guildname|%.2f%%>", info.RaidProgress / 100)
        local stencil = item.controllers.clippingNode:getStencil()
        stencil:setScaleX(info.RaidProgress / EDTables.guildConfig.wholePercent)
        ed.setString(item.controllers.progress,progress)
      end
    end
  end
end
local function openNewInstance(raidID)
  local row = ed.getDataTable("Raid")[raidID + 1]
  if not row then
    return
  end
  if openInstanceInfo[raidID + 1] then
    return
  end
  currentInstanceId = currentInstanceId + 1
  local maxTime = ed.getDataTable("VIP")[ed.player:getvip()]["Raid Enter Times"]
  addInstanceInfo(currentInstanceId, row["Begin Stage ID"], 0, maxTime, 0, ed.getServerTime())
end
local function onInstanceEnd(data)
  if nil == data then
    return
  end
  local summay = data._summary
  if data._result == "canceled" then
    ed.ui.stageaccount.initialize({
      stage_id = summay._stage_id,
      victory = false,
      loseType = "fail",
      isPveMode = false
    })
    return
  end
  local guildInstanceData = {}
  guildInstanceData.damage = ed.engine:getPlayerTotalDamage()
  guildInstanceData.oldProgress = data._stage_old_progress
  guildInstanceData.nowProgress = summay._stage_progress
  guildInstanceData.guildCoin = 0
  guildInstanceData.breakHistory = data._break_history
  if openInstanceInfo[summay._id].stageId ~= summay._stage_id then
    guildInstanceData.nowProgress = EDTables.guildConfig.wholePercent
    guildInstanceData.guildCoin = EDTables.guildConfig.guildCoinCount
  end
  local vipLevel = ed.player:getvip()
  local scale = ed.getDataTable("VIP")[vipLevel]["Raid Gold Bonus"]
  guildInstanceData.gold = math.floor(guildInstanceData.damage / 10) * scale
  ed.player:addMoney(guildInstanceData.gold)
  local guildCoin = guildInstanceData.guildCoin + (guildInstanceData.breakHistory and guildInstanceData.breakHistory._guildpoint or 0)
  ed.player:addGuildMoney(guildCoin)
  if guildInstanceData.breakHistory then
    ed.player:addrmb(guildInstanceData.breakHistory._diamond)
  end
  local loots = {}
  if data._rewards then
    for i, v in ipairs(data._rewards) do
      table.insert(loots, {
        type = ed.itemType(v),
        id = v
      })
    end
  end
  if data._apply_rewards then
    local specialLoots = {}
    for i, v in ipairs(data._apply_rewards) do
      if specialLoots[v] == nil then
        specialLoots[v] = 1
      else
        specialLoots[v] = specialLoots[v] + 1
      end
    end
    guildInstanceData.specialLoots = specialLoots
  end
  local args = {
    victory = true,
    stage_id = ed.engine.stage_info["Stage ID"],
    heroes = ed.engine.hero_id_list,
    loots = loots,
    guildInstanceData = guildInstanceData,
    mercenaryInfo = ed.engine:getTeamMercenaryInfo()
  }
  ed.player:takeStageReward(args.stage_id, nil, ed.engine.hero_list, loots)
  ListenTimer(Timer:Once(2), function()
    ed.ui.stageaccount.initialize(args)
  end)
  addInstanceInfo(summay._id, summay._stage_id, summay._stage_progress, summay._left_time, summay._progress, summay._start_time)
  if summay._progress == EDTables.guildConfig.wholePercent then
    openNewInstance(summay._id)
  end
  refreshInstanceProgress()
end
local onInstanceDrop = function(data)
  if nil == data then
    return
  end
  ed.showGuildReward(data)
end
local function onDropInfo(data)
  if nil == data then
    return
  end
  if data._items then
    guildPanel.rewardInfoLayer:setVisible(true)
    guildPanel.managerLayer:setVisible(false)
    guildPanel.rewardInfoLayer.rewardList:clear()
    guildMembersInfo = {}
    for i, v in ipairs(data._members) do
      guildMembersInfo[v._uid] = v
    end
    table.sort(data._items, function(a, b)
      return a._raid_id < b._raid_id
    end)
    for i, v in ipairs(data._items) do
      if v._item_info then
        guildPanel.rewardInfoLayer.rewardList:changeItemConfig(2)
        local raidName = ed.getDataTable("Raid")[v._raid_id]["Display Name"]
        guildPanel.rewardInfoLayer.rewardList:addItem({raidName})
        guildPanel.rewardInfoLayer.rewardList:changeItemConfig()
        local records = {}
        local maxDamage = 0
        if v._dps_list then
          for i, v in ipairs(v._dps_list) do
            if maxDamage < v._dps then
              maxDamage = v._dps
            end
            records[v._uid] = v._dps
          end
        end
        for _, item in ipairs(v._item_info) do
          local endTime = item._time_out_end
		--Todo: 0表示无时间限制,需求待完善
          if endTime == 0 or endTime > ed.getServerTime() then
            local icon = string.format("<item|%d|0.8>", item._item_id)
            local leftTime = endTime - ed.getServerTime()
            local h, m = ed.second2hms(leftTime)
            local time
            if h > 0 then
              time = string.format(LSTR("guild.1.10.046"), h, m)
            else
              time = string.format(LSTR("guild.1.10.047"), m)
            end
            local hint = string.format(T(LSTR("guild.1.10.048")), item._user_id and #item._user_id or 0)
            guildPanel.rewardInfoLayer.rewardList:addItem({
              icon,
              time,
              hint
            }, {
              item = item._item_id,
              raidId = v._raid_id,
              user = item._user_id,
              time = item._time_out_end,
              record = records,
              maxDamage = maxDamage
            })
          end
        end
      end
    end
  else
    ed.showToast(T(LSTR("guild.1.10.049")))
  end
end
local function onDropGive(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    ed.showToast(T(LSTR("guild.1.10.050")))
    guildPanel.rewardDetailLayer:setVisible(false)
    guildPanel.rewardInfoLayer.rewardList:removeItem(selectDropIndex)
    guildPanel.rewardInfoLayer.rewardList.dragList:reset()
    leftDistributeTime = leftDistributeTime - 1
  else
    ed.showToast(T(LSTR("guild.1.10.051")))
  end
end
local onInstanceDamage = function(data)
  if nil == data then
    return
  end
  if data._damages == nil then
    ed.showToast(T(LSTR("guild.1.10.052")))
  else
    ed.showGuildDamage(data._damages)
  end
end
local onRewardRecord = function(data)
  if nil == data then
    ed.showToast(T(LSTR("guild.1.10.053")))
    return
  end
  ed.showGuildRewardRecord(data._item_historys)
end
local function OnGuildRsp(data)
  if data._list then
    ed.pushScene(ed.ui.guild.create())
    refreshGuildList(data._list._guilds, data._list._create_cost)
  elseif data._create then
    onCreateGuild(data._create)
  elseif data._query then
    ed.pushScene(ed.ui.guild.create())
    showGuildInfo(data._query._info, data._query._worship, data._query._drop_info)
    if data._query._to_chairman then
      ListenTimer(Timer:Once(0.5), function()
        ed.showToast(T(LSTR("guild.1.10.054")))
      end)
    end
  elseif data._search then
    showSearchInfo(data._search._guilds)
  elseif data._join then
    onAddGuild(data._join)
  elseif data._set then
    onSettingChange(data._set)
  elseif data._join_confirm then
    onJoinConfirm(data._join_confirm)
  elseif data._kick then
    onKickConfirm(data._kick)
  elseif data._set_job then
    onSetJob(data._set_job)
  elseif data._query_hires then
    onShowHireHeros(data._query_hires)
  elseif data._add_hire then
    onAddHireHero(data._add_hire)
  elseif data._del_hire then
    onDeleteHireHero(data._del_hire)
  elseif data._worship_withdraw then
    onGetWorshipReward(data._worship_withdraw)
  elseif data._worship_req then
    onWorshipRsp(data._worship_req)
  elseif data._query_hh_detail then
    onQueruHeroDetail(data._query_hh_detail)
  elseif data._leave then
    onLeaveGuild(data._leave)
  elseif data._dismiss then
    OnDisMiss(data._dismiss)
  elseif data._instance_query then
    onInstanceQuery(data._instance_query)
  elseif data._instance_open then
    onInstanceOpen(data._instance_open)
  elseif data._instance_detail then
    onInstanceDetail(data._instance_detail)
  elseif data._instance_start then
    onInstanceStart(data._instance_start)
  elseif data._instance_end then
    onInstanceEnd(data._instance_end)
  elseif data._instance_drop then
    onInstanceDrop(data._instance_drop)
  elseif data._drop_info then
    onDropInfo(data._drop_info)
  elseif data._drop_give then
    onDropGive(data._drop_give)
  elseif data._instance_damage then
    onInstanceDamage(data._instance_damage)
  elseif data._items_history then
    onRewardRecord(data._items_history)
  elseif data._guild_stage_rank then
    ed.showGuildInstanceRank(data._guild_stage_rank)
  end
end
ListenEvent("GuildRsp", OnGuildRsp)

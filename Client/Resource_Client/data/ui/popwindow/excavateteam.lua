local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.excavateteam = class
local getVitalityCost = function(self)
  local row = ed.getDataTable("Stage")[self.stage_id]
  local vc = row["Vitality Cost"]
  return vc
end
class.getVitalityCost = getVitalityCost
local enterExcavateChange = function(self)
  local scene = ed.ui.battleprepare.create({
    mode = "excavateChange",
    excavateid = self.excavateId,
    excavateTeam = self.teamData,
    excavateCallback = function(param)
      local data = ed.ui.excavate.getTeamData({
        excavateId = self.excavateId,
        teamId = self.teamId
      })
      if not data then
        data = ed.downmsg.excavate_team()
        data._team_id = ed.getUserid()
        ed.ui.excavate.addTeamData({
          excavateId = self.excavateId,
          data = data
        })
      end
      data._hero_bases = {}
      for i = 1, #param do
        local tid = param[i]
        local hero = ed.player.heroes[tid]
        local hs = ed.downmsg.hero_summary()
        hero._tid = tid
        hero._rank = hero._rank
        hero._level = hero._level
        hero._stars = hero._stars
        hero._gs = hero._gs
        table.insert(data._hero_bases, hero)
      end
      ed.ui.excavate.updateTeamData(self.excavateId, self.teamId)
    end
  })
  ed.pushScene(scene)
end
class.enterExcavateChange = enterExcavateChange
local initMineHeroData = function(self, param)
  local team = ed.ui.excavate.getTeamData(param)
  if not team then
    return
  end
  local base = team._hero_bases or {}
  team._hero_dynas = team._hero_dynas or {}
  local dyna = team._hero_dynas
  local heroes = {}
  for i, v in pairs(base) do
    if not dyna[i] then
      dyna[i] = ed.downmsg.hero_dyna()
      dyna[i]._hp_perc = 10000
      dyna[i]._mp_perc = 0
    end
    heroes[i] = {
      base = base[i],
      dyna = dyna[i]
    }
  end
  return heroes
end
class.initMineHeroData = initMineHeroData
local initMineTeamData = function(self, heroes)
  if not heroes then
    return
  end
  local team = {}
  for i = 1, #heroes do
    local hero = heroes[i]
    local base = hero.base
    local hid = base._tid
    table.insert(team, hid)
  end
  self.teamData = team
end
class.initMineTeamData = initMineTeamData
local initMineTeam = function(self, param)
  local ui = self.ui
  for i = 1, #(ui.hero_icons or {}) do
    local icon = ui.hero_icons[i]
    if not tolua.isnull(icon) then
      icon:removeFromParentAndCleanup(true)
    end
  end
  local heroes = param.heroes
  local hero_icons = {}
  self:initMineTeamData(heroes)
  for i = 1, #heroes do
    local hero = heroes[i]
    local container = ui["hero_container_" .. i]
    local base = hero.base
    local hid = base._tid
    local icon = ed.readhero.createIcon({
      id = hid,
      level = base._level,
      rank = base._rank,
      stars = base._stars
    }).icon
    icon:setAnchorPoint(ccp(0, 0))
    container:addChild(icon)
    table.insert(hero_icons, icon)
  end
  ui.cg_button_container:setVisible(false)
  ui.go_battle_button:setVisible(false)
  if param.teamid == ed.getUserid() then
    ui.cg_button_container:setVisible(true)
    self:btRegisterButtonClick({
      button = ui.change_team_button,
      press = ui.change_team_button_press,
      key = "change_team_button",
      clickHandler = function()
        self:enterExcavateChange()
      end,
      priority = -10,
      force = true
    })
    self:btRegisterButtonClick({
      button = ui.give_up_button,
      press = ui.give_up_button_press,
      key = "give_up_button",
      clickHandler = function()
        ed.ui.excavategiveup.pop(self.excavateId, function()
          self:destroy({skipAnim = true})
          if self.getScene().initMap then
            self:getScene():initMap()
          end
        end)
      end,
      force = true
    })
  end
  return hero_icons
end
class.initMineTeam = initMineTeam
local initEnemyTeam = function(self, param)
  local ui = self.ui
  for i = 1, #(ui.hero_icons or {}) do
    local icon = ui.hero_icons[i]
    if not tolua.isnull(icon) then
      icon:removeFromParentAndCleanup(true)
    end
  end
  local heroes = param.heroes
  local isWild = param.isWild
  local enemyGuildName = param.enemyGuildName
  local hero_icons = {}
  local enemyAlive
  for i = 1, #(heroes or {}) do
    local hero = heroes[i]
    local container = ui["hero_container_" .. i]
    local heroData = hero.base
    local heroDyna = hero.dyna
    local icon = ed.readhero.createIcon({
      id = heroData._tid,
      level = heroData._level,
      stars = heroData._stars,
      hp = heroDyna._hp_perc,
      rank = heroData._rank,
      length = 80
    }).icon
    icon:setAnchorPoint(ccp(0, 0))
    container:addChild(icon)
    table.insert(hero_icons, icon)
    if heroDyna._hp_perc > 0 then
      enemyAlive = true
    end
  end
  ui.cg_button_container:setVisible(false)
  ui.go_battle_button:setVisible(true)
  if enemyAlive then
    ui.go_battle_button_press:setVisible(false)
    self:btRegisterButtonClick({
      button = ui.go_battle_button,
      press = ui.go_battle_button_press,
      key = "go_battle_button",
      clickHandler = function()
        if ed.ui.excavate.checkMineExcavateMax() and self.excavateId ~= ed.player.excavateAttackId then
          if ed.ui.excavate.canMineExcavateBeMore() then
            ed.showHandyDialog("needHighervip", {
              wholeText = LSTR("MAP.THE_TREASURE_HAS_REACHED_THE_MAXIMUM_NUMBER_PLEASE_UPGRADE_YOUR_VIP_LEVEL")
            })
          else
            ed.showToast(T(LSTR("EXCAVATETEAM.TREASURE_REACHED_THE_MAXIMUM_NUMBER_OF_CURRENT_OCCUPATION_NOT_ATTACK")))
          end
          return
        end
        local guildName = ed.player:getGuildName() or ""
        if (enemyGuildName or "") ~= "" and guildName ~= "" and enemyGuildName == guildName then
          ed.showToast(T(LSTR("EXCAVATETEAM.SOCIETY_CAN_NOT_ATTACK_WITH_A_SMALL_PARTNER")))
          return
        end
        local data = ed.ui.excavate.getData(self.excavateId)
        if data._state == "revengeProtect" and data._state_end_ts > ed.getServerTime() then
          ed.showToast(T(LSTR("EXCAVATETEAM.THIS_TREASURE_IS_TEMPORARILY_UNABLE_TO_ATTACK")))
        else
          local vc = self:getVitalityCost()
          if vc > ed.player:getVitality() then
            ed.showHandyDialog("buyVitality", {
              reply = function()
                self:refreshVitalityCost()
              end
            })
          else
            do
              local function gotoPrepare()
                local scene = ed.ui.battleprepare.create({
                  mode = "excavateAttack",
                  stage_id = self.stage_id,
                  excavateEnemy = heroes,
                  isExcavateBot = isWild,
                  excavateTeamid = self.teamId,
                  excavateTeamSvrid = self.svrid,
                  excavateTypeid = self.typeid,
                  excavateid = self.excavateId,
                  hireMercenary = ed.mercenary.getExcavateMercenary()
                })
                ed.pushScene(scene)
              end
              if not ed.ui.excavate.checkAttacking(self.excavateId) then
                local info = {
                  text = T(LSTR("EXCAVATETEAM.COMBAT_DATA_WILL_BE_EMPTIED_BEFORE_THE_FIGHTING_BEGAN_CONTINUE")),
                  rightHandler = function()
                    local function handler(result)
                      if not result then
                        ed.showToast(T(LSTR("EXCAVATENET.FAILED_TO_ENTER_BATTLE")))
                        return
                      end
                      ed.ui.excavate.removeAttackData()
                      gotoPrepare()
                    end
                    ed.registerNetReply("clear_excavate_battle", handler)
                    ed.ui.excavate.doClearExcavateBattle()
                  end
                }
                ed.showConfirmDialog(info)
              else
                gotoPrepare()
              end
            end
          end
        end
      end,
      force = true
    })
  else
    ui.go_battle_button_press:setVisible(true)
    self:btRegisterButtonClick({
      button = ui.go_battle_button,
      key = "go_battle_button",
      clickHandler = function()
        ed.showToast(T(LSTR("EXCAVATETEAM.THIS_DEFENSIVE_POINT_HAS_BEEN_CAPTURED_")))
      end,
      force = true
    })
  end
  return hero_icons
end
class.initEnemyTeam = initEnemyTeam
local initTeam = function(self, param)
  param = param or {}
  local owner = self.owner
  local team = ed.ui.excavate.getTeamData(param)
  local ui = self.ui
  local base = team._hero_bases or {}
  team._hero_dynas = team._hero_dynas or {}
  local dyna = team._hero_dynas
  local playerInfo = team._player or {}
  local svrid = team._svr_id
  local displaysvrid = team._display_svr_id
  local svrName = team._svr_name
  local avatar = playerInfo._avatar
  local name = playerInfo._name
  local level = playerInfo._level
  local vip = playerInfo._vip
  local guildName = playerInfo._guild_name
  local heroes = {}
  for i, v in pairs(base) do
    if not dyna[i] then
      dyna[i] = ed.downmsg.hero_dyna()
      dyna[i]._hp_perc = 10000
      dyna[i]._mp_perc = 0
    end
    heroes[i] = {
      base = base[i],
      dyna = dyna[i]
    }
  end
  local enemyid = team._team_id
  local row = ed.getDataTable("ExcavateWildEnemy")[enemyid]
  if owner == "monster" then
    local stageid = row["Stage ID"][1]
    self.stage_id = stageid
  elseif owner == "others" then
    local typeid = ed.ui.excavate.getData(self.excavateId)._type_id
    local stageid = ed.getDataTable("ExcavateTreasure")[typeid]["PVP Stage ID"]
    self.stage_id = stageid
  end
  if owner == "mine" then
    avatar = avatar or ed.player:getAvatar()
    name = name or ed.player:getName()
    level = level or ed.player:getLevel()
    vip = vip or ed.player:getvip()
  elseif owner == "monster" then
    heroes = ed.ui.excavate.getStageEnemyData({
      id = self.stage_id,
      dynas = dyna,
      excavateId = param.excavateId,
      teamId = param.teamId
    })
    local monsterTeam = {
      _hero_bases = {},
      _hero_dynas = {}
    }
    for i, v in pairs(heroes) do
      monsterTeam._hero_bases[i] = v.base
      monsterTeam._hero_dynas[i] = v.dyna
    end
    ed.ui.excavate.setMonsterTeam(param.excavateId, param.teamId, monsterTeam)
    avatar = row["Avatar ID"]
    name = row["Player Name"]
    level = row["Player Level"]
    vip = 0
  end
  avatar = math.max(avatar or 1, 1)
  level = level or 1
  vip = vip or 0
  local headContainer = ui.head_container
  local headIcon = ed.getTeamHead({
    id = avatar,
    type = vip > 0 and "vip" or "common"
  })
  headIcon:setAnchorPoint(ccp(0, 0))
  headIcon:setPosition(ccp(-10, -10))
  headContainer:addChild(headIcon)
  ui.headIcon = headIcon
  local levelContainer = ui.level_container
  local levelIcon = ed.getLevelIcon({
    level = level,
    type = vip > 0 and "vip" or "common"
  })
  levelIcon:setAnchorPoint(ccp(0, 0))
  levelIcon:setPosition(ccp(0, -4))
  levelContainer:addChild(levelIcon)
  ui.levelIcon = levelIcon
  if owner == "others" then
    if displaysvrid then
      ui.svr_label = ed.createNode({
        t = "Label",
        base = {
          text = T(LSTR("excavateteam.1.10.1.001"), displaysvrid, svrName),
          size = 20
        },
        config = {
          color = ccc3(251, 237, 211)
        }
      }, ui.guild_container)
    end
    if guildName then
      ed.setString(ui.guild_name, guildName .. T(LSTR("CHATCONFIG.GUILD")))
      if not tolua.isnull(ui.svr_label) then
        ed.right2(ui.svr_label, ui.guild_name, 50)
      end
    else
      ed.setString(ui.guild_title, T(LSTR("EXCAVATETEAM.THE_PLAYER_IS_NOT_A_MEMBER_OF_ANY_GUILD")))
      if not tolua.isnull(ui.svr_label) then
        ed.right2(ui.svr_label, ui.guild_title, 50)
      end
    end
  end
  local nameLabel = ui.name
  ed.setLabelString(nameLabel, name)
  if owner == "mine" then
    ui.hero_icons = self:initMineTeam({
      teamid = team._team_id,
      heroes = heroes
    })
  elseif owner == "others" or owner == "monster" then
    ui.hero_icons = self:initEnemyTeam({
      heroes = heroes,
      isWild = owner == "monster",
      enemyGuildName = guildName
    })
  end
end
class.initTeam = initTeam
local function create(param)
  param = param or {}
  local self = base.create("excavateteam")
  setmetatable(self, class.mt)
  self.owner = param.owner
  self.excavateId = param.excavateId
  self.teamId = param.teamId
  self.skipWindow = param.skipWindow
  self.typeid = param.typeid
  self.svrid = (ed.ui.excavate.getTeamData(param) or {})._svr_id
  if self.owner == "mine" and self.teamId == ed.getUserid() then
    local heroes = self:initMineHeroData(param)
    if not self.skipWindow then
    elseif #(heroes or {}) == 0 then
      self:initMineTeamData(heroes)
      self:enterExcavateChange()
      return
    end
  end
  local container, ui = ed.editorui(ed.uieditor.excavateteam)
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self.mainLayer:registerScriptHandler(function(event)
    xpcall(function()
      if event == "enter" then
        self:enterExcavateTeam()
      end
    end, EDDebug)
  end)
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    priority = -1
  })
  self:show()
  return self
end
class.create = create
local refreshBaseRecord = function(self)
  if tolua.isnull(self.mainLayer) then
    self:getScene():removeUpdateHandler("update_base_record")
    return
  end
  local ui = self.ui
  local type_id_group = {
    gold = {
      4,
      5,
      6
    },
    diamond = {
      1,
      2,
      3
    },
    exp = {
      7,
      8,
      9
    }
  }
  for k, v in pairs(type_id_group) do
    if ed.isElementInTable(ed.ui.excavate.getData(self.excavateId)._type_id, v) then
      ui["lack_icon_" .. k]:setVisible(true)
      ui["speed_icon_" .. k]:setVisible(true)
    else
      ui["lack_icon_" .. k]:setVisible(false)
      ui["speed_icon_" .. k]:setVisible(false)
    end
  end
  local unitTime = 60
  local storageAmount = ed.ui.excavate.getProduced(self.excavateId, self.teamId)
  local speedAmount = ed.ui.excavate.getProduceSpeed(self.excavateId, self.teamId) * 60
  storageAmount = math.floor(storageAmount)
  local pstr = "%d/%d"
  if speedAmount - math.floor(speedAmount) > 0 then
    pstr = "%.1f/%d"
  end
  ed.setLabelString(ui.lack_number_label, T("x%s", storageAmount))
  ed.setLabelString(ui.speed_number_label, "x" .. T(pstr, speedAmount, unitTime / 60) .. T(LSTR("TIME.HOUR")))
end
class.refreshBaseRecord = refreshBaseRecord
local refreshVitalityCost = function(self)
  local label = self.ui.vitality_number
  local vc = self:getVitalityCost()
  if vc > ed.player:getVitality() then
    ed.setLabelColor(label, ccc3(255, 0, 0))
  else
    ed.setLabelColor(label, ccc3(254, 234, 197))
  end
end
class.refreshVitalityCost = refreshVitalityCost
local enterExcavateTeam = function(self)
  local data = ed.ui.excavate.getData(self.excavateId)
  local team = ed.ui.excavate.getTeamData({
    excavateId = self.excavateId,
    teamId = self.teamId
  })
  if not data or not team then
    self:destroy({skipAnim = true})
    return
  end
  self:initTeam({
    excavateId = self.excavateId,
    teamId = self.teamId
  })
  ed.ui.excavate.setCurrentBattleid(self.excavateId, self.teamId)
  if data._owner == "mine" then
    self.ui.vitality_container:setVisible(false)
    self.ui.guild_container:setVisible(false)
    self.ui.explain_container:setVisible(true)
    self:refreshBaseRecord()
    do
      local count = 0
      self:getScene():registerUpdateHandler("update_base_record", function(dt)
        xpcall(function()
          count = count + dt
          if count > 180 then
            self:refreshBaseRecord()
            count = count - 180
          end
        end, EDDebug)
      end)
    end
  else
    self.frame_container_pos = self.frame_container_pos or ccp(self.ui.frame_container:getPosition())
    self.ui.vitality_container:setVisible(true)
    local vc = self:getVitalityCost()
    ed.setLabelString(self.ui.vitality_number, vc)
    self:refreshVitalityCost()
    self.ui.explain_container:setVisible(false)
    if data._owner == "monster" then
      self.ui.guild_container:setVisible(false)
      self.ui.frame_container:setPosition(ccpAdd(self.frame_container_pos, ed.DGccp(0, -35)))
      self.ui.frame:setContentSize(ed.DGSizeMake(810, 265))
    elseif data._owner == "others" then
      self.ui.guild_container:setVisible(true)
    end
    self:getScene():removeUpdateHandler("update_base_record")
  end
  local function checkHeroAlive()
    local dyna = team._hero_dynas
    for k, v in pairs(dyna or {}) do
      if v._hp_perc > 0 then
        return true
      end
    end
    return false
  end
  if self.isMultiEnter then
    if (data or {})._owner ~= self.owner or not checkHeroAlive() then
      self:destroy({skipAnim = true})
      return
    end
  end
  self.isMultiEnter = true
end
class.enterExcavateTeam = enterExcavateTeam

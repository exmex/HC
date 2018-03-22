
local ed = ed
local class = {
  mt = {}
}
ed.ui.stagedetail = class
class.mt.__index = class
local base = ed.ui.framework
setmetatable(class, base.mt)
local res = ed.ui.stagedetailres
local lsr = ed.ui.stagedetaillsr.create()
local function readSweepReply(self, info)
  local list = {}
  local wave = info._loot
  for k, v in pairs(wave) do
    local exp = v._exp
    local money = v._money
    local ll = {
      exp = exp,
      money = money,
      loots = {}
    }
    for ck, cv in pairs(v._items or {}) do
      local id = ed.bits(cv, 0, 10)
      local amount = ed.bits(cv, 10, 11)
      table.insert(ll.loots, {id = id, amount = amount})
    end
    table.insert(list, ll)
  end
  local el = {
    loots = {}
  }
  for k, v in pairs(info._items or {}) do
    local id = ed.bits(v, 0, 10)
    local amount = ed.bits(v, 10, 11)
    table.insert(el.loots, {id = id, amount = amount})
  end
  table.insert(list, el)
  return list
end
class.readSweepReply = readSweepReply
local function doSendSweepReply(self)
  local function handler(info)
    self:resetSweepLabel()
    local lootList = self:readSweepReply(info)
    local sweepWindow = ed.ui.repeatRewardWindow.create(lootList)
    function sweepWindow.destroyHandler()
      if ed.player:getLevel() > self.playerLevelPreSweep then
        ed.announce({
          type = "playerLevelup",
          param = {
            preLevel = self.playerLevelPreSweep
          }
        })
      end
    end
    self.sweepWindow = sweepWindow
    self.sweepWindow.parent = self
    if not tolua.isnull(self.scene) then
     self.scene:addChild(sweepWindow.mainLayer, 101)
    end
    self:refreshStageLimit()
    self:refreshSweepSomeLabel()
    self:refreshSweepContainer()
  end
  return handler
end
class.doSendSweepReply = doSendSweepReply
local function getSweepPrice(self, times)
  local price = ed.parameter.pay_sweep_unit_price
  price = price * times
  return price
end
class.getSweepPrice = getSweepPrice
local function doSendSweep(self, type, times)
  local function handler()
    if times < 1 then
      return
    end
    local cost = self:getSweepPrice(times) or 0
    if type == "pay" and cost > ed.player._rmb then
      ed.showHandyDialog("toRecharge")
      return
    end
    self.playerLevelPreSweep = ed.player:getLevel()
    ed.netdata.sweep = {
      type = type,
      times = times,
      power = self.stageInfo.power,
      cost = type == "pay" and self:getSweepPrice(times) or 0,
      stage = self.stage
    }
    ed.netreply.sweep = self:doSendSweepReply()
    local msg = ed.upmsg.sweep_stage()
    msg._type = type == "free" and "sweep_with_ticket" or "sweep_with_rmb"
    msg._stageid = self.stage
    msg._times = times
    ed.send(msg, "sweep_stage")
  end
  return handler
end
class.doSendSweep = doSendSweep
local function doPaySweepConfirm(self, times)
  local price = self:getSweepPrice(times)
  ed.showConfirmDialog({
    text = T(LSTR("STAGEDETAIL.RAID_TICKET_HAS_BEEN_USED_UP_NEXT_RAID_TAKES__D_DIAMONDS_\N_CONFIRM_TO_CONTINUE"), price),
    rightHandler = self:doSendSweep("pay", times)
  })
end
class.doPaySweepConfirm = doPaySweepConfirm
local function refreshSweepSomeLabel(self)
  if not self.repeatui then
    return
  end
  if tolua.isnull(self.repeatui.some_label) then
    return
  end
  self:getRepeatInformation()
  local text = ""
  if self.repeatInfo.limit < 1 then
    text = T(LSTR("STAGEDETAIL.RAID_FAILED"))
  else
    text = T(LSTR("STAGEDETAIL.RAID__D_TIMES"), self.repeatInfo.limit)
  end
  ed.setString(self.repeatui.some_label, text)
end
class.refreshSweepSomeLabel = refreshSweepSomeLabel
local function doClickSweep(self, times)
  if times > self.repeatInfo.cLimit then
    ed.showToast(T(LSTR("STAGEDETAIL.ENTER_TO_THIS_GAME_POINTS_HAS_REACHED_THE_UPPER_LIMIT_TODAY")))
    return
  end
  if self.sendSweepTime then
    local time = ed.getSystemTime()
    if time - self.sendSweepTime < 1.5 then
      return
    end
  end
  local price = self:getSweepPrice(times)
  local vc = self.stageInfo.power * times
  if vc > ed.player:getVitality() then
    self:doBuyVitality()
    return
  end
  if times > self.repeatInfo.tLimit then
    self:doPaySweepConfirm(times)
    return
  end
  self:doSendSweep("free", times)()
  self.sendSweepTime = ed.getSystemTime()
end
class.doClickSweep = doClickSweep
local function doRepeatOnce(self)
  if not ed.playerlimit.checkAreaUnlock("Raid One Function") then
    ed.showHandyDialog("vipLocked", {
      vip = ed.playerlimit.getAreaUnlockvip("Raid One Function"),
      name = T(LSTR("PRIVILEGE.FARM"))
    })
    return
  end
  self:doClickSweep(1)
end
class.doRepeatOnce = doRepeatOnce
local function doRepeatSome(self)
  if not ed.playerlimit.checkAreaUnlock("Raid Ten Function") then
    ed.showHandyDialog("vipLocked", {
      vip = ed.playerlimit.getAreaUnlockvip("Raid Ten Function"),
      name = T(LSTR("STAGEDETAIL.RAID_MULTIPLE_TIMES"))
    })
    return
  end
  self:doClickSweep(self.repeatInfo.limit)
end
class.doRepeatSome = doRepeatSome
local function doRepeatOnceTouch(self)
  local isPress
  local function handler(event, x, y)
    if not self.repeatui then
      return
    end
    if tolua.isnull(self.repeatui.once) then
      return
    end
    local ui = self.repeatui
    if event == "began" then
      if ed.containsPoint(ui.once, x, y) then
        isPress = true
        ui.once_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        ui.once_press:setVisible(false)
        if ed.containsPoint(ui.once, x, y) then
          self:doRepeatOnce()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doRepeatOnceTouch = doRepeatOnceTouch
local function doRepeatSomeTouch(self)
  local isPress
  local function handler(event, x, y)
    if not self.repeatui then
      return
    end
    if tolua.isnull(self.repeatui.some) then
      return
    end
    local ui = self.repeatui
    if event == "began" then
      if ed.containsPoint(ui.some, x, y) then
        isPress = true
        ui.some_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        ui.some_press:setVisible(false)
        if ed.containsPoint(ui.some_press, x, y) then
          self:doRepeatSome()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doRepeatSomeTouch = doRepeatSomeTouch
local function getRepeatInformation(self)
  local info = self.stageInfo
  local star = info.star
  local power = info.power
  local powerLimit = math.floor(ed.player:getVitality() / power)
  local countLimit
  if info.countLimit == 0 then
    countLimit = 999
  else
    countLimit = self:getLeftTimes()
  end
  local timeLimit = ed.player:getSweepTimes()
  local dt = ed.parameter.default_normal_sweep_times
  local limit
  if timeLimit == 0 then
    limit = dt
  else
    limit = math.min(timeLimit, dt)
  end
  limit = math.min(countLimit, limit)
  if ed.stageType(self.stage) == "elite" then
    limit = ed.parameter.default_elite_sweep_times
    limit = math.min(countLimit, limit)
  else
    limit = ed.parameter.default_normal_sweep_times
  end
  self.repeatInfo = {
    star = star,
    pLimit = powerLimit,
    cLimit = countLimit,
    tLimit = timeLimit,
    limit = limit
  }
end
class.getRepeatInformation = getRepeatInformation
local function createRepeatBattle(self)
  if self.identity == "exerciseStageDetail" or self.mode == "guild" then
    return
  end
  if not tolua.isnull(self.repeatContainer) then
    self.repeatContainer:removeFromParentAndCleanup(true)
  end
  self:getRepeatInformation()
  local info = self.repeatInfo
  if info.star < 3 then
    return
  end
  local type = ed.stageType(self.stage)
  if not ed.isElementInTable(type, {"normal", "elite"}) then
    return
  end
  local timeMax = res.repeat_battle_time_max
  local unitPrice = res.repeat_battle_unit_price
  self:removeMainTouchHandler("buyRepeatTimeTouch")
  self:removeMainTouchHandler("repeatOnce")
  self:removeMainTouchHandler("repeatSome")
  local repeatContainer = CCSprite:create()
  self.repeatContainer = repeatContainer
  if not tolua.isnull(self.mainLayer) then
    self.mainLayer:addChild(repeatContainer)
  end
  local stext = ""
  if self.repeatInfo.limit < 1 then
    stext = T(LSTR("STAGEDETAIL.RAID_FAILED"))
  else
    stext = T(LSTR("STAGEDETAIL.RAID__D_TIMES"), self.repeatInfo.limit)
  end
  self.repeatui = {}
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(662, 131)
      },
      config = {
        scaleSize = CCSizeMake(135, 150)
      }
    },
    {
      t = "Label",
      base = {
        name = "last_title",
        text = T(LSTR("EQUIP.SWEEP_TICKET")),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(631, 259)
      },
      config = {
        color = ccc3(241, 193, 113),
		visible=false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sweep_icon",
        res = "UI/alpha/HVGA/stagedetail_raidticket_icon.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(620, 259)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "last_title_suffix",
        text = ":",
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(678, 259)
      },
      config = {
        color = ccc3(241, 193, 113),
		visible=false
      }
    },
    {
      t = "Label",
      base = {
        name = "count",
        text = info.tLimit,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(665, 259)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "some",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(662, 215)
      },
      config = {
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "some_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "some"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Label",
      base = {
        name = "some_label",
        text = stext,
        fontinfo = "ui_normal_button",
      },
      layout = {
        position = ccp(662, 215)
      },
      config = {
        color = ccc3(255, 206, 31)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "once",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(662, 165)
      },
      config = {
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "once_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "once"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Label",
      base = {
        name = "once_label",
        text = T(LSTR("PRIVILEGE.FARM")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        position = ccp(662, 165)
      },
      config = {
        color = ccc3(255, 206, 31)
      }
    }
  }
  local readNode = ed.readnode.create(repeatContainer, self.repeatui)
  readNode:addNode(ui_info)
  self:refreshSweepContainer()
end
class.createRepeatBattle = createRepeatBattle
local function refreshSweepContainer(self)
  if ed.player:getvip() > 0 then
    if not tolua.isnull(self.repeatContainer) then
      self.repeatContainer:setVisible(true)
    end
    self:registerMainTouchHandler("repeatOnce", self:doRepeatOnceTouch())
    self:registerMainTouchHandler("repeatSome", self:doRepeatSomeTouch())
    return
  end
  local sweepCoinid = ed.parameter.sweep_coin_id
  local amount = ed.player.equip_qunty[sweepCoinid] or 0
  if amount <= 0 then
    self:removeMainTouchHandler("repeatOnce")
    self:removeMainTouchHandler("repeatSome")
  else
    self:registerMainTouchHandler("repeatOnce", self:doRepeatOnceTouch())
    self:registerMainTouchHandler("repeatSome", self:doRepeatSomeTouch())
  end
  if not tolua.isnull(self.repeatContainer) then
    self.repeatContainer:setVisible(amount > 0)
  end
end
class.refreshSweepContainer = refreshSweepContainer
local registerMainTouchHandler = function(self, key, handler)
  self.mainTouchHandlerList = self.mainTouchHandlerList or {}
  self.mainTouchHandlerList[key] = handler
end
class.registerMainTouchHandler = registerMainTouchHandler
local removeMainTouchHandler = function(self, key)
  self.mainTouchHandlerList = self.mainTouchHandlerList or {}
  self.mainTouchHandlerList[key] = nil
end
class.removeMainTouchHandler = removeMainTouchHandler
local doResetEliteLimit = function(self, pay)
  local function handler(result)
    if not result then
      return
    end
    self:refreshStageLimit()
    self:createRepeatBattle()
  end
  return handler
end
class.doResetEliteLimit = doResetEliteLimit
local function doPayReset(self)
  local id = self.stage
  local cost = ed.player:getResetEliteCost(id)
  local times = ed.player:getStageLimitResetTimes(id)
  if ed.player:checkStageLimitResetTimesMax(id) then
    ed.showHandyDialog("needHighervip", {
      number = times,
      name = T(LSTR("STAGEDETAIL.RESET_ELITE_GAME_POINTS"))
    })
  else
    local info = {
      text = T(LSTR("STAGEDETAIL.RESET_COSTS__D_DIAMONDS_\N_WISH_TO_CONTINUEYOU_HAVE_RESET__D_TIMES_TODAY"), cost, times),
      rightHandler = function()
        xpcall(function()
          self:doResetElite({pay = true})
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
  end
end
class.doPayReset = doPayReset
local function doResetElite(self, config)
  config = config or {}
  local pay = config.pay
  local id = self.stage
  local cost = ed.player:getResetEliteCost(id)
  if pay and cost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  ed.netdata.resetElite = {
    isPay = pay,
    cost = cost,
    stage = self.stage
  }
  ed.netreply.resetElite = self:doResetEliteLimit(pay)
  local type = pay and 1 or 0
  local msg = ed.upmsg.reset_elite()
  msg._type = type
  if pay then
    msg._stageid = self.stage
  end
  ed.send(msg, "reset_elite")
end
class.doResetElite = doResetElite
local function checkResetEliteLimit()
  local lastTime = ed.player:getEliteResetTime()
  local time = ed.getServerTime()
  return ed.checkTwoDateod(lastTime, time)
end
class.checkResetEliteLimit = checkResetEliteLimit
local doCheckResetEliteLimit = function(self)
  if self:checkResetEliteLimit() then
    self:doResetElite()
  end
end
class.doCheckResetEliteLimit = doCheckResetEliteLimit
local function resetSweepLabel(self)
  if not self.repeatui then
    return
  end
  if tolua.isnull(self.repeatui.count) then
    return
  end
  ed.setString(self.repeatui.count, ed.player:getSweepTimes())
  self:getRepeatInformation()
  self:refreshSweepSomeLabel()
end
class.resetSweepLabel = resetSweepLabel
local doUpdateCheckResetHandler = function(self)
  local count = 60
  self:doCheckResetEliteLimit()
  local function handler(dt)
    count = count + dt
    if count > 60 then
      count = count - 60
      self:doCheckResetEliteLimit()
    end
  end
  return handler
end
class.doUpdateCheckResetHandler = doUpdateCheckResetHandler
local function getStageInformation(self, stage)
  local info = {}
  info.stage = stage
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[stage]
  info.chapter = row["Chapter ID"]
  local chapterTable = ed.getDataTable("Chapter")
  info.chapterName = chapterTable[info.chapter]["Chapter Name"]
  info.title = row["Stage Name"]
  info.title = info.title--info.chapterName .. "·" .. info.title
  info.detail = row.description
  info.star = ed.player:getStageStar(stage)
  info.power = row["Vitality Cost"]
  info.countLimit = row["Daily Limit"]
  info.isKeyStage = row["Key Stage"]
  if ed.player.stage_limit then
    info.count = ed.player.stage_limit[ed.elite2NormalStage(stage)] or 0
  else
    info.count = 0
  end
  self.stageInfo = info
end
class.getStageInformation = getStageInformation
local function getResInformation(self, stage)
  local info = {}
  local type = ed.stageType(stage)
  if type == "elite" or type == "act" then
    info.frameRes = "UI/alpha/HVGA/stage-map-elite-frame.png"
	  info.titleBgRes = "UI/alpha/HVGA/Elite_title_bg.png"
    info.framePos = res.framePosElite
    info.titleBgSize = CCSizeMake(404, 12)
    info.starLeft = 530
    info.starGap = 50
    info.goButtonPos = res.goButtonPosElite
  elseif type == "normal" then
    info.frameRes = "UI/alpha/HVGA/stage-map-frame.png"
	  info.titleBgRes = "UI/alpha/HVGA/Normal_title_bg.png"
    info.framePos = res.framePosNormal
    info.titleBgSize = CCSizeMake(504, 12)
    info.starLeft = 580
    info.starGap = 55
    info.goButtonPos = res.goButtonPosNormal
  elseif type == "raid" then
    info.frameRes = "UI/alpha/HVGA/stage_map_guild_frame.png"
	  info.titleBgRes = "UI/alpha/HVGA/guild_title_bg.png"
    info.framePos = res.framePosElite
    info.titleBgSize = CCSizeMake(404, 12)
    info.starLeft = 530
    info.starGap = 50
    info.goButtonPos = res.goButtonPosElite
  end
  info.stars = {}
  for i = 1, 3 do
    if i <= (self.stageInfo.star or 0) then
      info.stars[i] = "UI/alpha/HVGA/detail_star.png"
    else
      info.stars[i] = "UI/alpha/HVGA/detail_star_grey.png"
    end
  end
  self.resInfo = info
end
class.getResInformation = getResInformation
local function findBoss(self, stage)
  local info = self.enemyInfo
  local bossPos = ed.getDataTable("Battle")[stage][self.step]["Boss Position"] or 0
  info.bossPos = bossPos
  if self.enemyInfo[bossPos] then
    self.enemyInfo[bossPos].isBoss = true
    local boss = self.enemyInfo[bossPos]
    table.remove(self.enemyInfo, bossPos)
    table.insert(self.enemyInfo, boss)
  end
  self.enemyInfo = info
end
class.findBoss = findBoss
local function getEnemyInformation(self, stage)
  local info = {}
  local row = ed.getDataTable("Stage")[stage]
  local ids = {}
  for i = 1, 5 do
    local brow = ed.getDataTable("Battle")[stage][self.step]
    local tn = string.format("Monster %d ID", i)
    local enemy = brow[tn]
    if enemy then
      ids[i] = enemy
    end
  end
  local unit = ed.getDataTable("Unit")
  for i = 1, #ids do
    if ids[i] ~= 0 then
      info[i] = {
        id = ids[i],
        res = unit[ids[i]].Portrait,
        level = ed.getDataTable("Stage")[self.stage]["Monster Level"],
        stars = ed.getDataTable("Battle")[self.stage][self.step]["Stars " .. i],
        index = i
      }
    end
  end
  self.enemyInfo = info
  self:findBoss(stage)
end
class.getEnemyInformation = getEnemyInformation
local function getRewardInformation(self, stage)
  local info = {}
  local row = ed.getDataTable("Stage")[stage]
  local ids = {}
  for i = 1, 7 do
    local tn = "UI reward" .. i
    local reward = row[tn]
    if reward then
      ids[i] = reward
    end
  end
  local unit = ed.getDataTable("Unit")
  local equip = ed.getDataTable("equip")
  for i = 1, #ids do
    if ids[i] ~= 0 then
      local id = ids[i]
      if ed.itemType(id) == "hero" then
        info[i] = {}
        info[i].id = id
        info[i].res = unit[id].Portrait
        info[i].rank = unit[id]["Initial Rank"]
        info[i].name = unit[id]["Display Name"]
        info[i].hero = true
      elseif ed.itemType(id) == "equip" then
        info[i] = {}
        info[i].id = id
        info[i].res = equip[id].Icon
        info[i].name = equip[id].Name
        info[i].hero = false
      end
    end
  end
  self.rewardInfo = info
end
class.getRewardInformation = getRewardInformation
local getInformation = function(self, stage)
  self:getStageInformation(stage)
  self:getResInformation(stage)
  self:getEnemyInformation(stage)
  self:getRewardInformation(stage)
end
class.getInformation = getInformation
local function getLeftTimes(self)
  local s = ed.elite2NormalStage(self.stage)
  local count = self.stageInfo.countLimit - ((ed.player.stage_limit or {})[s] or 0)
  return count
end
class.getLeftTimes = getLeftTimes
local function checkEnabled(self)
  local s = ed.elite2NormalStage(self.stage)
  local count = self:getLeftTimes()
  local label = self.ui.count_number
  ed.setString(label, count)
  if count < 1 then
    ed.setLabelColor(label, ed.toccc3(16737841))
  else
    ed.setLabelColor(label, ed.toccc3(16114110))
  end
  local vitality = ed.player:getVitality() or 0
  if vitality >= self.stageInfo.power then
    self.isVitalityEnabled = true
  else
    self.isVitalityEnabled = false
  end
  local resetButton = self.ui.reset
  local limit = self.stageInfo.countLimit
-- if not (limit > ed.player:getStageLimit(s)) then
-- else
--   if (limit or 0) <= 0 then
--     self.isCountEnabled = true
--     resetButton:setVisible(false)
-- end
-- else
--   self.isCountEnabled = false
--   resetButton:setVisible(true)
-- end
  if  (limit > ed.player:getStageLimit(s)) or (limit or 0) <= 0 then
      self.isCountEnabled = true
      if not tolua.isnull(resetButton) then
        resetButton:setVisible(false)
      end
  else
    self.isCountEnabled = false
    if not tolua.isnull(resetButton) then
      resetButton:setVisible(true)
    end
  end

  if self.isVitalityEnabled and self.isCountEnabled then
    ed.setLabelColor(self.ui.power_number, ed.toccc3(16114110))
    if not tolua.isnull(self.ui.go_button_shade) then
      self.ui.go_button_shade:setVisible(false)
    end
  else
    self.ui.go_button_shade:setVisible(true)
  end
  if self.mode == "guild" and not ed.ui.guild.isCurrentStageId(self.stage) then
    self.ui.go_button_shade:setVisible(false)
    self.ui.go_button:setVisible(false)
  end
end
class.checkEnabled = checkEnabled
local function refreshVitalityEnabled(self)
  local preVit = ed.player:getVitality()
  local function handler()
    if ed.player:getVitality() ~= preVit then
      self:checkEnabled()
    end
  end
  return handler
end
class.refreshVitalityEnabled = refreshVitalityEnabled
local downBuyVitality = function(self)
  local function handler()
    if not self then
      return
    end
    self:checkEnabled()
  end
  return handler
end
class.downBuyVitality = downBuyVitality
local function doBuyVitality(self)
  ed.showHandyDialog("buyVitality", {
    reply = self:downBuyVitality()
  })
end
class.doBuyVitality = doBuyVitality
local function doClickGo(self)
  local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
  if ul > ed.player:getLevel() then
    ed.showToast(T(LSTR("BATTLEPREPARE.REACH_LEVEL__D_TO_ENTER_THIS_CHAPTER"), ul))
    return
  end
  if self.mode == "guild" then
    local info = ed.ui.guild.getInstanceInfo(self.stageInfo.chapter)
    local h, m = ed.time2HMS()
    if tonumber(h) >= 5 and tonumber(h) <= 7 then
      ed.showToast(T(LSTR("battleprepare.1.10.1.001")))
      return
    end
    if info and info.leftTime <= 0 then
      ed.showToast(T(LSTR("stagedetail.1.10.1.001")))
      return
    end
    if self.guildUI and self.guildUI.challenger:isVisible() and self.guildInstanceData.challenger._summary._name ~= ed.player:getName() then
      ed.showToast(T(LSTR("stagedetail.1.10.1.002")))
      return
    end
  end
  if self.alreadyEnd == true then
    ed.showToast(T(LSTR("stagedetail.1.10.1.003")))
    return
  end
  local stage = self.stage
  local GWMode = self.identity == "stageDetailGWMode"
  local heroLimit = self.heroLimit
  local actType = self.actType
  if self.mode == "guild" then
    local msg = ed.upmsg.guild()
    msg._instance_prepare = {}
    msg._instance_prepare._stage_id = self.stage
    ed.send(msg, "guild")
    return
  else
    ed.pushScene(ed.ui.battleprepare.create({
      stage_id = stage,
      GWMode = GWMode,
      heroLimit = heroLimit,
      actType = actType
    }))
  end
  self.isPushing = true
end
class.doClickGo = doClickGo
local function doGoTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.go_button
  local press = ui.go_button_shade
  local function handler(event, x, y)
    if tolua.isnull(button) then
      return
    end
    if event == "began" and button:isVisible() then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        if ed.containsPoint(button, x, y) then
          if not self.isVitalityEnabled then
            lsr:report("clickDisabledgo")
            self:doBuyVitality()
          elseif not self.isCountEnabled then
            lsr:report("clickDisabledgo")
            ed.showToast(T(LSTR("STAGEDETAIL.CHALLENGE_TIMES_HAVE_REACHED_THE_MAXIMUM_NUMBER")))
          else
            lsr:report("clickgo")
            --add by xinghui:send dot info when click the btn in stagedetail
            if --[[ed.tutorial.checkDone("gotoPrepare")== false--]] ed.tutorial.isShowTutorial then
                ed.sendDotInfoToServer(ed.tutorialres.t_key["gotoPrepare"].id)
            end
            --
            ed.endTeach("gotoPrepare")
            if self.isPushing then
              return
            end
            press:setVisible(false)
            self:doClickGo()
          end
        else
          press:setVisible(false)
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doGoTouch = doGoTouch
local function doRankTouch(self)
  if not self.guildUI then
    return
  end
  local isPress
  local ui = self.guildUI
  local button = ui.rank
  local press = ui.rank_press
  local function handler(event, x, y)
    if tolua.isnull(button) then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          local msg = ed.upmsg.guild()
          msg._guild_stage_rank = {}
          msg._guild_stage_rank._stage_id = self.stage
          ed.send(msg, "guild")
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doRankTouch = doRankTouch
local function doBuffTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      local buff = self.ui.buff
      if buff:isVisible() and ed.containsPoint(buff, x, y) then
        local stage = ed.lookupDataTable("Stage", nil, self.stage)
        if stage and stage["Mps Restraint"] > 0 then
          local str = T(LSTR("stagedetail.1.10.1.004"), 100 - stage["Mps Restraint"])
          ed.showHintText(str, ccp(350, 390))
        end
      end
    elseif event == "ended" then
      ed.closeHintText()
    end
  end
  return handler
end
class.doBuffTouch = doBuffTouch
local function doEnemyTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.enemyInfo do
        local info = self.enemyInfo[i]
        if ed.containsPoint(self.ui["enemy" .. i], x, y) then
          lsr:report("pressEnemy")
          local panel = ed.readequip.getDetailCard(info.id, {
            level = info.level,
            isBoss = info.isBoss,
            isUnit = true
          })
          local enemy = self.ui["enemy" .. i]
          local x, y = enemy:getPosition()
          local size = enemy:getContentSize()
          local sy = enemy:getScaleY()
          panel:setPosition(ccp(x, y + size.height / 2 * sy))
          self.mainLayer:addChild(panel, 20)
          self.enemyDetailPanel = panel
        end
      end
    elseif event == "ended" and self.enemyDetailPanel then
      self.enemyDetailPanel:removeFromParentAndCleanup(true)
      self.enemyDetailPanel = nil
    end
  end
  return handler
end
class.doEnemyTouch = doEnemyTouch
local function doRewardTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.rewardInfo do
        local info = self.rewardInfo[i]
        if ed.containsPoint(self.ui["reward" .. i], x, y) then
          lsr:report("pressReward")
          local panel = ed.readequip.getDetailCard(info.id)
          local x, y = self.ui["reward" .. i]:getPosition()
          local size = self.ui["reward" .. i]:getContentSize()
          panel:setPosition(ccp(x + size.width / 2, y + size.height))
          self.rewardDetailPanel = panel
          self.mainLayer:addChild(panel, 20)
          break
        end
      end
    elseif event == "ended" and self.rewardDetailPanel then
      self.rewardDetailPanel:removeFromParentAndCleanup(true)
      self.rewardDetailPanel = nil
    end
  end
  return handler
end
class.doRewardTouch = doRewardTouch
local doClickReset = function(self)
  self:doPayReset()
end
class.doClickReset = doClickReset
local function doResetTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.reset
  local press = ui.reset_press
  local function handler(event, x, y)
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickReset()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doResetTouch = doResetTouch
local getMainTouchHandler = function(self)
  local resetTouch = self:doResetTouch()
  local goTouch = self:doGoTouch()
  local rewardTouch = self:doRewardTouch()
  local enemyTouch = self:doEnemyTouch()
  local buffTouch = self:doBuffTouch()
  local rankTouch = self:doRankTouch()
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.mainTouchHandlerList or {}) do
        v(event, x, y)
      end
      resetTouch(event, x, y)
      goTouch(event, x, y)
      rewardTouch(event, x, y)
      enemyTouch(event, x, y)
      buffTouch(event, x, y)
      if rankTouch then
        rankTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.getMainTouchHandler = getMainTouchHandler
local refreshStageLimit = function(self)
  if not self then
    return
  end
  if not self.ui then
    return
  end
  if tolua.isnull(self.ui.count_number) then
    return
  end
  self:checkEnabled()
end
class.refreshStageLimit = refreshStageLimit
local function createEnemy(self)
  local width = 0
  local ox, oy = 205, 168
  self.ui.enemyContainer:removeAllChildrenWithCleanup(true)
  for i = 1, 5 do
    self.ui["enemy" .. i] = nil
  end
  for i = 1, #self.enemyInfo do
    local info = self.enemyInfo[i]
    if info then
      local enemyLevel = info.level
      local rank = ed.heroLevel2Rank(enemyLevel)
      local stars = info.stars
      if rank > 8 then
        rank = 8
      end
      local unit = ed.readhero.createIcon({
        id = info.id,
        rank = rank,
        stars = stars,
        forceNormal = true
      })
      local bg = unit.icon
      bg:setFlipX(true)
      local pos
      local length = 70
      if info.isBoss == true then
        pos = ccp(ox + 80 * (i - 1) + 5, oy + 5)
        length = 80
      else
        pos = ccp(ox + 80 * (i - 1), oy)
      end
      bg:setPosition(pos)
      self.ui.enemyContainer:addChild(bg)
      local eScale = length / bg:getContentSize().width
      bg:setScale(eScale)
      if info.isBoss == true then
        local tag = ed.createSprite("UI/alpha/HVGA/stagedetail_boss_tag.png")
        tag:setPosition(ccp(52, 20))
        bg:addChild(tag, 10)
      end
      self.ui["enemy" .. i] = bg
      if self.guildInstanceData and self.guildInstanceData.hp[info.index] then
        unit:addMonsterHpInfo({
          hp = self.guildInstanceData.hp[info.index]
        })
      end
    end
  end
end
class.createEnemy = createEnemy
local function createReward(self)
  local ox, oy = 205, 50
  for i = 1, #self.rewardInfo do
    local reward = self.rewardInfo[i]
    if reward then
      local icon
      if reward.hero then
        icon = ed.readequip.createIcon(reward.id, nil, 4)
      else
        icon = ed.readequip.createIcon(reward.id)
      end
      self.ui["reward" .. i] = icon
      icon:setAnchorPoint(ccp(0.5, 0))
      icon:setPosition(ccp(ox + 80 * (i - 1), oy))
      self.mainLayer:addChild(icon)
    end
  end
end
class.createReward = createReward
local function createStars(self)
  if self.identity == "exerciseStageDetail" or self.mode == "guild" then
    return
  end
  local resInfo = self.resInfo
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "star1",
        res = resInfo.stars[1]
      },
      layout = {
        anchor = ccp(0, 0),
        --position = ccp(resInfo.starLeft + resInfo.starGap * 0, 340)
		position = ccp(320 + resInfo.starGap * 0,336)
      },
		config = {scale = 0.8}
    },
    {
      t = "Sprite",
      base = {
        name = "star2",
        res = resInfo.stars[2]
      },
      layout = {
        anchor = ccp(0, 0),
        --position = ccp(resInfo.starLeft + resInfo.starGap * 1, 340)
		position = ccp(320 + resInfo.starGap * 1,336)
      },
		config = {scale = 0.8}
    },
    {
      t = "Sprite",
      base = {
        name = "star3",
        res = resInfo.stars[3]
      },
      layout = {
        anchor = ccp(0, 0),
        --position = ccp(resInfo.starLeft + resInfo.starGap * 2, 340)
		position = ccp(320 + resInfo.starGap * 2,336)
      },
		config = {scale = 0.8}
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
end
class.createStars = createStars
local function addChallengerIcon(self)
  if self.guildInstanceData == nil then
    self.guildUI.challenger:setVisible(false)
    return
  end
  if self.guildInstanceData.challenger == nil then
    self.guildUI.challenger:setVisible(false)
    return
  end
  local potNum = 0
  CloseTimer("potRefresh")
  ListenTimer(Timer:Always(0.5, "potRefresh"), function()
    potNum = potNum + 1
    if potNum > 3 then
      potNum = 0
    end
    local str = ""
    if self.guildInstanceData.state == "battle" then
      str = T(LSTR("stagedetail.1.10.1.005"))
    else
      str = T(LSTR("stagedetail.1.10.1.006"))
    end
    for i = 1, potNum do
      str = str .. "·"
    end
    ed.setString(self.guildUI.hint, str)
  end, self.visibleEventScope)
  self.guildUI.challenger:setVisible(true)
  local icon = ed.getHeroIconByID({
    id = self.guildInstanceData.challenger._summary._avatar,
    vip = 0 < self.guildInstanceData.challenger._summary._vip
  })
  local level = ed.getLevelIcon({
    level = self.guildInstanceData.challenger._summary._level
  })
  self.guildUI.icon:removeAllChildrenWithCleanup(true)
  self.guildUI.icon:addChild(icon)
  level:setPosition(ccp(-15, -20))
  self.guildUI.icon:addChild(level)
  ed.setLabelString(self.guildUI.name, self.guildInstanceData.challenger._summary._name)
end
local function refreshGuildInstanceUI(self, data)
  if self.mode ~= "guild" then
    return
  end
  if data.stage ~= self.stage then
    return
  end
  self.guildInstanceData = data
  self.step = self.guildInstanceData.step
  addChallengerIcon(self)
  self.guildUI.guild_process:setString(T(LSTR("stagedetail.1.10.1.007"), self.step))
  self:getEnemyInformation(self.stage)
  self:createEnemy()
end
local function addGuildInstanceUI(self)
  if self.mode ~= "guild" then
    return
  end
  self.guildUI = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "guild_process",
        text = "",
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(250, 230)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challenger",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(660, 210)
      },
      config = {
        scaleSize = CCSizeMake(170, 160),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "hint",
        text = T(""),
        size = 22,
        parent = "challenger"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(40, 135)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = T(LSTR("CRUSADECONFIG.MY_NAME_IS_TOO_LONG")),
        size = 22,
        parent = "challenger"
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(85, 15)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png",
        parent = "challenger"
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(130, 15)
      }
    },
    {
      t = "Sprite",
      base = {name = "icon", parent = "challenger"},
      layout = {
        anchor = ccp(0, 0),
        position = ccp(85, 90)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "rank",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(650, 360)
      },
      config = {
        scaleSize = CCSizeMake(100, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "rank_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "rank"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(100, 50)
      }
    },
    {
      t = "Label",
      base = {
        name = "rank_label",
        text = T(LSTR("stagedetail.1.10.1.008")),
        parent = "rank",
        z = 1,
        fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(50, 25)
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.guildUI)
  readNode:addNode(ui_info)
  self.guildUI.guild_process:setString(string.format(T(LSTR("stagedetail.1.10.1.007")), self.step))
  addChallengerIcon(self)
end
class.addGuildInstanceUI = addGuildInstanceUI
local function addGuildEvent(self)
  if self.mode == "guild" then
    do
      local function OnGuildRsp(data)
        if data == nil then
          return
        end
        if data._instance_prepare then
          if data._instance_prepare._result == "success" then
            local stage = self.stage
            local GWMode = self.identity == "stageDetailGWMode"
            local heroLimit = self.heroLimit
            local actType = self.actType
            ed.pushScene(ed.ui.battleprepare.create({
              stage_id = stage,
              GWMode = GWMode,
              heroLimit = heroLimit,
              actType = actType,
              mode = "guildInstance",
              prepareTime = data._instance_prepare._left_time
            }))
          else
            ed.showToast(LSTR("stagedetail.1.10.1.009"))
          end
        end
      end
      self:registerOnEnterHandler("onEnter", function()
        CloseScope(self.scope)
        self.scope = {}
        ListenEvent("GuildInstanceQuery2", function()
          local guildInstanceData = {}
          local hpInfo = {}
          for i = 1, 5 do
            hpInfo[i] = 0
          end
          guildInstanceData.step = 3
          guildInstanceData.hp = hpInfo
          guildInstanceData.challenger = nil
          guildInstanceData.stage = self.stage
          self.alreadyEnd = true
          refreshGuildInstanceUI(self, guildInstanceData)
        end, self.scope)
        ListenEvent("GuildInstanceDetail", function(data)
          refreshGuildInstanceUI(self, data)
        end, self.scope)
        local function queryDetail()
          local msg = ed.upmsg.guild()
          msg._instance_detail = {}
          msg._instance_detail._stage_id = self.stage
          ed.send(msg, "guild")
        end
        queryDetail()
        ListenTimer(Timer:Always(10), queryDetail, self.scope)
        ListenEvent("GuildRsp", OnGuildRsp)
      end)
      self:registerOnExitHandler("onExit", function()
        CloseScope(self.scope)
        StopListenEvent("GuildRsp", OnGuildRsp)
      end)
      self:registerOnPopSceneHandler("onPop", function()
        CloseScope(self.scope)
      end)
    end
  end
end
local function initBuffSprite(self)
  if not self.ui then
    return
  end
  local stage = ed.lookupDataTable("Stage", nil, self.stage)
  if stage and stage["Mps Restraint"] > 0 then
    local title = self.ui.title
    local posX, posY = title:getPosition()
    local size = title:getContentSize()
    posX = posX + size.width / 2
    self.ui.buff:setPosition(ccp(posX, posY))
    self.ui.buff:setVisible(true)
  end
end
local function create(stage, addition, mode)
  local identity
  addition = addition or {}
  local isGetWay = addition.isGetWay
  local isExercise = addition.isExercise
  local heroLimit = addition.heroLimit
  local actType = addition.actType
  if isExercise then
    identity = "exerciseStageDetail"
  elseif isGetWay then
    identity = "stageDetailGWMode"
  else
    identity = "stageDetail"
  end
  local self = base.create(identity)
  setmetatable(self, class.mt)
  self.stage = stage
  self.mode = mode or "normal"
  self.heroLimit = heroLimit
  self.actType = actType
  local st = ed.stageType(self.stage)
  local isNormalMode = ed.stageType(stage) == "normal"
  self.guildInstanceData = addition.guildInstanceData
  self.step = self.guildInstanceData and self.guildInstanceData.step or 3
  self:getInformation(stage)
  local info = self.stageInfo
  local resInfo = self.resInfo
  self.ui = {}
  local mainLayer = self.mainLayer
  local map_ui = ed.ui.stageselectres.map["chapter" .. info.chapter]
  local stageContainer = CCLayer:create()
  self.ui.stageContainer = stageContainer
  self.mainLayer:addChild(stageContainer)
  stageContainer:setClipRect(CCRectMake(44, 20, 712, 370))
  local enemyContainer = CCNode:create()
  self.ui.enemyContainer = enemyContainer
  self.mainLayer:addChild(enemyContainer, 20)
  local titlepos = ccp(400, 355)
  if identity == "exerciseStageDetail" then
    titlepos = ccp(398, 355)
  end
  if not (self.stageInfo.count >= self.stageInfo.countLimit) or not ed.toccc3(16737841) then
  end
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame2",
        res = "UI/alpha/HVGA/detail_bg_2.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 205)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "frame3",
        res = resInfo.frameRes
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = resInfo.framePos
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/detail_title_bg.png",
        capInsets = CCRectMake(100, 0, 300, 12)
      },
      layout = {position = titlepos},
      config = {
        scaleSize = resInfo.titleBgSize
      }
	},
	  {
		  t = "Sprite",
		  base = {
			  name = "map_title_bg",
			  res = resInfo.titleBgRes
		  },
		  layout = {
			  position = ccp(397, 393)
		  },
		  config = {
		  }
	  }
	,
    {
      t = "Label",
      base = {
        name = "title",
        text = info.title,
        fontinfo = "ui_normal_button",
      },
	  layout = {
		position = ccp(397, 393)
	  },
      config = {
        color = ed.toccc3(16436496)
      }
    },
    {
      t = "Label",
      base = {
        name = "detail",
        text = info.detail,
        size = 21
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(70, 300)
      },
      config = {
        color = ed.toccc3(16777215),
        dimension = CCSizeMake(660, 300),
        horizontalAlignment = kCCTextAlignmentLeft,
        verticalAlignment = kCCVerticalTextAlignmentCenter,
        visible = info.isKeyStage,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buff",
        --res = "UI/alpha/HVGA/stagedetail_energy_leak_icon.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = titlepos
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "power_title",
        text = T(LSTR("STAGEDETAIL.PHYSICAL_EXERTION")),
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(70, 230)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Label",
      base = {
        name = "power_number",
        text = info.power,
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(170, 230)
      },
      config = {
        color = ed.toccc3(16114110)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "power_icon",
        res = "UI/alpha/HVGA/vitalityicon.png"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(200, 228)
      },
      config = {
        fix_size = CCSizeMake(24, 30)
      }
    },
    {
      t = "Label",
      base = {
        name = "count_title",
        text = T(LSTR("EXERCISE.REMAINING_TIMES_FOR_TODAY_"), (info.countLimit - info.count)),
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(250, 230)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Label",
      base = {
        name = "count_number",
        text = "" .. info.countLimit - info.count,
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(390, 230)
      },
      config = {
        color = (self.stageInfo.count >= self.stageInfo.countLimit)  and ed.toccc3(16737841)  or ed.toccc3(16114110),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "total_number",
        text = "/ " .. (info.countLimit or "??"),
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(410, 230)
      },
      config = {
        color = ed.toccc3(16114110)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reset",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(500, 242)
      },
      config = {
        scaleSize = CCSizeMake(100, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reset_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "reset"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(100, 50)
      }
    },
    {
      t = "Label",
      base = {
        name = "reset_label",
        text = T(LSTR("EQUIPINFO.PURCHASE")),
        fontinfo = "ui_normal_button",
        parent = "reset",
        z = 1
      },
      layout = {
        position = ccp(50, 25)
      },
      config = {
        color = ccc3(255, 206, 31)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemy_bg",
        res = "UI/alpha/HVGA/detail_enemy_bg.png"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(90, 130)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy_title",
        text = T(LSTR("STAGEDETAIL.ENEMY_LINEUP")),
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(70, 157)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Label",
      base = {
        name = "award_title",
        text = T(LSTR("STAGEDETAIL.MAY_BE_OBTAINED")),
        size = 22
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(70, 77)
      },
      config = {
        color = ed.toccc3(15843697)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_button",
        res = "UI/alpha/HVGA/startbtn.png"
      },
      layout = {
        position = resInfo.goButtonPos
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_button_shade",
        res = "UI/alpha/HVGA/startbtn-disabled.png",
        parent = "go_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  if self.ui ~= nil then
	  local w = self.ui.title:getContentSize().width
	  if w > 330 then
		  self.ui.title:setScale(330 / w)
	  end
  end
  initBuffSprite(self)
  self:createRepeatBattle()
  ed.teach("gotoPrepare", self.ui.go_button, self.mainLayer)
  self:createStars()
  self:createEnemy()
  self:createReward()
  self:addGuildInstanceUI()
  local dictionary = CCDictionary:create()
  local rres = map_ui.route.res
  local spr
  if rres then
    spr = ed.createSprite(rres)
    spr:setPosition(ccp(map_ui.route.pos.x - 40, 480 - map_ui.route.pos.y - 80))
    dictionary:setObject(spr, 1)
  end
  for i = 1, #(map_ui.stage or {}) do
    local icon
    local type, res = ed.ui.stageselect.getStageRes(map_ui.stage[i], map_ui.tag)
    icon = ed.createSprite(res)
    local pos = map_ui.stage[i].pos
    icon:setPosition(ccp(map_ui.stage[i].pos.x - 40, 480 - map_ui.stage[i].pos.y - 80))
    dictionary:setObject(icon, i + 1)
  end
  local frame1
  if 0 < dictionary:count() then
    frame1 = ed.createMultiSprite(map_ui.bg.res)
    frame1:setBackgroundScale(ed.getSpriteOriginalScale(map_ui.bg.res))
    frame1:setMultiSprite(dictionary)
  else
    frame1 = ed.createSprite(map_ui.bg.res)
  end
  frame1:setPosition(map_ui.bg.pos)
  self.ui.frame1 = frame1
  stageContainer:addChild(frame1)
  ed.setSpriteBlur(frame1, 1)
  if isNormalMode or st == "act" or self.mode == "guild" then
    self.ui.count_title:setVisible(false)
    self.ui.count_number:setVisible(false)
    self.ui.total_number:setVisible(false)
  end
  for i = 1, 6 do
    if self.ui["reward" .. i] ~= nil and self.rewardInfo[i].hero then
      self.ui["reward" .. i]:setScale(0.9)
      local res = ed.Hero.getIconFrameByRank(self.rewardInfo[i].rank)
      local frame = ed.createSprite(res)
      frame:setPosition(ccp(41, 40))
      self.ui["reward" .. i]:addChild(frame)
    end
  end
  mainLayer:registerScriptHandler(function(event)
    if event == "enter" then
      self:checkEnabled()
      self.isPushing = nil
    end
  end)
  self:btRegisterHandler({
    handler = self:getMainTouchHandler(),
    key = "stage_detail_main"
  })
  self:registerRefreshHandler("refreshVitalityEnabled", self:refreshVitalityEnabled())
  self:registerUpdateHandler("checkReset", self:doUpdateCheckResetHandler())
  addGuildEvent(self)
  return self
end
class.create = create
local function createForExercise(stage, addition)
  addition = addition or {}
  addition.isExercise = true
  return create(stage, addition)
end
class.createForExercise = createForExercise
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.repeatRewardWindow = class
local list_top_y = 375
local refreshClipRect = function(self)
  local function handler(dt)
    xpcall(function()
      if tolua.isnull(self.container) then
        self.layerScheduler:unscheduleScriptEntry(self.refreshClipRectID)
        return
      end
      self.draglist:refreshClipRect(self.container:getScale())
    end, EDDebug)
  end
  return handler
end
class.refreshClipRect = refreshClipRect
local playListLayerAnim = function(self, lh, ey)
  local ll = self.draglist:getList()
  local x, y = ll:getPosition()
  local bp = ccp(x, y)
  self.draglist:initListHeight(lh)
  ll:setPosition(bp)
  local ep = ccp(x, ey)
  ll:stopAllActions()
  if not self.skipLootAnim then
    local move = CCMoveTo:create(0.2, ep)
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  else
    ll:setPosition(ep)
  end
  if ll:getPositionY() > 0 then
    self.draglist:refreshShade()
  end
end
class.playListLayerAnim = playListLayerAnim
local function createEndTag(self, index)
  local oh = list_top_y
  local layer = self.draglist:getList()
  local lh = self.listHeight
  lh = lh + 30
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(400, oh - lh))
  layer:addChild(light, 5)
  light:setScale(0.8)
  light:setVisible(false)
  local endTag = ed.createSprite("UI/alpha/HVGA/stagedetail/stagedetail_raid_title.png")
  endTag:setPosition(ccp(400, oh - lh))
  layer:addChild(endTag, 6)
  endTag:setScale(0.8)
  endTag:setVisible(false)
  lh = lh + endTag:getContentSize().height / 2
  self.listHeight = lh
  self:playListLayerAnim(lh, math.max(lh - oh, 0))
  if self.skipLootAnim then
    endTag:setVisible(true)
    light:setVisible(true)
    local r = CCRotateBy:create(5, 360)
    r = CCRepeatForever:create(r)
    light:runAction(r)
    self:createLootAnim(index + 1)
  else
    local array = CCArray:create()
    local delay = CCDelayTime:create(0.5)
    local func = CCCallFunc:create(function()
      xpcall(function()
        endTag:setVisible(true)
        endTag:setScale(1.5)
      end, EDDebug)
    end)
    local scale = CCScaleTo:create(0.2, 1)
    scale = CCEaseBackOut:create(scale)
    local func2 = CCCallFunc:create(function()
      xpcall(function()
        light:setVisible(true)
        local r = CCRotateBy:create(5, 360)
        r = CCRepeatForever:create(r)
        light:runAction(r)
        self:createLootAnim(index + 1)
      end, EDDebug)
    end)
    array:addObject(delay)
    array:addObject(func)
    array:addObject(scale)
    array:addObject(func2)
    local s = CCSequence:create(array)
    endTag:runAction(s)
  end
end
class.createEndTag = createEndTag
local function createLoot(self, index)
  local oh = list_top_y
  local layer = self.draglist:getList()
  local list = self.lootList[index]
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  if index == #self.lootList then
    lh = lh + 20
  end
  local title = {}
--  if index ~= #self.lootList or not T(LSTR("STAGEDETAIL.EXTRA_BONUS")) then
--  end
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/stagedetail/stagedetail_raid_subtitle_bg.png"
      },
      layout = {
        position = ccp(400, oh - lh)
      }
    },
    {
      t = "Label",
      base = {
        name = "title",
        text =  index == #self.lootList and LSTR("STAGEDETAIL.EXTRA_BONUS") or T(LSTR("STAGEDETAIL.THE__D_BATTLE"), index),
        size = 20
      },
      layout = {
        position = ccp(400, oh - lh)
      }
    }
  }
  local readNode = ed.readnode.create(layer, title)
  readNode:addNode(ui_info)
  lh = lh + 35
  if index ~= #self.lootList then
    local em = {}
    ui_info = {
      {
        t = "Label",
        base = {
          name = "exp_title",
          text = "EXP:",
          size = 18
        },
        layout = {
          position = ccp(270, oh - lh)
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      },
      {
        t = "Label",
        base = {
          name = "exp",
          text = list.exp,
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(305, oh - lh)
        },
        config = {
          color = ccc3(210, 192, 162)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "money_icon",
          res = "UI/alpha/HVGA/goldicon_small.png"
        },
        layout = {
          position = ccp(432, oh - lh)
        }
      },
      {
        t = "Label",
        base = {
          name = "money",
          text = string.format(":    %d", list.money),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(456, oh - lh)
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      }
    }
    readNode = ed.readnode.create(layer, em)
    readNode:addNode(ui_info)
    lh = lh + 55
  else
    lh = lh + 25
  end
  local lootBg = {}
  local lootList = {}
  local loots = list.loots
  for i = 1, math.ceil(#loots / 5) do
    local iconBg = ed.createSprite("UI/alpha/HVGA/stagedetail/stagedetail_raid_item_bg.png")
    iconBg:setPosition(ccp(400, oh - lh - 90 * (i - 1) + 2))
    layer:addChild(iconBg)
    table.insert(lootBg, iconBg)
    if not self.skipLootAnim then
      iconBg:setVisible(false)
    end
  end
  for i = 1, #loots do
    local icon = ed.readequip.createIconWithAmount(loots[i].id, nil, loots[i].amount)
    icon:setPosition(ccp(250 + 75 * ((i - 1) % 5), oh - lh - 90 * (math.ceil(i / 5) - 1)))
    layer:addChild(icon)
    table.insert(lootList, {
      icon = icon,
      info = loots[i]
    })
    if not self.skipLootAnim then
      icon:setVisible(false)
    end
  end
  if #loots == 0 then
    local iconBg = ed.createSprite("UI/alpha/HVGA/stagedetail/stagedetail_raid_item_bg.png")
    iconBg:setPosition(ccp(400, oh - lh + 2))
    layer:addChild(iconBg)
    table.insert(lootBg, iconBg)
    local label = ed.createttf(T(LSTR("STAGEDETAIL.NO_ITEM_DROPPED_IN_THIS_RAID")), 20)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(220, oh - lh + 2))
    ed.setLabelColor(label, ccc3(241, 193, 113))
    layer:addChild(label)
    table.insert(lootList, {
      icon = label,
      info = {}
    })
    if not self.skipLootAnim then
      iconBg:setVisible(false)
      label:setVisible(false)
    end
  end
  lh = lh + 90 * math.max(0, math.floor((#loots - 1) / 5)) + 70
  self.listHeight = lh
  self:playListLayerAnim(lh, math.max(lh - oh, 0))
  self.loots = self.loots or {}
  self.loots[index] = lootList
  self.lootBg = self.lootsBg or {}
  self.lootBg[index] = lootBg
  self:playLootAnim(index)
end
class.createLoot = createLoot
local playLootAnim = function(self, index)
  if self.skipLootAnim then
    self:createLootAnim(index + 1)
    if index == #self.lootList then
      self.ui.close:setVisible(true)
    end
    return
  end
  local icons = self.loots[index]
  local bg = self.lootBg[index]
  local od = 0.5
  local delay = 0.1
  local di = 0
  for i = 1, #icons do
    if (i - 1) % 5 == 0 then
      local node = bg[math.floor((i - 1) / 5) + 1]
      self:playNodeAnim(node, delay)
      di = di + 1
    end
    local node = icons[i].icon
    if i == #icons then
      self:playNodeAnim(node, od + delay * di, function()
        local d = CCDelayTime:create(0.2)
        local f = CCCallFunc:create(function()
          xpcall(function()
            self:createLootAnim(index + 1)
            if index == #self.lootList then
              self.ui.close:setVisible(true)
            end
          end, EDDebug)
        end)
        self.mainLayer:runAction(CCSequence:createWithTwoActions(d, f))
      end)
    else
      self:playNodeAnim(node, od + delay * di)
    end
    di = di + 1
  end
end
class.playLootAnim = playLootAnim
local playNodeAnim = function(self, node, delay, handler)
  local d = CCDelayTime:create(delay)
  local f1 = CCCallFunc:create(function()
    xpcall(function()
      node:setVisible(true)
      node:setScale(1.5)
    end, EDDebug)
  end)
  local a = CCScaleTo:create(0.2, 1)
  a = CCEaseBackOut:create(a)
  a = CCSequence:createWithTwoActions(f1, a)
  local s = CCSequence:createWithTwoActions(d, a)
  if not handler then
    node:runAction(s)
  else
    local func = CCCallFunc:create(function()
      xpcall(function()
        handler()
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, func)
    node:runAction(s)
  end
end
class.playNodeAnim = playNodeAnim
local createLootAnim = function(self, index)
  if self.endPlayLootAnim then
    return
  end
  if index == #self.lootList then
    self:createEndTag(index)
    return
  end
  if index == #self.lootList + 1 then
    self:setAnimEnd()
    self:createLoot(index - 1)
    return
  end
  self:createLoot(index)
end
class.createLootAnim = createLootAnim
local getLootidInList = function(id)
  local j = id % 1000
  local i = (id - j) / 1000
  return i, j
end
local function doPressInList(self)
  local function handler(x, y)
    for i = 1, #self.loots do
      local loots = self.loots[i]
      for j = 1, #loots do
        local loot = loots[j]
        local icon = loot.icon
        local id = loot.info.id
        if id and ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          local pos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
          self.detailCard = ed.ui.equipableList.create(id, ccp(pos.x, pos.y + 30))
          self.mainLayer:addChild(self.detailCard.mainLayer)
          return i * 1000 + j
        end
      end
    end
  end
  return handler
end
class.doPressInList = doPressInList
local function cancelPressInList(self)
  local function handler(x, y, id)
    local i, j = getLootidInList(id)
    self.loots[i][j].icon:setScale(1)
    self.detailCard:destroy()
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local function doClickInList(self)
  local function handler(x, y, id)
    local i, j = getLootidInList(id)
    self.loots[i][j].icon:setScale(1)
    self.detailCard:destroy()
  end
  return handler
end
class.doClickInList = doClickInList
local function cancelClickInList(self)
  local function handler(x, y, id)
    local i, j = getLootidInList(id)
    self.loots[i][j].icon:setScale(1)
    self.detailCard:destroy()
  end
  return handler
end
class.cancelClickInList = cancelClickInList
local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(200, 21, 400, 374),
    container = self.container,
    priority = -135,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:setTouchEnabled(false)
end
class.createListLayer = createListLayer
local playTitleLightAnim = function(self)
  local light = self.ui.light
  light:setVisible(true)
  local rtt = CCRotateBy:create(5, 360)
  rtt = CCRepeatForever:create(rtt)
  light:runAction(rtt)
end
class.playTitleLightAnim = playTitleLightAnim
local playTitleAnim = function(self)
  local title = self.ui.title
  title:setVisible(true)
  title:setScale(2)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:playTitleLightAnim()
      self:createLootAnim(1)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  title:runAction(sequence)
end
class.playTitleAnim = playTitleAnim
local function doOutLayerTouch(self)
  local isPress
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(self.ui.bg, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not ed.containsPoint(self.ui.bg, x, y) then
        self:destroy()
      end
      isPress = nil
    end
  end
  return handler
end
class.doOutLayerTouch = doOutLayerTouch
local function doCloseButtonTouch(self)
  local isPress
  local function handler(event, x, y)
    if not self.ui.close:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(self.ui.close, x, y) then
        isPress = true
        self.ui.close_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        self.ui.close_press:setVisible(false)
        if ed.containsPoint(self.ui.close, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCloseButtonTouch = doCloseButtonTouch
local setAnimEnd = function(self)
  self.endPlayLootAnim = true
  self.draglist:setTouchEnabled(true)
end
class.setAnimEnd = setAnimEnd
local doMainLayerTouch = function(self)
  local outLayerTouch = self:doOutLayerTouch()
  local closeTouch = self:doCloseButtonTouch()
  local function handler(event, x, y)
    xpcall(function()
      if not self.endPlayLootAnim then
      else
        closeTouch(event, x, y)
        outLayerTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local destroy = function(self)
  self.layerScheduler = self.container:getScheduler()
  self.refreshClipRectID = self.layerScheduler:scheduleScriptFunc(self:refreshClipRect(), 0, false)
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        self.mainLayer:removeFromParentAndCleanup(true)
        self.parent.isClickSweep = true
        if self.destroyHandler then
          self.destroyHandler()
        end
      end
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  self.container:runAction(sequence)
end
class.destroy = destroy
local show = function(self)
  self.container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:createListLayer()
      self.mainLayer:setTouchEnabled(true)
      self:createLootAnim(1)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  self.container:runAction(sequence)
end
class.show = show
local function create(lootList)
  local self = {}
  setmetatable(self, class.mt)
  self.lootList = lootList
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -130, true)
  local container = CCLayer:create()
  container:setAnchorPoint(ccp(0.5, 0.5))
  self.container = container
  mainLayer:addChild(container)
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/task_title_bg.png"
      },
      layout = {
        position = ccp(400, 420)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = T(LSTR("PRIVILEGE.FARM")),
        size = 20
      },
      layout = {
        position = ccp(400, 420)
      },
      config = {
        color = ccc3(231, 206, 19),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        position = ccp(400, 205)
      },
      config = {
        scaleSize = CCSizeMake(430, 385)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png",
        z = 5
      },
      layout = {
        position = ccp(610, 380)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:show()
  return self
end
class.create = create

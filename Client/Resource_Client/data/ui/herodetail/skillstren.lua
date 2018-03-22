local herodetail = ed.ui.herodetail
local res = herodetail.res
local controller = herodetail.controller
local base = ed.ui.popwindow
local class = newclass(base.mt)
herodetail.skill = class
local ori_height, bd_height
local destroyDescBoard = function(self)
  if not tolua.isnull(self.ui.desc_board) then
    self.ui.desc_board:removeFromParentAndCleanup(true)
  end
end
class.destroyDescBoard = destroyDescBoard
local function createDescBoard(self, i)
  self:destroyDescBoard()
  local bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail-skill-tip.png",
      capInsets = CCRectMake(20, 52, 200, 5)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(525, ori_height + 37 - bd_height * (i - 1))
    }
  }, self.container)
  local label = ed.createNode({
    t = "Label",
    base = {
      text = self.skill.description[i],
      size = 16
    },
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(240, 0)
    }
  }, bg)
  local ox = 27
  if 1 < herodetail.getCacheSkillLevel(i, self.hid) and self.hero._rank >= self.skill.rank[i] then
    local addition = ed.createNode({
      t = "Label",
      base = {
        text = herodetail.getSkillDesc(self.hero, i, self.preSkillLevelAdd),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        horizontalAlignment = kCCTextAlignmentLeft,
        color = ccc3(231, 206, 19),
        dimensions = CCSizeMake(240, 0)
      }
    }, bg)
    local size = label:getContentSize()
    local aSize = addition:getContentSize()
    local dh = 80 - (size.height + aSize.height + 25)
    dh = math.max(dh, 0)
    label:setAnchorPoint(ccp(0, 0))
    label:setPosition(ccp(ox, 15 + aSize.height + dh / 2))
    addition:setPosition(ccp(ox, 10 + dh / 2))
    local height = math.max(size.height + aSize.height + 25, 80)
    bg:setContentSize(CCSizeMake(size.width + 40, height))
  else
    local size = label:getContentSize()
    local height = math.max(size.height + 40, 80)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(ox, height / 2))
    bg:setContentSize(CCSizeMake(size.width + 40, height))
  end
  self.ui.desc_board = bg
end
class.createDescBoard = createDescBoard
local function playAttAnim(self, id)
  local att = herodetail.getSkillLvupAtt(self.hid, id)
  local icon = self.iconui[id].icon
  if tolua.isnull(icon) then
    return
  end
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setPosition(ccp(32, 30))
  icon:addChild(effect)
  self:getScene():addFca(effect)
  local dt = 0.2
  for i = 1, #att do
    do
      local label = ed.createNode({
        t = "Label",
        base = {
          text = att[i],
          size = 16
        },
        layout = {
          position = ccp(100, 35)
        },
        config = {
          color = ccc3(231, 206, 19),
          stroke = {
            color = ccc3(0, 0, 0),
            size = 2
          },
          visible = false
        }
      }, icon)
      local a1 = CCDelayTime:create(dt * (i - 1))
      local a2 = CCCallFunc:create(function()
        label:setVisible(true)
      end)
      local a3 = CCMoveTo:create(0.5, ccp(100, 70))
      local a4 = CCFadeOut:create(0.1)
      local a5 = CCCallFunc:create(function()
        label:removeFromParentAndCleanup(true)
      end)
      label:runAction(ed.readaction.create({
        t = "seq",
        a1,
        a2,
        a3,
        a4,
        a5
      }))
    end
  end
end
class.playAttAnim = playAttAnim
local function doLvup(self, callback)
  return herodetail.sendSkillLvup(function(result)
    if not result then
      ed.showToast(T(LSTR("HERODETAILSKILL.SKILLS_ENHANCEMENT_FAILURE")))
    else
      if self.heroDetail then
        self.heroDetail:refreshgsLabel()
      end
      self:refreshLvupTimes()
      if callback then
        callback()
      end
    end
  end)
end
class.doLvup = doLvup
local function doClickLvupButton(self, id)
  ed.playEffect(ed.sound.heroDetail.clickSkillStrenButton)
  ed.endTeach("SUclickLevelup")
  ed.tutorial.tell("SUcomplete", nil, {z = 150})
  ed.endTeach("SUcomplete")
  local cost = self:getCost(id)
  if herodetail.getCacheSkillLevel(id, self.hid) >= self.hero._level then
    ed.showToast(T(LSTR("HERODETAILSKILL.YOU_HAVE_REACHED_CURRENT_LEVEL_CAP")))
  elseif cost > ed.player._money then
    self:doLvup()
    ed.showHandyDialog("useMidas", {
      refreshHandler = self:checkMoneyHandler()
    })
  elseif ed.player:getSkillLvupChance() < 1 then
    self:doClickcdButton()
  elseif 1 > herodetail.getCacheSkillPoint() then
    ed.showToast(T(LSTR("herodetailskill.1.10.1.002")))
  else
    ed.player:addMoney(-cost)
    herodetail.doSkillLvup(self.hid, id)
    self:refreshLevelBoard(id)
    self:refreshLvupTimes()
    self:playAttAnim(id)
    self:refreshCostColor()
  end
end
class.doClickLvupButton = doClickLvupButton
local checkMoneyHandler = function(self)
  local function handler(dt)
    self:refreshCostColor()
  end
  return handler
end
class.checkMoneyHandler = checkMoneyHandler
local doBuyChance = function(self, cost)
  local function handler()
    xpcall(function()
      if ed.player._rmb < cost then
        ed.showHandyDialog("toRecharge")
        return
      end
      ed.registerNetReply("sync_skill_stren_chance", nil, {cost = cost})
      local msg = ed.upmsg.buy_skill_stren_point()
      ed.send(msg, "buy_skill_stren_point")
    end, EDDebug)
  end
  return handler
end
class.doBuyChance = doBuyChance
local showBuyChanceDialog = function(self)
  local cost = self:getResetCost()
  local sprite = CCSprite:create()
  local info = {
    sprite = sprite,
    spriteLabel = T(LSTR("HERODETAILSKILL.YOU_DO_NOT_HAVE_ENOUGH_SKILL_POINTS_\N_BUY_10_SKILL_POINTS_TO_SPEND_DIAMONDS_D_\N_CONFIRM_TO_BUY_PURCHASED_TIMES_FOR_TODAY__D"), cost, ed.player:getSkillResetTimes()),
    rightHandler = self:doBuyChance(cost)
  }
  ed.showConfirmDialog(info)
end
class.showBuyChanceDialog = showBuyChanceDialog
local doClickcdButton = function(self)
  local ds, addition = ed.playerlimit.getAreaUnlockPrompt("Skill Upgrade CD Reset")
  if ds then
    if addition and addition.type == "vip" then
      ed.showHandyDialog("vipLocked", {
        vip = addition.limit
      })
    else
      ed.showToast(ds)
    end
  else
    self:showBuyChanceDialog()
  end
end
class.doClickcdButton = doClickcdButton
local refreshCostColor = function(self)
  for k, v in pairs(self.levelui) do
    if not tolua.isnull(v.cost) then
      local cs = self:getCost(k)
      if cs > ed.player._money then
        ed.setLabelColor(v.cost, ccc3(255, 0, 0))
      else
        ed.setLabelColor(v.cost, ccc3(255, 255, 255))
      end
    end
  end
end
class.refreshCostColor = refreshCostColor
local function refreshLevelBoard(self, i)
  local ui = self.levelui[i]
  local level = ui.level
  local cost = ui.cost
  local skillLevel = controller.getSkillLevel(self.hid, i)
  local cacheSkillLevel = controller.getCacheSkillLevel(i, self.hid)
  local cacheSkillLevelDisplay = controller.getCacheSkillLevelDisplay(i, self.hid)
  local cs = self:getCost(i)
  ed.setString(level, "lv." .. (cacheSkillLevelDisplay or 1))
  ed.setString(cost, cs)
  if cs > ed.player._money then
    ed.setLabelColor(cost, ccc3(255, 0, 0))
  end
  local button = self.levelui[i].button
  if not tolua.isnull(button) then
    if cacheSkillLevel >= self.hero._level then
      ed.setSpriteGray(button)
    else
      ed.resetSpriteShader(button)
    end
  end
end
class.refreshLevelBoard = refreshLevelBoard
local function heroUpgradeCallback(self, rank)
  local key = res.skill_unlock_key_rank
  local kr = key[rank]
  if kr then
    if self.unlockLabel and not tolua.isnull(self.unlockLabel[kr]) then
      self.unlockLabel[kr]:removeFromParentAndCleanup(true)
    end
    ed.resetSpriteShader(self.iconui[kr].icon)
    self:createSkillLevelBoard(kr)
    for i = 1, kr do
      self:refreshLevelBoard(i)
    end
  end
end
class.heroUpgradeCallback = heroUpgradeCallback
local refreshSkillAdd = function(self)
  local skillLevelAdd = (ed.readhero.getHeroAttByHero(self.hero).SKL or {}).all or 0
  if skillLevelAdd ~= self.preSkillLevelAdd then
    for i = 1, 4 do
      local lui = self.levelui[i]
      if not tolua.isnull(lui.levelAdd) then
        if skillLevelAdd > 0 then
          lui.levelAdd:setVisible(true)
        end
        ed.setString(lui.levelAdd, "+" .. skillLevelAdd)
        lui.levelAdd:runAction(ed.readaction.create({
          t = "seq",
          CCScaleTo:create(0.2, 1.2),
          CCScaleTo:create(0.2, 1)
        }))
      end
    end
  end
  self.preSkillLevelAdd = skillLevelAdd
end
class.refreshSkillAdd = refreshSkillAdd
local function createSkillLevelBoard(self, i)
  local lui = self.levelui[i] or {}
  local lb = lui.board
  if not tolua.isnull(lb) then
    lb:removeFromParentAndCleanup(true)
  end
  self.levelui[i] = {}
  local lui = self.levelui[i]
  local board = CCSprite:create()
  self.container:addChild(board)
  lui.board = board
  lui.level = ed.createNode({
    t = "Label",
    base = {
      text = "lv." .. (controller.getSkillLevel(self.hid, i) or 1),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(365, ori_height - 5 - bd_height * (i - 1))
    }
  }, board)
  local skillLevelAdd = (ed.readhero.getHeroAttByHero(self.hero).SKL or {}).all or 0
  self.preSkillLevelAdd = skillLevelAdd
  lui.levelAdd = ed.createNode({
    t = "Label",
    base = {
      text = "+" .. skillLevelAdd,
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(lui.level, 2)
    },
    config = {
      color = ccc3(17, 255, 23)
    }
  }, board)
  if skillLevelAdd == 0 then
    lui.levelAdd:setVisible(false)
  end
  if self.isLvupOpen then
    lui.button = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/herodetail_skill_upgrade_button_1.png"
      },
      layout = {
        position = ccp(495, ori_height-13 - 2 - bd_height * (i - 1))
      }
    }, board)
    lui.buttonPress = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/herodetail_skill_upgrade_button_2.png"
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {visible = false}
    }, lui.button)
    if herodetail.getCacheSkillLevel(i, self.hid) >= self.hero._level then
      ed.setSpriteGray(lui.button)
      ed.setSpriteGray(lui.buttonPress)
    else
      ed.teach("SUclickLevelup", lui.button, {
        board,
        self.heroDetail.mainLayer
      })
    end
    lui.moneyIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/goldicon_small.png"
      },
      layout = {
        position = ccp(370, ori_height - 25 - 2 - bd_height * (i - 1))
      },
      config = {scale = 0.5}
    }, board)
    lui.cost = ed.createNode({
      t = "Label",
      base = {
        text = self:getCost(i),
        size = 15
      },
      layout = {
        position = ccp(400, ori_height - 25 - 2 - bd_height * (i - 1))
      }
    }, board)
  end
  self:btRegisterButtonClick({
    button = lui.button,
    press = lui.buttonPress,
    disabled = lui.button,
    key = "lvup_button_" .. i,
    extraCheckHandler = function()
      if self.isSyncSkillChance then
        return false
      end
      if herodetail.getCacheSkillLevel(i, self.hid) >= self.hero._level then
        return false
      end
      return true
    end,
    clickHandler = function()
      self:doClickLvupButton(i)
    end,
    priority = -2,
    freeDelay = 0.3,
    lockHandler = function()
      if not tolua.isnull(lui.buttonPress) then
        lui.buttonPress:setVisible(true)
      end
    end,
    freeHandler = function()
      if not tolua.isnull(lui.buttonPress) then
        lui.buttonPress:setVisible(false)
      end
    end
  })
end
class.createSkillLevelBoard = createSkillLevelBoard
local function createSkillIcon(self)
  self.iconui = {}
  for i = 1, 4 do
    local nameLabel = ed.createttf(self.skill.name[i], 18)
    local icon, bg = ed.readhero.createSkillIcon(self.hid, i)
    icon:setPosition(ccp(320, ori_height - bd_height * (i - 1)))
    self.container:addChild(icon, 5)
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(ccp(365, ori_height + 20 - bd_height * (i - 1)))
    if nameLabel:getContentSize().width > 140 then
      nameLabel:setScale(140/nameLabel:getContentSize().width)
    end

    self.container:addChild(nameLabel)
    if self.hero._rank < self.skill.rank[i] then
      ed.setSpriteGray(icon)
    end
    self.iconui[i] = {bg = bg, icon = icon}
  end
end
class.createSkillIcon = createSkillIcon
local function createSkillUnlockLabel(self)
  for i = 1, 4 do
    if self.hero._rank < self.skill.rank[i] then
      local label = ed.createttf(T(LSTR("HERODETAILSKILL.ADVANCED_TO__S_TO_UNLOCK"), res.skill_unlock_color_text[self.skill.rank[i]]), 16)
      label:setAnchorPoint(ccp(0, 1))
      label:setPosition(ccp(365, ori_height - 5 - bd_height * (i - 1)))
      label:setHorizontalAlignment(kCCTextAlignmentLeft)
      ed.setLabelDimensions(label, CCSizeMake(150, 0))
      self.container:addChild(label)
      self.unlockLabel = self.unlockLabel or {}
      self.unlockLabel[i] = label
    else
      self:createSkillLevelBoard(i)
    end
  end
  self:refreshCostColor()
end
class.createSkillUnlockLabel = createSkillUnlockLabel
local createSkill = function(self)
  self:createSkillIcon()
  self:createSkillUnlockLabel()
end
class.createSkill = createSkill
local getResetCost = function(self)
  local times = ed.player:getSkillResetTimes()
  local price = ed.getDataTable("GradientPrice")
  return price[math.min(times + 1, 30)]["Skill Upgrade Reset"]
end
class.getResetCost = getResetCost
local function getCost(self, slot)
  return ed.getDataTable("SkillLevels")[herodetail.getCacheSkillLevel(slot, self.hid)].Price
end
class.getCost = getCost
local createInformationBar = function(self)
  if not self.isLvupOpen then
    return
  end
  if ed.player:getSkillLvupChance() > 0 then
    self:createTimesBar()
  else
    self:createcdBar()
  end
end
class.createInformationBar = createInformationBar
local function getcdText(self)
  if herodetail.getCacheSkillPoint() ~= ed.player:getSkillLvupChance() then
    return nil
  elseif ed.player:checkSkillChanceMax() then
    return T(LSTR("HERODETAILSKILL.FULL_POINTS"))
  else
    return ed.getmsNString(ed.player:getSkillLvupNextCount())
  end
end
class.getcdText = getcdText
local getcdTextSuffix = function(self)
  local text = self:getcdText()
  if text then
    return "(" .. text .. ")"
  else
    return ""
  end
end
class.getcdTextSuffix = getcdTextSuffix
local clearInformationBar = function(self)
  if not tolua.isnull(self.cdui.container) then
    self.cdui.container:removeFromParentAndCleanup(true)
  end
  if not tolua.isnull(self.timesui.container) then
    self.timesui.container:removeFromParentAndCleanup(true)
  end
end
class.clearInformationBar = clearInformationBar
local function refreshLvupTimes(self)
  local container = self.timesui.container
  if tolua.isnull(container) then
    return
  end
  local ui = self.timesui
  local label = ui.times
  local pre = ui.pre
  local suffix = ui.suffix
  local times = herodetail.getCacheSkillPoint()
  local chance = ed.player:getSkillLvupChance()
  if times < 1 then
    self:doLvup()
  end
  if chance < 1 then
    self:createcdBar()
  else
    ed.setString(label, times)
    ed.setString(suffix, self:getcdTextSuffix())
    self:refreshTimesLabelPos()
  end
end
class.refreshLvupTimes = refreshLvupTimes
local refreshcdHandler = function(self)
  local count = 0
  local function handler(dt)
    count = count + dt
    if count > 1 then
      count = count - 1
      local ui = self.cdui or {}
      local label = ui.cdLabel
      local suffix = ui.cdSuffix
      if not tolua.isnull(label) then
        ed.setString(label, self:getcdText())
        ed.right2(suffix, label, 3)
      end
    end
    if ed.player:getSkillLvupChance() > 0 then
      self:createTimesBar()
    end
  end
  return handler
end
class.refreshcdHandler = refreshcdHandler
local function refreshtimesHandler(self)
  local count = 0
  local pretimes = herodetail.getCacheSkillPoint()
  local t = pretimes
  local function handler(dt)
    count = count + dt
    if count > 1 then
      count = count - 1
      t = herodetail.getCacheSkillPoint()
      if not tolua.isnull(self.timesui.container) then
        local ui = self.timesui
        local times = ui.times
        local suffix = ui.suffix
        ed.setString(times, t)
        ed.setString(suffix, self:getcdTextSuffix())
        self:refreshTimesLabelPos()
      end
    end
  end
  return handler
end
class.refreshtimesHandler = refreshtimesHandler
local createcdBar = function(self)
  if tolua.isnull(self.mainLayer) then
    return
  end
  self:clearInformationBar()
  self:removeUpdateHandler("refreshtimes")
  local cui = self.cdui
  local container = CCSprite:create()
  self.container:addChild(container)
  cui.container = container
  cui.cdButton = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail-upgrade.png"
    },
    layout = {
      position = ccp(325, 420)
    }
  }, container)
  cui.cdButtonPress = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail-upgrade-mask.png"
    },
    layout = {
      anchor = ccp(0, 0)
    },
    config = {visible = false}
  }, cui.cdButton)
  cui.cdButtonLabel = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("EQUIPINFO.PURCHASE")),
      size = 18
    },
    layout = {
      position = ccp(42, 25)
    }
  }, cui.cdButton)
  cui.cdLabel = ed.createNode({
    t = "Label",
    base = {
      text = self:getcdText(),
      size = 18
    },
    layout = {
      position = ccp(390, 420)
    }
  }, container)
  cui.cdSuffix = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("HERODETAILSKILL.TO_GET_1_SKILL_POINT")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(cui.cdLabel, 3)
    },
    config = {
      color = ccc3(255, 234, 198)
    }
  }, container)
  self:registerUpdateHandler("refreshcd", self:refreshcdHandler())
  self:btRegisterButtonClick({
    button = cui.cdButton,
    press = cui.cdButtonPress,
    key = "cd_button",
    clickHandler = function()
      self:doClickcdButton()
    end,
    force = true
  })
end
class.createcdBar = createcdBar
local refreshTimesLabelPos = function(self)
  if tolua.isnull(self.mainLayer) then
    return
  end
  local container = self.timesui.container
  if tolua.isnull(container) then
    return
  end
  local ui = self.timesui
  local tw = ed.sumNodeSize(ui)
  local pre = ui.pre
  local times = ui.times
  local suffix = ui.suffix
  pre:setPosition(ccp(400 - tw / 2, 420))
  ed.right2(times, pre, 3)
  ed.right2(suffix, times, 5)
end
class.refreshTimesLabelPos = refreshTimesLabelPos
local function createTimesBar(self)
  if tolua.isnull(self.mainLayer) then
    return
  end
  self:clearInformationBar()
  self:removeUpdateHandler("refreshcd")
  local tui = self.timesui
  local container = CCSprite:create()
  self.container:addChild(container)
  tui.container = container
  tui.pre = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("HERODETAILSKILL.THE_REMAINING_SKILL_POINTS")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5)
    },
    config = {
      color = ccc3(241, 193, 113)
    }
  }, container)
  tui.times = ed.createNode({
    t = "Label",
    base = {
      text = herodetail.getCacheSkillPoint(),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5)
    },
    config = {
      color = ccc3(255, 234, 198)
    }
  }, container)
  tui.suffix = ed.createNode({
    t = "Label",
    base = {
      text = self:getcdTextSuffix(),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5)
    }
  }, container)
  self:refreshTimesLabelPos()
  self:registerUpdateHandler("refreshtimes", self:refreshtimesHandler())
end
class.createTimesBar = createTimesBar
local function init(self)
  self.hid = self.hero._tid
  self.heroDetail = self.addition.heroDetail
  local hid = self.hid
  local skill = {}
  local skillGroupInfo = ed.getDataTable("SkillGroup")[hid]
  local allSkillInfo = ed.getDataTable("Skill")
  skill.name = {}
  skill.res = {}
  skill.rank = {}
  skill.groupID = {}
  skill.description = {}
  for i = 1, 4 do
    skill.name[i] = skillGroupInfo[i]["Display Name"]
    skill.res[i] = skillGroupInfo[i].Icon
    skill.rank[i] = skillGroupInfo[i].Unlock
    skill.groupID[i] = skillGroupInfo[i]["Skill Group ID"]
    skill.description[i] = allSkillInfo[skill.groupID[i]][0].Description
  end
  self.skill = skill
  self.isLvupOpen = ed.playerlimit.checkAreaUnlock("SkillUpgrade")
  if self.heroDetail.otherPlayerInfo then
    self.isLvupOpen = false
  end
  if self.isLvupOpen then
    ori_height = 350
    bd_height = 90
  else
    ori_height = 390
    bd_height = 100
  end
end
class.init = init
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      if self.closeHandler then
        self.closeHandler()
      end
    end
  })
  for i = 1, 4 do
    self:btRegisterButtonClick({
      button = ui["board_" .. i],
      key = "board_" .. i,
      pressHandler = function()
        ed.playEffect(ed.sound.heroDetail.pressSkillIcon)
        self.mainLayer:setZOrder(11)
        self:createDescBoard(i)
      end,
      cancelPressHandler = function()
        self.mainLayer:setZOrder(0)
        self:destroyDescBoard()
      end
    })
  end
end
class.registerTouchHandler = registerTouchHandler
local function create(hero, addition)
  local self = base.create("herodetailskill")
  setmetatable(self, class.mt)
  self.cdui = {}
  self.timesui = {}
  self.levelui = {}
  self.hero = hero
  self.addition = addition
  self.closeHandler = addition.closeHandler
  self.parent = addition.parent
  self:init()
  local mainLayer = self.mainLayer
  local container = self.container
  local ui = self.ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/herodetail-detail-popup.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {isCascadeOpacity = true}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "board_1",
        res = "UI/alpha/HVGA/herodetail_skill_bg_1.png",
        capInsets = CCRectMake(15, 15, 15, 15)
      },
      layout = {
        position = ccp(400, ori_height - bd_height * 0)
      },
      config = {
        scaleSize = CCSizeMake(254, 86)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "board_2",
        res = "UI/alpha/HVGA/herodetail_skill_bg_2.png",
        capInsets = CCRectMake(15, 15, 15, 15)
      },
      layout = {
        position = ccp(400, ori_height - bd_height * 1)
      },
      config = {
        scaleSize = CCSizeMake(254, 86)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "board_3",
        res = "UI/alpha/HVGA/herodetail_skill_bg_1.png",
        capInsets = CCRectMake(15, 15, 15, 15)
      },
      layout = {
        position = ccp(400, ori_height - bd_height * 2)
      },
      config = {
        scaleSize = CCSizeMake(254, 86)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "board_4",
        res = "UI/alpha/HVGA/herodetail_skill_bg_2.png",
        capInsets = CCRectMake(15, 15, 15, 15)
      },
      layout = {
        position = ccp(400, ori_height - bd_height * 3)
      },
      config = {
        scaleSize = CCSizeMake(254, 86)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(545, 430)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        position = ccp(545, 430)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:createSkill()
  if addition.from == "create" then
    self.isSyncSkillChance = true
    ed.registerNetReply("sync_skill_stren_chance", function()
      self.isSyncSkillChance = nil
      self:createInformationBar()
    end)
    local msg = ed.upmsg.sync_skill_stren()
    ed.send(msg, "sync_skill_stren")
  else
    self:createInformationBar()
  end
  self:registerTouchHandler()
  self:registerOnExitHandler("exitHeroSkill", function()
    self:doLvup()
  end)
  self.parent:addChild(self.mainLayer)
  return self
end
class.create = create
local popBack = function(self, param)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if self.container:numberOfRunningActions() > 0 then
    return
  end
  self.mainLayer:setTouchEnabled(false)
  self.mainLayer:setZOrder(0)
  local move = CCMoveTo:create(0.2, param.endPos)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        ed.breakTeach("SUclickLevelup")
        self.mainLayer:removeFromParentAndCleanup(true)
      end
      if param.callback then
        param.callback()
      end
    end, EDDebug)
  end)
  self.container:runAction(ed.readaction.create({
    t = "seq",
    move,
    func
  }))
end
class.popBack = popBack
local pop = function(self, param)
  self.mainLayer:setTouchEnabled(false)
  if not param.skipAnim then
    self.container:setPosition(param.oriPos)
    local moveRight = CCMoveTo:create(0.2, param.endPos)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.mainLayer:setTouchEnabled(true)
      end, EDDebug)
    end)
    self.container:runAction(ed.readaction.create({
      t = "seq",
      moveRight,
      func
    }))
  else
    self.container:setPosition(param.endPos)
    self.mainLayer:setTouchEnabled(true)
  end
end
class.pop = pop

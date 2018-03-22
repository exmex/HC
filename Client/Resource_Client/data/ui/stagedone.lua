local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.stagedone = class
local lsr = ed.ui.stagedonelsr.create()
local star_pos = {
  ccp(260, 402),
  ccp(378, 410),
  ccp(488, 402)
}
local anim_delay = 1.5
local number_jump_gap = 1
local number_jump_delay = anim_delay
local loot_ori_x = 200
local loot_ori_y = 100
local loot_gap_x = 70
local loot_show_gap = 0.2
local loot_show_delay = anim_delay
local hero_ori_x = 195
local hero_ori_y = 243
local hero_gap_x = 92
local hero_show_gap = 0.1
local hero_show_delay = anim_delay
local list_rect = CCRectMake(160, 60, 460, 80)
local doPressInLoot = function(self)
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      if ed.containsPoint(loot.icon, x, y) then
        local panel = ed.ui.equipableList.create(loot.id, ccpAdd(loot.icon:convertToWorldSpace(ccp(35, 70)), ccp(40, 0)))
        self.mainLayer:addChild(panel.mainLayer, 50)
        self.namePanel = panel
        return i
      end
    end
  end
  return handler
end
class.doPressInLoot = doPressInLoot
local cancelPressInLoot = function(self)
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:destroy()
      self.namePanel = nil
    end
  end
  return handler
end
class.cancelPressInLoot = cancelPressInLoot
local cancelClickInLoot = function(self)
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:destroy()
      self.namePanel = nil
    end
  end
  return handler
end
class.cancelClickInLoot = cancelClickInLoot
local function doClickInLoot(self)
  local function handler(x, y, id)
    lsr:report("clickLoot")
    if self.namePanel then
      self.namePanel:destroy()
      self.namePanel = nil
    end
  end
  return handler
end
class.doClickInLoot = doClickInLoot
local function doLootTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.lootui do
        local loot = self.lootui[i]
        if ed.containsPoint(loot.icon, x, y) then
          lsr:report("pressLoot")
          self.namePanel = ed.readequip.getNameCard(loot.name)
          self.namePanel:setPosition(loot.icon:convertToWorldSpace(ccp(35, 70)))
          self.mainLayer:addChild(self.namePanel, 50)
        end
      end
    elseif event == "ended" and self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      self.namePanel = nil
    end
  end
  return handler
end
class.doLootTouch = doLootTouch
local function doClickReplay(self)
  lsr:report("clickReply")
  if self.hasTriggerShop then
    local sid = ed.player:getLastTriggerShopid()
    if sid then
      ed.replaceScene(ed.ui.shop.create(sid))
      ed.playMusic(ed.music.map)
      return
    end
  end
  ed.playMusic(ed.music.map)
  local stage = self.param.stage_id
  ed.endTeach("clickNextStage")
  ed.replaceScene(ed.ui.stagedetail.create(stage, {
    isGetWay = self.param.gwMode
  }))
end
class.doClickReplay = doClickReplay
local function doClickNext(self)
  lsr:report("clickNext")
  if self.hasTriggerShop then
    local sid = ed.player:getLastTriggerShopid()
    if sid then
      ed.replaceScene(ed.ui.shop.create(sid))
      return
    end
  end
     --add by xinghui
    if --[[ed.tutorial.checkDone("clickNextStage") == false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["clickNextStage"].id)
    end
    --
  ed.endTeach("clickNextStage")
  ed.playMusic(ed.music.map)
  ed.popScene()
  local stage = self.param.stage_id
  if ed.stageType(stage) == "act" then
    local scene = ed.ui.exercise.create(self.param.actType)
    ed.replaceScene(scene)
  end
  ListenTimer(Timer:Once(0.5), function()
    FireEvent("WinBackToSelect", self.param.stage_id)
  end)
end
class.doClickNext = doClickNext
local playLightAnim = function(self)
  local light = self.ui.light
  light:setOpacity(0)
  light:setVisible(true)
  local fade = CCFadeIn:create(0.2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(light) then
        local rotate = CCRotateBy:create(5, 360)
        rotate = CCRepeatForever:create(rotate)
        light:runAction(rotate)
      end
    end, EDDebug)
  end)
  light:runAction(ed.readaction.create({
    t = "seq",
    fade,
    func
  }))
end
class.playLightAnim = playLightAnim
local playInfoBgAnim = function(self)
  local bg = self.ui.info_bg
  local fade = CCFadeIn:create(0.2)
  bg:runAction(fade)
  local fade2 = CCFadeIn:create(0.2)
  self.ui.battleStatistNode:runAction(fade2)
end
class.playInfoBgAnim = playInfoBgAnim
local function playCastAnim(self,i)
	local cast_pos = {
		ccp(260, 372),
		ccp(378, 380),
		ccp(488, 372)
	}
	local sprFront = ed.createFcaNode("eff_UI_battle_skill_cast")
	sprFront:setPosition(cast_pos[i])
	local baseScene = ed.getCurrentScene()
	baseScene:addFcaOnce(sprFront)
	self.mainLayer:addChild(sprFront)
end
class.playCastAnim = playCastAnim
local function playStarAnim(self, index)
  lsr:report("starAnimEnd")
  if nil == self.param.stars then
    return
  end
  for i = 1, self.param.stars do
    do
      local star = self.ui["star_" .. i]
      star:setScale(0)
      star:setVisible(true)
	  local d = CCDelayTime:create(0.3+0.4*(i-1))
	  local func1 = CCCallFunc:create(function()
		  xpcall(function()
			 self:playCastAnim(i)
		  end, EDDebug)
	  end)
	  star:runAction(CCSequence:createWithTwoActions(d, func1))

	  local a = CCScaleTo:create(0.5, 1)
	  a = CCEaseElasticOut:create(a)
      local delay = CCDelayTime:create(0.5+0.4*(i-1))
      local func = CCCallFunc:create(function()
        xpcall(function()
          if i == 1 then
            lsr:report("firstStarAnim")
		  end
	  	  end, EDDebug)
      end)
      star:runAction(ed.readaction.create({
        t = "seq",
        delay,
		a,
        func
      }))
    end
  end
end
class.playStarAnim = playStarAnim
local function playWinAnim(self)
  local win
  if self.param.guildInstanceData then
    win = ed.createSprite("UI/alpha/HVGA/guild/stagedone_end_tag.png")
  else
    win = ed.createSprite("UI/alpha/HVGA/stagedone_win_tag.png")
  end
  win:setPosition(star_pos[2])
  self.mainLayer:addChild(win, 1)
  win:setScale(0)
  local a = CCScaleTo:create(0.2, 1)
  a = CCEaseElasticOut:create(a)
  local func = CCCallFunc:create(function()
    xpcall(function()
      local winLight = ed.createSprite("UI/alpha/HVGA/stagedone_win_tag_light.png")
      winLight:setPosition(star_pos[2])
      self.mainLayer:addChild(winLight)
      local a1 = CCFadeOut:create(0.2)
      local a2 = CCScaleTo:create(0.2, 2)
      local func = CCCallFunc:create(function()
        xpcall(function()
          if not tolua.isnull(winLight) then
            winLight:removeFromParentAndCleanup(true)
            --self:playLightAnim()
            --self:playInfoBgAnim()
          end
        end, EDDebug)
      end)
      winLight:runAction(ed.readaction.create({
        t = "seq",
        {
          t = "sp",
          a1,
          a2
        },
        func
      }))
    end, EDDebug)
  end)
  win:runAction(ed.readaction.create({
    t = "seq",
    a,
    func
  }))
end
class.playWinAnim = playWinAnim
local playLevelAnim = function(self)
  local info = self.param.playerInfo
  local animList = info.animList
  if #animList > 1 then
    local level = ed.player:getLevel()
    ed.setString(self.ui.lv, level)
    self:showTeamLevelMax(level)
    for i, v in ipairs(animList) do
      if i == #animList then
        ed.announce({
          type = "playerLevelup"
        })
      end
    end
  end
end
class.playLevelAnim = playLevelAnim
local function guildDataAnimation(self)
  local count = 0
  local guildInstanceData = self.param.guildInstanceData
  local grow = math.max((guildInstanceData.nowProgress - guildInstanceData.oldProgress) / 100, 0)
  local goldCount = guildInstanceData.gold
  if guildInstanceData.guildCoin == 0 then
    self.guildInstanceUI.coin:setVisible(false)
  else
    self.guildInstanceUI.coin:setVisible(true)
  end
  local damageSpeed = guildInstanceData.damage / number_jump_gap
  local growSpeed = grow / number_jump_gap / 0.5
  local goldSpeed = goldCount / number_jump_gap
  local scheduler = self.mainLayer:getScheduler()
  local function handler(dt)
    count = count + dt
    if tolua.isnull(self.mainLayer) then
      scheduler:unscheduleScriptEntry(self.guildAnimationId)
      return
    end
    local damge = math.min(math.floor(damageSpeed * count), guildInstanceData.damage)
    local progress = math.min(math.floor(growSpeed * count), grow)
    local gold = math.min(math.floor(goldSpeed * count), goldCount)
    if damge >= guildInstanceData.damage and progress >= grow and gold >= goldCount then
      damge = guildInstanceData.damage
      progress = grow
      gold = goldCount
      scheduler:unscheduleScriptEntry(self.guildAnimationId)
    end
    ed.setLabelString(self.guildInstanceUI.damage, ed.setCommForNumber(damge))
    ed.setLabelString(self.guildInstanceUI.goldMoney, ed.setCommForNumber(gold))
    ed.setLabelString(self.guildInstanceUI.progressNum, "+" .. progress .. "%")
    local stencil = self.guildInstanceUI.clippingNodeNow:getStencil()
    stencil:setScaleX((guildInstanceData.oldProgress + progress * 100) / 10000)
  end
  return handler
end
class.guildDataAnimation = guildDataAnimation
local function numberJump(self)
  local count = 0
  local expLabel = self.ui.exp_label
  local goldLabel = self.ui.gold_label
  local exp = self.param.exp
  local gold = self.param.gold
  local expSpeed = exp / number_jump_gap
  local goldSpeed = gold / number_jump_gap
  local hasDelay
  local function handler(dt)
    count = count + dt
    if count > number_jump_delay and not hasDelay then
      count = count - number_jump_delay
      hasDelay = true
    end
    if not hasDelay then
      return
    end
    local ce = math.min(math.floor(expSpeed * count), exp)
    local cg = math.min(math.floor(goldSpeed * count), gold)
    if ce >= exp or cg >= gold then
      ce = exp
      cg = gold
      self:removeUpdateHandler("number_jump")
    end
    ed.setString(expLabel, "+" .. ce)
    ed.setString(goldLabel, "+" .. cg)
  end
  return handler
end
class.numberJump = numberJump
local playNumberJumpAnim = function(self)
  self:registerUpdateHandler("number_jump", self:numberJump())
end
class.playNumberJumpAnim = playNumberJumpAnim
local function createHeroIcon(self)
  local heroui = {}
  local heroes = self.param.heroes
  for i = 1, #heroes do
    local hero = heroes[i]
    local mercenary = hero.bMercenary == true and {} or nil
    local heroIcon = ed.readhero.createIcon({
      id = hero.id,
      rank = hero.rank,
      level = hero.level,
      stars = hero._stars,
      hp = hero.hp,
      mp = hero.mp,
      mercenary = mercenary
    })
    local barBg = ed.createSprite("UI/alpha/HVGA/heroxp-progress-bg.png")
    barBg:setPosition(ccp(40, -8))
    heroIcon.icon:addChild(barBg, 1)
    local bar = ed.createSprite("UI/alpha/HVGA/heroxp-progress.png")
    bar:setAnchorPoint(ccp(0, 0.5))
    bar:setPosition(ccp(0, -8))
    bar:setScaleX(hero.exp / hero.maxExp)
    heroIcon.icon:addChild(bar, 2)
    local exp = ed.createttf("EXP +" .. hero.addHeroExp, 18)
    exp:setPosition(ccp(38, -30))
    heroIcon.icon:addChild(exp)
    heroIcon.icon:setPosition(ccp(hero_ori_x + hero_gap_x * (i - 1), hero_ori_y))
    self.mainLayer:addChild(heroIcon.icon, 10)
    heroIcon.icon:setVisible(false)
    heroui[i] = {
      icon = heroIcon,
      barBg = barBg,
      bar = bar,
      lv = lv
    }
  end
  self.heroui = heroui
end
class.createHeroIcon = createHeroIcon
local playLevelupEffect = function(self, icon, id)
  if not self.levelupEffect then
    self.levelupEffect = {}
  end
  if self.levelupEffect[id] then
    self.levelupEffect[id] = nil
  end
  local node = ed.createFcaNode("eff_UI_levelup")
  self:addFca(node)
  node:setPosition(ccp(40, 40))
  icon:addChild(node, 5)
  self.levelupEffect[id] = node
end
class.playLevelupEffect = playLevelupEffect
local function playHeroBarAnim(self)
  local dt = hero_show_delay + 0.05 * math.max(#self.heroui - 1, 0)
  for i = 1, #self.heroui do
    do
      local ui = self.heroui[i]
      local hero = self.param.heroes[i]
      local array = CCArray:create()
      local delay = CCDelayTime:create(dt)
      array:addObject(delay)
      array:addObject(CCCallFunc:create(function()
        xpcall(function()
          if self.param.guildInstanceData == nil then
            ui.icon.icon:setVisible(true)
          end
          lsr:report("heroBarAnim")
        end, EDDebug)
      end))
      for j = 1, hero.tLevel - hero.level do
        do
          local a = CCScaleTo:create(0.5, 1, 1)
          dt = dt + 0.5
          local f = CCCallFunc:create(function()
            xpcall(function()
              if not tolua.isnull(ui.bar) then
                lsr:report("heroLevelup")
                ui.bar:setScaleX(0)
                ui.icon:refreshLevel(hero.level + j)
                self:playLevelupEffect(ui.icon.icon, i)
              end
            end, EDDebug)
          end)
          array:addObject(a)
          array:addObject(f)
        end
      end
      local a = CCScaleTo:create(0.2, hero.tExp / hero.tMaxExp, 1)
      dt = dt + 0.2
      local f = CCCallFunc:create(function()
        xpcall(function()
          if not tolua.isnull(ui.bar) and hero.isMaxLevel then
            ui.bar:removeFromParentAndCleanup(true)
            local bar = ed.createSprite("UI/alpha/HVGA/heroxp-progress-full.png")
            bar:setAnchorPoint(ccp(0, 0.5))
            bar:setPosition(ccp(0, -8))
            ui.icon.icon:addChild(bar)
            local tag = ed.createttf(T(LSTR("EATEXPLIST.EXPERIENCE_FULL")), 12)
            tag:setPosition(ccp(40, -8))
            ui.icon.icon:addChild(tag)
            ed.tutorial.tell("heroExpMax", self.mainLayer)
            ed.endTeach("heroExpMax")
          end
        end, EDDebug)
      end)
      array:addObject(a)
      array:addObject(f)
      local sequence = CCSequence:create(array)
      ui.bar:runAction(sequence)
    end
  end
end
class.playHeroBarAnim = playHeroBarAnim
local function playHeroAnim(self)
  for i = 1, #self.heroui do
    local ui = self.heroui[i]
    ui.icon.icon:setOpacity(0)
    if i ~= #self.heroui then
      local delay = CCDelayTime:create(hero_show_delay + hero_show_gap * (i - 1))
      local fade = CCFadeIn:create(0.2)
      local sequence = CCSequence:createWithTwoActions(delay, fade)
      ui.icon.icon:runAction(sequence)
    else
      local array = CCArray:create()
      local delay = CCDelayTime:create(hero_show_delay + hero_show_gap * (i - 1))
      local fade = CCFadeIn:create(0.2)
      local func = CCCallFunc:create(function()
        xpcall(function()
          self:playLootAnim()
        end, EDDebug)
      end)
      array:addObject(delay)
      array:addObject(fade)
      array:addObject(func)
      local sequence = CCSequence:create(array)
      ui.icon.icon:runAction(sequence)
    end
  end
  self:playHeroBarAnim()
end
class.playHeroAnim = playHeroAnim
local createLootIcon = function(self)
  local lootui = {}
  local loots = self.param.lootList
  for k, v in pairs(loots) do
    local icon = ed.readequip.createStagedoneLootIcon(k, nil, v.amount)
    self.draglist.listLayer:addChild(icon)
    local name
    if v.type == "equip" then
      name = ed.getDataTable("equip")[k].Name
    elseif v.type == "hero" then
      name = ed.getDataTable("Unit")[k]["Display Name"]
    end
    table.insert(lootui, {
      icon = icon,
      name = name,
      id = k
    })
  end
  self.lootui = lootui
end
class.createLootIcon = createLootIcon
local createGetEquipablePropTutorial = function(self, index)
  ed.teach("clickNextStage", self.ui.next, self.mainLayer)
end
class.createGetEquipablePropTutorial = createGetEquipablePropTutorial
local function playLootAnim(self)
  local dt = 0
  if #(self.lootui or {}) == 0 then
    self:playButtonAnim()
  end
  for i = 1, #self.lootui do
    do
      local x = loot_ori_x + loot_gap_x * (i - 1)
      local y = loot_ori_y
      self.lootui[i].icon:setPosition(ccp(x, y))
      local icon = self.lootui[i].icon
      icon:setScale(0)
      local array = CCArray:create()
      local delay = CCDelayTime:create(dt + loot_show_gap * (i - 1))
      local func = CCCallFunc:create(function()
        xpcall(function()
          self.draglist:initListWidth(loot_gap_x * i + 20)
          local currentRightSide = self.draglist.listLayer:convertToWorldSpace(ccp(x, y)).x + 40
          local rightSide = list_rect.origin.x + list_rect.size.width
          if currentRightSide > rightSide then
            local x, y = self.draglist.listLayer:getPosition()
            local nx = rightSide - currentRightSide
            local move = CCMoveTo:create(0.2, ccp(nx, y))
            move = CCEaseBackOut:create(move)
            local func = CCCallFunc:create(function()
              xpcall(function()
                self.draglist:refreshShade()
                self:createGetEquipablePropTutorial(i)
              end, EDDebug)
            end)
            local sequence = CCSequence:createWithTwoActions(move, func)
            self.draglist.listLayer:runAction(sequence)
          else
            self:createGetEquipablePropTutorial(i)
          end
          if i == #self.lootui then
            self:playButtonAnim()
          end
        end, EDDebug)
      end)
      local action = CCScaleTo:create(0.2, 1)
      action = CCEaseElasticOut:create(action)
      array:addObject(delay)
      array:addObject(func)
      array:addObject(action)
      local sequence = CCSequence:create(array)
      icon:runAction(sequence)
    end
  end
end
class.playLootAnim = playLootAnim
local playButtonAnim = function(self)
  local replay = self.ui.replay
  local next = self.ui.next
  if replay:numberOfRunningActions() > 0 or next:numberOfRunningActions() > 0 then
    return
  end
  replay:setOpacity(0)
  replay:setVisible(self.param.isKeyStage)
  next:setOpacity(0)
  next:setVisible(true)
  local stage = self.param.stage_id
  local limit = ed.getDataTable("Stage")[stage]["Daily Limit"]
  local s = ed.elite2NormalStage(stage)
  local count = (ed.player.stage_limit or {})[s] or 0
  local action = CCFadeIn:create(0.2)
  if limit and limit <= count and limit > 0 then
  elseif ed.isElementInTable(ed.stageType(stage), {"elite", "normal"}) then
    replay:runAction(action)
  end
  next:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
end
class.playButtonAnim = playButtonAnim
local function createListLayer(self)
  local info = {
    cliprect = list_rect,
    leftshade = "UI/alpha/HVGA/stagedone_left_shade.png",
    rightshade = "UI/alpha/HVGA/stagedone_right_shade.png",
    container = self.mainLayer,
    zorder = 10,
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot(),
    cancelPressIn = self:cancelPressInLoot()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local test = {
  stars = 3,
  heroes = {
    1,
    2,
    3
  },
  loots = {
    {id = 101, type = "equip"},
    {id = 101, type = "equip"},
    {id = 105, type = "equip"},
    {id = 105, type = "equip"},
    {id = 106, type = "equip"},
    {id = 107, type = "equip"},
    {id = 108, type = "equip"},
    {id = 109, type = "equip"},
    {id = 110, type = "equip"},
    {id = 111, type = "equip"}
  },
  victory = true,
  stage_id = 1
}
local createGuildInstanceUI = function(self)
  local guildLayer = CCSprite:create()
  self.mainLayer:addChild(guildLayer)
  self.guildLayer = guildLayer
  self.guildInstanceUI = {}
  local uiRes = {
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("stagedone.1.10.1.001")),
        fontinfo = "normalButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(110, 305)
      }
    },
    {
      t = "Label",
      base = {
        name = "progressNum",
        text = "",
        fontinfo = "pressButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(190, 305)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/guild/guildraid_stagedone_progress_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(270, 307)
      }
    },
    {
      t = "ClippingNode",
      base = {
        name = "clippingNodeNow",
        stencil = "UI/alpha/HVGA/guild/guild_progress_mask.png",
        scalexy = {x = 0, y = 1}
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(270, 307)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressIcon",
        res = "UI/alpha/HVGA/guild/guildraid_stagedone_progress_2.png",
        parent = "clippingNodeNow"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      }
    },
    {
      t = "ClippingNode",
      base = {
        name = "clippingNodeOld",
        stencil = "UI/alpha/HVGA/guild/guild_progress_mask.png",
        scalexy = {x = 0, y = 1}
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(270, 307)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressOld",
        res = "UI/alpha/HVGA/guild/guildraid_stagedone_progress_1.png",
        parent = "clippingNodeOld"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("stagedone.1.10.1.002")),
        fontinfo = "normalButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(110, 261)
      }
    },
    {
      t = "Label",
      base = {
        name = "damage",
        text = "",
        fontinfo = "pressButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(220, 261)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "arrow",
        res = "UI/alpha/HVGA/player_levelup_arrow.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(300, 261)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("stagedone.1.10.1.003")),
        fontinfo = "normalButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(335, 261)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "moneyIcon",
        res = "UI/alpha/HVGA/goldicon_small.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(385, 261)
      }
    },
    {
      t = "Label",
      base = {
        name = "goldMoney",
        text = "",
        fontinfo = "pressButton"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(420, 261)
      }
    },
    {
      t = "RichText",
      base = {
        name = "coin",
        text = T(LSTR("stagedone.1.10.1.004"))
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(110, 215)
      }
    }
  }
  local readNode = ed.readnode.create(guildLayer, self.guildInstanceUI)
  readNode:addNode(uiRes)
  guildLayer:setVisible(false)
end
local playInstanceProcess = function(self)
  local guildInstanceData = self.param.guildInstanceData
  if guildInstanceData ~= nil then
    local stencil = self.guildInstanceUI.clippingNodeOld:getStencil()
    stencil:setScaleX(guildInstanceData.oldProgress / 10000)
    ListenTimer(Timer:Once(1), function()
      self.guildLayer:setVisible(true)
      self.guildAnimationId = self.mainLayer:getScheduler():scheduleScriptFunc(self:guildDataAnimation(), 0, false)
    end)
  end
end
local function playEnterAnim(self)
  self:playLightAnim()
  self:playInfoBgAnim()

  self:playLevelAnim()
  self:playHeroAnim()
  self:playNumberJumpAnim()
  if self.param.isKeyStage then
    if self.param.guildInstanceData then
      self:playWinAnim()
    else
      self:playStarAnim(1)
    end
  else
	  self:playWinAnim()
  end
  self.ui.top_win_bg_1:setVisible(self.param.isKeyStage)
  self.ui.top_win_bg_2:setVisible(not self.param.isKeyStage)
  playInstanceProcess(self)
  local reward = self.param.bestRankReward._best_rank_reward or 0
  if reward > 0 then
    self.mainLayer:setTouchEnabled(false)
    ListenTimer(Timer:Once(3), function()
      self.mainLayer:setTouchEnabled(true)
      local action = CCScaleTo:create(0.5, 1)
      action = CCEaseBackOut:create(action)
      self.pvpLayer:runAction(action)
      local rotate = CCRotateBy:create(5, 360)
      rotate = CCRepeatForever:create(rotate)
      self.pvpui.light:runAction(rotate)
      ed.setString(self.pvpui.reward, reward)
      self.pvpLayer:setVisible(true)
    end)
  end
  if self.param.guildInstanceData then
    do
      local specialLoots = self.param.guildInstanceData.specialLoots
      local breakHistory = self.param.guildInstanceData.breakHistory
      if specialLoots then
        self.mainLayer:setTouchEnabled(false)
        ListenTimer(Timer:Once(3), function()
          self.mainLayer:setTouchEnabled(true)
          ed.showGuildLoots(specialLoots, breakHistory)
        end)
      elseif self.param.guildInstanceData.breakHistory then
        self.mainLayer:setTouchEnabled(false)
        ListenTimer(Timer:Once(3), function()
          self.mainLayer:setTouchEnabled(true)
          ed.showGuildHistoryRank(breakHistory)
        end)
      end
    end
  end
end
class.playEnterAnim = playEnterAnim
local function onEnterHandler(self)
  local function handler()
    lsr:report("createScene")
    local getNewHero
    for k, v in pairs(self.param.lootList) do
      if v.type == "hero" then
        ed.announce({
          type = "getNewHero",
          param = {
            id = k,
            handler = function()
              self:playEnterAnim()
            end
          }
        })
        getNewHero = true
        break
      end
    end
    if not getNewHero then
      self:playEnterAnim()
    end
    if ed.playerlimit.checkAreaUnlock("shop") then
      ed.teach("unlockShop")
      ed.endTeach("unlockShop")
    end
    if ed.player:hasTriggerShop() then
      self.hasTriggerShop = true
      local ltid = ed.player:getLastTriggerShopid()
      if ltid == 2 then
        ed.teach("unlockSpecialShop")
      elseif ltid == 3 then
        ed.teach("unlockSoSpecialShop")
      elseif ltid == "starshop" then
        ed.teach("unlockStarShop")
      end
    end
    local lsr = ed.ui.baselsr.create("base")
    lsr:report("playerLevelup")
  end
  return handler
end
class.onEnterHandler = onEnterHandler
local onExitWork = function()
  ed.player.loots = {}
end
local doPvpLayerTouch = function(self)
  local function handler(event, x, y)
    if not self.pvpLayer:isVisible() then
      return false
    end
    if event == "began" then
      if ed.containsPoint(self.pvpui.closeRewardInfo, x, y) then
        self.pvpui.closeRewardInfo:setVisible(false)
        self.pvpui.closeRewardInfoPress:setVisible(true)
      end
    elseif event == "ended" and self.pvpui.closeRewardInfoPress:isVisible() then
      self.pvpui.closeRewardInfo:setVisible(true)
      self.pvpui.closeRewardInfoPress:setVisible(false)
      self.pvpLayer:setVisible(false)
    end
    return true
  end
  return handler
end
class.doPvpLayerTouch = doPvpLayerTouch
local createPvpRankReward = function(self)
  local pvpLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.scene:addChild(pvpLayer)
  self.pvpLayer = pvpLayer
  pvpLayer:setTouchEnabled(true)
  pvpLayer:registerScriptTouchHandler(self:doPvpLayerTouch(), false, -100, true)
  self.pvpui = {}
  local rewardUIRes = {
    {
      t = "Scale9Sprite",
      base = {
        name = "rewardBg",
        res = "installer/serverselect_serverlist_bg.png",
        capInsets = CCRectMake(15, 10, 142, 16)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 240)
      },
      config = {
        scaleSize = CCSizeMake(390, 450)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_light.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 350)
      },
      config = {scale = 2}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_result_highest.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 350)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(200, 310)
      },
      config = {scale = 1}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(250, 400)
      },
      config = {scale = 1}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(140, 400)
      },
      config = {scale = 2}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(180, 390)
      },
      config = {scale = 1}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(100, 310)
      },
      config = {scale = 1}
    },
    {
      t = "Sprite",
      base = {
        name = "heroInfo",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/tip_detail_bg.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 166)
      },
      config = {
        fix_size = CCSizeMake(390, 60)
      }
    },
    {
      t = "Sprite",
      base = {name = "heroInfo", parent = "rewardBg"},
      layout = {
        anchor = ccp(0.5, 0.5)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("STAGEDONE.RECEIVE_AWARDS_")),
        size = 22,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(60, 164)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_icon",
        res = "UI/alpha/HVGA/rmbicon.png",
        parent = "heroInfo"
      },
      layout = {
        position = ccp(180, 164)
      },
      config = {scale = 0.8}
    },
    {
      t = "Label",
      base = {
        name = "reward",
        text = "2323",
        size = 20,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(210, 164)
      },
      config = {
        color = ccc3(233, 150, 44)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(200, 130)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "closeRewardInfo",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 10, 100, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 44)
      },
      config = {
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "closeRewardInfoPress",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 10, 100, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 44)
      },
      config = {
        scaleSize = CCSizeMake(120, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("CHATCONFIG.CONFIRM")),
        fontinfo = "ui_normal_button",
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 44)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "RichText",
      base = {
        name = "historyRank",
        text = "",
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(60, 274)
      }
    },
    {
      t = "RichText",
      base = {
        name = "currentRank",
        text = "",
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(60, 224)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("STAGEDONE.AWARDS_WILL_BE_DISTRIBUTED_THROUGH_THE_MAIL")),
        size = 22,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(60, 104)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    }
  }
  local readNode = ed.readnode.create(pvpLayer, self.pvpui)
  readNode:addNode(rewardUIRes)
  local data = T(LSTR("STAGEDONE.TEXT_NORMALBUTTON_HISTORICAL_HIGH_RANK_ARTNUM_SMALL_PVP__D"), self.param.bestRankReward._best_rank)
  self.pvpui.historyRank:setString(data)
  data = T(LSTR("STAGEDONE.TEXT_NORMALBUTTON_CURRENT_RANK_ARTNUM_SMALL_PVP__DTEXT_NORMALBUTTON__SPRITE_UIALPHAHVGAPVPPVP_UPPNGTEXT_PRESSBUTTON__DTEXT_NORMALBUTTON__"), self.param.bestRankReward._cur_rank, self.param.bestRankReward._best_rank - self.param.bestRankReward._cur_rank)
  self.pvpui.currentRank:setString(data)
  self.pvpLayer:setVisible(false)
end
class.createPvpRankReward = createPvpRankReward
local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.replay,
    press = ui.replay_press,
    key = "replay_button",
    extraCheckHandler = function()
      if not self.param.isKeyStage then
        return false
      end
      return true
    end,
    clickHandler = function()
      self:doClickReplay()
    end
  })
  self:btRegisterButtonClick({
    button = ui.next,
    press = ui.next_press,
    key = "next_button",
    clickHandler = function()
      self:doClickNext()
    end
  })
  self:btRegisterButtonClick({
    button = ui.battleStatist,
    press = ui.battleStatist_press,
    key = "account_button",
    clickHandler = function()
      lsr:report("showBattleCount")
      ed.ui.battleStatist.create(ed.engine.unit_list)
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  local self = base.create("stagedone")
  setmetatable(self, class.mt)
  self.param = param
  local scene = self.scene
  local mainLayer = self.mainLayer
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = ed.ui.stageaccount.getBattleBgRes(param.stage_id)
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "ColorLayer",
      base = {
        name = "shelter",
        color = ccc4(0, 0, 0, 150)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/lettherebelight.png"
      },
      layout = {
        position = ccp(372, 400)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "star_1",
        res = "UI/alpha/HVGA/star_left.png",
		z = 100
      },
      layout = {
        position = star_pos[1]
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "star_2",
        res = "UI/alpha/HVGA/star_center.png",
		z = 101
      },
      layout = {
        position = star_pos[2]
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "star_3",
        res = "UI/alpha/HVGA/star_right.png",
		z = 102
      },
      layout = {
        position = star_pos[3]
      },
      config = {visible = false}
	},
    {
      t = "Sprite",
      base = {
        name = "replay",
        res = "UI/alpha/HVGA/replaybtn.png"
      },
      layout = {
        position = ccp(710, 315)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "replay_press",
        res = "UI/alpha/HVGA/replaybtn-disabled.png",
        parent = "replay"
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
        name = "next",
        res = "UI/alpha/HVGA/nextstagebtn.png"
      },
      layout = {
        position = ccp(710, 100)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "next_press",
        res = "UI/alpha/HVGA/nextstagebtn-disabled.png",
        parent = "next"
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
        name = "info_bg",
        res = "UI/alpha/HVGA/bigyellowbar.png"
      },
      layout = {
        position = ccp(380, 198)
      },
      config = {isCascadeOpacity = true}
	},
	  {
		  t = "Sprite",
		  base = {
			  name = "top_win_bg_1",
			  res = "UI/alpha/HVGA/wing_win_bg_1.png",
			  parent = "info_bg"
		  },
		  layout = {
			  position = ccp(285, 380)
		  }
	  }
	,
	  {
		  t = "Sprite",
		  base = {
			  name = "top_win_bg_2",
			  res = "UI/alpha/HVGA/wing_win_bg_2.png",
			  parent = "info_bg"
		  },
		  layout = {
			  position = ccp(285, 380)
		  }
	  }
	  ,
	  {
		  t = "Sprite",
		  base = {
			  name = "info_title_bg_1",
			  res = "UI/alpha/HVGA/yellowbar_win_bg.png",
			  parent = "info_bg"
		  },
		  layout = {
			  position = ccp(285, 295)
		  }
	  }
	  ,
	  {
		  t = "Sprite",
		  base = {
			  name = "info_title_bg_2",
			  res = "UI/alpha/HVGA/shadow_win_bg.png",
			  parent = "info_bg"
		  },
		  layout = {
			  position = ccp(285, 198)
		  }
	  }
	  ,
    {
      t = "Label",
      base = {
        name = "lv_title",
        text = "LV:",
        size = 18,
        parent = "info_bg"
      },
      layout = {
        position = ccp(95, 295)
      },
      config = {
        color = ccc3(169, 70, 6)
      }
    },
    {
      t = "Label",
      base = {
        name = "lv",
        text = self.param.playerInfo.oriLevel,
        size = 18,
        parent = "info_bg"
      },
      layout = {
        position = ccp(125, 295)
      },
      config = {
        color = ccc3(169, 70, 6)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "gold_icon",
        res = "UI/alpha/HVGA/goldicon_small.png",
        parent = "info_bg"
      },
      layout = {
        position = ccp(304, 296)
      }
    },
    {
      t = "Label",
      base = {
        name = "gold_label",
        text = "+0",
        size = 19,
        parent = "info_bg"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(334, 295)
      },
      config = {
        color = ccc3(169, 70, 6)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "battleStatistNode",
        z = 2
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(530, 320)
      },
      config = {isCascadeOpacity = true}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "battleStatist",
        res = "UI/alpha/HVGA/herodetail-upgrade.png",
        capInsets = CCRectMake(20, 20, 20, 20),
        parent = "battleStatistNode"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(70, 50),
        isCascadeOpacity = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "battleStatist_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(20, 20, 20, 20),
        parent = "battleStatistNode"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(70, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "battleCount",
        text = T(LSTR("STAGEDONE.DATA")),
        fontinfo = "ui_normal_button",
        parent = "battleStatistNode"
      },
      
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(35, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/HVGA/dialog_line.png",
        parent = "battleStatistNode"
      },
      layout = {
        position = ccp(311, 110)
      },
      config = {
        fix_size = CCSizeMake(463, 3),
		visible = false
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createTeamExpBar()
  if self.param.guildInstanceData then
    self.ui.info_bg:setVisible(false)
  end
  self:createListLayer()
  self:createHeroIcon()
  self:createLootIcon()
  self.ui.info_bg:setOpacity(0)
  self.ui.battleStatistNode:setOpacity(0)
  for i = 1, #self.heroui do
    local ui = self.heroui[i]
    ui.icon.icon:setOpacity(0)
  end
  self:registerOnEnterHandler("enterAnim", self:onEnterHandler())
  self:registerOnExitHandler("onExitwork", onExitWork)
  local loots = self.param.lootList
  for k, v in pairs(loots) do
    local list = ed.readequip.getEquipableHeroList(k)
    loots[k].equipableHero = list
  end
  if param.bestRankReward then
    if 0 < (param.bestRankReward._best_rank_reward or 0) then
      self:createPvpRankReward()
    end
  end
  if param.guildInstanceData ~= nil then
    createGuildInstanceUI(self)
  end
  self:registerTouchHandler()
  return self
end
class.create = create
local showTeamLevelMax = function(self, level)
  if ed.player:checkLevelMax(level) then
    self.mlContainer:setVisible(true)
    self.lbContainer:setVisible(false)
  end
end
class.showTeamLevelMax = showTeamLevelMax
local createTeamExpBar = function(self)
  local layer = self.mainLayer
  local ui = self.ui
  local readnode
  local ui_info = {}
  local isml = ed.player:checkLevelMax(self.param.playerInfo.oriLevel)
  local mlContainer = CCSprite:create()
  mlContainer:setCascadeOpacityEnabled(true)
  self.mlContainer = mlContainer
  self.ui.info_bg:addChild(mlContainer)
  readnode = ed.readnode.create(mlContainer, ui)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "max_level_prompt",
        text = T(LSTR("STAGEDONE.HAS_REACHED_THE_LEVEL_CAP")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(164, 295)
      },
      config = {
        color = ccc3(169, 70, 6)
      }
    }
  }
  readnode:addNode(ui_info)
  if not isml then
    local lbContainer = CCSprite:create()
    lbContainer:setCascadeOpacityEnabled(true)
    self.lbContainer = lbContainer
    self.ui.info_bg:addChild(lbContainer)
    readnode = ed.readnode.create(lbContainer, ui)
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "exp_title",
          res = "UI/alpha/HVGA/xpicon.png"
        },
        layout = {
          position = ccp(190, 295),
          visible = true
        }
      },
      {
        t = "Label",
        base = {
          name = "exp_label",
          text = "+0",
          size = 19
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(229, 295)
        },
        config = {
          color = ccc3(169, 70, 6)
        }
      }
    }
    readnode:addNode(ui_info)
    mlContainer:setVisible(false)
  end
end
class.createTeamExpBar = createTeamExpBar

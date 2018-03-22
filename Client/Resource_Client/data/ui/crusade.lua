local crusade = {}
crusade.__index = crusade
local base = ed.ui.framework
setmetatable(crusade, base.mt)
ed.ui.crusade = crusade
local panel
local maxBattleMax = 15
local battleState = {}
local battleReward = {}
local leftTime = 0
local resetTimes = 0
local currentStage = 1
local lastStage
local currentSelectStage = 1
local currentEnemyHero, enemyRobot
local dragPressX = 0
local layerOriPos = ccp(0, 0)
local dragMode = false
local crusadeScope = {}
local maxRight = -100
local acts = require("util.cocos2dx.actions")
local function refreshMaxRight()
  if currentStage > 5 then
    maxRight = -720
  end
  if currentStage > 8 then
    maxRight = -1220
  end
end
local function shakeBox()
  if battleState[currentStage - 1] ~= nil and battleState[currentStage - 1] == "passed" then
    local box = string.format("box%d", currentStage - 1)
    panel.dragLayer[box]:setAction("Shake")
  end
end
local function refreshFog()
  local fog1 = panel.dragLayer.fog1
  local fog2 = panel.dragLayer.fog2
  local fog3 = panel.dragLayer.fog3
  local fog4 = panel.dragLayer.fog4
  fog1:setVisible(true)
  fog1:setOpacity(255)
  fog2:setVisible(true)
  fog2:setOpacity(255)
  fog3:setVisible(true)
  fog3:setOpacity(255)
  fog4:setVisible(true)
  fog4:setOpacity(255)
  if currentStage > 3 then
    fog1:setVisible(false)
  end
  if currentStage > 6 then
    fog2:setVisible(false)
  end
  if currentStage > 9 then
    fog3:setVisible(false)
  end
  if currentStage > 12 then
    fog4:setVisible(false)
  end
end
local function refreshFogAnimation()
  local fog
  if lastStage == 3 and currentStage > 3 then
    fog = panel.dragLayer.fog1
  elseif lastStage == 6 and currentStage > 6 then
    fog = panel.dragLayer.fog2
  elseif lastStage == 9 and currentStage > 9 then
    fog = panel.dragLayer.fog3
  elseif lastStage == 12 and currentStage > 12 then
    fog = panel.dragLayer.fog4
  end
  if nil == fog then
    return
  end
  fog:runAction(acts.sequence({
    CCFadeOut:create(1.5),
    CCCallFunc:create(function()
      fog:setVisible(false)
    end)
  }))
end
local function onEnterCrusade()
  CloseScope(crusadeScope)
  ListenTimer(Timer:Always(1.5), shakeBox, crusadeScope)
  refreshFogAnimation()
end
local onExitCrusade = function()
end
local function onPopScene()
  panel = nil
  ed.player:clearAllCrusadeData()
  CloseScope(crusadeScope)
end
function crusade.closeBattleInfo()
  panel.battleLayer:setVisible(false)
end
function crusade.reqEnemyInfo(index)
  local msg = ed.upmsg.tbc()
  msg._query_oppo = {}
  msg._query_oppo._stage_id = index
  ed.send(msg, "tbc")
  currentSelectStage = index
end
local function refreshLocalHeros(data)
  if nil == data then
    return
  end
  if nil == data._oppos then
    return
  end
  for i = 1, #data._oppos do
    local index = (currentSelectStage - 1) * 5 + i
    local heroId = string.format("tbcHero%d", index)
    local oldId = CCUserDefault:sharedUserDefault():getIntegerForKey(heroId)
    local newId = data._oppos[i]._base._tid
    if oldId ~= newId and newId ~= nil then
      CCUserDefault:sharedUserDefault():setIntegerForKey(heroId, newId)
      local heroLevel = data._oppos[i]._base._level
      local heroStar = data._oppos[i]._base._stars
      local heroRank = data._oppos[i]._base._rank
      local newLevel = string.format("tbcHeroLevel%d", index)
      local newStar = string.format("tbcHeroStar%d", index)
      local newRank = string.format("tbcHeroRank%d", index)
      CCUserDefault:sharedUserDefault():setIntegerForKey(newLevel, heroLevel)
      CCUserDefault:sharedUserDefault():setIntegerForKey(newStar, heroStar)
      CCUserDefault:sharedUserDefault():setIntegerForKey(newRank, heroRank)
    end
  end
end
local function getLocalHerosInfo(data)
  if nil == data then
    return
  end
  if nil ~= data._oppos then
    return
  end
  data._oppos = {}
  for i = 1, 5 do
    local index = (currentSelectStage - 1) * 5 + i
    local sLevel = string.format("tbcHeroLevel%d", index)
    local sStar = string.format("tbcHeroStar%d", index)
    local sRank = string.format("tbcHeroRank%d", index)
    local sId = string.format("tbcHero%d", index)
    local id = CCUserDefault:sharedUserDefault():getIntegerForKey(sId)
    if nil ~= id and id ~= 0 then
      local hero = {}
      local base = {}
      base._tid = id
      base._level = CCUserDefault:sharedUserDefault():getIntegerForKey(sLevel)
      base._stars = CCUserDefault:sharedUserDefault():getIntegerForKey(sStar)
      base._rank = CCUserDefault:sharedUserDefault():getIntegerForKey(sRank)
      hero._base = base
      local dyna = {}
      dyna._hp_perc = 0
      hero._dyna = dyna
      table.insert(data._oppos, hero)
    end
  end
end
local function showBattleInfo(data)
  refreshLocalHeros(data)
  if panel == nil then
    return
  end
  panel.battleLayer:setVisible(true)
  ed.setString(panel.battleLayer.heroName, data._summary._name)
  ed.setString(panel.battleLayer.level, data._summary._level)
  ed.setString(panel.battleLayer.currentBattle, string.format("(%d/%d)", currentSelectStage, maxBattleMax))
  for i = 1, 5 do
    local hero = string.format("hero%d", i)
    panel.battleLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  currentEnemyHero = {
    base = {},
    crusade = {}
  }
  if nil == data._oppos then
    getLocalHerosInfo(data)
  end
  local param = {
    id = data._summary._avatar,
    vip = data._summary._vip > 0
  }
  local head = ed.getHeroIconByID(param)
  if head then
    panel.battleLayer.enemyIcon:removeAllChildrenWithCleanup(true)
    panel.battleLayer.enemyIcon:addChild(head)
  end
  enemyRobot = data._is_robot and 0 < data._is_robot
  if battleState[currentSelectStage] == "passed" or battleState[currentSelectStage] == "rewarded" then
    panel.battleLayer.start:setVisible(false)
  else
    panel.battleLayer.start:setVisible(true)
  end
  if data._oppos == nil then
    return
  end
  for i = 1, #data._oppos do
    local hero = string.format("hero%d", i)
    local base = data._oppos[i]._base
    local dyna = data._oppos[i]._dyna
    if 0 < dyna._hp_perc then
      table.insert(currentEnemyHero.base, base)
      local crusadeData = {
        _hp_perc = dyna._hp_perc,
        _mp_perc = dyna._mp_perc,
        _custom_data = dyna._custom_data
      }
      currentEnemyHero.crusade[base._tid] = crusadeData
    end
    local heroIcon = ed.readhero.createIcon({
      id = base._tid,
      rank = base._rank,
      level = base._level,
      stars = base._stars,
      hp = dyna._hp_perc
    })
    heroIcon.icon:setScale(0.8)
    panel.battleLayer[hero]:addChild(heroIcon.icon)
  end
  if data._summary._guild_name and data._summary._guild_name ~= "" then
    panel.battleLayer.guildName:setVisible(true)
    ed.setString(panel.battleLayer.guildHint, LSTR("CRUSADE.FROM_THE_GUILD"))
    ed.setString(panel.battleLayer.guildName, data._summary._guild_name)
  else
	panel.battleLayer.guildName:setVisible(false)
    ed.setString(panel.battleLayer.guildHint, LSTR("CRUSADE.NOT_IN_GUILDS"))
  end
  local w = panel.battleLayer.heroName:getContentSize().width
  if w > 200 then
	  panel.battleLayer.heroName:setScale(200 / panel.battleLayer.heroName:getContentSize().width)
  end
end
local function initRewardUI(index)
  local data = battleReward[index]
  if nil == data then
    return
  end
  panel.mainLayer.rewardInfo:setVisible(true)
  panel.mainLayer.heroStone:setVisible(false)
  ed.setString(panel.mainLayer.stoneNum, "")
  panel.mainLayer.stoneText:setVisible(false)
  panel.mainLayer.randomReward:setVisible(false)
  panel.mainLayer.randomText:setVisible(false)
  local bHasItem = false
  panel.mainLayer.rewardInfo:setContentSize(CCSizeMake(170, 88))
  for i, v in ipairs(data) do
    if v._type == "gold" then
      ed.setString(panel.mainLayer.money, v._param1)
    elseif v._type == "chestbox" then
      panel.mainLayer.randomReward:setVisible(true)
      panel.mainLayer.randomText:setVisible(true)
    elseif v._type == "item" then
      panel.mainLayer.stoneText:setVisible(true)
      panel.mainLayer.heroStone:setVisible(true)
      local stone = ed.readequip.createHeroStone(v._param1, 50)
      panel.mainLayer.heroStone:removeAllChildrenWithCleanup(true)
      panel.mainLayer.heroStone:addChild(stone)
      ed.setString(panel.mainLayer.stoneNum, string.format("x%d", v._param2))
      panel.mainLayer.rewardInfo:setContentSize(CCSizeMake(170, 155))
      bHasItem = true
    end
  end
  local size = panel.mainLayer.rewardInfo:getContentSize()
  local x, y = panel.mainLayer.money:getPosition()
  panel.mainLayer.money:setPosition(ccp(x, size.height - 20))
  x = panel.mainLayer.moneyIcon:getPosition()
  panel.mainLayer.moneyIcon:setPosition(ccp(x, size.height - 20))
  x = panel.mainLayer.randomReward:getPosition()
  panel.mainLayer.randomReward:setPosition(ccp(x, size.height - 55))
  x = panel.mainLayer.randomText:getPosition()
  panel.mainLayer.randomText:setPosition(ccp(x, size.height - 55))
  if bHasItem then
    x = panel.mainLayer.stoneText:getPosition()
    panel.mainLayer.stoneText:setPosition(ccp(x, size.height - 90))
    x = panel.mainLayer.heroStone:getPosition()
    panel.mainLayer.heroStone:setPosition(ccp(x, size.height - 125))
    x = panel.mainLayer.stoneNum:getPosition()
    panel.mainLayer.stoneNum:setPosition(ccp(x, size.height - 125))
  end
  panel.mainLayer.rewardInfo:setScale(0)
  local action = CCScaleTo:create(0.1, 1)
  panel.mainLayer.rewardInfo:runAction(action)
end
local function refreshHintPos()
  local hint = panel.mainLayer.currentStageHint
  if battleState[maxBattleMax] == "rewarded" then
    hint:setVisible(false)
    return
  end
  hint:setVisible(true)
  local target, offsetX
  if battleState[currentStage] == "unpassed" and (battleState[currentStage - 1] == "rewarded" or battleState[currentStage - 1] == nil) then
    local battle = string.format("battle%d", currentStage)
    target = panel.dragLayer[battle]
    offsetX = 0
  elseif battleState[currentStage - 1] == "passed" then
    local reward = string.format("boxButton%d", currentStage - 1)
    target = panel.dragLayer[reward]
    offsetX = 40
  end
  if target == nil then
    return
  end
  local pos = ccp(target.sprite:getPosition())
  pos = target.sprite:getParent():convertToWorldSpace(pos)
  pos.x = pos.x + offsetX
  pos.y = pos.y + 30
  hint:setPosition(pos)
end
local function refreshBattleState()
  for i = 1, maxBattleMax do
    local battle = string.format("battle%d", i)
    local box = string.format("box%d", i)
    if battleState[i] == "unpassed" and i > currentStage or currentStage == i and battleState[i - 1] ~= "rewarded" and i > 1 then
      panel.dragLayer[battle]:enable(false)
    else
      panel.dragLayer[battle]:enable(true)
    end
    if battleState[i] == "rewarded" then
      panel.dragLayer[box]:setAction("Opened")
    elseif battleState[i] == "unpassed" then
      panel.dragLayer[box]:setAction("Close")
    else
      panel.dragLayer[box]:setAction("Shake")
    end
  end
  refreshHintPos()
end
local function showRewardResult(data, heros)
  if panel == nil then
    return
  end
  panel.rewardLayer:setVisible(true)
  local result = ""
  for i, v in ipairs(data) do
    if v._type == "gold" then
      result = result .. string.format("<sprite|UI/alpha/HVGA/goldicon_small.png><text|normal_button|%d >", v._param1)
    elseif v._type == "item" then
      result = result .. string.format("<item|%d|0.5><text|normal_button|x%d >", v._param1, v._param2)
      local isHero, ihid = ed.ui.poptavernloot.isHero({
        id = v._param1,
        amount = v._param2
      })
      if isHero then
        ed.announce({
          type = "popHeroCard",
          param = {
            id = ihid,
            amount = v._param2,
            priority = -205
          }
        })
        --if ed.readhero.getHeroInitStars(ihid) >= 3 then
        --  ed.openEvaluate()
        --end
      end
    elseif v._type == "crusadepoint" then
      result = result .. string.format("<sprite|UI/alpha/HVGA/money_dragonscale_small.png><text|normal_button|x%d >", v._param1)
    end
  end
  if heros then
    for i, v in ipairs(heros) do
      ed.player:addHero(v._tid)
    end
  end
  panel.rewardLayer.rewards:setString(result)
  refreshBattleState()
end
function crusade.hintBox(index)
  if battleState[index] == "rewarded" then
    return
  end
  if battleState[index] == "passed" then
    local msg = ed.upmsg.tbc()
    msg._draw_reward = {}
    msg._draw_reward._stage_id = index
    ed.send(msg, "tbc")
    return
  end
end
function crusade.hintBoxDown(index)
  if battleState[index] ~= "unpassed" then
    return
  end
  if currentStage <= 3 and index > 3 then
    return
  end
  if currentStage <= 6 and index > 6 then
    return
  end
  if currentStage <= 9 and index > 9 then
    return
  end
  if currentStage <= 12 and index > 12 then
    return
  end
  initRewardUI(index)
end
function crusade.showRuleInfo()
  panel.ruleLayer:setVisible(true)
end
function crusade.closeRuleInfo()
  panel.ruleLayer:setVisible(false)
end
function crusade.start()
  local stageId = -2 - currentStage
  local crusadeMercenary = ed.mercenary.getCrusadeMercenary()
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "crusade",
    stage_id = stageId,
    heroLimit = {type = "level", detail = 20},
    hireMercenary = crusadeMercenary
  }))
  panel.battleLayer:setVisible(false)
end
local function dragLayerTouch(event, x, y)
  if nil == panel then
    return false
  end
  if not panel.dragLayer:getVisible() then
    return false
  end
  if event == "began" then
    dragPressX = x
    local x, y = panel.dragLayer.dragContainer:getPosition()
    layerOriPos = ccp(x, y)
    local rewarInfo = panel.mainLayer.rewardInfo
    if rewarInfo:isVisible() then
      rewarInfo:setVisible(false)
    end
  elseif event == "moved" then
    if nil == dragPressX then
      return
    end
    if math.abs(x - dragPressX) < 5 then
      return
    end
    local posX = layerOriPos.x + x - dragPressX
    posX = math.min(0, math.max(posX, maxRight))
    panel.dragLayer.dragContainer:setPosition(ccp(posX, layerOriPos.y))
    dragMode = true
    panel.mainLayer.currentStageHint:setVisible(false)
    panel.mainLayer.rewardInfo:setVisible(false)
  elseif event == "ended" then
    dragPressX = nil
    if dragMode == true then
      refreshHintPos()
      dragMode = false
      return
    end
  end
  panel.dragLayer:touch(event, x, y)
  return true
end
function crusade.conformReward()
  panel.rewardLayer:setVisible(false)
end
local function refreshLeftTime()
  ed.setString(panel.mainLayer.lefttime, T(LSTR("CRUSADE.THE_REMAINING_TIMES_OF_TODAY___D"), leftTime))
end
local function initDragPos()
  local offset = math.max(currentStage - 4, 0) * 50
  if currentStage > 5 then
    offset = offset + 450
  end
  if currentStage > 9 then
    offset = offset + 400
  end
  offset = math.min(0, math.max(-offset, maxRight))
  panel.dragLayer.dragContainer:setPosition(ccp(offset, layerOriPos.y))
end
local function initPanelData(data)
  if nil == data then
    return
  end
  resetTimes = data._reset_times
  currentStage = data._cur_stage
  if currentStage == 0 then
    currentStage = maxBattleMax + 1
  end
  for i = 1, maxBattleMax do
    battleState[i] = data._stages[i]._status
    battleReward[i] = data._stages[i]._rewards
  end
  refreshMaxRight()
  initDragPos()
  refreshBattleState()
  for i, v in pairs(data._heroes) do
    ed.player:setHeroCrusadeData(v)
  end
  local vipLevel = ed.player:getvip()
  local totalTime = ed.getDataTable("VIP")[vipLevel]["Crusade Free Chance"]
  leftTime = totalTime - data._reset_times
  refreshLeftTime()
  refreshFog()
end
local function initRuleLayer()
  local list = panel.ruleLayer.listview
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_MOLTEN_VOLCANIC_BURST"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_DRAGON_TREASURE_REVEALS_TO_THE_WORLD"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_DREAMER_BEWARE_OF_YOUR_GREED"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_BECAUSE_THE_MORE_DANGEROUS_MAN_THAN_ARALIA"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_IS_THE_TREASURE_HUNTER_WITH_YOU"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_DARK_WHITE_PROPHECY_OF_FIRE_VOLUME_VII"))
  })
  list:addItem({
    "<text|normalButton|>"
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_NORMALBUTTON_BATTLE_RULES_"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT___NORMALBUTTON___ABOVE_1_LEVEL_20+_HEROES_CAN_PARTICIPATE_IN_THE_EXPEDITION"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT___NORMALBUTTON___2_DURING_THE_EXPEDITION_HP_AND_ENERGY_OF_BOTH_SIDE_WILL_NOT_RECOVER_AND_RESET"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT___NORMALBUTTON___3_DIED_HEROES_WILL_NOT_BE_RESURRECTED"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT___NORMALBUTTON___4_IF_THE_FIGHT_IS_NOT_OVER_IN_DUE_TIME_ALL_HEROES_OF_BOTH_SIDE_SHALL_BE_COUNTED_AS_DEAD"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT___NORMALBUTTON___5_PLAYERS_CAN_PARTICIPATE_THE_EXPEDITION_ONCE_A_DAY_VIP10_OR_HIGHER_CAN_PARTICIPATE_MULTIPLE_TIMES_A_DAY"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_NORMALBUTTON_6_AFTER_DEFEATING_EVERY_WAVE_OF_ENEMY_YOU_CAN_OPEN_CHEST_TO_GET_GREATER_REWARDS_REWARDS"))
  })
  list:addItem({
    T(LSTR("CRUSADE.TEXT_NORMALBUTTON_7_YOU_CAN_ALSO_GET_DRAGONSCALE_COINS_FROM_THE_CHEST_WITH_THE_FIRST_RESET_OF_THE_EXPEDITION_DRAGONSCALE_COINS"))
  })
  list:addItem({
    "<text|normalButton|>"
  })
  list:addItem({
    "<text|normalButton|>"
  })
end
local initCrusadeMercenary = function(data)
  if nil == data then
    return
  end
  ed.mercenary.setCrusadeMercenary(data._hire_hero)
end
local function initPanel(data)
  if nil == data then
    return
  end
  for i = 1, maxBattleMax do
    battleState[i] = false
  end
  panel.battleLayer:setVisible(false)
  panel.ruleLayer:setVisible(false)
  initRuleLayer()
  initPanelData(data)
  initCrusadeMercenary(data)
  local hint = panel.mainLayer.currentStageHint
  hint:stopAllActions()
  local move = CCMoveBy:create(0.5, ccp(0, 10))
  local back = CCMoveBy:create(0.5, ccp(0, -10))
  local sequence = CCSequence:createWithTwoActions(move, back)
  hint:runAction(CCRepeatForever:create(sequence))
end
function crusade.create()
  local newscene = base.create("crusade")
  setmetatable(newscene, crusade)
  panel = panelMeta:new(newscene, EDTables.crusadeConfig.UIRes)
  local rect = panel.mainLayer.bgframe:boundingBox()
  rect.origin.x = rect.origin.x + 0.04 * rect.size.width
  rect.origin.y = rect.origin.y + 0.05 * rect.size.height
  rect.size.width = rect.size.width * 0.93
  rect.size.height = rect.size.height * 0.91
  panel.dragLayer:setClipRect(rect)
  panel.dragLayer.mainLayer:setTouchEnabled(true)
  panel.dragLayer.mainLayer:registerScriptTouchHandler(dragLayerTouch, false, 0, false)
  newscene:registerOnEnterHandler("onEnterCrusade", onEnterCrusade)
  newscene:registerOnExitHandler("onExitCrusade", onExitCrusade)
  newscene:registerOnPopSceneHandler("onPopScene", onPopScene)
  return newscene
end
function crusade.resetBattle()
  if leftTime <= 0 then
    ed.showToast(T(LSTR("CRUSADE.NO_RESET_TIMES_LEFT_TODAY")))
    return
  end
  local sprite = CCSprite:create()
  local info = {
    sprite = sprite,
    spriteLabel = T(LSTR("CRUSADE.END_THIS_EXPEDITION_AND_START_OVER")),
    leftText = T(LSTR("CHATCONFIG.CANCEL")),
    rightText = T(LSTR("CHATCONFIG.CONFIRM")),
    rightHandler = function()
      xpcall(function()
        local msg = ed.upmsg.tbc()
        msg._reset = {}
        ed.send(msg, "tbc")
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end
function crusade.openShop()
  ed.pushScene(ed.ui.shop.create(4))
end
local function endBattle(data)
  if nil == data then
    return
  end
  if "victory" == data._result or "timeout" == data._result then
    ed.record:refreshCommonRecord("completeCrusadeStage")
    battleState[currentStage] = "passed"
    lastStage = currentStage
    currentStage = currentStage + 1
    refreshBattleState()
  end
  if ed.netreply.exitStageReply then
    ed.netreply.exitStageReply(data._result)
    ed.netreply.exitStageReply = nil
  end
  refreshMaxRight()
end
local function getReward(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    do
      local box = string.format("box%d", data._stage_id)
      if panel then
        panel.dragLayer[box]:setAction("Opening")
      end
      battleState[data._stage_id] = "rewarded"
      local reward = data._rewards
      if nil == reward then
        return
      end
      for i, v in ipairs(reward) do
        if v._type == "gold" then
          ed.player:addMoney(v._param1)
        elseif v._type == "item" then
          if ed.itemType(v._param1) == "equip" then
            ed.player:addEquip(v._param1, v._param2)
          end
        elseif v._type == "crusadepoint" then
          ed.player:addCrusadeMoney(v._param1)
        end
      end
      ListenTimer(Timer:Once(0.8), function()
        showRewardResult(reward, data._heroes)
      end, crusadeScope)
    end
  end
end
local function OnCrusadeRsp(msg)
  if msg._open_panel then
    if panel == nil then
      ed.pushScene(ed.ui.crusade.create())
    end
    initPanel(msg._open_panel._info)
  elseif msg._query_oppo then
    showBattleInfo(msg._query_oppo)
  elseif msg._start_bat then
    if ed.netreply.gotoCrusadeBattleReply then
      ed.srand(msg._start_bat._rseed)
      ed.netreply.gotoCrusadeBattleReply(currentEnemyHero.base, enemyRobot, nil, currentEnemyHero.crusade)
      ed.netreply.gotoCrusadeBattleReply = nil
    end
  elseif msg._end_bat then
    endBattle(msg._end_bat)
  elseif msg._reset then
    if msg._reset._result == "success" then
      initPanel(msg._reset._info)
    end
  else
    if msg._draw_reward then
      getReward(msg._draw_reward)
    else
    end
  end
end
ListenEvent("CrusadeRsp", OnCrusadeRsp)

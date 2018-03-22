local storyUI = {}
local heroNameFramePos = {
  left = ccp(180, 112),
  right = ccp(620, 112)
}
local heroNamePos = {
  left = ccp(179, 113),
  right = ccp(619, 113)
}
local heroIconPos = {
  left = ccp(175, 100),
  right = ccp(625, 100)
}
local uiRes = {
  {
    t = "Sprite",
    base = {name = "heroIcon"},
    layout = {}
  },
  {
    t = "Sprite",
    base = {
      name = "shadowBg",
      res = "UI/alpha/HVGA/dialogue_bottom_shadow.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 60)
    },
    config = {
      fix_size = CCSizeMake(800, 500)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "storyBg",
      res = "UI/alpha/HVGA/dialogue_content_bg.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 60)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "hint",
      res = "UI/alpha/HVGA/dialogue_arrow.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(710, 40)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "nameFrame",
      res = "UI/alpha/HVGA/dialogue_name_bg.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 120)
    }
  },
  {
    t = "Label",
    base = {
      name = "heroName",
      text = "",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 120)
    },
    config = {
      color = ccc3(117, 77, 0)
    }
  },
  {
    t = "Label",
    base = {
      name = "content",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 60)
    },
    config = {
      dimension = CCSizeMake(600, 120),
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCTextAlignmentCenter,
      color = ccc3(117, 77, 0)
    }
  }
}
local mainLayer, storyData
local currentSection = 1
local storyName = ""
local getFadeAction = function()
  local fadeInAction = CCFadeIn:create(1)
  local fadeOutAction = CCFadeOut:create(1)
  local fadeAction = CCSequence:createWithTwoActions(fadeInAction, fadeOutAction)
  fadeAction = CCRepeatForever:create(fadeAction)
  return fadeAction
end
local function createMainLayer()
  local Layer = CCLayer:create()
  storyUI = {}
  local readNode = ed.readnode.create(Layer, storyUI)
  readNode:addNode(uiRes)
  local fadeAction = getFadeAction()
  storyUI.hint:runAction(fadeAction)
  return Layer
end
local getUnitInfo = function(playerIndex, monsterIndex)
  local unit
  if playerIndex ~= nil then
    local num = ed.engine:getUnitNum(ed.emCampPlayer)
    unit = ed.engine:getUnitByIndex(playerIndex > num and num or playerIndex, ed.emCampPlayer)
  elseif monsterIndex ~= nil then
    local num = ed.engine:getUnitNum(ed.emCampEnemy)
    unit = ed.engine:getUnitByIndex(monsterIndex > num and num or monsterIndex, ed.emCampEnemy)
  end
  return unit
end
local function setHeroInfo(icon, name, playerIndex, monsterIndex)
  local unit = getUnitInfo(playerIndex, monsterIndex)
  local info = unit and unit.info or nil
  local icon = info and info["Icon Name"] or icon
  local name = info and info["Display Name"] or name
  local frame = ed.getSpriteFrame(icon)
  if frame then
    storyUI.heroIcon:initWithSpriteFrame(frame)
  end
  if name then
    ed.setString(storyUI.heroName, name)
    if storyUI.heroName:getContentSize().width > 180 then
      storyUI.heroName:setScale(180 / storyUI.heroName:getContentSize().width)
    end
  end
end
local function changeStoryInfo()
  local data = storyData[currentSection]
  if nil == data then
    return
  end
  setHeroInfo(data.icon, data.name, data.playIndex, data.monsterIndex)
  if data.position == "left" then
    storyUI.storyBg:setFlipX(false)
    storyUI.heroIcon:setFlipX(false)
  else
    storyUI.heroIcon:setFlipX(true)
    storyUI.storyBg:setFlipX(true)
  end
  storyUI.heroIcon:setPosition(heroIconPos[data.position])
  storyUI.heroIcon:setAnchorPoint(ccp(0.5, 0))
  storyUI.heroName:setPosition(heroNamePos[data.position])
  storyUI.nameFrame:setPosition(heroNameFramePos[data.position])
  ed.setString(storyUI.content, data.text)
end
local function closeStory()
  storyUI = {}
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if not tolua.isnull(mainLayer) then
    mainLayer:unregisterScriptTouchHandler()
  end
  if currentScene and mainLayer then
    currentScene:removeChild(mainLayer, true)
    mainLayer = nil
  end
  if ed.getCurrentScene() == ed.scene then
    ed.scene:resumeBattle("story")
  end
  FireEvent("StoryEnd", storyName)
end
local function showStorySection()
  if currentSection > #storyData and mainLayer then
    closeStory()
    return
  end
  changeStoryInfo()
  currentSection = currentSection + 1
end
local function onMainLayerTouch()
  local function handler(event, x, y)
    xpcall(function()
      if event == "ended" then
        ed.playEffect(ed.sound.dialogue.click)
        --add by xinghui
        if storyName == "_5v5Opening" or storyName == "_5v5ES" or storyName == "_5v5CM" or storyName == "_5v5Sniper" or storyName == "_5v5Zeus" or storyName == "_5v5Ending" then
            ed.dot_id = ed.dot_id +1
            ed.sendDotInfoToServer(ed.dot_id)
        end
        --
        showStorySection()
      end
    end, EDDebug)
    return true
  end
  return handler
end
local function showStory(data)
  xpcall(function()
    if data == nil then
      return
    end
    currentSection = 1
    if EDTables.story[data] == nil then
      return
    end
    storyName = data
    storyData = EDTables.story[data].Content
    if true == EDTables.story[data].ShowOnce then
      if true == CCUserDefault:sharedUserDefault():getBoolForKey(data) then
        return
      end
      CCUserDefault:sharedUserDefault():setBoolForKey(data, true)
    end
    if mainLayer then
      closeStory()
    end
    mainLayer = createMainLayer()
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      mainLayer:setTouchEnabled(true)
      mainLayer:registerScriptTouchHandler(onMainLayerTouch(), false, -240, true)
      currentScene:addChild(mainLayer, 1000)
      showStorySection()
      ed.playEffect(ed.sound.dialogue.appear)
      if ed.getCurrentScene() == ed.scene then
        ed.scene:pauseBattle("story")
      end
    end
  end, EDDebug)
end
ed.showStory = showStory
local function EnterBattleStage(stage, wave)
  local storyName = string.format("Stage%dWave%d", stage, wave)
  showStory(storyName)
end
local function WinBackToSelect(state)
  local storyName = string.format("WinBackToSelect%d", state)
  showStory(storyName)
end
local function EnterMainUi()
  local storyName = "OpeningMain"
  showStory(storyName)
end
ListenEvent("EnterBattleStage", EnterBattleStage)
ListenEvent("WinBackToSelect", WinBackToSelect)
ListenEvent("EnterMainUI", EnterMainUi)

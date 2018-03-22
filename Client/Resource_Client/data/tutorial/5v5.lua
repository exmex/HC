local registerListeners, unregisterListeners
local function start5v5()
  registerListeners()
  ed.srand(1)
  local left = {
    {_tid = 1, name = "Coco", _level = 70},
    {_tid = 30, name = "ES", _level = 70},
    {_tid = 12, name = "CM", _level = 70},
    {_tid = 4, name = "Zeus", _level = 70},
    {_tid = 10, name = "Sniper", _level = 70}
  }
  local right = {
    {_tid = 14, name = "SG", _level = 70},
    {_tid = 31, name = "Luna", _level = 70},
    {_tid = 25, name = "SF", _level = 70},
    {_tid = 7, name = "QOP", _level = 70},
    {_tid = 2, name = "DR", _level = 70}
  }
  local stage = ed.lookupDataTable("Stage", nil, -2)
  local battle = ed.lookupDataTable("Battle", nil, -2, 1)
  ed.engine:enterStage(stage, left, true)
  local Coco = ed.engine:findHero("Coco")
  Coco.config.hp_mod = 10
  Coco:rebuild()
  Coco.hp = Coco.attribs.HP
  Coco.ai.will_cast_manual_skill = false
  local skill = Coco.skills.Coco_atk2
  skill.info["Plus Ratio"] = 2
  local ES = ed.engine:findHero("ES")
  ES.config.hp_mod = 1.1
  ES:rebuild()
  ES.hp = ES.attribs.HP
  ES.mp = 50
  ES.ai.will_cast_manual_skill = false
  local CM = ed.engine:findHero("CM")
  CM.config.hp_mod = 1.5
  CM:rebuild()
  CM.hp = CM.attribs.HP
  CM.mp = 400
  CM.ai.will_cast_manual_skill = false
  skill = CM.skills.CM_atk2
  skill.info.CD = 24
  CM.aura_skill_list = {}
  CM.effect_enemy_aura_skill_list = {}
  local Zeus = ed.engine:findHero("Zeus")
  Zeus.config.hp_mod = 1.5
  Zeus.config.dps_mod = 2.5
  Zeus:rebuild()
  Zeus.hp = Zeus.attribs.HP
  Zeus.mp = 50
  Zeus.ai.will_cast_manual_skill = false
  Zeus.skills.Zeus_atk3.info.CD = 24
  local Sniper = ed.engine:findHero("Sniper")
  Sniper.config.hp_mod = 0.9
  Sniper:rebuild()
  Sniper.hp = Sniper.attribs.HP
  Sniper.mp = 150
  skill = Sniper.skills.Sniper_ult
  skill.info["Plus Ratio"] = 4
  skill.info["Target Type"] = "farthest"
  Sniper.ai.will_cast_manual_skill = false
  local Axe = ed.engine:findMonster("Axe")
  Axe.config.hp_mod = 3.5
  Axe:rebuild()
  Axe.hp = Axe.attribs.HP
  Axe.mp = 1000
  skill = Axe.skills.Axe_ult
  skill.info["Plus Ratio"] = 10
  local Med = ed.engine:findMonster("Med")
  Med.config.hp_mod = 3
  Med.config.dps_mod = 3
  Med:rebuild()
  Med.hp = Med.attribs.HP
  Med.mp = 50
  Med.skills.Med_ult.info["Plus Ratio"] = 5
  local SF = ed.engine:findMonster("SF")
  SF.config.hp_mod = 100
  SF:rebuild()
  SF.hp = SF.attribs.HP
  skill = SF.skills.SF_ult
  skill.info["Plus Ratio"] = 10
  local QOP = ed.engine:findMonster("QOP")
  QOP.config.hp_mod = 5
  QOP.config.dps_mod = 2.5
  QOP:rebuild()
  QOP.mp = 0
  QOP.hp = QOP.attribs.HP
  local Bone = ed.engine:findMonster("Bone")
  Bone.config.hp_mod = 1.5
  Bone:rebuild()
  Bone.hp = Bone.attribs.HP
  ed.scene:reset(stage, battle)
  ed.pushScene(ed.scene)
  local enterLayer = CCLayer:create()
  enterLayer:registerScriptHandler(function(event)
    if event == "enter" then
      ed.endTeach("_5v5Anim")
    end
  end)
  ed.scene:ccScene():addChild(enterLayer)
  ed.scene.return_btn:setVisible(false)
  ed.scene.return_btn:setEnabled(false)
  ed.scene.auto_btn:setVisible(false)
  ed.scene.auto_btn:setEnabled(false)
  ed.scene.wave_mark:setVisible(false)
  ed.scene.goldmarker:setVisible(false)
  ed.scene.lootmarker:setVisible(false)
  
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
    ed.scene.google_play_btn:setVisible(false)
  end
end
ed.start5v5 = start5v5
local onSkillReady = function(unit)
  ed.scene:pauseBattle("5v5skill")
  ed.showStory("_5v5" .. unit.name)
end
local onSkillTouch = function(unit)
    --add by xinghui: 5v5fight, big skill dot
    ed.dot_id = ed.dot_id+1
    ed.sendDotInfoToServer(ed.dot_id)
    --
  ed.scene:resumeBattle("5v5skill")
end
local opening = function(stage, wave)
  if stage == -2 then
    ed.showStory("_5v5Opening")
  end
end
local count = 0
local function unitDie(unit, killer)
  if unit.camp == ed.emCampPlayer then
    count = count + 1
    if count == 4 then
      ed.showStory("_5v5Ending")
      ed.scene:pauseBattle("5v5ending")
    end
  end
end
local function storyEnd(storyname)
  LegendLog("+++Lua+++ storyEnd: "..storyname)
  if storyname == "_5v5Ending" then
    ed.engine.enabled = false
    ed.replaceScene(ed.ui.main.create({ps = "5v5"}))
    unregisterListeners()
  elseif string.match(storyname, "^_5v5") then
    local name = string.gsub(storyname, "^_5v5", "")
    local hero = ed.engine:findHero(name)
    if hero then
      local panel = hero.heroPanel
      ed.teach("_5v5UseSkill", panel.menu:getParent():convertToWorldSpace(ccp(panel.menu:getPosition())), 40, ed.scene.ui_layer, ed.scene.ui_layer)
    end
  end
end
function registerListeners()
  LegendLog("+++Lua+++ Start tutorial")
  ed.tutorial.isFinishTutorial = false
  ListenEvent("ult_skill_ready", onSkillReady)
  ListenEvent("ult_skill_touch", onSkillTouch)
  ListenEvent("EnterBattleStage", opening)
  ListenEvent("UnitDieDelay", unitDie)
  ListenEvent("StoryEnd", storyEnd)
end
function unregisterListeners()
  LegendLog("+++Lua+++ Finish tutorial")
  ed.tutorial.isFinishTutorial = true
  StopListenEvent("ult_skill_ready", onSkillReady)
  StopListenEvent("ult_skill_touch", onSkillTouch)
  StopListenEvent("EnterBattleStage", opening)
  StopListenEvent("UnitDieDelay", unitDie)
  StopListenEvent("StoryEnd", storyEnd)
end

local function skip5v5()
	ed.scene:exit();
	ed.endTeach("_5v5Anim");
	ed.engine.enabled = false
    ed.replaceScene(ed.ui.main.create({ps = "5v5"}))
	FireEvent("StoryEnd", "_5v5Opening")
	FireEvent("StoryEnd", "_5v5ES")
	FireEvent("StoryEnd", "_5v5CM")
	FireEvent("StoryEnd", "_5v5Sniper")
	FireEvent("StoryEnd", "_5v5Zeus")
	FireEvent("StoryEnd", "_5v5Zeus")
	FireEvent("StoryEnd", "_5v5Ending")	
	ed.tutorial.isFinishTutorial = true
end
ed.skip5v5 = skip5v5

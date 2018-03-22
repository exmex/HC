local ed = ed
local FireEvent = FireEvent
local class = {
  mt = {}
}
ed.HeroPanel = class
class.mt.__index = class
local function HeroPanelCreate(unit, color)
  local mercenary = unit:isMercenary() and {} or nil
  local info = unit.info
  local self = {
    what = "HeroPanel",
    unit = unit,
    node = CCNode:create(),
    hp_bar = ed.HpBarCreate(unit, "HP", color),
    mp_bar = ed.HpBarCreate(unit, unit.info["MP Type"]),
    portrait = ed.readhero.createIcon({
      id = unit.tid,
      stars = unit.stars,
      isHideFrame = true,
      mercenary = mercenary
    }),
    redmask = ed.createSprite("UI/alpha/HVGA/portraitredmask.png"),
    btn = nil,
    width = 120,
    height = 144,
    skill_ready = nil,
    skill_ready_timer = 0,
    ticks = -1,
    fca_switch = "eff_UI_battle_skill_can_switch",
    fca_ready = "eff_UI_battle_skill_will_ready",
    fca_cast = "eff_UI_battle_skill_cast",
    fca_trigger = "eff_UI_battle_skill_activate"
  }
  setmetatable(self, class.mt)
  self.portrait.icon:setPosition(ccp(0, 70))
  self.node:addChild(self.portrait.icon, 0)
  local res = ed.Hero.getIconFrameByRank(unit.rank)
  local frame = CCMenuItemImage:create(res, res, res)
  self.btn = frame
  local menu = CCMenu:createWithItem(frame)
  menu:setPosition(ccpAdd(frame:getAnchorPointInPoints(), ccp(-2, -2)))
  self.menu = menu
  self.portrait.icon:addChild(menu)
  function self.castHandler()
    if ed.engine.running then
      ed.engine:manuallyCastSkill(self.unit)
      self.btn:setEnabled(false)
      self:play_skill_cast_effect()
          --add by xinghui:send dot info when click big skill in normal stage
          if --[[(ed.tutorial.checkDone("useSkill")== false) and (ed.tutorial.checkDone("nextWave")) and (ed.tutorial.checkDone("gotoEquipProp")==false or ed.tutorial.isShowTutorial)--]] (ed.tutorial.isShowTutorial and (ed.tutorial.checkDone("nextWave"))) then
               ed.sendDotInfoToServer(ed.tutorialres.t_key["useSkill"].id)
          end
          --
      ed.endTeach("useSkill")
      FireEvent("ult_skill_touch", self.unit)
    end
  end
  self.btn:registerScriptTapHandler(function()
    xpcall(self.castHandler, EDDebug)
  end)
  self.btn:setEnabled(false)
  local container = ed.createSprite("UI/alpha/HVGA/herobucket.png")
  container:setPosition(ccpAdd(ccp(-1, -2), self.portrait.icon:getAnchorPointInPoints()))
  self.portrait.icon:addChild(container, -2)
  self.hp_bar.auto_hide = false
  self.hp_bar.node:setPosition(ccp(0, 21))
  self.node:addChild(self.hp_bar.node, 2)
  self.mp_bar.auto_hide = false
  self.mp_bar.node:setPosition(ccp(0, 8))
  self.node:addChild(self.mp_bar.node, 2)
  frame:addChild(self.redmask)
  self.redmask:setPosition(frame:getAnchorPointInPoints())
  self.redmask:setVisible(false)
  local action = CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 64), CCFadeTo:create(0.2, 255)))
  self.redmask:runAction(action)
  return self
end
class.create = HeroPanelCreate
ed.HeroPanelCreate = HeroPanelCreate
local function setPortrait(self, res)
  local frame = ed.getSpriteFrame(res)
  if not frame then
    return
  end
  self.portrait.icon:initWithSpriteFrame(frame)
end
class.setPortrait = setPortrait
local setVisible = CCNode.setVisible
local setEnabled = CCMenuItem.setEnabled
local max = math.max
local min = math.min
local function update(self, dt)
  if self.ticks ~= ed.engine.ticks and not ed.engine.arena_mode and not ed.engine.replayMode then
    self.ticks = ed.engine.ticks
    local newState
    if self.unit.can_cast_manual and ed.engine.running then
      newState = "cast"
    end
    if self.unit.current_skill and self.unit.current_skill:canTrigger() then
      newState = "trigger"
    end
    if newState == "cast" and self.unit.mp < 1000 then
      newState = "switch"
    end
    setEnabled(self.btn, newState ~= nil)
    if self.state ~= newState then
      if newState == "cast" then
        self:play_skill_ready(self.fca_ready)
        ed.teach("useSkill", self.menu:getParent():convertToWorldSpace(ccp(self.menu:getPosition())), 40, ed.scene.ui_layer, ed.scene.ui_layer)
      elseif newState == "trigger" then
        self:play_skill_ready(self.fca_trigger)
      elseif newState == "switch" then
        self:play_skill_ready(self.fca_switch)
      else
        self:disable_cast()
        self.castSkillTutorialHandler = nil
        ed.breakTeach("useSkill")
      end
      self.state = newState
    end
    self.redmask:setVisible(self.unit.hp_low)
    if not self.unit:isAlive() then
      self.redmask:setVisible(false)
      self.portrait.ori_icon:setColor(ccc3(100, 100, 100))
    end
    if (newState == "cast" or newState == "switch") and ed.scene.auto_combat then
      self.skill_ready_timer = self.skill_ready_timer + ed.tick_interval
      if self.skill_ready_timer > 0.5 and self.unit.manual_skill:willCast() then
        self.castHandler()
        self.skill_ready_timer = 0
      end
    end
  end
  for _, field in ipairs({
    "skill_ready",
    "skill_cast_anim"
  }) do
    local anim = self[field]
    if anim then
      anim:update(dt)
      if anim:isTerminated() then
        anim:removeFromParentAndCleanup(true)
        self[field] = nil
      end
    end
  end
  self.hp_bar:update(dt)
  self.mp_bar:update(dt)
end
class.update = update
local function play_skill_ready(self, res)
  if self.skill_ready then
    self.skill_ready:removeFromParentAndCleanup(true)
  end
  local effect = ed.createFcaNode(res)
  self.btn:addChild(effect)
  --Ray 英雄技能就绪光圈位置
  effect:setPosition(ccp(36, 31))
  self.skill_ready = effect
  self.skill_ready_timer = 0
  if res == self.fca_ready then
    ed.playEffect(ed.sound.battle.cdOver)
    FireEvent("ult_skill_ready", self.unit)
  end
end
class.play_skill_ready = play_skill_ready
local function play_skill_cast_effect(self)
  self:disable_cast()
  if not self.skill_cast_anim then
    local effect = ed.createFcaNode(self.fca_cast)
    self.btn:addChild(effect)
    effect:setPosition(ccp(36, 31))
    self.skill_cast_anim = effect
  end
end
class.play_skill_cast_effect = play_skill_cast_effect
local disable_cast = function(self)
  if self.skill_ready then
    self.skill_ready:removeFromParentAndCleanup(true)
    self.skill_ready = nil
  end
  if self.skill_trigger_anim then
    self.skill_trigger_anim:removeFromParentAndCleanup(true)
    self.skill_trigger_anim = nil
  end
end
class.disable_cast = disable_cast

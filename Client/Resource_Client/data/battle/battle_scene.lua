require("ui/hp_bar")
require("ui/hero_panel")
require("battle/edp")
require("battle/battle_engine")
require("battle/popup")
require("battle/loot")
local ed = ed
local acts = require("util.cocos2dx.actions")
local Queue = require("util.queue")
local class = {}
ed.scene = class
--add by xinghui
class.speedState = {common =1, speed = 2}
local curSpeedState = class.speedState.common
class.curSpeedState = curSpeedState
--
local returnBtnTapHandler, nextBtnTapHandler, googlePlayTapHandler

local function getCurrentMode(self)
	if nil == self or self.battleModeInfo == nil then
		return "pve"
	end
	if self.battleModeInfo.replayInfo then
		return "replay"
	end
	if self.battleModeInfo.pvpInfo then
		return self.battleModeInfo.pvpInfo.pvpMode
	end
	if self.battleModeInfo.crusadeInfo then
		return "crusade"
	end
	if self.battleModeInfo.guildInstanceInfo then
		return "guildInstance"
	end
	if self.battleModeInfo.excavateInfo then
		return "excavate"
	end
	local stageInfo = ed.engine.stage_info
	local stageId = (stageInfo or {})["Stage ID"]
	if stageId and ed.stageType(stageId) == "act" then
		return "act"
	end
	return "pve"
end

local function reset(self, stage_info, battle_info, extraInfo)
	self.identity = "battle"
	self.actor_list = {}
	self.effect_list = {}
	self.ui_list = {}
	self.frames = 0
	self.auto_combat = false
	self.pause_locks = {}
	self.battleModeInfo = extraInfo
	self.node = CCScene:create()
	local bg = battle_info["Background Pic"]
	self.background = ed.createSprite("UI/alpha/HVGA/" .. bg)
	local flip = battle_info["H Flip"]
	if flip then
		self.background:setFlipX(true)
	end
	self.background_layer = CCLayer:create()
	self.main_layer = CCLayer:create()
	self.top_layer = CCLayer:create()
	self.ui_layer = CCLayer:create()
	self.background:setAnchorPoint(ed.ccpZero)
	self.background:setPosition(ed.ccpZero)
	self.background_layer:addChild(self.background)
	self.node:addChild(self.background_layer, 0)
	self.node:addChild(self.main_layer, 1)
	self.node:addChild(self.top_layer, 2)
	self.node:addChild(self.ui_layer, 3)
	self:resetUI(stage_info, battle_info)
	local chapter = stage_info["Chapter ID"]
	self.delayPlayMusicHandler = self:delayPlayMusic(ed.music["chapter" .. chapter])
	self.lastSync = nil
	self:syncActors()
	local viewCamp = ed.emCampPlayer
	if self.battleModeInfo and self.battleModeInfo.replayInfo and self.battleModeInfo.replayInfo.oppoUserid == ed.getUserid() then
		viewCamp = ed.emCampEnemy
	end
	for i, unit in ipairs(ed.engine.unit_list) do
		if unit.actor then
			unit:preload()
		end
		if unit.camp == viewCamp and unit:isHero() then
			self:addHeroPanel(unit)
		end
		if unit.hpLayer and 0 ~= unit.hpLayer then
			self:addBigBloodPanel(unit)
		end
	end
end
class.reset = reset

local pauseBattle = function(self, reason)
	self.pause_locks[reason] = true
end
class.pauseBattle = pauseBattle

local resumeBattle = function(self, reason)
	self.pause_locks[reason] = false
end
class.resumeBattle = resumeBattle

local function doPauseLayerTouch(self)
	local function handler(event, x, y)
		xpcall(function()
			if event == "began" then
				for k, v in pairs(self.pauseLayerButton) do
					if ed.containsPoint(self.pauseLayerButton[k], x, y) then
						self.pauseLayerButtonPress[k]:setVisible(true)
						self.isPressPauseButtonID = k
						break
					end
				end
			elseif event == "ended" then
				local k = self.isPressPauseButtonID
				self.isPressPauseButtonID = nil
				if k then
					self.pauseLayerButtonPress[k]:setVisible(false)
					if ed.containsPoint(self.pauseLayerButton[k], x, y) then
						self.pauseLayerButtonHandler[k]()
					end
				end
			end
		end, EDDebug)
		return true
	end
	return handler
end
class.doPauseLayerTouch = doPauseLayerTouch

local function createPauseLayer(self)
	if self.pauseLayer and not tolua.isnull(self.pauseLayer) then
		return
	end
	ed.scene:pauseBattle("pauseButton")
	ed.tutorial.clear()
	if self.nextwaveAction then
		ed.scene.node:stopAction(self.nextwaveAction)
	end
	ed.setMusicVolume(0.25)
	local pauseLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
	self.ui_layer:addChild(pauseLayer, 400)
	pauseLayer:registerScriptTouchHandler(self:doPauseLayerTouch(), false, -130, true)
	self.pauseLayer = pauseLayer
	local pauseContainer = CCLayer:create()
	pauseContainer:setAnchorPoint(ccp(0.5, 0.5))
	pauseLayer:addChild(pauseContainer)
	self.pauseContainer = pauseContainer
	self.pauseLayerButton = {}
	self.pauseLayerButtonPress = {}
	self.pauseLayerButtonHandler = {}
	self.pauseLayerButtonLabel = {}


	local exit = ed.createSprite("UI/alpha/HVGA/back2mapbtn.png")
	local exitPress = ed.createSprite("UI/alpha/HVGA/back2mapbtn-disabled.png")
	exit:setPosition(ccp(255, 265))
	pauseContainer:addChild(exit)
	exitPress:setAnchorPoint(ccp(0, 0))
	exitPress:setVisible(false)
	exit:addChild(exitPress)
	local key = "exit"
	self.pauseLayerButton[key] = exit
	self.pauseLayerButtonPress[key] = exitPress
	self.pauseLayerButtonHandler[key] = function()
		xpcall(function()
			ed.resetMusicVolume()
			ed.scene.exit()
		end, EDDebug)
	end
	local label = ed.createttf(T(LSTR("BATTLE_SCENE.QUIT_FIGHT")), 18)
	label:setPosition(ccp(255, 180))
	pauseContainer:addChild(label)
	self.pauseLayerButtonLabel[key] = label
	local sound = ed.createSprite("UI/alpha/HVGA/sound_on.png")
	local soundPress = ed.createSprite("UI/alpha/HVGA/sound_off.png")
	sound:setPosition(ccp(400, 265))
	soundPress:setPosition(ccp(400, 265))
	soundPress:setVisible(false)
	pauseContainer:addChild(sound)
	pauseContainer:addChild(soundPress)
	if not ed.getSoundSwitch() then
		local temp = soundPress
		soundPress = sound
		sound = temp
		sound:setVisible(true)
		soundPress:setVisible(false)
	end
	local key = "sound"
	self.pauseLayerButton[key] = sound
	self.pauseLayerButtonPress[key] = soundPress
	self.pauseLayerButtonHandler[key] = function()
		xpcall(function()
			ed.turnSoundSwitch()
			local key = "sound"
			local temp = self.pauseLayerButton[key]
			self.pauseLayerButton[key] = self.pauseLayerButtonPress[key]
			self.pauseLayerButtonPress[key] = temp
			self.pauseLayerButton[key]:setVisible(true)
			self.pauseLayerButtonPress[key]:setVisible(false)
			ed.setString(self.pauseLayerButtonLabel[key], ed.getSoundSwitch() and T(LSTR("BATTLE_SCENE.SOUND__ON")) or T(LSTR("BATTLE_SCENE.SOUND__OFF")))
			if not ed.getSoundSwitch then
				ed.stopAllEffects()
			end
		end, EDDebug)
	end
	local label = ed.createttf(ed.getSoundSwitch() and T(LSTR("BATTLE_SCENE.SOUND__ON")) or T(LSTR("BATTLE_SCENE.SOUND__OFF")), 18)
	label:setPosition(ccp(400, 180))
	self.pauseContainer:addChild(label)
	self.pauseLayerButtonLabel[key] = label
	local resume = ed.createSprite("UI/alpha/HVGA/resume_battle.png")
	local resumePress = ed.createSprite("UI/alpha/HVGA/resume_battle_press.png")
	resume:setPosition(ccp(545, 265))
	pauseContainer:addChild(resume)
	resumePress:setAnchorPoint(ccp(0, 0))
	resumePress:setVisible(false)
	resume:addChild(resumePress)
	local key = "resume"
	self.pauseLayerButton[key] = resume
	self.pauseLayerButtonPress[key] = resumePress
	self.pauseLayerButtonHandler[key] = function()
		xpcall(function()
			ed.resetMusicVolume()
			local s = CCScaleTo:create(0.2, 0)
			s = CCEaseBackIn:create(s)
			local func = CCCallFunc:create(function()
				xpcall(function()
					self:resumeBattle("pauseButton")
					self.pauseLayer:removeFromParentAndCleanup(true)
					self.pauseLayer = nil
					if self.nextwaveAction then
						ed.scene.node:runAction(self.nextwaveAction)
					end
				end, EDDebug)
			end)
			local sequence = CCSequence:createWithTwoActions(s, func)
			self.pauseContainer:runAction(sequence)
		end, EDDebug)
	end
	local label = ed.createttf(T(LSTR("BATTLE_SCENE.RESUME_FIGHT")), 18)
	label:setPosition(ccp(545, 180))
	pauseContainer:addChild(label)
	self.pauseLayerButtonLabel[key] = label
	pauseContainer:setScale(0)
	local s = CCScaleTo:create(0.2, 1)
	s = CCEaseBackOut:create(s)
	local func = CCCallFunc:create(function()
		xpcall(function()
			pauseLayer:setTouchEnabled(true)
		end, EDDebug)
	end)
	local sequence = CCSequence:createWithTwoActions(s, func)
	pauseContainer:runAction(sequence)
end
class.createPauseLayer = createPauseLayer

local function exit()
	--add by xinghui
	class.curSpeedState = class.speedState.common
	--
	if not ed.engine.stage_ended then
		ed.stopMusic()
		ed.playMusic(ed.music.map)
		ed.engine:exitStage(2, true)
	end
	ed.popScene()
end
class.exit = exit

local function returnBtnTapHandler()
	ed.playSound(ed.sound.battle.clickReturn)
	ed.scene:createPauseLayer()
end

-- google play button click event
local function googlePlayTapHandler()
	xpcall(function()
		LegendGoogleConnect(LegendSDKType)
	end, EDDebug)
end

ed.next_battle_walk_speeder = 1.75
local function nextBtnTapHandler()
	xpcall(function()
		ed.playEffect(ed.sound.battle.goNextBattle)
            --add by xinghui:send dot info when click next wave btn
            if --[[ed.tutorial.checkDone("nextWave")== false--]] ed.tutorial.isShowTutorial then
                ed.sendDotInfoToServer(ed.tutorialres.t_key["nextWave"].id)
            end
            --
		ed.endTeach("nextWave")
		ed.engine:battleSupply()
		ed.scene.next_btn:setEnabled(false)
		ed.scene.next_btn:runAction(CCFadeOut:create(0.1))
		local maxtime = 0
		for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
			if unit.actor then
				unit.actor:gotoNextBattle()
			end
			local distance = ed.engine.stage_rect.maxX - unit.position[1]
			local time = distance / (unit.info["Walk Speed"] * ed.next_battle_walk_speeder)
			if maxtime < time then
				maxtime = time
			end
		end
		local action = CCCallFunc:create(function()
			xpcall(function()
				ed.scene:nextBattle()
				if ed.scene.nextwaveAction then
					ed.scene.nextwaveAction:release()
					ed.scene.nextwaveAction = nil
				end
			end, EDDebug)
		end)
		action = CCSequence:createWithTwoActions(CCDelayTime:create(maxtime), action)
		ed.scene.nextwaveAction = action
		action:retain()
		ed.scene.node:runAction(action)
		ed.scene:autoCollectLoots()
	end, EDDebug)
end

local autoCollectLoots = function(self, delay)
	delay = delay or 0
	for _, v in ipairs(self.ui_list) do
		if v.what == "Loot" and not v.terminated then
			local action = CCCallFunc:create(function()
				v.btn:setEnabled(false)
				v:onAutoCollect()
			end)
			action = CCSequence:createWithTwoActions(CCDelayTime:create(delay), action)
			v.node:runAction(action)
			delay = delay + 0.16666666666666666
		end
	end
end
class.autoCollectLoots = autoCollectLoots

local function nextBattle(self)
	local auto = self.auto_combat
	local stage = ed.engine.stage_info
	local battle = ed.lookupDataTable("Battle", nil, stage["Stage ID"], ed.engine.wave_id + 1)
	ed.engine:nextBattle()
	self:reset(stage, battle, self.battleModeInfo)
	self.auto_combat = auto
	self.auto_btn:setSelectedIndex(auto and 1 or 0)
	ed.replaceScene(ed.scene)
end
class.nextBattle = nextBattle

local ccScene = function(self)
	return self.node
end
class.ccScene = ccScene

local addActor = function(self, actor)
	if actor.node then
		table.insert(self.actor_list, actor)
		self.main_layer:addChild(actor.node)
	end
end
class.addActor = addActor

local function addHeroPanel(self, unit)
	local panel = ed.HeroPanelCreate(unit, "green")
	unit.heroPanel = panel
	self.heroes_panel:addChild(panel.node)
	table.insert(self.ui_list, panel)
	for idx, p in ipairs(self.ui_list) do
		p.node:setPosition(ccp(panel.width * (#self.ui_list / 2 - idx + 3) + 10, 15))
	end
end
class.addHeroPanel = addHeroPanel

local function calculateBigHpLength(self)
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	local ox, oy = origin.x, -origin.y * 0.25
	local self = ed.scene
	local leftX = 84 + origin.x + 106
	local rightX = 587 - origin.x
	return rightX - leftX
end

local function addBigBloodPanel(self, unit)
	local panel = ed.BigHpBarCreate(unit, calculateBigHpLength(self))
	self.ui_layer:addChild(panel.node)
	panel.node:setPosition(ccp(375, 440))
	table.insert(self.ui_list, panel)
end
class.addBigBloodPanel = addBigBloodPanel

local removeBigBloodPanel = function(self, panel)
	for i = 1, #self.ui_list do
		local item = self.ui_list[i]
		if item == panel then
			table.remove(self.ui_list, i)
		end
	end
end
class.removeBigBloodPanel = removeBigBloodPanel

local function syncActors(self)
	if self.lastSync ~= ed.engine.ticks then
		self.lastSync = ed.engine.ticks
		for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
			if not unit.actor then
				unit.actor = ed.UnitActorCreate(unit)
				self:addActor(unit.actor)
			end
		end
		for npc in ed.engine:foreachNpc() do
			if not npc.actor then
				npc.actor = ed.NpcActorCreate(npc)
				npc:setAction(npc.bornActionName, true)
				self:addActor(npc.actor)
			end
		end
	end
end
class.syncActors = syncActors

local function createActorIcon(actor, size)
	local unit = actor.model
	local portraitFrame = ed.getSpriteFrame(unit.info.Portrait)
	local originSize = portraitFrame:getOriginalSize()
	local portrait = CCSprite:createWithSpriteFrame(portraitFrame)
	portrait:retain()
	portrait:setCascadeColorEnabled(true)
	portrait:setCascadeOpacityEnabled(true)
	portrait:setScaleX(size.width / originSize.width)
	portrait:setScaleY(size.height / originSize.height)
	local rank
	if unit.camp == ed.emCampPlayer then
		rank = unit.rank or 1
	elseif unit.camp == ed.emCampEnemy then
		rank = 1
	end
	local outlineFrame = ed.getSpriteFrame(ed.Hero.getIconFrameByRank(rank))
	outlineSize = outlineFrame:getOriginalSize()
	local outline = CCSprite:createWithSpriteFrame(outlineFrame)
	outline:setScaleX(originSize.width / outlineSize.width)
	outline:setScaleY(originSize.height / outlineSize.height)
	outline:setAnchorPoint(ccp(0, 0))
	outline:setPosition(ccp(0, 0))
	portrait:addChild(outline)
	return portrait
end

local function getKillingEffect(callback)
	local list = {}
	for i = 1, 8 do
		table.insert(list, string.format("UI/alpha/HVGA/killing/NO-%04i.png", i))
	end
	local spr, anim = ed.createFrameAnim(list)
	local action = CCSequence:createWithTwoActions(anim, CCCallFunc:create(function()
		spr:removeFromParentAndCleanup(true)
		if callback then
			callback()
		end
	end))
	spr:runAction(action)
	return spr
end

local function createTipIcon(killer, victim)
	local size = {width = 40, height = 40}
	local k = createActorIcon(killer, size)
	local v = createActorIcon(victim, size)
	local container = CCSprite:create()
	container:setCascadeColorEnabled(true)
	container:setCascadeOpacityEnabled(true)
	container:setAnchorPoint(ccp(0, 0))
	container:retain()
	container:addChild(k)
	k:release()
	k:setAnchorPoint(ccp(0, 0))
	k:setPosition(ccp(0, 0))
	container:addChild(v)
	v:release()
	v:setAnchorPoint(ccp(0, 0))
	v:setPosition(ccp(60, 0))
	tolua.setpeer(container, {})
	function container.playKillingEffect()
		local effect = getKillingEffect(function()
			local gray = CCShaderCache:sharedShaderCache():programForKey("GrayScalingShader")
			v:setShaderProgram(gray)
			v:getShaderProgram():use()
		end)
		local parent = container
		local effectSize = effect:getContentSize()
		effect:setScaleX(effectSize.width / size.width * 0.4)
		effect:setScaleY(effectSize.height / size.height * 0.5)
		parent:addChild(effect)
		effect:setPosition(ccp(72, 20))
		v:runAction(CCShake:create(0.25, 5, 1.5))
	end
	return container
end

local function showKillingInfo(self, killer, victim)
	local board = self.killing_board
	local k = createTipIcon(killer, victim)
	k:setOpacity(0)
	board:addChild(k)
	k:release()
	local queue = board.queue
	queue.pushRight(k)
	if queue.length() == 3 then
		do
			local removal = queue.popLeft()
			acts.stopTarget(removal)
			removal:runAction(acts.sequence({
				acts.spawn({
					CCFadeOut:create(0.15),
					CCMoveTo:create(0.5, ccp(0, 100))
				}),
				CCCallFunc:create(function()
					removal:removeFromParentAndCleanup(true)
				end)
			}))
		end
	end
	if queue.length() == 2 then
		k:setPosition(ccp(0, -20))
	end
	if queue.length() == 1 then
		k:setPosition(ccp(0, 25))
	end
	k:runAction(acts.sequence({
		acts.spawn({
			CCFadeIn:create(0.5),
			CCMoveBy:create(0.2, ccp(0, 20))
		}),
		CCDelayTime:create(2),
		CCFadeOut:create(1),
		CCCallFunc:create(function()
			k:removeFromParentAndCleanup(true)
			queue.popLeft()
		end)
	}))
	k:runAction(acts.sequence({
		CCDelayTime:create(0.5),
		CCCallFunc:create(function()
			k.playKillingEffect()
		end)
	}))
	function k.onPop(k)
		local last = queue.left()
		if last and not tolua.isnull(last) then
			last:runAction(CCMoveBy:create(0.2, ccp(0, 45)))
		end
	end
end
class.showKillingInfo = showKillingInfo

local addEffect = function(self, effect, z)
	table.insert(self.effect_list, effect)
	z = z or 0
	if z < 0 then
		self.background_layer:addChild(effect.node or effect)
	elseif z == 0 then
		self.main_layer:addChild(effect.node or effect)
	elseif z == 1 then
		self.top_layer:addChild(effect.node or effect)
	elseif z == 2 then
		self.ui_layer:addChild(effect.node or effect)
	end
end
class.addEffect = addEffect

local function delayPlayMusic(self, music)
	local function handler()
		if not ed.scene then
			return
		end
		if tolua.isnull(ed.scene.node) then
			return
		end
		if ed.scene.node:isRunning() then
			ed.playMusic(music)
			self.delayPlayMusicHandler = nil
		end
	end
	return handler
end
class.delayPlayMusic = delayPlayMusic

local sub = string.sub
local createNumbers = ed.createNumbers
local insert = table.insert
local pairs = pairs
local ipairs = ipairs
local function update(self, dt)
	--add by xinghui
	if class.curSpeedState == class.speedState.speed then
		dt = dt*2
	end
	--
	local paused = false
	for k, v in pairs(self.pause_locks) do
		paused = paused or v
	end
	if not paused then
		ed.engine:update(dt)
		self.frames = self.frames + 1
		self:syncActors()
		local new_list = {}
		for _, actor in ipairs(self.actor_list) do
			if not actor.model.terminated then
				if not actor.model.frozen_actor then
					actor:update(dt)
				end
				insert(new_list, actor)
			else
				actor.node:removeFromParentAndCleanup(true)
			end
		end
		self.actor_list = new_list
		local new_list = {}
		for _, effect in ipairs(self.effect_list) do
			if effect.update then
				effect:update(dt)
			end
			if effect:isTerminated() then
				local node = effect.node or effect
				node:removeFromParentAndCleanup(true)
			else
				insert(new_list, effect)
			end
		end
		self.effect_list = new_list
		if (self.auto_combat or self.battleModeInfo and self.battleModeInfo.guildInstanceInfo) and self.next_btn:isEnabled() then
			if not self.auto_next_timer then
				self.auto_next_timer = 1
			end
			self.auto_next_timer = self.auto_next_timer - dt
			if self.auto_next_timer <= 0 then
				nextBtnTapHandler()
			end
		end
	end
	if self.delayPlayMusicHandler then
		self.delayPlayMusicHandler()
	end
	local new_list = {}
	for _, ui in ipairs(self.ui_list) do
		ui:update(dt)
		if ui.terminated then
		else
			insert(new_list, ui)
		end
	end
	self.ui_list = new_list
	self:updateTimer()
end
class.update = update

local function onSceneFreezeBegin(self)
	self.background:setColor(ccc3(96, 96, 96))
	for _, effect in ipairs(self.effect_list) do
		effect:setActionSpeeder(0)
	end
end
class.onSceneFreezeBegin = onSceneFreezeBegin

local function onSceneFreezeEnd(self)
	self.background:setColor(ccc3(255, 255, 255))
	for _, effect in ipairs(self.effect_list) do
		effect:setActionSpeeder(1)
	end
end
class.onSceneFreezeEnd = onSceneFreezeEnd

local ccp = ccp
local deepProjectionX = ed.deepProjectionX
local deepProjectionY = ed.deepProjectionY
local function toViewPosition(logical_position, height)
	local x = logical_position[1]
	local y = logical_position[2]
	return ccp(x + y * deepProjectionX, 265 + height + y * deepProjectionY)
end
ed.toViewPosition = toViewPosition

local function playEffectOnScene(self, effect_name, origin, scale, height, zOrder)
	scale = scale or {1, 1}
	height = height or 0
	local node
	local vp = ed.toViewPosition(origin, height)
	effect_name = string.gsub(effect_name, "%.cha$", "")
	node = ed.createFcaNode(effect_name)
	node:setPosition(vp)
	node:setScaleX(node:getScaleX() * scale[1])
	node:setScaleY(node:getScaleY() * scale[2])
	node:setZOrder(-origin[2])
	self:addEffect(node, zOrder)
	return node
end
class.playEffectOnScene = playEffectOnScene

local function showMonsterLoots(self, wave_idx, monster, lost_hp_per, old_lost_hp_per)
	local monster_idx = monster.monster_idx
	local list
	if lost_hp_per then
		list = ed.player:getHpLootOfMonster(wave_idx, monster_idx, lost_hp_per, old_lost_hp_per)
	else
		list = ed.player:getStageLootOfMonster(wave_idx, monster_idx)
	end
	for i, v in ipairs(list) do
		local _type = v.type
		local _id = v.id
		local icon
		if _type == "equip" then
			icon = ed.lookupDataTable("equip", "Icon", _id)
		elseif _type == "hero" then
			icon = ed.lookupDataTable("Unit", "Portrait", _id)
		elseif _type == "book" then
			EDDebug("Skill books not supported")
		end
		local loot = ed.LootCreate(icon, _type, monster, i, _id)
		table.insert(self.ui_list, loot)
		self.ui_layer:addChild(loot.node)
	end
end
class.showMonsterLoots = showMonsterLoots

local removeBall = function(self, idx, force)
	if self.ballSlots[idx] and self.ballSlots[idx].status ~= 5 and self.ballSlots[idx].status ~= 6 then
		self.ballSlots[idx].terminated = true
		self.ballSlots[idx].node:setVisible(false)
		self.ballSlots[idx] = nil
		return true
	end
	return false
end
class.removeBall = removeBall

local function removeAllBall(self)
	for k, v in pairs(self.ballSlots) do
		local picknode = ed.createFcaNode("eff_UI_Kael_pickball_" .. v.ballType)
		picknode:setPosition(v.node:getPosition())
		ed.scene:addEffect(picknode, 2)
		v.node:setVisible(false)
	end
	for idx, p in ipairs(self.ui_list) do
		if p.ball_bar then
			p.ball_bar:removeBall()
		end
	end
end
class.removeAllBall = removeAllBall

local function addLootMarker(self, num)
	num = num or 1
	local value
	if ed.engine and ed.engine.loot_count then
		ed.engine.loot_count = ed.engine.loot_count + num
		value = ed.engine.loot_count
	else
		value = 0
	end
	local width = createNumbers(self.lootmarker_text, "" .. value)
	self.lootmarker_text:setContentSize(CCSizeMake(width, 0))
	self.lootmarker_text:setAnchorPoint(ccp(0.5, 0.5))
	self.lootmarker_text:setPosition(25, 22)
	if num > 0 then
		do
			local duration = 0.3
			local holo = ed.createSprite("UI/alpha/HVGA/holo.png")
			self.lootmarker:addChild(holo, -1)
			holo:setPosition(ccp(24, 24))
			holo:setScale(0.4)
			local beat = CCScaleTo:create(duration, 1.2)
			holo:setOpacity(255)
			local blink = CCFadeTo:create(duration, 0)
			local action = CCSpawn:create(ccArrayMake(beat, blink))
			action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
				holo:removeFromParentAndCleanup(true)
			end))
			holo:runAction(action)
		end
	end
end
class.addLootMarker = addLootMarker

local function addGold(self, num)
	local value
	if ed.engine and ed.engine.gold_count then
		ed.engine.gold_count = ed.engine.gold_count + num
		value = ed.engine.gold_count
	else
		value = 0
	end
	local str = ed.formatNumWithComma(value)
	local width = createNumbers(self.goldmarker_text, str, -3)
	self.goldmarker_text:setContentSize(CCSizeMake(width, 0))
	self.goldmarker_text:setAnchorPoint(ccp(0.5, 0.5))
	self.goldmarker_text:setPosition(33, 22)
	if num > 0 then
		local duration = 0.1
		local node = self.goldmarker_text
		node:setOpacity(255)
		node:setScale(1.25)
		node:runAction(CCSpawn:create(ccArrayMake({
			CCFadeTo:create(duration, 255),
			CCScaleTo:create(duration, 1)
		})))
	end
end
class.addGold = addGold

local function autoCombatHandler()
	if ed.scene.battleModeInfo.pvpInfo and ed.scene.battleModeInfo.pvpInfo.pvpMode then
		ed.playEffect(ed.sound.deo.common_alert)
		ed.showToast(T(LSTR("BATTLE_SCENE.ONLY_ALLOW_AUTOFIGHT_IN_ARENA")), ccp(600, 130))
	else
		ed.scene.auto_combat = not ed.scene.auto_combat
		if ed.scene.auto_combat then
			ed.playEffect(ed.sound.battle.enableAuto)
		else
			ed.playEffect(ed.sound.battle.disenableAuto)
		end
		ed.endTeach("autoBattle")
	end
end
--add by xinghui
local function speedBtnHandler()
	--todo:加速
	if class.curSpeedState == class.speedState.common then
		class.curSpeedState = class.speedState.speed				
		local picSprame = ed.createSprite("UI/alpha/HVGA/CombatAcceleration_2.png")
		class.speedBtn:setNormalImage(picSprame)		
	else
		class.curSpeedState = class.speedState.common	
		local picSprame = ed.createSprite("UI/alpha/HVGA/CombatAcceleration_1.png")
		class.speedBtn:setNormalImage(picSprame)
	end		
end
local function speedUnableBtnHandler()
	--todo:弹出提示框
	ed.showToast(T(LSTR("BATTLE.BATTLESPEED.CHARGEFORVIP")))
end
--

local function skipHandler()
	if ed.debug_mode then
		ed.engine:victory(true)
	end
end

local function skip5v5()
	ed.skip5v5();
end

local function createButtonWithMask(image, mask)
	local normal = ed.createSprite(image)
	local selected = ed.createSprite(image)
	local size = selected:getContentSize()
	local mask = ed.createSprite(mask)
	mask:setPosition(ccp(size.width * 0.5, size.height * 0.5))
	selected:addChild(mask, 1)
	local btn = CCMenuItemSprite:create(normal, selected)
	return btn
end

local function createReplayUI(self)
	if not self.battleModeInfo.replayInfo then
		return
	end
	local info = self.battleModeInfo.replayInfo
	local positionConfig = {
		ccp(50, 360),
		ccp(550, 360)
	}
	local attack = {}
	local uiRes = {
		{
			t = "Sprite",
			base = {name = "ui"},
			layout = {
				position = ccp(40, 360)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {name = "iconParent", parent = "ui"},
			layout = {
				position = ccp(60, 80)
			},
			config = {scale = 0.7}
		},
		{
			t = "Sprite",
			base = {
				name = "namebg",
				res = "UI/alpha/HVGA/pvp/pvp_replay_name_bg.png",
				parent = "ui"
			},
			layout = {
				anchor = ccp(0, 0.5),
				position = ccp(80, 80)
			},
			config = {}
		},
		{
			t = "Label",
			base = {
				name = "name",
				text = "",
				size = 20,
				parent = "ui"
			},
			layout = {
				anchor = ccp(0, 0.5),
				position = ccp(90, 80)
			},
			config = {
				color = ccc3(255, 255, 255),
				shadow = {
					color = ccc3(42, 31, 22),
					offset = ccp(0, 2)
				}
			}
		}
	}
	local readNode = ed.readnode.create(self.ui_layer, attack)
	readNode:addNode(uiRes)
	attack.ui:setPosition(positionConfig[1])
	ed.setString(attack.name, info.userName)
	if attack.name:getContentSize().width > 160 then
		attack.name:setScale(160 / attack.name:getContentSize().width)
	end
	local head = ed.getHeroIconByID({
		id = info.userAvatar,
		vip = 0 < info.vip
	})
	if head then
		attack.iconParent:addChild(head)
	end
	local enemy = {}
	readNode = ed.readnode.create(self.ui_layer, enemy)
	readNode:addNode(uiRes)
	enemy.ui:setPosition(positionConfig[2])
	ed.setString(enemy.name, info.oppoUserName)
	if enemy.name:getContentSize().width > 160 then
		enemy.name:setScale(160 / enemy.name:getContentSize().width)
	end
	local head = ed.getHeroIconByID({
		id = info.oppoUserAvatar,
		vip = 0 < info.oppovip
	})
	if head then
		enemy.iconParent:addChild(head)
	end
	local title = ed.createSprite("UI/alpha/HVGA/pvp/pvp_replay_title.png")
	title:setPosition(400, 440)
	self.ui_layer:addChild(title)
end

local function resetUI(self, stage_info, battle_info)
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	local ox, oy = origin.x, -origin.y * 0.25
	local header_y = 440 + oy
	local return_btn = createButtonWithMask("UI/alpha/HVGA/pausebtn.png", "UI/alpha/HVGA/pausebtn-disabled.png")
	self.return_btn = return_btn
	return_btn:setPosition(ccp(757 - ox, header_y))
	return_btn:setVisible(true)
	return_btn:registerScriptTapHandler(returnBtnTapHandler)
	local currentMode = getCurrentMode(self)
	if currentMode == "attack" or --[[currentMode == "crusade" or--]] currentMode == "guildInstance" or currentMode == "excavate" then
		return_btn:setVisible(false)
		return_btn:setEnabled(false)
	end
	local next_btn = createButtonWithMask("UI/alpha/HVGA/nextbtn.png", "UI/alpha/HVGA/nextbtn.png")
	self.next_btn = next_btn
	local nextScale = 1.25
	next_btn:setScale(nextScale)
	next_btn:setPosition(ccp(670, 260))
	next_btn:setVisible(false)
	next_btn:setEnabled(false)
	next_btn:setTouchingArea(CCRectMake(-30 * nextScale, -30 * nextScale, 120 * nextScale, 120 * nextScale))
	next_btn:registerScriptTapHandler(nextBtnTapHandler)
	local auto_btn
	if self.battleModeInfo and self.battleModeInfo.pvpInfo then
		auto_btn = CCMenuItemImage:create("UI/alpha/HVGA/autocombat_on.png", "UI/alpha/HVGA/autocombat_on.png")
		if "attack" == currentMode then
			local lock = ed.createSprite("UI/alpha/HVGA/pvp/pvp_battle_lock.png")
			lock:setAnchorPoint(ccp(0, 0.5))
			local size = auto_btn:getContentSize()
			lock:setPosition(ccp(0, size.height))
			auto_btn:addChild(lock)
		end
	else
		local auto_off = CCMenuItemImage:create("UI/alpha/HVGA/autocombat_on.png", "UI/alpha/HVGA/autocombat_off.png")
		local auto_on = CCMenuItemImage:create("UI/alpha/HVGA/autocombat_off.png", "UI/alpha/HVGA/autocombat_on.png")
		auto_btn = CCMenuItemToggle:create(auto_on)
		auto_btn:addSubItem(auto_off)
		if currentMode == "pve" then
			local stars = ed.player:getStageStar(stage_info["Stage ID"])
			if stars < 3 then
				auto_btn:setVisible(false)
				auto_btn:setEnabled(false)
			else
				ed.teach("autoBattle", auto_btn, self.ui_layer)
			end
		elseif currentMode == "act" then
		end
	end
	--add by xinghui
	local stars = ed.player:getStageStar(stage_info["Stage ID"])
    local speedBtn = nil
    local speedUnableBtn = nil
	if stars == 3 then
		--todo:显示加速按钮
		local vipLevel = ed.player:getvip()
		if vipLevel > 0 then
			--todo:加速按钮可用
            if class.curSpeedState == class.speedState.common then
			    speedBtn = CCMenuItemImage:create("UI/alpha/HVGA/CombatAcceleration_1.png", "UI/alpha/HVGA/CombatAcceleration_1.png")
            elseif class.curSpeedState ==  class.speedState.speed then
			    speedBtn = CCMenuItemImage:create("UI/alpha/HVGA/CombatAcceleration_2.png", "UI/alpha/HVGA/CombatAcceleration_2.png")
            end
		else
			--todo:加速按钮不可用
			speedUnableBtn = CCMenuItemImage:create("UI/alpha/HVGA/CombatAcceleration_0.png", "UI/alpha/HVGA/CombatAcceleration_0.png")
		end
	end
	if speedBtn then
		class.speedBtn = speedBtn
		speedBtn:setPosition(ccp(735, 120))
		speedBtn:registerScriptTapHandler(speedBtnHandler)
		speedBtn:setVisible(true)
	end
	if speedUnableBtn then
		class.speedUnableBtn = speedUnableBtn
		speedUnableBtn:setPosition(ccp(735, 120))
		speedUnableBtn:registerScriptTapHandler(speedUnableBtnHandler)
		speedUnableBtn:setVisible(true)
	end
	--
	self.auto_btn = auto_btn
	auto_btn:setPosition(ccp(734, 60))
	auto_btn:registerScriptTapHandler(autoCombatHandler)
	if currentMode == "replay" then
		auto_btn:setVisible(false)
	end

	-- android google play sign-in button
	local google_play_btn = createButtonWithMask("UI/alpha/HVGA/connect/gs-1.png", "UI/alpha/HVGA/connect/gs-2.png")

	self.google_play_btn = google_play_btn
	local googlePlayScale = 0.8
	google_play_btn:setScale(googlePlayScale)
	google_play_btn:setPosition(ccp(ox + 70, header_y))
	google_play_btn:setVisible(false)
	google_play_btn:setEnabled(true)
	google_play_btn:setTouchingArea(CCRectMake(-30 * googlePlayScale, -30 * googlePlayScale, 120 * googlePlayScale, 120 * googlePlayScale))
	google_play_btn:registerScriptTapHandler(googlePlayTapHandler)


	local menu = CCMenu:createWithArray(ccArrayMake(return_btn, next_btn, auto_btn, google_play_btn))
	--add by xinghui
	if speedBtn then
		menu:addChild(speedBtn)
	elseif speedUnableBtn then
		menu:addChild(speedUnableBtn)
	end
	--
	menu:setPosition(ed.ccpZero)
	-- 隐藏背景 2014.9.12  liujun
	--local heroes_panel = ed.createSprite("UI/alpha/HVGA/battle_heroes_panel.png")
	local heroes_panel = CCSprite:create()
	self.heroes_panel = heroes_panel
	heroes_panel:setPosition(ccp(70, 5))
	--heroes_panel:setAnchorPoint(ccp(0.5, 0))
	self.ui_layer:addChild(heroes_panel)

	local wave_id = battle_info["Wave ID"]
	if wave_id and (currentMode == "pve" or currentMode == "act" or currentMode == "guildInstance") then
		local wave_mark = CCSprite:create()
		self.wave_mark = wave_mark
		self.ui_layer:addChild(wave_mark)
		wave_mark:setAnchorPoint(ccp(0, 0))
		wave_mark:setPosition(ccp(380, 440))
		createNumbers(wave_mark, wave_id .. "/3")
	end
	local killing_board = CCNode:create()
	self.killing_board = killing_board
	tolua.setpeer(killing_board, {})
	self.ui_layer:addChild(killing_board)
	killing_board:setPosition(675, 320)
	killing_board.queue = Queue.create()
	if "replay" == currentMode then
		self.timer = nil
		createReplayUI(self)
	else
		if currentMode == "pve" or currentMode == "guildInstance" or currentMode == "act" then
			local goldmarker = ed.createScale9Sprite("UI/alpha/HVGA/battle_number_bg.png")
			self.goldmarker = goldmarker
			self.ui_layer:addChild(goldmarker)
			goldmarker:setAnchorPoint(ccp(1, 0.5))
			goldmarker:setPosition(ccp(110 + ox, header_y))
			goldmarker:setContentSize(CCSizeMake(100, 44))
			local icon = ed.createSprite("UI/alpha/HVGA/goldicon_small.png")
			icon:setAnchorPoint(ccp(1, 0.5))
			local size = goldmarker:getContentSize()
			icon:setPosition(size.width - 4, size.height * 0.5)
			goldmarker:addChild(icon)
			local text = CCSprite:create()
			self.goldmarker_text = text
			text:setCascadeOpacityEnabled(true)
			goldmarker:addChild(text)
			self:addGold(0)
			local lootmarker = ed.createScale9Sprite("UI/alpha/HVGA/battle_number_bg.png")
			self.lootmarker = lootmarker
			self.ui_layer:addChild(lootmarker)
			lootmarker:setAnchorPoint(ccp(1, 0.5))
			lootmarker:setPosition(ccp(210 + ox, header_y))
			lootmarker:setContentSize(CCSizeMake(85, 44))
			local icon = ed.createSprite("UI/alpha/HVGA/chest_small.png")
			icon:setAnchorPoint(ccp(1, 0.5))
			local size = lootmarker:getContentSize()
			icon:setPosition(size.width - 4, size.height * 0.5)
			lootmarker:addChild(icon)
			local text = CCNode:create()
			self.lootmarker_text = text
			lootmarker:addChild(text)
			self:addLootMarker(0)
		end
		local timer = {
			bg = ed.createScale9Sprite("UI/alpha/HVGA/battle_number_bg.png"),
			mask = ed.createScale9Sprite("UI/alpha/HVGA/timermask.png"),
			hourglass = CCMenuItemImage:create("UI/alpha/HVGA/hourglass.png", "UI/alpha/HVGA/hourglass.png"),
			skipbtn = CCMenuItemImage:create("UI/alpha/HVGA/battle_skip.png", "UI/alpha/HVGA/battle_skip.png"),
			text = CCSprite:create(),
			value = -1
		}
		self.timer = timer
		timer.bg:setAnchorPoint(ccp(0, 0.5))
		timer.bg:setPosition(ccp(610 - ox, header_y))
		timer.bg:setContentSize(CCSizeMake(106, 44))
		self.ui_layer:addChild(timer.bg)
		timer.mask:setAnchorPoint(ccp(0, 0))
		timer.mask:setPosition(ccp(0, 0))
		timer.mask:setContentSize(CCSizeMake(106, 44))
		timer.bg:addChild(timer.mask)
		local action = CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 128), CCFadeTo:create(0.2, 255))
		action = CCRepeatForever:create(action)
		timer.mask:runAction(action)
		timer.mask:setVisible(false)
		timer.hourglass:setAnchorPoint(ccp(0, 0.5))
		timer.hourglass:setPosition(ccp(677 - ox, header_y-3))
		
		timer.skipbtn:setAnchorPoint(ccp(0,0.5));
		timer.skipbtn:setPosition(ccp(637 - ox, header_y));
		timer.skipbtn:setContentSize(CCSizeMake(106,44));
		if ed.tutorial.isFinishTutorial then
			menu:addChild(timer.hourglass)
			timer.hourglass:setVisible(true);
			timer.text:setVisible(true);
			timer.bg:setVisible(true);
		else
			menu:addChild(timer.skipbtn);
			timer.hourglass:setVisible(false);
			timer.text:setVisible(false);
			timer.bg:setVisible(false);
			local skipTxt = ed.createLabelTTF(LSTR("5V5_TUTORIAL.SKIP"),20)
			skipTxt:setAnchorPoint(ccp(0.5,0.5))
			skipTxt:setPosition(ccp(677 - ox, header_y))
			self.ui_layer:addChild(skipTxt,2000);
			timer.skipbtn:registerScriptTapHandler(skip5v5)
		end    
		timer.text:setPosition(ccp(12, 22))
		timer.text:setCascadeColorEnabled(true)
		timer.bg:addChild(timer.text)
	end
	self.ui_layer:addChild(menu)
end
class.resetUI = resetUI

local function showNextButton(self)
	ed.teach("nextWave", self.next_btn, self.ui_layer)
	local btn = self.next_btn
	btn:setVisible(true)
	btn:setEnabled(true)
	local action = CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(30, 0)), CCMoveBy:create(0.65, ccp(-30, 0)))
	action = CCRepeatForever:create(action)
	btn:runAction(action)
end
class.showNextButton = showNextButton

local function updateTimer(self)
	if not self.timer then
		return
	end
	local seconds = math.ceil(ed.engine.time_limit)
	if seconds ~= self.timer.value then
		self.timer.value = seconds
		local node = self.timer.text
		local str = string.format("%02i:%02i", seconds / 60, seconds % 60)
		local length = createNumbers(node, str, -3)
		if seconds < 20 then
			self.timer.mask:setVisible(true)
			node:setColor(ccc3(255, 144, 144))
			node:runAction(CCTintTo:create(1, 255, 210, 210))
		end
	end
	if not ed.engine.running then
		self.timer.mask:setVisible(false)
		self.timer.text:setColor(ccc3(255, 255, 255))
	end
end
class.updateTimer = updateTimer

local function addTimeOutUI(self)
	local node = ed.createSprite("UI/alpha/HVGA/battletext/battletext_timeover.png")
	node:setScale(0)
	local action = CCScaleTo:create(0.2, 1)
	action = CCEaseExponentialOut:create(action)
	node:setPosition(ccp(400, 300))
	self.ui_layer:addChild(node)
	node:runAction(action)
end
class.addTimeOutUI = addTimeOutUI

local startCameraShakeAnimationY = function(self, maxShakeHeight, shakeTime, shakeNum)
	if nil ~= CCDirector:sharedDirector().startCameraAnimationY then
		CCDirector:sharedDirector():startCameraAnimationY(maxShakeHeight, shakeTime, shakeNum)
	end
end
class.startCameraShakeAnimationY = startCameraShakeAnimationY

local stopCameraShakeAnimationY = function(self)
	if nil ~= CCDirector:sharedDirector().stopCameraAnimationY then
		CCDirector:sharedDirector():stopCameraAnimationY()
	end
end
class.stopCameraShakeAnimationY = stopCameraShakeAnimationY

local startCameraShakeAnimationX = function(self, maxShakeHeight, shakeTime, shakeNum)
	if nil ~= CCDirector:sharedDirector().startCameraAnimationX then
		CCDirector:sharedDirector():startCameraAnimationX(maxShakeHeight, shakeTime, shakeNum)
	end
end
class.startCameraShakeAnimationX = startCameraShakeAnimationX

local stopCameraShakeAnimationX = function(self)
	if nil ~= CCDirector:sharedDirector().stopCameraAnimationX then
		CCDirector:sharedDirector():stopCameraAnimationX()
	end
end
class.stopCameraShakeAnimationX = stopCameraShakeAnimationX

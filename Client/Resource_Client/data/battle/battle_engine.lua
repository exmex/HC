do_battle_log = EDFLAGWIN32 or EDFLAGSVR
local print_battle_log = false
require("battle/puppet")
require("battle/entity")
require("battle/ai")
require("battle/skill")
require("battle/buff")
require("battle/unit")
require("battle/effect")
require("battle/chain")
require("battle/projectile")
require("battle/npc")
require("battle/stage")
require("battle/energyball")
require("battle/ball")
local table = table
local ipairs = ipairs
local ed = ed
ed.tick_interval = 0.125
local class = {
	mt = {}
}
ed.engine = class
setmetatable(class, class.mt)
function class.mt:__tostring()
	local s = "---------------------------------------\n"
	s = s .. string.format("tick %d\n", self.ticks or 0)
	if self.unit_list then
		for i = 1, #self.unit_list do
			s = s .. tostring(self.unit_list[i])
		end
	end
	return s
end
local logbuffer
function btlog(...)
	local s = string.format(...)
	if print_battle_log then
		print(s)
	end
	if logbuffer then
		logbuffer:append(s)
		logbuffer:append("\n")
	end
end
local ballbuffer = ed.StringBufferCreate()
function klog(...)
	local s = string.format(...)
	if ballbuffer then
		ballbuffer:append(s)
		ballbuffer:append("\n")
	end
end
ed.klog = klog
function getBtlog()
	return tostring(logbuffer)
end

local function resetStage(self)
	if ed.player then
		ed.player.loots = {}
		ed.player.hpLoots = {}
	end
	self.enabled = true
	self.stage_ended = false
	self.stage_info = nil
	self.arena_mode = nil
	self.crusade_mode = nil
	self.excavate_mode = nil
	self.replayMode = nil
	self.guildInstance_mode = nil
	self.gmMode = nil
	self.stage_rect = {
		minX = 0,
		maxX = 800,
		minY = -120,
		maxY = 120
	}
	self.ticks = 0
	self.tick_interval = ed.tick_interval
	self.operation_list = {}
	self.next_operation_index = 1
	self.unit_list = {}
	self:resetBattle()
	self.hero_id_list = {}
	self.loot_count = 0
	self.gold_count = 0
	self.death_count = 0
	if ed.debug_mode then
		do_battle_log = true
	elseif ed.run_with_scene then
		math.randomseed(os.time())
		local num = math.random(1000)
		if num <= 10 then
			do_battle_log = true
		else
			do_battle_log = false
		end
	end
	self.battleLog = nil
	if do_battle_log then
		logbuffer = ed.StringBufferCreate()
	end
	self.origin_enemy_team = nil
	self.excavate_type_id = nil
	self.deliveredBallSlots = {}
	self.usedDeliveredBallSlots = {}
end
class.resetStage = resetStage

local function resetBattle(self)
	self.next_tick = 0
	if self.guildInstance_mode == true then
		self.time_limit = self.time_limit or 90
	else
		self.time_limit = 90
	end
	self.projectile_list = {}
	self.npc_list = {}
	self.alive_alliance_count = 0
	self.alive_enemy_count = 0
	self.dead_alliance_count = 0
	self.dead_enemy_count = 0
	self.freeze_level = 0
	self.supplied = false
	self.running = true
	local old = self.unit_list
	self.unit_list = {}
	self.alive_units = {
		[ed.emCampPlayer] = {},
		[ed.emCampEnemy] = {},
		[ed.emCampBoth] = {}
	}
	if old then
		for _, unit in ipairs(old) do
			if unit.camp == ed.emCampPlayer then
				self:addUnit(unit)
			end
		end
	end
end
class.resetBattle = resetBattle

local initial_position = {
	{0, 0},
	{-80, -40},
	{-160, 0},
	{-240, -40},
	{-320, 0}
}
local function setUpConfigEstimateInfo(config, tid, is_bot)
	if ed.enableMaxAttStrategy then
		local uinfo = ed.getDataTable("Unit")[tid]
		if uinfo["Unit Type"] == "Monster" then
			config.estimate_rank = is_bot
			config.estimate_skill = is_bot
			config.estimate_max_rank = false
		else
			config.estimate_rank = false
			config.estimate_skill = false
			config.estimate_max_rank = true
		end
	else
		config.estimate_rank = is_bot
		config.estimate_skill = is_bot
		config.estimate_max_rank = false
	end
end
local function resetUnitList(self)
	for i, unit in ipairs(self.unit_list) do
		unit:reset()
	end
end
local function setupBattle(self, battle, hp_info)
	self:resetBattle()
	self.wave_id = battle["Wave ID"]
	local battle_info = battle
	local modify = function(old, modifier, default)
		default = default or 100
		modifier = modifier or default
		if modifier == 0 then
			modifier = default
		end
		return old * modifier / 100
	end
	local boss_idx = battle_info["Boss Position"]
	local monsterPosIndex = 0
	self.monsterNum = 0
	for i = 1, 5 do
		local id = battle_info["Monster " .. i .. " ID"]
		if id and id > 0 then
			self.monsterNum = self.monsterNum + 1
			if not hp_info or hp_info[i]._hp_perc ~= 0 then
				local level = battle_info["Level " .. i]
				if not level then
					EDDebug("Monster level missing")
				end
				local stars = battle_info["Stars " .. i] or 1
				--local rank = ed.lookupDataTable("Levels", "Rank", level) + ed.lookupDataTable("Levels", "A", level)
				local config = {
					is_monster = true,
					is_boss = false,
					hp_mod = modify(1, battle_info["Monster HP%"]),
					dps_mod = modify(1, battle_info["Monster DPS%"]),
					size_mod = 1,
					money = battle_info["Money Reward " .. i],
					estimate_rank = true,
					estimate_skill = true,
					estimate_max_rank = false
				}
				if i == boss_idx then
					config.is_boss = true
					config.hp_mod = modify(config.hp_mod, battle_info["Boss HP%"])
					config.dps_mod = modify(config.dps_mod, battle_info["Boss DPS%"])
					config.size_mod = modify(config.size_mod, battle_info["BOSS SIZE%"], 120)
				end
				local slevel = level
				local proto = {
					_tid = id,
					_level = level,
					_stars = stars
				}
				local monster = ed.UnitCreate(proto, ed.emCampEnemy, config, hp_info and hp_info[i] or nil)
				local mp = battle_info["MP " .. i]
				monster.mp = mp or 0
				if monster.hp and monster.hp ~= 0 then
					monsterPosIndex = monsterPosIndex + 1
				end
				local position = initial_position[monsterPosIndex]
				position = {
					ed.engine.stage_rect.maxX - position[1],
					position[2]
				}
				monster.position = position
				self:addUnit(monster)
				monster.monster_idx = i
			end
		end
	end
	for i, hero in ipairs(self.alive_units[ed.emCampPlayer]) do
		hero.position = {
			initial_position[i][1],
			initial_position[i][2]
		}
	end
	resetUnitList(self)
	local script = ed.getStageScript(self.stage_info["Stage ID"], self.wave_id)
	if script then
		script(self)
	end
	if ed.run_with_scene then
		ListenTimer(Timer:Once(2.5), function()
			FireEvent("EnterBattleStage", self.stage_info["Stage ID"], self.wave_id)
		end)
	end
end
class.setupBattle = setupBattle

local pveMode = function(self)
	if self.arena_mode then
		return false
	end
	if self.crusade_mode then
		return false
	end
	if self.guildInstance_mode then
		return false
	end
	if self.excavate_mode then
		return false
	end
	return true
end

local function sortHeroList(list)
	local function range(hero)
		local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hero._tid)
		return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
	end
	class.getAutoAttackRange = getAutoAttackRange
	table.sort(list, function(a, b)
		return range(a) < range(b)
	end)
end

local function sortUnitList(list)
	local function range(unit)
		local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", unit.tid)
		return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
	end
	table.sort(list, function(a, b)
		return range(a) < range(b)
	end)
end

local function combineBaseDyna(base, dyna)
	local data = {}
	for i, v in ipairs(base) do
		data[i] = {
			base = v,
			dyna = dyna[i]
		}
	end
	return data
end
local function initUnitMercenaryData(unit, hero)
	if nil == unit or nil == hero then
		return
	end
	if ed.run_with_scene and hero.getMercenaryData then
		unit:setMercenaryData(hero:getMercenaryData())
	end
end

local function initSelfHero(self, hero_list, isbot)
	if nil == hero_list then
		return
	end
	self.hero_list = hero_list
	sortHeroList(hero_list)
	for i = 1, #hero_list do
		local proto = hero_list[i]
		local hero
		if ed.enableMaxAttStrategy then
			hero = ed.UnitCreate(proto, ed.emCampPlayer, {
				estimate_rank = false,
				estimate_skill = false,
				estimate_max_rank = ed.enableMaxAttStrategy
			})
		else
			hero = ed.UnitCreate(proto, ed.emCampPlayer, {
				estimate_rank = isbot,
				estimate_skill = isbot,
				estimate_max_rank = ed.enableMaxAttStrategy
			})
		end
		initUnitMercenaryData(hero, proto)
		hero.ai.will_cast_manual_skill = isbot
		table.insert(self.unit_list, hero)
		table.insert(self.hero_id_list, proto._tid)
	end
end

local function enterStage(self, stage_info, hero_list, isbot, startWaveId)
	self:resetStage()
	self.stage_info = stage_info
	initSelfHero(self, hero_list, isbot)
	startWaveId = startWaveId or 1
	local battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], startWaveId)
	self:setupBattle(battle)
	self.mp_bonus = self.stage_info["MP Bonus"]
end
class.enterStage = enterStage

local function getEnemyHpInfo(self)
	local enemyHpInfo = {}
	local donePercent = 0
	for i, unit in ipairs(self.unit_list) do
		if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
			local percernt = math.ceil(unit.hp / unit.attribs.HP * 10000)
			enemyHpInfo[unit.monster_idx] = percernt
			donePercent = donePercent + percernt
		end
	end
	for i = 1, 5 do
		if enemyHpInfo[i] == nil then
			enemyHpInfo[i] = 0
		end
	end
	return enemyHpInfo, donePercent
end
class.getEnemyHpInfo = getEnemyHpInfo

local function getStageProgress(self)
	local maxPercent = 10000
	local donePercent = 0
	local totalPercent = 0
	local totalWaves = self.stage_info.Waves
	for i = 1, totalWaves do
		local battle = ed.lookupDataTable("Battle", nil, self.stage_info["Stage ID"], i)
		local weight = battle["Raid Wave Weight"] or 0
		totalPercent = totalPercent + weight
		if i < self.wave_id then
			donePercent = donePercent + weight
		elseif self.wave_id == i then
			local hpInfo, percent = getEnemyHpInfo(self)
			local totalPercent = self.monsterNum * maxPercent
			donePercent = donePercent + (totalPercent - percent) / totalPercent * weight
		end
	end
	return math.floor(donePercent / totalPercent * maxPercent)
end

local function enterGuildInstance(self, stage_info, hero_list, guildInstanceInfo, isbot)
	if guildInstanceInfo == nil then
		return
	end
	self:resetStage()
	self.stage_info = stage_info
	self.mp_bonus = 1
	self.raid_id = guildInstanceInfo._raid_id
	self.guildInstance_mode = true
	initSelfHero(self, hero_list, isbot)
	local battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], guildInstanceInfo._wave_index)
	local hpData
	if guildInstanceInfo._hp_info then
		hpData = {}
		for i, v in ipairs(guildInstanceInfo._hp_info) do
			local hpInfo = {}
			hpInfo._hp_perc = v
			table.insert(hpData, hpInfo)
		end
	end
	self:setupBattle(battle, hpData)
end
class.enterGuildInstance = enterGuildInstance

local function initUnitList(self, isSelf, hero_list, hero_is_bot, hero_dyna, manual_skill)
	local unitlist = {}
	for i = 1, #hero_list do
		local isAlive = true
		if hero_dyna and hero_dyna[i]._hp_perc <= 0 then
			isAlive = false
		end
		if isAlive then
			local proto = hero_list[i]
			local config = {
				hp_mod = ed.lookupDataTable("Levels", "Arena HP Mult", proto._level)
			}
			setUpConfigEstimateInfo(config, proto._tid, hero_is_bot)
			local dyna
			if hero_dyna then
				dyna = hero_dyna[i]
			end
			local unit
			if isSelf then
				unit = ed.UnitCreate(proto, ed.emCampPlayer, config, dyna)
			else
				unit = ed.UnitCreate(proto, ed.emCampEnemy, config, dyna)
			end
			unit.index_in_team = i
			if isSelf then
				if self.crusade_mode or self.excavate_mode or manual_skill then
					unit.ai.will_cast_manual_skill = false
				end
				initUnitMercenaryData(unit, proto)
			end
			table.insert(unitlist, unit)
		end
	end
	return unitlist
end

local function initUnitInfo(self, self_unit, enemy_unit)
	sortUnitList(self_unit)
	sortUnitList(enemy_unit)
	for i, v in ipairs(self_unit) do
		v.position = {
			initial_position[i][1],
			initial_position[i][2]
		}
		table.insert(self.hero_id_list, v.tid)
		self:addUnit(v)
	end
	for i, v in ipairs(enemy_unit) do
		local position = initial_position[i]
		v.position = {
			ed.engine.stage_rect.maxX - position[1],
			position[2]
		}
		self:addUnit(v)
	end
	resetUnitList(self)
end

local function initHeroInfo(self, hero_list, hero_is_bot, enemy_list, enemy_is_bot, self_crusade, enemy_crusade, indexList)
	for i = 1, #hero_list do
		local proto = hero_list[i]
		local config = {
			hp_mod = ed.lookupDataTable("Levels", "Arena HP Mult", proto._level)
		}
		setUpConfigEstimateInfo(config, proto._tid, hero_is_bot)
		local crusade
		if self_crusade then
			crusade = self_crusade[proto._tid]
		end
		local hero = ed.UnitCreate(proto, ed.emCampPlayer, config, crusade)
		if self.crusade_mode then
			hero.ai.will_cast_manual_skill = false
		end
		if self.excavate_mode then
			hero.ai.will_cast_manual_skill = false
		end
		initUnitMercenaryData(hero, proto)
		self:addUnit(hero)
		hero.position = {
			initial_position[i][1],
			initial_position[i][2]
		}
		table.insert(self.hero_id_list, proto._tid)
	end
	for i = 1, #enemy_list do
		local proto = enemy_list[i]
		local config = {
			hp_mod = ed.lookupDataTable("Levels", "Arena HP Mult", proto._level)
		}
		setUpConfigEstimateInfo(config, proto._tid, enemy_is_bot)
		local crusade
		if enemy_crusade then
			if indexList then
				crusade = enemy_crusade[indexList[proto]]
			else
				crusade = enemy_crusade[proto._tid]
			end
		end
		local enemy = ed.UnitCreate(proto, ed.emCampEnemy, config, crusade)
		self:addUnit(enemy)
		local position = initial_position[i]
		enemy.position = {
			ed.engine.stage_rect.maxX - position[1],
			position[2]
		}
	end
	resetUnitList(self)
end

local function enterArena(self, hero_list, enemy_list, hero_is_bot, enemy_is_bot)
	self:resetStage()
	self.arena_mode = true
	self.stage_info = ed.lookupDataTable("Stage", -1)
	self.hero_list = hero_list
	sortHeroList(hero_list)
	sortHeroList(enemy_list)
	self.wave_id = 1
	initHeroInfo(self, hero_list, hero_is_bot, enemy_list, enemy_is_bot)
	self.mp_bonus = 1
end
class.enterArena = enterArena

local function enterCrusade(self, hero_list, enemy_list, enemy_is_bot, self_crusade, enemy_crusade, stage_id)
	self:resetStage()
	self.crusade_mode = true
	self.stage_info = ed.lookupDataTable("Stage", stage_id)
	self.hero_list = hero_list
	sortHeroList(hero_list)
	sortHeroList(enemy_list)
	self.wave_id = 1
	initHeroInfo(self, hero_list, false, enemy_list, enemy_is_bot, self_crusade, enemy_crusade)
	self.mp_bonus = 1
end
class.enterCrusade = enterCrusade

local function enterExcavate(self, hero_list, enemy_list, enemy_is_bot, self_dyna_list, enemy_dyna_list, stage_id, typeid)
	self:resetStage()
	self.excavate_mode = true
	self.stage_info = ed.lookupDataTable("Stage", stage_id)
	self.hero_list = hero_list
	self.wave_id = 1
	self.origin_enemy_team = combineBaseDyna(enemy_list, enemy_dyna_list)
	self.excavate_type_id = typeid
	local selfUnit = initUnitList(self, true, hero_list, false, self_dyna_list)
	local enemyUnit = initUnitList(self, false, enemy_list, enemy_is_bot, enemy_dyna_list)
	initUnitInfo(self, selfUnit, enemyUnit)
	self.mp_bonus = 1
end
class.enterExcavate = enterExcavate

local function enterRelay(self, param)
	param = param or {}
	self:resetStage()
	self.replayMode = true
	self.stage_info = ed.lookupDataTable("Stage", param.stage_id)
	self.wave_id = 1
	self.arena_mode = param.mode == "pvp"
	local self_manual, enemy_manual
	if param.oppoUserid == ed.getUserid() then
		if param.operations then
			enemy_manual = true
		end
	elseif param.operations then
		self_manual = true
	end
	local selfUnit = initUnitList(self, true, ed.copyProto(param.hero_list), param.hero_is_bot, param.self_dyna_list, self_manual)
	local enemyUnit = initUnitList(self, false, ed.copyProto(param.enemy_list), param.enemy_is_bot, param.enemy_dyna_list, enemy_manual)
	initUnitInfo(self, selfUnit, enemyUnit)
	self:setOperationList(param.operations)
	self.mp_bonus = 1
end
class.enterRelay = enterRelay

local function battleSupply(self, bSupplyEnemy)
	for unit in self:foreachAliveUnit(bSupplyEnemy and ed.emCampEnemy or ed.emCampPlayer) do
		local coefficient = 1
		if self.stage_info["Mps Restraint"] > 0 then
			coefficient = self.stage_info["Mps Restraint"] / 100
		end
		unit:battleSupply(coefficient)
		unit:removeAllBuffs()
	end
	if not bSupplyEnemy then
		self.supplied = true
	end
end
class.battleSupply = battleSupply

local function nextBattle(self)
	if not self.supplied then
		self:battleSupply()
	end
	local battle = ed.lookupDataTable("Battle", nil, self.stage_info["Stage ID"], self.wave_id + 1)
	self:setupBattle(battle)
	ed.engine.usedDeliveredBallSlots = {}
end
class.nextBattle = nextBattle

local function findMonster(self, IDorName)
	local list = {}
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampEnemy and (unit.id == IDorName or unit.name == IDorName) then
			table.insert(list, unit)
		end
	end
	if #list == 1 then
		return list[1]
	else
		EDDebug("WTF!")
	end
end
class.findMonster = findMonster

local function findBoss(self)
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampEnemy and unit.config.is_boss then
			return unit
		end
	end
	EDDebug("Find Boss Error")
end
class.findBoss = findBoss
local function findHero(self, IDorName)
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampPlayer and (unit.id == IDorName or unit.name == IDorName) then
			return unit
		end
	end
end
class.findHero = findHero

local update = function(self, dt)
	if not self.running then
		return
	end
	self.next_tick = self.next_tick - dt
	if self.next_tick <= 0 then
		self:tick()
		while self.next_tick <= 0 do
			self.next_tick = self.next_tick + self.tick_interval
		end
	end
end
class.update = update

local runScriptString = function()
	if LegendGetScriptString then
		local temp = LegendGetScriptString()
		if temp ~= nil then
			local func = loadstring(temp)
			if func ~= nil then
				xpcall(func, EDDebug)
			end
		end
	end
end

local function tick(self)
	if ed.enableBotMode then
		runScriptString()
	end
	if not self.running then
		return
	end
	local tick_interval = self.tick_interval
	self.time_limit = self.time_limit - tick_interval
	while self.operation_list[self.next_operation_index] do
		local opp = self.operation_list[self.next_operation_index]
		if opp.tick == self.ticks then
			local unit = self.unit_list[opp.unit_index]
			unit:castManualSkill()
			self.next_operation_index = self.next_operation_index + 1
		elseif opp.tick < self.ticks then
			EDDebug()
		else
			break
		end
	end
	for _, list_name in ipairs({
		"unit_list",
		"projectile_list",
		"npc_list"
	})
	do
		local list = self[list_name]
		local new_list = {}
		for _, entity in ipairs(list) do
			local f = entity.frozen_model
			if not f then
				entity:update(tick_interval)
			end
			if not entity.terminated then
				table.insert(new_list, entity)
			end
		end
		self[list_name] = new_list
	end
	self.ticks = self.ticks + 1
	if do_battle_log then
		btlog(tostring(self))
	end
	if self.time_limit <= 0 then
		self.result_stars = 0
		if self.crusade_mode then
			for i, unit in pairs(self.unit_list) do
				unit:die()
			end
		end
		if self.excavate_mode then
			for i, unit in pairs(self.unit_list) do
				unit:die()
			end
		end
		self:onBattleEnd()
		self:exitStage(3)
	elseif self.alive_enemy_count == 0 then
		self:unfreeze(true)
		self:onBattleEnd()
		self:victory()
	elseif self.alive_alliance_count == 0 then
		self.result_stars = 0
		self:unfreeze(true)
		self:onBattleEnd()
		if self.excavate_mode then
			self:battleSupply(true)
		end
		self:exitStage(1)
	end
end
class.tick = tick

local function manuallyCastSkill(self, unit)
	ed.endTeach("useSkill")
	local oppration = {
		op = 0,
		wave = self.wave_id,
		tick = self.ticks,
		unit_index = unit.index_in_engine
	}
	table.insert(self.operation_list, oppration)
end
class.manuallyCastSkill = manuallyCastSkill

local function manualTapBall(self, deliverer, idx, myslotidx, nexttick)
	local kael
	if deliverer.camp == ed.emCampPlayer then
		kael = ed.engine.playerKaelHero
	else
		kael = ed.engine.enemyKaelHero
	end
	local t = self.ticks
	if nexttick then
		t = t + 1
	end
	local oppration = {
		op = 5,
		wave = self.wave_id,
		tick = t,
		unit_index = kael.index_in_engine,
		ext = {idx, myslotidx}
	}
	table.insert(self.operation_list, oppration)
end
class.manualTapBall = manualTapBall

local globalBallIdx = 0
local function increBall()
	globalBallIdx = globalBallIdx + 1
	return globalBallIdx
end
class.increBall = increBall
local slotPositions = {}
for i = 1, 10 do
	slotPositions[i] = {
		100 + 70 * i,
		ed.rand() * 30 + 210
	}
end
for i = 11, 20 do
	slotPositions[i] = {
		100 + 70 * (i - 10),
		ed.rand() * 50 + 400
	}
end
class.slotPositions = slotPositions
local function getDeliveredEmptySlot(self, x)
	local neari = 0
	local nearlen = 9999999
	for i = 1, 10 do
		if not self.usedDeliveredBallSlots[i] then
			local a = math.abs(slotPositions[i][1] - x)
			if nearlen > a then
				nearlen = a
				neari = i
			end
		end
	end
	if neari ~= 0 then
		return neari, slotPositions[neari]
	else
		local r = math.floor(ed.rand() * 9 + 1)
		return r, slotPositions[r]
	end
end
class.getDeliveredEmptySlot = getDeliveredEmptySlot

local function getManualDeliveredEmptySlot(self, x)
	local neari = 0
	local nearlen = 9999999
	for i = 11, 20 do
		if not self.usedDeliveredBallSlots[i] then
			local a = math.abs(slotPositions[i][1] - x)
			if nearlen > a then
				nearlen = a
				neari = i
			end
		end
	end
	if neari ~= 0 then
		return neari, slotPositions[neari]
	else
		local r = math.floor(ed.rand() * 10 + 1)
		return r, slotPositions[r]
	end
end
class.getManualDeliveredEmptySlot = getManualDeliveredEmptySlot

local getAvailableBallSlot = function(self, deliver)
	for i, u in pairs(self.unit_list) do
		if u.energy_ball_manager and u.camp == deliver.camp then
			return u.energy_ball_manager:getEmptySlot(true)
		end
	end
end
class.getAvailableBallSlot = getAvailableBallSlot

local function setOperationList(self, list)
	self.operation_list = {}
	list = list or {}
	for i, v in ipairs(list) do
		local optype = ed.splitbits(v, 3)
		if optype ~= 5 then
			local tick, uidx, op = ed.splitbits(v, 12, 3, 3)
			self.operation_list[i] = {
				op = op,
				tick = tick,
				unit_index = uidx
			}
		elseif optype == 5 then
			local tick, uidx, idx, dsIdx, op = ed.splitbits(v, 12, 3, 9, 2, 3)
			self.operation_list[i] = {
				op = op,
				tick = tick,
				unit_index = uidx,
				ext = {idx, dsIdx}
			}
		end
	end
end
class.setOperationList = setOperationList

local function getOprationList(self)
	local list = {}
	for i, op in ipairs(self.operation_list) do
		local value
		if op.op ~= 5 then
			value = ed.makebits(12, op.tick, 3, op.unit_index, 3, op.op)
		elseif op.op == 5 then
			value = ed.makebits(12, op.tick, 3, op.unit_index, 9, op.ext[1], 2, op.ext[2], 3, op.op)
		end
		table.insert(list, value)
	end
	return list
end
class.getOprationList = getOprationList

local function freeze(self)
	if self.freeze_level == 0 then
		if ed.run_with_scene then
			ed.scene:onSceneFreezeBegin()
		end
		for i, unit in ipairs(self.unit_list) do
			unit:freeze()
		end
		for _, projectile in ipairs(self.projectile_list) do
			projectile:freeze()
		end
		for _, npc in ipairs(self.npc_list) do
			npc:freeze()
		end
	end
	self.freeze_level = self.freeze_level + 1
end
class.freeze = freeze

local function unfreeze(self, force)
	if force then
		if self.freeze_level == 0 then
			return
		else
			self.freeze_level = 1
		end
	end
	self.freeze_level = self.freeze_level - 1
	if self.freeze_level < 0 then
		EDDebug()
	end
	if self.freeze_level == 0 then
		for entity in self:foreachEntity() do
			entity:unfreeze()
		end
		if ed.run_with_scene then
			ed.scene:onSceneFreezeEnd()
		end
	end
end
class.unfreeze = unfreeze

local function addUnit(self, unit)
	local alive = unit:isAlive()
	unit.previous_position = {
		unit.position[1],
		unit.position[2]
	}
	table.insert(self.unit_list, unit)
	if alive then
		table.insert(self.alive_units[unit.camp], unit)
		table.insert(self.alive_units[ed.emCampBoth], unit)
		if unit.camp == ed.emCampPlayer then
			self.alive_alliance_count = self.alive_alliance_count + 1
		elseif unit.camp == ed.emCampEnemy then
			self.alive_enemy_count = self.alive_enemy_count + 1
		end
	elseif unit.camp == ed.emCampPlayer then
		self.dead_alliance_count = self.dead_alliance_count + 1
	elseif unit.camp == ed.emCampEnemy then
		self.dead_enemy_count = self.dead_enemy_count + 1
	end
	unit.index_in_engine = #self.unit_list
	unit.actor = nil
end
class.addUnit = addUnit

local summonUnit = function(self, unit, position, summoner, bornActionName)
	unit.config.is_summoned = true
	unit.position = position
	self:addUnit(unit)
	unit:summon(bornActionName)
	unit.config.summoner = summoner
	if unit.actor then
		unit.actor:update(0)
	end
end
class.summonUnit = summonUnit

local function onNpcDie(self, npc)
	local list = self.npc_list
	for i, u in pairs(list) do
		if u == npc then
			table.remove(self.npc_list, i)
			break
		end
	end
end
class.onNpcDie = onNpcDie

local function onUnitDie(self, unit, killer_unit)
	local list = self.alive_units[unit.camp]
	for i, u in pairs(list) do
		if u == unit then
			table.remove(list, i)
			break
		end
	end
	list = self.alive_units[ed.emCampBoth]
	local index
	for i, u in pairs(list) do
		if u == unit then
			index = i
		else
			u:handleUnitDieEvent(unit, killer_unit)
		end
	end
	if index then
		table.remove(list, index)
	end
	if killer_unit and killer_unit:isHero() and not unit.config.is_summoned then
		killer_unit:setMP(killer_unit.mp + 300)
		if killer_unit.actor then
			local color = killer_unit.camp == ed.emCampPlayer and "blue" or "red"
			ed.PopupCreate("kill", color, killer_unit.actor, nil, "text")
		end
	end
	if unit.camp == ed.emCampPlayer then
		self.alive_alliance_count = self.alive_alliance_count - 1
		self.dead_alliance_count = self.dead_alliance_count + 1
	elseif unit.camp == ed.emCampEnemy then
		self.alive_enemy_count = self.alive_enemy_count - 1
		self.dead_enemy_count = self.dead_enemy_count + 1
		if ed.run_with_scene then
			ed.scene:showMonsterLoots(self.wave_id, unit)
		end
	end
	if ed.run_with_scene then
		FireEvent("UnitDie", unit, killer)
		ListenTimer(Timer:Once(1), function()
			FireEvent("UnitDieDelay", unit, killer)
		end)
	end
end
class.onUnitDie = onUnitDie

local function doFailed(self, param)
	local id = ed.playEffect(ed.sound.battle.lose)
	ed.audioParam.effects.battleResult = id
	ed.scene.node:runAction(CCSequence:create(ccArrayMake(unpack({
		CCDelayTime:create(2.5),
		CCCallFunc:create(function()
			ed.ui.stageaccount.initialize(param)
		end)
	}))))
end
class.doFailed = doFailed

local function getTeamMercenaryInfo(self)
	if not self.unit_list then
		return
	end
	local mercenartInfo
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampPlayer and unit:getMercenaryData() then
			mercenartInfo = {}
			mercenartInfo.index = i
			mercenartInfo.data = unit:getMercenaryData()
			break
		end
	end
	return mercenartInfo
end
class.getTeamMercenaryInfo = getTeamMercenaryInfo

local function getMercenaryNum(self)
	local num = 0
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampPlayer and unit:isMercenary() == true then
			num = num + 1
		end
	end
	return num
end
class.getMercenaryNum = getMercenaryNum

function class:getSelfHeroIdList()
	local mercenaryInfo = getTeamMercenaryInfo(self)
	if mercenaryInfo then
		local heros = ed.copyTable(self.hero_id_list)
		heros[mercenaryInfo.index] = nil
	else
		return self.hero_id_list
	end
end

local function downExit(self, result)
	local function handler(isKnown, bestRankReward)
		bestRankReward = bestRankReward or {}
		if not self then
			return
		end
		if tolua.isnull(ed.scene.node) then
			return
		end
		local stage = self.stage_info["Stage ID"]
		if isKnown then
			if result == 0 then
				do
					local type = ed.stageType(stage)
					local s = ed.elite2NormalStage(stage)
					if type == "elite" then
						ed.player:addStageLimit(s)
					end
					if type == "act" then
						local sg = self.stage_info["Stage Group"]
						ed.player:addActTimes(sg)
						ed.player:refreshActResetTime(sg)
					end
					ed.player:takeStageReward(stage, self.result_stars - getMercenaryNum(self), self.hero_list, ed.player:getStageLoots())
					if pveMode(self) == true then
						local vit = self.stage_info["Vit Return"]
						ed.player:addVitality(-vit)
					end
					local id = ed.playEffect(ed.sound.battle.win)
					ed.audioParam.effects.battleResult = id
					local args = {
						stage_id = stage,
						victory = result == 0,
						heroes = self.hero_id_list,
						stars = pveMode(self) and self.exitStageMSG._stars - getMercenaryNum(self) or {},
						loots = ed.player:getStageLoots(),
						replayMode = self.replayMode,
						bestRankReward = bestRankReward,
						mercenaryInfo = getTeamMercenaryInfo(self),
						excavate_mode = self.excavate_mode,
						isPveMode = pveMode(self)
					}
					ed.scene.node:runAction(ed.readaction.create({
						t = "seq",
						CCDelayTime:create(3.6),
						CCCallFunc:create(function()
							ed.ui.stageaccount.initialize(args)
						end)
					}))
				end
			elseif result == 1 then
				self:doFailed({
					stage_id = stage,
					victory = false,
					heroes = self.hero_id_list,
					loseType = "fail",
					excavate_mode = self.excavate_mode,
					isPveMode = pveMode(self)
				})
				--ed.player:takeStageExp(stage)
			end
		else
			self:doFailed({
				stage_id = stage,
				victory = false,
				heroes = self.hero_id_list,
				loseType = "fail",
				excavate_mode = self.excavate_mode,
				isPveMode = pveMode(self)
			})
			--ed.player:takeStageExp(stage)
		end
	end
	return handler
end
class.downExit = downExit

local function onBattleEnd(self)
	local newlist = {}
	for i, unit in ipairs(self.unit_list) do
		if unit.config.is_summoned then
			local summoner = unit.config.summoner
			if summoner then
				summoner.dmg_statistics = summoner.dmg_statistics + unit.dmg_statistics
			end
		else
			unit:removeAllBuffs()
			table.insert(newlist, unit)
		end
	end
	self.unit_list = newlist
end
class.onBattleEnd = onBattleEnd

local function fillEnemyHpInfo(self, stageId, waveId)
	local hpTable = {}
	local battle_info = ed.lookupDataTable("Battle", nil, stageId, waveId)
	for i = 1, 5 do
		local id = battle_info["Monster " .. i .. " ID"]
		if id and id > 0 then
			table.insert(hpTable, 10000)
		else
			table.insert(hpTable, 0)
		end
	end
	return hpTable
end
class.fillEnemyHpInfo = fillEnemyHpInfo

local function getEenemyConsumePercent(self)
	local percent = 0
	local sumHp = 0
	local sumTotalHp = 0
	local sumDpsHp = 0
	for i, unit in ipairs(self.unit_list) do
		if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
			sumHp = sumHp + unit.hp
			sumTotalHp = sumTotalHp + unit.attribs.HP
		end
	end
	if 0 ~= sumTotalHp then
		percent = 1 - sumHp / sumTotalHp
	end
	sumDpsHp = sumTotalHp - sumHp
	return percent, sumDpsHp
end
class.getEenemyConsumePercent = getEenemyConsumePercent

local function getEnemyFinalHpInfo(self)
	local enemyHpInfo = {}
	for i, unit in ipairs(self.unit_list) do
		if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
			enemyHpInfo[unit.monster_idx] = {
				HP = unit.hp,
				SumHP = unit.attribs.HP
			}
		end
	end
	for i = 1, 5 do
		if enemyHpInfo[i] == nil then
			enemyHpInfo[i] = {HP = 0, SumHP = 0}
		end
	end
	return enemyHpInfo
end
class.getEnemyFinalHpInfo = getEnemyFinalHpInfo

local function getEnemyTotalHp(self)
	local sumTotalHp = 0
	for i, unit in ipairs(self.unit_list) do
		if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
			sumTotalHp = sumTotalHp + unit.attribs.HP
		end
	end
	return sumTotalHp
end
class.getEnemyTotalHp = getEnemyTotalHp

local function getRaidProgress(self)
	local raidTable = ed.getDataTable("Raid")
	local maxPercent = 10000
	local startStageId = raidTable[self.raid_id]["Begin Stage ID"]
	local stageNum = raidTable[self.raid_id]["Stages Count"]
	local currentStageId = self.stage_info["Stage ID"]
	local battleTable = ed.getDataTable("Battle")
	local percent = 0
	local totalPercent = 0
	for i = startStageId, startStageId + stageNum - 1 do
		local stagePercent = battleTable:getStageTotalPercent(i)
		totalPercent = totalPercent + stagePercent
		if i < currentStageId then
			percent = percent + stagePercent
		elseif currentStageId == i then
			percent = percent + getStageProgress(self) / maxPercent * stagePercent
		end
	end
	return math.floor(percent / totalPercent * maxPercent)
end

local function getBattleResult(self)
	local selfHeros = {}
	local enemyHeros = {}
	local bMercenary = {}
	for i, unit in pairs(self.unit_list) do
		if unit.config.is_summoned then
		else
			local hero = {}
			hero._heroid = unit.tid
			hero._hp_perc = math.ceil(unit.hp / unit.attribs.HP * 10000)
			hero._mp_perc = math.ceil(unit.mp / unit.attribs.MP * 10000)
			hero._custom_data = unit.custom_data
			if unit.camp == ed.emCampEnemy then
				if unit.index_in_team then
					enemyHeros[unit.index_in_team] = hero
				else
					table.insert(enemyHeros, hero)
				end
			elseif unit.camp == ed.emCampPlayer then
				table.insert(selfHeros, hero)
				table.insert(bMercenary, unit:isMercenary())
			end
		end
	end
	if self.excavate_mode then
		for i, v in ipairs(self.origin_enemy_team or {}) do
			if not enemyHeros[i] then
				local bv = v.base
				local dv = v.dyna
				local hero = {}
				hero._heroid = bv._tid
				hero._hp_perc = dv._hp_perc
				hero._mp_perc = dv._mp_perc
				hero._custom_data = dv._custom_data
				enemyHeros[i] = hero
			end
		end
	end
	return selfHeros, enemyHeros, bMercenary
end
class.getBattleResult = getBattleResult

local function applyCrusadeResult(selfHero, mercenay)
	if nil == selfHero then
		return
	end
	for i, v in ipairs(selfHero) do
		local hero
		if mercenay[i] == true then
			hero = ed.mercenary.getCrusadeMercenary()
		else
			hero = ed.player:getHero(v._heroid)
		end
		if hero then
			hero.crusadeData = {}
			hero.crusadeData._hp_perc = v._hp_perc
			hero.crusadeData._mp_perc = v._mp_perc
			hero.crusadeData._custom_data = v._custom_data
		end
	end
end

local function getExitMsg(self, result)
	local msg
	local msgName = ""
	if self.arena_mode then
		msg = ed.upmsg.ladder()
		msg._end_battle = {}
		msg._end_battle._result = result
		msgName = "ladder"
	elseif self.crusade_mode then
		local selfHero, enemyHero, mercenay = getBattleResult(self)
		applyCrusadeResult(selfHero, mercenay)
		msg = ed.upmsg.tbc()
		msg._end_bat = {}
		msg._end_bat._result = result
		msg._end_bat._self_heroes = selfHero
		msg._end_bat._oppo_heroes = enemyHero
		msg._end_bat._oprations = self:getOprationList()
		msgName = "tbc"
		ed.battleshare.getBattleData({
			result = result,
			oppo_heroes = enemyHero,
			oprations = self:getOprationList(),
			msgName = 1
		})
	elseif self.guildInstance_mode then
		local enemyHp = getEnemyHpInfo(self)
		msg = ed.upmsg.guild()
		msg._instance_end = {}
		msg._instance_end._result = result
		msg._instance_end._wave = self.wave_id
		msg._instance_end._oprations = self:getOprationList()
		msg._instance_end._hp_info = enemyHp
		msg._instance_end._damage = self:getPlayerTotalDamage()
		msg._instance_end._stage_progress = getStageProgress(self)
		msg._instance_end._progress = getRaidProgress(self)
		msg._instance_end._heroes = self.hero_id_list
		msgName = "guild"
	elseif self.excavate_mode then
		local selfHero, enemyHero, mercenary = getBattleResult(self)
		msg = ed.upmsg.excavate()
		local eeb = ed.upmsg.excavate_end_battle()
		eeb._result = result
		eeb._self_heroes = selfHero
		eeb._oppo_heroes = enemyHero
		eeb._type_id = self.excavate_type_id
		eeb._oprations = self:getOprationList()
		msgName = "excavate"
		msg._excavate_end_battle = eeb
		if ed.run_with_scene then
			ed.ui.excavate.refreshTeamHeroData(enemyHero)
			ed.ui.excavate.refreshExcavateBatHeroes(selfHero, mercenary)
		end
		ed.battleshare.getBattleData({
			result = result,
			oppo_heroes = enemyHero,
			oprations = self:getOprationList(),
			msgName = 2
		})
	else
		msg = ed.upmsg.exit_stage()
		msg._result = result
		if 0 == result then
			msg._heroes = self.hero_id_list
			msg._stars = self.result_stars
			msg._oprations = self:getOprationList()
			local selfHero = getBattleResult(self)
			local hp_info = {}
			for i, v in ipairs(selfHero) do
				hp_info[i] = v._hp_perc
			end
			msg._self_data = hp_info
		end
		msgName = "exit_stage"
	end
	return msg, msgName
end

local function printStatistics(self)
	print("==========================================")
	local maxdmg = 0
	local maxlen = 0
	for i, unit in ipairs(self.unit_list) do
		maxdmg = math.max(maxdmg, unit.dmg_statistics)
		maxlen = math.max(maxlen, #unit.name)
	end
	for i, unit in ipairs(self.unit_list) do
		local ratio = math.floor(unit.dmg_statistics / maxdmg * 20)
		print(table.concat({
			unit.camp == 1 and "[+]" or "[-]",
			unit.name,
			string.rep(" ", maxlen - #unit.name + 1),
			string.rep("#", ratio),
			string.rep(" ", 21 - ratio),
			math.floor(unit.dmg_statistics)
		}))
	end
	print("==========================================")
end
class.printStatistics = printStatistics

local function getPlayerTotalDamage(self)
	local damage = 0
	for i, unit in ipairs(self.unit_list) do
		if unit.camp == ed.emCampPlayer then
			damage = damage + unit.dmg_statistics
		end
	end
	return math.floor(damage)
end
class.getPlayerTotalDamage = getPlayerTotalDamage

local function exitStage(self, result, exitFlag)
	--add by xinghui
	ed.scene.curSpeedState = ed.scene.speedState.common
	--
	self.running = false
	self.enabled = false
	self.stage_ended = true
	self.playerKaelHero = nil
	self.enemyKaelHero = nil
	local function doTimeOut()
		local stage = self.stage_info["Stage ID"]
		self:doFailed({
			stage_id = stage,
			victory = false,
			heroes = self.hero_id_list,
			loseType = "timeout",
			excavate_mode = self.excavate_mode,
			isPveMode = pveMode(self)
		})
		--ed.player:takeStageExp(stage)
	end
	if ed.run_with_scene then
		self:printStatistics()
		ed.stopMusic()
		if self.gmMode then
			doTimeOut()
			return
		end
		if self.replayMode == true then
			self.replayMode = nil
			if exitFlag ~= true then
				ListenTimer(Timer:Once(2), function()
					ed.ui.vcdLayer.create()
				end)
			end
			return
		end
		if result == 0 then
			FireEvent("BattleEnding", self.stage_info["Stage ID"], "success")
			ed.netreply.exitStageReply = self:downExit(result)
			ed.scene:autoCollectLoots(2.8)
		elseif result == 1 then
			FireEvent("BattleEnding", self.stage_info["Stage ID"], "failed")
			for unit in self:foreachAliveUnit(ed.emCampEnemy) do
				if unit.actor then
					unit.actor:waitAfterBattle()
				end
			end
			ed.netreply.exitStageReply = self:downExit(result)
		elseif result == 2 then
			ed.playMusic(ed.music.map)
		elseif result == 3 then
			if self.crusade_mode or self.excavate_mode then
				ListenTimer(Timer:Once(2), function()
					doTimeOut()
				end)
			elseif self.guildInstance_mode then
				ed.scene:addTimeOutUI()
				LegendLog("guildInstance_mode time out")
			else
				doTimeOut()
			end
		end
		if do_battle_log and not EDFLAGSVR then
			self.battleLog = getBtlog()
			if ed.debug_mode then
				local folder = CCFileUtils:sharedFileUtils():getWritablePath()
				if EDFLAGWIN32 then
					folder = "btlog"
				end
				local path = string.format("%s/%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"))
				local file = io.open(path, "w")
				if file then
					file:write(self.battleLog)
					file:close()
				end
			end
		end
		local msg, msgName = getExitMsg(self, result)
		ed.netdata.exitStageReply = {
			stage = self.stage_info["Stage ID"],
			result = result
		}
		self.battleResult = result
		self.exitStageMSG = msg
		self.exitStageMsgName = msgName
		ed.send(msg, msgName)
	end
end
class.exitStage = exitStage

local enterGmMode = function(self)
	self.gmMode = true
end
class.enterGmMode = enterGmMode

local function victory(self, skip)
	self.running = false
	if self.wave_id < self.stage_info.Waves and not skip then
		for unit in self:foreachAliveUnit(ed.emCampPlayer) do
			if unit.config.is_summoned then
				unit:die()
			end
		end
		if ed.run_with_scene then
			ed.scene:showNextButton()
			for unit in self:foreachAliveUnit(ed.emCampPlayer) do
				if unit.actor then
					unit.actor:waitAfterBattle()
				end
			end
		else
			self:nextBattle()
		end
	else
		local deathcount = 0
		for i, unit in ipairs(self.unit_list) do
			if unit.camp == ed.emCampPlayer and unit:isHero() and not unit:isAlive() then
				deathcount = deathcount + 1
			end
		end
		self.death_count = deathcount
		self.result_stars = math.max(1, 3 - deathcount)
		if self.crusade_mode then
			self:battleSupply()
		end
		if self.excavate_mode then
			self:battleSupply()
		end
		if ed.run_with_scene then
			self.stage_ended = true
			self:exitStage(0)
			for unit in self:foreachAliveUnit(ed.emCampPlayer) do
				if unit.actor then
					unit.actor:cheer()
				end
			end
		end
	end
	if ed.run_with_scene then
		for _, unit in pairs(self.unit_list) do
			if unit.camp == ed.emCampEnemy and unit.actor then
				unit.actor:onUnitDeath()
			end
		end
	end
end
class.victory = victory

local foreachAliveUnit = function(self, camp)
	local list = self.alive_units[camp]
	local i = #list + 1
	return function()
		i = i - 1
		return list[i]
	end
end
class.foreachAliveUnit = foreachAliveUnit

local foreachNpc = function(self)
	local list = self.npc_list
	local i = #list + 1
	return function()
		i = i - 1
		return list[i]
	end
end
class.foreachNpc = foreachNpc

local foreachEntity = function(self)
	local list_of_list = {
		"unit_list",
		"projectile_list",
		"npc_list"
	}
	local i, j = 1, 1
	return function()
		repeat
			local list = self[list_of_list[i]]
			if list == nil then
				return nil
			end
			local ret = list[j]
			if j >= #list then
				i = i + 1
				j = 1
			else
				j = j + 1
			end
			if ret then
				return ret
			end
		until ret
	end
end
class.foreachEntity = foreachEntity

local function addProjectile(self, projectile)
	if projectile then
		projectile.previous_position = {
			projectile.position[1],
			projectile.position[2]
		}
		table.insert(self.projectile_list, projectile)
		if ed.run_with_scene then
			local actor = ed.ProjectileActorCreate(projectile)
			ed.scene:addActor(actor)
			projectile.actor = actor
		end
	end
end
class.addProjectile = addProjectile

local function createNpc(self, npcId, isFlipX, owner)
	local npc
	local npcInfo = ed.lookupDataTable("NPC", nil, npcId)
	if npcInfo then
		npcInfo.id = npcId
		npc = ed.NpcCreate(npcInfo, isFlipX, owner)
		table.insert(self.npc_list, npc)
	end
	return npc
end
class.createNpc = createNpc

local function addChain(self, chain)
	if chain then
		table.insert(self.projectile_list, chain)
	end
end
class.addChain = addChain

local getUnitByIndex = function(self, index, camp)
	if self.alive_units[camp] then
		return self.alive_units[camp][index]
	end
end
class.getUnitByIndex = getUnitByIndex

local getUnitNum = function(self, camp)
	if self.alive_units[camp] then
		return #self.alive_units[camp]
	end
	return 0
end
class.getUnitNum = getUnitNum

local deliverBall = function(self, unit, skill, idx)
	for i, u in pairs(self.unit_list) do
		if u.camp == unit.camp and u.showBall then
			u:showBall(unit, skill, idx)
		end
	end
end
class.deliverBall = deliverBall

local function showReplay(data, mode, channel)
	if not data then
		return
	end
	if 1 == channel then
		mode = "tbc"
	elseif 2 == channel then
		mode = "excavateReply"
	end
	mode = mode or "pvp"
	ed.ui.vcdLayer.setData(data, mode)
	local stageid
	if mode == "pvp" then
		stageid = -1
	elseif mode == "excavate" then
		local typeid = data._param1
		stageid = ed.getDataTable("ExcavateTreasure")[typeid]["PVP Stage ID"]
	elseif mode == "tbc" or mode == "excavateReply" then
		stageid = data._param1
	end
	local stage = ed.lookupDataTable("Stage", nil, stageid)
	local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
	local info = {
		userId = data._userid,
		userName = data._username,
		userAvatar = data._avatar,
		vip = data._vip,
		oppoUserid = data._oppo_userid,
		oppoUserName = data._oppo_name,
		oppoUserAvatar = data._oppo_avatar,
		oppovip = data._oppo_vip
	}
	ed.srand(data._rseed)
	local operations = data._operations
	if (1 == channel or 2 == channel) and not operations then
		operations = {}
	end
	ed.engine:enterRelay({
		hero_list = data._self_heroes,
		self_dyna_list = data._self_dynas,
		hero_is_bot = 0 < (data._self_robot or 0),
		enemy_list = data._oppo_heroes,
		enemy_dyna_list = data._oppo_dynas,
		enemy_is_bot = 0 < (data._oppo_robot or 0),
		stage_id = stageid,
		operations = operations,
		mode = mode
	})
	ed.scene:reset(stage, battle, {replayInfo = info})
	ed.pushScene(ed.scene)
end
ed.showReplay = showReplay

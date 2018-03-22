module("battle_check", package.seeall)

local enterGuildInstance = function(msg)
	local stage = ed.lookupDataTable("Stage", nil, msg._stageid)
	local guildInstanceInfo = {}
	guildInstanceInfo._wave_index = msg._start_wave
	guildInstanceInfo._hp_info = msg._hp_start
	guildInstanceInfo._raid_id = 1
	ed.engine:enterGuildInstance(stage, msg._self_heroes, guildInstanceInfo)
end

local getDynaData = function(msg)
	local self_dyna_data = {}
	for i, h in ipairs(msg._self_heroes) do
		self_dyna_data[h._tid] = msg._self_dyna_start[i]
	end
	local oppo_dyna_data = {}
	for i, h in ipairs(msg._oppo_heroes) do
		oppo_dyna_data[h._tid] = msg._oppo_dyna_start[i]
	end
	return self_dyna_data, oppo_dyna_data
end

local getStageEnemyData = function(param)
	param = param or {}
	local id = param.id
	local dynas = param.dynas
	local heroes = {}
	local stage = ed.getDataTable("Stage")
	local battle = ed.getDataTable("Battle")
	local srow = stage[id]
	local brow = battle[id][1]
	local level = srow["Monster Level"]
	local rank = ed.heroLevel2Rank(level)
	local down = pb_loader("bcdown")()
	local function getHeroByIndex(index)
		if not brow["Monster " .. index .. " ID"] then
			return
		end
		local hero = {}
		if dynas[index] then
			hero.dyna = dynas[index]
		else
			local dyna = down.hero_dyna()
			dyna._hp_perc = 10000
			dyna._mp_perc = brow["MP " .. index]
			hero.dyna = dyna
		end
		local base = down.hero()
		base._tid = brow["Monster " .. index .. " ID"]
		base._rank = rank
		base._level = level
		base._stars = brow["Stars " .. index]
		base._exp = 0
		base._gs = 0
		base._skill_levels = {}
		base._items = {}
		hero.base = base
		table.insert(heroes, hero)
		getHeroByIndex(index + 1)
	end
	getHeroByIndex(1)
	return heroes
end

local function fillExcavMsg(msg)
	local stageid = -1
	if msg._oppo_type == "monster" then
		stageid = ed.lookupDataTable("ExcavateWildEnemy", "Stage ID", msg._oppo_userid)[1]
		local monsters = getStageEnemyData({
			id = stageid,
			dynas = msg._oppo_dyna_start or {}
		})
		msg._oppo_heroes = {}
		msg._oppo_dyna_start = {}
		for i, monster in ipairs(monsters) do
			table.insert(msg._oppo_heroes, monster.base)
			table.insert(msg._oppo_dyna_start, monster.dyna)
		end
	end
	return stageid
end

local paraseMode = function(arg)
	if not arg then
		return
	end
	if string.find(arg, "stage") then
		return "stage"
	end
	if string.find(arg, "tbc") then
		return "tbc"
	end
	if string.find(arg, "guild") then
		return "guild"
	end
	if string.find(arg, "excav") then
		return "excav"
	end
end

function getMsg(arg)
	local msg = require(arg)
	local mode = paraseMode(arg)
	return msg, mode
end

function enterBattle(msg, mode)
	if not msg then
		return
	end
	if not mode then
		return
	end
	do_battle_log = true
	ed.srand(msg._rseed)
	if mode == "guild" then
		enterGuildInstance(msg)
		ed.engine:setOperationList(msg._oprations)
	elseif mode == "stage" then
		local stage = ed.lookupDataTable("Stage", nil, msg._stageid)
		ed.engine:enterStage(stage, msg._heroes)
		ed.engine:setOperationList(msg._oprations)
	elseif mode == "tbc" then
		local oppo_bot = msg._oppo_robot and msg._oppo_robot > 0
		local self_dyna, oppo_dyna = getDynaData(msg)
		ed.engine:enterCrusade(msg._self_heroes, msg._oppo_heroes, oppo_bot, self_dyna, oppo_dyna, -1)
		ed.engine:setOperationList(msg._oprations)
	elseif mode == "excav" then
		local stageid = fillExcavMsg(msg)
		local oppo_bot = msg._oppo_type == "monster"
		ed.engine:enterExcavate(msg._self_heroes, msg._oppo_heroes, oppo_bot, msg._self_dyna_start, msg._oppo_dyna_start, stageid)
		ed.engine:setOperationList(msg._oprations)
	elseif mode == "arena" then
		local self_bot = msg._self_robot and 0 < msg._self_robot
		local oppo_bot = msg._oppo_robot and msg._oppo_robot > 0
		ed.engine:enterArena(msg._self_heroes, msg._oppo_heroes, self_bot, oppo_bot)
	end
	if ed.run_with_scene then
		local stage = ed.lookupDataTable("Stage", nil, -1)
		local battle = ed.lookupDataTable("Battle", nil, -1, 1)
		ed.scene:reset(stage, battle, {})
		ed.pushScene(ed.scene)
	end
end

function endBattle()
	local battleLog = getBtlog()
	local folder = "btlog"
	local path = string.format("%s/%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"))
	local file = io.open(path, "w")
	if file then
		file:write(battleLog)
		file:close()
	end
	print("bot over")
end

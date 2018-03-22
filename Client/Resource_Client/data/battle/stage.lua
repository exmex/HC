local ed = ed

local function monsterAddBuff(bid)
	return function(engine)
		local info = ed.getDataTable("Buff")[bid]
		for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
			monster:addBuff(info, monster)
		end
	end
end

local function checkHeroGender(gender)
	return function(engine)
		for hero in engine:foreachAliveUnit(ed.emCampPlayer) do
			if hero.info.Gender ~= gender then
				if ed.run_with_scene then
					EDDebug("Hero gender not allowed!")
				else
					engine:exitStage(0)
				end
			end
		end
	end
end

local function monsterResetPosAndBuff(name, posX, posY)
	return function(engine)
		for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
			local binfo = ed.lookupDataTable("Buff", nil, "unheal")
			monster:addBuff(binfo, monster)
			if monster.tid == name then
				monster.position = {
					ed.engine.stage_rect.maxX - posX,
					posY
				}
				local binfo = ed.lookupDataTable("Buff", nil, "Building_boss")
				monster:addBuff(binfo, monster)
			end
		end
	end
end

local scripts = {
	[1] = {
		[2] = function(engine)
			local dr = engine:findHero("DR")
			if dr then
				dr:setMP(dr.mp + 150)
			end
		end,
		[3] = function(engine)
			engine:findBoss().ai.will_cast_manual_skill = false
		end
	},
	[2] = {
		[2] = function(engine)
			local dr = engine:findHero("DR")
			if dr then
				dr:setMP(dr.mp + 150)
			end
		end
	},
	[3] = {
		[2] = function(engine)
			local dr = engine:findHero("DR")
			if dr then
				dr:setMP(dr.mp + 150)
			end
		end
	},
	[6] = {
		[3] = function(engine)
			engine:findBoss().mp = 800
		end
	},
	[7] = {
		[3] = function(engine)
			engine:findBoss().mp = 950
		end
	},
	[23] = {
		[3] = function(engine)
			engine:findBoss().mp = 800
		end
	},
	[20003] = {
		[1] = monsterAddBuff("PIMU"),
		[2] = monsterAddBuff("PIMU"),
		[3] = monsterAddBuff("PIMU")
	},
	[21003] = {
		[1] = monsterAddBuff("PIMU"),
		[2] = monsterAddBuff("PIMU"),
		[3] = monsterAddBuff("PIMU")
	},
	[22003] = {
		[1] = monsterAddBuff("PIMU"),
		[2] = monsterAddBuff("PIMU"),
		[3] = monsterAddBuff("PIMU")
	},
	[23003] = {
		[1] = monsterAddBuff("PIMU"),
		[2] = monsterAddBuff("PIMU"),
		[3] = monsterAddBuff("PIMU")
	},
	[20004] = {
		[1] = monsterAddBuff("MIMU"),
		[2] = monsterAddBuff("MIMU"),
		[3] = monsterAddBuff("MIMU")
	},
	[21004] = {
		[1] = monsterAddBuff("MIMU"),
		[2] = monsterAddBuff("MIMU"),
		[3] = monsterAddBuff("MIMU")
	},
	[22004] = {
		[1] = monsterAddBuff("MIMU"),
		[2] = monsterAddBuff("MIMU"),
		[3] = monsterAddBuff("MIMU")
	},
	[23004] = {
		[1] = monsterAddBuff("MIMU"),
		[2] = monsterAddBuff("MIMU"),
		[3] = monsterAddBuff("MIMU")
	},
	[20005] = {
		[1] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[2] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[3] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE")))
	},
	[21005] = {
		[1] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[2] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[3] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE")))
	},
	[22005] = {
		[1] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[2] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[3] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE")))
	},
	[23005] = {
		[1] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[2] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE"))),
		[3] = checkHeroGender(T(LSTR("ACTSTAGEGROUP.FEMALE")))
	},
	[40021] = {
		[3] = monsterResetPosAndBuff(135, 95, -70)
	},
	[40049] = {
		[3] = monsterResetPosAndBuff(141, 169, -50)
	},
	[40055] = {
		[3] = monsterResetPosAndBuff(142, 70, -40)
	}
}

local function addBuffForGuildStage(bid)
	if ed.engine.guildInstance_mode then
		local script = monsterAddBuff(bid)
		if script then
			script(ed.engine)
		end
	end
end

local function getStageScript(stageid, waveid)
	addBuffForGuildStage("unheal")
	if scripts[stageid] then
		return scripts[stageid][waveid]
	end
end
ed.getStageScript = getStageScript

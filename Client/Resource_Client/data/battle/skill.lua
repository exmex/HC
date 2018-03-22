local ed = ed
local class = {
	mt = {}
}
ed.Skill = class
class.mt.__index = class

local function getSkillInfo(group, level)
	local skill_info = ed.lookupDataTable("Skill", nil, group["Skill Group ID"], 0)
	skill_info.groupId = group["Skill Group ID"]
	setmetatable(skill_info, {__index = group})
	local buff_info
	if 0 < skill_info["Buff ID"] then
		buff_info = ed.lookupDataTable("Buff", nil, skill_info["Buff ID"])
	end
	local skill_patch = {}
	local buff_patch = {}
	local index = 1
	while true do
		local field = group["Growth " .. index .. " Field"]
		if field then
			local growth = (level - 1) * group["Growth " .. index .. " Value"]
			if skill_info[field] then
				skill_patch[field] = skill_info[field] + growth
			elseif buff_info[field] then
				buff_patch[field] = buff_info[field] + growth
			end
			index = index + 1
		else
			break
		end
	end
	setmetatable(skill_patch, {__index = skill_info})
	skill_info = skill_patch
	if buff_info then
		setmetatable(buff_patch, {__index = buff_info})
		skill_info.buff_info = buff_patch
	end
	return skill_info
end
class.getSkillInfo = getSkillInfo

local function SkillCreate(info, caster, level)
	local self = {
		info = info,
		caster = caster,
		level = level,
		phase_list = {},
		max_range_sq = info["Max Range"] ^ 2,
		min_range_sq = info["Min Range"] ^ 2,
		cd_remaining = info["Init CD"] or 0,
		casting = false,
		target = nil,
		current_phase_idx = 0,
		current_phase = nil,
		current_phase_elapsed = 0,
		next_event_idx = 0,
		next_event = nil,
		attack_counter = 0,
		can_cast = false,
		can_cast_tick = -1,
		is_update = true
	}
	setmetatable(self, class.mt)
	if self.max_range_sq == 0 then
		self.max_range_sq = math.huge
	end
	local puppet_name = caster.info.Puppet
	self:rebuildPhaseList(puppet_name)
	local target_type = self.info["Target Type"]
	if target_type == "self" then
		self.info["Target Camp"] = 0
	elseif target_type == "target" then
		self.info["Target Camp"] = -1
	end
	self.target_selectors = {
		random = ed.rand,
		weakest = function(unit)
			return -unit.hp / unit.attribs.HP
		end,
		strongest = function(unit)
			return unit.hp
		end,
		nearest = function(unit)
			return -ed.edpDistanceSQ(unit.position, self.caster.position)
		end,
		farthest = function(unit)
			return ed.edpDistanceSQ(unit.position, self.caster.position)
		end,
		maxmp = function(unit)
			return unit.mp % 1000
		end,
		minmp = function(unit)
			return -unit.mp % 1000
		end,
		maxint = function(unit)
			return unit.attribs.INT
		end,
		minhp = function(unit)
			return -unit.hp
		end
	}
	return self
end
class.create = SkillCreate
ed.SkillCreate = SkillCreate

local display = function(self)
	return self.info["Display Name"] or self.info["Skill Name"]
end
class.display = display

local function rebuildPhaseList(self, puppet)
	self.phase_list = {}
	local anim_name_list = self.info["Action(s)"]
	for i = 1, #anim_name_list do
		local anim_name = anim_name_list[i]
		local resourceName = ed.lookupDataTable("Puppet", "Resource", puppet)
		if nil == resourceName then
			print("nil resourceName in table Puppet puppet -> " .. puppet)
		end
		resourceName = resourceName .. ".cha"
		local duration = ed.lookupDataTable("AnimDuration", "Duration", resourceName, anim_name)
		local events = ed.lookupDataTable("AnimAtkFrame", nil, resourceName, anim_name)
		if events then
			local event_list = {}
			for k, v in pairs(events) do
				table.insert(event_list, v)
				v.Type = "Attack"
			end
			table.sort(event_list, function(a, b)
				return a.Time < b.Time
			end)
			local phase = {
				action_name = anim_name,
				duration = duration,
				event_list = event_list
			}
			table.insert(self.phase_list, phase)
		end
	end
end
class.rebuildPhaseList = rebuildPhaseList

local getDurationFromAttackFrameToEndByIndex = function(self, phaseIndex, eventIndex)
	local isRet = false
	local time
	local phase = self.phase_list[phaseIndex]
	if phase then
		local duration = phase.duration
		local event = phase[eventIndex]
		if event then
			local eventTime = event.Time
			time = duration - eventTime
			isRet = true
		end
	end
	return isRet, time
end
class.getDurationFromAttackFrameToEndByIndex = getDurationFromAttackFrameToEndByIndex

local getDurationFromAttackFrameToEnd = function(self, phase, event)
	local isRet = false
	local time
	if phase and event then
		local duration = phase.duration
		local eventTime = event.Time
		time = duration - eventTime
		isRet = true
	end
	return isRet, time
end
class.getDurationFromAttackFrameToEnd = getDurationFromAttackFrameToEnd

local target_selector = function(self)
	return self.target_selectors[self.info["Target Type"]]
end
class.target_selector = target_selector

local affectedCamp = function(self)
	return self.caster.foecamp * self.info["Affected Camp"] * -1
end
class.affectedCamp = affectedCamp

local targetCamp = function(self)
	return self.caster.foecamp * self.info["Target Camp"] * -1
end
class.targetCamp = targetCamp

local reset = function(self)
	self.cd_remaining = self.info["Init CD"] or 0
	self.casting = false
	self.target = nil
	self.current_phase_idx = 0
	self.current_phase = nil
	self.current_phase_elapsed = 0
	self.next_event_idx = 0
	self.next_event = nil
	self.attack_counter = 0
end
class.reset = reset

local pause = function(self)
	self.is_update = false
end
class.pause = pause

local resume = function(self)
	self.is_update = true
end
class.resume = resume

local update = function(self, dt_action, dt_cd)
	if self.casting and self == self.caster.current_skill then
		local time = self.current_phase_elapsed + dt_action
		self.current_phase_elapsed = time
		local next_event = self.next_event
		while next_event and time > next_event.Time do
			if next_event.Type == "Attack" then
				self:onAttackFrame()
			end
			local idx = self.next_event_idx + 1
			next_event = self.current_phase.event_list[idx]
			self.next_event_idx = idx
			self.next_event = next_event
		end
	else
		self.cd_remaining = self.cd_remaining - dt_cd
	end
end
class.update = update

local gotoEventIdx = function(self, idx)
	local event = self.current_phase.event_list[idx]
	self.next_event_idx = idx + 1
	self.next_event = self.current_phase.event_list[idx + 1]
	self.current_phase_elapsed = event.Time
	local actor = self.caster.actor
	if actor then
		actor.puppet:setActionElapsed(self.current_phase_elapsed)
	end
end
class.gotoEventIdx = gotoEventIdx

local function canCastWithTarget(self, target)
	if self.can_cast_tick == ed.engine.ticks then
		return self.can_cast, "same tick"
	end
	self.can_cast_tick = ed.engine.ticks
	local info = self.info
	local caster = self.caster
	self.can_cast = false
	if info["Cost MP"] > caster.mp then
		return false, "mp"
	end
	if self.cd_remaining > 0 then
		return false, "cd"
	end
	if caster.buff_effects.stun then
		return false, "stun"
	end
	if self.info["Damage Type"] == "AD" and caster.buff_effects.disarm then
		return false, "disarm"
	end
	if self.info["Damage Type"] ~= "AD" and caster.buff_effects.silence then
		return false, "silence"
	end
	if self:target_selector() then
		target = self:selectTarget(target)
	end
	if not target then
		return false, "no target"
	end
	if target.buff_effects.untargetable then
		return false, "untargetable"
	end
	if 0 > target.camp * self:targetCamp() then
		return false, "target camp"
	end
	local distanceSQ = ed.edpDistanceSQ(target.position, self.caster.position)
	if distanceSQ > self.max_range_sq then
		return false, "too far"
	end
	if distanceSQ < self.min_range_sq then
		return false, "too near"
	end
	if not info["Outside Screen"] and caster:isOutOfStage() then
		return false, "outside stage"
	end
	self.can_cast = true
	return true
end
class.canCastWithTarget = canCastWithTarget

local willCast = function(self)
	return true
end
class.willCast = willCast

local canTrigger = function(self)
	return false
end
class.canTrigger = canTrigger

local start = function(self, target)
	local info = self.info
	if do_battle_log then
		btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
	end
	self.target = target
	self:selectTarget(target)
	self.cd_remaining = info.CD
	self.casting = true
	self.attack_counter = 0
	self:startPhase(1)
	self.is_update = true
	local caster = self.caster
	caster.global_cd = info["Global CD"]
	caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
	if caster.actor then
		local effect_name = info["Launch Effect"]
		if effect_name then
			caster.actor:addEffect(effect_name, -1)
		end
	end
end
class.start = start

local function selectTarget(self, default)
	local target_type = self.info["Target Type"]
	local selector = self:target_selector()
	if target_type == "target" then
		if default then
			self.target = default
		else
			local t, distanceSQ = self.caster.ai:searchTarget()
			if distanceSQ <= self.max_range_sq then
				self.target = t
			else
				self.target = nil
			end
		end
	elseif target_type == "self" then
		self.target = self.caster
	elseif selector then
		local max = -math.huge
		local chosen
		local caster = self.caster
		local caster_position = caster.position
		local enchanted = caster.buff_effects.enchanted
		for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
			if unit.buff_effects.untargetable then
			elseif enchanted and unit == caster then
			else
				local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
				if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
					local v = selector(unit)
					if max < v then
						max = v
						chosen = unit
					end
				end
			end
		end
		self.target = chosen
	else
		EDDebug("Unkonwn target type: " .. target_type)
	end
	return self.target
end
class.selectTarget = selectTarget

local function finish(self)
	if self.caster.manually_casting then
		ed.engine:unfreeze()
		self.caster.manually_casting = false
	end
	self.casting = false
	self.caster.current_skill = nil
	self.caster:idle()
end
class.finish = finish

local interrupt = function(self)
	if self.attack_counter == 0 then
		local info = self.info
		self.cd_remaining = info.CD * 0.5
		self.caster.global_cd = info["Global CD"] * 0.5
	end
	self:finish()
end
class.interrupt = interrupt

local startPhase = function(self, idx)
	local phase = self.phase_list[idx]
	if phase then
		self.current_phase_idx = idx
		self.current_phase = phase
		self.current_phase_elapsed = 0
		self.next_event_idx = 1
		self.next_event = phase.event_list[1]
		self.caster:setAction(phase.action_name, false, true)
	end
end
class.startPhase = startPhase

local function onAttackFrame(self)
	if self.caster.manually_casting then
		ed.engine:unfreeze()
		self.caster.manually_casting = false
	end
	self.attack_counter = self.attack_counter + 1
	if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
		self:selectTarget(nil)
	end
	if not self.target then
		return
	end
	local info = self.info
	local caster = self.caster
	local ttype = info["Track Type"]
	if ttype == "projectile" then
		local projectile = self:createProjectile()
		ed.engine:addProjectile(projectile)
	elseif ttype == "chain" then
		local chain = self:createChain()
		ed.engine:addChain(chain)
	elseif ttype == nil then
		self:takeEffectAt(self.target.position)
	else
		EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
	end
	caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
	if info["Move Forward"] ~= 0 then
		caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
	end
end
class.onAttackFrame = onAttackFrame

local function createProjectile(self)
	return ed.ProjectileCreate(self)
end
class.createProjectile = createProjectile

local function createChain(self)
	return ed.ChainCreate(self)
end
class.createChain = createChain

local function createBuff(self, target)
	return ed.BuffCreate(self.info.buff_info, target, self.caster)
end
class.createBuff = createBuff

local onPhaseFinished = function(self)
	local current_phase_idx = self.current_phase_idx
	if current_phase_idx == #self.phase_list then
		self:finish()
	else
		self:startPhase(current_phase_idx + 1)
	end
end
class.onPhaseFinished = onPhaseFinished

local testPointInShape = function(p, shape, arg1, arg2)
	if shape == "rectangle" then
		return p[1] >= 0 and arg1 >= p[1] and p[2] >= -arg2 * 0.5 and p[2] <= arg2 * 0.5
	elseif shape == "circle" then
		return p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
	elseif shape == "halfcircle" then
		return p[1] >= 0 and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
	elseif shape == "quartercircle" then
		return p[1] >= 0 and p[2] <= p[1] and p[2] >= -p[1] and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
	else
		EDDebug("Unkonwn AOE Type: '" .. shape .. "', spelling mistake?")
	end
end
class.testPointInShape = testPointInShape

local function takeEffectAt(self, location, source)
	local info = self.info
	local aoe = self.info["AOE Origin"]
	local direction = self.caster.direction
	if aoe == "self" then
		location = self.caster.position
	end
	local origin = {
		location[1] + info["X Shift"] * direction,
		location[2]
	}
	if aoe then
		local shape = info["AOE Shape"]
		local arg1 = info["Shape Arg1"]
		local arg2 = info["Shape Arg2"]
		for unit in ed.engine:foreachAliveUnit(self:affectedCamp()) do
			if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == self.caster then
			else
				local p2 = ed.edpSub(unit.position, origin)
				p2[1] = p2[1] * direction
				if testPointInShape(p2, shape, arg1, arg2) then
					self:takeEffectOn(unit)
				end
			end
		end
	else
		self:takeEffectOn(self.target, source)
	end
	if ed.run_with_scene then
		local effect_name = info["Point Effect"]
		if not effect_name then
			return
		end
		local effect_z = info["Point Zorder"] or 0
		ed.scene:playEffectOnScene(effect_name, origin, {
			self.caster.direction,
			1
		}, nil, effect_z)
	end
end
class.takeEffectAt = takeEffectAt

local power = function(self, source, target)
	local info = self.info
	local multiplier = info["Plus Ratio"]
	local base_attrib = self.caster.attribs[info["Plus Attr"]]
	local power = multiplier * base_attrib + info["Basic Num"]
	return power, 1
end
class.power = power

local getDamage = function(self, target, power, damage_type, field, source, crit_mod)
	local dmg = target:takeDamage({
		amount = power,
		damage_type = damage_type,
		field = field,
		source = source,
		crit_mod = crit_mod
	})
	return dmg
end
class.getDamage = getDamage

local function takeEffectOn(self, target, source)
	local caster = self.caster
	source = source or caster
	if not target:isAlive() or target.buff_effects.invulnerable or target.manually_casting and source.camp ~= target.camp then
		return false
	end
	local info = self.info
	local power, coefficient = self:power(source, target)
	local damage_type = info["Damage Type"]
	local affect_field = info["Affect MP"] and "mp" or "hp"
	local dmg = 0
	if damage_type == "Heal" then
		local heal = affect_field == "hp" and caster.attribs.HEAL or 0
		local power = power * (1 + heal / 100)
		if do_battle_log then
			btlog("%s: %s ++> %s (+%d)", self:display(), caster:display(), target:display(), power)
		end
		target:takeHeal(power, affect_field, caster)
	elseif damage_type then
		if damage_type == "AD" and not info["No Dodge"] then
			local dodg = math.max(0, target.attribs.DODG - caster.attribs.HIT)
			local prob = dodg / (100 + dodg)
			local dice = ed.rand()
			local hit = prob <= dice
			if not hit then
				if do_battle_log then
					btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
				end
				local color = target.camp == ed.emCampEnemy and "red" or "blue"
				if target.actor then
					ed.PopupCreate("dodge", color, target.actor, nil, "text")
				end
				return false
			end
		end
		if do_battle_log then
			btlog("%s: %s --> %s (-%d)", self:display(), caster:display(), target:display(), power)
		end
		dmg = self:getDamage(target, power, damage_type, affect_field, caster, info["CRIT%"] / 100)
		if target.buffImpactEffect and target.actor then
			local name = target.buffImpactEffect.value.ImpactEffect
			local effect_z = target.buffImpactEffect.value.ImpactEffectZorder
			target.actor:addEffect(name, effect_z)
		end
		if dmg == 0 then
			return false
		end
		if 0 < info["LFS%"] then
			local lfs = caster.attribs.LFS
			local heal = dmg * lfs / (100 + lfs + target.level) * info["LFS%"] * 0.01
			if heal > 1 then
				if do_battle_log then
					btlog("  %s leeches %d %s form %s", caster:display(), heal, affect_field, target:display())
				end
				caster:takeHeal(heal, affect_field)
			end
		end
	end
	local buff_miss = false
	if target:isAlive() and 0 < info["Buff ID"] then
		local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, self.level, target.level, target.attribs)
		if bSucess then
			target:addBuff(self:createBuff(target))
		else
			local color = target.camp == ed.emCampEnemy and "red" or "blue"
			local text = reason == "resist" and "resist" or "miss"
			if target.actor then
				ed.PopupCreate(text, color, target.actor, nil, "text")
			end
			buff_miss = true
		end
	end
	if not buff_miss and (0 < info["Knock Up"] or 0 < info["Knock Back"]) then
		local time = info["Knock Up"]
		local distance = info["Knock Back"]
		local direction = {1, 0}
		if target.position[1] == caster.position[1] and target.position[2] == caster.position[2] then
			direction = ed.edpNormalize({
				caster.direction,
				0
			})
		else
			direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
		end
		target:knockup(time, ed.edpMult(direction, distance))
	end
	local name = info["Impact Effect"]
	if name and target.actor then
		local effect_z = info["Impact Zorder"]
		target.actor:addEffect(name, effect_z)
	end
	return true, dmg
end
class.takeEffectOn = takeEffectOn

local trigger = function(self)
end
class.trigger = trigger

local function launchPoint(self)
	local event = self.next_event
	if event == nil or event.Type ~= "Attack" then
		event = {X = 0, Y = 75}
	end
	local bone_position = {
		event.X * ed.cha_scale,
		event.Y * ed.cha_scale
	}
	local caster = self.caster
	local sx, sy = caster:getRuntimeScale()
	local us = caster:getUnitScale()
	local pos = {
		caster.position[1] + bone_position[1] * sx * us,
		caster.position[2]
	}
	local h = bone_position[2] * sy * us
	return pos, h
end
class.launchPoint = launchPoint

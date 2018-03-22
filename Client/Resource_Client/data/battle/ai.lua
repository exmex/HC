local ed = ed

local function createAiForUnit(unit)
	return ed.AiCreate(unit)
end
ed.createAiForUnit = createAiForUnit


local class = {
	mt = {}
}
ed.Ai = class
class.mt.__index = class

local function AiCreate(owner)
	local self = {
		owner = owner,
		destination = nil,
		target = nil,
		will_cast_manual_skill = true
	}
	setmetatable(self, class.mt)
	return self
end
class.create = AiCreate
ed.AiCreate = AiCreate

local function update(self, dt)
	if self.owner.buff_effects.building then
		local target = self:searchTarget()
		if target then
			self.target = target
			local skill = self:findSkillToCast()
			if skill then
				if skill.info.Manual and ed.engine.arena_mode then
					self.owner:castManualSkill()
				else
					self.owner:castSkill(skill, target)
				end
			else
				self.owner:idle()
			end
		else
			self.owner:idle()
		end
	else
		local target = self:searchTarget()
		if target then
			self.target = target
			local skill = self:findSkillToCast()
			if skill then
				if skill.info.Manual and ed.engine.arena_mode then
					self.owner:castManualSkill()
				else
					self.owner:castSkill(skill, target)
				end
			else
				self:walkTo(target)
			end
		elseif self.destination then
			self.walkTo(self.destination)
		else
			self.owner:idle()
		end
	end
end
class.update = update

local function searchTarget(self)
	local minDistanSQ = math.huge
	local target
	local owner = self.owner
	local p0 = self.owner.position
	for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
		if unit ~= owner and not unit.buff_effects.untargetable then
			local p1 = unit.position
			local x = p0[1] - p1[1]
			local y = p0[2] - p1[2]
			local distanceSQ = x * x + y * y
			if minDistanSQ > distanceSQ then
				minDistanSQ = distanceSQ
				target = unit
			end
		end
	end
	return target, minDistanSQ
end
class.searchTarget = searchTarget

local findSkillToCast = function(self)
	if self.owner.global_cd > 0 then
		return nil
	end
	local list = self.owner.skill_list
	for i = 1, #list do
		local skill = list[i]
		if skill.is_update and (self.will_cast_manual_skill or not skill.info.Manual) then
			local cast, reason = skill:canCastWithTarget(self.target, true)
			if cast and skill:willCast() then
				return skill
			end
		else
		end
	end
	return nil
end
class.findSkillToCast = findSkillToCast

local function walkTo(self, dest)
	if dest.position then
		dest = dest.position
	end
	local owner = self.owner
	local distanceSQ = ed.edpDistanceSQ(dest, owner.position)
	if not (distanceSQ <= owner.attack_range ^ 2) or owner:isOutOfStage() then
	else
		owner:idle()
		return
	end
	owner:walkTowards(dest)
end
class.walkTo = walkTo


local class = {
	mt = {}
}
ed.AiHealer = class
class.mt.__index = class
local base = ed.Ai
setmetatable(class, base.mt)

local function AiHealerCreate(owner)
	local self = base.create(owner)
	setmetatable(self, class.mt)
	return self
end
class.create = AiHealerCreate
ed.AiHealerCreate = AiHealerCreate

local update = function(self, dt)
	local heal_target = self:searchHealTarget()
	if heal_target then
		self.target = heal_target
		local skill = self:findSkillToCast()
		if skill then
			self.owner:castSkill(skill, heal_target)
			return
		end
	end
	local attack_target = self:searchTarget()
	if attack_target then
		self.target = attack_target
		local skill = self:findSkillToCast()
		if skill then
			self.owner:castSkill(skill, attack_target)
			return
		end
	end
	if heal_target then
		self.target = heal_target
		self:walkTo(heal_target)
	elseif attack_target then
		self.target = attack_target
		self:walkTo(attack_target)
	else
		self.owner:idle()
	end
end
class.update = update

local function searchHealTarget(self)
	local weakest
	local lowestHpPercent = 1
	for unit in ed.engine:foreachAliveUnit(self.owner.camp) do
		local percent = unit.hp / unit.info["Max HP"]
		if lowestHpPercent > percent then
			weakest = unit
			lowestHpPercent = percent
		end
	end
	return weakest
end
class.searchHealTarget = searchHealTarget

local ed = ed
local class = {
	mt = {}
}
ed.Buff = class
class.mt.__index = class

local function BuffCreate(info, owner, caster)
	local self = {
		name = info.Name,
		info = info,
		timer = info.Time > 0 and info.Time or nil,
		owner = owner,
		caster = caster,
		caster_attribs = caster and caster.attribs or nil,
		shield = 0 < info["Shield Value"] and info["Shield Value"] or nil,
		clearOnDeathFlag = info["Clear On Death "],
		impactEffect = info["Impact Effect"],
		impactEffectZorder = info["Impact Effect Zorder"],
		class = class
	}
	if owner.config.hp_mod and self.shield then
		local shield_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or owner.config.hp_mod
		self.shield = self.shield * shield_mod
	end
	setmetatable(self, class.mt)
	return self
end
ed.BuffCreate = BuffCreate

class.create = create
local min = math.min

local function update(self, dt)
	local hpr = self.info.HPR * dt
	if hpr < 0 then
		local damage = min(-hpr, self.owner.hp)
		damage = damage * self.owner.dPSStatisticsRatio
		self.caster.dmg_statistics = self.caster.dmg_statistics + damage
	end
	if self.timer then
		self.timer = self.timer - dt
		if 0 > self.timer then
			self.owner:removeBuff(self)
		end
	end
end
class.update = update

local effect_inclusions = {
	frozen = {"stun"},
	stun = {
		"immoblilize",
		"silence",
		"disarm",
		"disableAI"
	},
	immoblilize = {},
	silence = {},
	disarm = {},
	disableAI = {},
	imprisonment = {
		"stun",
		"untargetable",
		"invulnerable"
	},
	untargetable = {},
	invulnerable = {},
	uncontrollable = {},
	enchanted = {},
	building = {"stable", "fix"},
	stable = {},
	fix = {},
	unheal = {},
	noHPR = {}
}

local negative_effects = {
	frozen = true,
	stun = true,
	immoblilize = true,
	silence = true,
	disarm = true,
	imprisonment = true,
	enchanted = true
}

local function apply(self)
	local info = self.info
	local attribs = self.owner.attribs
	for _, name in ipairs(ed.attrib_names) do
		local inc = info[name] or 0
		local x = info[name .. ".x"]
		if x then
			local a = info[name .. ".a"]
			inc = inc + self.caster_attribs[x] * a
		end
		if inc ~= 0 then
			attribs[name] = attribs[name] + inc
		end
	end
	local buff_effects = self.owner.buff_effects
	for i, effect in ipairs(info["Control Effects"]) do
		self:applyEffect(effect)
	end
end
class.apply = apply

local function isCrlEftConflictWithUncontrollable(self)
	local isRet = false
	local info = self.info
	for i, effect in ipairs(info["Control Effects"]) do
		if negative_effects[effect] then
			isRet = true
			break
		end
	end
	return isRet
end
class.isCrlEftConflictWithUncontrollable = isCrlEftConflictWithUncontrollable

local isHasUnControllableEffect = function(self)
	local isRet = false
	local info = self.info
	for i, effect in ipairs(info["Control Effects"]) do
		if effect == "uncontrollable" then
			isRet = true
			break
		end
	end
	return isRet
end
class.isHasUnControllableEffect = isHasUnControllableEffect

local function applyEffect(self, effect)
	local buff_effects = self.owner.buff_effects
	if buff_effects.uncontrollable and negative_effects[effect] then
		return
	end
	if buff_effects[effect] then
		return
	end
	buff_effects[effect] = true
	for i, name in ipairs(effect_inclusions[effect]) do
		self:applyEffect(name)
	end
	if effect == "uncontrollable" then
		for k, v in pairs(negative_effects) do
			buff_effects[k] = nil
		end
	end
end
class.applyEffect = applyEffect

local onAddedServer = function(self)
	local info = self.info
	local owner = self.owner
	if info.Puppet then
		self.puppet_id = owner:pushPuppet(info.Puppet)
	end
	if do_battle_log then
		btlog("    %s got buff:%s (%.1fs)", self.owner.info.Name, self.info.Name, self.info.Time or "nil")
	end
end
class.onAddedServer = onAddedServer

local function onAddedClient(self)
	local owner = self.owner
	local actor = owner.actor
	if actor then
		local info = self.info
		if info.Effect then
			self.effect_id = actor:addEffect(info.Effect, info["Effect Zorder"])
		end
		if info.Shader then
			self.shader_id = actor:pushShader(info.Shader)
		end
		local color, str
		if info.AD > 0 or 0 < info["AD.a"] then
			str = "inc_attack"
			color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
		elseif info.AD < 0 or 0 > info["AD.a"] then
			str = "dec_attack"
			color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
		end
		if 0 < info.ARM or 0 < info["ARM.a"] then
			str = "inc_armor"
			color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
		elseif 0 > info.ARM or 0 > info["ARM.a"] then
			str = "dec_armor"
			color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
		end
		if 0 < info.HAST or 0 < info["HAST.a"] then
			str = "haste"
			color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
		elseif 0 > info.HAST or 0 > info["HAST.a"] then
			str = "slow"
			color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
		end
		if info["Popup Text"] then
			str = info["Popup Text"]
			color = self.caster.camp == ed.emCampPlayer and "blue" or "red"
		end
		if str and color then
			ed.PopupCreate(str, color, self.owner.actor, nil, "text")
		end
	end
end
class.onAddedClient = onAddedClient

local onRemoved = function(self)
	if do_battle_log then
		btlog("%s lost buff:%s", self.owner.info.Name, self.info.Name)
	end
	if self.puppet_id then
		self.owner:removePuppet(self.puppet_id)
	end
	local actor = self.owner.actor
	if actor then
		local info = self.info
		if self.effect_id then
			actor.puppet:removeEffectWithID(self.effect_id)
		end
		if self.shader_id then
			actor:removeShader(self.shader_id)
			self.shader_id = nil
		end
	end
end
class.onRemoved = onRemoved

local removeEffectAndShader = function(self)
	local actor = self.owner.actor
	if actor then
		local info = self.info
		if self.effect_id then
			actor.puppet:removeEffectWithID(self.effect_id)
			self.effect_id = nil
		end
		if self.shader_id then
			actor:removeShader(self.shader_id)
			self.shader_id = nil
		end
	end
end
class.removeEffectAndShader = removeEffectAndShader

local function onDamaged(self, damage, damage_type)
	local info = self.info
	local owner = self.owner
	if self.shield then
		local block = false
		local stype = info["Shield Type"]
		if stype == damage_type or stype == "all" then
			self.shield = self.shield - damage
			if self.shield < 0 then
				self.owner:removeBuff(self)
				return -self.shield
			end
			if owner.actor then
				local color = owner.camp == ed.emCampPlayer and "blue" or "red"
				local str = {
					AD = "physical_immune",
					AP = "magic_immune",
					all = "immune"
				}
				ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
			end
			return 0
		end
	end
	return damage
end
class.onDamaged = onDamaged

local function checkResistAttribute(buffInfo, attribs)
	if not attribs then
		return true
	end
	local attribName = buffInfo["Resist Attribute"]
	if attribName and attribs[attribName] then
		local randValue = ed.rand()
		if randValue < attribs[attribName] / 100 then
			return false, "resist"
		end
	end
	return true
end

local function checkLevel(buffInfo, skillLevel, targetLevel)
	if ed.rand() < 0.3 then
		return true
	end
	local dice = buffInfo["Level Check Dice"]
	if dice == 0 then
		return true
	end
	if skillLevel < 30 then
		skillLevel = 10 + skillLevel / 30 * 20
	end
	dice = dice * ed.rand()
	local pass = targetLevel <= skillLevel + dice
	return pass
end

local function checkAddBuff(buffInfo, skillLevel, targetLevel, attribs)
	local levelPass = checkLevel(buffInfo, skillLevel, targetLevel)
	if not levelPass then
		return false
	end
	return checkResistAttribute(buffInfo, attribs)
end
class.checkAddBuff = checkAddBuff

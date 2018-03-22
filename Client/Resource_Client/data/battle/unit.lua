require("ui/parameter/parameter")

local ed = ed
local class = {
	mt = {}
}
ed.Unit = class
class.mt.__index = class
local base = ed.Entity
setmetatable(class, base.mt)

local state_to_string = {
	[ed.emUnitState_Idle] = "Idle",
	[ed.emUnitState_Walk] = "Walk",
	[ed.emUnitState_Attack] = "Attack",
	[ed.emUnitState_Hurt] = "Hurt",
	[ed.emUnitState_Dead] = "Dead",
	[ed.emUnitState_Birth] = "Birth",
	[ed.emUnitState_Dying] = "Dying"
}
ed.state_to_string = state_to_string

local function getUnitInfo(IDorName, level, rank)
	local uinfo = ed.getDataTable("Unit")[IDorName]
	local info = {}
	for k, v in pairs(uinfo) do
		info[k] = v
	end
	local id = info.ID
	local equipInfo = ed.lookupDataTable("hero_equip", nil, id, rank)
	info.equipInfo = equipInfo
	local rankInfo = ed.lookupDataTable("UnitRank", nil, id, rank)
	info.rankInfo = rankInfo
	local nextRankInfo = ed.lookupDataTable("UnitRank", nil, id, rank + 1)
	info.nextRankInfo = nextRankInfo
	return info
end

local isMercenary = function(self)
	return self.mercenaryData ~= nil
end
class.isMercenary = isMercenary

local setMercenaryData = function(self, data)
	self.mercenaryData = data
end
class.setMercenaryData = setMercenaryData

local getMercenaryData = function(self)
	return self.mercenaryData
end
class.getMercenaryData = getMercenaryData

local initHpMpInfo = function(self, bFinalInit)
	if self.hpmpInited then
		return
	end
	local hpPecent = 1
	local mpPecent = 0
	local dynaData = self.dynaData
	if dynaData then
		hpPecent = dynaData._hp_perc and dynaData._hp_perc / 10000 or 1
		mpPecent = dynaData._mp_perc and dynaData._mp_perc / 10000 or 0
		self.custom_data = dynaData._custom_data
	end
	self.hp = self.attribs.HP * hpPecent
	if not self.monster_idx then
		self.mp = self.attribs.MP * mpPecent
	end
	if bFinalInit then
		self.hpmpInited = true
	end
end

function dump_log(object, label, nesting, nest)
    local dump_print = CCLuaLog or print

    if type(nesting) ~= "number" then nesting = 99 end

    local lookup_table = {}
    local function _dump(object, label, indent, nest)
        if label == 'class' then
            dump_print(string.format("%s%s = %s", indent, tostring(label), object:className()..""))
            return
        end
        label = label or "<var>" 
        if type(object) ~= "table" then
            if type(object) == 'string' then
                object = string.gsub(object, '%%', '$');
            end
            dump_print(string.format("%s%s = %s", indent, tostring(label), tostring(object)..""))
        elseif lookup_table[object] then
            dump_print(string.format("%s%s = *REF*", indent, tostring(label)))
        else
            lookup_table[object] = true
            if nest > nesting then
                dump_print(string.format("%s%s = *MAX NESTING*", indent, label))
            else
                dump_print(string.format("%s%s = {", indent, tostring(label)))
                local indent2 = indent.."    " 
                for k, v in pairs(object) do
                    _dump(v, k, indent2, nest + 1)
                end
                dump_print(string.format("%s}", indent))
            end
        end
    end
    _dump(object, label, "- ", 1)
end

local function UnitCreate(proto, camp, config, extraData)
    dump_log(proto,"proto data is:");
	local self = base.create()
	self.what = "Unit"
	setmetatable(self, class.mt)
	config = config or {}
	config.hp_mod = config.hp_mod or 1
	config.dps_mod = config.dps_mod or 1
	config.size_mod = config.size_mod or 1
	config.money = config.money or 0
	self.config = config
	self.dynaData = extraData
	self.proto = proto
	self.tid = proto._tid
	self.stars = proto._stars or 1
	self.level = proto._level or 1;
	if config.estimate_rank then
		self.rank = math.floor((self.level + 9) / 10)
		self.rank_ratio = (self.level - 1) % 10 / 10
	elseif config.estimate_max_rank then
		self.rank = self:getMaxRankLevel()
		self.rank_ratio = 0
	else
		self.rank = math.floor(proto._rank or 1)
		self.rank_ratio = 0
	end
	if self.rank > 12 then
		self.rank = 12
		self.rank_ratio = 0
	end
	self.info = getUnitInfo(proto._tid, proto._level, self.rank)
	self.name = self.info.Name
	self.camp = camp or ed.emCampPlayer
	self.foecamp = -self.camp
	self.radius = self.info["Collide Radius"] * config.size_mod
	self.money = config.money
	self.equips = {}
	if config.estimate_max_rank then
		local items = ed.lookupDataTable("hero_equip", nil, self.info.ID, self.rank)
		if items then
			for index = 1, 6 do
				local eid = items["Equip" .. index .. " ID"]
				if eid and eid > 0 then
					local rl = ed.getDataTable("equip")[eid]["Level Requirement"]
					if rl <= self.level then
						local info = ed.lookupDataTable("equip", nil, eid)
						local level = ed.equipLvFromExp(eid, 2000)
						table.insert(self.equips, ed.wraptable(info, {level = level}))
					end
				end
			end
		end
	elseif not config.estimate_rank then

		for i = 1, #(proto._items or {}) do

			local item = proto._items[i]
			local id = item._item_id
			if id > 0 then
				local info = ed.lookupDataTable("equip", nil, id)
				local level = ed.equipLvFromExp(id, item._exp)
				table.insert(self.equips, ed.wraptable(info, {level = level}))
			end
		end
	end
	self.puppet_stack = {
		self.info.Puppet
	}
	self.previous_position = {0, 0}
	self.walk_v = {0, 0}
	self.state = ed.emUnitStateBase
	self.buff_effects = {}
	self.knockup_time = -1
	self.knockup_v = {0, 0}
	self.attribs = {}
	self.orig_attribs = {}
	self.hp = 0
	self.mp = 0
	self.walk_speed_multiplier = 1
	self.ai = ed.createAiForUnit(self)
	self.global_cd = 0
	self.current_skill = nil
	self.manually_casting = false
	self.action_name = nil
	self.action_loop = false
	self.action_duration = 0
	self.action_elapsed = 0
	self.speeder = 1
	self.buff_list = {}
	self.hp_low = false
	self.mp_low = false
	self.actor = nil
	self.can_cast_manual = false
	self.dmg_statistics = 0
	self.hpLayer = self.info["HP Layers"]
	self.bossIconName = self.info["Boss Portrait"]
	self.actionStageId = self.info["Period Group"]
	self.dPSStatisticsRatio = 1
	local dPSStatisticsRatio = self.info["DPS Statistics Ratio"]
	if dPSStatisticsRatio then
		self.dPSStatisticsRatio = dPSStatisticsRatio
	end
	self:initSkill()
	self:rebuild()
	initHpMpInfo(self)
	if self.info.Script then
		local init_func = require(self.info.Script)
		self = init_func(self)
	end
	self:idle()
	if self.actionStageId ~= nil then
		self:getActionStageInfo()
	end
	return self
end
class.create = UnitCreate
ed.UnitCreate = UnitCreate

local campDesc = {
	[1] = "+",
	[0] = "0",
	[-1] = "-"
}
local function display(self)
	return string.format("[%s%s]%s", campDesc[self.camp], self:isAlive() and "" or "D", self.name)
end
class.display = display

function class.mt:__tostring()
	local cdesc = string.format("%.1f", self.global_cd or 0)
	for i, skill in ipairs(self.skill_list or {}) do
		cdesc = string.format("%s|%.1f", cdesc, skill.cd_remaining)
	end
	return string.format("%s*%dL%d\tHP:%d/%d\tMP:%d\t(%d, %d)\t%s\t@%s:%.1f [%s] %s%s%s%s%s%s\n", self:display(), self.stars or 0, self.level or 0, self.hp or 0, self.attribs.HP or 0, self.mp or 0, self.position[1], self.position[2], state_to_string[self.state] or "nil", self.action_name or "nil", self.action_elapsed or 0, cdesc, self.buff_effects.silence and "S" or "", self.buff_effects.disarm and "D" or "", self.buff_effects.immoblilize and "I" or "", self.buff_effects.building and "B" or "", self.buff_effects.stable and "ST" or "", self.buff_effects.fix and "F" or "")
end

local attrib_names = {
	"STR",
	"INT",
	"AGI",
	"HP",
	"MP",
	"AD",
	"AP",
	"ARM",
	"MR",
	"CRIT",
	"MCRIT",
	"HPS",
	"MPS",
	"HIT",
	"DODG",
	"ARMP",
	"MRI",
	"LFS",
	"CDR",
	"HEAL",
	"HPR",
	"MPR",
	"HAST",
	"MSPD",
	"PDM",
	"TDM",
	"PIMU",
	"MIMU",
	"SKL",
	"SILR"
}
ed.attrib_names = attrib_names

local attrib_trans = {
	STR = {HP = 18, ARM = 0.15},
	INT = {AP = 2.4, MR = 0.1},
	AGI = {
		AD = 0.4,
		CRIT = 0.4,
		ARM = 0.08
	}
}

local attrib_gs = {
	STR = 0,
	INT = 0,
	AGI = 0,
	HP = 4,
	MP = 0,
	AD = 60,
	AP = 30,
	ARM = 200,
	MR = 200,
	CRIT = 125,
	MCRIT = 125,
	HPS = 6,
	MPS = 15,
	DODG = 100,
	HIT = 200,
	ARMP = 400,
	MRI = 400,
	LFS = 60,
	CDR = 125,
	HEAL = 300,
	SKL = 2000,
	SILR = 150
}

local monster_attribs = {
	"HP",
	"AD",
	"AP",
	"ARM",
	"MR",
	"CRIT",
	"MCRIT"
}

local calculateSKLAttri = function(self)
	local SKL = 0
	local name = "SKL"
	local info = self.info
	local rankInfo = info.rankInfo
	local field = name
	if self.config.estimate_rank then
		field = "E." .. name
	end
	SKL = rankInfo and rankInfo[field] or 0
	local equips = self.equips
	for i = 1, #equips do
		local info = equips[i]
		local lv = info.level
		local value = (info[name] or 0) + (info["+" .. name] or 0) * lv
		SKL = SKL + value
	end
	return SKL
end

local function initSkill(self)
	self.manual_skill = nil
	self.skill_list = {}
	self.passive_skill_list = {}
	self.aura_skill_list = {}
	self.effect_enemy_aura_skill_list = {}
	self.skills = {}
	self.attack_range = 0
	local config = self.config
	local info = self.info
	local skill_list = self.skill_list
	local skills = self.skills
	local uid = self.info.ID
	local SKL = calculateSKLAttri(self)
	for slot, group in pairs(ed.getDataTable("SkillGroup")[uid]) do
		local unlock = group.Unlock
		if config.is_monster then
			unlock = group["Unlock For Monster"]
		end
		if unlock > self.rank then
		else
			local skill_level = 0
			if config.estimate_max_rank then
				skill_level = math.floor(self.level)
			elseif config.estimate_skill then
				skill_level = math.floor(self.level)
			elseif self.proto._skill_levels then
				skill_level = (self.proto._skill_levels[slot] or 0) + SKL
			end
			if group["Skill Group ID"] == info["Basic Skill"] then
				skill_level = 1
			end
			if skill_level <= 0 then
			else
				local skill_info = ed.Skill.getSkillInfo(group, skill_level)
				local active_type = skill_info["Active Type"]
				if active_type == "active" then
					local skill = ed.SkillCreate(skill_info, self, skill_level)
					table.insert(skill_list, skill)
					skills[skill.info["Skill Group ID"]] = skill
					skills[skill.info["Skill Name"]] = skill
					if skill_info.Manual then
						self.manual_skill = skill
					end
				elseif active_type == "passive" then
					table.insert(self.passive_skill_list, skill_info)
				elseif active_type == "aura" then
					table.insert(self.aura_skill_list, skill_info)
				elseif active_type == "negative_aura" then
					table.insert(self.effect_enemy_aura_skill_list, skill_info)
				end
			end
		end
	end
	local basic_skill = skills[info["Basic Skill"]]
	self.basic_skill = basic_skill
	self.attack_range = basic_skill.info["Max Range"] - 5
	table.sort(skill_list, function(a, b)
		if a.info.Priority == b.info.Priority and a ~= b then
			print(T("%s:%d %d has the same priority", self.info.Name, a.info.Slot, b.info.Slot))
			EDDebug()
		end
		return a.info.Priority > b.info.Priority
	end)
end
class.initSkill = initSkill

local function rebuild(self)
	self.attribs = {}
	local attribs = self.attribs
	local orig = self.orig_attribs
	local info = self.info
	local level = self.level
	local rankInfo = info.rankInfo
	local nextInfo = info.nextRankInfo
	local ratio = self.rank_ratio
	local stars = self.stars
	local estimate_rank = self.config.estimate_rank
	for _, name in ipairs(attrib_names) do
		local growth = info["+" .. name .. stars] or 0
		local value = (info[name] or 0) + growth * level
		local field = name
		if estimate_rank then
			field = "E." .. name
		end
		local rankValue = rankInfo and rankInfo[field] or 0
		local nextValue = nextInfo and nextInfo[field] or rankValue
		value = value + rankValue * (1 - ratio) + nextValue * ratio
		attribs[name] = value
		orig[name] = value
	end
	attribs.PDM = 1
	attribs.TDM = 1
	if stars > 1 and info["Unit Type"] == "Monster" then
		for _, v in ipairs(monster_attribs) do
			local value = attribs[v]
			value = value * (0.875 + 0.125 * stars)
			attribs[v] = value
			orig[v] = value
		end
	end
	local equips = self.equips
	for i = 1, #equips do
		local info = equips[i]
		local lv = info.level
		for _, name in ipairs(attrib_names) do
			local value = (info[name] or 0) + (info["+" .. name] or 0) * lv
			attribs[name] = attribs[name] + value
		end
	end
	for _, skill_info in ipairs(self.passive_skill_list) do
		local aname = skill_info["Passive Attr"]
		local num = skill_info["Basic Num"]
		attribs[aname] = attribs[aname] + num
	end
	if ed.engine.enabled then
		for unit in ed.engine:foreachAliveUnit(self.camp) do
			for _, skill_info in ipairs(unit.aura_skill_list) do
				local aname = skill_info["Passive Attr"]
				local num = skill_info["Basic Num"]
				attribs[aname] = attribs[aname] + num
			end
		end
		local camp = self.camp == ed.emCampPlayer and ed.emCampEnemy or ed.emCampPlayer
		for unit in ed.engine:foreachAliveUnit(camp) do
			for _, skill_info in ipairs(unit.effect_enemy_aura_skill_list) do
				local aname = skill_info["Passive Attr"]
				local num = skill_info["Basic Num"]
				attribs[aname] = attribs[aname] + num
			end
		end
	end
	self.buff_effects = {}
	local buff_effects = self.buff_effects
	for _, buff in pairs(self.buff_list) do
		buff:apply()
	end
	if self.buff_effects.immoblilize and self.action_name == "Move" then
		self:idle()
	end
	local skill = self.current_skill
	if self.buff_effects.stun then
		self:hurt()
	elseif skill and (skill.info["Damage Type"] == "AD" and self.buff_effects.disarm or skill.info["Damage Type"] ~= "AD" and self.buff_effects.silence) then
		skill:interrupt()
	end
	self.foecamp = buff_effects.enchanted and self.camp or -self.camp
	for attr1, group in pairs(attrib_trans) do
		local value1 = attribs[attr1]
		local value2 = orig[attr1]
		for attr2, ratio in pairs(group) do
			attribs[attr2] = attribs[attr2] + value1 * ratio
			orig[attr2] = orig[attr2] + value2 * ratio
		end
	end
	attribs.HP = attribs.HP * self.config.hp_mod
	attribs.PDM = self.config.dps_mod
	if info["Main Attrib"] then
		local main = info["Main Attrib"]
		attribs.AD = attribs.AD + attribs[main]
		orig.AD = orig.AD + orig[main]
	end
	local gs = 0
	for attrib, value in pairs(attrib_gs) do
		gs = gs + attribs[attrib] * value
	end
	self.gs = gs / 100
	if self.hp > attribs.HP then
		self.hp = attribs.HP
	end
	if self.mp > attribs.MP then
		self.mp = attribs.MP
	end
end
class.rebuild = rebuild

local function getMaxRankLevel(self)
	local tmpRank = 0
	local maxRank = ed.parameter.unit_max_rank
	for rankLevel = 1, maxRank do
		local id = ed.getDataTable("Unit")[self.tid].ID
		local lvReq = ed.lookupDataTable("hero_equip", "LvReq", id, rankLevel)
		if lvReq <= self.level then
			if rankLevel < maxRank then
				tmpRank = rankLevel + 1
			else
				tmpRank = maxRank
			end
		end
	end
	return tmpRank
end
class.getMaxRankLevel = getMaxRankLevel

local function getActionStageInfo(self)
	if self.actionStageId then
		local nStage = 1
		self.actionStageInfos = {}
		while true do
			local stageData = ed.lookupDataTable("Period", nil, self.actionStageId, nStage)
			if stageData then
				table.insert(self.actionStageInfos, stageData)
				nStage = nStage + 1
			else
				break
			end
		end
	end
end
class.getActionStageInfo = getActionStageInfo

local checkActionStageValid = function(self, condtion)
	local bRet = false
	if condtion then
		local TriggerType = condtion["Trigger Type"]
		if TriggerType == "HP" then
			local conditionValue = condtion["HP Ratio"] / 100
			local hpValue = self.hp / self.attribs.HP
			if conditionValue >= hpValue then
				bRet = true
			end
		end
	end
	return bRet
end
class.checkActionStageValid = checkActionStageValid

local enterActionStageFromOneStage = function(self, nStage)
	if not self.isActionStageChangeByManual then
		local actionStage = nStage
		if self.currentActionStage and actionStage <= self.currentActionStage then
			return
		end
		if actionStage then
			self.currentActionStage = actionStage
			self:enterActionStage(self.currentActionStage)
		end
	else
		self.currentActionStage = nStage
		self:enterActionStage(nStage)
	end
end
class.enterActionStageFromOneStage = enterActionStageFromOneStage

local setActionStageChangeByManual = function(self, isByManual)
	self.isActionStageChangeByManual = isByManual
end
class.setActionStageChangeByManual = setActionStageChangeByManual

local updateActionStage = function(self)
	if self.actionStageInfos and #self.actionStageInfos > 0 then
		if self.currentActionStage == nil then
			self:enterActionStageFromOneStage(1)
		elseif not self.isActionStageChangeByManual then
			local stageNum = #self.actionStageInfos
			if stageNum > self.currentActionStage then
				local condtion = self.actionStageInfos[self.currentActionStage]
				if self:checkActionStageValid(condtion) then
					self:enterActionStageFromOneStage(self.currentActionStage + 1)
				end
			end
		end
	end
end
class.updateActionStage = updateActionStage

local function enterActionStage(self, nStage)
	if self.actionStageId then
		local stageData = ed.lookupDataTable("Period", nil, self.actionStageId, nStage)
		if stageData then
			local puppetName = stageData["Puppet ID"]
			self:rewritePuppetStack(1, puppetName)
			self:resetSkillList(stageData)
			local translationActionName = stageData["Enter Action"]
			if translationActionName and translationActionName ~= "" then
				self:setAction(translationActionName)
				self.state = ed.emUnitState_ActionTransition
			end
		end
	end
end
class.enterActionStage = enterActionStage

local getActionName = function(self, actionName)
	local newActionName = actionName
	if self.actor and self.actor.puppet then
		newActionName = self.actor:getActionName(actionName)
	end
	return newActionName
end
class.getActionName = getActionName

local function reset(self)
	if self:isAlive() then
		self.state = ed.emUnitState_Idle
	else
		self.state = ed.emUnitState_Dead
		self.hasCorpse = false
	end
	self.buff_effects = {}
	local oldai = self.ai
	self.ai.will_cast_manual_skill = oldai.will_cast_manual_skill
	self.global_cd = 0
	self.current_skill = nil
	self.manually_casting = false
	self.action_name = nil
	self.action_duration = 0
	self.action_elapsed = 0
	self.buff_list = {}
	for _, skill in ipairs(self.skill_list) do
		skill:reset()
	end
	self:rebuild()
	initHpMpInfo(self, true)
end
class.reset = reset

local resetSkillList = function(self, stageData)
	self.current_skill = nil
	self.action_name = nil
	self.action_duration = 0
	self.action_elapsed = 0
	for _, skill in ipairs(self.skill_list) do
		skill:reset()
		skill:pause()
	end
	local _normalSkillId = stageData["Basic Skill"]
	local _skillList = stageData["Skill List"]
	for _, id in ipairs(_skillList) do
		id = tonumber(id)
		for _, skill in ipairs(self.skill_list) do
			if id == skill.info.groupId then
				skill:resume()
			end
		end
	end
	local basic_skill = self.skills[_normalSkillId]
	self.basic_skill = basic_skill
	self.attack_range = basic_skill.info["Max Range"] - 5
	self:rebuild()
	self:idle()
end
class.resetSkillList = resetSkillList

local isHero = function(self)
	return self.info["Unit Type"] == "Hero" and not self.config.is_monster
end
class.isHero = isHero

local battleSupply = function(self, coefficient)
	if self.attribs.HPS > 0 then
		self:takeHeal(self.attribs.HPS)
	end
	if 0 < self.attribs.MPS then
		local mps = self.attribs.MPS * coefficient
		self:takeHeal(mps, "mp")
	end
end
class.battleSupply = battleSupply

local isHasUncontrolBufEffect = function(self)
	local isRet = false
	if self.buff_effects.uncontrollable then
		isRet = true
	end
	return isRet
end
class.isHasUncontrolBufEffect = isHasUncontrolBufEffect

local removeBuffsConlictWithUncontrol = function(self)
	local tempList = self.buff_list
	self.buff_list = {}
	for _, buff in pairs(tempList) do
		if buff:isCrlEftConflictWithUncontrollable() then
			buff:onRemoved()
		else
			table.insert(self.buff_list, buff)
		end
	end
end
class.removeBuffsConlictWithUncontrol = removeBuffsConlictWithUncontrol

local function addBuff(self, buff_Or_Binfo, caster)
	if self.state == ed.emUnitState_Dead then
		return
	end
	local buff
	if buff_Or_Binfo.class == ed.Buff then
		buff = buff_Or_Binfo
	else
		buff = ed.BuffCreate(buff_Or_Binfo, self, caster)
	end
	if self:isHasUncontrolBufEffect() then
		self:removeBuffsConlictWithUncontrol()
		if buff:isCrlEftConflictWithUncontrollable() then
			buff:onRemoved()
			return
		end
	elseif buff:isHasUnControllableEffect() then
		self:removeBuffsConlictWithUncontrol()
	end
	self.buff_list[#self.buff_list + 1] = buff
	if buff.impactEffect then
		self.buffImpactEffect = {
			name = buff.name,
			value = {
				ImpactEffect = buff.impactEffect,
				ImpactEffectZorder = buff.impactEffectZorder
			}
		}
	end
	buff:onAddedServer()
	if ed.run_with_scene then
		buff:onAddedClient()
	end
	self:rebuild()
	return buff
end
class.addBuff = addBuff

local removeBuff = function(self, buff)
	local list = self.buff_list
	for i = 1, #list do
		if list[i] == buff then
			list[i] = list[#list]
			list[#list] = nil
			break
		end
	end
	buff:onRemoved()
	if self.buffImpactEffect and buff.name == self.buffImpactEffect.name then
		self.buffImpactEffect = nil
	end
	self:rebuild()
end
class.removeBuff = removeBuff

local removeAllBuffs = function(self)
	for i, buff in ipairs(self.buff_list) do
		if self.buffImpactEffect and buff.name == self.buffImpactEffect.name then
			self.buffImpactEffect = nil
		end
		buff:onRemoved()
	end
	self.buff_list = {}
	self:rebuild()
end
class.removeAllBuffs = removeAllBuffs

local removeSignedBuffer = function(self)
	local tmpList = self.buff_list
	self.buff_list = {}
	for i, buff in ipairs(tmpList) do
		if buff.clearOnDeathFlag then
			buff:onRemoved()
		else
			table.insert(self.buff_list, buff)
		end
	end
	self:rebuild()
end
class.removeSignedBuffer = removeSignedBuffer

local function setAction(self, action_name, loop, interrupt)
	self.action_loop = loop or false
	if loop and action_name == self.action_name then
		return
	end
	self.action_name = action_name
	--DIFF
	self.action_elapsed = ( interrupt and  0 )  or math.max(0, self.action_elapsed - self.action_duration)

	if not loop and action_name ~= nil then
		local puppetName = self.puppet_stack[#self.puppet_stack]
		puppetName = ed.lookupDataTable("Puppet", "Resource", puppetName) .. ".cha"
		self.action_duration = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name)
		if not self.action_duration then
			print("nil action duration in table AnimDuration puppetName -> " .. puppetName)
			print("nil action duration in table AnimDuration action_name -> " .. action_name)
		end
	else
		self.action_duration = 0
	end
	if self.actor then
		self.actor:onStartNewAction()
	end
end
class.setAction = setAction

local getSide = function(self)
	if self.camp == 1 then
		return "left"
	end
	return "right"
end
class.getSide = getSide

local setHP = function(self, hp)
	if hp > self.attribs.HP then
		hp = self.attribs.HP
	end
	if hp < 0 then
		hp = 0
	end
	self.hp = hp
end
class.setHP = setHP

local setMP = function(self, mp)
	if mp > self.attribs.MP then
		mp = self.attribs.MP
	end
	if mp < 0 then
		mp = 0
	end
	self.mp = mp
end
class.setMP = setMP

local emUnitState_Dead = ed.emUnitState_Dead
local emUnitState_Dying = ed.emUnitState_Dying
local function isAlive(self)
	return self.state ~= emUnitState_Dead and self.state ~= emUnitState_Dying
end
class.isAlive = isAlive

local updateAi = ed.Ai.update
local function update(self, dt)
	local attribs = self.attribs
	local MSPD = attribs.MSPD
	if self.manually_casting or self.current_skill and self.current_skill.info["No Speeder"] then
		MSPD = 0
	end
	local speeder = MSPD >= 0 and (MSPD + 100) / 100 or 100 / (100 - MSPD)
	self.speeder = speeder
	local dt_action = dt * speeder
	self.dt_action = dt_action
	if self.action_name and not self.action_loop then
		local elapsed = self.action_elapsed + dt_action
		local duration = self.action_duration
		if duration > 0 and elapsed > duration then
			elapsed = elapsed - duration
			self:onActionFinished()
		end
		self.action_elapsed = elapsed
	end
	if not isAlive(self) then
		return
	end
	local movable = not self.buff_effects.immoblilize
	local pos = self.position
	local pp = self.previous_position
	pp[1] = pos[1]
	pp[2] = pos[2]
	local v1 = movable and self.walk_v or ed.edpZero
	local v2 = self.knockup_v
	local v = self.velocity
	v[1] = v1[1] + v2[1]
	v[2] = v1[2] + v2[2]
	if self.buff_effects.fix then
		if self.camp == ed.emCampPlayer then
			self.direction = 1
		else
			self.direction = -1
		end
	else
		local direction = 0
		if movable and v1[1] ~= 0 then
			direction = v1[1]
		elseif self.current_skill and self.current_skill.target then
			direction = self.current_skill.target.position[1] - pos[1]
		end
		if 0 > direction * self.direction then
			self.direction = self.direction * -1
		end
	end
	if 0 < self.knockup_time then
		self.knockup_time = self.knockup_time - dt
		if 0 >= self.knockup_time then
			self.knockup_v = {0, 0}
		end
	end
	local stage_rect = ed.engine.stage_rect
	if pos[1] > stage_rect.maxX - 50 and 0 < v[1] then
		v[1] = 0
	end
	if pos[1] < stage_rect.minX + 50 and 0 > v[1] then
		v[1] = 0
	end
	pos[1] = pos[1] + v[1] * dt_action
	pos[2] = pos[2] + v[2] * dt_action
	do
		local HAST = attribs.HAST
		local dt_cd = dt * (HAST > 0 and (100 + HAST) / 100 or 100 / (100 - HAST))
		self.global_cd = self.global_cd - dt_cd
		local skill_list = self.skill_list
		for i = 1, #skill_list do
			skill_list[i]:update(dt_action, dt_cd)
		end
	end
	if action_end and self.state == ed.emUnitState_Attack then
		self.current_skill:onPhaseFinished()
	end
	self:updateActionStage()
	local buff_effects = self.buff_effects
	local enable_ai = self.state == ed.emUnitState_Idle or self.state == ed.emUnitState_Walk
	if self.SpecialCheckEnableAi and self:SpecialCheckEnableAi() then
		enable_ai = true
	end
	enable_ai = enable_ai and not buff_effects.disableAI
	enable_ai = enable_ai and ed.engine.freeze_level == 0
	if enable_ai then
		updateAi(self.ai, dt)
	end
	local isWalking = self.state == ed.emUnitState_Walk
	local isIdle = self.state == ed.emUnitState_Idle
	local isBuilding = self.buff_effects.building
	if movable and (isWalking or isIdle) then
		local pushVelocity = 0
		local position = self.position
		local collideWith = ed.Entity.collideWith
		for unit in ed.engine:foreachAliveUnit(self.camp) do
			if self ~= unit and collideWith(self, unit) then
				local dy = position[2] - unit.position[2]
				if not isBuilding then
					pushVelocity = pushVelocity + (dy > 0 and 30 or -30)
				end
			end
		end
		if pos[2] > stage_rect.maxY and pushVelocity > 0 then
			pushVelocity = 0
		end
		if pos[2] < stage_rect.minY and pushVelocity < 0 then
			pushVelocity = 0
		end
		if pushVelocity ~= 0 then
			self.push = true
			position[2] = position[2] + pushVelocity * dt
			if isIdle then
				self:setAction("Move", true)
			end
		else
			self.push = false
			if isIdle then
				self:setAction("Idle", true)
			end
		end
	end
	for _, buff in ipairs(self.buff_list) do
		buff:update(dt)
	end
	local mp_regen = attribs.MPR
	setMP(self, self.mp + mp_regen * dt * ed.engine.mp_bonus)
	if not self.buff_effects.noHPR then
		local hp_regen = attribs.HPR
		if hp_regen < 0 or not self.buff_effects.unheal then
			setHP(self, self.hp + hp_regen * dt)
		end
	end
	if self.hp == 0 and isAlive(self) then
		self.hp = 1
	end
	self.hp_low = self.hp / attribs.HP < 0.2
	if self.manual_skill then
		local target = self.ai.target
		local why
		self.can_cast_manual, why = self.manual_skill:canCastWithTarget(target)
	end
end
class.update = update

local function onActionFinished(self)
	if self.state == ed.emUnitState_Dead then
		EDDebug()
	elseif self.state == ed.emUnitState_Dying then
		self.state = ed.emUnitState_Dead
		self:setAction(nil)
		if not self.config.is_summoned then
			self.hasCorpse = true
		end
	elseif self.state == ed.emUnitState_Attack then
		self.current_skill:onPhaseFinished()
	else
		self:idle()
	end
end
class.onActionFinished = onActionFinished

local function idle(self)
	if not self:isAlive() then
		return
	end
	if self.state == ed.emUnitState_Idle then
		return
	end
	self.state = ed.emUnitState_Idle
	self.walk_v = {0, 0}
	self:setAction(self.push and "Move" or "Idle", true)
end
class.idle = idle

local abs = math.abs
local function walkTowards(self, dest)
	if not self:isAlive() then
		return
	end
	if self.state ~= ed.emUnitState_Walk then
		self.state = ed.emUnitState_Walk
		self:setAction("Move", true)
	end
	local base_speed = self.info["Walk Speed"]
	local direction = ed.edpSub(dest, self.position)
	if direction[1] == 0 and direction[2] == 0 then
		self.walk_v = {0, 0}
	else
		direction = {
			direction[1] * abs(direction[1]),
			direction[2] * abs(direction[2])
		}
		self.walk_v = ed.edpMult(ed.edpNormalize(direction), base_speed * self.walk_speed_multiplier)
	end
end
class.walkTowards = walkTowards

local function summon(self, bornActionName)
	self.state = ed.emUnitState_Birth
	self.walk_v = {0, 0}
	if nil == bornActionName then
		bornActionName = ed.state_to_string[ed.emUnitState_Birth]
	end
	self:setAction(bornActionName)
end
class.summon = summon

local function castSkill(self, skill, target)
	if not self:isAlive() then
		return
	end
	self.state = ed.emUnitState_Attack
	self.walk_v = {0, 0}
	skill:start(target)
	self.current_skill = skill
end
class.castSkill = castSkill

local function castManualSkill(self)
	if not self:isAlive() then
		return
	end
	if self.manual_skill:canTrigger() then
		self.manual_skill:trigger()
		return
	end
	if not self.manual_skill:canCastWithTarget(self.ai.target) then
		return
	end
	if self.current_skill then
		self.current_skill:interrupt()
	end
	self:castSkill(self.manual_skill, self.ai.target)
	self.manually_casting = true
	ed.engine:freeze()
	self:unfreeze()
	self.can_cast_tick = -1
end
class.castManualSkill = castManualSkill

local function hurt(self)
	if not self:isAlive() then
		return
	end
	if self.current_skill then
		self.current_skill:interrupt()
	end
	if self.actor and self.actor.puppet then
		self.actor.puppet:interruptSound()
	end
	self:setAction("Damaged", false, true)
	self.state = ed.emUnitState_Hurt
	self.walk_v = {0, 0}
end
class.hurt = hurt

local setDeathWithEffectOrNot = function(self, isDeathWithEffect)
	self.isDeathWithEffect = isDeathWithEffect
end
class.setDeathWithEffectOrNot = setDeathWithEffectOrNot

local setDisapearWhenDie = function(self, isDisapearWhenDie)
	self.isDisapearWhenDie = isDisapearWhenDie
end
class.setDisapearWhenDie = setDisapearWhenDie

local function die(self, killer)
	if not self:isAlive() then
		return
	end
	if do_battle_log then
		btlog("%s died.", self:display())
	end
	self:removeSignedBuffer()
	if self.manually_casting then
		self.manually_casting = false
		ed.engine:unfreeze()
	end
	if self.current_skill then
		self.current_skill:interrupt()
	end
	self.state = ed.emUnitState_Dying
	self.can_cast_manual = false
	self.walk_v = {0, 0}
	self.hp = 0
	self.mp = 0
	if not self.isDeathWithEffect then
		self:setAction("Death", false, true)
	else
		self.action_name = nil
		self.action_loop = false
		self.action_duration = 0
		self.action_elapsed = 0
		local origin = {
			self.position[1],
			self.position[2]
		}
		if ed.run_with_scene then
			local effect_name = "eff_point_mirror_die.cha"
			if effect_name then
				ed.scene:playEffectOnScene(effect_name, origin, {
					self.direction * 0.85,
					0.85
				}, nil, 1)
			end
		end
	end
	ed.engine:onUnitDie(self, killer)
	if 0 < #self.aura_skill_list then
		for unit in ed.engine:foreachAliveUnit(self.camp) do
			unit:rebuild()
		end
	end
	if 0 < #self.effect_enemy_aura_skill_list then
		local camp = self.camp == ed.emCampPlayer and ed.emCampEnemy or ed.emCampPlayer
		for unit in ed.engine:foreachAliveUnit(camp) do
			unit:rebuild()
		end
	end
	if self.actor then
		self.actor:onUnitDeath()
	end
end
class.die = die

local handleUnitDieEvent = function(self, unit, killer_unit)
end
class.handleUnitDieEvent = handleUnitDieEvent

local floor = math.floor
local function takeHeal(self, amount, _type, source)
	if not self:isAlive() then
		return
	end
	_type = _type or "hp"
	if source then
		amount = amount * source.attribs.PDM
	end
	local isAddPoint = true
	if _type == "mp" then
		self:setMP(self.mp + amount)
	elseif not self.buff_effects.unheal then
		self:setHP(self.hp + amount)
	else
		isAddPoint = false
	end
	if do_battle_log then
		btlog("    %s gains %d %s", self:display(), amount, _type)
	end
	self:unfreezeActor()
	if isAddPoint and self.actor and amount > 1 then
		local str = "+" .. floor(amount + 0.5)
		local color = _type == "mp" and "yellow" or "green"
		ed.PopupCreate(str, color, self.actor, false, "heal")
	end
end
class.takeHeal = takeHeal

local max = math.max
local min = math.min
local function getLostHPAfterImmunity(self, damage, immunity)
	return max(1, damage * (100 - immunity) / 100)
end
class.getLostHPAfterImmunity = getLostHPAfterImmunity

local function takeDamage(self, amount, damage_type, field, source, coefficient, crit_mod)
	if type(amount) == "table" then
		damage_type = amount.damage_type
		field = amount.field
		source = amount.source
		coefficient = amount.coefficient
		crit_mod = amount.crit_mod
		amount = amount.amount
	end
	field = field or "hp"
	coefficient = coefficient or 1
	crit_mod = crit_mod or 1
	if not self:isAlive() then
		return
	end
	if self.manually_casting then
		EDDebug()
	end
	local defence, dd, dc, immunity, crit
	local level = self.level
	if damage_type == "AD" then
		defence = max(0, self.attribs.ARM - source.attribs.ARMP)
		crit = source.attribs.CRIT
		immunity = self.attribs.PIMU or 0
		dd = defence * 8
		dc = defence * 8
	elseif damage_type == "AP" then
		defence = max(0, self.attribs.MR - source.attribs.MRI)
		crit = source.attribs.MCRIT
		immunity = self.attribs.MIMU or 0
		dd = defence * 12
		dc = defence * 2.5
	elseif damage_type == "Holy" then
		defence = 0
		crit = 0
		immunity = 0
		dd = 0
		dc = 0
	else
		EDDebug("Unknown Damage Type '" .. damage_type .. "'")
	end
	local crit_prob = crit / (100 + dc) * crit_mod
	local bCrit = crit_prob > ed.rand()
	local crit_multiplier = bCrit and 2 or 1
	amount = max(0, amount)
	local damage = amount * amount / (amount + dd * coefficient)
	damage = damage * crit_multiplier * source.attribs.PDM
	if immunity >= 100 then
		if ed.run_with_scene then
			local color = self.camp == ed.emCampEnemy and "red" or "blue"
			local adimm = self.attribs.PIMU >= 100
			local apimm = self.attribs.MIMU >= 100
			local str
			if adimm and apimm then
				str = "immune"
			elseif adimm then
				str = "physical_immune"
			else
				str = "magic_immune"
			end
			ed.PopupCreate(str, color, self.actor, nil, "text")
		end
		return 0
	end
	for _, buff in ipairs(self.buff_list) do
		damage = buff:onDamaged(damage, damage_type)
	end
	if damage <= 0 then
		return 0
	end
	local lost = self:getLostHPAfterImmunity(damage, immunity)
	local damage = min(self.hp, lost)
	damage = damage * self.dPSStatisticsRatio
	if source ~= self then
		source.dmg_statistics = source.dmg_statistics + damage
	end
	if do_battle_log then
		btlog("    %s lost %d %s %s", self:display(), lost, field, bCrit and "(Crit!)" or "")
	end
	local oldLostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
	if field == "hp" then
		self:setHP(self.hp - lost)
		if self.hp == 0 then
			self:die(source)
		else
			do
				local interruptHpRatio = self.info["Interrupt HP Ratio"] ~= 0 and self.info["Interrupt HP Ratio"] or 0.08
				if lost <= self.attribs.HP * interruptHpRatio then
				elseif self.state == emUnitState_Birth then
				elseif self.current_skill and not self.current_skill.info.Interruptable then
				elseif self.buff_effects.uncontrollable then
				else
					self:hurt()
					if do_battle_log then
						btlog("    %s was interrupted.", self:display())
					end
				end
			end
			local mp_gain = lost * self.info["MP Gain Rate"] / self.attribs.HP
			self:setMP(self.mp + mp_gain * ed.engine.mp_bonus)
		end
	elseif field == "mp" then
		self:setMP(self.mp - lost)
	end
	self:unfreezeActor()
	if self.actor then
		local str = "-" .. floor(lost + 0.5)
		if str ~= "-0" then
			local color
			if field == "mp" then
				color = "yellow"
			elseif self.camp == ed.emCampPlayer then
				color = "red"
			else
				color = "orange"
			end
			ed.PopupCreate(str, color, self.actor, bCrit)
			if self.monster_idx then
				local lostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
				ed.scene:showMonsterLoots(ed.engine.wave_id, self, lostHpPer, oldLostHpPer)
			end
		end
	end
	return lost
end
class.takeDamage = takeDamage

local affectField = function(self, buffInfo)
	for i, skill in ipairs(self.skill_list) do
		skill:affectField(buffInfo)
	end
end
class.affectField = affectField

local unAffectField = function(self, buffInfo)
	for i, skill in ipairs(self.skill_list) do
		skill:unAffectField(buffInfo)
	end
end
class.unAffectField = unAffectField

local knockup = function(self, time, distance)
	if not self.buff_effects.stable then
		if time == 0 then
			EDDebug("Knock Up can not be zero.")
		end
		self.knockup_time = time
		self.knockup_v = {
			distance[1] / time,
			distance[2] / time
		}
		if self.actor then
			self.actor:launch(time)
		end
	end
end
class.knockup = knockup

local rewritePuppetStack = function(self, index, name)
	local isRet = true
	if index > #self.puppet_stack then
		isRet = false
	else
		self.puppet_stack[index] = name
		for i, buff in ipairs(self.buff_list) do
			buff:removeEffectAndShader()
		end
		self:usePuppet()
	end
	return isRet
end
class.rewritePuppetStack = rewritePuppetStack

local pushPuppet = function(self, name)
	table.insert(self.puppet_stack, name)
	self:usePuppet()
	return #self.puppet_stack
end
class.pushPuppet = pushPuppet

local removePuppet = function(self, puppet_id)
	local stack = self.puppet_stack
	if puppet_id > #stack then
		EDDebug()
	end
	stack[puppet_id] = ""
	while stack[#stack] == "" do
		stack[#stack] = nil
	end
	self:usePuppet()
end
class.removePuppet = removePuppet

local usePuppet = function(self)
	local puppet = self.puppet_stack[#self.puppet_stack]
	for i, skill in ipairs(self.skill_list) do
		skill:rebuildPhaseList(puppet)
	end
	if self.actor then
		self.actor:usePuppet()
	end
end
class.usePuppet = usePuppet

local function getUnitScale(self)
	local ret = ed.lookupDataTable("Puppet", "Scale", self.puppet_stack[#self.puppet_stack])
	ret = ret * self.config.size_mod
	return ret
end
class.getUnitScale = getUnitScale

local getRuntimeScale = function(self)
	if self.isScaleActionRunning then
		local dt = self.dt_action
		self.scaleActionRunningTime = self.scaleActionRunningTime + dt
		if self.scaleActionRunningTime > self.scaleActionDuration then
			local scale = self.scaleActionScaleValue
			return self.direction * scale, scale
		else
			local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
			return self.direction * scale, scale
		end
	end
	if not self.isScaleActionRunning then
		local m = self.manually_casting
		return self.direction * (m and 1.35 or 1), m and 1.35 or 1
	end
end
class.getRuntimeScale = getRuntimeScale

local startScalingAction = function(self, scaleX, duration)
	local actor = self.actor
	if actor then
		local node = actor.node
		if node then
			self.isScaleActionRunning = true
			self.scaleActionDuration = duration
			self.scaleActionRunningTime = 0
			self.scaleActionScaleValue = scaleX
		end
	else
	end
end
class.startScalingAction = startScalingAction

local endScalingAction = function(self)
	self.isScaleActionRunning = false
	self.scaleActionDuration = 0
	self.scaleActionRunningTime = 0
	self.scaleActionScaleValue = 0
end
class.endScalingAction = endScalingAction

local function getUnitFlipX(self)
	local ret = ed.lookupDataTable("Puppet", "ScaleX Inverse", self.puppet_stack[#self.puppet_stack])
	return ret
end
class.getUnitFlipX = getUnitFlipX


local class = {
	mt = {}
}
ed.UnitActor = UnitActor
class.mt.__index = class

local function UnitActorCreate(model)
	local self = {
		puppet = nil,
		node = CCNode:create(),
		model = model,
		bar_hp = nil,
		bar_shield = nil,
		bar_group = nil,
		puppetName = nil,
		tick = 0,
		position = {0, 0},
		velocity = {0, 0},
		speeder = 1,
		height = 0,
		zSpeed = nil,
		offline = false,
		actor_scale = 1,
		shader_stack = {},
		puppetInfo = nil
	}
	setmetatable(self, class.mt)
	self:usePuppet()
	self.bar_group = ed.FloatingBarGroup.create()
	if not self.model.hpLayer or 0 == self.model.hpLayer then
		self.bar_hp = ed.FloatingBar.create(model, "HP")
		self.node:addChild(self.bar_hp.node, 999)
		self.bar_hp.node:setPosition(0, 114.5)
		self.bar_hp.node:setScale(0.6666666666666666)
		self.bar_group:AddBar("HP", self.bar_hp)
		self.bar_shield = ed.FloatingBar.create(model, "Shield")
		self.node:addChild(self.bar_shield.node, 999)
		self.bar_shield.node:setPosition(0, 110)
		self.bar_shield.node:setScale(0.6666666666666666)
		self.bar_group:AddBar("Shield", self.bar_shield)
	else
		self.bar_shield = ed.FloatingBar.create(model, "ShieldBoss")
		self.bar_shield.node:setPosition(ccp(355, 426))
		self.bar_shield.node:setScaleX(-1)
		ed.scene.ui_layer:addChild(self.bar_shield.node, -1)
		self.bar_group:AddBar("ShieldBoss", self.bar_shield)
	end
	return self
end
class.create = UnitActorCreate
ed.UnitActorCreate = UnitActorCreate

local function usePuppet(self)
	local old = self.puppet
	local model = self.model
	model.actor = self
	self.puppetName = model.puppet_stack[#model.puppet_stack]
	local info = ed.lookupDataTable("Puppet", nil, self.puppetName)
	--self.puppet = LegendAnimation:create(info.Resource, model:getUnitScale())
	self.puppet = ed.createAnimation(info.Resource, model:getUnitScale(), info.AniType or 0)
	local isFlipX = model:getUnitFlipX()
	if isFlipX then
		self.puppet:setScaleX(-1)
	end
	self.puppetInfo = info
	local comps = info["Change Components"]
	if comps then
		for i = 1, #comps, 2 do
			self.puppet:setComponent(comps[i], comps[i + 1])
		end
	end
	if model.config.is_boss and (model.isBossCreateWithEffect or model.isBossCreateWithEffect == nil) then
		self.puppet:addEffect("eff_buff_boss", -1)
	end
	self.node:addChild(self.puppet, 0)
	if old then
		self.shader_stack = {}
		old:removeFromParentAndCleanup(true)
	end
	local actionName = self:getActionName(model.action_name)
	self.puppet:setAction(actionName)
	self.puppet:setLoop(model.action_loop)
	self.puppet:setActionElapsed(model.action_elapsed)
	for i, buff in ipairs(model.buff_list) do
		buff:onAddedClient()
	end
end
class.usePuppet = usePuppet

local pushShader = function(self, shader)
	table.insert(self.shader_stack, shader)
	self.puppet:useShader(shader)
	return #self.shader_stack
end
class.pushShader = pushShader

local removeShader = function(self, shader_id)
	local stack = self.shader_stack
	if shader_id > #stack then
		LegendLog("Actor shader has been removed!");
		return;
  end
  stack[shader_id] = ""
  while stack[#stack] == "" do
    stack[#stack] = nil
  end
  if #stack == 0 then
    self.puppet:useDefaultShader()
  else
    self.puppet:useShader(stack[#stack])
  end
end
class.removeShader = removeShader

local onStartNewAction = function(self)
	if self.offline then
		return
	end
	local model = self.model
	if not model.buff_effects.frozen then
		local actionName = self:getActionName(model.action_name)
		self.puppet:setAction(actionName)
		self.puppet:setLoop(model.action_loop)
	end
end
class.onStartNewAction = onStartNewAction

local function playGoldDropEffect(self)
	if self.model.money and self.model.money > 0 then
		if self.gold_drop_played then
			return
		end
		self.gold_drop_played = true
		local parent = self.node
		parent:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(function()
			ed.scene:playEffectOnScene("eff_battle_drop_money.cha", self.position, {1, 1}, 0, 1)
			local str = "+" .. floor(self.model.money)
			local color = "golden"
			ed.PopupCreate(str, color, self, false, "gold")
			ed.scene:addGold(self.model.money)
		end)))
	end
end
class.playGoldDropEffect = playGoldDropEffect

local onUnitDeath = function(self)
	local model = self.model
	local duration = model.action_duration
	local delay = model.is_summoned and 0 or 2
	if model.isDeathWithEffect then
		delay = 0
	end
	if duration + delay <= 0 then
		self.node:setVisible(false)
	elseif model.isDisapearWhenDie or nil == model.isDisapearWhenDie then
		self.puppet:runAction(CCSequence:create(ccArrayMake(unpack({
			CCDelayTime:create(duration + delay),
			CCFadeOut:create(1),
			CCCallFunc:create(function()
				self.node:setVisible(false)
			end)
		}))))
	end
	self.puppet:setActionSpeeder(1)
	self.offline = true
	self.puppet:setLoop(false)
	self.velocity = {0, 0}
	self:playGoldDropEffect()
end
class.onUnitDeath = onUnitDeath

local setScaleX = CCNode.setScaleX
local setScaleY = CCNode.setScaleY
local setPosition = CCNode.setPosition
local setZOrder = CCNode.setZOrder
local hp_update = ed.HpBar.update
local gravity = -1800

local function update(self, dt)
	local node = self.node
	local u = self.model
	if not self.offline and self.tick ~= ed.engine.ticks then
		self.tick = ed.engine.ticks
		local speeder = u.speeder
		do
			local x, y = ed.Unit.getRuntimeScale(u)
			setScaleX(node, x)
			setScaleY(node, y)
		end
		do
			local p1 = self.position
			local p2 = u.position
			p1[1] = p2[1]
			p1[2] = p2[2]
		end
		do
			local v1 = self.velocity
			local v2 = u.velocity
			v1[1] = v2[1] * speeder
			v1[2] = v2[2] * speeder
		end
		self.puppet:setActionSpeeder(u.buff_effects.frozen and 0 or speeder)
	else
		local pos = self.position
		local v = self.velocity
		pos[1] = pos[1] + v[1] * dt
		pos[2] = pos[2] + v[2] * dt
	end
	if not tolua.isnull(self.puppet) then
		self.puppet:update(dt, false)
	end
	local h = 0
	if self.zSpeed then
		h = self.height + self.zSpeed * dt
		self.zSpeed = self.zSpeed + gravity * dt
		if h < 0 then
			self.zSpeed = nil
			h = 0
		end
		self.height = h
	end
	setPosition(node, ed.toViewPosition(self.position, h))
	setZOrder(node, -self.position[2])
	if self.bar_group then
		self.bar_group:update(dt)
	end
end
class.update = update

local addEffect = function(self, name, zorder)
	local puppet = self.puppet
	if string.match(name, "%.cha$") then
		name = string.gsub(name, "%.cha$", "")
		zorder = zorder or 1
		return puppet:addEffect(name, zorder)
	end
end
class.addEffect = addEffect

local addEffectToComponent = function(self, name, component_name, zorder, option_args)
	local puppet = self.puppet
	if string.match(name, "%.cha$") then
		name = string.gsub(name, "%.cha$", "")
		zorder = zorder or 1
		option_args = option_args or {}
		local offset_x = option_args.x or 0
		local offset_y = option_args.y or 0
		local angle = option_args.angle or 0
		angle = angle / 180 * math.pi
		local t = CCAffineTransformMakeIdentity()
		t = CCAffineTransformTranslate(t, offset_x, offset_y)
		t = CCAffineTransformRotate(t, angle)
		local inherit_rotation = option_args.inherit_rotation or false
		local inherit_visible = option_args.inherit_visible or false
		return puppet:addEffectToComponent(name, component_name, zorder, t, inherit_rotation, inherit_visible)
	end
end
class.addEffectToComponent = addEffectToComponent

local addNode = function(self, node, zorder, option_args)
	if node == nil then
		return
	end
	local puppet = self.puppet
	zorder = zorder or 1
	option_args = option_args or {}
	local offset_x = option_args.x or 0
	local offset_y = option_args.y or 0
	local angle = option_args.angle or 0
	angle = angle / 180 * math.pi
	local t = CCAffineTransformMakeIdentity()
	t = CCAffineTransformTranslate(t, offset_x, offset_y)
	t = CCAffineTransformRotate(t, angle)
	return puppet:addNode(node, zorder, t)
end
class.addNode = addNode

local addNodeToComponent = function(self, node, component_name, zorder, option_args)
	if node == nil then
		return
	end
	local puppet = self.puppet
	zorder = zorder or 1
	option_args = option_args or {}
	local offset_x = option_args.x or 0
	local offset_y = option_args.y or 0
	local angle = option_args.angle or 0
	angle = angle / 180 * math.pi
	local t = CCAffineTransformMakeIdentity()
	t = CCAffineTransformTranslate(t, offset_x, offset_y)
	t = CCAffineTransformRotate(t, angle)
	local inherit_rotation = option_args.inherit_rotation or false
	local inherit_visible = option_args.inherit_visible or false
	return puppet:addNodeToComponent(node, component_name, zorder, t, inherit_rotation, inherit_visible)
end
class.addNodeToComponent = addNodeToComponent

local removeExtraNode = function(self, id)
	if id == nil then
		return
	end
	self.puppet:removeNodeWithID(id)
end
class.removeExtraNode = removeExtraNode

local function launch(self, time)
	self.zSpeed = time * -gravity * 0.5
end
class.launch = launch

local function gotoNextBattle(self)
	local puppet = self.puppet
	local moveActionName = self:getActionName("Move")
	puppet:setAction(moveActionName)
	puppet:setLoop(true)
	puppet:setActionSpeeder(ed.next_battle_walk_speeder ^ 0.5)
	self.velocity = {
		self.model.info["Walk Speed"] * ed.next_battle_walk_speeder,
		0
	}
	self.node:setScaleX(1)
	self.node:setScaleY(1)
	self.offline = true
end
class.gotoNextBattle = gotoNextBattle

local waitAfterBattle = function(self)
	local puppet = self.puppet
	local idleActionName = self:getActionName("Idle")
	puppet:setNextAction(idleActionName)
	puppet:setLoop(true)
	self.velocity = {0, 0}
	self.node:setScaleX(self.model.direction)
	self.node:setScaleY(1)
	self.offline = true
end
class.waitAfterBattle = waitAfterBattle

local cheer = function(self)
	local puppet = self.puppet
	local cheerActionName = self:getActionName("Cheer")
	puppet:setNextAction(cheerActionName)
	puppet:setLoop(true)
	self.velocity = {0, 0}
	self.node:setScaleX(1)
	self.node:setScaleY(1)
	self.offline = true
end
class.cheer = cheer

local tint = function(self, r, g, b)
	self.puppet:tint(r, g, b)
end
class.tint = tint

local getActionName = function(self, actionName)
	local newActionName = actionName
	if self.puppetInfo ~= nil and actionName ~= nil then
		local flagName = "Action " .. actionName
		local tmpActionName = self.puppetInfo[flagName]
		if tmpActionName ~= nil then
			newActionName = tmpActionName
		end
	end
	return newActionName
end
class.getActionName = getActionName

local isActionEmpty = function(self, actionName)
	local bRet = true
	if self.puppetInfo ~= nil and actionName ~= nil then
		local flagName = "Action " .. actionName
		local tmpActionName = self.puppetInfo[flagName]
		if tmpActionName ~= nil and tmpActionName ~= "" then
			bRet = false
		end
	end
	return bRet
end
class.isActionEmpty = isActionEmpty

require("battle.preload")

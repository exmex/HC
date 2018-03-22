local ed = ed
local skill4_power = function(basefunc, skill, source, target)
  local power, i = basefunc(skill, target, source)
  if target ~= skill.target then
    return power * skill.info["Script Arg2"] / 100, i
  else
    return power, i
  end
end
local function skill2_buffOnDamaged(basefunc, buff, damage, damage_type)
  local info = buff.info
  local owner = buff.owner
  if damage <= 0 then
    if buff.refraction and 0 >= buff.refraction then
      owner:removeBuff(buff)
    end
    return 0
  end
  if buff.shield then
    local block = false
    local stype = buff.info["Shield Type"]
    if stype == damage_type or stype == "all" then
      buff.shield = buff.shield - damage
      local temp = buff.shield
      buff.refraction = buff.refraction - 1
      buff.shield = buff.info["Shield Value"]
      if buff.refraction and 0 >= buff.refraction then
        owner:removeBuff(buff)
      end
      local mppower = owner.skills.TA_atk2.info["Script Arg3"]
      owner:takeHeal(mppower, "mp", owner)
      if temp < 0 then
        return -temp
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
local skill2_buffOnRemoved = function(basefunc, buff)
  local owner = buff.owner
  buff.refraction = 0
  return basefunc(buff)
end
local function skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.refraction = skill.info["Script Arg2"]
  buff.onRemoved = override(buff.onRemoved, skill2_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, skill2_buffOnDamaged)
  return buff
end
local function skillult_selectTarget(basefunc, skill, default)
  local attack_counter = skill.attack_counter
  if attack_counter > 1 then
    return skill.target
  end
  local target = basefunc(skill, default)
  local caster = skill.caster
  local damage = (skill.info["Basic Num"] + skill.info["Plus Ratio"] * caster.attribs[skill.info["Plus Attr"]]) * 2
  local targethp = target and target.hp or 0
  local maxHPTarget = target
  if damage > targethp then
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      if targethp < unit.hp and damage >= unit.hp then
        maxHPTarget = unit
        targethp = unit.hp
      end
    end
  end
  skill.target = maxHPTarget
  return maxHPTarget
end
local skillult_power = function(basefunc, skill, source, target)
  local power, i = basefunc(skill, target, source)
  if target ~= skill.target then
    return power, i
  else
    return power, i
  end
end
local function skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if skill.attack_counter == 1 then
    skill.origtarget = skill.target
    if target then
      caster:setPosition({
        target.position[1] + caster.direction * 120,
        target.position[2]
      })
      caster.direction = -caster.direction
    end
  elseif attack_counter == 2 then
    skill.target = skill.origtarget
    basefunc(skill, skill.target.position, source)
  else
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "target",
      ["Point Effect"] = false
    })
    basefunc(skill, skill.target.position, source)
    skill.info = originfo
    caster.position = {
      caster.origposition[1],
      caster.origposition[2]
    }
  end
end
local function skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.origposition = {
    caster.position[1],
    caster.position[2]
  }
  caster.origtarget = target
  local bid = 120
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local buffs = {}
  local index = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 106 then
      index = index + 1
      buffs[index] = tbuff
    end
  end
  for i = 1, index do
    caster:removeBuff(buffs[index + 1 - i])
  end
end
local hero_handleUnitDieEvent = function(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if killer_unit == self then
    local skillatk2 = self.skills.TA_atk2
    if skillatk2 then
      skillatk2.cd_remaining = 0
    end
  end
end
local function init_hero(hero)
  hero.handleUnitDieEvent = override(hero.handleUnitDieEvent, hero_handleUnitDieEvent)
  local skillult = hero.skills.TA_ult
  skillult.takeEffectAt = override(skillult.takeEffectAt, skillult_takeEffectAt)
  skillult.power = override(skillult.power, skillult_power)
  skillult.start = override(skillult.start, skillult_start)
  skillult.selectTarget = override(skillult.selectTarget, skillult_selectTarget)
  local skillatk2 = hero.skills.TA_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
  end
  local skillatk4 = hero.skills.TA_atk4
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, skill4_power)
  end
  return hero
end
return init_hero

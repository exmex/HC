local ed = ed
local skill_atk3_createProjectile = function(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(5)
  projectile:enableTrack(skill.target)
  return projectile
end
local percents = {
  1,
  1,
  1,
  1,
  1
}
local function skill_atk3_power(basefunc, skill, source)
  local ret = basefunc(skill)
  ret = ret * percents[source.jumps]
  return ret
end
local skillatk3_takeEffectOn = function(basefunc, skill, target, source)
  return basefunc(skill, target, source)
end
local skillatk3_getDamage = function(basefunc, self, target, power, damage_type, field, source, crit_mod)
  if target.config.is_summoned then
    power = power * 2
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod
  })
  return dmg
end
local function skillatk4_selectTarget(basefunc, self, default)
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
          if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
            max = v
            chosen = unit
          elseif v > max then
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
local function skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 150
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, owner)
  owner:addBuff(buff, owner)
end
local function skillatk3_createBuff(basefunc, self, target)
  local owner = self.caster
  if target.config.is_summoned then
    local bid = 7
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, self.caster)
  else
    return ed.BuffCreate(self.info.buff_info, target, self.caster)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.WD_ult
  local skill_atk3 = hero.skills.WD_atk3
  local skill_atk4 = hero.skills.WD_atk4
  if skill_atk3 then
    skill_atk3.createProjectile = override(skill_atk3.createProjectile, skill_atk3_createProjectile)
    skill_atk3.power = override(skill_atk3.power, skill_atk3_power)
    skill_atk3.getDamage = override(skill_atk3.getDamage, skillatk3_getDamage)
    skill_atk3.takeEffectOn = override(skill_atk3.takeEffectOn, skillatk3_takeEffectOn)
    skill_atk3.createBuff = override(skill_atk3.createBuff, skillatk3_createBuff)
  end
  if skill_atk4 then
    skill_atk4.selectTarget = override(skill_atk4.selectTarget, skillatk4_selectTarget)
  end
  if skillult then
    skillult.start = override(skillult.start, skillult_start)
  end
  return hero
end
return init_hero

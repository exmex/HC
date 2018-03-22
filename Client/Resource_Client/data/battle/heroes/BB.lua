local ed = ed
local damagePercentCast = 0.2
local skillult_canCastWithTarget = function(basefunc, skill, target)
  if skill.caster.ultBuff then
    return false, "ult"
  end
  return basefunc(skill, target)
end
local skillult_buffOnRemoved = function(basefunc, buff)
  local caster = buff.caster
  if caster.changePeriod then
    caster:enterActionStageFromOneStage(1)
    caster.changePeriod = nil
    caster.ultBuff = false
  end
  basefunc(buff)
end
local function skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skillult_buffOnRemoved)
  skill.caster.ultBuff = buff.info.PIMU
  return buff
end
local skillult_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod = true
end
local skillult_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod then
    caster:enterActionStageFromOneStage(2)
  end
end
local function hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.BB_atk3
  if skillatk3 and hero.totalDamage and hero.totalDamage >= hero.attribs.HP * damagePercentCast then
    skillatk3:takeEffectAt(hero.position, hero)
    hero:setMP(hero.mp + skillatk3.info["Gain MP"] * ed.engine.mp_bonus)
    hero.totalDamage = hero.totalDamage - hero.attribs.HP * damagePercentCast
  end
end
local getLostHPAfterImmunity = function(basefunc, hero, damage, immunity)
  local skillatk3 = hero.skills.BB_atk3
  if skillatk3 then
    hero.totalDamage = hero.totalDamage and hero.totalDamage + damage or damage
  end
  return basefunc(hero, damage, immunity)
end
local hero_takeDamage = function(basefunc, self, amount, damage_type, field, source, coefficient, crit_mod)
  if self.ultBuff then
    local direct = type(amount) == "table" and amount.source.direction or source.direction
    if direct == self.direction then
      local temp = self.attribs.PIMU
      local temp2 = self.attribs.MIMU
      self.attribs.PIMU = self.attribs.PIMU - self.ultBuff
      self.attribs.MIMU = self.attribs.MIMU - self.ultBuff
      local dmg = basefunc(self, amount, damage_type, field, source, coefficient, crit_mod)
      self.attribs.PIMU = temp
      self.attribs.MIMU = temp
      return dmg
    end
  end
  return basefunc(self, amount, damage_type, field, source, coefficient, crit_mod)
end
local function init_hero(hero)
  local skillatk3 = hero.skills.BB_atk3
  if skillatk3 then
    hero.totalDamage = 0
  end
  hero.takeDamage = override(hero.takeDamage, hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, getLostHPAfterImmunity)
  hero.update = override(hero.update, hero_update)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.BB_ult
  skillult.createBuff = override(skillult.createBuff, skillult_createBuff)
  skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  skillult.finish = override(skillult.finish, skillult_finish)
  skillult.canCastWithTarget = override(skillult.canCastWithTarget, skillult_canCastWithTarget)
  return hero
end
return init_hero

local ed = ed
local function createProjectile(basefunc, skill)
  local origTarget = skill.target
  local mod = skill.info["Script Arg1"] / 100
  local counter = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= 5 then
      break
    end
    counter = counter + 1
    skill.target = unit
    local projectile = basefunc(skill, unit)
    projectile.dmgModifier = unit == origTarget and 1 or mod
    projectile:enableTrack(unit)
    ed.engine:addProjectile(projectile)
  end
end
local power = function(basefunc, self, source)
  return basefunc(self, source) * source.dmgModifier, source.dmgModifier
end
local function skillatk3_takeEffectAt(basefunc, skill, location)
  local caster = skill.caster
  local bid = 34
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, location)
  caster:removeBuff(buff)
end
local function init_hero(hero)
  local skillatk2 = hero.skills.Med_atk2
  local skillatk3 = hero.skills.Med_atk3
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, createProjectile)
    skillatk2.power = override(skillatk2.power, power)
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, skillatk3_takeEffectAt)
  end
  return hero
end
return init_hero

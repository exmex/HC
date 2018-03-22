local ed = ed
local function skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local effect_moon = "eff_point_Luna_moon.cha"
    local origin = {400, 0}
    local casterorigin = skill.caster.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 0)
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end
local skill_atk3_createProjectile = function(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(4)
  projectile:enableTrack(skill.target)
  return projectile
end
local percents = {
  0.65,
  0.75,
  0.85,
  1
}
local function skill_atk3_power(basefunc, skill, source)
  local ret = basefunc(skill)
  ret = ret * percents[source.jumps]
  return ret
end
local skill_atk3_takeEffectOn = function(basefunc, skill, target, source)
  source.affect_times[target] = (source.affect_times[target] or 0) + 1
  return basefunc(skill, target, source)
end
local function init_hero(hero)
  local skillult = hero.skills.Luna_ult
  if skillult then
    skillult.start = override(skillult.start, skillult_start)
  end
  local skill_atk3 = hero.skills.Luna_atk3
  if skill_atk3 then
    skill_atk3.createProjectile = override(skill_atk3.createProjectile, skill_atk3_createProjectile)
    skill_atk3.power = override(skill_atk3.power, skill_atk3_power)
  end
  return hero
end
return init_hero

local ed = ed
local function skill2_takeEffecOn(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_name = "eff_launch_spike.cha"
    local origin = target.position
    local effect_z = skill.info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end
local function init_hero(hero)
  local skill2 = hero.skills.Lion_atk2
  if skill2 then
    skill2.takeEffectOn = override(skill2.takeEffectOn, skill2_takeEffecOn)
  end
  return hero
end
return init_hero

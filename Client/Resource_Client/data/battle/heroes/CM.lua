local ed = ed
local function skill3_start(basefunc, skill, target)
  local info = skill.info
  local origin = skill.caster.position
  local scale = {
    skill.caster.direction,
    1
  }
  if ed.run_with_scene then
    local effect_name = "eff_CM_ult_snow.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, origin, scale)
  end
  basefunc(skill, target)
end
local function skill3_takeEffectAt(basefunc, skill, location)
  local info = skill.info
  local origin = {
    location[1] + info["X Shift"],
    120
  }
  local aoe = skill.info["AOE Origin"]
  local scale = {
    skill.caster.direction * 3,
    2
  }
  local height = 100
  if aoe then
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * skill.caster.direction
      if ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
        skill:takeEffectOn(unit)
      end
    end
  else
    skill:takeEffectOn(skill.target)
  end
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      return
    end
    if skill.attack_counter == 1 then
      ed.scene:playEffectOnScene(effect_name, origin, scale, height)
    end
  end
end
local init_hero = function(hero)
  local skill3 = hero.skills.CM_ult
  return hero
end
return init_hero

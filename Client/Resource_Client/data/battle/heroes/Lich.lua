local ed = ed
local function skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Lich_night.cha"
    local effect_moon = "eff_point_Lich_moon.cha"
    local origin = {400, 0}
    local casterorigin = skill.caster.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 0)
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end
local function skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(4)
  projectile:enableTrack(skill.target)
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  return projectile
end
local function init_hero(hero)
  local skillult = hero.skills.Lich_ult
  skillult.createProjectile = override(skillult.createProjectile, skillult_createProjectile)
  return hero
end
return init_hero

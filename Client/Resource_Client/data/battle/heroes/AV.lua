local ed = ed
local origin
local function skillult_start(basefunc, skill, target)
  origin = {
    skill.target.position[1],
    skill.target.position[2]
  }
  if ed.run_with_scene then
    local effect_name = "eff_launch_AV_ult.cha"
    skill:selectTarget(target)
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, origin, nil, nil, -1)
  end
  basefunc(skill, target)
end
local function skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 300
  projectile.position = origin
  return projectile
end
local skillult_willCast = function(basefunc, skill)
  return basefunc(skill) and skill.caster.current_skill ~= skill.caster.skills.AV_atk3
end
local function skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local dis = caster.direction == 1 and 800 - caster.position[1] or caster.position[1]
  local t = 2.3
  local v = dis / t
  if skill.attack_counter and skill.attack_counter == 0 then
    caster.walk_v = {
      caster.direction * v,
      0
    }
    caster.AVultposition = {
      caster.position[1],
      caster.position[2]
    }
    local bid = skill.info["Script Arg1"]
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
    basefunc(skill)
  elseif skill.attack_counter and skill.attack_counter == 11 then
    caster.walk_v = {0, 0}
    caster.position = {
      caster.AVultposition[1],
      caster.AVultposition[2]
    }
  else
    basefunc(skill)
  end
end
local function skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 1200
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  local targetpos = target.position
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ -0.5
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
  projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  return projectile
end
local function init_hero(hero)
  local skillult = hero.skills.AV_ult
  local skillatk3 = hero.skills.AV_atk3
  local skillatk2 = hero.skills.AV_atk2
  skillult.start = override(skillult.start, skillult_start)
  skillult.createProjectile = override(skillult.createProjectile, skillult_createProjectile)
  skillult.willCast = override(skillult.willCast, skillult_willCast)
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, skillatk3_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, skillatk2_createProjectile)
  end
  return hero
end
return init_hero

local ed = ed
local function skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 1500
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
local function skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end
local function skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.5
  local bid = 97
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if caster then
    caster:enterActionStageFromOneStage(2)
  end
end
local function skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(10, 0.1, 10)
  end
end
local function init_hero(hero)
  local skillatk = hero.skills.AncientTreant_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, skillatk_createProjectile)
  end
  local skillatk2 = hero.skills.AncientTreant_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, skillatk2_takeEffectAt)
  end
  local skill6 = hero.skills.AncientTreant_atk6
  if skill6 then
    skill6.start = override(skill6.start, skill6_start)
    skill6.finish = override(skill6.finish, skill6_finish)
  end
  hero.isBossCreateWithEffect = false
  hero:setDisapearWhenDie(false)
  return hero
end
return init_hero

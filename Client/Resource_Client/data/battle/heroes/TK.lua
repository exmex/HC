local ed = ed
local function skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  if skill.info["Target Type"] == "random" then
    skill:selectTarget(skill.target)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  local counter = skill.attack_counter
  local ttype = info["Track Type"]
  if counter % 3 ~= 2 then
    skill.info["Tile Art"] = "projectile/TK_atk2_tile.png"
    skill.info["Tile OTT Height"] = 0
    skill.info["Tile XY Speed"] = skill.info["Script Arg2"]
    skill.info["Tile Z Speed"] = 0
  else
    skill.info["Tile Art"] = "projectile/TK_atk3_tile.png"
    skill.info["Tile OTT Height"] = skill.info["Script Arg4"]
    skill.info["Tile XY Speed"] = skill.info["Script Arg5"]
    skill.info["Tile Z Speed"] = skill.info["Script Arg6"]
  end
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. type .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if 0 < info["Move Forward"] then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end
local function projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  projectile.zSpeed = projectile.zSpeed - projectile.skill.info["Tile Gravity"] * dt
  local dv = 600 * dt
  local target = projectile.skill.target
  if not target then
    return
  end
  target = target.position
  local xySpeed = projectile.velocity
  local zSpeed = projectile.zSpeed
  local v = {
    xySpeed[1],
    xySpeed[2],
    zSpeed
  }
  local targetxyV = ed.edpSub(target, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ -0.5
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  if zSpeed and dv < zSpeed then
    projectile.zSpeed = projectile.zSpeed - dv
    dv = 0
  elseif zSpeed and zSpeed > 0 then
    dv = dv - zSpeed
    projectile.zSpeed = 0
  end
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * dv * 8
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * dv * 8
  projectile.zSpeed = projectile.zSpeed + targetV[3] * dv * 8
end
local function skill_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, projectile_update)
  return projectile
end
local function init_hero(hero)
  local skillult = hero.skills.TK_ult
  local skillatk3 = hero.skills.TK_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, skill_createProjectile)
  end
  skillult.createProjectile = override(skillult.createProjectile, skill_createProjectile)
  skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  return hero
end
return init_hero

local ed = ed
local interval = 1
local targetpos
local function skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  targetpos = {
    target.position[1] - 60 * caster.direction,
    target.position[2]
  }
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ -0.5
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end
local function infernal_atk3_buff_update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + interval
    local skill = buff.owner.skills.Infernal_atk3
    skill:takeEffectAt()
  end
  buff.attack_timer = timer
end
local function skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local infernal_skill2_lv = caster.skills.WL_atk3 and caster.skills.WL_atk3.level or 0
  local infernal_skill3_lv = caster.skills.WL_atk4 and caster.skills.WL_atk4.level or 0
  local infernal = caster.infernal
  if infernal and infernal:isAlive() then
    infernal:die()
  end
  if caster and caster:isAlive() then
    local proto = {
      _tid = 128,
      _level = skill.level or 1,
      _stars = caster.stars,
      _skill_levels = {
        [3] = infernal_skill2_lv,
        [4] = infernal_skill3_lv
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      summoner = caster
    }
    local infernal = ed.UnitCreate(proto, caster.camp, config)
    infernal.direction = caster.direction
    ed.engine:summonUnit(infernal, targetpos, caster)
    caster.infernal = infernal
    local infernal_atk3 = infernal.skills.Infernal_atk3
    if infernal_atk3 then
      local bid = infernal_atk3.info["Script Arg2"]
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = infernal:addBuff(binfo, caster)
      buff.attack_timer = interval
      buff.update = override(buff.update, infernal_atk3_buff_update)
    end
  end
  basefunc(skill, location, source)
end
local function skillatk2_createBuff(basefunc, skill, target)
  local caster = skill.caster
  if caster.camp == target.camp then
    return ed.BuffCreate(skill.info.buff_info, target, skill.caster)
  else
    local bid = skill.info["Script Arg2"]
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.HPR = -skill.info["Script Arg1"]
    return ed.BuffCreate(binfo, target, skill.caster)
  end
end
local hero_die = function(basefunc, hero, killer)
  if hero.infernal and hero.infernal:isAlive() then
    hero.infernal:die()
  end
  basefunc(hero, killer)
end
local function init_hero(hero)
  local skillult = hero.skills.WL_ult
  local skillatk2 = hero.skills.WL_atk2
  hero.die = override(hero.die, hero_die)
  skillult.createProjectile = override(skillult.createProjectile, skillult_createProjectile)
  skillult.takeEffectAt = override(skillult.takeEffectAt, skillult_takeEffectAt)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
    local heal = hero.attribs.HEAL or 0
    local origininfo = skillatk2.info.buff_info
    local hpr = origininfo.HPR
    skillatk2.info.buff_info = ed.wraptable(origininfo, {
      HPR = hpr * (1 + heal / 100)
    })
  end
  ed.PreloadPuppetRcs("Infernal")
  return hero
end
return init_hero

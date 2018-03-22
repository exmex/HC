local ed = ed
local math = math
local KaelSkillElement = {
  [530] = {
    1,
    1,
    1
  },
  [531] = {
    3,
    0,
    0
  },
  [532] = {
    2,
    1,
    0
  },
  [533] = {
    2,
    0,
    1
  },
  [534] = {
    0,
    3,
    0
  },
  [535] = {
    1,
    2,
    0
  },
  [536] = {
    0,
    2,
    1
  },
  [537] = {
    0,
    0,
    3
  },
  [538] = {
    0,
    1,
    2
  },
  [539] = {
    1,
    0,
    2
  }
}
ed.KaelSkillElement = KaelSkillElement
local epsilon = ed.epsilon
local ballKeywords = {
  ice = 1,
  fire = 1,
  lightning = 1
}
local ballName = {
  [1] = "ice",
  [2] = "fire",
  [3] = "lightning"
}
local function deliverBall(kael, deliverer, t, lifetime, isManual, skill, fromLaunchPoint)
  local idx = ed.engine.increBall()
  local dsIdx = isManual and ed.engine:getManualDeliveredEmptySlot(deliverer.position[1]) or ed.engine:getDeliveredEmptySlot(deliverer.position[1])
  local duration = lifetime or 6
  kael.deliveredBalls[idx] = {
    balltype = t,
    duration = duration,
    idx = idx,
    deliveredSlotIdx = dsIdx,
    deliverer = deliverer,
    autoPick = 0.6,
    autoGet = 0.25,
    startAutoGet = false,
    tapped = false,
    myslotidx = 0
  }
  ed.engine.usedDeliveredBallSlots[dsIdx] = true
  if ed.run_with_scene and kael.displayBall then
    local b = ed.BallCreate(deliverer, t, idx, dsIdx, duration, skill, fromLaunchPoint)
    table.insert(ed.scene.ui_list, b)
    ed.scene.ui_layer:addChild(b.node, 100)
  end
end
local function deliverRandBall(kael, deliverer, number, lifetime, isManual, skill, fromLaunchPoint)
  local number = number or 1
  for i = 1, number do
    local k = math.floor(ed.rand() * 3 + 1)
    deliverBall(kael, deliverer, ballName[k], lifetime, isManual, skill, fromLaunchPoint)
  end
end
local function showBall(kael, deliverer, skill, eventIdx)
  if not kael:isAlive() then
    return
  end
  local t = skill.info["Skill Tags"][eventIdx]
  if not t or not ballKeywords[t] then
    return
  end
  deliverBall(kael, deliverer, t)
end
local function update(basefunc, kael, dt)
  for k, v in pairs(kael.deliveredBalls) do
    v.duration = v.duration - dt
    if v.duration < epsilon and not v.startAutoGet then
      if ed.run_with_scene then
        ed.scene:removeBall(v.idx)
      end
      kael.deliveredBalls[v.idx] = nil
      ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
    end
    if (kael.aiMode or kael.auto_combat) and v.autoPick > epsilon then
      v.autoPick = v.autoPick - dt
    end
    if v.startAutoGet and v.autoGet > epsilon then
      v.autoGet = v.autoGet - dt
      if v.autoGet < epsilon then
        ed.engine.usedDeliveredBallSlots[v.deliveredSlotIdx] = false
        kael:addEnergyBall(v.idx, v.balltype, v.myslotidx)
      end
    end
  end
  kael.energy_ball_manager:update(dt)
  basefunc(kael, dt)
end
local ballKeywords2 = {
  "ice",
  "fire",
  "lightning"
}
local addEnergyBall = function(self, idx, balltype, myslotidx)
  if self.deliveredBalls[idx] then
    self.deliveredBalls[idx] = nil
    self.energy_ball_manager:addEnergyBall(balltype, myslotidx)
  else
  end
end
local function tapBall(self, ext)
  local idx = ext[1]
  local myslotidx = ext[2]
  if not self.deliveredBalls[idx] then
    self.energy_ball_manager.slots[myslotidx].occupied = false
    return
  end
  if self.aiMode then
  else
  end
  self.deliveredBalls[idx].startAutoGet = true
  self.deliveredBalls[idx].myslotidx = myslotidx
  if ed.run_with_scene and self.displayBall and ed.scene.ballSlots[idx] then
    ed.scene.ballSlots[idx]:onTapped2(myslotidx)
  end
end
local function castSkill(basefunc, kael, skill, target)
  if kael.current_skill and not kael.current_skill.info.Manual then
    kael.current_skill:interrupt()
  end
  basefunc(kael, skill, target)
  local sid = skill.info["Skill Group ID"]
  if KaelSkillElement[sid] then
    kael.energy_ball_manager:consumeEnergyBall()
  end
end
local function autoTapBall(kael)
  if not kael.aiMode and not kael.auto_combat then
    return
  end
  for k, v in pairs(kael.deliveredBalls) do
    if v.autoPick < epsilon and not v.tapped then
      local s, myslotidx = kael.energy_ball_manager:getEmptySlot(true)
      if s then
        s.occupied = true
        v.tapped = true
        if kael.aiMode then
          kael:tapBall({
            v.idx,
            myslotidx
          })
        elseif kael.auto_combat then
          ed.engine:manualTapBall(v.deliverer, v.idx, myslotidx, true)
        end
      end
    end
  end
end
local function SpecialCheckEnableAi(kael)
  if kael.energy_ball_manager:isSlotsAvailable() and not ed.engine.arena_mode then
    return true
  end
  return false
end
local reset = function(basefunc, kael)
  basefunc(kael)
  kael.deliveredBalls = {}
  kael.energy_ball_manager:clear()
end
local function die(basefunc, kael, killer)
  basefunc(kael, killer)
  if ed.run_with_scene then
    ed.scene:removeAllBall()
  end
end
local function skillshock_createBuff(basefunc, skill, target)
  local bid = 35
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  target:addBuff(binfo, skill.caster)
  return basefunc(skill, target)
end
local function frozenbuff_onDamaged(basefunc, buff, damage, damage_type)
  local damage = basefunc(buff, damage, damage_type)
  if not buff.owner.config.is_boss and buff.owner.state ~= ed.emUnitState_Hurt then
    buff.owner:hurt()
  end
  return damage
end
local function skillfrozen_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, frozenbuff_onDamaged)
  return buff
end
local function skillfireman_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local proto = {
    _tid = 146,
    _level = skill.level
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    estimate_skill = true
  }
  local oldfireman = caster.oldfireman
  if oldfireman and oldfireman:isAlive() then
    oldfireman:die()
  end
  local fireman = ed.UnitCreate(proto, caster.camp, config)
  local location = {
    caster.position[1] + 50 * caster.direction,
    caster.position[2]
  }
  fireman.direction = caster.direction
  ed.engine:summonUnit(fireman, location, caster)
  caster.oldfireman = fireman
end
local skillmagnet_takeEffectOn = function(basefunc, skill, target, source)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg1"]
    target:takeDamage(power, "Holy", "mp", skill.caster)
  end
  return succ
end
local function skillmagnet_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.magnetorigin = {
        skill.target.position[1],
        -30
      }
    else
      skill.magnetorigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Kael_atk8.cha"
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  else
    basefunc(skill, skill.magnetorigin, source)
  end
end
local trigger_distance = 50
local skillmeteor_createProjectile = function(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local tileVx = 400
  local tileVz = -600
  local projectilex = caster.position[1]
  local distance = caster.position[1] - skill.target.position[1]
  if distance < 0 then
    distance = -distance
  end
  if distance > 200 then
    projectilex = skill.target.position[1] - caster.direction * 200
    tileVx = 200
  else
    tileVx = distance
  end
  projectile.height = 500
  projectile.velocity = {
    tileVx * caster.direction,
    0
  }
  skill.meteorDirection = caster.direction
  projectile.zSpeed = tileVz
  projectile.position = {
    projectilex,
    caster.position[2]
  }
  return projectile
end
local function projectile2_update(basefunc, projectile2, dt)
  local skill = projectile2.skill
  local info = projectile2.skill.info
  local distance = projectile2.tile_distance - 160 * dt
  while distance <= 0 do
    local location = {
      projectile2.position[1] - distance,
      projectile2.position[2]
    }
    skill:takeEffectAt(location, projectile2)
    distance = distance + trigger_distance
  end
  projectile2.tile_distance = distance
  basefunc(projectile2, dt)
  if projectile2.distance >= 310 then
    if not projectile2.fadeout_timer then
      projectile2.velocity = {0, 0}
      projectile2.fadeout_timer = 0.5
    else
      projectile2.fadeout_timer = projectile2.fadeout_timer - dt
    end
    if 0 > projectile2.fadeout_timer then
      projectile2:terminate()
    end
  end
  return
end
local function skillmeteor_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  if source and source.tile2 then
    basefunc(skill, location, source)
  else
    skill.info = ed.wraptable(originfo, {
      ["Point Effect"] = "eff_point_Kael_atk2_2.cha",
      ["Point Zorder"] = 1,
      ["Tile OTT Height"] = 50,
      ["Tile Art"] = "eff_tile_Kael_atk2.cha"
    })
    basefunc(skill, location, source)
    skill:selectTarget()
    local projectile2 = ed.ProjectileCreate(skill)
    projectile2.tile2 = true
    projectile2.update = override(projectile2.update, projectile2_update)
    projectile2.height = 35
    projectile2.velocity = {
      160 * skill.meteorDirection,
      0
    }
    projectile2.tile_distance = trigger_distance
    projectile2.position = {
      location[1],
      location[2]
    }
    ed.engine:addProjectile(projectile2)
    skill.info = originfo
  end
end
local swiftbuff_onRemoved = function(basefunc, buff)
  if buff.originfo then
    buff.owner.basic_skill.info = buff.originfo
  end
  basefunc(buff)
end
local function skillswift_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local targetBasicSkill = buff.owner.basic_skill
  local originfo = targetBasicSkill.info
  buff.originfo = originfo
  targetBasicSkill.cd_remaining = 0
  targetBasicSkill.info = ed.wraptable(originfo, {
    ["CD"] = 0,
    ["Global CD"] = 1
  })
  buff.onRemoved = override(buff.onRemoved, swiftbuff_onRemoved)
  return buff
end
local function skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local balltime = skill.info["Script Arg1"]
  if skill.attack_counter <= 6 then
    skill.attack_counter = skill.attack_counter + 1
    if skill.attack_counter > 1 then
      deliverRandBall(caster, caster, 1, balltime, true, skill, true)
    end
  else
    deliverRandBall(caster, caster, 1, balltime, true, skill, true)
    basefunc(skill)
  end
end
local skillicewall_takeEffectAt = function(basefunc, skill, location)
  local caster = skill.caster
  local origin = {
    location[1],
    0
  }
  basefunc(skill, origin)
end
local function skillatk_startPhase(basefunc, skill, idx)
  local id = math.floor(ed.rand() * 2 + 1)
  basefunc(skill, id)
end
local skillatk_onPhaseFinished = function(basefunc, skill)
  skill:finish()
end
local function skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 2 then
    deliverRandBall(caster, caster, 1, 6, false, skill, true)
  end
  basefunc(skill)
end
local skillskyfire_power = function(basefunc, skill, source, target)
  local power, coefficient = basefunc(skill, source, target)
  if not skill.affectnum then
    skill.affectnum = 1
  end
  return power / skill.affectnum, coefficient
end
local function skillskyfire_takeEffectAt(basefunc, skill, location, source)
  local info = skill.info
  local direction = skill.caster.direction
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  local affectlist = {}
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == skill.caster then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        table.insert(affectlist, unit)
      end
    end
  end
  skill.affectnum = #affectlist or 1
  basefunc(skill, location, source)
end
local function init_hero(hero)
  local skillshock = hero.skills.Kael_all
  local skillfrozen = hero.skills.Kael_ice3
  local skillfireman = hero.skills.Kael_fire2ice
  local skillmagnet = hero.skills.Kael_lightning3
  local skillmeteor = hero.skills.Kael_fire2lightning
  local skillswift = hero.skills.Kael_lightning2fire
  local skillult = hero.skills.Kael_book
  local skillatk = hero.skills.Kael_atk
  local skillicewall = hero.skills.Kael_ice2fire
  local skillskyfire = hero.skills.Kael_fire3
  if skillshock then
	skillshock.createBuff = override(skillshock.createBuff, skillshock_createBuff)
  end
  if skillfrozen then
	skillfrozen.createBuff = override(skillfrozen.createBuff, skillfrozen_createBuff)
  end
  if skillfireman then
	skillfireman.takeEffectOn = override(skillfireman.takeEffectOn, skillfireman_takeEffectOn)
  end
  if skillmagnet then
	skillmagnet.takeEffectAt = override(skillmagnet.takeEffectAt, skillmagnet_takeEffectAt)
	skillmagnet.takeEffectOn = override(skillmagnet.takeEffectOn, skillmagnet_takeEffectOn)
  end	
  if skillmeteor then
	skillmeteor.createProjectile = override(skillmeteor.createProjectile, skillmeteor_createProjectile)
	skillmeteor.takeEffectAt = override(skillmeteor.takeEffectAt, skillmeteor_takeEffectAt)
  end
  if skillswift then
	skillswift.createBuff = override(skillswift.createBuff, skillswift_createBuff)
  end
  if skillult then
	skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  end
  if skillicewall then
	skillicewall.takeEffectAt = override(skillicewall.takeEffectAt, skillicewall_takeEffectAt)
  end
  if skillatk then
	skillatk.startPhase = override(skillatk.startPhase, skillatk_startPhase)
	skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, skillatk_onPhaseFinished)
	skillatk.onAttackFrame = override(skillatk.onAttackFrame, skillatk_onAttackFrame)
  end
  if skillskyfire then
	skillskyfire.takeEffectAt = override(skillskyfire.takeEffectAt, skillskyfire_takeEffectAt)
	skillskyfire.power = override(skillskyfire.power, skillskyfire_power)
  end
  
  hero.update = override(hero.update, update)
  hero.castSkill = override(hero.castSkill, castSkill)
  hero.reset = override(hero.reset, reset)
  hero.die = override(hero.die, die)
  hero.energy_ball_manager = ed.EnergyBallManagerCreate(hero)
  hero.showBall = showBall
  hero.skillConditon = KaelSkillElement
  hero.addEnergyBall = addEnergyBall
  hero.autoTapBall = autoTapBall
  hero.tapBall = tapBall
  hero.SpecialCheckEnableAi = SpecialCheckEnableAi
  hero.deliveredBalls = {}
  hero.orderedIdx = {}
  hero.isKael = true
  hero.displayBall = false
  hero.aiMode = false
  if ed.engine.arena_mode then
    hero.aiMode = true
  end
  if hero.camp == ed.emCampEnemy and not ed.engine.replayMode then
    hero.aiMode = true
  end
  hero.auto_combat = false
  hero.ultTime = 2
  hero.startUltTime = false
  if hero.camp == ed.emCampPlayer then
    ed.engine.playerKaelHero = hero
  else
    ed.engine.enemyKaelHero = hero
  end
  return hero
end
return init_hero

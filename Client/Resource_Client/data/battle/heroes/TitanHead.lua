local ed = ed
local shieldValue = 40000
local atk3level = 85
local location1, location2
local randomHeros = {}
local skill2_power = function(basefunc, skill, source, target)
  local caster = skill.caster
  return target.attribs.HP * caster.atk2damage, 1
end
local npc_onActionFinished = function(basefunc, npc)
  if npc.action_name == "Idle1change2" or npc.action_name == "atk2" then
    npc:setAction("Idle2", true, false)
  end
end
local buff_update = function(basefunc, self, dt)
  basefunc(self, dt)
end
local function skill5_buffOnRemoved(basefunc, buff)
  local caster = buff.owner
  if buff.shield > 0 then
  else
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      local bid1 = 123
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = unit:addBuff(binfo1, unit)
      unit:takeHeal(500, "mp", unit)
      unit:takeHeal(99999, "hp", unit)
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_TitanHead_atk5.cha", {
        buff.owner.position[1],
        buff.owner.position[2] - 1
      }, {
        buff.owner.direction,
        1
      }, nil, 0)
    end
    caster.maxDamage = 150000
  end
  if caster then
    caster:enterActionStage(2)
  end
  return basefunc(buff)
end
local skill5_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
end
local function skill5_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.shield = shieldValue
  buff.onRemoved = override(buff.onRemoved, skill5_buffOnRemoved)
  buff.update = override(buff.update, buff_update)
  return buff
end
local skillatk4_start = function(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.skill4damage = 1
end
local skill4_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.skill4damage = nil
end
local skillatk3_start = function(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local npc_up = caster.npc_up
  local npc_down = caster.npc_down
  npc_up:setAction("atk2", false, false)
  npc_down:setAction("atk2", false, false)
end
local skillatk4_update = function(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if caster.skill4damage and caster.skill4damage > caster.maxDamage then
    skill:finish()
    caster:hurt()
    caster.skill4damage = nil
  end
end
local newHero_update = function(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end
local function skillatk3_takeEffectAt(basefunc, skill, location, source)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    basefunc(skill, location, source)
  elseif attack_counter == 2 then
    local caster = skill.caster
    local proto = {
      _tid = randomHeros[(caster.heroindex + 1) % 10 + 1],
      _level = atk3level,
      _stars = caster.stars,
      _skill_levels = {
        caster.level,
        caster.level,
        caster.level,
        caster.level
      },
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      hp_mod = 0.8,
      dps_mod = 0.8,
      size_mod = 1.1
    }
    local newHero = ed.UnitCreate(proto, caster.camp, config)
    proto._tid = randomHeros[(caster.heroindex + 2) % 10 + 1]
    local newHero2 = ed.UnitCreate(proto, caster.camp, config)
    caster.heroindex = caster.heroindex + 2
    newHero.mDuration = 15
    newHero2.mDuration = 15
    newHero.update = override(newHero.update, newHero_update)
    newHero2.update = override(newHero2.update, newHero_update)
    newHero:setDeathWithEffectOrNot(true)
    newHero2:setDeathWithEffectOrNot(true)
    local bid1 = 89
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local bid2 = 111
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff1 = newHero:addBuff(binfo1, caster)
    local buff12 = newHero2:addBuff(binfo1, caster)
    local buff2 = newHero:addBuff(binfo2, caster)
    local buff22 = newHero2:addBuff(binfo2, caster)
    location1 = {
      caster.position[1] - 80,
      caster.position[2] + 30
    }
    location2 = {
      caster.position[1] - 90,
      caster.position[2] - 20
    }
    newHero.mp = 900
    newHero2.mp = 900
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_tp.cha", {
        location1[1],
        location1[2]
      }, {
        caster.direction,
        1
      }, nil, 1)
      ed.scene:playEffectOnScene("eff_point_tp.cha", {
        location2[1],
        location2[2]
      }, {
        caster.direction,
        1
      }, nil, 1)
    end
    newHero.direction = caster.direction
    newHero2.direction = caster.direction
    ed.engine:summonUnit(newHero, location1, caster, "Idle")
    ed.engine:summonUnit(newHero2, location2, caster, "Idle")
    caster.newHero = newHero
    caster.newHero2 = newHero2
  end
end
local function skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 800
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
local hero_takeDamage = function(basefunc, unit, amount, damage_type, field, source, coefficient, crit_mod)
  local dmg = basefunc(unit, amount, damage_type, field, source, coefficient, crit_mod)
  if unit.skill4damage then
    unit.skill4damage = unit.skill4damage + dmg
  end
  return dmg
end
local function skill6_start(basefunc, skill, target)
  local caster = skill.caster
  caster.useskill6 = true
  local npc_up = caster.npc_up
  local npc_down = caster.npc_down
  npc_up:setAction("Idle1change2", false, false)
  npc_down:setAction("Idle1change2", false, false)
  npc_up.onActionFinished = override(npc_up.onActionFinished, npc_onActionFinished)
  npc_down.onActionFinished = override(npc_down.onActionFinished, npc_onActionFinished)
  basefunc(skill)
end
local skill6_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.5
  caster.atk2damage = 0.16
  if caster then
    caster:enterActionStageFromOneStage(5)
  end
end
local function init_hero(hero)
  hero.takeDamage = override(hero.takeDamage, hero_takeDamage)
  hero.isBossCreateWithEffect = false
  hero:setDisapearWhenDie(false)
  local npc_up = ed.engine:createNpc(1, true, hero)
  local npc_down = ed.engine:createNpc(2, true, hero)
  hero.npc_up = npc_up
  hero.npc_down = npc_down
  local skillatk = hero.skills.TitanHead_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, skillatk_createProjectile)
  end
  local skillatk2 = hero.skills.TitanHead_atk2
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, skill2_power)
  end
  local skillatk3 = hero.skills.TitanHead_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, skillatk3_start)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, skillatk3_takeEffectAt)
  end
  local skillatk4 = hero.skills.TitanHead_atk4
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, skillatk_createProjectile)
    skillatk4.start = override(skillatk4.start, skillatk4_start)
    skillatk4.update = override(skillatk4.update, skillatk4_update)
    skillatk4.finish = override(skillatk4.finish, skill4_finish)
  end
  local skillatk5 = hero.skills.TitanHead_atk5
  if skillatk5 then
    skillatk5.createBuff = override(skillatk5.createBuff, skill5_createBuff)
  end
  local skillatk6 = hero.skills.TitanHead_atk6
  if skillatk6 then
    skillatk6.start = override(skillatk6.start, skill6_start)
    skillatk6.finish = override(skillatk6.finish, skill6_finish)
  end
  hero.atk2damage = 0.3
  hero.maxDamage = 50000
  hero.heroindex = -1
  for i = 1, 10 do
    local heroid = math.floor(ed.rand() * 49) + 1
    while heroid == 33 do
      heroid = math.floor(ed.rand() * 49) + 1
    end
    randomHeros[i] = heroid
    ed.PreloadPuppetRcsByUnitId(randomHeros[i])
  end
  return hero
end
return init_hero

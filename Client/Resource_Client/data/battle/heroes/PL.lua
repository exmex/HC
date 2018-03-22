local ed = ed
local TB_range_interval = 150
local mirror_time = 12
local TBult_atk_cd = 1.5
local LancerMirror2_update = function(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end
local LancerMirror_update = function(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end
local function skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local locationtb
  if attack_counter == 1 then
  end
  if attack_counter == 2 then
    local proto = {
      _tid = 147,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.config.hp_mod or 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
    local bid = 89
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = LancerMirror:addBuff(binfo, caster)
    LancerMirror.mDuration = mirror_time
    LancerMirror.update = override(LancerMirror.update, LancerMirror_update)
    LancerMirror:setDeathWithEffectOrNot(true)
    LancerMirror.direction = caster.direction
    locationtb = {
      caster.position[1],
      caster.position[2]
    }
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
    caster.LancerMirrorult = LancerMirror
  end
end
local function skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.Lancer_atk3
  local proto = {
    _tid = 147,
    _level = skillatk3.level or 1,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror:addBuff(binfo, caster)
  LancerMirror.mDuration = mirror_time
  LancerMirror.update = override(LancerMirror.update, LancerMirror_update)
  LancerMirror:setDeathWithEffectOrNot(true)
  LancerMirror.direction = caster.direction
  local locationtb = {
    target.position[1] + 70 * LancerMirror.direction,
    target.position[2]
  }
  if locationtb[1] > 799 or locationtb[1] < 1 then
    locationtb[1] = target.position[1] - 70 * LancerMirror.direction
  end
  local owner = skill.caster
  local skillatk3 = owner.skills.Lancer_atk3
  local mobrate = skillatk3.info["Script Arg2"]
  if skill.caster:isAlive() then
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
  end
  caster.LancerMirror3 = LancerMirror
end
local function skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local proto = {
    _tid = 147,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local LancerMirror1 = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror1:addBuff(binfo, caster)
  LancerMirror1.mDuration = mirror_time
  LancerMirror1.update = override(LancerMirror1.update, LancerMirror_update)
  LancerMirror1:setDeathWithEffectOrNot(true)
  local LancerMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror2:addBuff(binfo, caster)
  LancerMirror2.mDuration = mirror_time
  LancerMirror2.update = override(LancerMirror2.update, LancerMirror_update)
  LancerMirror2:setDeathWithEffectOrNot(true)
  LancerMirror1.direction = caster.direction
  local locationtb21 = {
    location[1] + LancerMirror1.direction * 40,
    location[2] + LancerMirror1.direction * 30
  }
  local locationtb22 = {
    location[1] + LancerMirror2.direction * 40,
    location[2] - LancerMirror2.direction * 30
  }
  caster.position[1] = caster.position[1] - LancerMirror1.direction * 40
  ed.engine:summonUnit(LancerMirror1, locationtb21, caster, "Birth")
  caster.LancerMirror21 = LancerMirror1
  ed.engine:summonUnit(LancerMirror2, locationtb22, caster, "Birth")
  caster.LancerMirror22 = LancerMirror2
end
local skillult_power = function(basefunc, self, source, target)
  local power, i = basefunc(self, source, target)
  local attack_counter = self.attack_counter
  if attack_counter == 2 then
    return 0, i
  end
  return power, i
end
local hero_die = function(basefunc, hero, killer)
  if hero.LancerMirror1 and hero.LancerMirror1:isAlive() then
    hero.LancerMirror1:die()
  end
  if hero.LancerMirror21 and hero.LancerMirror21:isAlive() then
    hero.LancerMirror21:die()
  end
  if hero.LancerMirror22 and hero.LancerMirror22:isAlive() then
    hero.LancerMirror22:die()
  end
  if hero.LancerMirror3 and hero.LancerMirror3:isAlive() then
    hero.LancerMirror3:die()
  end
  if hero.LancerMirror4 and hero.LancerMirror4:isAlive() then
    hero.LancerMirror4:die()
  end
  if hero.LancerMirrorult and hero.LancerMirrorult:isAlive() then
    hero.LancerMirrorult:die()
  end
  basefunc(hero, killer)
end
local skillminSQ = 18225
local function skillatk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local caster = self.caster
  local distanceSQ = (self.target.position[1] - caster.position[1]) ^ 2
  self.originfo = self.info
  if distanceSQ > skillminSQ then
    self.info = ed.wraptable(self.originfo, {
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 231,
      ["Shape Arg2"] = 150
    })
  else
    self.info = ed.wraptable(self.originfo, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 140,
      ["Shape Arg2"] = false
    })
  end
  if distanceSQ > skillminSQ then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end
local skillatk_onPhaseFinished = function(basefunc, self)
  self:finish()
end
local skillatk3_createProjectile = function(basefunc, skill)
  local projectile = basefunc(skill)
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  return projectile
end
local function skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter >= 2 and attack_counter <= 6 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 231
    })
    basefunc(skill)
    skill.info = originfo
  else
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 300
    })
    basefunc(skill)
    skill.info = originfo
  end
end
local skillatk_finish = function(basefunc, skill)
  skill.originfo = skill.info
  basefunc(skill)
end
local function init_hero(hero)
  hero.die = override(hero.die, hero_die)
  local skillult = hero.skills.Lancer_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, skillult_takeEffectAt)
    skillult.power = override(skillult.power, skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  end
  local skillatk2 = hero.skills.Lancer_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, skillatk2_takeEffectAt)
  end
  hero.info.mDuration = mirror_time
  local skillatk = hero.skills.Lancer_atk
  if skillatk then
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, skillatk_onPhaseFinished)
    skillatk.start = override(skillatk.start, skillatk_start)
    skillatk.finish = override(skillatk.finish, skillatk_finish)
  end
  local skillatk3 = hero.skills.Lancer_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, skillatk3_takeEffectOn)
    skillatk3.createProjectile = override(skillatk3.createProjectile, skillatk3_createProjectile)
  end
  return hero
end
return init_hero

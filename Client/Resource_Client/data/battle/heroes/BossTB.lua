local ed = ed
local TB_range_interval = 150
local mirror_time = 10
local TBult_atk_cd = 0.5
local skillatk3_onAttackFrame = function(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  basefunc(skill)
end
local skillatk3_canCastWithTarget = function(basefunc, skill, target)
  local hero = skill.caster
  if basefunc(skill, target) and hero.ultBuff then
    return true
  end
  return false
end
local TBMirror_update = function(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end
local function skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local proto = {
    _tid = 129,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank
  }
  if caster.ultBuff then
    proto._tid = 130
  end
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 0.5,
    dps_mod = caster.config.dps_mod / 3 or 1
  }
  local TBMirror1 = ed.UnitCreate(proto, caster.camp, config)
  local TBMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = TBMirror1:addBuff(binfo, caster)
  local buff2 = TBMirror2:addBuff(binfo, caster)
  TBMirror1.mDuration = mirror_time
  TBMirror1.update = override(TBMirror1.update, TBMirror_update)
  TBMirror1:setDeathWithEffectOrNot(true)
  TBMirror2.mDuration = mirror_time
  TBMirror2.update = override(TBMirror2.update, TBMirror_update)
  TBMirror2:setDeathWithEffectOrNot(true)
  local sDirection = caster.direction
  TBMirror1.direction = sDirection
  TBMirror2.direction = sDirection
  local locationtb1 = {
    location[1] + 50 * caster.direction,
    location[2] + 30
  }
  local locationtb2 = {
    location[1] + 50 * caster.direction,
    location[2] - 30
  }
  ed.engine:summonUnit(TBMirror1, locationtb1, caster)
  ed.engine:summonUnit(TBMirror2, locationtb2, caster)
  caster.TBMirror = {TBMirror1, TBMirror2}
  local TBMirror3 = ed.UnitCreate(proto, caster.camp, config)
  local TBMirror4 = ed.UnitCreate(proto, caster.camp, config)
  local buff3 = TBMirror3:addBuff(binfo, caster)
  local buff4 = TBMirror4:addBuff(binfo, caster)
  TBMirror3.mDuration = mirror_time
  TBMirror3.update = override(TBMirror3.update, TBMirror_update)
  TBMirror3:setDeathWithEffectOrNot(true)
  TBMirror4.mDuration = mirror_time
  TBMirror4.update = override(TBMirror4.update, TBMirror_update)
  TBMirror4:setDeathWithEffectOrNot(true)
  TBMirror3.direction = sDirection
  TBMirror4.direction = sDirection
  local locationtb3 = {
    location[1] - 100 * caster.direction,
    location[2] + 50
  }
  local locationtb4 = {
    location[1] - 100 * caster.direction,
    location[2] - 50
  }
  ed.engine:summonUnit(TBMirror3, locationtb3, caster)
  ed.engine:summonUnit(TBMirror4, locationtb4, caster)
  caster.TBMirror = {
    TBMirror1,
    TBMirror2,
    TBMirror3,
    TBMirror4
  }
end
local function skillult_buffOnRemoved(basefunc, buff)
  local skillatk = buff.owner.skills.BossTB_atk
  skillatk.info = skillatk.originfo
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  skillatk.cd_remaining = 1
  local owner = buff.owner
  owner.attack_range = owner.attack_range - TB_range_interval
  owner.ultBuff = nil
  basefunc(buff)
  owner:hurt()
  owner:setAction("Birth", false, true)
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel:setPortrait("UI/HERO/TB.jpg")
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/mp_rage.png"))
    end
    ed.scene:playEffectOnScene("eff_point_TB_ult.cha", {
      buff.owner.position[1],
      buff.owner.position[2] - 1
    }, {
      buff.owner.direction,
      1
    }, nil, 0)
  end
end
local function skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skillult_buffOnRemoved)
  local skillatk = buff.owner.skills.BossTB_atk
  skillatk.originfo = skillatk.info
  skillatk.info = ed.wraptable(skillatk.originfo, {
    ["Max Range"] = skillatk.info["Max Range"] + TB_range_interval,
    ["CD"] = TBult_atk_cd,
    ["Global CD"] = TBult_atk_cd,
    ["Gain MP"] = 0,
    ["Track Type"] = "projectile",
    ["AOE Origin"] = false,
    ["Plus Ratio"] = 0.9,
    ["Impact Effect"] = "eff_impact_TB_atk.cha"
  })
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  skillatk.cd_remaining = TBult_atk_cd
  buff.owner.attack_range = buff.owner.attack_range + TB_range_interval
  buff.owner.global_cd = TBult_atk_cd
  buff.owner.ultBuff = 1
  return buff
end
local skillult_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.position[1] = caster.position[1] - caster.direction * 127 * 1.2
end
local function skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local origin = {
      caster.position[1],
      caster.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_TB_ult3.cha"
      if effect_name then
        skill:selectTarget(caster)
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  else
    basefunc(skill, target)
  end
end
local function skillult_start(basefunc, skill, target)
  local bid = 90
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end
local function init_hero(hero)
  local skillatk2 = hero.skills.BossTB_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, skillatk2_takeEffectAt)
  end
  hero.info.mDuration = mirror_time
  local skillult = hero.skills.BossTB_atk6
  if skillult then
    skillult.createBuff = override(skillult.createBuff, skillult_createBuff)
    skillult.finish = override(skillult.finish, skillult_finish)
    skillult.start = override(skillult.start, skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  end
  local skillatk3 = hero.skills.BossTB_atk3
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, skillatk3_canCastWithTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, skillatk3_onAttackFrame)
  end
  return hero
end
return init_hero

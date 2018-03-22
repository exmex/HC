local ed = ed
local TB_range_interval = 150
local mirror_time = 25
local TBult_atk_cd = 1.5
local function skillatk3_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local bid = 17
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
  caster:removeBuff(buff)
end
local skillatk3_canCastWithTarget = function(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff then
    return false
  end
  return true
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
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local TBMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = TBMirror:addBuff(binfo, caster)
  TBMirror.mDuration = mirror_time
  TBMirror.update = override(TBMirror.update, TBMirror_update)
  TBMirror:setDeathWithEffectOrNot(true)
  TBMirror.direction = caster.direction
  local locationtb = {
    location[1],
    location[2] + 25
  }
  caster.position[2] = caster.position[2] - 25
  ed.engine:summonUnit(TBMirror, locationtb, caster)
  caster.TBMirror = TBMirror
end
local skillult_buffUpdate = function(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.mp == 0 then
    buff.owner.removeBuff(buff.owner, buff)
  end
end
local function skillult_buffOnRemoved(basefunc, buff)
  local skillatk = buff.owner.skills.TB_atk
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
  buff.update = override(buff.update, skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, skillult_buffOnRemoved)
  local skillatk = buff.owner.skills.TB_atk
  skillatk.originfo = skillatk.info
  skillatk.info = ed.wraptable(skillatk.originfo, {
    ["Max Range"] = skillatk.info["Max Range"] + TB_range_interval,
    ["CD"] = TBult_atk_cd,
    ["Global CD"] = TBult_atk_cd,
    ["Gain MP"] = 0,
    ["Track Type"] = "projectile",
    ["AOE Origin"] = false,
    ["Impact Effect"] = "eff_impact_TB_atk.cha"
  })
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  skillatk.cd_remaining = TBult_atk_cd
  buff.owner.attack_range = buff.owner.attack_range + TB_range_interval
  buff.owner.global_cd = TBult_atk_cd
  buff.owner.ultBuff = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel:setPortrait("UI/HERO/TBult.jpg")
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/mp_rage_2.png"))
    end
  end
  return buff
end
local skillult_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.position[1] = caster.position[1] - caster.direction * 127
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
local skillult_canCastWithTarget = function(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff or hero.mp < 500 then
    return false
  end
  return true
end
local function init_hero(hero)
  local skillult = hero.skills.TB_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, skillult_finish)
    skillult.start = override(skillult.start, skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  end
  local skillatk2 = hero.skills.TB_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, skillatk2_takeEffectAt)
  end
  hero.info.mDuration = mirror_time
  local skillatk3 = hero.skills.TB_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, skillatk3_takeEffectOn)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, skillatk3_canCastWithTarget)
  end
  ed.PreloadPuppetRcs("TBult")
  return hero
end
return init_hero

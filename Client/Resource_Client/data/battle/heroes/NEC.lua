local ed = ed
local base = ed.Entity
local function NECult_castManualSkill(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.NEC_ult.target
  if not target then
    return
  end
  target:unfreezeActor()
  local bid = 19
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, hero)
end
local function skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if not skill.NEC_ult_effect and skill.current_phase_elapsed > 0.1 then
    local origin = skill.target.position
    local scale = {
      skill.target.direction,
      1
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_NEC_ult.cha"
      if not effect_name then
        return
      end
      ed.scene:playEffectOnScene(effect_name, origin, scale, nil, 1)
    end
    skill.NEC_ult_effect = true
  end
end
local skillult_takeEffectOn = function(basefunc, skill, target)
  if not target:isAlive() then
    return
  end
  local losthp = target.attribs.HP - target.hp
  local ratio = skill.info["Script Arg1"] or 0
  local power = losthp * ratio
  local powermax = skill.info["Script Arg3"] or 0
  local powermin = skill.info["Script Arg4"] or 0
    --DIFF
  power = (power > powermax and powermax)  or (power < powermin  and powermin) or power
  skill.info["Basic Num"] = power
  basefunc(skill, target)
end
local function skillatk2_createProjectile(basefunc, skill)
  local shape = "circle"
  local arg1 = 220
  local arg2 = 0
  local caster = skill.caster
  skill:takeEffectOn(caster)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, caster.position)
    if unit ~= caster and ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
      local projectile = basefunc(skill)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end
local skillatk2_takeEffectOn = function(basefunc, skill, target)
  local caster = skill.caster
  if caster.camp == target.camp then
    skill.info["Damage Type"] = "Heal"
    skill.info["Impact Effect"] = "eff_impact_heal.cha"
  else
    skill.info["Damage Type"] = "AP"
    skill.info["Impact Effect"] = "eff_impact_slash.cha"
  end
  basefunc(skill, target)
end
local skillult_start = function(basefunc, skill)
  skill.NEC_ult_effect = nil
  basefunc(skill)
end
local function init_hero(hero)
  local skillult = hero.skills.NEC_ult
  hero.castManualSkill = override(hero.castManualSkill, NECult_castManualSkill)
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  skillult.update = override(skillult.update, skillult_update)
  skillult.start = override(skillult.start, skillult_start)
  local skillatk2 = hero.skills.NEC_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, skillatk2_takeEffectOn)
    skillatk2.createProjectile = override(skillatk2.createProjectile, skillatk2_createProjectile)
  end
  return hero
end
return init_hero

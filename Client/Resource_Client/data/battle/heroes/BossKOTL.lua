local ed = ed
local skill6_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, duration)
end
local function skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end
local skill6_finish = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.8
  if caster then
    caster:enterActionStageFromOneStage(2)
  end
  caster:endScalingAction()
end
local canTrigger = function(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end
local function onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
    end
    skill.caster.manually_casting = false
    skill.ultbegin = skill.current_phase_elapsed
    skill.attack_counter = 1
  else
    if skill.attack_counter == 1 then
      skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
      skill.ultcharge = math.min(5, skill.ultcharge) / 5
      basefunc(skill)
    else
    end
  end
end
local trigger = function(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end
local interrupt = function(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end
local power = function(basefunc, skill, source)
  local muti = 1
  if 1 <= skill.ultcharge then
    muti = 1.5
  end
  return basefunc(skill, source) * (0.3 + skill.ultcharge * muti), 1
end
local skill2_takeEffectOn = function(basefunc, skill, target)
  local caster = skill.caster
  if target:isAlive() then
    target:takeDamage((target.hp - 2) / caster.attribs.PDM, "Holy", "hp", caster)
  end
  local name = skill.info["Impact Effect"]
  if name and target.actor then
    local effect_z = skill.info["Impact Zorder"]
    target.actor:addEffect(name, effect_z)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.BossKOTL_atk4
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.onAttackFrame = override(skillult.onAttackFrame, onAttackFrame)
    skillult.canTrigger = override(skillult.canTrigger, canTrigger)
    skillult.trigger = override(skillult.trigger, trigger)
    skillult.interrupt = override(skillult.interrupt, interrupt)
    skillult.power = override(skillult.power, power)
  end
  local skill2 = hero.skills.BossKOTL_atk2
  if skill2 then
    skill2.takeEffectOn = override(skill2.takeEffectOn, skill2_takeEffectOn)
  end
  local skill6 = hero.skills.BossKOTL_atk6
  if skill6 then
    skill6.start = override(skill6.start, skill6_start)
    skill6.finish = override(skill6.finish, skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, skill6_onAttackFrame)
  end
  return hero
end
return init_hero

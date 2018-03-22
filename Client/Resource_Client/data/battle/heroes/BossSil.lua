local ed = ed
local takeEffectOn = function(basefunc, skill, target)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg1"]
    target:takeDamage(power, "Holy", "mp", skill.caster)
  end
  return succ
end
local function skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end
local skill6_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end
local function skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2)
  end
  local skill2 = caster.skills.BossSil_atk4
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {CD = 2})
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end
local function init_hero(hero)
  local skill = hero.skills.BossSil_atk3
  if skill then
    skill.takeEffectOn = override(skill.takeEffectOn, takeEffectOn)
  end
  local skill6 = hero.skills.BossSil_atk6
  if skill6 then
    skill6.start = override(skill6.start, skill6_start)
    skill6.finish = override(skill6.finish, skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, skill6_onAttackFrame)
  end
  return hero
end
return init_hero

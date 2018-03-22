local ed = ed
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
local launchPoint = function(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] - 400 * direction
  if position[1] < 1 then
    position[1] = 1
  end
  if position[1] > 799 then
    position[1] = 799
  end
  position[2] = 0
  height = 10
  return position, height
end
local function skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.5
  caster:enterActionStageFromOneStage(2)
  local skill2 = caster.skills.BossCoco_atk2
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {
    ["CD"] = 1,
    ["Shape Arg1"] = 500
  })
  caster:endScalingAction()
end
local function skill5_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if ed.run_with_scene then
    local effect_name = "eff_point_Coco_atk3.cha"
    if not effect_name then
      return
    end
    local effect_z = skill.info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, target.position, {
      target.direction,
      1
    }, nil, effect_z)
  end
end
local function init_hero(hero)
  local skill = hero.skills.BossCoco_atk4
  if skill then
    skill.launchPoint = override(skill.launchPoint, launchPoint)
  end
  local skill5 = hero.skills.BossCoco_atk5
  if skill5 then
    skill5.takeEffectOn = override(skill5.takeEffectOn, skill5_takeEffectOn)
  end
  local skill6 = hero.skills.BossCoco_atk6
  if skill6 then
    skill6.start = override(skill6.start, skill6_start)
    skill6.finish = override(skill6.finish, skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, skill6_onAttackFrame)
  end
  return hero
end
return init_hero

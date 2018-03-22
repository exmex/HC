local ed = ed
local timegap = 0.25
local collidedis = 30
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
  caster:startScalingAction(1.2, 0.8)
end
local function skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), collidedis))
      caster.walk_v = {
        d2[1] / timegap,
        d2[2] / timegap
      }
    end
  else
    local bid = 98
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end
local function skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2)
  end
  local caster = skill.caster
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 1.6
  local skillult = caster.skills.BossHuskar_atk3
  skillult.originfo = skillult.info
  skillult.info = ed.wraptable(skillult.originfo, {
    ["Plus Attr"] = "AD",
    ["CD"] = 10
  })
  caster:endScalingAction()
end
local function skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skill1 = caster.skills.BossHuskar_atk
  skill1.originfo = skill1.info
  skill1.info = ed.wraptable(skill1.originfo, {
    ["Global CD"] = 0,
    ["CD"] = 0.5
  })
  local skill2 = caster.skills.BossHuskar_atk2
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {
    ["Global CD"] = 0,
    ["CD"] = 0.5
  })
end
local function init_hero(hero)
  local skillatk = hero.skills.BossHuskar_atk
  local skillult = hero.skills.BossHuskar_atk3
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  skillult.finish = override(skillult.finish, skillult_finish)
  local skill6 = hero.skills.BossHuskar_atk6
  if skill6 then
    skill6.start = override(skill6.start, skill6_start)
    skill6.finish = override(skill6.finish, skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, skill6_onAttackFrame)
  end
  return hero
end
return init_hero

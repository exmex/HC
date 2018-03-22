local range_interval = 150
local atk2_cost_hp = 20
local ed = ed
local function skill2_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills.Marine_atk
  skillatk.info = skillatk.originfo
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  owner.attack_range = owner.attack_range + range_interval
  owner.medBuff = nil
  return basefunc(buff)
end
local skillult_onPhaseFinished = function(basefunc, skill)
  basefunc(skill)
  local position = skill.caster.position
  position[1] = position[1] - 40
end
local function skillult_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 140,
      ["Point Effect"] = false,
      ["Knock Back"] = 70,
      ["Knock Up"] = 0.2,
      ["Basic Num"] = 10,
      ["Plus Ratio"] = 0.3
    })
    basefunc(skill, location, source)
    skill.info = originfo
  elseif attack_counter == 2 then
    basefunc(skill, location, source)
  end
end
local function skillult_takeEffectOn(basefunc, skill, target, source)
  if skill.attack_counter == 1 then
    local bid = 92
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  end
  basefunc(skill, target, source)
end
local function skillatk2_createBuff(basefunc, skill, target)
  local hpcost = target.attribs.HP * skill.info["Cost HP"] * 0.01
  target.takeDamage(target, hpcost, "Holy", "hp", skill.caster)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk = caster.skills.Marine_atk
  skillatk.originfo = skillatk.info
  skillatk.info = ed.wraptable(skillatk.originfo, {
    ["Max Range"] = skillatk.info["Max Range"] - range_interval,
    ["Gain MP"] = 30
  })
  skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  skillatk.cd_remaining = 0
  caster.attack_range = caster.attack_range - range_interval
  caster.medBuff = true
  buff.onRemoved = override(buff.onRemoved, skill2_buffOnRemoved)
  return buff
end
local function skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if skill.caster.medBuff then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end
local skillatk_onPhaseFinished = function(basefunc, skill)
  skill:finish()
end
local skillatk_power = function(basefunc, skill, source, target)
  local caster = skill.caster
  local power, i = basefunc(skill, source, target)
  return power * 0.5 ^ (skill.attack_counter - 1), i
end
local skillatk2_canCastWithTarget = function(basefunc, skill, target)
  local caster = skill.caster
  local hpcost = caster.attribs.HP * skill.info["Cost HP"] * 0.01
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if hpcost > caster.hp then
    return false, "hp"
  end
  if caster.current_skill and caster.current_skill.info["Skill Name"] == "Marine_ult" then
    return false, "ult"
  end
  if caster.medBuff then
    return false, "medBuff"
  end
  return true
end
local hero_update = function(basefunc, hero, dt)
  basefunc(hero, dt)
  local skill2 = hero.skills.Marine_atk2
  hero.can_cast_manual = hero.can_cast_manual or skill2 and skill2:canCastWithTarget(hero.ai.target)
end
local hero_castManualSkill = function(basefunc, hero)
  local skill2 = hero.skills.Marine_atk2
  if skill2 and hero.mp < 1000 and skill2:canCastWithTarget(hero.ai.target) then
    hero:castSkill(hero.skills.Marine_atk2, hero)
  else
    basefunc(hero)
  end
end
local function hero_ai_findSkillToCast(basefunc, ai)
  local skill = basefunc(ai)
  if skill and skill.info["Skill Name"] == "Marine_atk2" then
    local caster = skill.caster
    if ed.engine.arena_mode or caster.getSide(caster) == "right" then
      return skill
    end
    return caster.skills.Marine_atk
  end
  return skill
end
local function init_hero(hero)
  local skillult = hero.skills.Marine_ult
  skillult.onPhaseFinished = override(skillult.onPhaseFinished, skillult_onPhaseFinished)
  skillult.takeEffectAt = override(skillult.takeEffectAt, skillult_takeEffectAt)
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  local skillatk2 = hero.skills.Marine_atk2
  if skillatk2 then
    skillatk2.info["Cost HP"] = atk2_cost_hp
    skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, skillatk2_canCastWithTarget)
  end
  local skillatk = hero.skills.Marine_atk
  skillatk.start = override(skillatk.start, skillatk_start)
  skillatk.power = override(skillatk.power, skillatk_power)
  skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, skillatk_onPhaseFinished)
  hero.update = override(hero.update, hero_update)
  hero.castManualSkill = override(hero.castManualSkill, hero_castManualSkill)
  hero.ai.findSkillToCast = override(hero.ai.findSkillToCast, hero_ai_findSkillToCast)
  return hero
end
return init_hero

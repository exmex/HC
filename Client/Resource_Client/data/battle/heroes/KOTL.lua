local canTrigger = function(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end
local onAttackFrame = function(basefunc, skill)
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
  return basefunc(skill, source) * skill.ultcharge, 1
end
local function init_hero(hero)
  local skillult = hero.skills.KOTL_ult
  skillult.info["No Speeder"] = true
  skillult.onAttackFrame = override(skillult.onAttackFrame, onAttackFrame)
  skillult.canTrigger = override(skillult.canTrigger, canTrigger)
  skillult.trigger = override(skillult.trigger, trigger)
  skillult.interrupt = override(skillult.interrupt, interrupt)
  skillult.power = override(skillult.power, power)
  return hero
end
return init_hero

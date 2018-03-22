local skillminSQ = 14400
local function skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  local distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  if distanceSQ > skillminSQ then
    skill:startPhase(1)
  else
    skill:startPhase(2)
  end
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end
local skillatk2_takeEffectAt = function(basefunc, skill, location, source)
  if skill.current_phase_idx == 1 then
    skill.caster.position = {
      skill.target.position[1] - skill.caster.direction * 70,
      skill.target.position[2]
    }
  else
    basefunc(skill, location, source)
  end
end
local skillatk2_takeEffectOn = function(basefunc, skill, target, source)
  local mppower = skill.info["Script Arg2"]
  basefunc(skill, target, source)
  target:takeDamage(mppower, "Holy", "mp", skill.caster)
end
local skillult_takeEffectAt = function(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 70
      if skill.target.buff_effects.stable or position1 > 799 or position1 < 1 then
        position1 = position1 - caster.direction * 140
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.AM_ult
  local skillatk2 = hero.skills.AM_atk2
  skillult.takeEffectAt = override(skillult.takeEffectAt, skillult_takeEffectAt)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, skillatk2_start)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, skillatk2_takeEffectAt)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, skillatk2_takeEffectOn)
  end
  return hero
end
return init_hero

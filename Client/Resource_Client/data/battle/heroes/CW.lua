local skillatk3_start = function(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster.camp
  caster.walk_v = {
    250 * caster.camp,
    0
  }
end
local skillatk3_onAttackFrame = function(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 2 then
    basefunc(skill)
  end
end
local function init_hero(hero)
  local skillatk3 = hero.skills.CW_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, skillatk3_onAttackFrame)
  end
  return hero
end
return init_hero

local skillatk2_start = function(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster.camp
  local distance = 240 * caster.camp
  local time = skill.current_phase.duration
  local v = distance / time
  caster.walk_v = {
    caster.direction * v,
    0
  }
end
local skillatk2_onAttackFrame = function(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  basefunc(skill)
end
local function init_hero(hero)
  local skillatk2 = hero.skills.POM_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, skillatk2_onAttackFrame)
  end
  return hero
end
return init_hero

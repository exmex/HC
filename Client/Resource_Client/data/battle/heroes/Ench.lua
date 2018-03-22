local ed = ed
local skillatk3_takeEffectOn = function(basefunc, skill, target)
  basefunc(skill, target)
  target.basic_skill.cd_remaining = 0
  target.global_cd = 0
end
local function init_hero(hero)
  local skillatk3 = hero.skills.Ench_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, skillatk3_takeEffectOn)
  end
  return hero
end
return init_hero

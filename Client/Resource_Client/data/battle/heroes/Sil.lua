local ed = ed
local takeEffectOn = function(basefunc, skill, target)
  local succ = basefunc(skill, target)
  if succ then
    local power = skill.info["Script Arg1"]
    target:takeDamage(power, "Holy", "mp", skill.caster)
  end
  return succ
end
local function init_hero(hero)
  local skill = hero.skills.Sil_atk3
  if skill then
    skill.takeEffectOn = override(skill.takeEffectOn, takeEffectOn)
  end
  return hero
end
return init_hero

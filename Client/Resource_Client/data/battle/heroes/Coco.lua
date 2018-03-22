local launchPoint = function(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] - 400 * direction
  position[2] = 0
  height = 10
  return position, height
end
local function init_hero(hero)
  local skill = hero.skills.Coco_ult
  if skill then
    skill.launchPoint = override(skill.launchPoint, launchPoint)
  end
  return hero
end
return init_hero

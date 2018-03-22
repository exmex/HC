local createProjectile = function(basefunc, skill)
  local projectile = basefunc(skill)
  if not skill.target then
    return
  end
  projectile:enableTrack(skill.target)
  return projectile
end
local function init_hero(hero)
  local skillult = hero.skills.Viper_ult
  skillult.createProjectile = override(skillult.createProjectile, createProjectile)
  return hero
end
return init_hero

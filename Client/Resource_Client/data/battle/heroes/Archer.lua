local ed = ed
local function skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local distance = ed.edpSub(skill.target.position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
end
local function init_hero(hero)
  local skill_atk2 = hero.skills.Archer_atk2
  if skill_atk2 then
    skill_atk2.createProjectile = override(skill_atk2.createProjectile, skillatk2_createProjectile)
  end
  return hero
end
return init_hero

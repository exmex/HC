local ed = ed
local offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}
local function createProjectile(basefunc, skill)
  local count = (skill.info["Script Arg1"] - skill.attack_counter) / 5 + 1
  local origtarget = skill.target
  for i = 1, count do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    if i > 1 then
      skill:selectTarget()
    end
    if i == 1 or skill.target ~= origtarget then
      local target_position = {
        skill.target.position[1] + offset_list[i][1] * skill.caster.camp,
        skill.target.position[2] + offset_list[i][2]
      }
      local distance = ed.edpSub(target_position, skill.caster.position)
      projectile.velocity = ed.edpMult(distance, 1 / t)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end
local function init_hero(hero)
  local skill = hero.skills.DR_ult
  skill.createProjectile = override(skill.createProjectile, createProjectile)
  return hero
end
return init_hero

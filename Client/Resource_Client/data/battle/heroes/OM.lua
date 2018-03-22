local ed = ed
local multicast_table = {
  OM_ult = {
    0,
    40,
    35,
    25
  },
  OM_atk2 = {
    60,
    32,
    8
  },
  OM_atk3 = {
    50,
    35,
    10,
    5
  }
}
local function OM_rand(skill)
  local prob_table = multicast_table[skill.info["Skill Name"]]
  local rand = ed.rand() * 100
  local times = #prob_table
  for i, v in ipairs(prob_table) do
    rand = rand - v
    if rand < 0 then
      times = i
      break
    end
  end
  if ed.run_with_scene and times > 1 then
    local str
    local color = skill.caster.camp == emCampPlayer and "red" or "blue"
    if times == 2 then
      str = "multicast_x2"
    elseif times == 3 then
      str = "multicast_x3"
    elseif times == 4 then
      str = "multicast_x4"
    end
    ed.PopupCreate(str, color, skill.caster.actor, nil, "text")
  end
  return times
end
local function OM_select_targets(skill)
  local times = OM_rand(skill)
  local list = {}
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    table.insert(list, {
      unit,
      ed.rand()
    })
  end
  table.sort(list, function(a, b)
    return a[2] > b[2]
  end)
  local count = math.min(times, #list)
  local ret = {}
  for i = 1, count do
    ret[i] = list[i][1]
  end
  return ret
end
local function skillult_takeEffectOn(basefunc, skill, target)
  local times = OM_rand(skill)
  for i = 1, times do
    basefunc(skill, target)
  end
end
local function skill2_createProjectile(basefunc, skill)
  local targets = OM_select_targets(skill)
  for i, unit in ipairs(targets) do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    local target_position = unit.position
    local distance = ed.edpSub(target_position, projectile.position)
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return nil
end
local function skill3_takeEffectOn(basefunc, skill, target)
  local targets = OM_select_targets(skill)
  for i, unit in ipairs(targets) do
    basefunc(skill, unit)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.OM_ult
  local skillatk2 = hero.skills.OM_atk2
  local skillatk3 = hero.skills.OM_atk3
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, skill2_createProjectile)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, skill3_takeEffectOn)
  end
  return hero
end
return init_hero

local ed = ed
local sniperult_castManualSkill = function(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.Sniper_ult.target
  target:unfreezeActor()
end
local function skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.target:unfreezeActor()
  local bid = 14
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = skill.target:addBuff(binfo, caster)
end
local function skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end
local function init_hero(hero)
  local sniper = hero
  local skillult = hero.skills.Sniper_ult
  local skillatk3 = hero.skills.Sniper_atk3
  skillult.start = override(skillult.start, skillult_start)
  sniper.castManualSkill = override(sniper.castManualSkill, sniperult_castManualSkill)
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, skillatk3_createProjectile)
  end
  return hero
end
return init_hero

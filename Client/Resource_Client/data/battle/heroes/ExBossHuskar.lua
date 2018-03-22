local ed = ed
local timegap = 0.25
local collidedis = 30
local name = "ExBossHuskar"
local function reset(basefunc, hero)
  basefunc(hero)
  if not hero.has_resetted then
    hero.has_resetted = true
    local owner = hero
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    owner:addBuff(buff, owner)
  end
end
local function skill_atk2_createProjectile(basefunc, skill)
  local skill5 = skill.caster.skills[name .. "_atk5"]
  if skill.target and skill.target.config and skill.target.config.is_summoned then
    local shortCD = 5.5
    skill5.cd_remaining = skill5.cd_remaining / skill5.info.CD * shortCD
    skill5.info = ed.wraptable(skill5.originfo, {CD = shortCD})
  else
    local longCD = 10
    skill5.cd_remaining = skill5.cd_remaining / skill5.info.CD * longCD
    skill5.info = ed.wraptable(skill5.originfo, {CD = longCD})
  end
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  return projectile
end
local function skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), collidedis))
      caster.walk_v = {
        d2[1] / timegap,
        d2[2] / timegap
      }
    end
  else
    local bid = 98
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    local perc = 24.3
    local leftHp = math.max(caster.attribs.HP * 0.003, caster.hp - caster.attribs.HP * perc / 100)
    local damage = caster.hp - leftHp
    caster:setHP(leftHp)
    if ed.run_with_scene then
      local floor = math.floor
      local str = "-" .. floor(damage + 0.5)
      if str ~= "-0" then
        local color = "orange"
        ed.PopupCreate(str, color, caster.actor, false)
      end
    end
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end
local skillult_finish = function(basefunc, skill)
  basefunc(skill)
end
local skillatk2_power = function(basefunc, skill, source, target)
  local ratio = 0.08
  local power = target.attribs.HP * ratio
  print("ExBossHuskar|" .. ratio .. " target:" .. target.info.Name .. " power:" .. power .. " hp:" .. target.attribs.HP)
  return power, 1
end
local function init_hero(hero)
  hero.reset = override(hero.reset, reset)
  local skill2 = hero.skills[name .. "_atk2"]
  skill2.createProjectile = override(skill2.createProjectile, skill_atk2_createProjectile)
  local skillult = hero.skills[name .. "_atk3"]
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  skillult.finish = override(skillult.finish, skillult_finish)
  local skill5 = hero.skills[name .. "_atk5"]
  skill5.originfo = skill5.info
  return hero
end
return init_hero

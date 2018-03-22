local ed = ed
local function skill2_createBuff(basefunc, skill, target)
  if target.info["Can Fly"] then
    local caster = skill.caster
    local bid = 110
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, caster)
  end
  return basefunc(skill, target)
end
local function init_hero(hero)
  local skill2 = hero.skills.Sorceress_atk2
  if skill2 then
    skill2.createBuff = override(skill2.createBuff, skill2_createBuff)
  end
  return hero
end
return init_hero

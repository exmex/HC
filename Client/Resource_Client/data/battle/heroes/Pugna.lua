local ed = ed
local function skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local bid = 17
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
  caster:removeBuff(buff)
end
local function init_hero(hero)
  local skillult = hero.skills.Pugna_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  return hero
end
return init_hero

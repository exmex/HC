local ed = ed
local function skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end
local skillatk_takeEffectAt = function(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  caster:die(source)
end
local function init_hero(hero)
  local skillatk = hero.skills.SuicideGoblinjr_atk
  skillatk.start = override(skillatk.start, skillatk_start)
  skillatk.takeEffectAt = override(skillatk.takeEffectAt, skillatk_takeEffectAt)
  return hero
end
return init_hero

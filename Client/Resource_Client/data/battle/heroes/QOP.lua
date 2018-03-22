local start = function(basefunc, skill, target)
  basefunc(skill, target)
  local bid = skill.info["Script Arg1"]
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
end
local function init_hero(hero)
  local skill = hero.skills.QOP_atk3
  if skill then
    skill.start = override(skill.start, start)
  end
  return hero
end
return init_hero

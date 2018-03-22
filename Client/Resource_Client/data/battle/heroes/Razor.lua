local ed = ed
local function skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local info = skill.info
  local bid = info["Script Arg1"]
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  binfo.AD = -info.buff_info.AD
  caster:addBuff(binfo, caster)
end
local function init_hero(hero)
  local skillatk3 = hero.skills.Razor_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, skillatk3_takeEffectOn)
  end
  return hero
end
return init_hero

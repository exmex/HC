local skill3_attack_range = 0
local function walkTo(basefunc, ai, dest)
  local owner = ai.owner
  local old_range = owner.attack_range
  if dest.what == "Unit" and dest.info["Position Type"] ~= T(LSTR("UNIT.FRONT_ROW")) then
    owner.attack_range = skill3_attack_range
  end
  basefunc(ai, dest)
  owner.attack_range = old_range
end
local function init_hero(hero)
  local skill3 = hero.skills.Troll_atk3
  if skill3 then
    skill3_attack_range = skill3.info["Max Range"]
    hero.ai.walkTo = override(hero.ai.walkTo, walkTo)
  end
  return hero
end
return init_hero

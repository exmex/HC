local takeEffectOn = function(basefunc, skill, target)
  if target.info["Main Attrib"] == "INT" then
    if ed.run_with_scene then
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local str = "immune"
      ed.PopupCreate(str, color, target.actor, nil, "text")
    end
    return false
  else
    return basefunc(skill, target)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.OD_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, takeEffectOn)
  return hero
end
return init_hero

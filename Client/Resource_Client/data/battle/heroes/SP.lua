local onDamaged = function(basefunc, buff, damage)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  if damage <= maxdmg then
    return damage
  else
    local absorption = damage - maxdmg
    if absorption < buff.shield then
      buff.shield = buff.shield - absorption
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate("funeral", color, owner.actor, nil, "text")
      end
    else
      absorption = buff.shield
      buff.shield = 0
      buff.owner:removeBuff(buff)
    end
    return damage - absorption
  end
end
local function createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, onDamaged)
  return buff
end
local function init_hero(hero)
  local skill = hero.skills.SP_atk3
  if skill then
    skill.createBuff = override(skill.createBuff, createBuff)
  end
  return hero
end
return init_hero

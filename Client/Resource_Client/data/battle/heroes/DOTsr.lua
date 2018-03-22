local ed = ed
local buff_update = function(basefunc, buff, dt)
  basefunc(buff, dt)
  local time = buff.timer
  if buff.owner.actor then
    if time > 2.3 then
      buff.owner.actor.zSpeed = 280
    else
      buff.owner.actor.zSpeed = 80 * math.sin(math.rad(time * 360)) + 100
    end
  end
end
local function skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, buff_update)
  return buff
end
local function init_hero(hero)
  local skillatk2 = hero.skills.DOTsr_atk2
  skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
  return hero
end
return init_hero

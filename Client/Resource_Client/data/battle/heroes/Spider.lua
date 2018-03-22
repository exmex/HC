local skillatk2_buffUpdate = function(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.timeTag = buff.timeTag - dt
  local owner = buff.owner
  if buff.timeTag <= 0 then
    buff.timeTag = buff.timeTag + 1
    owner.takeHeal(owner, owner.attribs.HP * 0.1, "HP")
  end
  if owner.hp == owner.attribs.HP then
    owner.global_cd = 3
    owner:removeBuff(buff)
  end
  for i, buf in ipairs(owner.buff_list) do
    if buf.info.Name ~= "Spider_atk2" then
      for j, effect in ipairs(buf.info["Control Effects"]) do
        if string.find(effect, "stun") or string.find(effect, "frozen") or string.find(effect, "silence") then
          owner.global_cd = 3
          owner:removeBuff(buff)
          return
        end
      end
    end
  end
end
local skillatk2_buffonRemoved = function(basefunc, skill)
  basefunc(skill)
end
local function skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timeTag = 1
  buff.update = override(buff.update, skillatk2_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, skillatk2_buffonRemoved)
  return buff
end
local skillatk2_canCastWithTarget = function(basefunc, skill, target)
  local caster = skill.caster
  if caster.hp < caster.attribs.HP * 0.3 then
    return basefunc(skill, target)
  end
  return false, "hp too much"
end
local function init_hero(hero)
  local skillatk2 = hero.skills.Spider_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, skillatk2_canCastWithTarget)
  end
  return hero
end
return init_hero

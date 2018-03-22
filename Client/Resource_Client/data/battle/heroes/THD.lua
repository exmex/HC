local ed = ed
local function buff_onRemoved(basefunc, buff)
  if buff.timer <= 0 then
    local bid = 70
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = buff.owner:addBuff(binfo, buff.caster)
  end
  basefunc(buff)
end
local function skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, buff_onRemoved)
  return buff
end
local function init_hero(hero)
  local skillult = hero.skills.THD_ult
  skillult.createBuff = override(skillult.createBuff, skillult_createBuff)
  return hero
end
return init_hero

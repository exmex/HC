local percentPerSec = 0.213
local name = "ExBossSpider"
local reset = function(basefunc, hero)
  basefunc(hero)
  if not hero.has_resetted then
    hero.has_resetted = true
    local owner = hero
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    hero.uncon_buff = buff
    owner:addBuff(buff, owner)
  end
end
local function skillatk2_start(basefunc, skill, target)
  local self = skill.caster
  local list = self.buff_list
  local debuff_list = {}
  local my_camp = self.camp
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp ~= my_camp or buff.info.Name == "ExBossSpider_Invulnerable") then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    self:removeBuff(debuff_list[i])
  end
  local bid = 159
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local owner = skill.caster
  local buff = ed.BuffCreate(binfo, owner, owner)
  owner:addBuff(buff, owner)
  local lackPercent = 1 - owner.hp / owner.attribs.HP
  owner.needMakeupPercent = math.min(0.618, lackPercent) * percentPerSec
  basefunc(skill, target)
end
local skillatk2_buffUpdate = function(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  buff.timeTag = buff.timeTag - dt
  if buff.timeTag <= 0 then
    buff.timeTag = buff.timeTag + 1
    local curMakeup = owner.needMakeupPercent * owner.attribs.HP
    if owner.hp < owner.attribs.HP then
      owner.takeHeal(owner, curMakeup, "HP")
    end
    owner.needMakeupPercent = owner.needMakeupPercent * 0.9
  end
end
local skillatk2_buffonRemoved = function(basefunc, skill)
  basefunc(skill)
  skill.caster.global_cd = 1.5
  local owner = skill.caster
  for i, buf in ipairs(owner.buff_list) do
    if buf.info.Name == "ExBossSpider_Invulnerable" then
      owner:removeBuff(buf)
      break
    end
  end
  owner:addBuff(owner.uncon_buff, owner)
end
local skillatk2_onAttackFrame = function(basefunc, skill)
  local owner = skill.caster
  for _, buf in ipairs(owner.buff_list) do
    if buf.info.Name == "ExBossSpider_Invulnerable" then
      owner:removeBuff(buf)
      break
    end
  end
  for _, buf in ipairs(owner.buff_list) do
    if buf.info.Name == owner.uncon_buff.info.Name then
      owner:removeBuff(buf)
      break
    end
  end
  basefunc(skill)
end
local function skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timeTag = 0.5
  buff.update = override(buff.update, skillatk2_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, skillatk2_buffonRemoved)
  return buff
end
local skillatk4_buffUpdate = function(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  buff.timeTag = buff.timeTag - dt
  if buff.timeTag <= 0 then
    buff.timeTag = buff.timeTag + 1
    owner:takeDamage(buff.damagePerSec, "AP", "hp", buff.caster, 1, 0)
  end
end
local function skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.damagePerSec = skill.info["Script Arg1"]
  buff.timeTag = 0.5
  buff.update = override(buff.update, skillatk4_buffUpdate)
  return buff
end
local function init_hero(hero)
  hero.reset = override(hero.reset, reset)
  local skillatk2 = hero.skills[name .. "_atk2"]
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, skillatk2_createBuff)
  end
  local skillatk4 = hero.skills[name .. "_atk4"]
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, skillatk4_createBuff)
  end
  return hero
end
return init_hero

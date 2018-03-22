local ed = ed
local skill_createBuff = function(basefunc, skill, target)
  local buff = basefunc(skill, target)
  return buff
end
local skill_buffOnRemoved = function(basefunc, buff)
  local owner = buff.owner
  local skill = owner.skills.Phoenix_pasv
  if owner:isAlive() then
    owner:setHP(skill.info["Script Arg2"] * (owner.config.hp_mod or 1))
  end
  local owner = buff.owner
  owner.isDandan = false
  return basefunc(buff)
end
local skill_buff2OnRemoved = function(basefunc, buff)
  local owner = buff.owner
  local skillatk3 = owner.skills.Phoenix_atk3
  if skillatk3 then
    owner:castSkill(skillatk3, skillatk3.target)
  end
  return basefunc(buff)
end
local function die(basefunc, self, killer)
  local skill = self.skills.Phoenix_pasv
  if not self.isDandan and self.custom_data ~= 3 then
    self.isDandan = true
    if self.custom_data == nil then
      self.custom_data = 1
    else
      self.custom_data = self.custom_data + 1
    end
    self:removeAllBuffs()
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    if self.custom_data == 1 then
      self.hp = 4
    elseif self.custom_data == 2 then
      self.hp = 3
    elseif self.custom_data == 3 then
      self.hp = 2
    end
    self.mp = 0
    local bid = 129
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = self:addBuff(binfo, self)
    buff.onRemoved = override(buff.onRemoved, skill_buffOnRemoved)
    local bid = 126
    local binfo2 = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo2, self)
    buff2.onRemoved = override(buff2.onRemoved, skill_buff2OnRemoved)
    local bid = 135
    local binfo2 = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo2, self)
    self.state = ed.emUnitState_Birth
    local skillatk4 = self.skills.Phoenix_pasv
    if skillatk4 then
      self:castSkill(skillatk4, skillatk4.target)
    end
  else
    self.custom_data = 0
    basefunc(self, killer)
  end
end
local skill_getLostHPAfterImmunity = function(basefunc, self, damage, immunity)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 129 then
      return 1
    end
  end
  return basefunc(self, damage, immunity)
end
local skillult_getDamage = function(basefunc, self, target, power, damage_type, field, source, crit_mod)
  coefficient = 0.25
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    coefficient = 0.25,
    crit_mod = crit_mod
  })
  return dmg
end
local function skill2_buffOnRemoved(basefunc, buff)
  local skill = buff.caster.skills.Phoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "projectile/Lina_atk_tile.png",
    ["AOE Origin"] = false,
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "0",
    ["Point Effect"] = false,
    ["Damage Type"] = "AD",
    ["Plus Attr"] = "AD",
    ["Plus Ratio"] = "1"
  })
  caster.atk2Buff = false
  return basefunc(buff)
end
local function skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skill2_buffOnRemoved)
  local skill = buff.caster.skills.Phoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "eff_tile_Phoenix_atk2.cha",
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "100",
    ["Point Effect"] = "eff_point_burst.cha",
    ["Damage Type"] = "AP",
    ["Plus Attr"] = "AP",
    ["Plus Ratio"] = "0.6"
  })
  caster = skill.caster
  caster.atk2Buff = true
  return buff
end
local function skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    local bid = 128
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    local stype = buff.info.HPR
    stype = -owner.attribs.HP * 0.15
    buff.info.HPR = stype
    owner:addBuff(buff, owner)
  end
  if owner.hp == 1 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 31 then
        local buff = tbuff
      end
    end
    if buff then
      local absorption = stype * 0.8
      if absorption < buff.shield then
        buff.shield = buff.shield - absorption
        return
      else
        absorption = buff.shield
        buff.shield = 0
        buff.owner:removeBuff(buff)
        owner:die()
      end
    end
    owner:die()
  end
end
local skillult_finish = function(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 128 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end
local skill2_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
end
local function skill3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local bid = 125
  local binfo3 = ed.lookupDataTable("Buff", nil, bid)
  local buff3 = owner:addBuff(binfo3, owner)
end
local skill3_canCastWithTarget = function(basefunc, skill, target)
  if not basefunc(skill, target) then
    return false
  end
  local caster = skill.caster
  if caster.atk2Buff then
    return false, "atk2Buff"
  end
  return true
end
local function init_hero(hero)
  local skill2 = hero.skills.Phoenix_atk2
  if skill2 then
    skill2.createBuff = override(skill2.createBuff, skill2_createBuff)
    skill2.onAttackFrame = override(skill2.onAttackFrame, skill2_onAttackFrame)
  end
  local skill = hero.skills.Phoenix_pasv
  if skill then
    hero.die = override(hero.die, die)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, skill_getLostHPAfterImmunity)
    skill.createBuff = override(skill.createBuff, skill_createBuff)
  end
  local skillult = hero.skills.Phoenix_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, skillult_getDamage)
    skillult.finish = override(skillult.finish, skillult_finish)
  end
  local skill3 = hero.skills.Phoenix_atk3
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, skill3_onAttackFrame)
    skill3.canCastWithTarget = override(skill3.canCastWithTarget, skill3_canCastWithTarget)
  end
  return hero
end
return init_hero

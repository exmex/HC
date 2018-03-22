local ed = ed
local skill_createBuff = function(basefunc, skill, target)
  local buff = basefunc(skill, target)
  return buff
end
local skill_buffOnRemoved = function(basefunc, buff)
  local owner = buff.owner
  local skill = owner.skills.ExPhoenix_pasv
  if owner:isAlive() then
    owner:setHP(owner.attribs.HP * (owner.config.hp_mod or 1))
  end
  local owner = buff.owner
  owner.isDandan = false
  return basefunc(buff)
end
local skill_buff2OnRemoved = function(basefunc, buff)
  local owner = buff.owner
  local skillatk3 = owner.skills.ExPhoenix_atk3
  if skillatk3 then
    owner:castSkill(skillatk3, skillatk3.target)
  end
  return basefunc(buff)
end
local function shieldbuff_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.caster
  local shieldbuff
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 158 then
      shieldbuff = tbuff
    end
  end
  if shieldbuff and shieldbuff.shield > 0 then
    shieldbuff.shield = shieldbuff.shield - 1
    if owner.actor then
      local str = "-" .. 1
      local color = "orange"
      ed.PopupCreate(str, color, owner.actor, 1)
    end
    return 0
  else
    local damage = basefunc(buff, damage, damage_type)
    return damage
  end
end
local function die(basefunc, self, killer)
  local skill = self.skills.ExPhoenix_pasv
  if not self.isDandan then
    self.isDandan = true
    if self.custom_data == nil then
      self.custom_data = 1
    else
      self.custom_data = self.custom_data + 1
    end
    self:removeAllBuffs()
    local bid = 162
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo, self)
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    local bid = 158
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    local stype = buff.info["Shield Value"]
    if self.level <= 65 then
      stype = 12
    elseif self.level <= 70 then
      stype = 18
    elseif self.level <= 80 then
      stype = 24
    elseif self.level <= 85 then
      stype = 30
    elseif self.level <= 90 then
      stype = 30
    elseif self.level > 90 then
      stype = 37
    end
    buff.shield = math.floor(stype)
    buff.onDamaged = override(buff.onDamaged, shieldbuff_onDamaged)
    self:addBuff(buff, self)
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
    local skillatk4 = self.skills.ExPhoenix_pasv
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
  local skill = buff.caster.skills.ExPhoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "projectile/Lina_atk_tile.png",
    ["AOE Origin"] = false,
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "0",
    ["Point Effect"] = false,
    ["Damage Type"] = "AD",
    ["Plus Attr"] = "AD",
    ["Plus Ratio"] = "3"
  })
  return basefunc(buff)
end
local function skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skill2_buffOnRemoved)
  local skill = buff.caster.skills.ExPhoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "eff_tile_Phoenix_atk2.cha",
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "100",
    ["Point Effect"] = "eff_point_burst.cha",
    ["Damage Type"] = "AP",
    ["Plus Attr"] = "AP",
    ["Plus Ratio"] = "1.4"
  })
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
      local buff = tbuffs
      buff.owner:removeBuff(buff)
    end
    if tbuff.info.ID == 163 then
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
local function reset(basefunc, hero)
  basefunc(hero)
  local bid = 162
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff2 = hero:addBuff(binfo, hero)
end
local function skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 163
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff2 = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end
local function update(basefunc, self, dt)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 152 then
      self.uncontroll = true
    else
      self.uncontroll = false
    end
  end
  if self.uncontroll == false then
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo, self)
  end
  basefunc(self, dt)
end
local function init_hero(hero)
  local stype
  if hero.level <= 65 then
    stype = 12
  elseif hero.level <= 70 then
    stype = 18
  elseif hero.level <= 80 then
    stype = 24
  elseif hero.level <= 85 then
    stype = 30
  elseif hero.level <= 90 then
    stype = 30
  elseif hero.level > 90 then
    stype = 37
  end
  hero.maxShield = stype
  hero.update = override(hero.update, update)
  local skill2 = hero.skills.ExPhoenix_atk2
  if skill2 then
    hero:preloadEffect("eff_point_burst.cha")
    hero:preloadEffect("eff_tile_Phoenix_atk2.cha")
    skill2.createBuff = override(skill2.createBuff, skill2_createBuff)
    skill2.onAttackFrame = override(skill2.onAttackFrame, skill2_onAttackFrame)
  end
  local skill = hero.skills.ExPhoenix_pasv
  if skill then
    hero.die = override(hero.die, die)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, skill_getLostHPAfterImmunity)
    skill.createBuff = override(skill.createBuff, skill_createBuff)
  end
  local skillult = hero.skills.ExPhoenix_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, skillult_getDamage)
    skillult.finish = override(skillult.finish, skillult_finish)
    skillult.start = override(skillult.start, skillult_start)
  end
  local skill3 = hero.skills.ExPhoenix_atk3
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, skill3_onAttackFrame)
    skill3.canCastWithTarget = override(skill3.canCastWithTarget, skill3_canCastWithTarget)
  end
  hero.reset = override(hero.reset, reset)
  return hero
end
return init_hero

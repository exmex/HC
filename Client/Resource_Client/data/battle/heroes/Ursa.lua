local skillpasv3_getDamage = function(basefunc, self, target, power, damage_type, field, source, crit_mod)
  if not target.isBuff134 then
    local bid = 134
    local buff134 = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(buff134, self.caster)
  end
  local buff134, power134
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 134 then
      buff134 = tbuff.buff134
    end
  end
  if buff134 then
    power134 = buff134 * 0.05 + power
  else
    power134 = power
    target.isBuff134 = false
  end
  local dmg = target:takeDamage({
    amount = power134,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod
  })
  return dmg
end
local skillult_getDamage = function(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local buff134, power134
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 134 then
      if tbuff.buff134 == nil then
        tbuff.buff134 = 1
      else
        tbuff.buff134 = tbuff.buff134 + 1
      end
      buff134 = tbuff.buff134
      tbuff.timer = 7
    end
  end
  local owner = self.caster
  if buff134 then
    local skillawake = owner.skills.Ursa_awake
    local rate = skillawake.info["Basic Num"]
    if buff134 > 5 then
      buff134 = 5
    end
    power134 = buff134 * rate + power
  else
    power134 = power
  end
  local dmg = target:takeDamage({
    amount = power134,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod
  })
  if not buff134 and dmg > 0 then
    local bid = 134
    local buff134 = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(buff134, self.caster)
  end
  return dmg
end
local skillatk_getDamage = function(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local buff134, power134
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 134 then
      if tbuff.buff134 == nil then
        tbuff.buff134 = 1
      else
        tbuff.buff134 = tbuff.buff134 + 1
      end
      buff134 = tbuff.buff134
      tbuff.timer = 7
      break
    end
  end
  local owner = self.caster
  if buff134 then
    local skillawake = owner.skills.Ursa_awake
    local rate = skillawake.info["Basic Num"]
    if buff134 > 5 then
      buff134 = 5
    end
    power134 = buff134 * rate + power
  else
    power134 = power
  end
  local dmg = target:takeDamage({
    amount = power134,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod
  })
  if not buff134 and dmg > 0 then
    local bid = 134
    local buff134 = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(buff134, self.caster)
  end
  return dmg
end
local skillatk_takeEffectOn = function(basefunc, skill, target, source)
  local owner = skill.caster
  basefunc(skill, target, source)
end
local skillult_takeEffectOn = function(basefunc, skill, target, source)
  local owner = skill.caster
  basefunc(skill, target, source)
end
local function init_hero(hero)
  if ed.protoAwake and ed.protoAwake(hero.proto) then
    local skillpasv3 = hero.skills.Ursa_pasv3
    if skillpasv3 then
      skillpasv3.getDamage = override(skillpasv3.getDamage, skillpasv3_getDamage)
    end
    local skillult = hero.skills.Ursa_ult
    if skillult then
      skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
      skillult.getDamage = override(skillult.getDamage, skillult_getDamage)
    end
    local skillatk = hero.skills.Ursa_atk
    if skillatk then
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, skillatk_takeEffectOn)
      skillatk.getDamage = override(skillatk.getDamage, skillatk_getDamage)
    end
  end
  return hero
end
return init_hero

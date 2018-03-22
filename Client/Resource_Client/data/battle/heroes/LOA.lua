local ultbuff_onDamaged = function(basefunc, buff, damage, damage_type)
  local caster = buff.owner
  local remaindamage = basefunc(buff, damage, damage_type)
  local power = damage - remaindamage
  if power > 0 then
    caster:takeHeal(power, "hp")
    if caster.actor then
      caster.actor:addEffect("eff_impact_heal.cha", 0)
    end
  end
  return remaindamage
end
local function skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, ultbuff_onDamaged)
  return buff
end
local skill2_takeEffectOn = function(basefunc, skill, target, source)
  local originfo = skill.info
  if target.camp ~= skill.caster.camp then
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = originfo["Basic Num"] * 3,
      ["Plus Ratio"] = originfo["Plus Ratio"] * 3
    })
  end
  basefunc(skill, target, source)
  skill.info = originfo
end
local skill3_buffOnRemoved = function(basefunc, buff)
  if buff.timer >= 0 and 0 < buff.shield then
    return basefunc(buff)
  end
  local skill = buff.caster.skills.LOA_atk3
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = 150,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  skill:takeEffectAt(buff.owner.position)
  skill.info = originfo
  return basefunc(buff)
end
local function skill3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skill3_buffOnRemoved)
  return buff
end
local function init_hero(hero)
  local skillult = hero.skills.LOA_ult
  skillult.createBuff = override(skillult.createBuff, skillult_createBuff)
  local skill2 = hero.skills.LOA_atk2
  if skill2 then
    skill2.takeEffectOn = override(skill2.takeEffectOn, skill2_takeEffectOn)
  end
  local skill3 = hero.skills.LOA_atk3
  if skill3 then
    skill3.createBuff = override(skill3.createBuff, skill3_createBuff)
  end
  return hero
end
return init_hero

local ed = ed
local function skill2_buffOnRemoved(basefunc, buff)
  local skill = buff.caster.skills.Footman_atk2
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "halfcircle",
    ["Shape Arg1"] = 150,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  buff.caster.global_cd = 3
  skill:takeEffectAt(buff.owner.position)
  skill.info = originfo
  return basefunc(buff)
end
local function skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, skill2_buffOnRemoved)
  return buff
end
local function init_hero(hero)
  local skill = hero.skills.Footman_atk2
  skill.createBuff = override(skill.createBuff, skill2_createBuff)
  return hero
end
return init_hero

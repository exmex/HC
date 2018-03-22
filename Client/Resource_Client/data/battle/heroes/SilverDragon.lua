local skillatk3ice_takeEffectAt = function(basefunc, skill, location, source)
  basefunc(skill, location, source)
  if skill.attack_counter == 1 and ed.run_with_scene then
    local effect_name = "eff_point_SilverDragon_atk3.cha"
    ed.scene:playEffectOnScene(effect_name, skill.caster.position, {
      skill.caster.direction,
      1
    }, nil, 0)
  end
end
local skillicetakeEffectOn = function(basefunc, skill, target, source)
end
local skillicecreateBuff = function(basefunc, skill, target)
  if target.buff_effects.frozen then
    skill = skill.caster.skills.SilverDragon_ice_mark
    skill:takeEffectAt(target.position)
    target:removeAllBuffs()
    local bid = 5
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, skill.caster)
  elseif target.attribs.MSPD < 0 then
    local bid = 113
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, skill.caster)
  end
  return basefunc(skill, target, skill.caster)
end
local function init_hero(hero)
  local skill_atk3_ice = hero.skills.SilverDragon_atk3_ice
  local skill_atk2_ice = hero.skills.SilverDragon_atk2_ice
  local skill_atk_ice = hero.skills.SilverDragon_atk_ice
  hero:setDisapearWhenDie(false)
  skill_atk3_ice.takeEffectAt = override(skill_atk3_ice.takeEffectAt, skillatk3ice_takeEffectAt)
  skill_atk2_ice.createBuff = override(skill_atk2_ice.createBuff, skillicecreateBuff)
  skill_atk_ice.createBuff = override(skill_atk_ice.createBuff, skillicecreateBuff)
  local ratio = hero.hp / hero.attribs.HP
  if ratio <= 0.1 then
    hero.config.dps_mod = hero.config.dps_mod / 2
  end
  return hero
end
return init_hero

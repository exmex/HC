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
    skill = skill.caster.skills.ExSilverDragon_ice_mark
    skill:takeEffectAt(target.position)
    if target.info["Can Fly"] then
      target:removeAllBuffs()
    end
    local bid = 5
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, skill.caster)
  elseif target.attribs.MSPD < 0 then
  end
  return basefunc(skill, target, skill.caster)
end
local update = function(basefunc, self, dt)
  if not self.dyingTimer then
    self.dyingTimer = 6
  end
  self.dyingTimer = self.dyingTimer - dt
  if self.dyingTimer <= 0 then
    self.dyingTimer = 1
    local skill = self.skills.ExSilverDragon_frozen
    skill:takeEffectAt(self.position)
  end
  if not self.uncontroll then
    self.uncontroll = true
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo, self)
  end
  if ed.run_with_scene and not self.ice then
    local effect_night = "eff_UI_ice.cha"
    local origin = {400, 0}
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    self.ice = 1
  end
  basefunc(self, dt)
end
local skill_frozen_takeEffectOn = function(basefunc, skill, target, source)
  local buff
  if not target.info["Can Fly"] then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 151 then
        buff = tbuff
      end
    end
    if not buff then
      local bid = 151
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, self)
    end
  end
  return basefunc(skill, target, source)
end
local function init_hero(hero)
  local skill_atk3_ice = hero.skills.ExSilverDragon_atk3_ice
  local skill_atk2_ice = hero.skills.ExSilverDragon_atk2_ice
  local skill_atk_ice = hero.skills.ExSilverDragon_atk_ice
  local skill_frozen = hero.skills.ExSilverDragon_frozen
  hero:setDisapearWhenDie(false)
  hero.update = override(hero.update, update)
  skill_atk3_ice.takeEffectAt = override(skill_atk3_ice.takeEffectAt, skillatk3ice_takeEffectAt)
  skill_atk2_ice.createBuff = override(skill_atk2_ice.createBuff, skillicecreateBuff)
  skill_atk_ice.createBuff = override(skill_atk_ice.createBuff, skillicecreateBuff)
  skill_frozen.takeEffectOn = override(skill_frozen.takeEffectOn, skill_frozen_takeEffectOn)
  local ratio = hero.hp / hero.attribs.HP
  if ratio <= 0.1 then
    hero.config.dps_mod = hero.config.dps_mod / 2
  end
  return hero
end
return init_hero

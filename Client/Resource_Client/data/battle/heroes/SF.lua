local ed = ed
local function update(basefunc, self, dt)
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer then
      self.dyingTimer = 0.8
    end
    self.dyingTimer = self.dyingTimer - dt
    if self.dyingTimer <= 0 then
      self.dyingTimer = 99999
      local skill = self.skills.SF_ult
      skill:takeEffectAt(self.position)
    end
  else
    self.dyingTimer = nil
  end
  basefunc(self, dt)
end
local hero_handleUnitDieEvent = function(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk3 = self.skills.SF_atk3
  if skillatk3 and not unit.config.is_summoned then
    skillatk3:takeEffectOn(self, self)
  end
end
local skill5_power = function(basefunc, skill, source, target)
  local caster = skill.caster
  local info = caster.skills.SF_atk2.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = caster.attribs[info["Plus Attr"]]
  local power = multiplier * base_attrib + info["Basic Num"]
  return power, 1
end
local skill2_finish = function(basefunc, skill)
  skill.currentNum = skill.currentNum + 1
  if skill.currentNum >= 3 then
    skill.currentNum = 0
    skill.cd_remaining = 12
  end
  basefunc(skill)
end
local function skill2_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["X Shift"] = originfo["X Shift"] + skill.currentNum * 100
  })
  basefunc(skill, location, source)
  skill.info = originfo
end
local function init_hero(hero)
  hero.update = override(hero.update, update)
  hero.handleUnitDieEvent = override(hero.handleUnitDieEvent, hero_handleUnitDieEvent)
  local skill2 = hero.skills.SF_atk2
  if skill2 then
    skill2.takeEffectAt = override(skill2.takeEffectAt, skill2_takeEffectAt)
    skill2.finish = override(skill2.finish, skill2_finish)
    skill2.currentNum = 0
  end
  return hero
end
return init_hero

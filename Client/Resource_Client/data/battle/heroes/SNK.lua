local ed = ed
local function die(basefunc, self, killer)
  local skill = self.skills.SNK_pasv2
  if skill and self.custom_data ~= 1 and not self.buff_effects.unheal then
    self.rebirth_timer = 2.5
    self.custom_data = 1
    self.state = ed.emUnitState_Birth
    self:removeAllBuffs()
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 0
    self.mp = 0
    local buff = skill.info.buff_info
    self:addBuff(buff, self)
    self:setAction("Death", false, true)
  else
    basefunc(self, killer)
  end
end
local onActionFinished = function(basefunc, self)
  if self.rebirth_timer then
  else
    basefunc(self)
  end
end
local update = function(basefunc, self, dt)
  basefunc(self, dt)
  if self.rebirth_timer then
    self.rebirth_timer = self.rebirth_timer - dt
    if self.rebirth_timer <= 0 then
      self.rebirth_timer = nil
      local skill = self.skills.SNK_pasv2
      self:setHP(skill.info["Basic Num"] * (self.config.hp_mod or 1))
      self:summon()
    end
  end
end
local function init_hero(hero)
  local skill = hero.skills.SNK_pasv2
  if skill then
    hero.die = override(hero.die, die)
    hero.onActionFinished = override(hero.onActionFinished, onActionFinished)
    hero.update = override(hero.update, update)
  end
  return hero
end
return init_hero

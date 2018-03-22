local ed = ed
local mirror_time = 12
local TBMirror_update = function(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end
local function NagaonHitMiss(basefunc, self, skill)
  local skillawake = self.skills.Naga_awake
  local caster = skill.caster
  local proto = {
    _tid = 145,
    _level = skillawake.level or 1,
    _stars = self.stars,
    _rank = self.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = self.config.hp_mod or 1,
    dps_mod = self.config.dps_mod or 1
  }
  local TBMirror = ed.UnitCreate(proto, self.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = TBMirror:addBuff(binfo, caster)
  TBMirror.mDuration = mirror_time
  TBMirror.update = override(TBMirror.update, TBMirror_update)
  TBMirror:setDeathWithEffectOrNot(true)
  TBMirror.direction = self.direction
  local locationtb
  local rand = ed.rand()
  if rand <= 1 and rand > 0.75 then
    locationtb = {
      self.position[1] + TBMirror.direction * 60,
      self.position[2] + TBMirror.direction * 30
    }
  end
  if rand <= 0.75 and rand > 0.5 then
    locationtb = {
      self.position[1] + TBMirror.direction * 60,
      self.position[2] - TBMirror.direction * 30
    }
  end
  if rand <= 0.5 and rand > 0.25 then
    locationtb = {
      self.position[1] - TBMirror.direction * 60,
      self.position[2] - TBMirror.direction * 30
    }
  end
  if rand <= 0.25 then
    locationtb = {
      self.position[1] + TBMirror.direction * 60,
      self.position[2]
    }
  end
  if self.mobcd <= 0 then
    ed.engine:summonUnit(TBMirror, locationtb, caster, "Birth")
    if self.nagalist == nil then
      self.nagalist = {}
    end
    table.insert(self.nagalist, TBMirror)
    self.mobcd = 12
  end
end
local update = function(basefunc, self, dt)
  basefunc(self, dt)
  if self.mobcd then
    self.mobcd = self.mobcd - dt
  end
end
local hero_die = function(basefunc, hero, killer)
  if hero.nagalist then
    for i, naga in ipairs(hero.nagalist) do
      if naga and naga:isAlive() then
        naga:die()
      end
    end
  end
  basefunc(hero, killer)
end
local function init_hero(hero)
  hero.mobcd = 0
  hero.orderedIdx = {}
  if ed.protoAwake and ed.protoAwake(hero.proto) then
    hero.die = override(hero.die, hero_die)
    hero.onHitMiss = override(hero.onHitMiss, NagaonHitMiss)
    hero.update = override(hero.update, update)
  end
  return hero
end
return init_hero

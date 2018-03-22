local ed = ed
local function selectTarget(basefunc, self, default)
  self.target = nil
  local camp = self.caster.camp
  for i, unit in ipairs(ed.engine.unit_list) do
    if unit.state == ed.emUnitState_Dead and unit.hasCorpse and unit.action_elapsed < 5 then
      self.target = unit
    end
  end
  return self.target
end
local onAttackFrame = function(basefunc, self)
  self:takeEffectAt(self.target.position)
end
local function takeEffectOn(basefunc, self, target, source)
  if not target.hasCorpse then
    return false
  end
  target.hasCorpse = false
  if target.actor then
    target.actor.node:setVisible(false)
  end
  local proto = {
    _tid = 111,
    _level = target.level
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    estimate_skill = true
  }
  local caster = self.caster
  local skeleton = ed.UnitCreate(proto, caster.camp, config)
  skeleton.direction = caster.direction
  ed.engine:summonUnit(skeleton, target.position, caster)
end
local function init_hero(hero)
  local skill = hero.skills.Necromancersr_atk2
  if skill then
    function skill.target_selector()
      return true
    end
    skill.selectTarget = override(skill.selectTarget, selectTarget)
    skill.onAttackFrame = override(skill.onAttackFrame, onAttackFrame)
    skill.takeEffectOn = override(skill.takeEffectOn, takeEffectOn)
  end
  return hero
end
return init_hero

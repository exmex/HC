local skillawake_selectTarget = function(basefunc, self, default)
  local selector = ed.rand
  local max = -math.huge
  local chosen
  local caster = self.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if not unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
        local v = selector(unit)
        if max < v then
          max = v
          chosen = unit
        end
      end
    end
  end
  self.target = chosen
  return self.target
end
local function skillawake_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    local target = skillawake_selectTarget(nil, skill, nil)
    if target then
      if ed.run_with_scene then
        local info = skill.info
        local direction = caster.direction
        local location = target.position
        local origin = {
          location[1] + info["X Shift"] * direction,
          location[2]
        }
        local effect_name = info["Point Effect"]
        if not effect_name then
          return
        end
        local effect_z = info["Point Zorder"] or 0
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction,
          1
        }, nil, effect_z)
        local str = "devour"
        local color = caster.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate(str, color, target.actor, nil, "text")
      end
      target:die(skill.caster)
    end
  else
    local binfo = skill.info.buff_info
    local owner = caster
    local buff = ed.BuffCreate(binfo, owner, owner)
    owner:addBuff(buff, owner)
  end
end
local function init_hero(hero)
  local skillawake = hero.skills.Bone_awake
  if skillawake then
    skillawake.selectTarget = override(skillawake.selectTarget, skillawake_selectTarget)
    skillawake.onAttackFrame = override(skillawake.onAttackFrame, skillawake_onAttackFrame)
  end
  return hero
end
return init_hero

local ed = ed
local moveforwardtable = {
  [0] = 0,
  [1] = 15,
  [2] = 10,
  [3] = 15,
  [4] = 5,
  [5] = 15,
  [6] = 5,
  [7] = 5,
  [8] = 5,
  [9] = 5
}
local function skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local moveforward = moveforwardtable[attack_counter] or 0
  if attack_counter == 0 then
    skill.info = ed.wraptable(originfo, {
      ["Track Type"] = "projectile",
      ["Buff ID"] = 0
    })
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter < 5 then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.1,
      ["Knock Back"] = 10
    })
    basefunc(skill)
    skill.info = originfo
    return
  elseif attack_counter == 5 then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.6,
      ["Knock Back"] = 20
    })
    local origin = {
      skill.caster.position[1] + 50 * skill.caster.direction,
      skill.caster.position[2]
    }
    if skill.target and not skill.target.buff_effects.stable then
      skill.target.position = {
        origin[1] + 20 * skill.caster.direction,
        origin[2]
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Panda_ult.cha"
      ed.scene:playEffectOnScene(effect_name, origin, {
        skill.caster.direction,
        1
      }, nil, 0)
    end
    basefunc(skill)
    skill.info = originfo
    return
  elseif attack_counter > 5 then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 5
    })
    basefunc(skill)
    skill.info = originfo
    return
  end
end
local function init_hero(hero)
  local skillult = hero.skills.Panda_ult
  skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  return hero
end
return init_hero

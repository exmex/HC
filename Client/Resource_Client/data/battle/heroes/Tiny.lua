local ed = ed
local skillult_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  skill.thrownUnit = skill.target
end
local function skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.thrownUnit and skill.thrownUnit.knockup_time <= 0 then
    local unit = skill.thrownUnit
    skill.thrownUnit = nil
    local info = skill.info
    skill.info = ed.wraptable(info, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = info["Script Arg1"],
      ["Plus Ratio"] = info["Script Arg2"],
      ["AOE Origin"] = "target",
      ["Knock Up"] = 0,
      ["Knock Back"] = 0,
      ["Buff ID"] = 0
    })
    skill:takeEffectAt(unit.position)
    skill.info = info
  end
end
local function init_hero(hero)
  local skillult = hero.skills.Tiny_ult
  skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  skillult.update = override(skillult.update, skillult_update)
  return hero
end
return init_hero

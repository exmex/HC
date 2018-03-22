local ed = ed
local function checkVSUlt(skillLevel, targetLevel)
  if ed.rand() < 0.3 then
    return true
  end
  local dice = 20
  if skillLevel < 30 then
    skillLevel = 10 + skillLevel / 30 * 20
  end
  dice = dice * ed.rand()
  local pass = targetLevel <= skillLevel + dice
  return pass
end
local function skillult_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local targetp = {
    target.position[1],
    target.position[2]
  }
  local casterp = {
    skill.caster.position[1],
    skill.caster.position[2]
  }
  if checkVSUlt(skill.level, target.level) and not target.buff_effects.stable then
    skill.caster.position = targetp
    target.position = casterp
    local skill2 = skill.caster.skills.VS_atk2
    if skill2 then
      skill2.target = target
      local projectile = skill2:createProjectile()
      projectile:enableTrack(target)
      ed.engine:addProjectile(projectile)
    end
  else
    local color = target.camp == ed.emCampEnemy and "red" or "blue"
    if target.actor then
      ed.PopupCreate("miss", color, target.actor, nil, "text")
    end
  end
end
local function init_hero(hero)
  local skillult = hero.skills.VS_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  return hero
end
return init_hero

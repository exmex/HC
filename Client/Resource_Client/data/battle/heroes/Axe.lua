local ed = ed
local function skillult_takeEffectOn(basefunc, skill, target, source)
  local killratio = 0.32
  local hpratio = target.hp / target.attribs.HP
  local originfo = skill.info
  if killratio > hpratio then
    if ed.run_with_scene then
      local effect_name = "eff_point_Axe_ult.cha"
      local effect_z = skill.info["Point Zorder"] or 0
      ed.scene:playEffectOnScene(effect_name, skill.caster.position, {
        skill.caster.direction,
        1
      }, nil, effect_z)
      local color = target.camp == ed.emCampEnemy and "blue" or "red"
      ed.PopupCreate("culling", color, target.actor, true, "text")
    end
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 1,
      ["No Dodge"] = true,
      ["Basic Num"] = originfo["Basic Num"] * 3,
      ["Plus Ratio"] = originfo["Plus Ratio"] * 3
    })
  end
  local ret, dmg = basefunc(skill, target, source)
  skill.info = originfo
  if ret and not target:isAlive() and not target.config.is_summoned then
    skill.caster:takeHeal(300, "mp", skill.caster)
  end
  return ret, dmg
end
local willCast = function(basefunc, skill)
  local ret = basefunc(skill)
  if ret then
    target = skill.target
    if target then
      local hpratio = target.hp / target.attribs.HP
      return hpratio <= 0.31
    end
  end
  return ret
end
local function init_hero(hero)
  local skillult = hero.skills.Axe_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  skillult.willCast = override(skillult.willCast, willCast)
  return hero
end
return init_hero

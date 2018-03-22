local ed = ed
local function skillatk_takeEffectOn(basefunc, skill, target, source)
  local skillawake = skill.caster.skills.Lina_awake
  basefunc(skill, target, source)
  if ed.protoAwake(skill.caster.proto) then
    target:addBuff(skillawake:createBuff(target))
  end
end
local skillatk_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local skillatk4 = skill.caster.skills.Lina_atk4
  if skillatk4 then
    local mp = skillatk4.info["Script Arg1"]
    skill.caster:takeHeal(mp, "mp")
  end
end
local function init_hero(hero)
  local skillatk = hero.skills.Lina_atk
  skillatk.onAttackFrame = override(skillatk.onAttackFrame, skillatk_onAttackFrame)
  if ed.protoAwake(hero.proto) then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, skillatk_takeEffectOn)
  end
  return hero
end
return init_hero

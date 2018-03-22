local skill2_takeEffectOn = function(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local owner = skill.caster
  if ed.protoAwake and ed.protoAwake(owner.proto) then
    local bid = 137
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, skill.caster)
  end
end
local function init_hero(hero)
  if ed.protoAwake and ed.protoAwake(hero.proto) then
    local skill2 = hero.skills.OK_atk2
    if skill2 then
      skill2.takeEffectOn = override(skill2.takeEffectOn, skill2_takeEffectOn)
    end
  end
  return hero
end
return init_hero

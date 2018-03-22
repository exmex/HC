local ed = ed
local timegap = 0.25
local collidedis = 30
local function skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), collidedis))
      caster.walk_v = {
        d2[1] / timegap,
        d2[2] / timegap
      }
    end
  else
    local bid = 65
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo = ed.wraptable(binfo, {
      AD = skill.info["Script Arg2"]
    })
    local buff = caster:addBuff(binfo, caster)
    local perc = skill.info["Script Arg1"]
    caster:setHP(caster.hp * (100 - perc) / 100)
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end
local function init_hero(hero)
  local skillult = hero.skills.Huskar_ult
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  return hero
end
return init_hero

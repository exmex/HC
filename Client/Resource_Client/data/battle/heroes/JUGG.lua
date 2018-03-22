local ed = ed
local function skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 48
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.JUGGUltPosition = {
    caster.position[1],
    caster.position[2],
    0
  }
  basefunc(skill, target)
end
local skillult_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 6 and caster.JUGGUltPosition then
    caster.position = {
      caster.JUGGUltPosition[1],
      caster.JUGGUltPosition[2],
      0
    }
  end
end
local skillult_takeEffectOn = function(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  caster.position = {
    target.position[1],
    target.position[2] - 1
  }
  basefunc(skill, target)
end
local function skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  local v = 180
  local bid = 49
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.walk_v = {
    caster.direction * v,
    0
  }
  basefunc(skill, target)
end
local skillatk2_onAttackFrame = function(basefunc, skill)
  basefunc(skill)
  local skill = skill
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 4 then
    local v = -caster.walk_v[1]
    caster.walk_v = {v, 0}
  elseif skill.attack_counter and skill.attack_counter == 8 then
    caster.walk_v = {0, 0}
  end
end
local skillatk2_finish = function(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.caster.direction = skill.caster.direction * -1
  basefunc(skill)
end
local function init_hero(hero)
  local skillatk2 = hero.skills.JUGG_atk2
  local skillult = hero.skills.JUGG_ult
  skillult.onAttackFrame = override(skillult.onAttackFrame, skillult_onAttackFrame)
  skillult.start = override(skillult.start, skillult_start)
  skillult.takeEffectOn = override(skillult.takeEffectOn, skillult_takeEffectOn)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, skillatk2_finish)
  end
  return hero
end
return init_hero

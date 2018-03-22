local interval = 0.375
local function update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + interval
    local skill = buff.caster.skills.DP_ult
    local originfo = skill.info
    local origtarget = skill.target
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0,
      ["Damage Type"] = "AP",
      ["Target Camp"] = -1,
      ["Affected Camp"] = -1,
      ["Target Type"] = "random"
    })
    local target = skill:selectTarget()
    if target then
      local succ, dmg = skill:takeEffectOn(target, skill.caster)
      if dmg then
        buff.total_dmg = buff.total_dmg + dmg
      end
    end
    skill.info = originfo
    skill.target = origtarget
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end
local onRemoved = function(basefunc, buff)
  buff.caster:takeHeal(buff.total_dmg * 0.5, "hp", buff.caster)
  basefunc(buff)
end
local function createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = interval
  buff.total_dmg = 0
  buff.update = override(buff.update, update)
  buff.onRemoved = override(buff.onRemoved, onRemoved)
  return buff
end
local function init_hero(hero)
  local skill = hero.skills.DP_ult
  skill.createBuff = override(skill.createBuff, createBuff)
  return hero
end
return init_hero

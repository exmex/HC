local ed = ed
local rush_speed = 300
local SB_Rush_Buff_ID = 148
local SB_Waiting_Buff_ID = 149
local function reset(basefunc, hero)
  basefunc(hero)
  local dir = hero:getInitDir()
  hero.position[1] = 400 - 480 * dir
  local has_friend_unit = false
  local unit_list = ed.engine.unit_list
  for i, unit in pairs(unit_list) do
    if unit.name ~= hero.name and unit.camp == hero.camp then
      has_friend_unit = true
      break
    end
  end
  for _, skill in pairs(hero.skill_list) do
    if skill.info["Skill Name"] == "SB_atk2" then
      if has_friend_unit then
        do
          local owner = hero
          local bid = SB_Waiting_Buff_ID
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, owner, owner)
          owner:addBuff(buff, owner)
        end
        break
      end
      skill.cd_remaining = 999
      break
    end
  end
end
local function skillatk2_takeEffectOn(skillatk2, owner, unit)
  local x = unit.position[1]
  local dir = owner:getInitDir()
  local extraDis = (dir > 0 and x or 800 - x) * 0.05
  local distance = math.abs(x - (390 + dir * extraDis))
  unit:knockup(math.max(0.3, distance / 400), {
    distance * dir,
    0
  })
  owner.skillatk2_affected_units[unit] = true
  local bid = 6
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, unit, owner)
  unit:addBuff(buff, owner)
  if ed.run_with_scene then
    local info = skillatk2.info
    local effect_name = info["Point Effect"]
    if effect_name then
      local effect_z = info["Point Zorder"] or 0
      ed.scene:playEffectOnScene(effect_name, unit.position, {
        owner.direction,
        1
      }, nil, effect_z)
    end
  end
  skillatk2:takeEffectOn(unit, owner)
end
local function skillatk2_onAttackFrame(basefunc, skill)
  local owner = skill.caster
  owner.position = {
    400 - 80 * owner:getInitDir(),
    0
  }
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == SB_Rush_Buff_ID then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  owner.walk_v = {0, 0}
end
local function skillatk2_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local skillatk2 = owner.skillatk2
  if skillatk2 then
    local owner = skillatk2.caster
    local info = skillatk2.info
    local direction = owner.direction
    local location = owner.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local shape = info["AOE Shape"]
    local arg1 = 120
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skillatk2:affectedCamp()) do
      local skillatk2_affected_units = owner.skillatk2_affected_units
      if not skillatk2_affected_units[unit] then
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if skillatk2.testPointInShape(p2, shape, arg1, arg2) then
          skillatk2_affected_units[unit] = true
          skillatk2_takeEffectOn(skillatk2, owner, unit)
        end
      end
    end
  end
  basefunc(buff, dt)
end
local function skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local sb = skill.caster
  sb.skillatk2 = skill
  sb.skillatk2_affected_units = {}
  sb.rush_destination = 400
  local caster = skill.caster
  local eventList = skill.current_phase.event_list
  local atkFrame
  for i = 1, #eventList do
    if eventList[i].Type == "Attack" then
      atkFrame = eventList[i]
      break
    end
  end
  local time = atkFrame.Time
  local dir = caster:getInitDir()
  caster.position = {
    400 - (80 + time * rush_speed) * dir,
    0
  }
  caster.walk_v = {
    rush_speed * dir,
    0
  }
  local bid = SB_Rush_Buff_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local owner = skill.caster
  local buff = ed.BuffCreate(binfo, owner, owner)
  buff.update = override(buff.update, skillatk2_buff_update)
  owner:addBuff(buff, owner)
end
local function skillatk2_finish(basefunc, skill, target)
  local owner = skill.caster
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == SB_Rush_Buff_ID then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  basefunc(skill, target)
end
local ori_position
local skillult_start = function(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.target then
    local position1 = skill.target.position[1] + caster.direction * 70
    caster:setPosition({
      position1,
      skill.target.position[2]
    })
  end
end
local skillult_takeEffectAt = function(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 70
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end
local function awake_update(basefunc, self, dt)
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer then
      self.dyingTimer = 1
    end
    self.dyingTimer = self.dyingTimer - dt
    if self.dyingTimer <= 0 then
      self.dyingTimer = 99999
      local skill = self.skills.SB_awake
      skill:takeEffectAt(self.position)
      ed.engine:deliverBall(self, skill, 1)
    end
  else
    self.dyingTimer = nil
  end
  basefunc(self, dt)
end
local function init_hero(hero)
  if ed.protoAwake(hero.proto) then
    hero.update = override(hero.update, awake_update)
  end
  hero.reset = override(hero.reset, reset)
  local skillatk2 = hero.skills.SB_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, skillatk2_onAttackFrame)
  end
  local skillult = hero.skills.SB_ult
  if skillult then
    skillult.start = override(skillult.start, skillult_start)
  end
  return hero
end
return init_hero

local herodetail = ed.ui.herodetail
local class = newclass("g")
herodetail.herofca = class
setfenv(1, class)
heroid = nil
puppet = nil
cha = nil
preActor = nil
duration = nil
function init()
  heroid = nil
  puppet = nil
  cha = nil
  preActor = nil
  duration = nil
end
function create(hid)
  init()
  heroid = hid
  puppet, cha = ed.readhero.getActor(hid, "Idle")
  preActor = "Idle"
  return puppet
end
function change(name)
  local row = ed.getDataTable("AnimDuration")[cha]
  local act = {}
  local dur = {}
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(act, k)
        table.insert(dur, v.Duration)
      end
    elseif not ed.isElementInTable(k, {
      "Death",
      "Idle",
      "Damaged",
      "Cheer",
      "Rage",
      "Switch",
      "Temp"
    }) and k ~= preActor then
      table.insert(act, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #act)
  end
  local actor = act[index]
  preActor = actor
  duration = dur[index]
  if not tolua.isnull(puppet) then
    puppet:setAction(actor)
    if actor ~= "Move" then
      puppet:setLoop(false)
    else
      puppet:setLoop(true)
    end
  end
  return actor, duration
end
function playIdle()
  if not tolua.isnull(puppet) then
    puppet:setAction("Idle")
    puppet:setLoop(true)
  end
end
function playCheer(param)
  param = param or {}
  local hasEffect = param.hasEffect
  change("Cheer")
  if hasEffect then
    local effect = ed.getDataTable("Unit")[heroid]["Voice Upgrade"]
    if effect then
      ed.playEffect(effect)
    end
  end
end

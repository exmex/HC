local class = {
  mt = {}
}
class.mt.__index = class
ed.readaction = class
function class.create(array)
  array = array or {}
  local t = array.t
  if not t then
    return
  end
  local action
  if t == "seq" then
    action = class.createSequence(array)
  elseif t == "sp" then
    action = class.createSpawn(array)
  end
  if array.isRepeat then
    return CCRepeatForever:create(action)
  else
    return action
  end
end
function class.getArray(array)
  local a = CCArray:create()
  for k, v in ipairs(array) do
    local vt = type(v)
    local element = v
    if vt == "table" then
      element = class.create(v)
      a:addObject(element)
    else
      a:addObject(v)
    end
  end
  return a
end
function class.createSequence(array)
  local a = class.getArray(array)
  return CCSequence:create(a)
end
function class.createSpawn(array)
  local a = class.getArray(array)
  return CCSpawn:create(a)
end
function class.getMoveCircleAction(param)
  param = param or {}
  local palstance = param.palstance or 180
  palstance = palstance / 180 * math.pi
  local center = param.center or ccp(400, 240)
  local radius = param.radius or 200
  local cursor = param.start or 0
  local node = param.node
  local target = param.target
  local callback = param.callback
  local circleCount = 0
  local function handler(dt)
    cursor = cursor + palstance * dt
    if cursor > 2 * math.pi then
      circleCount = circleCount + 1
      cursor = cursor - 2 * math.pi
    end
    if target and circleCount >= target and callback then
      callback()
      callback = nil
    end
    local x = center.x
    local y = center.y
    x = x - radius * math.cos(cursor)
    y = y + radius * math.sin(cursor)
    local pos = ccp(x, y)
    if not node then
      return pos
    end
    node:setPosition(pos)
  end
  return handler
end
function class.getColorChangeHandler(param)
  param = param or {}
  local origin = param.origin
  local target = param.target
  local duration = param.duration
  local callback = param.callback
  local label = param.label
  local count = 0
  local function getSpeed(key)
    return (target[key] - origin[key]) / duration
  end
  local function getValue(key, gap)
    local speed = getSpeed(key)
    if speed > 0 then
      return math.min(origin[key] + speed * gap, target[key])
    else
      return math.max(origin[key] + speed * gap, target[key])
    end
  end
  local function handler(dt)
    count = count + dt
    local color = ccc3(getValue("r", count), getValue("g", count), getValue("b", count))
    if not tolua.isnull(label) then
      ed.setLabelColor(label, color)
    end
    if count > duration and callback then
      callback()
    end
  end
  return handler
end

local acts = {}
local ACTION_EASING = {}
ACTION_EASING.BACKIN = {CCEaseBackIn, 1}
ACTION_EASING.BACKINOUT = {CCEaseBackInOut, 1}
ACTION_EASING.BACKOUT = {CCEaseBackOut, 1}
ACTION_EASING.BOUNCE = {CCEaseBounce, 1}
ACTION_EASING.BOUNCEIN = {CCEaseBounceIn, 1}
ACTION_EASING.BOUNCEINOUT = {CCEaseBounceInOut, 1}
ACTION_EASING.BOUNCEOUT = {CCEaseBounceOut, 1}
ACTION_EASING.ELASTIC = {
  CCEaseElastic,
  2,
  0.3
}
ACTION_EASING.ELASTICIN = {
  CCEaseElasticIn,
  2,
  0.3
}
ACTION_EASING.ELASTICINOUT = {
  CCEaseElasticInOut,
  2,
  0.3
}
ACTION_EASING.ELASTICOUT = {
  CCEaseElasticOut,
  2,
  0.3
}
ACTION_EASING.EXPONENTIALIN = {CCEaseExponentialIn, 1}
ACTION_EASING.EXPONENTIALINOUT = {CCEaseExponentialInOut, 1}
ACTION_EASING.EXPONENTIALOUT = {CCEaseExponentialOut, 1}
ACTION_EASING.IN = {
  CCEaseIn,
  2,
  1
}
ACTION_EASING.INOUT = {
  CCEaseInOut,
  2,
  1
}
ACTION_EASING.OUT = {
  CCEaseOut,
  2,
  1
}
ACTION_EASING.RATEACTION = {
  CCEaseRateAction,
  2,
  1
}
ACTION_EASING.SINEIN = {CCEaseSineIn, 1}
ACTION_EASING.SINEINOUT = {CCEaseSineInOut, 1}
ACTION_EASING.SINEOUT = {CCEaseSineOut, 1}
local actionManager = CCDirector:sharedDirector():getActionManager()
local functions = require("util.functions")
local function newEasing(action, easingName, more)
  local key = string.upper(tostring(easingName))
  if string.sub(key, 1, 6) == "CCEASE" then
    key = string.sub(key, 7)
  end
  local easing
  if ACTION_EASING[key] then
    local cls, count, default = unpack(ACTION_EASING[key])
    if count == 2 then
      easing = cls:create(action, more or default)
    else
      easing = cls:create(action)
    end
  end
  return easing or action
end
acts.newEasing = newEasing
function acts.execute(target, action, args)
  assert(not tolua.isnull(target), "acts.execute() - target is not CCNode")
  args = functions.totable(args)
  if args.easing then
    if type(args.easing) == "table" then
      action = newEasing(action, unpack(args.easing))
    else
      action = newEasing(action, args.easing)
    end
  end
  local actions = {}
  local delay = functions.tonumber(args.delay)
  if delay > 0 then
    actions[#actions + 1] = CCDelayTime:create(delay)
  end
  actions[#actions + 1] = action
  local onComplete = args.onComplete
  if type(onComplete) ~= "function" then
    onComplete = nil
  end
  if onComplete then
    actions[#actions + 1] = CCCallFunc:create(onComplete)
  end
  if #actions > 1 then
    action = acts.sequence(actions)
    target:runAction(action)
  else
    target:runAction(actions[1])
  end
  return action
end
function acts.rotateTo(target, args)
  assert(not tolua.isnull(target), "acts.rotateTo() - target is not CCNode")
  local action = CCRotateTo:create(args.time, args.rotate)
  return acts.execute(target, action, args)
end
function acts.moveTo(target, args)
  assert(not tolua.isnull(target), "acts.moveTo() - target is not CCNode")
  local tx, ty = target:getPosition()
  local x = args.x or tx
  local y = args.y or ty
  local action = CCMoveTo:create(args.time, ccp(x, y))
  return acts.execute(target, action, args)
end
function acts.moveBy(target, args)
  assert(not tolua.isnull(target), "acts.moveBy() - target is not CCNode")
  local x = args.x or 0
  local y = args.y or 0
  local action = CCMoveBy:create(args.time, ccp(x, y))
  return acts.execute(target, action, args)
end
function acts.fadeIn(target, args)
  assert(not tolua.isnull(target), "acts.fadeIn() - target is not CCNode")
  local action = CCFadeIn:create(args.time)
  target:setOpacity(0)
  return acts.execute(target, action, args)
end
function acts.fadeOut(target, args)
  assert(not tolua.isnull(target), "acts.fadeOut() - target is not CCNode")
  local action = CCFadeOut:create(args.time)
  target:setOpacity(255)
  return acts.execute(target, action, args)
end
function acts.fadeTo(target, args)
  assert(not tolua.isnull(target), "acts.fadeTo() - target is not CCNode")
  local opacity = functions.toint(args.opacity)
  if opacity < 0 then
    opacity = 0
  elseif opacity > 255 then
    opacity = 255
  end
  local action = CCFadeTo:create(args.time, opacity)
  return acts.execute(target, action, args)
end
function acts.scaleTo(target, args)
  assert(not tolua.isnull(target), "acts.scaleTo() - target is not CCNode")
  local action
  if args.scale then
    action = CCScaleTo:create(functions.tonumber(args.time), functions.tonumber(args.scale))
  elseif args.scaleX or args.scaleY then
    local scaleX, scaleY
    if args.scaleX then
      scaleX = functions.tonumber(args.scaleX)
    else
      scaleX = target:getScaleX()
    end
    if args.scaleY then
      scaleY = functions.tonumber(args.scaleY)
    else
      scaleY = target:getScaleY()
    end
    action = CCScaleTo:create(functions.tonumber(args.time), scaleX, scaleY)
  end
  return acts.execute(target, action, args)
end
function acts.sequence(actions)
  if #actions < 1 then
    return
  end
  if #actions < 2 then
    return actions[1]
  end
  local prev = actions[1]
  for i = 2, #actions do
    prev = CCSequence:createWithTwoActions(prev, actions[i])
  end
  return prev
end
function acts.spawn(actions)
  if type(actions) ~= "table" then
    EDDebug()
  end
  if #actions < 1 then
    return
  end
  if #actions < 2 then
    return actions[1]
  end
  local prev = actions[1]
  for i = 2, #actions do
    prev = CCSpawn:createWithTwoActions(prev, actions[i])
  end
  return prev
end
function acts.removeAction(action)
  if not tolua.isnull(action) then
    actionManager:removeAction(action)
  end
end
function acts.stopTarget(target)
  if not tolua.isnull(target) then
    actionManager:removeAllActionsFromTarget(target)
  end
end
function acts.pauseTarget(target)
  if not tolua.isnull(target) then
    actionManager:pauseTarget(target)
  end
end
function acts.resumeTarget(target)
  if not tolua.isnull(target) then
    actionManager:resumeTarget(target)
  end
end
local function applyCheckBasedActionIter(node, check, actionCreator)
  local actionSet = {}
  if node.getChildren ~= nil then
    local children = node:getChildren()
    if children then
      for i = 0, children:count() - 1 do
        local child = children:objectAtIndex(i)
        table.foreach(applyCheckBasedActionIter(child, check, actionCreator), function(k, v)
          table.insert(actionSet, v)
        end)
      end
    end
  end
  if check(node) then
    table.insert(actionSet, actionCreator(node))
  end
  return actionSet
end
function acts.applyCheckBasedAction(node, check, actionCreator)
  local rv
  xpcall(function()
    rv = acts.spawn(applyCheckBasedActionIter(node, check, actionCreator))
  end, EDDebug)
  return rv
end
local function createExtensiveSeq(node, ctx, seq, callback)
  ctx.seq = {}
  if not ctx.extend then
    function ctx.extend(ctx, newAction)
      table.insert(ctx.seq, newAction)
      newAction:retain()
    end
  end
  local target = acts.sequence({
    acts.sequence(seq),
    CCCallFunc:create(function()
      if #ctx.seq > 0 then
        node:runAction(createExtensiveSeq(node, ctx, ctx.seq, callback))
        for _, action in ipairs(ctx.seq) do
          action:release()
        end
      else
        if callback then
          callback(ctx)
        end
        ctx.seq = nil
      end
    end)
  })
  return target
end
acts.createExtensiveSeq = createExtensiveSeq
return acts

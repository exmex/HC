local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.toast = class
local function waitRemove(record, container)
  local container = container
  local record = record
  local bg = ed.toast.toast
  local function remove(dt)
    xpcall(function()
      if CCDirector:sharedDirector():getRunningScene() ~= container then
        if not tolua.isnull(bg) then
          bg:removeFromParentAndCleanup(true)
        end
        ed.toast.toast = nil
        record.scheduler:unscheduleScriptEntry(record.id)
      end
      if tolua.isnull(bg) then
        record.scheduler:unscheduleScriptEntry(record.id)
      else
        if bg:getOpacity() == 0 then
          bg:removeFromParentAndCleanup(true)
          record.scheduler:unscheduleScriptEntry(record.id)
        else
        end
      end
    end, EDDebug)
  end
  return remove
end
class.waitRemove = waitRemove
local function createToast(text)
  local bg = CCSprite:create()
  bg:setCascadeOpacityEnabled(true)
  local board = ed.createScale9Sprite("UI/alpha/HVGA/toast_bg.png", CCRectMake(20, 20, 194, 20))
  board:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(board)
  local label = ed.createttf(text, 24)
  label:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(label)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  local labelSize = label:getContentSize()
  board:setPosition(ccp(0, -2))
  board:setContentSize(CCSizeMake(labelSize.width + 20, labelSize.height + 40))
  return bg, board, label
end
class.createToast = createToast
local function showToast(text, param)
  param = param or {}
  if not CCDirector:sharedDirector():getRunningScene() then
    return
  end
  if not tolua.isnull(ed.toast.toast) then
    ed.toast.toast:removeFromParentAndCleanup(true)
  end
  local bg, board, label = createToast(text)
  bg:setPosition(ccp(400, 240))
  ed.toast.toast = bg
  local container = CCDirector:sharedDirector():getRunningScene()
  container:addChild(bg, 500)
  ed.playEffect(ed.sound.toast.show)
  local record = {}
  record.scheduler = container:getScheduler()
  record.id = record.scheduler:scheduleScriptFunc(waitRemove(record, container), 0, false)
  if not param.keepOn then
    local delay = CCDelayTime:create(param.constant or 1)
    local fadeout = CCFadeOut:create(1)
    local sequence = CCSequence:createWithTwoActions(delay, fadeout)
    bg:runAction(sequence)
  end
  return bg, board, label
end
ed.registerOverloadFunc(class, "showToast", {
  types = {
    "string",
    {"table", nil}
  },
  func = showToast
})
local function showToastWithPos(text, pos, param)
  local bg, board, label = showToast(text, param)
  bg:setPosition(pos)
  return bg, board, label
end
ed.registerOverloadFunc(class, "showToast", {
  types = {
    "string",
    "userdata",
    {"table", nil}
  },
  func = showToastWithPos
})
ed.setOverloadFunc(class, "showToast")
ed.showToast = class.showToast
local function showToastForever(text, pos)
  return ed.showToast(text, pos, {keepOn = true})
end
ed.showToastForever = showToastForever

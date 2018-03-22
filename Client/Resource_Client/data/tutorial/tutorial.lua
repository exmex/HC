local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.tutorial = class
local res = ed.tutorialres
local items = {}
local delayItems = {}
local dialogs = {}
class.items = items
class.delayItems = delayItems
class.dialogs = dialogs
local t_key = res.t_key
local c_times = res.c_times
local ui = ed.tutorialDisposable
local dui = ed.tutorialDialog
local maker = ed.tutorialmaker
local isFinishTutorial = true
class.isFinishTutorial = isFinishTutorial
--add by xinghui
local isShowTutorial = false
class.isShowTutorial = isShowTutorial
--

local function getid(key)
  return t_key[key].id
end
class.getid = getid
local function getPre(key)
  return t_key[key].pre
end
class.getPre = getPre
local function getAddition(key)
  return t_key[key].addition
end
class.getAddition = getAddition
local function getRecord(key)
  local id = getid(key)
  return ed.player:getTutorialRecord(id)
end
class.getRecord = getRecord
local function checkDone(key)
  local record = getRecord(key)
  if (record or 0) >= (c_times[key] or 1) then
    return true
  end
  return false
end
class.checkDone = checkDone
local function completeAddition(key)
  local add = getAddition(key)
  for i = 1, #(add or {}) do
    local k = add[i]
    local kid = getid(k)
    ed.player:setTutorialRecord(kid, c_times[k] or 1)
  end
end
class.completeAddition = completeAddition
local function checkPre(key)
  local pk = getPre(key)
  if not pk then
    return true
  end
  return checkDone(pk)
end
class.checkPre = checkPre
local function addTutorial(key, container, addition)
  xpcall(function()
    local dc, hc
    class.isShowTutorial = true--add by xinghui
    if type(container) == "userdata" then
      dc = container
      hc = container
    elseif type(container) == "table" then
      dc = container.tutorialContainer or container[1]
      hc = container.dialogContainer or container[2]
    end
    if dc then
      dc:addChild(items[key].mainLayer, 300)
    end
    dialogs[key] = dui.create(key, addition)
    if dialogs[key].mainLayer and hc then
      hc:addChild(dialogs[key].mainLayer, 100)
    end
  end, EDDebug)
end
class.addTutorial = addTutorial
local function fadeOutTutorial(key)
  items[key]:fadeOut()
  dialogs[key]:fadeOut()
end
class.fadeOutTutorial = fadeOutTutorial
local function removeTutorial(key, noClear)
  xpcall(function()
    if not noClear then
      if not tolua.isnull(dialogs[key].mainLayer) then
        dialogs[key].mainLayer:unregisterScriptTouchHandler()
        dialogs[key].mainLayer:removeFromParentAndCleanup(true)
      end
      if not tolua.isnull(items[key].mainLayer) then
     	items[key].mainLayer:unregisterScriptTouchHandler()
        items[key].mainLayer:removeFromParentAndCleanup(true)
        
      end
    end
    items[key]:clearTouchHandler()
    items[key] = nil
    dialogs[key] = nil
  end, EDDebug)
end
class.removeTutorial = removeTutorial
local function preInstCreate(key, container, force)
  xpcall(function()
    if checkDone(key) then
      container = nil
      return
    end
    if items[key] then
      if not force then
        if not tolua.isnull(items[key].mainLayer) then
          container = nil
          return
        else
          items[key] = nil
        end
      else
        removeTutorial(key)
      end
    end
    if not container then
      container = CCDirector:sharedDirector():getRunningScene()
    end
  end, EDDebug)
  return container
end
class.preInstCreate = preInstCreate
ed.registerOverloadFunc(class, "instCreate", {
  types = {
    "string",
    "userdata",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, button, container, force)
    xpcall(function()
      local container = preInstCreate(key, container, force)
      if not container then
        return
      end
      local ir = res[key]
      if ir.type == "finger" then
        items[key] = maker.createCommonFingerLayer(key, button)
      elseif ir.type == "tips" then
        items[key] = maker.createCommonTipsLayer(key, button)
      elseif ir.type == "announce" then
        items[key] = maker.createExhibitionLayer(key)
      end
      addTutorial(key, container, {button = button})
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "instCreate", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, pos, radius, parent, container, force)
    xpcall(function()
      local container = preInstCreate(key, container, force)
      if not container then
        return
      end
      local ir = res[key]
      if ir.type == "finger" then
        items[key] = maker.createCommonFingerLayer(key, pos, radius, parent)
      elseif ir.type == "tips" then
        items[key] = maker.createCommonTipsLayer(key, pos, radius, parent)
      elseif ir.type == "announce" then
        items[key] = maker.createExhibitionLayer(key)
      end
      addTutorial(key, container, {
        pos = pos,
        radius = radius,
        parent = parent
      })
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "instCreate", {
  types = {
    "string",
    "table",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, info, container, force)
    xpcall(function()
      local container = preInstCreate(key, container, force)
      if not container then
        return
      end
      local ir = res[key]
      if ir.type == "finger" then
        items[key] = maker.createCommonFingerLayer(key, info)
      elseif ir.type == "tips" then
        items[key] = maker.createCommonTipsLayer(key, info)
      elseif ir.type == "announce" then
        items[key] = maker.createExhibitionLayer(key, info)
      end
      addTutorial(key, container)
    end, EDDebug)
  end
})
ed.setOverloadFunc(class, "instCreate")
local instCreate = class.instCreate
ed.registerOverloadFunc(class, "delayCreateHandler", {
  types = {
    "string",
    "userdata",
    {"userdata", "table"},
    "number"
  },
  func = function(key, button, container, delay)
    local count = 0
    local scheduler, id, done
    local function handler(dt)
      xpcall(function()
        count = count + dt
        if not scheduler or not id then
          scheduler = delayItems[key].scheduler
          id = delayItems[key].id
        end
        if tolua.isnull(button) then
          scheduler:unscheduleScriptEntry(id)
          return
        end
        if count >= delay and not done then
          instCreate(key, button, container)
          scheduler:unscheduleScriptEntry(id)
          done = true
        end
      end, EDDebug)
    end
    return handler
  end
})
ed.registerOverloadFunc(class, "delayCreateHandler", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    {"userdata", "table"},
    "number"
  },
  func = function(key, pos, radius, parent, container, delay)
    local count = 0
    local scheduler, id, done
    local function handler(dt)
      xpcall(function()
        count = count + dt
        if not scheduler or not id then
          scheduler = delayItems[key].scheduler
          id = delayItems[key].id
        end
        if tolua.isnull(parent) then
          scheduler:unscheduleScriptEntry(id)
          return
        end
        if count >= delay and not done then
          instCreate(key, pos, radius, parent, container)
          scheduler:unscheduleScriptEntry(id)
          done = true
        end
      end, EDDebug)
    end
    return handler
  end
})
ed.registerOverloadFunc(class, "delayCreateHandler", {
  types = {
    "string",
    "table",
    {"userdata", "table"},
    "number"
  },
  func = function(key, info, container, delay)
    local count = 0
    local scheduler, id, done
    local function handler(dt)
      xpcall(function()
        count = count + dt
        if not scheduler or not id then
          scheduler = delayItems[key].scheduler
          id = delayItems[key].id
        end
        if tolua.isnull(info) then
          scheduler:unscheduleScriptEntry(id)
          return
        end
        if count >= delay and not done then
          instCreate(key, info, container)
          scheduler:unscheduleScriptEntry(id)
          done = true
        end
      end, EDDebug)
    end
    return handler
  end
})
ed.setOverloadFunc(class, "delayCreateHandler")
local delayCreateHandler = class.delayCreateHandler
local function preDelayCreate(key, container, delay)
  xpcall(function()
    if checkDone(key) then
      container = nil
      return
    end
    if delayItems[key] then
      local scheduler = delayItems[key].scheduler
      local id = delayItems[key].id
      scheduler:unscheduleScriptEntry(id)
      delayItems[key] = nil
    end
    if items[key] then
      if not tolua.isnull(items[key].mainLayer) then
        removeTutorial(key)
      else
        removeTutorial(key, true)
      end
    end
    if not container then
      container = CCDirector:sharedDirector():getRunningScene()
    end
  end, EDDebug)
  return container
end
class.preDelayCreate = preDelayCreate
ed.registerOverloadFunc(class, "delayCreate", {
  types = {
    "string",
    "userdata",
    {"userdata", "table"},
    "number"
  },
  func = function(key, button, container, delay)
    xpcall(function()
      local container = preDelayCreate(key, container, delay)
      if not container then
        return
      end
      local scheduler =( (type(container) == "userdata" and container) or (container.tutorialContainer or container[1])):getScheduler()
      local id = scheduler:scheduleScriptFunc(delayCreateHandler(key, button, container, delay), 0, false)
      delayItems[key] = {scheduler = scheduler, id = id}
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "delayCreate", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    {"userdata", "table"},
    "number"
  },
  func = function(key, pos, radius, parent, container, delay)
    xpcall(function()
      local container = preDelayCreate(key, container, delay)
      if not container then
        return
      end
      local scheduler = ( (type(container) == "userdata" and container) or (container.tutorialContainer or container[1])):getScheduler()
  
      local id = scheduler:scheduleScriptFunc(delayCreateHandler(key, pos, radius, parent, container, delay), 0, false)
      delayItems[key] = {scheduler = scheduler, id = id}
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "delayCreate", {
  types = {
    "string",
    "table",
    {"userdata", "table"},
    "number"
  },
  func = function(key, info, container, delay)
    xpcall(function()
      local container = preDelayCreate(key, container, delay)
      if not container then
        return
      end
      local scheduler = (type(container) == "userdata" and container or container.tutorialContainer or container[1]):getScheduler()
      local id = scheduler:scheduleScriptFunc(delayCreateHandler(key, info, container, delay), 0, false)
      delayItems[key] = {scheduler = scheduler, id = id}
    end, EDDebug)
  end
})
ed.setOverloadFunc(class, "delayCreate")
local delayCreate = class.delayCreate
ed.registerOverloadFunc(class, "create", {
  types = {
    "string",
    "userdata",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, button, container, force)
    xpcall(function()
      if not checkPre(key) then
        return
      end
      local delay = res[key].showDelay
      if not delay then
        instCreate(key, button, container, force)
      else
        delayCreate(key, button, container, delay)
      end
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "create", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, pos, radius, parent, container, force)
    xpcall(function()
      if not checkPre(key) then
        return
      end
      local delay = res[key].showDelay
      if not delay then
        instCreate(key, pos, radius, parent, container, force)
      else
        delayCreate(key, pos, radius, parent, container, delay)
      end
    end, EDDebug)
  end
})
ed.registerOverloadFunc(class, "create", {
  types = {
    "string",
    "table",
    {"userdata", "table"},
    "boolean"
  },
  func = function(key, info, container, force)
    xpcall(function()
      if not checkPre(key) then
        return
      end
      local delay = res[key].showDelay
      if not delay then
        instCreate(key, info, container, force)
      else
        delayCreate(key, info, container, delay)
      end
    end, EDDebug)
  end
})
ed.setOverloadFunc(class, "create")
local create = class.create
function ed.teach(...)
  local key = select(1, ...)
  create(...)
  return checkPre(key) and not checkDone(key)
end
function ed.canTeach(key)
  return checkPre(key) and not checkDone(key)
end
local function cancelCreate(key)
  xpcall(function()
    if delayItems[key] then
      local scheduler = delayItems[key].scheduler
      local id = delayItems[key].id
      scheduler:unscheduleScriptEntry(id)
      delayItems[key] = nil
    end
    if items[key] then
      if not tolua.isnull(items[key].mainLayer) then
        removeTutorial(key)
      else
        removeTutorial(key, true)
      end
    end
  end, EDDebug)
end
class.cancelCreate = cancelCreate
ed.breakTeach = cancelCreate
local function clear()
  xpcall(function()
    for k, v in pairs(t_key) do
      cancelCreate(k)
    end
  end, EDDebug)
end
class.clear = clear
local function complete(key)
  local result
  xpcall(function()
    local id = getid(key)
    local tr = res[key] or {}
    if not checkPre(key) then
      return
    end
    if checkDone(key) then
      return
    end
    local mustShow = tr.must_show
    if mustShow then
      if not items[key] then
        return
      end
      if tolua.isnull(items[key].mainLayer) then
        return
      end
    end
    ed.player:increaseTutorial(id)
    completeAddition(key)
    local msg = ed.upmsg.tutorial()
    msg._record = ed.player._tutorial
    if key == "_5v5Anim" then
      ed.send(msg, "tutorial")
    else
      ed.delaySend(msg, "tutorial")
    end
    local stillShow = tr.still_show
    if not stillShow then
      if not items[key] then
        return
      end
      if tolua.isnull(items[key].mainLayer) then
        return
      end
      removeTutorial(key)
    end
    result = true
  end, EDDebug)
  return result
end
class.complete = complete
ed.endTeach = complete
local function tell(key, container, addition)
  xpcall(function()
    addition = addition or {}
    local z = addition.z or 100
    local id = getid(key)
    if checkDone(key) then
      return
    end
    if dialogs[key] then
      return
    end
    if not container then
      container = CCDirector:sharedDirector():getRunningScene()
    end
    dialogs[key] = dui.create(key)
    if dialogs[key].mainLayer then
      container:addChild(dialogs[key].mainLayer, z)
    end
  end, EDDebug)
end
class.tell = tell

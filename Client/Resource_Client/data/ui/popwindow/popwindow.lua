local base = ed.ui.basenode
local class = newclass(base.mt)
ed.ui.popwindow = class
class.config = {
  equipboardofpackage = {
    touch_priority = -10,
    not_swallow = true,
    no_shade = true
  },
  usersummary = {touch_priority = -130, layer_opacity = 0},
  worldcup = {touch_priority = -130},
  maintask = {touch_priority = -130},
  dailytask = {touch_priority = -130},
  herosplitwindow = {touch_priority = -130},
  starshopbuywindow = {touch_priority = -130},
  herodetail = {touch_priority = -130},
  excavateteam = {touch_priority = -130},
  excavatehistory = {touch_priority = -130},
  excavateinvite = {touch_priority = -130},
  eatexp = {touch_priority = -130},
  fastsell = {touch_priority = -130},
  equipboardofsell = {touch_priority = -130},
  equipboardofbuy = {touch_priority = -130},
  herodetailskill = {
    touch_priority = -135,
    not_swallow = true,
    no_shade = true
  },
  herodetailcard = {
    touch_priority = -135,
    not_swallow = true,
    no_shade = true
  },
  herodetailatt = {
    touch_priority = -135,
    not_swallow = true,
    no_shade = true
  },
  evolveequip = {
    touch_priority = -135,
    not_swallow = true,
    no_shade = true
  },
  configure = {touch_priority = -145},
  excavatebattlereport = {touch_priority = -145},
  notification = {touch_priority = -150},
  cdkeywindow = {touch_priority = -150},
  poptavernloot = {touch_priority = -155, layer_opacity = 200},
  mailbox = {touch_priority = -160},
announcement = {touch_priority = -160},
buyconfirm = {touch_priority = -1000},
  fbattention = {touch_priority = -1000},
  appremark = {touch_priority = -1000},
  equipcraft = {touch_priority = -160},
  mailcontent = {touch_priority = -170},
  popherocard = {touch_priority = -175},
  midas = {touch_priority = -180},
  splitconfirmwindow = {touch_priority = -200},
  explainwindow = {touch_priority = -200},
  mailoverfull = {touch_priority = -205},
  guildapplyreward = {touch_priority = -215},
  guildapplydetail = {touch_priority = -220},
  heroselect = {touch_priority = -300},
  bename = {touch_priority = -500},
  languagechange = {touch_priority = -500},
  confirmdialog = {touch_priority = -1000},
  scrolldialog = {touch_priority = -1000},
	continuechargedialog={touch_priority = -1000}
}
local window_stack = {}
ed.window_stack = window_stack
for k, v in pairs(class.config) do
  window_stack[k] = {}
end
local function getPopWindow(identity)
  if window_stack[identity] and not tolua.isnull(window_stack[identity].mainLayer) then
    return window_stack[identity]
  end
  return nil
end
ed.getPopWindow = getPopWindow

local function destroyAllWindow()
  
  --destroy(window_stack[0],{})
  for k, v in pairs(window_stack) do
  	LegendLog("check popScene destroyAllWindow 2")
      window_stack[k].mainLayer:setTouchEnabled(false)
      window_stack[k].mainLayer:removeFromParentAndCleanup(true)  	
  	
 	 	destroy(window_stack[k],{})
	end

end
ed.destroyAllWindow = destroyAllWindow

local destroy = function(self, param)
  param = param or {}
  local function destroyMainLayer()
    if not tolua.isnull(self.mainLayer) then
      self.mainLayer:setTouchEnabled(false)
      self.mainLayer:removeFromParentAndCleanup(true)
    end
  end
  local container = self.container
  local callback = param.callback or self.destroyCallback
  if self.isSkipTransAnim or self.isSkipDestroyAnim or param.skipAnim then
    if callback then
      callback()
    end
    destroyMainLayer()
    return
  end
  local draglist, scaleContainer
  if self.refreshCliprectConfig then
    local config = self.refreshCliprectConfig
    draglist = config.draglist or self.draglist
    scaleContainer = config.scaleContainer or self.container
    self:beginRefreshCliprect(draglist, scaleContainer)
  end
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if self.refreshCliprectConfig then
        self:endRefreshCliprect()
        self:refreshCliprect(draglist, scaleContainer)
      end
      if callback then
        callback()
      end
      self.mainLayer:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  if not tolua.isnull(container) then
    container:runAction(s)
  end
end
class.destroy = destroy
local show = function(self, param)
  param = param or {}
  local container = self.container
  local callback = param.callback or self.showCallback
  if self.isSkipTransAnim or self.isSkipShowAnim or param.skipAnim then
    if callback then
      callback()
    end
    return
  end
  local draglist, scaleContainer
  if self.refreshCliprectConfig then
    local config = self.refreshCliprectConfig
    draglist = config.draglist or self.draglist
    scaleContainer = config.scaleContainer or self.container
    self:beginRefreshCliprect(draglist, scaleContainer)
  end
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if self.refreshCliprectConfig then
        self:endRefreshCliprect()
        self:refreshCliprect(draglist, scaleContainer)
      end
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  if not tolua.isnull(container) then
    container:runAction(s)
  end
end
class.show = show
local function create(identity, param)

	local strLog="popScene."..identity
	LegendLog(strLog)


  param = param or {}
  local self = base.create("window")
  setmetatable(self, class.mt)
  window_stack[identity] = self
  self.onEnterHandlers = {}
  self.onExitHandlers = {}
  self.param = param
  self.identity = identity
  self.scene = self:ccScene()
  local cfg = self.config[identity] or {}
  local noShade = param.noShade or cfg.no_shade
  local shadeColor = param.shadeColor or cfg.shade_color
  local forbidTouch = param.forbidTouch
  local swallow = param.swallow
  if swallow == nil then
    if cfg.not_swallow then
      swallow = false
    else
      swallow = true
    end
  end
  if not noShade then
    self.mainLayer = CCLayerColor:create(shadeColor or ccc4(0, 0, 0, cfg.layer_opacity or 150))
  else
    self.mainLayer = CCLayer:create()
  end
  local mainLayer = self.mainLayer
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  self.ui = {}
  self.mainTouchPriority = param.priority or cfg.touch_priority
  if self.mainTouchPriority then
    mainLayer:setTouchEnabled(true)
    mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.mainTouchPriority, swallow)
  end
  if self.forbidTouch then
    mainLayer:setTouchEnabled(false)
  end
  mainLayer:registerScriptHandler(self:getEventHandler())
  return self
end
class.create = create
local setContainer = function(self, container, z)
  if not tolua.isnull(self.container) then
    self.container:removeFromParentAndCleanup(true)
  end
  self.container = container
  self.mainLayer:addChild(container, z or 0)
end
class.setContainer = setContainer
local ccScene = function(self)
  return ed.getCurrentScene():ccScene()
end
class.ccScene = ccScene
local getScene = function(self)
  return ed.getCurrentScene()
end
class.getScene = getScene
local registerOnEnterHandler = function(self, key, handler)
  self.onEnterHandlers[key] = handler
end
class.registerOnEnterHandler = registerOnEnterHandler
local removeOnEnterHandler = function(self, key)
  self.onEnterHandlers[key] = nil
end
class.removeOnEnterHandler = removeOnEnterHandler
local registerOnExitHandler = function(self, key, handler)
  self.onExitHandlers[key] = handler
end
class.registerOnExitHandler = registerOnExitHandler
local removeOnExitHandler = function(self, key)
  self.onExitHandlers[key] = nil
end
class.removeOnExitHandler = removeOnExitHandler
local getEventHandler = function(self)
  local function handler(event)
    if event == "enter" then
      for k, v in pairs(self.onEnterHandlers) do
        v()
      end
    elseif event == "exit" then
      for k, v in pairs(self.onExitHandlers) do
        v()
      end
    end
  end
  return handler
end
class.getEventHandler = getEventHandler
local registerUpdateHandler = function(self, key, handler)
  self:getScene():registerUpdateHandler(key, handler)
end
class.registerUpdateHandler = registerUpdateHandler
local removeUpdateHandler = function(self, key)
  self:getScene():removeUpdateHandler(key)
end
class.removeUpdateHandler = removeUpdateHandler
local addFca = function(self, fca, addition)
  if not addition then
    self:getScene():addFca(fca)
  elseif addition.isOnce then
    self:getScene():addFcaOnce(fca)
  end
end
class.addFca = addFca
local addFcaOnce = function(self, fca)
  self:getScene():addFcaOnce(fca)
end
class.addFcaOnce = addFcaOnce
local popWindow = function(self, z)
  self:ccScene():addChild(self.mainLayer, z or 300)
end
class.popWindow = popWindow
local getRefreshCliprectHandler = function(self, draglist, scaleContainer)
  local function handler(dt)
    if tolua.isnull(scaleContainer) then
      self:endRefreshCliprect()
      return
    end
    draglist:refreshClipRect(scaleContainer:getScale())
  end
  return handler
end
class.getRefreshCliprectHandler = getRefreshCliprectHandler
local refreshCliprect = function(self, draglist, scaleContainer)
  draglist:refreshClipRect(scaleContainer:getScale())
end
class.refreshCliprect = refreshCliprect
local beginRefreshCliprect = function(self, draglist, scaleContainer)
  self:getScene():registerUpdateHandler("refresh_cliprect", self:getRefreshCliprectHandler(draglist, scaleContainer))
end
class.beginRefreshCliprect = beginRefreshCliprect
local endRefreshCliprect = function(self)
  self:getScene():removeUpdateHandler("refresh_cliprect")
end
class.endRefreshCliprect = endRefreshCliprect

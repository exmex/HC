local base = ed.ui.basenode
local class = newclass(base.mt)
ed.ui.basescene = class
local mesh_switch = false
local backexit_switch = false
local scene_mainlayer_z = {pvp = 30, crusade = 30}
local scene_touch_priority = {debuglogin = -129, newbie = -129}
local checkRunning = function(self)
  local scene = self:ccScene()
  if not tolua.isnull(scene) and CCDirector:sharedDirector():getRunningScene() == scene then
    return true
  end
  return false
end
class.checkRunning = checkRunning
local doMeshLayerTouch = function(self)
  local handler = function(event, x, y)
    if event == "ended" then
      print(string.format("Mesh: %d,%d", x, y))
    end
    return true
  end
  return handler
end
class.doMeshLayerTouch = doMeshLayerTouch
local baseHandler = function(self)
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        self:onEnter()
      elseif event == "exit" then
        self:onExit()
      end
    end, EDDebug)
  end
  return handler
end
class.baseHandler = baseHandler
local registerOnEnterHandler = function(self, key, handler)
  xpcall(function()
    self.onEnterHandlerList = self.onEnterHandlerList or {}
    if self.onEnterHandlerList[key] then
    end
    self.onEnterHandlerList[key] = handler
  end, EDDebug)
end
class.registerOnEnterHandler = registerOnEnterHandler
local removeOnEnterHandler = function(self, key)
  xpcall(function()
    self.onEnterHandlerList = self.onEnterHandlerList or {}
    self.onEnterHandlerList[key] = nil
  end, EDDebug)
end
class.removeOnEnterHandler = removeOnEnterHandler
local clearOnEnterHandler = function(self)
  self.onEnterHandlerList = nil
end
class.clearOnEnterHandler = clearOnEnterHandler
local onEnter = function(self)
  xpcall(function()
    for k, v in pairs(self.onEnterHandlerList or {}) do
      v()
    end
  end, EDDebug)
end
class.onEnter = onEnter
local registerOnExitHandler = function(self, key, handler)
  xpcall(function()
    self.onExitHandlerList = self.onExitHandlerList or {}
    if self.onExitHandlerList[key] then
    end
    self.onExitHandlerList[key] = handler
  end, EDDebug)
end
class.registerOnExitHandler = registerOnExitHandler
local removeOnExitHandler = function(self, key)
  xpcall(function()
    self.onExitHandlerList = self.onExitHandlerList or {}
    self.onExitHandlerList[key] = nil
  end, EDDebug)
end
class.removeOnExitHandler = removeOnExitHandler
local clearOnExitHandler = function(self)
  self.onExitHandlerList = nil
end
class.clearOnExitHandler = clearOnExitHandler
function class:registerOnPopSceneHandler(key, handler)
  xpcall(function()
    self.onPopSceneHandlerList = self.onPopSceneHandlerList or {}
    self.onPopSceneHandlerList[key] = handler
  end, EDDebug)
end
function class:clearOnPopSceneHandler()
  self.onExitHandlerList = nil
end
function class:OnPopScene()
  xpcall(function()
    for k, v in pairs(self.onPopSceneHandlerList or {}) do
      v()
    end
  end, EDDebug)
end
local onExit = function(self)
  xpcall(function()
    for k, v in pairs(self.onExitHandlerList or {}) do
      v()
    end
  end, EDDebug)
end
class.onExit = onExit
local function create(identity, addition)
  local self = base.create("scene")
  setmetatable(self, class.mt)
  self.fcaList = {}
  self.identity = identity
  self.addition = addition or {}
  local scene = CCScene:create()
  self.scene = scene
  local baseLayer = CCLayer:create()
  self.baseLayer = baseLayer
  scene:addChild(baseLayer)
  baseLayer:registerScriptHandler(self:baseHandler())
  self.ui = {}
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer, scene_mainlayer_z[identity] or 0)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, not scene_touch_priority[identity] and 0, false)
  if mesh_switch then
    local meshLayer = CCLayer:create()
    self.meshLayer = meshLayer
    scene:addChild(meshLayer)
    meshLayer:setTouchEnabled(true)
    meshLayer:registerScriptTouchHandler(self:doMeshLayerTouch(), false, -1000, false)
  end
  self.checkFcaHandler = self:clearFcaHandler()
  self.updateVitality = self:updateVitalityHandler()
  self:createSDKAddition()
  self.visibleEventScope = {}
  self:registerOnPopSceneHandler("clearVisibleEvent", function()
    CloseScope(self.visibleEventScope)
  end)
  return self
end
class.create = create
local ccScene = function(self)
  return self.scene
end
class.ccScene = ccScene
local createSDKAddition = function(self)

	LegendLog("[basescene.lua|createSDKAddition] registerScriptKeypadHandler createSDKAddition LegendSDKType=")
	if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID and ed.isElementInTable(LegendSDKType, {
  	4,
    104,
    107,
    105
	}) then
	LegendLog("[basescene.lua|createSDKAddition] registerScriptKeypadHandler createSDKAddition 3")
    ed.setKeyBack(self.scene, function(event)
      xpcall(function()
      
      LegendLog("CCLayerColor popScene 88")

        if event == "backClicked" then
        
          backexit_switch=true
                      local info = {
                        text = T(LSTR("tools.exitgame")),
                        leftText = T(LSTR("CHATCONFIG.CANCEL")),
                        rightText = T(LSTR("CHATCONFIG.CONFIRM")),
                        rightHandler = function()
                          xpcall(function()
                          	--refresh notify
                            if ed.player.initialized then
   
   														 ed.localnotify.refresh()
 														end                          	
 														backexit_switch=false
                          	LegendExit()
                          end, EDDebug)
                        end,
      
                        leftHandler = function()
                          xpcall(function()
	
	
														backexit_switch=false
                           LegendLog("registerScriptKeypadHandler leftHandler basescene applicationDidEnterBackground cancel 22") 
                          end, EDDebug)
                        end
      
                      }
                      
                      LegendLog("check popScene 1 "..ed.getSceneCount())
                      
                      
                      
                      
											if ed.getSceneCount() > 0 or ed.getchatTune()==true then 
												if ed.getchatTune()==true then
													ed.endChat()
												else
													for i=1,ed.getSceneCount() do
                     	 			ed.popScene()    	
                     	 		end	
                     	 	end              
                     	else 	
                      	ed.showConfirmDialog(info)
                      end	
                      
                      LegendLog("check popScene 3")
                           
        end
      end, EDDebug)
    end)
  end
  
  LegendLog("[basescene.lua|createSDKAddition]registerScriptKeypadHandler createSDKAddition 3")
end
class.createSDKAddition = createSDKAddition
local uploadVitality = function()
  if not ed.player.initialized then
    return
  end
  local msg = ed.upmsg.sync_vitality()
  ed.delaySend(msg, "sync_vitality")
end
class.uploadVitality = uploadVitality
local updateVitalityHandler = function(self)
  local refreshCount = 0
  local function handler(dt)
    if not ed.player.initialized then
      return
    end
    if self.stopUpdateVitality then
      return
    end
    refreshCount = refreshCount + dt
    if refreshCount > 1 then
      ed.player:refreshVitality()
      refreshCount = refreshCount - 1
    end
  end
  return handler
end
class.updateVitalityHandler = updateVitalityHandler
local update = function(self, dt)
  self.updateVitality(dt)
  for k, v in pairs(self.updateHandlerList or {}) do
    if v then
      xpcall(function()
        v(dt)
      end, EDDebug)
    else
    	EDDebug("updateHandler is null :" .. k)
    end
  end
  self:updateFca(dt)
  self:doRegisterUpdateHandler()
  self:doRemoveUpdateHandler()
end
class.update = update
local doRegisterUpdateHandler = function(self)
  self.register_uh_list = self.register_uh_list or {}
  for k, v in ipairs(self.register_uh_list) do
    local key = v.k
    local handler = v.v
    self.updateHandlerList = self.updateHandlerList or {}
    --if not self.updateHandlerList[key] then
	self.updateHandlerList[key] = handler
    --end
  end
  self.register_uh_list = nil
end
class.doRegisterUpdateHandler = doRegisterUpdateHandler
local registerUpdateHandler = function(self, key, handler)
  xpcall(function()
    self.register_uh_list = self.register_uh_list or {}
    table.insert(self.register_uh_list, {k = key, v = handler})
  end, EDDebug)
end
class.registerUpdateHandler = registerUpdateHandler
local doRemoveUpdateHandler = function(self)
  self.remove_uh_list = self.remove_uh_list or {}
  for k, v in ipairs(self.remove_uh_list) do
    (self.updateHandlerList or {})[v] = nil
  end
  self.remove_uh_list = nil
end
class.doRemoveUpdateHandler = doRemoveUpdateHandler
local removeUpdateHandler = function(self, key)
  xpcall(function()
    self.remove_uh_list = self.remove_uh_list or {}
    table.insert(self.remove_uh_list, key)
  end, EDDebug)
end
class.removeUpdateHandler = removeUpdateHandler
local clearUpdateHandler = function(self)
  xpcall(function()
    self.updateHandlerList = nil
  end, EDDebug)
end
class.clearUpdateHandler = clearUpdateHandler
local refresh = function(self)
  for k, v in pairs(self.refreshHandlerList or {}) do
    xpcall(function()
      v()
    end, EDDebug)
  end
end
class.refresh = refresh
local registerRefreshHandler = function(self, key, handler)
  xpcall(function()
    self.refreshHandlerList = self.refreshHandlerList or {}
    if self.refreshHandlerList[key] then
    end
    self.refreshHandlerList[key] = handler
  end, EDDebug)
end
class.registerRefreshHandler = registerRefreshHandler
local removeRegisterHandler = function(self, key)
  xpcall(function()
    (self.registerHandlerList or {})[key] = nil
  end, EDDebug)
end
class.removeRegisterHandler = removeRegisterHandler
local clearRegisterHandler = function(self)
  self.registerHandlerList = nil
end
class.clearRegisterHandler = clearRegisterHandler
local updateFca = function(self, dt)
  for k, v in pairs(self.fcaList or {}) do
    if v.once and not tolua.isnull(v.node) and v.node.isTerminated and v.node:isTerminated() then
      v.node:removeFromParentAndCleanup(true)
    end
    if not tolua.isnull(v.node) and not v.isPause then
      xpcall(function()
        v.node:update(dt, false)
      end, EDDebug)
    else
      self.fcaList[k] = nil
    end
    if v.pauseDelayTime then
      v.pauseDelayTime = v.pauseDelayTime - dt
      if v.pauseDelayTime < 0 then
        v.pauseDelayTime = nil
        v.isPause = true
      end
    end
  end
end
class.updateFca = updateFca
local addFcaCache = function(self, node, duration)
  self.fcaCacheIndex = self.fcaCacheIndex or 0
  local key = self.fcaCacheIndex + 1
  key = "fca" .. key
  local count = 0
  local function handler(dt)
    count = count + dt
    if count > duration then
      if not tolua.isnull(node) then
        node:removeFromParentAndCleanup(true)
      end
      self:removeUpdateHandler(key)
    end
  end
  self:registerUpdateHandler(key, handler)
end
class.addFcaCache = addFcaCache
local addFca = function(self, fca, duration)
  self.fcaList[#self.fcaList + 1] = {node = fca}
  if duration then
    self:addFcaCache(fca.node, duration)
  end
end
class.addFca = addFca
local addFcaOnce = function(self, fca)
  self.fcaList[#self.fcaList + 1] = {node = fca, once = true}
end
class.addFcaOnce = addFcaOnce
local removeFca = function(self, fca)
  for i = 1, #self.fcaList do
    if self.fcaList[i].node == fca then
      table.remove(self.fcaList, i)
      break
    end
  end
end
class.removeFca = removeFca
local pauseFca = function(self, fca)
  for i = 1, #self.fcaList do
    if self.fcaList[i].node == fca then
      self.fcaList[i].isPause = true
      break
    end
  end
end
class.pauseFca = pauseFca
local resumeFca = function(self, fca)
  for i = 1, #self.fcaList do
    if self.fcaList[i].node == fca then
      self.fcaList[i].isPause = false
      break
    end
  end
end
class.resumeFca = resumeFca
local delayPauseFca = function(self, fca, delay)
  for i = 1, #self.fcaList do
    if self.fcaList[i].node == fca then
      self.fcaList[i].pauseDelayTime = delay or 0.1
      break
    end
  end
end
class.delayPauseFca = delayPauseFca
local clearFca = function(self)
  self.fcaList = {}
end
class.clearFca = clearFca
local clearFcaHandler = function(self)
  local count = 0
  local function handler(dt)
    count = count + dt
    if count > 120 then
      self:checkFca()
      count = count - 120
    end
  end
  return handler
end
class.clearFcaHandler = clearFcaHandler
local checkFca = function(self)
  for i = 1, #self.fcaList do
    if tolua.isnull(self.fcaList[i].node) then
      table.remove(self.fcaList, i)
      return self:checkFca()
    end
  end
end
class.checkFca = checkFca

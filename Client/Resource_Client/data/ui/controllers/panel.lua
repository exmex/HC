local panelLayer = {}
function panelLayer:__index(key)
  local object = rawget(panelLayer, key)
  if object then
    return object
  end
  local object = rawget(self.uiControllers, key)
  if object then
    return object
  end
end
function panelLayer:init()
  self.buttonList = {}
  self.mainLayer = nil
  self.uiControllers = {}
  self.activeController = nil
  self.focusController = nil
  self.alert = false
end
function panelLayer:new(panelData, config)
  local layer = {}
  setmetatable(layer, self)
  layer:init()
  layer.panelData = panelData
  if config.touchInfo then
    layer.alert = config.touchInfo.alert or false
  end
  return layer
end
function panelLayer:touch(event, x, y)
  if false == self:getVisible() then
    return false
  end
  if self.focusController and not self.focusController:isContainPoint(x, y) and self.focusController.lostFocus then
    self.focusController:lostFocus()
  end
  if event == "began" then
    for k, v in pairs(self.buttonList) do
      local done = v:touch(event, x, y)
      if done then
        self.activeController = v
        self.focusController = v
        if v.setFocus then
          v:setFocus()
        end
        return done
      end
    end
  elseif event == "moved" then
    if self.activeController then
      self.activeController:touch(event, x, y)
    end
  elseif event == "ended" and self.activeController ~= nil then
    self.activeController:touch(event, x, y)
    self.activeController = nil
    return true
  end
  if self.alert and self.alert == true then
    return true
  else
    return false
  end
end
function panelLayer:setVisible(visible)
  if self.mainLayer then
    self.mainLayer:setVisible(visible)
  end
end
function panelLayer:getVisible()
  if self.mainLayer then
    return self.mainLayer:isVisible()
  end
  return false
end
function panelLayer:addButton(button, base)
  if nil == button then
    return
  end
  button:setHandler(self.panelData.panelLogic[base.handleName], self.panelData.panelLogic[base.downHandleName], self.panelData.panelLogic[base.upHandleName])
  local node = button:getSprite()
  if not base then
    return
  end
  if base.parent then
    if self.uiControllers[base.parent] then
      self.uiControllers[base.parent]:addChild(node, base.z or 0)
    end
  else
    self.mainLayer:addChild(node, base.z or 0)
  end
  if base.name then
    self.uiControllers[base.name] = button
  end
  table.insert(self.buttonList, button)
end
function panelLayer:addListView(listView, base)
  if nil == listView then
    return
  end
  if base.name then
    self.uiControllers[base.name] = listView
  end
  listView:setPanelLogic(self.panelData.panelLogic)
  listView:setHandler(self.panelData.panelLogic[base.handleName], self.panelData.panelLogic[base.downhandleName], self.panelData.panelLogic[base.uphandleName], self.panelData.panelLogic[base.movehandleName])
  table.insert(self.buttonList, listView)
end
function panelLayer:addEditTTF(editTTF, base)
  if nil == editTTF then
    return
  end
  if base.name then
    self.uiControllers[base.name] = editTTF
  end
  table.insert(self.buttonList, editTTF)
end
function panelLayer:addEditBox(editBox, base)
  if nil == editBox then
    return
  end
  if base and base.name then
    self.uiControllers[base.name] = editBox
  end
  table.insert(self.buttonList, editBox)
end
function panelLayer:setPosition(pos)
  if nil == self.mainLayer then
    return
  end
  self.mainLayer:setPosition(pos)
end
function panelLayer:getPosition()
  if nil == self.mainLayer then
    return
  end
  return self.mainLayer:getPosition()
end
function panelLayer:setClipRect(rect)
  if nil == self.mainLayer then
    return
  end
  self.mainLayer:setClipRect(rect)
end
function panelLayer:release()
  self.buttonList = nil
  self.mainLayer = nil
  self.uiControllers = nil
  self.activeController = nil
  self.focusController = nil
end
panelMeta = {}
function panelMeta:getLayerData(name)
  if self.resData then
    for k, v in ipairs(self.resData) do
      if v.layerName == name then
        return v
      end
    end
  end
end
function panelMeta:initLayerBaseInfo(layer, layerData)
  if layer == nil or layerData == nil then
    return
  end
  if layerData.layerColor then
    layer.mainLayer = CCLayerColor:create(layerData.layerColor)
  else
    layer.mainLayer = CCLayer:create()
  end
  if layerData.layerOrder then
    layer.mainLayer:setZOrder(layerData.layerOrder)
  end
  if layerData.initVisible ~= nil then
    layer.mainLayer:setVisible(layerData.initVisible)
  end
  local touchInfo = layerData.touchInfo
  if touchInfo then
    layer.mainLayer:registerScriptTouchHandler(function(event, x, y)
      return layer:touch(event, x, y)
    end, false, touchInfo.iPriority or 0, touchInfo.bSwallowsTouches or false)
    layer.mainLayer:setTouchEnabled(true)
  end
end
function panelMeta:initLayer(layerData)
  if nil == layerData then
    return
  end
  local Layer = panelLayer:new(self, layerData)
  self:initLayerBaseInfo(Layer, layerData)
  local parent = self:getRoot()
  if layerData.iPriority then
    parent:addChild(Layer.mainLayer, layerData.iPriority)
  else
    parent:addChild(Layer.mainLayer)
  end
  local readNode = ed.readnode.createWithLayer(Layer)
  readNode:addNode(layerData.uiRes)
  self:addLayer(layerData.layerName, Layer)
  return Layer
end
function panelMeta:__index(key)
  local object = rawget(panelMeta, key)
  if object then
    return object
  end
  object = self.panelLayers[key]
  if object then
    return object
  else
    local layerData = self:getLayerData(key)
    if layerData then
      return self:initLayer(layerData)
    end
  end
  for k, v in pairs(self.panelLayers) do
    object = rawget(v.uiControllers, key)
    if object then
      return object
    end
  end
end
function panelMeta:getRoot()
  local parent = self.rootLayer
  if parent == nil then
    parent = self.scene.scene
  end
  return parent
end
function panelMeta:initLayers(data)
  if nil == data then
    return
  end
  self.resData = data
  for k, v in ipairs(data) do
    if v.delayLoad ~= true then
      self:initLayer(v)
    end
  end
end
function panelMeta:new(scene, resData)
  if nil == scene then
    print("error:panel scene is nil!!!")
    return
  end
  if resData == nil then
    print("error:resData is nil!!!")
    return
  end
  local panelData = {}
  setmetatable(panelData, self)
  panelData.panelLayers = {}
  panelData.visible = true
  panelData.scene = scene
  panelData.panelLogic = scene
  panelData:initLayers(resData)
  return panelData
end
function panelMeta:getScene()
  return self.scene
end
function panelMeta:new2(logic, resData)
  if resData == nil then
    print("error:resData is nil!!!")
    return
  end
  local panelData = {}
  setmetatable(panelData, self)
  panelData.panelLayers = {}
  panelData.visible = true
  panelData.rootLayer = CCLayer:create()
  panelData.panelLogic = logic
  panelData:initLayers(resData)
  return panelData
end
function panelMeta:addLayer(name, panelLayer)
  self.panelLayers[name] = panelLayer
end
function panelMeta:release()
  for k, v in pairs(self.panelLayers) do
    if v then
      v:release()
    end
  end
  self.panelLayers = nil
end
function panelMeta:setVisible(visible)
  self.visible = visible
  for k, v in pairs(self.panelLayers) do
    if v then
      v:setVisible(visible)
    end
  end
end
function panelMeta:getVisible()
  return self.visible
end
function panelMeta:getRootLayer()
  return self.rootLayer
end

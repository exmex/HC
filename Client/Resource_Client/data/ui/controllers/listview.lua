local listItemPanel = {}
listItemPanel.__index = listItemPanel
function listItemPanel:new(panelLogic, rootNode, index)
  local itemPanel = {}
  setmetatable(itemPanel, self)
  itemPanel.panelLogic = panelLogic
  itemPanel.rootNode = rootNode
  itemPanel.arrayIndex = index
  itemPanel.activeController = nil
  itemPanel.buttonList = {}
  itemPanel.controllers = {}
  return itemPanel
end
function listItemPanel:addButton(button, base)
  if nil == button then
    return
  end
  if nil == self.panelLogic then
    return
  end
  button:setArrayIndex(self.arrayIndex)
  local node = button:getSprite()
  self.rootNode:addChild(node, base.z or 0)
  button:setHandler(self.panelLogic[base.handleName], self.panelLogic[base.downHandleName], self.panelLogic[base.upHandleName])
  if base.name then
    self.controllers[base.name] = button
  end
  table.insert(self.buttonList, button)
end
function listItemPanel:addSuperLink(link, bFront)
  if nil == link then
    return
  end
  if bFront == true then
    table.insert(self.buttonList, 1, link)
  else
    table.insert(self.buttonList, link)
  end
end
function listItemPanel:preTouch(event, x, y)
  if event == "ended" then
    if self.activeController and self.activeController.enablePress then
      self.activeController:enablePress(false)
    end
    if self.activeController and self.activeController.upHandler then
      xpcall(function()
        self.activeController.upHandler(self.activeController.dataInfo.base.arrayIndex or self.activeController.arrayIndex)
      end, EDDebug)
    end
  end
end
function listItemPanel:touch(event, x, y)
  if event == "began" then
    for k, v in ipairs(self.buttonList) do
      local done = v:touch(event, x, y)
      if done then
        self.activeController = v
        return done
      end
    end
  elseif event == "ended" and self.activeController ~= nil then
    self.activeController:touch(event, x, y)
    self.activeController = nil
    return true
  end
  return false
end
function listItemPanel:getTouchButton(x, y)
  for k, v in ipairs(self.buttonList) do
    local touched = v:isContainPoint(x, y)
    if touched then
      return v
    end
  end
end
listView = {}
listView.__index = listView
listView.configData = nil
listView.dragList = nil
listView.panelLayer = nil
listView.panelLogic = nil
listView.itemHeightInner = 5
listView.colNum = 1
listView.itemWidthInner = 3
listView.handler = nil
listView.downhandler = nil
listView.uphandler = nil
listView.movehandler = nil
listView.visible = true
listView.activeIndex = 0
listView.currentWidth = 0
listView.currentHeight = 0
listView.currentMaxHeight = 0
listView.currentMaxWidth = 0
listView.anchor = ccp(0, 1)
listView.maxItem = nil
listView.selfDealMessage = false
listView.endWidth = 0
listView.autoClipItemEnabled = true
listView.layoutMode = "down"
listView.newClickFunc = false
function listView:setPanelLayer(layer)
  if nil == layer then
    return
  end
  self.panelLayer = layer
end
function listView:setPanelLogic(logic)
  self.panelLogic = logic
end
function listView:initSelfData()
  self.listData = {}
  self.iconData = {}
  self.currentRow = 0
  self.currentCol = 0
  self.currentWidth = 0
  self.currentHeight = 0
  self.currentMaxHeight = 0
  self.endWidth = 0
end
function listView:setMaxItem(maxItem)
  self.maxItem = maxItem
end
function listView:init(info)
  if info == nil then
    return
  end
  if info.base == nil then
    print("error:listview need base info")
  end
  if info.base.cliprect == nil then
    print("error:listview need cliprect")
  end
  if info.base.colNum then
    self.colNum = info.base.colNum
  end
  if info.base.widthInner then
    self.itemWidthInner = info.base.widthInner
  end
  if info.base.anchor then
    self.anchor = info.base.anchor
  end
  if info.base.layoutMode then
    self.layoutMode = info.base.layoutMode
  end
  if info.base.maxItem then
    self.maxItem = info.base.maxItem
  end
  if info.base.heightInner then
    self.itemHeightInner = info.base.heightInner
  end
  if info.base.selfDealMessage then
    self.selfDealMessage = info.base.selfDealMessage
  end
  if info.base.newClickFunc then
    self.newClickFunc = info.base.newClickFunc
  end
  local noshade = info.base.noShade
  if noshade == nil then
    noshade = true
  end
  local info = {
    cliprect = info.base.cliprect,
    priority = info.base.priority or -5,
    container = self.panelLayer,
    noshade = noshade,
    message = not self.selfDealMessage,
    upShade = info.base.upShade,
    downShade = info.base.downShade,
    bar = info.base.bar
  }
  local listLayer = ed.draglist.create(info)
  self.dragList = listLayer
end
function listView:setHandler(func, downfunc, upfunc, movefunc)
  if func ~= nil then
    self.handler = func
  end
  if downfunc ~= nil then
    self.downhandler = downfunc
  end
  if upfunc ~= nil then
    self.uphandler = upfunc
  end
  if movefunc ~= nil then
    self.movehandler = movefunc
  end
end
function listView:setItem(data, controller, config, extraData, itemData)
  if nil == data or nil == controller then
    return
  end
  if "Label" == config.t then
    ed.setString(controller, data)
  elseif "Sprite" == config.t then
    if config.specialType == "heroIcon" then
      local param = {id = data}
      if "table" == type(data) then
        param = data
		if config.nameWidth then
		  param.nameWidth = config.nameWidth
        end
      end
      local head = ed.getWholeHeadIcon(param)
      if head then
        controller:removeAllChildrenWithCleanup(true)
        if "table" ~= type(data) then
          head:setScale(0.6)
        end
        controller:addChild(head)
      end
    elseif config.specialType == "hero" then
      local heroIcon = ed.readhero.createIcon(data)
      controller:addChild(heroIcon.icon)
    elseif config.addIcon == "true" then
      controller:addChild(data)
    else
      local frame = ed.getSpriteFrame(data)
      if frame then
        controller:initWithSpriteFrame(frame)
        controller:setAnchorPoint(config.layout.anchor)
      end
    end
  elseif "Scale9Sprite" == config.t then
    if config.addIcon == "true" then
      controller:addChild(data)
    else
      controller:initWithFile(config.base.capInsets, data)
    end
  elseif "RichText" == config.t then
    controller:setString(data, extraData)
    if controller:getLink() and itemData.itemPanel then
      itemData.itemPanel:addSuperLink(controller:getLink(), true)
    end
  end
end
function listView:setItemData(data, controllers, extraData, itemData)
  local itemConfig = self:getItemConfig()
  local index = 1
  local itemNum = #data
  for i, v in ipairs(itemConfig) do
    if v.listData == true then
      self:setItem(data[index], controllers[v.base.name], v, extraData, itemData)
      index = index + 1
      if itemNum < index then
        return
      end
    end
  end
end
function listView:getContentSize(item, itemData)
  if item == nil then
    return
  end
  local minx, miny = 10000, 10000
  local maxx, maxy = -10000, -10000
  for k, v in pairs(itemData.controllers) do
    local x1, x2, y1, y2
    if v.getControllerSize then
      x1, x2, y1, y2 = v:getControllerSize()
    else
      local rect = ed.getNodeSize(v)
      x1 = rect:getMinX()
      x2 = rect:getMaxX()
      y1 = rect:getMinY()
      y2 = rect:getMaxY()
    end
    if minx > x1 then
      minx = x1
    end
    if maxx < x2 then
      maxx = x2
    end
    if miny > y1 then
      miny = y1
    end
    if maxy < y2 then
      maxy = y2
    end
  end
  return maxx - minx, maxy - miny
end
function listView:refreshItemLayout()
  local offset = self.currentMaxHeight + self.itemHeightInner
  for i, v in ipairs(self.listData) do
    if v.itemNode and i ~= #self.listData then
      local x, y = v.itemNode:getPosition()
      v.itemNode:setPosition(x, y - offset)
    end
  end
end
function listView:refreshList(item, itemData)
  if self.maxItem and #self.listData > self.maxItem then
    self:removeItem(1)
  end
  local width, height = self:getContentSize(item, itemData)
  if height > self.currentMaxHeight then
    self.currentMaxHeight = height
  end
  if width > self.currentMaxWidth then
    self.currentMaxWidth = width
  end
  itemData.width = width
  itemData.height = height
  local itemNum = #self.listData
  local rows = math.floor((itemNum - 1) / self.colNum) + 1
  local colIndex = itemNum % self.colNum == 0 and self.colNum or itemNum % self.colNum
  if colIndex == 1 then
    self.currentWidth = 0
  end
  self.dragList:initListHeight(self.currentHeight + self.currentMaxHeight + self.itemHeightInner, false)
  local touchArea = self.dragList.cliprect
  local itemY = touchArea.size.height + touchArea.origin.y - 10 - self.currentHeight
  if self.layoutMode == "up" then
    itemY = touchArea.size.height + touchArea.origin.y - 10
    self:refreshItemLayout()
  end
  local itemX = touchArea.origin.x + self.currentWidth
  item:setPosition(ccp(itemX, itemY))
  self.currentWidth = self.currentWidth + width + self.itemWidthInner
  self.endWidth = self.endWidth
  if colIndex == self.colNum then
    self.currentHeight = self.currentHeight + self.currentMaxHeight + self.itemHeightInner
    self.currentMaxHeight = 0
    self.currentWidth = self.currentWidth + self.currentMaxHeight + self.itemWidthInner
    self.currentMaxWidth = 0
  end
  if self.currentWidth > self.endWidth then
    self.endWidth = self.currentWidth
  end
end
function listView:clear()
  if self.dragList then
    self.dragList:clearList()
  end
  self:initSelfData()
end
function listView:getItemConfig()
  if self.itemConfigIndex == nil then
    return self.configData.itemConfig
  else
    local str = string.format("itemConfig%d", self.itemConfigIndex)
    return self.configData[str]
  end
end
function listView:addItem(data, extraData)
  if nil == data then
    return
  end
  local itemConfig = self:getItemConfig()
  local item = CCSprite:create()
  local itemPanel = listItemPanel:new(self.panelLogic, item, #self.listData + 1)
  item:setAnchorPoint(ccp(1, 1))
  local controllers = itemPanel.controllers
  local readNode = ed.readnode.create(item, controllers)
  readNode:setListItemPanel(itemPanel)
  readNode:addNode(itemConfig)
  self.dragList.listLayer:addChild(item)
  local itemData = {
    data = data,
    controllers = controllers,
    itemNode = item,
    extraData = extraData,
    itemPanel = itemPanel
  }
  table.insert(self.listData, itemData)
  self:setItemData(data, controllers, extraData, itemData)
  self:refreshList(item, itemData)
  if self.autoClipItemEnabled then
    self.dragList:setFrameRect(item, CCRectMake(0, 0, itemData.width, itemData.height))
    self.dragList:setParentClipNode(item, self.dragList.listLayer)
    self.dragList:setClipItemAnchorPt(item, ccp(0, 1))
  end
  return itemData
end
function listView:setAutoClipItemsEnabled(isEnable)
  self.autoClipItemEnabled = isEnable
end
function listView:changeItemConfig(index)
  self.itemConfigIndex = index
end
function listView:newGetClickIndex(x, y)
  if self.newClickFunc == true then
    return self:getClickIndex2(x, y)
  else
    return self:getClickIndex(x, y)
  end
end
function listView:getClickIndex2(x, y)
  for i, v in ipairs(self.listData) do
    if v.itemPanel then
      local button = v.itemPanel:getTouchButton(x, y)
      if button then
        return i, button
      end
    end
  end
  return 0
end
function listView:getClickIndex(x, y)
  for i, v in ipairs(self.listData) do
    if v.itemNode then
      local pos = v.itemNode:getParent():convertToWorldSpace(ccp(v.itemNode:getPosition()))
      local anchor = self.anchor
      if x > pos.x and x < pos.x + v.width and y > pos.y - v.height * anchor.y and y < pos.y + v.height * (1 - anchor.y) then
        return i
      end
    end
  end
  return 0
end
function listView:new(configData, layer)
  local object = {}
  setmetatable(object, self)
  object.configData = configData
  object.listData = {}
  object:setPanelLayer(layer)
  object:init(configData)
  return object
end
function listView:isEmpty()
  if #self.listData == 0 then
    return true
  end
  return false
end
function listView:isContainPoint()
  return false
end
function listView:checkTouchCondition(event, x, y)
  if self.visible == false then
    return false
  end
  if ed.checkVisible(self.panelLayer) == false then
    return false
  end
  if self:isEmpty() then
    return false
  end
  local wRect = self.dragList:getTouchArea()
  if not wRect:containsPoint(ccp(x, y)) and event == "began" then
    return false
  end
  return true
end
function listView:touch(event, x, y)
  if self:checkTouchCondition(event, x, y) == false then
    return false
  end
  if self.selfDealMessage == true then
    self.dragList:doListLayerTouch(event, x, y)
  end
  if self.activeIndex > 0 and self.listData[self.activeIndex] and self.listData[self.activeIndex].itemPanel then
    self.listData[self.activeIndex].itemPanel:preTouch(event, x, y)
  end
  if self.dragList.dragMode == true then
    return true
  end
  if event == "began" then
    local currentIndex = self:newGetClickIndex(x, y)
    if currentIndex ~= 0 then
      self.activeIndex = currentIndex
      if self.listData[self.activeIndex].itemPanel then
        self.listData[self.activeIndex].itemPanel:touch(event, x, y)
      end
      if self.downhandler then
        xpcall(function()
          self.downhandler(self.listData[self.activeIndex], x, y)
        end, EDDebug)
      end
      return true
    end
  elseif event == "ended" then
    if self.activeIndex ~= 0 then
      if self.uphandler then
        xpcall(function()
          self.uphandler(self.listData[self.activeIndex], x, y, self.activeIndex)
        end, EDDebug)
      end
      if self.listData[self.activeIndex].itemPanel then
        self.listData[self.activeIndex].itemPanel:touch(event, x, y)
      end
      local index = self:newGetClickIndex(x, y)
      if index ~= 0 and self.activeIndex == index then
        print(string.format("list click:%d", index))
        if self.handler then
          xpcall(function()
            self.handler(self.listData[self.activeIndex], x, y, self.activeIndex)
          end, EDDebug)
        end
        self.activeIndex = 0
        return true
      end
      self.activeIndex = 0
    end
  elseif self.movehandler then
    xpcall(function()
      self.movehandler(self.listData[self.activeIndex], x, y, self.activeIndex)
    end, EDDebug)
  end
  return true
end
function listView:setVisible(visible)
  self.visible = visible
  if self.dragList then
    self.dragList.listLayer:setVisible(visible)
  end
end
function listView:getListData(index)
  return self.listData[index]
end
function listView:getListDataNum()
  return #self.listData
end
function listView:getALLListData()
  return self.listData
end
function listView:removeItem(index)
  if nil == index then
    return
  end
  if nil == self.listData[index] then
    return
  end
  local height = self.listData[index].height
  local startIndex, endIndex
  if self.layoutMode == "up" then
    startIndex = index - 1
    endIndex = 1
  else
    startIndex = index + 1
    endIndex = #self.listData
  end
  for i = startIndex, endIndex do
    local item = self.listData[i]
    if item and item.itemNode then
      local x, y = item.itemNode:getPosition()
      item.itemNode:setPosition(x, y + height + self.itemHeightInner)
    end
  end
  for i = index + 1, #self.listData do
    local item = self.listData[i]
    if item and item.itemPanel then
      for i, v in ipairs(item.itemPanel.buttonList) do
        if v.setArrayIndex and v.arrayIndex then
          v:setArrayIndex(v.arrayIndex - 1)
        end
      end
    end
  end
  self.dragList.listLayer:removeChild(self.listData[index].itemNode, true)
  table.remove(self.listData, index)
  self.currentHeight = self.currentHeight - height - self.itemHeightInner
  self.dragList:initListHeight(self.currentHeight, false)
end

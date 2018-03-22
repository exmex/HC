local ed = ed
local class = {
  mt = {}
}
ed.ui.addequip = class
class.mt.__index = class
local function showEquipName(self)
  local count = 0
  local isAdd = false
  local function showName(dt)
    xpcall(function()
      count = count + dt
      if count > 0.5 and not isAdd then
        local name = ed.createSprite("UI/alpha/HVGA/craft_promt_bg.png")
        local pos = ccp(self.equips[self.pressId].icon:getPosition())
        local pos = self.draglist:getItemWorldPos(pos)
        name:setPosition(ccp(pos.x, pos.y + 56))
        self.name = name
        self.layer:addChild(name, 20)
        local label = ed.createttf(self.equips[self.pressId].name, 20)
        label:setPosition(ccp(name:getContentSize().width / 2, name:getContentSize().height / 2 + 5))
        self.name:addChild(label)
        if label:getContentSize().width > name:getContentSize().width then
          name:setScaleX(label:getContentSize().width / name:getContentSize().width * 1.06)
          label:setScaleX(name:getContentSize().width / label:getContentSize().width / 1.06)
        end
        if self.showNameId then
          self.layer:getScheduler():unscheduleScriptEntry(self.showNameId)
          self.showNameId = nil
        end
        self.isLongPress = true
      end
    end, EDDebug)
  end
  return showName
end
class.showEquipName = showEquipName
local function doLengthButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for i = 1, #self.nameLen do
          if ed.containsPoint(self.lenButton[i], x, y) then
            self.pressLenId = i
          end
        end
      elseif event == "ended" then
        if self.pressLenId == nil then
          return
        end
        if ed.containsPoint(self.lenButton[self.pressLenId], x, y) then
          self.currentLen = self.nameLen[self.pressLenId]
          self:listCreate(self.currentList)
          for i = 1, #self.nameLen do
            if i == self.pressLenId then
              self.lenButtonSelect[i]:setVisible(true)
            else
              self.lenButtonSelect[i]:setVisible(false)
            end
          end
        end
        self.pressLenId = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doLengthButtonTouch = doLengthButtonTouch
local function doCategoryButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for i = 1, #self.categoryText do
          if ed.containsPoint(self.categoryButton[i], x, y) then
            self.pressCategoryId = i
          end
        end
      elseif event == "ended" then
        if self.pressCategoryId == nil then
          return
        end
        if ed.containsPoint(self.categoryButton[self.pressCategoryId], x, y) then
          if self.pressCategoryId == 1 then
            self:listCreate(self.listAll)
          elseif self.pressCategoryId == 2 then
            self:listCreate(self.listComponent)
          elseif self.pressCategoryId == 3 then
            self:listCreate(self.listSynthetics)
          elseif self.pressCategoryId == 4 then
            self:listCreate(self.listConsume)
          elseif self.pressCategoryId == 5 then
            self:listCreate(self.listScroll)
          elseif self.pressCategoryId == 6 then
            self:listCreate(self.listFragment)
          end
          for i = 1, #self.categoryText do
            if i == self.pressCategoryId then
              self.categoryButtonSelect[i]:setVisible(true)
            else
              self.categoryButtonSelect[i]:setVisible(false)
            end
          end
        end
        self.pressCategoryId = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doCategoryButtonTouch = doCategoryButtonTouch
local function doModelButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for i = 1, #self.modelText do
          if ed.containsPoint(self.modelButton[i], x, y) then
            self.pressModelId = i
          end
        end
      elseif event == "ended" then
        if self.pressModelId == nil then
          return
        end
        if ed.containsPoint(self.modelButton[self.pressModelId], x, y) then
          self.model = self.pressModelId
          self:listCreate(self.currentList)
          for i = 1, #self.modelText do
            if i == self.pressModelId then
              self.modelButtonSelect[i]:setVisible(true)
            else
              self.modelButtonSelect[i]:setVisible(false)
            end
          end
        end
        self.pressModelId = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doModelButtonTouch = doModelButtonTouch
local function doNumberButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for i = 1, #self.number do
          if ed.containsPoint(self.numberButton[i], x, y) then
            self.pressNumberId = i
            break
          end
        end
      elseif event == "ended" then
        if self.pressNumberId == nil then
          return
        end
        if ed.containsPoint(self.numberButton[self.pressNumberId], x, y) then
          self.addNumber = self.number[self.pressNumberId]
          for i = 1, #self.number do
            if i == self.pressNumberId then
              self.numberButtonSelect[i]:setVisible(true)
            else
              self.numberButtonSelect[i]:setVisible(false)
            end
          end
        end
        self.pressNumberId = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doNumberButtonTouch = doNumberButtonTouch
local function doBackButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.back, x, y) then
          self.backShade:setVisible(true)
          self.isPressBack = true
        end
      elseif event == "ended" then
        if ed.containsPoint(self.back, x, y) and self.isPressBack then
          CCDirector:sharedDirector():popScene()
        end
        self.backShade:setVisible(false)
        self.isPressBack = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doBackButtonTouch = doBackButtonTouch
local doMainLayerTouch = function(self)
  local function handler(event, x, y)
    xpcall(function()
      self:doBackButtonTouch()(event, x, y)
      self:doNumberButtonTouch()(event, x, y)
      self:doModelButtonTouch()(event, x, y)
      self:doCategoryButtonTouch()(event, x, y)
      self:doLengthButtonTouch()(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doClickInList(self)
  local function handler(x, y, id)
    xpcall(function()
      for k, v in pairs(self.equips) do
        if ed.containsPoint(v.icon, x, y, self.draglist:getList()) and id == k and not self.isLongPress then
          ed.player:gmAddEquip(self.equips[id].id, self.addNumber)
          local text = LSTR("ADDEQUIP.GET") .. self.addNumber .. LSTR("ADDEQUIP.A") .. self.equips[id].name
          ed.showToast(text, ccp(440, 440))
        end
      end
      if self.showNameId then
        self.layer:getScheduler():unscheduleScriptEntry(self.showNameId)
        self.showNameId = nil
      end
      if self.name then
        self.name:removeFromParentAndCleanup(true)
        self.name = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doClickInList = doClickInList
local cancelClickInList = function(self)
  local function handler(x, y, id)
    xpcall(function()
      if id then
        self.equips[id].icon:setScale(self.iconScale * 1)
      end
      if self.showNameId then
        self.layer:getScheduler():unscheduleScriptEntry(self.showNameId)
        self.showNameId = nil
      end
      if self.name then
        self.name:removeFromParentAndCleanup(true)
        self.name = nil
      end
    end, EDDebug)
  end
  return handler
end
class.cancelClickInList = cancelClickInList
local function doPressInList(self)
  local function handler(x, y)
    local pressId
    xpcall(function()
      self.isLongPress = nil
      for k, v in pairs(self.equips) do
        if ed.containsPoint(v.icon, x, y, self.draglist:getList()) then
          v.icon:setScale(self.iconScale * 0.95)
          self.pressId = k
          local handler = self:showEquipName()
          self.showNameId = self.layer:getScheduler():scheduleScriptFunc(handler, 0, false)
          pressId = k
        end
      end
    end, EDDebug)
    return pressId
  end
  return handler
end
class.doPressInList = doPressInList
local cancelPressInList = function(self)
  local function handler(x, y, id)
    xpcall(function()
      if id then
        self.equips[id].icon:setScale(self.iconScale * 1)
      end
      if self.showNameId then
        self.layer:getScheduler():unscheduleScriptEntry(self.showNameId)
        self.showNameId = nil
      end
      if self.name then
        self.name:removeFromParentAndCleanup(true)
        self.name = nil
      end
    end, EDDebug)
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local function getList(self)
  self.listAll = {}
  self.listComponent = {}
  self.listSynthetics = {}
  self.listFragment = {}
  self.listConsume = {}
  self.listScroll = {}
  local data = ed.getDataTable("equip")
  for k, v in pairs(data) do
    if type(k) == "number" then
      local id = k
      local hasIcon = string.find(ed.readequip.value(id, "Icon") or "", "UI/", 0)
      if hasIcon then
        local name = ed.readequip.value(id, "Name")
        local category = ed.readequip.value(id, "Category")
        local len = ed.readequip.value(id, "length") or 7
        table.insert(self.listAll, {
          id = id,
          name = name,
          category = category,
          len = len
        })
        if category == T(LSTR("EQUIP.PARTS")) then
          table.insert(self.listComponent, {
            id = id,
            name = name,
            category = category,
            len = len
          })
        elseif category == T(LSTR("EQUIP.REEL")) then
          table.insert(self.listScroll, {
            id = id,
            name = name,
            category = category,
            len = len
          })
        elseif category == T(LSTR("EQUIP.SYNTHETICS")) then
          table.insert(self.listSynthetics, {
            id = id,
            name = name,
            category = category,
            len = len
          })
        elseif category == T(LSTR("EQUIP.CONSUMABLES")) then
          table.insert(self.listConsume, {
            id = id,
            name = name,
            category = category,
            len = len
          })
        elseif category == T(LSTR("EQUIP.FRAGMENT")) then
          table.insert(self.listFragment, {
            id = id,
            name = name,
            category = category,
            len = len
          })
        end
      end
    end
  end
end
class.getList = getList
local function listCreate(self, list)
  self.draglist:clearList()
  local model = self.model
  self.currentList = list
  self.equips = {}
  for k, v in pairs(list) do
    local id = v.id
    local name = v.name
    local category = v.category
    local len = v.len
    len = tonumber(len)
    local icon
    if not model or model == 1 then
      if not self.currentLen or self.currentLen == 0 or self.currentLen ~= 4 and len == self.currentLen or self.currentLen == 4 and len >= self.currentLen then
        icon = ed.readequip.createIcon(id, 50)
        self.iconScale = 0.6944444444444444
      end
    elseif model == 2 and (not self.currentLen or self.currentLen == 0 or self.currentLen ~= 4 and len == self.currentLen or self.currentLen == 4 and len >= self.currentLen) then
      icon = ed.createSprite("UI/alpha/HVGA/elitetoggle-ns.png")
      local label = ed.createttf(name, 15)
      label:setPosition(ccp(49, 24))
      icon:addChild(label)
      self.iconScale = 1
    end
    if not self.currentLen or self.currentLen == 0 or self.currentLen ~= 4 and len == self.currentLen or self.currentLen == 4 and len >= self.currentLen then
      table.insert(self.equips, {
        id = id,
        name = name,
        icon = icon
      })
    end
  end
  if not model or model == 1 then
    local amount = 0
    for k, v in pairs(self.equips) do
      v.icon:setPosition(ccp(192 + 65 * ((k - 1) % 9), 375 - 65 * math.floor((k - 1) / 9)))
      self.draglist:addItem(v.icon)
      amount = amount + 1
    end
    self.draglist:initListHeight(65 * math.ceil(amount / 9) + 5)
  elseif model == 2 then
    local amount = 0
    for k, v in pairs(self.equips) do
      v.icon:setPosition(ccp(194 + 102 * ((k - 1) % 6), 375 - 65 * math.floor((k - 1) / 6)))
      self.draglist:addItem(v.icon)
      amount = amount + 1
    end
    self.draglist:initListHeight(65 * math.ceil(amount / 6) + 5)
  end
end
class.listCreate = listCreate
local function create()
  local self = {}
  setmetatable(self, class.mt)
  self.addNumber = 1
  local scene = CCScene:create()
  self.scene = scene
  local layer = CCLayer:create()
  self.layer = layer
  scene:addChild(layer)
  layer:setTouchEnabled(true)
  local handler = self:doMainLayerTouch()
  layer:registerScriptTouchHandler(handler, false, 0, false)
  local bg = ed.createSprite("UI/alpha/HVGA/bg.jpg")
  bg:setPosition(ccp(400, 240))
  layer:addChild(bg)
  local back = ed.createSprite("UI/alpha/HVGA/backbtn.png")
  back:setPosition(ccp(30, 444))
  self.back = back
  layer:addChild(back)
  local backShade = ed.createSprite("UI/alpha/HVGA/backbtn-disabled.png")
  backShade:setPosition(ccp(30, 444))
  backShade:setVisible(false)
  self.backShade = backShade
  layer:addChild(backShade)
  self.number = {1, 99}
  self.numberButton = {}
  self.numberButtonSelect = {}
  for i = 1, #self.number do
    local button = ed.createSprite("UI/alpha/HVGA/elitetoggle-ns.png")
    button:setPosition(ccp(160 + 100 * (i - 1), 444))
    self.numberButton[i] = button
    layer:addChild(button)
    local buttonSelect = ed.createSprite("UI/alpha/HVGA/elitetoggle-s.png")
    buttonSelect:setPosition(ccp(160 + 100 * (i - 1), 444))
    self.numberButtonSelect[i] = buttonSelect
    if i ~= 1 then
      buttonSelect:setVisible(false)
    end
    layer:addChild(buttonSelect)
    local label = ed.createttf("" .. self.number[i], 20)
    label:setPosition(ccp(160 + 100 * (i - 1), 444))
    layer:addChild(label, 1)
  end
  self.modelText = {LSTR("ADDEQUIP.IMAGE_MODE"), LSTR("ADDEQUIP.TEXT_MODE")}
  self.modelButton = {}
  self.modelButtonSelect = {}
  for i = 1, #self.modelText do
    local button = ed.createSprite("UI/alpha/HVGA/elitetoggle-ns.png")
    button:setPosition(ccp(55, 390 - 50 * (i - 1)))
    self.modelButton[i] = button
    layer:addChild(button)
    local buttonSelect = ed.createSprite("UI/alpha/HVGA/elitetoggle-s.png")
    buttonSelect:setPosition(ccp(55, 390 - 50 * (i - 1)))
    self.modelButtonSelect[i] = buttonSelect
    if i ~= 1 then
      buttonSelect:setVisible(false)
    end
    layer:addChild(buttonSelect)
    local label = ed.createttf("" .. self.modelText[i], 20)
    label:setPosition(ccp(55, 390 - 50 * (i - 1)))
    layer:addChild(label, 1)
  end
  self.categoryText = {
    T(LSTR("BATTLEPREPARE.WHOLE")),
    T(LSTR("EQUIP.PARTS")),
    T(LSTR("EQUIP.SYNTHETICS")),
    T(LSTR("EQUIP.CONSUMABLES")),
    T(LSTR("EQUIP.REEL")),
    T(LSTR("EQUIP.FRAGMENT"))
  }
  self.categoryButton = {}
  self.categoryButtonSelect = {}
  for i = 1, #self.categoryText do
    local button = ed.createSprite("UI/alpha/HVGA/elitetoggle-ns.png")
    button:setPosition(ccp(55, 270 - 45 * (i - 1)))
    self.categoryButton[i] = button
    layer:addChild(button)
    local buttonSelect = ed.createSprite("UI/alpha/HVGA/elitetoggle-s.png")
    buttonSelect:setPosition(ccp(55, 270 - 45 * (i - 1)))
    self.categoryButtonSelect[i] = buttonSelect
    if i ~= 1 then
      buttonSelect:setVisible(false)
    end
    layer:addChild(buttonSelect)
    local label = ed.createttf("" .. self.categoryText[i], 20)
    label:setPosition(ccp(55, 270 - 45 * (i - 1)))
    layer:addChild(label, 1)
  end
  self.nameLen = {
    0,
    2,
    3,
    4
  }
  self.lenText = {
    T(LSTR("BATTLEPREPARE.WHOLE")),
    "2",
    "3",
    ">4"
  }
  self.lenButton = {}
  self.lenButtonSelect = {}
  for i = 1, #self.lenText do
    local button = ed.createSprite("UI/alpha/HVGA/elitetoggle-ns.png")
    button:setPosition(ccp(435 + 100 * (i - 1), 444))
    self.lenButton[i] = button
    layer:addChild(button)
    local buttonSelect = ed.createSprite("UI/alpha/HVGA/elitetoggle-s.png")
    buttonSelect:setPosition(ccp(435 + 100 * (i - 1), 444))
    self.lenButtonSelect[i] = buttonSelect
    if i ~= 1 then
      buttonSelect:setVisible(false)
    end
    layer:addChild(buttonSelect)
    local label = ed.createttf("" .. self.lenText[i], 20)
    label:setPosition(ccp(435 + 100 * (i - 1), 444))
    layer:addChild(label, 1)
  end
  local sf = ed.getSpriteFrame("UI/alpha/HVGA/equip_detail_bg.png")
  local frame = CCScale9Sprite:createWithSpriteFrame(sf, CCRectMake(20, 20, 410, 360))
  frame:setContentSize(CCSizeMake(680, 400))
  frame:setPosition(ccp(450, 220))
  layer:addChild(frame)
  local info = {
    cliprect = CCRectMake(140, 35, 620, 376),
    container = self.layer,
    zorder = 10,
    bar = {
      bglen = 360,
      bgpos = ccp(130, 220)
    },
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.draglist = ed.draglist.create(info)
  self:getList()
  self:listCreate(self.listAll)
  return self
end
class.create = create

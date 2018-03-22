local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
ed.ui.handbook = class
local lsr = ed.ui.handbooklsr.create()
local isVerticalJudge = true
local pageChangeDistanceThreshold = 100
local pageChangeGapThreshold = 1
local leftFirstX, leftFirstY = 196, 356
local rightFirstX, rightFirstY = 476, 356
local gapX, gapY = 130, 115
local equipIconSize
local equipIconPosX, equipIconPosY = 57, 64
local equipNameLabelSize = 18
local equipNameLabelColor = ccc3(182, 65, 21)
local equipNameLabelPosX, equipNameLabelPosY = 57, 17
local leftArrowPosX, leftArrowPosY = 295, 50
local rightArrowPosX, rightArrowPosY = 515, 50
local tagNormalColor = ccc3(178,150,146)
local tagSelectColor = ccc3(255,255,255)
local clickTime
local tagTextIndex = {
  ALL = 1,
  STR = 2,
  AGI = 3,
  INT = 4,
  HP = 5,
  AD = 6,
  AP = 7,
  ARM = 8,
  CRIT = 9,
  HPS = 10,
  MPS = 11,
  HEAL = 12
}
local tagText = {
  T(LSTR("BATTLEPREPARE.WHOLE")),
  T(LSTR("HERO_EQUIP.STRENGTH")),
  T(LSTR("HERO_EQUIP.AGILITY")),
  T(LSTR("HERO_EQUIP.INTELLIGENCE")),
  T(LSTR("HANDBOOK.HEALTH")),
  T(LSTR("HANDBOOK.PHYSICAL_ATTACK")),
  T(LSTR("HANDBOOK.MAGIC_ATTACK")),
  T(LSTR("HANDBOOK.ARMOR")),
  T(LSTR("HANDBOOK.CRIT")),
  T(LSTR("HANDBOOK.HEALTH_SUPPLY")),
  T(LSTR("HANDBOOK.MAGIC_SUPPLY")),
  T(LSTR("SKILL.HEAL")),
  title1 = T(LSTR("HANDBOOK.WHOLE")),
  title2 = T(LSTR("HANDBOOK.POWER")),
  title3 = T(LSTR("HANDBOOK.AGILITY")),
  title4 = T(LSTR("HANDBOOK.INTELLIGENCE")),
  title5 = T(LSTR("BASERES.MAXIMUM_HP")),
  title6 = T(LSTR("BASERES.PHYSICAL_ATTACK")),
  title7 = T(LSTR("BASERES.MAGIC_STRENGTH")),
  title8 = T(LSTR("BASERES.PHYSICAL_ARMOR")),
  title9 = T(LSTR("HANDBOOK.PHYSICAL_CRIT_MAGIC_CRIT")),
  title10 = T(LSTR("BASERES.RECOVER_HP_AFTER_EACH_BATTLE")),
  title11 = T(LSTR("BASERES.REPLENISH_ENERGY_AFTER_EACH_BATTLE")),
  title12 = T(LSTR("BASERES.IMPROVE_THERAPEUTIC_SKILL_EFFECT")),
  list1 = "ALL",
  list2 = "STR",
  list3 = "AGI",
  list4 = "INT",
  list5 = "HP",
  list6 = "AD",
  list7 = "AP",
  list8 = "ARM",
  list9 = "CRIT",
  list10 = "HPS",
  list11 = "MPS",
  list12 = "HEAL"
}
local function doSelectTag(self, id)
  if not self.currentTagID then
    self.currentTagID = 1
  end
  id = id or 1
  local pid = self.currentTagID
  self.currentTagID = id
  if pid == id and  (self.pageid or 1) == 1 then
    
  else
    lsr:report("handbooklsr")
  end
  self.tagButtonPress[pid]:setVisible(false)
  self.tagButton[pid]:setVisible(true)
  self.tagLabel[pid]:setPosition(self:getTagPosition(3, pid))
  self.tagLabel[pid]:setZOrder(4)
  self.tagLabel[pid]:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelColor(self.tagLabel[pid],ccc3(178,150,146))
  self.tagButtonPress[id]:setVisible(true)
  self.tagButton[id]:setVisible(false)
  self.tagLabel[id]:setPosition(self:getTagPosition(3, id))
  self.tagLabel[id]:setZOrder(9)
  self.tagLabel[id]:disableShadow()
  ed.setLabelColor(self.tagLabel[id], ccc3(255, 255, 255))
  self:createPage(tagText["list" .. id], 1)
end
class.doSelectTag = doSelectTag
local function doSelectElement(self, id)
  lsr:report("clickElement")
  self.craftLayer = ed.ui.equipcraft.create({context = "handbook", eid = id})
  self.mainLayer:addChild(self.craftLayer.mainLayer, 30)
end
class.doSelectElement = doSelectElement
local function doEquipTouch(self)
  local id
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        self.isClickEquip = nil
        for i = 1, #self.equipElements do
          if ed.containsPoint(self.equipElements[i].icon, x, y) then
            id = i
            self.equipElements[i].icon:setScale(0.95)
          end
        end
      elseif event == "ended" then
        if id and not self.isChangePage then
          local element = self.equipElements[id]
          element.icon:setScale(1)
          if ed.containsPoint(element.icon, x, y) and (not self.craftLayer or not self.craftLayer:isShow()) then
            if element.isOpen then
              self:doSelectElement(element.id)
              self.isClickEquip = true
            else
              ed.showToast(T(LSTR("HANDBOOK.NOT_YET_UNLOCKED_PLEASE_UPGRADE_YOURSELF")))
            end
          end
        end
        id = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doEquipTouch = doEquipTouch
local function doChangePageTouch(self)
  local pos, pressTime
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        self.isChangePage = nil
        if ed.containsPoint(self.ui.book_page, x, y) then
          pos = ccp(x, y)
          pressTime = ed.getMillionTime()
        end
      elseif event == "ended" then
        local pressTime = pressTime or ed.getMillionTime()
        local time = ed.getMillionTime()
        local gap = time - pressTime
        if not isVerticalJudge or isVerticalJudge and pos and math.abs(x - pos.x) > math.abs(y - pos.y) then
          if x - pos.x > pageChangeDistanceThreshold and gap < pageChangeGapThreshold then
            self:setPage("-1")
            self.isChangePage = true
          elseif x - pos.x < -pageChangeDistanceThreshold and gap < pageChangeGapThreshold then
            self:setPage("+1")
            self.isChangePage = true
          end
        end
        pos = nil
        pressTime = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doChangePageTouch = doChangePageTouch
local function doTagButtonTouch(self)
  local id
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for i = 1, 12 do
          if ed.containsPoint(self.tagButton[i], x, y) then
            id = i
            self.isClickTag = nil
            local press = self.tagButtonPress[i]
            local button = self.tagButton[i]
            local label = self.tagLabel[i]
            press:setVisible(true)
            button:setVisible(false)
            label:setPosition(self:getTagPosition(3, i, true))
            label:disableShadow()
            label:setZOrder(9)
            ed.setLabelColor(label, ccc3(255, 255, 255))
          end
        end
      elseif event == "ended" then
        if id then
          local press = self.tagButtonPress[id]
          local button = self.tagButton[id]
          local label = self.tagLabel[id]
          press:setVisible(false)
          button:setVisible(true)
          label:setPosition(self:getTagPosition(3, id, false))
          label:setShadow(ccc3(0, 0, 0), ccp(0, 2))
          label:setZOrder(4)
          ed.setLabelColor(label, ccc3(255, 255, 255))
          if ed.containsPoint(button, x, y) and not self.isClickEquip then
            self:doSelectTag(id)
            self.isClickTag = true
          end
        end
        id = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doTagButtonTouch = doTagButtonTouch
local function doBackButtonTouch(self)
  local isPress
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.ui.back, x, y) then
          isPress = true
          self.ui.backPress:setVisible(true)
        end
      elseif event == "ended" then
        if isPress then
          self.ui.backPress:setVisible(false)
          if ed.containsPoint(self.ui.back, x, y) then
            lsr:report("clickBack")
            ed.popScene()
          end
        end
        isPress = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doBackButtonTouch = doBackButtonTouch
local function doArrowTouch(self)
  local isPressLeft, isPressRight
  local function handler(event, x, y)
    xpcall(function()
      local time = ed.getMillionTime()
      local canClick = clickTime == nil or time - clickTime > 0.5
      if event == "began" then
        if ed.containsPoint(self.ui.left_arrow, x, y) and canClick then
          isPressLeft = true
          self.ui.left_arrow:setScale(0.95)
        end
        if ed.containsPoint(self.ui.right_arrow, x, y) and canClick then
          isPressRight = true
          self.ui.right_arrow:setScale(0.95)
        end
      elseif event == "ended" then
        if isPressLeft and canClick then
          lsr:report("clickArrow")
          isPressLeft = nil
          self.ui.left_arrow:setScale(1)
          self:setPage("-1")
          clickTime = ed.getMillionTime()
        end
        if isPressRight and canClick then
          lsr:report("clickArrow")
          isPressRight = nil
          self.ui.right_arrow:setScale(1)
          self:setPage("+1")
          clickTime = ed.getMillionTime()
        end
        isPressLeft = nil
        isPressRight = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doArrowTouch = doArrowTouch
local doMainLayerTouch = function(self)
  local tagButtonTouch = self:doTagButtonTouch()
  local backTouch = self:doBackButtonTouch()
  local changePageTouch = self:doChangePageTouch()
  local equipTouch = self:doEquipTouch()
  local arrowTouch = self:doArrowTouch()
  local function handler(event, x, y)
    xpcall(function()
      backTouch(event, x, y)
      changePageTouch(event, x, y)
      equipTouch(event, x, y)
      tagButtonTouch(event, x, y)
      arrowTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local getTagPosition = function(self, type, index, isLabelSelected)
  type = type or 1
  index = index or 1
  local osx = 10
  local x, y = 0, 0
  if index <= 6 then
    if type == 1 then
      x = 93 - 2 * (index - 1)
    elseif type == 2 then
      x = 83
    elseif type == 3 then
      if isLabelSelected == nil then
        if index == (self.currentTagID or 1) then
          x = 83 - osx - 24
        else
          x = 93 - osx - 2 * (index - 1) - 24
        end
      elseif isLabelSelected then
        x = 83 - osx - 24
      else
        x = 93 - osx - 2 * (index - 1) - 24
      end
    end
    y = 360 - 60 * (index - 1)
    if type == 3 then
      y = y + 3
    end
  else
    if type == 1 then
      x = 710 + 2 * (index - 7)
    elseif type == 2 then
      x = 720
    elseif type == 3 then
      if isLabelSelected == nil then
        if index == (self.currentTagID or 1) then
          x = 720 + osx + 24
        else
          x = 710 + osx + 2 * (index - 7) + 24
        end
      elseif isLabelSelected then
        x = 720 + osx + 24
      else
        x = 710 + osx + 2 * (index - 7) + 24
      end
    end
    y = 360 - 60 * (index - 7)
    if type == 3 then
      y = y + 3
    end
  end
  return ccp(x, y)
end
class.getTagPosition = getTagPosition
local function createTagButton(self)
  local ui_info = {}
  for i = 1, 1 do
    local b = {
      t = "Sprite",
      base = {
        name = i,
        res = i > 6 and "UI/alpha/HVGA/handbook_right.png" or "UI/alpha/HVGA/handbook_left.png",
        array = self.tagButton,
        z = 4
      },
      layout = {
        position = self:getTagPosition(1, i)
      },
      config = {
        visible = false
      }
    }
    local pb = {
      t = "Sprite",
      base = {
        name = i,
        res = i > 6 and "UI/alpha/HVGA/handbook_right_select.png" or "UI/alpha/HVGA/handbook_left_select.png",
        array = self.tagButtonPress,
        z = 9
      },
      layout = {
        position = self:getTagPosition(2, i)
      },
      config = {
        visible = false
      }
    }

    local bt = {
      t = "Label",
      base = {
        name = i,
        text = tagText[i],
        font = ed.selfFont,
        size = 16,
        array = self.tagLabel,
        z = i == 1 and 9 or 4
      },
      layout = {
        anchor =   (i > 6)  and ccp(1, 0.5) or ccp(0, 0.5)  ,
        position = self:getTagPosition(3, i)
      },
      config = {
        color = i == 1 and tagSelectColor or tagNormalColor,
		visible=false
      }
    }
    table.insert(ui_info, b)
    table.insert(ui_info, pb)
    table.insert(ui_info, bt)
  end
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
end
class.createTagButton = createTagButton
local function getIconPosition(self, id)
  if not id or id < 1 or id > 12 then
    return ccp(0, 0)
  end
  if id <= 6 then
    return ccp(leftFirstX + gapX * ((id - 1) % 2), leftFirstY - gapY * math.floor((id - 1) / 2))
  else
    return ccp(rightFirstX + gapX * ((id - 7) % 2), leftFirstY - gapY * math.floor((id - 7) / 2))
  end
end
class.getIconPosition = getIconPosition
local function createIcon(self, info)
  local bg = ed.createSprite("UI/alpha/HVGA/handbook_equip_bg.png")
  bg:setCascadeOpacityEnabled(true)
  local name = info.name
  local isOpen = false
  if ed.player:getLevel() >= info.lr then
    local icon = ed.readequip.createIcon(info.id, equipIconSize)
    icon:setPosition(ccp(equipIconPosX, equipIconPosY))
    bg:addChild(icon)
    isOpen = true
  else
    local iconBg = ed.createSprite("UI/alpha/HVGA/handbook_icon_bg.png")
    iconBg:setCascadeOpacityEnabled(true)
    local icon = ed.createSprite("UI/alpha/HVGA/handbook_icon_lock.png")
    icon:setPosition(ccp(33, 33))
    iconBg:addChild(icon)
    iconBg:setPosition(ccp(equipIconPosX, equipIconPosY))
    bg:addChild(iconBg)
    name = T(LSTR("HANDBOOK.LV_D_ACTIVATED"), info.lr)
  end
  local label = ed.createttf(name, equipNameLabelSize)
  ed.setLabelColor(label, equipNameLabelColor)
  if label:getContentSize().width > 114 then
    label:setScale(114 / label:getContentSize().width)
  end
  label:setPosition(ccp(equipNameLabelPosX, equipNameLabelPosY))
  bg:addChild(label)
  return bg, isOpen
end
class.createIcon = createIcon
local createList = function(self, listName, page)
  local eAmount = #self.list[listName]
  local pAmount = math.ceil(eAmount / 12)
  local equipElements = {}
  for i = 12 * (page - 1) + 1, eAmount < 12 * page and eAmount or 12 * page do
    local info = self.list[listName][i]
    local icon, isOpen = self:createIcon(info)
    icon:setPosition(self:getIconPosition(i - 12 * (page - 1)))
    self.pageLayer:addChild(icon)
    table.insert(equipElements, {
      icon = icon,
      id = info.id,
      name = info.name,
      isOpen = isOpen
    })
  end
  self.equipElements = equipElements
end
class.createList = createList
local function setPageTitle(self, listName, page)
  if (self.currentListName or "") ~= listName then
    do
      local pageTitle = ed.createttf(tagText["title" .. tagTextIndex[listName]], 18, ed.selfFont)
      ed.setLabelColor(pageTitle, ccc3(255, 255, 255))
      pageTitle:setPosition(ccp(400, 431))
      self.mainLayer:addChild(pageTitle, 20)
      pageTitle:setOpacity(0)
      local element
      if self.ui.pageTitle then
        element = self.ui.pageTitle
      end
      self.ui.pageTitle = pageTitle
      if element then
        local action = CCFadeOut:create(0.2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            element:removeFromParentAndCleanup(true)
            local action = CCFadeIn:create(0.2)
            self.ui.pageTitle:runAction(action)
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(action, func)
        element:runAction(sequence)
      else
        local action = CCFadeIn:create(0.2)
        pageTitle:runAction(action)
      end
    end
  end
  if (self.currentListName or "") == listName then
  else--if (self.pageid or 0) ~= page then --modify by xinghui DT-163
    self.pageAmount = math.ceil(#self.list[listName] / 12) or 1
    if self.pageAmount < 1 then
      self.pageAmount = 1
    end
    do
      local pageNumber = ed.createttf(string.format("· %d / %d ·", page, self.pageAmount), 18)
      pageNumber:setPosition(ccp(640, 55))
      ed.setLabelColor(pageNumber, ccc3(174, 133, 76))
      self.mainLayer:addChild(pageNumber, 20)
      pageNumber:setOpacity(0)
      local element
      if self.ui.pageNumber then
        element = self.ui.pageNumber
      end
      self.ui.pageNumber = pageNumber
      if element then
        local action = CCFadeOut:create(0.2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            element:removeFromParentAndCleanup(true)
            local action = CCFadeIn:create(0.2)
            self.ui.pageNumber:runAction(action)
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(action, func)
        element:runAction(sequence)
      else
        local action = CCFadeIn:create(0.2)
        pageNumber:runAction(action)
      end
    end
  end
end
class.setPageTitle = setPageTitle
local function setPage(self, page)
  if page == "+1" then
    page = self.pageid + 1
  end
  if page == "-1" then
    page = self.pageid - 1
  end
  local prePage = self.pageid
  self:createPage(self.currentListName, page)
  ed.setString(self.ui.pageNumber, string.format("· %d / %d ·", self.pageid, self.pageAmount))
  if prePage == self.pageid then
    lsr:report("tuenPageFailed")
  else
    lsr:report("turnPage")
  end
end
class.setPage = setPage
local createPage = function(self, listName, page)
  listName = listName or self.currentListName or "ALL"
  page = page or 1
  local eAmount = #self.list[listName]
  local pAmount = math.ceil(eAmount / 12)
  if page > pAmount then
    page = pAmount
  end
  if page < 1 then
    page = 1
  end
  self:setPageTitle(listName, page)
  if (self.currentListName or "") ~= listName or self.pageid ~= page then
    self.currentListName = listName
    self.pageid = page
    do
      local pageLayer = CCSprite:create()
      pageLayer:setCascadeOpacityEnabled(true)
      self.mainLayer:addChild(pageLayer, 20)
      local element
      if self.pageLayer then
        element = self.pageLayer
      end
      self.pageLayer = pageLayer
      self:createList(listName, page)
      pageLayer:setOpacity(0)
      if element then
        local action = CCFadeOut:create(0.2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            element:removeFromParentAndCleanup(true)
            local action = CCFadeIn:create(0.2)
            self.pageLayer:runAction(action)
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(action, func)
        element:runAction(sequence)
      else
        local action = CCFadeIn:create(0.2)
        self.pageLayer:runAction(action)
      end
    end
  end
end
class.createPage = createPage
local function create()
  local self = base.create("handbook")
  setmetatable(self, class.mt)
  local scene = self.scene
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  scene:addChild(mainLayer)
  self.ui = {}
  self.tagButton = {}
  self.tagButtonPress = {}
  self.tagLabel = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/bg.jpg"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "book_bg",
        res = "UI/alpha/HVGA/handbook_bg.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "book_page_shade",
        res = "UI/alpha/HVGA/handbook_bg_2.png",
        z = 5
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "book_page",
        res = "UI/alpha/HVGA/handbook_bg_1.png",
        z = 10
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/backbtn.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(70, 428)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "backPress",
        res = "UI/alpha/HVGA/backbtn-disabled.png",
        parent = "back"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "left_arrow",
        res = "UI/alpha/HVGA/handbook_left_arrow.png",
        z = 20
      },
      layout = {
        position = ccp(leftArrowPosX, leftArrowPosY)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "right_arrow",
        res = "UI/alpha/HVGA/handbook_right_arrow.png",
        z = 20
      },
      layout = {
        position = ccp(rightArrowPosX, rightArrowPosY)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createTagButton()
  self.list = ed.readequip.classifyEquip()
  self:createPage("ALL", 1)
  ed.tutorial.tell("aboutHandbook", self.mainLayer)
  ed.endTeach("aboutHandbook")
  return self
end
class.create = create

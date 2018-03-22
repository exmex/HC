local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipdetail = class
local lsr = ed.ui.equipdetaillsr.create()
local offsetX = -40
local refreshClipRect = function(self)
  local function handler(dt)
    xpcall(function()
      if tolua.isnull(self.layer) then
        self:endRefreshCliprect()
        return
      end
      self.draglist:refreshClipRect(self.layer:getScale())
    end, EDDebug)
  end
  return handler
end
class.refreshClipRect = refreshClipRect
local beginRefreshCliprect = function(self)
  self.baseScene:registerUpdateHandler("refreshCliprect", self:refreshClipRect())
end
class.beginRefreshCliprect = beginRefreshCliprect
local endRefreshCliprect = function(self)
  self.baseScene:removeUpdateHandler("refreshCliprect")
end
class.endRefreshCliprect = endRefreshCliprect
local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.closePress
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCloseTouch = doCloseTouch
local function doOutLayerTouch(self)
  local isPress
  local ui = self.ui
  local bg = self.ui.bg
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(self.ui.bg, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not ed.containsPoint(self.ui.bg, x, y) then
        self:destroy()
      end
      isPress = nil
    end
  end
  return handler
end
class.doOutLayerTouch = doOutLayerTouch
local doMainLayerTouch = function(self)
  local outLayerTouch = self:doOutLayerTouch()
  local closeTouch = self:doCloseTouch()
  local function handler(event, x, y)
    xpcall(function()
      outLayerTouch(event, x, y)
      closeTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function getEquipData(self, id)
  local equipList = {}
  local craftData = ed.getDataTable("equipcraft")
  for k, v in pairs(craftData) do
    for i = 1, 4 do
      if v["Component" .. i] == id and not ed.getDataTable("equip")[k].Hide then
        if k ~= id then
          table.insert(equipList, {
            id = k,
            name = ed.getDataTable("equip")[k].Name
          })
        end
        break
      end
    end
  end
  self.equipList = equipList
  local heroList = {}
  local idList = {}
  local heroData = ed.getDataTable("hero_equip")
  local unitData = ed.getDataTable("Unit")
  for k, v in pairs(heroData) do
    local index = 1
    while v[index] do
      local row = v[index]
      for j = 1, 6 do
        if row["Equip" .. j .. " ID"] == id then
          if k > 0 then
            local ur = unitData[k]
            if ur then
              if 0 < (ed.player.equip_qunty[ed.readhero.getStoneid(k)] or 0) and index <= ed.parameter.display_equipale_hero_rank then
                local name = ur["Display Name"]
                table.insert(heroList, {
                  id = k,
                  rank = index,
                  name = name
                })
                table.insert(idList, k)
              end
            end
          end
          break
        end
      end
      index = index + 1
    end
  end
  self.heroList = heroList
end
class.getEquipData = getEquipData
local function createDetail(self, id)
  id = id or self.id
  self.draglist:clearList()
  self:getEquipData(id)
  local layer = self.draglist:getList()
  local height = 15
  local gap = 20
  if #self.equipList > 0 then
    local equipTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
    equipTitleBg:setPosition(ccp(440 + offsetX, 435 - height - equipTitleBg:getContentSize().height / 2))
    layer:addChild(equipTitleBg)
    local equipTitle = ed.createttf(T(LSTR("EQUIPDETAIL.EQUIPMENT_CAN_BE_SYNTHESIZED")), 24)
    ed.setLabelColor(equipTitle, ccc3(250, 205, 16))
    equipTitle:setPosition(ccp(equipTitleBg:getPosition()))
    layer:addChild(equipTitle)
    height = height + gap + equipTitleBg:getContentSize().height
    local equipHeight = 15 + 55 * math.ceil(#self.equipList / 2)
    local equipListBg = ed.createScale9Sprite("UI/alpha/HVGA/equip_detail_panel_bg.png", CCRectMake(10, 30, 400, 65))
    equipListBg:setAnchorPoint(ccp(0.5, 1))
    equipListBg:setPosition(ccp(440 + offsetX, 435 - height))
    if equipHeight < 60 then
      equipHeight = 60
    end
    equipListBg:setContentSize(CCSizeMake(560, equipHeight))
    layer:addChild(equipListBg)
    local list = self.equipList
    for i = 1, #list do
      local icon = ed.readequip.createIcon(list[i].id, 40)
      if icon then
        icon:setPosition(ccp(200 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
        layer:addChild(icon)
      end
      local name = ed.createttf(list[i].name, 20)
      name:setAnchorPoint(ccp(0, 0.5))
      name:setPosition(ccp(230 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
      ed.setLabelColor(name, ccc3(60, 60, 60))
	  if name:getContentSize().width > 195 then
    	name:setScale(195 / name:getContentSize().width)
	  end
      layer:addChild(name)
    end
    height = height + gap + equipHeight
  end
  if 0 < #self.heroList then
    local heroTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
    heroTitleBg:setPosition(ccp(440 + offsetX, 435 - height - heroTitleBg:getContentSize().height / 2))
    layer:addChild(heroTitleBg)
    local heroTitle = ed.createttf(T(LSTR("EQUIPDETAIL.HEROES_CAN_BE_EQUIPPED")), 24)
    ed.setLabelColor(heroTitle, ccc3(250, 205, 16))
    heroTitle:setPosition(ccp(heroTitleBg:getPosition()))
    layer:addChild(heroTitle)
    height = height + gap + heroTitleBg:getContentSize().height
    local heroHeight = 15 + 55 * math.ceil(#self.heroList / 2)
    local heroListBg = ed.createScale9Sprite("UI/alpha/HVGA/equip_detail_panel_bg.png", CCRectMake(10, 30, 400, 65))
    heroListBg:setAnchorPoint(ccp(0.5, 1))
    heroListBg:setPosition(ccp(440 + offsetX, 435 - height))
    if heroHeight < 60 then
      heroHeight = 60
    end
    heroListBg:setContentSize(CCSizeMake(560, heroHeight))
    layer:addChild(heroListBg)
    local list = self.heroList
    for i = 1, #list do
      local icon = ed.readhero.getIcon({
        id = list[i].id,
        rank = list[i].rank,
        length = 40
      })
      if icon then
        icon:setPosition(ccp(200 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
        layer:addChild(icon)
      end
      local name, w = ed.readhero.createHeroNameByInfo({
        name = list[i].name,
        rank = list[i].rank,
        nameColor = ccc3(60, 60, 60)
      })
      name:setPosition(ccp(230 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
	  if name:getContentSize().width > 195 then
    	name:setScale(195 / name:getContentSize().width)
	  end
      layer:addChild(name)
    end
    height = height + gap + heroHeight
  end
  local getTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
  getTitleBg:setPosition(ccp(440 + offsetX, 435 - height - getTitleBg:getContentSize().height / 2))
  layer:addChild(getTitleBg)
  local getTitle = ed.createttf(T(LSTR("EQUIPCRAFT.WAY_TO_GET")), 24)
  ed.setLabelColor(getTitle, ccc3(250, 205, 16))
  getTitle:setPosition(ccp(getTitleBg:getPosition()))
  layer:addChild(getTitle)
  height = height + gap + getTitleBg:getContentSize().height
  local getDetailBg = ed.createScale9Sprite("UI/alpha/HVGA/equip_detail_panel_bg.png", CCRectMake(10, 30, 400, 65))
  getDetailBg:setAnchorPoint(ccp(0.5, 1))
  getDetailBg:setPosition(ccp(440 + offsetX, 435 - height))
  layer:addChild(getDetailBg)
  local row = ed.getDataTable("equip")[id] or {}
  local stageTable = ed.getDataTable("Stage")
  local getWay = {}
  for i = 1, 3 do
    local gw = row["Drop " .. i]
    if gw and gw > 0 then --ray --Hide Stage > 13
      local chapter = stageTable[gw]["Chapter ID"]
      if chapter <= ed.GameConfig.MaxChapter then
        local name = stageTable[gw]["Stage Name"]
        local isElite = ed.stageType(gw) == "elite"
        if isElite then
          name = T(LSTR("EQUIPCRAFT.ELITE")) .. " ".. name
        end
        local res = ed.ui.stageselectres.getStageIcon(gw)
        table.insert(getWay, {
          id = gw,
          name = name,
          res = res
        })
      end
    end
  end
  for i = 1, #getWay do
    local way = getWay[i]
    local icon = ed.createSprite(way.res)
    icon:setPosition(ccp(200 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
    layer:addChild(icon)
    icon:setScale(60 / icon:getContentSize().width)
    local name = ed.createttf(way.name, 20)
    name:setAnchorPoint(ccp(0, 0.5))
    name:setPosition(ccp(230 + 260 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
    ed.setLabelColor(name, ccc3(60, 60, 60))
	if name:getContentSize().width > 195 then
		name:setScale(195 / name:getContentSize().width)
	end
    layer:addChild(name)
  end
  local getHeight = 55 * math.ceil(#getWay / 2)
  local getText = row["How To Get"]
  if getText then
    local label = ed.createNode({
      t = "Label",
      base = {text = getText, size = 18},
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(440 + offsetX, 435 - height - getHeight - 10)
      },
      config = {
        color = ccc3(238, 204, 119),
        dimension = CCSizeMake(240, 0),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, layer)
    getHeight = getHeight + 20 + label:getContentSize().height
  end
  if getHeight < 60 then
    getHeight = 60
  end
  getDetailBg:setContentSize(CCSizeMake(560, getHeight + 20))
  height = height + getHeight + 20
  self.draglist:initListHeight(height)
end
class.createDetail = createDetail
local function createIcon(self, id)
  if self.ui.icon then
    self.ui.icon:removeFromParentAndCleanup(true)
  end
  local icon = ed.readequip.createIcon(id)
  icon:setPosition(ccp(120 + offsetX, 360))
  self.ui.icon = icon
  self.layer:addChild(icon)
end
class.createIcon = createIcon
local function createList(self, id)
  local info = {
    cliprect = CCRectMake(0, 47, 740, 387),
    rect = CCRectMake(170 + offsetX, 47, 540, 387),
    container = self.layer,
    zorder = 10,
    priority = -135,
    bar = {
      bglen = 360,
      bgpos = ccp(157 + offsetX, 240)
    }
  }
  self.draglist = ed.draglist.create(info)
  self:createDetail()
end
class.createList = createList
local function create(id)
  local self = {}
  setmetatable(self, class.mt)
  self.id = id
  local baseScene = ed.getCurrentScene()
  self.baseScene = baseScene
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  mainLayer:setTouchEnabled(true)
  self.mainLayer = mainLayer
  local layer = CCLayer:create()
  self.layer = layer
  self.mainLayer:addChild(layer)
  local ui = {}
  self.ui = ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/equip_detail_bg.png"
      },
      layout = {
        position = ccp(440 + offsetX, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png",
        z = 11
      },
      layout = {
        position = ccp(700, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closePress",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {
        position = ccp(700, 410)
      },
      config = {visible = false}
    }
  }
  local readnode = ed.readnode.create(layer, ui)
  readnode:addNode(ui_info)
  self:createIcon(id)
  self:createList(id)
  self:show()
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -130, true)
  return self
end
class.create = create
local show = function(self)
  self.layer:setScale(0)
  self.mainLayer:setVisible(true)
  self.mainLayer:setTouchEnabled(true)
  local refresh = self:refreshClipRect()
  self:beginRefreshCliprect()
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:endRefreshCliprect()
      refresh()
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(s, func)
  self.layer:runAction(s)
end
class.show = show
local function destroy(self)
  lsr:report("closeWindow")
  self:beginRefreshCliprect()
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:endRefreshCliprect()
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.destroyHandler then
        self.destroyHandler()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  self.layer:runAction(s)
end
class.destroy = destroy
local isShow = function(self)
  return self.mainLayer:isVisible()
end
class.isShow = isShow

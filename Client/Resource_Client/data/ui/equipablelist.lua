local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipableList = class
local panel_width = 180
local hero_icon_len = 60
local destroy = function(self)
  if not self then
    return
  end
  if tolua.isnull(self.mainLayer) then
    return
  end
  self.mainLayer:removeFromParentAndCleanup(true)
end
class.destroy = destroy
local function doClickOutPanel(self)
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(self.panel, x, y) then
        self.isPressOut = true
      end
    elseif event == "ended" then
      local k = self.isPressOut
      self.isPressOut = nil
      if k and not ed.containsPoint(self.panel, x, y) then
        self:destroy()
      end
    end
  end
  return handler
end
class.doClickOutPanel = doClickOutPanel
local doMainLayerTouch = function(self)
  local function handler(event, x, y)
    xpcall(function()
      self:doClickOutPanel()(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function createNoListPrompt(self)
  if ed.getDataTable("equip")[self.id].Category == T(LSTR("EQUIP.FRAGMENT")) then
    local id = ed.readequip.getComposedID(self.id)
    if ed.itemType(id) == "hero" then
      return
    end
  end
  local label = ed.createttf(T(LSTR("EQUIPABLELIST.NO_AVAILABLE_HEROES")), 20)
  label:setAnchorPoint(ccp(0.5, 0))
  label:setPosition(ccp(self.pw / 2, self.ph))
  self.ph = self.ph + label:getContentSize().height + 5
  self.panel:addChild(label)
end
class.createNoListPrompt = createNoListPrompt
local function createHeroList(self)
  local info = {
    cliprect = CCRectMake(10, self.ph, self.pw - 20, 40),
    noshade = true,
    container = self.panel,
    priority = -136
  }
  self.draglist = ed.draglist.create(info)
  local list = self.hList
  for i = 1, #list do
    local icon = ed.readhero.createIcon({
      id = list[i]._tid,
      rank = list[i]._rank,
      length = 40
    })
    icon.icon:setPosition(ccp(30 + 42 * (i - 1), self.ph + 20))
    self.draglist.listLayer:addChild(icon.icon)
    icon:showAddTag(self.id)
  end
  self.draglist:initListWidth(42 * #list)
  self.ph = self.ph + 40
end
class.createHeroList = createHeroList
local function createEquipName(self)
  local id = self.id
  local row = ed.getDataTable("equip")[id]
  local name = row.Name
  local category = row.Category
  if category == T(LSTR("EQUIP.FRAGMENT")) then
    local numberBg = ed.createSprite("UI/alpha/HVGA/tip_detail_bg.png")
    numberBg:setAnchorPoint(ccp(0.5, 0))
    numberBg:setPosition(ccp(self.pw / 2, self.ph))
    self.panel:addChild(numberBg)
    local needAmount
    for k, v in pairs(ed.getDataTable("fragment")) do
      if v["Fragment ID"] == id then
        needAmount = v["Fragment Count"]
        break
      end
    end
    local numberLabel = ed.createttf(string.format("%d/%d", ed.player.equip_qunty[id] or 0, needAmount or 0), 18)
    numberLabel:setAnchorPoint(ccp(0.5, 0))
    numberLabel:setPosition(ccp(self.pw / 2, self.ph + 2))
    self.panel:addChild(numberLabel)
    self.ph = self.ph + numberBg:getContentSize().height + 5
    ed.setLabelColor(numberLabel, ccc3(166, 235, 31))
    local label = ed.createttf(name, 18)
    label:setAnchorPoint(ccp(0.5, 0))
    label:setPosition(ccp(self.pw / 2, self.ph))
    self.panel:addChild(label)
    self.ph = self.ph + label:getContentSize().height + 10
  else
    local label = ed.createttf(name, 18)
    label:setAnchorPoint(ccp(0.5, 0))
    self.ph = self.ph + 10
    label:setPosition(ccp(self.pw / 2, self.ph))
    self.panel:addChild(label)
    self.ph = self.ph + label:getContentSize().height + 10
  end
end
class.createEquipName = createEquipName
local function createHeroListPanel(self)
  local panel = ed.createScale9Sprite("UI/alpha/HVGA/craft_promt_bg.png", CCRectMake(15, 15, 114, 15))
  panel:setAnchorPoint(ccp(0.5, 0))
  self.mainLayer:addChild(panel)
  self.panel = panel
  self.pw, self.ph = panel_width, 25
  self.hList = ed.readequip.getEquipableHeroList(self.id) or {}
  if #self.hList == 0 then
    self:createNoListPrompt()
  else
    self:createHeroList()
  end
  self:createEquipName()
  self.panel:setContentSize(CCSizeMake(self.pw, self.ph))
end
class.createHeroListPanel = createHeroListPanel
local function createHeroList(self)
  if #self.hList == 0 then
  else
    local len = hero_icon_len
    local hlTitle = ed.createttf(T(LSTR("EQUIPABLELIST.AVAILABLE_HEROES_")), 16)
    hlTitle:setAnchorPoint(ccp(0, 0.5))
    hlTitle:setPosition(ccp(20, len + 30))
    self.panel:addChild(hlTitle)
    for i = 1, math.min(#self.hList, 3) do
      local icon = ed.readhero.createIcon({
        id = self.hList[i]._tid,
        rank = self.hList[i]._rank,
        length = len
      })
      icon.icon:setAnchorPoint(ccp(0, 0))
      icon.icon:setPosition(ccp(20 + (len + 2) * (i - 1), 15))
      self.panel:addChild(icon.icon)
      icon:showAddTag(self.id)
    end
    if #self.hList > 3 then
      local dots = ed.createttf("···", 20)
      dots:setPosition(ccp(20 + (len + 2) * 3 + 10, 15 + len / 2))
      self.panel:addChild(dots)
    end
  end
end
class.createHeroList = createHeroList
local function create(id, pos, addition)
  local self = {}
  setmetatable(self, class.mt)
  addition = addition or {}
  local ow = addition.ow
  self.id = id
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  self.hList = ed.readequip.getEquipableHeroList(self.id) or {}
  if type(id) == "string" then
    local panel = ed.readequip.getDetailCard(id)
    panel:setPosition(pos)
    self.panel = panel
    self.mainLayer:addChild(panel)
  elseif type(id) == "number" then
    if ed.itemType(id) == "hero" then
      local panel = ed.readequip.getDetailCard(id, {level = 1, isUnit = true})
      panel:setPosition(pos)
      self.panel = panel
      self.mainLayer:addChild(panel)
    elseif ed.itemType(id) == "equip" then
      local oh = 40
      if #self.hList > 0 then
        oh = hero_icon_len + 20
      else
        oh = 0
      end
      local category = ed.getDataTable("equip")[id].Category
      local isEquip
      if ed.isElementInTable(category, {
        T(LSTR("EQUIP.SYNTHETICS")),
        T(LSTR("EQUIP.PARTS"))
      }) then
        isEquip = true
      else
        oh = 0
      end
      local panel = ed.readequip.getDetailCard(id, nil, {
        ow = ow or 280,
        oh = oh
      })
      panel:setPosition(pos)
      self.panel = panel
      if isEquip then
        self:createHeroList()
      end
      self.mainLayer:addChild(self.panel)
    end
  end
  return self
end
class.create = create

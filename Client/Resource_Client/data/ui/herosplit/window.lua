local base = ed.ui.popwindow
local class = newclass(base.mt)
local split = ed.ui.herosplit
split.splitwindow = class
class.stone_icon_pos = ed.DGccp(105, 205)
local refreshSelectButton = function(self)
  local ui = self.ui
  if self.hid then
    ui.select_hero_button:setVisible(true)
    ui.select_hero_button_light:setVisible(false)
  else
    ui.select_hero_button:setVisible(false)
    ui.select_hero_button_light:setVisible(true)
  end
  if not self.hid then
    ui.select_stone_button_container:setVisible(false)
  else
    ui.select_stone_button_container:setVisible(true)
    if self.selectStone then
      ui.select_stone_button:setVisible(true)
      ui.select_stone_button_light:setVisible(false)
    else
      ui.select_stone_button:setVisible(false)
      ui.select_stone_button_light:setVisible(true)
    end
  end
end
class.refreshSelectButton = refreshSelectButton
local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy({
        skipAnim = true,
        callback = self.callback
      })
    end
  })
  self:btRegisterButtonClick({
    button = {
      ui.select_hero_button,
      ui.select_hero_button_light
    },
    press = {
      ui.select_hero_button_press,
      ui.select_hero_button_light_press
    },
    key = "select_hero_button",
    clickHandler = function()
      self:doSelectHero()
    end
  })
  self:btRegisterButtonClick({
    button = ui.explain_button,
    press = ui.explain_button_press,
    key = "explain_button",
    clickHandler = function()
      split.popExplain()
    end
  })
  self:btRegisterButtonClick({
    button = {
      ui.select_stone_button,
      ui.select_stone_button_light
    },
    press = {
      ui.select_stone_button_press,
      ui.select_stone_button_light_press
    },
    key = "select_stone_button",
    clickHandler = function()
      self:doSelectStone()
    end
  })
  self:btRegisterButtonClick({
    button = ui.split_button,
    press = ui.split_button_press,
    key = "split_button",
    clickHandler = function()
      self:firstConfirm()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local firstConfirm = function(self)
  if not self.hid then
    ed.showToast(T(LSTR("EQUIPSTRENGTHEN.PLEASE_SELECT_HERO")))
    return
  end
  if not self.selectStone then
    ed.showToast(T(LSTR("window.1.10.1.002")))
    return
  end
  local name = ed.getDataTable("Unit")[self.hid]["Display Name"]
  ed.popConfirmDialog({
    text = T(LSTR("window.1.10.1.003"), name),
    rightHandler = function()
      self:secondConfirm()
    end
  })
end
class.firstConfirm = firstConfirm
local function secondConfirm(self)
  split.popConfirm(self.hid, self.selectStone.id, function(result)
    if result then
      ed.showToast(T(LSTR("window.1.10.1.004")))
      self:resetHero()
    end
  end)
end
class.secondConfirm = secondConfirm
local function doSelectHero(self)
  local heroes = split.getSplitableHeroes()
  if #heroes == 0 then
    ed.showToast(T(LSTR("window.1.10.1.005")))
  else
    ed.ui.selectwindow.pop({
      name = "hero",
      signName = "herosplit",
      withState = true,
      explain = T(LSTR("window.1.10.1.006")),
      callback = function(hid)
        self:setSplitHero(hid)
      end,
      heroList = heroes
    })
  end
end
class.doSelectHero = doSelectHero
local function doSelectStone(self)
  local function handler(list)
    if list then
      if #list.stones > 0 then
        self:popStoneWindow(list)
      else
        ed.showToast(T(LSTR("window.1.10.1.007")))
        self:setSplitStone(nil, list)
      end
    end
  end
  local list = split.getSplitReturn(self.hid, function(list)
    handler(list)
  end)
  handler(list)
end
class.doSelectStone = doSelectStone
local initItemHandler = function(self)
  local handler = function(param)
    local container = param.container
    local key = param.key
    if key == "hero" then
      local initStar = ed.getDataTable("Unit")[param.id]["Initial Stars"]
      local icon = ed.readhero.createIcon({
        id = param.id,
        stars = initStar,
        length = 65,
        level = 1
      }).icon
      icon:setPosition(ed.getCenterPos(icon))
      container:addChild(icon)
      return {icon = icon}
    elseif key == "item" then
      local icon = ed.readequip.createIconWithAmount(param.id, nil, param.amount)
      icon:setPosition(ed.getCenterPos(icon))
      container:addChild(icon)
      return {icon = icon}
    end
  end
  return handler
end
class.initItemHandler = initItemHandler
local pressListItem = function(self)
  local function handler(x, y)
    local list = self.itemList
    for i, v in ipairs(list) do
      local id = v.param.id
      local icon = v.ui.icon
      local parent = icon:getParent()
      if ed.containsPoint(icon, x, y, parent) then
        local panel = ed.readequip.getDetailCard(id)
        local px, py = icon:getPosition()
        local pos = parent:convertToWorldSpace(ccp(px, py))
        panel:setPosition(ccpAdd(pos, ccp(0, 40)))
        self.mainLayer:addChild(panel, 10)
        self.ui.detail_card = panel
        return i
      end
    end
  end
  return handler
end
class.pressListItem = pressListItem
local cancelPressListItem = function(self)
  local function handler(x, y, id)
    local panel = self.ui.detail_card
    if not tolua.isnull(panel) then
      panel:removeFromParentAndCleanup(true)
    end
  end
  return handler
end
class.cancelPressListItem = cancelPressListItem
local createListLayer = function(self, list)
  local info = {
    cliprect = ed.DGRectMake(232, 95, 632, 208),
    noshade = true,
    zorder = 5,
    container = self.ui.return_container,
    priority = self.mainTouchPriority - 5,
    direction = "v",
    pageSize = CCSizeMake(6, 1),
    oriPosition = ed.DGccp(240, 200),
    itemSize = ed.DGSizeMake(102, 108),
    initHandler = self:initItemHandler(),
    useBar = true,
    barPosition = "left",
    barLenOffset = -10,
    barPosOffset = ccp(0, 0),
    barThick = 3,
    heightOffset = 0,
    doPressIn = self:pressListItem(),
    cancelPressIn = self:cancelPressListItem(),
    doClickIn = self:cancelPressListItem(),
    cancelClickIn = self:cancelPressListItem()
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollView
  scrollView:push({
    key = "hero",
    id = self.hid
  })
  if self.selectStone.id then
    scrollView:push({
      key = "item",
      id = self.selectStone.id,
      amount = self.selectStone.amount
    })
  end
  for i, v in ipairs(list.items) do
    scrollView:push({
      key = "item",
      id = v.id,
      amount = v.amount
    })
  end
  self.itemList = scrollView.items
end
class.createListLayer = createListLayer
local popStoneWindow = function(self, list)
  ed.ui.selectwindow.pop({
    name = "item",
    signName = "herosplit",
    explain = T(LSTR("window.1.10.1.008")),
    callback = function(item)
      self:setSplitStone(item, list)
    end,
    itemList = list.stones
  })
end
class.popStoneWindow = popStoneWindow
local resetSplitDetail = function(self)
  local ui = self.ui
  ui.detail_container:setVisible(false)
  if not tolua.isnull(ui.return_container) then
    ui.return_container:removeFromParentAndCleanup(true)
  end
  self.selectStone = nil
end
class.resetSplitDetail = resetSplitDetail
local function setSplitStone(self, item, list)
  if not self.hid then
    ed.showToast(T(LSTR("window.1.10.1.009")))
    return
  end
  self:resetSplitDetail()
  local ui = self.ui
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  ui.frame:addChild(container)
  ui.return_container = container
  self.selectStone = item or {}
  ui.detail_container:setVisible(true)
  if item then
    ui.stone_icon = ed.readequip.createIconWithAmount(item.id, nil, item.amount)
    ui.stone_icon:setPosition(class.stone_icon_pos)
    container:addChild(ui.stone_icon)
  end
  self:btRegisterButtonClick({
    button = ui.stone_icon,
    pressScale = 0.95,
    key = "stone_icon",
    clickHandler = function()
      self:doSelectStone()
    end,
    force = true
  })
  local return_hero_icon = ed.readhero.createIconByID(self.hid, {len = 65, state = "idle"}).icon
  return_hero_icon:setPosition(ed.DGccp(300, 425))
  container:addChild(return_hero_icon)
  local sid = ed.readhero.getStoneid(self.hid)
  local sAmount = ed.player.equip_qunty[sid] or 0
  if sAmount > 0 then
    local return_stone_icon = ed.readequip.createIconWithAmount(sid, nil, sAmount)
    return_stone_icon:setPosition(ed.DGccp(400, 425))
    container:addChild(return_stone_icon)
  end
  local param = {
    t = "HorizontalNode",
    base = {},
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(248, 322)
    },
    ui = {
      {
        t = "Sprite",
        base = {
          res = "UI/alpha/HVGA/task_gold_icon_2.png"
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          text = T("x%d", list.gold or 0),
          size = 20
        },
        config = {
          color = ccc3(194, 78, 0)
        }
      },
      {
        t = "Label",
        base = {
          text = T(LSTR("window.1.10.1.010")),
          size = 20,
          offset = 20
        },
        config = {
          color = ccc3(135, 58, 6)
        }
      },
      {
        t = "Label",
        base = {
          text = T("x%d", list.skillPoint or 0),
          size = 20,
          offset = 5
        },
        config = {
          color = ccc3(135, 58, 6)
        }
      }
    }
  }
  local common_return = ed.readnode.getFeralNode(param)
  container:addChild(common_return)
  self:createListLayer(list)
  self:refreshSelectButton()
end
class.setSplitStone = setSplitStone
local resetHero = function(self)
  local ui = self.ui
  if not tolua.isnull(ui.head_container) then
    ui.head_container:removeFromParentAndCleanup(true)
  end
  ui.select_stone_button_container:setVisible(false)
  self:createUnknownHero()
  self.hid = nil
  self.selectStone = nil
  self:resetSplitDetail()
  ui.select_stone_button_container:setVisible(false)
  ui.convert_arrow:setVisible(false)
  self:removeUnknownStone()
  self:refreshSelectButton()
end
class.resetHero = resetHero
local setSplitHero = function(self, hid)
  local ui = self.ui
  self:resetHero()
  self.hid = hid
  self:removeUnknownHero()
  self:createUnknownStone()
  local container = CCSprite:create()
  ui.frame:addChild(container)
  ui.head_container = container
  local head = ed.readhero.createIconByID(hid, {state = "idle"}).icon
  head:setPosition(ed.DGccp(110, 445))
  container:addChild(head)
  local name = ed.readhero.createHeroName(hid)
  name:setAnchorPoint(ccp(0.5, 0.5))
  name:setPosition(ed.DGccp(110, 540))
  container:addChild(name)
  ui.select_stone_button_container:setVisible(true)
  self:btRegisterButtonClick({
    button = head,
    pressScale = 0.95,
    key = "head_icon",
    clickHandler = function()
      self:doSelectHero()
    end,
    force = true
  })
  self:refreshSelectButton()
end
class.setSplitHero = setSplitHero
local createUnknownHero = function(self)
  self:removeUnknownHero()
  local ui = self.ui
  local head = ed.readhero.createIcon().icon
  head:setPosition(ed.DGccp(110, 445))
  ui.frame:addChild(head)
  ui.unkonwn_head = head
  self:btRegisterButtonClick({
    button = ui.unkonwn_head,
    pressScale = 0.95,
    key = "head_icon",
    clickHandler = function()
      self:doSelectHero()
    end,
    force = true
  })
end
class.createUnknownHero = createUnknownHero
local removeUnknownHero = function(self)
  if not tolua.isnull(self.ui.unkonwn_head) then
    self.ui.unkonwn_head:removeFromParentAndCleanup(true)
  end
end
class.removeUnknownHero = removeUnknownHero
local function createUnknownStone(self)
  self:removeUnknownStone()
  local ui = self.ui
  ui.convert_arrow:setVisible(true)
  ui.unknown_stone = ed.readequip.getUnknownHeroStone()
  ui.unknown_stone:setPosition(class.stone_icon_pos)
  ui.frame:addChild(ui.unknown_stone)
  self:btRegisterButtonClick({
    button = ui.unknown_stone,
    pressScale = 0.95,
    key = "stone_icon",
    clickHandler = function()
      self:doSelectStone()
    end,
    force = true
  })
end
class.createUnknownStone = createUnknownStone
local removeUnknownStone = function(self)
  if not tolua.isnull(self.ui.unknown_stone) then
    self.ui.unknown_stone:removeFromParentAndCleanup(true)
  end
end
class.removeUnknownStone = removeUnknownStone
local function create(callback)
  local self = base.create("herosplitwindow")
  setmetatable(self, class.mt)
  self.callback = callback
  local container
  container, self.ui = ed.editorui(ed.uieditor.herosplit)
  self:setContainer(container)
  self:createUnknownHero()
  self.ui.detail_container:setVisible(false)
  self:refreshSelectButton()
  self:registerTouchHandler()
  self:show({skipAnim = true})
  return self
end
class.create = create
local function pop(callback)
  local window = create(callback)
  window:popWindow(200)
end
class.pop = pop

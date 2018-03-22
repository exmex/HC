local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
ed.ui.equipstrengthen = class
setmetatable(class, base.mt)
local res = ed.ui.baseres
local lsr = ed.ui.equipstrengthenlsr.create()
local function createnpcTalk(self, text)
  if tolua.isnull(self.talkContainer) then
    local container = CCSprite:create()
    self.talkContainer = container
    container:setCascadeOpacityEnabled(true)
    if not tolua.isnull(self.container) then
      self.container:addChild(container, 50)
    end
    local ui = {}
    local frame = ed.createScale9Sprite("UI/alpha/HVGA/skill_talk_bg_down.png", CCRectMake(30, 30, 145, 20))
    frame:setContentSize(CCSizeMake(224, 76))
    frame:setAnchorPoint(ccp(0.5, 1))
    frame:setPosition(ccp(645, 305))
    container:addChild(frame)
    ui.frame = frame
    local label = ed.createttf("", 18)
    label:setAnchorPoint(ccp(0.5, 1))
    label:setPosition(ccp(645, 282))
    container:addChild(label)
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    ed.setLabelDimensions(label, CCSizeMake(200, 0))
    ui.label = label
    self.talkui = ui
  end
  local ui = self.talkui
  local frame = ui.frame
  local label = ui.label
  ed.setString(label, text)
  local height = label:getContentSize().height + 42
  height = math.max(60, height)
  frame:setContentSize(CCSizeMake(224, height))
end
class.createnpcTalk = createnpcTalk
local doTalk = function(self, text)
  self:createnpcTalk(text)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(255)
end
class.doTalk = doTalk
local doSpeak = function(self, text)
  self:createnpcTalk(text)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(255)
  local delay = CCDelayTime:create(1)
  local fade = CCFadeOut:create(0.2)
  local s = CCSequence:createWithTwoActions(delay, fade)
  container:runAction(s)
end
class.doSpeak = doSpeak
local hideTalk = function(self)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(0)
end
class.hideTalk = hideTalk
local function doStrenReply(self)
  local slot = self.slot
  local function handler(result)
    if result then
      lsr:report("enhanceSuccess")
      self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.CONGRATULATIONS_ENCHANTED_SUCCESSFULLY")))
    else
      self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.UNFORTUNATELY_ENCHANTED_FAILED")))
    end
    self:initmtList()
    self:initStrenButton()
    self:initBar()
    self:initEquipAtt()
    self:initHeroEquip()
  end
  return handler
end
class.doStrenReply = doStrenReply
local initmtList = function(self)
  if self:checkMaxLevel(self.slot) then
    self:doShowMaxLevel()
  else
    self:refreshmtList()
    self:refreshmtListPos()
    self:initMaterialLayer()
  end
  self.addmtInfo = {}
end
class.initmtList = initmtList
local asyncLoadmt = function(self)
  local index = 1
  local eof
  local function handler()
    eof = self:createmt(index)
    index = index + 1
    if eof then
      self:removeUpdateHandler("asyncLoadmt")
    end
  end
  return handler
end
class.asyncLoadmt = asyncLoadmt
local function createmt(self, index)
  local list = self.allmt
  local amount = #list
  local ox, oy = 140, 155
  local dx, dy = 80, 75
  if not self.mts then
    self.mts = {}
  end
  local bi = 6 * (index - 1) + 1
  local ei = math.min(6 * index, amount)
  if amount < bi then
    return true
  end
  for i = bi, ei do
    local icon = ed.readequip.createIcon(list[i].id)
    icon:setPosition(ccp(ox + dx * (i - bi), oy - dy * (index - 1)))
    self.draglist:addItem(icon)
    local ehcBg
    if list[i].category == T(LSTR("EQUIP.FRAGMENT")) then
      ehcBg = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_fragment_bg.png")
    else
      ehcBg = ed.createSprite("UI/alpha/HVGA/skill_material_att_bg.png")
    end
    ehcBg:setPosition(ccp(36, 18))
    icon:addChild(ehcBg, -1)
    local aLabel = ed.createttf(list[i].amount, 18)
    aLabel:setPosition(ccp(36, 20))
    icon:addChild(aLabel)
    table.insert(self.mts, {
      icon = icon,
      amountLabel = aLabel,
      info = list[i],
      add = 0
    })
    if i == 1 then
      ed.teach("EEclickMaterial", icon, self.draglist.listLayer)
      self.EEclickMaterialid = i
    end
  end
end
class.createmt = createmt
local refreshmtList = function(self)
  self.moneyCost = nil
  for i = 1, #(self.mts or {}) do
    local info = self.mts[i]
    local amount = info.info.amount - info.add
    self.mts[i].info.amount = amount
    self.mts[i].add = 0
    if amount <= 0 then
      info.icon:removeFromParentAndCleanup(true)
      table.remove(self.mts, i)
      return self:refreshmtList()
    end
  end
end
class.refreshmtList = refreshmtList
local getmtPos = function(self, index)
  local ox, oy = 140, 155
  local dx, dy = 80, 75
  local x = (index - 1) % 6
  local y = math.floor((index - 1) / 6)
  return ccp(ox + x * dx, oy - y * dy)
end
class.getmtPos = getmtPos
local refreshmtListPos = function(self)
  for i = 1, #(self.mts or {}) do
    local icon = self.mts[i].icon
    local pos = self:getmtPos(i)
    if not tolua.isnull(icon) then
      icon:setPosition(pos)
    end
  end
end
class.refreshmtListPos = refreshmtListPos
local function createmtList(self)
  local elist = ed.readequip.getMaterialList()
  self.allmt = elist
  local amount = #elist
  self.mts = {}
  local plies = math.ceil(amount / 6)
  local height = 75 * plies
  self.draglist:initListHeight(height)
  self:registerUpdateHandler("asyncLoadmt", self:asyncLoadmt())
end
class.createmtList = createmtList
local function createMinusIcon(self, id)
  local mt = (self.mts or {})[id]
  if tolua.isnull(mt.minus) then
    local minus = ed.createSprite("UI/alpha/HVGA/equipupgrade/skill_material_delete.png")
    local minusPress = ed.createSprite("UI/alpha/HVGA/equipupgrade/skill_material_delete_down.png")
    minusPress:setAnchorPoint(ccp(0, 0))
    minusPress:setPosition(ccp(0, 0))
    minus:addChild(minusPress)
    minusPress:setVisible(false)
    minus:setPosition(ccp(68, 65))
    mt.icon:addChild(minus)
    self.mts[id].minus = minus
    self.mts[id].minusPress = minusPress
  end
end
class.createMinusIcon = createMinusIcon
local removeMinusIcon = function(self, id)
  local mt = (self.mts or {})[id]
  if not tolua.isnull(mt.minus) then
    mt.minus:removeFromParentAndCleanup(true)
  end
end
class.removeMinusIcon = removeMinusIcon
local function playAddmtAnim(self, id)
  local index = id
  local mt = (self.mts or {})[id]
  local id = mt.info.id
  local icon = mt.icon
  local ti = ed.readequip.createIcon(id)
  local pos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  ti:setPosition(pos)
  self.container:addChild(ti)
  local epos = ccp(400, 212)
  local array = CCArray:create()
  local m = CCMoveTo:create(0.2, epos)
  m = CCEaseSineIn:create(m)
  local scale = CCScaleTo:create(0.2, 0.5)
  local spawn = CCSpawn:createWithTwoActions(m, scale)
  local fade = CCFadeOut:create(0.2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      ti:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  array:addObject(spawn)
  array:addObject(fade)
  array:addObject(func)
  local s = CCSequence:create(array)
  ti:runAction(s)
end
class.playAddmtAnim = playAddmtAnim
local function playAddExpAnim(self, id)
  local mt = (self.mts or {})[id]
  local bpos = ccp(380, 235)
  local ehc = mt.info.ehc
  local label = ed.createttf("+" .. ehc, 24)
  ed.setLabelColor(label, ccc3(101, 207, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 1)
  label:setPosition(bpos)
  self.container:addChild(label, 10)
  label:setOpacity(0)
  local a = CCArray:create()
  local fi = CCFadeIn:create(0.2)
  local d = CCDelayTime:create(0.2)
  local m = CCMoveBy:create(0.5, ccp(0, 50))
  m = CCEaseSineOut:create(m)
  local fo = CCFadeOut:create(0.5)
  local spawn = CCSpawn:createWithTwoActions(m, fo)
  local f = CCCallFunc:create(function()
    xpcall(function()
      label:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  a:addObject(fi)
  a:addObject(d)
  a:addObject(spawn)
  a:addObject(f)
  local s = CCSequence:create(a)
  label:runAction(s)
end
class.playAddExpAnim = playAddExpAnim
local function addMaterial(self, id)
  if self:checkMaxLevel(self.slot, self.targetExp) then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.EXPERIENCE_MAXED_OUT")))
    return
  end
  local mt = (self.mts or {})[id]
  local add = mt.add
  local amount = mt.info.amount
  if add == amount then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.THIS_MATERIAL_HAS_BEEN_USED_UP")))
    return
  end
  add = add + 1
  self.mts[id].add = add
  self.addmtInfo = self.addmtInfo or {}
  self.addmtInfo[mt.info.id] = (self.addmtInfo[mt.info.id] or 0) + 1
  ed.setString(mt.amountLabel, string.format("%d/%d", add, amount))
  self:createMinusIcon(id)
  self:playAddmtAnim(id)
  self:playAddExpAnim(id)
  self:addExp(mt.info.ehc)
  self.addmtInfo = self.addmtInfo or {}
end
class.addMaterial = addMaterial
local function deleteMaterial(self, id)
  local mt = self.mts[id]
  local add = mt.add
  if add == 0 then
    return
  end
  add = add - 1
  self.addmtInfo[mt.info.id] = self.addmtInfo[mt.info.id] - 1
  self.mts[id].add = add
  local amount = mt.info.amount
  ed.setString(mt.amountLabel, string.format("%d/%d", add, amount))
  self:addExp(-mt.info.ehc)
  if add == 0 then
    self:removeMinusIcon(id)
  end
end
class.deleteMaterial = deleteMaterial
local function doPressInList(self)
  local function handler(x, y)
    local mt = self.mts
    for i = 1, #(mt or {}) do
      local icon = mt[i].icon
      local minus = mt[i].minus
      local press = mt[i].minusPress
      if not tolua.isnull(minus) and ed.isPointInRect(CCRectMake(0, 0, 50, 40), x, y, minus) then
        press:setVisible(true)
        return -i
      end
      if ed.containsPoint(icon, x, y) then
        icon:setScale(0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressInList = doPressInList
local cancelPressInList = function(self)
  local function handler(x, y, id)
    local mt = self.mts or {}
    local icon
    if id > 0 then
      icon = mt[id].icon
      icon:setScale(1)
    else
      icon = mt[-id].minusPress
      icon:setVisible(false)
    end
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local function doClickInList(self)
  local function handler(x, y, id)
    local mt = self.mts or {}
    if self.EEclickMaterialid == id then
      ed.endTeach("EEclickMaterial")
      ed.teach("EEclickEnhance", self.strenui.stren, self.container)
    end
    if id > 0 then
      lsr:report("clickMaterial")
      local icon = mt[id].icon
      icon:setScale(1)
      if ed.containsPoint(icon, x, y) then
        self:addMaterial(id)
      end
    else
      local minus = mt[-id].minus
      local minusPress = mt[-id].minusPress
      minusPress:setVisible(false)
      if ed.isPointInRect(CCRectMake(0, 0, 50, 40), x, y, minus) then
        self:deleteMaterial(-id)
      end
    end
  end
  return handler
end
class.doClickInList = doClickInList
local cancelClickInList = function(self)
  local function handler(x, y, id)
    local mt = self.mts or {}
    local icon
    if id > 0 then
      icon = mt[id].icon
      icon:setScale(1)
    else
      icon = mt[-id].minusPress
      icon:setVisible(false)
    end
  end
  return handler
end
class.cancelClickInList = cancelClickInList
local function createmtListLayer(self)
  local info = {
    cliprect = CCRectMake(98, 42, 500, 155),
    noshade = true,
    container = self.mtContainer,
    bar = {
      bglen = 145,
      bgpos = ccp(88, 122)
    },
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:setLayerPos(ccp(0, -100))
  local m = CCMoveTo:create(0.2, ccp(0, 0))
  m = CCEaseSineOut:create(m)
  self.draglist:runLayerAction(m)
end
class.createmtListLayer = createmtListLayer
local initMaterialData = function(self)
  self.moneyCost = nil
  for i = 1, #(self.mts or {}) do
    self.mts[i].add = 0
  end
  self.addmtInfo = {}
end
class.initMaterialData = initMaterialData
local function initMaterialLayer(self)
  if not self.draglist then
    return
  end
  if self.draglist:checknull() then
    return
  end
  local ll = self.draglist:getList()
  ll:stopAllActions()
  ll:setPosition(ccp(0, 0))
  self:initMaterialData()
  for i = 1, #(self.mts or {}) do
    local minus = self.mts[i].minus
    if not tolua.isnull(minus) then
      minus:removeFromParentAndCleanup(true)
    end
    ed.setString(self.mts[i].amountLabel, self.mts[i].info.amount)
  end
end
class.initMaterialLayer = initMaterialLayer
local function createMaterialLayer(self)
  ed.endTeach("EEopenMaterial")
  self.ui.material_label:setVisible(false)
  if not tolua.isnull(self.mtContainer) then
    self:initMaterialLayer()
    return
  end
  local container = CCLayer:create()
  self.mtContainer = container
  self.container:addChild(container)
  self.mtContainer:setClipRect(CCRectMake(0, 42, 800, 155))
  self:createmtListLayer()
  self:createmtList()
end
class.createMaterialLayer = createMaterialLayer
local removeMaterialLayer = function(self)
  if not tolua.isnull(self.mtContainer) then
    self.mtContainer:removeFromParentAndCleanup(true)
    self.mtContainer = nil
  end
end
class.removeMaterialLayer = removeMaterialLayer
local function initStrenButton(self)
  local ui = self.strenui
  if not tolua.isnull(ui.no_cost) then
    ui.no_cost:setVisible(true)
    ui.money_icon:setVisible(false)
    ui.money:setVisible(false)
  end
  self.moneyCost = 0
  self.rmbCost = self:getFastStrenCost(self.slot)
  ed.setString(ui.rmb, self.rmbCost)
end
class.initStrenButton = initStrenButton
local function refreshStrenCostHandler(self)
  local function handler()
    local ui = self.strenui
    if self.moneyCost > ed.player._money then
      ed.setLabelColor(ui.money, ccc3(255, 0, 0))
    else
      ed.setLabelColor(ui.money, ccc3(255, 255, 255))
    end
  end
  return handler
end
class.refreshStrenCostHandler = refreshStrenCostHandler
local function refreshStrenCostCallback(self)
  local function handler()
    local ui = self.strenui
    if self.moneyCost > ed.player._money then
      self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.IT_SEEMS_IT_IS_NOT_ENOUGH")))
    else
      self:hideTalk()
    end
  end
  return handler
end
class.refreshStrenCostCallback = refreshStrenCostCallback
local function refreshStrenCost(self)
  local ui = self.strenui
  local hasmt = false
  for k, v in pairs(self.addmtInfo) do
    if 0 < (v or 0) then
      hasmt = true
    end
  end
  local target = math.max(math.min(self.targetExp, self:getTotalExp(self.slot)), 0)
  local ori = self:getItemExp(self.slot)
  local cost = self:getUnitMoney(self.slot) * (target - ori)
  ed.setString(self.strenui.money, cost)
  self.moneyCost = cost
  if not hasmt then
    ui.no_cost:setVisible(true)
    ui.money_icon:setVisible(false)
    ui.money:setVisible(false)
  else
    ui.no_cost:setVisible(false)
    ui.money_icon:setVisible(true)
    ui.money:setVisible(true)
    if cost > ed.player._money then
      ed.setLabelColor(ui.money, ccc3(255, 0, 0))
      self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.YOUR_MONEY_IS_NOT_ENOUGH")))
    else
      ed.setLabelColor(ui.money, ccc3(255, 255, 255))
      self:hideTalk()
    end
  end
end
class.refreshStrenCost = refreshStrenCost
local function dombTouch(self)
  local isPress
  local function handler(event, x, y)
    local button = self.ui.material_bg
    local label = self.ui.material_label
    local slot = self.slot
    if not slot then
      return
    end
    if self:checkMaxLevel(slot) then
      return
    end
    if not self.ui.material_label:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        --ed.setLabelStroke(label, ccc3(251, 214, 153), 2)
        button:setScale(0.99)
      end
    elseif event == "ended" then
      if isPress then
        button:setScale(1)
        --ed.setLabelStroke(label, ccc3(207, 195, 175), 2)
        if ed.containsPoint(button, x, y) then
          lsr:report("createMaterialList")
          self:createMaterialLayer()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.dombTouch = dombTouch
local function doClickStren(self)
  ed.endTeach("EEclickEnhance")
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.THIS_ITEM_CAN_NOT_BE_ENCHANTED_ANYMORE")))
    return
  end
  if (self.moneyCost or 0) <= 0 then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.NO_MATERIAL_ADDED")))
    return
  end
  if ed.player._money < (self.moneyCost or 0) then
    ed.showHandyDialog("useMidas", {
      callback = self:refreshStrenCostCallback(),
      refreshHandler = self:refreshStrenCostHandler()
    })
    return
  end
  local mt = {}
  local mts = {}
  for k, v in pairs(self.addmtInfo) do
    local m = ed.packItem(k, v)
    table.insert(mt, m)
    table.insert(mts, {id = k, amount = v})
  end
  ed.netdata.equipUpgrade = {
    type = "money",
    cost = self.moneyCost,
    mts = mts,
    hid = self.hid,
    slot = self.slot
  }
  ed.netreply.equipUpgrade = self:doStrenReply()
  local msg = ed.upmsg.hero_equip_upgrade()
  msg._op_type = 1
  msg._heroid = self.hid
  msg._slot = self.slot
  msg._materials = mt
  ed.send(msg, "hero_equip_upgrade")
end
class.doClickStren = doClickStren
local function doStrenTouch(self)
  local isPress
  local function handler(event, x, y)
    if not self.strenui then
      return
    end
    if tolua.isnull(self.strenui.stren) then
      return
    end
    local button = self.strenui.stren
    local press = self.strenui.stren_press
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickEnhance")
          self:doClickStren()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doStrenTouch = doStrenTouch
local function upFastStren(self)
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
    return
  end
  if ed.player._rmb < (self.rmbCost or 0) then
    ed.showHandyDialog("toRecharge")
    return
  end
  ed.netdata.equipUpgrade = {
    type = "rmb",
    cost = self.rmbCost,
    hid = self.hid,
    slot = self.slot
  }
  ed.netreply.equipUpgrade = self:doStrenReply()
  local msg = ed.upmsg.hero_equip_upgrade()
  msg._op_type = 2
  msg._heroid = self.hid
  msg._slot = self.slot
  ed.send(msg, "hero_equip_upgrade")
end
class.upFastStren = upFastStren
local function doClickFastStren(self)
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.THIS_ITEM_CAN_NOT_BE_ENCHANTED_ANYMORE")))
    return
  end
  local ds, addition = ed.playerlimit.getAreaUnlockPrompt("Item One-Click-Upgrade")
  if ds then
    if addition and addition.type == "vip" then
      ed.showHandyDialog("vipLocked", {
        vip = addition.limit
      })
    else
      ed.showToast(ds)
    end
    return
  end
  local price = self.rmbCost
  local info = {
    text = T(LSTR("EQUIPSTRENGTHEN.ONECLICK_ENCHANTING_COSTS__D_DIAMONDS_ARE_YOU_SURE_TO_CONTINUE"), price),
    rightHandler = function()
      self:upFastStren()
    end
  }
  ed.showConfirmDialog(info)
end
class.doClickFastStren = doClickFastStren
local function doFastStrenTouch(self)
  local isPress
  local function handler(event, x, y)
    if not self.strenui then
      return
    end
    if tolua.isnull(self.strenui.faststren) then
      return
    end
    if tolua.isnull(self.strenui.fsContainer) then
      return
    end
    if not self.strenui.fsContainer:isVisible() then
      return
    end
    local button = self.strenui.faststren
    local press = self.strenui.faststren_press
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickFastEnhance")
          self:doClickFastStren()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doFastStrenTouch = doFastStrenTouch
local function createStrenButton(self, slot)
  if not tolua.isnull(self.strenContainer) then
    self.strenContainer:removeFromParentAndCleanup(true)
    self.strenContainer = nil
  end
  if not slot then
    self.strenui = nil
    self:removeMaterialLayer()
    return
  end
  local container = CCSprite:create()
  self.strenContainer = container
  container:setCascadeOpacityEnabled(true)
  self.container:addChild(container)
  self.rmbCost = self:getFastStrenCost(slot)
  local strenui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "money_bg",
        res = "UI/alpha/HVGA/pvp/pvp_price_bg.png"
      },
      layout = {
        position = ccp(665, 185)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "no_cost",
        text = T(LSTR("EQUIPSTRENGTHEN.NO_MATERIAL_ADDED")),
        size = 18
      },
      layout = {
        position = ccp(665, 185)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_icon",
        res = "UI/alpha/HVGA/goldicon_small.png"
      },
      layout = {
        position = ccp(615, 183)
      },
      config = {
        fix_size = CCSizeMake(27, 25),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "money",
        text = 0,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(715, 183)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "stren",
        res = "UI/alpha/HVGA/herodetail-upgrade.png",
        capInsets = CCRectMake(20, 20, 53, 29)
      },
      layout = {
        position = ccp(666, 145)
      },
      config = {
        scaleSize = CCSizeMake(125, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "stren_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(20, 20, 53, 29),
        parent = "stren"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(125, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "stren_label",
        text = T(LSTR("EQUIPSTRENGTHEN.ENCHANTING")),
        fontinfo = "ui_normal_button",
        parent = "stren"
      },
      layout = {
        position = ccp(62, 21)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  local readNode = ed.readnode.create(container, strenui)
  readNode:addNode(ui_info)
  local fsContainer = CCSprite:create()
  strenui.fsContainer = fsContainer
  container:addChild(fsContainer)
  readNode = ed.readnode.create(fsContainer, strenui)
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "rmb_bg",
        res = "UI/alpha/HVGA/pvp/pvp_price_bg.png"
      },
      layout = {
        position = ccp(665, 102)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "no_fastcost",
        text = "",
        size = 18
      },
      layout = {
        position = ccp(665, 100)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "rmb_icon",
        res = "UI/alpha/HVGA/task_rmb_icon_2.png"
      },
      layout = {
        position = ccp(620, 100)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "rmb",
        text = self.rmbCost,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(715, 100)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "faststren",
        res = "UI/alpha/HVGA/herodetail-upgrade.png",
        capInsets = CCRectMake(20, 20, 53, 29)
      },
      layout = {
        position = ccp(666, 60)
      },
      config = {
        scaleSize = CCSizeMake(125, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "faststren_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(20, 20, 53, 29),
        parent = "faststren"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(125, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "faststren_label",
        text = T(LSTR("EQUIPSTRENGTHEN.ONECLICK_ENCHANTING")),
        fontinfo = "ui_normal_button",
        parent = "faststren"
      },
      layout = {
        position = ccp(62, 21)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  readNode:addNode(ui_info)
  self.strenui = strenui
  self:refreshFastStrenButton()
end
class.createStrenButton = createStrenButton
local function refreshFastStrenButton(self)
  local ui = self.strenui or {}
  if tolua.isnull(ui.fsContainer) then
    return
  end
  local showvip = ed.playerlimit.getAreaShowvip("Item One-Click-Upgrade")
  if showvip <= ed.player:getvip() then
    ui.fsContainer:setVisible(true)
  else
    ui.fsContainer:setVisible(false)
  end
end
class.refreshFastStrenButton = refreshFastStrenButton
local function initBar(self)
  local slot = self.slot
  local level, exp, mlevel, mexp = self:getEquipLevel(slot)
  self.oriExp = self:getItemExp(slot)
  self.oriLevel = level
  self.targetExp = self.oriExp
  local nl = math.min(level + 1, mlevel)
  local ui = self.barui
  ed.setString(ui.b_lv, res.enhance_level_res[level] or "")
  ed.setString(ui.n_lv, res.enhance_level_res[nl] or "")
  ed.setString(ui.ehc, string.format("%d/%d", exp, mexp))
  ui.bar:setVisible(true)
  ui.anim_bar:setVisible(false)
  if not tolua.isnull(ui.bar) then
    ui.bar:setTextureRect(CCRectMake(0, 0, 655 * exp / mexp, 18))
  end
end
class.initBar = initBar
local function refreshExpBar(self)
  local count = 0
  local exp = self.oriExp
  local target = math.max(math.min(self.targetExp, self:getTotalExp(self.slot)), 0)
  local ui = self.barui
  local bar = ui.anim_bar
  ui.bar:setVisible(false)
  bar:setVisible(true)
  local isAdd = exp < target
  local speed = isAdd and math.max(target - exp, 60) or math.min(target - exp, -60)
  local function handler(dt)
    exp = isAdd and math.min(target, exp + speed * dt) or math.max(target, exp + speed * dt)
    if isAdd then
      if exp >= target then
        exp = target
        self:removeUpdateHandler("refreshExpBar")
      end
    elseif exp <= target then
      exp = target
      self:removeUpdateHandler("refreshExpBar")
      if exp == self:getItemExp(self.slot) then
        ui.bar:setVisible(true)
        bar:setVisible(false)
      end
    end
    local l, e, ml, me = self:getEquipLevel(self.slot, exp)
    local e = math.floor(e)
    local me = math.floor(me)
    if l ~= self.oriLevel then
      self.oriLevel = l
      ed.setString(ui.b_lv, res.enhance_level_res[l] or "")
      ed.setString(ui.n_lv, res.enhance_level_res[math.min(l + 1, ml)] or "")
    end
    ed.setString(ui.ehc, string.format("%d/%d", e, me))
    if not tolua.isnull(bar) then
      bar:setTextureRect(CCRectMake(0, 0, 655 * e / me, 18))
    end
    self.oriExp = exp
  end
  return handler
end
class.refreshExpBar = refreshExpBar
local addExp = function(self, exp)
  self.targetExp = (self.targetExp or self.oriExp) + exp
  self:registerUpdateHandler("refreshExpBar", self:refreshExpBar())
  self:refreshStrenCost()
end
class.addExp = addExp
local function createExpBar(self, slot)
  if not tolua.isnull(self.barContainer) then
    self.barContainer:removeFromParentAndCleanup(true)
    self.barContainer = nil
  end
  if not slot then
    return
  end
  local container = CCSprite:create()
  self.barContainer = container
  container:setCascadeOpacityEnabled(true)
  self.container:addChild(container)
  local level, exp, mlevel, mexp = self:getEquipLevel(slot)
  self.oriExp = self:getItemExp(slot)
  self.oriLevel = level
  self.targetExp = self.oriExp
  local nl = math.min(level + 1, mlevel)
  local barui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bar_bg",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_progress_bg.png"
      },
      layout = {
        position = ccp(400, 212)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "b_lv",
        text = res.enhance_level_res[level] or "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(75, 235)
      },
      config = {
        color = ccc3(146, 0, 9),
		shadow = {
			color = ccc3(0, 0, 0),
			offset = ccp(0, 1)
      }
    },
    },
    {
      t = "Label",
      base = {
        name = "n_lv",
        text = res.enhance_level_res[nl] or "",
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(725, 235)
      },
      config = {
        color = ccc3(146, 0, 9)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_progress_1.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(72, 213)
      },
      config = {
        textureRect = CCRectMake(0, 0, 655 * exp / mexp, 18)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "anim_bar",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_progress_2.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(72, 213)
      },
      config = {
        textureRect = CCRectMake(0, 0, 655 * exp / mexp, 18),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ehc",
        text = string.format("%d/%d", exp, mexp),
        size = 16
      },
      layout = {
        position = ccp(400, 212)
      },
      config = {
        stroke = {
          color = ccc3(0, 0, 0),
          size = 2
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, barui)
  readNode:addNode(ui_info)
  self.barui = barui
end
class.createExpBar = createExpBar
local function initEquipAtt(self)
  local slot = self.slot
  local preAdd = self.preAddAtt
  local att, add = self:getEquipAtt(slot)
  local ui = self.attui
  ed.setString(ui.level, self:getLevelText(slot))
  for k, v in pairs(add) do
    if (preAdd[k] or 0) ~= v then
      for i = 1, #self.attLabelList do
        if k == self.attLabelList[i].key then
          local label = self.attLabelList[i].add
          ed.setString(label, "+" .. v)
          local s = CCScaleTo:create(0.2, 1.2)
          s = CCEaseBackIn:create(s)
          local sb = CCScaleTo:create(0.2, 1)
          sb = CCEaseBackIn:create(sb)
          local seq = CCSequence:createWithTwoActions(s, sb)
          label:runAction(seq)
          self.preAddAtt[k] = v
        end
      end
    end
  end
  self:refreshAttListPos()
end
class.initEquipAtt = initEquipAtt
local getEquipid = function(self, slot)
  return self.equips[slot].id
end
class.getEquipid = getEquipid
local function getEquipRow(self, slot)
  local id = self:getEquipid(slot)
  return ed.getDataTable("equip")[id]
end
class.getEquipRow = getEquipRow
local getEquipName = function(self, slot)
  local row = self:getEquipRow(slot)
  return row.Name
end
class.getEquipName = getEquipName
local function getEquipLevelExp(self, slot)
  return ed.readequip.getEquipLevelExp(self.hid, slot)
end
class.getEquipLevelExp = getEquipLevelExp
local getTotalExp = function(self, slot)
  local le = self:getEquipLevelExp(slot)
  local exp = 0
  for i = 1, #le do
    exp = exp + le[i]
  end
  return exp
end
class.getTotalExp = getTotalExp
local function getEquipLevel(self, slot, exp)
  return ed.readequip.getEquipLevel(self.hid, slot, exp)
end
class.getEquipLevel = getEquipLevel
local function getUnitrmb(self, slot)
  local quality = self:getEquipRow(slot).Quality
  local info = ed.getDataTable("enhancement")
  return info[quality]["One-Click Unit Price"]
end
class.getUnitrmb = getUnitrmb
local function getUnitMoney(self, slot)
  local quality = self:getEquipRow(slot).Quality
  local info = ed.getDataTable("enhancement")
  return info[quality]["Unit Price"]
end
class.getUnitMoney = getUnitMoney
local getFastStrenCost = function(self, slot)
  local up = self:getUnitrmb(slot)
  local l, e, ml, me = self:getEquipLevel(slot)
  local et, tl = self:getEquipLevelExp(slot)
  local cost = 0
  cost = cost + up * (me - e)
  for i = l + 2, tl do
    cost = cost + up * et[i]
  end
  return cost
end
class.getFastStrenCost = getFastStrenCost
local checkMaxLevel = function(self, slot, exp)
  local l, e, ml, me = self:getEquipLevel(slot, exp)
  if l == ml and e == me then
    return true
  end
  return false
end
class.checkMaxLevel = checkMaxLevel
local function getEquipAtt(self, slot)
  self.att = {}
  self.attAdd = {}
  local att, attAdd = {}, {}
  local id = self:getEquipid(slot)
  att = ed.readequip.getAttList(id)
  local el = self:getEquipLevel(slot)
  attAdd = ed.readequip.getAddAttList(id, el)
  return att, attAdd
end
class.getEquipAtt = getEquipAtt
local function getLevelText(self, slot)
  local level = self:getEquipLevel(slot)
  if level == 0 then
    return T(LSTR("EQUIPINFO.UNENCHANTED"))
  else
    return res.enhance_level_res[level] or ""
  end
end
class.getLevelText = getLevelText
local refreshAttListPos = function(self)
  local ox, oy = 347, 355
  local list = self.attLabelList
  local y = oy
  for i = 1, #list do
    local x = ox
    local axl, axr
    local pre = list[i].pre
    local att = list[i].att
    local add = list[i].add
    local suf = list[i].suf
    axl = 0
    axr = pre:getContentSize().width / 2
    x = x + axl + axr
    pre:setPosition(ccp(x, y))
    axl = pre:getContentSize().width / 2
    axr = att:getContentSize().width / 2
    --Ray 合成界面属性增加空格
    x = x + axl + axr + 5
    att:setPosition(ccp(x, y))
    axl = att:getContentSize().width / 2
    axr = add:getContentSize().width / 2
    x = x + axl + axr
    add:setPosition(ccp(x, y))
    axl = add:getContentSize().width / 2
    axr = suf:getContentSize().width / 2
    x = x + axl + axr
    suf:setPosition(ccp(x, y))
    y = y - att:getContentSize().height
  end
end
class.refreshAttListPos = refreshAttListPos
local function createAttList(self, slot)
  local res = ed.ui.baseres
  local pre = res.att_pre
  local suffix = res.att_suffix
  local att, add = self:getEquipAtt(slot)
  self.preAddAtt = add
  self.attLabelList = {}
  local attList = ed.ui.baseres.att_name
  for i, v in ipairs(attList) do
    if att[v] then
      local k = v
      v = att[v]
      local lpre = ed.createttf(pre[k], 18)
      ed.setLabelColor(lpre, ccc3(255, 255, 255))
      self.attContainer:addChild(lpre)
	  ed.setLabelShadow(lpre, ccc3(0, 0, 0), ccp(0, 1))
      local latt = ed.createttf(v, 18)
      ed.setLabelColor(latt, ccc3(255, 0, 0))
      self.attContainer:addChild(latt)
	  ed.setLabelShadow(latt, ccc3(0, 0, 0), ccp(0, 1))
      local ladd
      if 0 < (add[k] or 0) then
        ladd = ed.createttf("+" .. add[k], 18)
      else
        ladd = ed.createttf("", 18)
      end
      ed.setLabelColor(ladd, ccc3(0, 255, 0))
      self.attContainer:addChild(ladd)
	  ed.setLabelShadow(ladd, ccc3(0, 0, 0), ccp(0, 1))
      local lsuf
      if suffix[k] then
        lsuf = ed.createttf(suffix[k], 18)
      else
        lsuf = ed.createttf("", 18)
      end
      ed.setLabelColor(lsuf, ccc3(0, 0, 0))
      self.attContainer:addChild(lsuf)
	  ed.setLabelShadow(lsuf, ccc3(0, 0, 0), ccp(0, 1))
      table.insert(self.attLabelList, {
        key = k,
        pre = lpre,
        att = latt,
        add = ladd,
        suf = lsuf
      })
    end
  end
  self:refreshAttListPos()
end
class.createAttList = createAttList
local function createEquipAtt(self, slot)
  if not tolua.isnull(self.attContainer) then
    do
      local ac = self.attContainer
      self.attContainer = nil
      ac:stopAllActions()
      local fade = CCFadeOut:create(0.2)
      local func = CCCallFunc:create(function()
        xpcall(function()
          ac:removeFromParentAndCleanup(true)
        end, EDDebug)
      end)
      local s = CCSequence:createWithTwoActions(fade, func)
      ac:runAction(s)
    end
  end
  if not slot then
    return
  end
  self:getEquipAtt(slot)
  local name = self:getEquipName(slot)
  local level = self:getEquipLevel(slot)
  local container = CCSprite:create()
  self.attContainer = container
  container:setCascadeOpacityEnabled(true)
  self.container:addChild(container)
  local ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_item_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(345, 415)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(347, 415)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = self:getLevelText(slot),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(347, 385)
      },
      config = {
        color = ccc3(255, 120, 0),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 1)
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  self:createAttList(slot)
  self.attContainer:setOpacity(0)
  local delay = CCDelayTime:create(0.2)
  local fade = CCFadeIn:create(0.2)
  local s = CCSequence:createWithTwoActions(delay, fade)
  self.attContainer:runAction(s)
  self.attui = ui
end
class.createEquipAtt = createEquipAtt
local function initHeroEquip(self)
  local slot = self.slot
  local stars = self.equips[slot].stars
  ed.readequip.refreshHeroItemStar(self.hid, slot, stars)
  self:playEnhanceAnim(slot)
end
class.initHeroEquip = initHeroEquip
local playStarAnim = function(self, stars, index, eof, isdelay)
  if eof < index then
    return
  end
  local star = stars[index].icon
  star:stopAllActions()
  local osc = star:getScale()
  local a = CCArray:create()
  local delay = CCDelayTime:create(0.5)
  local f1 = CCCallFunc:create(function()
    xpcall(function()
      star:setVisible(true)
      star:setScale(2)
    end, EDDebug)
  end)
  local sl = CCScaleTo:create(0.2, osc)
  sl = CCEaseBackIn:create(sl)
  local f2 = CCCallFunc:create(function()
    xpcall(function()
      self:playStarAnim(stars, index + 1, eof)
    end, EDDebug)
  end)
  if isdelay then
    a:addObject(delay)
  end
  a:addObject(f1)
  a:addObject(sl)
  a:addObject(f2)
  local s = CCSequence:create(a)
  star:runAction(s)
end
class.playStarAnim = playStarAnim
local function playEnhanceAnim(self, slot)
  local hid = self.hid
  local equip = self.equips[slot]
  local icon = equip.icon
  local stars = equip.stars
  local level = equip.level
  local nl = ed.readequip.getEquipLevel(hid, slot)
  equip.level = nl
  if level < nl then
    local size = icon:getContentSize()
    local node = ed.createFcaNode("eff_UI_enhance_success")
    node:setPosition(ccp(size.width / 2, size.height / 2))
    icon:addChild(node)
    self:addFca(node)
  end
  for i = level + 1, nl do
    local s = stars[i]
    s.icon:setVisible(false)
  end
  self:playStarAnim(stars, level + 1, nl, true)
end
class.playEnhanceAnim = playEnhanceAnim
local getEquipPos = function(self, i)
  local ox, oy = 235, 405
  local dx, dy = 72, 72
  local ix = (i - 1) % 2
  local iy = math.floor((i - 1) / 2)
  local x = ox + dx * ix
  local y = oy - dy * iy
  return ccp(x, y)
end
class.getEquipPos = getEquipPos
local function createEquip(self, skipAnim, isEmpty)
  if not tolua.isnull(self.equipContainer) then
    self.equipContainer:removeFromParentAndCleanup(true)
    self.equipContainer = nil
    self.equips = nil
  end
  local container = CCSprite:create()
  self.equipContainer = container
  container:setCascadeOpacityEnabled(true)
  self.container:addChild(container)
  if not isEmpty then
    self.equips = {}
  end
  local count = 0
  local maxQuality = 0
  local maxStars = true
  for i = 1, 6 do
    local icon, eIcon, stars
    if isEmpty then
      icon = ed.createSprite("UI/alpha/HVGA/gocha.png")
    else
      local id = self:getItemid(i)
      if id > 0 then
        icon, eIcon, stars = ed.readequip.createESHeroItem(self.hid, i)
        local level = ed.readequip.getEquipLevel(self.hid, i)
        self.equips[i] = {
          icon = icon,
          eIcon = eIcon,
          stars = stars,
          id = id,
          has = true,
          level = level
        }
        count = count + 1
        maxQuality = math.max(maxQuality, ed.readequip.quality(id))
        if not self:checkMaxLevel(i) then
          maxStars = false
        end
      else
        icon = ed.createSprite("UI/alpha/HVGA/gocha.png")
        self.equips[i] = {
          icon = icon,
          eIcon = nil,
          id = nil,
          has = false
        }
      end
      local pos = self:getEquipPos(i)
      icon:setPosition(pos)
      container:addChild(icon)
      if id > 0 and 1 < ed.readequip.quality(id) and not self:checkMaxLevel(i) and ed.readequip.quality(id) then
        ed.teach("EEclickEquip", icon, container)
        self.EEclickEquipid = i
      end
    end
  end
  if not skipAnim and not isEmpty then
    container:setOpacity(0)
    local fade = CCFadeTo:create(0.2, 255)
    container:runAction(fade)
  end
  return count, maxQuality, maxStars
end
class.createEquip = createEquip
local selectEquip = function(self, slot)
  if not self.equips then
    return
  end
  if slot then
    local el, ml = self:getEquipLevelExp(slot)
    if ml == 0 then
      self:doSpeak(T(LSTR("EQUIPSTRENGTHEN.ONLY_GREEN_AND_OVER_THE_QUALITY_OF_THE_EQUIPMENT_CAN_BE_ENCHANTED")))
      return
    end
  end
  local heroChange
  if not self.slot then
    self.slot = slot
    heroChange = true
  elseif self.slot == slot then
    return
  else
    self.slot = slot
  end
  self:doSelectSlot(slot, heroChange)
  if self:checkMaxLevel(slot) then
    self:doTalk(T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
  else
    self:doTalk(T(LSTR("EQUIPSTRENGTHEN.PLEASE_ADD_MATERIAL_IT_CAN_BE_ADDED_TO_ALL_EQUIPMENTS")))
  end
  for i = 1, 6 do
    local icon = self.equips[i].icon
    local has = self.equips[i].has
    icon:stopAllActions()
    local fade
    if slot == i then
      fade = CCFadeTo:create(0.2, 255)
    else
      fade = CCFadeTo:create(0.2, 75)
    end
    if fade then
      icon:runAction(fade)
    end
  end
end
class.selectEquip = selectEquip
local getItemid = function(self, slot)
  local hero = self:getHero()
  if not hero then
    return 0
  end
  local id = hero._items[slot]._item_id or 0
  return id
end
class.getItemid = getItemid
local getItemExp = function(self, slot)
  local hero = self:getHero()
  if not hero then
    return 0
  end
  local exp = hero._items[slot]._exp or 0
  return exp
end
class.getItemExp = getItemExp
local getEquipid = function(self, i)
  local hero = self:getHero()
  local hid = self.hid
  local rank = hero._rank
  local items = hero._items[i]
  if not items then
    print("the slot has no item")
    return
  end
  local eid = items._item_id
  return eid
end
class.getEquipid = getEquipid
local function getHero(self)
  if not self.hid then
    return nil
  end
  return ed.player.heroes[self.hid]
end
class.getHero = getHero
local function doChangeHero(self)
  ed.endTeach("EEclickHero")
  ed.ui.selectwindow.pop({
    name = "hero",
    callback = self:setHeroIcon()
  })
end
class.doChangeHero = doChangeHero
local function setHeroIcon(self)
  local function handler(tid)
    if not self.hid then
      local ui = self.ui
      local label = ui.select_hero_label
      ed.setString(label, T(LSTR("EQUIPSTRENGTHEN.SWITCH_HEROES")))
    end
    self:initMaterialData()
    self.hid = tid
    local hero = ed.player.heroes[tid]
    local rank = hero._rank
    local stars = hero._stars
    local pos = ccp(self.ui.heroIcon:getPosition())
    self.ui.heroIcon:removeFromParentAndCleanup(true)
    local icon = ed.readhero.createIcon({
      id = tid,
      rank = rank,
      stars = stars
    }).icon
    icon:setPosition(pos)
    self.container:addChild(icon)
    self.ui.heroIcon = icon
    if self.ui.heroName then
      self.ui.heroName:removeFromParentAndCleanup(true)
    end
    local name, w, h = ed.readhero.createHeroName(tid)
     if w > 130 then
      name:setScale(130 / w)
    end
    name:setAnchorPoint(ccp(0, 0.5))
    name:setPosition(ccp(130 - math.min(w, 120) / 2, 395))
    --name:setPosition(ccp(130, 400))
    self.container:addChild(name)
    self.ui.heroName = name
    local count, mq, ms = self:createEquip()
    self:doSelectSlot()
    local talk = T(LSTR("EQUIPSTRENGTHEN.PLEASE_SELECT_EQUIPMENT"))
    if count <= 0 then
      talk = T(LSTR("EQUIPSTRENGTHEN.THIS_HERO_DOE_NOT_WEAR_ANY_EQUIPMENT_PLEASE_RESELECT_HERO"))
    elseif mq <= 1 then
      talk = T(LSTR("EQUIPSTRENGTHEN.THIS_HERO_DOESNT_HAVE_EQUIPMENT_FOR_ENHANCED_PLEASE_RESELECT_HERO"))
    elseif ms then
      talk = T(LSTR("EQUIPSTRENGTHEN.THIS_HERO_HAS_ALL_EQUIPMENTS_ENHANCED_TO_THE_MAXED_LEVEL_PLEASE_RESELECT_HERO"))
    end
    self:doTalk(talk)
  end
  return handler
end
class.setHeroIcon = setHeroIcon
local function doClickEquip(self, i)
  if i == (self.EEclickEquipid or 0) then
    ed.endTeach("EEclickEquip")
  end
  self:selectEquip(i)
end
class.doClickEquip = doClickEquip
local function doEquipTouch(self)
  local id
  local function handler(event, x, y)
    if not self.equips then
      return
    end
    if event == "began" then
      for i = 1, 6 do
        local equip = self.equips[i]
        if ed.containsPoint(equip.icon, x, y) then
          if not equip.has then
            return
          end
          id = i
          equip.icon:setScale(0.95)
        end
      end
    elseif event == "ended" then
      if id then
        local equip = self.equips[id]
        equip.icon:setScale(1)
        if ed.containsPoint(equip.icon, x, y) then
          lsr:report("clickEquip")
          self:doClickEquip(id)
        end
      end
      id = nil
    end
  end
  return handler
end
class.doEquipTouch = doEquipTouch
local function doHeroTouch(self)
  local isPress
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.heroIcon, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(self.ui.heroIcon, x, y) then
        lsr:report("clickHeroHead")
        self:doChangeHero()
      end
      isPress = nil
    end
  end
  return handler
end
class.doHeroTouch = doHeroTouch
local function doSelectHeroTouch(self)
  local isPress
  local normal = self.ui.select_hero
  local press = self.ui.select_hero_press
  local function handler(event, x, y)
    if not normal:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(normal, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(normal, x, y) then
          lsr:report("clickSelectHero")
          self:doChangeHero()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doSelectHeroTouch = doSelectHeroTouch
local function doClickBack(self)
  ed.popScene()
end
class.doClickBack = doClickBack
local function doBackTouch(self)
  local isPress
  local button = self.ui.back
  local press = self.ui.back_press
  local function handler(event, x, y)
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickBack")
          self:doClickBack()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doBackTouch = doBackTouch
local doMainLayerTouch = function(self)
  local heroTouch = self:doHeroTouch()
  local backTouch = self:doBackTouch()
  local equipTouch = self:doEquipTouch()
  local selectHeroTouch = self:doSelectHeroTouch()
  local mbTouch = self:dombTouch()
  local strenTouch = self:doStrenTouch()
  local fastStrenTouch = self:doFastStrenTouch()
  local function handler(event, x, y)
    xpcall(function()
      heroTouch(event, x, y)
      backTouch(event, x, y)
      equipTouch(event, x, y)
      selectHeroTouch(event, x, y)
      mbTouch(event, x, y)
      strenTouch(event, x, y)
      fastStrenTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doShowMaxLevel(self)
  local slot = self.slot
  self:doShowmbPrompt(slot)
  self:removeMaterialLayer()
  local ui = self.strenui
  ui.money_icon:setVisible(false)
  ui.money:setVisible(false)
  ui.no_cost:setVisible(true)
  ui.rmb_icon:setVisible(false)
  ui.rmb:setVisible(false)
  ui.no_fastcost:setVisible(true)
  ed.setString(ui.no_cost, T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
  ed.setString(ui.no_fastcost, T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
  local ui = self.barui
  ui.b_lv:setVisible(false)
  ui.n_lv:setVisible(false)
  ed.setString(ui.ehc, T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
end
class.doShowMaxLevel = doShowMaxLevel
local function doSelectSlot(self, slot, heroChange)
  self.slot = slot
  local hc = heroChange
  if slot then
    self:createEquipAtt(slot)
    self:createExpBar(slot)
    self:createStrenButton(slot)
    self:initMaterialLayer()
    if hc then
      self:doShowmbPrompt(slot)
    else
      ed.setString(self.ui.material_label, T(LSTR("EQUIPSTRENGTHEN.CLICK_HERE_TO_OPEN_THE_PACK\N_YOU_CAN_USE_ANY_EQUIPMENT_TO_ENCHANT")))
    end
    ed.teach("EEopenMaterial", self.ui.material_label, self.container)
    if self:checkMaxLevel(slot) then
      self:doShowMaxLevel()
    end
  else
    self:createEquipAtt()
    self:createExpBar()
    self:doShowmbPrompt()
    self:createStrenButton()
  end
end
class.doSelectSlot = doSelectSlot
local function doShowmbPrompt(self, slot)
  if slot then
    self.ui.material_bg:removeFromParentAndCleanup(true)
    local bg = ed.createScale9Sprite("UI/alpha/HVGA/equipupgrade/equipupgrade_material_bg.png", CCRectMake(10, 10, 480, 144))
    bg:setContentSize(CCSizeMake(520, 154))
    self.container:addChild(bg)
    bg:setPosition(ccp(335, 120))
    self.ui.material_bg = bg
    self.ui.material_label:setVisible(true)
    if self:checkMaxLevel(slot) then
      ed.setString(self.ui.material_label, T(LSTR("EQUIPSTRENGTHEN.YOUR_ENCHANTING_LEVEL_HAS_BEEN_MAXED_OUT")))
    else
      ed.setString(self.ui.material_label, T(LSTR("EQUIPSTRENGTHEN.CLICK_HERE_TO_OPEN_THE_PACK\N_YOU_CAN_USE_ANY_EQUIPMENT_TO_ENCHANT")))
    end
  else
    self.ui.material_bg:removeFromParentAndCleanup(true)
    local bg = ed.createScale9Sprite("UI/alpha/HVGA/equipupgrade/equipupgrade_bottom_bg.png", CCRectMake(10, 10, 640, 146))
    bg:setContentSize(CCSizeMake(660, 154))
    self.container:addChild(bg)
    bg:setPosition(ccp(400, 120))
    self.ui.material_bg = bg
    self.ui.material_label:setVisible(false)
  end
end
class.doShowmbPrompt = doShowmbPrompt
local function create()
  local self = base.create("equipStrengthen")
  setmetatable(self, class.mt)
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  self.scene:addChild(mainLayer)
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  self.ui = {}
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
        name = "frame",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_frame.png"
      },
      layout = {
        position = ccp(400, 230)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "heroIcon",
        res = "UI/alpha/HVGA/hero_icon_frame_1.png"
      },
      layout = {
        position = ccp(135, 340)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "nohead",
        res = "UI/alpha/HVGA/handbook_icon_lock.png",
        z = -1,
        parent = "heroIcon"
      },
      layout = {
        position = ccp(41, 41)
      },
      config = {
        fix_size = CCSizeMake(82, 82)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "select_hero",
        res = "UI/alpha/HVGA/herodetail-upgrade.png",
        capInsets = CCRectMake(20, 20, 53, 29)
      },
      layout = {
        position = ccp(135, 270)
      },
      config = {
        scaleSize = CCSizeMake(110, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "select_hero_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(20, 20, 53, 29),
        parent = "select_hero"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(110, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "select_hero_label",
        text = T(LSTR("EATEXPLIST.CHOOSE_A_HERO")),
        fontinfo = "ui_normal_button",
        parent = "select_hero"
      },
      layout = {
        position = ccp(55, 19)
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
        position = ccp(65, 430)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
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
      t = "Scale9Sprite",
      base = {
        name = "material_bg",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_bottom_bg.png",
        capInsets = CCRectMake(10, 10, 640, 146)
      },
      layout = {
        position = ccp(400, 120)
      },
      config = {
        scaleSize = CCSizeMake(660, 166)
      }
    },
    {
      t = "Label",
      base = {
        name = "material_label",
        text = T(LSTR("EQUIPSTRENGTHEN.CLICK_HERE_TO_OPEN_THE_PACK\N_YOU_CAN_USE_ANY_EQUIPMENT_TO_ENCHANT")),
        size = 22,
        z = 1
      },
      layout = {
        position = ccp(325, 120)
      },
      config = {
        color = ccc3(255, 255, 255),
        --[[
        stroke = {
          color = ccc3(207, 195, 175),
          size = 1
        },]]--
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "npc",
        res = "UI/alpha/HVGA/equipupgrade/equipupgrade_npc_head.png"
      },
      layout = {
        position = ccp(638, 378)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:createEquip(nil, true)
  self:doSelectSlot()
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self:registerOnEnterHandler("enterEnhance", self:enterScene())
  self:doTalk(T(LSTR("EQUIPSTRENGTHEN.PLEASE_SELECT_HERO")))
  return self
end
class.create = create
local function enterScene(self)
  local function handler()
    ed.teach("EEclickHero", self.ui.select_hero, self.container)
  end
  return handler
end
class.enterScene = enterScene

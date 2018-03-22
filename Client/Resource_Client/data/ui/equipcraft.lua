local class = newclass()
ed.ui.equipcraft = class
local lsr = ed.ui.equipcraftlsr.create()
local checkMoneyEnough = function(self)
  local cost = self.craftWindow.expense or 0
  local money = ed.player._money
  return cost <= money
end
class.checkMoneyEnough = checkMoneyEnough
local normalColor = ccc3(255, 255, 255)
local pressColor = ccc3(150, 150, 150)
local isShow = function(self)
  if self.mainLayer then
    return self.mainLayer:isVisible(), true
  else
    return false, false
  end
end
class.isShow = isShow
local function show(self)
  lsr:report("createWindow")
  local frame = self.equipLayer.ui.frame
  frame:setScale(0)
  frame:runAction(CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))
end
class.show = show
local function destroy(self)
  lsr:report("closeWindow")
  local a = CCArray:create()
  local action = CCScaleTo:create(0.2, 0)
  action = CCEaseBackIn:create(action)
  local delay = CCDelayTime:create(0.1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
      self.mainLayer = nil
      if self.callback then
        if self.putonSuccessful then
          self.callback("equip")
        else
          self.callback("update")
        end
      end
    end, EDDebug)
  end)
  a:addObject(action)
  a:addObject(delay)
  a:addObject(func)
  local s = CCSequence:create(a)
  if not tolua.isnull(self.actionLayer) then
    self.actionLayer:runAction(s)
  end
  if self.destroyHandler then
    self.destroyHandler()
  end
end
class.destroy = destroy
local doMainLayerTouch = function(self)
  local infoButtonTouch = self:doInfoButtonTouch()
  local outLayerTouch = self:doOutLayerTouch()
  local treeNodeTouch = self:doTreeNodeTouch()
  local craftButtonTouch = self:doCraftButtonTouch()
  local getWayTouch = self:doGetWayTouch()
  local function handler(event, x, y)
    xpcall(function()
      infoButtonTouch(event, x, y)
      outLayerTouch(event, x, y)
      treeNodeTouch(event, x, y)
      craftButtonTouch(event, x, y)
      getWayTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local doClickGetWay = function(self, id)
  local st = ed.stageType(id)
  if ed.isElementInTable(st, {"normal", "elite"}) then
    local star = ed.player:getStageStar(id) or 0
    local preStar = ed.player:getStageStar(id - 1) or 0
    if star + preStar > 0 then
      local scene = ed.ui.stageselect.createByStage(id)
      ed.pushScene(scene)
    else
      ed.showToast(T(LSTR("EQUIPCRAFT.CHAPTER_YET_TO_OPEN")))
    end
  end
end
class.doClickGetWay = doClickGetWay
local doGetWayTouch = function(self)
  local id
  local scale = 1
  local function handler(event, x, y)
    if not self.isOpen then
      return
    end
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if event == "began" then
      for i = 1, #buttons do
        local button = buttons[i]
        if ed.containsPoint(button, x, y) then
          id = i
          scale = button:getScale()
          button:setScale(scale * 0.95)
          break
        end
      end
    elseif event == "ended" then
      if id and buttons[id] then
        buttons[id]:setScale(scale)
        if ed.containsPoint(buttons[id], x, y) then
          self:doClickGetWay(self.getWayID[id])
        end
      end
      id = nil
    end
  end
  return handler
end
class.doGetWayTouch = doGetWayTouch
local doOutLayerTouch = function(self)
  local isPress
  local rect1 = CCRectMake(255, 55, 285, 375)
  local rect2 = CCRectMake(105, 55, 575, 375)
  local function handler(event, x, y)
    local rect
    if not self.isOpen then
      rect = rect1
    else
      rect = rect2
    end
    if event == "began" then
      if not rect:containsPoint(ccp(x, y)) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not rect:containsPoint(ccp(x, y)) then
        self:destroy()
      end
      isPress = nil
    end
  end
  return handler
end
class.doOutLayerTouch = doOutLayerTouch
local function doClickInfoButton(self)
  if self.context == "handbook" then
    lsr:report("clickOpenCraftLayer")
    if not self.isOpen then
      self:openCraftPanel()
    else
      self:destroy()
    end
  elseif self:getAmount() > 0 and not self.isEquiped then
    if ed.getMillionTime() - (self.TPclickPuton or 0) > 0.5 then
      lsr:report("clickWearEquip")
      self.TPclickPuton = ed.getMillionTime()
      self:putonEquip()
    end
  elseif self:getAmount() == 0 and not self.isEquiped and not self.isOpen then
    lsr:report("clickOpenCraftLayer")
    self:openCraftPanel()
  elseif self.isEquiped then
    lsr:report("clickWearEquip")
    self:destroy()
  else
    lsr:report("clickWearEquip")
  end
end
class.doClickInfoButton = doClickInfoButton
local function doInfoButtonTouch(self)
  local isPress
  local function handler(event, x, y)
    if self.isForbidInfoButton then
      return
    end
    local button = self.infoButton
    local press = self.infoButtonPress
    local label = self.infoButtonLabel
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
        ed.setLabelColor(label, pressColor)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        ed.setLabelColor(label, normalColor)
        if ed.containsPoint(self.infoButton, x, y) then
          self:doClickInfoButton()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doInfoButtonTouch = doInfoButtonTouch
local function doClickCraftButton(self)
  lsr:report("clickCraftButton")
  local components = self.components
  if components == 0 then
    if self.historyid > 1 then
      self:setHistory(self.historyid - 1)
    else
      self:closeCraftPanel()
      if 0 < self:getAmount() and self.context == "heroDetail" then
        ed.setString(self.infoButtonLabel, T(LSTR("EQUIPCRAFT.EQUIPMENT")))
        ed.setLabelColor(self.infoButtonLabel, normalColor)
      else
        ed.setString(self.infoButtonLabel, T(LSTR("EQUIPCRAFT.WAY_TO_GET")))
        ed.setLabelColor(self.infoButtonLabel, normalColor)
      end
    end
  else
    self:craftEquip()
  end
end
class.doClickCraftButton = doClickCraftButton
local doCraftButtonTouch = function(self)
  local isPress
  local function handler(event, x, y)
    if not self.isOpen then
      return
    end
    if self.isForbidCraftButton then
      return
    end
    if not ed.containsPoint(self.tree.craftButton, x, y) then
      return
    end
    local ui = self.tree
    local button = ui.craftButton
    local shade = ui.craftButtonPress
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        shade:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        shade:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickCraftButton()
        end
      end
      isPress = false
    end
  end
  return handler
end
class.doCraftButtonTouch = doCraftButtonTouch
local function doTreeNodeTouch(self)
  local id
  local function handler(event, x, y)
    if not self.isOpen then
      return
    end
    local nodes = self.tree.children or {}
    if event == "began" then
      for i = 1, #nodes do
        if ed.containsPoint(nodes[i], x, y) and self.craftWindow.nodeAmount[i] < 10000 then
          id = i
          self.clickTreeElementScale = nodes[i]:getScale()
          nodes[i]:setScale(self.clickTreeElementScale * 0.95)
        end
      end
    elseif event == "ended" then
      if id then
        if ed.containsPoint(nodes[id], x, y) then
          lsr:report("clickTreeNode")
          self:setHistory(0, self.craftWindow.nodeid[id])
          self:createCraftTree(self.craftWindow.nodeid[id])
        end
        if nodes[id] then
          nodes[id]:setScale(self.clickTreeElementScale)
        end
      end
      id = nil
    end
  end
  return handler
end
class.doTreeNodeTouch = doTreeNodeTouch
local upCraft = function(self)
  local cw = self.craftWindow
  if self.craftCategory == T(LSTR("EQUIPCRAFT.SYNTHETIC_FRAGMENTS")) then
    local fid = cw.nodeid[1]
    local famount = cw.nodeNeed[1]
    local makeid = ed.readequip.getComposedID(cw.nodeid[1])
    ed.netdata.fragmentCompose = {
      id = fid,
      fragmentAmount = famount,
      cost = cw.expense,
      makeId = makeid
    }
    ed.netreply.composeFragmentReply = self:craftReply()
    local msg = ed.upmsg.fragment_compose()
    msg._fragment = makeid
    msg._frag_amount = cw.nodeNeed[1]
    ed.send(msg, "fragment_compose")
  else
    ed.netdata.equipCraft = {
      id = self.craftid,
      node = cw.nodeid,
      consume = cw.nodeNeed,
      expense = cw.expense
    }
    ed.netreply.craftReply = self:craftReply()
    local msg = ed.upmsg.equip_synthesis()
    msg._equip_id = self.craftid
    ed.send(msg, "equip_synthesis")
  end
end
class.upCraft = upCraft
local createNeedCraftPrompt = function(self)
  local cw = self.craftWindow
  local ui = self.tree
  local showNeed, showNeed
  if not ed.isElementInTable(self.craftCategory, {
    T(LSTR("EQUIPCRAFT.SYNTHETIC_FRAGMENTS"))
  }) then
    for i = 1, #cw.nodeAmount do
      if cw.nodeAmount[i] < cw.nodeNeed[i] and ed.isEquipCraftable(cw.nodeid[i]) then
        if tolua.isnull(ui.prompt) then
          local promptBg = ed.createSprite("UI/alpha/HVGA/craft_promt_bg.png")
          local x, y = ui.children[i]:getPosition()
          promptBg:setAnchorPoint(ccp(0.5, 0))
          promptBg:setPosition(ccp(x, y + 20))
          ui.prompt = promptBg
          ui.layer:addChild(promptBg, 10)
          promptBg:setCascadeOpacityEnabled(true)
          local promptLabel = ed.createttf(T(LSTR("EQUIPCRAFT.THIS_PIECE_OF_EQUIPMENT_NEED_TO_BE_SYNTHESIZED_FIRST")), 18)
          local size = promptBg:getContentSize()
          local plSize = promptLabel:getContentSize()
          promptLabel:setPosition(ccp(size.width / 2, size.height / 2 + 5))
          promptBg:addChild(promptLabel)
          promptLabel:setScale((size.width - 20) / plSize.width)
          local a = CCArray:create()
          a:addObject(CCDelayTime:create(1))
          a:addObject(CCFadeOut:create(0.5))
          a:addObject(CCCallFunc:create(function()
            xpcall(function()
              if not tolua.isnull(ui.prompt) then
                ui.prompt:removeFromParentAndCleanup(true)
                ui.prompt = nil
              end
            end, EDDebug)
          end))
          local s = CCSequence:create(a)
          promptBg:runAction(s)
        end
        showNeed = true
        break
      end
    end
  end
  if not showNeed then
    ed.showToast(T(LSTR("EQUIPCRAFT.NO_SUITABLE_MATERIAL_GO_TO_COLLECT_SOME")), ccp(545, 280))
  end
end
class.createNeedCraftPrompt = createNeedCraftPrompt
local function craftEquip(self)
  local cw = self.craftWindow
  local ui = self.tree
  if self.lackOfComponent then
    self:createNeedCraftPrompt()
    lsr:report("clickCraftButtonDisenabled")
    return
  end
  if not self:checkMoneyEnough() then
    ed.showHandyDialog("useMidas", {
      refreshHandler = self:checkExpenseHandler()
    })
    lsr:report("clickCraftButtonDisenabled")
    return
  end
  lsr:report("clickCraftButton")
  if self.isCrafting then
    return
  end
  self.up = {}
  self.up.id = self.craftid
  self.up.nodeid = cw.nodeid
  self:upCraft()
  self.isCrafting = true
end
class.craftEquip = craftEquip
local function craftReply(self)
  local function handler(reply)
    if not self then
      return
    end
    if reply then
      self:playCraftEffect()
    else
      lsr:report("craftFailed")
      ed.showToast(T(LSTR("EQUIPCRAFT.SYNTHESIS_FAILURE")), ccp(545, 280))
    end
  end
  return handler
end
class.craftReply = craftReply
local function playCraftEffect(self)
  self.setCallback = nil
  local endPos = ccp(142, 226)
  if self.tree.children == nil then
    return
  end
  for k, v in pairs(self.tree.children) do
    local amount = self.craftWindow.nodeNeed[k]
    local dt = 0
    for i = 1, math.min(amount, 5) do
      do
        local element = ed.readequip.createSmallIcon(self.craftWindow.nodeid[k])
        if not tolua.isnull(v) then
          element:setPosition(ccp(v:getPosition()))
        end
        if not tolua.isnull(self.tree.layer) then
          self.tree.layer:addChild(element)
        end
        local array = CCArray:create()
        dt = 0.05 * (i - 1)
        local delay = CCDelayTime:create(dt)
        local move = CCEaseOut:create(CCMoveTo:create(0.4, endPos), 2.5)
        local fade = CCFadeOut:create(0.2)
        local remove = CCCallFunc:create(function()
          xpcall(function()
            element:removeFromParentAndCleanup(true)
          end, EDDebug)
        end)
        array:addObject(delay)
        array:addObject(move)
        array:addObject(fade)
        if not self.setCallback then
          array:addObject(CCCallFunc:create(function()
            xpcall(function()
              self:refreshReplyData()
              self:createCraftTree(self.craftid, true)
              if self.up.id == self.id then
                if self.context == "heroDetail" then
                  lsr:report("craftSuccess")
                  self:playPutonEffect()
                  self:createPutonTutorial()
                  ed.showToast(T(LSTR("EQUIPCRAFT.SYNTHESIS_SUCCESS")), ccp(545, 280))
                end
              else
                lsr:report("craftSuccess")
                ed.showToast(T(LSTR("EQUIPCRAFT.SYNTHESIS_SUCCESS")), ccp(545, 280))
              end
              if self.context == "heroDetail" and self.historyid > 1 then
                self:setHistory(self.historyid - 1)
              end
              self.isCrafting = false
            end, EDDebug)
          end))
          self.setCallback = true
        end
        array:addObject(remove)
        local sequence = CCSequence:create(array)
        element:runAction(sequence)
      end
    end
  end
  local rootPos = ccp(139, 226)
  local nodeAbove = ed.createFcaNode("eff_UI_craft_above")
  local nodeBelow = ed.createFcaNode("eff_UI_craft_below")
  nodeBelow:setPosition(rootPos)
  nodeAbove:setPosition(rootPos)
  local bs = ed.getCurrentScene()
  self.baseScene:addFcaOnce(nodeBelow)
  self.baseScene:addFcaOnce(nodeAbove)
  if not tolua.isnull(self.tree.layer) then
    self.tree.layer:addChild(nodeBelow)
    self.tree.layer:addChild(nodeAbove)
  end
end
class.playCraftEffect = playCraftEffect
local playPutonEffect = function(self)
  if self.hasPlayPutonEffect then
    return
  end
  local hlv, elv = self:getJudgeLevel()
  if hlv < elv then
    return
  end
  local node = ed.createSprite("UI/alpha/HVGA/puton_promt.png")
  node:setPosition(ccp(145, 43))
  self.equipLayer.ui.frame:addChild(node)
  local fo = CCFadeOut:create(1)
  local fi = CCFadeIn:create(1)
  local s = CCSequence:createWithTwoActions(fo, fi)
  s = CCRepeatForever:create(s)
  node:runAction(s)
  self.hasPlayPutonEffect = true
end
class.playPutonEffect = playPutonEffect
local refreshReplyData = function(self)
  if self.up.id == self.id then
    if self.context == "heroDetail" then
      self.infoButtonRemark:setVisible(true)
      local hlv, elv = self:getJudgeLevel()
      if elv <= hlv then
        self:forbidInfoButton(false)
      end
      self.equipLayer:refreshAmount()
    elseif self.context == "handbook" then
      self.equipLayer:refreshAmount()
    end
  end
end
class.refreshReplyData = refreshReplyData
local getJudgeLevel = function(self)
  local hid = self.hid
  local eid = self.id
  local canWear, hlv, elv = ed.canWearEquip(hid, eid)
  return hlv, elv
end
class.getJudgeLevel = getJudgeLevel
local putonEquip = function(self)
  local hlv, elv = self:getJudgeLevel()
  if hlv < elv then
    ed.showToast(T(LSTR("EQUIPCRAFT.REQUIRED_HERO_LEVEL___D"), elv))
    return
  end
  ed.netdata.putonReply = {
    hid = self.hid,
    sid = self.sid,
    eid = self.id
  }
  ed.netreply.putonReply = self:putonReply()
  local msg = ed.upmsg.wear_equip()
  msg._hero_id = self.hid
  msg._item_pos = self.sid
  ed.send(msg, "wear_equip")
  --add by xinghui
  if --[[ed.tutorial.checkDone("equipProp")==false--]] ed.tutorial.isShowTutorial then
    ed.sendDotInfoToServer(ed.tutorialres.t_key["equipProp"].id)
  end
  --
  ed.endTeach("equipProp")
  local preKeys = {
    "canEquipProp",
    "gotoHeroDetailToEquip",
    "gotoEquipProp",
    "openShortcutToEquip",
    "clickNextStage"
  }
  for k, v in pairs(preKeys) do
    if (ed.tutorial.getRecord(v) or 0) == 0 then
      ed.endTeach(v)
    end
  end
end
class.putonEquip = putonEquip
local putonReply = function(self)
  local function handler(isSuccessful)
    if not self then
      return
    end
    if isSuccessful then
      self.putonSuccessful = true
    end
    self:destroy()
  end
  return handler
end
class.putonReply = putonReply
local function openCraftPanel(self)
  self.isOpen = true
  local label = self.infoButtonLabel
  if self.context == "heroDetail" then
    ed.setString(label, T(LSTR("EQUIPCRAFT.EQUIPMENT")))
    ed.setLabelColor(label, pressColor)
    self:forbidInfoButton(true)
  elseif self.context == "handbook" then
    ed.setString(label, T(LSTR("CHATCONFIG.CONFIRM")))
  end
  self:createCraftWindow()
end
class.openCraftPanel = openCraftPanel
local closeCraftPanel = function(self)
  self:initHistory()
  self:initTree()
  self.isOpen = false
  if self.context == "heroDetail" then
    self:forbidInfoButton(false)
  end
  local ll = self.equipLayer.ui.frame
  local rl = self.craftWindow.mainLayer
  local mr = CCMoveTo:create(0.2, ccp(400, 240))
  ll:runAction(CCEaseElasticOut:create(mr, 5))
  local ml = CCMoveTo:create(0.2, ccp(400, 240))
  local func = CCCallFunc:create(function()
    xpcall(function()
      rl:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  rl:setZOrder(0)
  local s = CCSequence:createWithTwoActions(CCEaseOut:create(ml, 5), func)
  rl:runAction(s)
end
class.closeCraftPanel = closeCraftPanel
local function createInfoButton(self, state)
  local text, rv
  self.equipLayer:refreshAmount()
  if self.context == "heroDetail" then
    text = T(LSTR("EQUIPCRAFT.EQUIPMENT"))
    rv = true
    if self.isEquiped then
      rv = true
      text = T(LSTR("CHATCONFIG.CONFIRM"))
    elseif self:getAmount() == 0 then
      if not self.isOpen then
        if self:getComponents() == 0 then
          text = T(LSTR("EQUIPCRAFT.WAY_TO_GET"))
        else
          text = T(LSTR("EQUIPCRAFT.SYNTHESIS_FORMULA"))
        end
      else
        text = T(LSTR("EQUIPCRAFT.EQUIPMENT"))
        self:forbidInfoButton(true)
      end
    else
      self:forbidInfoButton(false)
    end
  elseif self.context == "handbook" then
    rv = true
    if not self.isOpen then
      if 0 < self:getComponents() then
        text = T(LSTR("EQUIPCRAFT.SYNTHESIS_FORMULA"))
      else
        text = T(LSTR("EQUIPCRAFT.WAY_TO_GET"))
      end
    else
      text = T(LSTR("CHATCONFIG.CONFIRM"))
    end
  end
  local remarkText = T(LSTR("EQUIPCRAFT.BINDS_WHEN_EQUIPPED_WITH_THE_HERO"))
  local remarkColor = ed.toccc3(1598976)
  if self.context == "heroDetail" then
    local hlv, elv = self:getJudgeLevel()
    if hlv < elv then
      remarkText = T(LSTR("EQUIPCRAFT.REQUIRED_HERO_LEVEL___D"), elv)
      remarkColor = ccc3(255, 0, 0)
    end
    if self.isEquiped then
      remarkText = T(LSTR("EQUIPCRAFT.REQUIRED_HERO_LEVEL___D"), elv)
    end
  elseif self.context == "handbook" then
    local elv = ed.getDataTable("equip")[self.id]["Level Requirement"] or 0
    remarkText = T(LSTR("EQUIPCRAFT.REQUIRED_HERO_LEVEL___D"), elv)
  end
  if not tolua.isnull(self.infoContainer) then
    self.infoContainer:removeFromParentAndCleanup(true)
    self.infoContainer = nil
  end
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, 0))
  self.infoContainer = container
  self.equipLayer.ui.frame:addChild(container)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "infoButtonRemark",
        text = remarkText,
        size = 18
      },
      layout = {
        position = ccp(147, 80)
      },
      config = {color = remarkColor, visible = rv}
    },
    {
      t = "Sprite",
      base = {
        name = "infoButton",
        res = "UI/alpha/HVGA/package_button.png"
      },
      layout = {
        position = ccp(147, 40)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "infoButtonPress",
        res = "UI/alpha/HVGA/package_button_down.png"
      },
      layout = {
        position = ccp(147, 40)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "infoButtonLabel",
        fontinfo = "ui_normal_button",
        text = text,
      },
      layout = {
        position = ccp(147, 40)
      },
      config = {color = normalColor}
    }
  }
  local readNode = ed.readnode.create(container, self)
  readNode:addNode(ui_info)
  if self.context == "heroDetail" and self:getAmount() == 0 and self.isOpen then
    self:forbidInfoButton(true)
  end
  if self.context == "heroDetail" and not self.isEquiped and self:getAmount() > 0 then
    self:createPutonTutorial()
  end
end
class.createInfoButton = createInfoButton
local initHistory = function(self)
  self.history = nil
  self.historyid = nil
end
class.initHistory = initHistory
local doPressInHistory = function(self)
  local function handler(x, y)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    for i = 1, #(hst or {}) do
      local icon = hst[i].iconBg
      if ed.containsPoint(icon, x, y) then
        icon:setScale(osc * 0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressInHistory = doPressInHistory
local function doClickInHistory(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
    if ed.containsPoint(icon, x, y) then
      lsr:report("clickHistoryNode")
      local delay = CCDelayTime:create(0)
      local func = CCCallFunc:create(function()
        xpcall(function()
          self:setHistory(id)
        end, EDDebug)
      end)
      local s = CCSequence:createWithTwoActions(delay, func)
      self.mainLayer:runAction(s)
    end
  end
  return handler
end
class.doClickInHistory = doClickInHistory
local cancelPressInHistory = function(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  return handler
end
class.cancelPressInHistory = cancelPressInHistory
local cancelClickInHistory = function(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  return handler
end
class.cancelClickInHistory = cancelClickInHistory
local createHistoryLayer = function(self)
  if self.draglist and not tolua.isnull(self.draglist.layer) then
    return self.draglist.listLayer
  end
  local config = {
    cliprect = CCRectMake(12, 300, 265, 80),
    container = self.craftWindow.mainLayer,
    zorder = 10,
    priority = -161,
    noshade = true,
    doClickIn = self:doClickInHistory(),
    cancelClickIn = self:cancelClickInHistory(),
    doPressIn = self:doPressInHistory(),
    cancelPressIn = self:cancelPressInHistory()
  }
  self.draglist = ed.draglist.create(config)
  return self.draglist.listLayer
end
class.createHistoryLayer = createHistoryLayer
local setHistoryListWidth = function(self, width)
  local lw = 265
  local pw = self.draglist.listWidth
  local ll = self.draglist.listLayer
  local px, py = ll:getPosition()
  self.draglist:initListWidth(width)
  ll:setPosition(px, py)
  if width > lw then
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(lw - width, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  else
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(0, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  end
end
class.setHistoryListWidth = setHistoryListWidth
local setHistory = function(self, index, id)
  self.history = self.history or {}
  index = index or 0
  local hst = self.history
  local cw = self.craftWindow
  local ori = ccp(55, 350)
  local offsetX = 58
  local len = #self.history
  local cursor
  local container = self:createHistoryLayer()
  if index == 0 or index > len then
    self.historyid = len + 1
    local iconBg, icon = ed.readequip.createSmallIcon(id)
    iconBg:setPosition(ori.x + offsetX * len, ori.y)
    self.hstIconScale = iconBg:getScale()
    local arrow
    if len > 0 then
      arrow = ed.createSprite("UI/alpha/HVGA/view_history_arrow.png")
      arrow:setPosition(ori.x + offsetX * (len - 0.5), ori.y)
    end
    local element = {
      id = id,
      iconBg = iconBg,
      icon = icon,
      arrow = arrow
    }
    hst[len + 1] = element
    if arrow then
      container:addChild(arrow)
    end
    container:addChild(iconBg)
    local action = CCFadeIn:create(0.5)
    iconBg:runAction(action)
    cursor = len + 1
    self:setHistoryListWidth(ori.x + offsetX * len + 30)
  elseif index <= len then
    self.historyid = index
    for i = index + 1, len do
      hst[i].iconBg:removeFromParentAndCleanup(true)
      if hst[i].arrow then
        hst[i].arrow:removeFromParentAndCleanup(true)
      end
      hst[i] = nil
    end
    self:createCraftTree(hst[index].id)
    cursor = index
    local x = hst[index].iconBg:getPositionX()
    self:setHistoryListWidth(x + 30)
  end
  if tolua.isnull(self.historyCursor) then
    local tag = ed.createSprite("UI/alpha/HVGA/equip_craft_select.png")
    self.historyCursor = tag
    container:addChild(tag, 10)
  end
  self.historyCursor:setPosition(ccp(ori.x + offsetX * (cursor - 1), ori.y - 5))
end
class.setHistory = setHistory
local fadeTreeElement = function(self, element, isClear)
  if isClear then
    local fade = CCFadeOut:create(0.1)
    local func = CCCallFunc:create(function()
      xpcall(function()
        element:removeFromParentAndCleanup(true)
        self:fadeTreeLayer(false)
      end, EDDebug)
    end)
    local s = CCSequence:createWithTwoActions(fade, func)
    element:runAction(s)
  else
    local action = CCFadeIn:create(0.3)
    element:runAction(action)
  end
end
class.fadeTreeElement = fadeTreeElement
local fadeTreeLayer = function(self, isClear)
  if not self.tree then
    return
  end
  local container = self.tree.layer
  self:fadeTreeElement(container, isClear)
  if isClear then
    self.tree = {}
  end
end
class.fadeTreeLayer = fadeTreeLayer
local initTree = function(self, id)
  self.tree = nil
end
class.initTree = initTree
local function createCraftTree(self, id, skipAnim)
  if not skipAnim then
    self:fadeTreeLayer(true)
  elseif self.tree and not tolua.isnull(self.tree.layer) then
    self.tree.layer:removeFromParentAndCleanup(true)
  end
  self.tree = {}
  self.getWayButton = {}
  local cw = self.craftWindow
  local layer = cw.mainLayer
  local components, category
  local row = ed.getDataTable("equipcraft")[id]
  if row then
    components = row.Components
    category = row.Category
  else
    components = 0
  end
  components = components or 0
  self.craftid = id
  self.components = components
  self.craftCategory = category
  local tree = CCSprite:create()
  self.tree.layer = tree
  tree:setCascadeOpacityEnabled(true)
  layer:addChild(tree)
  local childrenPos = {
    {
      ccp(142, 150)
    },
    {
      ccp(113, 150),
      ccp(171, 150)
    },
    {
      ccp(83, 150),
      ccp(141, 150),
      ccp(199, 150)
    },
    {
      ccp(55, 150),
      ccp(113, 150),
      ccp(171, 150),
      ccp(229, 150)
    }
  }
  local labelOffset = -30
  local lineres = {
    {
      res = "UI/alpha/HVGA/fragment_compose_arrow.png",
      rotation = -90
    },
    {
      res = "UI/alpha/HVGA/equip_craft_2.png"
    },
    {
      res = "UI/alpha/HVGA/equip_craft_3.png"
    },
    {
      res = "UI/alpha/HVGA/equip_craft_4.png"
    }
  }
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = ed.getDataTable("equip")[id].Name,
        size = 18
      },
      layout = {
        position = ccp(142, 292)
      },
      config = {
        color = ccc3(255, 0, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "craftButton",
        res = "UI/alpha/HVGA/package_button.png"
      },
      layout = {
        position = ccp(143, 45)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "craftButtonPress",
        res = "UI/alpha/HVGA/package_button_down.png"
      },
      layout = {
        position = ccp(143, 45)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(tree, self.tree)
  readNode:addNode(ui_info)
  if self.tree.name:getContentSize().width > 220 then
	  self.tree.name:setScale(220 / self.tree.name:getContentSize().width)
  end
  local rootBg = ed.readequip.createIcon(id, 60)
  rootBg:setPosition(ccp(141, 230))
  self.tree.rootBg = rootBg
  tree:addChild(rootBg, 1)
  local text = ""
  local expense
  if components > 0 then
    cw.nodeid = {}
    cw.nodeRepeat = {}
    cw.nodeAmount = {}
    cw.nodeNeed = {}
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "trunk",
          res = lineres[components].res
        },
        layout = {
          position = ccp(142, 190)
        },
        config = {
          rotation = lineres[components].rotation
        }
      }
    }
    readNode:addNode(ui_info)
    childrenPos = childrenPos[components]
    self.tree.children = {}
    self.tree.amountLabel = {}
    for i = 1, components do
      local id = row["Component" .. i]
      local need = math.max(row[string.format("Component%d Count", i)] or 1, 1)
      cw.nodeNeed[i] = need
      cw.nodeid[i] = id
      if i == 1 then
        cw.nodeRepeat[i] = 0
      end
      for j = 1, i - 1 do
        if cw.nodeid[j] == cw.nodeid[i] then
          cw.nodeRepeat[i] = (cw.nodeRepeat[i] or 0) + need
        else
          cw.nodeRepeat[i] = 0
        end
      end
      cw.nodeAmount[i] = ed.player.equip_qunty[cw.nodeid[i]] or 0
      if 0 >= cw.nodeAmount[i] - cw.nodeRepeat[i] then
        cw.nodeAmount[i] = 0
      end
      local childBg = ed.readequip.createIcon(id, 45)
      childBg:setPosition(childrenPos[i])
      self.tree.children[i] = childBg
      tree:addChild(childBg)
      local amount = cw.nodeAmount[i]
      if amount < 10000 then
        amount = amount or 0
        local amountLabel = ed.createttf("" .. amount, 18)
        if amount < cw.nodeNeed[i] then
          ed.setLabelColor(amountLabel, ccc3(255, 0, 0))
        else
          ed.setLabelColor(amountLabel, ccc3(50, 41, 31))
        end
        amountLabel:setPosition(ccp(childrenPos[i].x - amountLabel:getContentSize().width / 2, 115))
        self.tree.amountLabel[i] = amountLabel
        tree:addChild(amountLabel)
      end
      local text, pos
      if amount < 10000 then
        text = "/" .. need
        pos = ccp(childrenPos[i].x + 9, 115)
      else
        text = T(LSTR("EQUIPCRAFT.EQUIPPED"))
        pos = ccp(childrenPos[i].x, 115)
      end
      local amountNeed = ed.createttf(text, 18)
      ed.setLabelColor(amountNeed, ccc3(50, 41, 31))
      amountNeed:setPosition(pos)
      tree:addChild(amountNeed)
    end
    local sf = ed.getSpriteFrame("UI/alpha/HVGA/equip_craft_money_bg.png")
    local costBg = CCSprite:createWithSpriteFrame(sf)
    costBg:setPosition(142, 86)
    self.tree.costBg = costBg
    tree:addChild(costBg)
    local costTitle = ed.createttf(T(LSTR("EQUIPCRAFT.SYNTHESIS_COST_")), 18)
    ed.setLabelColor(costTitle, ccc3(50, 41, 31))
    costTitle:setPosition(ccp(100, 85))
    self.tree.costTitle = costTitle
    tree:addChild(costTitle)
    expense = row.Expense
    expense = expense or 99999999
    local cost = ed.createttf("" .. expense, 18)
    if expense <= (ed.player._money or 0) then
      ed.setLabelColor(cost, ccc3(155, 34, 14))
    else
      ed.setLabelColor(cost, ccc3(255, 0, 0))
    end
    cost:setPosition(ccp(200, 85))
    cw.expense = expense
    self.tree.cost = cost
    tree:addChild(cost)
    self.lackOfComponent = false
  else
    rootBg:setPosition(ccp(50, 250))
    rootBg:setScale(0.6)
    local bg = ed.createSprite("UI/alpha/HVGA/equip_craft_getway_bg.png")
    bg:setPosition(ccp(142, 177))
    tree:addChild(bg)
    local label = ed.createttf(T(LSTR("EQUIPCRAFT.WAY_TO_GET_")), 20)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(80, 250))
    ed.setLabelColor(label, ccc3(155, 34, 14))
    tree:addChild(label)
    local getway = {}
    local equipInfo = ed.getDataTable("equip")[id]
    local st = ed.getDataTable("Stage")
    for i = 1, 3 do
      local s = equipInfo["Drop " .. i]
      if s and s > 0 then --ray --Hide Stage > 13
        local row = st[s]
        local chapter = row["Chapter ID"]
        if chapter <= ed.GameConfig.MaxChapter then
          table.insert(getway, s)
        end
      end
    end
    self.getWayID = getway
    for i = 1, #getway do
      local id = getway[i]
      local board = ed.createSprite("UI/alpha/HVGA/equip_craft_getway_board.png")
      board:setPosition(ccp(142, 200 - 50 * (i - 1)))
      tree:addChild(board)
      board:setCascadeOpacityEnabled(true)
      local stageTable = ed.getDataTable("Stage")
      local row, isElite
      if id < 10000 then
        row = stageTable[id]
        isElite = false
      else
        local gid = stageTable[id]["Stage Group"]
        row = stageTable[gid]
        isElite = true
        id = gid
      end
      local stage = ed.createSprite(ed.ui.stageselectres.getStageIcon(id))
      stage:setPosition(ccp(35, 25))
      stage:setScale(75 / stage:getContentSize().width)
      board:addChild(stage)
      local title = ed.createttf(T(LSTR("EQUIPCRAFT._CHAPTER__D"), row["Chapter ID"]), 18)
      ed.setLabelColor(title, ccc3(182, 65, 21))
      title:setAnchorPoint(ccp(0, 0.5))
      title:setPosition(ccp(65, 35))
      board:addChild(title)
      if isElite then
        local elite = ed.createttf(T(LSTR("EQUIPCRAFT.ELITE")), 18)
        ed.setLabelColor(elite, ccc3(255, 0, 0))
        elite:setAnchorPoint(ccp(0, 0.5))
        elite:setPosition(ccp(75 + title:getContentSize().width, 35))
        board:addChild(elite)
      end
      local name = ed.createttf(row["Stage Name"], 18)
      ed.setLabelColor(name, ccc3(182, 65, 21))
      name:setAnchorPoint(ccp(0, 0.5))
      name:setPosition(ccp(68, 12))
	  local W = name:getContentSize().width
	  if  W > 160 then
		  local ww = 160 / W
		  name:setScale(ww)
	  end
      board:addChild(name)
      self.getWayButton[i] = board
    end
  end
  if components < 1 then
    text = T(LSTR("EQUIPCRAFT.RETURN"))
  else
    text = T(LSTR("EQUIPCRAFT.SYNTHESIS"))
  end
  local craftLabel = ed.createttf(text, 17, ed.selfFont)
  craftLabel:setPosition(ccp(143, 45))
  ed.setLabelColor(craftLabel, normalColor)
  self.tree.craftLabel = craftLabel
  tree:addChild(craftLabel)
  if expense then
    if expense > ed.player._money then
      self:forbidCraftButton(false)
    end
    for i = 1, #cw.nodeAmount do
      if cw.nodeAmount[i] < cw.nodeNeed[i] then
        self:forbidCraftButton(false)
        self.lackOfComponent = true
        break
      end
    end
  end
  if not skipAnim then
    tree:setOpacity(0)
  end
end
class.createCraftTree = createCraftTree
local checkExpenseHandler = function(self)
  local function handler()
    if self:checkMoneyEnough() then
      ed.setLabelColor(self.tree.cost, ccc3(202, 108, 60))
    else
      ed.setLabelColor(self.tree.cost, ccc3(255, 0, 0))
    end
  end
  return handler
end
class.checkExpenseHandler = checkExpenseHandler
local createCraftWindow = function(self)
  local sf = ed.getSpriteFrame("UI/alpha/HVGA/equip_craft_bg.png")
  local bg = CCSprite:createWithSpriteFrame(sf)
  bg:setPosition(ccp(400, 240))
  self.craftWindow = {}
  self.craftWindow.mainLayer = bg
  self.actionLayer:addChild(bg)
  self:createCraftTree(self.id)
  self.tree.layer:setOpacity(255)
  self:setHistory(0, self.id)
  local ml = CCMoveTo:create(0.2, ccp(252, 240))
  ml = CCEaseElasticOut:create(ml, 5)
  local mr = CCMoveTo:create(0.2, ccp(548, 240))
  mr = CCEaseElasticOut:create(mr, 5)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.craftWindow.mainLayer:setZOrder(2)
    end, EDDebug)
  end)
  self.equipLayer.ui.frame:runAction(ml)
  self.craftWindow.mainLayer:runAction(CCSequence:createWithTwoActions(mr, func))
end
class.createCraftWindow = createCraftWindow
local createPanel = function(self, equipid, level)
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -160, true)
  local actionLayer = CCLayer:create()
  self.actionLayer = actionLayer
  mainLayer:addChild(actionLayer)
  local equipLayer = ed.ui.equipboard.init("ofcraft", {id = equipid, level = level})
  self.equipLayer = equipLayer
  actionLayer:addChild(equipLayer.ui.frame, 1)
  mainLayer:registerScriptHandler(function(event)
    xpcall(function()
      if event == "enter" then
        self:createInfoButton()
      end
    end, EDDebug)
  end)
  self:show()
end
class.createPanel = createPanel
local createPutonTutorial = function(self)
  local hlv, elv = self:getJudgeLevel()
  if hlv < elv then
    return
  end
  ed.teach("equipProp", self.infoButton, {
    self.equipLayer.ui.frame,
    self.mainLayer
  })
end
class.createPutonTutorial = createPutonTutorial
local function create(config)
  local self = {}
  setmetatable(self, class.mt)
  config = config or {}
  self.config = config
  self.context = config.context
  if not self.context then
    print("you must set the context of the equip-craft window!")
    return
  end
  self.id = config.eid
  self.level = config.level
  self.isEquiped = config.isEquiped
  self.hid = config.hid
  self.sid = config.sid
  self.callback = config.callback
  self.hero = ed.player.heroes[self.hid]
  self.baseScene = ed.getCurrentScene()
  self:createPanel(self.id, self.level)
  return self
end
class.create = create
local getAmount = function(self)
  return ed.player.equip_qunty[self.id] or 0
end
class.getAmount = getAmount
local getComponents = function(self)
  local row = ed.getDataTable("equipcraft")[self.id]
  if row then
    return row.Components
  else
    return 0
  end
end
class.getComponents = getComponents
local function forbidInfoButton(self, forbid)
  if self.context == "handbook" then
    forbid = false
    return
  end
  local label = self.infoButtonLabel
  if forbid then
    ed.setLabelColor(label, pressColor)
  else
    ed.setLabelColor(label, normalColor)
  end
  self.isForbidInfoButton = forbid
end
class.forbidInfoButton = forbidInfoButton
local function forbidCraftButton(self, forbid)
  local label = self.tree.craftLabel
  if not forbid then
    ed.setLabelColor(label, normalColor)
  else
    ed.setLabelColor(label, pressColor)
  end
  self.isForbidCraftButton = forbid
end
class.forbidCraftButton = forbidCraftButton

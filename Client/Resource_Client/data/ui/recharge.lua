local ed = ed
local lsr = ed.ui.rechargelsr.create()
local class = {
  mt = {}
}
class.mt.__index = class
local recharge = class
local goodInfos
require "activity/ActiveRechargeRebate"
is_RechargeRebate = 0

local function checkHasLimitItem(self)
  local rt = ed.getDataTable("Recharge")
  for k, v in pairs(rt) do
    if type(k) == "number" then
      if  (v.Limit or 0) >0 and ed.player:checkRechargeItemValid(k) then
        return true
      end
    end
  end
  return false
end
class.checkHasLimitItem = checkHasLimitItem
local function getItems(self)
  local items = {}
  local rt = ed.getDataTable("Recharge")
  for k, v in pairs(rt) do
    if type(k) == "number" and ed.player:checkRechargeItemValid(k) then
      local t = {
        id = v.ID,
        type = v.Type,
        order = v.Order,
        title = v["Display Name"],
        cost = v.Cost,
        get = v["Get Diamond"],
        tag = v.Recommended,
        des = v.Description,
        icon = v.Icon,
        limit = v.Limit
      }
      if t.type == "MonthlyCard" and ed.player:isMonthCardValid(t.id) then
        t.des = T(LSTR("RECHARGE.MONTH_CARD_IS_IN_EFFECT_THE_REMAINING_D_DAYS"), ed.player:getMonthCardLeftTimes(t.id))
      end
      table.insert(items, t)
    end
  end
  self.items = items
  self:orderItems()
  goodInfos = self.items
end
class.getItems = getItems
local orderItems = function(self)
  local list = self.items
  for i = 1, #list do
    for j = i, 2, -1 do
        if list[j].order < list[j - 1].order then
        local t = list[j]
        list[j] = list[j - 1]
        list[j - 1] = t      
      end
    end
  end
end
class.orderItems = orderItems
local function createItems(self)
  if not tolua.isnull(self.itemContainer) then
    self.itemContainer:removeFromParentAndCleanup(true)
    self.itemContainer = nil
  end
  self:getItems()
  local boards = {}
  local ox, oy = 229, 270
  local dx, dy = 322, 97
  local function getpos(i)
    local x = (i - 1) % 2
    local y = math.floor((i - 1) / 2)
    return ox + dx * x, oy - dy * y
  end
  local listLayer = self.baseScene.draglist
  local container = CCLayer:create()
  self.itemContainer = container
  if not tolua.isnull(self.mainLayer) then
    self.mainLayer:addChild(container)
  end
  local items = self.items
  for i = 1, #items do
    local v = items[i]
    local board = ed.createSprite("UI/alpha/HVGA/recharge_list_bg.png")
    board:setPosition(ccp(getpos(i)))
    container:addChild(board)
    local titleBg = ed.createSprite("UI/alpha/HVGA/recharge_list_title_bg.png")
    titleBg:setAnchorPoint(ccp(0, 0.5))
    titleBg:setPosition(ccp(78, 68))
    board:addChild(titleBg)
    local icon = ed.createSprite(v.icon)
    icon:setPosition(ccp(47, 47))
    board:addChild(icon)
    local tag
    if v.tag and not self:checkHasLimitItem() then
      tag = ed.createSprite("UI/alpha/HVGA/recharge_recommended.png")
      tag:setAnchorPoint(ccp(0, 1))
      tag:setPosition(ccp(0, 97))
      board:addChild(tag)
    end
    local limit
    if v.limit == 1 then
      limit = ed.createSprite("UI/alpha/HVGA/recharge_recommended.png")
      limit:setAnchorPoint(ccp(0, 1))
      limit:setPosition(ccp(0, 97))
      board:addChild(limit)
    end
    local des
    if v.des then
      des = ed.createLabelTTF(v.des, 18)
      des:setAnchorPoint(ccp(0, 0.5))
      ed.setLabelColor(des, ccc3(0, 139, 16))
      des:setPosition(ccp(90, 34))
      board:addChild(des)
    end
    local title = ed.createLabelTTF(v.title, 17)
    title:setAnchorPoint(ccp(0, 0.5))
    title:setPosition(ccp(90, 68))
    if title:getContentSize().width > 135 then
      title:setScale(135 / title:getContentSize().width)
    end
	ed.setLabelColor(title, ccc3(66,45,28))
    ed.setLabelShadow(title, ccc3(0, 0, 0), ccp(0, 2))
    board:addChild(title)
    local readPrice = CCUserDefault:sharedUserDefault():getStringForKey("OC_SHOP_PRICE_"..v.id)
    local cost
    if string.len(readPrice) ~= 0 then
      cost = ed.createLabelTTF(readPrice, 17, nil, true)
    else
      cost = ed.createLabelTTF(T(LSTR("RECHARGE.$_F"), v.cost), 17, nil, true)
    end
    --cost = ed.createLabelTTF(T(LSTR("RECHARGE.$_F"), v.cost), 17, nil, true)
    cost:setAnchorPoint(ccp(1, 0.5))
    cost:setPosition(ccp(310, 68))
    ed.setLabelColor(cost, ccc3(33, 69, 173))
    board:addChild(cost)
    boards[i] = {
      item = v,
      board = board,
      icon = icon,
      tag = tag,
      titleBg = titleBg,
      title = title,
      cost = cost
    }
  end
  self.boards = boards
  local height = 99 * math.ceil(#items / 2)
  self.parent:initListHeight(height)
end
class.createItems = createItems
local function create(info)
  local self = {}
  setmetatable(self, class.mt)
  self.parent = info.parent
  self.baseScene = ed.getCurrentScene()
  local detailLayer = self.parent.detailLayer
  if detailLayer and not tolua.isnull(detailLayer.mainLayer) then
    detailLayer.mainLayer:removeFromParentAndCleanup(true)
    self.parent.detailLayer = nil
  end
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  self.parent.draglist.listLayer:addChild(mainLayer)
  self.parent.rechargeLayer = self
  self.ui = {}
  self:createItems()
  local listLayer = self.parent.draglist
  listLayer.doPressIn = self:doPressIn()
  listLayer.cancelPressIn = self:cancelPressIn()
  listLayer.doClickIn = self:doClickIn()
  listLayer.cancelClickIn = self:cancelClickIn()
  CloseEvent("QueryDataRsp")
  ListenEvent("QueryDataRsp", self:onQueryRsp())
  return self
end
class.create = create
local function doPressIn(self)
  local function handler(x, y)
    for i = 1, #self.boards do
      local board = self.boards[i].board
      if ed.containsPoint(board, x, y) then
        board:setScale(0.96)
        return i
      end
    end
  end
  return handler
end
class.doPressIn = doPressIn
local cancelPressIn = function(self)
  local function handler(x, y, id)
    local v = self.boards[id]
    local button = v.board
    button:setScale(1)
  end
  return handler
end
class.cancelPressIn = cancelPressIn
local function doClickIn(self)
  local function handler(x, y, id)
    local v = self.boards[id]
    local button = v.board
    button:setScale(1)
    if ed.containsPoint(button, x, y) then
      local info = v.item
      if info.type == "MonthlyCard" then
        local id = info.id
        if not ed.player:canMonthCardRenew(id) then
          ed.showToast(LSTR("RECHARGE.MONTH_CARD_CAN_BE_RENEWED_ONCE_THE_REMAINING_EFFECTIVE_TIME_IS_LESS_THEN_3_DAYS"))
          return
        end
      end
      self:doRecharge(info)
    end
  end
  return handler
end
class.doClickIn = doClickIn
local cancelClickIn = function(self)
  local function handler(x, y, id)
    local v = self.boards[id]
    local button = v.board
    button:setScale(1)
  end
  return handler
end
class.cancelClickIn = cancelClickIn
local recharge_item
local function reqRmbData()
  local msg = ed.upmsg.query_data()
  msg._type = {
    "rmb",
    "recharge",
    "monthcard"
  }
  if recharge_item ~= nil and recharge_item.type == "MonthlyCard" then
    msg._month_card_id = {
      recharge_item.id
  }
  end
  ed.send(msg, "query_data")
end
local closeQueryEvent = function()
  CloseEvent("QueryDataRsp")
end
local function onPayResult(sucess)
  reqRmbData()
  if rechargeRebateID == 1 then
	is_RechargeRebate = 1
	ed.ActiveRechargeRebatePage.create()
  end
  --ListenTimer(Timer:Times(5, 12), reqRmbData)
end
local onQueryRsp = function(self)
  local function handler(data)
    self.parent:refreshVipbar()
    self:createItems()
  end
  return handler
end
class.onQueryRsp = onQueryRsp
local function onChargeRsp(self)
  local function handler(data)
    print("do onchargersp")
    if data._charge_id then
      print("onChargeRsp   ........." .. data._charge_id)
    end
    if data._serial_id then
      print("data._serial_id ............  " .. data._serial_id)
    end
    local goodInfo
    for i, v in ipairs(goodInfos) do
      if v.id == data._charge_id then
        goodInfo = v
        break
      end
    end
    if goodInfo == nil then
      return
    end
    if 3 == LegendSDKType then
      LegendBuyDiamond(1, goodInfo.title, goodInfo.cost, data._serial_id, string.format("%s:%d:%s", game_server_ip, data._charge_id, ed.getUserid()))
    end
    --刷新连续充值页面
	local msg = ed.upmsg.continue_pay()
	msg._continue_pay = 1
	ed.send(msg, "continue_pay")
	
    if 117 == LegendSDKType then
      local pInfo = {
        id = ed.getUserid(),
        userid = ed.getDeviceId(),
        extraData = data._serial_id,
        item = data._charge_id,
        serverid = game_server_id,
        gameName = LSTR("RECHARGE.TURRET_LEGEND"),
        currentCost = goodInfo.cost,
        item = goodInfo.id,
        itemName = goodInfo.title,
        cost = goodInfo.cost
      }
      LegendAndroidPurchase(ed.getJson(pInfo))
    end
  end
  return handler
end
class.onChargeRsp = onChargeRsp
ListenEvent("91PayResult", onPayResult)
local function doRecharge(self, info)
  recharge_item = info
  CloseEvent("chargeRsp")
  ListenEvent("chargeRsp", self:onChargeRsp())
local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
	 scene:addChild(ed.ui.buyconfirm.create(info).mainLayer, 150)
	end
 

end
class.doRecharge = doRecharge
local function rechargeReplyHandler(self, info)
  local function handler(result)
    if not result then
      ed.showToast(LSTR("RECHARGE.UNSUCCESSFUL_CHARGE"))
      return
    end
    ed.showToast(T(LSTR("RECHARGE.SPEND_$_D_TO_GAIN__D_DIAMOND"), info.cost, info.get))
    self.parent:refreshVipbar()
  end
  return handler
end
class.rechargeReplyHandler = rechargeReplyHandler
local class = {
  mt = {}
}
class.mt.__index = class
local detail = class
local turnNextPage = function(self)
  self:setPage(self.currentVip + 1)
end
class.turnNextPage = turnNextPage
local turnPrePage = function(self)
  self:setPage(self.currentVip - 1)
end
class.turnPrePage = turnPrePage
local function setPage(self, vip)
  local info = self.parent:getVipInfo()
  if not info[vip] then
    return
  end
  if vip == self.currentVip then
    return
  end
  local dir
  if vip < self.currentVip then
    dir = "pre"
  else
    dir = "next"
  end
  self.currentVip = vip
  local ui = self.ui
  ed.setLabelString(ui.vip, vip)
  ed.setLabelString(ui.left_vip, vip - 1)
  ed.setLabelString(ui.right_vip, vip + 1)
  self:refreshLRButton()
  self:createDetail(dir)
end
class.setPage = setPage
local refreshLRButton = function(self)
  local v = self.currentVip
  local info = self.parent:getVipInfo()
  if not info[v - 1] then
    self.leftContainer:setVisible(false)
  else
    self.leftContainer:setVisible(true)
  end
  if not info[v + 1] then
    self.rightContainer:setVisible(false)
  else
    self.rightContainer:setVisible(true)
  end
end
class.refreshLRButton = refreshLRButton
local function createLRButton(self)
  local v = self.currentVip
  local container = self.mainLayer
  local leftContainer = CCSprite:create()
  local rightContainer = CCSprite:create()
  container:addChild(leftContainer)
  container:addChild(rightContainer)
  local ui = self.ui
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "left_title",
        text = LSTR("RECHARGE.VIEW"),
        size = 20
      },
      layout = {
        position = ccp(95, 228)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "left_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png"
      },
      layout = {
        position = ccp(85, 200)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "left_vip",
        text = v - 1,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(105, 200)
      },
      config = {
        color = ccc3(255, 248, 164)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "left",
        res = "UI/alpha/HVGA/resume_battle.png"
      },
      layout = {
        position = ccp(96, 160)
      },
      config = {flip = "x", fix_height = 55}
    },
    {
      t = "Sprite",
      base = {
        name = "left_press",
        res = "UI/alpha/HVGA/resume_battle_press.png",
        parent = "left"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {flip = "x", visible = false}
    }
  }
  local readNode = ed.readnode.create(leftContainer, ui)
  readNode:addNode(ui_info)
  self.leftContainer = leftContainer
  ui_info = {
    {
      t = "Label",
      base = {
        name = "right_title",
        text = LSTR("RECHARGE.VIEW"),
        size = 20
      },
      layout = {
        position = ccp(682, 228)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "right_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png"
      },
      layout = {
        position = ccp(675, 200)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "right_vip",
        text = v + 1,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(690, 200)
      },
      config = {
        color = ccc3(255, 248, 164)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "right",
        res = "UI/alpha/HVGA/resume_battle.png"
      },
      layout = {
        position = ccp(685, 160)
      },
      config = {fix_height = 55}
    },
    {
      t = "Sprite",
      base = {
        name = "right_press",
        res = "UI/alpha/HVGA/resume_battle_press.png",
        parent = "right"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode = ed.readnode.create(rightContainer, ui)
  readNode:addNode(ui_info)
  self.rightContainer = rightContainer
end
class.createLRButton = createLRButton
local function getKeys(self)
  if self.keys_pre and self.keys_mid and self.keys_post then
    return self.keys_pre, self.keys_mid, self.keys_post
  else
    local prv = ed.getDataTable("Privilege")
    local list_pre = {}
    local list_mid = {}
    local list_post = {}
    for k, v in pairs(prv) do
      if type(k) == "number" and v.Display then
        table.insert(list_pre, {
          id = k,
          key = v.Name,
          detail = v["Pre Display"]
        })
        table.insert(list_mid, {
          id = k,
          key = v.Name,
          detail = v["Mid Display"]
        })
        table.insert(list_post, {
          id = k,
          key = v.Name,
          detail = v["Post Display"]
        })
      end
    end
    for i = 1, #list_pre do
      for j = i, 2, -1 do
        if list_pre[j].id < list_pre[j - 1].id then
          local t = list_pre[j]
          list_pre[j] = list_pre[j - 1]
          list_pre[j - 1] = t
        end
      end
    end
    for i = 1, #list_mid do
      for j = i, 2, -1 do
        if list_mid[j].id < list_mid[j - 1].id then
          local t = list_mid[j]
          list_mid[j] = list_mid[j - 1]
          list_mid[j - 1] = t
        end
      end
    end
    for i = 1, #list_post do
      for j = i, 2, -1 do
        if list_post[j].id < list_post[j - 1].id then
          local t = list_post[j]
          list_post[j] = list_post[j - 1]
          list_post[j - 1] = t
        end
      end
    end
    self.keys_pre = list_pre
    self.keys_mid = list_mid
    self.keys_post = list_post
    return list_pre, list_mid, list_post
  end
end
class.getKeys = getKeys
local function getDetail(self)
  local ks_pre, ks_mid, ks_post = self:getKeys()
  local vt = ed.getDataTable("VIP")
  local row = vt[self.currentVip]
  local prerow = vt[self.currentVip - 1]
  local details_pre = {}
  local details_mid = {}
  local details_post = {}
  for i = 1, #ks_pre do
    local k = ks_pre[i].key
    local d = ks_pre[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_pre, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_pre, d)
    end
  end
  for i = 1, #ks_mid do
    local k = ks_mid[i].key
    local d = ks_mid[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_mid, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_mid, string.format(d, v))
    end
  end
  for i = 1, #ks_post do
    local k = ks_post[i].key
    local d = ks_post[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_post, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_post, d)
    end
  end
  if self.currentVip > 1 then
    table.insert(details_pre, 2, LSTR("RECHARGE.INCLUDE"))
    table.insert(details_mid, 2, string.format("VIP%d", self.currentVip - 1))
    table.insert(details_post, 2, LSTR("RECHARGE.ALL_LEVEL_PRIVILEGES"))
  end
  return details_pre, details_mid, details_post
end
class.getDetail = getDetail
local function createDetail(self, dir)
  local oh = 0
  local details_pre, details_mid, details_post = self:getDetail()
  local vip = self.currentVip
  local preContainer
  if not tolua.isnull(self.detailContainer) then
    preContainer = self.detailContainer
    self.detialContainer = nil
  end
  local container = CCSprite:create()
  self.detailContainer = container
  self.clipLayer:addChild(container)
  local ox, oy = 175, 255
  local dy = 25
  local icon_len = 80
  oy = oy - oh
  local sumbefore = {}
  for i = 1, #details_pre do
    local label = ed.createLabelTTF(details_pre[i], 18)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(ox, oy - dy * (i - 1)))
    ed.setLabelColor(label, ccc3(239, 197, 121))
    container:addChild(label)
    sumbefore[i] = label:getContentSize().width
  end
  for i = 1, #details_mid do
    local label = ed.createLabelTTF(details_mid[i], 18)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(ox + sumbefore[i] + 3, oy - dy * (i - 1)))
    ed.setLabelColor(label, ccc3(255, 241, 215))
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
    container:addChild(label)
    sumbefore[i] = sumbefore[i] + label:getContentSize().width
  end
  for i = 1, #details_post do
    local label = ed.createLabelTTF(details_post[i], 18)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(ox + sumbefore[i] + 6, oy - dy * (i - 1)))
    ed.setLabelColor(label, ccc3(239, 197, 121))
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
    container:addChild(label)
    sumbefore[i] = sumbefore[i] + label:getContentSize().width
  end
  if preContainer then
    local gap = 500
--    if dir ~= "pre" or not ccp(-gap, 0) then
--    end
    container:setPosition((dir == "pre" and  ccp(-gap, 0) or ccp(gap, 0)))
--    if dir ~= "pre" or not ccp(gap, 0) then
--    end
    local m1 = CCMoveTo:create(0.2, dir == "pre" and ccp(gap, 0) or  (ccp(-gap, 0)))
    m1 = CCEaseSineOut:create(m1)
    local f1 = CCCallFunc:create(function()
      xpcall(function()
        preContainer:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    local s1 = CCSequence:createWithTwoActions(m1, f1)
    preContainer:runAction(s1)
    local m2 = CCMoveTo:create(0.2, ccp(0, 0))
    m2 = CCEaseSineOut:create(m2)
    container:runAction(m2)
  end
  self.detailList:initListHeight(dy * #details_pre + 50 + oh)
end
class.createDetail = createDetail
local function createClipLayer(self)
  local info = {
    cliprect = CCRectMake(160, 0, 465, 282),
    container = self.mainLayer,
    noshade = true
  }
  local list = ed.draglist.create(info)
  self.detailList = list
  self.clipLayer = list:getList()
  self.listTouch = list:getListLayerTouchHandler()
end
class.createClipLayer = createClipLayer
local function create(info)
  local self = {}
  setmetatable(self, class.mt)
  info = info or {}
  self.baseScene = ed.getCurrentScene()
  self.parent = info.parent
  local showVip = info.showVip
  local vip = info.vip
  self.vip = vip
  vip = vip or ed.player:getvip()
  self.parent.detailLayer = self
  local rechargeLayer = self.parent.rechargeLayer
  if rechargeLayer and not tolua.isnull(rechargeLayer.mainLayer) then
    rechargeLayer.mainLayer:removeFromParentAndCleanup(true)
    self.parent.rechargeLayer = nil
  end
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  local currentVip = showVip or ed.player:getvip()
  self.currentVip = math.max(currentVip, 1)
  local maxvip = ed.playerlimit.maxVipLevel()
  self.currentVip = math.min(self.currentVip, maxvip)
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/act/act_popup_bg.png"
      },
      layout = {
        position = ccp(390, 300)
      },
      config = {
        fix_size = CCSizeMake(620, 34)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "vip_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png"
      },
      layout = {
        position = ccp(330, 300)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "vip",
        text = self.currentVip,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(352, 301)
      },
      config = {
        color = ccc3(255, 248, 164)
      }
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = LSTR("RECHARGE.LEVEL_PRIVILEGES"),
        size = 20
      },
      layout = {
        position = ccp(420, 300)
      },
      config = {
        color = ccc3(231, 206, 19)
      }
    }
  }
  local readNode = ed.readnode.create(mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createClipLayer()
  self:createLRButton()
  self:createDetail()
  self:refreshLRButton()
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -195, false)
  self.parent.draglist.listLayer:addChild(mainLayer)
  return self
end
class.create = create
local function refreshGiftButton(self)
  local ui = self.ui
  local button = ui.gift
  if ed.player:checkvipGiftValid(self.currentVip) then
    button:setVisible(true)
  else
    button:setVisible(false)
  end
end
class.refreshGiftButton = refreshGiftButton
local function doGetvipGiftReply(self, vip)
  local function handler(result)
    if not result then
      ed.showToast(LSTR("DAILYLOGIN.FAILED_TO_RECEIVE"))
    else
      self:refreshGiftButton()
      local items = {}
      local gt = ed.player:getvipGift(vip) or {}
      for i = 1, #gt do
        local g = gt[i]
        table.insert(items, {
          type = g.type,
          id = g.id,
          amount = g.amount
        })
      end
      ed.announce({
        type = "getProp",
        param = {
          title = T(LSTR("RECHARGE.VIP_D_PACK_AWARDS"), vip),
          alignment = "left",
          items = items
        }
      })
    end
  end
  return handler
end
class.doGetvipGiftReply = doGetvipGiftReply
local function doClickvipGift(self)
  ed.netdata.getvipGift = {
    vip = self.currentVip
  }
  ed.netreply.getvipGift = self:doGetvipGiftReply(self.currentVip)
  local msg = ed.upmsg.get_vip_gift()
  msg._vip = self.currentVip
  ed.send(msg, "get_vip_gift")
end
class.doClickvipGift = doClickvipGift
local function dovipGiftButtonTouch(self)
  local isPress
  local function handler(event, x, y)
    local ui = self.ui
    local button = ui.gift
    local press = ui.gift_press
    if tolua.isnull(button) then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        self:doClickvipGift()
      end
    end
  end
  return handler
end
class.dovipGiftButtonTouch = dovipGiftButtonTouch
local function createGiftDetail(self, param)
  self:destroyGiftDetail()
  local icon = param.icon
  local id = param.id
  local pos = icon:getParent():convertToWorldSpace(ccp(icon:getPosition()))
  local panel = ed.ui.equipableList.create(id, ccpAdd(pos, ccp(35, -5)))
  self.parent.mainLayer:addChild(panel.mainLayer)
  self.giftDetail = panel
  self.giftDetailPanel = panel.mainLayer
end
class.createGiftDetail = createGiftDetail
local destroyGiftDetail = function(self)
  if not tolua.isnull(self.giftDetailPanel) then
    self.giftDetailPanel:removeFromParentAndCleanup(true)
  end
end
class.destroyGiftDetail = destroyGiftDetail
local function dovipGiftTouch(self)
  local px, py
  local function handler(event, x, y)
    local icons = self.giftIcons or {}
    if event == "began" then
      for i = 1, #icons do
        local ic = icons[i]
        if ed.containsPoint(ic.icon, x, y) then
          self:createGiftDetail(ic)
        end
      end
      px = x
      py = y
    elseif event == "moved" then
      local dis = ccpDistanceSQ(ccp(x, y), ccp(px, py))
      if dis > 50 then
        self:destroyGiftDetail()
      end
    elseif event == "ended" then
      self:destroyGiftDetail()
      px = nil
      py = nil
    end
  end
  return handler
end
class.dovipGiftTouch = dovipGiftTouch
local function doLeftTouch(self)
  local isPress
  local container = self.leftContainer
  local button = self.ui.left
  local press = self.ui.left_press
  local function handler(event, x, y)
    if not container:isVisible() then
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
          self:turnPrePage()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doLeftTouch = doLeftTouch
local function doRightTouch(self)
  local isPress
  local container = self.rightContainer
  local button = self.ui.right
  local press = self.ui.right_press
  local function handler(event, x, y)
    if not container:isVisible() then
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
          self:turnNextPage()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doRightTouch = doRightTouch
local doMainLayerTouch = function(self)
  local leftTouch = self:doLeftTouch()
  local rightTouch = self:doRightTouch()
  local function handler(event, x, y)
    xpcall(function()
      leftTouch(event, x, y)
      rightTouch(event, x, y)
      self.listTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.recharge = class
local resetListTouch = function(self)
  local list = self.draglist
  list.doPressIn = nil
  list.cancelPressIn = nil
  list.doClickIn = nil
  list.cancelPressIn = nil
  list:initListHeight(0)
end
class.resetListTouch = resetListTouch
local function doClickSwitch(self)
  self.type = self.type == "recharge" and "detail" or "recharge"
  local ui = self.ui
  local sl = ui.switch_label
  local st = self.type == "recharge" and LSTR("RECHARGE.PRIVILEGE") or LSTR("RECHARGE.CHARGE")
  ed.setLabelString(sl, st)
  self:resetListTouch()
  if self.type == "recharge" then
    recharge.create({parent = self})
  elseif self.type == "detail" then
    detail.create({
      parent = self,
      vip = ed.player:getvip()
    })
  end
end
class.doClickSwitch = doClickSwitch
local function doSwitchTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.switch
  local press = ui.switch_press
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
          self:doClickSwitch()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doSwitchTouch = doSwitchTouch
local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.close_press
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
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local switchTouch = self:doSwitchTouch()
  local function handler(event, x, y)
    xpcall(function()
      closeTouch(event, x, y)
      switchTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function createListLayer(self, type)
  local info = {
    cliprect = CCRectMake(0, 30, 800, 295),
    rect = CCRectMake(80, 28, 620, 299),
    container = self.animLayer,
    priority = -195,
    bar = {
      bglen = 265,
      bgpos = ccp(65, 175)
    }
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local initListHeight = function(self, height)
  local ll = self.draglist
  ll:initListHeight(height)
end
class.initListHeight = initListHeight
local function getVipInfo(self)
  local info = {}
  local vt = ed.getDataTable("VIP")
  local index = 1
  while vt[index] do
    local row = vt[index]
    info[index] = row.Recharge
    index = index + 1
  end
  return info
end
class.getVipInfo = getVipInfo
local stopRefreshVipbar = function(self)
  self.baseScene:removeUpdateHandler("refreshVipbar")
end
class.stopRefreshVipbar = stopRefreshVipbar
local function refreshVipbarHandler(self)
  local vip, ne, me = ed.player:getvip()
  ed.setLabelString(self.vipui.need, ne)
  local c = self.currentVip
  local cv, cn, cm = c.vip, c.ne, c.me
  local vinfo = self:getVipInfo()
  local speed = math.max(cm / 1, 600)
  local function handler(dt)
    cn = cn - speed * dt
    if cn <= 0 then
      local pv = cv
      cv = math.min(cv + 1, vip)
      cm = vinfo[cv + 1] or vinfo[cv]
      local isMax = false
      if not vinfo[cv + 1] then
        isMax = true
      end
      if pv < cv and not isMax then
        cn = ne
        speed = math.max(cm / 1, 600)
      else
        cn = 0
      end
    end
    if cn > cm then
      cn = cm
    end
    if cv == vip and cn <= ne then
      cn = ne
      self:stopRefreshVipbar()
    end
    self.currentVip = {
      vip = cv,
      ne = cn,
      me = cm
    }
    local isMax
    if vinfo[cv + 1] then
      isMax = false
    elseif cn == 0 then
      isMax = true
    end
    local info = {
      v = cv,
      ce = cm - cn,
      me = cm,
      nv = vinfo[cv + 1] and cv + 1 or cv,
      isMax = isMax
    }
    self:refreshVipLabel(info)
  end
  return handler
end
class.refreshVipbarHandler = refreshVipbarHandler
local refreshVipbar = function(self)
  if not self.currentVip then
    return
  end
  self.baseScene:registerUpdateHandler("refreshVipbar", self:refreshVipbarHandler())
end
class.refreshVipbar = refreshVipbar
local refreshNextDetailPos = function(self)
  local ox, oy = 445, 347
  local ui = self.vipui
  local title, need, rmbIcon, title2, vipIcon, nvip = ui.title, ui.need, ui.rmbIcon, ui.title2, ui.vipIcon, ui.nvip
  title:setPosition(ccp(ox, oy))
  local w = title:getContentSize().width
  ox = ox + w + 5
  w = need:getContentSize().width / 2
  ox = ox + w
  need:setPosition(ccp(ox, oy))
  ox = ox + w
  rmbIcon:setPosition(ccp(ox, oy))
  ox = ox + 10
  title2:setPosition(ccp(ox, oy))
  w = title2:getContentSize().width
  ox = ox + w + 5
  vipIcon:setPosition(ccp(ox, oy))
  w = vipIcon:getContentSize().width
  ox = ox + w + 5
  w = nvip:getContentSize().width / 2
  ox = ox + w
  nvip:setPosition(ox, oy)
end
class.refreshNextDetailPos = refreshNextDetailPos
local function refreshVipLabel(self, info)
  local ui = self.vipui
  local v, ce, me, nv = info.v, info.ce, info.me, info.nv
  local isMax = info.isMax
  if not isMax then
    local vip = ui.vip
    local nvip = ui.nvip
    local barLabel = ui.bar_label
    local bar = ui.bar
    ce = math.floor(ce)
    ed.setLabelString(vip, v)
    ed.setLabelString(nvip, nv)
    ed.setLabelString(barLabel, string.format("%d/%d", ce, me))
    if not tolua.isnull(bar) then
      bar:setTextureRect(CCRectMake(0, 0, 306 * ce / me, 26))
    end
    self:refreshNextDetailPos()
  else
    self:createVipbar()
  end
end
class.refreshVipLabel = refreshVipLabel
local function createNextDetail(self)
  if not tolua.isnull(self.ndContainer) then
    self.ndContainer:removeFromParentAndCleanup(true)
    self.ndContainer = nil
  end
  local container = CCSprite:create()
  self.ndContainer = container
  self.vipContainer:addChild(container)
  local ui = self.vipui
  local vip, ne, me = ed.player:getvip()
  self.currentVip = {
    vip = vip,
    ne = ne,
    me = me
  }
  local title = ed.createLabelTTF(LSTR("RECHARGE.CHARGE_ANOTHER"), 18)
  title:setAnchorPoint(ccp(0, 0.5))
  container:addChild(title)
  ui.title = title
  local need = ed.createLabelTTF(ne, 18)
  local w = need:getContentSize().width / 2
  container:addChild(need)
  ed.setLabelColor(need, ccc3(175, 247, 90))
  ui.need = need
  local rmbIcon = ed.createSprite("UI/alpha/HVGA/shop_token_icon.png")
  rmbIcon:setAnchorPoint(ccp(0, 0.5))
	rmbIcon:setVisible(false)
  rmbIcon:setScale(22 / rmbIcon:getContentSize().height)
  container:addChild(rmbIcon)
  ui.rmbIcon = rmbIcon
  local title2 = ed.createLabelTTF(LSTR("RECHARGE.CAN_BECOME"), 18)
  title2:setAnchorPoint(ccp(0, 0.5))
  container:addChild(title2)
  ui.title2 = title2
  local nvipIcon = ed.createSprite("UI/alpha/HVGA/recharge_vip_icon.png")
  nvipIcon:setAnchorPoint(ccp(0, 0.5))
  container:addChild(nvipIcon)
  ui.vipIcon = nvipIcon
  local nvip = ed.createLabelTTF(vip + 1, 16)
  local w = nvip:getContentSize().width / 2
  container:addChild(nvip)
  ed.setLabelColor(nvip, ccc3(255, 248, 164))
  ui.nvip = nvip
  self:refreshNextDetailPos()
end
class.createNextDetail = createNextDetail
local function createVipbar(self)
  if not tolua.isnull(self.vipContainer) then
    self.vipContainer:removeFromParentAndCleanup(true)
    self.vipContainer = nil
  end
  local container = CCSprite:create()
  self.animLayer:addChild(container)
  self.vipContainer = container
  local vip, ne, me = ed.player:getvip()
  local ox, oy = 180, 347
  if ne == 0 then
    ox = 240
  end
  self.vipui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "vip_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png"
      },
      layout = {
        position = ccp(ox, oy)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "vip",
        text = vip,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(ox + 20, oy)
      },
      config = {
        color = ccc3(255, 248, 164)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar_bg",
        res = "UI/alpha/HVGA/recharge_vip_progress_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(ox + 40, oy)
      },
      config = {
        scalexy = {x = 0.70}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar",
        res = "UI/alpha/HVGA/recharge_vip_progress.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(ox + 40, oy)
      },
      config = {
        scalexy = {x = 0.70},
        textureRect = CCRectMake(0, 0, 306 * (me - ne) / me, 26)
      }
    },
    {
      t = "Label",
      base = {
        name = "bar_label",
        text = string.format("%d/%d", me - ne, me),
        size = 18
      },
      layout = {
        position = ccp(ox + 158, oy - 1)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, self.vipui)
  readNode:addNode(ui_info)
  if ne ~= 0 then
    self:createNextDetail()
  end
end
class.createVipbar = createVipbar
local function create(info)
  local self = {}
  setmetatable(self, class.mt)
  info = info or {}
  local type = info.type or "recharge"
  local callback = info.callback
  local showVip = info.showVip
  self.baseScene = ed.getCurrentScene()
  self.type = type
  self.callback = callback
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  local animLayer = CCLayer:create()
  animLayer:setAnchorPoint(ccp(0.5, 0.5))
  mainLayer:addChild(animLayer)
  self.animLayer = animLayer
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/recharge_frame.png"
      },
      layout = {
        position = ccp(390, 198)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(730, 358)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        parent = "close"
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
        name = "switch",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(115, 345)
      },
      config = {
        scaleSize = CCSizeMake(95, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "switch_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(115, 345)
      },
      config = {
        scaleSize = CCSizeMake(95, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "switch_label",
        text = type == "recharge" and LSTR("RECHARGE.PRIVILEGE") or LSTR("RECHARGE.CHARGE"),
        fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(115, 344)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  local readNode = ed.readnode.create(animLayer, self.ui)
  readNode:addNode(ui_info)
  self:createVipbar()
  self:createListLayer(type)
  if type == "recharge" then
    recharge.create({parent = self})
  elseif type == "detail" then
    detail.create({parent = self, showVip = showVip})
  end
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -190, true)
  self:show()
  return self
end
class.create = create
local show = function(self)
  self:refreshClipRect()
  self.animLayer:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:stopRefreshClipRect()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  self.animLayer:runAction(s)
end
class.show = show
local function destroy(self)
  self:refreshClipRect()
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
      self:stopRefreshClipRect()
      self:stopRefreshVipbar()
      ed.ui.baselsr.create():report("closeRechargeWindow")
      if self.callback then
        self.callback()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  self.animLayer:runAction(s)
  closeQueryEvent()
end
class.destroy = destroy
local refreshClipRectHandler = function(self)
  local function handler()
    if not tolua.isnull(self.animLayer) then
      self.draglist:refreshClipRect(self.animLayer:getScale())
    end
    if self.detailLayer and not tolua.isnull(self.detailLayer.mainLayer) then
      self.detailLayer.detailList:refreshClipRect(self.animLayer:getScale())
    end
  end
  return handler
end
class.refreshClipRectHandler = refreshClipRectHandler
local refreshClipRect = function(self)
  self.baseScene:registerUpdateHandler("refreshClipRect", self:refreshClipRectHandler())
end
class.refreshClipRect = refreshClipRect
local stopRefreshClipRect = function(self)
  self:refreshClipRectHandler()()
  self.baseScene:removeUpdateHandler("refreshClipRect")
end
class.stopRefreshClipRect = stopRefreshClipRect
local function getAllItemsID()
  local rt = ed.getDataTable("Recharge")
  local itemLIist = ""
  for k, v in pairs(rt) do
    if type(k) == "number" then
        if string.len(itemLIist) > 0 then
          itemLIist = itemLIist..":"
        end
        itemLIist =itemLIist..v.ID
    end
  end
  return itemLIist
end
class.getAllItemsID = getAllItemsID

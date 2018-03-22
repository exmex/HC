local base = ed.ui.framework
local class = newclass(base.mt)
ed.ui.shop = class
local lsr = ed.ui.shoplsr.create()
local config = ed.ui.marketconfig
local showTutorialHandler = function(self)
  local isSellout = true
  for k, v in pairs(self.goods) do
    if v.data.amount > 0 then
      isSellout = false
      break
    end
  end
  if isSellout then
    ed.teach("refreshShop", self.ui.refresh, self.mainLayer)
  end
end
class.showTutorialHandler = showTutorialHandler
local function showTalk(self, key, callback)
  local str = ed.ui.market.getTalkContent(self.shop, key)
  if not str then
    return
  end
  if not tolua.isnull(self.talkBg) then
    self.talkBg:removeFromParentAndCleanup(true)
  end
  str = str or ""
  local bg = ed.createNode({
    t = "Sprite",
    config = {isCascadeOpacity = true}
  }, self.container, 60)
  self.talkBg = bg
  local frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = config.getuiConfig(self.shop).talkBgRes,
      capInsets = CCRectMake(30, 15, 110, 26)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(190, 360)
    },
    config = {isCascadeOpacity = true}
  }, bg)
  local talk = ed.createNode({
    t = "Label",
    base = {text = str, size = 20},
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, frame:getContentSize().height / 2)
    }
  }, frame)
  local size = talk:getContentSize()
  frame:setContentSize(CCSizeMake(size.width + 30, 56))
  local delay = CCDelayTime:create(1)
  local action = CCFadeOut:create(1)
  local remove = CCCallFunc:create(function()
    xpcall(function()
      if self then
        bg:removeFromParentAndCleanup(true)
        if callback then
          callback()
        end
      end
    end, EDDebug)
  end)
  bg:runAction(ed.readaction.create({
    t = "seq",
    delay,
    action,
    remove
  }))
end
class.showTalk = showTalk
local function refreshCostLabel(self)
  for k, v in pairs(self.goods or {}) do
    local data = v.data
    if not tolua.isnull(v.ui.costLabel) then
      local color = config.getuiConfig(self.shop).costLabelColor
      if data.amount >= 1 and not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
        color = ccc3(255, 0, 0)
      end
      ed.setLabelColor(v.ui.costLabel, color)
    end
  end
end
class.refreshCostLabel = refreshCostLabel
local refreshCostHandler = function(self)
  local function handler()
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:refreshCostColor()
    end
    self:refreshCostLabel()
  end
  return handler
end
class.refreshCostHandler = refreshCostHandler
local function refreshGoods(self, result, index)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if result then
    lsr:report("buySuccess")
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:destroy()
    end
    local goods = self.goods[index]
    goods.data.amount = 0
    goods.ui.noneTag:setVisible(true)
    self:refreshCostLabel()
    if config.hasRefreshButton(self.shop) then
      self:showTutorialHandler()
    end
  else
    lsr:report("buyFailed")
  end
  self:showTalk("Purchase")
  if config.willAutoExit(self.shop) and ed.player:checkShopGoodsEmpty(self.shop) then
    self:showTalk("Expire", function()
      ed.popScene()
    end)
  end
end
class.refreshGoods = refreshGoods
local buyReply = function(self)
  local refreshData = function(result, data)
    if result and data then
      local shop = data.shop
      local goods = data.goods
      ed.player:addEquip(goods.id, goods.amount)
      ed.player:addPoint(goods.pay, -goods.cost)
      ed.player:buyShopGoods(shop, goods.slot)
    end
  end
  local function handler(result, data)
    refreshData(result, data)
    self:refreshGoods(result, data.goods.index)
  end
  return handler
end
class.buyReply = buyReply
local upBuy = function(self, data)
  ed.registerNetReply("shop_consume", self:buyReply(), {
    shop = self.shop,
    goods = data
  })
  local msg = ed.upmsg.shop_consume()
  msg._sid = self.shop
  msg._slotid = data.slot
  msg._amount = data.amount
  ed.send(msg, "shop_consume")
end
class.upBuy = upBuy
local function doBuy(self, data)
  local function handler()
    if config.checkPackageFull(data.id, data.amount) then
      ed.showToast(T(LSTR("SHOP.YOUR_PACKAGE_DOESNT_HAVE_ENOUGH_SPACE")))
    elseif not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
      if data.pay == "gold" then
        ed.showHandyDialog("useMidas", {
          callback = self:refreshCostHandler(),
          refreshHandler = self:refreshCostHandler()
        })
      elseif data.pay == "diamond" then
        ed.showHandyDialog("toRecharge", {
          callback = self:refreshCostHandler()
        })
      elseif data.pay == "crusadepoint" then
        ed.showToast(T(LSTR("SHOP.INSUFFIENT_INTERFAX_COINS_THUS_YOU_CAN_NOT_BUY")))
      elseif data.pay == "arenapoint" then
        ed.showToast(T(LSTR("SHOP.INSUFFIENT_GLADIATOR_COINS_THUS_YOU_CAN_NOT_BUY")))
      elseif data.pay == "guildpoint" then
        ed.showToast(T(LSTR(LSTR("shop.1.10.1.001"))))
      end
    else
      self:upBuy(data)
    end
  end
  return handler
end
class.doBuy = doBuy
local function doPressInProduct(self)
  local function handler(x, y)
    local parent = self.draglist.listLayer
    for i, v in ipairs(self.goods or {}) do
      local st = config.getBuyType(self.shop)
      if st == "coin" then
        local panel = v.ui.panel
        if ed.containsPoint(panel, x, y, parent) then
          panel:setScale(0.95)
          return i
        end
      elseif st == "stone" then
        local panel = v.ui.item_bg
        if ed.containsPoint(panel, x, y, parent) then
          v.ui.item_press:setVisible(true)
          return i
        end
      end
    end
  end
  return handler
end
class.doPressInProduct = doPressInProduct
local function cancelPressInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    local ui = self.goods[id].ui
    if st == "coin" then
      ui.panel:setScale(1)
    elseif st == "stone" then
      ui.item_press:setVisible(false)
    end
  end
  return handler
end
class.cancelPressInProduct = cancelPressInProduct
local function cancelClickInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    local ui = self.goods[id].ui
    if st == "coin" then
      ui.panel:setScale(1)
    elseif st == "stone" then
      ui.item_press:setVisible(false)
    end
  end
  return handler
end
class.cancelClickInProduct = cancelClickInProduct
local function doClickInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    local layer = self.draglist.listLayer
    local ui = self.goods[id].ui
    local data = self.goods[id].data
    if data.amount <= 0 then
      self:showTalk("Soldout")
      return
    end
    if st == "coin" then
      local panel = ui.panel
      panel:setScale(1)
      if self.isAutoRefreshing then
        return
      end
      if ed.containsPoint(panel, x, y, layer) then
        self:openBuyPanel(id)
      end
    elseif st == "stone" then
      ui.item_press:setVisible(false)
      if ed.containsPoint(ui.item_bg, x, y, layer) then
        if not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
          ed.showToast(T(LSTR("SHOP.SOUL_STONE_QUANTITY_IS_INSUFFICIENT_YOU_CANNOT_BUY_")))
        else
          ed.ui.starshopbuywindow.create({
            sid = self.shop,
            slotid = id,
            data = self.goods[id].data,
            addition = self.goods[id].addition,
            callback = function(result)
              self:refreshGoods(result, id)
            end
          })
        end
      end
    end
  end
  return handler
end
class.doClickInProduct = doClickInProduct
local doSendRefresh = function(self)
  self:showTalk("Refresh")
  ed.registerNetReply("refresh_shop", self:refreshList({from = "refresh"}), {
    id = self.shop,
    type = 2
  })
  local msg = ed.upmsg.shop_refresh()
  msg._type = 2
  msg._shop_id = self.shop
  ed.send(msg, "shop_refresh")
end
class.doSendRefresh = doSendRefresh
local function doRefresh(self)
  local function handler()
    ed.endTeach("refreshShop")
    if config.canRefresh(self.shop) then
      self:doSendRefresh()
    end
  end
  return handler
end
class.doRefresh = doRefresh
local function doClickRefresh(self)
  lsr:report("clickRefresh")
  local shoprefreshcost = ed.player:getShopRefreshCost(self.shop)
  local refreshcoinname = config.getRefreshCoinName(self.shop)
  local refreshshoptimes = ed.player:getRefreshShopTimes(self.shop)
  local info = {
    text = T(LSTR("SHOP.SPEND_XXX_TO_REFRESH"), shoprefreshcost, refreshcoinname, refreshshoptimes),
    rightHandler = self:doRefresh()
  }
  ed.showConfirmDialog(info)
end
class.doClickRefresh = doClickRefresh
local openBuyPanel = function(self, id)
  local data = self.goods[id].data
  if self.buyLayer and not self.buyLayer:checknull() then
    self.buyLayer:destroy({skipAnim = true})
  end
  data.doBuy = self:doBuy(data)
  self.buyLayer = ed.ui.equipboard.init("ofbuy", data)
  self.scene:addChild(self.buyLayer.mainLayer, 110)
  self.buyLayer:show()
end
class.openBuyPanel = openBuyPanel
local function createCommon(self)
  local goods = {}
  local container = self.listContainer
  local equipInfo = ed.getDataTable("equip")
  local shopData = ed.player:getShopGoods(self.shop)
  for k, v in pairs(shopData or {}) do
    local tag, slot
    local isShowHotTag = config.isShowHotTag(self.shop)
    if isShowHotTag == true then
      slot = v.slot
      tag = v.tag
      v = v.good
    elseif isShowHotTag == false then
      slot = v.slot
      v = v.good
    end
    local info = equipInfo[v._id]
    if info and info.Icon then
      table.insert(goods, {
        data = {
          index = #goods + 1,
          id = v._id,
          pay = v._type,
          payid = nil,
          price = v._price,
          amount = v._amount,
          cost = v._price * math.max(v._amount, 1),
          slot = slot or k,
          res = info.Icon,
          name = info.Name,
          tag = tag,
          category = info.Category,
          sale = v._is_sale
        },
        ui = {}
      })
    end
  end
  local function getItemPos(index)
--    local ox = #goods > 6 and 180 or 195
--    local oy = 256
--    local dx, dy = 205, 145
--    local x = ox + dx * 3 * math.floor((index - 1) / 6) + dx * math.floor((index % 6 - 1) % 3)
--    local y = oy - dy * math.floor((index - 1) % 6 / 3)
--    return ccp(x, y)

    local lineCount = math.ceil((#goods)/2)
    local dx, dy = 185, 150
    local x, y = 0, 0
    local oy = 256
    if index <= lineCount then
        x = dx + (index-1)*205
        y = oy
    else
        x = dx + (index - lineCount-1)*205
        y = oy-dy
    end
    return ccp(x, y)
  end
  local function getListWidth()
--    local ox = 200
--    local dx = 205
--    local offset_x = 20
--    if #goods % 6 >= 3 then
--      return ox + dx * 3 * math.floor((#goods - 1) / 6) + dx * 2 + offset_x
--    else
--      return ox + dx * 3 * math.floor((#goods - 1) / 6) + dx * math.floor((#goods % 6 - 1) % 3) + offset_x
--    end
    local lineCount = math.ceil((#goods)/2)
    return lineCount*205 + 35
  end
  for i = 1, #goods do
    local data = goods[i].data
    local ui = goods[i].ui
    local nameText = 1 < data.amount and data.name .. " x " .. data.amount or data.name
    local tagRes = config.getHotTagRes(data.tag)
    ui.panel = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).productBgRes
      },
      layout = {
        position = getItemPos(i)
      },
      config = {isCascadeOpacity = true}
    }, container)
    if ed.isComplexText(nameText) then
    ui.name = ed.createNode({
        t = "ComplexLabel",
      base = {text = nameText, size = 20},
      layout = {
        position = ccp(100, 125)
      },
      config = {
        color = ccc3(69, 59, 56)
      }
    }, ui.panel)
    else
      ui.name = ed.createNode({
        t = "Label",
        base = {text = nameText, size = 20},
        layout = {
          position = ccp(100, 125)
        },
        config = {
          color = ccc3(69, 59, 56)
        }
      }, ui.panel)
    end
    ui.icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIconWithAmount(data.id, nil, data.amount)
      },
      layout = {
        position = ccp(100, 75)
      }
    }, ui.panel)
    ui.coinIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getCoinRes(data.pay)
      },
      layout = {
        position = ccp(40, 25)
      }
    }, ui.panel)
    ui.costLabel = ed.createNode({
      t = "Label",
      base = {
        text = tostring(data.cost),
        size = 20
      },
      layout = {
        position = ccp(110, 25)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    if data.sale == 1 then
      ui.saleIcon = ed.createNode({
        t = "Sprite",
        base = {
          res = config.scaleIcon
        },
        layout = {
          position = ccp(75, 50)
        }
      }, ui.panel)
    end
    if tagRes then
      ui.tagIcon = ed.createNode({
        t = "Sprite",
        base = {res = tagRes},
        layout = {
          position = ccp(55, 55)
        }
      }, ui.panel)
    end
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).noneTagRes
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = 1 > data.amount
      }
    }, ui.panel)
    
    local tName = ed.createttf(nameText, 20)
    local ow = 190
    local w = ui.name:getContentSize().width
    if ow < w then
      ui.name:setScale(ow / w)
    end
  end
  self.draglist:initListWidth(getListWidth())
  return goods
end
class.createCommon = createCommon
local function createStarList(self)
  local goods = {}
  local ox, oy = 90, 35
  local dx, dy = 212, 282
  local function getItemPos(index)
    return ccp(ox + dx * (index - 1), oy)
  end
  local function getListWidth()
    local len = #goods
    if len <= 3 then
      if len == 1 then
        goods[1].ui.container:setPosition(ccp(ox + dx, oy))
      elseif len == 2 then
        goods[1].ui.container:setPosition(ccp(ox + dx * 0.5, oy))
        goods[2].ui.container:setPosition(ccp(ox + dx * 1.5, oy))
      end
      return 0
    else
      return dx * len + 40
    end
  end
  local layer = self.listContainer
  local gd = ed.player:getShopGoods(self.shop)
  for i, v in ipairs(gd) do
    goods[i] = {
      data = {
        pay = "stone",
        box = v._type,
        payid = v._stone_id,
        price = v._stone_amount,
        cost = v._stone_amount,
        amount = v._amount
      },
      addition = {
        name = config.getStarGoodsName(v._type)
      },
      ui = {}
    }
    local container, ui = ed.editorui(ed.uieditor.itemstarshop)
    goods[i].ui = ui
    ed.createNode({
      t = "CCNode",
      base = {node = container},
      layout = {
        position = getItemPos(i)
      }
    }, layer)
    ui.item_icon = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getStarGoodsRes(v._type)
      },
      layout = {
        anchor = ccp(0, 0)
      }
    }, ui.item_icon_container)
    ui.stone_icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIcon(v._stone_id, 46)
      },
      layout = {
        anchor = ccp(0, 0)
      }
    }, ui.stone_container)
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).noneTagRes
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = v._amount < 1
      }
    }, ui.item_bg, 10)
    local stoneName = ui.stone_name
    ed.setString(stoneName, "x" .. v._stone_amount)
    stoneName:setPosition(ccpAdd(ccp(stoneName:getPosition()), ccp(30, 0)))
    ui.costLabel = stoneName
    ed.setString(ui.item_name, config.getStarGoodsName(v._type))
  end
  self.draglist:initListWidth(getListWidth())
  return goods
end
class.createStarList = createStarList
local function listCreate(self, shop, addition)
  addition = addition or {}
  local from = addition.from
  if self.listContainer then
    do
      local element = self.listContainer
      self.listContainer = nil
      if from == "refresh" then
        local action = CCFadeOut:create(0.5)
        local remove = CCCallFunc:create(function()
          xpcall(function()
            element:removeFromParentAndCleanup(true)
            if self.listContainer then
              self.listContainer:runAction(CCFadeIn:create(0.2))
            end
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(action, remove)
        if not tolua.isnull(element) then
          element:runAction(sequence)
        end
      else
        self.listNeedFade = nil
        if not tolua.isnull(element) then
          element:removeFromParentAndCleanup(true)
        end
      end
    end
  end
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  if not tolua.isnull(self.draglist.listLayer) then
   self.draglist.listLayer:addChild(container)
  end
  self.listContainer = container
  local goodsType = config.getGoodsType(self.shop)
  if goodsType == "coin" then
    self.goods = self:createCommon()
  elseif goodsType == "stone" then
    self.goods = self:createStarList()
  end
  self:refreshCostLabel()
  if self.listNeedFade then
    container:setOpacity(0)
  else
    self.listNeedFade = true
  end
end
class.listCreate = listCreate
local function timeRefresh(self)
  local count = 0
  local tc = 0
  local tcgap = 0
  self.isAutoRefreshing = nil
  local timeType = ed.player:checkShopTimeType(self.shop)
  local function time(dt)
    count = count + dt
    if count >= 1 then
      count = count - 1
      local time = ed.player:getShopShowTime(self.shop)
      tc = time + tcgap
      time = math.max(time, 0)
      if timeType == "expire" then
        ed.setString(self.ui.time, ed.gethmsNString(time))
      end
      local state = ed.player:checkShopTimeType(self.shop)
      if state == "refresh" then
        if tc <= 0 then
          if not self.isAutoRefreshing and self.buyLayer and not self.buyLayer:checknull() then
            self.buyLayer:destroy()
          end
          self.isAutoRefreshing = true
          if tc < -2 then
            tcgap = tcgap + 60
            ed.registerNetReply("refresh_shop", self:refreshList({from = "refresh"}), {
              id = self.shop,
              state = 1
            })
            local msg = ed.upmsg.shop_refresh()
            msg._type = 1
            msg._shop_id = self.shop
            ed.send(msg, "shop_refresh")
          end
        else
          self.isAutoRefreshing = nil
        end
      end
      if tc < 0 and state == "expire" then
        self:showTalk("Expire")
        local handler = function()
          ed.popScene()
        end
        local text = T(LSTR("SHOP.THE_MYSTERIOUS_BUSINESSMAN_HAS_DRIFTED_AWAY_PLEASE_BE_QUICK_NEXT_TIME"))
        ed.showAlertDialog({text = text, handler = handler})
        self:removeUpdateHandler("refreshTime")
      end
    end
  end
  return time
end
class.timeRefresh = timeRefresh
local enterRefresh = function(self)
  ed.registerNetReply("refresh_shop", self:refreshList(), {
    id = self.shop,
    type = 1
  })
  local msg = ed.upmsg.shop_refresh()
  msg._type = 1
  msg._shop_id = self.shop
  ed.send(msg, "shop_refresh")
end
class.enterRefresh = enterRefresh
local refreshList = function(self, addition)
  local function handler()
    addition = addition or {}
    local from = addition.from
    if not self then
      return
    end
    self:listCreate(self.shop, addition)
    local timeType = ed.player:checkShopTimeType(self.shop)
    if timeType == "refresh" then
      local nextTime = ed.player:getShopNextAutoRefreshPointDesc(self.shop)
      ed.setString(self.ui.time, nextTime)
    elseif timeType == "expire" then
      local time = ed.player:getShopShowTime(self.shop)
      time = math.max(time, 0)
      ed.setString(self.ui.time, ed.gethmsNString(time))
    end
    self:registerUpdateHandler("refreshTime", self:timeRefresh())
    if not ed.isElementInTable(self.shop, {"starshop"}) then
      self:showTutorialHandler()
    end
  end
  return handler
end
class.refreshList = refreshList
local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(65, 35, 670, 325),
    noshade = ed.isElementInTable(id, {"starshop"}),
    container = self.container,
    doClickIn = self:doClickInProduct(),
    cancelClickIn = self:cancelClickInProduct(),
    doPressIn = self:doPressInProduct(),
    cancelPressIn = self:cancelPressInProduct()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local getTimeTitle = function(self)
  local state = ed.player:checkShopTimeType(self.shop)
  local timeTitle = T(LSTR("SHOP.NEXT_AUTOMATICALLY_REFRESH_TIME"))
  local timeTitleSuffix = ""
  if state == "refresh" then
    timeTitle = T(LSTR("SHOP.NEXT_AUTOMATICALLY_REFRESH_TIME"))
    timeTitleSuffix = ""
  elseif state == "expire" then
    timeTitle = T(LSTR("SHOP.MERCHANT_LEAVES_AFTER"))
    timeTitleSuffix = T(LSTR("SHOP.TIMES"))
  end
  return timeTitle, timeTitleSuffix
end
class.getTimeTitle = getTimeTitle
--create shop scene with id, eg. 7 means guild shop
local function create(id)
  id = id or 1
  local self = base.create("shop", {
    shopName = config.getShopName(id)
  })
  setmetatable(self, class.mt)
  self.shop = id
  local mainLayer = self.mainLayer
  local container = CCLayer:create()
  self.container = container
  self.infoLayer:addChild(container, 20)
  local ui = self.ui
  local timeTitle, timeTitleSuffix = self:getTimeTitle()
  local ui_config = config.getuiConfig(self.shop)
  local readNode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = ui_config.frameRes
      },
      layout = {
        position = ui_config.framePos
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title",
        res = ui_config.titleRes,
        z = 5
      },
      layout = {
        position = ui_config.titlePos
      }
    },
    {
      t = "HorizontalNode",
      base = {
        name = "time_title_node",
        nodeArray = ui
      },
      layout = {
        position = ccp(400, 350)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "time_title",
            text = timeTitle,
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "time",
            text = "00:00:00",
            size = 16,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(219, 199, 168)
          }
        },
        {
          t = "Label",
          base = {
            name = "time_suffix",
            text = timeTitleSuffix,
            size = 18,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        }
      }
    }
  }
  if ui_config.headRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "head",
        res = ui_config.headRes,
        z = 20
      },
      layout = {
        position = ui_config.headPos
      }
    })
  end
  if ui_config.titleBgRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = ui_config.titleBgRes
      },
      layout = {
        position = ui_config.titlePos
      }
    })
  end
  if config.hasRefreshButton(self.shop) then
    local temp_info = {
      {
        t = "Sprite",
        base = {
          name = "refresh",
          res = "UI/alpha/HVGA/shop_refresh_button.png"
        },
        layout = {
          position = ccp(580, 350)
        },
        config = { scale = 1 }
      },
      {
        t = "Sprite",
        base = {
          name = "refresh_down",
          res = "UI/alpha/HVGA/shop_refresh_button_down.png",
          parent = "refresh"
        },
        layout = {mediate = true},
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "refresh_label",
          res = "UI/alpha/HVGA/shop_refresh_label.png",
          parent = "refresh",
          z = 3
        },
        layout = {mediate = true}
      },
      {
        t = "Sprite",
        base = {
          name = "refresh_label_down",
          res = "UI/alpha/HVGA/shop_refresh_label_down.png",
          parent = "refresh",
          z = 3
        },
        layout = {mediate = true},
        config = {visible = false}
      }
    }
    for i = 1, #temp_info do
      table.insert(ui_info, temp_info[i])
    end
  end
  readNode:addNode(ui_info)
  self:createListLayer()
  self:showTalk("Welcome")
  if self.shop == 1 then
    ed.tutorial.tell("aboutShop", self.mainLayer)
    ed.endTeach("aboutShop")
  else
    ed.tutorial.tell("aboutSpecialShop", self.mainLayer)
    ed.endTeach("aboutSpecialShop")
  end
  self:btRegisterButtonClick({
    button = self.ui.refresh,
    press = {
      self.ui.refresh_down,
      self.ui.refresh_label_down
    },
    key = "refresh_button",
    clickHandler = function()
      self:doClickRefresh()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.head,
    key = "head_button",
    clickHandler = function()
      self:showTalk("Touch")
    end
  })
  if id == "starshop" then
    self:btRegisterRectClick({
      rect = CCRectMake(95, 330, 110, 100),
      key = "head_rect",
      clickHandler = function()
        self:showTalk("Touch")
      end
    })
  end
  self:registerOnEnterHandler("enterShop", self:onEnterShop())
  return self
end
class.create = create
local openShopReplyHandler = function(self)
  local function handler(result)
    if result then
      local handler = self:refreshList()
      handler()
    else
      local info = {
        text = T(LSTR("SHOP.STORE_IS_NOT_OPEN")),
        handler = function()
          ed.popScene()
        end
      }
      ed.showAlertDialog(info)
    end
  end
  return handler
end
class.openShopReplyHandler = openShopReplyHandler
local function checkOpenShop(self)
  if config.needOpen(self.shop) then
    local iv = ed.player:checkShopValid(self.shop)
    if not iv then
      ed.netreply.openShop = self:openShopReplyHandler()
      local msg = ed.upmsg.open_shop()
      msg._shopid = self.shop
      ed.send(msg, "open_shop")
    else
      local handler = self:refreshList()
      handler()
    end
  else
    local handler = self:refreshList()
    handler()
  end
end
class.checkOpenShop = checkOpenShop
local function onEnterShop(self)
  local function handler()
    self:checkOpenShop()
    if config.needEnterRefresh(self.shop) then
      self:enterRefresh()
    end
    if config.needFastSell(self.shop) then
      ed.ui.fastsell.pop({
        callback = self:refreshCostHandler()
      }, 200)
    end
  end
  return handler
end
class.onEnterShop = onEnterShop

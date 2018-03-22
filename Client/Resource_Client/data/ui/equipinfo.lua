local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipinfo = class
local function create(id, hasCloseButton)
  local self = {}
  setmetatable(self, class.mt)
  self.id = id
  local bg = ed.createSprite("UI/alpha/HVGA/package_detail_bg.png")
  self.bg = bg
  bg:setCascadeOpacityEnabled(true)
  if hasCloseButton then
    local readnode = ed.readnode.create(bg, self)
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "close",
          res = "UI/alpha/HVGA/herodetail-detail-close.png"
        },
        layout = {
          position = ccp(286, 358)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "closePress",
          res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
          parent = "close"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      }
    }
    readnode:addNode(ui_info)
  end
  return self
end
class.create = create
local function createContainer(self, config)
  local id = config.id
  local withName = config.withName
  local level = config.level
  id = id or self.id
  if not id then
    return
  end
  if self.container and not tolua.isnull(self.container) then
    self.container:removeFromParentAndCleanup(true)
  end
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(3, 0))
  self.bg:addChild(container)
  container:setCascadeOpacityEnabled(true)
  self.container = container
  self.ui = {}
  if id then
    if 0 < (level or 0) then
      self.ui.icon = ed.readequip.createIconWithLevel(id, level or 0)
    else
      self.ui.icon = ed.readequip.createIcon(id)
    end
  end
  if self.ui.icon then
    self.ui.icon:setPosition(ccp(49, 328))
    self.container:addChild(self.ui.icon)
  end
  if withName then
    local name = ed.readequip.value(id, "Name")
    self.ui.name = ed.createttf(name, 24)
    self.ui.name:setAnchorPoint(ccp(0, 0.5))
    self.ui.name:setPosition(ccp(90, 345))
    ed.setLabelShadow(self.ui.name, ccc3(0, 0, 0), ccp(0, 2))
    container:addChild(self.ui.name)
    if self.ui.name:getContentSize().width > 160 then
      self.ui.name:setScale(160 / self.ui.name:getContentSize().width)
    end
    if level then
      local level_des = ed.ui.baseres.enhance_level_res
      local text = ""
      if ed.readequip.getMaxLevel(id) > 1 then
        text = T(LSTR("EQUIPINFO.UNENCHANTED"))
      end
      if level >= 1 then
        text = level_des[level] or ""
      end
      local lvLabel = ed.createttf(text, 16)
      ed.setLabelColor(lvLabel, ccc3(67, 59, 56))
      --ed.setLabelShadow(lvLabel, ccc3(0, 0, 0), ccp(0, 2))
      lvLabel:setAnchorPoint(ccp(0, 0.5))
      lvLabel:setPosition(ccp(90, 309))
      container:addChild(lvLabel)
      self.ui.level = lvLabel
    end
  end
end
class.createContainer = createContainer
local function createDescription(self, id, level)
  local sf = ed.getSpriteFrame("UI/alpha/HVGA/package_detail_bg_2.png")
  local detailBg = CCScale9Sprite:createWithSpriteFrame(sf, CCRectMake(10, 10, 230, 120))
  detailBg:setAnchorPoint(ccp(0.5, 1))
  detailBg:setPosition(ccp(143.5, 287))
  self.detailBg = detailBg
  self.container:addChild(detailBg)
  local descri, addDes, sufDes = ed.readequip.getDescription(id, level)
  local amount = ed.player.equip_qunty[id] or 0
  local isFragment, needAmount, universalAmount, universalTotalAmount, universalNeedAmount, isFragmentEnough
  local isAttDes = true
  if ed.readequip.value(id, "Description") then
    isAttDes = nil
    descri = {}
    descri[1] = ed.readequip.value(id, "Description")
    local info = ed.readequip.getFragmentAmount(id)
    isFragment = info.isFragment
    needAmount = info.need
    universalAmount = info.ufcan
    universalTotalAmount = info.uftotal
    universalNeedAmount = info.ufneed
    if isFragment then
      local max = 3
      if amount >= needAmount then
        max = 2
        isFragmentEnough = true
      else
        max = 3
      end
      if self.context == "buy" then
        max = 2
      end
      for i = 1, max do
        table.insert(descri, " ")
      end
    end
  end
  self.descri = descri
  self.isFragmentEnough = isFragmentEnough
  if #descri < 5 and not isFragment then
    table.insert(self.descri, " ")
  end
  local height = 8
  for i = 1, #descri do
    local label = ed.createttf(descri[i], 16)
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(ccp(20, 292 - height))
    ed.setLabelColor(label, ccc3(255, 217, 153))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
    if not isAttDes then
      label:setDimensions(CCSizeMake(232, 0))
    end
    self.ui["att" .. i] = label
    self.container:addChild(label)
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 1))
    local lh = label:getContentSize().height
    height = height + lh
    if addDes[i] then
      local al = ed.createttf(addDes[i], 16)
      al:setAnchorPoint(ccp(0, 1))
      al:setPosition(ed.getRightSidePos(label, 2))
      self.container:addChild(al)
      ed.setLabelColor(al, ccc3(0, 255, 0))
      ed.setLabelShadow(al, ccc3(0, 0, 0), ccp(0, 1))
      self.ui["addatt" .. i] = al
      if sufDes[i] then
        local sl = ed.createttf(sufDes[i], 16)
        sl:setAnchorPoint(ccp(0, 1))
        sl:setPosition(ed.getRightSidePos(al))
        self.container:addChild(sl)
        ed.setLabelColor(sl, ccc3(255, 217, 153))
        ed.setLabelShadow(sl, ccc3(0, 0, 0), ccp(0, 1))
        self.ui["sufatt" .. i] = sl
      end
    end
  end
  self.descriHeight = height
  if isFragment then
    local ua = 0
    if universalNeedAmount < needAmount - amount then
      ua = universalNeedAmount
    else
      ua = needAmount - amount
    end
    local ui_info = {}
    local findex, uindex
    findex = #descri
    if not isFragmentEnough then
    end
    local title = {
      t = "Label",
      base = {
        name = "fragment_title",
        text = T(LSTR("EQUIPINFO.SYNTHESIS_REQUIRES_FRAGMENT_")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(25, self.ui["att" .. findex]:getPositionY())
      },
      config = {
        color = ccc3(255, 217, 153),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
    local text = {
      t = "Label",
      base = {
        name = "fragment_amount",
        text = string.format("%d/%d", amount, needAmount),
        size = 16
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(160, self.ui["att" .. findex]:getPositionY())
      },
      config = {
        color = ccc3(255, 217, 153),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
    table.insert(ui_info, title)
    table.insert(ui_info, text)
    local readNode = ed.readnode.create(self.container, self.ui)
    readNode:addNode(ui_info)
  end
  local bw = self.detailBg:getContentSize().width
  local bh = self.detailBg:getContentSize().height
  local oriScaleY = 1
  self.detailBgScale = oriScaleY
  self.detailBgSize = CCSizeMake(bw, height * oriScaleY)
  self.detailBg:setContentSize(self.detailBgSize)
end
class.createDescription = createDescription
local function createDetail(self, id)
  local detail = ed.readequip.value(id, "Comment")
  detail = detail or " "
  local label = ed.createttf(detail, 18)
  label:setAnchorPoint(ccp(0, 1))
  label:setPosition(ccp(16, 278 - self.descriHeight))
  label:setDimensions(CCSizeMake(252, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
  self.container:addChild(label)
  ed.setLabelColor(label, ccc3(67, 59, 56))
  self.ui.detail = label
end
class.createDetail = createDetail
local createTouchLayer = function(self, handler)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = layer
  layer:setTouchEnabled(true)
  layer:registerScriptTouchHandler(handler, false, -130, true)
  self.bg:setPosition(ccp(380, 240))
  layer:addChild(self.bg)
  layer:setVisible(false)
  self:show()
end
class.createTouchLayer = createTouchLayer
local isShow = function(self)
  return self.mainLayer:isVisible()
end
class.isShow = isShow
local function show(self)
  ed.playEffect(ed.sound.sellProp.openWindow)
  self.bg:setScale(0)
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:setVisible(true)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  self.bg:runAction(action)
end
class.show = show
local function hide(self)
  ed.playEffect(ed.sound.buyProp.closeWindow)
  local action = CCScaleTo:create(0.2, 0)
  action = CCEaseBackIn:create(action)
  local sequence = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        self.mainLayer:setTouchEnabled(false)
        self.mainLayer:setVisible(false)
      end
    end, EDDebug)
  end))
  self.bg:runAction(sequence)
  if self.hideHandler then
    self.hideHandler()
  end
end
class.hide = hide
local hideInfo = function(self)
  if self.container then
    self.container:setVisible(false)
  end
end
class.hideInfo = hideInfo
local showInfo = function(self)
  if self.container then
    self.container:setVisible(true)
  end
end
class.showInfo = showInfo
local function doCloseTouch(self)
  local isPress
  local button = self.close
  local press = self.closePress
  local function handler(event, x, y)
    xpcall(function()
      if not self.close:isVisible() then
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
            self:hide()
          end
        end
        isPress = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doCloseTouch = doCloseTouch
class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipinfoforcommon = class
local base = ed.ui.equipinfo
setmetatable(class, base.mt)
local fadeInfo = function(self, isFadeOut)
  if not self.ui then
    return
  end
  if isFadeOut and self.container then
    do
      local fadeOut = CCFadeOut:create(0.1)
      local element = self.container
      local action = CCSequence:createWithTwoActions(fadeOut, CCCallFunc:create(function()
        xpcall(function()
          element:removeAllChildrenWithCleanup(true)
        end, EDDebug)
      end))
      element:runAction(action)
      return true
    end
  else
    self.container:setOpacity(0)
    local fadeIn = CCFadeIn:create(0.1)
    self.container:runAction(fadeIn)
  end
end
class.fadeInfo = fadeInfo
local function getInformation(self, id)
  self.amount = ed.player.equip_qunty[id] or 0
  self.amountColor = ccc3(0, 71, 188)
  if amount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
end
class.getInformation = getInformation
local function create(config)
  config = config or {}
  local id = config.id
  local isShow = config.isShow
  local level = config.level
  local self = base.create(id, false)
  setmetatable(self, class.mt)
  self:setInfo(config)
  return self
end
class.create = create
local function setInfo(self, config)
  local id = config.id
  local isShow = config.isShow
  local level = config.level
  local hasInit = self:fadeInfo(true)
  if not id then
    return
  end
  self.context = "comon"
  self.explanation = "package"
  self.id = id
  self:getInformation(id)
  self:createContainer({
    id = id,
    withName = true,
    level = level
  })
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.HAVE")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = self.amount,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(190, 309)
      },
      config = {
        color = self.amountColor
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_title_suffix",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(165, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:createDescription(id, level)
  --self:createDetail(id)  ray 暂时取消道具描述显示 2014-06-30
  if self.bg:getOpacity() < 255 then
    self.bg:setOpacity(255)
  end
  if not isShow then
    self:fadeInfo(false)
  end
end
class.setInfo = setInfo
local function refreshAmount(self)
  local amount = ed.player.equip_qunty[self.id] or 0
  self:setAmount(amount)
  return amount
end
class.refreshAmount = refreshAmount
local function setAmount(self, amount)
  amount = amount or 0
  ed.setString(self.ui.amount_label, amount)
  local amountColor = ccc3(0, 71, 188)
  if amount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
  ed.setLabelColor(self.ui.amount_label, amountColor)
  local info = ed.readequip.getFragmentAmount(self.id)
  local isFragment = info.isFragment
  local needAmount = info.need
  local universalAmount = info.ufcan
  local universalTotalAmount = info.uftotal
  local universalNeedAmount = info.ufneed
  local ua = 0
  if universalNeedAmount < needAmount - amount then
    ua = universalNeedAmount
  else
    ua = needAmount - amount
  end
  if isFragment then
    ed.setString(self.ui.fragment_amount, string.format("%d/%d", amount, needAmount))
    local uAmountLabel = self.ui.universal_amount
    if not tolua.isnull(uAmountLabel) then
      ed.setString(self.ui.universal_amount, string.format("%d/%d", universalTotalAmount, ua))
    end
  end
  local isFragmentEnough = amount >= needAmount
  if not isFragment or not isFragmentEnough or self.isFragmentEnough or self.context ~= "buy" then
  end
  if not isFragment or isFragmentEnough or self.isFragmentEnough then
  end
end
class.setAmount = setAmount
local function changeAmountTitle(self, str)
  self.ui.amount_label:setVisible(false)
  local title
  if str then
    title = str
  else
    title = ""
  end
  ed.setString(self.ui.amount_title, title)
  self.ui.amount_title_suffix:setVisible(false)
end
class.changeAmountTitle = changeAmountTitle
local function resetAmountTitle(self, str)
  self.ui.amount_label:setVisible(true)
  ed.setString(self.ui.amount_title, T(LSTR("EQUIPINFO.HAVE")))
  self.ui.amount_title_suffix:setVisible(true)
end
class.resetAmountTitle = resetAmountTitle
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipinfoforbuy = class
local base = ed.ui.equipinfo
setmetatable(class, base.mt)
local function refreshCostColor(self)
  local info = self.info
  local md = info.pay == 1 and ed.player._money or ed.player._rmb
  if md < self.cost then
    self.costColor = ccc3(255, 0, 0)
  else
    self.costColor = ccc3(251, 206, 16)
  end
  ed.setLabelColor(self.ui.money, self.costColor)
end
class.refreshCostColor = refreshCostColor
local function getInformation(self, info)
  if not info then
    return false
  end
  self.info = info
  self.id = info.id
  self.amount = info.amount
  self.price = info.price
  self.pay = info.pay
  self.cost = info.price * math.max(info.amount, 1)
  self.iconRes = ed.readequip.value(self.id, "Icon")
  self.name = ed.readequip.value(self.id, "Name")
  if info.amount > 1 then
    self.name = self.name .. " x " .. info.amount
  end
  self.hasAmount = ed.player.equip_qunty[info.id] or 0
  self.goldRes = ed.ui.marketconfig.getCoinRes(self.pay)
  local amountColor = ccc3(0, 71, 188)
  if self.amount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
  self.amountColor = amountColor
  if not ed.ui.marketconfig.checkMoneyEnough(self.pay, self.cost) then
    self.costColor = ccc3(255, 0, 0)
  else
    self.costColor = ccc3(251, 206, 16)
  end
end
class.getInformation = getInformation
local function create(info)
  local self = base.create(info.id, true, info.nokeypad)
  setmetatable(self, class.mt)
  self.context = "buy"
  self.explaination = "shop"
  if not info then
    return
  end
  self:setInfo(info)
  local handler = self:doMainLayerTouch()
  self:createTouchLayer(handler)
  return self
end
class.create = create
local function setInfo(self, info)
  self:createContainer({
    id = info.id,
    withName = false
  })
  self:getInformation(info)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = self.name,
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 345)
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
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.HAVE")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_title_suffix",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(165, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = self.hasAmount,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(174, 309)
      },
      config = {
        color = self.amountColor
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.PURCHASE")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(25, 95)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(98, 95)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount",
        text = "" .. self.amount,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {name = "amount", offset = 3}
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_bg",
        res = "UI/alpha/HVGA/sell_number_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(115, 95)
      },
      config = {
        fix_size = CCSizeMake(155, 36)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_icon",
        res = self.goldRes
      },
      layout = {
        position = ccp(135, 95)
      }
    },
    {
      t = "Label",
      base = {
        name = "money",
        text = "" .. self.cost,
        size = 16
      },
      layout = {
        position = ccp(200, 95)
      },
      config = {
        color = self.costColor,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(1, 1)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sell",
        res = "UI/alpha/HVGA/package_button.png"
      },
      layout = {
        position = ccp(147, 40)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sell_shade",
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
        name = "sell_label",
        text = T(LSTR("EQUIPINFO.CONFIRM_PURCHASE")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        position = ccp(147, 40)
      },
      config = {}
      }
    }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  if self.ui.name:getContentSize().width > 160 then
    self.ui.name:setScale(160 / self.ui.name:getContentSize().width)
  end
  self:createDescription(info.id)
end
class.setInfo = setInfo
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local function handler(event, x, y)
    xpcall(function()
      self:doBuyLayerTouch()(event, x, y)
      closeTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doBuyLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      local normalColor = ccc3(255, 255, 255)
      local pressColor = ccc3(162, 129, 11)
      if event == "began" then
        if not ed.containsPoint(self.bg, x, y) then
          self.isPressOutOfBuyPanel = true
        end
        if ed.containsPoint(self.ui.sell, x, y) then
          self.isPressBuyButton = true
          self.ui.sell_shade:setVisible(true)
          ed.setLabelColor(self.ui.sell_label, pressColor)
        end
      elseif event == "ended" then
        if not ed.containsPoint(self.bg, x, y) and self.isPressOutOfBuyPanel then
          self:hide()
        end
        self.ui.sell_shade:setVisible(false)
        ed.setLabelColor(self.ui.sell_label, normalColor)
        if ed.containsPoint(self.ui.sell, x, y) and self.isPressBuyButton and self.amount > 0 then
          local time = self.preClickBuyTime or 0
          if self.doBuy and ed.getServerTime() - time > 0.5 then
            self.doBuy()
            self.preClickBuyTime = ed.getServerTime()
          end
        end
        self.isPressBuyButton = false
        self.isPressOutOfBuyPanel = false
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doBuyLayerTouch = doBuyLayerTouch
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.equipinfoforsell = class
local base = ed.ui.equipinfo
setmetatable(class, base.mt)
local function getInformation(self, id)
  self.id = id
  self.iconRes = ed.readequip.value(id, "Icon")
  self.name = ed.readequip.value(id, "Name")
  self.hasAmount = ed.player.equip_qunty[id] or 0
  local amountColor = ccc3(0, 71, 188)
  if self.hasAmount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
  self.amountColor = amountColor
  self.amount = 1
  self.amountLimit = ed.player.equip_qunty[id]
  self.unitPrice = "" .. ed.readequip.value(id, "Sell Price")
  self.income = self.unitPrice
end
class.getInformation = getInformation
local function create(id, withClose, nokeypad)
  local self = base.create(id, true, nokeypad)
  setmetatable(self, class.mt)
  self.explanation = "sell"
  self.context = "sell"
  self:setInfo(id)
  local handler = self:doMainLayerTouch()
  self:createTouchLayer(handler)
  return self
end
class.create = create
local function setInfo(self, id)
  self:getInformation(id)
  self:createContainer({id = id, withName = true})
  self.button = {}
  self.buttonPress = {}
  self.buttonLabel = {}
  self.buttonShade = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.HAVE")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_title_suffix",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(165, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = self.hasAmount,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(174, 309)
      },
      config = {
        color = self.amountColor
      }
    },
    {
      t = "Sprite",
      base = {
        name = "unit_bg",
        res = "UI/alpha/HVGA/money_board.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(147, 262)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "unit_gold_icon",
        res = "UI/alpha/HVGA/goldicon.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 262)
      },
      config = {
        fix_size = CCSizeMake(30, 30)
      }
    },
    {
      t = "Label",
      base = {
        name = "unitprice_title",
        text = T(LSTR("EQUIPINFO.UNIT_SALE_COST")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, 260)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "unitprice",
        text = self.unitPrice,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(150, 260)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    },
    {
      t = "Label",
      base = {
        name = "sell_amount_title",
        text = T(LSTR("EQUIPINFO.SELECT_SALE_AMOUNT")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(22, 220)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sell_amount_bg",
        res = "UI/alpha/HVGA/sell_number_bg.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(144, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus",
        array = self.button,
        res = "UI/alpha/HVGA/sell_number_button.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(42, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/sell_number_button_down.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(42, 165)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "minus",
        array = self.buttonLabel,
        text = "-",
        size = 24
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(42, 168)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "add",
        array = self.button,
        res = "UI/alpha/HVGA/sell_number_button.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(177, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "add",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/sell_number_button_down.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(177, 165)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "add",
        array = self.buttonLabel,
        text = "+",
        size = 24
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(177, 166)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max",
        array = self.button,
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(234, 165)
      },
      config = {
        scaleSize = CCSizeMake(70, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(234, 165)
      },
      config = {
        scaleSize = CCSizeMake(70, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "max",
        array = self.buttonLabel,
        text = T(LSTR("EQUIPINFO.MAXIMUM")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(232, 165)
      }
    },
    {
      t = "Label",
      base = {
        name = "sell_amount",
        text = "" .. self.amount,
        size = 20
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(102, 165)
      },
      config = {
        color = ccc3(255, 234, 198)
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
        name = "sell_amount_gap",
        text = "/",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(108, 165)
      },
      config = {
        color = ccc3(241, 193, 113)
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
        name = "sell_amount_limit",
        text = self.amountLimit,
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(114, 165)
      },
      config = {
        color = ccc3(241, 193, 113)
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
        name = "incom_bg",
        res = "UI/alpha/HVGA/money_board.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(144, 112)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "income_gold_icon",
        res = "UI/alpha/HVGA/goldicon.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 112)
      },
      config = {
        fix_size = CCSizeMake(30, 30)
      }
    },
    {
      t = "Label",
      base = {
        name = "income_title",
        text = T(LSTR("EQUIPINFO.MONEY_GAINED")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(22, 110)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "income",
        text = self.unitPrice,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(150, 110)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    },
    -- 出售按钮 START --
    {
      t = "Sprite",
      base = {
        name = "sell",
        array = self.button,
        res = "UI/alpha/HVGA/package_button.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(144, 40)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sell",
        array = self.buttonShade,
        res = "UI/alpha/HVGA/package_button_down.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(144, 40)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "sell",
        array = self.buttonLabel,
        text = T(LSTR("EQUIPINFO.CONFIRM_TO_SELL")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(144, 40)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
end
class.setInfo = setInfo
local function refreshLayer(self, amount)
  amount = amount or ed.player.equip_qunty[self.id]
  self.amount = 1
  self.amountLimit = amount
  self.income = self.unitPrice
  local amountColor = ccc3(0, 71, 188)
  if amount < 1 then
    amountColor = ccc3(255, 0, 0)
  end
  ed.setString(self.ui.amount_label, amount)
  ed.setLabelColor(self.ui.amount_label, amountColor)
  ed.setString(self.ui.sell_amount, self.amount)
  ed.setString(self.ui.sell_amount_limit, amount)
  ed.setString(self.ui.income, self.income)
end
class.refreshLayer = refreshLayer
local function setSellAmount(self, amount)
  if amount > self.amountLimit then
    amount = self.amountLimit
  end
  if amount < 1 then
    amount = 1
  end
  self.amount = amount
  self.income = self.unitPrice * amount
  ed.setString(self.ui.sell_amount, "" .. self.amount)
  ed.setString(self.ui.income, "" .. self.income)
end
class.setSellAmount = setSellAmount
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local function handler(event, x, y)
    xpcall(function()
      self:doSellLayerTouch()(event, x, y)
      self:doOutSellLayerTouch()(event, x, y)
      closeTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doSellLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      local normalColor = ccc3(255, 255, 255)
      local pressColor = ccc3(162, 129, 11)
      if event == "began" then
        for k, v in pairs(self.button) do
          if ed.containsPoint(v, x, y) then
            if self.buttonPress[k] then
              self.buttonPress[k]:setVisible(true)
              v:setVisible(false)
            end
            if self.buttonShade[k] then
              self.buttonShade[k]:setVisible(true)
            end
            ed.setLabelColor(self.buttonLabel[k], pressColor)
            self.pressButtonName = k
            if not self.keepChangeID then
              local keep
              if k == "add" then
                keep = self:keepChangeAmount(true)
              else
                keep = self:keepChangeAmount(false)
              end
              self.keepChangeID = self.button.add:getScheduler():scheduleScriptFunc(keep, 0, false)
            end
          end
        end
      elseif event == "ended" then
        self:stopKeepChange()
        if self.pressButtonName then
          local k = self.pressButtonName
          if self.buttonPress[k] then
            self.buttonPress[k]:setVisible(false)
            self.button[k]:setVisible(true)
          end
          if self.buttonShade[k] then
            self.buttonShade[k]:setVisible(false)
          end
          ed.setLabelColor(self.buttonLabel[k], normalColor)
          if ed.containsPoint(self.button[k], x, y) then
            if k == "add" and not self.hasKeep then
              self:doClickAdd()
            elseif k == "minus" and not self.hasKeep then
              self:doClickMinus()
            elseif k == "max" then
              self:doClickMax()
            elseif k == "sell" then
              self:doClickSell()
            end
          end
        end
        self.pressButtonName = nil
        self.hasKeep = false
      end
    end, EDDebug)
  end
  return handler
end
class.doSellLayerTouch = doSellLayerTouch
local function doOutSellLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if not ed.containsPoint(self.bg, x, y) then
          self.isPressOutSellLayer = true
        end
      elseif event == "ended" and not ed.containsPoint(self.bg, x, y) and self.isPressOutSellLayer then
        self:hide()
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doOutSellLayerTouch = doOutSellLayerTouch
local stopKeepChange = function(self)
  if self.keepChangeID then
    self.button.add:getScheduler():unscheduleScriptEntry(self.keepChangeID)
    self.keepChangeID = nil
  end
end
class.stopKeepChange = stopKeepChange
local keepChangeAmount = function(self, isAdd)
  local increment
  if isAdd then
    increment = 1
  else
    increment = -1
  end
  local count = 0
  local function keep(dt)
    xpcall(function()
      count = count + dt
      if count > 1 then
        self.hasKeep = true
        self:setSellAmount(self.amount + increment)
        count = count - 0.1
      end
    end, EDDebug)
  end
  return keep
end
class.keepChangeAmount = keepChangeAmount
local function doClickAdd(self)
  ed.playEffect(ed.sound.sellProp.add)
  self:setSellAmount(self.amount + 1)
end
class.doClickAdd = doClickAdd
local function doClickMinus(self)
  ed.playEffect(ed.sound.sellProp.minus)
  self:setSellAmount(self.amount - 1)
end
class.doClickMinus = doClickMinus
local function doClickMax(self)
  ed.playEffect(ed.sound.sellProp.max)
  self:setSellAmount(self.amountLimit)
end
class.doClickMax = doClickMax
local function doClickSell(self)
  ed.netdata.sell = {
    items = {
      {
        id = self.id,
        amount = self.amount
      }
    },
    income = self.income
  }
  if self.package then
    ed.netreply.sellItemReply = self.package:downSell()
  end
  if self.bg:numberOfRunningActions() > 0 then
    return
  end
  local msg = ed.upmsg.sell_item()
  msg._item = {
    ed.packItem(self.id, self.amount)
  }
  ed.send(msg, "sell_item")
end
class.doClickSell = doClickSell

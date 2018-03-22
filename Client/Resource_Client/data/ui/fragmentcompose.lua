local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.fragmentcompose = class
local lsr = ed.ui.fragmentcomposelsr.create()


local function show(self)
  lsr:report("createWindow")
  self.bg:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  self.bg:runAction(action)
end
class.show = show


local function destroy(self)
  lsr:report("closeWindow")
  if tolua.isnull(self.bg) then
    return
  end
  if self.bg:numberOfRunningActions() > 0 then
    return
  end
  local action = CCScaleTo:create(0.2, 0)
  action = CCEaseBackIn:create(action)
  local sequence = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
    end, EDDebug)
  end))
  self.bg:runAction(sequence)
  if self.destroyHandler then
    self.destroyHandler()
  end
end
class.destroy = destroy


local function doOutPanelTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if not ed.containsPoint(self.bg, x, y) then
          self.isClickOutPanel = true
        end
      elseif event == "ended" and not ed.containsPoint(self.bg, x, y) and self.isClickOutPanel then
        self:destroy()
      end
    end, EDDebug)
  end
  return handler
end
class.doOutPanelTouch = doOutPanelTouch


local function doCloseButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.ui.close, x, y) then
          self.isPressCloseButton = true
          self.ui.close_down:setVisible(true)
        end
      elseif event == "ended" then
        if ed.containsPoint(self.ui.close, x, y) then
          self:destroy()
        end
        self.ui.close_down:setVisible(false)
        self.isPressCloseButton = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doCloseButtonTouch = doCloseButtonTouch


local function refreshFragmentAmount(self)
  self.info.fragmentAmount = self.info.fragmentAmount - self.info.needAmount
  ed.setString(self.ui.amount_label, self.info.fragmentAmount)
  if self.info.fragmentAmount < self.info.needAmount then
    self.info.amountColor = ccc3(255, 0, 0)
  else
    self.info.amountColor = ccc3(50, 41, 31)
  end
  self.info.amountColor = ccc3(255, 0, 0)

  ed.setLabelColor(self.ui.amount_label, self.info.amountColor)
end
class.refreshFragmentAmount = refreshFragmentAmount


local function composeReply(self, id)
  local function handler(result, amount)
    self:refreshFragmentAmount()
    self:destroy()
    ed.showToast(T(LSTR("FRAGMENTCOMPOSE.SUCCESSFULLY_SYNTHESIZED_FRAGMENT")))
  end
  return handler
end
class.composeReply = composeReply


local function refreshCostColor(self)
  local function handler()
    local ui = self.ui
    local info = self.info
    if info.cost > ed.player._money then
      ed.setLabelColor(ui.cost, ccc3(232, 18, 18))
    else
      ed.setLabelColor(ui.cost, ccc3(182, 65, 21))
    end
  end
  return handler
end
class.refreshCostColor = refreshCostColor


local function doCompose(self)
  local ua = self.info.universalAmount
  if self.info.universalAmount > self.info.universalNeedAmount then
    ua = self.info.universalNeedAmount
  end
  if self.info.fragmentAmount + ua < self.info.needAmount then
    ed.showToast(T(LSTR("FRAGMENTCOMPOSE.INSUFFICIENT_FRAGMENT_SYNTHESIS_FAILED")))
    return
  end
  if self.info.cost > ed.player._money then
    ed.showHandyDialog("useMidas", {
      refreshHandler = self:refreshCostColor()
    })
    return
  end
  if ed.itemType(self.info.makeId) == "hero" and ed.player.heroes[self.info.makeId] then
    ed.showToast(T(LSTR("FRAGMENTCOMPOSE.YOU_HAVE_ALREADY_GOT_THIS_HERO")))
    return
  end
  local fragmentAmount = self.info.fragmentAmount
  if self.info.fragmentAmount > self.info.needAmount then
    fragmentAmount = self.info.needAmount
  end
  local universalAmount = self.info.needAmount - self.info.fragmentAmount
  if universalAmount < 0 then
    universalAmount = 0
  end
  ed.netdata.fragmentCompose = {
    id = self.info.id,
    fragmentAmount = fragmentAmount,
    universalAmount = universalAmount,
    cost = self.info.cost,
    makeId = self.info.makeId
  }
  if self.package then
    ed.netreply.composeFragmentReply = self.package:downFragmentCompose()
  end
  local msg = ed.upmsg.fragment_compose()
  msg._fragment = self.info.makeId
  msg._frag_amount = fragmentAmount
  ed.send(msg, "fragment_compose")
end
class.doCompose = doCompose
local function doOKButtonTouch(self, event, x, y)
  local pressColor = ccc3(255, 255, 255)
  local normalColor = ccc3(251, 206, 16)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.ui.ok, x, y) then
          self.isPressOKButton = true
          self.ui.ok_down:setVisible(true)
          ed.setLabelColor(self.ui.ok_label, pressColor)
        end
      elseif event == "ended" then
        if ed.containsPoint(self.ui.ok, x, y) and self.isPressOKButton then
          self:doCompose()
        end
        self.ui.ok_down:setVisible(false)
        ed.setLabelColor(self.ui.ok_label, normalColor)
        self.isPressOKButton = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doOKButtonTouch = doOKButtonTouch
local doMainLayerTouch = function(self)
  local function handler(event, x, y)
    xpcall(function()
      self:doOutPanelTouch()(event, x, y)
      self:doCloseButtonTouch()(event, x, y)
      self:doOKButtonTouch()(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function getInformation(self, id)
  local info = {}
  local equipInfo = ed.getDataTable("equip")[id]
  local fragmentTable = ed.getDataTable("fragment")
  local fragmentInfo
  for k, v in pairs(fragmentTable) do
    if v["Fragment ID"] == id then
      info.makeId = k
      if ed.itemType(k) == "equip" then
        info.makeName = ed.getDataTable("equip")[k].Name
      elseif ed.itemType(k) == "hero" then
        info.makeName = ed.getDataTable("Unit")[k]["Display Name"]
      else
        info.makeName = ""
      end
      info.cost = v.Expense
      fragmentInfo = v
      break
    end
  end
  info.id = id
  info.name = equipInfo.Name
  info.needAmount = fragmentInfo["Fragment Count"]
  info.universalNeedAmount = fragmentInfo["Universal Fragment Count"]
  info.universalId = fragmentInfo["Universal Fragment ID"]
  info.fragmentAmount = ed.player.equip_qunty[id] or 0
  info.universalAmount = ed.player.equip_qunty[info.universalId] or 0
  info.lackAmount = info.needAmount - info.fragmentAmount
  if 0 > info.lackAmount then
    info.lackAmount = 0
  end
  if info.lackAmount > info.universalNeedAmount then
    info.lackAmount = info.universalNeedAmount
  end
  if info.lackAmount > info.universalAmount then
    info.lackText = T(LSTR("FRAGMENTCOMPOSE.INSUFFICIENT_FRAGMENT_SYNTHESIS_FAILED"))
  else
    info.lackText = T(LSTR("FRAGMENTCOMPOSE.INSUFFICIENT_FRAGMENT_SYNTHESIS_FAILED"))
  end
  if 0 < info.lackAmount then
    info.amountColor = ccc3(255, 0, 0)
  else
    info.amountColor = ccc3(169, 91, 28)
  end
  self.info = info
  return info
end
class.getInformation = getInformation


local function create(id)
  local self = {}
  setmetatable(self, class.mt)
  local info = self:getInformation(id)
  self.info = info
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -130, true)
  local bg = ed.createSprite("UI/alpha/HVGA/fragment_compose_bg.png")
  bg:setPosition(ccp(400, 240))
  self.bg = bg
  mainLayer:addChild(bg)
  self.ui = {}
  if not (info.cost <= ed.player._money) or not ccc3(182, 65, 21) then
  end
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = T(LSTR("EQUIPCRAFT.SYNTHESIS")) .." ".. info.makeName,
        size = 18
      },
      layout = {
        position = ccp(142, 348)
      },
      config = {
        color = ccc3(184, 6, 6)
      }
    },
    --[[{
      t = "Label",
      base = {
        name = "make_name",
        text = info.makeName,
        size = 18
      },
      layout = {
        position = ccp(212, 178)
      },
      config = {
        color = ccc3(169, 91, 28)
      }
    },]]--
    {
      t = "Sprite",
      base = {
        name = "arrow",
        res = "UI/alpha/HVGA/fragment_compose_arrow.png"
      },
      layout = {
        position = ccp(145, 230)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = info.fragmentAmount,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(78, 178)
      },
      config = {
        color = info.amountColor
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_need_label",
        text = "/" .. info.needAmount,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(78, 178)
      },
      config = {
        color = ccc3(50, 41, 31)
      }
    },
    {
      t = "Label",
      base = {
        name = "universal",
        text = info.lackText,
        size = 20
      },
      layout = {
        position = ccp(145, 130)
      },
      config = {
        color = ccc3(182, 65, 21),
        visible = info.lackAmount ~= 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "cost_bg",
        res = "UI/alpha/HVGA/equip_craft_money_bg.png"
      },
      layout = {
        position = ccp(142, 95)
      },
      config = {
        fix_size = CCSizeMake(260, 32)
      }
    },
    {
      t = "Label",
      base = {
        name = "cost_title",
        text = T(LSTR("EQUIPCRAFT.SYNTHESIS_COST_")),
        size = 18
      },
      layout = {
        position = ccp(72, 94)
      },
      config = {
        color = ccc3(50, 41, 31)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "cost_icon",
        res = "UI/alpha/HVGA/goldicon.png"
      },
      layout = {
        position = ccp(152, 95)
      },
      config = {scale = 0.8}
    },
    {
      t = "Label",
      base = {
        name = "cost",
        text = info.cost,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(180, 94)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(280, 375)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_down",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        position = ccp(280, 375)
      },
      config = {visible = false}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/herodetail-upgrade.png",
        capInsets = CCRectMake(20, 20, 20, 20)
      },
      layout = {
        position = ccp(145, 45)
      },
      config = {
        scaleSize = CCSizeMake(250, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_down",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(20, 20, 20, 20)
      },
      layout = {
        position = ccp(145, 45)
      },
      config = {
        scaleSize = CCSizeMake(250, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T(LSTR("FRAGMENTCOMPOSE.CONFIRM_SYNTHESIS")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        position = ccp(145, 45)
      }
    }
  }
  local readNode = ed.readnode.create(self.bg, self.ui)
  readNode:addNode(ui_info)
  local fragmentIcon = ed.readequip.createFragment(info.id)
  self.fragmentIcon = fragmentIcon
  fragmentIcon:setPosition(ccp(78, 230))
  self.bg:addChild(fragmentIcon)
  local makeIcon = ed.readequip.createIcon(info.makeId)
  self.makeIcon = makeIcon
  makeIcon:setPosition(ccp(212, 230))
  self.bg:addChild(makeIcon)
  if self.ui.name:getContentSize().width > 200 then
	  self.ui.name:setScale(210 / self.ui.name:getContentSize().width)
  end
  self:show()
    local refreshHandler = self:refreshCostColor()
    refreshHandler()
  return self
end
class.create = create

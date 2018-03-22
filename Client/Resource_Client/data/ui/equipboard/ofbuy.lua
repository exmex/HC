local equipBoard = ed.ui.equipboard
local base = equipBoard
local class = newclass(base.mt)
equipBoard.ofbuy = class
local checknull = function(self)
  return tolua.isnull(self.mainLayer)
end
class.checknull = checknull
local refreshCostColor = function(self)
  local ui = self.ui
  local param = self.param
  local md = param.pay == 1 and ed.player._money or ed.player._rmb
  if not (md < param.cost) or not ccc3(255, 0, 0) then
  end
  ed.setLabelColor(ui.money, (ccc3(251, 206, 16)))
end
class.refreshCostColor = refreshCostColor
local registerTouchHandler = function(self)
  local ui = self.ui
  local param = self.param
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.sell,
    press = ui.sell_press,
    key = "sell_button",
    clickHandler = function()
      if param.amount > 0 and param.doBuy then
        param.doBuy()
      end
    end,
    clickInterval = 0.5
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
end
class.registerTouchHandler = registerTouchHandler
local initWindow = function(self)
  local param = self.param
  local id = param.id
  local amount = param.amount or 0
  local price = param.price
  local pay = param.pay
  local cost = price * math.max(amount, 1)
  param.cost = cost
  local name = ed.readequip.value(id, "Name")
  name = param.amount > 1 and T("%sx%d", name, amount)
  local goldRes = ed.ui.marketconfig.getCoinRes(pay)
  local costColor = ed.ui.marketconfig.checkMoneyEnough(pay, cost) and ccc3(251, 206, 16) or ccc3(255, 0, 0)
  local ui = self.ui
  local ui_info = {
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
        name = "amount",
        text = tostring(amount),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {
          name = "amount_title",
          offset = 10
        }
      },
      config = {
        color = ccc3(0, 71, 188)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_suffix",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 18
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
      base = {name = "money_icon", res = goldRes},
      layout = {
        position = ccp(145, 95)
      }
    },
    {
      t = "Label",
      base = {
        name = "money",
        text = tostring(cost),
        size = 16
      },
      layout = {
        position = ccp(200, 95)
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
        name = "sell_press",
        res = "UI/alpha/HVGA/package_button_down.png",
        parent = "sell"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "sell_label",
        text = T(LSTR("EQUIPINFO.CONFIRM_PURCHASE")),
        size = 20,
        fontinfo = "ui_normal_button",
        parent = "sell",
      },
      layout = {mediate = true},
      config = {
      }
    }
  }
  local readNode = ed.readnode.create(ui.container, ui)
  readNode:addNode(ui_info)
  self:refreshCostColor()
end
class.initWindow = initWindow
local function create(param)
  param = param or {}
  local self = base.create("equipboardofbuy")
  setmetatable(self, class.mt)
  self.param = param
  self:initFrame()
  self:initAmount()
  self:initWindow()
  self:registerTouchHandler()
  return self
end
class.create = create

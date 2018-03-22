	local equipBoard = ed.ui.equipboard
local base = equipBoard
local class = newclass(base.mt)
equipBoard.ofsell = class
local checknull = function(self)
  return tolua.isnull(self.mainLayer)
end
class.checknull = checknull
local getKeepChangeHandler = function(self, isAdd)
  local increment
  increment = isAdd and 1 or -1
  local count = 0
  local function handler(dt)
    count = count + dt
    while count > 1 do
      self.isKeepPress = true
      self:setSellAmount(tostring(increment))
      count = count - 0.1
    end
  end
  return handler
end
class.getKeepChangeHandler = getKeepChangeHandler
local setSellAmount = function(self, input)
  local config = self.config
  local amount = config.sellAmount
  local min = 1
  local max = ed.player.equip_qunty[self.param.id]
  if type(input) == "string" then
    local add = tonumber(input)
    amount = amount + add
  elseif type(input) == "number" then
    amount = input
  end
  amount = math.max(min, math.min(max, amount))
  config.sellAmount = amount
  self:refreshSellAmount()
end
class.setSellAmount = setSellAmount
local refreshSellAmount = function(self)
  local config = self.config
  local ui = self.ui
  ed.setString(ui.sell_amount, tostring(config.sellAmount))
  ed.setString(ui.income, tostring(config.unitPrice * config.sellAmount))
end
class.refreshSellAmount = refreshSellAmount
local refreshAfterSell = function(self)
  local amount = ed.player.equip_qunty[self.param.id] or 0
  if amount == 0 then
    self:destroy()
  end
  self:refreshAmount()
  ed.setString(self.ui.sell_amount_limit, tostring(amount))
  self:setSellAmount(0)
end
class.refreshAfterSell = refreshAfterSell
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_frame",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.minus,
    press = ui.minus_press,
    key = "minus_button",
    pressHandler = function()
      self.isKeepPress = nil
      self:registerUpdateHandler("keepChange", self:getKeepChangeHandler(false))
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("keepChange")
    end,
    clickHandler = function()
      if not self.isKeepPress then
        ed.playEffect(ed.sound.sellProp.minus)
        self:setSellAmount("-1")
      end
    end
  })
  self:btRegisterButtonClick({
    button = ui.add,
    press = ui.add_press,
    key = "add_button",
    pressHandler = function()
      self.isKeepPress = nil
      self:registerUpdateHandler("keepChange", self:getKeepChangeHandler(true))
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("keepChange")
    end,
    clickHandler = function()
      if not self.isKeepPress then
        ed.playEffect(ed.sound.sellProp.add)
        self:setSellAmount("1")
      end
    end
  })
  self:btRegisterButtonClick({
    button = ui.max,
    press = ui.max_press,
    key = "max_button",
    clickHandler = function()
      ed.playEffect(ed.sound.sellProp.max)
      self:setSellAmount(ed.player.equip_qunty[self.param.id])
    end
  })
  self:btRegisterButtonClick({
    button = ui.sell,
    press = ui.sell_press,
    key = "sell_button",
    clickHandler = function()
      local id = self.param.id
      local config = self.config
      ed.registerNetReply("sell_item", function(result, amount)
        if result then
          self:refreshAfterSell()
        end
        ed.ui.baselsr.create():sellProp(result, amount)
      end, {
        items = {
          {
            id = id,
            amount = config.sellAmount
          }
        },
        income = config.sellAmount * config.unitPrice
      })
      local msg = ed.upmsg.sell_item()
      msg._item = {
        ed.packItem(id, config.sellAmount)
      }
      ed.send(msg, "sell_item")
    end,
    clickInterval = 0.5
  })
end
class.registerTouchHandler = registerTouchHandler
local initWindow = function(self)
  local id = self.param.id
  local row = ed.readequip.row(id)
  local config = self.config
  config.unitPrice = row["Sell Price"]
  local ui = self.ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "unit_bg",
        res = "UI/alpha/HVGA/money_board.png"
      },
      layout = {
        position = ccp(144, 262)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "unit_gold_icon",
        res = "UI/alpha/HVGA/goldicon.png"
      },
      layout = {
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
        position = ccp(25, 260)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "unitprice",
        text = row["Sell Price"],
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
        position = ccp(25, 220)
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
        position = ccp(147, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus",
        res = "UI/alpha/HVGA/sell_number_button.png"
      },
      layout = {
        position = ccp(42, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        parent = "minus"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "minus_label",
        text = "-",
        size = 24,
        parent = "minus"
      },
      layout = {
        mediate = true,
        offset = ccp(0, 3)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "add",
        res = "UI/alpha/HVGA/sell_number_button.png"
      },
      layout = {
        position = ccp(177, 165)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "add_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        parent = "add"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "add_label",
        text = "+",
        size = 24,
        parent = "add"
      },
      layout = {
        mediate = true,
        offset = ccp(0, 2)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(234, 165)
      },
      config = {
        scaleSize = CCSizeMake(70, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(20, 20, 28, 29),
        parent = "max"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(70, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "max_label",
        text = T(LSTR("EQUIPINFO.MAXIMUM")),
        fontinfo = "ui_normal_button",
        parent = "max"
      },
      layout = {mediate = true},
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "sell_amount",
        text = tostring(config.sellAmount),
        size = 20
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(102, 165)
      },
      config = {
        color = ccc3(66,45,28),
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
        position = ccp(108, 165)
      },
      config = {
        color = ccc3(241, 193, 113),
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
        text = tostring(ed.player.equip_qunty[id] or 0),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(114, 165)
      },
      config = {
        color = ccc3(66, 45,28),
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
        position = ccp(25, 110)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "income",
        text = config.unitPrice,
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
        text = T(LSTR("EQUIPINFO.CONFIRM_TO_SELL")),
        fontinfo = "ui_normal_button",
        parent = "sell"
      },
      layout = {mediate = true},
      config = {}
    }
  }
  local readNode = ed.readnode.create(ui.container, ui)
  readNode:addNode(ui_info)
end
class.initWindow = initWindow
local function create(param)
  param = param or {}
  local self = base.create("equipboardofsell")
  setmetatable(self, class.mt)
  self.param = param
  if (ed.player.equip_qunty[self.param.id] or 0) == 0 then
    print(T("The amount of equip : %d is %d"), self.param.id, 0)
    return
  end
  self.config = {sellAmount = 1}
  self:initFrame({ignoreAtt = true})
  self:initAmount()
  self:initWindow()
  self:registerTouchHandler()
  return self
end
class.create = create

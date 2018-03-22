local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fastsell = class
local doClickCancel = function(self)
  self:destroy({
    callback = self.callback
  })
end
class.doClickCancel = doClickCancel
local doClickok = function(self)
  if self.ct_ok then
    if ed.getServerTime() - self.ct_ok < 1 then
      return
    end
    self.ct_ok = ed.getServerTime()
  end
  local items = {}
  for i = 1, #self.garbageData do
    local em = self.garbageData[i]
    table.insert(items, {
      id = em.id,
      amount = em.amount
    })
  end
  ed.registerNetReply("sell_item", function()
    self:destroy({
      callback = self.callback
    })
  end, {
    items = items,
    income = self.totalIncome
  })
  local itemData = {}
  for i = 1, #items do
    local em = items[i]
    table.insert(itemData, ed.packItem(em.id, em.amount))
  end
  local msg = ed.upmsg.sell_item()
  msg._item = itemData
  ed.send(msg, "sell_item")
end
class.doClickok = doClickok
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    clickHandler = function()
      self:destroy({
        callback = self.callback
      })
    end,
    priority = 1
  })
  self:btRegisterButtonClick({
    button = ui.yes_button,
    press = ui.yes_button_press,
    clickHandler = function()
      self:doClickok()
    end
  })
  self:btRegisterButtonClick({
    button = ui.no_button,
    press = ui.no_button_press,
    clickHandler = function()
      self:doClickCancel()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  param = param or {}
  local self = base.create("fastsell")
  setmetatable(self, class.mt)
  local callback = param.callback
  self.callback = callback
  self:getGarbageData()
  local income = self:getIncome()
  if income == 0 then
    return nil
  end
  self.totalIncome = income
  local mainLayer = self.mainLayer
  self:createWindow()
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local function pop(param, z)
  local window = create(param)
  if window then
    window:popWindow(z)
  end
end
class.pop = pop
local createWindow = function(self)
  local ui = self.ui
  local container = self.container
  local height = 0
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(10, 10, 58, 26)
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {
        scaleSize = CCSizeMake(425, 100)
      }
    }
  }
  readnode:addNode(ui_info)
  height = 0
  height = self:createConfirmButtons(height)
  height = self:createTotalIncome(height)
  height = self:createItemList(height)
  height = self:createTitle(height)
  self.ui.frame:setContentSize(CCSizeMake(425, height))
end
class.createWindow = createWindow
local createConfirmButtons = function(self, height)
  local ui = self.ui
  local frame = ui.frame
  local readnode = ed.readnode.create(frame, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "yes_button",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(212, height + 40)
      },
      config = {
        scaleSize = CCSizeMake(115, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "yes_button_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "yes_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(115, 45),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "yes_button_label",
        text = T(LSTR("FASTSELL.GOOD")),
        fontinfo = "ui_normal_button",
        parent = "yes_button"
      },
      layout = {
        position = ccp(58, 20)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "line_above_button",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 0)
      },
      layout = {
        position = ccp(212, height + 72)
      },
      config = {
        scaleSize = CCSizeMake(395, 2)
      }
    }
  }
  readnode:addNode(ui_info)
  return height + 75
end
class.createConfirmButtons = createConfirmButtons
local getIncome = function(self)
  local income = 0
  local list = self.garbageData
  for i = 1, #list do
    local e = list[i]
    income = income + e.price * e.amount
  end
  return income
end
class.getIncome = getIncome
local createTotalIncome = function(self, height)
  local ui = self.ui
  local frame = ui.frame
  local readnode = ed.readnode.create(frame, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "income"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, height + 20)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "pre",
            text = T(LSTR("FASTSELL.CAN_GET")),
            size = 16
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {
            color = ccc3(255, 235, 137)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "gold_icon",
            res = "UI/alpha/HVGA/goldicon_small.png",
            offset = 5
          },
          layout = {},
          config = {fix_height = 24}
        },
        {
          t = "Label",
          base = {
            name = "income",
            text = self.totalIncome,
            size = 16,
            offset = 5
          },
          layout = {},
          config = {
            color = ccc3(255, 174, 51)
          }
        },
        {
          t = "Label",
          base = {
            name = "suffix",
            text = "",
            size = 16
          },
          layout = {},
          config = {
            color = ccc3(255, 235, 137)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  return height + 40
end
class.createTotalIncome = createTotalIncome
local getGarbageData = function(self)
  local list = {}
  local data = ed.getDataTable("equip")
  for k, v in pairs(data) do
    local gt = v["Consume Type"]
    local id = k
    local name = v.Name
    local price = v["Sell Price"]
    local amount = ed.player.equip_qunty[id] or 0
    if gt == T(LSTR("EQUIP.GARBAGE")) and amount > 0 then
      table.insert(list, {
        id = id,
        name = name,
        price = price,
        amount = amount
      })
    end
  end
  for i = 1, #list do
    for j = i, 2, -1 do
      local temp = list[j]
      if list[j - 1].price < list[j].price then
        list[j] = list[j - 1]
        list[j - 1] = temp
      end
    end
  end
  self.garbageData = list
end
class.getGarbageData = getGarbageData
local refreshItemPosition = function(self, height)
  local list = self.garbageData
  local dx, dy = 200, 42
  local ox, oy = 35, height + (math.ceil(#list / 2) - 0.5) * dy + 10
  for i = 1, #list do
    local item = self.ui["item" .. i]
    local x = ox + dx * ((i - 1) % 2)
    local y = oy - dy * math.floor((i - 1) / 2)
    item:setPosition(ccp(x, y))
    local name = item:getChildren():objectAtIndex(1)
    if name and not tolua.isnull(name) and (name.getContentSize ~= nil) then
      local w = name:getContentSize().width
      if 120 < w then
        name:setScale(120 / w)
        local amount = item:getChildren():objectAtIndex(2)
        local ptx,pty = amount:getPosition()
        amount:setPosition(ccp(160, pty))
      end
    end
  end
end
class.refreshItemPosition = refreshItemPosition
local createItemList = function(self, height)
  local ui = self.ui
  local frame = ui.frame
  local readnode = ed.readnode.create(frame, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "list_bg",
        res = "UI/alpha/HVGA/tip_detail_bg.png",
        capInsets = CCRectMake(50, 10, 61, 10)
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(212, height + 5)
      },
      config = {
        scaleSize = CCSizeMake(425, 50)
      }
    }
  }
  local list = self.garbageData
  for i = 1, #list do
    local gd = list[i]
    table.insert(ui_info, {
      t = "HorizontalNode",
      base = {
        name = "item" .. i
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "CCNode",
          base = {
            name = "icon",
            node = ed.readequip.createIcon(gd.id, 40)
          },
          layout = {},
          config = {}
        },
        {
          t = "Label",
          base = {
            name = "name",
            text = gd.name,
            size = 16,
            offset = 5
          },
          layout = {},
          config = {}
        },
        {
          t = "Label",
          base = {
            name = "amount",
            text = "x" .. gd.amount,
            size = 16,
            offset = 5
          },
          layout = {},
          config = {}
        }
      }
    })
  end
  readnode:addNode(ui_info)
  self:refreshItemPosition(height)
  local bg = ui.list_bg
  local dh = 10 + 42 * math.ceil(#list / 2)
  bg:setContentSize(CCSizeMake(425, dh))
  return height + dh
end
class.createItemList = createItemList
local createTitle = function(self, height)
  local ui = self.ui
  local frame = ui.frame
  local readnode = ed.readnode.create(frame, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "window_title",
        text = T(LSTR("FASTSELL.ARE_YOU_SURE_TO_SELL_THE_FOLLOWING_USELESS_ITEMS_TO_BUSINESSMAN")),
        size = 16
      },
      layout = {
        position = ccp(212, height + 30)
      },
      config = {
        color = ccc3(255, 235, 137)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "no_button",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(420, height + 38)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "no_button_press",
        res = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
        parent = "no_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readnode:addNode(ui_info)
  return height + 60
end
class.createTitle = createTitle

local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.mailcontent = class
local createTitle = function(self, y)
  y = y or 380
  local container = self.draglist:getList()
  local readnode = ed.readnode.create(container, self.listui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/equip_craft_money_bg.png",
        capInsets = CCRectMake(10, 10, 217, 6)
      },
      layout = {
        position = ccp(165, y)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = self.title,
        size = 18
      },
      layout = {
        position = ccp(165, y)
      },
      config = {
        color = ccc3(172, 75, 30),
        dimension = CCSizeMake(290, 0)
      }
    }
  }
  readnode:addNode(ui_info)
  local size = self.listui.title:getContentSize()
  local width = 300
  local height = size.height + 10
  self.listui.title_bg:setContentSize(CCSizeMake(width, height))
  return y - height
end
class.createTitle = createTitle
local createBody = function(self, y)
  y = y or 380
  local container = self.draglist:getList()
  local readnode = ed.readnode.create(container, self.listui)
  local ui_info = {}
  if type(self.body) == "string" then
    ui_info = {
      {
        t = "Label",
        base = {
          name = "body",
          text = self.body,
          size = 16
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(165, y)
        },
        config = {
          color = ccc3(162, 88, 41),
          dimension = CCSizeMake(250, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      }
    }
  else
    ui_info = {
      {
        t = "CCNode",
        base = {
          name = "body",
          node = self.body
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(165 - self.body:getContentSize().width / 2 + 10, y)
        }
      }
    }
  end
  readnode:addNode(ui_info)
  return y - self.listui.body:getContentSize().height - 20
end
class.createBody = createBody
local createFrom = function(self, y)
  y = y or 380
  local container = self.draglist:getList()
  local readnode = ed.readnode.create(container, self.listui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "from",
        text = self.from,
        size = 16
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(300, y)
      },
      config = {
        color = ccc3(162, 88, 41)
      }
    }
  }
  readnode:addNode(ui_info)
  return y - 20
end
class.createFrom = createFrom
local createSplitLine = function(self, y)
  y = y or 380
  local container = self.draglist:getList()
  local readnode = ed.readnode.create(container, self.listui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "split_line",
        res = "UI/alpha/HVGA/mailbox/mailbox_letter_delimeter.png"
      },
      layout = {
        position = ccp(165, y)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  return y - 5
end
class.createSplitLine = createSplitLine
local createItemAttach = function(self, attach, y)
  local icon_len = 65
  local function getpos(i)
    local ox, oy = 34, y
    local dx, dy = icon_len, icon_len
    local px = ox + dx * ((i - 1) % 4) + icon_len / 2
    local py = oy - dy * math.floor((i - 1) / 4) - icon_len / 2
    return ccp(px, py)
  end
  local attach = attach or {}
  local container = self.draglist:getList()
  local itemAttach = {}
  for i = 1, #attach do
    local a = attach[i]
    local id = a.id
    local amount = a.amount
    local pos = getpos(i)
    local icon = ed.readequip.createIconWithAmount(id, 60, amount)
    icon:setPosition(pos)
    container:addChild(icon)
    itemAttach[i] = {icon = icon, id = id}
  end
  self.itemAttach = itemAttach
  local height = icon_len * math.ceil(#attach / 4)
  return y - height
end
class.createItemAttach = createItemAttach
local createCommonAttach = function(self, attach, y)
  local icon_res = {
    Diamond = "UI/alpha/HVGA/shop_token_icon.png",
    Gold = "UI/alpha/HVGA/goldicon_small.png",
    Exp = "UI/alpha/HVGA/task_exp_icon_2.png",
    CrusadeMoney = "UI/alpha/HVGA/money_dragonscale_big.png",
    PvpMoney = "UI/alpha/HVGA/money_arenatoken_big.png",
    GuildMoney = "UI/alpha/HVGA/money_guildtoken_big.png",
    SkillPoint = "UI/alpha/HVGA/herodetail_skill_upgrade_button_1.png"
  }
  attach = attach or {}
  local container = self.draglist:getList()
  for i = 1, #attach do
    local type = attach[i].type
    local amount = attach[i].amount or 0
    local iconres = icon_res[type]
    local nodes = {}
    local readnode = ed.readnode.create(container, nodes)
    local ui_info = {
      {
        t = "Sprite",
        base = {name = "icon", res = iconres},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(40, y)
        },
        config = {fix_height = 25}
      },
      {
        t = "Label",
        base = {
          name = "amount",
          text = string.format("x%d", amount),
          size = 18
        },
        layout = {
          anchor = ccp(0, 1),
          right2 = {
            array = nodes,
            name = "icon",
            offset = 20
          }
        },
        config = {
          color = ccc3(129, 61, 22)
        }
      }
    }
    readnode:addNode(ui_info)
    y = y - 30
  end
  return y
end
class.createCommonAttach = createCommonAttach
local createAttach = function(self, y)
  local attach = self.attach or {}
  local oy = y
  local container = self.draglist:getList()
  local readnode = ed.readnode.create(container, self.listui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "attach_bg",
        res = "UI/alpha/HVGA/mailbox/mailbox_letter_addon_bg.png",
        capInsets = CCRectMake(5, 5, 16, 16)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(20, y)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "attach_title",
        text = T(LSTR("MAILBOX.ATTACHMENTS_")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, y - 15)
      },
      config = {
        color = ccc3(152, 98, 34)
      }
    }
  }
  readnode:addNode(ui_info)
  y = y - 30
  local common = {}
  local items = {}
  for i = 1, #attach do
    local a = attach[i]
    if not ed.isElementInTable(a.type, {"Item"}) then
      table.insert(common, {
        type = a.type,
        amount = a.amount
      })
    elseif a.type == "Item" then
      table.insert(items, {
        id = a.id,
        amount = a.amount
      })
    end
  end
  self.attachedItems = items
  y = self:createCommonAttach(common, y)
  y = self:createItemAttach(items, y)
  local bh = oy - y
  self.listui.attach_bg:setContentSize(CCSizeMake(300, bh))
  return y
end
class.createAttach = createAttach
local createContent = function(self)
  self.listui = {}
  local y = 380
  local oy = y
  if self.title then
    y = self:createTitle(y)
  end
  if self.body then
    y = self:createBody(y)
  end
  if self.from then
    y = self:createFrom(y)
  end
  if self.attached then
    y = self:createSplitLine(y)
    y = self:createAttach(y)
  end
  local height = oy - y + 30
  self.draglist:initListHeight(height)
end
class.createContent = createContent
local doPressIn = function(self)
  local function handler(x, y)
    local ia = self.itemAttach or {}
    for i = 1, #ia do
      local a = ia[i]
      local icon = a.icon
      self.oriItemScale = self.oriItemScale or icon:getScale()
      local id = a.id
      if ed.containsPoint(icon, x, y) then
        icon:setScale(self.oriItemScale * 0.95)
        self:createAttachDetail(icon, id)
        return i
      end
    end
  end
  return handler
end
class.doPressIn = doPressIn
local cancelPressIn = function(self)
  local function handler(x, y, id)
    local ia = self.itemAttach or {}
    local a = ia[id]
    local icon = a.icon
    local id = a.id
    icon:setScale(self.oriItemScale)
    self:destroyAttachDetail()
  end
  return handler
end
class.cancelPressIn = cancelPressIn
local doClickIn = function(self)
  local function handler(x, y, id)
    local ia = self.itemAttach or {}
    local a = ia[id]
    local icon = a.icon
    local id = a.id
    icon:setScale(self.oriItemScale)
    self:destroyAttachDetail()
  end
  return handler
end
class.doClickIn = doClickIn
local cancelClickIn = function(self)
  local function handler(x, y, id)
    local ia = self.itemAttach or {}
    local a = ia[id]
    local icon = a.icon
    local id = a.id
    icon:setScale(self.oriItemScale)
    self:destroyAttachDetail()
  end
  return handler
end
class.cancelClickIn = cancelClickIn
local createAttachDetail = function(self, icon, id)
  local x, y = icon:getPosition()
  y = y + 30
  local pos = icon:getParent():convertToWorldSpace(ccp(x, y))
  local panel = ed.readequip.getDetailCard(id)
  panel:setPosition(pos)
  self.container:addChild(panel, 40)
  self.attachDetailPanel = panel
end
class.createAttachDetail = createAttachDetail
local destroyAttachDetail = function(self)
  local panel = self.attachDetailPanel
  if not tolua.isnull(panel) then
    panel:removeFromParentAndCleanup(true)
  end
end
class.destroyAttachDetail = destroyAttachDetail
local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(22, 75, 284, 325),
    rect = CCRectMake(25, 75, 276, 326),
    container = self.ui.frame,
    priority = -178,
    upShade = "UI/alpha/HVGA/mailbox/mailbox_letter_scroll_mask.png",
    downShade = "UI/alpha/HVGA/mailbox/mailbox_letter_scroll_mask.png",
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressIn(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelClickIn()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local function create(param)
  local self = base.create("mailcontent")
  setmetatable(self, class.mt)
  param = param or {}
  self.id = param.id
  self.status = param.status
  local attached = param.attached
  self.attached = attached
  local content = param.content or {}
  local touchHandlers
  local body = content.body
  if type(body) == "table" and body.t == "format_mail" then
    body, touchHandlers = ed.mailutil.create(body.mid, body.param)
    content.body = body
  end
  self.touchHandlers = touchHandlers or {}
  self.content = content
  self.title = content.title
  self.body = content.body
  self.from = content.from
  self.attach = content.attach
  self.callback = param.callback
  local mainLayer = self.mainLayer
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/mailbox/mailbox_letter_bg.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  readnode = ed.readnode.create(ui.frame, ui)
  ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(162, 42)
      },
      config = {
        scaleSize = CCSizeMake(165, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(165, 45),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text =  self.attached and T(LSTR("MAILBOX.CLAIM")) or T(LSTR("MAILBOX.CLOSE")),
        fontinfo = "ui_normal_button",
        parent = "ok"
      },
      layout = {
        position = ccp(83, 22)
      },
      config = {
        color = ccc3(236, 222, 209)
      }
    }
  }
  readnode:addNode(ui_info)
  self:createListLayer()
  self:createContent()
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local doClickRead = function(self)
  if self.status == "unread" then
    self:doReadMail()
  else
    self:destroy({
      skipAnim = true,
      callback = self.callback
    })
  end
end
class.doClickRead = doClickRead
local doReadMail = function(self)
  local function doRead()
    ed.netdata.readMail = {
      id = self.id
    }
    function ed.netreply.readMail()
      xpcall(function()
        self:destroy({
          skipAnim = true,
          callback = self.callback
        })
      end, EDDebug)
    end
    local msg = ed.upmsg.read_mail()
    msg._id = self.id
    ed.send(msg, "read_mail")
  end
  local overfull = {}
  local items = self.attachedItems or {}
  for i, v in ipairs(items) do
    local id = v.id
    local amount = v.amount
    local ca = ed.player.equip_qunty[id] or 0
    local da = ca + amount - ed.parameter.max_item_amount
    if da > 0 then
      table.insert(overfull, {id = id, amount = da})
    end
  end
  if #overfull == 0 then
    doRead()
  else
    ed.ui.mailoverfull.pop({
      items = overfull,
      leftCallback = function()
        doRead()
      end
    })
  end
end
class.doReadMail = doReadMail
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "read_button",
    clickHandler = function()
      self:doClickRead()
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      if self.status == "unread" and not self.attached then
        self:doReadMail()
      else
        self:destroy({skipAnim = true})
      end
    end
  })
  self:btRegisterHandler({
    key = "touch_handlers",
    handler = function(event, x, y)
      if event == "began" and not ed.isPointInRect(CCRectMake(22, 75, 284, 325), x, y, self.ui.frame) then
        return
      end
      for i, v in ipairs(self.touchHandlers or {}) do
        v(event, x, y)
      end
    end
  })
end
class.registerTouchHandler = registerTouchHandler

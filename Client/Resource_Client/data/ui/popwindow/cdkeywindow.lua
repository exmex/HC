local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
ed.ui.cdkeywindow = class
local show = function(self)
  local container = self.container
  container:setScale(0)
  self.edit:setVisible(false)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self.edit:setVisible(true)
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
end
class.show = show
local destroy = function(self)
  local container = self.container
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  self.edit:setVisible(false)
  container:runAction(s)
end
class.destroy = destroy
local createEdit = function(self)
  local parent = self.ui.edit_bg
  local fontColor = ccc3(198, 175, 126)
  local info = {
    config = {
      editSize = CCSize(290, 45),
      maxLength = 20,
      fontColor,
      fontSize = 20,
      position = ccp(390, 360)
    }
  }
  local edit = editBox:new(info)
  edit:setPlaceHolder(T(LSTR("CDKEYWINDOW.PLEASE_ENTER_THE_REDEMPTION_CODE")))
  self.mainLayer:addChild(edit.edit)
  self.edit = edit
end
class.createEdit = createEdit
local function createWindow(self)
  local ui = self.ui
  local container = self.container
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
        scaleSize = CCSizeMake(355, 180)
      }
    }
  }
  readnode:addNode(ui_info)
  readnode = ed.readnode.create(ui.frame, ui)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "title",
        text = T(LSTR("CDKEYWINDOW.PLEASE_ENTER_THE_REDEMPTION_CODE_")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, 150)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "edit_bg",
        res = "UI/alpha/HVGA/activate_input.png",
        capInsets = CCRectMake(12, 10, 12, 22)
      },
      layout = {
        position = ccp(175, 95)
      },
      config = {
        scaleSize = CCSizeMake(300, 42)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(20, 20, 28, 29)
      },
      layout = {
        position = ccp(235, 35)
      },
      config = {
        scaleSize = CCSizeMake(110, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(20, 20, 28, 29),
        parent = "ok"
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
        name = "ok_label",
        text = T(LSTR("CHATCONFIG.CONFIRM")),
        fontinfo = "ui_normal_button",
        z = 1,
        parent = "ok"
      },
      layout = {
        position = ccp(55, 23)
      },
      config = {
        color = ccc3(235, 225, 205)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "cancel",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(115, 35)
      },
      config = {
        scaleSize = CCSizeMake(110, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "cancel_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "cancel"
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
        name = "cancel_label",
        text = T(LSTR("CHATCONFIG.CANCEL")),
        fontinfo = "ui_normal_button",
        z = 1,
        parent = "cancel"
      },
      layout = {
        position = ccp(55, 23)
      },
      config = {
        color = ccc3(235, 225, 205)
      }
    }
  }
  readnode:addNode(ui_info)
  self:createEdit()
end
class.createWindow = createWindow
local function create(param)
  local param = param or {}
  local self = base.create("cdkeywindow", param)
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local container = self.container
  container:setPosition(ccp(0, 115))
  local ui = self.ui
  self:createWindow()
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit:touch(event, x, y)
    end,
    key = "edit"
  })
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    clickHandler = function()
      self:doClickok()
    end
  })
  self:btRegisterButtonClick({
    button = ui.cancel,
    press = ui.cancel_press,
    clickHandler = function()
      self:doClickCancel()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local doClickCancel = function(self)
  self:destroy()
end
class.doClickCancel = doClickCancel
local function doAskKeyReply(self)
  local function handler(result, data)
    if result == "already_used" then
      ed.showToast(T(LSTR("CDKEYWINDOW.THIS_REDEMPTION_CODE_DOES_NOT_EXIST_OR_HAS_BEEN_USED")))
      return
    elseif result == "not_exists" then
      ed.showToast(T(LSTR("CDKEYWINDOW.INVALID_REDEMPTION_CODE")))
      return
    elseif result == "once_only" then
      ed.showToast(T(LSTR("CDKEYWINDOW.THIS_REDEMPTION_CODE_DOES_NOT_EXIST_OR_HAS_BEEN_USED")))
      return
    end
    local list = {}
    local money = data._money or 0
    ed.player:addMoney(money)
    if money > 0 then
      table.insert(list, {type = "Gold", amount = money})
    end
    local diamond = data._diamond or 0
    ed.player:addrmb(diamond)
    if diamond > 0 then
      table.insert(list, {type = "Diamond", amount = diamond})
    end
    local items = data._items or {}
    for k, v in pairs(items) do
      local iv = ed.analyzeItem(v)
      local id = iv.id
      local amount = iv.amount
      ed.player:addEquip(id, amount)
      table.insert(list, {
        type = "item",
        id = id,
        amount = amount
      })
    end
    local heroes = data._heroes or {}
    for k, v in pairs(heroes) do
      ed.player:resetHero(v)
      table.insert(list, {
        type = "item",
        id = v._tid,
        amount = 1
      })
    end
    local monthCard = data._month_card
    if monthCard then
      ed.player:refreshMonthCardData(monthCard)
      table.insert(list, {
        type = "MonthCard",
        name = LSTR("cdkeywindow.1.10.1.001"),
        amount = 1
      })
    end
    ed.announce({
      type = "getProp",
      param = {
        title = T(LSTR("CDKEYWINDOW.REDEEMED_SUCCESSFULLY")),
        items = list,
        callback = self:getRewardReplyCallback(heroes),
        forbidPopHero = true
      }
    })
    self:destroy()
  end
  return handler
end
class.doAskKeyReply = doAskKeyReply
local function getRewardReplyCallback(self, heroes)
  local function handler()
    local hs = {}
    for k, v in pairs(heroes or {}) do
      table.insert(hs, v._tid)
    end
    if #hs == 0 then
      return
    end
    local index = 1
    local function popHeroCard(index)
      if hs[index] then
        ed.announce({
          type = "popHeroCard",
          param = {
            id = hs[index],
            callback = function()
              xpcall(function()
                popHeroCard(index + 1)
              end, EDDebug)
            end
          }
        })
      end
    end
    popHeroCard(index)
  end
  return handler
end
class.getRewardReplyCallback = getRewardReplyCallback
local function doAskKey(self)
  local key = self.edit:getString()
  ed.netreply.cdkeyGift = self:doAskKeyReply()
  local msg = ed.upmsg.cdkey_gift()
  msg._cdkey = key
  ed.send(msg, "cdkey_gift")
end
class.doAskKey = doAskKey
local doClickok = function(self)
  self:doAskKey()
end
class.doClickok = doClickok
local doDetachIME = function(self)
end
class.doDetachIME = doDetachIME
local doClickEdit = function(self)
end
class.doClickEdit = doClickEdit

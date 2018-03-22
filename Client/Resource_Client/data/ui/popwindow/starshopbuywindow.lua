local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.starshopbuywindow = class
local shopConsumeReply = function(self, data)
  local function handler(items, heroes)
    local sid = data.sid
    local slotid = data.slotid
    local consumeid = data.consumeid
    local consumeAmount = data.consumeAmount
    ed.player:consumeEquip(consumeid, consumeAmount)
    ed.player:buyShopGoods(sid, slotid)
    local box = "starshop"
    local loots = items
    local addition = {
      destroyHandler = function()
        self.callback(true)
      end
    }
    local popwindow = ed.ui.poptavernloot.pop({
      type = box,
      boxType = data.boxType,
      loots = loots,
      addition = addition
    })
    self:destroy({skipAnim = true})
  end
  return handler
end
class.shopConsumeReply = shopConsumeReply
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_frame",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    key = "cancel_button",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      local cid = self.consumeid
      local camount = self.consumeAmount
      if camount > (ed.player.equip_qunty[cid] or 0) then
        ed.showToast(T(LSTR("STARSHOPBUYWINDOW.NUMBER_OF_SOUL_STONE_IS_INSUFFICIENT_TO_BUY")))
        return
      end
      local data = {
        sid = self.sid,
        slotid = self.slotid,
        consumeid = self.consumeid,
        consumeAmount = self.consumeAmount,
        boxType = self.data.box
      }
      local handler = self:shopConsumeReply(data)
      ed.netdata.tavern = {type = "stone"}
      ed.netreply.tavern = handler
      local boxTypes = {
        stone_green = "stone_green",
        stone_blue = "stone_blue",
        stone_purple = "stone_purple"
      }
      local msg = ed.upmsg.tavern_draw()
      msg._draw_type = "stone"
      msg._box_type = boxTypes[self.data.box]
      ed.send(msg, "tavern_draw")
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  param = param or {}
  local data = param.data or {}
  local addition = param.addition or {}
  local self = base.create("starshopbuywindow")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local container = self.container
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.starshopbuywindow)
  self.data = data
  self.sid = param.sid
  self.slotid = param.slotid
  self.callback = param.callback
  local id = data.payid
  local amount = data.cost
  self.consumeid, self.consumeAmount = id, amount
  local stone_container = ui.icon_container
  local len = 45
  local icon = ed.readequip.createIcon(id, len)
  icon:setAnchorPoint(ccp(0, 0))
  stone_container:addChild(icon)
  ed.setString(ui.amount_label,  T(LSTR("STARSHOPBUYWINDOW.AMOUNT"), amount))
  ed.setString(ui.name_label, addition.name)
  self:ccScene():addChild(mainLayer, 100)
  self:show()
  self:registerTouchHandler()
  return self
end
class.create = create
local show = function(self)
  local ui = self.ui
  local frame = ui.frame
  frame:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  frame:runAction(s)
end
class.show = show
local destroy = function(self, param)
  param = param or {}
  local skipAnim = param.skipAnim
  local ui = self.ui
  local frame = ui.frame
  if not skipAnim then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.mainLayer:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    s = ed.readaction.create({
      t = "seq",
      s,
      func
    })
    frame:runAction(s)
  else
    self.mainLayer:removeFromParentAndCleanup(true)
  end
end
class.destroy = destroy

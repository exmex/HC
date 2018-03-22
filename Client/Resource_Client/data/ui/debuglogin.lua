local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.debuglogin = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.entergame,
    press = ui.entergame_press,
    key = "enter_game",
    clickHandler = function()
      local did = self.edit_box:getString() or ""
      did = string.gsub(did, " ", "")
      if did == "" then
        ed.showToast(T(LSTR("debuglogin.1.10.1.001")))
      else
        ed.setDeviceId(did)
        CCUserDefault:sharedUserDefault():setStringForKey("dn_dvd", did)
        ed.pushScene(ed.ui.serverlogin.create())
      end
    end
  })
  self:btRegisterButtonClick({
    button = ui.edit_frame,
    pressScale = 0.98,
    key = "input_button",
    clickHandler = function()
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
end
class.registerTouchHandler = registerTouchHandler
local function create()
  local self = base.create("debuglogin")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local ui = self.ui
  ui.bg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/splash.jpg"
    },
    layout = {
      position = ccp(400, 240)
    },
    config = {}
  }, mainLayer)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "entergame",
        res = "installer/serverselect_confirm_button_1.png",
        capInsets = CCRectMake(10, 10, 28, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 200)
      },
      config = {
        scaleSize = CCSizeMake(183, 59)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "entergame_press",
        res = "installer/serverselect_confirm_button_2.png",
        capInsets = CCRectMake(10, 10, 28, 29),
        parent = "entergame"
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(183, 59),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "entergame_label",
        text = T(LSTR("SERVERLOGIN.ENTER_THE_GAME")),
        size = 24,
        parent = "entergame"
      },
      layout = {
        position = ccp(92, 30)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    }
  }
  local readNode = ed.readnode.create(mainLayer, ui)
  readNode:addNode(ui_info)
  ui.edit_frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(12, 10, 12, 22)
    },
    layout = {
      position = ccp(400, 260)
    },
    config = {
      scaleSize = CCSizeMake(200, 40)
    }
  }, mainLayer)
  local info = {
    config = {
      editSize = ui.edit_frame:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setString(CCUserDefault:sharedUserDefault():getStringForKey("dn_dvd") or "visitor")
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  ui.edit_frame:addChild(edit_box.edit)
  self.edit_box = edit_box
  self:registerTouchHandler()
  self:registerUpdateHandler("check deveice id", function()
    local str = self.edit_box:getString()
    str = string.gsub(str, " ", "")
    self.edit_box:setString(str)
  end)
  return self
end
class.create = create

local base = ed.ui.popwindow
local class = newclass(base.mt)
local split = ed.ui.herosplit
split.splitconfirm = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:doSplit()
      self:destroy()
    end,
    clickInterval = 0.5
  })
end
class.registerTouchHandler = registerTouchHandler
local doSplit = function(self)
  ed.ui.herosplit.doSplit(self.hid, self.stoneid, self.callback)
end
class.doSplit = doSplit
local initWindow = function(self, hid)
  local ui = self.ui
  local row = ed.getDataTable("Unit")[hid]
  local icon = ed.readhero.createIconByID(hid, {state = "idle"}).icon
  icon:setPosition(ed.DGccp(195, 262))
  ui.frame:addChild(icon)
  local icon = ed.readhero.createIcon({
    id = hid,
    rank = 1,
    stars = row["Initial Stars"],
    level = 1
  }).icon
  icon:setPosition(ed.DGccp(400, 262))
  ui.frame:addChild(icon)
  local name = row["Display Name"]
  local param = {
    t = "ChaosNode",
    base = {},
    layout = {
      anchor = ccp(0, 1),
      position = ed.DGccp(138, 186)
    },
    ui = {
      {
        {
          t = "Label",
          base = {
            text = T(LSTR("confirm.1.10.1.001")),
            size = 20
          },
          config = {
            color = ccc3(255, 227, 133)
          }
        }
      },
      {
        {
          t = "Label",
          base = {
            text = T(LSTR("confirm.1.10.1.002")),
            size = 20
          },
          config = {
            color = ccc3(255, 227, 133)
          }
        },
        {
          t = "Label",
          base = {
            text = name,
            size = 20,
            offset = 5
          },
          config = {}
        },
        {
          t = "Label",
          base = {
            text = "？",
            size = 20,
            offset = 5
          },
          config = {
            color = ccc3(255, 227, 133)
          }
        }
      }
    }
  }
  local node = ed.readnode.getFeralNode(param)
  ui.frame:addChild(node)
end
class.initWindow = initWindow
local function create(hid, stoneid, callback)
  local self = base.create("splitconfirmwindow")
  setmetatable(self, class.mt)
  self.hid = hid
  self.stoneid = stoneid
  self.callback = callback
  local container
  container, self.ui = ed.editorui(ed.uieditor.herosplitconfirm)
  self:setContainer(container)
  self:initWindow(hid)
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local function pop(hid, stoneid, callback)
  local window = create(hid, stoneid, callback)
  window:popWindow()
end
class.pop = pop

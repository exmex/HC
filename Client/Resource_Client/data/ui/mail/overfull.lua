local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.mailoverfull = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "left_button",
    clickHandler = function()
      if self.param.leftCallback then
        self.param.leftCallback()
      end
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "right_button",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local createContent = function(self)
  local info = {
    cliprect = ed.DGRectMake(65, 130, 455, 230),
    noshade = true,
    container = self.ui.frame,
    priority = self.mainTouchPriority - 5,
    zorder = 10
  }
  self.draglist = ed.draglist.create(info)
  local ui = {
    {
      {
        t = "Label",
        base = {
          name = "r_1_1",
          text = T(LSTR("overfull.1.10.1.001")),
          size = 18
        },
        config = {
          color = ccc3(243, 194, 113),
          dimension = ed.DGSizeMake(400, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      }
    },
    {
      {
        t = "Label",
        base = {
          name = "r_2_1",
          text = T(LSTR("overfull.1.10.1.002")),
          size = 18
        },
        config = {
          color = ccc3(243, 194, 113)
        }
      }
    }
  }
  local items = self.param.items or {}
  for i = 1, #items / 4 + 1 do
    local ui_info = {}
    for j = 1, 4 do
      local item = items[4 * (i - 1) + j]
      if item then
        id = item.id
        amount = item.amount
        table.insert(ui_info, {
          t = "CCNode",
          base = {
            name = T("item_%d_%d", i, j),
            node = ed.readequip.createIconWithAmount(id, 60, amount)
          }
        })
      end
    end
    table.insert(ui, ui_info)
  end
  table.insert(ui, {
    {
      t = "Label",
      base = {
        name = "r_3_1",
        text = T(LSTR("overfull.1.10.1.003")),
        size = 18
      },
      config = {
        color = ccc3(243, 194, 113)
      }
    }
  })
  local param = {
    t = "ChaosNode",
    base = {name = "node", offset = 3},
    config = {},
    ui = ui
  }
  local node = ed.readnode.getFeralNode(param)
  node:setAnchorPoint(ccp(0.5, 1))
  node:setPosition(ed.DGccp(296, 355))
  self.draglist:addItem(node)
  self.draglist:initListHeight(node:getContentSize().height)
end
class.createContent = createContent
local function create(param)
  local self = base.create("mailoverfull")
  setmetatable(self, class.mt)
  self.param = param or {}
  local mainLayer = self.mainLayer
  local container = self.container
  local container
  container, self.ui = ed.editorui(ed.uieditor.mailoverfull)
  self:setContainer(container)
  self:createContent()
  self:registerTouchHandler()
  return self
end
class.create = create
local function pop(param)
  local window = create(param)
  window:popWindow(240)
end
class.pop = pop

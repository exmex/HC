local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.explainwindow = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    priority = -1
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local createListLayer = function(self)
  local info = {
    cliprect = ed.DGRectMake(200, 98, 622, 362),
    noshade = true,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    zorder = 20
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local function create(identity, param)
  local self = base.create(identity or "explainwindow", param)
  setmetatable(self, class.mt)
  self.left_x, self.right_x = 160, 634
  self.top_y = 350
  self.label_dimensions = ed.DGSizeMake(612, 0)
  local container
  container, self.ui = ed.editorui(ed.uieditor.explainwindow)
  self:setContainer(container)
  self:registerTouchHandler()
  self:createListLayer()
  return self
end
class.create = create

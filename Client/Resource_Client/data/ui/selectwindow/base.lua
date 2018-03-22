ed.ui.selectwindow = {}
local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.selectwindow.base = class
local lsr = ed.ui.heroselectlsr.create()
local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(154, 60, 492, 365),
    container = self.container,
    priority = self.mainTouchPriority - 5,
    bar = {
      bglen = 320,
      bgpos = ccp(150, 240)
    }
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local createExplain = function(self)
  local param = self.param
  local explain = param.explain
  if not explain then
    return
  end
  self.ui.explain = ed.createNode({
    t = "Label",
    base = {text = explain, size = 20},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(self.left_top_x, self.left_top_y)
    },
    config = {
      dimensions = CCSizeMake(480, 0),
      horizontalAlignment = kCCTextAlignmentLeft,
      color = ccc3(255, 218, 128)
    }
  }, self.draglist.listLayer)
end
class.createExplain = createExplain
local function create(param)
  param = param or {}
  local self = base.create("heroselect", {
    priority = param.priority
  })
  setmetatable(self, class.mt)
  self.left_top_x = 160
  self.left_top_y = 410
  self.explain_offset_y = 15
  self.param = param
  self.name = param.identity
  local mainLayer = self.mainLayer
  local container = self.container
  self.ui = {}
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
        scaleSize = CCSizeMake(530, 375)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:createListLayer()
  self:createExplain()
  self:show({skipAnim = true})
  self:btRegisterOutClick({
    area = self.ui.frame,
    key = "out_frame",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
  return self
end
class.create = create
function ed.ui.selectwindow.create(param)
  local param = param or {}
  local name = param.name
  if name then
    return ed.ui.selectwindow["of" .. name].create(param)
  end
  return nil
end
function ed.ui.selectwindow.pop(param, z)
  local window = ed.ui.selectwindow.create(param)
  window:popWindow(z)
end

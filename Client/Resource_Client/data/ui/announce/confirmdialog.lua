local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.confirmdialog = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "right_button",
    clickHandler = function()
      self:destroy({
        skipAnim = self.param.skipDestroyAnim,
        callback = self.param.rightHandler
      })
    end
  })
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "left_button",
    clickHandler = function()
      self:destroy({
        skipAnim = self.param.skipDestroyAnim,
        callback = self.param.leftHandler
      })
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local initWindow = function(self, param)
  local ui = self.ui
  local leftText = param.leftText
  local rightText = param.rightText
  if leftText then
    ed.setString(ui.left_button_label, leftText)
  end
  if rightText then
    ed.setString(ui.right_button_label, rightText)
  end
  local text = param.text
  local node = param.node
  local location = param.location
  if not text and tolua.isnull(node) then
    return
  end
  if text then
    node = ed.createttf(text, 20)
    if node:getContentSize().width > ed.DGLen(385) then
      ed.setLabelDimensions(node, ed.DGSizeMake(385, 0))
    end
    node:setHorizontalAlignment(kCCTextAlignmentLeft)
  end
  local frame = ui.frame
  local nSize = node:getContentSize()
  local nw, nh = nSize.width, nSize.height
  local w = math.max(500, math.min(nw * 1.28 + 80, 600))
  if param.widthMax then
    w = 600
  end
  ui.left_button:setPosition(ed.DGccp(w / 7 * 2, 58))
  ui.right_button:setPosition(ed.DGccp(w / 7 * 5, 58))
  ui.delimeter:setScaleX(w / 500)
  ui.delimeter:setPosition(ed.DGccp(w / 2, 100))
  node:setAnchorPoint(ccp(0.5, 0))
  node:setPosition(ed.DGccp(w / 2, 135))
  frame:addChild(node)
  frame:setContentSize(ed.DGSizeMake(w, 180 + nh * 1.28))
end
class.initWindow = initWindow
local function create(param)
  local self = base.create("confirmdialog")
  setmetatable(self, class.mt)
  self.param = param or {}
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.confirmdialog)
  self:setContainer(container)
  self:initWindow(param)
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local function pop(param)
  local window = create(param)
  local scene = window.scene
  scene:addChild(window.mainLayer, 1000)
end
class.pop = pop
ed.popConfirmDialog = pop

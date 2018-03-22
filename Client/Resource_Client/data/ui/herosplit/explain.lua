local base = ed.ui.explainwindow
local class = newclass(base.mt)
ed.ui.herosplit.explain = class
local createContent = function(self)
  local lx, rx = self.left_x, self.right_x
  local oy = self.top_y
  local container = self.draglist.listLayer
  local text_list = {
    T(LSTR("explain.1.10.1.001")),
    T(LSTR("explain.1.10.1.002")),
    T(LSTR("explain.1.10.1.003")),
    T(LSTR("explain.1.10.1.004"))
  }
  local dy = 3
  local height = 0
  for i, v in ipairs(text_list) do
    local label = ed.createNode({
      t = "Label",
      base = {text = v, size = 16},
      layout = {
        anchor = ccp(0, 1),
        position = ccp(lx, oy - height)
      },
      config = {
        dimensions = ed.DGSizeMake(612, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        color = ccc3(238, 204, 119),
        dimensions = self.label_dimensions
      }
    })
    container:addChild(label)
    height = height + label:getContentSize().height + dy
  end
  self.draglist:initListHeight(height + 20)
end
class.createContent = createContent
local function create()
  local self = base.create()
  setmetatable(self, class.mt)
  self:createContent()
  return self
end
class.create = create
local function pop()
  local window = create()
  window:popWindow()
end
class.pop = pop

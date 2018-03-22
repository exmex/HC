local class = newclass("g")
ed.widget = {}
local widget = ed.widget
widget.base = class
local function create(identity)
  local self = {}
  setmetatable(self, class.mt)
  self.identity = identity
  return self
end
class.create = create

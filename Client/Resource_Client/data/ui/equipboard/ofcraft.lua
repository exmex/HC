local equipBoard = ed.ui.equipboard
local base = equipBoard
local class = newclass(base.mt)
equipBoard.ofcraft = class
local function create(param)
  param = param or {}
  local self = base.create("equipboardofcraft")
  setmetatable(self, class.mt)
  self.param = param
  self:initFrame({isFeralFrame = true, ignoreClose = true})
  self:initAmount()
  return self
end
class.create = create

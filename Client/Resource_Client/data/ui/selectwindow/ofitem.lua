local base = ed.ui.selectwindow.base
local class = newclass(base.mt)
ed.ui.selectwindow.ofitem = class
local function create(param)
  local self = base.create(param)
  setmetatable(self, class.mt)
  self.item_len = 75
  self.colume_count = 5
  self.item_gap_x = 25
  self.item_gap_y = 20
  self:createItemList()
  return self
end
class.create = create
local getItemPos = function(self, i)
  local ox, oy = self.left_top_x + self.item_len / 2, self.left_top_y - self.item_len / 2
  local en = self.ui.explain
  if not tolua.isnull(en) then
    oy = oy - en:getContentSize().height - self.explain_offset_y
  end
  local x = ox + (self.item_len + self.item_gap_x) * ((i - 1) % self.colume_count)
  local y = oy - (self.item_len + self.item_gap_y) * math.floor((i - 1) / self.colume_count)
  return ccp(x, y)
end
class.getItemPos = getItemPos
local getListHeight = function(self)
  local list = self:getList()
  local h = (self.item_len + self.item_gap_y) * math.ceil(#list / self.colume_count) + 20
  local en = self.ui.explain
  if not tolua.isnull(en) then
    h = h + en:getContentSize().height
    h = h + self.explain_offset_y
  end
  return h
end
class.getListHeight = getListHeight
local createItemList = function(self)
  self.draglist:initListHeight(self:getListHeight())
  local index = 1
  self:getScene():registerUpdateHandler("asyncLoadList", function()
    for i = index, index + 9 do
      self:createItem(i)
    end
    index = index + 10
  end)
end
class.createItemList = createItemList
local createItem = function(self, i)
  local list = self:getList()
  if i > #list then
    self:getScene():removeUpdateHandler("asyncLoadList")
    return
  end
  local v = list[i]
  local icon = ed.readequip.createIconWithAmount(v.id, nil, v.amount)
  icon:setPosition(self:getItemPos(i))
  self.draglist:addItem(icon)
  self:btRegisterButtonClick({
    button = icon,
    pressScale = 0.95,
    key = "item_" .. i,
    clickHandler = function()
      if self.param.callback then
        self.param.callback(v)
      end
      self:destroy({skipAnim = true})
    end,
    force = true,
    mcpMode = true
  })
end
class.createItem = createItem
local getList = function(self)
  if not self.currentItemList then
    local list = {}
    if self.param.itemList then
      list = self.param.itemList
    else
      print("Create Item-SelectWindow without setting the itemList?")
    end
    self.currentItemList = list
  end
  return self.currentItemList
end
class.getList = getList

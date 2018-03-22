local class = newclass()
ed.scrollview = class
local widthOffset, heightOffset, cliprect, shaderect, noshade, container, zorder, priority, direction, useBar, barPosition, barLenOffset, barPosOffset, initHandler, pageSize, rowCount, columnCount, pageCount, pageSequence, oriPosition, itemSize, ox, oy, dx, dy, doPressIn, cancelPressIn, doClickIn, cancelClickIn, xMax, yMax, items
local function create(param)
  local self = {}
  setmetatable(self, class.mt)
  param = param or {}
  widthOffset = param.widthOffset or 0
  heightOffset = param.heightOffset or 0
  cliprect = param.cliprect
  noshade = param.noshade
  shaderect = param.shaderect
  container = param.container
  zorder = param.zorder
  priority = param.priority
  direction = param.direction or "v"
  barThick = param.barThick
  barPosition = param.barPosition
  barLenOffset = param.barLenOffset or 0
  barPosOffset = param.barPosOffset or ccp(0, 0)
  useBar = param.useBar
  initHandler = param.initHandler
  pageSize = param.pageSize or CCSizeMake(1, 1)
  rowCount = pageSize.width
  rowCount = math.max(rowCount, 1)
  columnCount = pageSize.height
  columnCount = math.max(columnCount, 1)
  pageCount = rowCount * columnCount
  pageSequence = param.pageSequence
  oriPosition = param.oriPosition or ccp(0, 0)
  itemSize = param.itemSize or CCSizeMake(0, 0)
  ox, oy = oriPosition.x, oriPosition.y
  dx, dy = itemSize.width, itemSize.height
  doPressIn = param.doPressIn
  cancelPressIn = param.cancelPressIn
  doClickIn = param.doClickIn
  cancelClickIn = param.cancelClickIn
  xMax, yMax = 0, 0
  items = {}
  self.items = items
  local info = {}
  info.cliprect = cliprect
  info.rect = shaderect
  info.noshade = noshade
  info.zorder = zorder
  info.container = container
  info.priority = priority
  if useBar then
    info.bar = self:initBar()
    info.bar.barthick = barThick
  end
  info.doPressIn = doPressIn
  info.cancelPressIn = cancelPressIn
  info.doClickIn = doClickIn
  info.cancelClickIn = cancelClickIn
  self.draglist = ed.draglist.create(info)
  return self
end
class.create = create
local function initBar(self)
  local origin = cliprect.origin
  local size = cliprect.size
  local x, y = origin.x, origin.y
  local w, h = size.width, size.height
  local len, pos
  if direction == "v" then
    len = h - 10 + barLenOffset
    if barPosition == "left" then
      pos = ccpAdd(barPosOffset, ccp(x, y + h / 2))
    else
      pos = ccpAdd(barPosOffset, ccp(x + w, y + h / 2))
    end
  else
    len = w - 10 + barLenOffset
    if barPosition == "top" then
      pos = ccpAdd(barPosOffset, ccp(x + w / 2, y + h))
    else
      pos = ccpAdd(barPosOffset, ccp(x + w / 2, y))
    end
  end
  return {bglen = len, bgpos = pos}
end
class.initBar = initBar
local function getItemXY(self, index)
  local xc = rowCount
  local yc = columnCount
  local tc = pageCount
  local seq
  local x, y = 1, 1
  if direction == "v" then
    seq = pageSequence or "hv"
    if seq == "hv" then
      x = (index - 1) % xc
      x = math.max(x, 0)
      y = math.floor((index - 1) / xc)
      y = math.max(y, 0)
    else
      x = math.floor((index - 1) % tc / yc)
      x = math.max(x, 0)
      y = math.floor((index - 1) / tc) * yc + math.ceil(math.max((index - 1) % tc, 0) % yc)
    end
  else
    seq = pageSequence or "vh"
    if seq == "vh" then
      x = math.floor((index - 1) / yc)
      x = math.max(x, 0)
      y = (index - 1) % yc
      y = math.max(y, 0)
    else
      x = math.floor((index - 1) / tc) * xc + math.ceil(math.max((index - 1) % tc, 0) % xc)
      y = math.floor((index - 1) % tc / xc)
      y = math.max(y, 0)
    end
  end
  xMax = math.max(x, xMax)
  yMax = math.max(y, yMax)
  return x, y
end
class.getItemXY = getItemXY
local function getItemPos(self, index)
  local x, y = self:getItemXY(index)
  local px = ox + dx * x
  local py = oy - dy * y
  return ccp(px, py)
end
class.getItemPos = getItemPos
local function push(self, param)
  param = param or {}
  local index = #items + 1
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  local pos = self:getItemPos(index)
  self.draglist:addItem(container, pos)
  param.container = container
  local item = {
    container = container,
    ui = initHandler(param),
    param = param
  }
  table.insert(items, item)
  self:refreshSize()
end
class.push = push
local addMulti = function(self, params)
  params = params or {}
  for i = 1, #params do
    self:add(params[i], true)
  end
  self:refresh()
end
class.addMulti = addMulti
local function add(self, param, noRefresh)
  param = param or {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  self.draglist:addItem(container, ccp(0, 0))
  param.container = container
  local item = {
    container = container,
    ui = initHandler(param),
    param = param
  }
  table.insert(items, item)
  if not noRefresh then
    self:refresh()
  end
end
class.add = add
local function remove(self, index)
  table.remove(items, index)
  self:refresh()
end
class.remove = remove
local function refresh(self)
  self:order()
  for i = 1, #items do
    local container = items[i].container
    local pos = self:getItemPos(i)
    container:setPosition(pos)
  end
  self:refreshSize()
end
class.refresh = refresh
local function refreshSize(self)
  if direction == "v" then
    self.draglist:initListHeight(dy * (yMax + 1) + heightOffset, false)
  elseif direction == "h" then
    self.draglist:initListWidth(dx * (xMax + 1) + widthOffset, false)
  end
end
class.refreshSize = refreshSize
local function order(self)
  for i = 1, #items do
    for j = i, 2, -1 do
      if (items[j].param.index or 0) < (items[i].param.index or 0) then
        local temp = items[i]
        items[i] = items[j]
        items[j] = temp
      end
    end
  end
end
class.order = order
local function move2end(self, duration, callback)
  if self.draglist.isPressing then
    self.draglist.listLayer:stopAllActions()
    if callback then
      callback()
    end
    return
  end
  local ch = cliprect.size.height
  local lh = dy * (yMax + 1) + heightOffset
  if ch < lh then
    self.draglist.listLayer:stopAllActions()
    local pos = ccp(0, lh - ch)
    local m = CCMoveTo:create(duration, pos)
    m = CCEaseBackOut:create(m)
    local f = CCCallFunc:create(function()
      xpcall(function()
        if callback then
          callback()
        end
      end, EDDebug)
    end)
    self.draglist.listLayer:runAction(ed.readaction.create({
      t = "seq",
      m,
      f
    }))
  elseif callback then
    callback()
  end
end
class.move2end = move2end
local destroy = function(self)
  local layer = self.draglist.mainLayer
  if not tolua.isnull(layer) then
    layer:removeFromParentAndCleanup(true)
  end
end
class.destroy = destroy
local doMoveLayer = function(self, endPos, callback)
  local m = CCMoveTo:create(0.2, endPos)
  m = CCEaseSineOut:create(m)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  self.draglist.listLayer:runAction(ed.readaction.create({
    t = "seq",
    m,
    f
  }))
end
class.doMoveLayer = doMoveLayer
local setTouchEnabled = function(self, enabled)
  self.draglist:setTouchEnabled(enabled)
end
class.setTouchEnabled = setTouchEnabled
local checkTouchInList = function(self, x, y)
  return self.draglist:checkTouchInList(x, y)
end
class.checkTouchInList = checkTouchInList

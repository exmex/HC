local base = ed.ui.basescene
local class = newclass(base.mt)
ed.fruit = ed.fruit or {}
ed.fruit.banana = class
local ox, oy = 75, 372
local dx, dy = 100, 100
local side_len = 4
local total_index = side_len * side_len
local getRandom = function(range)
  math.random()
  math.random()
  math.random()
  if range < 1 then
    return
  end
  return math.random(1, range)
end
local randomBool = function()
  math.random()
  math.random()
  math.random()
  local r = math.random()
  if r < 0.75 then
    return false
  else
    return true
  end
end
local function getMatrixPos(index)
  return index % side_len + 1, math.ceil(index / side_len)
end
class.getMatrixPos = getMatrixPos
local initData = function(self)
  self.actionCount = 0
  self.actionQueue = {}
end
class.initData = initData
local increaseAction = function(self)
  self.actionCount = self.actionCount + 1
end
class.increaseAction = increaseAction
local reduceAction = function(self)
  if self.actionCount > 0 then
    self.actionCount = self.actionCount - 1
  end
  if self.actionCount == 0 then
    self:refreshCellIcon()
    self:throwCell()
  end
end
class.reduceAction = reduceAction
local function initMatrix(self)
  local sideLen = side_len
  local matrix = {}
  for y = 1, sideLen do
    matrix[y] = {}
    for x = 1, sideLen do
      matrix[y][x] = {
        number = 0,
        pos = {x = x, y = y},
        icon = nil,
        rank = number,
        operated = nil
      }
    end
  end
  self.matrix = matrix
  self:throwCell()
  self:throwCell()
end
class.initMatrix = initMatrix
local initCell = function(self, param)
  local x, y = param.x, param.y
  local mx = self.matrix
  mx[y][x] = {
    number = 0,
    pos = {x = x, y = y},
    icon = nil,
    rank = number
  }
end
class.initCell = initCell
local function checkGameOver(self)
  local mx = self.matrix
  isOver = true
  for y = 1, side_len do
    for x = 1, side_len do
      if mx[y][x].number == 0 then
        isOver = false
      end
      local nx, ny = x + 1, y + 1
      nx = math.min(nx, side_len)
      ny = math.min(ny, side_len)
      if ny ~= y then
        if mx[ny][x].number == 0 then
          isOver = false
        end
        if mx[ny][x].number == mx[y][x].number then
          isOver = false
        end
      end
      if nx ~= x then
        if mx[y][nx].number == 0 then
          isOver = false
        end
        if mx[y][nx].number == mx[y][x].number then
          isOver = false
        end
      end
    end
  end
  if isOver then
    self:doGameOver()
  end
end
class.checkGameOver = checkGameOver
local doGameWin = function(self)
  self.puppet:setZOrder(60)
  local winLayer, ui = ed.editorui(ed.uieditor.bananawin, {isShade = true})
  winLayer:setTouchEnabled(true)
  local ftn = ed.ui.basetouchnode.btCreate()
  winLayer:registerScriptTouchHandler(ftn:btGetMainTouchHandler(), false, -100, true)
  self.container:addChild(winLayer, 50)
  ftn:btRegisterButtonClick({
    button = ui.replay,
    press = ui.replay_press,
    key = "replay_button",
    clickHandler = function()
      ed.replaceScene(ed.fruit.banana.create())
    end
  })
  ftn:btRegisterButtonClick({
    button = ui.back,
    press = ui.back_press,
    key = "back_button",
    clickHandler = function()
      winLayer:removeFromParentAndCleanup(true)
      local arrowKeys = {
        "up",
        "down",
        "left",
        "right"
      }
      for i = 1, #arrowKeys do
        local key = arrowKeys[i]
        self:btRemoveMainTouchHandler(key .. "_button")
      end
      self:btRemoveMainTouchHandler("drag_handler")
    end
  })
  self:playHeroCheer({hasEffect = true})
end
class.doGameWin = doGameWin
local doGameOver = function(self)
  self.puppet:setZOrder(60)
  local failedLayer, ui = ed.editorui(ed.uieditor.bananalose, {isShade = true})
  failedLayer:setTouchEnabled(true)
  local ftn = ed.ui.basetouchnode.btCreate()
  failedLayer:registerScriptTouchHandler(ftn:btGetMainTouchHandler(), false, -100, true)
  self.container:addChild(failedLayer, 50)
  ftn:btRegisterButtonClick({
    button = ui.exit,
    press = ui.exit_press,
    key = "exit_button",
    clickHandler = function()
      ed.popScene()
    end
  })
  ftn:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      ed.replaceScene(ed.fruit.banana.create())
    end
  })
  self:playHeroDead()
end
class.doGameOver = doGameOver
local function throwCell(self)
  local mx = self.matrix
  local max = 0
  local leftAmount = {}
  for i = 1, total_index do
    local x, y = getMatrixPos(i)
    local cell = mx[y][x].number
    max = math.max(cell, max)
    if cell == 0 then
      table.insert(leftAmount, {x = x, y = y})
    end
  end
  if #leftAmount < 1 then
    return
  end
  local throwNumber
  local tf = randomBool()
  if tf then
    throwNumber = 2
  else
    throwNumber = 1
  end
  local ri = getRandom(#leftAmount)
  local pos = leftAmount[ri]
  mx[pos.y][pos.x].number = throwNumber
  self:createCellIcon(pos)
  if #leftAmount == 1 then
    self:checkGameOver()
  end
end
class.throwCell = throwCell
local getUpdateActionHandler = function(self)
  local function handler(dt)
    if self.actionCount == 0 and 0 < #self.actionQueue then
      self:doMove(self.actionQueue[1])
      table.remove(self.actionQueue, 1)
    end
  end
  return handler
end
class.getUpdateActionHandler = getUpdateActionHandler
local addMoveAction = function(self, param)
  local oringin = param.oringin
  local ending = param.ending
  local mx = self.matrix
  local icon = oringin.icon
  local oriPos = oringin.pos
  local orix, oriy = oriPos.x, oriPos.y
  local endPos = ending.pos
  local endx, endy = endPos.x, endPos.y
  local pos = self:getCellPosition({x = endx, y = endy})
  local oriNumber = mx[oriy][orix].number
  local endNumber = mx[endy][endx].number
  local toRemove
  if endNumber == 0 then
    mx[endy][endx] = mx[oriy][orix]
  elseif oriNumber == endNumber then
    toRemove = true
    mx[endy][endx].number = endNumber + 1
    mx[endy][endx].operated = true
    if mx[endy][endx].number == 11 then
      self:doGameWin()
    end
    if mx[endy][endx].number > 1 then
      self:playHeroCheer({
        hasEffect = mx[endy][endx].number >= 10
      })
    end
  end
  mx[endy][endx].pos = {x = endx, y = endy}
  self:increaseAction()
  icon:setZOrder(5)
  local move = CCMoveTo:create(0.08, pos)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if toRemove then
        icon:removeFromParentAndCleanup(true)
      end
      self:reduceAction()
    end, EDDebug)
  end)
  local s = ed.readaction.create({
    t = "seq",
    move,
    func
  })
  icon:runAction(s)
end
class.addMoveAction = addMoveAction
local checkCanMove = function(self, origin, ending)
  local mx = self.matrix
  local oriPos = origin.pos
  local endPos = ending.pos
  local ox, oy = oriPos.x, oriPos.y
  local ex, ey = endPos.x, endPos.y
  if ox == ex then
    for i = math.min(oy, ey) + 1, math.max(oy, ey) - 1 do
      if mx[i][ox].number > 0 then
        return false
      end
    end
  end
  if oy == ey then
    for i = math.min(ox, ex) + 1, math.max(ox, ex) - 1 do
      if mx[oy][i].number > 0 then
        return false
      end
    end
  end
  return true
end
class.checkCanMove = checkCanMove
local function doMoveTo(self, param)
  local isAsc = param.isAsc
  local axis = param.axis
  local mx = self.matrix
  local o1, r1, g1, o2, d2, g2
  if isAsc then
    o1, r1, g1 = side_len - 1, 1, -1
    o2, d2, g2 = side_len, 1, -1
  else
    o1, r1, g1 = 2, side_len, 1
    o2, d2, g2 = 1, -1, 1
  end
  for m = 1, side_len do
    for n = o1, r1, g1 do
      local x, y
      if axis == "x" then
        x, y = n, m
      else
        x, y = m, n
      end
      if mx[y][x].number ~= 0 then
        for i = o2, n + d2, g2 do
          local tx, ty
          if axis == "x" then
            tx, ty = i, y
          else
            tx, ty = x, i
          end
          if not mx[ty][tx].operated and (mx[ty][tx].number == 0 or mx[y][x].number == mx[ty][tx].number) and self:checkCanMove(mx[y][x], mx[ty][tx]) then
            self:addMoveAction({
              oringin = mx[y][x],
              ending = mx[ty][tx]
            })
            self:initCell({x = x, y = y})
            break
          end
        end
      end
    end
  end
end
class.doMoveTo = doMoveTo
local function doMove(self, tag)
  local mx = self.matrix
  for i = 1, total_index do
    local x, y = getMatrixPos(i)
    mx[y][x].operated = nil
  end
  if tag == "up" then
    self:doMoveTo({axis = "y", isAsc = false})
  elseif tag == "down" then
    self:doMoveTo({axis = "y", isAsc = true})
  elseif tag == "left" then
    self:doMoveTo({axis = "x", isAsc = false})
  elseif tag == "right" then
    self:doMoveTo({axis = "x", isAsc = true})
  end
end
class.doMove = doMove
local dealMoveAction = function(self, tag)
  if ed.isElementInTable(tag, {
    "up",
    "down",
    "left",
    "right"
  }) then
    table.insert(self.actionQueue, tag)
  end
end
class.dealMoveAction = dealMoveAction
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.back_button,
    press = ui.back_button_press,
    key = "back_button",
    clickHandler = function()
      ed.popScene()
    end
  })
  local arrowKeys = {
    "up",
    "down",
    "left",
    "right"
  }
  for i = 1, #arrowKeys do
    do
      local key = arrowKeys[i]
      self:btRegisterButtonClick({
        button = ui[key],
        pressHandler = function()
          ui[key .. "_button"]:setScale(0.95)
        end,
        cancelPressHandler = function()
          ui[key .. "_button"]:setScale(1)
        end,
        key = key .. "_button",
        clickHandler = function()
          self:dealMoveAction(key)
        end
      })
    end
  end
  self:btRegisterHandler({
    key = "drag_handler",
    handler = self:doDragTouch(),
    priority = 10
  })
end
class.registerTouchHandler = registerTouchHandler
local doDragTouch = function(self)
  local px, py
  local function handler(event, x, y)
    if event == "began" then
      px, py = x, y
    elseif event == "ended" then
      if not px or not py then
        return
      end
      local tag
      local dx = x - px
      local dy = y - py
      if math.abs(dx) > 100 or math.abs(dy) > 100 then
        if math.abs(dx) >= math.abs(dy) then
          if dx < 0 then
            tag = "left"
          else
            tag = "right"
          end
        elseif dy > 0 then
          tag = "up"
        else
          tag = "down"
        end
        self:dealMoveAction(tag)
      end
    end
  end
  return handler
end
class.doDragTouch = doDragTouch
local function createMatrixBackground(self)
  local ui = self.ui
  local frame = ui.matrix_bg
  for i = 1, 16 do
    local bg = ed.createSprite("UI/alpha/HVGA/dailylogin/dailylogin_matrix.png")
    bg:setScale(80 / bg:getContentSize().width)
    local ix = (i - 1) % 4
    local iy = math.floor((i - 1) / 4)
    local x = ox + dx * ix
    local y = oy - dy * iy
    bg:setPosition(ed.DGccp(x, y))
    frame:addChild(bg)
  end
end
class.createMatrixBackground = createMatrixBackground
local function getHeroId(self)
  if not self.hid then
    local index = getRandom(#ed.player.heroes)
    if index == 0 then
      self.hid = 1
    end
    local hero = ed.player.heroes[index]
    if not hero then
      self.hid = 1
    else
      self.hid = hero._tid
    end
  end
  return self.hid
end
class.getHeroId = getHeroId
local createHero = function(self)
  self.puppet, self.cha = ed.readhero.getActor(self.hid, "Idle")
  self.puppet:setPosition(ccp(120, 40))
  self.container:addChild(self.puppet, 5)
  self:addFca(self.puppet)
  self.preFca = "Idle"
  self:btRegisterRectClick({
    rect = CCRectMake(60, 40, 235, 260),
    key = "hero_button",
    clickHandler = function()
      self:changeFca()
    end
  })
end
class.createHero = createHero
local changeFca = function(self, name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local act = {}
  local duration = {}
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(act, k)
        table.insert(duration, v.Duration)
      end
    elseif not ed.isElementInTable(k, {
      "Death",
      "Idle",
      "Damaged",
      "Cheer"
    }) and k ~= self.preFca then
      table.insert(act, k)
      table.insert(duration, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #act)
  end
  local fca = act[index]
  self.preFca = fca
  self.fcaDuration = duration[index]
  self.puppet:setAction(fca)
  if fca ~= "Move" then
    self.puppet:setLoop(false)
  else
    self.puppet:setLoop(true)
  end
  self:registerUpdateHandler("checkFcaHandler", self:getCheckFcaHandler(fca))
end
class.changeFca = changeFca
local playHeroCheer = function(self, param)
  param = param or {}
  local hasEffect = param.hasEffect
  self:changeFca("Cheer")
  if hasEffect then
    local hid = self.hid
    local effect = ed.getDataTable("Unit")[hid]["Voice Upgrade"]
    if effect then
      ed.playEffect(effect)
    end
  end
end
class.playHeroCheer = playHeroCheer
local playHeroDead = function(self)
  self:changeFca("Death")
end
class.playHeroDead = playHeroDead
local getCheckFcaHandler = function(self, fca)
  local count = 0
  local function handler(dt)
    count = count + dt
    if fca ~= "Move" and count > self.fcaDuration then
      if not tolua.isnull(self.puppet) then
        self.puppet:setAction("Idle")
        self.puppet:setLoop(true)
      end
      self:removeUpdateHandler("checkFcaHandler")
    end
  end
  return handler
end
class.getCheckFcaHandler = getCheckFcaHandler
local function create()
  local self = base.create("banana")
  setmetatable(self, class.mt)
  math.randomseed(ed.getMillionTime() * 1000)
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.banana)
  mainLayer:addChild(container)
  self.container = container
  self:createMatrixBackground()
  self:registerTouchHandler()
  self:initData()
  self:initMatrix()
  self:createHero()
  self:registerUpdateHandler("updateAction", self:getUpdateActionHandler())
  return self
end
class.create = create
local function getCellPosition(self, param)
  local x, y = param.x, param.y
  return ed.DGccp(ox + dx * (x - 1), oy - dy * (y - 1))
end
class.getCellPosition = getCellPosition
local createCellIcon = function(self, param)
  local x, y = param.x, param.y
  local hid = self:getHeroId()
  local mx = self.matrix
  local cell = mx[y][x]
  local rank = cell.number
  if rank < 0 then
    return
  end
  if not tolua.isnull(cell.icon) then
    cell.icon:removeFromParentAndCleanup(true)
  end
  local text = {
    nil,
    nil,
    "+1",
    nil,
    "+1",
    "+2",
    nil,
    "+1",
    "+2",
    "+3"
  }
  local icon = ed.readhero.createIcon({
    id = hid,
    rank = rank,
    length = 70,
    text = text[rank],
    textColor = ed.Hero.getHeroNameColorByRank(rank)
  }).icon
  mx[y][x].rank = rank
  mx[y][x].icon = icon
  icon:setPosition(self:getCellPosition(param))
  self.ui.matrix_bg:addChild(icon, 10)
  local oriScale = icon:getScale()
  icon:setScale(0)
  local action = CCScaleTo:create(0.2, oriScale)
  action = CCEaseBackOut:create(action)
  icon:runAction(action)
end
class.createCellIcon = createCellIcon
local function refreshCellIcon(self)
  local mx = self.matrix
  for i = 1, total_index do
    local x, y = getMatrixPos(i)
    local cell = mx[y][x]
    if not tolua.isnull(cell.icon) and cell.number ~= cell.rank then
      self:createCellIcon({x = x, y = y})
    end
  end
end
class.refreshCellIcon = refreshCellIcon

richText = {}
richText.__index = richText
richText.rootNode = nil
richText.pos = nil
richText.middle = false
richText.anchor = ccp(0, 0.5)
richText.lastValidHeight = 0
richText.width = 0
richText.height = 0
richText.link = nil
function richText:init()
  self.rootNode = CCNode:create()
end
function richText:new()
  local obj = {}
  setmetatable(obj, self)
  obj:init()
  return obj
end
function richText:setVisible(visible)
  if self.rootNode then
    self.rootNode:setVisible(visible)
  end
end
function richText:setMiddle(middle)
  self.middle = middle
end
function richText:setPosition(pos)
  self.pos = pos
  self.rootNode:setPosition(pos)
end
function richText:createNewObject(param, extraData)
  if nil == param then
    return
  end
  local type, param1, param2, param3 = unpack(param)
  local newObject
  local width, height = 0, nil
  local scale = 1
  if type == "text" then
    newObject = ed.createLabelWithFontInfo(param2, param1)
    if param3 then
      newObject:setDimensions(CCSizeMake(param3, 0))
    end
    newObject:setHorizontalAlignment(kCCTextAlignmentLeft)
    width = newObject:getTextureRect().size.width
    height = newObject:getTextureRect().size.height
  elseif type == "sprite" then
    newObject = ed.createSprite(param1)
    if param2 then
      newObject:setScale(param2)
      scale = param2
    end
    width = newObject:getTextureRect().size.width * scale
    height = newObject:getTextureRect().size.height * scale
  elseif type == "artnum" then
    newObject = CCNode:create()
    width, height = ed.createNumbers(newObject, param2, -2, nil, param1)
  elseif type == "item" then
    if param3 then
      newObject = ed.readequip.createIconWithAmount(tonumber(param1), nil, tonumber(param3) or 1)
    else
      newObject = ed.readequip.createIcon(tonumber(param1))
    end
    if param2 then
      newObject:setScale(param2)
      scale = param2
    end
    width = newObject:getTextureRect().size.width * scale
    height = newObject:getTextureRect().size.height * scale
  elseif type == "link" then
    local link = ed.createSuperLink(param1, param2, param3)
    self.link = link
    if extraData then
      link:setExtraData(extraData)
    end
    newObject = link:getLabel()
    if ed.isElementInTable(link.type, {"pvp"}) then
      newObject:setHorizontalAlignment(kCCTextAlignmentLeft)
    elseif ed.isElementInTable(link.type, {"excavate"}) then
      newObject:setAnchorPoint(ccp(0, 0.5))
    end
    local size = link:getSize()
    width, height = size.width, size.height
  else
    return nil
  end
  if newObject then
    self.rootNode:addChild(newObject)
  end
  return newObject, width, height
end
function richText:refreshPos(width)
  if self.middle == false then
    return
  end
  local posx, posy
  if self.pos == nil then
    posx, posy = self.rootNode:getPosition()
    self.pos = ccp(posx, posy)
  else
    posx = self.pos.x
    posy = self.pos.y
  end
  posx = posx - width / 2
  self.rootNode:setPosition(ccp(posx, posy))
end
function richText:setAnchor(anchor)
  self.anchor = anchor
end
function richText:getSize()
  return self.width, self.height
end
function richText:setString(content, extraData)
  if type(content) ~= "string" then
    print("richText content must be string!!")
  end
  self.rootNode:removeAllChildrenWithCleanup(true)
  local startPos = ccp(0, 0)
  local changeLine = false
  local tempHeight = 0
  for str in string.gmatch(content, "<.->") do
    local t = {}
    local i = 0
    local temp = string.sub(str, 2, string.len(str) - 1)
    while true do
      local start = string.find(temp, "|", i + 1)
      if start == nil then
        table.insert(t, string.sub(temp, i + 1, string.len(temp)))
        break
      end
      table.insert(t, string.sub(temp, i + 1, start - 1))
      i = start
      if t[1] == "text" and #t == 2 then
        start = string.find(temp, "|", i + 1)
        if start == nil then
          table.insert(t, string.sub(temp, i + 1, string.len(temp)))
          break
        end
        do
          local num = string.sub(temp, start + 1, string.len(temp))
          if tonumber(num) ~= nil then
            table.insert(t, string.sub(temp, i + 1, start - 1))
            table.insert(t, num)
            break
          end
          table.insert(t, string.sub(temp, i + 1, string.len(temp)))
        end
        break
      end
    end
    local newObject, width, height = self:createNewObject(t, extraData)
    if newObject then
      if changeLine == true then
        changeLine = false
        startPos.x = 0
        startPos.y = startPos.y - height * (1 - self.anchor.y) - self.lastValidHeight * self.anchor.y
      end
      newObject:setPosition(startPos)
      newObject:setAnchorPoint(self.anchor)
      startPos.x = startPos.x + width
      self.lastValidHeight = height
      if startPos.x > self.width then
        self.width = startPos.x
      end
      if tempHeight < height then
        tempHeight = height
      end
    else
      self.height = self.height + tempHeight
      tempHeight = 0
      changeLine = true
    end
  end
  self.height = self.height + tempHeight
  self:refreshPos(startPos.x)
end
function richText:getRootNode()
  return self.rootNode
end
function richText:getControllerSize()
  local minx, miny = 10000, 10000
  local maxx, maxy = -10000, -10000
  local childCount = self.rootNode:getChildrenCount()
  local children = self.rootNode:getChildren()
  if children then
    for i = 0, children:count() - 1 do
      local child = children:objectAtIndex(i)
      if child then
        local rect = ed.getNodeSize(child)
        if rect then
          if minx > rect:getMinX() then
            minx = rect:getMinX()
          end
          if maxx < rect:getMaxX() then
            maxx = rect:getMaxX()
          end
          if miny > rect:getMinY() then
            miny = rect:getMinY()
          end
          if maxy < rect:getMaxY() then
            maxy = rect:getMaxY()
          end
        end
      end
    end
  end
  return minx, maxx, miny, maxy
end
function richText:getLink()
  return self.link
end

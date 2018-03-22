local list_node = {}
list_node.value = nil
list_node.next = nil
list_node.prev = nil
function list_node:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end
list_iterator = {}
list_iterator.node = nil
list_iterator.owner = nil
function list_iterator:new(_owner)
  local object = {}
  setmetatable(object, self)
  self.__index = self
  object.owner = _owner
  return object
end
function list_iterator:next(count)
  count = count or 1
  for i = 1, count do
    if self.node ~= nil then
      self.node = self.node.next
    else
      return false
    end
  end
  return self.node ~= nil
end
function list_iterator:prev(count)
  count = count or 1
  for i = 1, count do
    if self.node ~= nil then
      self.node = self.node.prev
    else
      return false
    end
  end
  return self.node ~= nil
end
function list_iterator:value()
  if self.node ~= nil then
    return self.node.value
  end
  return nil
end
function list_iterator:erase()
  if self.owner ~= nil then
    return self.owner:erase(self)
  end
end
function list_iterator:valid()
  return self.owner ~= nil and self.node ~= nil
end
list = {}
list.first = nil
list.last = nil
function list:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end
function list:push_back(value)
  if nil == self.last or nil == self.first then
    self.first = list_node:new()
    self.last = self.first
    self.last.value = value
    return
  end
  local newNode = list_node:new()
  newNode.prev = self.last
  newNode.value = value
  self.last.next = newNode
  self.last = newNode
end
function list:pop_back()
  if nil == self.last then
    return nil
  end
  local back = self:back()
  local prevNode = self.last.prev
  if prevNode == nil then
    self.first = nil
    self.last = nil
  else
    prevNode.next = nil
    self.last = prevNode
  end
  return back
end
function list:push_front(value)
  if nil == self.first or nil == self.last then
    self.first = list_node:new()
    self.last = self.first
    self.last.value = value
    return
  end
  local newNode = list_node:new()
  newNode.value = value
  newNode.next = self.first
  self.first.prev = newNode
  self.first = newNode
end
function list:pop_front()
  if nil == self.first then
    return nil
  end
  local front = self:front()
  local nextNode = self.first.next
  if nextNode == nil then
    self.first = nil
    self.last = nil
  else
    nextNode.prev = nil
    self.first = nextNode
  end
  return front
end
function list:front()
  if self.first ~= nil then
    return self.first.value
  end
  return nil
end
function list:back()
  if self.last ~= nil then
    return self.last.value
  end
  return nil
end
function list:empty()
  return nil == self.first or nil == self.last
end
function list:clear()
  self.first = nil
  self.last = nil
end
function list:Begin()
  local itr = list_iterator:new(self)
  itr.node = self.first
  return itr
end
function list:End()
  local itr = list_iterator:new(self)
  itr.node = self.last
  return itr
end
function list:find(v, start)
  if start == nil then
    start = self:Begin()
  end
  repeat
    if v == start:value() then
      return start
    end
  until start:next() == false
  return nil
end
function list:rfind(v, start)
  if start == nil then
    start = self:End()
  end
  repeat
    if v == start:value() then
      return start
    end
  until start:prev() == false
  return nil
end
function list:erase(itr)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return itr
  end
  local nextItr = list_iterator:new(self)
  nextItr.node = itr.node
  nextItr:next()
  if itr.node == self.first then
    self:pop_front()
  elseif itr.node == self.last then
    self:pop_back()
  else
    local prevNode = itr.node.prev
    local nextNode = itr.node.next
    if prevNode ~= nil then
      prevNode.next = nextNode
    end
    if nextNode ~= nil then
      nextNode.prev = prevNode
    end
  end
  itr.owner = nil
  itr.node = nil
  return nextItr
end
function list:erase_value(value)
  local itr = self:find(value)
  self:erase(itr)
end
function list:erase_all(value)
  local itr = self:find(value)
  while itr ~= nil and itr:valid() do
    itr = self:erase(itr)
    itr = self:find(value, itr)
  end
end
function list:insert(itr, value)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return
  end
  local result_itr = list_iterator:new(self)
  if itr.node == self.last then
    self:push_back(value)
    result_itr.node = self.last
  else
    local prevNode = itr.node
    local nextNode = itr.node.next
    local newNode = list_node:new()
    newNode.value = value
    prevNode.next = newNode
    nextNode.prev = newNode
    newNode.next = nextNode
    newNode.prev = prevNode
    result_itr.node = newNode
  end
  return result_itr
end
function list:insert_before(itr, value)
  if nil == itr or nil == itr.node or itr.owner ~= self then
    return
  end
  local result_itr = list_iterator:new(self)
  if itr.node == self.first then
    self:push_front(value)
    result_itr.node = self.first
  else
    local prevNode = itr.node.prev
    local nextNode = itr.node
    local newNode = list_node:new()
    newNode.value = value
    prevNode.next = newNode
    nextNode.prev = newNode
    newNode.next = nextNode
    newNode.prev = prevNode
    result_itr.node = newNode
  end
  return result_itr
end
function ilist(l)
  local itr_first = list_iterator:new(l)
  itr_first.node = list_node:new()
  itr_first.node.next = l.first
  local ilist_it = function(itr)
    itr:next()
    local v = itr:value()
    if v ~= nil then
      return v, itr
    else
      return nil
    end
  end
  return ilist_it, itr_first
end
function rilist(l)
  local itr_last = list_iterator:new(l)
  itr_last.node = list_node:new()
  itr_last.node.prev = l.last
  local rilist_it = function(itr)
    itr:prev()
    local v = itr:value()
    if v ~= nil then
      return v, itr
    else
      return nil
    end
  end
  return rilist_it, itr_last
end
function list:Print()
  for v in ilist(self) do
    print(tostring(v))
  end
end
function list:size()
  local count = 0
  for v in ilist(self) do
    count = count + 1
  end
  return count
end
function list:clone()
  local newList = list:new()
  for v in ilist(self) do
    newList:push_back(v)
  end
  return newList
end

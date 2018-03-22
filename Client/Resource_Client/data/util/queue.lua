local Queue = {}
function Queue.create(table)
  local queue = {first = 1, last = 0}
  return {
    length = function()
      local first, last = queue.first, queue.last
      if first > last then
        return 0
      end
      return last - first + 1
    end,
    left = function()
      local first, last = queue.first, queue.last
      if first > last then
        return nil
      end
      return queue[first]
    end,
    right = function()
      local first, last = queue.first, queue.last
      if first > last then
        return nil
      end
      return queue[last]
    end,
    pushLeft = function(value)
      assert(value, "Queue.pushLeft: cannot push nil value.")
      local first = queue.first - 1
      queue.first = first
      queue[first] = value
    end,
    popLeft = function()
      local first = queue.first
      if first > queue.last then
        return nil
      end
      local value = queue[first]
      queue[first] = nil
      queue.first = first + 1
      if value.onPop then
        value:onPop()
      end
      return value
    end,
    pushRight = function(value)
      assert(value, "Queue.pushRight: cannot push nil value.")
      local last = queue.last + 1
      queue.last = last
      queue[last] = value
    end,
    popRight = function()
      local last = queue.last
      if last < queue.first then
        return nil
      end
      local value = queue[last]
      queue[last] = nil
      queue.last = last - 1
      if value.onPop then
        value:onPop()
      end
      return value
    end
  }
end
return Queue

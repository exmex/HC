local SystemEvent = Event:new()
SystemEvent.Name = ""
SystemEvent.Timer = nil
SystemEvent.Scope = nil
function SystemEvent:SetTimer(timer)
  self.Timer = timer
end
function SystemEvent:Update(deltTime)
  local timer = self.Timer
  if timer == nil then
    return
  end
  if timer.AlwaysRepeat == true then
    timer:UpdateAlways(self, deltTime)
  elseif timer.RepeatCount > 0 then
    timer:UpdateTimes(self, deltTime)
  elseif timer.RepeatCount <= 0 then
    return true
  end
  return false
end
function SystemEvent:Open(name, scope)
  self.Name = name
  if nil == scope then
    return
  end
  if nil == scope.Events then
    scope.Events = {}
  end
  if nil == scope.Events[self.Name] then
    scope.Events[self.Name] = true
  end
  self.Scope = scope
end
function SystemEvent:Close()
  local scope = self.Scope
  if nil == scope then
    return
  end
  if scope.Events ~= nil then
    scope.Events[self.Name] = nil
  end
  self.Scope = nil
end
function SystemEvent:Print()
  print("event name:" .. self.Name)
  print("event scope:" .. self.Scope)
  print("event responsers:" .. self.Responsers:size())
  print("event triggers:" .. self.Triggers:size())
  if self.Timer ~= nil then
    print("event Timer:")
    print("\tInterval:" .. self.Timer.Interval)
    print("\tRepeatCount:" .. self.Timer.RepeatCount)
    print("\tAlwaysRepeat:" .. tostring(self.Timer.AlwaysRepeat))
    print("\tCurTime:" .. self.Timer.CurTime)
  end
end
Timer = {}
Timer.Interval = 0
Timer.RepeatCount = 0
Timer.AlwaysRepeat = false
Timer.CurTime = 0
Timer.TotalTime = 0
Timer.Name = nil
function Timer:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end
function Timer:getName()
  return self.Name
end
function Timer:Clone()
  local newTimer = Timer:new()
  newTimer.Interval = self.Interval
  newTimer.AlwaysRepeat = self.AlwaysRepeat
  if not self.AlwaysRepeat then
    newTimer.RepeatCount = self.RepeatCount
  end
  return newTimer
end
function Timer:Always(interval, name)
  if interval == nil then
    interval = 0
  end
  local timer = Timer:new()
  timer.Interval = interval
  timer.AlwaysRepeat = true
  timer.Name = name
  return timer
end
function Timer:Times(interval, count)
  local timer = Timer:new()
  timer.Interval = interval
  timer.AlwaysRepeat = false
  timer.RepeatCount = count
  return timer
end
function Timer:Once(interval)
  return Timer:Times(interval, 1)
end
function Timer:UpdateTimes(event, deltTime)
  self.CurTime = self.CurTime + deltTime
  self.TotalTime = self.TotalTime + deltTime
  if self.CurTime >= self.Interval then
    if event ~= nil and event:Fire(self.CurTime, self.TotalTime) then
      self.RepeatCount = self.RepeatCount - 1
    end
    self.CurTime = 0
  end
end
function Timer:UpdateAlways(event, deltTime)
  self.CurTime = self.CurTime + deltTime
  self.TotalTime = self.TotalTime + deltTime
  if self.CurTime >= self.Interval then
    if event ~= nil then
      event:Fire(self.CurTime, self.TotalTime)
    end
    self.CurTime = 0
  end
end
function Timer:Update(deltTime)
  self.CurTime = self.CurTime + deltTime
  self.TotalTime = self.TotalTime + deltTime
end
function Timer:CanTigger()
  if self.CurTime >= self.Interval then
    self.CurTime = 0
    if self.AlwaysRepeat then
      return true
    end
    if 0 < self.RepeatCount then
      self.RepeatCount = self.RepeatCount - 1
      return true
    end
  end
  return false
end
local EventSystem = {}
local NeedUpdateEvents = {}
local NoNeedUpdateEvents = {}
local NewCreatedEvents = {}
local UpdateInternal = 0.01
local UpdatePassTime = 0
local function SystemEventDispatcher(event)
  if event == nil then
    return
  end
  if event.Timer ~= nil and event:ResponserCount() > 0 then
    NeedUpdateEvents[event.Name] = event
    NoNeedUpdateEvents[event.Name] = nil
    NewCreatedEvents[event.Name] = nil
  elseif event:ResponserCount() > 0 then
    NeedUpdateEvents[event.Name] = nil
    NoNeedUpdateEvents[event.Name] = event
    NewCreatedEvents[event.Name] = nil
  elseif event.Timer ~= nil or 0 < event:TriggerCount() then
    NeedUpdateEvents[event.Name] = nil
    NoNeedUpdateEvents[event.Name] = nil
    NewCreatedEvents[event.Name] = event
  else
    EventSystem.Close(event.Name)
  end
end
function EventSystem.Open(name, scope)
  if nil == name then
    return nil
  end
  if NeedUpdateEvents[name] ~= nil then
    return NeedUpdateEvents[name]
  end
  if NoNeedUpdateEvents[name] ~= nil then
    return NoNeedUpdateEvents[name]
  end
  if NewCreatedEvents[name] ~= nil then
    return NewCreatedEvents[name]
  end
  local event = SystemEvent:new()
  event:Open(name, scope)
  NewCreatedEvents[name] = event
  return event
end
function EventSystem.Close(name)
  if nil == name then
    return
  end
  local event = EventSystem.Find(name)
  if nil == event then
    return
  end
  event:Close()
  NeedUpdateEvents[name] = nil
  NoNeedUpdateEvents[name] = nil
  NewCreatedEvents[name] = nil
end
function EventSystem.CloseScope(scope)
  if nil == scope then
    return
  end
  if nil == scope.Events then
    return
  end
  for k, v in pairs(scope.Events) do
    EventSystem.Close(k)
  end
  scope = nil
end
function EventSystem.Find(name)
  if nil == name then
    return nil
  end
  if NeedUpdateEvents[name] ~= nil then
    return NeedUpdateEvents[name]
  end
  if NoNeedUpdateEvents[name] ~= nil then
    return NoNeedUpdateEvents[name]
  end
  if NewCreatedEvents[name] ~= nil then
    return NewCreatedEvents[name]
  end
  return nil
end
function EventSystem.Bind(name, func)
  local event = EventSystem.Find(name)
  if event ~= nil then
    event:Bind(func)
    SystemEventDispatcher(event)
    return true
  end
  return false
end
function EventSystem.Unbind(name, func)
  local event = EventSystem.Find(name)
  if event ~= nil then
    event:Unbind(func)
    SystemEventDispatcher(event)
    return true
  end
  return false
end
function EventSystem.Fire(name, ...)
  if nil == name then
    return
  end
  local event = NoNeedUpdateEvents[name]
  if event ~= nil then
    event:Fire(...)
  end
  return false
end
function EventSystem.BindTrigger(name, func)
  local event = EventSystem.Find(name)
  if event ~= nil then
    event:BindTrigger(func)
    return true
  end
  return false
end
function EventSystem.UnbindTrigger(name, func)
  local event = EventSystem.Find(name)
  if event ~= nil then
    event:UnbindTrigger(func)
    return true
  end
  return false
end
function EventSystem.SetTimer(name, timer)
  local event = EventSystem.Find(name)
  if event ~= nil then
    event:SetTimer(timer)
    SystemEventDispatcher(event)
    return true
  end
  return false
end
function EventSystem.Update(deltTime)
  UpdatePassTime = deltTime + UpdatePassTime
  if UpdatePassTime < UpdateInternal then
    return
  end
  for k, event in pairs(NeedUpdateEvents) do
    if event ~= nil then
      local delete = event:Update(UpdatePassTime)
      if delete then
        EventSystem.Close(k)
      end
    end
  end
  UpdatePassTime = 0
end
local GlobleScope = {}
function UpdateEventSystem(deltTime)
  EventSystem.Update(deltTime)
end
function FireEvent(name, ...)
  return EventSystem.Fire(name, ...)
end
function PrintEvent(name)
  local event = EventSystem.Find(name)
  if event ~= nil then
    return event:Print()
  end
end
function ListenEvent(eventType, func, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("listen event no scope")
    return nil
  end
  if nil == eventType then
    print("listen event no event")
  end
  if nil == func then
    print("listen event no func")
    return nil
  end
  local event = EventSystem.Open(eventType, scope)
  if event ~= nil then
    EventSystem.Bind(event.Name, func)
  end
  return event
end
function StopListenEvent(eventType, func)
  if nil == eventType then
    print("listen event no event")
  end
  if nil == func then
    print("listen event no func")
    return nil
  end
  return EventSystem.Unbind(eventType, func)
end
function AddTriggerEvent(eventType, timer, trigger, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("add Trigger no scope")
    return nil
  end
  if nil == eventType then
    print("add Trigger no eventname")
  end
  if nil == timer then
    print("add Trigger no timer")
    return nil
  end
  local event = EventSystem.Open(eventType, scope)
  if nil == event then
    return nil
  end
  EventSystem.SetTimer(eventType, timer)
  EventSystem.BindTrigger(eventType, trigger)
  return event
end
function CloseEvent(name)
  EventSystem.Close(name)
end
function ListenTimer(timer, func, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("listen timer no scope")
    return nil
  end
  if nil == timer then
    print("listen timer no timer")
    return nil
  end
  if nil == func then
    print("listen timer no func")
    return nil
  end
  local name = timer:getName() and timer:getName() or "Timer_" .. tostring(timer)
  local event = EventSystem.Open(name, scope)
  if event ~= nil then
    EventSystem.Bind(name, func)
  end
  EventSystem.SetTimer(name, timer)
  return event
end
function CloseTimer(name)
  EventSystem.Close(name)
end
function CloseScope(scope)
  EventSystem.CloseScope(scope)
end

local Trigger = {}
Trigger.Func = nil
function Trigger:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end
function Trigger:Check(event, ...)
  return self.Func(event, self, ...)
end
Responser = {}
Responser.Func = nil
Responser.Filter = nil
function Responser:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end
function Responser:Fire(fireData, ...)
  if fireData == nil then
    self.Func(...)
  else
    self.Func(fireData, ...)
  end
end
Event = {}
function Event:Error(title, msg)
  print("Error:" .. title .. msg)
end
function Event:new()
  local object = {}
  setmetatable(object, self)
  self.__index = self
  object.Responsers = list:new()
  object.Triggers = list:new()
  object.ExtraData = nil
  return object
end
function Event:Bind(exe)
  if nil == exe then
    return
  end
  local newExe = exe
  if type(exe) == "function" then
    newExe = Responser:new()
    newExe.Func = exe
  end
  self.Responsers:push_back(newExe)
end
function Event:Unbind(exe)
  if exe == nil then
    return
  end
  local isFunc = type(exe) == "function"
  for _responser, itr in rilist(self.Responsers) do
    if _responser ~= nil and (isFunc == true and _responser.Func == exe or isFunc == false and _responser == exe) then
      self.Responsers:erase(itr)
      return
    end
  end
end
function Event:Fire(...)
  if not self:Check(...) then
    return false
  end
  for responser in ilist(self.Responsers) do
    if responser ~= nil then
      responser.Fire(responser, self.ExtraData, ...)
    end
  end
  return true
end
function Event:BindTrigger(func)
  if func == nil then
    return
  end
  local newTrigger = func
  if type(func) == "function" then
    newTrigger = Trigger:new()
    newTrigger.Func = func
  end
  self.Triggers:push_back(newTrigger)
end
function Event:UnbindTrigger(func)
  if func == nil then
    return
  end
  local isFunc = type(func) == "function"
  for _trigger, itr in rilist(self.Triggers) do
    if _trigger ~= nil and (isFunc == true and _trigger.Func == func or isFunc == false and _trigger == func) then
      self.Triggers:erase(itr)
      return
    end
  end
end
function Event:Check(...)
  for trigger in ilist(self.Triggers) do
    if trigger ~= nil then
      local bOk, bResult = pcall(trigger.Check, trigger, self, ...)
      if not bOk then
        self:Error("Trigger", bResult)
        return false
      end
      if not bResult then
        return false
      end
    end
  end
  return true
end
function Event:ResponserCount()
  return self.Responsers:size()
end
function Event:TriggerCount()
  return self.Triggers:size()
end

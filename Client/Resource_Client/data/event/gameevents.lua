local EventsFactory = {}
testData = 1
EventsFactory.StoryEvent = {
  eventName = "ShowStory",
  createCondition = function()
    if testData == 1 then
      return true
    else
      return false
    end
  end,
  tigger = function(event)
    if event.testData == nil and testData == 2 then
      event.testData = 2
      event.ExtraData = "newPlayerStory"
      return true
    end
    if event.testData ~= nil then
      CloseEvent(event.Name)
    end
    return false
  end,
  timer = Timer:Always(1)
}
pcall(function()
  for k, v in pairs(EventsFactory) do
    if v.createCondition() then
      AddTriggerEvent(v.eventName, v.timer, v.tigger)
    end
  end
end)

local ed = ed
local self = ed.ui.PanelCreate()
ed.ui.testPanel = self
self.node:retain()
self.layout = ed.ui.layout.fill
self.stretch = true
self:refresh()
local actor = LegendAnimation:create("CM")
self.actor = actor
self.node:addChild(actor)
actor:setPosition(ccp(240, 175))
actor:setAction("Move")
actor:setLoop(true)
function self:update(dt)
  actor:update(dt)
end

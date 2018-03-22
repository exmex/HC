local ed = ed
local class = {
	mt = {}
}
ed.Popup = class
class.mt.__index = class

local record = {}
local function PopupCreate(str, color, actor, crit, style)
	if not actor then
		return
	end
	style = style or "damage"
	local self = {
		position = nil,
		life = 0.8,
		tick = -1
	}
	setmetatable(self, class.mt)
	if style == "text" then
		self.node = ed.createSprite("UI/alpha/HVGA/battletext/battletext_" .. str .. "_" .. color .. ".png")
	else
		self.node = CCSprite:create()
		local width = ed.createNumbers(self.node, str, -2, nil, color)
		self.node:setContentSize(CCSizeMake(width, 20))
		self.node:setCascadeOpacityEnabled(true)
	end
	local action
	if style == "damage" then
		self.node:setPosition(ed.toViewPosition(actor.position, 75))
		self.node:setScale(0.5 * (crit and 1.2 or 0.75))
		local duration = self.life * 0.2
		local camp = actor.model.camp
		action = CCMoveBy:create(duration, ccp(0, crit and 70 or 45))
		action = CCEaseExponentialOut:create(action)
		action = CCSpawn:create(ccArrayMake(action, CCScaleBy:create(duration, 2)))
		local duration = self.life * 0.8
		local action2 = CCMoveBy:create(duration, ccp(0, 60))
		action2 = CCEaseIn:create(action2, 3)
		action2 = CCSpawn:create(ccArrayMake(action2, CCFadeOut:create(duration)))
		action = CCSequence:createWithTwoActions(action, action2)
	elseif style == "heal" then
		self.node:setPosition(ed.toViewPosition(actor.position, 100))
		self.node:setScale(0.75)
		local duration = self.life
		action = CCMoveBy:create(duration, ccp(0, 100))
		action = CCSpawn:createWithTwoActions(action, CCFadeOut:create(duration))
	elseif style == "gold" then
		self.node:setPosition(ed.toViewPosition(actor.position, 30))
		self.node:setOpacity(0)
		self.node:setScale(0.75)
		local duration = 0.625
		action = CCSpawn:create(ccArrayMake({
			CCMoveBy:create(duration, ccp(0, 80)),
			CCFadeTo:create(duration, 255)
		}))
		action = CCEaseOut:create(action, 4)
		action = CCSequence:create(ccArrayMake({
			CCDelayTime:create(0.3),
			action,
			CCDelayTime:create(0.15),
			CCFadeOut:create(0.1)
		}))
	elseif style == "text" then
		self.node:setPosition(ed.toViewPosition(actor.position, actor.height + 100))
		self.node:setScale(0.5)
		local duration = self.life * 0.2
		action = CCMoveBy:create(duration, ccp(0, 50))
		action = CCEaseExponentialOut:create(action)
		action = CCSpawn:createWithTwoActions(action, CCScaleBy:create(duration, 2))
		duration = self.life * 0.8
		action = CCSequence:create(ccArrayMake(action, CCDelayTime:create(duration * 0.5), CCFadeOut:create(duration * 0.5)))
	end
	action = CCSequence:create(ccArrayMake(action, CCCallFunc:create(function()
		self.node:removeFromParentAndCleanup(true)
		if record[actor] == self.tick then
			record[actor] = nil
		end
	end)))
	self.node:runAction(action)
	local tick = ed.engine.ticks
	local delay = 0
	local old = record[actor] or -1
	if tick <= old then
		delay = old + 2 - tick
		tick = tick + delay
	end
	record[actor] = tick
	self.tick = tick
	if delay == 0 then
		ed.scene.ui_layer:addChild(self.node)
	else
		self.node:retain()
		local action = CCDelayTime:create(delay * ed.engine.tick_interval)
		action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
			ed.scene.ui_layer:addChild(self.node)
			self.node:release()
		end))
		ed.scene.ui_layer:runAction(action)
	end
	return self
end
class.create = PopupCreate
ed.PopupCreate = PopupCreate

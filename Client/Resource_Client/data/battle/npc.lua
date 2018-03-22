local class = {
	mt = {}
}
ed.Npc = class
class.mt.__index = class
local base = ed.Entity
setmetatable(class, base.mt)

local function NpcCreate(info, isFlipX, owner)
	local self = base.create()
	setmetatable(self, class.mt)
	self.info = info
	self.owner = owner
	self.bornActionName = "Idle"
	self.action_name = nil
	self.action_loop = false
	self.action_duration = 0
	self.action_elapsed = 0
	if isFlipX == nil then
		isFlipX = false
	end
	self.puppet_stack = {
		self.info.Puppet
	}
	self.position = {
		info["Position X"],
		info["Position Y"]
	}
	self.birthtick = ed.engine.ticks
	self:setFlipX(isFlipX)
	self.state = ed.emUnitState_Idle
	return self
end
class.create = NpcCreate
ed.NpcCreate = NpcCreate

local setBornAction = function(self, actionName)
	self.bornActionName = actionName
end
class.setBornAction = setBornAction

local function update(self, dt)
	local dt_action = dt
	self.dt_action = dt_action
	if self.action_name and not self.action_loop then
		local elapsed = self.action_elapsed + dt_action
		local duration = self.action_duration
		if duration > 0 and elapsed > duration then
			elapsed = elapsed - duration
			self:onActionFinished()
			self.action_name = nil
		end
		self.action_elapsed = elapsed
	end
	if self.actor then
		self.actor:setFlipX(self.isFlipX)
	end
	base.update(self, dt)
end
class.update = update

local function terminate(self)
	local basefunc = base.terminate
	basefunc(self)
end
class.terminate = terminate

local onActionFinished = function(self)
end
class.onActionFinished = onActionFinished

local emUnitState_Dead = ed.emUnitState_Dead
local emUnitState_Dying = ed.emUnitState_Dying

local function isAlive(self)
	return self.state ~= emUnitState_Dead and self.state ~= emUnitState_Dying
end
class.isAlive = isAlive

local die = function(self)
	if not self:isAlive() then
		return
	end
	self:setAction("Death", false, true)
	ed.engine:onNpcDie(self)
	self.state = ed.emUnitState_Dying
	if self.actor then
		self.actor:onNpcDeath()
	end
end
class.die = die

local setAction = function(self, action_name, loop, interrupt)
	self.action_loop = loop or false
	if loop and action_name == self.action_name then
		return
	end
	self.action_name = action_name
	self.action_elapsed = interrupt and 0 or math.max(0, self.action_elapsed - self.action_duration)
	if not loop and action_name ~= nil then
		local puppetName = self.puppet_stack[#self.puppet_stack]
		puppetName = ed.lookupDataTable("Puppet", "Resource", puppetName) .. ".cha"
		self.action_duration = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name)
		if not self.action_duration then
			EDDebug()
		end
	else
		self.action_duration = 0
	end
	if self.actor then
		self.actor:onStartNewAction()
	end
end
class.setAction = setAction

local setFlipX = function(self, isFlipX)
	self.isFlipX = isFlipX
end
class.setFlipX = setFlipX

local getUnitScale = function(self)
	local ret = ed.lookupDataTable("Puppet", "Scale", self.puppet_stack[#self.puppet_stack])
	return ret
end
class.getUnitScale = getUnitScale


local class = {
	mt = {}
}
ed.NpcActor = class
class.mt.__index = class

local function NpcActorCreate(model)
	local self = {
		puppet = nil,
		node = CCNode:create(),
		model = model,
		puppetName = nil,
		tick = 0,
		position = {0, 0},
		offline = false,
		puppetInfo = nil
	}
	setmetatable(self, class.mt)
	model.actor = self
	self:usePuppet()
	return self
end
class.create = NpcActorCreate
ed.NpcActorCreate = NpcActorCreate

local setPosition = CCNode.setPosition
local setRotation = CCNode.setRotation
local setScaleY = CCNode.setScaleY
local setZOrder = CCNode.setZOrder

local function update(self, dt)
	local m = self.model
	if self.tick ~= ed.engine.ticks then
		self.tick = ed.engine.ticks
	else
	end
	local p1 = self.position
	local p2 = m.position
	p1[1] = p2[1]
	p1[2] = p2[2]
	local node = self.node
	setPosition(node, ed.toViewPosition(self.position, 0))
	setZOrder(node, -self.position[2])
	if self.puppet then
		self.puppet:update(dt, false)
	end
end
class.update = update

local onStartNewAction = function(self)
	if self.offline then
		return
	end
	local model = self.model
	local actionName = model.action_name
	self.puppet:setAction(actionName)
	self.puppet:setLoop(model.action_loop)
end
class.onStartNewAction = onStartNewAction

local usePuppet = function(self)
	local old = self.puppet
	local model = self.model
	model.actor = self
	self.puppetName = model.puppet_stack[#model.puppet_stack]
	local info = ed.lookupDataTable("Puppet", nil, self.puppetName)
	self.puppet = LegendAnimation:create(info.Resource, model:getUnitScale())
	self.puppetInfo = info
	self.node:addChild(self.puppet, 0)
	if old then
		old:removeFromParentAndCleanup(true)
	end
	local actionName = model.action_name
	self.puppet:setAction(actionName)
	self.puppet:setLoop(model.action_loop)
	self.puppet:setActionElapsed(model.action_elapsed)
end
class.usePuppet = usePuppet

local tint = function(self, r, g, b)
	if self.puppet then
		self.puppet:tint(r, g, b)
	elseif self.node then
		ed.tintSprite(self.node, r, g, b)
	end
end
class.tint = tint

local setFlipX = function(self, isFlipX)
	if isFlipX then
		self.puppet:setScaleX(-1)
	else
		self.puppet:setScaleX(1)
	end
end
class.setFlipX = setFlipX

local onNpcDeath = function(self)
	local model = self.model
	local duration = model.action_duration
	local delay = 0
	self.puppet:runAction(CCSequence:create(ccArrayMake(unpack({
		CCDelayTime:create(duration + delay),
		CCFadeOut:create(1),
		CCCallFunc:create(function()
			self.node:setVisible(false)
			model.state = ed.emUnitState_Dead
		end)
	}))))
	self.puppet:setActionSpeeder(1)
	self.puppet:setLoop(false)
end
class.onNpcDeath = onNpcDeath

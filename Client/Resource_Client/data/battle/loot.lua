local ed = ed
local class = {
	mt = {}
}
ed.Loot = class
class.mt.__index = class

local function LootCreate(icon, _type, monster, idx, id)
	local chest = "UI/alpha/HVGA/chest1.png"
	local self = {
		what = "Loot",
		id = id,
		node = CCNode:create(),
		btn = CCMenuItemImage:create(chest, chest),
		type = _type,
		icon = icon,
		position = {
			monster.position[1],
			monster.position[2]
		},
		height = 0,
		velocity = {
			100 * idx,
			-100,
			300
		},
		life = 0.6,
		terminated = false,
		bound = CCDirector:sharedDirector():getVisibleOrigin().x
	}
	setmetatable(self, class.mt)
	local btn = self.btn
	btn:setPosition(ed.ccpZero)
	btn:registerScriptTapHandler(function()
		xpcall(function()
			self:onTapped()
		end, EDDebug)
	end)
	self:update(0)
	local menu = CCMenu:createWithItem(btn)
	menu:setPosition(ed.ccpZero)
	self.node:addChild(menu, 1)
	local shine = ed.createSprite("UI/alpha/HVGA/shine.png")
	local holo = ed.createSprite("UI/alpha/HVGA/chest_holo.png")
	self.shine = shine
	self.holo = holo
	self.node:addChild(holo, -1)
	self.node:addChild(shine, -1)
	local duration = 1
	shine:setOpacity(96)
	local blink = CCSequence:createWithTwoActions(CCFadeTo:create(duration * 0.5, 255), CCFadeTo:create(duration * 0.5, 0))
	shine:setRotation(30)
	local rotate = CCRotateBy:create(duration, duration * 60)
	local action = CCSpawn:create(ccArrayMake(blink, rotate))
	shine:runAction(CCRepeatForever:create(action))
	holo:setOpacity(96)
	local blink = CCSequence:createWithTwoActions(CCFadeTo:create(duration * 0.5, 255), CCFadeTo:create(duration * 0.5, 96))
	local action = blink
	holo:runAction(CCRepeatForever:create(action))
	return self
end
ed.LootCreate = LootCreate
class.create = LootCreate

local function update(self, dt)
	if self.life <= 0 or self.terminated then
		return
	end
	self.life = self.life - dt
	if self.position[1] > 785 - self.bound and 0 < self.velocity[1] then
		self.velocity[1] = self.velocity[1] * -1.5
	end
	self.position[1] = self.position[1] + self.velocity[1] * dt
	self.position[2] = self.position[2] + self.velocity[2] * dt
	self.height = self.height + self.velocity[3] * dt
	self.velocity[3] = self.velocity[3] + -1000 * dt
	local p = ed.toViewPosition(self.position, self.height)
	self.node:setPosition(p)
end
class.update = update

local function flyToMarkerAndCleanup(sprite)
	local duration = 0.3
	local move = CCMoveTo:create(duration, ccp(157, 445))
	local fade = CCFadeOut:create(duration)
	local scale = CCScaleBy:create(duration, 0.5)
	local action = CCSpawn:create(ed.ccArrayMake(move, fade, scale))
	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
		ed.scene:addLootMarker()
		sprite:removeFromParentAndCleanup(true)
	end))
	return action
end

local function onTapped(self)
	ed.playEffect(ed.sound.battle.clickLoot)
	local chest_open = ed.createSprite("UI/alpha/HVGA/chestopen1.png")
	chest_open:setPosition(self.node:getPosition())
	ed.scene.ui_layer:addChild(chest_open)
	local action = CCFadeOut:create(0.3)
	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
		chest_open:removeFromParentAndCleanup(true)
	end))
	chest_open:runAction(action)
	local icon = ed.readequip.createIcon(self.id)
	icon:setPosition(self.node:getPosition())
	ed.scene.ui_layer:addChild(icon)
	local action = CCMoveBy:create(0.3, ccp(0, 70))
	action = CCEaseOut:create(action, 4)
	local action2 = flyToMarkerAndCleanup(icon)
	action = CCSequence:createWithTwoActions(action, action2)
	icon:runAction(action)
	self.terminated = true
	self.node:removeFromParentAndCleanup(true)
end
class.onTapped = onTapped

local function onAutoCollect(self)
	ed.playEffect(ed.sound.autoCollectLoot)
	local chest = ed.createSprite("UI/alpha/HVGA/chest1.png")
	chest:setPosition(self.node:getPosition())
	ed.scene.ui_layer:addChild(chest)
	chest:runAction(flyToMarkerAndCleanup(chest))
	self.terminated = true
	self.node:removeFromParentAndCleanup(true)
end
class.onAutoCollect = onAutoCollect

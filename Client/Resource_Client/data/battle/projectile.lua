local class = {
	mt = {}
}
ed.Projectile = class
class.mt.__index = class
local base = ed.Entity
setmetatable(class, base.mt)

local function ProjectileCreate(skill)
	local self = base.create()
	setmetatable(self, class.mt)
	local info = skill.info
	local caster = skill.caster
	self.skill = skill
	self.camp = caster.camp
	self.affect_camp = skill:affectedCamp()
	self.affect_times = {}
	self.distance = 0
	self.max_distance = info["Tile Distance"] == 0 and math.huge or info["Tile Distance"]
	self.birthtick = ed.engine.ticks
	self.track = false
	self.jumps = 0
	self.position, self.height = skill:launchPoint()
	local v = {
		info["Tile XY Speed"],
		info["Tile Z Speed"]
	}
	local d = ed.edpSub(skill.target.position, self.position)
	if info["Aim Target"] then
		if d[1] == 0 and d[2] == 0 then
			self.velocity = {
				caster.direction,
				0
			}
		else
			self.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
		end
	else
		d[2] = 0
		if d[1] == 0 and d[2] == 0 then
			self.velocity = {
				caster.direction,
				0
			}
		else
			self.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
		end
	end
	self.zSpeed = v[2]
	local caster = skill.caster
	self.previous_position = {
		self.position[1],
		self.position[2]
	}
	return self
end
class.create = ProjectileCreate
ed.ProjectileCreate = ProjectileCreate

local enableTrack = function(self, target)
	self.track = true
	self.track_target = target
	local d = ed.edpNormalize(ed.edpSub(target.position, self.position))
	self.velocity = ed.edpMult(d, self.skill.info["Tile XY Speed"])
end
class.enableTrack = enableTrack

local enableJump = function(self, times)
	self.jumps = times
	self.source = self.skill.target
end
class.enableJump = enableJump

local function update(self, dt)
	if self.birthtick == ed.engine.ticks then
		return
	end
	local target = self.track_target
	if target then
		if not target:isAlive() then
			self.track_target = nil
		end
		if target.buff_effects.untargetable then
			self.track_target = nil
		end
	end
	self.previous_position = {
		self.position[1],
		self.position[2]
	}
	base.update(self, dt)
	local info = self.skill.info
	self.height = self.height + self.zSpeed * dt
	self.zSpeed = self.zSpeed + info["Tile Gravity"] * dt
	self.distance = self.distance + info["Tile XY Speed"] * dt
	local h = self.height
	local ott = info["Tile OTT Height"]
	local aoe = self.skill.info["AOE Origin"]
	if ott == 0 or h < ott then
		local firstTime = 1
		local firstUnit
		local piercing = info["Tile Piercing"]
		for unit in ed.engine:foreachAliveUnit(self.affect_camp) do
			if piercing and self.affect_times[unit] then
			else
				local collide = self:collideCheck(unit)
				if not collide then
				elseif piercing then
					self:hit(unit)
				elseif firstTime > collide then
					firstTime = collide
					firstUnit = unit
				end
			end
		end
		if firstUnit then
			self:hit(firstUnit)
			self:terminate()
		end
	end
	if not self.terminated and h <= 0 and aoe then
		self.skill:takeEffectAt(self.position)
		self:terminate()
	end
	if not self.terminated and (self:isOutOfStage() or h < 0 or self.distance > self.max_distance) then
		self:terminate()
	end
end
class.update = update

local hit = function(self, target)
	local aoe = self.skill.info["AOE Origin"]
	if aoe then
		self.skill:takeEffectAt(target.position, self)
	else
		self.skill:takeEffectOn(target, self)
	end
	self.affect_times[target] = (self.affect_times[target] or 0) + 1
end
class.hit = hit

local collideCheck = function(self, unit)
	if self.track_target and unit ~= self.track_target then
		return false
	end
	if unit.buff_effects.untargetable then
		return false
	end
	local radius = unit.info["Collide Radius"]
	local ux = unit.position[1]
	local ux0 = unit.previous_position[1]
	local d = self.position[1] - ux
	local d0 = self.previous_position[1] - ux0
	if d > 0 and d0 > 0 then
		d = d - radius
		d0 = d0 - radius
	elseif d < 0 and d0 < 0 then
		d = d + radius
		d0 = d0 + radius
	end
	local t = -d0 / (d - d0)
	if t < 0 or t > 1 then
		return false
	end
	return t
end
class.collideCheck = collideCheck

local function terminate(self)
	local basefunc = base.terminate
	self.jumps = self.jumps - 1
	if self.jumps <= 0 or self:isOutOfStage() then
		basefunc(self)
	else
		local skill = self.skill
		local target = self:findNextTaeget()
		if target then
			local d = ed.edpSub(target.position, self.position)
			local speed = skill.info["Tile XY Speed"]
			self.velocity = ed.edpMult(ed.edpNormalize(d), speed)
			if self.track then
				self.track_target = target
			end
			self.source = target
		else
			basefunc(self)
		end
	end
end
class.terminate = terminate

class.findNextTaeget = ed.Chain.findNextTaeget


local class = {
	mt = {}
}
ed.ProjectileActor = class
class.mt.__index = class

local function ProjectileActorCreate(model)
	local self = {
		model = model,
		node = nil,
		puppet = nil,
		position = {0, 0},
		height = 0,
		velocity = {0, 0},
		zSpeed = 0,
		rotation = 0,
		tick = -1
	}
	setmetatable(self, class.mt)
	model.actor = self
	local info = model.skill.info
	local art = info["Tile Art"]
	if string.match(art, "%.png$") then
		self.node = ed.createSprite(art)
	elseif string.match(art, "%.cha$") then
		art = string.gsub(art, "%.cha$", "")
		self.puppet = LegendAminationEffect:create(art)
		self.puppet:setLoopAction("Loop")
		self.node = self.puppet
	end
	return self
end
class.create = ProjectileActorCreate
ed.ProjectileActorCreate = ProjectileActorCreate

local setPosition = CCNode.setPosition
local setRotation = CCNode.setRotation
local setScaleY = CCNode.setScaleY
local setZOrder = CCNode.setZOrder

local function update(self, dt)
	local m = self.model
	local info = m.skill.info
	if self.tick ~= ed.engine.ticks then
		self.tick = ed.engine.ticks
		self.height = m.height
		self.zSpeed = m.zSpeed
		local p1 = self.position
		local p2 = m.position
		p1[1] = p2[1]
		p1[2] = p2[2]
		local v1 = self.velocity
		local v2 = m.velocity
		v1[1] = v2[1]
		v1[2] = v2[2]
	else
		local pos = self.position
		local v = self.velocity
		pos[1] = pos[1] + v[1] * dt
		pos[2] = pos[2] + v[2] * dt
		self.height = self.height + self.zSpeed * dt
		self.zSpeed = self.zSpeed + info["Tile Gravity"] * dt
	end
	local node = self.node
	local vp = ed.toViewPosition(self.position, self.height)
	setPosition(node, vp)--set the position of projectile
	setZOrder(node, -self.position[2])
	local vz = self.zSpeed
	local v = self.velocity
	local rotation = -math.atan2(vz + v[2] * ed.deepProjectionY, v[1] + v[2] * ed.deepProjectionX) * (180 / math.pi)
	setRotation(node, rotation)
	setScaleY(node, v[1] > 0 and 1 or -1)
	if self.puppet then
		self.puppet:update(dt, false)
	end
	if not ed.engine.running then
		self.node:setVisible(false)
	end
end
class.update = update

local tint = function(self, r, g, b)
	if self.puppet then
		self.puppet:tint(r, g, b)
	elseif self.node then
		ed.tintSprite(self.node, r, g, b)
	end
end
class.tint = tint

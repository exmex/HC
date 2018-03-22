local edp = edp
local class = {
	mt = {}
}
ed.Effect = class
class.mt.__index = class
local base = ed.Puppet
setmetatable(class, base.mt)

local effect_group_cache = {}

local function EffectCreate(effect_group_name, hd)
	if string.match(effect_group_name, "%.cha$") then
		local name = string.gsub(effect_group_name, "%.cha$", "")
		local effect = LegendAminationEffect:create(name)
		return effect
	end
	local effect_group = effect_group_cache[effect_group_name]
	if not effect_group then
		local file = effect_group_name .. ".EffectGroup"
		local xfile = xml.load(file)
		effect_group = xfile[1]
		effect_group_cache[effect_group_name] = effect_group
	end
	local puppet_info = ed.PuppetInfoGet(effect_group.Filename, nil, hd)
	local self = base.create(puppet_info)
	self.name = effect_group_name
	self.zOrder = effect_group.Z or 0
	self.bone = effect_group.Bone
	self.start_anim = effect_group.start or "Play"
	self.loop_anim = effect_group.loop
	self.terminated = false
	setmetatable(self, class.mt)
	self.node:setScaleX((effect_group.Scale or 1) * (effect_group.ScaleX or 1))
	self.node:setScaleY((effect_group.Scale or 1) * (effect_group.ScaleY or 1))
	self.node:setRotation(effect_group.Rotation or 0)
	local function effect_handler(eventType)
		if eventType == "enter" then
			self:setAction(self.start_anim)
		end
	end
	self.node:registerScriptHandler(effect_handler)
	return self
end
class.create = EffectCreate
ed.EffectCreate = EffectCreate

local onAnimFinished = function(self)
	if self.loop_anim then
		self:setAnim(self.loop_anim)
	else
		self:terminate()
	end
end
class.onAnimFinished = onAnimFinished

local terminate = function(self)
	self.terminated = true
end
class.terminate = terminate

local isTerminated = function(self)
	return self.terminated
end
class.isTerminated = isTerminated

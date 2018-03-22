local ed = ed
local skins = {
	SNK = {
		puppet = "Civ/Human/Fighter/Hum-Fi",
		origin_path = "Civ/Human/Fighter",
		skin_path = "Skin/SNK"
	},
	Lion = {
		puppet = "Civ/Orcs/Witch/Orc-Witch",
		origin_path = "Civ/Orcs/Witch",
		skin_path = "Skin/Lion"
	},
	Sniper = {
		puppet = "Civ/Dwarf/Gunner/Dwf-Gunner",
		origin_path = "Civ/Dwarf/Gunner",
		skin_path = "Skin/Sniper"
	},
	OK = {
		puppet = "Civ/Dwarf/Paladin/Dwf-Paladin",
		origin_path = "Civ/Dwarf/Paladin",
		skin_path = "Skin/OK"
	}
}

local class = {
	mt = {}
}
ed.PuppetInfo = class
class.mt.__index = class

local puppetCache = {}
local puppetCache_hd = {}
local function PuppetInfoGet(resource, name, hd)
	local file = resource .. ".Puppet"
	local skin = skins[resource]
	hd = true
	local cache = hd and puppetCache_hd or puppetCache
	local self = cache[file]
	if self then
		return self
	end
	self = {
		name = name or resource,
		attachments = {},
		part_infos = {},
		anim_infos = {},
		hd = hd,
		skin = skin
	}
	cache[file] = self
	setmetatable(self, class.mt)
	local part_infos = self.part_infos
	local anim_infos = self.anim_infos
	if skin then
		file = skin.puppet .. ".Puppet"
	end
	local xfile = xml.load(file)
	local xpuppet = xfile:find("puppet")
	local n_parts = 0
	local trans_multiplier = hd and 1 or 0.5
	for i = 1, #xpuppet do
		local elem = xpuppet[i]
		if xml.tag(elem) == "Attachments" then
			local xattachments = xpuppet:find("Attachments")
			for j = 1, #xattachments do
				local xattachment = xattachments[j]
				local attachment = {
					trans = {
						xattachment.translationX * trans_multiplier,
						xattachment.translationY * trans_multiplier
					},
					rotation = tonumber(xattachment.rotation),
					texturename = xattachment.textureName,
					name = xattachment.name
				}
				if ed.run_with_scene then
					attachment.ccp_trans = ed.ccp(attachment.trans[1], attachment.trans[2])
				end
				self.attachments[attachment.name] = attachment
			end
		elseif xml.tag(elem) == "Part" then
			local part_info = elem
			part_info.order = n_parts
			part_infos[part_info.type] = part_info
			n_parts = n_parts + 1
		elseif xml.tag(elem) == "Anim" then
			local anim_info = elem
			anim_info.event_list = {}
			anim_infos[anim_info.type] = anim_info
			table.sort(anim_info, function(a, b)
				return a.Time < b.Time
			end)
			for j = 1, #anim_info do
				anim_info[j].Time = tonumber(anim_info[j].Time)
				anim_info.event_list[j] = anim_info[j]
				anim_info[j] = nil
			end
			setmetatable(anim_info, nil)
		end
	end
	return self
end
class.get = PuppetInfoGet
ed.PuppetInfoGet = PuppetInfoGet

local function getAnimWithActionName(self, action_name)
	if action_name == nil then
		return nil
	end
	local anim_info = self.anim_infos[action_name]
	local anim_file = anim_info.name .. ".PuppetAnim"
	local anim = ed.PuppetAnimGet(anim_file, nil, self.hd)
	return anim, anim_info
end
class.getAnimWithActionName = getAnimWithActionName


local class = {
	mt = {}
}
ed.PuppetAnim = PuppetAnim
class.mt.__index = class

local puppetAnimCache = {}
local function PuppetAnimGet(file, aname, hd)
	local self = puppetAnimCache[file]
	if self then
		return self
	end
	self = {
		name = aname or file,
		hd = hd,
		filename = file,
		bone_infos = {},
		duration = 0
	}
	puppetAnimCache[file] = self
	setmetatable(self, class.mt)
	local bone_infos = self.bone_infos
	local xfile = xml.load(file)
	local xanim = xfile:find("anim")
	local trans_multiplier = hd and 1 or 0.5
	for i = 1, #xanim do
		local bone_info = xanim[i]
		bone_infos[bone_info.name] = bone_info
		for j = 1, #bone_info do
			local xframe = bone_info[j]
			local frame = {
				time = tonumber(xframe.time),
				trans = {
					xframe.translationX * trans_multiplier,
					xframe.translationY * trans_multiplier
				},
				scaleX = tonumber(xframe.scaleX),
				scaleY = tonumber(xframe.scaleY),
				rotation = tonumber(xframe.rotation),
				alpha = tonumber(xframe.alpha) or 255
			}
			if ed.run_with_scene then
				frame.ccp_trans = ed.ccp(frame.trans[1], frame.trans[2])
			end
			bone_info[j] = frame
			if frame.time > self.duration then
				self.duration = frame.time
			end
		end
		table.sort(bone_info, function(a, b)
			return a.time < b.time
		end)
	end
	return self
end
class.get = PuppetAnimGet
ed.PuppetAnimGet = PuppetAnimGet

local getBonePosition = function(self, bone_name, time)
	if not bone_name then
		return {0, 0}
	end
	local bone_info = self.bone_infos[bone_name]
	if not bone_info then
		return nil
	end
	local idx = #bone_info
	for i = 2, #bone_info do
		if time < bone_info[i].time then
			idx = i - 1
			break
		end
	end
	return bone_info[idx].trans
end
class.getBonePosition = getBonePosition


local class = {
	mt = {}
}
ed.Puppet = class
class.mt.__index = class

class.onAnimFinished = nil

local function PuppetCreate(info)
	local self = {
		info = info,
		hd = info.hd,
		node = CCNode:create(),
		parts_root = CCSprite:create(),
		anim_name = "",
		anim = nil,
		anim_info = nil,
		anim_time = 0,
		loop = false,
		parts_by_type = {},
		part_list = {},
		next_event = nil,
		next_event_index = 0,
		effects = {},
		actionSpeeder = 1
	}
	setmetatable(self, class.mt)
	self.node:addChild(self.parts_root)
	self.node:setScale(0.75)
	for _, part_info in pairs(self.info.part_infos) do
		local part = ed.PuppetPartCreate(self, part_info)
		self.parts_by_type[part.type] = part
		table.insert(self.part_list, part)
		self.parts_root:addChild(part.node, part.zOrder)
	end
	return self
end
class.create = PuppetCreate
ed.PuppetCreate = PuppetCreate

local setLoop = function(self, loop)
	self.loop = loop
end
class.setLoop = setLoop

local function setAnim(self, anim_name)
	self:revertEvents()
	self.anim_name = anim_name
	local anim, anim_info = self.info:getAnimWithActionName(anim_name)
	if anim == nil then
		EDDebug()
		return
	end
	self.anim = anim
	self.anim_info = anim_info
	local list = self.part_list
	local setAnim = ed.PuppetPart.setAnim
	for i = 1, #list do
		setAnim(list[i], anim)
	end
	self.anim_time = 0
	self.next_event_index = 1
	self.next_event = anim_info.event_list[1]
end
class.setAnim = setAnim
class.setAction = setAnim

local function handleEvent(self, e)
	local type = e.Type
	if type == "Attack" then
	elseif type == "PlaySound" then
		ed.playSound(e.Filename)
	elseif type == "OverrideAttachment" then
		local part = self.parts_by_type[e.Part]
		part:attach(e.Attachment)
	elseif type == "SpawnEffectGroup" then
		self:addEffect(e.Filename)
	elseif type == "RemoveEffectGroup" then
		local effect = self.effects[e.Filename]
		if effect then
			effect:terminate()
			self.effects[effect.name] = nil
		end
	end
end
class.handleEvent = handleEvent

local function update(self, dt)
	local time = self.anim_time + dt * self.actionSpeeder
	self.anim_time = time
	if self.anim then
		local event_list = self.anim_info.event_list
		local event = self.next_event
		while event and time >= event.Time do
			handleEvent(self, event)
			local next_index = self.next_event_index + 1
			event = event_list[next_index]
			self.next_event = event
			self.next_event_index = next_index
		end
		local list = self.part_list
		local updateAnim = ed.PuppetPart.updateAnim
		local speeder = self.actionSpeeder
		for i = 1, #list do
			updateAnim(list[i])
		end
		if self.anim_time > self.anim.duration then
			self:onAnimFinished()
		end
	end
	for _, effect in pairs(self.effects) do
		effect:update(dt)
		if effect:isTerminated() then
			self.effects[effect.name] = nil
			self.node:removeChild(effect.node or effect, true)
		end
	end
end
class.update = update

local setActionSpeeder = function(self, v)
	self.actionSpeeder = v
end
class.setActionSpeeder = setActionSpeeder

local onAnimFinished = function(self)
	if self.loop then
		self:setAnim(self.anim_name)
	end
end
class.onAnimFinished = onAnimFinished

local revertEvents = function(self)
	if not self.anim then
		return
	end
	local event_list = self.anim_info.event_list
	for event_idx = 1, self.next_event_index - 1 do
		local e = event_list[event_idx]
		local type = e.Type
		if type == "OverrideAttachment" then
			local part = self.parts_by_type[e.Part]
			part:attach(part.default_attachment)
		end
	end
end
class.revertEvents = revertEvents

local function addEffect(self, name)
	if not name then
		return
	end
	self:removeEffect(name)
	local effect = ed.EffectCreate(name, self.hd)
	self.effects[name] = effect
	effect.name = name
	if effect.node then
		self.node:addChild(effect.node, effect.zOrder)
		local pos = self.anim:getBonePosition(effect.bone, self.anim_time)
		effect.node:setPosition(ccp(pos[1], pos[2]))
	else
		self.node:addChild(effect)
	end
end
class.addEffect = addEffect

local removeEffect = function(self, name)
	if not name then
		return
	end
	if self.effects[name] then
		local effect = self.effects[name]
		self.effects[name] = nil
		if effect.terminate then
			effect:terminate()
		end
		self.node:removeChild(effect.node or effect, true)
	end
end
class.removeEffect = removeEffect

local function tint(self, r, g, b)
	local list = self.part_list
	for i = 1, #list do
		ed.tintSprite(list[i].sprite, r, g, b)
	end
	for _, effect in pairs(self.effects) do
		effect:tint(r, g, b)
	end
end
class.tint = tint

local tintSprite = function(spr, r, g, b)
	local orig = spr:getColor()
	local new = ccc3(orig.r * r, orig.g * g, orig.b * b)
	spr:setColor(new)
end
ed.tintSprite = tintSprite


local class = {
	mt = {}
}
ed.PuppetPart = class
class.mt.__index = class

local setVisible = CCNode.setVisible
local setPosition = CCNode.setPosition
local setScaleX = CCNode.setScaleX
local setScaleY = CCNode.setScaleY
local setRotation = CCNode.setRotation
local setOpacity = CCSprite.setOpacity
local setDisplayFrame = CCSprite.setDisplayFrame

local function PuppetPartCreate(puppet, part_info)
	local ret = {
		puppet = puppet,
		type = part_info.type,
		bone_name = part_info.bone,
		default_attachment = part_info.defaultAttachment,
		node = CCNode:create(),
		sprite = CCSprite:create(),
		zOrder = part_info.order,
		attachment_name = "",
		frame_list = nil,
		next_frame = nil,
		next_frame_index = 0
	}
	setmetatable(ret, class.mt)
	ret.node:addChild(ret.sprite)
	ret:attach(ret.default_attachment)
	return ret
end
class.create = PuppetPartCreate
ed.PuppetPartCreate = PuppetPartCreate

local weapon_bones = {
	BoneSword = true,
	BoneMainHand = true,
	BoneOffHand = true
}
local function attach(self, attachment_name)
	if attachment_name == self.attachment_name then
		return
	end
	self.attachment_name = attachment_name
	local sprite = self.sprite
	if "" == attachment_name then
		setVisible(sprite, false)
		return
	end
	local attachment = self.puppet.info.attachments[attachment_name]
	setVisible(sprite, true)
	setPosition(sprite, attachment.ccp_trans)
	setRotation(sprite, attachment.rotation * (weapon_bones[self.bone_name] and -1 or 1))
	local file = attachment.texturename
	local skin = self.puppet.info.skin
	if skin then
		file = string.gsub(file, skin.origin_path, skin.skin_path)
	end
	local frame = ed.getSpriteFrame(file)
	if frame then
		setDisplayFrame(sprite, frame)
	end
end
class.attach = attach

local setAnim = function(self, anim)
	self.frame_list = anim.bone_infos[self.bone_name]
	self.next_frame_index = 1
	self.next_frame = self.frame_list[1]
end
class.setAnim = setAnim

local function updateAnim(self)
	local time = self.puppet.anim_time
	local frame = self.next_frame
	local frame_index = self.next_frame_index
	local list = self.frame_list
	if 0 == #list then
		return
	else
		while frame and time >= frame.time do
			local node = self.node
			setPosition(node, frame.ccp_trans)
			setScaleX(node, frame.scaleX)
			setScaleY(node, frame.scaleY)
			setRotation(node, frame.rotation)
			setOpacity(self.sprite, frame.alpha)
			frame_index = frame_index + 1
			frame = list[frame_index]
		end
	end
	self.next_frame = frame
	self.next_frame_index = frame_index
end
class.updateAnim = updateAnim

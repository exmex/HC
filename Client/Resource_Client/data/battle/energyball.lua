local epsilon = ed.epsilon
local slotCD = 0
local ballCD = 0
local skillCastCD = 0
local BallStatus = {
	Empty = 0,
	Born = 1,
	Available = 2
}

local class = {
	mt = {}
}
class.mt.__index = class

local function EnergyBallSlotCreate(i)
	local self = {
		ballType = "",
		ballStatus = BallStatus.Empty,
		ballCDTime = 0,
		cdTime = 0,
		occupied = false,
		myslotidx = i
	}
	setmetatable(self, class.mt)
	return self
end

local function slotReset(self)
	self.ballType = ""
	self.ballStatus = BallStatus.Empty
	self.ballCDTime = 0
	self.occupied = false
end
class.slotReset = slotReset


local class = {
	mt = {}
}
class.mt.__index = class

local function EnergyBallManagerCreate(unit_)
	local self = {
		slots = {},
		unit = unit_,
		skillCastCDTime = 0,
		skillCastStatus = 0
	}
	setmetatable(self, class.mt)
	for i = 1, 3 do
		self.slots[i] = EnergyBallSlotCreate(i)
	end
	return self
end
class.EnergyBallManagerCreate = EnergyBallManagerCreate
ed.EnergyBallManagerCreate = EnergyBallManagerCreate

local function getEmptySlot(self, chechOccupied)
	for i, slot in ipairs(self.slots) do
		if chechOccupied then
			if slot.ballType == "" and slot.cdTime <= epsilon and self.skillCastCDTime <= epsilon and chechOccupied and not slot.occupied then
				return slot, i
			end
		elseif slot.ballType == "" and slot.cdTime <= epsilon and self.skillCastCDTime <= epsilon then
			return slot, i
		end
	end
	return nil, 0
end
class.getEmptySlot = getEmptySlot

local isSlotsFull = function(self)
	for i, slot in ipairs(self.slots) do
		if slot.ballType == "" then
			return false
		end
	end
	return true
end
class.isSlotsFull = isSlotsFull

local function isSlotsAvailable(self)
	for i, slot in ipairs(self.slots) do
		if slot.ballType == "" or slot.ballStatus ~= BallStatus.Available then
			return false
		end
	end
	return true
end
class.isSlotsAvailable = isSlotsAvailable

local ballKeywords = {
	"ice",
	"fire",
	"lightning"
}

local function addEnergyBall(self, balltype, myslotidx)
	if not self.unit:isAlive() or self.skillCastCDTime > epsilon then
		return
	end
	local slot
	if not myslotidx then
		slot = getEmptySlot(self, false)
	else
		slot = self.slots[myslotidx]
	end
	if not slot then
		print("no available")
		return
	end
	slot.ballType = balltype
	slot.ballStatus = BallStatus.Born
	slot.ballCDTime = ballCD
	slot.cdTime = slotCD
	if ed.run_with_scene and self.unit.ballBar then
		self.unit.ballBar:addBall(balltype, myslotidx)
	end
end
class.addEnergyBall = addEnergyBall

local function consumeEnergyBall(self)
	if not self.unit:isAlive() then
		return
	end
	if not isSlotsAvailable(self) then
		return
	end
	for i, slot in ipairs(self.slots) do
		slot:slotReset()
	end
	self.skillCastCDTime = skillCastCD
	self.skillCastStatus = 1
	if ed.run_with_scene and self.unit.ballBar then
		self.unit.ballBar:playCompose()
	end
end
class.consumeEnergyBall = consumeEnergyBall

local function update(self, dt)
	for i = 1, 3 do
		local slot = self.slots[i]
		if slot.cdTime >= epsilon then
			slot.cdTime = slot.cdTime - dt
		end
		if slot.ballStatus == BallStatus.Born then
			slot.ballCDTime = slot.ballCDTime - dt
			if slot.ballCDTime <= epsilon then
				slot.ballStatus = BallStatus.Available
			end
		end
	end
	if self.skillCastCDTime > epsilon then
		self.skillCastCDTime = self.skillCastCDTime - dt
		if self.skillCastCDTime <= epsilon then
			self.skillCastStatus = 2
		end
	end
end
class.update = update

local function getAvailableBalls(self)
	local t = {}
	for i, slot in ipairs(self.slots) do
		if slot.ballType ~= "" or slot.ballStatus == BallStatus.Available then
			t[slot.ballType] = (t[slot.ballType] or 0) + 1
		end
	end
	return ed.makebits(2, t.ice or 0, 2, t.fire or 0, 2, t.lightning or 0)
end
class.getAvailableBalls = getAvailableBalls

local function canCastSkill(self, skill)
	local cond = self.unit.skillConditon[skill.info["Skill Group ID"]]
	if not cond then
		return true
	end
	local m = ed.makebits(2, cond[1], 2, cond[2], 2, cond[3])
	local t = getAvailableBalls(self)
	if isSlotsAvailable(self) and m == t then
		return true
	else
	end
	return false
end
class.canCastSkill = canCastSkill

local clear = function(self)
	for i = 1, 3 do
		self.slots[i]:slotReset()
	end
end
class.clear = clear

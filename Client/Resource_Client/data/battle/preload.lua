local ed = ed
local class = ed.Unit

local function preloadCha(name)
	if not name then
		return
	end
	if string.match(name, "%.cha$") then
		name = string.gsub(name, "%.cha$", "")
		ed.createFcaNode(name)
	end
end

local preloadAction = function(self, action_name)
end
class.preloadAction = preloadAction

local function preloadSkill(skill)
	local info = skill.info
	preloadCha(info["Launch Effect"])
	preloadCha(info["Point Effect"])
	preloadCha(info["Impact Effect"])
	preloadCha(info["Chain Effect"])
	local art = info["Tile Art"]
	if art and string.match(art, "%.png$") then
		ed.getSpriteFrame(art)
	elseif art then
		preloadCha(art)
	end
end

local function preload(self)
	if not ed.run_with_scene then
		return
	end
	local cha = self.info.Puppet
	cha = ed.lookupDataTable("Puppet", "Resource", cha) .. ".cha"
	local actions = ed.getDataTable("AnimDuration")[cha]
	for action_name, _ in pairs(actions) do
		self:preloadAction(action_name)
	end
	for _, skill in ipairs(self.skill_list) do
		preloadSkill(skill)
	end
end
class.preload = preload

local function PreloadPuppetRcs(puppetRcsName)
	if ed.run_with_scene then
		local puppet = LegendAnimation:create(puppetRcsName, 1)
		if puppet then
			puppet:removeFromParentAndCleanup(true)
		end
	end
end
ed.PreloadPuppetRcs = PreloadPuppetRcs

local function PreloadPuppetRcsByUnitId(id)
	if ed.run_with_scene then
		local puppetRcsName = ed.lookupDataTable("Unit", "Puppet", id)
		if puppetRcsName then
			puppetRcsName = ed.lookupDataTable("Puppet", "Resource", puppetRcsName)
			local puppet = LegendAnimation:create(puppetRcsName, 1)
			if puppet then
				puppet:removeFromParentAndCleanup(true)
			end
		end
	end
end
ed.PreloadPuppetRcsByUnitId = PreloadPuppetRcsByUnitId

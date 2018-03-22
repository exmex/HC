local class = newclass()
ed.ui.readconfig = class

local set = function(key, value)
	if type(value) ~= "string" then
		print("wrong type of value!")
		return
	end
	local uid = ed.getDeviceId()
	local ip = game_server_id
	CCUserDefault:sharedUserDefault():setStringForKey(string.format("%s-%s-%s", ip, uid, key), value)
end
class.set = set

local get = function(key)
	local uid = ed.getDeviceId()
	local ip = game_server_id
	return CCUserDefault:sharedUserDefault():getStringForKey(string.format("%s-%s-%s", ip, uid, key))
end
class.get = get

local function getTeamData(key)
	local str = get(key)
	local team = {}
	for s in string.gfind(str, "%d+,") do
		local id = string.gsub(s, ",", "")
		table.insert(team, tonumber(id))
	end
	return team
end
class.getTeamData = getTeamData

local function setTeamData(key, data)
	local str = ""
	for i = 1, #(data or {}) do
		str = str .. data[i] .. ","
	end
	set(key, str)
end
class.setTeamData = setTeamData

local visit_team_handler = {
common = "td_cm",
pvp = "td_pp",
nophysical = "td_np",
nomagical = "td_nm",
female = "td_fm"
}

function ed.setTeamData(type, data)
	setTeamData(visit_team_handler[type], data)
end

function ed.getTeamData(type)
	return getTeamData(visit_team_handler[type])
end

function ed.resetNotificationData()
	local key = "nt_nt"
	set(key, "")
end

function ed.saveNotificationData(data)
	local tKey = "nt_fn"
	local key = "nt_nt"
	local str = ""
	for k, v in pairs(data) do
		if v then
			str = str .. v .. ","
		end
	end
	set(tKey, "fls")
	set(key, str)
end

function ed.loadNotificationData()
	local tKey = "nt_fn"
	local key = "nt_nt"
	local tag = get(tKey)
	local str = get(key)
	local data = {}
	for s in string.gfind(str, "%d,") do
		local id = string.gsub(s, ",", "")
		id = tonumber(id)
		table.insert(data, id)
	end
	return data, tag
end

function ed.saveSoundSwitch()
	local v = ed.soundSwitch and "y" or "n"
	CCUserDefault:sharedUserDefault():setStringForKey("swq_s", v)
end

function ed.loadSoundSwitch()
	ed.soundSwitch = CCUserDefault:sharedUserDefault():getStringForKey("swq_s") ~= "n"
	LegendSetSoundSwitch(ed.soundSwitch and 0 or 1)
end

local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.playerlimit = class
class.module_switch = {}
local function closeModule(key)
  class.module_switch[key] = "close"
end
class.closeModule = closeModule
local getTable = function()
  return ed.getDataTable("PlayerLevel")
end
class.getTable = getTable
local function row(level)
  local plt = getTable()
  level = level or ed.player:getLevel()
  return plt[level]
end
class.row = row
local function heroLevelLimit()
  return row()["Max Hero Level"]
end
class.heroLevelLimit = heroLevelLimit
local function maxVitality()
	local original= row()["Max Vitality"]
	local viplevel=ed.player:getvip()
	local vipTable=ed.getDataTable("VIP")
	return original+(vipTable[viplevel])["User Vitality Max"]
end
class.maxVitality = maxVitality
local function maxChapter()
  local c = row().Chapter
  local level = ed.player:getLevel()
  while (c or 0) < 1 do
    level = level - 1
    c = row(level).Chapter
  end
  return c
end
class.maxChapter = maxChapter
local maxVipLevel = function()
  local vt = ed.getDataTable("VIP")
  local index = 0
  while vt[index] do
    index = index + 1
  end
  return index - 1
end
class.maxVipLevel = maxVipLevel
local function chapterUnlockLevel(c)
  local i = 1
  local plt = getTable()
  while plt[i] and c > plt[i].Chapter do
    i = i + 1
  end
  return i
end
class.chapterUnlockLevel = chapterUnlockLevel
local function getAreaUnlockLevel(key)
  local plt = getTable()
  local index = 1
  while plt[index] do
    local row = plt[index]
    local unlock = row.Unlock
    for k, v in pairs(unlock) do
      if v == key then
        return index
      end
    end
    index = index + 1
  end
  print("Are you sure the " .. key .. " is limited by the player level?")
  return 0
end
class.getAreaUnlockLevel = getAreaUnlockLevel
local getAreaUnlockStage = function(key)
  local us = {shop = 39}
  local s = us[key]
  if not s then
    print("Are you sure the " .. key .. " is limited by the stage?")
    s = 0
  end
  return s
end
class.getAreaUnlockStage = getAreaUnlockStage
local getAreaUnlockvip = function(key)
  local vt = ed.getDataTable("VIP")
  local index = 0
  while vt[index] do
    if vt[index][key] then
      return index
    end
    index = index + 1
  end
  return index
end
class.getAreaUnlockvip = getAreaUnlockvip
local function getAreaShowvip(key)
  local vip = getAreaUnlockvip(key)
  vip = math.max(vip - 2, 0)
  return vip
end
class.getAreaShowvip = getAreaShowvip
local function unlockRequire(key)
  local ur = {
    ["SkillUpgrade"] = "playerlevel",
    ["Elite"] = "playerlevel",
    ["PVP"] = "playerlevel",
    ["Midas"] = "playerlevel",
    ["COT"] = "playerlevel",
    ["Enhance"] = "playerlevel",
    ["Exercise"] = "playerlevel",
    ["shop"] = "stage",
    ["sshop"] = "playerlevel",
    ["ssshop"] = "playerlevel",
    ["Crusade"] = "playerlevel",
    ["Guild"] = "playerlevel",
    --["Excavate"] = "playerlevel",
    ["Awake"] = "playerlevel",
    ["Skill Upgrade CD Reset"] = "vip",
    ["Item One-Click-Upgrade"] = "vip",
    ["Raid One Function"] = "vip",
    ["Raid Ten Function"] = "vip",
    ["Magic Soul Box"] = "vip",
    ["Multiple Midas"] = "vip"
  }
  if class.module_switch[key] == "close" then
    return 0, {type = "notopen"}
  end
  local state = ur[key] or "playerlevel"
  if state == "playerlevel" then
    return getAreaUnlockLevel(key), {
      type = "playerlevel",
      current = ed.player:getLevel() or 0
    }
  elseif state == "stage" then
    return getAreaUnlockStage(key), {
      type = "stage",
      current = ed.player:getStageProgress() - 1
    }
  elseif state == "vip" then
    return getAreaUnlockvip(key), {
      type = "vip",
      current = ed.player:getvip()
    }
  else
    if state == "unlockhero" then
      local heroid = ed.getAwakeHero()
      if heroid == nil then
        return 1, {type = "awake", current = 0}
      else
        return 0, {type = "awake", current = 1}
      end
    else
    end
  end
  return nil
end
class.unlockRequire = unlockRequire
local function checkAreaUnlock(key)
  local limit, addition = unlockRequire(key)
  addition = addition or {}
  local current = addition.current
  local state = addition.type
  if state == "notopen" then
    return false
  elseif limit > current then
    return false
  else
    return true
  end
end
class.checkAreaUnlock = checkAreaUnlock
local function getAreaUnlockPrompt(key)
  local limit, addition = unlockRequire(key)
  local state = addition.type
  if checkAreaUnlock(key) then
    return nil
  end
  if state == "notopen" then
    return T(LSTR("playerlimit.2.0.1.001"))
  elseif state == "playerlevel" then
    return T(LSTR("PLAYERLIMIT.OPEN_AT__D_TEAM_LEVEL"), limit)
  elseif state == "stage" then
    if key == "shop" then
      return T(LSTR("PLAYERLIMIT.OPEN_BY_FINISHING_CHAPTER_TWO"))
    end
    return T(LSTR("PLAYERLIMIT.OPEN_BY_FINISHING__D_STAGES"), limit)
  elseif state == "vip" then
    return T(LSTR("PLAYERLIMIT.OPEN_BY_UPGRADING_VIP_LEVEL_TO__D"), limit), {type = "vip", limit = limit}
  end
end
class.getAreaUnlockPrompt = getAreaUnlockPrompt

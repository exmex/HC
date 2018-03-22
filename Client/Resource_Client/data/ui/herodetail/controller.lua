ed.ui.herodetail = ed.ui.herodetail or {}
local herodetail = ed.ui.herodetail
function herodetail.initWindow(hero, otherPlayerInfo, addition)
  ed.ui.herodetail.setHero(hero)
  return herodetail.window.create(hero, otherPlayerInfo, addition)
end
local herodetail = ed.ui.herodetail
local res = herodetail.res
local class = newclass("g")
herodetail.controller = class
setmetatable(ed.ui.herodetail, {__index = class})
setfenv(1, class)
skillLvupHero = nil
skillLvupOrder = {}
skillLvupPoint = 0
skillLvupPointCache = 0
hero = nil
function packSkillOrder(slot, amount)
  return ed.makebits(11, amount, 4, slot)
end
function setHero(hero_)
  hero = hero_
end
function init()
  initSkilllvupData()
  resetSkilllvupCache()
end
function initSkilllvupData()
  skillLvupHero = nil
  skillLvupOrder = {}
  skillLvupPoint = 0
end
function resetSkilllvupCache()
  skillLvupPointCache = 0
end
function doSkillLvup(hid, slot)
  if skillLvupHero ~= nil and skillLvupHero ~= hid then
    print("!-- Skill Lv UP : change hero but not init the order .")
    initSkilllvupData()
    return false
  end
  skillLvupHero = hid
  skillLvupOrder[slot] = (skillLvupOrder[slot] or 0) + 1
  skillLvupPoint = skillLvupPoint + 1
  skillLvupPointCache = skillLvupPoint
  return true
end
function sendSkillLvup(callback)
  if skillLvupPoint <= 0 then
    return false
  end
  ed.registerNetReply("skill_level_up", callback, {
    hid = skillLvupHero,
    order = ed.copyTable(skillLvupOrder),
    point = skillLvupPoint
  })
  local order = {}
  for k, v in pairs(skillLvupOrder) do
    table.insert(order, packSkillOrder(k, v))
  end
  local msg = ed.upmsg.skill_levelup()
  msg._heroid = skillLvupHero
  msg._order = order
  ed.send(msg, "skill_levelup")
  initSkilllvupData()
  return true
end
function getSkillDesc(hero, slot, skillAdd)
  skillAdd = skillAdd or 0
  local text = ""
  local skillgroup = ed.getDataTable("SkillGroup")[hero._tid][slot]
  local gid = skillgroup["Skill Group ID"]
  local skill = ed.getDataTable("Skill")[gid][0]
  local bid = skill["Buff ID"]
  local buff = ed.getDataTable("Buff")[bid]
  local index = 1
  while true do
    local field = skillgroup["Growth " .. index .. " Field"]
    if field then
      local growth = skillgroup["Growth " .. index .. " Value"]
      local multiplier = skillgroup["Growth " .. index .. " Multiplier"]
      local summary = skillgroup["Growth " .. index .. " Summary"]
      if not field or not summary or growth == 0 or multiplier == 0 then
        break
      end
      local value = skill[field] or buff[field]
      local level = getCacheSkillLevel(slot, hero._tid) + skillAdd
      growth = growth * multiplier
      value = value * multiplier
      local append = string.gsub(summary, "##", value + growth * (level - 1))
      append = string.gsub(append, "#", growth * level)
      text = text .. append .. "\n"
      index = index + 1
    else
      break
    end
  end
  return text
end
function getSkillLvupAtt(hid, id)
  local att = {}
  local row = ed.getDataTable("SkillGroup")[hid][id]
  local index = 1
  while true do
      local field = row["Growth " .. index .. " Field"]
      if field then
        local popupstr = row["Growth " .. index .. " Popup"]
        local value = row["Growth " .. index .. " Value"]
        local multicof = row["Growth " .. index .. " Multiplier"]
        if popupstr then
          local add = value * multicof
          if add < 2 then
            add = string.format("%.1f", add)
          else
            add = math.floor(add)
          end
          local element = string.gsub(popupstr, "#", add)
          table.insert(att, element)
          index = index + 1
          break
        end
      else
        break
      end
  end
  return att
end
function getCacheSkillPoint()
  return ed.player:getSkillLvupChance() - skillLvupPointCache
end
function getSkillLevel(hid, slot)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 1
  end
  local sgTable = ed.getDataTable("SkillGroup")
  local skillLevel = heroInfo._skill_levels[slot]
  local initLevel = sgTable[hid][slot]["Init Level"]
  return skillLevel - initLevel + 1
end
function getCacheSkillLevel(slot, hid)
  local heroInfo = getHero(hid or skillLvupHero)
  if heroInfo == nil then
    return 0
  end
  return heroInfo._skill_levels[slot] + (skillLvupOrder[slot] or 0)
end
function getCacheSkillLevelDisplay(slot, hid)
  local sgTable = ed.getDataTable("SkillGroup")
  local initLevel = sgTable[hid or skillLvupHero][slot]["Init Level"]
  return getCacheSkillLevel(slot, hid) - initLevel + 1
end
function getHero(hid)
  if hero then
    return hero
  end
  return ed.player.heroes[hid]
end
function getHeroMaxExp(hid)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 0
  end
  local level = heroInfo._level
  return ed.lookupDataTable("Levels", "Exp", level)
end
function getHeroExp(hid)
  local maxExp = getHeroMaxExp(hid)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 0
  end
  return math.min(heroInfo._exp, maxExp)
end
function getUnitRow(hid)
  local unit = ed.getDataTable("Unit")
  return unit[hid]
end
function getHeroTypeRes(hid)
  local mainAtt = getUnitRow(hid)["Main Attrib"]
  return res.type_icon[mainAtt]
end
function getHeroEquipid(hid, slot)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 0
  end
  return heroInfo:getEquipid(slot) or 0
end
function getHerocsvEquipid(hid, slot, rank)
  local heroInfo = getHero(hid)
  local heroRank = 1
  if heroInfo ~= nil then
    heroRank = heroInfo._rank
  end
  heroRank = rank or heroRank
  local heroEquips = ed.getDataTable("hero_equip")[hid]
  if heroEquips == nil then
    return 0
  end
  local heroEquipRank = heroEquips[heroRank]
  if heroEquipRank == nil then
    return 0
  end
  return heroEquipRank[string.format("Equip%d ID", slot)] or 0
end
function getHeroEquipState(hid, slot)
  local eid = getHerocsvEquipid(hid, slot)
  local ceid = getHeroEquipid(hid, slot)
  local ea = ed.player.equip_qunty[eid] or 0
  if eid == 0 then
    return "ignore"
  end
  if ceid == 0 then
    if ea == 0 then
      if ed.isEquipCraftable(eid) then
        if ed.canWearEquip(hid, eid) then
          return "canCraft", "wear"
        else
          return "canCraft", "cannotwear"
        end
      else
        return "notHave"
      end
    elseif not ed.canWearEquip(hid, eid) then
      return "cannotwear", "cannotwear"
    else
      return "canWear", "wear"
    end
  else
    return "isEquiped"
  end
end
function getHeroEvolveStoneNeed(hid)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 999
  end
  local stars = heroInfo._stars + 1
  local row = ed.getDataTable("HeroStars")[stars] or {}
  return row["Upgrade Fragments"] or 999
end
function getHeroEvolveCost(hid)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return 0
  end
  local stars = heroInfo._stars + 1
  local row = ed.getDataTable("HeroStars")[stars] or {}
  return row["Upgrade Price"] or 0
end
function checkHeroMaxStar(hid)
  local heroInfo = getHero(hid)
  if heroInfo == nil then
    return true
  end
  local stars = heroInfo._stars + 1
  if not ed.getDataTable("HeroStars")[stars] then
    return true
  else
    return false
  end
end

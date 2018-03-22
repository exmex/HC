local mercenary = {}
mercenary.__index = mercenary
ed.mercenary = mercenary
local mercenaryHeros = {}
local crusadeMercenary, excavateMercenary
local MecrenaryType = {
  cHired = "cHired",
  bHired = "bHired",
  bLevel = "bLevel"
}
local generateMercenaryInfo = function(uid, name, cost, sort)
  local mercenaryInfo = {}
  mercenaryInfo._uid = uid
  mercenaryInfo._name = name
  mercenaryInfo._cost = cost
  mercenaryInfo._sort = sort
  return mercenaryInfo
end
local function getAllMercenary()
  return mercenaryHeros
end
function mercenary.getMercenaryHero(uid, tid)
  if uid == nil or tid == nil then
    return nil
  end
  for k, v in ipairs(mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == uid and v._tid == tid then
      return v
    end
  end
  return nil
end
function mercenary.getCrusadeMercenary()
  return crusadeMercenary
end
function mercenary.getExcavateMercenary()
  return excavateMercenary
end
function mercenary.setCrusadeMercenary(data)
  local hero = mercenary.setMercenary(data, "crusade")
  crusadeMercenary = hero
end
function mercenary.setExcavateMercenary(data)
  local hero = mercenary.setMercenary(data, "excavate")
  excavateMercenary = hero
end
function mercenary.clearExcavateMercenary()
  excavateMercenary = nil
end
function mercenary.setMercenary(data, mode)
  local hero
  if nil == data then
    hero = nil
    return
  end
  if hero == nil then
    hero = ed.HeroCreate()
  end
  local heroInfo = data._hero
  hero:setup(heroInfo._base)
  local mercenaryInfo = generateMercenaryInfo(data._uid, data._name, 0)
  hero:setMercenaryData(mercenaryInfo)
  if mode == "crusade" then
    hero:setCrusade(heroInfo._dyna)
  elseif mode == "excavate" then
    hero:setExcavate(heroInfo._dyna)
  end
  local bFound = false
  for k, v in ipairs(mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == data._uid and v._tid == heroInfo._base._tid then
      mercenaryHeros[k] = hero
      bFound = true
      break
    end
  end
  if bFound == false then
    table.insert(mercenaryHeros, hero)
  end
  return hero
end
local generateDynaData = function()
  local data = {}
  data._hp_perc = 10000
  data._mp_perc = 0
  return data
end
local function setupHeroData(data)
  if nil == data then
    return
  end
  if data._result ~= "success" then
    if data._result == "stage_invalid" then
      ed.showToast(T(LSTR("mercenary.1.10.1.001")))
    else
      ed.showToast(T(LSTR("MERCENARY.RECRUITING_HERO_FAILED")))
    end
    return
  end
  if nil == mercenaryHeros then
    return
  end
  for k, v in ipairs(mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == data._uid and v._tid == data._hero._tid then
      v:setup(data._hero)
      FireEvent("HireMercenarySuccess")
      ed.player:addMoney(-mercenaryInfo._cost)
      if data._from == "tbc" then
        local crusadeData = generateDynaData()
        v:setCrusade(crusadeData)
        mercenaryInfo._cost = 0
        crusadeMercenary = v
      elseif data._from == "excav" then
        local excavateData = generateDynaData()
        v:setExcavate(excavateData)
        mercenaryInfo._cost = 0
        excavateMercenary = v
      end
      return
    end
  end
end
local checkAllowHired = function()
end
local function onGetSummaryInfo(data)
  mercenaryHeros = {}
  if data._users == nil then
    return
  end
  for k, v in ipairs(data._users) do
    if v and v._heroes then
      local bHired = false
      local bSort = MecrenaryType.cHired
      if data._hire_uids and ed.isElementInTable(v._uid, data._hire_uids) then
        bSort = MecrenaryType.bHired
      end
      if v._uid == ed.getUserid() then
        bHired = true
      end
      if bHired == false and v._heroes then
        for i, heroInfo in ipairs(v._heroes) do
          local type = bSort
          if heroInfo._hero._level > ed.player:getLevel() then
            bSort = MecrenaryType.bLevel
          end
            local hero = ed.HeroCreate()
            hero:setup(heroInfo._hero)
          local mercenaryInfo = generateMercenaryInfo(v._uid, v._name, heroInfo._cost, bSort)
            hero:setMercenaryData(mercenaryInfo)
            if data._from == "tbc" then
              local crusadeData = generateDynaData()
              hero:setCrusade(crusadeData)
            elseif data._from == "excav" then
              local excavateData = generateDynaData()
              hero:setExcavate(excavateData)
            end
            table.insert(mercenaryHeros, hero)
          bSort = type
        end
      end
    end
  end
  FireEvent("MercenaryAlready", mercenaryHeros)
end
local function OnGetMercenary(data)
  if nil == data then
    return
  end
  if data._query_hires then
    onGetSummaryInfo(data._query_hires)
  elseif data._hire_hero then
    setupHeroData(data._hire_hero)
  end
end
ListenEvent("GuildRsp", OnGetMercenary)

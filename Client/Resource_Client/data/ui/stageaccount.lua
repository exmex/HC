local class = newclass({__index = _G})
ed.ui.stageaccount = class
setfenv(1, class)
function initialize(param)
  local param = param
  local battleParam = ed.battleDataCache or {}
  ed.battleDataCache = nil
  param.gwMode = battleParam.gwMode
  param.actType = battleParam.actType
  param.heroLimit = battleParam.heroLimit
  param.bestRankReward = param.bestRankReward or {}
  param.isPveMode = param.isPveMode or false
  if param.victory then
    dealVictoryParam(param)
    ed.replaceScene(ed.ui.stagedone.create(param))
  else
    dealLoseParam(param)
    ed.replaceScene(ed.ui.stagefailed.create(param))
  end
end
function dealLoseParam(param)
  if param.excavate_mode then
    local sid = param.stage_id
    local st = ed.getDataTable("Stage")
    local row = st[sid]
    param.exp = row["Exp Reward"]
    local info = {
      exp = ed.player:getExp(),
      addExp = param.exp,
      maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
      level = ed.player:getLevel()
    }
    param.playerInfo = getPlayerInfo(info)
  end
end
function dealVictoryParam(param)
  local sid = param.stage_id
  local st = ed.getDataTable("Stage")
  local row = st[sid]
  param.isKeyStage = row["Key Stage"]
  param.chapter = row["Chapter ID"]
  param.exp = row["Exp Reward"]
  param.gold = param.guildInstanceData and param.guildInstanceData.gold or row["Money Reward"]
  local loots = {}
  for i, v in ipairs(param.loots) do
    if loots[v.id] then
      loots[v.id].amount = loots[v.id].amount + 1
    else
      loots[v.id] = {
        amount = 1,
        type = v.type
      }
    end
  end
  param.lootList = loots
  local totalExp
  if sid == -1 then
    totalExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()]["Arena Hero Exp"]
  else
    totalExp = row["Heroexp Reward"]
  end
  local heroExp = math.floor(totalExp / #param.heroes)
  param.totalExp = totalExp
  param.heroExp = heroExp
  local heroes = {}
  for i, v in ipairs(param.heroes) do
    local isMercenary
    if param.mercenaryInfo and param.mercenaryInfo.index == i then
      isMercenary = true
    end
    heroes[i] = getHeroInfo(param, v, heroExp, isMercenary)
  end
  param.heroes = heroes
  local info = {
    exp = ed.player:getExp(),
    addExp = param.exp,
    maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
    level = ed.player:getLevel()
  }
  param.playerInfo = getPlayerInfo(info)
end
function getHeroInfo(param, id, heroExp, isMercenary)
  local unitLevel = ed.getDataTable("Levels")
  local hero
  if isMercenary then
    hero = ed.mercenary.getMercenaryHero(param.mercenaryInfo.data._uid, id)
  else
    hero = ed.player.heroes[id]
  end
  local id = hero._tid
  local hc = (ed.player.heroCache or {})[id] or {}
  local exp = hero._exp
  local level = hero._level
  local maxExp = unitLevel[level].Exp
  local rank = hero._rank
  local preExp = isMercenary == true and exp or hc.preExp or 0
  local preLevel = isMercenary == true and level or hc.preLevel or 0
  local addExp = isMercenary == true and 0 or hc.expIncrement or 0
  local preMaxExp
  if preLevel and unitLevel[preLevel] then
    preMaxExp = unitLevel[preLevel].Exp
  else
    preMaxExp = unitLevel[level].Exp
  end
  local isMaxLevel = false
  if level >= ed.playerlimit.heroLevelLimit() and exp >= maxExp then
    isMaxLevel = true
  end
  return {
    id = id,
    rank = rank,
    level = preLevel,
    exp = preExp,
    maxExp = preMaxExp,
    tLevel = level,
    tExp = exp,
    tMaxExp = maxExp,
    isMaxLevel = isMaxLevel,
    hp = hero:hp_perc(),
    mp = hero:mp_perc(),
    addExp = addExp,
    addHeroExp = isMercenary == true and 0 or heroExp or 0,
    bMercenary = isMercenary
  }
end
function getPlayerInfo(info)
  local pt = ed.getDataTable("PlayerLevel")
  if ed.player.teamAlreadyMaxLevel then
    info.addExp = 0
  end
  local exp = info.exp
  local addExp = info.addExp
  local level = info.level
  local maxExp = info.maxExp
  local cExp = exp
  local cLevel = level
  local cAddExp = addExp
  local animList = {}
  while cExp < cAddExp do
    table.insert(animList, 1, {
      be = 0,
      ee = cExp,
      len = pt[cLevel].Exp,
      lv = cLevel
    })
    cAddExp = cAddExp - cExp
    if pt[cLevel - 1] == nil then
      break
    end
    cLevel = cLevel - 1
    cExp = pt[cLevel].Exp
  end
  table.insert(animList, 1, {
    be = cExp - cAddExp,
    ee = cExp,
    len = pt[cLevel].Exp,
    lv = cLevel
  })
  cExp = cExp - cAddExp
  return {
    oriExp = cExp,
    oriLevel = cLevel,
    oriMaxExp = pt[cLevel].Exp,
    exp = exp,
    level = level,
    addExp = addExp,
    maxExp = maxExp,
    animList = animList
  }
end
function getBattleBgRes(stage)
  local level = ed.getDataTable("Battle")[stage]
  local waves = ed.getDataTable("Stage")[stage].Waves
  local res = level[waves]["Background Pic"]
  return "UI/alpha/HVGA/" .. res
end
function getStageVitalityCost(stage)
  local row = ed.getDataTable("Stage")[stage]
  if row then
    return row["Vitality Cost"]
  end
  return 0
end
function getLoseTitleRes(loseType)
  if loseType == "timeout" then
    return "UI/alpha/HVGA/overtime_title.png"
  elseif loseType == "fail" then
    return "UI/alpha/HVGA/failed_title.png"
  end
end

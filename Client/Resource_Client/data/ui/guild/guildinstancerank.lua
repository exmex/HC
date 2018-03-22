local rankPanel
local rankLogic = {}
local showHeroNum = 3
function rankLogic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and rankPanel then
    currentScene:removeChild(rankPanel:getRootLayer(), true)
    rankPanel = nil
  end
end
local function addHint(content)
  rankPanel.rankList:changeItemConfig(6)
  rankPanel.rankList:addItem({content})
end
local getRankNode = function(num)
  local rankRecource = {
    "UI/alpha/HVGA/pvp/pvp_rank_1st.png",
    "UI/alpha/HVGA/pvp/pvp_rank_2nd.png",
    "UI/alpha/HVGA/pvp/pvp_rank_3rd.png"
  }
  local node
  local spriteName = rankRecource[num]
  if spriteName then
    node = ed.createSprite(spriteName)
  else
    node = ed.getNumberNode({
      text = num,
      folder = "big_pvp",
      padding = -1
    }).node
  end
  return node
end
local getStageInfo = function(stageId)
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[stageId]
  local stageName = row["Stage Name"]
  local chapter = row["Chapter ID"]
  local chapterTable = ed.getDataTable("Chapter")
  local chapterName = chapterTable[chapter]["Chapter Name"]
  return stageName, chapterName
end
local getHerosNode = function(data)
  if not data then
    return
  end
  local node = CCNode:create()
  for i, v in ipairs(data) do
    local heroIcon = ed.readhero.createIcon({
      id = v._tid,
      rank = v._rank,
      level = v._level,
      stars = v._stars,
      awake = ed.protoAwake(v)
    })
    heroIcon.icon:setScale(0.4)
    heroIcon.icon:setPosition(ccp(i * 40, 0))
    node:addChild(heroIcon.icon)
  end
  return node
end
local function initPanel(data)
  if nil == data then
    return
  end
  local stageName, chapterName = getStageInfo(data._stage_id)
  local fastData = data._fast_pass
  if fastData then
    rankPanel.rankList:addItem({
      T(LSTR("guildinstancerank.1.10.001"), chapterName)
    })
    rankPanel.rankList:changeItemConfig(2)
    rankPanel.rankList:addItem({
      T(LSTR("guildinstancerank.1.10.002"))
    })
    local res = ed.getDataTable("GuildAvatar")[fastData._icon].Picture
    local time = ed.getdhmsCString(fastData._time)
    rankPanel.rankList:changeItemConfig(4)
    rankPanel.rankList:addItem({
      res,
      fastData._name,
      fastData._id,
      time
    })
  end
  rankPanel.rankList:changeItemConfig()
  rankPanel.rankList:addItem({
    stageName
  })
  rankPanel.rankList:changeItemConfig(2)
  rankPanel.rankList:addItem({
    T(LSTR("guildinstancerank.1.10.004"))
  })
  local firstData = data._first_pass
  if firstData then
    local summary = firstData._summary
    local y, mon, d, h, m, s = ed.time2YMDHMS(firstData._pass_time)
    local timeDes = T(LSTR("guildinstancerank.1.10.005"), y, mon, d)
    rankPanel.rankList:changeItemConfig(3)
    rankPanel.rankList:addItem({
      {
        id = summary._avatar,
        level = summary._level,
        scale = 0.6,
        name = summary._name
      },
      summary._guild_name,
      timeDes
    })
  else
    addHint(T(LSTR("guildinstancerank.1.10.006")))
  end
  rankPanel.rankList:changeItemConfig(2)
  rankPanel.rankList:addItem({
    T(LSTR("guildinstancerank.1.10.007"))
  })
  local dps = data._dps_rank
  if dps then
    for i, v in ipairs(dps) do
      local rankNode = getRankNode(i)
      local summary = v._dps_user
      if v._array and i <= showHeroNum then
        rankPanel.rankList:changeItemConfig(7)
        local heros = getHerosNode(v._array._heros)
        rankPanel.rankList:addItem({
          rankNode,
          {
            id = summary._avatar,
            level = summary._level,
            scale = 0.6,
            name = summary._name
          },
          summary._guild_name,
          v._dps,
          heros
        })
      else
        rankPanel.rankList:changeItemConfig(5)
        rankPanel.rankList:addItem({
          rankNode,
          {
            id = summary._avatar,
            level = summary._level,
            scale = 0.6,
            name = summary._name
          },
          summary._guild_name,
          v._dps
        })
      end
    end
  else
    addHint(T(LSTR("guildinstancerank.1.10.008")))
  end
end
function ed.showGuildInstanceRank(data)
  if rankPanel == nil then
    rankPanel = panelMeta:new2(rankLogic, EDTables.guildConfig.instanceRankRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(rankPanel:getRootLayer(), 500)
    end
  end
  initPanel(data)
end

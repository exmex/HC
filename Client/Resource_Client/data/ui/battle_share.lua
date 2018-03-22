local class = {}
ed.battleshare = class
local oppoInformation, oppoNameData
local oppodynas = {}
local oppoheroes = {}
local battleResultInformation, playerInformation
local playerHeroes = {}
local playerHeroesDyna = {}
local rseed, stage_id, sharePanel, selectChannel
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
local function release()
  oppoInformation = nil
  oppoNameData = nil
  oppodynas = {}
  oppoheroes = {}
  battleResultInformation = nil
  playerInformation = nil
  playerHeroes = {}
  playerHeroesDyna = {}
  rseed = nil
  sharePanel = nil
  selectChannel = nil
  stage_id = nil
end
local setOppoHeroes = function(target, heroes)
  for k, v in ipairs(heroes) do
    table.insert(target, v[".data"])
  end
end
local function getOppoInfo(data, oppodyna)
  release()
  oppoNameData = data
  oppodynas = oppodyna
end
class.getOppoInfo = getOppoInfo
local function getRseed(data)
  rseed = data
end
class.getRseed = getRseed
local function setStageid(id)
  stage_id = id
end
class.setStageid = setStageid
local function getBattleData(data)
  battleResultInformation = data
end
class.getBattleData = getBattleData
local function setPlayerHeroes(playerInformation)
  if not playerInformation then
    return
  end
  for k, v in ipairs(playerInformation) do
    table.insert(playerHeroesDyna, v.crusadeData)
    table.insert(playerHeroes, v.data[".data"])
  end
end
local function getPlayerInfo(playerdata, oppodata)
  playerInformation = playerdata
  oppoInformation = oppodata
  setPlayerHeroes(playerInformation)
  setOppoHeroes(oppoheroes, oppoInformation)
end
class.getPlayerInfo = getPlayerInfo
local function setBinary()
  local msg = ed.upmsg.battle_record()
  msg._checkid = 1
  msg._userid = 1
  msg._username = ed.player:getName()
  msg._level = ed.player:getLevel()
  msg._avatar = ed.player:getAvatar()
  msg._vip = ed.player:getvip()
  msg._oppo_userid = 1
  msg._oppo_name = oppoNameData._summary._name
  msg._oppo_level = oppoNameData._summary._level
  msg._oppo_avatar = oppoNameData._summary._avatar
  msg._oppo_vip = oppoNameData._summary._vip
  msg._oppo_robot = oppoNameData._is_robot
  msg._result = battleResultInformation.result
  msg._self_heroes = playerHeroes
  msg._self_dynas = playerHeroesDyna
  msg._oppo_heroes = oppoheroes
  msg._oppo_dynas = oppodynas
  msg._rseed = rseed
  msg._self_robot = 1
  msg._param1 = stage_id
  msg._operations = battleResultInformation.operations
  local code, err = msg:Serialize()
  local data = ed.upmsg.battle_record():Parse(code)
  return code
end
local showReplay = function(data, stageid)
  if not data then
    return
  end
  ed.showReplay(data)
end
class.showReplay = showReplay
local function exit()
  if nil == sharePanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(sharePanel:getRootLayer(), true)
  end
end
function class.shareToWorld()
  if ed.player:getLevel() < 24 then
    ed.showToast(T(LSTR("CHAT.REACH_LEVEL_24_TO_USE_THE_WORLD_CHANNEL")))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  sharePanel.shareLayer.input:setVisible(true)
  selectChannel = "world_channel"
end
function class.shareToUnin()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T(LSTR("CHAT.NEED_TO_JOIN_A_GUILD_FIRST_TO_USE_THE_GUILD_CHANNEL")))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  sharePanel.shareLayer.input:setVisible(true)
  selectChannel = "guild_channel"
end
function class.cancelShare()
  exit()
end
function class.sendShare()
  if oppoInformation and battleResultInformation and playerInformation then
    local result = string.format("<link|pvp|%s>", sharePanel.shareLayer.replayName:getString())
    local content = sharePanel.shareLayer.input:getString()
    if content ~= "" then
      result = string.format("%s<><text|chat_content|%s|400>", result, content)
    end
    ed.ui.chat.sendPvpLink(result, stage_id, selectChannel, setBinary(), "binary_replay")
    exit()
  end
end
function class.closeShare()
  exit()
end
local function create()
  if sharePanel == nil then
    sharePanel = panelMeta:new2(class, EDTables.battleShareConfig.ShareUIRes)
  end
  if getRunScene() then
    getRunScene():addChild(sharePanel:getRootLayer(), 200)
  end
  sharePanel.shareLayer:setVisible(true)
  sharePanel.shareLayer.shareBg:setVisible(true)
  sharePanel.shareLayer.share:setVisible(false)
  sharePanel.shareLayer.input:setVisible(false)
  sharePanel.shareLayer.input.edit:setAnchorPoint(ccp(0, 0))
  local replayName = string.format(LSTR("battle_share.1.10.1.001"), ed.player:getName(), oppoNameData._summary._name or "")
  ed.setString(sharePanel.shareLayer.replayName, replayName)
end
class.create = create

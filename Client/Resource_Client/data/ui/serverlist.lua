local class = {}
ed.serverlist = class
local serverlistPanel
local serverListData = {}
local lastServerInfo = {}
local currentServerName = ""
local bSDKLoginSucess = false
local colNum = 10
local sessionId = ""
local user_id = ""
local stateColor = {
  [T(LSTR("SERVERLOGIN.MAINTAINENACE"))] = ccc3(183, 183, 183),
  [T(LSTR("SERVERLOGIN.FULL"))] = ccc3(255, 81, 20),
  [T(LSTR("SERVERLOGIN.BUSY"))] = ccc3(255, 225, 20),
  [T(LSTR("SERVERLOGIN.RECOMMEND"))] = ccc3(20, 255, 59),
  [T(LSTR("serverlist.1.10.1.001"))] = ccc3(238, 204, 119)
}
local function release()
  serverListData = {}
  lastServerInfo = {}
  currentServerName = ""
  bSDKLoginSucess = false
  sessionId = ""
  user_id = ""
  serverlistPanel = nil
end
local function getServerInfoByName(name)
  for k, v in ipairs(serverListData) do
    if v.name == name then
      return v
    end
  end
  return serverListData[1]
end
local function getLastServerInfo()
  local lastServerName = CCUserDefault:sharedUserDefault():getStringForKey("lastservername")
  if lastServerName == "" then
    lastServerName = serverListData[1].name
  end
  lastServerInfo = getServerInfoByName(lastServerName)
end
local getGroupNum = function(data, num)
  if 0 == num then
    return
  end
  return math.ceil(data / num)
end
local setItemData = function(n, k, dataLen)
  local minNum = k * n - (n - 1)
  local maxNum = k * n
  if dataLen < maxNum then
    maxNum = dataLen
  end
  return minNum, maxNum
end
local setZeroForNum = function(num)
  local sNum = tostring(num)
  if #sNum < 3 then
    for k = 3 - #sNum, 1, -1 do
      sNum = "0" .. sNum
    end
  end
  return sNum
end
local function initListView(serverData)
  local groupNum = getGroupNum(#serverData, colNum)
  for k = groupNum, 1, -1 do
    local minNum, maxNum = setItemData(colNum, k, #serverData)
    local string = setZeroForNum(minNum) .. "--" .. setZeroForNum(maxNum) .. T(LSTR("serverlist.1.10.1.002"))
    serverlistPanel.ListView:changeItemConfig()
    serverlistPanel.ListView:addItem({string}, {minNum, maxNum})
  end
end
local setNodeColor = function(node1, node2, color)
  if node1 then
    node1:setColor(color)
  end
  if node2 then
    node2:setColor(color)
  end
end
local function createServerItem(minNum, maxNum)
  ed.setString(serverlistPanel.servernum, T("服务器 ") .. minNum .. "-" .. maxNum)
  serverlistPanel.serverInfo:clear()
  serverlistPanel.serverInfo:changeItemConfig()
  for k = minNum, maxNum do
    local index = #serverListData + 1 - k
    local itemData = serverlistPanel.serverInfo:addItem({
      serverListData[index].name,
      serverListData[index].state
    }, {
      serverListData[index],
      k
    })
    if stateColor[serverListData[index].state] then
      setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, stateColor[serverListData[index].state])
    end
    if itemData.extraData[2] == maxNum or itemData.extraData[2] == maxNum - 1 then
      itemData.controllers.lineinfo:setVisible(false)
    end
  end
end
local function initLastServerInfo()
  local itemData = serverlistPanel.lastServerInfo:addItem({
    lastServerInfo.name,
    lastServerInfo.state
  }, {lastServerInfo})
  if stateColor[lastServerInfo.state] then
    setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, stateColor[lastServerInfo.state])
  end
end
local function initServerInfo()
  createServerItem(1, 10)
end
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
local function exit()
  if nil == serverlistPanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(serverlistPanel:getRootLayer(), true)
  end
  release()
end
function class.listDownClick(itemData, x, y)
  local listData = serverlistPanel.ListView:getALLListData()
  for k = 1, #listData do
    if listData[k] == itemData then
      listData[k].controllers.bg:setVisible(true)
      listData[k].controllers.servername:setColor(ccc3(255, 234, 198))
    else
      listData[k].controllers.servername:setColor(ccc3(238, 204, 119))
      listData[k].controllers.bg:setVisible(false)
    end
  end
end
local function initData(data)
  serverListData = data.serverListData
  currentServerName = data.currentServerName
  user_id = userid
  sessionId = data.sessionId
  bSDKLoginSucess = data.bSDKLoginSucess
  getLastServerInfo()
end
function class.create(data)
  initData(data)
  if nil == serverlistPanel then
    serverlistPanel = panelMeta:new2(class, EDTables.serverlistConfig.UIRes)
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:addChild(serverlistPanel:getRootLayer(), 500)
  end
  initListView(serverListData)
  initLastServerInfo()
  initServerInfo()
end
local function setLabelText(index, text)
  ed.setString(serverlistPanel.servername .. index, text)
end
function class.onListClick(itemData, x, y)
  if not itemData.extraData then
    return
  end
  createServerItem(itemData.extraData[1], itemData.extraData[2])
end
function class.onClickServerinfo(itemData, x, y)
  ed.ui.serverlogin.refreshCurrentServerInfo(itemData.extraData[1].name)
  exit()
end
function class.serverInfoDownClick(itemData, x, y)
  local listData = serverlistPanel.serverInfo:getALLListData()
  local lastServerlistData = serverlistPanel.lastServerInfo:getALLListData()
  if lastServerlistData[1] == itemData then
    lastServerlistData[1].controllers.bg:setVisible(true)
    for k = 1, #listData do
      listData[k].controllers.bg:setVisible(false)
    end
  else
    lastServerlistData[1].controllers.bg:setVisible(false)
    for k = 1, #listData do
      if listData[k] == itemData then
        listData[k].controllers.bg:setVisible(true)
      else
        listData[k].controllers.bg:setVisible(false)
      end
    end
  end
end
function class.serverInfoUpClick()
  local listData = serverlistPanel.serverInfo:getALLListData()
  for k = 1, #listData do
    listData[k].controllers.bg:setVisible(false)
  end
  serverlistPanel.lastServerInfo:getListData(1).controllers.bg:setVisible(false)
end

local Activities = {}
activitiesPanel = nil
local ipairs = ipairs
ed.ui.activities = Activities
local activitiesButton = {}
local buttonPanel
ed.ui.activitiesButton = activitiesButton
local activitiesInfo, login_reply
local release = function()
end
function Activities.ListClick(itemData, x, y)
  if nil == itemData then
    return
  end
  if nil == itemData.extraData.data then
    return
  end
  local info = itemData.extraData.data
  if "single_br_tavern" == info._type or "combo_br_tavern" == info._type or "single_gd_tavern" == info._type or "combo_gd_tavern" == info._type or "magic_soul_tavern" == info._type then
    ed.ui.tenPumping.create(info)
  elseif "rmb_recharge" == info._type or "diamond_consume" == info._type then
    ed.ui.rebateActivities.create(info)
  end
end
local splitInfo = function(info)
  print("info " .. #info)
  local rightActivities = {}
  local endActivities = {}
  local currentTime = os.time()
  for i = 1, #info or {} do
    if currentTime <= info[i]._end_time then
      table.insert(rightActivities, info[i])
    else
      table.insert(endActivities, info[i])
    end
  end
  print("endActivities " .. #endActivities)
  return rightActivities, endActivities
end
local setDescPosition = function(k)
  local listData = activitiesPanel.findListView:getListData(k)
  local size = listData.controllers.name1:getContentSize()
  if size.width > 420 then
    size.width = 420
    listData.controllers.name1:setDimensions(CCSizeMake(size.width, size.height))
  end
  listData.controllers.info1:setPosition(ccp(size.width + 20, -15))
  local size1 = listData.controllers.info1:getContentSize()
  if size.width + size1.width > 460 then
    size1.width = 460 - size.width
    listData.controllers.info1:setDimensions(CCSizeMake(size1.width, size1.height))
  end
end
local function init(info)
  local rightActivities, endActivities = splitInfo(info)
  activitiesPanel.findListView:setAutoClipItemsEnabled(false)
  activitiesPanel.findListView:changeItemConfig(2)
  activitiesPanel.findListView:addItem({
    T(LSTR("ACTIVITIESLIST.IN_PROGRESS"))
  }, {})
  activitiesPanel.findListView:changeItemConfig(1)
  for k = 1, #(rightActivities or {}) do
    local v = rightActivities[k]
    local title = string.format("%s:", v._title)
    local desc = v._desc
    activitiesPanel.findListView:addItem({title, desc}, {data = v})
    setDescPosition(k + 1)
  end
  activitiesPanel.findListView:changeItemConfig(2)
  if #endActivities > 0 then
    activitiesPanel.findListView:addItem({
      T(LSTR("ACTIVITIESLIST.ENDED"))
    }, {})
  end
  activitiesPanel.findListView:changeItemConfig(1)
  for k = 1, #(endActivities or {}) do
    local v = endActivities[k]
    local title = string.format("%s:", v._title)
    local desc = v._desc
    activitiesPanel.findListView:addItem({title, desc}, {data = v})
    setDescPosition(k + 2 + #rightActivities)
  end
end
local function refreshList(info)
  activitiesPanel.findListView:clear()
  init(info)
end
local function create(info)
  activitiesInfo = info
  if activitiesPanel then
    refreshList(info)
    return
  end
  if nil == activitiesPanel then
    activitiesPanel = panelMeta:new2(Activities, EDTables.activitiesConfig.UIRes)
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:addChild(activitiesPanel:getRootLayer(), 500)
    init(info)
  end
end
ListenEvent("getActivities", create)
local setAllowTarget = function(info)
  for k = 1, #info._rewards or {} do
    local v = info._rewards[k]
    if info._type == "single_br_tavern" or info._type == "combo_br_tavern" or info._type == "single_gd_tavern" or info._type == "combo_gd_tavern" or info._type == "magic_soul_tavern" then
      if v._dailyjob._task_target > v._dailyjob._last_rewards_time then
        return true
      end
    elseif (info._type == "rmb_recharge" or info._type == "iamond_consume") and v._dailyjob._last_rewards_time == 0 and v._amount < v._dailyjob._task_target then
      return true
    end
  end
  return false
end
local function judgeAllowData()
  local info = activitiesInfo
  for k = 1, #info or {} do
    if setAllowTarget(info[k]) and buttonPanel then
      buttonPanel.ui21:setVisible(true)
      return
    end
  end
  if buttonPanel then
    buttonPanel.ui21:setVisible(false)
  end
end
function Activities.exit()
  judgeAllowData()
  if nil == activitiesPanel then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(activitiesPanel:getRootLayer(), true)
    activitiesPanel = nil
  end
  release()
end
function activitiesButton.create(parent, pos)
  local info = login_reply
  if not info then
    return
  end
  if not info then
    return
  end
  if nil == buttonPanel then
    buttonPanel = panelMeta:new2(activitiesButton, EDTables.activitiesConfig.UIButton)
  end
  if parent then
    parent:addChild(buttonPanel:getRootLayer(), 10)
    buttonPanel.panelLayers.mainLayer.buttonList[1].sprite:setPosition(pos)
    buttonPanel.panelLayers.mainLayer.uiControllers.ui21:setPosition(ccpAdd(pos, ccp(0, 12)))
  end
  if info then
    buttonPanel.ui21:setVisible(true)
    login_reply = nil
  end
end
function activitiesButton.refesh(parent, pos)
  if not buttonPanel and parent then
    activitiesButton.create(parent, pos)
  end
  local info = login_reply
  if info and buttonPanel then
    buttonPanel.ui21:setVisible(true)
  end
end
local function setData(info)
  login_reply = info
end
ListenEvent("activityNotify", setData)
function activitiesButton.createlist()
  local msg = ed.upmsg.ask_activity_info()
  ed.send(msg, "ask_activity_info")
end

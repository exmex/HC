local tenPumping = {}
local tenPumpingPanel
ed.ui.tenPumping = tenPumping
local ipairs = ipairs
local title, pTime, desc, rewards, showPanel, joinNum, noGetNum, getInfo, activitieData, endTime, noGetNumLTTF, prizesInfo
local iconnameTable = {}
local function initData()
  iconnameTable = {}
end
local function release()
  tenPumpingPanel = nil
  activitieData = nil
  title = nil
  pTime = nil
  rewards = nil
  getInfo = nil
  endTime = nil
  showPanel = nil
  joinNum = nil
  noGetNum = nil
  getInfo = nil
  activitieData = nil
  endTime = nil
  iconnameTable = nil
  prizesInfo = nil
end
local initPrizeData = function(data)
  local tt = data or {}
  local t = {
    id = tt._id,
    type = tt._type,
    startTime = tt._start_time,
    endTime = tt._end_time,
    title = tt._title,
    desc = tt._desc,
    rules = tt._rules
  }
  t.rewards = tt._rewards
  return t
end
local setPostion = function(icon)
  local anchor = icon:getAnchorPoint()
  local size = icon:getContentSize()
  local scaleX = icon:getScaleX()
  local scaleY = icon:getScaleY()
  local w = size.width * scaleX
  local h = size.height * scaleY
  local pos = icon:getParent():convertToWorldSpace(ccp(icon:getPosition()))
  local posX = pos.x
  local posY = pos.y
  local x = posX
  local y = posY + (0.4 - anchor.y) * h
  return x, y
end
local createTitleLabel = function(text1, amount, text2, info1, info2)
  local icon1, icon2, icon3
  icon1 = ed.createLabelWithFontInfo(text1, info1)
  icon1:setAnchorPoint(ccp(1, 0))
  icon2 = ed.createLabelWithFontInfo(amount, info2)
  icon2:setAnchorPoint(ccp(1, 0))
  if ed.createLabelWithFontInfo(text2, info1) then
    icon3 = ed.createLabelWithFontInfo(text2, info1)
  else
    icon3 = ed.createSprite(text2)
  end
  icon3:setAnchorPoint(ccp(1, 1))
  icon3:addChild(icon2)
  icon2:addChild(icon1)
  return icon3
end
local function createPrizeList(list)
  local loots = list or {}
  local iconTable = {}
  for k, v in ipairs(loots) do
    local icon = CCSprite:create("UI/alpha/HVGA/fragment_stencil.png")
    local plistIcon, plistName, plistNum, plistIcon1, plistIcon2, fragmentIcon
    if v._type == "item" then
      plistIcon = ed.readequip.createIcon(v._id)
      plistName = ed.getDataTable("equip")[v._id].Name
    elseif v._type == "hero" then
      plistIcon = ed.readequip.createIcon(v._id)
      plistName = ed.getDataTable("Unit")[v._id]["Display Name"]
    elseif v._type == "rmb" then
      plistIcon = CCSprite:create("UI/alpha/HVGA/task_rmb_icon.png")
      plistName = LSTR("RECHARGE.DIAMOND")
    elseif v._type == "money" then
      plistIcon = CCSprite:create("UI/alpha/HVGA/task_gold_icon.png")
      plistName = LSTR("TASK.GOLD")
    elseif v._type == "rand_soul" then
      plistIcon1, fragmentIcon = ed.readequip.getUnknownHeroStone()
      plistIcon1:setAnchorPoint(ccp(0, 0))
      plistIcon1:setPosition(ccp(0, 0))
      plistIcon = ed.createScale9Sprite("UI/alpha/HVGA/fragment_frame_blue.png")
      plistIcon:setAnchorPoint(ccp(0, 0))
      plistIcon:setPosition(ccp(0, 0))
      plistIcon:addChild(plistIcon1)
      plistName = T(LSTR("REBATEACTIVITIES.RANDOM_SOUL_STONE_"))
    end
    local size = icon:getContentSize()
    plistIcon:setAnchorPoint(ccp(0.5, 0.5))
    plistIcon:setPosition(ccp(size.width / 2, size.height / 2))
    plistNum = string.format("x%d", v._amount)
    plistNum = ed.createLabelTTF(plistNum, 20)
    plistName = ed.createLabelWithFontInfo(plistName, "dark_white2")
    plistNum:setAnchorPoint(ccp(1, 0))
    plistNum:setPosition(ccp(80, 5))
    plistNum:setStroke(ccc3(0, 0, 0), 3)
    plistName:setAnchorPoint(ccp(0.5, 0.5))
    plistName:setPosition(ccp(35, -10))
    plistIcon:addChild(plistNum)
    icon:addChild(plistIcon)
    plistIcon:addChild(plistName)
    icon:setScale(0.8)
    icon[k] = icon
    plistIcon[k] = plistIcon
    table.insert(iconTable, icon[k])
  end
  return iconTable
end
local movePosition = function(icon, height)
  local size = icon:getContentSize()
  size.height = size.height + height
  icon:setContentSize(CCSizeMake(size.width, size.height))
end
local function setPrizeList(iconTable)
  prizesInfo = iconTable or {}
  local size = prizesInfo[1]:getContentSize()
  local x, y = 150, 18
  local listData = tenPumpingPanel.ListView:getListData(1)
  if #prizesInfo > 4 then
    listData.controllers.bgframe3:setContentSize(CCSizeMake(440, 190))
    listData.controllers.bgframe3:setAnchorPoint(ccp(0, 0.75))
    movePosition(listData.controllers.pNoGetTitle, 160)
    movePosition(listData.controllers.pNoGet, 160)
    listData.controllers.getprize1:setPosition(ccp(360, -360))
    listData.controllers.getprize1.dataInfo.layout.position = ccp(360, -360)
    listData.height = 560
  end
  for k = 1, #prizesInfo do
    local v = prizesInfo[k]
    local x1 = 100 * (k - 1) + x
    local y1 = y
    if k > 4 then
      x1 = 100 * (k - 5) + x
      y1 = y - 100
      tenPumpingPanel.ListView.dragList:initListHeight(400)
    end
    v:setPosition(ccp(x1, y1))
    listData.controllers.ui2:addChild(v)
    table.insert(iconnameTable, v)
  end
end
local formatTime = function(time)
  local wTime = os.date(LSTR("REBATEACTIVITIES._Y__M__D__H_"), time)
  return wTime
end
local function setVisibleWithUI(num)
  if 0 == num then
    local listData = tenPumpingPanel.ListView:getListData(1)
    listData.controllers.pNoGetTitle:setVisible(false)
    listData.controllers.pNoGet:setVisible(false)
    listData.controllers.getprize1:setVisible(false)
    tenPumpingPanel.ListView.dragList:initListHeight(320)
  end
end
local function init(list)
  local prize = initPrizeData(list)
  title = prize.title
  pTime = string.format("%s-%s", formatTime(prize.startTime), formatTime(prize.endTime))
  desc = prize.desc
  endTime = prize.endTime
  if string.len(desc) > 184 then
    desc = string.sub(desc, 1, 184)
  end
  joinNum = createTitleLabel(T(LSTR("TENPUMPING.PARTICIPATED")), prize.rewards[1]._dailyjob._task_target, T(LSTR("DAILYLOGIN.TIMES")), "dark_white1", "chat_quality_white")
  joinNum:setAnchorPoint(ccp(0, 0.5))
  joinNum:setPosition(ccp(60, 0))
  noGetNum = prize.rewards[1]._dailyjob._task_target - prize.rewards[1]._dailyjob._last_rewards_time
  if noGetNum < 0 then
    noGetNum = 0
  end
  noGetNumLTTF = createTitleLabel(T(""), noGetNum, T(LSTR("DAILYLOGIN.TIMES")), "dark_white1", "chat_quality_white")
  noGetNumLTTF:setAnchorPoint(ccp(0, 0.5))
  noGetNumLTTF:setPosition(ccp(70, 0))
  ed.setString(tenPumpingPanel.title, title)
  rewards = prize.rewards
  tenPumpingPanel.ListView:changeItemConfig(1)
  tenPumpingPanel.ListView:setAutoClipItemsEnabled(false)
  tenPumpingPanel.ListView:addItem({
    pTime,
    desc,
    joinNum,
    noGetNumLTTF
  }, {})
  setVisibleWithUI(noGetNum)
  local iconTable = createPrizeList(prize.rewards[1]._rewards)
  setPrizeList(iconTable)
end
local doTaskConsume = function(info, index)
  for i = 1, #(info or {}) do
    local v = info[i]
    local id = v._id
    local type = v._type
    local amount = v._amount
    if "rmb" == type then
      ed.player:addrmb(amount)
    elseif "money" == type then
      ed.player:addMoney(amount)
    elseif "item" == type then
      ed.player:addEquip(id, amount)
    elseif "hero" == type then
      ed.player:addHero(id)
    end
  end
end
local function doClickPrizeReply(replys)
  local info = replys._activity_reward
  if not replys._result then
    ed.showToast(T(LSTR("TASK.TASK_SUBMISSION_FAILED")))
  else
    doTaskConsume(info)
    noGetNum = 0
    local listData = tenPumpingPanel.ListView:getListData(1)
    noGetNumLTTF = createTitleLabel(T(""), noGetNum, T(LSTR("DAILYLOGIN.TIMES")), "dark_white1", "chat_quality_white")
    noGetNumLTTF:setAnchorPoint(ccp(0, 0.5))
    noGetNumLTTF:setPosition(ccp(70, 0))
    activitieData._rewards[1]._dailyjob._last_rewards_time = activitieData._rewards[1]._dailyjob._task_target
    tenPumping.create(activitieData)
    local items = {}
    for i = 1, #(info or {}) do
      local r = info[i]
      local types
      if "money" == r._type then
        types = "Gold"
      elseif "rmb" == r._type then
        types = "Diamond"
      elseif "item" == r._type then
        types = "item"
      elseif "hero" == r._type then
        types = "item"
      elseif "rand_soul" == r._type then
        types = "item"
      end
      local it = {
        type = types,
        id = r._id,
        amount = r._amount
      }
      table.insert(items, it)
    end
    local config = {
      type = "getProp",
      param = {title = LSTR("REBATEACTIVITIES.GAINED"), items = items}
    }
    ed.announce(config)
    local msg = ed.upmsg.ask_activity_info()
    ed.send(msg, "ask_activity_info")
  end
end
ListenEvent("getTemPuming", doClickPrizeReply)
local function completeTask(info)
  getInfo = info
  local msg = ed.upmsg.job_rewards()
  msg._job = info._dailyjob._id
  ed.netreply.tenPumping = "2"
  ed.send(msg, "job_rewards")
end
local function overTime(endtime)
  local currentTime = os.time()
  if endtime > currentTime then
    return true
  end
  if currentTime - endTime > 0 then
    return false
  else
    return true
  end
end
local function overGetTime(endtime)
  local currentTime = os.time()
  if endtime > currentTime then
    return true
  end
  if currentTime - endTime > 86400 then
    return false
  else
    return true
  end
end
function tenPumping.getPrize()
  if not overGetTime(endTime) then
    ed.showToast(T(LSTR("REBATEACTIVITIES.YOU_HAVE_BEEN_ON_THE_PODIUM_TIME_")))
    return
  end
  if 0 == joinNum then
    return
  end
  if 0 == noGetNum then
    ed.showToast(T(LSTR("REBATEACTIVITIES.YOU_HAVE_CLAIMED_THE_REWARDS")))
    return
  end
  if nil == activitieData then
    return
  end
  local info = activitieData._rewards[1]
  completeTask(info)
end
local function suspensionLayer(i, icon)
  local info = activitieData._rewards[1]
  if showPanel then
    tenPumpingPanel.frame1:removeChild(showPanel, true)
    showPanel = nil
  end
  if nil == showPanel then
    local pinfo = info._rewards[i]
    if "rmb" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("Diamond")
    elseif "money" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("Gold")
    elseif "rand_soul" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("rand_soul")
    else
      showPanel = ed.readequip.getDetailCard(pinfo._id)
    end
    local x, y = setPostion(icon)
    local pos = ccp(x, y)
    showPanel:setPosition(pos)
    showPanel:setScale(1)
  end
  tenPumpingPanel.frame1:addChild(showPanel)
end
function tenPumping.listDownClick(itemData, x, y)
  for k = 1, #(iconnameTable or {}) do
    local v = iconnameTable[k]
    if ed.containsPoint(v, x, y) then
      suspensionLayer(k, v)
      return
    end
  end
  return
end
function tenPumping.listUpClick()
  if tenPumpingPanel and showPanel then
    tenPumpingPanel.frame1:removeChild(showPanel, true)
    showPanel = nil
  end
end
function tenPumping.listMoveClick()
  if tenPumpingPanel and showPanel then
    tenPumpingPanel.frame1:removeChild(showPanel, true)
    showPanel = nil
  end
end
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
function tenPumping.exit()
  if nil == tenPumpingPanel then
    return
  end
  local listData = tenPumpingPanel.ListView:getListData(1)
  listData.controllers.getprize1.dataInfo.layout.position = ccp(360, -270)
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(tenPumpingPanel:getRootLayer(), true)
  end
  release()
end
function tenPumping.joinPrize()
  if not overTime(endTime) then
    ed.showToast(T(LSTR("REBATEACTIVITIES.THIS_ACTIVITY_HAS_EXPIRED_YOU_ARE_UNABLE_TO_ATTEND_")))
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(tenPumpingPanel:getRootLayer(), true)
    tenPumpingPanel = nil
    currentScene:removeChild(activitiesPanel:getRootLayer(), true)
    activitiesPanel = nil
    ed.pushScene(ed.ui.tavern.create())
  end
end
local function refreshList(info)
  tenPumpingPanel.ListView:clear()
  init(info)
end
function tenPumping.create(info)
  initData()
  if nil == info then
    return
  end
  if tenPumpingPanel then
    refreshList(info)
    return
  end
  if nil == tenPumpingPanel then
    tenPumpingPanel = panelMeta:new2(tenPumping, EDTables.tenPumpingConfig.UIRes)
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:addChild(tenPumpingPanel:getRootLayer(), 500)
  end
  activitieData = info
  init(info)
end

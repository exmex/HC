local rebateActivities = {}
local rebatepanel
local rolepanelLogic = {}
local rolepanel
ed.ui.rebateActivities = rebateActivities
local ipairs = ipairs
local activitieData, title, pTime, roles, hasDone, desc, rewards
local params = {}
local getIndex, getInfo, endTime, showPanel
local function release()
  title = nil
  pTime = nil
  roles = nil
  hasDone = nil
  desc = nil
  rewards = nil
  getIndex = nil
  getInfo = nil
  endTime = nil
end
local formatTime = function(time)
  local wTime = os.date(LSTR("REBATEACTIVITIES._Y__M__D__H_"), time)
  return wTime
end
local initPrizeData = function(data)
  local tt = data or {}
  local row = tt._rewards
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
local function createPrize(listdata)
  local iconlist = {}
  local list = listdata or {}
  local i = 0
  for k, v in ipairs(list) do
    local icon = CCSprite:create()
    local plistIcon, plistName, plistNum, plistIcon2
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
      plistName = LSTR("REBATEACTIVITIES.RANDOM_SOUL_STONE_")
    end
    plistIcon:setAnchorPoint(ccp(0.5, 1))
    plistIcon:setScale(0.8)
    plistIcon:setPosition(ccp(40, 80))
    plistNum = string.format("x%s", v._amount)
    plistNum = ed.createLabelTTF(plistNum, 20)
    plistNum:setAnchorPoint(ccp(1, 0))
    plistNum:setPosition(ccp(80, 5))
    plistNum:setStroke(ccc3(0, 0, 0), 3)
    plistIcon:addChild(plistNum)
    plistName = ed.createLabelWithFontInfo(plistName, "op_act_item_name")
    plistName:setAnchorPoint(ccp(0.5, 1))
    plistName:setPosition(ccp(40, 17))
    icon:addChild(plistIcon)
    icon:addChild(plistName)
    iconlist[k] = icon
    i = k
  end
  while i < 3 do
    local icon = CCSprite:create()
    iconlist["i+1"] = icon
    i = i + 1
  end
  i = nil
  return iconlist
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
local createTitleSprite = function(text1, amount, text2, info1, info2)
  local icon1, icon2, icon3
  icon1 = ed.createLabelWithFontInfo(text1, info1)
  icon1:setAnchorPoint(ccp(1, 0))
  icon2 = ed.createLabelWithFontInfo(amount, info2)
  icon2:setAnchorPoint(ccp(1, 0))
  icon2:setPosition(ccp(0, 5))
  icon3 = ed.createSprite(text2)
  icon3:setAnchorPoint(ccp(1, 1))
  icon3:addChild(icon2)
  icon2:addChild(icon1)
  return icon3
end
local function createPrizeIndex(info)
  local amount = info._amount
  local prizeTarget = info._dailyjob._task_target
  local rewards = info._rewards
  local isAllow = (amount or 1) <= (prizeTarget or 0)
  local bgRes, getRes, getConditions, bgResMark
  if "rmb_recharge" == activitieData._type then
    getConditions = createTitleLabel(LSTR("PRIVILEGE.ACCUMULATED_RECHARGING"), info._amount, LSTR("REBATEACTIVITIES.USD"), "op_act_grey", "op_act_dark_blue")
  elseif "diamond_consume" == activitieData._type then
    getConditions = createTitleLabel(LSTR("REBATEACTIVITIES.THE_CUMULATIVE_CONSUMPTION_"), info._amount, LSTR("REBATEACTIVITIES.DIAMOND"), "op_act_grey", "op_act_dark_blue")
  else
    return
  end
  if isAllow then
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_2.png"
    getRes = ed.createSprite("UI/alpha/HVGA/task_get_reward_button.png")
    getRes:setPosition(ccp(50, 18))
  else
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_1.png"
  end
  local prizeIcon = createPrize(rewards)
  rebatepanel.prizeListView:setAutoClipItemsEnabled(false)
  if 0 == info._dailyjob._last_rewards_time then
    rebatepanel.prizeListView:addItem({
      bgRes,
      getConditions,
      prizeIcon[1],
      prizeIcon[2],
      prizeIcon[3],
      bgResMark,
      getRes
    }, {data = info, isAllow = isAllow})
  else
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_1.png"
    bgResMark = "UI/alpha/HVGA/activity/activity_list_mask_received.png"
    getRes = ed.createSprite("UI/alpha/HVGA/dailylogin/dailylogin_checked_green.png")
    getRes:setPosition(ccp(45, 35))
    rebatepanel.prizeListView:addItem({
      bgRes,
      getConditions,
      prizeIcon[1],
      prizeIcon[2],
      prizeIcon[3],
      bgResMark,
      getRes
    }, {data = info, isAllow = isAllow})
  end
end
local function createPrizeList(list)
  list = list or {}
  for k, v in ipairs(list) do
    createPrizeIndex(v)
  end
end
local function createWindow()
  ed.setLabelString(rebatepanel.title, title)
  ed.setLabelString(rebatepanel.ptime, pTime)
  ed.setLabelString(rebatepanel.pdesc, desc)
  local hasDone1
  if not hasDone then
    hasDone = 0
  end
  if "rmb_recharge" == activitieData._type then
    hasDone1 = createTitleLabel(LSTR("REBATEACTIVITIES.HAS_ACCUMULATED"), hasDone, LSTR("REBATEACTIVITIES.USD"), "op_act_white", "op_act_light_blue")
  else
    hasDone1 = createTitleSprite(LSTR("REBATEACTIVITIES.ALREADY_ACCUMULATIVE_TOTAL_CONSUMPTION_"), hasDone, "UI/alpha/HVGA/task_rmb_icon_2.png", "op_act_white", "op_act_light_blue")
    rebatepanel.goto:setVisible(false)
  end
  rebatepanel.hasdone:addChild(hasDone1)
end
local function init(list)
  local prize = initPrizeData(list)
  title = prize.title
  pTime = string.format("%s-%s", formatTime(prize.startTime), formatTime(prize.endTime))
  desc = prize.desc
  roles = prize.rules
  endTime = prize.endTime
  hasDone = prize.rewards[1]._dailyjob._task_target
  if string.len(desc) > 130 then
    desc = string.sub(desc, 1, 184)
  end
  rewards = prize.rewards
  createPrizeList(rewards)
  createWindow()
end
function rebateActivities.showRoles()
  if nil == rolepanel then
    rolepanel = panelMeta:new2(rolepanelLogic, EDTables.rebateActivitiesConfig.rolUIRes)
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:addChild(rolepanel:getRootLayer(), 700)
  end
  rolepanel.roleListView:additem({roles}, {})
end
local function doTaskConsume(info, index)
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
  getInfo._dailyjob._last_rewards_time = string.format("%s", os.time())
  local data = {
    "UI/alpha/HVGA/activity/activity_list_bg_2.png"
  }
  local extraData = {}
  local newInfo = {data = data, extraData = extraData}
  rebatepanel.prizeListView:removeItem(index)
  createPrizeIndex(getInfo)
end
local function doClickPrizeReply(replys)
  local index = getIndex
  local info = replys._activity_reward
  if not replys._result then
    ed.showToast(LSTR("TASK.TASK_SUBMISSION_FAILED"))
  else
    doTaskConsume(info, index)
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
ListenEvent("getPrize", doClickPrizeReply)
local function completeTask(info, index)
  getInfo = info
  getIndex = index
  local msg = ed.upmsg.job_rewards()
  msg._job = info._dailyjob._id
  ed.netreply.tenPumping = "1"
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
  local y = posY + (0.5 - anchor.y) * h
  return x, y
end
function rebateActivities.onListClick(itemData, x, y)
  if nil == itemData then
    return
  end
  if nil == itemData.extraData then
    return
  end
  local info = itemData.extraData
  if not overGetTime(endTime) then
    ed.showToast(LSTR("REBATEACTIVITIES.YOU_HAVE_BEEN_ON_THE_PODIUM_TIME_"))
    return
  end
  if 0 == info.data._dailyjob._last_rewards_time then
    if info.isAllow then
      local index = rebatepanel.prizeListView:getClickIndex(x, y)
      completeTask(info.data, index)
      return
    end
    return
  end
  ed.showToast(LSTR("REBATEACTIVITIES.YOU_HAVE_CLAIMED_THE_REWARDS"))
  return
end
local function suspensionLayer(itemData, i)
  local icon = itemData.controllers["icon" .. i]
  if nil == itemData then
    return
  end
  if nil == itemData.extraData then
    return
  end
  local info = itemData.extraData.data
  if showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
  end
  if nil == showPanel then
    local pinfo = info._rewards[i]
    if not pinfo then
      return
    end
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
  rebatepanel.frame1:addChild(showPanel)
end
function rebateActivities.listDownClick(itemData, x, y)
  if ed.containsPoint(itemData.controllers.icon1, x, y) then
    suspensionLayer(itemData, 1)
    return
  end
  if ed.containsPoint(itemData.controllers.icon2, x, y) then
    suspensionLayer(itemData, 2)
    return
  end
  if ed.containsPoint(itemData.controllers.icon3, x, y) then
    suspensionLayer(itemData, 3)
    return
  end
end
function rebateActivities.listUpClick(itemData, x, y)
  if rebatepanel and showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
    return
  end
  if ed.containsPoint(itemData.controllers.frame4, x, y) then
    rebateActivities.onListClick(itemData, x, y)
    return
  end
end
function rebateActivities.listMoveClick()
  if rebatepanel and showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
    return
  end
end
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
function rebateActivities.create(info)
  if nil == info then
    return
  end
  if nil == rebatepanel then
    rebatepanel = panelMeta:new2(rebateActivities, EDTables.rebateActivitiesConfig.UIRes)
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:addChild(rebatepanel:getRootLayer(), 500)
  end
  activitieData = info
  init(info)
end
function rebateActivities.addRecharge()
  if not overTime(endTime) then
    ed.showToast(T(LSTR("REBATEACTIVITIES.THIS_ACTIVITY_HAS_EXPIRED_YOU_ARE_UNABLE_TO_ATTEND_")))
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rebatepanel:getRootLayer(), true)
    rebatepanel = nil
    currentScene:removeChild(activitiesPanel:getRootLayer(), true)
    activitiesPanel = nil
    local rechargeLayer = newrecharge.create()
    currentScene:addChild(rechargeLayer, 600)
  end
end
function rebateActivities.exit()
  if nil == rebatepanel then
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rebatepanel:getRootLayer(), true)
    rebatepanel = nil
  end
  release()
end
function rolepanelLogic.roleExit()
  if nil == rolepanel then
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rolepanel:getRootLayer(), true)
    rolepanel = nil
  end
end

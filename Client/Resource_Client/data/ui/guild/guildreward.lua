local guildRewardPanel, detailpanel, reward, currentRaidId, currentSelectIndex
local currentApplyId = 300
local currentRank = 200
local jumpTimes = 0
local jumpCost = 0
local guildRewardLogic = {}
function guildRewardLogic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and guildRewardPanel then
    currentScene:removeChild(guildRewardPanel:getRootLayer(), true)
    guildRewardPanel = nil
  end
end
function guildRewardLogic.hideDetail(index)
  if detailpanel and guildRewardPanel then
    detailpanel:removeFromParentAndCleanup(true)
    detailpanel = nil
  end
end
function guildRewardLogic.showDetail(index)
  guildRewardLogic.hideDetail()
  local item = guildRewardPanel.mainLayer.rewardList:getListData(index)
  local itemId = item.extraData.itemId
  if itemId then
    detailpanel = ed.readequip.getDetailCard(itemId)
    if detailpanel then
      local button = string.format("detail%d", index)
      local node = item.controllers.detail
      local pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
      detailpanel:setPosition(ccp(pos.x, pos.y + 10))
      guildRewardPanel.mainLayer.mainLayer:addChild(detailpanel, 20)
    end
  end
end
local function reqItem()
  if nil == currentSelectIndex then
    return
  end
  local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
  if nil == item then
    return
  end
  local msg = ed.upmsg.guild()
  msg._instance_apply = {}
  msg._instance_apply._raid_id = currentRaidId
  msg._instance_apply._item_id = item.extraData.itemId
  ed.send(msg, "guild")
end
local function showConformLayer()
  if currentSelectIndex == nil then
    return
  end
  local equipTable = ed.getDataTable("equip")
  local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
  local oldName = equipTable[currentApplyId].Name
  if item.extraData.state == "no_apply" then
    guildRewardPanel.conformLayer:setVisible(true)
    local newName = equipTable[item.extraData.itemId].Name
        guildRewardPanel.conformLayer.hintText1:setString(T(LSTR("guildreward.1.10.001"), oldName, currentRank,oldName,newName))
  else
    guildRewardPanel.conformLayer2:setVisible(true)
    guildRewardPanel.conformLayer2.hintText1:setString(T(LSTR("guildreward.1.10.002"), oldName, currentRank,oldName))
  end
end
local function doReqItem()
  if currentSelectIndex == nil then
    return
  end
  local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
  if currentRaidId and item and item.extraData.itemId then
    local equipTable = ed.getDataTable("equip")
    local raidTable = ed.getDataTable("Raid")
    local chapter = raidTable[currentRaidId]["Chapter ID"]
    local levelReq = ed.getDataTable("Chapter")[chapter]["Unlock Level"]
    if levelReq > ed.player:getLevel() then
      ed.showToast(T(LSTR("guildreward.2.0.0.001")))
      return
    end
    local newName = equipTable[item.extraData.itemId].Name
    if item.extraData.leftNum > 0 and item.extraData.ableApplyNum == 0 and item.extraData.state == "no_apply" then
      guildRewardPanel.conformLayer3:setVisible(true)
      guildRewardPanel.conformLayer3.hintText1:setString(T(LSTR("guildreward.2.0.0.002"), item.extraData.leftNum, newName))
      guildRewardPanel.conformLayer3.hintText2:setString(T(LSTR("guildreward.2.0.0.003")))
      return
    end
    if currentApplyId then
      showConformLayer()
      return
    end
    reqItem()
  end
end
guildRewardLogic.doReqItem = doReqItem
function guildRewardLogic.applyItem(index)
  currentSelectIndex = index
  doReqItem()
end
function guildRewardLogic.cancelApply()
  if not guildRewardPanel then
    return
  end
  guildRewardPanel.conformLayer:setVisible(false)
end
function guildRewardLogic.conformApply()
  if not guildRewardPanel then
    return
  end
  reqItem()
  guildRewardPanel.conformLayer:setVisible(false)
end
function guildRewardLogic.cancelApply2()
  if not guildRewardPanel then
    return
  end
  guildRewardPanel.conformLayer2:setVisible(false)
end
function guildRewardLogic.conformApply3()
  if not guildRewardPanel then
    return
  end
  guildRewardPanel.conformLayer3:setVisible(false)
  if currentApplyId then
    showConformLayer()
    return
  end
  reqItem()
end
function guildRewardLogic.cancelApply3()
  if not guildRewardPanel then
    return
  end
  guildRewardPanel.conformLayer3:setVisible(false)
end
local function getJumpDesc()
  local result = ""
  result = result .. T(LSTR("guildreward.1.10.005"), currentRank - 1)
  result = result .. T(LSTR("guildreward.1.10.006"))
  result = result .. T(LSTR("guildreward.1.10.007"), currentRank, jumpTimes)
  result = result .. T(LSTR("guildreward.1.10.008"), jumpCost)
  guildRewardPanel.jumpLayer.hintText1:setString(result)
end
function guildRewardLogic.jump()
  if not ed.ui.guild.getCanJump() then
    --ed.showToast(T(LSTR("guildreward.2.0.0.004")))
    return
  end
  if currentRank == 1 then
    ed.showToast(T(LSTR("guildreward.1.10.009")))
    return
  end
  if jumpCost > ed.player:getGuildMoney() then
    ed.showToast(T(LSTR("applyreward.1.10.015")))
    return
  end
  guildRewardPanel.jumpLayer:setVisible(true)
  getJumpDesc()
end
function guildRewardLogic.conformJump()
  guildRewardPanel.jumpLayer:setVisible(false)
  local msg = ed.upmsg.guild()
  msg._guild_jump = {}
  ed.send(msg, "guild")
end
function guildRewardLogic.cancelJump()
  guildRewardPanel.jumpLayer:setVisible(false)
end
function guildRewardLogic.conformApply2()
  if not guildRewardPanel then
    return
  end
  reqItem()
  guildRewardPanel.conformLayer2:setVisible(false)
end
function guildRewardLogic.closeRewarDetailLayer()
  if not guildRewardPanel then
    return
  end
  guildRewardPanel.rewardDetailLayer:setVisible(false)
end
function guildRewardLogic.reqDetail(index)
  currentSelectIndex = index
  local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
  if item then
    local msg = ed.upmsg.guild()
    msg._guild_app_queue = {}
    msg._guild_app_queue._item_id = item.extraData.itemId
    ed.send(msg, "guild")
  end
end
local function getItemDesc(leftNum, itemId, num)
  local str = ""
  if leftNum > 0 then
    str = T(LSTR("guildreward.1.10.010"), leftNum)
    if itemId == currentApplyId or num > 0 then
      str = str .. "<text|normalButton|,>"
    end
  end
  if itemId == currentApplyId then
    str = str .. T(LSTR("guildreward.1.10.011"), currentRank)
  elseif num > 0 then
    str = str .. T(LSTR("guildreward.1.10.012"), num)
  end
  return str
end
local function initPanel()
  if reward == nil or guildRewardPanel == nil then
    return
  end
  detailpanel = nil
  for i, v in ipairs(reward) do
    local item = string.format("<item|%d|0.8>", v._item_id)
    local str = getItemDesc(v._num, v._item_id, v._apply_num)
    local row = ed.getDataTable("equip")[v._item_id]
    local name
    if row then
      name = row.Name
    end
    local listItem = guildRewardPanel.mainLayer.rewardList:addItem({
      item,
      str,
      name
    }, {
      itemId = v._item_id,
      state = v._state,
      leftNum = v._num,
      applyNum = v._apply_num,
      ableApplyNum = v._able_app_count
    })
    if v._state == "apply" then
      listItem.controllers.alreadyApply:setVisible(true)
      listItem.controllers.noApply:setVisible(false)
    else
      listItem.controllers.alreadyApply:setVisible(false)
      listItem.controllers.noApply:setVisible(true)
    end
    listItem.controllers.conform:setVisible(v._apply_num > 0)
  end
end
function ed.showGuildReward(data)
  if data == nil then
    return
  end
  if guildRewardPanel == nil then
    guildRewardPanel = panelMeta:new2(guildRewardLogic, EDTables.guildInstanceReward.UIRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(guildRewardPanel:getRootLayer(), 100)
    end
  end
  reward = data._items
  currentRaidId = data._raid_id
  currentApplyId = data._apply_item_id
  currentRank = data._rank
  initPanel()
end
local function refreshList()
  local num = guildRewardPanel.mainLayer.rewardList:getListDataNum()
  for i = 1, num do
    local item = guildRewardPanel.mainLayer.rewardList:getListData(i)
    if item then
      if item.extraData.itemId == currentApplyId then
        item.controllers.alreadyApply:setVisible(true)
        item.controllers.noApply:setVisible(false)
        item.extraData.applyNum = item.extraData.applyNum + 1
        item.extraData.state = "apply"
        currentRank = item.extraData.applyNum
      else
        item.extraData.state = "no_apply"
        if item.controllers.alreadyApply:isVisible() then
          item.extraData.applyNum = item.extraData.applyNum - 1
        end
        item.controllers.alreadyApply:setVisible(false)
        item.controllers.noApply:setVisible(true)
      end
      local str = getItemDesc(item.extraData.leftNum, item.extraData.itemId, item.extraData.applyNum)
      item.controllers.itemNum:setString(str)
      item.controllers.conform:setVisible(item.extraData.applyNum > 0)
    end
  end
end
local function refreshDetailUI(rank)
  if nil == rank then
    return
  end
  if not guildRewardPanel.rewardDetailLayer:getVisible() then
    return
  end
  if rank > 0 then
    currentRank = rank
    guildRewardPanel.rewardDetailLayer.hint2:setVisible(true)
    guildRewardPanel.rewardDetailLayer.hint2:setString(T(LSTR("guildreward.1.10.013"), rank))
    guildRewardPanel.rewardDetailLayer.alreadyApply:setVisible(true)
    guildRewardPanel.rewardDetailLayer.noApply:setVisible(false)
  else
    guildRewardPanel.rewardDetailLayer.hint2:setVisible(false)
    guildRewardPanel.rewardDetailLayer.alreadyApply:setVisible(false)
    guildRewardPanel.rewardDetailLayer.noApply:setVisible(true)
  end
end
local function showApplyDetail(data)
  if nil == data then
    return
  end
  jumpTimes = data._jump_times
  jumpCost = data._cost_money
  guildRewardPanel.rewardDetailLayer:setVisible(true)
  guildRewardPanel.rewardDetailLayer.rewardList:clear()
  if data._summary then
    for i, v in ipairs(data._summary) do
      guildRewardPanel.rewardDetailLayer.rewardList:addItem({
        {
          id = v._avatar,
          scale = 0.6,
          name = v._name,
          vip = v._vip > 0,
          level = v._level
        },
        T("<artnum|white|%d>", i)
      })
    end
    guildRewardPanel.rewardDetailLayer.noApplyer:setVisible(false)
  else
    guildRewardPanel.rewardDetailLayer.noApplyer:setVisible(true)
  end
  guildRewardPanel.rewardDetailLayer.itemNum:setString(T(LSTR("guildreward.1.10.014"), data._item_count))
  guildRewardPanel.rewardDetailLayer.item:setString(T("<item|%d>", data._item_id))
  if 0 < data._item_count then
    guildRewardPanel.rewardDetailLayer.hint1:setVisible(true)
    if 0 < data._timeout then
      local nowTime = ed.getServerTime()
      local timeOut = data._timeout
      local h, m, s = ed.second2hms(timeOut - nowTime)
      if 0 < tonumber(h) then
      guildRewardPanel.rewardDetailLayer.hint1:setString(T(LSTR("guildreward.1.10.015"), h, m))
    else
      guildRewardPanel.rewardDetailLayer.hint1:setString(T(LSTR("guildreward.1.10.016"), m))
      end
    end
  else
    guildRewardPanel.rewardDetailLayer.hint1:setVisible(false)
  end
  refreshDetailUI(data._rank)
end
local function jumpResult(data)
  if nil == data then
    return
  end
  if data._result == "success" then
    ed.showToast(T(LSTR("guildreward.1.10.017")))
    ed.player:addGuildMoney(-jumpCost)
    showApplyDetail(data._app_queue)
    local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
    if item then
      local str = getItemDesc(item.extraData.leftNum, item.extraData.itemId, item.extraData.applyNum)
      item.controllers.itemNum:setString(str)
    end
  end
end
local function OnGuildRewardRsp(data)
  if data._instance_apply and data._instance_apply._result == "success" then
    local item = guildRewardPanel.mainLayer.rewardList:getListData(currentSelectIndex)
    if item then
      if guildRewardPanel.rewardDetailLayer:getVisible() then
        showApplyDetail(data._instance_apply._app_queue)
      end
      if item.extraData.state == "no_apply" then
        currentApplyId = item.extraData.itemId
        refreshList()
        refreshDetailUI(item.extraData.applyNum)
      else
        currentApplyId = nil
        currentRank = nil
        refreshList()
        refreshDetailUI(0)
      end
    end
  end
  if data._guild_app_queue then
    showApplyDetail(data._guild_app_queue)
  elseif data._guild_jump then
    jumpResult(data._guild_jump)
  end
end
ListenEvent("GuildRsp", OnGuildRewardRsp)
local damagePanel
local damageLogic = {}
function damageLogic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and damagePanel then
    currentScene:removeChild(damagePanel:getRootLayer(), true)
    damagePanel = nil
  end
end
function ed.showGuildDamage(data)
  if nil == data then
    return
  end
  if damagePanel == nil then
    damagePanel = panelMeta:new2(damageLogic, EDTables.guildInstanceReward.damageUIRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(damagePanel:getRootLayer(), 100)
    end
  end
  table.sort(data, function(a, b)
    return a._damage > b._damage
  end)
  local maxDamage = data[1]._damage
  for i, v in ipairs(data) do
    local item = damagePanel.damageList:addItem({
      v._challenger._summary._avatar,
      v._challenger._summary._level,
      v._challenger._summary._name,
      ed.setCommForNumber(v._damage),
      T("<artnum|white|%d>", i)
    })
    if v._challenger._summary._name == ed.player:getName() then
      item.controllers.bg:setVisible(false)
      item.controllers.bg2:setVisible(true)
    else
      item.controllers.bg:setVisible(true)
      item.controllers.bg2:setVisible(false)
    end
    local oldScale = item.controllers.percent:getScale()
    item.controllers.percent:setScaleX(v._damage / maxDamage * oldScale)
  end
end
local specialLootsLogic = {}
local specialLootsPanel, newBreakHistory
local function addReward(data)
  if nil == data then
    return
  end
  local result = ""
  for i, v in pairs(data) do
    local temp = string.format("<item|%d|0.8|%d>", i, v)
    result = result .. temp
  end
  specialLootsPanel.rewards:setString(result)
end
function specialLootsLogic.conform()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and specialLootsPanel then
    currentScene:removeChild(specialLootsPanel:getRootLayer(), true)
    specialLootsPanel = nil
  end
  if newBreakHistory then
    ed.showGuildHistoryRank(newBreakHistory)
  end
end
function ed.showGuildLoots(data, breakHistory)
  if specialLootsPanel == nil then
    specialLootsPanel = panelMeta:new2(specialLootsLogic, EDTables.guildConfig.specialLootUIRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(specialLootsPanel:getRootLayer(), 500)
    end
  end
  addReward(data)
  newBreakHistory = breakHistory
end

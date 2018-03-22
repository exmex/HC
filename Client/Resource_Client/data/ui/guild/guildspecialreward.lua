local mainPanel, detailpanel
local logic = {}
local itemIds = {}
function logic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and mainPanel then
    currentScene:removeChild(mainPanel:getRootLayer(), true)
    mainPanel = nil
  end
end
function logic.hideDetail(index)
  if detailpanel and mainPanel then
    detailpanel:removeFromParentAndCleanup(true)
    detailpanel = nil
  end
end
function logic.showDetail(index)
  logic.hideDetail()
  local itemId = itemIds[index]
  if itemId then
    detailpanel = ed.readequip.getDetailCard(itemId)
    if detailpanel then
      local button = string.format("detail%d", index)
      local x, y = mainPanel.mainLayer[button]:getPosition()
      detailpanel:setPosition(ccp(x, y + 30))
      mainPanel.mainLayer.bg:addChild(detailpanel, 20)
    end
  end
end
local function initPanel(raidId)
  local raidTable = ed.getDataTable("Raid")
  local raid = raidTable[raidId]
  if raid == nil then
    return
  end
  local name = raid["Display Name"]
  mainPanel.mainLayer.name:setString(name)
  mainPanel.mainLayer.selectInfo:setString("")
  itemIds = {}
  local drop = ""
  for j = 1, 10 do
    local itemId = raid[string.format("Special Loot %d ID", j)]
    if itemId and itemId > 0 then
      drop = drop .. string.format("<item|%d|0.6>", itemId)
      table.insert(itemIds, itemId)
    end
  end
  mainPanel.mainLayer.selectInfo:setString(drop)
  local w, h = mainPanel.mainLayer.selectInfo:getSize()
  mainPanel.mainLayer.bg:setContentSize(CCSizeMake(w + 38, 150))
  mainPanel.mainLayer.close:setPosition(ccp(w + 25, 130))
  detailpanel = nil
end
function ed.showGuildInstanceReward(raidId)
  if raidId == nil then
    return
  end
  if mainPanel == nil then
    mainPanel = panelMeta:new2(logic, EDTables.guildInstanceReward.specialRewardUIRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(mainPanel:getRootLayer(), 500)
    end
  end
  initPanel(raidId)
end

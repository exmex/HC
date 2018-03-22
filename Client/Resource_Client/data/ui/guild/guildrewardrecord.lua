local recordPanel
local logic = {}
function logic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and recordPanel then
    currentScene:removeChild(recordPanel:getRootLayer(), true)
    recordPanel = nil
  end
end
local function initPanel(data)
  if nil == data then
    return
  end
  for i, v in ipairs(data) do
    local y, mon, d, h, m, s = ed.time2YMDHMS(v._send_time)
    local item = T("<item|%d|0.7>", v._item_id)
    local hint1 = T(LSTR("guildrewardrecord.1.10.001"), v._receiver_name, mon, d, h, m)
    local hint2
    if v._sender_name then
      hint2 = T(LSTR("guildrewardrecord.1.10.002"), v._sender_name)
    else
      hint2 = T(LSTR("guildrewardrecord.1.10.003"))
    end
    recordPanel.recordList:addItem({
      item,
      hint1,
      hint2
    })
  end
end
function ed.showGuildRewardRecord(data)
  if data == nil then
    ed.showToast(T(LSTR("guild.1.10.053")))
    return
  end
  if recordPanel == nil then
    recordPanel = panelMeta:new2(logic, EDTables.guildInstanceReward.rewardRecordUI)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(recordPanel:getRootLayer(), 100)
    end
  end
  initPanel(data)
end

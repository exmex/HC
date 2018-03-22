local class = {}
ed.blacklist = class
local blacklistPanel, targetUid, currentIndex
local function release()
  blacklistPanel = nil
  targetUid = nil
  currentIndex = nil
end
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
local getBlacklistData = function()
  return ed.player._chat._black_list or {}
end
class.getBlacklistData = getBlacklistData
local setBlacklistData = function(data)
  ed.player._chat._black_list = data
end
class.setBlacklistData = setBlacklistData
local function initData(data)
  if not data then
    return
  end
  for k, v in ipairs(data) do
    local param = {
      scale = 0.8,
      id = v._user_summary._avatar,
      vip = v._user_summary._vip > 0,
      level = v._user_summary._level,
      name = v._user_summary._name
    }
    print("up downuid " .. v._userid)
    blacklistPanel.ListView:addItem({param}, {
      uid = v._userid
    })
  end
end
function class.create(data)
  if nil == blacklistPanel then
    blacklistPanel = panelMeta:new2(class, EDTables.blacklistConfig.UIRes)
  end
  if getRunScene() then
    getRunScene():addChild(blacklistPanel:getRootLayer(), 200)
  end
  initData(data._chat_blacklist_user)
end
function class.cancelShielding(index)
  currentIndex = index
  local item = blacklistPanel.ListView:getListData(index)
  if item.extraData then
    targetUid = item.extraData.uid
    local msg = ed.upmsg.chat()
    msg._chat_del_bl = {}
    msg._chat_del_bl._uid = item.extraData.uid
    ed.send(msg, "chat")
  end
end
function class.exit()
  if nil == blacklistPanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(blacklistPanel:getRootLayer(), true)
  end
  release()
end
function class.getBlacklist()
  local msg = ed.upmsg.chat()
  msg._chat_fetch_bl = {}
  ed.send(msg, "chat")
end
local findIdInBlacklist = function(list, id)
  list = list or {}
  for k, v in ipairs(list) do
    if v == id then
      return k
    end
  end
  return false
end
function class.addBlacklist(uid)
  local data = getBlacklistData()
  if not findIdInBlacklist(data, uid) then
    table.insert(data, uid)
  end
  setBlacklistData(data)
  ed.showToast(T(LSTR("blacklist.1.10.1.001")))
end
function class.deleteBlacklist()
  if not targetUid then
    return
  end
  local data = getBlacklistData()
  local k = findIdInBlacklist(data, targetUid)
  if k then
    table.remove(data, k)
  end
  if currentIndex then
    blacklistPanel.ListView:removeItem(currentIndex)
  end
  setBlacklistData(data)
  ed.showToast(T(LSTR("blacklist.1.10.1.002")))
end
function class.isInBlacklist(id)
  local blist, uid = {}, id
  for k, v in ipairs(getBlacklistData()) do
    blist[v] = k
  end
  if blist[uid] then
    return true
  end
  return false
end
function class.setTargetUid(uid)
  targetUid = uid
end
local function OnChatRsp(data)
  if data._chat_add_bl then
    if data._chat_add_bl._ret == "success" and targetUid then
      class.addBlacklist(targetUid)
    end
  elseif data._chat_del_bl then
    if data._chat_del_bl._ret == "success" then
      class.deleteBlacklist()
    end
  elseif data._chat_blacklist then
    class.create(data._chat_blacklist)
  end
end
ListenEvent("ChatRsp", OnChatRsp)

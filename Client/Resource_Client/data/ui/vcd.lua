local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.vcdLayer = class
local ed = ed
local vcdPanel, currentAccessory, currentMode
local base = ed.ui.basescene
local function initPlayer(player, name, level, result, heros, icon, vip)
  local sIcon = player .. "Icon"
  local sLevel = player .. "Level"
  local sName = player .. "Name"
  local sResult = player .. "Result"
  local head = ed.getHeroIconByID({
    id = icon,
    vip = vip > 0
  })
  if head then
    vcdPanel.pvpLayer[sIcon]:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    vcdPanel.pvpLayer[sIcon]:addChild(head)
  end
  ed.setString(vcdPanel.pvpLayer[sLevel], tostring(level))
  ed.setString(vcdPanel.pvpLayer[sName], name)
  local effectName = result == "victory" and "UI/alpha/HVGA/pvp/pvp_win.png" or "UI/alpha/HVGA/pvp/pvp_lose.png"
  local frame = ed.getSpriteFrame(effectName)
  if frame then
    vcdPanel.pvpLayer[sResult]:initWithSpriteFrame(frame)
  end
  for i = 1, 5 do
    local hero = string.format("%sHero%d", player, i)
    vcdPanel.pvpLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  if heros then
    for i, v in ipairs(heros) do
      local hero = string.format("%sHero%d", player, i)
      local heroIcon = ed.readhero.createIcon({
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars
      })
      heroIcon.icon:setScale(0.6)
      vcdPanel.pvpLayer[hero]:addChild(heroIcon.icon)
    end
  end
end
local function showPvp(data)
  if nil == data then
    return
  end
  local leftResult = data._result
  local rightResult
  if leftResult == "victory" then
    rightResult = "defeat"
  elseif leftResult == "defeat" then
    rightResult = "victory"
  end
  local leftAvatar = data._avatar ~= 0 and data._avatar or 1
  local rightAvatar = data._oppo_avatar ~= 0 and data._oppo_avatar or 1
  initPlayer("left", data._username, data._level, leftResult, data._self_heroes, leftAvatar, data._vip)
  initPlayer("right", data._oppo_name, data._oppo_level, rightResult, data._oppo_heroes, rightAvatar, data._oppo_vip)
end
class.showPvp = showPvp
local function showData()
  if ed.engine.unit_list then
    ed.ui.battleStatist.create(ed.engine.unit_list, "pvp")
  end
end
class.showData = showData
local getRunScene = function()
  return CCDirector:sharedDirector():getRunningScene()
end
local function create()
  local currentScene = getRunScene()
  if currentScene then
    if nil == currentAccessory then
      return currentScene
    end
    if not vcdPanel then
      vcdPanel = panelMeta:new2(class, EDTables.vcdConfig.UIRes)
      currentScene:addChild(vcdPanel:getRootLayer(), 400)
      showPvp(currentAccessory)
    end
  end
end
class.create = create
local function setData(data, mode)
  if nil == data then
    return
  end
  currentAccessory = data
  currentMode = mode
end
class.setData = setData
local function release()
  vcdPanel = nil
  currentAccessory = nil
end
local function showReplay()
  ed.popScene()
  ed.showReplay(currentAccessory, currentMode)
  vcdPanel = nil
end
class.showReplay = showReplay
local function closePvp()
  ed.popScene()
  release()
end
class.closePvp = closePvp

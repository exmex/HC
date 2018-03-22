local battleStatist = {}
local battlepanel
ed.ui.battleStatist = battleStatist
local uiName
local ipairs = ipairs
local engineList
local layerScriptFuncid = {}
local maxdmg = 0
local function setImx()
  for i, unit in ipairs(engineList) do
    maxdmg = math.max(maxdmg, unit.dmg_statistics)
  end
end
local getLableName = function(name, num)
  return name .. tostring(num)
end
local getBarTime = function(tdmg, cmaxdmg, maxtime)
  if 0 == cmaxdmg then
    return 0
  end
  return tdmg / cmaxdmg * maxtime
end
local setCommaForNumber = function(number)
  local str = tostring(number)
  local str2 = ""
  local sub = string.sub
  local i = 0
  for n = #str, 1, -1 do
    i = i + 1
    str2 = sub(str, n, n) .. str2
    if i == 3 then
      i = 0
      str2 = "," .. str2
    end
  end
  if sub(str2, 1, 1) == "," then
    str2 = sub(str2, 2, #str2)
  end
  return str2
end
ed.setCommForNumber = setCommaForNumber
local function numberJump(layerid, layer, name, cnum, dmg_statistics, speedtime)
  local count = 0
  local scheduler = layer.mainLayer:getScheduler()
  local speed = 0
  if 0 ~= speedtime then
    speed = dmg_statistics / speedtime
  end
  local id
  local LabelName = getLableName(name, cnum)
  local function handler(dt)
    count = count + dt
    local ce = math.min(math.floor(speed * count), dmg_statistics)
    if not id then
      id = layerScriptFuncid[layerid]
    end
    if not layer then
      scheduler:unscheduleScriptEntry(id)
      return
    end
    if nil == battlepanel then
      scheduler:unscheduleScriptEntry(id)
      return
    end
    if tolua.isnull(layer.mainLayer) then
      scheduler:unscheduleScriptEntry(id)
      return
    end
    if ce >= dmg_statistics then
      ce = dmg_statistics
      scheduler:unscheduleScriptEntry(id)
    end
    ed.setString(battlepanel[LabelName], setCommaForNumber(math.floor(ce)))
  end
  return handler
end
local function palyNumberJump(i, layer, name, cnum, dmg_statistics, speed)
  layerScriptFuncid[i] = layer.mainLayer:getScheduler():scheduleScriptFunc(numberJump(i, layer, name, cnum, dmg_statistics, speed), 0, false)
end
local function getIcon(UserInfo, panelSprite)
  if nil == engineList then
    return
  end
  local mercenary = UserInfo:getMercenaryData(UserInfo)
  local spriteIcon = ed.readhero.getIcon({
    id = UserInfo.tid,
    level = UserInfo.level,
    stars = UserInfo.stars,
    length = 45,
    rank = UserInfo.rank,
    mercenary = mercenary
  })
  local sprite = battlepanel[panelSprite]
  sprite:addChild(spriteIcon)
end
local function upBar(ui, bar, num, len, barTime)
  local cui = getLableName(ui, num)
  local cbar = getLableName(bar, num)
  battlepanel[cui]:setVisible(true)
  battlepanel[cbar]:setVisible(true)
  battlepanel[cbar]:setScaleX(0)
  battlepanel[cbar]:setScaleY(0.5)
  local array = CCArray:create()
  local action = CCScaleTo:create(barTime, 0.5 * len, 0.5)
  array:addObject(action)
  local sequence = CCSequence:create(array)
  battlepanel[cbar]:runAction(sequence)
end
local function showPlayBar()
  local mCNum = 1
  local eCNum = 1
  for i, unit in ipairs(engineList) do
    do
      local len = unit.dmg_statistics
      local batTime = getBarTime(len, maxdmg, 0.8)
      xpcall(function()
        if ed.emCampPlayer == unit.camp and mCNum <= 5 then
          local mSprite = getLableName("mSprite", mCNum)
          getIcon(unit, mSprite)
          upBar("ui", "mBar", mCNum, len / maxdmg, batTime)
          mCNum = mCNum + 1
        elseif ed.emCampEnemy == unit.camp and eCNum <= 5 then
          local eSprite = getLableName("eSprite", eCNum)
          getIcon(unit, eSprite)
          upBar("eui", "eBar", eCNum, len / maxdmg, batTime)
          eCNum = eCNum + 1
        end
      end, EDDebug)
    end
  end
end
local function setCount()
  local mCNum = 1
  local eCNum = 1
  for i, unit in ipairs(engineList) do
    if ed.emCampPlayer == unit.camp and mCNum <= 5 then
      local len = unit.dmg_statistics
      local speedTime = getBarTime(len, maxdmg, 0.8)
      palyNumberJump(i, battlepanel.hurtStatistLayer, "mCount", mCNum, unit.dmg_statistics, speedTime)
      mCNum = mCNum + 1
    elseif ed.emCampEnemy == unit.camp and eCNum <= 5 then
      local len = unit.dmg_statistics
      local speedTime = getBarTime(len, maxdmg, 0.8)
      palyNumberJump(i, battlepanel.hurtStatistLayer, "eCount", eCNum, unit.dmg_statistics, speedTime)
      eCNum = eCNum + 1
    end
  end
end
local function changeTitle()
  ed.setString(battlepanel.self, T(LSTR("battleStatistics.1.10.1.001")))
  ed.setString(battlepanel.enemy, T(LSTR("EXCAVATEBATTLEREPORT.DEFENDER")))
end
function battleStatist.create(enginelist, type)
  engineList = enginelist
  setImx()
  if nil == engineList then
    return
  end
  if nil == battlepanel then
    battlepanel = panelMeta:new2(battleStatist, EDTables.battleStatisticsConfig.UIRes)
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:addChild(battlepanel:getRootLayer(), 500)
  end
  showPlayBar()
  setCount()
  if type and type == "pvp" then
    changeTitle()
  end
end
local function release()
  uiName = nil
  engineList = nil
  layerScriptFuncid = {}
  maxdmg = 0
end
function battleStatist.exit()
  if nil == battlepanel then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(battlepanel:getRootLayer(), true)
    battlepanel = nil
  end
  release()
end

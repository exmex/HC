local fontEdit = {}
fontEdit.__index = fontEdit
local base = ed.ui.basescene
setmetatable(fontEdit, base.mt)
ed.ui.fontedit = fontEdit
local fontEditScope = {}
local panel
local fontnName = "default"
local color = ccc3(255, 255, 255)
local size = 20
local shadowColor, shadowOffset, strokeColor, strokeSize
local change = false
local function conform()
  local info = {}
  info.color = color
  info.size = size
  if shadowColor and shadowOffset then
    info.shadowColor = shadowColor
    info.shadowOffset = shadowOffset
  end
  if strokeColor and strokeSize then
    info.strokeColor = strokeColor
    info.strokeSize = strokeSize
  end
  EDTables.fontconfigs[fontnName] = nil
  EDTables.fontconfigs[fontnName] = info
  print(info.size)
  change = true
end
function fontEdit.addNewFont()
  if fontnName == "" then
    print("error:font name can not be  empty!")
    return
  end
  if EDTables.fontconfigs[fontnName] then
    local info = {
      text = T(LSTR("FONTEDIT.CONFIRM_TO_COVER_ORIGINAL_FONT")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = conform
    }
    ed.showConfirmDialog(info)
    return
  end
  conform()
end
function fontEdit.onHitFont(data)
  if data == nil then
    return
  end
  local fontName = data.data[1]
  local fontInfo = EDTables.fontconfigs[fontName]
  if not fontInfo then
    return
  end
  panel.name:setString(fontName)
  panel.size:setString(fontInfo.size)
  local color = fontInfo.color
  panel.colorR:setString(color.r)
  panel.colorG:setString(color.g)
  panel.colorB:setString(color.b)
  local shadowColor = fontInfo.shadowColor
  local shadowOffset = fontInfo.shadowOffset
  if shadowColor and shadowOffset then
    panel.shadowcolorR:setString(shadowColor.r)
    panel.shadowcolorG:setString(shadowColor.g)
    panel.shadowcolorB:setString(shadowColor.b)
    panel.shadowoffsetX:setString(shadowOffset.x)
    panel.shadowoffsetY:setString(shadowOffset.y)
  else
    panel.shadowcolorR:setString("")
    panel.shadowcolorG:setString("")
    panel.shadowcolorB:setString("")
    panel.shadowoffsetX:setString("")
    panel.shadowoffsetY:setString("")
  end
  local strokeColor = fontInfo.strokeColor
  local strokeSize = fontInfo.strokeSize
  if strokeColor and strokeSize then
    panel.strokecolorR:setString(strokeColor.r)
    panel.strokecolorG:setString(strokeColor.g)
    panel.strokecolorB:setString(strokeColor.b)
    panel.strokesize:setString(strokeSize)
  else
    panel.strokecolorR:setString("")
    panel.strokecolorG:setString("")
    panel.strokecolorB:setString("")
    panel.strokesize:setString("")
  end
end
function fontEdit.exit()
  if change == false then
    ed.popScene()
    return
  end
  local file = io.open("lua/gametable/fontconfigs.lua", "w+")
  local myText = "EDDefineTable(\"fontconfigs\")"
  myText = myText .. "\n"
  for k, v in pairs(EDTables.fontconfigs) do
    myText = myText .. string.format("%s = { size = %d, color = %s,", k, v.size, tostring(v.color))
    if v.shadowColor and v.shadowOffset then
      myText = myText .. string.format("shadowColor = %s, shadowOffset = %s,", tostring(v.shadowColor), tostring(v.shadowOffset))
    end
    if v.strokeColor and v.strokeSize then
      myText = myText .. string.format("strokeColor = %s, strokeSize =%d,", tostring(v.strokeColor), v.strokeSize)
    end
    myText = myText .. "}\n"
  end
  file:write(myText)
  file:close()
  ed.popScene()
end
local function getEditValue(name)
  local edit = panel[name]
  if nil == edit then
    return nil
  end
  local value = edit:getString()
  if value ~= "" and tonumber(value) == nil then
    print(name .. "input wrong format")
    return nil
  end
  return tonumber(value)
end
local function update()
  fontnName = panel.name:getString()
  if fontnName == "" then
    print("font name is empty!!!")
  end
  local colorR = getEditValue("colorR")
  if colorR == nil then
    return
  end
  local colorG = getEditValue("colorG")
  if colorG == nil then
    return
  end
  local colorB = getEditValue("colorB")
  if colorB == nil then
    return
  end
  size = getEditValue("size")
  if size == nil then
    return
  end
  color = ccc3(colorR, colorG, colorB)
  panel.font:removeAllChildrenWithCleanup(true)
  local zimu = ed.createttf("1234567890", size)
  local zimu2 = ed.createttf(T(LSTR("FONTEDIT.TURRET_LEGEND_PRC")), size)
  zimu:setColor(color)
  zimu2:setColor(color)
  local shadowcolorR = getEditValue("shadowcolorR")
  local shadowcolorG = getEditValue("shadowcolorG")
  local shadowcolorB = getEditValue("shadowcolorB")
  local shadowoffsetX = getEditValue("shadowoffsetX")
  local shadowoffsetY = getEditValue("shadowoffsetY")
  if shadowcolorR and shadowcolorG and shadowcolorB and shadowoffsetX and shadowoffsetY then
    shadowColor = ccc3(shadowcolorR, shadowcolorG, shadowcolorB)
    shadowOffset = ccp(shadowoffsetX, shadowoffsetY)
    ed.setLabelShadow(zimu, shadowColor, shadowOffset)
    ed.setLabelShadow(zimu2, shadowColor, shadowOffset)
  end
  local strokecolorR = getEditValue("strokecolorR")
  local strokecolorG = getEditValue("strokecolorG")
  local strokecolorB = getEditValue("strokecolorB")
  local size2 = getEditValue("strokesize")
  if strokecolorR and strokecolorG and strokecolorB and size2 then
    strokeColor = ccc3(strokecolorR, strokecolorG, strokecolorB)
    strokeSize = size2
    ed.setLabelStroke(zimu, strokeColor, strokeSize)
    ed.setLabelStroke(zimu2, strokeColor, strokeSize)
  end
  zimu2:setPosition(ccp(0, 50))
  panel.font:addChild(zimu)
  panel.font:addChild(zimu2)
end
local function initFontList()
  for k, v in pairs(EDTables.fontconfigs) do
    panel.listview:addItem({k})
  end
end
local function onEnterFramework()
  initFontList()
  ListenTimer(Timer:Always(0.5), update, fontEditScope)
end
local function onExitFramework()
  CloseScope(fontEditScope)
  panel = nil
end
function fontEdit.create()
  local newscene = base.create("fontedit")
  setmetatable(newscene, fontEdit)
  panel = panelMeta:new(newscene, EDTables.uiconfig.fontedit)
  newscene:registerOnEnterHandler("onEnterFramework", onEnterFramework)
  newscene:registerOnExitHandler("onExitFramework", onExitFramework)
  return newscene
end
function ed.showFontEdit()
  ed.pushScene(ed.ui.fontedit.create())
end

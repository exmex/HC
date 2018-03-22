local mainLayer
function tui()
  mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  local readnode = ed.readnode.create(mainLayer, {})
  local ui_info = ed.uieditor.ppp
  readnode:addNode(ui_info)
  ed.getCurrentScene():ccScene():addChild(mainLayer)
end
function clear()
  if not tolua.isnull(mainLayer) then
    mainLayer:removeFromParentAndCleanup(true)
  end
end
function ed.testunlock(level)
  for i = 1, level - ed.player._level do
    ed.player:levelup("sweep")
  end
end
function ed.printTable(t, index)
  index = index or 1
  local pre = ""
  for i = 1, index - 1 do
    pre = pre .. "\t"
  end
  print(pre .. "{")
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(pre .. k .. " = ")
      ed.printTable(v, index + 1)
    else
      local str = pre .. "\t"
      str = str .. k .. " = " .. tostring(v)
      print(str)
    end
  end
  print(pre .. "}")
end

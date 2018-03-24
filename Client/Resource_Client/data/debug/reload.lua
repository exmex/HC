module("eddebug", package.seeall)
local pushSceneByName = function(name, index)
  if name == nil or name == "" then
    return
  end
  if ed.ui[name] ~= nil then
    if index == 1 then
      LegendLog("replaceScene: " .. name)
      ed.replaceScene(ed.ui[name].create())
    else
      LegendLog("pushScene: " .. name)
      ed.pushScene(ed.ui[name].create())
    end
  end
end
function reload(bClearTexture)
  local bClearTexture = bClearTexture and bClearTexture or false
  if bClearTexture then
    CCTextureCache:sharedTextureCache():removeAllTextures()
    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
  end
  local scene_stack = ed.scene_stack
  local scenes = {}
  for i, v in ipairs(ed.scene_stack) do
    if v.identity ~= nil then
      table.insert(scenes, v.identity)
    end
  end
  for i = 1, #scene_stack - 1 do
    ed.popScene()
  end
  local userid = ed.getUserid()
  for i, v in ipairs(ed.needLoadFiles) do
    if not ed.isElementInTable(v, {"player"}) then
      LegendClearLoaded(v)
    end
  end
  loadAllFiles()
  ed.setUserid(userid)
  scene_stack = {}
  for i, v in ipairs(scenes) do
    pushSceneByName(v, i)
  end
  ed.loadEnd()
end

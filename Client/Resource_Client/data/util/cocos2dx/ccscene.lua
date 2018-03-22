local functions = require("util.functions")
CCSceneExtend = functions.class("CCSceneExtend")
function CCSceneExtend.create()
  local scene = CCScene:create()
  functions.extend(scene, CCSceneExtend)
  local function handler(event)
    if event == "enter" then
      if scene.onEnter then
        scene:onEnter()
      end
    elseif event == "enterTransitionFinish" then
      if scene.onEnterTransitionFinish then
        scene:onEnterTransitionFinish()
      end
    elseif event == "exitTransitionStart" then
      if scene.onExitTransitionStart then
        scene:onExitTransitionStart()
      end
    elseif event == "cleanup" then
      if scene.onCleanup then
        scene:onCleanup()
      end
    elseif event == "exit" then
      if scene.onExit then
        scene:onExit()
      end
    elseif event == "cleanup" and scene.onCleanup then
      scene:onCleanup()
    end
  end
  scene:registerScriptHandler(handler)
  return scene
end
return CCSceneExtend

module("errorNet", package.seeall)
local UIRes = {
  {
    layerName = "errornetLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 0),
    touchInfo = {
      iPriority = -700,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "errorBg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 260)
        },
        config = {
          scaleSize = CCSizeMake(310, 160)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("ERRORNET.NETWORK_ANOMALY")),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 140)
        },
        listData = true
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("ERRORNET.PLEASE_RETRY_ONCE_THE_NETWORK_IS_CONFIRMED_AS_FIXED")),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 115)
        },
        listData = true
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 85)
        },
        config = {scale = 0.8}
      },
      {
        t = "Scale9Button",
        base = {
          name = "tryAgain",
          parent = "errorBg",
          buttonName = {
            text = T(LSTR("ERRORNET.RETRY")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "reLoad"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(155, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  }
}
local errorLogic = {}
local errorPanel, currentFunc, isCreate
function showError(currentFun)
  if nil == currentFun then
    return
  end
  currentFunc = currentFun
  if errorPanel == nil then
    errorPanel = panelMeta:new2(errorLogic, UIRes)
  end
  if not isCreate then
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(errorPanel:getRootLayer(), 500)
    end
    isCreate = true
  end
end
function errorLogic.reLoad()
  if nil == currentFunc then
    return
  end
  xpcall(function()
    currentFunc()
  end, EDDebug)
  if errorPanel == nil then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(errorPanel:getRootLayer(), true)
    errorPanel = nil
  end
  isCreate = nil
end

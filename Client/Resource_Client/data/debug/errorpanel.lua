module("debugError", package.seeall)
local UIRes = {
  {
    layerName = "errorLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {iPriority = -100, bSwallowsTouches = true},
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
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(600, 400)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "errorBg",
          handleName = "close"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(600, 400)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Feral Bug",
          fontinfo = "title_yellow"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 440)
        },
        listData = true
      },
      {
        t = "ListView",
        base = {
          name = "listviewWorld",
          cliprect = CCRectMake(10, 60, 650, 390),
          priority = -200,
          heightInner = 10
        },
        itemConfig = {
          {
            t = "Label",
            base = {
              name = "content",
              text = "",
              fontinfo = "chat_content"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -27)
            },
            config = {
              dimension = CCSizeMake(600, 0),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          }
        }
      }
    }
  }
}
local errorLogic = {}
local errorPanel
function showError(msg)
  if errorPanel == nil then
    errorPanel = panelMeta:new2(errorLogic, UIRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(errorPanel:getRootLayer(), 500)
    end
  end
  errorPanel.listviewWorld:addItem({msg})
end
function errorLogic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and errorPanel then
    currentScene:removeChild(errorPanel:getRootLayer(), true)
    errorPanel = nil
  end
end

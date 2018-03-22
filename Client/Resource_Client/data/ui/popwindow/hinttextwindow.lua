local uiRes = {
  {
    layerName = "mainLayer",
    iPriority = 0,
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(450, 340)
        }
      },
      {
        t = "RichText",
        base = {
          name = "content",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(10, 55)
        }
      }
    }
  }
}
local hintPanel
local xOffset = 30
local yBgOffset = 30
function ed.closeHintText()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and hintPanel then
    currentScene:removeChild(hintPanel:getRootLayer(), true)
    hintPanel = nil
  end
end
function ed.showHintText(text, pos)
  if hintPanel == nil then
    hintPanel = panelMeta:new2({}, uiRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(hintPanel:getRootLayer(), 500)
    end
  end
  hintPanel.bg:setPosition(pos)
  hintPanel.content:setString(text)
  local width, heigth = hintPanel.content:getSize()
  hintPanel.bg:setContentSize(CCSizeMake(width + xOffset, heigth + yBgOffset))
  hintPanel.content:setPosition(ccp(10, heigth + yBgOffset / 2))
end

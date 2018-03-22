local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.appremark = class
require("ui/uieditor/Appremark")
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:destroy()
      libOS:getInstance():openURL(praise_url)
    end
  })
 self:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    key = "cancel_button",
    clickHandler = function()
      self:destroy()
    end
  })
 self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function createIcon(x,y,num) 
  local iconBroad = ed.createScale9Sprite("UI/alpha/HVGA/fragment_frame_blue.png")
  --iconBroad:setAnchorPoint(ccp(0.5, 0.5))
  iconBroad:setPosition(ccp(x,y))
  iconBroad:setScale(0.47)
  local icon, fragmentIcon = ed.createClippingNode(reward_100.res[1], "UI/alpha/HVGA/fragment_stencil.png")
  icon:setPosition(ccp(37,39)); 
  icon:setScale(0.78)
  iconBroad:addChild(icon)
  local numSprite = CCSprite:create()
  plistNum = string.format("x%s", num)
  local width = ed.createNumbers(numSprite, plistNum, -2, nil, "white")
  numSprite:setContentSize(CCSizeMake(width, 20))
  numSprite:setCascadeOpacityEnabled(true)
  numSprite:setAnchorPoint(ccp(0, 0))
  numSprite:setPosition(ccp(69, 10.2))
  numSprite:setScale(1.2)
  iconBroad:addChild(numSprite)
  return iconBroad
end

local function createPic(x,y,resPath,num)
  local pic = CCSprite:create(resPath)
  plistNum = string.format("x%s", num)
  local numSprite2 = CCSprite:create()
  local width = ed.createNumbers(numSprite2, plistNum, -2, nil, "white")
  numSprite2:setContentSize(CCSizeMake(width, 20))
  numSprite2:setCascadeOpacityEnabled(true)
  numSprite2:setAnchorPoint(ccp(0, 0))
  numSprite2:setPosition(ccp(69, 10.2))
  numSprite2:setScale(1.43)
  pic:addChild(numSprite2)
  pic:setScale(0.4)
  pic:setPosition(x,y)
  return pic
end
  
class.createIcon = createIcon
local function create()
  local self = base.create("appremark")
  setmetatable(self, class.mt)
  local container
  container, self.ui = ed.editorui(ed.uieditor.appremarkinfo)
  self:setContainer(container)
  self.ui.titlecontent:setHorizontalAlignment(0)
  for i=1,4 do
  container:addChild(createIcon(440,275.6-32*i,3*i))
  end
  container:addChild(createPic(500,275.6-32,reward_50.res[2],reward_50.num[2]))
  container:addChild(createPic(500,275.6-64,reward_100.res[2],reward_100.num[2]))
  container:addChild(createPic(500,275.6-96,reward_300.res[2],reward_300.num[2]))
  container:addChild(createPic(500,275.6-128,reward_500.res[2],reward_500.num[2]))
  container:addChild(createPic(560,275.6-64,reward_100.res[3],reward_100.num[3]))
  container:addChild(createPic(560,275.6-96,reward_300.res[3],reward_300.num[3]))
  container:addChild(createPic(560,275.6-128,reward_500.res[3],reward_500.num[3]))
  self:registerTouchHandler()
  return self
end
class.create = create


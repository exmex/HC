local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
ed.ui.loading = class
local res = ed.ui.loadingres
local function createLoading(self, key)
  self.loading = LoadResources:create(#res[key])
  for i = 1, #res[key] do
    self.loading:insert(res[key][i])
  end
  LoadResources:load()
end
class.createLoading = createLoading
local init = function(self)
  self.count = 0
end
class.init = init
local function create(key)
  local self = base.create("loading")
  setmetatable(self, class.mt)
  local scene = self.scene
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  local bg = ed.createSprite("UI/alpha/HVGA/bg.jpg")
  bg:setPosition(ccp(400, 240))
  mainLayer:addChild(bg)
  local barBg = ed.createSprite("UI/alpha/HVGA/herodetail-xp-bg.png")
  barBg:setScaleX(1.5)
  barBg:setPosition(ccp(400, 100))
  self.mainLayer:addChild(barBg)
  self.barBg = barBg
  barBg:setScaleY(0.5)
  local bar = ed.createSprite("UI/alpha/HVGA/herodetail-xp.png", CCRectMake(19, 10, 200, 8))
  bar:setAnchorPoint(ccp(0, 0))
  bar:setPosition(ccp(0, 0))
  barBg:addChild(bar)
  self.bar = bar
  bar:setScaleX(0)
  self:createLoading(key)
  self:init()
  self:registerUpdateHandler("loading", self:updateLoading())
  return self
end
class.create = create
local function updateLoading(self)
  local function handler(dt)
    self.count = self.count + dt
    local progress = LoadResources:getProgress()
 --   LegendLog("**progress " .. tostring(progress));
    self.bar:setScaleX(math.min(progress or 0, 1))
    if LoadResources:isEnd() then
      ed.popScene()
    end
  end
  return handler
end
class.updateLoading = updateLoading

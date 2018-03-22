local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
ed.ui.logo = class
local auto_update_switch = not EDFLAGWIN32 and not EDFLAGWP8
local loadShaders = function(self)
  local firstLoadTitle = "Watched the Mouse"
  local firstLoadProgress = 0
  local list = {
    "GrayScalingShader",
    "FrozenShader",
    "StoneShader",
    "PoisonShader",
    "BanishShader",
    "InvisibleShader",
    "Blur",
    "IceShader",
    "MirrorShader"
  }
  for i = 1, #list do
    print("loading shader "..list[i] )
    LegendLoadShader(list[i])
    firstLoadProgress = i / #list
  end
end
class.loadShaders = loadShaders
local function loadTable(self)
  local firstLoadTitle = T(LSTR("LOGO.READING_INFORMATION"))
  local firstLoadProgress = 0
  local list = {
    "ActStageGroup",
    "affixcount",
    "AnimDuration",
    "AnimAtkFrame",
    "Battle",
    "Buff",
    "Chapter",
    "enhancement",
    "equip",
    "equipcraft",
    "fragment",
    "hero_equip",
    "HeroStars",
    "GradientPrice",
    "Levels",
    "MerchantTalk",
    "PlayerLevel",
    "Privilege",
    "PVPEmeny",
    "PVPRankReward",
    "Recharge",
    "Shop",
    "Skill",
    "SkillGroup",
    "SkillLevels",
    "Stage",
    "Task",
    "TavernType",
    "TextureConfig",
    "Todolist",
    "TodoTriggers",
    "Triggers",
    "Unit",
    "UnitRank",
    "VIP",
    "GuildAvatar",
    "GuildWorship",
    "GuildHirePrice",
    "activity/ActivityConfig",
	"activity/ContinueChargeConfig"
  }
  for i = 1, #list do
    ed.getDataTable(list[i])
    firstLoadProgress = i / #list
  end
end
class.loadTable = loadTable
local doLoginReply = function(self)
  local function handler()
    self:createLoading()
  end
  return handler
end
class.doLoginReply = doLoginReply
local function doLogin(self)
  ed.netreply.loginReply = self:doLoginReply()
  local languageId = CCApplication:sharedApplication():getCurrentLanguage()
  local login = ed.upmsg.login()
  ed.upmsg._user_id = ed.getUserid()
  login._active_code = 0
  login._old_deviceid = ed.getDeviceId() --game_server_id
  login._version = LegendGetLoginPwd();
  login._languageid = languageId--add by xinghui
  ed.send(login, "login")
end
class.doLogin = doLogin
local function doLoginButtonTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if not self.loginButton:isVisible() then
        return
      end
      if event == "began" then
        if ed.containsPoint(self.loginButton, x, y) then
          self.loginButtonPress:setVisible(true)
          self.isPressLogin = true
        end
      elseif event == "ended" then
        local key = self.isPressLogin
        self.isPressLogin = nil
        if key then
          self.loginButtonPress:setVisible(false)
          if ed.containsPoint(self.loginButton, x, y) then
            self:doLogin()
          end
        end
      end
    end, EDDebug)
  end
  return handler
end
class.doLoginButtonTouch = doLoginButtonTouch
local doMainLayerTouch = function(self)
  local handler = function(event, x, y)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local createUpdating = function(self)
  self:showBar()
  local delay = CCDelayTime:create(1)
  local func = CCCallFunc:create(function()
    self.loading = LoadResources:create()
    LoadResources:update()
  end)
  local s = CCSequence:createWithTwoActions(delay, func)
  self.mainLayer:runAction(s)
end
class.createUpdating = createUpdating
local autoLogin = function(self)
  local scheduler = self.mainLayer:getScheduler()
  local id
  local function handler(dt)
    xpcall(function()
      if not id then
        id = self.autoLoginID
      end
      if tolua.isnull(self.scene) then
        scheduler:unscheduleScriptEntry(id)
        return
      end
      if self.scene:isRunning() and id then
        self:doLogin()
        scheduler:unscheduleScriptEntry(id)
      end
    end, EDDebug)
  end
  return handler
end
class.autoLogin = autoLogin
local createConnecting = function(self)
  self:refreshExplanation(T(LSTR("LOGO.CONNECTING_TO_SERVER_PLEASE_WAIT……")))
  self.autoLoginID = self.mainLayer:getScheduler():scheduleScriptFunc(self:autoLogin(), 0, false)
end
class.createConnecting = createConnecting

function OnRestartGame()
  local function handler()
    --CloseEvent("RestartGame")
    ed.replaceScene(ed.ui.platformlogo.create())
  end

  --test
  return handler
end

local function createLoading(self)
  self:refreshExplanation(T(LSTR("LOGO.LOADING_RESOURCES_PLEASE_WAIT……")))
  local delay = CCDelayTime:create(0)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:loadShaders()
      self:loadTable()
      if ed.fatal_error then
        return
      end
      
      if not ed.tutorial.checkDone("_5v5Anim") then
        ed.start5v5()
        ed.tutorial.isFinishTutorial = false
        LegendLog("+++Lua+++ isFinishTutorial is false")
      else
        ed.replaceScene(ed.ui.main.create())
        ed.tutorial.isFinishTutorial = true
        LegendLog("+++Lua+++ isFinishTutorial is true")
      end
      CloseEvent("RestartGame")
      ListenEvent("RestartGame", OnRestartGame())
     
      ed.ui.recharge.getAllItemsID()
      LegendGetShopPriceInfo(ed.ui.recharge.getAllItemsID())
      
--      if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
--        if ed.tutorial.isFinishTutorial == true then
--          LegendEnterGameNotifiy()
--        end
--      else
        LegendEnterGameNotifiy((ed.tutorial.isFinishTutorial and 1) or 0)
--  end
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(delay, func)
  self.mainLayer:runAction(sequence)
end
class.createLoading = createLoading
local function createBar(self)
  local barBg = ed.createSprite("installer/loading_bar_bg.png")
  barBg:setPosition(ccp(400, 60))
  self.mainLayer:addChild(barBg)
  self.barBg = barBg
  local bar = ed.createSprite("installer/loading_bar.png")
  bar:setAnchorPoint(ccp(0, 0))
  bar:setPosition(ccp(0, 0))
  barBg:addChild(bar)
  self.bar = bar
  bar:setTextureRect(CCRectMake(0, 0, 0, 25))
  local lightLayer = CCLayer:create()
  self.lightLayer = lightLayer
  lightLayer:setClipRect(CCRectMake(15, -240, 400, 480))
  barBg:addChild(lightLayer)
  local barLight = ed.createSprite("installer/loading_bar_light.png")
  barLight:setAnchorPoint(ccp(0.9, 0))
  barLight:setPosition(ccp(0, 0))
  lightLayer:addChild(barLight)
  self.barLight = barLight
end
class.createBar = createBar
local refreshBar = function(self, percent)
  local width, height = 318, 25
  if percent > 1 then
    percent = 1
  end
  local width = width * percent
  self.bar:setTextureRect(CCRectMake(0, 0, width, height))
  self.barLight:setPosition(ccp(math.min(width, 298.91999999999996), 0))
end
class.refreshBar = refreshBar
local hideBar = function(self)
  self.barBg:setVisible(false)
end
class.hideBar = hideBar
local showBar = function(self)
  self.barBg:setVisible(true)
end
class.showBar = showBar
local rotateFlower = function(self)
  local gap = 0.1
  local scene = CCDirector:sharedDirector():getRunningScene()
  local count = 0
  local scheduler = self.mainLayer:getScheduler()
  local id
  local function handler(dt)
    count = count + dt
    if not id then
      id = self.loadIconRotateID
    end
    if not self or tolua.isnull(self.loadIcon) then
      scheduler:unscheduleScriptEntry(id)
      return
    end
    if count > gap then
      count = count - gap
      self.loadIcon:setRotation((self.loadIcon:getRotation() + 30) % 360)
    end
  end
  return handler
end
class.rotateFlower = rotateFlower
local function createExplanation(self)
  local descriContainer = CCSprite:create()
  self.descriContainer = descriContainer
  self.mainLayer:addChild(descriContainer)
  local descriBg = ed.createSprite("installer/loading_label_bg.png")
  descriBg:setPosition(ccp(400, 105))
  self.descriContainer:addChild(descriBg)
  self.labelBg = descriBg
  local descri = ed.createttf(T(LSTR("LOGO.UPDATING……")), 20)
  descri:setAnchorPoint(ccp(0.5, 0.5))
  descri:setPosition(ccp(400, 105))
  ed.setLabelShadow(descri, ccc3(0, 0, 0), ccp(0, 2))
  self.descri = descri
  self.descriContainer:addChild(descri)
  local loadIcon = ed.createSprite("installer/load_flower.png")
  self.descriContainer:addChild(loadIcon)
  self.loadIcon = loadIcon
  self:refreshDescri()
  self.loadIconRotateID = self.mainLayer:getScheduler():scheduleScriptFunc(self:rotateFlower(), 0, false)
end





class.createExplanation = createExplanation
local refreshDescri = function(self)
  self:refreshLoadIconPos()
  self:refreshLabelBgWidth()
end
class.refreshDescri = refreshDescri
local refreshLoadIconPos = function(self)
  local x = 400 - self.descri:getContentSize().width / 2 - 20
  self.loadIcon:setPosition(ccp(x, 105))
end
class.refreshLoadIconPos = refreshLoadIconPos
local refreshLabelBgWidth = function(self)
  local width = self.descri:getContentSize().width + self.loadIcon:getContentSize().width
  self.labelBg:setScaleX(width / self.labelBg:getContentSize().width)
end
class.refreshLabelBgWidth = refreshLabelBgWidth
local function refreshExplanation(self, text)
  ed.setString(self.descri, text)
  self:refreshDescri()
end
class.refreshExplanation = refreshExplanation
local function create(sessionId)
  local self = base.create("logo")
  setmetatable(self, class.mt)
  self.sessionId = sessionId
  local scene = self.scene
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  local bg = ed.createSprite("installer/splash.jpg")
  bg:setPosition(ccp(400, 240))
  mainLayer:addChild(bg)
  local logo = ed.createSprite("installer/logo.png")
  logo:setPosition(ccp(170, 402))
  mainLayer:addChild(logo)
  self:createBar()
  self:createExplanation()
  self:hideBar()

  --if auto_update_switch then
    --    if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
    --      if LoadResources:checkUpdate() then
    --        self:checkWifi(function()
    --          self:createUpdating()
    --        end)
    --      else
    --        self:createUpdating()
    --     end
    --   else
    --self:createUpdating()
    --   end
 -- else
    self:createConnecting()
 -- end
  self.count = 0
  self:registerUpdateHandler("logo", self:updateLogo())

  local latestVersion = T(LSTR("SERVERLOGIN.VERSION_")) ..SeverConsts:getInstance():getBaseVersion()
  local versionLable = ed.createttf(latestVersion, 15)
  versionLable:setAnchorPoint(ccp(0, 0))
  versionLable:setPosition(ccp(600, 15))
  ed.setLabelShadow(versionLable, ccc3(0, 0, 0), ccp(0, 2))
  self.mainLayer:addChild(versionLable)


  return self
end
class.create = create
local function checkWifi(self, handler)
  local isWifi = LegendCheckWifi()
  if not isWifi then
    local info = {
      text = T(LSTR("LOGO.UPDATE_PACKAGE_IS_DETECTED_IT_IS_RECOMMENDED_TO_USE_WLAN_TO_DOWNLOAD_YOU_HAVE_NOT_YET_OPENED_OR_CONNECT_WLAN_CONNECTION_CONFIRM_TO_CONTINUE_TO_DOWNLOAD")),
      rightHandler = function()
        handler()
      end
    }
    ed.showConfirmDialog(info)
  else
    handler()
  end
end
class.checkWifi = checkWifi
local function checkLatestVersion(self)
  local function handler()
    local latestVersion = CCUserDefault:sharedUserDefault():getStringForKey("latest-version")
    local currentVersion = SeverConsts:getInstance():getBaseVersion()
    LegendLog("Latest Version: " .. latestVersion)
    if latestVersion ~= currentVersion then
      ed.fatal_error = true
      local text = T(LSTR("LOGO.AUTOMATIC_UPDATE_FAILS_RESTART_THE_GAME \N_\N_ERROR_MESSAGE__\N_S"), CCUserDefault:sharedUserDefault():getStringForKey("err-msg"))
      ed.showAlertDialog({
        text = text,
        buttonText = T(LSTR("NETWORK.QUIT")),
        handler = function()
          os.exit()
        end
      })
    end
    ed.removeGameUpdateHandler("checkLatestVersion")
  end
  ed.registerGameUpdateHandler("checkLatestVersion", handler)
end
class.checkLatestVersion = checkLatestVersion
local function updateLogo(self)
  local index = 0
  local function handler(dt)
    self.count = self.count + dt
    if auto_update_switch then
      local progress = LoadResources:getProgress()
      if not self.autoUpdateEof then
        if LoadResources:getCode() == 5 and not self.dealWithFailed then
          self:refreshExplanation( T(LSTR("LOGO.FAILED_TO_CONNECT_TO_SERVER_") )  )
          local text =T(LSTR("LOGO.CONNECT_TO_THE_UPDATE_SERVER_FAILED_RETRY"))

          local info = {
            text = text,
            handler = function()
              xpcall(function()
                self:createUpdating()
                self.dealWithFailed = nil
              end, EDDebug)
            end,
            buttonText = T(LSTR("CHATCONFIG.CONFIRM"))
          }
          ed.showAlertDialog(info, self.mainLayer)
          self.dealWithFailed = true

        elseif LoadResources:getCode() == 4  then
          checkLatestVersion()
          self:refreshExplanation(T(LSTR("LOGO.THE_CURRENT_VERSION_IS_UP_TO_DATE")))
          self:refreshBar(1)
          self:createConnecting()
          self.autoUpdateEof = true
          LegendLog("--autoUpdateEof " .. tostring(progress));

        elseif LoadResources:getCode() == 3 then
          local step = LoadResources:getStep()
          local des = LoadResources:getDes()
          self:refreshExplanation(des or T(LSTR("LOGO.UPDATING……")))
          --  LegendLog("--refreshBar " .. tostring(progress));
          self:refreshBar(progress)
          if LoadResources:isEnd() and not self.autoUpdateEof then
            checkLatestVersion()
            self.autoUpdateEof = true




            self:refreshExplanation(T(LSTR("LOGO.UPDATE_SUCCESSFULLY")))
            self:refreshBar(1)

            if  LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS or LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
              if LoadResources:isBinaryUpdated() then
                      self:refreshExplanation(T(LSTR("LOGO.UPDATE_SUCCESSFULLY")))
                      self:refreshBar(1)
      
                      local info = {
                        text = T(LSTR("LOGO.UPDATE_FAILED_TOO_OLD")),
                        leftText = T(LSTR("CHATCONFIG.CANCEL")),
                        rightText = T(LSTR("CHATCONFIG.CONFIRM")),
                        rightHandler = function()
                          xpcall(function()
                            ed.openAppStore();
--                            if LoadResources:isScriptChanged() then
--                              LegendRestartApplication();
--                            else
                              if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
                                  LegendExit();
                              end
                          end, EDDebug)
                        end,
      
                        leftHandler = function()
                          xpcall(function()
--                            if LoadResources:isScriptChanged() then
--                              LegendRestartApplication();
--                            else
                              LegendExit();
--                            end
                          end, EDDebug)
                        end
      
                      }
                      ed.showConfirmDialog(info)

              else
                LegendRestartApplication();
              end
            else
              self:createConnecting()
            end

          end
        end
      end
    end
  end
  return handler
end
class.updateLogo = updateLogo

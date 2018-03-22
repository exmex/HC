local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.languagechange = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
local registerTouchHandler = function(self)
  local ui = self.ui
  local mainLayer = self.mainLayer
  mainLayer:setTouchEnabled(true)
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      self:doClickok()
    end
  })
  self:btRegisterButtonClick({
    button = ui.cancel,
    press = ui.cancel_press,
    key = "cancel_button",
    clickHandler = function()
      self:doClickCancel()
    end
  })
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      self:doClickCancel()
    end
  })
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.mainTouchPriority, true)
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  param = param or {}
  local pt = param.type
  local self = base.create("languagechange")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  self.ui = {}
  local frame = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  frame:setContentSize(CCSizeMake(630, 440))
  frame:setPosition(ccp(400, 232))
  mainLayer:addChild(frame)
  self.ui.bg = frame
   local ui_info = {
   -- {
   --   t = "Label",
   --   base = {
   --    name = "title",
    --    text = T(LSTR("BENAME.A_NAME_FOR_YOUR_TEAM_")),
    --    size = 20
    --  },
    --  layout = {
    --    anchor = ccp(0, 0.5),
    --    position = ccp(200, 370),
    --  },
    --  config = {
    --    color = ccc3(220, 176, 103),
    --  }
    --},
    {
      t = "Sprite",
      base = {
        name = "cancel",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(610, 425)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "cancel_press",
        res = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
        parent = "cancel"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(frame, self.ui)
  readNode:addNode(ui_info)
  local  height = 100

  self:createLanguageButton(height,"en-US",100,340)
  self:createLanguageButton(height,"de-DE",210,340)
  self:createLanguageButton(height,"ko-KR",320,340)
  self:createLanguageButton(height,"zh-CN",430,340)
  self:createLanguageButton(height,"ru-RU",540,340)
  self:createLanguageButton(height,"tr-TR",100,250)
  self:createLanguageButton(height,"pt-BR",210,250)
  --[[
  self:createLanguageButton(height,"fr-FR",540,340)

  self:createLanguageButton(height,"it-IT",100,250)
  self:createLanguageButton(height,"ja-JP",210,250)
  self:createLanguageButton(height,"es-ES",320,250)
  self:createLanguageButton(height,"ms-MY",430,250)
  self:createLanguageButton(height,"nb-NO",540,250)

  self:createLanguageButton(height,"nl-NL",100,160)
  self:createLanguageButton(height,"pt-BR",210,160)
  self:createLanguageButton(height,"ru-RU",320,160)
  self:createLanguageButton(height,"th-TH",430,160)
  self:createLanguageButton(height,"tr-TR",540,160)
  self:createLanguageButton(height,"vi-VN",100,70)
  self:createLanguageButton(height,"id-ID",220,70)
  ]]--
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local function createLanguageButton(self, height,planguage,x,y)
  local bg = self.ui.bg
  local container = self.container
  local readnode = ed.readnode.create(bg, self.ui)
  local languageBtn = "language_button"
  local languageBtnPress = "language_button_press"
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = languageBtn,
        res = getLanguagePng(planguage),
        capInsets = CCRectMake(15, 22, 15, 15),
        fontinfo = "normal_button",
        z = 200
      },
      layout = {
        position = ccp(x, y)
      },
      config = {
      }
    },
    {
      t = "Sprite",
      base = {
        name = languageBtnPress,
        res = getLanguagePng(planguage),
        capInsets = CCRectMake(15, 22, 15, 25),
        z = 200
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(x-40, y-25)
      },
      config = {
        scalexy = {x = 1.1, y = 1.1},
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "language_label",
        text = T(LSTR("CONFIGURE.LANGUAGE."..string.upper(planguage))),
        fontinfo = "normal_button",
        size = 20,
        z = 200
      },
      layout = {
        position = ccp(x, y+45)
      },
      config = {
        color = ccc3(220, 176, 103),
      }
    },
  }
  readnode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = self.ui.language_button,
    press = self.ui.language_button_press,
    key = planguage..languageBtn,
    clickHandler = function()
      self:doClickChangeLanguage(planguage)
    end
  })
  return height
end
class.createLanguageButton = createLanguageButton
local function show(self)
  local bg = self.ui.bg
  ed.setNodeAnchor(bg, ccp(0.5, 0.5))
  bg:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  bg:runAction(s)
end
class.show = show
local destroy = function(self)
  if not self then
    return
  end
  if not self.ui then
    return
  end
  if tolua.isnull(self.ui.bg) then
    return
  end
  local bg = self.ui.bg
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.destroyHandler and self.isClose then
        self.destroyHandler()
      end
      if self.callback then
        self.callback()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  bg:runAction(s)
end
class.destroy = destroy
local doClickCancel = function(self)
  self.isClose = true
  self:destroy()
end
class.doClickCancel = doClickCancel
local doClickChangeLanguage = function(self,planguage)
    if currentLang == planguage then
      return
    end
    local languageT = T(LSTR("CONFIGURE.LANGUAGE."..string.upper(planguage)))
    local text = T(LSTR("CONFIGURE.LANGUAGE.CHANGE"),languageT)
    local function rightHandler()
		
      --add by xinghui
	  local platformTag=GetPlatformOS()		
	  if (platformTag ~=3) and (planguage == "zh-CN") then
		planguage = "en-US"
	  end
	
      currentLang = planguage
	
      local systemSetting = ed.upmsg.system_setting()
      systemSetting._change = {}
      systemSetting._change.key = "language"
      systemSetting._change.value = currentLang
      needRestart = true
      ed.send(systemSetting, "system_setting")
	  --add by xinghui
	  ed.clearDataTable()
    end
    local info = {text = text, rightHandler = rightHandler}
    ed.showConfirmDialog(info)
end
class.doClickChangeLanguage = doClickChangeLanguage
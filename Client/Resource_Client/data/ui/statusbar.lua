local class = newclass()
ed.ui.statusbar = class
local res = ed.ui.uires
local sb_touch_priority = -16
local getInfoBarType = function(self)
  if self.identity == "shop" then
    local sn = self.addition.shopName
    if sn == "crusade" then
      return "crusadeShop"
    elseif sn == "pvp" then
      return "pvpShop"
    elseif sn == "guild" then
      return "guildShop"
    end
  end
  return "common"
end
local getuiList = function(self)
  self.sb_ui = self.sb_ui or {}
  return self.sb_ui
end
local getContainer = function(self)
  if tolua.isnull(self.frameworkLayer) then
    self.frameworkLayer = CCLayer:create()
    self.mainLayer:addChild(self.frameworkLayer, 100)
  end
  return self.frameworkLayer
end
local function getInfoContainer(self)
  local container = getContainer(self)
  if tolua.isnull(self.infoLayer) then
    local infoLayer = CCSprite:create()
    infoLayer:setCascadeOpacityEnabled(true)
    container:addChild(infoLayer, 100)
    self.infoLayer = infoLayer
  end
  return self.infoLayer
end
local function registerTitleTouchHandler(self)
  local ui = getuiList(self)
  self:btRegisterButtonClick({
    button = ui.money_bg,
    press = ui.money_add_icon_press,
    key = "add_money",
    clickHandler = function()
      self:doClickMidas()
    end,
    priority = sb_touch_priority
  })
  self:btRegisterButtonClick({
    button = ui.rmb_bg,
    press = ui.rmb_add_icon_press,
    key = "add_rmb",
    clickHandler = function()
      self:doClickrmb()
    end,
    priority = sb_touch_priority
  })
  self:btRegisterButtonClick({
    button = ui.vitality_add_icon,
    press = ui.vitality_add_icon_press,
    radius = 30,
    clickHandler = function()
      ed.showHandyDialog("buyVitality", {active = true})
    end,
    key = "add_vitality",
    priority = sb_touch_priority - 1
  })
  self:btRegisterButtonClick({
    button = ui.vit_bg,
    key = "vit_board",
    pressHandler = function()
      self:createVitalityPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard(self)
    end,
    priority = sb_touch_priority
  })
end
local function createSDKIcon(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local container = getContainer(self)
  local ui = getuiList(self)
  local sid = LegendSDKType or 0
  local list = {
    [2] = {
      iconres = "UI/alpha/HVGA/main_tbt_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(1)
      end
    },
    [3] = {
      iconres = "UI/alpha/HVGA/main_pp_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(1)
      end
    },
    [4] = {
      iconres = "UI/alpha/HVGA/main_lt_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(1)
      end
    },
    [5] = {
      iconres = "UI/alpha/HVGA/main_itools_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(1)
      end
    },
    [8] = {
      iconres = "UI/alpha/HVGA/main_lt_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(1)
      end
    },
    [103] = {
      iconres = "UI/alpha/HVGA/main_lt_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(103)
      end
    },
    [110] = {
      iconres = "UI/alpha/HVGA/main_dangle_icon.png",
      clickSDKIconHandler = function()
        LegendEnableSDKUI(110)
      end
    }
  }
  local v = list[sid]
  if v then
    local iconres = v.iconres
    local icon = ed.createSprite(iconres)
    icon:setAnchorPoint(ccp(0, 0))
    local l, r, t, b = ed.getDisplayVertex()
    icon:setPosition(ccp(l, b))
    container:addChild(icon, 10)
    ui.sdkIcon = icon
    self:btRegisterButtonClick({
      button = ui.sdkIcon,
      pressScale = 0.95,
      key = "sdk_icon",
      clickHandler = function()
        v.clickSDKIconHandler()
      end,
      priority = sb_touch_priority
    })
  end
end
local function createBack(self)
  if ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local container = getContainer(self)
  local ui = getuiList(self)
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/backbtn.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(70, 435)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/HVGA/backbtn-disabled.png",
        parent = "back"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = ui.back,
    press = ui.back_press,
    key = "back_button",
    clickHandler = function()
      self:doClickBack()
      if self.what == "StageSelectPanel" then
        ed.stopMusic()
      end
    end,
    priority = sb_touch_priority
  })
end
local function refreshHead(self)
  local head_bg = {
    "UI/alpha/HVGA/main_head_bg_silver.png",
    "UI/alpha/HVGA/main_head_bg_gold.png"
  }
  local head_frame = {
    "UI/alpha/HVGA/main_head_frame_silver.png",
    "UI/alpha/HVGA/main_head_frame_gold.png"
  }
  local name_bg = {
    "UI/alpha/HVGA/main_head_name_bg_silver.png",
    "UI/alpha/HVGA/main_head_name_bg_gold.png"
  }
  local ui = getuiList(self)
  if tolua.isnull(ui.headContainer) then
    return
  end
  local head = ui.head
  local keys = {
    "head",
    "head_frame",
    "head_bg",
    "name_bg"
  }
  for k, v in pairs(keys) do
    if not tolua.isnull(ui[v]) then
      ui[v]:removeFromParentAndCleanup(true)
      ui[v] = nil
    end
  end
  local head, headicon = ed.getHeadIcon()
  head:setPosition(res.head_icon_pos)
  ui.headContainer:addChild(head, 5)
  ui.head = head
  ui.headIcon = headicon
  local readnode = ed.readnode.create(ui.headContainer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "head_bg",
        res = ed.player:getvip() > 0 and head_bg[2] or head_bg[1],
        z = 4
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 10)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "head_frame",
        res = ed.player:getvip() > 0 and head_frame[2] or head_frame[1],
        z = 6
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 10)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "head_chistmas_frame",
        res = "UI/alpha/HVGA/activity/ChristmasActivities/Snow_8.png",
        z = 6
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(2, 32)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = 0 < self.vip and name_bg[2] or name_bg[1],
        z = 7
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(64, 7)
      },
      config = {
        visible = self.playerName ~= ""
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = self.playerName,
        size = 16,
        parent = "name_bg"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(241, 235, 206),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
  if self.sb_ui.name:getContentSize().width > 110 then
	  self.sb_ui.name:setScale(110 / self.sb_ui.name:getContentSize().width)
  end
  self:btRegisterButtonClick({
    button = ui.headIcon,
    pressScale = 0.95,
    key = "head_button",
    force = true,
    clickHandler = function()
      self.mainLayer:addChild(ed.ui.configure.create().mainLayer, 200)
    end,
    priority = sb_touch_priority
  })
end
local function refreshDailyloginTag(self)
  if self.identity ~= "main" then
    return
  end
  local ui = getuiList(self)
  local button = ui.dailylogin
  local dls = ed.player:getLoginRewardStatus()
  local hasdl
  if dls == "common" then
    hasdl = true
  elseif dls == "vip" then
    local frq = ed.player:getLoginFrequency()
    local vip = ed.ui.dailylogin.getRewardAt(frq).vip
    local pv = ed.player:getvip()
    if vip <= pv then
      hasdl = true
    end
  end
  if not tolua.isnull(ui.dlTag) then
    ui.dlTag:removeFromParentAndCleanup(true)
  end
  if hasdl then
    local tag = ed.createSprite("UI/alpha/HVGA/main_deal_tag.png")
    tag:setPosition(ccp(60, 38))
    button:addChild(tag, 5)
    ui.dlTag = tag
  end
  ed.ui.activitiesButton.refesh(button)
end
local function refreshWorldcupButton(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.worldcup) then
    return
  end
  if ed.getServerTime() < 1403884800 or ed.getServerTime() > 1405353600 then
    ui.worldcup:setVisible(false)
    ed.ui.activitiesButton.refesh(self.infoLayer, res.third_pos)
  else
    ui.worldcup:setVisible(true)
    ed.ui.activitiesButton.refesh(self.infoLayer, res.fourth_pos)
  end
end
class.refreshWorldcupButton = refreshWorldcupButton
local function createTitleButton(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local readNode = ed.readnode.create(self.infoLayer, ui)
  if tolua.isnull(ui.dailylogin) then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "recharge",
          res = "UI/alpha/HVGA/main_icon_recharge_1.png",
          z = 10
        },
        layout = {
          position = res.recharge_pos
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "recharge_press",
          res = "UI/alpha/HVGA/main_icon_recharge_2.png",
          parent = "recharge"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      }
    }
    readNode:addNode(ui_info)
  end
  self:btRegisterButtonClick({
    button = ui.recharge,
    press = ui.recharge_press,
    clickHandler = function()
      self:doClickrmb()
    end,
    priority = sb_touch_priority
  })
  if tolua.isnull(ui.dailylogin) then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "dailylogin",
          res = "UI/alpha/HVGA/main_dailyreward_1.png",
          z = 10
        },
        layout = {
          position = res.dailylogin_pos
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "dailylogin_press",
          res = "UI/alpha/HVGA/main_dailyreward_2.png",
          parent = "dailylogin"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      }
    }
    readNode:addNode(ui_info)
  end
  self:btRegisterButtonClick({
    button = ui.dailylogin,
    press = ui.dailylogin_press,
    clickHandler = function()
      self:showDailyLogin()
    end,
    priority = sb_touch_priority
  })

  if tolua.isnull(ui.appremark) then
    ui_info = {
      {
         t = "Sprite",
         base = {
           name = "appremark",
           res = "UI/alpha/HVGA/tavern_bg_chest_3.png",
           z = 10      
         },
          layout = {
            position = res.appremark_pos  
         },
          config = {
            scale = 0.53
         }       
      },
      {
          t = "Sprite",
          base = {
            name = "appremark_press",
            res = "UI/alpha/HVGA/tavern_bg_chest_1.png",
            parent = "appremark"
        },
          layout = {
            anchor = ccp(0, 0),
            position = ccp(0, 0)
        },
          config = {}
       }
    }
    if apprIsVisiable == true then
     readNode:addNode(ui_info)
    end
  end
    self:btRegisterButtonClick({
    button = ui.appremark,
    press = ui.appremark_press,
    clickHandler = function()
      self:showAppremark()
    end,
    priority = sb_touch_priority
  })
  if tolua.isnull(ui.fbattention) then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "fbattention",
          res = "UI/alpha/HVGA/fb_Gold.png",
          z = 10
        },
        layout = {
          position = res.fblogin_pos
        },
        config = {
		  scale = 1.25
		}
      },
      {
        t = "Sprite",
        base = {
          name = "fbattention_press",
          res = "UI/alpha/HVGA/fb_Gold_down.png",
          parent = "fbattention"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {}      
    }
  }
	if fb_flag==true then
		readNode:addNode(ui_info)
		buttonUI=ui
	end
  end	
  self:btRegisterButtonClick({
    button = ui.fbattention,
    press = ui.fbattention_press,
    clickHandler = function()
      self:showFbattention()
    end,
    priority = sb_touch_priority
  })
  -- add by cooper.x for activity
    if tolua.isnull(ui.activity) then
        ui_info = {
            {
                t = "Sprite",
                base =
                {
                    name = "activity",
                    res = "UI/alpha/HVGA/main_icon_op_act_1.png",
                    z = 10
                },
                layout =
                {
                    position = res.activity_pos
                },
                config = { }
            },
            {
                t = "Sprite",
                base =
                {
                    name = "activity_press",
                    res = "UI/alpha/HVGA/main_icon_op_act_2.png",
                    parent = "avtivity"
                },
                layout =
                {
                    anchor = ccp(0,0),
                    position = ccp(0,0)
                },
                config = { visible = false }
            }
        }
        readNode:addNode(ui_info)
    end
    self:btRegisterButtonClick( {
        button = ui.activity,
        press = ui.activity_press,
        clickHandler = function()
            self:showActivity()
        end,
        priority = sb_touch_priority
    } )
    --
  refreshDailyloginTag(self)
end
--add by xt
local hide_fb_botton=function(self)
	local ui = getuiList(self)
	local fb_button = ui.fbattention
	if fb_attention_success == true then 
		fb_button:setVisible(false)
    end
	fb_button:setVisible(false)
end
class.hide_fb_botton = hide_fb_botton

local function createHead(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  self.playerName = ed.player:getName()
  self.avatarid = ed.player:getAvatar()
  self.vip = ed.player:getvip()
  self.playerLevel = ed.player:getLevel()
  local headContainer = CCSprite:create()
  headContainer:setContentSize(CCSizeMake(137, 105))
  headContainer:setPosition(res.head_bg_pos)
  container:addChild(headContainer, 10)
  ui.headContainer = headContainer
  local name_bg = {
    "UI/alpha/HVGA/main_head_name_bg_silver.png",
    "UI/alpha/HVGA/main_head_name_bg_gold.png"
  }
  readNode = ed.readnode.create(headContainer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "vip_bg",
        res = "UI/alpha/HVGA/recharge_vip_bg.png"
      },
      layout = {
        position = ccp(90, 58)
      },
      config = {
        visible = self.vip > 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "vip_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png",
        z = 10
      },
      layout = {
        position = ccp(85, 58)
      },
      config = {
        visible = self.vip > 0
      }
    },
    {
      t = "Label",
      base = {
        name = "vip",
        text = self.vip,
        size = 15,
        parent = "vip_icon",
        z = 10
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(27, 9)
      },
      config = {
        visible = self.vip > 0,
        color = ccc3(241, 235, 206),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = self.vip > 0 and name_bg[2] or name_bg[1],
        z = 3
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(64, -3)
      },
      config = {
        visible = self.playerName ~= ""
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = self.playerName,
        size = 16,
        parent = "name_bg"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(241, 235, 206),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = self.playerLevel,
        size = 16,
        z = 8
      },
      layout = {
        position = ccp(82, 37)
      },
      config = {
        color = ccc3(241, 235, 206)
      }
    },
	  {
		  t = "Sprite",
		  base = {
			  name = "chatTurnUp",
			  res = "UI/alpha/HVGA/chat/chat_entrance_1.png"
		  },
		  layout = {
			  position = ccp(40, -327)
		  },
		  config = {}
	  },
	  {
		  t = "Sprite",
		  base = {
			  name = "chatTurnDown",
			  res = "UI/alpha/HVGA/chat/chat_entrance_2.png",
		  },
		  layout = {
			  position = ccp(40, -327)
		  },
		  config = {visible = false}
	  }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
	  button = ui.chatTurnUp,
	  press = ui.chatTurnDown,
	  clickHandler = function()
		  local chatPanel = ed.getChatPanel()
		  chatPanel.mainLayer:setVisible(true)
		  ed.ui.chat.chatTurn()
	  end,
	  priority = sb_touch_priority
  })
end
local function createTitle(self)
  local ui = getuiList(self)
  local infoLayer = getInfoContainer(self)
  local titleLayer = CCSprite:create()
  titleLayer:setCascadeOpacityEnabled(true)
  self.titleLayer = titleLayer
  infoLayer:addChild(titleLayer)
  local ibt = getInfoBarType(self)
  readNode = ed.readnode.create(titleLayer, ui)
  if ibt == "common" then
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "money_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(251, 450)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "money_icon",
          res = "UI/alpha/HVGA/add_goldicon_small.png",
          array = self.frameworkicon,
          parent = "money_bg"
        },
        layout = {
          position = ccp(158, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "money_add_icon",
          res = "UI/alpha/HVGA/empty.png",
          parent = "money_bg"
        },
        layout = {
          position = ccp(20, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "money_add_icon_press",
          res = "UI/alpha/HVGA/empty.png",
          parent = "money_add_icon"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "moneyBg", parent = "money_bg"},
        layout = {
          position = ccp(140, 23)
        }
      },
      {
        t = "Sprite",
        base = {name = "moneyText", parent = "moneyBg"},
        layout = {},
        config = {
          scale = res.mrv_scale
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "rmb_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(434, 450)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rmb_icon",
          res = "UI/alpha/HVGA/add_rmbicon.png",
          array = self.frameworkicon,
          parent = "rmb_bg"
        },
        layout = {
          position = ccp(156, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "rmb_add_icon",
          res = "UI/alpha/HVGA/empty.png",
          parent = "rmb_bg"
        },
        layout = {
          position = ccp(20, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "rmb_add_icon_press",
          res = "UI/alpha/HVGA/empty.png",
          parent = "rmb_add_icon"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "rmbBg", parent = "rmb_bg"},
        layout = {
          position = ccp(140, 23)
        }
      },
      {
        t = "Sprite",
        base = {name = "rmbText", parent = "rmbBg"},
        layout = {},
        config = {
          scale = res.mrv_scale
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "vit_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(601, 450)
        },
        config = {
          scaleSize = CCSizeMake(145, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "vitality_icon",
          res = "UI/alpha/HVGA/add_vitalityicon.png",
          array = self.frameworkicon,
          parent = "vit_bg"
        },
        layout = {
          position = ccp(125, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "vitality_add_icon",
          res = "UI/alpha/HVGA/main_status_plus_icon_1.png",
          parent = "vit_bg"
        },
        layout = {
          position = ccp(20, 23)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "vitality_add_icon_press",
          res = "UI/alpha/HVGA/main_status_plus_icon_2.png",
          parent = "vitality_add_icon"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "maxVitBg", parent = "vit_bg"},
        layout = {
          position = ccp(110, 23)
        }
      },
      {
        t = "Sprite",
        base = {name = "vitBg", parent = "vit_bg"},
        layout = {
          position = ccp(110, 24)
        }
      },
      {
        t = "Sprite",
        base = {name = "maxVitText", parent = "maxVitBg"},
        layout = {},
        config = {
          scale = res.mrv_scale
        }
      },
      {
        t = "Sprite",
        base = {name = "vitText", parent = "vitBg"},
        layout = {},
        config = {
          scale = res.mrv_scale
        }
      }
    }
    readNode:addNode(ui_info)
    registerTitleTouchHandler(self)
  elseif ibt == "crusadeShop" then
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "crusade_money_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(601, 440)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "crusade_money_icon",
          res = "UI/alpha/HVGA/money_dragonscale_big.png",
          array = self.frameworkicon,
          parent = "crusade_money_bg"
        },
        layout = {
          position = ccp(156, 24)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
  elseif ibt == "pvpShop" then
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "pvp_money_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(601, 440)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "pvp_money_icon",
          res = "UI/alpha/HVGA/money_arenatoken_big.png",
          array = self.frameworkicon,
          parent = "pvp_money_bg"
        },
        layout = {
          position = ccp(158, 24)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
  elseif ibt == "guildShop" then
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "guild_money_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(601, 440)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "guild_money_icon",
          res = "UI/alpha/HVGA/money_guildtoken_small.png",
          array = self.frameworkicon,
          parent = "guild_money_bg"
        },
        layout = {
          position = ccp(158, 24)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
  end
end
local function getBarConfig(self, key)
  local ui = getuiList(self)
  self.bar_config = self.bar_config or {
    money = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player._money
      end,
      bgNode = "money_bg",
      textNode = "moneyText",
      text = function(value)
        return ed.formatNumWithComma(value or ed.player._money)
      end,
      padding = -3,
      rightPoint = ccp(135, 25),
      rightNode = nil
    },
    rmb = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player._rmb
      end,
      bgNode = "rmb_bg",
      textNode = "rmbText",
      text = function()
        return ed.formatNumWithComma(ed.player._rmb)
      end,
      padding = -3,
      rightPoint = ccp(130, 25),
      rightNode = nil
    },
    crusadeMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getCrusadeMoney()
      end,
      bgNode = "crusade_money_bg",
      textNode = "crusadeMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getCrusadeMoney())
      end,
      padding = -3,
      rightPoint = ccp(140, 25),
      rightNode = nil
    },
    pvpMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPvpMoney()
      end,
      bgNode = "pvp_money_bg",
      textNode = "pvpMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getPvpMoney())
      end,
      padding = -3,
      rightPoint = ccp(140, 25),
      rightNode = nil
    },
    guildMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getGuildMoney()
      end,
      bgNode = "guild_money_bg",
      textNode = "guildMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getGuildMoney())
      end,
      padding = -3,
      rightPoint = ccp(140, 25),
      rightNode = nil
    },
    vitality = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getVitality()
      end,
      bgNode = "vit_bg",
      textNode = "vitText",
      text = function()
        return ed.formatNumWithComma(ed.player:getVitality())
      end,
      padding = -3,
      folder = function()
        if ed.player:getVitality() > ed.playerlimit.maxVitality() then
          return "main_blue"
        end
      end,
      rightPoint = nil,
      rightNode = "maxVitText"
    },
    maxVit = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.playerlimit.maxVitality()
      end,
      bgNode = "vit_bg",
      textNode = "maxVitText",
      text = function()
        return "/" .. ed.formatNumWithComma(ed.playerlimit.maxVitality())
      end,
      padding = -3,
      rightPoint = ccp(107, 25),
      rightNode = nil,
      refreshKeys = {"vitality"}
    }
  }
  if not key then
    return self.bar_config
  else
    return self.bar_config[key]
  end
end
local function initBarConfig(self, key)
  local bc = getBarConfig(self, key)
  if key then
    bc.hasInit = nil
  else
    for k, v in pairs(bc) do
      v.hasInit = nil
    end
  end
end
class.interface = {
  sbGetuiList = getuiList,
  sbGetInfoBarType = getInfoBarType,
  sbGetContainer = getContainer,
  sbGetInfoContainer = getInfoContainer,
  --sbGetVitalityPromptText = getVitalityPromptText,
  sbCreateBack = createBack,
  sbCreateSDKIcon = createSDKIcon,
  sbCreateHead = createHead,
  sbRefreshHead = refreshHead,
  sbCreateTitle = createTitle,
  sbCreateTitleButton = createTitleButton,
  sbRefreshDailyloginTag = refreshDailyloginTag,
  sbGetBarConfig = getBarConfig,
  sbInitBarConfig = initBarConfig,
}

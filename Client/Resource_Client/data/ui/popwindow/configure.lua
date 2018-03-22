local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.configure = class

function changeGoogleConnectState(self, state)
  local ui = self.ui
  local google_connect = ui.google_connect
  local google_disconnect = ui.google_disconnect

  ed.player.isGoogleLinked = state

  if state == true then
    -- connect success, change button to disconnect
    if google_connect then
      google_connect:setVisible(true)
    end

    if google_disconnect then
      google_disconnect:setVisible(false)
    end
  else
    if google_connect then
      google_connect:setVisible(false)
    end

    if google_disconnect then
      google_disconnect:setVisible(true)
    end
  end
end


function changeFacebookConnectState(self, state)

  local ui = self.ui
  local facebook_connect = ui.facebook_connect
  local facebook_disconnect = ui.facebook_disconnect


  if  state == 1 then

    LegendLog("changeFacebookConnectState connected")
    -- connect success, change button to disconnect
    if facebook_connect then
      facebook_connect:setVisible(true)
    end

    if facebook_disconnect then
      facebook_disconnect:setVisible(false)
    end
  else

    LegendLog("changeFacebookConnectState disconnected")

    if facebook_connect then
      facebook_connect:setVisible(false)
    end

    if facebook_disconnect then
      facebook_disconnect:setVisible(true)
    end
  end
end

class.changeGoogleConnectState = changeGoogleConnectState
class.changeFacebookConnectState = changeFacebookConnectState
local function getHeadFrameRes(self)
  local vip = ed.player:getvip()
  if vip > 0 then
    return "UI/alpha/HVGA/main_head_frame_gold.png"
  else
    return "UI/alpha/HVGA/main_head_frame_silver.png"
  end
end
class.getHeadFrameRes = getHeadFrameRes
local function createHeadIcon(self, res)
  local head, headicon = ed.getHeadIcon({res = res})
  head:setPosition(ccp(185, 363))
  if not tolua.isnull(self.container) then
    self.container:addChild(head, 3)
  end
end
class.createHeadIcon = createHeadIcon
local function createName(self)
  if not tolua.isnull(self.ui.name) then
    self.ui.name:removeFromParentAndCleanup(true)
  end
  local readnode = ed.readnode.create(self.container, self.ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = ed.player:getName(),
        size = 20
      },
      layout = {
        position = ccp(370, 410)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
  if ed.player:getName() ~= "" or not T(LSTR("CONFIGURE.SET_NICKNAME")) then
  end
  if self.ui.name:getContentSize().width > 180 then
    self.ui.name:setScale(180 / self.ui.name:getContentSize().width)
  end
  ed.setString(self.ui.change_name_label, (T(LSTR("CONFIGURE.CHANGE_NICKNAME"))))
end
class.createName = createName
local function createPlayerInformation(self)
  local tlevel = ed.player:getLevel()
  local ps
  local hlevel = ed.playerlimit.heroLevelLimit()
  local exp = ed.player:getExp()
  local maxexp = ed.player:getMaxExp()
  local info = {
    {
      title = T(LSTR("ANNOUNCE.TEAM_RATING_")),
      text = " "..tlevel,
      ps = ed.player:checkLevelMax() and T(LSTR("CONFIGURE.HAS_REACHED_THE_LEVEL_CAP")) or nil
    },
    {
      title = T(LSTR("CONFIGURE.TEAM_EXPERIENCE_")),
      text = " "..string.format("%d/%d", exp, maxexp)
    },
    {
      title = T(LSTR("PLAYERLEVELDISPLAY.HERO_LEVEL_LIMIT_")),
      text = " "..hlevel
    },
    {
      title = T(LSTR("CONFIGURE.ACCOUNT_ID_")),
      text = " "..ed.getUserid()
    }
  }
  for i = 1, #info do
    local tt = info[i]
    local ui = {}
    local readnode = ed.readnode.create(self.container, ui)
    local ui_info = {
      {
        t = "Label",
        base = {
          name = "title",
          text = tt.title,
          size = 19
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(305, 365 - 22 * (i - 1))
        },
        config = {
          color = ccc3(219, 196, 126)
        }
      }
    }
    readnode:addNode(ui_info)
    ui_info = {
      {
        t = "Label",
        base = {
          name = "text",
          text = tt.text,
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(0, 0)
        },
        config = {
          color = ccc3(249, 238, 208)
        }
      }
    }
    readnode:addNode(ui_info)
    ui.text:setPosition(ed.getRightSidePos(ui.title))
    if tt.ps then
      ui_info = {
        {
          t = "Label",
          base = {
            name = "ps",
            text = tt.ps,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(249, 238, 208)
          }
        }
      }
      readnode:addNode(ui_info)
      ui.ps:setPosition(ed.getRightSidePos(ui.text))
    end
  end
end
class.createPlayerInformation = createPlayerInformation

class.createGoogleConnectButton = function(self, height)
  --[[if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
    return height
  end]]
	
  local ui = self.ui
  local container = self.container
  height = height + 50
  local bw, bh = 160, 50
  local buttonSize = CCSizeMake(bw, bh)
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    -- facebook connect
    {
      config = {scaleSize = CCSizeMake(180, 55)},
      t = "DGButton",
      base = {
        normal = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        name = "fb_bottom",
        text = "",
        press = "UI/alpha/HVGA/sell_number_button_down.png",
      },
      layout = {
        position = ccp(590, 550 - height)
      }
    },
    {
      config = {
        visible = false,
        flip = "",
        scaleSize = CCSizeMake(190, 30),
        opacity = 255,
        labelConfig = {
          color = ccc3(89, 255, 0)
        },
        pressConfig = {flip = ""}
      },
      t = "DGButton",
      base = {
        normal = "UI/alpha/HVGA/connect/fc-1.png",
        name = "facebook_connect",
        parent = "fb_bottom",
        text = T(LSTR("CONFIGURE.FACEBOOK.CONNECT")),
        press = "UI/alpha/HVGA/connect/fc-2.png",
        fontinfo = "ui_normal_button",
        size = 18,
      },
      layout = {
        position = ccp(105, 25)
      }
    },
    {
      config = {
        visible = true,
        flip = "",
        scaleSize = CCSizeMake(190, 30),
        opacity = 255,
        labelConfig = {
          color = ccc3(235, 223, 207),
          shadow = {
            color = ccc3(0, 0, 0),
            offset = ccp(0, 2)
          }
        },
        pressConfig = {flip = ""}
      },
      t = "DGButton",
      base = {
        normal = "UI/alpha/HVGA/connect/fc-1.png",
        name = "facebook_disconnect",
        parent = "fb_bottom",
        text = T(LSTR("CONFIGURE.FACEBOOK.DISCONNECT")),
        press = "UI/alpha/HVGA/connect/fc-2.png",
        fontinfo = "ui_normal_button",
        size = 19,
      },
      layout = {
        position = ccp(105, 28)
      }
    },
  }

  local ui_google_info = {
      -- gooogle connect
      {
          config = { scaleSize = CCSizeMake(180, 55) },
          t = "DGButton",
          base = {
              normal = "UI/alpha/HVGA/sell_number_button.png",
              capInsets = CCRectMake(15, 22, 15, 25),
              name = "google_bottom",
              text = "",
              press = "UI/alpha/HVGA/sell_number_button_down.png",
          },
          layout = {
              position = ccp(200, 550 - height)
          }
      },
      {
          config = {
              visible = false,
              flip = "",
              scaleSize = CCSizeMake(190, 25),
              opacity = 255,
              labelConfig = {
                  color = ccc3(89, 255, 0)
              },
              pressConfig = { flip = "" }
          },
          t = "DGButton",
          base = {
              normal = "UI/alpha/HVGA/connect/gd-1.png",
              name = "google_connect",
              parent = "google_bottom",
              text = T(LSTR("CONFIGURE.FACEBOOK.CONNECT")),
              press = "UI/alpha/HVGA/connect/gd-2.png",
          },
          layout = {
              position = ccp(105, 25)
          }
      },
      {
          config = {
              visible = false,
              flip = "",
              scaleSize = CCSizeMake(190, 25),
              opacity = 255,
              labelConfig = {
                  color = ccc3(235, 223, 207),
              },
              pressConfig = { flip = "" }
          },
          t = "DGButton",
          base = {
              normal = "UI/alpha/HVGA/connect/gd-1.png",
              name = "google_disconnect",
              parent = "google_bottom",
              text = T(LSTR("CONFIGURE.FACEBOOK.DISCONNECT")),
              press = "UI/alpha/HVGA/connect/gd-2.png",
              fontinfo = "ui_normal_button",
              size = 19,
          },
          layout = {
              position = ccp(105, 25)
          }
      },
  }	
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
      for i, v in ipairs(ui_google_info) do
          table.insert(ui_info, v)
      end
  end

  readnode:addNode(ui_info)
	
  height = height + 10
  return height
end

local function createLogoffButton(self, height)
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
    return
  end

  local ui = self.ui
  local container = self.container
  height = height + 50
  local bw, bh = 160, 50
  local buttonSize = CCSizeMake(bw, bh)
  local logoffText = T(LSTR("CONFIGURE.LOG_OUT"))
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "logoff_line_down",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 535 - height)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "logoff",
        res = "UI/alpha/HVGA/playerinfo_button_red_1.png",
        capInsets = CCRectMake(15, 15, 70, 20)
      },
      layout = {
        position = ccp(400, 470 - height)
      },
      config = {scaleSize = buttonSize}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "logoff_press",
        res = "UI/alpha/HVGA/playerinfo_button_red_2.png",
        capInsets = CCRectMake(15, 15, 70, 20),
        parent = "logoff"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {scaleSize = buttonSize, visible = false}
    },
    {
      t = "Label",
      base = {
        name = "logoff_label",
        fontinfo = "ui_normal_button",
        text = logoffText,
        size = 18,
        parent = "logoff"

      },
      layout = {
        position = ccp(bw / 2, bh / 2)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
  height = height + 10
  return height
end
class.createLogoffButton = createLogoffButton

local function create360Buttons(self, height)
  local ui = self.ui
  local container = self.container
  height = height + 50
  local bw, bh = 160, 50
  local buttonSize = CCSizeMake(bw, bh)
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "360_line_down",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 505 - height)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "register_real_name",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(280, 465 - height)
      },
      config = {scaleSize = buttonSize}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "register_real_name_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "register_real_name"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {scaleSize = buttonSize, visible = false}
    },
    {
      t = "Label",
      base = {
        name = "register_real_name_label",
        text = T(LSTR("CONFIGURE.REALNAME_REGISTRATION")),
        size = 18,
        parent = "register_real_name"
      },
      layout = {
        position = ccp(bw / 2, bh / 2)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "anti_addiction",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(520, 465 - height)
      },
      config = {scaleSize = buttonSize}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "anti_addiction_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "anti_addiction"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {scaleSize = buttonSize, visible = false}
    },
    {
      t = "Label",
      base = {
        name = "anti_addiction_label",
        text = T(LSTR("CONFIGURE.ANTIADDICTION_INQUIRY")),
        size = 18,
        parent = "anti_addiction"
      },
      layout = {
        position = ccp(bw / 2, bh / 2)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
  height = height + 20
  return height
end
class.create360Buttons = create360Buttons
local function createSociety(self, height)
  local ui = self.ui
  local container = self.container
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "society_line_up",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 275)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    {
      t = "HorizontalNode",
      base = {
        name = "society_name"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(120, 255)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "title",
            text = T(LSTR("CONFIGURE.GUILD_")),
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {
            color = ccc3(220, 176, 103)
          }
        },
        {
          t = "Label",
          base = {
            name = "name",
            text = ed.player:getGuildName() or "",
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
    },
    {
      t = "HorizontalNode",
      base = {name = "society_id"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(120, 230)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "title",
            text = T(LSTR("CONFIGURE.GUILD_ID_")),
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {
            color = ccc3(220, 176, 103)
          }
        },
        {
          t = "Label",
          base = {
            name = "id",
            text = ed.player:getGuildId(),
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "quit_society",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(615, 240)
      },
      config = {
        scaleSize = CCSizeMake(130, 55)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "quit_society_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "quit_society"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(130, 55),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "quit_society_label",
        text = T(LSTR("CONFIGURE.QUIT_GUILD")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "quit_society"
      },
      layout = {
        position = ccp(65, 27)
      },
      config = {
        color = ccc3(235, 223, 207)
      }
    }
  }
  readnode:addNode(ui_info)
  return height + 65
end
class.createSociety = createSociety
local function createSWButton(self, height)
  local ui = self.ui
  local container = self.container
  height = height + 60
  local buttonHeight = 495
  local sbw, sbh = 190, 60
  local sbSize = CCSizeMake(sbw, sbh)
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "society_line_down",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 600 - height)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "setup_button",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25),
      },
      layout = {
        position = ccp(200, buttonHeight - height-60)
      },
      config = {
        scaleSize = CCSizeMake(180, 55)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "setup_button_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "setup_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(180, 55),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "setup_label",
        text = T(LSTR("CONFIGURE.SYSTEM.SETTING")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "setup_button"
      },
      layout = {
        position = ccp(90, 27)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    --新增 选择服务器按钮

    {
      t = "Scale9Sprite",
      base = {
        name = "select_server",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(393, buttonHeight - height-60)
      },
      config = {
        scaleSize = CCSizeMake(180, 55)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "select_server_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "select_server"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(180, 55),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "select_server_label",
        text = T(LSTR("CONFIGURE.CHANGE_SERVER")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "select_server"
      },
      layout = {
        position = ccp(90, 27)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },

    {
      t = "Scale9Sprite",
      base = {
        name = "support_button",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(590, buttonHeight - height-60)
      },
      config = {
        scaleSize = CCSizeMake(180, 55),
		visible = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "support_button_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "support_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(180, 55)
      }
    },
	 {
      t = "Sprite",
      base = {
        name = "facebookicon",
        res = "UI/alpha/HVGA/fb_normal.png",
		 parent = "support_button"
      },
      layout = {
        position = ccp(28, 27)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "support_button_label",
        text = T(LSTR("CONFIGURE.SYSTEM.FACEBOOK")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "support_button"
      },
      layout = {
        position = ccp(90, 27)
      },
      config = {
        color = ccc3(235, 223, 207),
		visible = true,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "language_line_down",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 150)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "language_button",
        res = getLanguagePng(currentLang),
        capInsets = CCRectMake(15, 22, 15, 15)
      },
      layout = {
        position = ccp(162, buttonHeight - height+80)
      },
      config = {
        scaleSize = CCSizeMake(100, 60)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "language_button_press",
        res = getLanguagePng(currentLang),
        capInsets = CCRectMake(15, 22, 15, 25),
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(113, buttonHeight - height+51)
      },
      config = {
        scalexy = {x = 0.97, y = 0.97},
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "language_label",
        text = T(LSTR("CONFIGURE.LANGUAGE")),
        fontinfo = "normal_button",
        size = 20,
      },
      layout = {
        position = ccp(250, buttonHeight - height+80)
      },
      config = {
        color = ccc3(220, 176, 103),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "facebook_line_down",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(170, 1, 10, 1)
      },
      layout = {
        position = ccp(390, 85)
      },
      config = {
        scaleSize = CCSizeMake(600, 2)
      }
    },
    ---------------------
    {
      t = "Scale9Sprite",
      base = {
        name = "web_button",
        res = "UI/alpha/HVGA/shop_refresh_button.png",
        capInsets = CCRectMake(25, 25, 50, 15)
      },
      layout = {
        position = ccp(515, buttonHeight - height-60)
      },
      config = {scaleSize = sbSize}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "web_button_press",
        res = "UI/alpha/HVGA/shop_refresh_button_down.png",
        capInsets = CCRectMake(25, 25, 50, 15),
        parent = "web_button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {scaleSize = sbSize, visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "web_label",
        res = "UI/alpha/HVGA/playerinfo_button_guide_1.png",
        parent = "web_button"
      },
      layout = {
        position = ccp(sbw / 2, sbh / 2)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "web_label_press",
        res = "UI/alpha/HVGA/playerinfo_button_guide_2.png",
        parent = "web_label"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }

  readnode:addNode(ui_info)
   
	local support_button = ui.support_button
	local button = ui.language_button
	local press = ui.language_button_press
	local languagelabel=ui.language_label
	--add by xt
	if fb_flag == true then
		support_button:setVisible(false)
	end
	if ed.debug_mode==false then
		press:setVisible(false)
		languagelabel:setVisible(false)
		button:setVisible(false)
	end
  --ui.setup_button:setPosition(ccp(233, buttonHeight - height))
  ui.web_button:setVisible(false)
  return height
end
class.createSWButton = createSWButton
local function createWindow(self)
  if not tolua.isnull(self.container) then
    self.container:removeFromParentAndCleanup(true)
  end
  local container = CCLayer:create()
  container:setAnchorPoint(ccp(0.5, 0.8))
  self.container = container
  self.mainLayer:addChild(container)
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  if ed.player:getName() ~= "" or not T(LSTR("CONFIGURE.SET_NICKNAME")) then
  end
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(394, 455)
      },
      config = {
        scaleSize = CCSizeMake(500, 250)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(690, 435)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "head_pattern",
        res = "UI/alpha/HVGA/avatar_head_patterns.png"
      },
      layout = {
        position = ccp(185, 360)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "head_bg",
        res = "UI/alpha/HVGA/avatar_head_bg.png"
      },
      layout = {
        position = ccp(185, 360)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "head_frame",
        res = self:getHeadFrameRes(),
        z = 5
      },
      layout = {
        position = ccp(200, 360)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "change_head",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(615, 312)
      },
      config = {
        scaleSize = CCSizeMake(130, 55)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "change_head_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "change_head"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(130, 55),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "change_head_label",
        text = T(LSTR("CONFIGURE.CHANGE_AVATAR")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "change_head"
      },
      layout = {
        position = ccp(65, 27)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/HVGA/tip_detail_bg.png"
      },
      layout = {
        position = ccp(370, 410)
      },
      config = {
        fix_wh = {w = 225, h = 30}
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "change_name",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(615, 385)
      },
      config = {
        scaleSize = CCSizeMake(130, 55)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "change_name_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "change_name"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(130, 55),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "change_name_label",
        text = T(LSTR("CONFIGURE.CHANGE_NICKNAME")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "change_name"
      },
      layout = {
        position = ccp(65, 27)
      },
      config = {
        color = ccc3(235, 223, 207),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
  
  self:createHeadIcon()
  self:createName()
  self:createPlayerInformation()
  local height = 260
  if ed.player:getGuildId() ~= 0 then
    height = self:createSociety(height)
  end
  height = self:createSWButton(height)
  if self:showLogoff() then
    height = self:createLogoffButton(height)
  end
  if self:showGoogleConnect() then
    height = self:createGoogleConnectButton(height)
    self:changeGoogleConnectState(ed.player.isGoogleLinked)
    self:changeFacebookConnectState(LegendIsFacebookConnected())
  end	

	height=height+60
  if LegendSDKType == 104 then
    height = self:create360Buttons(height)
  end
  self.ui.frame:setContentSize(CCSizeMake(620, height))
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -145, true)
end
class.createWindow = createWindow
local function create()
  local self = {}
  setmetatable(self, class.mt)
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  self:createWindow()
  self:show()

  CloseEvent("GoogleConnectResponse")
  ListenEvent("GoogleConnectResponse", function(stateStr)
    local state = false
    local self = self
    if "true" == stateStr then
      state = true
    else
      state = false
    end
    LegendLog("+++Lua+++ GoogleConnectResponse: "..stateStr)
    self:changeGoogleConnectState(state)
  end)


  CloseEvent("FacebookConnectResult")
  ListenEvent("FacebookConnectResult", function(result)
    local self = self


    self:changeFacebookConnectState(result)
  end)


  return self
end
class.create = create
local show = function(self)
  local container = self.container
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  container:runAction(s)
end
class.show = show
local destroy = function(self)
  local container = self.container
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
end
class.destroy = destroy
local function doClickSetupButton(self)
  local layer = ed.ui.notification.create().mainLayer
  self.mainLayer:addChild(layer, 220)
end
class.doClickSetupButton = doClickSetupButton
local function doSetupButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.setup_button
  local press = ui.setup_button_press
  --local labelPress = ui.setup_label_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
        --labelPress:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        --labelPress:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickSetupButton()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doSetupButtonTouch = doSetupButtonTouch

local function doClickSelectServer(self)
  ed.pushScene(ed.ui.selectserverwin.create())
end
class.doClickSelectServer = doClickSelectServer
local function doSelectServerTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.select_server
  local press = ui.select_server_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickSelectServer()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doSelectServerTouch = doSelectServerTouch

---支持
local function doClickSupport(self)
	 libOS:getInstance():openURL("http://www.facebook.com/we4dota")	
  --ed.ui.helpsupport.create()
 -- libPlatformManager:getPlatform():switchUsers()
end
class.doClickSupport = doClickSupport
local function doSupportTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.support_button
  local press = ui.support_button_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickSupport()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doSupportTouch = doSupportTouch
local function doLanguageTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.language_button
  local press = ui.language_button_press
  local function handler(event, x, y)
	if ed.debug_mode==false then
			return
		end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setVisible(false)
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        button:setVisible(true)
        if ed.containsPoint(button, x, y) then
            local res = getLanguagePng(currentLang)
            local text2d = CCTextureCache:sharedTextureCache():addImage(res);
            button:setTexture(text2d)
            press:setTexture(text2d)
            local languageWin = ed.ui.languagechange.create()
            self.mainLayer:addChild(languageWin.mainLayer, 100)
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doLanguageTouch = doLanguageTouch

---google connect
local function doClickGoogleConnect(self)
  LegendGoogleConnect(LegendSDKType)
end
class.doClickGoogleConnect = doClickGoogleConnect
local function doGoogleConnectTouch(self)
  local isPress
  local ui = self.ui
  local google_bottom = ui.google_bottom
  local google_connect = ui.google_connect
  local google_bottom_press = ui.google_bottom_press
  local google_connect_press = ui.google_connect_press

  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(google_connect, x, y) then
        isPress = true
        google_connect_press:setVisible(true)
        google_bottom_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        google_connect_press:setVisible(false)
        google_bottom_press:setVisible(false)
        if ed.containsPoint(google_connect, x, y) then
          self:doClickGoogleConnect()
        end
      end
      isPress = nil
    end
  end

  return handler
end
class.doGoogleConnectTouch = doGoogleConnectTouch

local function doFacebookConnectTouch(self)
  local isPress
  local ui = self.ui
  local fb_bottom = ui.fb_bottom
  local facebook_connect = ui.facebook_connect
  local fb_bottom_press = ui.fb_bottom_press
  local facebook_connect_press = ui.facebook_connect_press

  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(facebook_connect, x, y) then
        isPress = true
        facebook_connect_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        facebook_connect_press:setVisible(false)
        if ed.containsPoint(facebook_connect, x, y) then
          if LegendIsFacebookConnected()==1 then
            LegendDisconnectFacebook()
            self:changeFacebookConnectState(0)
          else
            LegendConnectFacebook()
          end
        end
      end
      isPress = nil
    end
  end

  return handler
end
class.doFacebookConnectTouch = doFacebookConnectTouch

local doClickWebButton = function(self)
  ----此处地址要进行更换
  local addr = "http://www.we4dota.com"
  LegendOpenURL(addr)
end

class.doClickWebButton = doClickWebButton
local function doWebButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.web_button
  local press = ui.web_button_press
  local label = ui.web_label
  local labelPress = ui.web_label_press
  local function handler(event, x, y)
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
        labelPress:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        labelPress:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickWebButton()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doWebButtonTouch = doWebButtonTouch
local function doClickQuitSociety(self)
  local info = {
    text = T(LSTR("CONFIGURE.AFTER_EXITING_THE_GUILD_CAN_NOT_JOIN_ANY_GUILD_WITHIN_ONE_HOUR_UNABLE_TO_RETURN_TO_THE_ORIGINAL_GUILD_WITHIN_48_HOURS_WHETHER_TO_EXIT")),
    rightHandler = function()
      ed.ui.guild.exitGuild(function()
        xpcall(function()
          self:createWindow()
        end, EDDebug)
      end)
    end
  }
  ed.showConfirmDialog(info)
end
class.doClickQuitSociety = doClickQuitSociety
local function doQuitSocietyTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.quit_society
  local press = ui.quit_society_press
  local function handler(event, x, y)
    if tolua.isnull(button) then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickQuitSociety()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doQuitSocietyTouch = doQuitSocietyTouch
local function doCloseTouch(self)
  local isPressClose, isPressOut
  local ui = self.ui
  local frame = ui.frame
  local button = ui.close
  local press = ui.close_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPressClose = true
        press:setVisible(true)
        return
      end
      if not ed.containsPoint(frame, x, y) then
        isPressOut = true
      end
    elseif event == "ended" then
      if isPressClose then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
        isPressClose = nil
      end
      if isPressOut then
        if not ed.containsPoint(frame, x, y) then
          self:destroy()
        end
        isPressOut = nil
      end
    end
  end
  return handler
end
class.doCloseTouch = doCloseTouch
local function doClickChangeHead(self)
  ed.ui.selectwindow.pop({
    name = "avatar",
    callback = function(key)
      local res = ed.getDataTable("Avatar")[key].Picture
      self:createHeadIcon(res)
    end
  })
end
class.doClickChangeHead = doClickChangeHead
local function doChangeHeadTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.change_head
  local press = ui.change_head_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickChangeHead()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doChangeHeadTouch = doChangeHeadTouch
local function doClickChangeName(self)
  local cd = ed.player:getNameCountdown()
  if cd then
    ed.showAlertDialog({
      text = T(LSTR("CONFIGURE.AFTER_THE__S_CAN_BE_RENAMED_AGAIN"), cd)
    })
    return
  end
  local bename = ed.ui.bename.create({
    type = ed.player:getName() == "" and "free" or "pay",
    callback = function()
      xpcall(function()
        self:createName()
      end, EDDebug)
    end
  })
  self.mainLayer:addChild(bename.mainLayer, 100)
end
class.doClickChangeName = doClickChangeName
local function doChangeNameTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.change_name
  local press = ui.change_name_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickChangeName()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doChangeNameTouch = doChangeNameTouch
local function doClickLogoff(self)
    LegendExit(LegendSDKType)
end
class.doClickLogoff = doClickLogoff
local function doLogoffTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.logoff
  local press = ui.logoff_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        self:doClickLogoff()
      end
      isPress = nil
    end
  end
  return handler
end
class.doLogoffTouch = doLogoffTouch
local function doRealNameRegisterTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.register_real_name
  local press = ui.register_real_name_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          local info = {
            accessToken = ed.getAccessToken(),
            uin = ed.getDeviceId()
          }
          --LegendAndroidExtra("realNameRegister", ed.getJson(info))
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doRealNameRegisterTouch = doRealNameRegisterTouch
local function doAntiAddictionTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.anti_addiction
  local press = ui.anti_addiction_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          local info = {
            accessToken = ed.getAccessToken(),
            uin = ed.getDeviceId()
          }
          LegendAndroidExtra("checkAntiAddiction", ed.getJson(info))
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doAntiAddictionTouch = doAntiAddictionTouch
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local changeHeadTouch = self:doChangeHeadTouch()
  local changeNameTouch = self:doChangeNameTouch()
  local quitSocietyTouch = self:doQuitSocietyTouch()
  local setupTouch = self:doSetupButtonTouch()
  local selectServerTouch = self:doSelectServerTouch()
  local languageTouch = self:doLanguageTouch()
  local googleConnectTouch = self:doGoogleConnectTouch()
  local facebookConnectTouch = self:doFacebookConnectTouch()

  local webTouch = self:doWebButtonTouch()
  local logoffTouch
  if self:showLogoff() then
    logoffTouch = self:doLogoffTouch()
  end
  local realNameRegisterTouch, antiAddictionTouch
  if LegendSDKType == 104 then
    realNameRegisterTouch = self:doRealNameRegisterTouch()
    antiAddictionTouch = self:doAntiAddictionTouch()
  end

local supportTouch = self:doSupportTouch()

  local function handler(event, x, y)
    xpcall(function()
      closeTouch(event, x, y)
      changeHeadTouch(event, x, y)
      changeNameTouch(event, x, y)
      quitSocietyTouch(event, x, y)
      setupTouch(event, x, y)
      selectServerTouch(event,x,y)
      languageTouch(event,x,y)
      googleConnectTouch(event,x,y)
      facebookConnectTouch(event,x,y)
      webTouch(event, x, y)
      if logoffTouch then
        logoffTouch(event, x, y)
      end
	if fb_flag==nil or fb_flag==false then
		supportTouch(event,x,y)
	end
      if realNameRegisterTouch then
        realNameRegisterTouch(event, x, y)
      end
      if antiAddictionTouch then
        antiAddictionTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function showLogoff(self)
      if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
          return false;
      end
  --  return false
  --  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID and not ed.isElementInTable(LegendSDKType, {
  --    102,
  --    104,
  --    109,
  --    110,
  --    111,
  --    112,
  --    113,
  --    114,
  --    115,
  --    116,
  --    117,
  --    118,
  --    119,
  --    120,
  --    121,
  --    122,
  --    123,
  --    124,
  --    125
  --  }) then
  --    return true
  --  end
  if EDFLAGWP8 then
    return true
  end
  return false
end
class.showLogoff = showLogoff

-- only android show google connect
class.showGoogleConnect = function (self)
   return false
  --[[if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
    return true
  else
    return false
  end]]
end

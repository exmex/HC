ed.uieditor = ed.uieditor or {}
ed.uieditor.herosplitconfirm = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(462.5, 329.69)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(58.59, 85.94, 339.84, 15.63),
      res = "UI/alpha/HVGA/common/common_alert_bg.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403.13, 233.59)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(359.38, 11.72)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 1,
      parent = "frame",
      res = "UI/alpha/HVGA/herodetail-title-mark.png",
      capInsets = CCRectMake(78.13, 0, 69.53, 11.72)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229.69, 288.28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 49.21875, h = 52.34375},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
      name = "close_button",
      z = 2,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(430.47, 294.53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 222, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 2,
      parent = "frame",
      text = T(LSTR("herosplitconfirm.1.10.1.001")),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.25, 289.06)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(118.75, 52.34),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(14.06, 15.63, 15.63, 17.19),
      name = "ok_button",
      z = 2,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.25, 50.78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.90625, h = 27.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/player_levelup_arrow.png",
      name = "arrow",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.47, 207.81)
    }
  }
}

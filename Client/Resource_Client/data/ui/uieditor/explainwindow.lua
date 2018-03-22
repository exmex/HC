ed.uieditor = ed.uieditor or {}
ed.uieditor.explainwindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 156.25)
    },
    t = "Layer",
    base = {
      name = "window_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(183.59, 398.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(548.44, 378.91)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame",
      z = 0,
      parent = "window_container",
      res = "UI/alpha/HVGA/main_vit_tips.png",
      capInsets = CCRectMake(17.19, 17.19, 46.88, 15.63)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(-58.59, 31.25)
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
      z = 20,
      parent = "window_container",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475.78, 11.72)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(480.47, 39.06)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 1,
      parent = "window_container",
      res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png",
      capInsets = CCRectMake(109.38, 0, 156.25, 34.38)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(214.84, -8.59)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(234, 171, 41),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "window_container",
      text = T(LSTR("PVP.RULE_DESCRIPTION")),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5, -8.59)
    }
  }
}

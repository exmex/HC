ed.uieditor = ed.uieditor or {}
ed.uieditor.setup = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 390.63)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(11.72, 11.72, 54.69, 23.44),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(128.13, 42.97)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 517.34375, h = 34.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 359.38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "frame",
      text = T(LSTR("SETUP.PUSH_SET")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 360.94)
    }
  },
  {
    config = {
      rotation = 0,
      --fix_wh = {w = 49.21875, h = 52.34375},
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
      name = "close",
      z = 1,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(532.81, 370.31)
    }
  }
}

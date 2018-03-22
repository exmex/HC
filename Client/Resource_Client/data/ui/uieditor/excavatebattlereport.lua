ed.uieditor = ed.uieditor or {}
ed.uieditor.excavatebattlereport = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(703.13, 434.38)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(21.88, 21.09, 39.06, 11.72),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(419.53, 233.59)
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
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(752.34, 432.81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 224, 131),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 22,
      text = T(LSTR("EXCAVATEBATTLEREPORT.OFFENCE")),
      name = "left_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239.06, 426.56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 224, 131),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 22,
      text = T(LSTR("EXCAVATEBATTLEREPORT.DEFENDER")),
      name = "right_title",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(554.69, 426.56)
    }
  }
}

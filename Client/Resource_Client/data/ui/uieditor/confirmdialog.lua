ed.uieditor = ed.uieditor or {}
ed.uieditor.confirmdialog = {
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(390.63, 234.38),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.53, 19.53, 46.88, 11.72),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 234.38)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 371.09375, h = 2.34375},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196.88, 85.16)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(125, 54.69),
      opacity = 255,
      labelConfig = {
        color = ccc3(234, 225, 205)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "right_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.03, 42.97)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(125, 54.69),
      opacity = 255,
      labelConfig = {
        color = ccc3(234, 225, 205)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "left_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CANCEL")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.59, 42.97)
    }
  }
}

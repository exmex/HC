ed.uieditor = ed.uieditor or {}
ed.uieditor.starshopbuywindow = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 466.40625, h = 289.84375},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/shop_star_tips_frame.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(409.38, 200)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 405.46875, h = 7.8125},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/shop_star_tips_delimeter.png",
      name = "line",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.86, 102.73)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 120.3125, h = 53.90625},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/shop_star_button_1.png",
      name = "cancel_button",
      z = 2,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CANCEL")),
      press = "UI/alpha/HVGA/shop_star_button_2.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.02, 66.8)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 120.3125, h = 53.90625},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/shop_star_button_1.png",
      name = "ok_button",
      z = 4,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/shop_star_button_2.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(308.98, 64.45)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(129, 204, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "title_1",
      z = 2,
      parent = "frame",
      text = T(LSTR("STARSHOPBUYWINDOW.ARE_YOU_SURE_TO_USE_IT")),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240, 140)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(42.97, 42.97),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "frame",
      name = "icon_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(180, 155)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(131, 240, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "amount_label",
      z = 2,
      parent = "frame",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(240, 180)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(129, 204, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "title_2",
      z = 2,
      parent = "frame",
      text = T(LSTR("STARSHOPBUYWINDOW.EXCHANGE")),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 220)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(131, 240, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "name_label",
      z = 2,
      parent = "frame",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(186.33, 220)
    }
  }
}

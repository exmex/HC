ed.uieditor = ed.uieditor or {}
ed.uieditor.worldcupwindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587.5, 457.03)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 50, 535.16, 50),
      res = "UI/alpha/HVGA/dailylogin/dailylogin_frame.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390.63, 236.72)
    }
  },
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
      parent = "frame",
      name = "title_container",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(293.75, 228.52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 57.8125, h = 58.59375},
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
      normal = "UI/alpha/HVGA/herodetail-detail-close.png",
      name = "close_button",
      z = 5,
      parent = "title_container",
      text = "",
      press = "UI/alpha/HVGA/herodetail-detail-close-p.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.19, 202.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 573.4375, h = 34.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_container",
      res = "UI/alpha/HVGA/act/act_popup_bg.png",
      name = "title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.78, 192.19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 242, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 6,
      parent = "title_container",
      text = T(LSTR("worldcupwindow.1.10.1.001")),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.78, 192.97)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(113.28, 52.34),
      flip = "",
      labelConfig = {
        color = ccc3(234, 225, 205)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 19.53, 15.63, 15.63),
      name = "explain_button",
      z = 5,
      parent = "title_container",
      text = T(LSTR("EXCAVATEMAP.RULES")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, 191.41)
    }
  }
}

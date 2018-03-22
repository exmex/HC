ed.uieditor = ed.uieditor or {}
ed.uieditor.vipprivilege = {
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 156.25),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "window_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(183.59-40, 398.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(433.59+80, 355.47),
      flip = ""
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
      position = ccp(0, 0)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 300.78125, h = 300.78125},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "window_container",
      res = "UI/alpha/HVGA/lettherebelight.png",
      name = "title_light",
      z = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5+40, 5.47)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 350.78125, h = 108.59375},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "window_container",
      res = "UI/alpha/HVGA/vip_levelup_title.png",
      name = "title_label",
      z = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(211.72+40, 0)
    }
  },
  {
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
      position = ccp(510, -5)
    },
    config = {
      visible = true,
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
    },
  }
}

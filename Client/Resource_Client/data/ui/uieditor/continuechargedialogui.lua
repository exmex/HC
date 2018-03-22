ed.uieditor = ed.uieditor or {}
ed.uieditor.continuechargedialogui = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(582.03, 410.16)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(35.16, 82.03, 281.25, 62.5),
      res = "UI/alpha/HVGA/dialog_bg.png",
      name = "frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 239.84)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 472.265625, h = 3.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/dialog_line.png",
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.02, 73.05)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 54.69),
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
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "ok_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.02, 41.8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 521.09375, h = 39.0625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_window_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.02, 376.95)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.bananalose = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 323.4375, h = 123.4375},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/failed_title.png",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 314.06)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(156.25, 62.5),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "exit",
      z = 2,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = LSTR("BANANALOSE.BACK_RIGHT"),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.56, 200)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(156.25, 62.5),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "ok",
      z = 4,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = LSTR("BANANALOSE.OK"),
      fontinfo = "ui_normal_button",
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.38, 201.56)
    }
  }
}

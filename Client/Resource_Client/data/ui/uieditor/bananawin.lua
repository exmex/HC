ed.uieditor = ed.uieditor or {}
ed.uieditor.bananawin = {
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
      name = "replay",
      z = 2,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = LSTR("BANANAWIN.DO_IT_AGAIN"),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 203.13)
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
      name = "back",
      z = 4,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = LSTR("BANANAWIN.NO_THANKS"),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 123.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 183.59375, h = 123.4375},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/stagedone_win_tag.png",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 317.97)
    }
  }
}

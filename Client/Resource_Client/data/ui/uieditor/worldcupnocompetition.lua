ed.uieditor = ed.uieditor or {}
ed.uieditor.worldcupnocompetition = {
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
      name = "ok_button",
      z = 12,
      capInsets = CCRectMake(15.63, 19.53, 15.63, 15.63),
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294.53, 38.28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(531.25, 332.03)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 23.44, 23.44),
      res = "UI/alpha/HVGA/worldcup/worldcup_select_bg.png",
      name = "bg_1",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.31, 227.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 470.3125, h = 260.15625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/worldcup/worldcup_bg.png",
      name = "bg_2",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(293.75, 228.91)
    }
  }
}

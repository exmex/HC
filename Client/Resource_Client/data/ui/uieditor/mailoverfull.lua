ed.uieditor = ed.uieditor or {}
ed.uieditor.mailoverfull = {
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(121.09, 54.69),
      opacity = 255,
      labelConfig = {
        color = ccc3(239, 230, 209)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "left_button",
      z = 2,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = T(LSTR("mailoverfull.1.10.1.001")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311.72, 88.28)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(121.09, 54.69),
      opacity = 255,
      labelConfig = {
        color = ccc3(239, 230, 209)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "right_button",
      z = 2,
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      text = T(LSTR("mailoverfull.1.10.1.002")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 89.06)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(463.28, 363.28),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(66.41, 93.75, 335.94, 7.81),
      res = "UI/alpha/HVGA/common/common_alert_bg.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400.78, 216.41)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(359.38, 11.72),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(78.13, 0, 69.53, 11.72),
      res = "UI/alpha/HVGA/herodetail-title-mark.png",
      name = "title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 355.47)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 215, 17),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      size = 23,
      text = T(LSTR("mailoverfull.1.10.1.003")),
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 357.03)
    }
  }
}

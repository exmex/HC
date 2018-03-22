ed.uieditor = ed.uieditor or {}
ed.uieditor.worldcupselect = {
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
      text = T(LSTR("guildinstancereward.1.10.016")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484.38, 39.06)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(531.25, 164.06)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 23.44, 23.44),
      res = "UI/alpha/HVGA/worldcup/worldcup_select_bg.png",
      name = "board_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.31, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(531.25, 164.06)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 23.44, 23.44),
      res = "UI/alpha/HVGA/worldcup/worldcup_select_bg.png",
      name = "board_2",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.31, 144.53)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.78125, h = 116.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_1",
      res = "UI/alpha/HVGA/worldcup/worldcup_delimiter.png",
      name = "delimeter_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 99.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.78125, h = 116.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_2",
      res = "UI/alpha/HVGA/worldcup/worldcup_delimiter.png",
      name = "delimeter_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 99.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.53125, h = 36.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_1",
      res = "UI/alpha/HVGA/chat/chat_replay_vs.png",
      name = "vs_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 105.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.53125, h = 36.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_2",
      res = "UI/alpha/HVGA/chat/chat_replay_vs.png",
      name = "vs_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 105.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 516.40625, h = 35.9375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_1",
      res = "UI/alpha/HVGA/worldcup/worldcup_tip_bg.png",
      name = "bottom_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.41, 26.56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 516.40625, h = 35.9375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_2",
      res = "UI/alpha/HVGA/worldcup/worldcup_tip_bg.png",
      name = "bottom_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.41, 26.56)
    }
  }
}

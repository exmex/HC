ed.uieditor = ed.uieditor or {}
ed.uieditor.applyguildreward = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470.31, 446.88)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 42.97, 19.53),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 236.72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 49.21875, h = 52.34375},
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
      normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
      name = "close_button",
      z = 10,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457.03, 426.56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 398.43741570313, h = 37.7314829375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(234.38, 420.31)
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
      name = "board_container_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.16, 223.44)
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
      name = "board_container_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.16, 160.94)
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
      name = "board_container_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.16, 98.44)
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
      name = "board_container_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.16, 35.94)
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
      name = "board_container_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.16, -26.56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 408.203125, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.16, 83.59)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(140.63, 52.34),
      flip = "",
      labelConfig = {
        color = ccc3(243, 235, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(19.53, 19.53, 15.63, 15.63),
      name = "apply_detail_button",
      z = 5,
      parent = "frame",
      text = T(LSTR("applyguildreward.1.10.1.001")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127.34, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(140.63, 52.34),
      flip = "",
      labelConfig = {
        color = ccc3(243, 235, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(19.53, 19.53, 15.63, 15.63),
      name = "apply_button",
      z = 5,
      parent = "frame",
      text = T(LSTR("applydetail.1.10.002")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(342.97, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 413.28123292969, h = 49.453146632813},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_5",
      res = "UI/alpha/HVGA/tip_detail_bg.png",
      name = "board_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3.13, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 188, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_5",
      z = 1,
      parent = "board_container_5",
      text = T(LSTR("applyguildreward.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-129.69, 147.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_5",
      res = "UI/alpha/HVGA/money_guildtoken_small.png",
      name = "icon_5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-59.38, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_5",
      z = 1,
      parent = "board_container_5",
      text = "500",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-39.06, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5625, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_5",
      res = "UI/alpha/HVGA/guild/guildraid_select_frame.png",
      name = "check_bg_5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_5",
      res = "UI/alpha/HVGA/fragment_tick.png",
      name = "check_5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 413.28123292969, h = 49.453146632813},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_4",
      res = "UI/alpha/HVGA/tip_detail_bg.png",
      name = "board_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3.13, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 188, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_4",
      z = 1,
      parent = "board_container_4",
      text = T(LSTR("applyguildreward.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-129.69, 147.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_4",
      res = "UI/alpha/HVGA/money_guildtoken_small.png",
      name = "icon_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-59.38, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_4",
      z = 1,
      parent = "board_container_4",
      text = "200",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-39.06, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5625, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_4",
      res = "UI/alpha/HVGA/guild/guildraid_select_frame.png",
      name = "check_bg_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_4",
      res = "UI/alpha/HVGA/fragment_tick.png",
      name = "check_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 413.28123292969, h = 49.453146632813},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_3",
      res = "UI/alpha/HVGA/tip_detail_bg.png",
      name = "board_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3.13, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 188, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_3",
      z = 1,
      parent = "board_container_3",
      text = T(LSTR("applyguildreward.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-129.69, 147.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_3",
      res = "UI/alpha/HVGA/money_guildtoken_small.png",
      name = "icon_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-59.38, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_3",
      z = 1,
      parent = "board_container_3",
      text = "100",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-39.06, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5625, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_3",
      res = "UI/alpha/HVGA/guild/guildraid_select_frame.png",
      name = "check_bg_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_3",
      res = "UI/alpha/HVGA/fragment_tick.png",
      name = "check_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 413.28123292969, h = 49.453146632813},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_2",
      res = "UI/alpha/HVGA/tip_detail_bg.png",
      name = "board_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3.13, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 188, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_2",
      z = 1,
      parent = "board_container_2",
      text = T(LSTR("applyguildreward.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-129.69, 147.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_2",
      res = "UI/alpha/HVGA/money_guildtoken_small.png",
      name = "icon_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-59.38, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_2",
      z = 1,
      parent = "board_container_2",
      text = "50",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-39.06, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5625, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_2",
      res = "UI/alpha/HVGA/guild/guildraid_select_frame.png",
      name = "check_bg_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_2",
      res = "UI/alpha/HVGA/fragment_tick.png",
      name = "check_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 413.28123292969, h = 49.453146632813},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_1",
      res = "UI/alpha/HVGA/tip_detail_bg.png",
      name = "board_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3.13, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 188, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_1",
      z = 1,
      parent = "board_container_1",
      text = T(LSTR("applyguildreward.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-129.69, 147.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_1",
      res = "UI/alpha/HVGA/money_guildtoken_small.png",
      name = "icon_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-59.38, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_1",
      z = 1,
      parent = "board_container_1",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-39.06, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5625, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_1",
      res = "UI/alpha/HVGA/guild/guildraid_select_frame.png",
      name = "check_bg_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 146.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "board_container_1",
      res = "UI/alpha/HVGA/fragment_tick.png",
      name = "check_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.19, 145.31)
    }
  }
}

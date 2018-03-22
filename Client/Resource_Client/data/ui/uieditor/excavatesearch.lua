ed.uieditor = ed.uieditor or {}
ed.uieditor.excavatesearch = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 800, h = 481.25},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/bg.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 239.84)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 100.78125, h = 102.34375},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/excavate/excavate_magnifier.png",
      name = "search_icon",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 254.69)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(800, 480.47),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "frame_container",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-3.13, 3.91)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(117.19, 53.13),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "histroy_button",
      z = 10,
      capInsets = CCRectMake(15.63, 15.63, 18.75, 18.75),
      text = "",
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.69, 81.25)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(66.41, 53.13),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      name = "explain_button",
      z = 10,
      capInsets = CCRectMake(15.63, 15.63, 18.75, 18.75),
      text = "",
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250.78, 81.25)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 702.34375, h = 392.96875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame_container",
      res = "UI/alpha/HVGA/excavate/excavate_empty.jpg",
      name = "frame_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 217.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 733.59375, h = 454.6875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame_container",
      res = "UI/alpha/HVGA/excavate/excavate_main_frame.png",
      name = "frame",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 233.59)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 246.09375, h = 35.9375},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame_container",
      res = "UI/alpha/HVGA/excavate/excavate_main_title.png",
      name = "title",
      z = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 431.25)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      --fix_wh = {w = 57.8125, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/backbtn.png",
      name = "back_button",
      z = 11,
      parent = "frame_container",
      text = "",
      press = "UI/alpha/HVGA/backbtn-disabled.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.63, 434.38)
    }
  },
  {
    config = {
      visible = true,
      opacity = 200,
      scaleSize = CCSizeMake(171.88, 101.56),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(23.44, 23.44, 19.53, 19.53),
      res = "UI/alpha/HVGA/crusade/crusade_reset_bg.png",
      name = "search_frame",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(637.5, 99.22)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(234, 225, 205),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "history_button_label",
      z = 1,
      parent = "histroy_button",
      text = T(LSTR("EXCAVATEHISTORY.DEFENSIVE_RECORD")),
      fontinfo = "normal_button",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.59, 28.13)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(234, 225, 205),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "explain_button_label",
      z = 1,
      parent = "explain_button",
      text = T(LSTR("EXCAVATEMAP.RULES")),
      fontinfo = "normal_button",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.2, 28.13)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 16.40625, h = 17.1875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "histroy_button",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      name = "history_red_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.16, 42.97)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(39.06, 39.06),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "search_frame",
      name = "search_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(85.94, 54.69)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(140.63, 50.78),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/tavern_button_1.png",
      capInsets = CCRectMake(21.88, 19.53, 73.44, 20.31),
      name = "search_button",
      z = 0,
      parent = "search_container",
      text = "",
      press = "UI/alpha/HVGA/tavern_button_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.78, -21.88)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 33.59375, h = 31.25},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "search_container",
      res = "UI/alpha/HVGA/goldicon_small.png",
      name = "gold_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-28.91, 22.66)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 174, 53),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "cost_label",
      z = 0,
      parent = "search_container",
      text = "10000",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(48.44, 24.22)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 140.8437778125, h = 52.5536484375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/excavate/excavate_icon_search_1.png",
      name = "search_label",
      z = 1,
      parent = "search_button",
      text = "",
      press = "UI/alpha/HVGA/excavate/excavate_icon_search_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.31, 25.39)
    }
  }
}

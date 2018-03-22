ed.uieditor = ed.uieditor or {}
ed.uieditor.excavatemap = {
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
      visible = false,
      opacity = 255,
      fix_wh = {w = 100.78125, h = 102.34375},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/excavate/excavate_magnifier.png",
      name = "search_icon",
      z = 15
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
      fix_wh = {w = 42.96875, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/prevchap.png",
      name = "left_button",
      z = 10,
      text = "",
      press = "UI/alpha/HVGA/prevchap-mask.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.28, 217.19)
    }
  },
  {
    config = {
      visible = true,
      flip = "x",
      fix_wh = {w = 42.96875, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = "x"}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/prevchap.png",
      name = "right_button",
      z = 10,
      text = "",
      press = "UI/alpha/HVGA/prevchap-mask.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(735.94, 217.97)
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
      res = "UI/alpha/HVGA/excavate/excavate_main_bg.png",
      name = "frame_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 235.16)
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
      z = 20
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
      fix_wh = {w = 339.84375, h = 37.5},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame_container",
      res = "UI/alpha/HVGA/excavate/excavate_name_diamond_1.png",
      name = "title",
      z = 24
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
      z = 30,
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
      opacity = 255,
      scaleSize = CCSizeMake(78.13, 78.13),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "frame_container",
      name = "page_tag_container",
      z = 30
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(416.41, 81.25)
    }
  },
  {
    config = {
      visible = true,
      opacity = 0,
      fix_wh = {w = 702.34375, h = 392.96875},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/excavate/excavate_fog.png",
      name = "search_fog",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396.88, 220.31)
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
      parent = "frame_container",
      name = "info_layer",
      z = 15
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      capInsets = CCRectMake(15.63, 15.63, 18.75, 18.75),
      name = "explain_button",
      z = 0,
      parent = "info_layer",
      text = "",
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250.78, 80.47)
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
      capInsets = CCRectMake(15.63, 15.63, 18.75, 18.75),
      name = "histroy_button",
      z = 0,
      parent = "info_layer",
      text = "",
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.69, 80.47)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(281.25, 99.22),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "explain_bg",
      z = 5,
      parent = "info_layer",
      res = "UI/alpha/HVGA/excavate/excavate_info_bg.png",
      capInsets = CCRectMake(132.81, 44.53, 89.84, 31.25)
    },
    layout = {
      anchor = ccp(1, 1),
      position = ccp(742.97, 400.78)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(210.94, 30.47),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "tag_bg",
      z = 1,
      parent = "page_tag_container",
      res = "UI/alpha/HVGA/excavate/excavate_cycle_bg.png",
      capInsets = CCRectMake(15.63, 0, 12.5, 29.69)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 30.46875, h = 30.46875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "page_tag_container",
      res = "UI/alpha/HVGA/excavate/excavate_cycle_mask_right.png",
      name = "tag_shade_right",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.41, 0)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 30.46875, h = 30.46875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "page_tag_container",
      res = "UI/alpha/HVGA/excavate/excavate_cycle_mask_left.png",
      name = "tag_shade_left",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-91.41, 0)
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
      name = "research_frame",
      z = 0,
      parent = "info_layer",
      res = "UI/alpha/HVGA/crusade/crusade_reset_bg.png",
      capInsets = CCRectMake(23.44, 23.44, 19.53, 19.53)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(637.5, 99.22)
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
      parent = "info_layer",
      name = "explain_container",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(601.56, 351.56)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "explain_container",
      name = "lack_label_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-106.25, -4.69)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "explain_container",
      name = "speed_label_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-105.47, -38.28)
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
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.38, 42.97)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "lack_label_title",
      z = 0,
      parent = "lack_label_container",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(85.94, 23.44)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "speed_label_title",
      z = 0,
      parent = "speed_label_container",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(85.94, 23.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "explain_container",
      name = "count_time_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-106.25, -72.66)
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
      parent = "research_frame",
      name = "research_container",
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
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "count_time_label",
      z = 0,
      parent = "count_time_container",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 23.44)
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
      name = "research_button",
      z = 0,
      parent = "research_container",
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
      parent = "research_container",
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
      parent = "research_container",
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
      visible = false,
      opacity = 255,
      fix_wh = {w = 33.59375, h = 31.25},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "lack_label_container",
      res = "UI/alpha/HVGA/goldicon_small.png",
      name = "lack_icon_gold",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 23.44)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 33.59375, h = 31.25},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "speed_label_container",
      res = "UI/alpha/HVGA/goldicon_small.png",
      name = "speed_icon_gold",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 22.66)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 33.59375, h = 32.03125},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "lack_label_container",
      res = "UI/alpha/HVGA/shop_token_icon.png",
      name = "lack_icon_diamond",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 20.31)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 33.59375, h = 32.03125},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "speed_label_container",
      res = "UI/alpha/HVGA/shop_token_icon.png",
      name = "speed_icon_diamond",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 19.53)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 25.78125, h = 30.46875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "lack_label_container",
      res = "UI/alpha/HVGA/excavate/excavate_exp_icon.png",
      name = "lack_icon_exp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 23.44)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 25.78125, h = 30.46875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "speed_label_container",
      res = "UI/alpha/HVGA/excavate/excavate_exp_icon.png",
      name = "speed_icon_exp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.66, 22.66)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "lack_number_label",
      z = 1,
      parent = "lack_label_container",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121.09, 23.44)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "speed_number_label",
      z = 0,
      parent = "speed_label_container",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121.09, 23.44)
    }
  },
  {
    config = {
      visible = false,
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
      parent = "research_button",
      text = "",
      press = "UI/alpha/HVGA/excavate/excavate_icon_search_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.31, 25.39)
    }
  },
  {
    config = {
      visible = false,
      flip = "",
      fix_wh = {w = 141.328125, h = 52.734375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/excavate/excavate_icon_another_1.png",
      name = "research_label",
      z = 0,
      parent = "research_button",
      text = "",
      press = "UI/alpha/HVGA/excavate/excavate_icon_another_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.31, 25.39)
    }
  }
}

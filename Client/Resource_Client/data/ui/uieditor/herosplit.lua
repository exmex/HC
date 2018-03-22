ed.uieditor = ed.uieditor or {}
ed.uieditor.herosplit = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 702.34375, h = 447.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/heroresolve/hero_resolve_frame.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 240.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 57.8125, h = 58.59375},
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
      normal = "UI/alpha/HVGA/herodetail-detail-close.png",
      name = "close_button",
      z = 1,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/herodetail-detail-close-p.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(679.3, 419.92)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.13, 53.13),
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
      capInsets = CCRectMake(15.63, 15.63, 19.53, 19.53),
      name = "select_hero_button",
      z = 2,
      parent = "frame",
      text = T(LSTR("EATEXPLIST.CHOOSE_A_HERO")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.98, 273.05)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.13, 53.13),
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
      capInsets = CCRectMake(15.63, 15.63, 19.53, 19.53),
      name = "explain_button",
      z = 4,
      parent = "frame",
      text = T(LSTR("herosplit.1.10.1.001")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.98, 44.14)
    }
  },
  {
    config = {
      rotation = 90,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.90625, h = 21.875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/fragment_compose_arrow.png",
      name = "convert_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.98, 223.83)
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
      name = "select_stone_button_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(351.17, 223.83)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(78.13, 78.13)
    },
    t = "Layer",
    base = {
      parent = "frame",
      name = "detail_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(351.17, 223.83)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.13, 53.13),
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
      capInsets = CCRectMake(15.63, 15.63, 19.53, 19.53),
      name = "select_stone_button",
      z = 0,
      parent = "select_stone_button_container",
      text = T(LSTR("herosplit.1.10.1.002")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-267.19, -130.47)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.91, 49.22),
      flip = "",
      labelConfig = {
        color = ccc3(254, 244, 16)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/task_button.png",
      capInsets = CCRectMake(15.63, 15.63, 39.06, 15.63),
      name = "select_hero_button_light",
      z = 4,
      parent = "frame",
      text = T(LSTR("EATEXPLIST.CHOOSE_A_HERO")),
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.98, 273.83)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 455, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "detail_container",
      res = "UI/alpha/HVGA/chat/chat_delimeter.png",
      name = "delimeter",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.22, 68.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 506.25, h = 34.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "detail_container",
      res = "UI/alpha/HVGA/task_title_bg.png",
      name = "title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.47, 189.84)
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
      name = "title_label",
      z = 2,
      parent = "detail_container",
      text = T(LSTR("herosplit.1.10.1.003")),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.47, 189.84)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.91, 49.22),
      flip = "",
      labelConfig = {
        color = ccc3(254, 244, 16)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/task_button.png",
      capInsets = CCRectMake(15.63, 15.63, 39.06, 15.63),
      name = "select_stone_button_light",
      z = 0,
      parent = "select_stone_button_container",
      text = T(LSTR("herosplit.1.10.1.002")),
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-267.19, -130.47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(57, 44, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_1",
      z = 2,
      parent = "detail_container",
      text = T(LSTR("herosplit.1.10.1.004")),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-153.13, 160.94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(57, 44, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_2",
      z = 4,
      parent = "detail_container",
      text = T(LSTR("herosplit.1.10.1.005")),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-153.13, 55.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(511.72, 167.97)
    },
    t = "Scale9Sprite",
    base = {
      name = "list_bg",
      z = 2,
      parent = "detail_container",
      res = "UI/alpha/HVGA/equipupgrade/equipupgrade_bottom_bg.png",
      capInsets = CCRectMake(14.06, 15.63, 640.63, 136.72)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, -67.97)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(128.91, 49.22),
      flip = "",
      labelConfig = {
        color = ccc3(254, 244, 16)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/task_button.png",
      capInsets = CCRectMake(15.63, 15.63, 39.06, 15.63),
      name = "split_button",
      z = 2,
      parent = "detail_container",
      text = T(LSTR("heropackage.1.10.1.001")),
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.06, -179.69)
    }
  }
}

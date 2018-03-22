ed.uieditor = ed.uieditor or {}
ed.uieditor.setuplist = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 445.3125, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.88, 305.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 445.3125, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.88, 239.84)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 445.3125, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter_3",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.88, 172.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 445.3125, h = 2.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
      name = "delimeter_4",
      z = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.88, 107.03)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_left_1",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.78, 157.81)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_right_1",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(234.38, 157.81)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_left_2",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.56, 92.19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_right_2",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(234.38, 92.19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_left_3",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.56, 28.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_right_3",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(234.38, 28.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_left_4",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.56, -38.00)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(544.53, 373.44)
    },
    t = "Layer",
    base = {
      name = "switch_container_right_4",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(234.38, -38.00)
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
      name = "left_label_1_1",
      z = 1,
      parent = "switch_container_left_1",
      text = "12:00",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
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
      name = "left_label_4_1",
      z = 1,
      parent = "switch_container_right_1",
      text = "9:00",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
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
      name = "left_label_2_1",
      z = 1,
      parent = "switch_container_left_2",
      text = "18:00",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
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
      name = "left_label_5_1",
      z = 1,
      parent = "switch_container_right_2",
      text = "21:00",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_7",
      z = 1,
      parent = "switch_container_left_4",
      text = T(LSTR("LOCALNOTIFY.ARENA_REWARD_PUSH_TITLE")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_8",
      z = 1,
      parent = "switch_container_right_4",
      text = T(""),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.56, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_1_2",
      z = 2,
      parent = "switch_container_left_1",
      text = T(LSTR("PLAYERINFO.CLAIM_ENERGY")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.06, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_4_2",
      z = 2,
      parent = "switch_container_right_1",
      text = T(LSTR("PLAYERINFO.STORE_REFRESH")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.06, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_2_2",
      z = 2,
      parent = "switch_container_left_2",
      text = T(LSTR("PLAYERINFO.CLAIM_ENERGY")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.06, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_5_2",
      z = 2,
      parent = "switch_container_right_2",
      text = T(LSTR("PLAYERINFO.CLAIM_ENERGY")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.06, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_3",
      z = 2,
      parent = "switch_container_left_3",
      text = T(LSTR("PLAYERINFO.FULL_ENERGY_RECOVERY_NOTICE")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.78, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_label_6",
      z = 2,
      parent = "switch_container_right_3",
      text = T(LSTR("PLAYERINFO.SKILL_POINTS_BACK_FULL_NOTICE")),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.53, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_1",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_1",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237.5, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_1",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_1",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237.5, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_1",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_4",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_1",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_4",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_2",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_2",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_2",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_2",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_2",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_5",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_2",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_5",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_3",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_3",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_3",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_3",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 177.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_3",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_6",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_3",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_6",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_4",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_7",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_left_4",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_7",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_4",
      res = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
      name = "switch_open_8",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.625, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_container_right_4",
      res = "UI/alpha/HVGA/playerinfo_button_notice_close.png",
      name = "switch_close_8",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.34, 178.13)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
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
      normal = "UI/alpha/HVGA/shop_refresh_button.png",
      name = "sound",
      z = 1,
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      text = "",
      press = "UI/alpha/HVGA/shop_refresh_button_down.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.03, 439.84)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/shop_refresh_button.png",
      name = "cdkey",
      z = 0,
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      text = "",
      press = "UI/alpha/HVGA/shop_refresh_button_down.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.81, 438.28)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/shop_refresh_button.png",
      name = "blacklist",
      z = 1,
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      text = "",
      press = "UI/alpha/HVGA/shop_refresh_button_down.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.03, 380.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 527.5, h = 34.375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/task_title_bg.png",
      name = "notice_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 381.25)
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
      size = 18,
      text = T(LSTR("PLAYERINFO.NEWS_ALERT")),
      name = "notice_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.78, 382.81)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/playerinfo_button_sound_off_1.png",
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      name = "sound_off",
      z = 0,
      parent = "sound",
      text = "",
      press = "UI/alpha/HVGA/playerinfo_button_sound_off_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.41, 29.3)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
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
      normal = "UI/alpha/HVGA/playerinfo_button_sound_on_1.png",
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      name = "sound_on",
      z = 0,
      parent = "sound",
      text = "",
      press = "UI/alpha/HVGA/playerinfo_button_sound_on_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.41, 29.3)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/playerinfo_button_redeem_1.png",
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      name = "cd_key_label",
      z = 0,
      parent = "cdkey",
      text = "",
      press = "UI/alpha/HVGA/playerinfo_button_redeem_1.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.97, 28.52)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(181.25, 58.59),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/chat/playerinfo_button_blacklist_1.png",
      capInsets = CCRectMake(19.53, 15.63, 74.22, 19.53),
      name = "blacklist1",
      z = 0,
      parent = "blacklist",
      text = "",
      press = "UI/alpha/HVGA/chat/playerinfo_button_blacklist_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.41, 29.3)
    }
  }
}

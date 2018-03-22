ed.uieditor = ed.uieditor or {}
ed.uieditor.excavateteam = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(632.81, 242.19)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17.97, 18.75, 46.88, 11.72),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 219.53)
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
      name = "frame_container",
      z = 12
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(316.41, 142.97)
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
      z = 0,
      parent = "frame_container",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.13, 82.81)
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
      parent = "frame_container",
      name = "player_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.69, -3.13)
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
      parent = "frame_container",
      name = "team_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -8.59)
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
      parent = "frame_container",
      name = "vitality_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.53, -2.34)
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
      parent = "frame_container",
      name = "explain_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.81, 0)
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
      parent = "frame_container",
      name = "guild_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 41.41)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 46.88)
    },
    t = "Layer",
    base = {
      parent = "explain_container",
      name = "lack_label_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-249.22, -132.03)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 46.88)
    },
    t = "Layer",
    base = {
      parent = "explain_container",
      name = "speed_label_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-22.66, -132.03)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_title",
      z = 0,
      parent = "guild_container",
      text = T(LSTR("EXCAVATETEAM.FROM_GUILD_")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-273.44, -150)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lack_label_title",
      z = 0,
      parent = "lack_label_container",
      text = T(LSTR("EXCAVATETEAM.CUMULATIVE_PRODUCTION_RESOURCES_")),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(88.28, 23.44)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "speed_label_title",
      z = 0,
      parent = "speed_label_container",
      text = T(LSTR("EXCAVATEMAP.PRODUCTION_SPEED_")),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(85.94, 23.44)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 192, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality_title",
      z = 1,
      parent = "vitality_container",
      text = T(LSTR("STAGEDETAIL.PHYSICAL_EXERTION")),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(174.22, 57.03)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.703125, h = 34.453125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "vitality_container",
      res = "UI/alpha/HVGA/vitalityicon.png",
      name = "vitality_icon",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.44, 24.22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 197),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality_number",
      z = 2,
      parent = "vitality_container",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(225.78, 23.44)
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
      parent = "team_container",
      name = "cg_button_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 5.47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 237, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name",
      z = 1,
      parent = "guild_container",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-215.63, -149.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(62.5, 62.5)
    },
    t = "Layer",
    base = {
      parent = "player_container",
      name = "head_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-285.16, 23.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(39.06, 31.25)
    },
    t = "Layer",
    base = {
      parent = "player_container",
      name = "level_container",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-217.97, 41.41)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 329.6875, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_container",
      res = "UI/alpha/HVGA/task_name_bg.png",
      name = "name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.25, 55.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85.94, 85.94)
    },
    t = "Layer",
    base = {
      parent = "team_container",
      name = "hero_container_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-281.25, -74.22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85.94, 85.94)
    },
    t = "Layer",
    base = {
      parent = "team_container",
      name = "hero_container_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-188.28, -73.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85.94, 85.94)
    },
    t = "Layer",
    base = {
      parent = "team_container",
      name = "hero_container_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-96.88, -73.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85.94, 85.94)
    },
    t = "Layer",
    base = {
      parent = "team_container",
      name = "hero_container_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-4.69, -73.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85.94, 85.94)
    },
    t = "Layer",
    base = {
      parent = "team_container",
      name = "hero_container_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(85.16, -73.44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 100, h = 96.09375},
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
      normal = "UI/alpha/HVGA/startbtn.png",
      name = "go_battle_button",
      z = 0,
      parent = "team_container",
      text = "",
      press = "UI/alpha/HVGA/startbtn-disabled.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(233.59, -32.81)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.59375, h = 31.25},
      visible = false
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
      position = ccp(101.56, 23.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.59375, h = 31.25},
      visible = false
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
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.59375, h = 32.03125},
      visible = false
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
      position = ccp(101.56, 20.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.59375, h = 32.03125},
      visible = false
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
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.78125, h = 30.46875},
      visible = false
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
      position = ccp(101.56, 23.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.78125, h = 30.46875},
      visible = false
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
      name = "lack_number_label",
      z = 1,
      parent = "lack_label_container",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(125, 23.44)
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
      rotation = 0,
      scaleSize = CCSizeMake(125, 49.22),
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
      normal = "UI/alpha/HVGA/task_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "change_team_button",
      z = 0,
      parent = "cg_button_container",
      text = T(LSTR("EXCAVATETEAM.ADJUST_FORMATION")),
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, -11.72)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 49.22),
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
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "give_up_button",
      z = 0,
      parent = "cg_button_container",
      text = T(LSTR("excavateteam.1.10.1.002")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.72, -65.63)
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
      name = "name",
      z = 1,
      parent = "name_bg",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.41, 13.28)
    }
  }
}

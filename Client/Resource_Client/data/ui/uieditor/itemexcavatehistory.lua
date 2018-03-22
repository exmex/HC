ed.uieditor = ed.uieditor or {}
ed.uieditor.itemexcavatehistory = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(514.06, 74.22)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(67.97, 36.72, 265.63, 60.94),
      res = "UI/alpha/HVGA/equip_detail_panel_bg.png",
      name = "board",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.03, 34.38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.90625, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_win.png",
      name = "tag_win",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.34, 50.78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.90625, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_lose.png",
      name = "tag_lose",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.34, 50.78)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(65, 57, 54),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 16,
      text = "",
      name = "time_label",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.22, 20.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 100,
      fix_wh = {w = 329.6875, h = 26.5625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/task_name_bg.png",
      name = "enemy_name_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.78, 50)
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
      size = 16,
      text = "",
      name = "enemy_name_label",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.22, 52.34)
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
      normal = "UI/alpha/HVGA/excavate/excavate_history_button_detail_1.png",
      name = "check_button",
      z = 1,
      text = "",
      press = "UI/alpha/HVGA/excavate/excavate_history_button_detail_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 35.16)
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
      normal = "UI/alpha/HVGA/excavate/excavate_history_button_vit_1.png",
      name = "vit_button",
      z = 1,
      text = "",
      press = "UI/alpha/HVGA/excavate/excavate_history_button_vit_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(416.41, 34.38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.40625, h = 17.1875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "vit_button",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      name = "red_tag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 49.61)
    }
  }
}

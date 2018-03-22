ed.uieditor = ed.uieditor or {}
ed.uieditor.excavateinvite = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(424.22, 300)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(27.34, 31.25, 371.09, 121.09),
      res = "UI/alpha/HVGA/pvp/pvp_replay_share_bg.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 258.59)
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
      name = "window_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(212.11, 146.09)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 369.53125, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "window_container",
      res = "UI/alpha/HVGA/pvp/pvp_replay_share_input.png",
      name = "edit_frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1.56, -38.28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "invite_title",
      z = 2,
      parent = "window_container",
      text = T(LSTR("EXCAVATEINVITE.YOU_CAN_NOT_HOLD_ONTO_THIS_SINGLE_BIG_TREASURE_WHETHER_TO_INVITE_THE_ASSOCIATION_OF_SMALL_MINING_PARTNERS_TOGETHER")),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-178.13, 122.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(234.38, 31.25)
    },
    t = "Layer",
    base = {
      parent = "window_container",
      name = "excavate_name_container",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-177.34, 56.25)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(121.09, 54.69),
      flip = "",
      labelConfig = {
        color = ccc3(239, 230, 209)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "ok_button",
      z = 0,
      parent = "window_container",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.69, -110.94)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(121.09, 54.69),
      flip = "",
      labelConfig = {
        color = ccc3(239, 230, 209)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "cancel_button",
      z = 0,
      parent = "window_container",
      text = T(LSTR("CHATCONFIG.CANCEL")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      fontinfo = "ui_normal_button"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-82.81, -110.94)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(74.22, 54.69),
      flip = "",
      labelConfig = {
        color = ccc3(239, 230, 209)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "change_button",
      z = 0,
      parent = "window_container",
      text = T(LSTR("GUILDCONFIG.CHANGE")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.38, 19.53)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 395.625, h = 58.4375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "window_container",
      res = "UI/alpha/HVGA/task_name_bg.png",
      name = "target_bg",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.84, 20.31)
    }
  }
}

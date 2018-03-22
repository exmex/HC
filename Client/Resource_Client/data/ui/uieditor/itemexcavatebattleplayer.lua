ed.uieditor = ed.uieditor or {}
ed.uieditor.itemexcavatebattleplayer = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 290.625, h = 101.5625},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/chat/chat_replay_bg.png",
      name = "board",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.69, 60.16)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 28.90625, h = 50},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_lose.png",
      name = "tag_lose",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.06, 89.06)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 28.90625, h = 50},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pvp/pvp_win.png",
      name = "tag_win",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.06, 89.06)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "icon_container",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(52.34, 68.75)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(35.16, 31.25),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "level_container",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(100, 73.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 164.84375, h = 26.5625},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/task_name_bg.png",
      name = "name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.03, 90.63)
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
      size = 21,
      text = "",
      name = "name_label",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(137.5, 92.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "hicon_container_5",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(238.28, 17.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "hicon_container_4",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(185.16, 17.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "hicon_container_3",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(132.03, 17.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "hicon_container_2",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.91, 17.19)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(46.88, 46.88),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "hicon_container_1",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 17.19)
    }
  }
}

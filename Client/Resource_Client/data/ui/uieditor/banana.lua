ed.uieditor = ed.uieditor or {}
ed.uieditor.banana = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 800, h = 480.46875},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/bg.jpg",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 239.06)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 57.8125, h = 58.59375},
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
      z = 2,
      text = "",
      press = "UI/alpha/HVGA/backbtn-disabled.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.63, 425)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(351.56, 343.75),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 19.53, 19.53),
      res = "UI/alpha/HVGA/dailylogin/dailylogin_reward_bg.png",
      name = "matrix_bg",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(408.59, 190.63)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 156.25),
      flip = ""
    },
    t = "Layer",
    base = {
      name = "arrow_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(592.19, 26.56)
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
      parent = "arrow_container",
      name = "down",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "arrow_container",
      name = "up",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 109.38)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(78.13, 62.5),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "arrow_container",
      name = "left",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 47.66)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(78.13, 62.5),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "arrow_container",
      name = "right",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.13, 46.88)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 50.78125, h = 35.9375},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "down",
      res = "UI/alpha/HVGA/tutorial_arrow_down.png",
      name = "down_button",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.13, 23.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 50.78125, h = 35.9375},
      flip = "y"
    },
    t = "Sprite",
    base = {
      parent = "up",
      res = "UI/alpha/HVGA/tutorial_arrow_down.png",
      name = "up_button",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.13, 23.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 35.9375, h = 48.4375},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "left",
      res = "UI/alpha/HVGA/tutorial_arrow_left.png",
      name = "left_button",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.53, 31.25)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 35.9375, h = 48.4375},
      flip = "x"
    },
    t = "Sprite",
    base = {
      parent = "right",
      res = "UI/alpha/HVGA/tutorial_arrow_left.png",
      name = "right_button",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.59, 31.25)
    }
  }
}

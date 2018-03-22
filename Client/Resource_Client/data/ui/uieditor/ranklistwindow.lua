ed.uieditor = ed.uieditor or {}
ed.uieditor.ranklistwindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 800, h = 481.25},
      visible = true
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
      normal = "UI/alpha/HVGA/backbtn.png",
      name = "back_button",
      z = 0,
      text = "",
      press = "UI/alpha/HVGA/backbtn-disabled.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.28, 439.06)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      --scaleSize = CCSizeMake(558.59, 39.06)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(203.13, 19.53, 117.19, 19.53),
      res = "UI/alpha/HVGA/ranklist/ranklist_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399.22, 439.06),
	visible=false
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(722, 400.25)
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/ranklist/ranklist_bg.png",
      name = "window",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 216)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.84375, h = 58.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail_arrow_left.png",
      name = "left_arrow",
      z = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.13, 21700.19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.84375, h = 58.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail_arrow_right.png",
      name = "right_arrow",
      z = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(672.66, 21700.19)
    }
  }
}

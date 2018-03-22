ed.uieditor = ed.uieditor or {}
ed.uieditor.itemexcavatebattlereport = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(314.84, 11.72)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(74.22, 11.72, 82.03, 11.72),
      res = "UI/alpha/HVGA/herodetail-title-mark.png",
      name = "title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.28, 135.94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 210, 17),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 23,
      text = "",
      name = "title_label",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.84, 135.16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(312.5, 125)
    },
    t = "Layer",
    base = {
      name = "right_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(315.63, -0.78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(312.5, 125)
    },
    t = "Layer",
    base = {
      name = "left_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.53125, h = 36.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/chat/chat_replay_vs.png",
      name = "vs_icon",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.28, 63.28)
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
      normal = "UI/alpha/HVGA/pvp/pvp_button_replay_1.png",
      name = "replay_button",
      z = 2,
      text = "",
      press = "UI/alpha/HVGA/pvp/pvp_button_replay_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(650, 63.28)
    }
  }
}

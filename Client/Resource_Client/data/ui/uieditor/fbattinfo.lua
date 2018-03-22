ed.uieditor = ed.uieditor or {}
ed.uieditor.fbattinfo = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 250)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(35.16, 82.03, 281.25, 62.5),
      res = "UI/alpha/HVGA/dialog_bg.png",
      name = "frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 239.84)
    }
  },
	{
	 t = "Label",
    base = {text = T(LSTR("FBATTINFO.CONTENT")), 
	parent="frame",
	name="titlebasic",
	z="0",
	size = 20},
    layout = {
     position =ccp(225, 220),
	 anchor = ccp(0.5, 1),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
	{
	 t = "Label",
    base = {text = T(LSTR("FBATTINFO.REWORD")), 
	parent="frame",
	name="titlebasic",
	z="0",
	size = 20},
    layout = {
     position =ccp(225, 177),
	 anchor = ccp(0.5, 1),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 400, h = 3.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/dialog_line.png",
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225, 90)
    }
  },
{
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
	  scale = 0.7
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/recharge_diamond_icon_3.png",
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 135)
    }
  },
{
	 t = "Label",
    base = {text = 50, 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 16},
    layout = {
     position =ccp(167, 128),
	 anchor = ccp(0.5, 1),
    },
    config = {
      color = ccc3(234, 225, 205),
	  visible="true"
    }
	},
{
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
	  scale = 0.75
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/ITEM/502.png",
      name = "delimiter",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219, 135)
    }
  },
{
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
	  scale = 0.75
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/equip_frame_green.png",
      name = "trrrrrr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219, 135)
    }
  },
{
	 t = "Label",
    base = {text = 20, 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 16},
    layout = {
     position =ccp(236, 128),
	 anchor = ccp(0.5, 1),
    },
    config = {
      color = ccc3(234, 225, 205),
	  visible="true"
    }
	},
{
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
	  scale = 0.7,
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_gold_icon.png",
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 135)
    }
  },
{
	 t = "Label",
    base = {text = 20000, 
	parent="frame",
	name="titlebasic",
	z="0",
	size = 16},
    layout = {
     position =ccp(292, 128),
	 anchor = ccp(0.5, 1),
    },
    config = {
      color = ccc3(234, 225, 205),
	  visible="true"
    }
	},
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 54.69),
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
      name = "ok_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("FBATTINFO.ATTENTION")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 51.8)
    }
  },
{
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 54.69),
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
      normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
      name = "cancel_button",
      z = 10,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 225)
    }
  }
}

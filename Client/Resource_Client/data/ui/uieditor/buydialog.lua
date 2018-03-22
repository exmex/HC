ed.uieditor = ed.uieditor or {}
ed.uieditor.buydialog = {
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
    base = {text = T(LSTR("BUYCONFIRM.BASIC")), 
	parent="frame",
	name="titlebasic",
	z="0",
	size = 20},
    layout = {
      position =ccp(40, 210),
	 anchor = ccp(0, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
		{
	 t = "Label",
    base = {text = T(LSTR("BUYCONFIRM.BONUS")), 
	name="titlebonus",
	parent="frame",
	z="0",
	size = 20},
    layout = {
      position =ccp(40, 180),
	 anchor = ccp(0, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
	{
	 t = "Label",
    base = {text = T(LSTR("BUYCONFIRM.TOTAL")), 
	parent="frame",
	name="titletotal",
	z="0",
	size = 20},
    layout = {
      position =ccp(40, 130),
	 anchor = ccp(0, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},{
		 t = "Label",
    base = {text = T(LSTR("BUYCONFIRM.VIPPOINT")), 
	parent="frame",
	name="titlevippoint",
	z="0",
	size = 20},
    layout = {
      position =ccp(40, 100),
	 anchor = ccp(0, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
	{
	 t = "Label",
    base = {text = "", 
	parent="frame",
	name="bonusgem",
	z="0",
	size = 20},
    layout = {
      position =ccp(385, 180),
	 anchor = ccp(1, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
		{
	 t = "Label",
    base = {text = "400 gems", 
	parent="frame",
	name="basicgem",
	z="0",
	size = 20},
    layout = {
      position =ccp(385, 210),
	 anchor = ccp(1, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
	{
	 t = "Label",
    base = {text = "400 gems", 
	parent="frame",
	name="totalgem",
	z="0",
	size = 20},
    layout = {
      position =ccp(385, 130),
	 anchor = ccp(1, 0.5),
    },
    config = {
      color = ccc3(255, 208, 18),
	visible="true"
    }
	},
	{
	 t = "Label",
    base = {text = "400 gems", 
	parent="frame",
	name="vippoint",
	z="0",
	size = 20},
    layout = {
      position =ccp(410, 100),
	 anchor = ccp(1, 0.5),
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
      position = ccp(225, 80)
    }
  },
  {
    config = {
      visible = true,
	 scaleSize = CCSizeMake(50, 30)
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_rmb_icon_3.png",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410, 213)
    }
  },
 {
    config = {
      visible = true,
	 scaleSize = CCSizeMake(50, 30)
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_rmb_icon_3.png",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410, 183)
    }
  },
 {
    config = {
      visible = true,
	 scaleSize = CCSizeMake(50, 30)
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_rmb_icon_3.png",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410, 133)
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
      text = T(LSTR("BUYCONFIRM.BUY")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 41.8)
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
      name = "cancel_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("BUYCONFIRM.CANCEL")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 41.8)
    }
  }
}

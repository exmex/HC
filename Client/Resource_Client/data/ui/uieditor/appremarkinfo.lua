ed.uieditor = ed.uieditor or {}
 
ed.uieditor.appremarkinfo = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(580, 370)
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
      base = {
        text = T(LSTR("APPREMARK.TITLE")), 
	  parent="frame",
	  name="titlebasic",
	  z="1",
	  size = 21
    },
      layout = {
        position =ccp(290, 350),
	  anchor = ccp(0.5, 1),
    },
      config = {
        color = ccc3(255, 208, 18),
	  visible="true"
    }
  },
  {
         config = {
         scaleSize = CCSizeMake(380, 32)
    },
         t = "Scale9Sprite",
         base = {
           capInsets = CCRectMake(70, 7, 20, 10),
           parent = "frame",
           res = "UI/alpha/HVGA/tip_detail_bg.png",
           name = "delimiter",
           z = "0"
    },
         layout = {
         anchor = ccp(0.5, 1),
         position = ccp(290, 353)
    }
  },
	{
	 t = "Label",
       base = {text = reward_time[1], 
	   parent="frame",
	   name="titlebasic",
	   z="0",
	   size = 17
    },
       layout = {
         position =ccp(290, 316),
	   anchor = ccp(0.5, 1),
    },
       config = {
         color = ccc3(255, 208, 18),
	   visible="true"
    }
  },
  {
	 t = "Label",
       base = {text = T(LSTR("APPREMARK.CONTENT")), 
	   parent="frame",
	   name="titlecontent",
	   z="0",
	   size = 16
    },
       layout = {
         position =ccp(290, 290),
	   anchor = ccp(0.5, 1),
    },
       config = {
         color = ccc3(255, 208, 18),
	   visible="true"
    }
  },
  {
	 t = "Label",
       base = {text = T(LSTR("APPREMARK.REWARD1")), 
	   parent="frame",
	   name="titlebasic",
	   z="0",
	   size = 15
    },
       layout = {
         position =ccp(170, 195),
	   anchor = ccp(0.5, 1),
    },
       config = {
         color = ccc3(255, 208, 18),
	   visible="true"
    }
  },
  {
	 t = "Label",
       base = {text = T(LSTR("APPREMARK.REWARD2")), 
	   parent="frame",
	   name="titlebasic",
	   z="0",
	   size = 15
    },
       layout = {
         position =ccp(170, 165),
	   anchor = ccp(0.5, 1),
    },
       config = {
         color = ccc3(255, 208, 18),
	   visible="true"
    }
  },{
	 t = "Label",
       base = {text = T(LSTR("APPREMARK.REWARD3")), 
	   parent="frame",
	   name="titlebasic",
	   z="0",
	   size = 15
    },
       layout = {
         position =ccp(170, 135),
	   anchor = ccp(0.5, 1),
    },
       config = {
         color = ccc3(255, 208, 18),
	   visible="true"
    }
  },{
	 t = "Label",
       base = {text = T(LSTR("APPREMARK.REWARD4")), 
	   parent="frame",
	   name="titlebasic",
	   z="0",
	   size = 15
    },
       layout = {
         position =ccp(170, 105),
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
           fix_wh = {w = 500, h = 3.125},
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
         position = ccp(290, 72)
    }
  },
--[[{
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_50.res[1],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320, 188)
    }
  },
  {
	 t = "Label",
    base = {text = reward_50.num[1], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(332.1, 186.1),
	 anchor = ccp(1, 1),
    },
    config = {
      color = ccc3(234, 225, 205),
	  visible="true"
    }
	},
	 {
        t = "Scale9Sprite",
        base = {
          name = "rmb_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(434, 450)
        },
        config = {
          scaleSize = CCSizeMake(178, 48)
        }
      },
	
 {
  config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_50.res[2],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 188)
    }
  },
  {
	 t = "Label",
    base = {text = reward_50.num[2], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(382.1, 186.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_100.res[1],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320, 156)
    }
  },
   {
	 t = "Label",
    base = {text = reward_100.num[1], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(332.1, 154.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_100.res[2],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 156)
    }
  },
    {
	 t = "Label",
    base = {text = reward_100.num[2], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(382.1, 154.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_100.res[3],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420, 156)
    }
  },
    {
	 t = "Label",
    base = {text = reward_100.num[3], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(432.1, 154.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_300.res[1],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320, 124)
    }
  },
   {
	 t = "Label",
    base = {text = reward_300.num[1], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(332.1, 122.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_300.res[2],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 124)
    }
  },
   {
	 t = "Label",
    base = {text = reward_300.num[2], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(382.1, 122.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_300.res[3],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420, 124)
    }
  },
   {
	 t = "Label",
    base = {text = reward_300.num[3], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(432.1, 122.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_500.res[1],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320, 92)
    }
  },
   {
	 t = "Label",
    base = {text = reward_500.num[1], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(332.1, 90.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_500.res[2],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 92)
    }
  },
    {
	 t = "Label",
    base = {text = reward_500.num[2], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(382.1, 90.1),
	 anchor = ccp(1, 1),
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
	  scale = 0.4
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = reward_500.res[3],
      name = "delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420, 92)
    }
  },
    {
	 t = "Label",
    base = {text = reward_500.num[3], 
	parent="frame",
	name="titlebasic",
	z="1",
	size = 14},
    layout = {
     position =ccp(432.1, 90.1),
	 anchor = ccp(1, 1),
    },
    config = {
      color = ccc3(234, 225, 205),
	  visible="true"
    }
	},--]]
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 54.69),
      flip = "",
      labelConfig = {
        color = ccc3(234, 225, 205)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/sell_number_button.png",
      capInsets = CCRectMake(15.63, 15.63, 19.53, 15.63),
      name = "cancel_button",
      z = 0,
      parent = "frame",
      text = T(LSTR("APPREMARK.CANCEL")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 45.8)
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
      name = "close_button",
      z = 10,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(610, 345)
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
      text = T(LSTR("APPREMARK.OK")),
      press = "UI/alpha/HVGA/sell_number_button_down.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 40)
    }
  }
  
}

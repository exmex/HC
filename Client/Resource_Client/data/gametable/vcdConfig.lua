EDDefineTable("vcdConfig")
UIRes = {
  {
    layerName = "pvpLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -400,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "pvpBg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(50, 330)
        },
        config = {
          scaleSize = CCSizeMake(665, 200)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "replay",
          buttonName = {
            text = T(LSTR("vcdConfig.1.10.1.001")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "pvpBg",
          handleName = "showReplay"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(150, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "data",
          buttonName = {
            text = T(LSTR("vcdConfig.1.10.1.002")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "pvpBg",
          handleName = "showData"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(330, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "exit",
          buttonName = {
            text = T(LSTR("vcdConfig.1.10.1.003")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "pvpBg",
          handleName = "closePvp"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(490, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "left",
          res = "UI/alpha/HVGA/chat/chat_replay_bg.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 120)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "right",
          res = "UI/alpha/HVGA/chat/chat_replay_bg.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 120)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/chat/chat_replay_vs.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(307, 120)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "leftResult",
          parent = "left",
          res = "UI/alpha/HVGA/pvp/pvp_win.png"
        },
        layout = {
          position = ccp(25, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftIcon", parent = "left"},
        layout = {
          position = ccp(65, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "left"
        },
        layout = {
          position = ccp(160, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
          parent = "left"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(106, 80)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "leftLevel",
          text = "",
          size = 16,
          parent = "left"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(106, 80)
        },
        config = {
          color = ccc3(226, 206, 174)
        }
      },
      {
        t = "Label",
        base = {
          name = "leftName",
          text = "",
          size = 18,
          parent = "left"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(130, 80)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Sprite",
        base = {name = "leftHero1", parent = "left"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(34, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero2", parent = "left"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(84, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero3", parent = "left"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(134, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero4", parent = "left"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(184, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero5", parent = "left"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(234, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "rightResult",
          parent = "right",
          res = "UI/alpha/HVGA/pvp/pvp_win.png"
        },
        layout = {
          position = ccp(25, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightIcon", parent = "right"},
        layout = {
          position = ccp(65, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "right"
        },
        layout = {
          position = ccp(160, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
          parent = "right"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(106, 80)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "rightLevel",
          text = "",
          size = 16,
          parent = "right"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(106, 80)
        },
        config = {
          color = ccc3(226, 206, 174)
        }
      },
      {
        t = "Label",
        base = {
          name = "rightName",
          text = "",
          size = 18,
          parent = "right"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(130, 80)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Sprite",
        base = {name = "rightHero1", parent = "right"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(34, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero2", parent = "right"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(84, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero3", parent = "right"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(134, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero4", parent = "right"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(184, 30)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero5", parent = "right"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(234, 30)
        },
        config = {}
      }
    }
  }
}

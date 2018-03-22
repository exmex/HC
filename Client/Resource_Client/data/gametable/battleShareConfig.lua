EDDefineTable("battleShareConfig")
ShareUIRes = {
  {
    layerName = "shareLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -210,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "shareBg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 330)
        },
        config = {
          scaleSize = CCSizeMake(200, 140)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "shareToWorld",
          buttonName = {
            text = T(LSTR("CHATCONFIG.SHARE_TO_WORLD_CHAT")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "shareBg",
          handleName = "shareToWorld"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 40)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "shareToUnin",
          buttonName = {
            text = T(LSTR("CHATCONFIG.SHARE_TO_GUILD_CHAT")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "shareBg",
          handleName = "shareToUnin"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 100)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          clickPos = "outSide",
          parent = "shareBg",
          handleName = "closeShare"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 70)
        },
        config = {
          messageRect = CCRectMake(0, 0, 200, 140)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "share",
          res = "UI/alpha/HVGA/pvp/pvp_replay_share_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 350)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("CHATCONFIG.SHARE_")),
          parent = "share",
          fontinfo = "normal_button"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 205)
        }
      },
      {
        t = "Label",
        base = {
          name = "replayName",
          text = "[xx vs xx]",
          parent = "share",
          fontinfo = "big_pvp_link"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(205, 175)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_replay_share_input.png",
          parent = "share"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 120)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "cancel",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "share",
          handleName = "cancelShare"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(120, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "confirm",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CONFIRM")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "share",
          handleName = "sendShare"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "EditBox",
        base = {name = "input"},
        config = {
          visible = true,
          editSize = CCSizeMake(330, 30),
          maxLength = 60,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(214, 340)
        }
      }
    }
  }
}

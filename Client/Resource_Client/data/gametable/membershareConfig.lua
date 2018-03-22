EDDefineTable("membershareConfig")
UIRes = {
  {
    layerName = "membershareLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 180),
    touchInfo = {
      iPriority = -600,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "frame1",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(10, 10, 60, 10)
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(210, 30)
        },
        config = {
          scaleSize = CCSizeMake(420, 400)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/chat/dialog_blacklist_title.png",
          capInsets = CCRectMake(160, 20, 160, 4),
          parent = "frame1"
        },
        layout = {
          position = ccp(210, 375),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(410, 35)
        }
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T(LSTR("guildinstancereward.1.10.012")),
          size = 20,
          parent = "title_bg",
          fontinfo = "op_act_title"
        },
        layout = {
          position = ccp(205, 17),
          anchor = ccp(0.5, 0.5)
        },
        config = {}
      },
      {
        t = "Scale9Button",
        base = {
          name = "cExit",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
            press = "UI/alpha/HVGA/common/common_tips_button_close_2.png"
          },
          capInsets = CCRectMake(10, 10, 38, 20),
          parent = "frame1",
          handleName = "exit1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(406, 379)
        },
        config = {}
      },
      {
        t = "Scale9Button",
        base = {
          name = "shareunit",
          buttonName = {
            text = T(LSTR("guildinstancereward.1.10.013")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(15, 20, 110, 15),
          handleName = "choiceUnit",
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 330)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "shareunit",
          buttonName = {
            text = T(LSTR("guildinstancereward.1.10.014")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(15, 20, 110, 15),
          handleName = "clearAll",
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(360, 330)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "ListView",
        base = {
          name = "memberlist",
          parent = "frame1",
          cliprect = CCRectMake(15, 60, 402, 243),
          priority = -200,
          newClickFunc = true,
          uphandleName = "listUpClick",
          movehandleName = "listMoveClick",
          noShade = true,
          selfDealMessage = true,
          widthInner = "25",
          heightInner = "0",
          upShade = "UI/alpha/HVGA/common/common_balck_mask.png",
          downShade = "UI/alpha/HVGA/common/common_balck_mask.png",
          bar = {
            bglen = 200,
            bgpos = ccp(10, 180)
          }
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/guild/guild_member_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(-1, 0)
            },
            config = {
              scalexy = {x = 0.93, y = 1}
            }
          },
          {
            t = "Sprite",
            specialType = "heroIcon",
            base = {
              name = "heroinfo",
              capInsets = CCRectMake(80, 0, 80, 2)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(35, -25)
            },
            config = {
              scaleSize = CCSizeMake(160, 2)
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "select_frame",
              res = "UI/alpha/HVGA/guild/guildraid_select_frame.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(320, -13)
            },
            config = {
              scalexy = {}
            }
          },
          {
            t = "Sprite",
            base = {
              name = "select_frame",
              res = "UI/alpha/HVGA/fragment_tick.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(320, -13)
            },
            config = {visible = false}
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitHead",
              res = {},
              handleName = "onListClick"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(320, -15)
            },
            config = {
              messageRect = CCRectMake(0, 0, 100, 40)
            }
          }
        }
      },
      {
        t = "Sprite",
        base = {
          name = "t_bg",
          parent = "frame1",
          res = "UI/alpha/HVGA/tip_detail_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(190, 30)
        },
        config = {
          scalexy = {x = 2.8, y = 1.8}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          parent = "frame1",
          text = T(LSTR("guildinstancereward.1.10.015")),
          fontinfo = "dark_yellow"
        },
        layout = {
          position = ccp(20, 30),
          anchor = ccp(0, 0.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "num",
          parent = "frame1",
          text = T("0"),
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(151, 30),
          anchor = ccp(0, 0.5)
        },
        config = {}
      },
      {
        t = "Scale9Button",
        base = {
          name = "shareunit",
          buttonName = {
            text = T(LSTR("guildinstancereward.1.10.016")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(15, 20, 45, 15),
          handleName = "choicePrivate",
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(360, 30)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      }
    }
  }
}

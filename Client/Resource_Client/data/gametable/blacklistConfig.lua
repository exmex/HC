EDDefineTable("blacklistConfig")
UIRes = {
  {
    layerName = "blacklistLayer",
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
          position = ccp(170, 30)
        },
        config = {
          scaleSize = CCSizeMake(500, 380)
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
          position = ccp(250, 350),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(490, 35)
        }
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T(LSTR("blacklistConfig.1.10.1.001")),
          size = 20,
          parent = "title_bg",
          fontinfo = "op_act_title"
        },
        layout = {
          position = ccp(250, 17),
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
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(486, 359)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "allserver",
          parent = "frame1",
          text = T(LSTR("blacklistConfig.1.10.1.002")),
          size = 20,
          fontinfo = "normal_button",
          parent = "frame1"
        },
        layout = {
          position = ccp(250, 315),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(160, 200)
        }
      },
      {
        t = "Label",
        base = {
          name = "allserver",
          parent = "frame1",
          text = T(LSTR("blacklistConfig.1.10.1.003")),
          size = 20,
          fontinfo = "normal_button",
          parent = "frame1"
        },
        layout = {
          position = ccp(250, 295),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(160, 200)
        }
      },
      {
        t = "ListView",
        base = {
          name = "ListView",
          parent = "frame1",
          cliprect = CCRectMake(25, 12, 460, 270),
          priority = -200,
          handleName = "onListClick",
          downhandleName = "listDownClick",
          uphandleName = "listUpClick",
          movehandleName = "listMoveClick",
          noShade = true,
          selfDealMessage = true,
          widthInner = "25",
          heightInner = "5",
          upShade = "UI/alpha/HVGA/common/common_balck_mask.png",
          downShade = "UI/alpha/HVGA/common/common_balck_mask.png",
          bar = {
            bglen = 280,
            bgpos = ccp(10, 150)
          }
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(-20, -25)
            },
            config = {
              scalexy = {x = 3.8, y = 3.2}
            }
          },
          {
            t = "Sprite",
            specialType = "heroIcon",
            base = {
              name = "heroinfo",
              res = "UI/alpha/HVGA/serverselect/serverselect_delimiter_2.png",
              capInsets = CCRectMake(80, 0, 80, 2)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -25)
            },
            config = {
              scaleSize = CCSizeMake(160, 2)
            },
            listData = true
          },
          {
            t = "Scale9Button",
            base = {
              name = "cancelshielding",
              buttonName = {
                text = T(LSTR("blacklistConfig.1.10.1.004")),
                fontInfo = "normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
                press = "UI/alpha/HVGA/tavern_button_normal_2.png"
              },
              capInsets = CCRectMake(15, 20, 45, 15),
              handleName = "cancelShielding"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(405, -25)
            },
            config = {
              scaleSize = CCSizeMake(100, 48)
            }
          }
        }
      }
    }
  }
}

EDDefineTable("tenPumpingConfig")
UIRes = {
  {
    layerName = "tenPumpingLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 180),
    touchInfo = {
      iPriority = -100,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "frame1",
          res = "UI/alpha/HVGA/package_herolist_bg.png",
          capInsets = CCRectMake(20, 20, 300, 300)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 220)
        },
        config = {
          scaleSize = CCSizeMake(620, 385)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "cExit",
          res = {
            normal = "UI/alpha/HVGA/herodetail-detail-close.png",
            press = "UI/alpha/HVGA/herodetail-detail-close-p.png"
          },
          capInsets = CCRectMake(10, 10, 38, 20),
          parent = "frame1",
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(616, 359)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          capInsets = CCRectMake(250, 20, 20, 4),
          parent = "frame1"
        },
        layout = {
          position = ccp(310, 350),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(580, 35)
        }
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = LSTR("REBATEACTIVITIESCONFIG.GOLD_TEN_SPINS"),
          size = 20,
          parent = "title_bg",
          fontinfo = "op_act_title"
        },
        layout = {
          position = ccp(280, 17),
          anchor = ccp(0.5, 0.5)
        },
        config = {}
      },
      {
        t = "ListView",
        base = {
          name = "ListView",
          parent = "frame1",
          cliprect = CCRectMake(40, 20, 550, 300),
          priority = -200,
          handleName = "onListClick",
          downhandleName = "listDownClick",
          uphandleName = "listUpClick",
          movehandleName = "listMoveClick",
          noShade = false,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/package_list_shade.png",
          widthInner = "25",
          heightInner = "50",
          downShade = "UI/alpha/HVGA/package_list_shade.png",
          bar = {
            bglen = 250,
            bgpos = ccp(15, 170)
          }
        },
        itemConfig1 = {
          {
            t = "Label",
            base = {
              name = "ptimeui",
              text = T(LSTR("REBATEACTIVITIESCONFIG.TIME_OF_THE_ACTIVITY")),
              size = 20,
              fontinfo = "dark_yellow1"
            },
            layout = {
              position = ccp(0, 0),
              anchor = ccp(0, 0.5)
            },
            config = {}
          },
          {
            t = "Label",
            base = {
              name = "ptime",
              text = T(LSTR("REBATEACTIVITIESCONFIG.STARTED_IN__ENDED_IN")),
              size = 18,
              fontinfo = "dark_white1"
            },
            layout = {
              position = ccp(95, 0),
              anchor = ccp(0, 0.5)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "roleui",
              text = T(LSTR("REBATEACTIVITIESCONFIG.ACTIVITY_INTRODUCTION")),
              size = 20,
              fontinfo = "dark_yellow1"
            },
            layout = {
              position = ccp(0, -22),
              anchor = ccp(0, 1)
            },
            config = {}
          },
          {
            t = "Label",
            base = {
              name = "roles",
              fontinfo = "dark_white1",
              text = "text",
              size = 18
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(95, -22)
            },
            config = {
              dimension = CCSizeMake(440, 260),
              horizontalAlignment = kCCTextAlignmentLeft,
              verticalAlignment = kCCVerticalTextAlignmentCenter,
              shadow = {
                color = ccc3(0, 0, 0),
                offset = ccp(0, 2)
              }
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("TENPUMPINGCONFIG.THE_CUMULATIVE_PARTICIPATING_TIMES")),
              fontinfo = "dark_yellow"
            },
            layout = {
              position = ccp(0, -100),
              anchor = ccp(0, 0.5)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "pjoinNum",
              text = T(LSTR("TENPUMPINGCONFIG.HAS_PARTICIPATED_FOR_5_TIMES")),
              fontinfo = "dark_white"
            },
            addIcon = "true",
            layout = {
              position = ccp(125, -100),
              anchor = ccp(0, 0.5)
            },
            config = {},
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "bgframe3",
              res = "UI/alpha/HVGA/tip_detail_bg.png",
              capInsets = CCRectMake(60, 18, 40, 20)
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(95, -180)
            },
            config = {
              scaleSize = CCSizeMake(440, 100)
            }
          },
          {
            t = "Label",
            base = {
              name = "ui2",
              text = T(LSTR("TENPUMPINGCONFIG.ACTIVITIES_AWARD")),
              size = 20,
              fontinfo = "dark_yellow1"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -180)
            },
            config = {}
          },
          {
            t = "Scale9Button",
            base = {
              name = "getprize1",
              buttonName = {
                text = T(LSTR("MAILBOX.CLAIM")),
                fontInfo = "normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/herodetail-upgrade.png",
                press = "UI/alpha/HVGA/herodetail-upgrade-mask.png"
              },
              capInsets = CCRectMake(20, 20, 20, 20),
              handleName = "getPrize"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(360, -270)
            },
            config = {
              scaleSize = CCSizeMake(100, 50)
            }
          },
          {
            t = "Scale9Button",
            base = {
              name = "goto1",
              buttonName = {
                text = T(LSTR("TENPUMPINGCONFIG.GO_PARTICIPATE")),
                fontInfo = "normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
                press = "UI/alpha/HVGA/tavern_button_normal_2.png"
              },
              capInsets = CCRectMake(14, 20, 60, 23),
              handleName = "joinPrize"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(360, -100)
            },
            config = {
              scaleSize = CCSizeMake(100, 50)
            }
          },
          {
            t = "Label",
            base = {
              name = "pNoGetTitle",
              text = T(LSTR("TENPUMPINGCONFIG.TIMES_AVAILABLE")),
              fontinfo = "dark_yellow"
            },
            layout = {
              position = ccp(0, -270),
              anchor = ccp(0, 0.5)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "pNoGet",
              text = T(""),
              fontinfo = "dark_white"
            },
            layout = {
              position = ccp(40, -270),
              anchor = ccp(0, 0.5)
            },
            addIcon = "true",
            config = {},
            listData = true
          }
        }
      }
    }
  }
}

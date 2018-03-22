EDDefineTable("rebateActivitiesConfig")
UIRes = {
  {
    layerName = "rebateConfig",
    iPriority = 100,
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
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(580, 420)
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
          capInsets = CCRectMake(10, 10, 10, 10),
          parent = "frame1",
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(576, 394)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          capInsets = CCRectMake(200, 20, 70, 4),
          parent = "frame1"
        },
        layout = {
          position = ccp(290, 384),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(560, 35)
        }
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T(LSTR("REBATEACTIVITIESCONFIG.GOLD_TEN_SPINS")),
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
        t = "Scale9Button",
        base = {
          name = "goto",
          buttonName = {
            text = T(LSTR("REBATEACTIVITIESCONFIG.RULES_OF_THE_ACTIVITY_")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "title_bg",
          handleName = "showRoles"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 17)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("REBATEACTIVITIESCONFIG.TIME_OF_THE_ACTIVITY")),
          size = 20,
          parent = "frame1",
          fontinfo = "dark_yellow"
        },
        layout = {
          position = ccp(40, 346),
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
          parent = "frame1",
          fontinfo = "dark_white"
        },
        layout = {
          position = ccp(130, 346),
          anchor = ccp(0, 0.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "pui",
          text = T(LSTR("REBATEACTIVITIESCONFIG.ACTIVITY_INTRODUCTION")),
          size = 20,
          parent = "frame1",
          fontinfo = "dark_yellow"
        },
        layout = {
          position = ccp(40, 328),
          anchor = ccp(0, 1)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "pdesc",
          text = "text",
          size = 18,
          parent = "frame1",
          fontinfo = "dark_white"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(130, 328)
        },
        config = {
          dimension = CCSizeMake(440, 260),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentCenter,
          shadow = {
            color = ccc3(0, 0, 0),
            offset = ccp(0, 2)
          }
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "listbg",
          res = "UI/alpha/HVGA/activity/recharge_list_mask.png",
          capInsets = CCRectMake(15, 15, 8, 8),
          parent = "frame1"
        },
        layout = {
          position = ccp(12, 174),
          anchor = ccp(0, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(556, 216)
        }
      },
      {
        t = "ListView",
        layout = {
          anchor = ccp(0, 0),
          position = ccp(20, 5)
        },
        base = {
          name = "prizeListView",
          parent = "listbg",
          handleName = "",
          downhandleName = "listDownClick",
          movehandleName = "listMoveClick",
          uphandleName = "listUpClick",
          cliprect = CCRectMake(20, 8, 600, 201),
          noShade = true,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png",
          downShade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png",
          widthInner = "25",
          priority = -200,
          selfDealMessage = true,
          bar = {
            bglen = 198,
            bgpos = ccp(10, 108)
          }
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {name = "frame4"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 0)
            },
            config = {
              scalexy = {x = 0.98, y = 1}
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "uimoney1",
              text = "",
              size = 18
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, -30)
            },
            config = {
              horizontalAlignment = kCCTextAlignmentLeft,
              shadow = {
                color = ccc3(0, 0, 0),
                offset = ccp(0, 2)
              },
              visible = false
            }
          },
          {
            t = "Sprite",
            base = {name = "target", text = ""},
            addIcon = "true",
            layout = {
              anchor = ccp(1, 1),
              position = ccp(140, -30)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui5",
              text = T(LSTR("FASTSELL.CAN_GET")),
              fontinfo = "op_act_grey"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(140, -50)
            },
            config = {}
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "icon1",
              res = "UI/alpha/HVGA/activity/activity_reward_bg.png",
              capInsets = CCRectMake(20, 20, 90, 85)
            },
            addIcon = "true",
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(160, -46)
            },
            config = {
              scaleSize = CCSizeMake(80, 80)
            },
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "icon2",
              res = "UI/alpha/HVGA/activity/activity_reward_bg.png",
              capInsets = CCRectMake(20, 20, 90, 85)
            },
            addIcon = "true",
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(260, -46)
            },
            config = {
              scaleSize = CCSizeMake(80, 80)
            },
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "icon3",
              res = "UI/alpha/HVGA/activity/activity_reward_bg.png",
              capInsets = CCRectMake(20, 20, 90, 85)
            },
            addIcon = "true",
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(360, -46)
            },
            config = {
              scaleSize = CCSizeMake(80, 80)
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {name = "bgmark"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 0)
            },
            config = {
              scalexy = {x = 0.98, y = 1}
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {name = "gePrize"},
            addIcon = "true",
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(430, -32)
            },
            config = {
              scaleSize = CCSizeMake(70, 70),
              scale = 0.9
            },
            listData = true
          }
        }
      },
      {
        t = "Sprite",
        base = {
          name = "hasdone",
          text = "",
          parent = "frame1",
          fontinfo = "op_act_light_blue"
        },
        layout = {
          position = ccp(370, 50),
          anchor = ccp(0.5, 0.5)
        },
        config = {}
      },
      {
        t = "Scale9Button",
        base = {
          name = "goto",
          buttonName = {
            text = T(LSTR("REBATEACTIVITIESCONFIG.BUY_GAME_CENTS_NOW")),
            fontInfo = "op_act_title"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_1.png",
            press = "UI/alpha/HVGA/tavern_button_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "frame1",
          handleName = "addRecharge"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(480, 39)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  }
}
rolUIRes = {
  {
    layerName = "rebateConfig",
    iPriority = 200,
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
          name = "rewardBg1",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 240)
        },
        config = {
          scaleSize = CCSizeMake(550, 360)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "cExit",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
            press = "UI/alpha/HVGA/common/common_tips_button_close_2.png"
          },
          capInsets = CCRectMake(10, 10, 10, 10),
          parent = "rewardBg1",
          handleName = "roleExit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(532, 342)
        },
        config = {
          scalSize = CCSizeMake(40, 40)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "roletitle_bg",
          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png",
          capInsets = CCRectMake(200, 20, 20, 4),
          parent = "rewardBg1"
        },
        layout = {
          position = ccp(275, 330),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(500, 35)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("REBATEACTIVITIESCONFIG.ACTIVITY_RULE_DESCRIPTION_")),
          size = 22,
          parent = "roletitle_bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 17)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      },
      {
        t = "ListView",
        base = {
          name = "roleListView",
          parent = "frame1",
          cliprect = CCRectMake(60, 20, 480, 240),
          priority = -200,
          handleName = "onListClick",
          downhandleName = "listDownClick",
          uphandleName = "listUpClick",
          movehandleName = "listMoveClick",
          noShade = false,
          selfDealMessage = true,
          widthInner = "25",
          heightInner = "50",
          upShade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png",
          downShade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png"
        },
        itemConfig = {
          {
            t = "Label",
            base = {
              name = "proles",
              text = T(LSTR("REBATEACTIVITIESCONFIG.ACTIVITY_RULE_DESCRIPTION_")),
              size = 18,
              parent = "rewardBg1",
              fontInfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, -40)
            },
            config = {
              dimension = CCSizeMake(500, 240),
              horizontalAlignment = kCCTextAlignmentLeft,
              verticalAlignment = kCCVerticalTextAlignmentCenter,
              listData = true
            }
          }
        }
      }
    }
  }
}

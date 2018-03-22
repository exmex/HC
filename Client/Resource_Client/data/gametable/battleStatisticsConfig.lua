EDDefineTable("battleStatisticsConfig")
UIRes = {
  {
    layerName = "hurtStatistLayer",
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
          name = "hurtBg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 240)
        },
        config = {
          scaleSize = CCSizeMake(420, 360)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "hurtBg1",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          capInsets = CCRectMake(15, 20, 45, 15),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(210, 152)
        },
        config = {
          scaleSize = CCSizeMake(420, 280)
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
          parent = "hurtBg",
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(402, 339)
        },
        config = {
          scalSize = CCSizeMake(40, 40)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("BATTLESTATISTICSCONFIG.OUR_PART")),
          fontinfo = "normalButton",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(137, 340)
        },
        listData = true
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("BATTLESTATISTICSCONFIG.ENEMYS_PART")),
          fontinfo = "normalButton",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(283, 340)
        },
        listData = true
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("BATTLESTATISTICSCONFIG.OUTPUT_INJURY")),
          fontinfo = "normalButton",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(137, 320)
        },
        listData = true
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("BATTLESTATISTICSCONFIG.OUTPUT_INJURY")),
          fontinfo = "normalButton",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(283, 320)
        },
        listData = true
      },
      {
        t = "Sprite",
        base = {name = "mSprite1", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(40, 260)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "mCount1",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(138, 280)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui1",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(136, 250)
        },
        config = {
          scaleSize = CCSizeMake(137, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "mBar1",
          res = "UI/alpha/HVGA/stagedone_statistics_friend.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "ui1"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "mSprite2", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(40, 210)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "mCount2",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(138, 230)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui2",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(136, 200)
        },
        config = {
          scaleSize = CCSizeMake(137, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "mBar2",
          res = "UI/alpha/HVGA/stagedone_statistics_friend.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "ui2"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "mSprite3", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(40, 160)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "mCount3",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(138, 180)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui3",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(136, 150)
        },
        config = {
          scaleSize = CCSizeMake(137, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "mBar3",
          res = "UI/alpha/HVGA/stagedone_statistics_friend.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "ui3"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "mSprite4", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(40, 110)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "mCount4",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(138, 130)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui4",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(136, 100)
        },
        config = {
          scaleSize = CCSizeMake(137, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "mBar4",
          res = "UI/alpha/HVGA/stagedone_statistics_friend.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "ui4"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "mSprite5", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(40, 60)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "mCount5",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(138, 80)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui5",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(136, 50)
        },
        config = {
          scaleSize = CCSizeMake(137, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "mBar5",
          res = "UI/alpha/HVGA/stagedone_statistics_friend.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "ui5"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "eSprite1", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(380, 260)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "eCount1",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(282, 280)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eui1",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(284, 250)
        },
        config = {
          scaleSize = CCSizeMake(136, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eBar1",
          res = "UI/alpha/HVGA/stagedone_statistics_enemy.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "eui1"
        },
        layout = {
          anchor = ccp(1, 0),
          position = ccp(133, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "eSprite2", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(380, 210)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "eCount2",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(282, 230)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eui2",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(284, 200)
        },
        config = {
          scaleSize = CCSizeMake(136, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eBar2",
          res = "UI/alpha/HVGA/stagedone_statistics_enemy.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "eui2"
        },
        layout = {
          anchor = ccp(1, 0),
          position = ccp(133, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "eSprite3", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(380, 160)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "eCount3",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(282, 180)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eui3",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(284, 150)
        },
        config = {
          scaleSize = CCSizeMake(136, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eBar3",
          res = "UI/alpha/HVGA/stagedone_statistics_enemy.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "eui3"
        },
        layout = {
          anchor = ccp(1, 0),
          position = ccp(133, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "eSprite4", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(380, 110)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "eCount4",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(282, 130)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eui4",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(284, 100)
        },
        config = {
          scaleSize = CCSizeMake(136, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eBar4",
          res = "UI/alpha/HVGA/stagedone_statistics_enemy.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "eui4"
        },
        layout = {
          anchor = ccp(1, 0),
          position = ccp(133, 2)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {name = "eSprite5", parent = "hurtBg"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(380, 60)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "eCount5",
          text = "",
          fontinfo = "normal_button",
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(282, 80)
        },
        listData = true
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eui5",
          res = "UI/alpha/HVGA/hp_black_small.png",
          capInsets = CCRectMake(12, 4, 12, 4),
          parent = "hurtBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(284, 50)
        },
        config = {
          scaleSize = CCSizeMake(136, 15),
          visible = false
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "eBar5",
          res = "UI/alpha/HVGA/stagedone_statistics_enemy.png",
          capInsets = CCRectMake(12, 2, 12, 5),
          parent = "eui5"
        },
        layout = {
          anchor = ccp(1, 0),
          position = ccp(133, 2)
        },
        config = {visible = false}
      }
    }
  }
}

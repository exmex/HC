EDDefineTable("guildInstanceReward")
UIRes = {
  {
    layerName = "mainLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(480, 350)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(240, 320)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.001")),
          fontinfo = "title_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(240, 320)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.002")),
          fontinfo = "normalButton",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(240, 285)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rewardList",
          parent = "bg",
          cliprect = CCRectMake(30, 10, 430, 260),
          priority = -200,
          handleName = "OnRewardListClick",
          noShade = true,
          selfDealMessage = true,
          heightInner = 5,
          newClickFunc = true,
          bar = {
            bglen = 250,
            bgpos = ccp(20, 140)
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
              scalexy = {x = 3.5, y = 3.2}
            }
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<item|126|0.8>"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 3)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "itemNum",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(70, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(70, -12)
            },
            listData = true
          },
          {
            t = "SpriteButton",
            base = {name = "apply", handleName = "applyItem"},
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(380, -26)
            },
            config = {
              messageRect = CCRectMake(0, 0, 110, 50)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "alreadyApply",
              res = "UI/alpha/HVGA/guild/guildraid_loot_need.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(380, -26)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "noApply",
              res = "UI/alpha/HVGA/guild/guildraid_loot_no_need.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(380, -26)
            },
            config = {}
          },
          {
            t = "SpriteButton",
            base = {
              name = "detail",
              parent = "bg",
              res = {},
              downHandleName = "showDetail",
              upHandleName = "hideDetail"
            },
            layout = {
              position = ccp(20, -15)
            },
            config = {
              messageRect = CCRectMake(0, 0, 60, 60)
            }
          },
          {
            t = "Scale9Button",
            base = {
              name = "conform",
              buttonName = {
                text = T(LSTR("PACKAGE.DETAIL")),
                fontInfo = "ui_normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/herodetail-upgrade.png",
                press = "UI/alpha/HVGA/herodetail-upgrade-mask.png"
              },
              capInsets = CCRectMake(10, 20, 60, 15),
              handleName = "reqDetail"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(305, -26)
            },
            config = {
              scaleSize = CCSizeMake(60, 55)
            }
          },
          {
            t = "Fixs9bInst",
            name = "conform",
            anchor = "right"
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "close"
        },
        layout = {
          position = ccp(475, 330)
        }
      }
    }
  },
  {
    layerName = "conformLayer",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 150,
    delayLoad = true,
    touchInfo = {
      iPriority = -500,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {name = "payResult"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 150)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15),
          parent = "payResult"
        },
        layout = {
          position = ccp(91, 100)
        },
        config = {
          scaleSize = CCSizeMake(450, 200)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "payResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 175)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.003")),
          parent = "payResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(88, 175)
        }
      },
      {
        t = "Label",
        base = {
          name = "hintText1",
          text = T(""),
          parent = "payResult",
          size = 17
        },
        layout = {
          position = ccp(100, 120)
        },
        config = {
          dimensions = CCSizeMake(400, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CONFIRM")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "conformApply"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 35)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "cancelApply"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(20, 35)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      }
    }
  },
  {
    layerName = "conformLayer2",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 150,
    delayLoad = true,
    touchInfo = {
      iPriority = -500,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {name = "payResult"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 150)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15),
          parent = "payResult"
        },
        layout = {
          position = ccp(91, 100)
        },
        config = {
          scaleSize = CCSizeMake(450, 170)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "payResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 160)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.003")),
          parent = "payResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(88, 160)
        }
      },
      {
        t = "Label",
        base = {
          name = "hintText1",
          text = T(""),
          parent = "payResult",
          size = 17
        },
        layout = {
          position = ccp(100, 120)
        },
        config = {
          dimensions = CCSizeMake(400, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CONFIRM")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "conformApply2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "cancelApply2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(20, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      }
    }
  },
  {
    layerName = "conformLayer3",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 150,
    delayLoad = true,
    touchInfo = {
      iPriority = -500,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {name = "payResult"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(310, 150)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15),
          parent = "payResult"
        },
        layout = {
          position = ccp(91, 100)
        },
        config = {
          scaleSize = CCSizeMake(450, 170)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "payResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 160)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.003")),
          parent = "payResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(88, 160)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText1",
          text = T(""),
          parent = "payResult"
        },
        layout = {
          position = ccp(-110, 125)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText2",
          text = T(""),
          parent = "payResult"
        },
        layout = {
          position = ccp(-110, 90)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CONFIRM")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "conformApply3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "payResult",
          handleName = "cancelApply3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(20, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      }
    }
  },
  {
    layerName = "rewardDetailLayer",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 100,
    delayLoad = true,
    initVisible = false,
    touchInfo = {
      iPriority = -300,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(480, 350)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(235, 330)
        },
        config = {
          scalexy = {x = 3, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = T(LSTR("guildinstancereward.1.10.004")),
          fontinfo = "normal_button",
          parent = "bg"
        },
        layout = {
          position = ccp(235, 330)
        }
      },
      {
        t = "Label",
        base = {
          name = "noApplyer",
          text = T(LSTR("guildinstancereward.1.10.005")),
          fontinfo = "normal_button",
          parent = "bg"
        },
        layout = {
          position = ccp(235, 300)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rewardList",
          parent = "bg",
          cliprect = CCRectMake(30, 115, 420, 205),
          priority = -200,
          noShade = false,
          selfDealMessage = true,
          heightInner = 0,
          newClickFunc = true
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
            }
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(70, -27)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "RichText",
            base = {name = "rank", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, -27)
            },
            listData = true
          }
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(45, 115)
        }
      },
      {
        t = "RichText",
        base = {
          name = "item",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(40, 95)
        }
      },
      {
        t = "RichText",
        base = {
          name = "itemNum",
          text = T(LSTR("guildinstancereward.1.10.006")),
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(120, 80)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hint1",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(120, 60)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hint2",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(120, 40)
        }
      },
      --{
      --  t = "Scale9Button",
      --  base = {
      --    name = "join",
      --    parent = "bg",
      --    buttonName = {
      --      text = T(LSTR("guildinstancereward.1.10.007")),
      --      fontInfo = "normal_button"
      --    },
      --    res = {
      --      normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
      --      press = "UI/alpha/HVGA/tavern_button_normal_2.png"
      --    },
      --    capInsets = CCRectMake(14, 20, 60, 23),
      --    handleName = "jump"
      --  },
      --  layout = {
       --   anchor = ccp(0.5, 0.5),
       --   position = ccp(385, 35)
       -- },
       -- config = {
       --   scaleSize = CCSizeMake(95, 48)
       -- }
      --},
      {
        t = "SpriteButton",
        base = {
          name = "apply",
          parent = "bg",
          handleName = "doReqItem"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 80)
        },
        config = {
          messageRect = CCRectMake(0, 0, 110, 50)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "alreadyApply",
          res = "UI/alpha/HVGA/guild/guildraid_loot_need.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 80)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "noApply",
          res = "UI/alpha/HVGA/guild/guildraid_loot_no_need.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 80)
        },
        config = {}
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "closeRewarDetailLayer"
        },
        layout = {
          position = ccp(475, 330)
        }
      }
    }
  },
  {
    layerName = "jumpLayer",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 100,
    delayLoad = true,
    initVisible = false,
    touchInfo = {
      iPriority = -500,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(400, 300)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText1",
          text = T(""),
          parent = "bg"
        },
        layout = {
          position = ccp(45, 270)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText3",
          text = T(LSTR("guildinstancereward.1.10.008")),
          parent = "bg"
        },
        layout = {
          position = ccp(45, 120)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("guildinstancereward.1.10.009")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bg",
          handleName = "conformJump"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bg",
          handleName = "cancelJump"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 45)
        }
      }
    }
  }
}
damageUIRes = {
  {
    layerName = "mainLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(380, 350)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.010")),
          fontinfo = "title_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(190, 315)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(""),
          fontinfo = "title_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 310)
        }
      },
      {
        t = "ListView",
        base = {
          name = "damageList",
          parent = "bg",
          cliprect = CCRectMake(10, 20, 370, 275),
          priority = -200,
          selfDealMessage = true,
          heightInner = 5,
          newClickFunc = true
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(20, -25)
            },
            config = {
              scalexy = {x = 2.7, y = 2}
            }
          },
          {
            t = "Sprite",
            base = {
              name = "bg2",
              res = "UI/alpha/HVGA/tip_detail_bg_green.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(20, -25)
            },
            config = {
              scalexy = {x = 2.7, y = 2}
            }
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(70, -12)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(78, -12)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/hp_black_small.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(255, -30)
            },
            config = {scale = 1.5}
          },
          {
            t = "Sprite",
            base = {
              name = "percent",
              res = "UI/alpha/HVGA/hp_green_small.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(255, -30)
            },
            config = {scale = 1.5}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(43, -27)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "level",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(88, -17)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(110, -17)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "damage",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(358, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {name = "rank", text = ""},
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -30)
            },
            listData = true
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          clickPos = "outSide",
          handleName = "close"
        },
        layout = {
          position = ccp(200, 300)
        },
        config = {
          messageRect = CCRectMake(0, 0, 200, 200)
        }
      }
    }
  }
}
specialRewardUIRes = {
  {
    layerName = "mainLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -200,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(300, 150)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 120)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = "sdsdsd",
          fontinfo = "guild_join_tab_white",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 120)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildinstancereward.1.10.011")),
          fontinfo = "normal_button",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 85)
        }
      },
      {
        t = "RichText",
        base = {
          name = "selectInfo",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(18, 35)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail1",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 1
        },
        layout = {
          position = ccp(40, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail2",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 2
        },
        layout = {
          position = ccp(80, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail3",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 3
        },
        layout = {
          position = ccp(120, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail4",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 4
        },
        layout = {
          position = ccp(170, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail5",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 5
        },
        layout = {
          position = ccp(220, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail6",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 6
        },
        layout = {
          position = ccp(260, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail7",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 7
        },
        layout = {
          position = ccp(310, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail8",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 8
        },
        layout = {
          position = ccp(350, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail9",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 9
        },
        layout = {
          position = ccp(400, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "detail10",
          parent = "bg",
          res = {},
          downHandleName = "showDetail",
          handleName = "hideDetail",
          arrayIndex = 10
        },
        layout = {
          position = ccp(450, 35)
        },
        config = {
          messageRect = CCRectMake(0, 0, 40, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "close"
        },
        layout = {
          position = ccp(290, 130)
        }
      }
    }
  }
}
rewardRecordUI = {
  {
    layerName = "mainLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -200,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 230)
        },
        config = {
          scaleSize = CCSizeMake(450, 350)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 320)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.010")),
          fontinfo = "title_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 320)
        }
      },
      {
        t = "ListView",
        base = {
          name = "recordList",
          parent = "bg",
          cliprect = CCRectMake(50, 15, 350, 275),
          priority = -200,
          noShade = true,
          selfDealMessage = true,
          heightInner = 5,
          newClickFunc = true,
          bar = {
            bglen = 250,
            bgpos = ccp(20, 140)
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
              position = ccp(-20, -20)
            },
            config = {
              scalexy = {x = 3.2, y = 3.2}
            }
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<item|126|0.8>"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(3, 2)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {name = "hint1", text = ""},
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(60, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {name = "hint2", text = ""},
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(60, -35)
            },
            listData = true
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "close"
        },
        layout = {
          position = ccp(445, 330)
        }
      }
    }
  }
}

EDDefineTable("chatConfig")
UIRes = {
  {
    layerName = "mainLayer",
    iPriority = 200,
	layerColor = ccc4(0, 0, 0, 190),
	initVisible = false,
	touchInfo = {
		iPriority = -500,
		bSwallowsTouches = true,
		alert = true
	},
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "chatBg",
          res = "UI/alpha/HVGA/chat/chat_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 0)
        },
        config = {scale = 0.95}
      },
      {
        t = "SpriteButton",
        base = {
          name = "chatTurn",
          res = {
            normal = "UI/alpha/HVGA/chat/chat_entrance_1.png",
            press = "UI/alpha/HVGA/chat/chat_entrance_2.png"
          },
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(614, 230)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "chatTurnBack",
          res = {
            normal = "UI/alpha/HVGA/backbtn.png",
            press = "UI/alpha/HVGA/backbtn-disabled.png"
          },
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(24, 423)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "chatHint",
          res = "UI/alpha/HVGA/chat/chat_entrance_3.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(614, 230)
        },
        config = {visible = false}
      },
      {
        t = "SpriteButton",
        base = {
          name = "tabWorld",
          res = {
            normal = "UI/alpha/HVGA/chat/chat_tab_normal.png"
          },
          parent = "chatBg",
          handleName = "OnWorldTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(99, 379)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "tabUnion",
          res = {
            normal = "UI/alpha/HVGA/chat/chat_tab_normal.png"
          },
          parent = "chatBg",
          handleName = "OnUninTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(249, 379)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "tabPrivate",
          res = {
            normal = "UI/alpha/HVGA/chat/chat_tab_normal.png"
          },
          parent = "chatBg",
          handleName = "OnPrivateTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(399, 379)
        },config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "inputBg",
          res = "UI/alpha/HVGA/chat/chat_input.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(352, 330)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "worldInput",
          res = "UI/alpha/HVGA/chat/chat_input_2.png",
          parent = "chatBg",
          capInsets = CCRectMake(15, 15, 10, 15)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(18, 329)
        },
        config = {
          scaleSize = CCSizeMake(495, 35)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "uninInput",
          res = "UI/alpha/HVGA/chat/chat_input_2.png",
          parent = "chatBg",
          capInsets = CCRectMake(15, 15, 10, 15)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(18, 329)
        },
        config = {
          scaleSize = CCSizeMake(580, 35)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "privateInput",
          res = "UI/alpha/HVGA/chat/chat_input_2.png",
          parent = "chatBg",
          capInsets = CCRectMake(15, 15, 10, 15)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(18, 329),
        },
        config = {
          scaleSize = CCSizeMake(580, 35)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "world",
          res = "UI/alpha/HVGA/chat/chat_tab_current.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(99, 378)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "unin",
          res = "UI/alpha/HVGA/chat/chat_tab_current.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(249, 378)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "private",
          res = "UI/alpha/HVGA/chat/chat_tab_current.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(399, 378)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "worldText",
          text = T(LSTR("CHATCONFIG.WORLD")),
          fontinfo = "chat_channel_inactive",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(99, 379)
        }
      },
      {
        t = "Label",
        base = {
          name = "guildText",
          text = T(LSTR("CHATCONFIG.GUILD")),
          fontinfo = "chat_channel_inactive",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(249, 379)
        }
      },
      {
        t = "Label",
        base = {
          name = "privateText",
          text = T(LSTR("chatconfig.1.10.1.001")),
          fontinfo = "chat_channel_inactive",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(399, 379)
        },config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "leftTimeBg",
          res = "UI/alpha/HVGA/chat/chat_price_bg.png",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(525, 328)
        }
      },
      {
        t = "RichText",
        base = {
          name = "leftTimes",
          parent = "chatBg",
          text = T(LSTR("CHATCONFIG.TEXT_GUILD_JOIN_LIST_GUILDNAME__FREE_10"))
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(531, 328)
        }
      },
      {
        t = "Label",
        base = {
          name = "privateHint",
          parent = "chatBg",
          text = "",
          fontinfo = "main_name"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 328)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "sendChat",
          buttonName = {
            text = T(LSTR("CHATCONFIG.SEND")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "chatBg",
          handleName = "sendChat"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(646, 327)
        },
        config = {
          scaleSize = CCSizeMake(80, 48)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listviewWorld",
          parent = "chatBg",
          cliprect = CCRectMake(10, 10, 630, 274),
          selfDealMessage = true,
          heightInner = 10,
          layoutMode = "up",
          maxItem = 30
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter_2.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(5, 6)
            },
            config = {
              scalexy = {x = 1, y = 0.83},
              visible = false
            }
          },
          {
            t = "Sprite",
            base = {name = "ui"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(60, 2)
            },
            config = {visible = false}
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
              position = ccp(77, -3)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "chat_name"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -2)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "job",
              text = "",
              fontinfo = "chat_title"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(300, -2)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(640, -5)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "content",
              text = "",
              fontinfo = "chat_content"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -27)
            },
            config = {
              dimension = CCSizeMake(440, 0),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(6, -27)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(37, -10)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "RichText",
            base = {name = "superlink", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -27)
            },
            listData = true
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitHead",
              res = {},
              --handleName = "hitWorldHead"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(15, 5)
            },
            config = {
              messageRect = CCRectMake(0, 0, 450, 80)
            }
          }
        }
      },
      {
        t = "ListView",
        base = {
          name = "listviewUnin",
          parent = "chatBg",
          cliprect = CCRectMake(10, 10, 630, 274),
          selfDealMessage = true,
          heightInner = 10,
          layoutMode = "up",
          maxItem = 30
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter_2.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(5, 6)
            },
            config = {
              scalexy = {x = 1, y = 0.83},
              visible = false
            }
          },
          {
            t = "Sprite",
            base = {name = "ui"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(60, 2)
            },
            config = {visible = false}
          },
          {
            t = "Label",
            base = {
              name = "level",
              text = "99",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(77, -3)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "chat_name"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -2)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "job",
              text = "",
              fontinfo = "chat_title"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(300, -2)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(640, -5)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "content",
              text = "",
              fontinfo = "chat_content"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -27)
            },
            config = {
              dimension = CCSizeMake(440, 0),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(6, -27)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(37, -10)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "RichText",
            base = {name = "superlink", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -27)
            },
            listData = true
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitHead",
              res = {},
              --handleName = "hitUninHead"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(15, 5)
            },
            config = {
              messageRect = CCRectMake(0, 0, 450, 80)
            }
          }
        }
      },
      {
        t = "ListView",
        base = {
          name = "listviewPrivate",
          parent = "chatBg",
          cliprect = CCRectMake(10, 10, 630, 274),
          selfDealMessage = true,
          heightInner = 10,
          layoutMode = "up",
          maxItem = 30,
          newClickFunc = true
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {name = "ui"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(60, 2)
            },
            config = {visible = false}
          },
          {
            t = "Label",
            base = {
              name = "level",
              text = "99",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(77, -3)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "chat_name"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -2)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "hint",
              text = T(LSTR("chatconfig.1.10.1.002")),
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(150, -5)
            }
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(540, -5)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "content",
              text = "",
              fontinfo = "chat_content"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -20)
            },
            config = {
              dimension = CCSizeMake(400, 0),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(37, -5)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(6, -20)
            },
            config = {}
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitIndex",
              res = {},
              handleName = "hitPrivateIndex"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, 15)
            },
            config = {
              messageRect = CCRectMake(0, 0, 500, 80)
            }
          },
          {
            t = "RichText",
            base = {name = "superlink", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -20)
            },
            listData = true
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitHead",
              res = {},
              --handleName = "hitPrivateHead"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(15, 15)
            },
            config = {
              messageRect = CCRectMake(0, 0, 85, 80)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Label",
            base = {
              name = "hint",
              text = T(LSTR("chatconfig.1.10.1.003")),
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(30, 13)
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "chat_name"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, 13)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "chat_time"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(540, -5)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "content",
              text = "",
              fontinfo = "chat_content"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -10)
            },
            config = {
              dimension = CCSizeMake(400, 0),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/chat/chat_delimeter.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(6, -20)
            },
            config = {}
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitIndex",
              res = {},
              handleName = "hitPrivateIndex"
            },
            layout = {
              anchor = ccp(0, 0),
              position = ccp(100, -30)
            },
            config = {
              messageRect = CCRectMake(0, 0, 500, 40)
            }
          },
          {
            t = "RichText",
            base = {name = "superlink", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -10)
            },
            listData = true
          },
          {
            t = "SpriteButton",
            base = {
              name = "hitHead",
              res = {},
              --handleName = "hitPrivateHead"
            },
            layout = {
              anchor = ccp(0, 0),
              position = ccp(15, -30)
            },
            config = {
              messageRect = CCRectMake(0, 0, 85, 40)
            }
          }
        }
      },
      {
        t = "EditBox",
        base = {name = "worldEdit"},
        config = {
          editSize = CCSizeMake(460, 50),
          maxLength = 55,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(60, 300)
        }
      },
      {
        t = "EditBox",
        base = {name = "guildEdit"},
        config = {
          editSize = CCSizeMake(520, 50),
          maxLength = 55,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(60, 300)
        }
      },
      {
        t = "EditBox",
        base = {
          name = "privateEdit"
        },
        config = {
          editSize = CCSizeMake(520, 50),
          maxLength = 55,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(60, 300)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "assertButton",
          parent = "chatBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 200)
        },
        config = {
          messageRect = CCRectMake(0, 0, 680, 600)
        }
      }
    }
  },
  {
    layerName = "targetLayer",
    iPriority = 200,
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
          name = "targetInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(390, 250)
        },
        config = {
          scaleSize = CCSizeMake(330, 175)
        }
      },
      {
        t = "Sprite",
        base = {name = "target", parent = "targetInfo"},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(50, 130)
        },
        config = {}
      },
      {
        t = "RichText",
        base = {
          name = "guildInfo",
          parent = "targetInfo",
          text = T("")
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(98, 95)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeMemberInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "targetInfo",
          handleName = "closeTargetInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(333, 178)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "targetInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(0, 70)
        },
        config = {scale = 0.85}
      },
      {
        t = "Scale9Button",
        base = {
          name = "chat",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.004")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "targetInfo",
          handleName = "onTargetChat"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 35)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "addblack",
          buttonName = {
            text = T(LSTR("chatconfig.1.10.1.004")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "targetInfo",
          handleName = "addBlacklist"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(180, 35)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  },
  {
    layerName = "pvpLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
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
          name = "pvpBg",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(50, 330)
        },
        config = {
          scaleSize = CCSizeMake(700, 200)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "replay",
          buttonName = {
            text = T(LSTR("CHATCONFIG.BATTLE_REPLAY")),
            fontInfo = "ui_normal_button"
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
          position = ccp(595, 40)
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
        t = "SpriteButton",
        base = {
          name = "closePvp",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "pvpBg",
          handleName = "closePvp"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(705, 203)
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
            fontInfo = "ui_normal_button"
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
            fontInfo = "ui_normal_button"
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
            fontInfo = "ui_normal_button"
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
            fontInfo = "ui_normal_button"
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

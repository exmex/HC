EDDefineTable("activitiesConfig")
UIRes = {
  {
    layerName = "mainLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 220),
    touchInfo = {
      iPriority = -80,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "framelist",
          res = "UI/alpha/HVGA/package_herolist_bg.png",
          capInsets = CCRectMake(20, 20, 300, 300)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 200)
        },
        config = {
          scaleSize = CCSizeMake(540, 300)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/task_window_title_bg.png",
          parent = "framelist"
        },
        layout = {
          position = ccp(270, 303),
          anchor = ccp(0.5, 0)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T(LSTR("ACTIVITIESLISTCONFIG.EXCITING_ACTIVITIES")),
          size = 20,
          parent = "title_bg",
          fontinfo = "op_act_title1"
        },
        layout = {
          position = ccp(263, 18),
          anchor = ccp(0.5, 0.5)
        },
        config = {}
      },
      {
        t = "ListView",
        base = {
          name = "findListView",
          parent = "framelist",
          cliprect = CCRectMake(25, 30, 490, 250),
          priority = -200,
          handleName = "ListClick",
          noShade = false,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/package_list_shade.png",
          downShade = "UI/alpha/HVGA/package_list_shade.png",
          bar = {
            bglen = 250,
            bgpos = ccp(15, 155)
          }
        },
        itemConfig1 = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg1",
              res = "UI/alpha/HVGA/guild/guild_guildlist_member_bg.png",
              capInsets = CCRectMake(20, 20, 300, 50)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(1, 0)
            },
            config = {
              scaleSize = CCSizeMake(490, 50)
            }
          },
          {
            t = "Label",
            base = {
              name = "name1",
              text = "",
              fontinfo = "op_act_grey"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, -15)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "info1",
              text = "",
              fontinfo = "op_act_red"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(200, -15)
            },
            config = {
              dimension = CCSizeMake(400, 18),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "bgtitle",
              res = "UI/alpha/HVGA/equip_detail_title_bg.png"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(350, 5)
            },
            config = {
              scaleSize = CCSizeMake(500, 15)
            }
          },
          {
            t = "Label",
            base = {
              name = "titlename",
              text = "",
              fontinfo = "op_act_title"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(250, 5)
            },
            listData = true
          }
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
          parent = "framelist",
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(536, 274)
        },
        config = {}
      }
    }
  }
}
UIButton = {
  {
    layerName = "mainLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 0),
    touchInfo = {iPriority = 0, bSwallowsTouches = true},
    uiRes = {
      {
        t = "Scale9Button",
        base = {
          name = "icon1",
          res = {
            normal = "UI/alpha/HVGA/main_icon_op_act_1.png",
            press = "UI/alpha/HVGA/main_icon_op_act_2.png"
          },
          capInsets = CCRectMake(10, 10, 10, 10),
          handleName = "createlist"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(180, -2)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui21",
          res = "UI/alpha/HVGA/main_deal_tag.png"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(210, 30)
        },
        config = {visible = false}
      }
    }
  }
}

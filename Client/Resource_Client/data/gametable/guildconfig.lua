EDDefineTable("guildConfig")
JoinUIRes = {
  {
    layerName = "joinLayer",
    iPriority = 0,
    touchInfo = {iPriority = -1, bSwallowsTouches = true},
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/bg.jpg"
        },
        layout = {
          position = ccp(400, 240)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/guild/guild_frame.png"
        },
        layout = {
          position = ccp(400, 240)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/Normal_title_bg.png",
          z = 30
        },
        layout = {
          position = ccp(400, 430.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = LSTR("GUILD.GUILD"),
          parent = "title_bg",
          fontinfo = "ui_normal_button",
          size = 24
        },
        layout = {
          position = ccp(230, 30)
        },
        config = {
          color = ccc3(250, 205, 16)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_bg.png",
          parent = "bg",
          capInsets = CCRectMake(28, 33, 28, 20)
        },
        layout = {
          position = ccp(365, 181)
        },
        config = {
          scaleSize = CCSizeMake(680, 315)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "buttonBg",
          res = "UI/alpha/HVGA/guild/guild_tab_light.png",
          parent = "bg"
        },
        layout = {
          position = ccp(165, 365)
        },
        config = {}
      },
      {
        t = "Scale9CheckButton",
        base = {
          name = "joinGuild",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.JOIN_GUILD")),
            normalFontInfo = "guild_join_tab_white",
            pressFontInfo = "guild_join_tab_yellow"
          },
          res = {
            normal = "UI/alpha/HVGA/elitetoggle-ns.png",
            press = "UI/alpha/HVGA/elitetoggle-s.png"
          },
          capInsets = CCRectMake(30, 20, 60, 23),
          parent = "bg",
          handleName = "joinGuildTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(165, 365)
        },
        config = {
          scaleSize = CCSizeMake(140, 48)
        }
      },
      {
        t = "Scale9CheckButton",
        base = {
          name = "createGuild",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CREATE_GUILD")),
            normalFontInfo = "guild_join_tab_white",
            pressFontInfo = "guild_join_tab_yellow"
          },
          res = {
            normal = "UI/alpha/HVGA/elitetoggle-ns.png",
            press = "UI/alpha/HVGA/elitetoggle-s.png"
          },
          capInsets = CCRectMake(30, 20, 60, 23),
          parent = "bg",
          handleName = "createGuildTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(365, 365)
        },
        config = {
          scaleSize = CCSizeMake(140, 48)
        }
      },
      {
        t = "Scale9CheckButton",
        base = {
          name = "findGuild",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.SEARCH_GUILD")),
            normalFontInfo = "guild_join_tab_white",
            pressFontInfo = "guild_join_tab_yellow"
          },
          res = {
            normal = "UI/alpha/HVGA/elitetoggle-ns.png",
            press = "UI/alpha/HVGA/elitetoggle-s.png"
          },
          capInsets = CCRectMake(30, 20, 60, 23),
          parent = "bg",
          handleName = "findGuildTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(565, 365)
        },
        config = {
          scaleSize = CCSizeMake(140, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeGuildPanel",
          res = {
            normal = "UI/alpha/HVGA/backbtn.png",
            press = "UI/alpha/HVGA/backbtn-disabled.png"
          },
          handleName = "closeGuildPanel"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(63, 420)
        }
      },
      {
        t = "Sprite",
        base = {name = "joinTab", parent = "bg"},
        layout = {
          position = ccp(0, 0)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "noJoinGuild",
          text = T(LSTR("GUILDCONFIG.NO_GUILD_TO_JOIN_IN_FOUND")),
          fontinfo = "guild_create_words_yellow",
          parent = "joinTab"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(365, 320)
        }
      },
      {
        t = "ListView",
        base = {
          name = "guildListView",
          parent = "joinTab",
          cliprect = CCRectMake(50, 35, 632, 300),
          priority = -200,
          handleName = "OnJoinListClick",
          noShade = false,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png",
          downShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png"
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/guild/guild_guildlist_member_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(2, 0)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/guild/guild_icon_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(19, -6)
            },
            config = {scale = 0.8}
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "join",
              res = "UI/alpha/HVGA/task_button.png",
              capInsets = CCRectMake(15, 20, 45, 15),
              fontinfo = "ui_normal_button",
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(610, -11)
            },
            config = {
              scaleSize = CCSizeMake(105, 50)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(90, -12)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(25, -12)
            },
            config = {
              scalexy = {x = 0.8, y = 0.8}
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/equip_frame_white.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(18, -6)
            },
            config = {scale = 0.85}
          },
          {
            t = "RichText",
            base = {
              name = "name",
              text = T(LSTR("GUILDCONFIG.TEXT_GUILD_JOIN_LIST_GUILDNAME_THE_FIRSTTEXT_GUILD_CREATE_WORDS_YELLOW_40"))
            },
            layout = {
              position = ccp(90, -25)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "info",
              text = "",
              fontinfo = "guild_join_list_description"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(90, -40)
            },
            config = {
              dimension = CCSizeMake(400, 18),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "limit",
              text = "",
              fontinfo = "guild_join_list_levelrequirement"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(490, -16)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "ui_normal_button"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(556, -39)
            },
            listData = true
          }
        }
      },
      {
        t = "Sprite",
        base = {name = "createTab", parent = "bg"},
        layout = {
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_NAME_")),
          fontinfo = "guild_create_words_yellow",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(200, 300)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22),
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(300, 300)
        },
        config = {
          scaleSize = CCSizeMake(240, 42)
        }
      },
      {
        t = "EditBox",
        base = {
          name = "createInput"
        },
        config = {
          visible = false,
          editSize = CCSizeMake(200, 50),
          maxLength = 10,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(433, 309)
        }
      },
      {
        t = "Label",
        base = {
          name = "guildName",
          text = "",
          fontinfo = "normal_button",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(305, 300)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_delimeter_h.png",
          parent = "createTab"
        },
        layout = {
          position = ccp(380, 245)
        },
        config = {
          scalexy = {x = 2.5, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_LOGO_")),
          fontinfo = "guild_create_words_yellow",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(200, 190)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "guildIcon",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(300, 190)
        },
        scale = {0.9}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/equip_frame_white.png",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(301, 189)
        },
        scale = {0.9}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_delimeter_h.png",
          parent = "createTab"
        },
        layout = {
          position = ccp(380, 135)
        },
        config = {
          scalexy = {x = 2.5, y = 1}
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "change",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CHANGE")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "createTab",
          handleName = "changeIcon"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(490, 190)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.CREATION_COST_")),
          fontinfo = "guild_create_words_yellow",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(200, 85)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(290, 85)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/rmbicon.png",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(310, 85)
        },
        config = {scale = 0.8}
      },
      {
        t = "Label",
        base = {
          name = "createCost",
          text = "1000",
          fontinfo = "normal_button",
          parent = "createTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 85)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "create",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CREATE_GUILD")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "createTab",
          handleName = "createGuild"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(490, 85)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "ui",
          handleName = "changeIcon",
          parent = "createTab"
        },
        layout = {
          position = ccp(335, 190)
        },
        config = {
          messageRect = CCRectMake(0, 0, 75, 70)
        }
      },
      {
        t = "Sprite",
        base = {name = "findTab", parent = "bg"},
        layout = {
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_search_bg.png",
          parent = "findTab",
          capInsets = CCRectMake(28, 33, 28, 20)
        },
        layout = {
          position = ccp(365, 305)
        },
        config = {
          scaleSize = CCSizeMake(675, 65)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_ID_")),
          fontinfo = "normal_button",
          parent = "findTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(150, 305)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22),
          parent = "findTab"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 305)
        },
        config = {
          scaleSize = CCSizeMake(235, 42)
        }
      },
      {
        t = "EditBox",
        base = {name = "input"},
        config = {
          visible = false,
          editSize = CCSizeMake(200, 50),
          maxLength = 10,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(383, 315)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "find",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.SEARCH")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "findTab",
          handleName = "reqGuildById"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(550, 305)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "ListView",
        base = {
          name = "findListView",
          parent = "findTab",
          cliprect = CCRectMake(49, 30, 630, 240),
          priority = -200,
          handleName = "OnJoinListClick",
          noShade = false,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png",
          downShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png"
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/guild/guild_guildlist_member_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(1, 0)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/gocha.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(10, -3)
            },
            config = {scale = 0.9}
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "join",
              res = "UI/alpha/HVGA/tavern_button_normal_1.png",
              capInsets = CCRectMake(20, 15, 88, 19)
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(605, -12)
            },
            config = {
              scaleSize = CCSizeMake(105, 50)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(80, -11)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(18, -7)
            },
            config = {scale = 0.84},
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "name",
              text = T(LSTR("GUILDCONFIG.TEXT_GUILD_JOIN_LIST_GUILDNAME_THE_FIRSTTEXT_GUILD_CREATE_WORDS_YELLOW_40"))
            },
            layout = {
              position = ccp(90, -25)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "info",
              text = "",
              fontinfo = "guild_join_list_description"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(80, -40)
            },
            config = {
              dimension = CCSizeMake(400, 18),
              horizontalAlignment = kCCTextAlignmentLeft
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "limit",
              text = "",
              fontinfo = "guild_join_list_levelrequirement"
            },
            layout = {
              anchor = ccp(1, 1),
              position = ccp(485, -15)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = "",
              fontinfo = "ui_normal_button"
            },
            layout = {
			   anchor = ccp(0.5, 0.5),
			   position = ccp(553, -37)
            },
            listData = true
          }
        }
      }
    }
  }
}
GuildRes = {
  {
    layerName = "mainLayer",
    iPriority = 0,
    touchInfo = {iPriority = -1, bSwallowsTouches = true},
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/bg.jpg"
        },
        layout = {
          position = ccp(400, 240)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/guild/guild_frame.png"
        },
        layout = {
          position = ccp(400, 240)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "title_bg",
          res = "UI/alpha/HVGA/Normal_title_bg.png",
        },
        layout = {
          position = ccp(370, 430.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = LSTR("GUILD.GUILD"),
          parent = "title_bg",
          fontinfo = "ui_normal_button",
          size = 24
        },
        layout = {
          position = ccp(230, 30)
        },
        config = {
          color = ccc3(250, 205, 16)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_bg.png",
          parent = "bg",
          capInsets = CCRectMake(28, 33, 28, 20)
        },
        layout = {
          position = ccp(365, 209)
        },
        config = {
          scaleSize = CCSizeMake(670, 353)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "guildIcon",
          res = "UI/alpha/HVGA/guild/guild_delimeter_v.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(485, 210)
        },
        config = {
          scalexy = {x = 1, y = 1.7}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "guildIcon",
          res = "UI/alpha/HVGA/guild/guild_delimeter_h.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(495, 280)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "managerGuild",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.GUILD_MANAGEMENT")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bg",
          handleName = "manageGuild"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(425, 330)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "herosCamp",
          res = {
            normal = "UI/alpha/HVGA/shop_refresh_button.png",
            press = "UI/alpha/HVGA/shop_refresh_button_down.png"
          },
          capInsets = CCRectMake(14, 20, 60, 27),
          parent = "bg",
          handleName = "herosCamp"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(590, 245)
        },
        config = {
          scaleSize = CCSizeMake(160, 60)
        }
      },
      {
        t = "Label",
        base = {
          name = "herosCamp_label",
          text = T(LSTR("GUILDCONFIG.HERO_CAMP")),
          fontinfo = "ui_normal_button",
          size = 16,
          parent = "bg"
        },
        layout = {
          position = ccp(593, 245)
        },
          config = {
            color = ccc3(235, 223, 207),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "guildInstance",
          res = {
            normal = "UI/alpha/HVGA/shop_refresh_button.png",
            press = "UI/alpha/HVGA/shop_refresh_button_down.png"
          },
          capInsets = CCRectMake(14, 20, 60, 27),
          parent = "bg",
          handleName = "guildInstance"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(590, 184)
        },
        config = {
          scaleSize = CCSizeMake(160, 60),
			visible=false
        }
      },
      {
        t = "Label",
        base = {
          name = "guildInstance_label",
          text = T(LSTR("GUILDCONFIG.RAID_INSTANCES")),
          fontinfo = "ui_normal_button",
          size = 18,
          parent = "bg"
        },
        layout = {
          position = ccp(597, 182) 
        },
          config = {
            color = ccc3(235, 223, 207),
			visible=false,
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "worship",
          res = {
            normal = "UI/alpha/HVGA/shop_refresh_button.png",
            press = "UI/alpha/HVGA/shop_refresh_button_down.png"
          },
          capInsets = CCRectMake(14, 20, 60, 27),
          parent = "bg",
          handleName = "worship"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(590, 184) --(590,123)
        },
        config = {
          scaleSize = CCSizeMake(160, 60)
        }
      },
      {
        t = "Label",
        base = {
          name = "worship_label",
          text = T(LSTR("GUILDCONFIG.TOP_PLAYERS")),
          fontinfo = "ui_normal_button",
          size = 16,
          parent = "bg"
        },
        layout = {
          position = ccp(593, 182) --(605,122)
        },
          config = {
            color = ccc3(235, 223, 207),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
        }
      },
      {
       t = "Scale9Button",
        base = {
          name = "guildShop",
          res = {
            normal = "UI/alpha/HVGA/shop_refresh_button.png",
            press = "UI/alpha/HVGA/shop_refresh_button_down.png"
          },
         capInsets = CCRectMake(14, 20, 60, 27),
          parent = "bg",
          handleName = "guildShop"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(590, 123)
        },
        config = {
          scaleSize = CCSizeMake(160, 60),
		visible=false
        }
     },
      {
        t = "Label",
        base = {
          name = "guildShop_label",
          text = T(LSTR("GUILDCONFIG.SHOP")),
          fontinfo = "ui_normal_button",
          size = 16,
          parent = "bg"
        },
        layout = {
          position = ccp(593, 122)
        },
          config = {
            color = ccc3(235, 223, 207),
			visible=false,
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeGuildPanel",
          res = {
            normal = "UI/alpha/HVGA/backbtn.png",
            press = "UI/alpha/HVGA/backbtn-disabled.png"
          },
          handleName = "closeGuildPanel",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(28, 420)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_button_hire_1.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(532, 245)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_button_worship_1.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(532, 124)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_button_raid_1.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(532, 184)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_button_shop_1.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(532, 61)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "worshipTag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "bg",
          z = 10
        },
        layout = {
          position = ccp(660, 138)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "managerTag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "bg",
          z = 10
        },
        layout = {
          position = ccp(466, 344)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(125, 370)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "guildIcon",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(50, 370)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/equip_frame_white.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(51, 368)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = "",
          fontinfo = "guild_join_list_guildname",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(130, 365)
        }
      },
      {
        t = "Label",
        base = {
          name = "uiGuidId",
          text = T(LSTR("GUILDCONFIG.GUILD_ID_")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(130, 340)
        }
      },
      {
        t = "Label",
        base = {
          name = "id",
          text = "",
          fontinfo = "dark_white",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(200, 340)
        }
      },
      {
        t = "Label",
        base = {
          name = "uiMembers",
          text = T(LSTR("GUILDCONFIG.MEMBERS_")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(130, 320)
        }
      },
      {
        t = "Label",
        base = {
          name = "members",
          text = "",
          fontinfo = "dark_white",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(210, 320)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_MANIFESTO")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(500, 370)
        }
      },
      {
        t = "Label",
        base = {
          name = "slogan",
          text = "",
          fontinfo = "dark_white",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(500, 380)
        },
        config = {
          dimension = CCSizeMake(180, 120),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCTextAlignmentCenter
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "vitalityBg",
          parent = "bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(20, 10, 100, 28)
        },
        layout = {
          position = ccp(630, 425)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "money_icon",
          res = "UI/alpha/HVGA/guild/money_guildactive_big.png",
          parent = "vitalityBg"
        },
        layout = {
          position = ccp(140, 22)
        },
        config = {}
      },
      {
        t = "RichText",
        base = {
          name = "vitality",
          text = "",
          parent = "vitalityBg"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(100, 22)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "button",
          parent = "vitalityBg",
          downHandleName = "showVitalityInfo",
          upHandleName = "hideVitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {
          messageRect = CCRectMake(0, 0, 200, 200)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "vitalityInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(450, 340)
        },
        config = {
          scaleSize = CCSizeMake(450, 120),
          visible = false
        }
      },
      {
        t = "Label",
        base = {
          name = "explain_1",
          text = T(LSTR("guildconfig.1.10.001")),
          fontinfo = "dark_yellow",
          parent = "vitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(10, 105)
        },
        config = {horizontalAlignment = kCCTextAlignmentLeft}
      },
      {
        t = "Label",
        base = {
          name = "explain_2",
          text = T(LSTR("guildconfig.1.10.002")),
          fontinfo = "dark_yellow",
          parent = "vitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(10, 95)
        },
        config = {horizontalAlignment = kCCTextAlignmentLeft}
      },
      {
        t = "RichText",
        base = {
          name = "explain_3",
          text = T(LSTR("guildconfig.1.10.003")),
          parent = "vitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(10, 55)
        }
      },
      {
        t = "RichText",
        base = {
          name = "explain_4",
          text = T(LSTR("guildconfig.1.10.025")),
          parent = "vitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(10, 75)
        }
      },
      {
        t = "RichText",
        base = {
          name = "selfVitality",
          text = "",
          parent = "vitalityInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(10, 35)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_memberlist_bg.png",
          capInsets = CCRectMake(10, 10, 20, 20),
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 166)
        },
        config = {
          scaleSize = CCSizeMake(440, 255)
        }
      },
      {
        t = "ListView",
        base = {
          name = "memberList",
          parent = "bg",
          cliprect = CCRectMake(53, 50, 422, 244),
          priority = -200,
          handleName = "OnMemberClick",
          heightInner = 4,
          selfDealMessage = true,
          noShade = false,
          upShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png",
          downShade = "UI/alpha/HVGA/guild/guild_list_mask_up.png"
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
              position = ccp(32, -27)
            },
			nameWidth = 150,
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
              position = ccp(82, -17)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "normal_button",
              max_width = 160
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(103, -27)
            },
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "worship",
              res = "UI/alpha/HVGA/tavern_button_normal_1.png",
              capInsets = CCRectMake(20, 15, 88, 19)
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(370, -27)
            },
            config = {
              scaleSize = CCSizeMake(100, 43)
            }
          },
          {
            t = "Label",
            base = {
              name = "worshipLabel",
              text = T(LSTR("GUILDCONFIG.WORSHIP")),
              fontinfo = "ui_normal_button"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(370, -27)
            }
          },
          {
            t = "Label",
            base = {
              name = "job",
              text = T(""),
              fontinfo = "guild_player_title"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(250, -17)
            },
            config = {visible = false}
          }
        }
      }
    }
  },
  {
    layerName = "memberLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "memberInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(400, 150)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeMemberInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "memberInfo",
          handleName = "closeMemberInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(406, 155)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(135, 123)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "memberName",
          text = "",
          fontinfo = "normal_button",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(150, 120)
        }
      },
      {
        t = "Label",
        base = {
          name = "job",
          text = T(""),
          fontinfo = "normal_button",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(290, 118)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(110, 124)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "memberIcon", parent = "memberInfo"},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(80, 110)
        }
      },
      {
        t = "Label",
        base = {
          name = "memberLevel",
          text = "",
          fontinfo = "normal_button",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(124, 120)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "memberInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(30, 70)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "worship",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.WORSHIP")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "memberInfo",
          handleName = "OnWorship"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(150, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "chat",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.004")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "memberInfo",
          handleName = "onChat"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(225, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48),
		visible=false
        }
      },
      {t = "Fixs9bInst", name = "worship"},
      {t = "Fixs9bInst", name = "chat"}
    }
  },
  {
    layerName = "managerLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "managerSelect",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 420)
        },
        config = {
          scaleSize = CCSizeMake(200, 390),
          visible = false
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "setting",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.GUILD_SETTINGS")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "changeSetting"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 119)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "change",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.EDIT_ANNOUNCEMENT")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "changeAdvertise"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 196)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "join",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.APPLICATION")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "changeApply"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 350)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "dismiss",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.DISSOLVE_GUILD")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "dismissGuild"
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
          name = "dismiss",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.005")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "distributeReward"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 80)
        },
        config = {
          scaleSize = CCSizeMake(160, 48),
		visible=false
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "member",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.006")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "managerSelect",
          handleName = "showMemberManager"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 273)
        },
        config = {
          scaleSize = CCSizeMake(160, 48)
        }
      },
      {
        t = "Fixs9bListInst",
        size = CCSizeMake(160, 48),
        list = {
          "setting",
          "change",
          "join",
          "dismiss",
          "share",
          "member"
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeApplyInfo",
          parent = "managerSelect",
          clickPos = "outSide",
          handleName = "CloseManager"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {
          messageRect = CCRectMake(0, 0, 200, 200)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "applyTab",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "managerSelect",
          z = 10
        },
        layout = {
          position = ccp(174, 366)
        },
        config = {visible = false}
      },
      {
        t = "Fixs9sInst",
        name = "managerSelect",
        refer = {"setting", "sprite"},
        offsetSize = CCSizeMake(80, 0)
      },
      {
        t = "SetPosInst",
        name = {
          "setting",
          "change",
          "join",
          "dismiss",
          "share",
          "member"
        },
        parent = "managerSelect",
        parentMode = "x"
      },
      {
        t = "Sprite",
        base = {name = "applyInfo"},
        config = {visible = false}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "frame",
          res = "UI/alpha/HVGA/guild/guild_request_bg.png",
          capInsets = CCRectMake(100, 30, 100, 10),
          parent = "applyInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 230)
        },
        config = {
          scaleSize = CCSizeMake(600, 410)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/Normal_title_bg.png",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 400)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.APPLICATION")),
          fontinfo = "title_yellow",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 400)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_MEMBERS_")),
          fontinfo = "dark_yellow",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 370)
        }
      },
      {
        t = "Label",
        base = {
          name = "merberNum",
          text = "",
          fontinfo = "dark_white",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(350, 370)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeApplyInfo",
          res = {
            normal = "UI/alpha/HVGA/herodetail-detail-close.png",
            press = "UI/alpha/HVGA/herodetail-detail-close-p.png"
          },
          parent = "frame",
          handleName = "closeApplyInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(615, 422)
        }
      },
      {
        t = "Label",
        base = {
          name = "applyDesc",
          text = T(LSTR("GUILDCONFIG.NO_NEW_APPLICATION")),
          fontinfo = "dark_yellow",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(285, 320)
        }
      },
      {
        t = "ListView",
        base = {
          name = "applyList",
          parent = "frame",
          cliprect = CCRectMake(18, 30, 560, 320),
          priority = -200,
          handleName = "OnGuildApplyClick",
          noShade = false,
          selfDealMessage = true
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
              position = ccp(0, 0)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(100, -14)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(69, -12)
            },
            config = {}
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "agree",
              res = "UI/alpha/HVGA/tavern_button_normal_1.png",
              capInsets = CCRectMake(20, 15, 88, 19)
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(457, -3)
            },
            config = {
              scaleSize = CCSizeMake(70, 49)
            }
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "refuse",
              res = "UI/alpha/HVGA/tavern_button_normal_1.png",
              capInsets = CCRectMake(20, 15, 88, 19)
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(528, -3)
            },
            config = {
              scaleSize = CCSizeMake(70, 49)
            }
          },
          {
            t = "Label",
            base = {
              name = "agreeLabel",
              text = T(LSTR("GUILDCONFIG.ALLOW")),
              fontinfo = "ui_normal_button"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(457, -18)
            }
          },
          {
            t = "Label",
            base = {
              name = "refuseLabel",
              text = T(LSTR("GUILDCONFIG.DENY")),
              fontinfo = "ui_normal_button"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(528, -18)
            }
          },
          {
            t = "Label",
            base = {
              name = "result",
              text = T(LSTR("GUILDCONFIG.APPLICATION_APPROVED")),
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(450, -18)
            },
            config = {visible = false}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(37, -26)
            },
			nameWidth = 150,
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
              position = ccp(86, -17)
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
              position = ccp(109, -17)
            },
            listData = true
          }
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "adviceInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 350)
        },
        config = {
          scaleSize = CCSizeMake(500, 150),
          visible = false
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "adviceInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 120)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.EDIT_ANNOUNCEMENT")),
          fontinfo = "title_yellow",
          parent = "adviceInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 120)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22),
          parent = "adviceInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(40, 50)
        },
        config = {
          scaleSize = CCSizeMake(300, 42)
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
          parent = "adviceInfo",
          handleName = "applyAdvice"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 49)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeAdviceInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "adviceInfo",
          handleName = "closeAdviceInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(512, 157)
        }
      },
      {
        t = "EditBox",
        base = {
          name = "sloganInput"
        },
        config = {
          visible = false,
          editSize = CCSizeMake(280, 50),
          maxLength = 30,
          fontColor = ccc3(0, 0, 0),
          fontSize = 20,
          position = ccp(340, 250)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "settingInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(450, 350),
          visible = false
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 320)
        },
        config = {
          scalexy = {x = 0.8, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_SETTINGS")),
          fontinfo = "title_yellow",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 320)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CONFIRM_MODIFICATION")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "settingInfo",
          handleName = "applySetting"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 40)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeAdviceInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "settingInfo",
          handleName = "closeSettingInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(460, 357)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "guildIcon",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(196, 250)
        },
        conifg = {scale = 0.9}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/equip_frame_white.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(196, 249)
        },
        conifg = {scale = 0.9}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_LOGO_")),
          fontinfo = "normal_button",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 250)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "change",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CHANGE")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "settingInfo",
          handleName = "changeIcon"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(360, 250)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_TYPE_")),
          fontinfo = "normal_button",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 185)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(280, 178)
        },
        config = {scale = 1.9}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(280, 115)
        },
        config = {scale = 1.9}
      },
      {
        t = "Label",
        base = {
          name = "guildType",
          text = T(LSTR("GUILDCONFIG.ALL_PLAYERS_CAN_JOIN")),
          fontinfo = "normal_button",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(283, 178)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.MINIMUM_TEAM_LEVEL")),
          fontinfo = "normal_button",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 115)
        }
      },
      {
        t = "Label",
        base = {
          name = "guildLimit",
          text = "30",
          fontinfo = "normal_button",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(283, 115)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "subType",
          res = {
            normal = "UI/alpha/HVGA/sell_number_button.png"
          },
          parent = "settingInfo",
          handleName = "subType"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 178)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "addType",
          res = {
            normal = "UI/alpha/HVGA/sell_number_button.png"
          },
          parent = "settingInfo",
          handleName = "addType"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 178)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "subimit",
          res = {
            normal = "UI/alpha/HVGA/sell_number_button.png"
          },
          parent = "settingInfo",
          handleName = "subLimit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 115)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "addLimit",
          res = {
            normal = "UI/alpha/HVGA/sell_number_button.png"
          },
          parent = "settingInfo",
          handleName = "addLimit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_settings_button_left.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 180)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_settings_button_right.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 180)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_settings_button_left.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_settings_button_right.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
          parent = "settingInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(225, 75)
        }
      },
--      {
--        t = "Label",
--        base = {
--          name = "ui",
--         text = T(LSTR("guildconfig.2.0.0.001")),
--          fontinfo = "normal_button",
--          parent = "settingInfo"
--        },
--        layout = {
--          anchor = ccp(0, 0.5),
--          position = ccp(30, 100)
--        }
--      },
--      {
--        t = "CheckButton",
--        base = {
--          name = "enableJoin",
--          parent = "settingInfo",
--          res = {
--            normal = "UI/alpha/HVGA/playerinfo_button_notice_open.png",
--            press = "UI/alpha/HVGA/playerinfo_button_notice_close.png"
--          },
--          handleName = "changeJoinTeam"
--        },
--        layout = {
--          anchor = ccp(1, 0.5),
--          position = ccp(390, 100)
--        }
--      },
      {
        t = "FixScaleInst",
        name = "guildType",
        mode = "w",
        size = CCSizeMake(164, 0)
      },
      {t = "Fixs9bInst", name = "conform"}
    }
  },
  {
    layerName = "memberManagerLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    initVisible = false,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {name = "applyInfo"},
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "frame",
          res = "UI/alpha/HVGA/guild/guild_request_bg.png",
          capInsets = CCRectMake(100, 30, 100, 10),
          parent = "applyInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 230)
        },
        config = {
          scaleSize = CCSizeMake(600, 420)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/Normal_title_bg.png",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 410)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.006")),
          fontinfo = "title_yellow",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 410)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUILD_MEMBERS_")),
          fontinfo = "dark_yellow",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 370)
        }
      },
      {
        t = "Label",
        base = {
          name = "merberNum",
          text = "",
          fontinfo = "dark_white",
          parent = "frame"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(350, 370)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeMemberManager",
          res = {
            normal = "UI/alpha/HVGA/herodetail-detail-close.png",
            press = "UI/alpha/HVGA/herodetail-detail-close-p.png"
          },
          parent = "frame",
          handleName = "closeMemberManager"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(620, 430)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "time",
          parent = "frame",
          buttonName = {
            text = T(LSTR("guildconfig.2.0.0.002")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(10, 10, 50, 29),
          handleName = "rankByTime"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(40, 330)
        },
        config = {
          scaleSize = CCSizeMake(150, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "active",
          parent = "frame",
          buttonName = {
            text = T(LSTR("guildconfig.2.0.0.003")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(10, 10, 50, 29),
          handleName = "rankByactive"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(400, 330)
        },
        config = {
          scaleSize = CCSizeMake(150, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "guildInstance",
          parent = "frame",
          buttonName = {
            text = T(LSTR("guildconfig.2.0.0.004")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(10, 10, 50, 29),
          handleName = "rankByGuildInstance"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(400, 330)
        },
        config = {
          scaleSize = CCSizeMake(150, 48),
		visible=false
        }
      },
      {
        t = "ListView",
        base = {
          name = "membersList",
          parent = "frame",
          newClickFunc = true,
          cliprect = CCRectMake(30, 30, 545, 280),
          priority = -200,
          noShade = false,
          selfDealMessage = true
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {name = "parent"},
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(270, 0)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/guild/guild_member_bg.png",
              parent = "parent"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(0, -27)
            },
            config = {
              scalexy = {x = 1.3, y = 1}
            }
          },
          {
            t = "SpriteButton",
            base = {
              name = "button",
              handleName = "onMemberManager",
              downHandleName = "scaleDownMember",
              upHandleName = "scaleUpMember"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(280, 0)
            },
            config = {
              messageRect = CCRectMake(0, 0, 500, 60)
            }
          },
          {
            t = "Sprite",
            base = {name = "icon", parent = "parent"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(-220, -27)
            },
			  nameWidth = 135,
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "job",
              parent = "parent",
              text = T(""),
              fontinfo = "guild_player_title"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(-40, -18)
            },
            config = {visible = false}
          },
          {
            t = "RichText",
            base = {
              name = "info",
              text = "",
              parent = "parent"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(40, -26)
            } or {
              anchor = ccp(0, 1),
              position = ccp(30, -16)
            },
            listData = true
          }
        }
      }
    }
  },
  {
    layerName = "jobChangeLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "memberInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 230)
        },
        config = {
          scaleSize = CCSizeMake(250, 280)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeMemberInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "memberInfo",
          handleName = "closeJobChange"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(260, 300)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(90, 245)
        },
        config = { scalexy = {x = 0.7, y = 1} }
      },
      {
        t = "Label",
        base = {
          name = "memberName",
          text = "",
          fontinfo = "normal_button",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(110, 243)
        }
      },
--      {
--        t = "Label",
--        base = {
--          name = "job",
--          text = T(""),
--          fontinfo = "normal_button",
--          parent = "memberInfo"
--        },
--        layout = {
--          anchor = ccp(0, 1),
--          position = ccp(270, 258)
--        },
--        config = {}
--      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(63, 248)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "memberIcon", parent = "memberInfo"},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(40, 235)
        }
      },
      {
        t = "Label",
        base = {
          name = "memberLevel",
          text = "",
          fontinfo = "normal_button",
          parent = "memberInfo"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(80, 245)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "memberInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(10, 200)
        },
        config = { scalexy = {x = 0.6, y = 1} }
      },
      {
        t = "Scale9Button",
        base = {
          name = "elder",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.007")),
            fontInfo = "ui_normal_button",
            size = 24
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(30, 20, 20, 20),
          parent = "memberInfo",
          handleName = "onElder"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(24, 160)
        },
        config = {
          scaleSize = CCSizeMake(200, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "disElder",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.008")),
            fontInfo = "ui_normal_button",
            size = 24
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(30, 20, 20, 20),
          parent = "memberInfo",
          handleName = "onDisElder"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(24, 160)
        },
        config = {
          scaleSize = CCSizeMake(200, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "promotion",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.PROMOTE_TO_HOST")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(30, 20, 20, 20),
          parent = "memberInfo",
          handleName = "OnPromotion"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(24, 110)
        },
        config = {
          scaleSize = CCSizeMake(200, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "discharge",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.KICK_OUT")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/herodetail-upgrade.png",
            press = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
            disable = "UI/alpha/HVGA/herodetail-upgrade-disabled.png"
          },
          capInsets = CCRectMake(30, 20, 20, 20),
          parent = "memberInfo",
          handleName = "OnDischarge"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(24, 60)
        },
        config = {
          scaleSize = CCSizeMake(200, 48)
        }
      }
    }
  },
  {
    layerName = "worshihInfoLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    initVisible = false,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "worshihInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(500, 250)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 220)
        },
        config = {
          scalexy = {x = 0.8, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.WORSHIP_BIG_SHOT")),
          fontinfo = "title_yellow",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 220)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.YOU_CAN_ONLY_WORSHIP_PLAYERS_5_TEAM_LEVEL_HIGHER_THAN_YOURS_FOR_EACH_WORSHIP_YOU_GET_ENERGY_AS_REWARD_WHILE_PLAYER_BEEN_WORSHIPED_GET_COINS_AS_REWARD")),
          fontinfo = "normal_button",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(248, 160)
        },
        config = {
          dimension = CCSizeMake(390, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.WORSHIP_TIMES_LEFT_TODAY_")),
          fontinfo = "normal_button",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(53, 100)
        }
      },
      {
        t = "Label",
        base = {
          name = "leftTime",
          text = "",
          fontinfo = "normal_button",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(240, 100)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.YOU_ACCUMULATED_REWARDS_TO_CLAIM_")),
          fontinfo = "normal_button",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(53, 50)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/goldicon_small.png",
          parent = "worshihInfo"
        },
        layout = {
          position = ccp(250, 50)
        }
      },
      {
        t = "Label",
        base = {
          name = "worshTime",
          text = "",
          fontinfo = "normal_button",
          parent = "worshihInfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(270, 50)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.CLAIM_REWARDS")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "worshihInfo",
          handleName = "reqWorshReward"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 50)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "getRewardTag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "worshihInfo",
          z = 10
        },
        layout = {
          position = ccp(445, 65)
        },
        config = {visible = false}
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeAdviceInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "worshihInfo",
          handleName = "closeWorshInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(510, 255)
        }
      }
    }
  },
  {
    layerName = "worshihTypeLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "worshihType",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 380)
        },
        config = {
          scaleSize = CCSizeMake(520, 300)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "worshihType"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 270)
        },
        config = {
          scalexy = {x = 0.9, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.SELECT_WORSHIP_MODE_")),
          fontinfo = "guild_worship_title",
          parent = "worshihType"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 270)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "worship1",
          parent = "worshihType"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(0, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "freeType",
          res = {
            normal = "UI/alpha/HVGA/act/act_select_bg.png",
            press = "UI/alpha/HVGA/act/act_select_bg_chosen.png"
          },
          parent = "worship1",
          handleName = "freeWorship"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 140)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 145)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/task_vit_icon.png",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 144)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "exp1",
          text = "0",
          fontinfo = "guild_worship_exp_amount",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(123, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_comment_bg.png",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 10)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "free",
          text = T(LSTR("GUILDCONFIG.FREE")),
          fontinfo = "guild_worship_price_free",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 10)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "ui",
          res = {
            normal = "UI/alpha/HVGA/guild/guild_worship_select_free.png",
            press = "UI/alpha/HVGA/guild/guild_worship_select_free_2.png"
          },
          parent = "worship1",
          handleName = "freeWorship"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(100, 101)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.ENERGY_GAINED_")),
          fontinfo = "dark_yellow",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 55)
        }
      },
      {
        t = "Label",
        base = {
          name = "reward1",
          text = "100",
          fontinfo = "dark_white",
          parent = "worship1"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(150, 55)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "worship2",
          parent = "worshihType"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(0, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "goldType",
          res = {
            normal = "UI/alpha/HVGA/act/act_select_bg.png",
            press = "UI/alpha/HVGA/act/act_select_bg_chosen.png"
          },
          parent = "worship2",
          handleName = "goldWorship"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 140)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 145)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/task_vit_icon.png",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 144)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "exp2",
          text = "0",
          fontinfo = "guild_worship_exp_amount",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(283, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_comment_bg.png",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(260, 10)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "goldCost",
          text = "0",
          fontinfo = "guild_worship_price_not_free",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(270, 10)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "ui",
          res = {
            normal = "UI/alpha/HVGA/guild/guild_worship_select_gold.png",
            press = "UI/alpha/HVGA/guild/guild_worship_select_gold_2.png"
          },
          parent = "worship2",
          handleName = "goldWorship"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(260, 101)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "money_icon",
          res = "UI/alpha/HVGA/goldicon_small.png",
          parent = "worship2"
        },
        layout = {
          position = ccp(220, 10)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.ENERGY_GAINED_")),
          fontinfo = "dark_yellow",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 55)
        }
      },
      {
        t = "Label",
        base = {
          name = "reward2",
          text = "100",
          fontinfo = "dark_white",
          parent = "worship2"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(310, 55)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "worship3",
          parent = "worshihType"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(0, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "rmbType",
          res = {
            normal = "UI/alpha/HVGA/act/act_select_bg.png",
            press = "UI/alpha/HVGA/act/act_select_bg_chosen.png"
          },
          parent = "worship3",
          handleName = "rmbWorship"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(420, 140)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_icon_bg.png",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(420, 145)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/task_vit_icon.png",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(420, 144)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "exp3",
          text = "0",
          fontinfo = "guild_worship_exp_amount",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(440, 115)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_comment_bg.png",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(420, 10)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "rmbCost",
          text = "0",
          fontinfo = "guild_worship_price_not_free",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(430, 10)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "ui",
          res = {
            normal = "UI/alpha/HVGA/guild/guild_worship_select_diamond.png",
            press = "UI/alpha/HVGA/guild/guild_worship_select_diamond_2.png"
          },
          parent = "worship3",
          handleName = "rmbWorship"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(420, 101)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rmb_icon",
          res = "UI/alpha/HVGA/shop_token_icon.png",
          parent = "worship3"
        },
        layout = {
          position = ccp(390, 10)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.ENERGY_GAINED_")),
          fontinfo = "dark_yellow",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(410, 55)
        }
      },
      {
        t = "Label",
        base = {
          name = "reward3",
          text = "100",
          fontinfo = "dark_white",
          parent = "worship3"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(470, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeWorshipType",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "worshihType",
          handleName = "closeWorshipType"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(530, 305)
        }
      }
    }
  },
  {
    layerName = "herosCampLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "campInfo",
          res = "UI/alpha/HVGA/guild/guild_hire_bg_1.png",
          capInsets = CCRectMake(45, 45, 500, 15),
          z = 1
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(380, 435)
        },
        config = {
          scaleSize = CCSizeMake(550, 400)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/crusade_title_short_bg.png",
          z = 20
        },
        layout = {
          position = ccp(380, 426)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.MERCENARY_CAMP")),
          fontinfo = "title_yellow",
          parent = "ui"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(175, 32)
        }
      },
      {
        t = "Sprite",
        base = {name = "selfHeros", z = 2},
        layout = {
          anchor = ccp(0.5, 0),
          position = ccp(380, 372)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/guild/guild_hire_bg_2.png",
          parent = "selfHeros"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(0, 64)
        },
        config = {
          scalexy = {x = 1.01, y = 1.015}
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "rule",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.DESCRIPTION")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "selfHeros",
          handleName = "showRule"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(-172, -13)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.MERCENARIES_DEPLOYED_")),
          fontinfo = "guild_hire_sent_hero_amount_title",
          parent = "selfHeros"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(5, -10)
        }
      },
      {
        t = "Label",
        base = {
          name = "sendNum",
          text = "0/2",
          fontinfo = "guild_hire_sent_hero_amount_number",
          parent = "selfHeros"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(75, -10)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "sendHero",
          buttonName = {
            text = T(LSTR("GUILDCONFIG.DEPLOY_MERCENARIES")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "selfHeros",
          handleName = "sendHero"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(175, -13)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Fixs9bInst",
        name = "sendHero",
        anchor = "right"
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/equipupgrade/equipupgrade_bottom_bg.png",
          parent = "selfHeros",
          capInsets = CCRectMake(10, 10, 640, 146)
        },
        layout = {
          position = ccp(1, -175)
        },
        config = {
          scaleSize = CCSizeMake(500, 270)
        }
      },
      {
        t = "ListView",
        base = {
          name = "selfMercenaryList",
          parent = "selfHeros",
          cliprect = CCRectMake(-230, -305, 465, 262),
          priority = -200,
          handleName = "OnSelfMercenaryClick",
          noShade = false,
          selfDealMessage = true,
          upShade = "UI/alpha/HVGA/guild/guild_hire_myhero_list_mask.png",
          downShade = "UI/alpha/HVGA/guild/guild_hire_myhero_list_mask.png"
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/guild/guild_hire_hero_bg_2.png",
              capInsets = CCRectMake(100, 30, 50, 20)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 0)
            },
            config = {
              scaleSize = CCSizeMake(465, 95)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "addHero",
              res = "UI/alpha/HVGA/herodetail-equipadd.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(58, -41)
            }
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "returnHero",
              res = "UI/alpha/HVGA/tavern_button_normal_1.png",
              capInsets = CCRectMake(20, 15, 88, 19)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(355, -25)
            },
            config = {
              visible = false,
              scaleSize = CCSizeMake(100, 50)
            }
          },
          {
            t = "Label",
            base = {
              name = "back",
              text = T(LSTR("GUILDCONFIG.RETURN_IMMEDIATELY")),
              fontinfo = "ui_normal_button",
              parent = "returnHero"
            },
            layout = {mediate = true},
            config = {visible = false}
          },
          {
            t = "Fixs9bInst",
            button = "returnHero",
            label = "back",
            offset = 10,
            anchor = "right"
          },
          {
            t = "Label",
            base = {
              name = "returnDes",
              text = T(LSTR("GUILDCONFIG.GUARDING_TIME_")),
              fontinfo = "guild_hire_sent_hero_amount_title"
            },
            layout = {
              anchor = ccp(0.5, 1),
              position = ccp(150, -50)
            },
            config = {visible = false}
          },
          {
            t = "Sprite",
            base = {
              name = "glodIcon",
              res = "UI/alpha/HVGA/task_gold_icon_2.png"
            },
            layout = {
              position = ccp(220, -20)
            },
            config = {visible = false, scale = 0.85}
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = T(LSTR("GUILDCONFIG.ACCUMULATED_INCOME_")),
              fontinfo = "guild_hire_sent_hero_amount_title"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(150, -20)
            },
            config = {visible = false}
          },
          {
            t = "Label",
            base = {
              name = "sendHint",
              text = T(LSTR("GUILDCONFIG.DEPLOY_MERCENARIES")),
              fontinfo = "guild_send_hero_green"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(58, -70)
            }
          },
          {
            t = "Sprite",
            base = {name = "heroIcon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(60, -46)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "income",
              text = "",
              fontinfo = "guild_hire_my_hero_income_number"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(260, -20)
            },
            config = {visible = false},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "returnTime",
              text = "",
              fontinfo = "guild_hire_my_hero_time"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(200, -50)
            },
            config = {visible = false},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "sendHint2",
              text = T(LSTR("GUILDCONFIG.MERCENARIES_ARE_PAID_WITH_COINS_BY_THE_HOUR_\N_OTHER_PLAYERS_IN_THE_GUILD_CAN_PAY_THE_COINS")),
              fontinfo = "small_normal_button"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(115, -46)
            },
            config = {
              horizontalAlignment = kCCTextAlignmentLeft,
			color = ccc3(65, 64, 63)
			--[[
              stroke = {
                color = ccc3(0, 0, 0),
                size = 1
              }
			--]]
            }
          }
        }
      },
      {
        t = "Sprite",
        base = {name = "allHeros", z = 3},
        layout = {
          anchor = ccp(0.5, 0),
          position = ccp(110, 100)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "allHeros"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 270)
        },
		config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.ALL_MERCENARIES_OF_THE_GUILD")),
          fontinfo = "title_yellow",
          parent = "allHeros"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 270)
        }
      },
      {
        t = "ListView",
        base = {
          name = "heroList",
          parent = "allHeros",
          cliprect = CCRectMake(20, -16, 500, 265),
          priority = -200,
          colNum = 3,
          heightInner = 0,
          selfDealMessage = true,
          handleName = "OnMercenaryListClick"
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/guild/guild_hire_hero_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 0)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(85, -77)
            },
            config = {},
            specialType = "hero",
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
              anchor = ccp(0.5, 0.5),
              position = ccp(82, -20)
            },
            listData = true
          }
        }
      },
      {
        t = "CheckButton",
        base = {
          name = "page1",
          res = {
            normal = "UI/alpha/HVGA/classbtn.png",
            press = "UI/alpha/HVGA/classbtnselected.png"
          },
          handleName = "showHeroPage",
          arrayIndex = 1,
          normalZ = 0,
          pressZ = 2
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(746, 310)
        }
      },
      {
        t = "CheckButton",
        base = {
          name = "page2",
          res = {
            normal = "UI/alpha/HVGA/classbtn.png",
            press = "UI/alpha/HVGA/classbtnselected.png"
          },
          handleName = "showHeroPage",
          arrayIndex = 2,
          normalZ = 0,
          pressZ = 2
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(746, 250)
        }
      },
      {
        t = "Label",
        base = {
          name = "myHero",
          text = T(LSTR("GUILDCONFIG.MY_MERCENARIES")),
          fontinfo = "ui_normal_button",
          z = 3
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(692, 310)
        }
      },
      {
        t = "Label",
        base = {
          name = "allHero",
          text = T(LSTR("GUILDCONFIG.ALL_MERCENARIES")),
          fontinfo = "ui_normal_button",
          z = 3
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(692, 250)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeCampInfo",
          z = 2,
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "closeCampInfo"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(680, 445)
        }
      },
      {
        t = "FixScaleInst",
        name = "myHero",
        size = CCSizeMake(80, 0),
        mode = "w"
      },
      {
        t = "FixScaleInst",
        name = "allHero",
        size = CCSizeMake(80, 0),
        mode = "w"
      },
      {
        t = "FixScale2SameInst",
        list = {"myHero", "allHero"},
        mode = "min"
      }
    }
  },
  {
    layerName = "rewardLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "rewardResult"
        },
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
          res = "UI/alpha/HVGA/common/common_getitem_bg.png",
          capInsets = CCRectMake(70, 84, 325, 10),
          parent = "rewardResult"
        },
        layout = {
          position = ccp(91, 100)
        },
        config = {
          scaleSize = CCSizeMake(400, 252)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 188)
        },
        config = {
          scalexy = {x = 0.6, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.COMMISSION_ACQUIRED")),
          parent = "rewardResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(90, 188)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.EMPLOYMENT_INCOME_")),
          parent = "rewardResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(15, 130)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.GUARDIANSHIP_INCOME_")),
          parent = "rewardResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(15, 90)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/goldicon_small.png",
          parent = "rewardResult"
        },
        layout = {
          position = ccp(100, 130)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/goldicon_small.png",
          parent = "rewardResult"
        },
        layout = {
          position = ccp(100, 90)
        }
      },
      {
        t = "Label",
        base = {
          name = "income1",
          text = "5000",
          parent = "rewardResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(150, 130)
        }
      },
      {
        t = "Label",
        base = {
          name = "income2",
          text = "5000",
          parent = "rewardResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(150, 90)
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
          parent = "rewardResult",
          handleName = "conformReward"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 30)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      }
    }
  },
  {
    layerName = "worshipRewardLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -1,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "rewardResult"
        },
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
          res = "UI/alpha/HVGA/common/common_getitem_bg.png",
          capInsets = CCRectMake(70, 84, 325, 10),
          parent = "rewardResult"
        },
        layout = {
          position = ccp(91, 100)
        },
        config = {
          scaleSize = CCSizeMake(400, 252)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png",
          parent = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 188)
        },
        config = {
          scalexy = {x = 0.6, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.WORSHIPMENT_AWARDS")),
          parent = "rewardResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(90, 188)
        }
      },
      {
        t = "Label",
        base = {
          name = "type",
          text = T(LSTR("GUILDCONFIG.ENERGY_GAINED_")),
          parent = "rewardResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(40, 110)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "icon",
          res = "UI/alpha/HVGA/task_vit_icon.png",
          parent = "rewardResult"
        },
        layout = {
          position = ccp(150, 110)
        }
      },
      {
        t = "Label",
        base = {
          name = "income1",
          text = "5000",
          parent = "rewardResult",
          fontinfo = "guild_worship_exp_amount"
        },
        layout = {
          position = ccp(170, 85)
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
          parent = "rewardResult",
          handleName = "conformWorshipReward"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(100, 30)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      }
    }
  },
  {
    layerName = "ruleLayer",
    layerColor = ccc4(0, 0, 0, 190),
    layerOrder = 100,
    delayLoad = true,
    touchInfo = {
      iPriority = -200,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "ruleInfo",
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
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.RULES_FOR_ROOKIES_OF_MERCENARY_POST")),
          size = 22,
          parent = "ruleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(270, 320)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "heroInfo",
          parent = "ruleInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 320)
        },
        config = {
          scalexy = {x = 1.3, y = 1.1}
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeRuleInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "ruleInfo",
          handleName = "closeRuleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(534, 340)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listview",
          cliprect = CCRectMake(140, 90, 500, 250),
          priority = -200,
          selfDealMessage = trued
        },
        itemConfig = {
          {
            t = "RichText",
            base = {name = "name", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, 0)
            },
            listData = true
          }
        }
      }
    }
  },
  {
    layerName = "guildInstanceLayer",
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -20,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/guild/guild_hire_bg_1.png",
          capInsets = CCRectMake(35, 40, 50, 40),
          z = 1
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(400, 430)
        },
        config = {
          scaleSize = CCSizeMake(550, 394)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/Normal_title_bg.png",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 384)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.009")),
          fontinfo = "title_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 385)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "openInstance",
          parent = "bg",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.010")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "reqRewardRecord"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(443, 330)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "rule",
          parent = "bg",
          buttonName = {
            text = T(LSTR("EXCAVATEMAP.RULES")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "openRule"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(130, 330)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Fixs9bInst",
        name = "openInstance",
        anchor = "right"
      },
      {
        t = "ListView",
        base = {
          name = "instanceList",
          parent = "bg",
          cliprect = CCRectMake(25, 20, 500, 280),
          priority = -200,
          handleName = "OnRewardListClick",
          noShade = false,
          selfDealMessage = true,
          heightInner = 0,
          newClickFunc = true,
          bar = {
            bglen = 270,
            bgpos = ccp(17, 155)
          }
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/task_board.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(250, -40)
            },
            config = {}
          },
          {
            t = "RichText",
            base = {name = "item", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(21, -6)
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/hero_icon_frame_1.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(17, -4)
            },
            config = {scale = 0.8}
          },
          {
            t = "Sprite",
            base = {
              name = "battle",
              res = "UI/alpha/HVGA/guild/guild_battle_icon.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(60, -50)
            },
            config = {visible = false}
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "guild_worship_exp_amount",
              size = 17
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -17)
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "progressBg",
              res = "UI/alpha/HVGA/guild/guild_progress_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -67)
            },
            config = {}
          },
          {
            t = "ClippingNode",
            base = {
              name = "clippingNode",
              stencil = "UI/alpha/HVGA/guild/guild_progress_mask.png",
              scalexy = {x = 0, y = 1}
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -67)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "progressIcon",
              res = "UI/alpha/HVGA/guild/guild_progress.png",
              parent = "clippingNode"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, 0)
            },
            config = {}
          },
          {
            t = "RichText",
            base = {name = "progress", text = ""},
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(220, -67)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "leftTime",
              text = T("")
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -40)
            },
            listData = true
          },
          {
            t = "Scale9Button",
            base = {
              name = "goInstance",
              buttonName = {
                text = T(LSTR("guildconfig.1.10.011")),
                fontInfo = "ui_normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/task_button.png",
                press = "UI/alpha/HVGA/task_button_press.png"
              },
              capInsets = CCRectMake(15, 20, 45, 15),
              handleName = "goInstance"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(430, -52)
            },
            config = {
              scaleSize = CCSizeMake(100, 48)
            }
          },
          {
            t = "Scale9Button",
            base = {
              name = "select",
              buttonName = {
                text = T(LSTR("guildconfig.1.10.011")),
                fontInfo = "ui_normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/task_button.png",
                press = "UI/alpha/HVGA/task_button_press.png"
              },
              capInsets = CCRectMake(15, 20, 45, 15),
              handleName = "showInstanceManager"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(440, -55)
            },
            config = {
              scaleSize = CCSizeMake(80, 40)
            }
          },
          {
            t = "Fixs9bInst",
            name = "goInstance",
            offset = 10,
            anchor = "left"
          },
          {
            t = "Scale9Button",
            base = {
              name = "openInstance",
              buttonName = {
                text = T(LSTR("guildconfig.2.0.0.005")),
                fontInfo = "normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/task_button.png",
                press = "UI/alpha/HVGA/task_button_press.png"
              },
              capInsets = CCRectMake(15, 20, 45, 15),
              handleName = "openInstance"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(440, -55)
            },
            config = {
              scaleSize = CCSizeMake(80, 40)
            }
          },
          {
            t = "RichText",
            base = {
              name = "openCost",
              text = T("")
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(395, -18)
            },
            config = {visible = false}
          },
          {
            t = "SpriteButton",
            base = {
              name = "detail",
              res = {},
              handleName = "showInstanceDetail"
            },
            layout = {
              position = ccp(160, -30)
            },
            config = {
              messageRect = CCRectMake(0, 0, 300, 80)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "mask",
              res = "UI/alpha/HVGA/task_board_mask.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(250, -40)
            },
            config = {visible = false}
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          res = {
            normal = "UI/alpha/HVGA/herodetail-detail-close.png"
          },
          handleName = "closeInstance"
        },
        layout = {
          position = ccp(540, 380)
        }
      }
    }
  },
  {
    layerName = "instanceRuleLayer",
    layerColor = ccc4(0, 0, 0, 190),
    layerOrder = 100,
    delayLoad = true,
    touchInfo = {
      iPriority = -200,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "ruleInfo",
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
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.009")),
          fontinfo = "title_yellow",
          size = 22,
          parent = "ruleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(270, 320)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "heroInfo",
          parent = "ruleInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 320)
        },
        config = {
          scalexy = {x = 1.3, y = 1.1}
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeRuleInfo",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "ruleInfo",
          handleName = "closeInstanceRule"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(534, 340)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listview",
          cliprect = CCRectMake(140, 90, 500, 250),
          priority = -200
        },
        itemConfig = {
          {
            t = "RichText",
            base = {name = "name", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, 0)
            },
            listData = true
          }
        }
      }
    }
  },
  {
    layerName = "instanceManagerLayer",
    iPriority = 0,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
    touchInfo = {
      iPriority = -50,
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
          scaleSize = CCSizeMake(165, 118)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "goInstance",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.011")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bg",
          handleName = "goInstance"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(84, 85)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "resetInstance",
          buttonName = {
            text = T(LSTR("guildconfig.1.10.012")),
            fontInfo = "ui_normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bg",
          handleName = "selectInstance"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(84, 35)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          clickPos = "outSide",
          handleName = "closeInstanceMangaer"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {
          messageRect = CCRectMake(0, 0, 200, 200)
        }
      }
    }
  },
  {
    layerName = "instanceConformLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
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
          scaleSize = CCSizeMake(360, 250)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.013")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 220)
        }
      },
      {
        t = "RichText",
        base = {
          name = "opened",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 200)
        }
      },
      {
        t = "RichText",
        base = {
          name = "leftTime",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 180)
        }
      },
      {
        t = "RichText",
        base = {
          name = "time",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 160)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.014")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 120)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.015")),
          fontinfo = "dark_yellow",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(30, 100)
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
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 80)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "cancelOpen",
          parent = "bg",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CANCEL")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "cancelOpen"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 40)
        },
        config = {
          scaleSize = CCSizeMake(110, 50)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conformOpen",
          parent = "bg",
          buttonName = {
            text = T(LSTR("CHATCONFIG.CONFIRM")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "conformOpen"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(270, 40)
        },
        config = {
          scaleSize = CCSizeMake(110, 50)
        }
      }
    }
  },
  {
    layerName = "rewardInfoLayer",
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
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
          scaleSize = CCSizeMake(470, 350)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rewardList",
          parent = "bg",
          cliprect = CCRectMake(40, 20, 400, 310),
          priority = -200,
          handleName = "OnRewardListClick",
          noShade = false,
          selfDealMessage = true,
          heightInner = 3,
          newClickFunc = true
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
              position = ccp(0, -30)
            },
            config = {
              scalexy = {x = 3, y = 3}
            }
          },
          {
            t = "RichText",
            base = {name = "item", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(5, -2)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {name = "time", text = ""},
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(85, -45)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "hint",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(85, -20)
            },
            listData = true
          },
          {
            t = "Scale9Button",
            base = {
              name = "distribute",
              buttonName = {
                text = T(LSTR("guildconfig.1.10.016")),
                fontInfo = "normal_button"
              },
              res = {
                normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
                press = "UI/alpha/HVGA/tavern_button_normal_2.png"
              },
              capInsets = CCRectMake(14, 20, 60, 23),
              handleName = "distributeItem"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(330, -30)
            },
            config = {
              scaleSize = CCSizeMake(110, 45)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -10)
            },
            config = {
              scalexy = {x = 3, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(LSTR("guildconfig.1.10.017")),
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(200, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -30)
            }
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
          handleName = "closeRewarInfoLayer"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(477, 360)
        }
      }
    }
  },
  {
    layerName = "rewardDetailLayer",
    layerColor = ccc4(0, 0, 0, 190),
    delayLoad = true,
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
          scaleSize = CCSizeMake(470, 350)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rewardList",
          parent = "bg",
          cliprect = CCRectMake(25, 10, 420, 320),
          priority = -200,
          handleName = "OnRewardListClick",
          noShade = false,
          selfDealMessage = true,
          heightInner = 5,
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
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(65, -12)
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
              position = ccp(70, -14)
            },
            config = {}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(32, -27)
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
              position = ccp(82, -17)
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
              position = ccp(103, -17)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("guildconfig.1.10.018")),
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(250, -6)
            }
          },
          {
            t = "Label",
            base = {
              name = "damage",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(335, -6)
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "damageBg",
              res = "UI/alpha/HVGA/guild/guild_member_hurt_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(250, -37)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "percent",
              res = "UI/alpha/HVGA/stagedone_statistics_friend.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(253, -37)
            },
            config = {
              scalexy = {x = 0.5, y = 0.51}
            }
          },
          {
            t = "SpriteButton",
            base = {
              name = "button",
              handleName = "selectMember"
            },
            layout = {
              position = ccp(175, -20)
            },
            config = {
              messageRect = CCRectMake(0, 0, 300, 40)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -10)
            },
            config = {
              scalexy = {x = 3, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(200, -10)
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
          handleName = "closeRewarDetailLayer"
        },
        layout = {
          anchor = ccp(1, 1),
          position = ccp(477, 360)
        }
      }
    }
  }
}
GuildIconRes = {
  {
    layerName = "iconLayer",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 100,
    touchInfo = {
      iPriority = -2,
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
          anchor = ccp(0.5, 1),
          position = ccp(400, 360)
        },
        config = {
          scaleSize = CCSizeMake(510, 300)
        }
      },
      {
        t = "ListView",
        base = {
          name = "iconList",
          cliprect = CCRectMake(187, 70, 425, 286),
          priority = -200,
          colNum = 5,
          handleName = "OnIconClick",
          selfDealMessage = true
        },
        itemConfig = {
          {
            t = "Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/hero_icon_frame_1.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, 0)
            }
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(10, -10)
            },
            listData = true
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeIcon",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          handleName = "closeIcon",
          parent = "bg",
          z = 500
        },
        layout = {
          position = ccp(500, 280)
        }
      }
    }
  }
}
payUIRes = {
  {
    layerName = "payLayer",
    layerColor = ccc4(0, 0, 0, 190),
    iPriority = 100,
    touchInfo = {
      iPriority = -2,
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
          scaleSize = CCSizeMake(450, 252)
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
          position = ccp(90, 188)
        },
        config = {
          scalexy = {x = 0.7, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("GUILDCONFIG.CONFIRM_EMPLOYMENT")),
          parent = "payResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(88, 188)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText2",
          middle = true,
          text = T(LSTR("GUILDCONFIG.TEXT_DARK_WHITE__YOURE_NOT_ALLOWED_TO_HIRE_OTHER_MERCENARIES_FROM_TEXT_DARK_YELLOW_XXXXXXXXXTEXT_DARK_WHITE__TODAY")),
          parent = "payResult"
        },
        layout = {
          position = ccp(88, 148)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/goldicon_small.png",
          parent = "payResult"
        },
        layout = {
          position = ccp(50, 114)
        }
      },
      {
        t = "Label",
        base = {
          name = "payNum",
          text = "5000",
          parent = "payResult",
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(110, 114)
        }
      },
      {
        t = "RichText",
        base = {
          name = "hintText",
          middle = true,
          text = T(LSTR("GUILDCONFIG.TEXT_DARK_WHITE__YOURE_NOT_ALLOWED_TO_HIRE_OTHER_MERCENARIES_FROM_TEXT_DARK_YELLOW_XXXXXXXXXTEXT_DARK_WHITE__TODAY")),
          parent = "payResult"
        },
        layout = {
          position = ccp(90, 78)
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
          handleName = "conformPay"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 24)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
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
          handleName = "cancelPay"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(20, 24)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  }
}
specialLootUIRes = {
  {
    layerName = "rewardLayer",
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -500,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 150)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/common/common_getitem_bg.png",
          capInsets = CCRectMake(70, 84, 325, 10),
          parent = "rewardResult"
        },
        layout = {
          position = ccp(0, 120)
        },
        config = {
          scaleSize = CCSizeMake(450, 320)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/equip_detail_title_bg.png",
          parent = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 245)
        },
        config = {
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.019")),
          parent = "rewardResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(0, 245)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.020")),
          parent = "rewardResult",
          fontinfo = "guild_send_hero_green"
        },
        layout = {
          position = ccp(0, 190)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.1.10.021")),
          parent = "rewardResult",
          fontinfo = "guild_send_hero_green"
        },
        layout = {
          position = ccp(0, 80)
        }
      },
      {
        t = "RichText",
        base = {
          name = "rewards",
          middle = true,
          parent = "rewardResult",
          text = ""
        },
        layout = {
          position = ccp(5, 131)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "conform",
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "rewardResult",
          handleName = "conform"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 15)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("CHATCONFIG.CONFIRM")),
          fontinfo = "middle_normal_button",
          parent = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 15)
        }
      }
    }
  }
}
instanceRankRes = {
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
        t = "ListView",
        base = {
          name = "rankList",
          parent = "bg",
          cliprect = CCRectMake(15, 10, 450, 335),
          priority = -200,
          noShade = true,
          selfDealMessage = true,
          heightInner = 0,
          newClickFunc = true
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/herodetail-title-mark.png",
              capInsets = CCRectMake(78.13, 0, 69.53, 11.72)
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(220, -15)
            },
            config = {
              scaleSize = CCSizeMake(460, 10)
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              fontinfo = "title_yellow"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(225, -12)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -35)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -10)
            },
            config = {
              scalexy = {x = 3.5, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(""),
              fontinfo = "op_act_white"
            },
            layout = {
              position = ccp(225, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -30)
            }
          }
        },
        itemConfig3 = {
          {
            t = "Sprite",
            base = {name = "summary"},
            layout = {
              position = ccp(30, -15)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("HERODETAIL.FROM_")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(60, -40)
            }
          },
          {
            t = "Label",
            base = {
              name = "guildName",
              text = "",
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(105, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("guildconfig.1.10.022")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(270, -10)
            }
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = T(""),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(270, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -55)
            }
          }
        },
        itemConfig4 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/guild/guild_icon_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(14, 0)
            },
            config = {scale = 0.8}
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, -6)
            },
            config = {
              scalexy = {x = 0.8, y = 0.8}
            },
            listData = true
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/equip_frame_white.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(13, 0)
            },
            config = {scale = 0.85}
          },
          {
            t = "Label",
            base = {
              name = "guildNmae",
              text = T(""),
              fontinfo = "op_act_white"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(80, -10)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = "ID:",
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(80, -40)
            }
          },
          {
            t = "Label",
            base = {
              name = "ID",
              text = T("24334"),
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(115, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("guildconfig.1.10.023")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(270, -10)
            }
          },
          {
            t = "Label",
            base = {
              name = "time",
              text = T(""),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(270, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -60)
            }
          }
        },
        itemConfig5 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, 0)
            },
            config = {
              scalexy = {x = 3.3, y = 3}
            }
          },
          {
            t = "Sprite",
            base = {name = "num"},
            layout = {
              position = ccp(45, -30)
            },
            addIcon = "true",
            listData = true
          },
          {
            t = "Sprite",
            base = {name = "summary"},
            layout = {
              position = ccp(240, -18)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("HERODETAIL.FROM_")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(260, -43)
            }
          },
          {
            t = "Label",
            base = {
              name = "guildName",
              text = T(""),
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(305, -43)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("guildconfig.1.10.024")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -20)
            }
          },
          {
            t = "Label",
            base = {
              name = "damage",
              text = T("1234345"),
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -45)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -80)
            }
          }
        },
        itemConfig6 = {
          {
            t = "Label",
            base = {
              name = "hint",
              text = T(""),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(225, 0)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -10)
            }
          }
        },
        itemConfig7 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(20, 0)
            },
            config = {
              scalexy = {x = 3.3, y = 4.4}
            }
          },
          {
            t = "Sprite",
            base = {name = "num"},
            layout = {
              position = ccp(45, -30)
            },
            addIcon = "true",
            listData = true
          },
          {
            t = "Sprite",
            base = {name = "summary"},
            layout = {
              position = ccp(220, -18)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("HERODETAIL.FROM_")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(255, -40)
            }
          },
          {
            t = "Label",
            base = {
              name = "guildName",
              text = T(""),
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(300, -40)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "ui",
              text = T(LSTR("guildconfig.1.10.024")),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -20)
            }
          },
          {
            t = "Label",
            base = {
              name = "damage",
              text = T("1234345"),
              fontinfo = "pressButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(100, -45)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -80)
            }
          },
          {
            t = "Sprite",
            base = {name = "heros"},
            layout = {
              position = ccp(190, -70)
            },
            addIcon = "true",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -110)
            }
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          handleName = "close",
          clickPos = "outSide"
        },
        layout = {
          position = ccp(240, 150)
        },
        config = {
          messageRect = CCRectMake(0, 0, 480, 300)
        }
      }
    }
  }
}
historyRankRes = {
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
          scaleSize = CCSizeMake(400, 250)
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
          position = ccp(200, 180)
        },
        config = {
          scalexy = {x = 3, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "light",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_light.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(195, 250)
        },
        config = {scale = 2}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_result_highest.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(195, 250)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 300)
        },
        config = {scale = 1}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(250, 310)
        },
        config = {scale = 1}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(140, 310)
        },
        config = {scale = 2}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(180, 330)
        },
        config = {scale = 1}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "bg",
          res = "UI/alpha/HVGA/pvp/pvp_rank_1st_star.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 200)
        },
        config = {scale = 1}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.2.0.0.006")),
          fontinfo = "op_act_white",
          parent = "bg"
        },
        layout = {
          position = ccp(200, 180)
        }
      },
      {
        t = "Sprite",
        base = {name = "summary", parent = "bg"},
        layout = {
          position = ccp(40, 147)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.2.0.0.007")),
          fontinfo = "normalButton",
          parent = "bg"
        },
        layout = {
          position = ccp(290, 150)
        }
      },
      {
        t = "Label",
        base = {
          name = "oldDamage",
          text = T(""),
          fontinfo = "pressButton",
          parent = "bg"
        },
        layout = {
          position = ccp(340, 150)
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
          position = ccp(200, 110)
        },
        config = {
          scalexy = {x = 3, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.2.0.0.008")),
          fontinfo = "op_act_white",
          parent = "bg"
        },
        layout = {
          position = ccp(200, 110)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.2.0.0.009")),
          fontinfo = "normalButton",
          parent = "bg"
        },
        layout = {
          position = ccp(80, 75)
        }
      },
      {
        t = "Label",
        base = {
          name = "newDamage",
          text = T(""),
          fontinfo = "pressButton",
          parent = "bg"
        },
        layout = {
          position = ccp(150, 75)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("guildconfig.2.0.0.010")),
          fontinfo = "normalButton",
          parent = "bg"
        },
        layout = {
          position = ccp(280, 75)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("PVP.REWARDED_")),
          fontinfo = "normalButton",
          parent = "bg"
        },
        layout = {
          position = ccp(80, 40)
        }
      },
      {
        t = "RichText",
        base = {
          name = "reward",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(120, 40)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          handleName = "close",
          clickPos = "outSide"
        },
        layout = {
          position = ccp(240, 150)
        },
        config = {
          messageRect = CCRectMake(0, 0, 300, 250)
        }
      }
    }
  }
}
logRes = {
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
          scaleSize = CCSizeMake(550, 350)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/act/act_popup_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 400)
        },
        config = {
          scalexy = {x = 0.8, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "name",
          parent = "bg",
          text = T(LSTR("guildconfig.2.0.0.011")),
          fontinfo = "title_yellow"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(240, 325)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rankList",
          parent = "bg",
          cliprect = CCRectMake(15, 10, 500, 290),
          priority = -200,
          noShade = true,
          selfDealMessage = true,
          heightInner = 0,
          newClickFunc = true
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/herodetail-title-mark.png",
              capInsets = CCRectMake(78.13, 0, 69.53, 11.72)
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(220, -15)
            },
            config = {
              scaleSize = CCSizeMake(460, 10)
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(""),
              fontinfo = "title_yellow"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(225, -12)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -35)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/tip_detail_bg.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, -10)
            },
            config = {
              scalexy = {x = 3.5, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(""),
              fontinfo = "op_act_white"
            },
            layout = {
              position = ccp(225, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -30)
            }
          }
        },
        itemConfig3 = {
          {
            t = "Label",
            base = {
              name = "time",
              text = T(""),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(10, 0)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "logContent",
              text = T("")
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(60, 0)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -10)
            }
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          handleName = "close",
          clickPos = "outSide"
        },
        layout = {
          position = ccp(240, 150)
        },
        config = {
          messageRect = CCRectMake(0, 0, 480, 300)
        }
      }
    }
  }
}
guildType = {
  T(LSTR("GUILDCONFIG.ALL_PLAYERS_CAN_JOIN")),
  T(LSTR("GUILDCONFIG.NEED_VERIFICATION_FIRST")),
  T(LSTR("GUILDCONFIG.APPLICATION_DENIED"))
}
guildLevelLimit = {minLevel = 32, maxLevel = 80}
guildJoinType = {
  T(LSTR("GUILDCONFIG.JOIN_IN_INSTANTLY")),
  T(LSTR("GUILDCONFIG.APPLY_TO_JOIN")),
  T(LSTR("GUILDCONFIG.NO_APPLICATION_ALLOWED"))
}
maxGuildMember = 50
autoDropTime = 43200
guildInstanceTime = 604800
wholePercent = 10000
guildCoinCount = 30
maxGetGuildCoinTime = 3
worshipLevelDif = 1
joinGuildFial = {
  join_guild_cd = LSTR("guildconfig.2.0.0.012"),
  join_same_guild_cd = LSTR("guildconfig.2.0.0.013"),
  join_guild_week_cd = LSTR("guildconfig.2.0.0.014")
}

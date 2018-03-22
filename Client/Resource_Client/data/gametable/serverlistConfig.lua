EDDefineTable("serverlistConfig")
UIRes = {
  {
    layerName = "serverlistLayer",
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
          capInsets = CCRectMake(20, 20, 300, 300)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(370, 220)
        },
        config = {
          scaleSize = CCSizeMake(620, 385)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "installer/serverselect_serverlist_bg.png",
          capInsets = CCRectMake(10, 10, 100, 10),
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 30)
        },
        config = {
          scaleSize = CCSizeMake(160, 360)
        }
      },
      {
        t = "Label",
        base = {
          name = "allserver",
          parent = "ui",
          text = T(LSTR("SERVERLOGIN.ALL_SERVERS")),
          size = 20,
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(80, 336),
          anchor = ccp(0.5, 0.5)
        },
        config = {
          scaleSize = CCSizeMake(160, 200)
        },
        listData = true
      },
      {
        t = "ListView",
        base = {
          name = "ListView",
          parent = "ui",
          cliprect = CCRectMake(0, 10, 160, 313),
          priority = -200,
          handleName = "onListClick",
          downhandleName = "listDownClick",
          uphandleName = "listUpClick",
          movehandleName = "listMoveClick",
          noShade = true,
          selfDealMessage = true,
          widthInner = "25",
          heightInner = "0",
          bar = {
            bglen = 300,
            bgpos = ccp(10, 170)
          }
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/serverselect/serverselect_selected_highlight_green.png",
              capInsets = CCRectMake(50, 20, 50, 15)
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(10, -15)
            },
            config = {
              scaleSize = CCSizeMake(140, 40),
              visible = false
            }
          },
          {
            t = "Label",
            base = {
              name = "servername",
              text = T(LSTR("serverlistConfig.1.10.1.001")),
              size = 20,
              fontinfo = "dark_yellow1"
            },
            layout = {
              position = ccp(80, -7),
              anchor = ccp(0.5, 1)
            },
            config = {},
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "lineinfo",
              res = "UI/alpha/HVGA/serverselect/serverselect_delimiter_2.png",
              capInsets = CCRectMake(80, 0, 80, 2)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(0, -36)
            },
            config = {
              scaleSize = CCSizeMake(160, 2)
            }
          }
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "serverinfobg",
          res = "installer/serverselect_serverlist_bg.png",
          capInsets = CCRectMake(10, 10, 100, 10),
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(170, 30)
        },
        config = {
          scaleSize = CCSizeMake(510, 300)
        }
      },
      {
        t = "Label",
        base = {
          name = "servernum",
          parent = "serverinfobg",
          text = T(LSTR("serverlistConfig.1.10.1.002")),
          size = 20,
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(255, 285),
          anchor = ccp(0.5, 1)
        },
        config = {}
      },
      {
        t = "ListView",
        base = {
          name = "serverInfo",
          parent = "serverinfobg",
          colNum = 2,
          cliprect = CCRectMake(0, 0, 510, 260),
          priority = -200,
          handleName = "onClickServerinfo",
          downhandleName = "serverInfoDownClick",
          uphandleName = "serverInfoUpClick",
          noShade = true,
          selfDealMessage = true,
          widthInner = "0",
          heightInner = "2"
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/serverselect/serverselect_selected_highlight_brown.png",
              capInsets = CCRectMake(85, 20, 170, 15)
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(10, -20)
            },
            config = {
              scaleSize = CCSizeMake(240, 40),
              visible = false
            }
          },
          {
            t = "Label",
            base = {
              name = "servername",
              text = T(LSTR("serverlistConfig.1.10.1.001")),
              size = 20,
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(20, -20),
              anchor = ccp(0, 0.5)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "serverstate",
              text = T(""),
              size = 20,
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(200, -20),
              anchor = ccp(0, 0.5)
            },
            config = {},
            listData = true
          },
          {
            t = "Scale9Sprite",
            base = {
              name = "lineinfo",
              res = "UI/alpha/HVGA/serverselect/serverselect_delimiter.png",
              capInsets = CCRectMake(80, 0, 260, 2)
            },
            layout = {
              anchor = ccp(0, 0),
              position = ccp(20, -45)
            },
            config = {
              scaleSize = CCSizeMake(240, 2)
            }
          }
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "lastserverbg",
          res = "installer/serverselect_serverlist_bg.png",
          capInsets = CCRectMake(10, 10, 100, 10),
          parent = "frame1"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(170, 337)
        },
        config = {
          scaleSize = CCSizeMake(510, 53)
        }
      },
      {
        t = "Label",
        base = {
          name = "lastlogin",
          parent = "lastserverbg",
          text = T(LSTR("serverlistConfig.1.10.1.003")),
          size = 20,
          fontinfo = "normal_button"
        },
        layout = {
          position = ccp(20, 30),
          anchor = ccp(0, 0.5)
        },
        config = {}
      },
      {
        t = "ListView",
        base = {
          name = "lastServerInfo",
          parent = "lastserverbg",
          colNum = 2,
          cliprect = CCRectMake(140, 0, 400, 60),
          priority = -200,
          handleName = "onClickServerinfo",
          downhandleName = "serverInfoDownClick",
          uphandleName = "serverInfoUpClick",
          noShade = true,
          selfDealMessage = true,
          widthInner = "10",
          heightInner = "15"
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/serverselect/serverselect_delimiter.png",
              capInsets = CCRectMake(80, 0, 260, 2)
            },
            layout = {
              anchor = ccp(0, 0),
              position = ccp(0, -42)
            },
            config = {
              scaleSize = CCSizeMake(340, 40),
              visible = false
            }
          },
          {
            t = "Label",
            base = {
              name = "servername",
              text = T(LSTR("serverlistConfig.1.10.1.001")),
              size = 20,
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(40, -30),
              anchor = ccp(0, 0)
            },
            config = {},
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "serverstate",
              text = T("1111"),
              size = 20,
              fontinfo = "normal_button"
            },
            layout = {
              position = ccp(260, -30),
              anchor = ccp(0, 0)
            },
            config = {},
            listData = true
          }
        }
      }
    }
  }
}

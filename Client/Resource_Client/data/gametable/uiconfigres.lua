EDDefineTable("uiconfig")
fontedit = {
  {
    layerName = " mainLayer",
    touchInfo = {iPriority = -50},
    uiRes = {
      {
        t = "Sprite",
        base = {name = bg},
        layout = {
          position = ccp(400, 240)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Text Name:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 430)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(170, 430)
        },
        config = {
          scaleSize = CCSizeMake(100, 30)
        }
      },
      {
        t = "EditTTF",
        base = {name = "name", text = "default"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(175, 430)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Text Color R:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 400)
        },
        config = {}
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(170, 400)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "EditTTF",
        base = {name = "colorR", text = "255"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(175, 400)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(170, 370)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Text Color G:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 370)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(170, 340)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "EditTTF",
        base = {name = "colorG", text = "255"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(175, 370)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Text Color B:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 340)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {name = "colorB", text = "255"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(175, 340)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Font Size:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 310)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(170, 310)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "EditTTF",
        base = {name = "size", text = "30"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(175, 310)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Shadow Color R:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 400)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 400)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 370)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 340)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 310)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 280)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "shadowcolorR"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 400)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Shadow Color G:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 370)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "shadowcolorG"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 370)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Shadow Color B:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 340)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "shadowcolorB"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 340)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Shadow Offset X:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 310)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "shadowoffsetX"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 310)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Shadow Offset Y:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 280)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "shadowoffsetY"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 280)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Stroke Color R:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(450, 400)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 400)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 370)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 340)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/activate_input.png",
          capInsets = CCRectMake(12, 10, 12, 22)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 310)
        },
        config = {
          scaleSize = CCSizeMake(50, 30)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "strokecolorR"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 400)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Stroke Color G:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(450, 370)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "strokecolorG"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 370)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Stroke Color B:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(450, 340)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {
          name = "strokecolorB"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 340)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = "Stroke Size:",
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(450, 310)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "EditTTF",
        base = {name = "strokesize"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(550, 310)
        },
        config = {
          messageRect = CCRectMake(0, 0, 50, 15)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "addNewFont",
          buttonName = {
            text = T(LSTR("UICONFIGRES.ADD")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "installer/serverselect_confirm_button_1.png",
            press = "installer/serverselect_confirm_button_2.png"
          },
          capInsets = CCRectMake(10, 10, 28, 29),
          handleName = "addNewFont"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(300, 50)
        },
        config = {}
      },
      {
        t = "Scale9Button",
        base = {
          name = "addNewFont",
          buttonName = {
            text = T(LSTR("NETWORK.QUIT")),
            fontInfo = "normal_button"
          },
          res = {
            normal = "installer/serverselect_confirm_button_1.png",
            press = "installer/serverselect_confirm_button_2.png"
          },
          capInsets = CCRectMake(10, 10, 28, 29),
          handleName = "exit"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(500, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "font"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(300, 150)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listview",
          cliprect = CCRectMake(500, 100, 300, 150),
          handleName = "onHitFont"
        },
        itemConfig = {
          {
            t = "Label",
            base = {
              name = "name",
              text = "",
              size = 20
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(0, 0)
            },
            config = {
              color = ccc3(255, 255, 255)
            },
            listData = true
          }
        }
      }
    }
  }
}

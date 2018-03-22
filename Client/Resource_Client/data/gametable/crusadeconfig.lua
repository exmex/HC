EDDefineTable("crusadeConfig")
UIRes = {
  {
    layerName = "dragLayer",
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "dragContainer"
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/crusade/crusade_detail_bg1.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/crusade/crusade_detail_bg2.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(752, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/crusade/crusade_detail_bg3.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(1477, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "laftMap",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 12)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rightMap",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(752, 12)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rightMap2",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(1477, 12)
        }
      },
      {
        t = "FcaEffect",
        base = {
          name = "box1",
          res = "eff_UI_box_bronze",
          parent = "laftMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(100, 155)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box2",
          res = "eff_UI_box_bronze",
          parent = "laftMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 110)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box3",
          res = "eff_UI_box_silver",
          parent = "laftMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(410, 310)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box4",
          res = "eff_UI_box_bronze",
          parent = "laftMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(488, 162)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box5",
          res = "eff_UI_box_bronze",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(-10, 170)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box6",
          res = "eff_UI_box_silver",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(215, 117)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box7",
          res = "eff_UI_box_bronze",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(320, 186)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box8",
          res = "eff_UI_box_bronze",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(370, 305)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box9",
          res = "eff_UI_box_silver",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(468, 133)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box10",
          res = "eff_UI_box_bronze",
          parent = "rightMap",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(627, 262)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box11",
          res = "eff_UI_box_bronze",
          parent = "rightMap2",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(-10, 175)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box12",
          res = "eff_UI_box_silver",
          parent = "rightMap2",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(157, 130)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box13",
          res = "eff_UI_box_bronze",
          parent = "rightMap2",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(233, 310)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box14",
          res = "eff_UI_box_bronze",
          parent = "rightMap2",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(350, 195)
        },
        config = {scale = 0.8}
      },
      {
        t = "FcaEffect",
        base = {
          name = "box15",
          res = "eff_UI_box_gold",
          parent = "rightMap2",
          action = ""
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(435, 125)
        },
        config = {scale = 0.8}
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle1",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_1.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_1_locked.png"
          },
          parent = "laftMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 1
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(135, 260)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle2",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_2.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_2_locked.png"
          },
          parent = "laftMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 2
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(210, 132)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle3",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_3.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_3_locked.png"
          },
          parent = "laftMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 3
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(370, 211)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle4",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_4.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_4_locked.png"
          },
          parent = "laftMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 4
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(548, 268)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle5",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_5.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_5_locked.png"
          },
          parent = "laftMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 5
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(584, 126)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle6",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_6.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_6_locked.png"
          },
          parent = "rightMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 6
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(121, 190)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle7",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_7.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_7_locked.png"
          },
          parent = "rightMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 7
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(345, 130)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle8",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_8.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_8_locked.png"
          },
          parent = "rightMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 8
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(278, 275)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle9",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_9.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_9_locked.png"
          },
          parent = "rightMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 9
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(472, 283)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle10",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_10.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_10_locked.png"
          },
          parent = "rightMap",
          handleName = "reqEnemyInfo",
          arrayIndex = 10
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(584, 145)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle11",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_11.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_11_locked.png"
          },
          parent = "rightMap2",
          handleName = "reqEnemyInfo",
          arrayIndex = 11
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(30, 265)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle12",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_12.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_12_locked.png"
          },
          parent = "rightMap2",
          handleName = "reqEnemyInfo",
          arrayIndex = 12
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(60, 120)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle13",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_13.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_13_locked.png"
          },
          parent = "rightMap2",
          handleName = "reqEnemyInfo",
          arrayIndex = 13
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(185, 230)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle14",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_14.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_14_locked.png"
          },
          parent = "rightMap2",
          handleName = "reqEnemyInfo",
          arrayIndex = 14
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(375, 277)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "battle15",
          res = {
            normal = "UI/alpha/HVGA/crusade/stage/crusade_stage_15.png",
            disable = "UI/alpha/HVGA/crusade/stage/crusade_stage_15_locked.png"
          },
          parent = "rightMap2",
          handleName = "reqEnemyInfo",
          arrayIndex = 15
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(285, 130)
        },
        config = {
          messageRect = CCRectMake(0, 0, 80, 80)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton1",
          parent = "laftMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 1
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(65, 160)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton2",
          parent = "laftMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 2
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(315, 120)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton3",
          parent = "laftMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 3
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(375, 320)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton4",
          parent = "laftMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 4
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(455, 160)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton5",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 5
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(-45, 160)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton6",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 6
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(180, 125)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton7",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 7
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(285, 180)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton8",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 8
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(335, 315)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton9",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 9
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(435, 130)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton10",
          parent = "rightMap",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 10
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(590, 255)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton11",
          parent = "rightMap2",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 11
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(-55, 175)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton12",
          parent = "rightMap2",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 12
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(120, 130)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton13",
          parent = "rightMap2",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 13
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(198, 310)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton14",
          parent = "rightMap2",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 14
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(312, 195)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "boxButton15",
          parent = "rightMap2",
          handleName = "hintBox",
          downHandleName = "hintBoxDown",
          arrayIndex = 15
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(397, 125)
        },
        config = {
          messageRect = CCRectMake(0, 0, 65, 55)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "fog4",
          res = "UI/alpha/HVGA/crusade/crusade_fog_4.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "fog3",
          res = "UI/alpha/HVGA/crusade/crusade_fog_3.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "fog2",
          res = "UI/alpha/HVGA/crusade/crusade_fog_2.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "fog1",
          res = "UI/alpha/HVGA/crusade/crusade_fog_1.png",
          parent = "dragContainer"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(25, 210)
        },
        config = {}
      }
    }
  },
  {
    layerName = "mainLayer",
    touchInfo = {iPriority = -1, bSwallowsTouches = true},
    uiRes = {
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/crusade/crusade_map_frame_light1.png"
        },
        layout = {
          position = ccp(400, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/HVGA/crusade/crusade_map_frame_light2.png"
        },
        layout = {
          position = ccp(400, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "bgframe",
          res = "UI/alpha/HVGA/crusade/crusade_map_frame.png"
        },
        layout = {
          position = ccp(400, 210)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/crusade/crusade_title_bg.png"
        },
        layout = {
          position = ccp(402, 395.3)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/crusade/crusade_title.png"
        },
        layout = {
          position = ccp(402, 390)
        }
      },
      {
        t = "Sprite",
        base = {name = "bottom"},
        layout = {
          position = ccp(402, 55)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "bottomframe",
          res = "UI/alpha/HVGA/crusade/crusade_reset_bg.png",
          capInsets = CCRectMake(20, 20, 18, 18),
          parent = "bottom"
        },
        layout = {},
        config = {
          scaleSize = CCSizeMake(560, 58)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "showrule",
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bottom",
          handleName = "showRuleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(-210, 0)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("CRUSADECONFIG.REVIEW_RULES")),
          fontinfo = "ui_normal_button",
          parent = "bottom"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(-210, 0)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "resetbattle",
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bottom",
          handleName = "resetBattle"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 0)
        },
        config = {
          scaleSize = CCSizeMake(120, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "reset",
          text = T(LSTR("CRUSADECONFIG.RESTART")),
          fontinfo = "ui_normal_button",
          parent = "bottom"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 0)
        }
      },
      {
        t = "Label",
        base = {
          name = "lefttime",
          text = T(LSTR("CRUSADECONFIG.TIMES_LEFT__2")),
          fontinfo = "normal_button",
          parent = "bottom"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(65, 0)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "shop",
          res = {
            normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
            press = "UI/alpha/HVGA/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          parent = "bottom",
          handleName = "openShop"
        },
        layout = {
          position = ccp(-75, 0)
        },
        config = {
          scaleSize = CCSizeMake(130, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "shopLabel",
          text = T(LSTR("CRUSADECONFIG.REDEEM")),
          fontinfo = "ui_normal_button",
          parent = "bottom"
        },
        layout = {
          position = ccp(-60, 0)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/money_dragonscale_small.png",
          parent = "bottom"
        },
        layout = {
          position = ccp(-115, 1)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "currentStageHint",
          res = "UI/alpha/HVGA/stagepointer.png"
        },
        layout = {
          anchor = ccp(0.5, 0),
          position = ccp(80, 110)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "rewardInfo",
          res = "UI/alpha/HVGA/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0),
          position = ccp(400, 200)
        },
        config = {
          scaleSize = CCSizeMake(170, 60),
          visible = false
        }
      },
      {
        t = "Sprite",
        base = {
          name = "moneyIcon",
          res = "UI/alpha/HVGA/goldicon.png",
          parent = "rewardInfo"
        },
        layout = {
          position = ccp(42, 40)
        },
        config = {scale = 0.65}
      },
      {
        t = "Sprite",
        base = {name = "heroStone", parent = "rewardInfo"},
        layout = {
          position = ccp(40, 110)
        },
        config = {scale = 0.65}
      },
      {
        t = "Sprite",
        base = {
          name = "randomReward",
          res = "UI/alpha/HVGA/handbook_icon_lock.png",
          parent = "rewardInfo"
        },
        layout = {
          position = ccp(40, 70)
        },
        config = {scale = 0.5}
      },
      {
        t = "Label",
        base = {
          name = "randomText",
          text = T(LSTR("CRUSADECONFIG.MYSTERIOUS_REWARD")),
          parent = "rewardInfo",
          fontinfo = "small_normal_button"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(115, 70)
        }
      },
      {
        t = "Label",
        base = {
          name = "money",
          text = "30000",
          parent = "rewardInfo",
          fontinfo = "normal_button"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(115, 40)
        }
      },
      {
        t = "Label",
        base = {
          name = "stoneNum",
          text = "x1",
          fontinfo = "normal_button",
          parent = "rewardInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(115, 110)
        }
      },
      {
        t = "Label",
        base = {
          name = "stoneText",
          text = T(LSTR("CRUSADECONFIG.REWARDS_FOR_THIS_PASS_")),
          fontinfo = "normal_button",
          parent = "rewardInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(85, 110)
        }
      }
    }
  },
  {
    layerName = "rewardLayer",
    layerColor = ccc4(0, 0, 0, 190),
    layerOrder = 100,
    initVisible = false,
    touchInfo = {
      iPriority = -200,
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
          scaleSize = CCSizeMake(400, 220)
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
          position = ccp(0, 188)
        },
        config = {
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T(LSTR("CRUSADECONFIG.REWARDS_RECEIVED")),
          parent = "rewardResult",
          fontinfo = "title_yellow"
        },
        layout = {
          position = ccp(0, 188)
        }
      },
      {
        t = "RichText",
        base = {
          name = "rewards",
          middle = true,
          parent = "rewardResult",
          text = "<sprite|UI/alpha/HVGA/goldicon.png><text|normal_button|10000  ><item|126|0.6><text|normal_button| x1>"
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
          handleName = "conformReward"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 63)
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
          fontinfo = "ui_normal_button",
          parent = "rewardResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(0, 63)
        }
      }
    }
  },
  {
    layerName = "battleLayer",
    touchInfo = {
      iPriority = 0,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "battleinfo",
          res = "UI/alpha/HVGA/toast_bg.png",
          capInsets = CCRectMake(17, 10, 200, 46)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 220)
        },
        config = {
          scaleSize = CCSizeMake(500, 180)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeBattle",
          res = {
            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
          },
          parent = "battleinfo",
          handleName = "closeBattleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(482, 158)
        }
      },
      {
        t = "Sprite",
        base = {name = "enemyIcon", parent = "battleinfo"},
        layout = {
          position = ccp(50, 140)
        },
        config = {scale = 0.65}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/tip_detail_bg.png",
          parent = "battleinfo"
        },
        layout = {
          position = ccp(160, 140)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
          parent = "battleinfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 140)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "level",
          text = "99",
          parent = "battleinfo",
          fontinfo = "normal_button"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 140)
        }
      },
      {
        t = "Label",
        base = {
          name = "heroName",
          text = "Hero Name",
          fontinfo = "normal_button",
          parent = "battleinfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(110, 140)
        }
      },
      {
        t = "Label",
        base = {
          name = "currentBattle",
          text = "(9/10)",
          fontinfo = "normal_button",
          parent = "battleinfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(250, 140)
        }
      },
      {
        t = "Sprite",
        base = {name = "hero1", parent = "battleinfo"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(54, 75)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "hero2", parent = "battleinfo"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(129, 75)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "hero3", parent = "battleinfo"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(204, 75)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "hero4", parent = "battleinfo"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(279, 75)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "hero5", parent = "battleinfo"},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(354, 75)
        },
        config = {}
      },
      {
        t = "SpriteButton",
        base = {
          name = "start",
          res = {
            normal = "UI/alpha/HVGA/startbtn.png",
            press = "UI/alpha/HVGA/startbtn.png"
          },
          parent = "battleinfo",
          handleName = "start"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(442, 75)
        },
        config = {scale = 0.75}
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          parent = "battleinfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 33)
        },
        config = {
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "guildHint",
          text = "",
          size = 16,
          parent = "battleinfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(24, 21)
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      },
      {
        t = "Label",
        base = {
          name = "guildName",
          text = "",
          size = 16,
          parent = "battleinfo"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(105, 21)
        },
        config = {
          color = ccc3(244, 224, 189),
          visible = false
        }
      }
    }
  },
  {
    layerName = "ruleLayer",
    layerColor = ccc4(0, 0, 0, 190),
    layerOrder = 100,
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
          text = T(LSTR("CRUSADECONFIG.BURNING_CRUSADE")),
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
  }
}

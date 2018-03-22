ed.uieditor = ed.uieditor or {}
ed.uieditor.applyguildrewarddetail = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470.31, 446.88)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 42.97, 19.53),
      res = "UI/alpha/HVGA/main_vit_tips.png",
      name = "frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 236.72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_wh = {w = 49.21875, h = 52.34375},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png",
      name = "close_button",
      z = 10,
      parent = "frame",
      text = "",
      press = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457.03, 426.56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      fix_wh = {w = 398.43741570313, h = 37.7314829375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(234.38, 420.31)
    }
  }
}

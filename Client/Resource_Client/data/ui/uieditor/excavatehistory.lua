ed.uieditor = ed.uieditor or {}
ed.uieditor.excavatehistory = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 568.75, h = 409.21875},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/package_herolist_bg.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393.75, 212.5)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 57.8125, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/herodetail-detail-close.png",
      name = "close_button",
      z = 20,
      text = "",
      press = "UI/alpha/HVGA/herodetail-detail-close-p.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(678.91, 389.06)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 521.09375, h = 39.0625},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/HVGA/task_window_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270.31, 398.83)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 216, 17),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "title_bg",
      text = T(LSTR("EXCAVATEHISTORY.DEFENSIVE_RECORD")),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.55, 19.53)
    }
  }
}

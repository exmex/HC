ed.uieditor = ed.uieditor or {}
ed.uieditor.itemstarshop = {
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 207.03125, h = 286.71875},
      flip = ""
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/shop_star_item_bg.png",
      name = "item_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.13, 143.75)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "item_name",
      z = 1,
      parent = "item_bg",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.73, 248.05)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(156.25, 156.25),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "item_bg",
      name = "item_icon_container",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(35.55, 113.67)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 236, 255),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "cost_title_label",
      z = 2,
      parent = "item_bg",
      text = T(LSTR("ITEMSTARSHOP.NEED_TO_CONSUME_THE_SOUL_STONE")),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.52, 89.45)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      fix_wh = {w = 135.15625, h = 28.90625},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "item_bg",
      res = "UI/alpha/HVGA/shop_star_price_bg.png",
      name = "cost_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.11, 49.61)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      fix_wh = {w = 207.03125, h = 286.71875},
      flip = ""
    },
    t = "Sprite",
    base = {
      parent = "item_bg",
      res = "UI/alpha/HVGA/shop_star_item_light.png",
      name = "item_press",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.52, 143.36)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(45.31, 45.31),
      flip = ""
    },
    t = "Layer",
    base = {
      parent = "item_bg",
      name = "stone_container",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.17, 26.95)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(39, 209, 232),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "stone_name",
      z = 2,
      parent = "item_bg",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72.27, 51.17)
    }
  }
}

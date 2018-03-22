ed.uieditor = ed.uieditor or {}
ed.uieditor.newbie = {
  {
    config = {
      visible = false,
      opacity = 255,
      scaleSize = CCSizeMake(524.22, 261.72),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(86.72, 17.97, 0.78, 0.78),
      res = "installer/serverselect_serverlist_bg.png",
      name = "updatepass",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 263.28)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      scaleSize = CCSizeMake(524.22, 156.25),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(86.72, 17.97, 0.78, 0.78),
      res = "installer/serverselect_serverlist_bg.png",
      name = "forgetpass",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 263.28)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      scaleSize = CCSizeMake(524.22, 320.31),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(86.72, 17.97, 0.78, 0.78),
      res = "installer/serverselect_serverlist_bg.png",
      name = "registerpanel",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.56, 263.28)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(524.22, 230.47),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(86.72, 17.97, 0.78, 0.78),
      res = "installer/serverselect_serverlist_bg.png",
      name = "newbiebg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 217.97)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "forgetpass_imgnewpass1",
      z = 0,
      parent = "updatepass",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.17, 57.42)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "forgetpass_imgnewpass",
      z = 0,
      parent = "updatepass",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.95, 132.42)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "forgetpass_imgoldpass",
      z = 0,
      parent = "updatepass",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.17, 185.55)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(278.91, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "forgetpass_imgoldpass_2",
      z = 0,
      parent = "forgetpass",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.73, 80.47)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "registerpanel_img_password_bg",
      z = 0,
      parent = "registerpanel",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.89, 173.44)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "registerpanel_img_password_bg1",
      z = 0,
      parent = "registerpanel",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.67, 96.09)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "registerpanel_img_username_bg",
      z = 0,
      parent = "registerpanel",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.33, 246.88)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "newbiebg_img_password_bg",
      z = 0,
      parent = "newbiebg",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.55, 80.08)
    }
  },
  {
    config = {
      visible = true,
      opacity = 255,
      scaleSize = CCSizeMake(303.13, 46.09),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "newbiebg_img_username_bg",
      z = 0,
      parent = "newbiebg",
      res = "UI/alpha/HVGA/activate_input.png",
      capInsets = CCRectMake(17.19, 20.31, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.55, 158.98)
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
      name = "lab_forgetpass_hint2",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.031")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.86, 134.77)
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
      name = "lab_forgetpass_hint1",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.032")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.08, 183.98)
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
      name = "lab_forgetpass_title_0",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.033")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.45, 225.39)
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
      name = "lab_forgetpass_hint3",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.031")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.08, 58.98)
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
      name = "lab_forgetpass_title",
      z = 0,
      parent = "forgetpass",
      text = T(LSTR("newbie.1.10.1.034")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.42, 80.47)
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
      name = "lab_password_pre_0_0",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.035")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.95, 171.88)
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
      name = "lab_newbie_title_1",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.036")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.11, 292.97)
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
      name = "lab_password_pre_0",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.037")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.33, 94.53)
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
      name = "lab_account_pre_1",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.038")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.33, 248.44)
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
      name = "lab_newbie_title",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.039")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.11, 205.08)
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
      name = "lab_password_pre",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.035")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.48, 77.73)
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
      name = "lab_account_pre",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.040")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.48, 158.98)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "updatepass_btn_back_login",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.041")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.08, -43.36)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "forgetpass_btn_back_login",
      z = 0,
      parent = "forgetpass",
      text = T(LSTR("newbie.1.10.1.041")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(259.77, -38.28)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "registerpanel_btn_back_reg",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("EQUIPCRAFT.RETURN")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.64, -32.81)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "newbiebg_btn_register",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.042")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.86, -33.2)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "updatepass_btn_changepass",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("CHATCONFIG.CONFIRM")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366.8, -43.36)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "registerpanel_btn_register",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.043")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.08, -32.81)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      fix_wh = {w = 185.15625, h = 58.59375},
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "newbiebg_btn_login",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.044")),
      press = "installer/serverselect_confirm_button_2.png",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(353.52, -32.42)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "forgetpass_laberr2",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.045")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(155.08, 22.27)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "forgetpass_laberr1",
      z = 0,
      parent = "updatepass",
      text = T(LSTR("newbie.1.10.1.045")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(154.3, 96.48)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "registerpanel_lab_password_error",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.046")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121.48, 136.72)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "registerpanel_lab_password_error1",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.023")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121.48, 58.59)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "registerpanel_lab_username_error",
      z = 0,
      parent = "registerpanel",
      text = T(LSTR("newbie.1.10.1.047")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121.48, 209.38)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "newbiebg_lab_password_error",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.045")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120.7, 42.58)
    }
  },
  {
    config = {
      visible = false,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 0, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "newbiebg_lab_username_error",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.048")),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120.7, 120.7)
    }
  },
  {
    config = {
      visible = true,
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 0),
      opacity = 255,
      scalexy = {y = 1, x = 1},
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      name = "newbiebg_labForgetPass",
      z = 0,
      parent = "newbiebg",
      text = T(LSTR("newbie.1.10.1.049")),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(469.92, 69.92)
    }
  },
  {
    config = {
      visible = true,
      flip = "",
      scaleSize = CCSizeMake(75.78, 42.19),
      opacity = 255,
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/tavern_button_normal_1.png",
      capInsets = CCRectMake(54.69, 20.31, 14.06, 9.38),
      name = "forgetpass_btn_resetpass",
      z = 0,
      parent = "forgetpass",
      text = T(LSTR("newbie.1.10.1.050")),
      press = "UI/alpha/HVGA/tavern_button_normal_2.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455.86, 80.47)
    }
  },
  {
    config = {
      visible = false,
      opacity = 255,
      scaleSize = CCSizeMake(465.63, 2.34),
      flip = ""
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_155",
      z = 0,
      parent = "forgetpass",
      res = "installer/serverselect_delimiter.png",
      capInsets = CCRectMake(177.34, 0.78, 0.78, 1.56)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.23, 33.59)
    }
  }
}

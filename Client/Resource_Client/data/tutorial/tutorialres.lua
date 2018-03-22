local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.tutorialres = class
class.default_drag_range = 7
local t_keys = {
  FTintoMain = {id = 1},
  FTBronzeOpen = {id = 2},
  FTBronzeOne = {
    id = 3,
    pre = "FTBronzeOpen"
  },
  FTBronzeClose = {
    id = 4,
    pre = "FTBronzeOne"
  },
  _NOT_SET_1 = {id = 5},
  _NOT_SET_2 = {id = 6},
  _NOT_SET_3 = {id = 7},
  FTGoldOpen = {
    id = 8,
    pre = "FTBronzeClose"
  },
  FTGoldOne = {id = 9, pre = "FTGoldOpen"},
  FTGoldClose = {id = 10, pre = "FTGoldOne"},
  FTbackToMain = {
    id = 11,
    pre = "FTGoldClose"
  },
  gotoSelectStage = {
    id = 12,
    pre = "FTbackToMain"
  },
  selectStage = {
    id = 13,
    pre = "gotoSelectStage"
  },
  gotoPrepare = {
    id = 14,
    pre = "selectStage"
  },
  selectHero = {
    id = 15,
    pre = "gotoPrepare"
  },
  gotoBattle = {id = 16, pre = "selectHero"},
  clickNextStage = {id = 17},
  openShortcutToEquip = {
    id = 18,
    pre = "clickNextStage"
  },
  gotoEquipProp = {
    id = 19,
    pre = "clickNextStage",
    addition = {
      "openShortcutToEquip"
    }
  },
  gotoHeroDetailToEquip = {
    id = 20,
    pre = "gotoEquipProp"
  },
  canEquipProp = {
    id = 21,
    pre = "gotoHeroDetailToEquip"
  },
  equipProp = {
    id = 22,
    pre = "canEquipProp"
  },
  closeHeroDetail = {id = 23, pre = "equipProp"},
  backToStageSelect = {
    id = 24,
    pre = "closeHeroDetail"
  },
  firstTaskOpenShortcut = {id = 25},
  firstTaskOpenTaskWindow = {
    id = 26,
    addition = {
      "firstTaskOpenShortcut"
    }
  },
  firstTaskClickComplete = {
    id = 27,
    pre = "firstTaskOpenTaskWindow"
  },
  firstTaskClickok = {
    id = 28,
    pre = "firstTaskClickComplete"
  },
  firstTaskClickClose = {
    id = 29,
    pre = "firstTaskClickok"
  },
  SHopenShortcut = {id = 30},
  SHclickHeroPackage = {
    id = 31,
    addition = {
      "SHopenShortcut"
    }
  },
  SHclickHero = {
    id = 32,
    pre = "SHclickHeroPackage"
  },
  SHclickok = {
    id = 33,
    pre = "SHclickHero"
  },
  EEclickHero = {id = 34},
  EEselectHero = {
    id = 35,
    pre = "EEclickHero"
  },
  EEclickEquip = {
    id = 36,
    pre = "EEselectHero"
  },
  EEopenMaterial = {
    id = 37,
    pre = "EEclickEquip"
  },
  EEclickMaterial = {
    id = 38,
    pre = "EEopenMaterial"
  },
  EEclickEnhance = {
    id = 39,
    pre = "EEclickMaterial"
  },
  clickEliteModeButton = {id = 40},
  openShop = {id = 41},
  openSpecialShop = {id = 42},
  openSoSpecialShop = {id = 43},
  openSkillUpgrade = {id = 44},
  openpvp = {id = 45},
  openMidas = {id = 46},
  opencot = {id = 47},
  openEnhance = {id = 48},
  openExercise = {id = 49},
  unlockEliteMode = {id = 50},
  unlockShop = {id = 51},
  unlockSpecialShop = {id = 52},
  unlockSoSpecialShop = {id = 53},
  unlockSkillUpgrade = {id = 54},
  unlockpvp = {id = 55},
  unlockMidas = {id = 56},
  unlockcot = {id = 57},
  unlockEnhance = {id = 58},
  unlockExercise = {id = 59},
  equipSuccess = {id = 60},
  aboutHandbook = {id = 61},
  aboutShop = {id = 62},
  aboutSpecialShop = {id = 63},
  aboutSkillUpgrade = {id = 64},
  aboutSkillHeroPackage = {id = 65},
  SUopenShortcut = {id = 66},
  SUclickHeroPackage = {id = 67},
  SUclickHero = {
    id = 68,
    pre = "SUclickHeroPackage",
    addition = {
      "SUopenShortcut"
    }
  },
  SUclickSkillButton = {
    id = 69,
    pre = "SUclickHero"
  },
  SUclickLevelup = {
    id = 70,
    pre = "SUclickSkillButton"
  },
  SUcomplete = {id = 71},
  composeFragment = {id = 72},
  autoBattle = {id = 73},
  useSkill = {id = 74, pre = "FTintoMain"},
  canCraftProp = {id = 75},
  heroUpgrade = {id = 76},
  heroEvolve = {id = 77},
  refreshShop = {id = 78},
  nextWave = {id = 79},
  addHeroToTeam = {id = 80},
  heroExpMax = {id = 81},
  _5v5UseSkill = {id = 82},
  _5v5Anim = {id = 83},
  gotoTavernEnch = {id = 84},
  openTavernEnch = {
    id = 85,
    pre = "gotoTavernEnch"
  },
  tavernEnch = {
    id = 86,
    pre = "openTavernEnch",
    addition = {
      "gotoTavernEnch",
      "openTavernEnch"
    }
  },
  unlockCrusade = {id = 87},

 firstMercenary = {id = 88},

  unlockGuild = {id = 89},
  unlockWorldChannel = {id = 90},
--  unlockExcavate = {id = 91},
  unlockStarShop = {id = 92},
--  openExcavate = {id = 93},
  openStarshop = {id = 94},
  clickExcavatePoint2 = {id = 95},
  clickExcavatePoint3 = {id = 96}
}
class.t_key = t_keys
local c_times = {useSkill = 2, _5v5UseSkill = 4}
class.c_times = c_times
class.label_size = 20
class.label_color = ccc3(253, 246, 143)
class.stroke_color = ccc3(103, 47, 0)
class.label_dimensions = {
  big_vertical = CCSizeMake(125, 0),
  big_horizontal = CCSizeMake(0, 70),
  small_vertical = CCSizeMake(110, 0),
  small_horizontal = CCSizeMake(0, 40)
}
class.bubble_res = {
  big = "UI/alpha/HVGA/tutorial_bubble_big.png",
  small = "UI/alpha/HVGA/tutorial_bubble_small.png"
}
class.bubble_size = {
  big = CCSizeMake(174, 134),
  small = CCSizeMake(172, 90)
}
class.bubble_arrow_gap = {
  big = {
    left = 90,
    right = -90,
    down = 70,
    up = -70
  },
  small = {
    left = 90,
    right = -90,
    down = 50,
    up = -50
  }
}
class.arrow_res = {
  left = "UI/alpha/HVGA/tutorial_arrow_left.png",
  right = "UI/alpha/HVGA/tutorial_arrow_right.png",
  down = "UI/alpha/HVGA/tutorial_arrow_down.png",
  up = "UI/alpha/HVGA/tutorial_arrow_down.png"
}
class.arrow_amplitude_xy = {
  left = ccp(-10, 0),
  right = ccp(10, 0),
  down = ccp(0, 10),
  up = ccp(0, -10)
}
class.arrow_anim_period = 1
class.use_bubble_duration = true
class.base_show_duration = 10
class.popTop = 580
class.popBottom = -100
class.popLeft = -600
class.popRight = 600
class.popGap = 0.2
class.FTintoMain = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.HERE_YOU_CAN_RECRUIT_THE_MOST_POWERFUL_TEAMMATES")),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.FTBronzeOpen = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.FREE_BRONZE_CHEST_SEE_WHATS_INSIDE")),
  dialog_head_pos = ccp(0.65, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 250,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.FTBronzeOne = {type = "tips"}
class.FTBronzeClose = {
  type = "tips",
  dialog_head_pos = ccp(0.1, 0.12),
  dialog_text = T(LSTR("TUTORIALRES.WITH_FIRE_WOMAN_JOINED_IN_I_BEGAN_TO_MOURN_FOR_OUR_ENEMIES"))
}
class.FTSilverOpen = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.SILVER_CHEST_ALSO_FOR_FREE_YEAH")),
  dialog_head_pos = ccp(0.8, 0.25),
  dialog_talk_width = 250,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_from = "right"
}
class.FTSilverOne = {type = "tips"}
class.FTSilverClose = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.WITH_FIRE_WOMAN_JOINED_IN_I_BEGAN_TO_MOURN_FOR_OUR_ENEMIES")),
  dialog_head_pos = ccp(0.1, 0.12)
}
class.FTGoldOpen = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.TRY_GOLD_TREASURE_CHEST")),
  dialog_head_pos = ccp(0.2, 0.15)
}
class.FTGoldOne = {type = "tips"}
class.FTGoldClose = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.BLACK_YOU_ARE_WELCOME_TO_JOIN_OUR_STRENGTH_IS_MORE_POWERFUL")),
  dialog_head_pos = ccp(0.2, 0.12)
}
class.FTbackToMain = {type = "tips", still_show = true}
class.gotoSelectStage = {
  type = "finger",
  need_check_drag = true,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  circle_center = ccp(630, 130),
  circle_radius = 100,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.BEGINNING_OF_A_GREAT_ADVENTURE")),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.selectStage = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_INTO_THE_GAME_POINT")),
  dialog_head_pos = ccp(0.75, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  duration = 0
}
class.gotoPrepare = {type = "finger"}
class.selectHero = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.SEND_HEROES_TO_THE_BATTLEFIELD")),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0
}
class.gotoBattle = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.SEND_HEROES_TO_THE_BATTLEFIELD")),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0
}
class.nextWave = {
  type = "tips",
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  duration = 0,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_HERE_TO_AGAINST_THE_NEXT_WAVE_OF_ENEMIES")),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  dialog_head_flip = false
}
class.useSkill = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_TO_ENLARGE_STROKES")),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 2
}
class._5v5UseSkill = {
  type = "finger",
  must_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_TO_CAST_SKILLS")),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 0
}
class.addHeroToTeam = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.LET_THE_NEW_HEROES_JOIN_THE_FIGHT")),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.autoBattle = {
  type = "tips",
  text = T(LSTR("TUTORIALRES.TURN_ON_AUTOMATIC_BATTLE")),
  offsetx = -30,
  offsety = 50,
  arrowOffsetx = 0,
  showDelay = 1,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.getEquipableProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.THIS_IS_A_WEARABLE_ITEM_LONG_PRESS_TO_VIEW")),
  dialog_head_pos = ccp(0.65, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  dialog_pop_from = "right",
  duration = 0
}
class.clickNextStage = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.GET_A_WEARABLE_EQUIPMENT_PUT_IT_ON")),
  dialog_head_pos = ccp(0.25, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openShortcutToEquip = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.LET_ME_TEACH_YOU_HOW_TO_WEAR_THE_EQUIPMENT")),
  dialog_head_pos = ccp(0.1, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0,
  finger_be_left = true
}
class.gotoEquipProp = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.gotoHeroDetailToEquip = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CHOOSE_ONE_HERO_WHO_CAN_WEAR_EQUIPMENT")),
  dialog_head_pos = ccp(0.1, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.equipProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_OK_TO_EQUIP_\N_IT_BINDS_TO_THE_HERO_AFTER_EQUIPMENT")),
  dialog_head_pos = ccp(0.1, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.canEquipProp = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_EQUIPMENT_SLOT")),
  dialog_head_pos = ccp(0, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.canCraftProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_EQUIPMENT_SLOT")),
  dialog_head_pos = ccp(0.1, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.composeFragment = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.THIS_DEBRIS_CAN_BE_SYNTHESIZED_CLICK_VIEW")),
  dialog_head_pos = ccp(0.1, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.heroUpgrade = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.THE_HERO_CAN_BE_ADVANCED_UP")),
  dialog_head_pos = ccp(-0.3, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.refreshShop = {
  type = "tips",
  text = T(LSTR("TUTORIALRES.REFRESH_TO_SHOW_A_NEW_SERIAL_OF_ITEMS")),
  offsetx = -60,
  arrowDirection = "right"
}
class.stageFailToEquipProp = {
  type = "tips",
  text = T(LSTR("TUTORIALRES.UPDATE_EQUIPMENT_AND_TRY_AGAIN")),
  offsetx = -80,
  showDelay = 1,
  arrowDirection = "right"
}
class.stageFailToUpgradeHero = {
  type = "tips",
  text = T(LSTR("TUTORIALRES.PLEASE_UPGRADE_HERO_LEVEL_AND_THEN_TRY_AGAIN")),
  offsetx = -80,
  showDelay = 1,
  arrowDirection = "right"
}
class.clickEliteModeButton = {
  type = "tips",
  text = T(LSTR("TUTORIALRES.NEWLY_OPEN_ELITE_LEVELS")),
  offsety = -50,
  arrowDirection = "up",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  duration = 0
}
class.closeHeroDetail = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.AFTER_WEAR_FULL_SIX_EQUIPMENTS_THE_HERO_CAN_BECOME_STRONGER_ADVANCED")),
  dialog_head_pos = ccp(-0.3, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 400,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.backToStageSelect = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.ADVENTURE_NOW_CONTINUES")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.firstTaskOpenShortcut = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.firstTaskOpenTaskWindow = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.firstTaskClickComplete = {type = "tips"}
class.firstTaskClickok = {type = "tips"}
class.firstTaskClickClose = {type = "tips"}
class.SHopenShortcut = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.COME_WITH_ME")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickHeroPackage = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.I_HAVE_A_FEELING_THAT_A_NEW_HERO_IS_ABOUT_TO_JOIN_US")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickHero = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.HERO_LISTEN_TO_MY_CALL")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickok = {type = "tips"}
class.EEclickHero = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_TO_SELECT_A_HERO")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.EEselectHero = {type = "tips"}
class.EEclickEquip = {type = "tips"}
class.EEopenMaterial = {type = "tips"}
class.EEclickMaterial = {type = "tips"}
class.EEclickEnhance = {type = "tips"}
class.SUopenShortcut = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.COME_WITH_ME")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips",
  finger_be_left = true
}
class.SUclickHeroPackage = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.IT_IS_TIME_TO_TEACH_YOU_TO_UPGRADE_SKILLS")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.SUclickHero = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.SELECT_A_HERO")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUclickSkillButton = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.YOU_CAN_ACCESS_THE_SKILLS_PANEL_FROM_HERE")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUclickLevelup = {
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.CLICK_THIS_BUTTON_TO_UPGRADE_SKILLS")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUcomplete = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.SKILL_POINTS_ARE_AUTOMATICALLY_RESTORED_OVER_TIME_MAKE_GOOD_USE_OF")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.gotoTavernEnch = {type = "tips", must_show = true}
class.openTavernEnch = {type = "tips", must_show = true}
class.tavernEnch = {type = "tips", must_show = true}
class.aboutHandbook = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.WITH_THE_INCREASE_OF_TEAM_LEVEL_THERE_WILL_BE_MORE_EQUIPMENTS_TO_BE_SHOWED")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.aboutShop = {still_show = true}
class.aboutSkillUpgrade = {still_show = true}
class.aboutSpecialShop = {still_show = true}
class.equipSuccess = {still_show = true}
class.aboutSkillHeroPackage = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.SELECT_THE_HERO_WHO_NEEDS_TO_STRENGTHEN_THE_SKILLS")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.heroExpMax = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T(LSTR("TUTORIALRES.UPGRADE_CLAN_LEVEL_CAN_INCREASE_THERES_LEVEL_CAP")),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.unlockShop = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_STORE_FUNCTION")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop",
  fca_pos = ccp(280, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSkillUpgrade = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_SKILLS_ENHANCEMENT")),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(275, 270),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockEliteMode = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_ELITE_MODE")),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockpvp = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_ARENA_FEATURES")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Pvp",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockMidas = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED GOLDEN_HAND_FUNCTION")),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockcot = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_CAVERNS_OF_TIME")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Guard",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockEnhance = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_ENCHANTING_EQUIPMENT")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Skill",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockExercise = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_HEROES_TRIALS")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Exercise",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockCrusade = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_THE_BURNING_CRUSADE")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Volcano",
  fca_scale = 0.8,
  fca_pos = ccp(269, 275),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockGuild = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_CREATING_AND_JOINING_THE_ASSOCIATION")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Guild",
  fca_scale = 0.6,
  fca_pos = ccp(269, 260),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockWorldChannel = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_WORLD_CHANNEL")),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_worldchannel.png",
  icon_pos = ccp(269, 240),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockExcavate = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.UNLOCKED_TREASURE_CRYPT_")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Treasure",
  fca_scale = 0.5,
  fca_pos = ccp(285, 230),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockStarShop = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T(LSTR("TUTORIALRES.INTERSTELLAR_TRAVEL_BUSINESSMAN_VISITING_")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop_Star",
  fca_scale = 1.2,
  fca_pos = ccp(285, 230),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSpecialShop = {
  type = "announce",
  still_show = true,
  text = T(LSTR("TUTORIALRES.GOBLIN_MERCHANT_HAS_BEEN_FOUND")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop2",
  fca_pos = ccp(269, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSoSpecialShop = {
  type = "announce",
  still_show = true,
  text = T(LSTR("TUTORIALRES.BLACK_MARKET_BUSINESSMAN_HAS_BEEN_FOUND")),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop3",
  fca_pos = ccp(285, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.openShop = {
  type = "tips",
  must_show = true,
  circle_radius = 68,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEW_STORE_OPENS")),
  offsety = 60,
  offsetx = 0,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openSpecialShop = {
  type = "tips",
  must_show = true,
  circle_radius = 68,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_GOBLIN_MERCHANT_OPENS")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openSoSpecialShop = {
  type = "tips",
  must_show = true,
  circle_radius = 40,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_BLACK_MARKET_TRADERS_OPEN")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openStarshop = {
  type = "tips",
  must_show = true,
  circle_radius = 40,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.INTERSTELLAR_TRAVEL_BUSINESSMAN_VISITING_")),
  offsetx = -60,
  arrowDirection = "right",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openEnhance = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_ENCHANT_EQUIPMENT_OPENS")),
  offsety = 20,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openpvp = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_ARENA_OPENS")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openMidas = {type = "tips"}
class.opencot = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_CAVERNS_OF_TIME_OPENS")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openEnhance = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_ENCHANT_EQUIPMENT_OPENS")),
  offsety = 20,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openExercise = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEWLY_HERO_TRIAL_OPENS")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openExcavate = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/HVGA/tutorial_circle_big.png",
  text = T(LSTR("TUTORIALRES.THE_NEW_OPENING_OF_THE_TREASURE_CRYPT_")),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.firstMercenary = {
  type = "tips",
  dialog_text = T(LSTR("TUTORIALRES.YOU_CAN_INVITE_STRONG_FOREIGN_AID_TEAMS_FROM_THE_SAME_GUILD_MERCENARY_CAMP")),
  dialog_head_pos = ccp(0, 0.15),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}

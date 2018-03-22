local base = ed.ui.uires
local class = newclass(base.mt)
ed.ui.mainres = class
class.offset_x = 212
class.offset_x_verytop=212
class.offset_x_verytopmin=0
class.button_key = {
  "mailbox",
  "defence",
  "pve",
  "pvp",
  "shop",
  "sshop",
  "ssshop",
  "handbook",
  "estren",
  "tavern",
  "exercise",
  "volcano",
  "starshop",
--  "excavate"
 "ranklist"
}
class.unlock_keys = {
  defence = "COT",
  pvp = "PVP",
  shop = "shop",
  estren = "Enhance",
  exercise = "Exercise",
  volcano = "Crusade",
  handbook = "Guild",
  excavate = "Excavate"
}
class.res_pos = {
--[[
  tree = {
    res = "eff_UI_Main_Tree",
    pos = ccp(1240, 390),
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0
  },
  spring = {
    res = "eff_UI_Main_Spring",
    pos = ccp(120, 105),
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 65,
    titlePos = ccp(0, -60),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(100, 100)
  },
  ]]--
  lightning = {
    res = "eff_UI_Main_Lightning",
    pos = ccp(205, 330),
    fcaz = 15,
    gap_min = 1.71,
    gap_max = 1.71,
    loop_gap = 1.71,
    loop_times_min = 3,
    loop_times_max = 10
  },
  defence = {
    res = "eff_UI_Main_Guard",
	aniType = 1,
    pos = ccp(1270, 280),
    scale = 0.9,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(-10, 10),
    touchRadius = 65,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.TimeRift"),
    titlePos = ccp(0, -50),
    lightPos = ccp(0, 40),
    lightSize = CCSizeMake(300, 300)
  },
  pvp = {
    res = "eff_UI_Main_Pvp",
	aniType = 1,
    pos = ccp(355, 150),
    --scale = 0.8,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(-15, 0),
    touchRadius = 65,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Arean"),
    titlePos = ccp(0, -40),
    lightPos = ccp(0, 40),
    lightSize = CCSizeMake(350, 400)
  },
  pve = {
    res = "eff_UI_Main_Pve",
	aniType = 1,
    pos = ccp(625, 135),
	parent_index = 4,
    --scale = 0.8,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(-10, 0),
    touchRadius = 100,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Campaign"),
    titlePos = ccp(3, -70),
    lightPos = ccp(0, 19),
    lightSize = CCSizeMake(230, 350)
  },
  tavern = {
    res = "eff_UI_Main_Tarven",
	aniType = 1,
    pos = ccp(1290, 90),
    --scale = 1.0,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 13),
    touchRadius = 100,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Chests"),
    titlePos = ccp(0, -40),
    lightPos = ccp(0, 30),
    lightSize = CCSizeMake(300, 200)
  },
  exercise = {
    res = "eff_UI_Main_Exercise",
	aniType = 1,
    pos = ccp(1150, 185),
    --scale = 0.9,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 13),
    touchRadius = 85,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Trials"),
    titlePos = ccp(0, -60),
    lightPos = ccp(0, 35),
    lightSize = CCSizeMake(200, 250)
  },
  estren = {
    res = "eff_UI_Main_Skill",
	aniType = 1,
    pos = ccp(475, 275),
    --scale = 0.65,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(-10, 2),
    touchRadius = 85,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Enchanting"),
    titlePos = ccp(-0, -40),
    lightPos = ccp(-0, 60),
    lightSize = CCSizeMake(250, 250)
  },
  handbook = {
    res = "eff_UI_Main_Guild",
	aniType = 1,
    pos = ccp(115, 90),
    --scale = 0.6,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, -5),
    touchRadius = 150,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Guild"),
    titlePos = ccp(0, -60),
    lightPos = ccp(0, 30),
    lightSize = CCSizeMake(500, 500)
  },
  shop = {
    res = "eff_UI_Main_Shop",
	aniType = 1,
    pos = ccp(1000, 225),
    scale = 0.8,
    gap_min = 2.75,
    gap_max = 2.75,
    loop_gap = 1.71,
    loop_times_min = 2,
    loop_times_max = 6,
    touchCenter = ccp(25, 0),
    touchRadius = 68,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Merchant"),
    titlePos = ccp(0, -30),
    lightPos = ccp(0, 50),
    lightSize = CCSizeMake(300, 300)
  },
  sshop = {
    res = "eff_UI_Main_Shop2",
	aniType = 1,
    pos = ccp(195, 200 ),
    --scale = 0.8,
    gap_min = 1.46,
    gap_max = 1.46,
    loop_gap = 1.46,
    loop_times_min = 1,
    loop_times_max = 6,
    touchCenter = ccp(0, 0),
    touchRadius = 68,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.GoblinMerchant"),
    titlePos = ccp(5, -30),
    lightPos = ccp(0, 25),
    lightSize = CCSizeMake(317, 300),
    summonTitleres = "UI/alpha/HVGA/main_title_summonsshop_a.png",
    summonTitlePressres = "UI/alpha/HVGA/main_title_summonsshop_b.png",
    summonTitlenotopenres = "UI/alpha/HVGA/main_title_summonsshop_a.png",
    summonTitle = LSTR("mainres.SummonPermanentMerchant"),
  },
  ssshop = {
    res = "eff_UI_Main_Shop3",
	aniType = 1,
    pos = ccp(10, 220),
    --scale = 0.8,
    gap_min = 2,
    gap_max = 4,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 40,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Godfather"),
    titlePos = ccp(5, -45),
    lightPos = ccp(0, 45),
    lightSize = CCSizeMake(307, 200),
    summonTitleres = "UI/alpha/HVGA/main_title_summonsshop_a.png",
    summonTitlePressres = "UI/alpha/HVGA/main_title_summonsshop_b.png",
    summonTitlenotopenres = "UI/alpha/HVGA/main_title_summonsshop_a.png",
    summonTitle = LSTR("mainres.SummonPermanentGodfather"),
  },
  mailbox = {
    res = "eff_UI_Main_Mailbox",
	aniType = 1,
    --default_action = "Empty",
    --scale = 0.8,
    gap_min = 2,
    gap_max = 4,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    pos = ccp(1000, 70),
    touchCenter = ccp(0, 40),
    touchRadius = 60,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Mailbox"),
    titlePos = ccp(5, -25),
    lightPos = ccp(8, 45),
    lightSize = CCSizeMake(200, 200)
  },
  volcano = {
    res = "eff_UI_Main_Volcano",
	aniType = 1,
    --scale = 0.8,
    parent_index = 2,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    pos = ccp(670, 350),
    touchCenter = ccp(0, -30),
    touchRadius = 100,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Crusade"),
    titlePos = ccp(0, -40),
    lightPos = ccp(0, 40),
    lightSize = CCSizeMake(250, 250)
  },
  starshop = {
    res = "eff_UI_Main_Shop_Star",
    scale = 0.8,
    gap_min = 1.4583,
    gap_max = 1.4583,
    loop_gap = 2.04167,
    loop_times_min = 3,
    loop_times_max = 10,
    pos = ccp(82, 240),
    touchCenter = ccp(0, 35),
    touchRadius = 60,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.StarShop"),
    titlePos = ccp(-5, -48),
    lightPos = ccp(-6, 30),
    lightSize = CCSizeMake(150, 180)
  },
  excavate = {
    res = "eff_UI_Main_Treasure",
	aniType = 1,
    --scale = 1,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    pos = ccp(1450, 190),
    touchCenter = ccp(0, -50),
    touchRadius = 100,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Excavate"),
    titlePos = ccp(0, -125),
    lightPos = ccp(0, 75),
    lightSize = CCSizeMake(600, 400)
  },
  ranklist = {
    res = "eff_UI_Main_Rank",
	aniType = 1,
    --scale = 1,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    pos = ccp(860, 150),
    touchCenter = ccp(0, 30),
    touchRadius = 50,
    titleres = "UI/alpha/HVGA/main_title_a.png",
    titlePressres = "UI/alpha/HVGA/main_title_b.png",
    titlenotopenres = "UI/alpha/HVGA/main_title_a.png",
    title = LSTR("mainres.Rank"),
    titlePos = ccp(0, -40),
    lightPos = ccp(0, 30),
    lightSize = CCSizeMake(150, 250)
  }
}
class.cloud_res = {
  cloud4 = {
    pos = ccp(305, 370),
    move_duration = 6,
    move_distance = ccp(0, 5)
  },
  cloud5 = {
    pos = ccp(195, 385),
    move_duration = 8,
    move_distance = ccp(0, 15)
  },
  cloud6 = {
    pos = ccp(270, 420),
    move_duration = 4,
    move_distance = ccp(0, -5)
  }
}
class.drag_range = {
  x = {
    min = 0,
    max = class.offset_x,
	maxverytop=class.offset_x_verytop,
	minverytop=class.offset_x_verytopmin
  },
  y = {min = 0, max = 0}
}
class.sky_coefficient = 0.3
class.sea_coefficient = 0.4
class.verytop_coefficient=0.9
class.light_coefficient = 1
class.drag_mode_judge_range = 50
class.drag_inertance_gap = 0.5
class.drag_inertance_coefficient = 1


class.CampaignX=530
class.CampaignY=-30

class.animationX=0
class.animationY=0

class.waterFallX=745
class.waterFallY=175

class.mainFogX=600
class.mainFogY=0
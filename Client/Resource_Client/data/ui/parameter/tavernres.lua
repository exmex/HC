local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.tavernres = class
class.board_bg = {
  bronze = "UI/alpha/HVGA/tavern_bg_1.png",
  silver = "UI/alpha/HVGA/tavern_bg_2.png",
  gold = "UI/alpha/HVGA/tavern_bg_3.png",
  magic = "UI/alpha/HVGA/tavern_bg_2.png"
}
class.light_res = {
  bronze = nil,
  silver = "UI/alpha/HVGA/tavern_light_rotate_2.png",
  gold = "UI/alpha/HVGA/tavern_light_rotate_3.png",
  magic = "UI/alpha/HVGA/tavern_light_rotate_2.png"
}
class.is_light_visible = {
  bronze = false,
  silver = true,
  gold = true,
  magic = true
}
class.board_title = {
  bronze = "UI/alpha/HVGA/tavern_title_1.png",
  silver = "UI/alpha/HVGA/tavern_title_2.png",
  gold = "UI/alpha/HVGA/tavern_title_3.png",
  magic = "UI/alpha/HVGA/tavern_title_4.png"
}
class.box_res = {
  bronze = "UI/alpha/HVGA/tavern_bg_chest_1.png",
  silver = "UI/alpha/HVGA/tavern_bg_chest_2.png",
  gold = "UI/alpha/HVGA/tavern_bg_chest_3.png",
  magic = "UI/alpha/HVGA/tavern_bg_chest_4.png"
}
class.first_ad_res = {
  bronze = "UI/alpha/HVGA/tavern_ad_1.png",
  silver = "UI/alpha/HVGA/tavern_ad_2.png",
  gold = "UI/alpha/HVGA/tavern_ad_3.png",
  magic = "UI/alpha/HVGA/tavern_ad_13.png"
}
class.common_ad_res = {
  bronze = "UI/alpha/HVGA/tavern_ad_4.png",
  silver = "UI/alpha/HVGA/tavern_ad_5.png",
  gold = "UI/alpha/HVGA/tavern_ad_6.png",
  magic = "UI/alpha/HVGA/tavern_ad_13.png"
}
class.ten_prompt = {
  bronze = T(LSTR("TAVERNRES.ONE_BLUE_ITEM_IS_DOOMED_TO_BE_GOT_IF_YOU_DRAW_10TIMES_AT_ONE_TIME")),
  silver = T(LSTR("TAVERNRES.MULTIPLE_SOUL_STONES_ARE_DOOMED_TO_BE_GOT_IF_YOU_DRAW_10_TIMES_AT_ONE_TIME")),
  gold = T(LSTR("TAVERNRES.HERO_IS_DOOMED_TO_BE_GOT_IF_YOU_DRAW_10TIMES_AT_ONE_TIME")),
  magic = T(LSTR("TAVERNRES.CAN_GET_MULTIPLE_SOUL_STONES"))
}

local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.herodetailres = class
local base = ed.ui.baseres
setmetatable(class, base.mt)
local equip_tag_icon = {
  wear = "UI/alpha/HVGA/herodetail-equipadd.png",
  cannotwear = "UI/alpha/HVGA/herodetail_icon_plus_yellow.png"
}
class.equip_tag_icon = equip_tag_icon
local equip_tag_text = {
  notHave = "UI/alpha/HVGA/herodetail-equip-nowned.png",
  canWear = "UI/alpha/HVGA/herodetail-equip-owned.png",
  cannotwear = "UI/alpha/HVGA/herodetail_cannot_equip.png",
  canCraft = "UI/alpha/HVGA/herodetail-equip-craftable.png"
}
class.equip_tag_text = equip_tag_text
local type_icon = {
  STR = "UI/alpha/HVGA/icon_str.png",
  AGI = "UI/alpha/HVGA/icon_agi.png",
  INT = "UI/alpha/HVGA/icon_int.png"
}
class.type_icon = type_icon
local card_type_icon = {
  STR = "UI/alpha/HVGA/card/card_att_str.png",
  AGI = "UI/alpha/HVGA/card/card_att_agi.png",
  INT = "UI/alpha/HVGA/card/card_att_int.png"
}
class.card_type_icon = card_type_icon
local card_frame = {
  "UI/alpha/HVGA/card/card_bg_white.png",
  "UI/alpha/HVGA/card/card_bg_green.png",
  "UI/alpha/HVGA/card/card_bg_green.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_orange.png"
}
class.card_frame = card_frame
class.card_rotate_amount = 0
class.card_rotate_direction = "left"

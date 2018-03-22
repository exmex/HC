local base = ed.ui.baseres
local class = newclass(base.mt)
ed.ui.uires = class
setfenv(1, class)
local winLeft, winRight = ed.getDisplayVertex()
local ori_pos = ccp(220, 392)
local d_pos = ccp(110, 0)
vit_gap = math.floor(sync_vitality_gap / 60)
shortcut_board_to_right = 40
shortcut_board_pos = ccp(winRight - shortcut_board_to_right, 460)
shortcut_board_pop_time = 0.2
shortcut_board_width = 82
shortcut_board_touch_width = 100
shortcut_board_height_max = 460
shortcut_board_height_min = 40
shortcut_pos_x = shortcut_board_pos.x
shortcut_pos_y = 440
s_b_offset_y = -20
shortcutBoardButtonHeight = {
  138,
  208,
  284,
  354,
  434
}
shortcutBoardButtonPosY = {
  382,
  307,
  237,
  162,
  83
}
for i = 1, #shortcutBoardButtonHeight do
  shortcutBoardButtonHeight[i] = shortcutBoardButtonHeight[i] + s_b_offset_y
end
for i = 1, #shortcutBoardButtonPosY do
  shortcutBoardButtonPosY[i] = shortcutBoardButtonPosY[i] + s_b_offset_y
end
shortcut_board_rect = CCRectMake(shortcut_board_pos.x - shortcut_board_touch_width / 2, 0, shortcut_board_touch_width, 480)
head_bg_pos = ccp(winLeft + 70, 434)
head_icon_pos = ccp(40, 54)
head_icon_radius = 30
fourth_pos = ccpAdd(ori_pos, ccpMult(d_pos, 3))
fourth_radius = 23
third_pos = ccpAdd(ori_pos, ccpMult(d_pos, 2))
third_radius = 23
recharge_pos = ccpAdd(ori_pos, ccpMult(d_pos, 1))
recharge_radius = 23
fblogin_pos = ccpAdd(ori_pos, ccp(winLeft-185, -110))
fblogin_radius = 23
appremark_pos = ccpAdd(ori_pos, ccp(winLeft-185, -50))
appremark_radius = 23
dailylogin_pos = ori_pos
dailylogin_radius = 23
mrv_scale = 1
mrv_scale_large = 1.5
--add by cooper.x for activity
activity_pos = ccpAdd(ori_pos, ccpMult(d_pos, 2))
activity_radius = 23
--
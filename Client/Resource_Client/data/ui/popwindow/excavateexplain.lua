local base = ed.ui.explainwindow
local class = newclass(base.mt)
ed.ui.excavateexplain = class
local createContent = function(self)
  local lx, rx = self.left_x, self.right_x
  local oy = self.top_y
  local container = self.draglist.listLayer
  local text_list_1 = {
    T(LSTR("EXCAVATEEXPLAIN.DARK_IRON_DWARVES_KINGDOM_BUILDING_IN_THE_GROUND_MORE_WRONG_SECTION_OF_THE_HOLE_DISK_AS_THE_ROOT_OF_THE_TREE_OF_THE_WORLD_TO_BE")),
    T(LSTR("EXCAVATEEXPLAIN.BUT_ITS_HISTORY_OLDER_THAN_THE_WORLD_TREE_ITSELF_WHEN_THESE_DORMANT_FOR_MILLIONS_OF_YEARS_OF_HEAVY_TREASURE")),
    T(LSTR("EXCAVATEEXPLAIN.SEE_THE_LIGHT_EXPLORERS_WERE_SURPRISED_TO_HAVE_FOUND_GOLD_AND_DIAMONDS_ARE_STILL_DWARVES_TIMELESS_A")),
    T(LSTR("EXCAVATEEXPLAIN.DUST_IS_NOT_DYED_BUT_WITH_GOLD_AS_ETERNAL_HUMAN_GREED_AND_PLUNDER"))
  }
  local text_2 = T(LSTR("EXCAVATEEXPLAIN._ANUBAR_WARS"))
  local text_list_3 = {
    T(LSTR("EXCAVATEEXPLAIN.1_IN_THE_TREASURE_CRYPT_YOU_CAN_FIND_A_VARIETY_OF_RESOURCE_POINTS_INCLUDING_GOLD_DIAMOND_AND_LABORATORY")),
    T(LSTR("EXCAVATEEXPLAIN.2_YOU_CAN_LAUNCH_MULTIPLE_ATTACKS_POINT_TO_RESOURCES_EACH_ATTACK_WILL_CONSUME_SOME_ENERGY_AND")),
    T(LSTR("EXCAVATEEXPLAIN.OBTAIN_THE_CORRESPONDING_TEAM_EXPERIENCE_BEFORE_THE_END_OF_ALL_THE_FIGHTING_BOTH_OFFENSIVE_AND_DEFENSIVE_HEROS_LIFE")),
    T(LSTR("EXCAVATEEXPLAIN.AND_ENERGY_VALUES_​​ARE_NOT_RESET")),
    T(LSTR("EXCAVATEEXPLAIN.3_IF_YOU_BEAT_ALL_THE_DEFENDERS_IN_A_LIMITED_TIME_YOU_CAN_CAPTURE_RESOURCE_POINTS_OCCUPIED_CAPITAL")),
    T(LSTR("EXCAVATEEXPLAIN.YOU_WILL_CONTINUE_TO_SOURCE_PRODUCTION_RESOURCES")),
    T(LSTR("EXCAVATEEXPLAIN.4_WHEN_THE_NEW_OCCUPATION_TREASURES_RANGING_FROM_THE_PROTECTION_OBTAINED_12_HOURS_DEPENDING_ON_THE_TYPE_OF_TREASURES")),
    T(LSTR("EXCAVATEEXPLAIN.ROOMS_IN_THE_GUARD_TIME_OTHER_PLAYERS_CAN_NOT_SEARCH_AND_ATTACK_THIS_TREASURE")),
    T(LSTR("EXCAVATEEXPLAIN.5_RESOURCE_POINTS_YOU_NEED_TO_SEND_A_HERO_DEFENSE_HAD_OCCUPIED_THE_MORE_HEROIC_GARRISON_RESOURCE_EXPLOITATION")),
    T(LSTR("EXCAVATEEXPLAIN.FASTER")),
    T(LSTR("EXCAVATEEXPLAIN.6_DURING_THE_HEROIC_GARRISON_CAN_NOT_PARTICIPATE_IN_OTHER_BATTLES_YOU_CAN_ALWAYS_REPLACE_THE_GARRISON_HERO")),
    T(LSTR("EXCAVATEEXPLAIN.7_RESOURCE_LIMITED_RESOURCE_POINTS_TOTAL_RESERVES_ALL_MINING_FINISHED_THE_HERO_WILL_BE_SHIPPED_ALL_RESOURCES")),
    T(LSTR("EXCAVATEEXPLAIN.BACK_TO_YOUR_WAREHOUSE")),
    T(LSTR("EXCAVATEEXPLAIN.8_IF_THE_RESOURCE_EXTRACTION_PROCESS_WAS_ATTACKED_AND_DEFENSE_FAILS_YOU_MAY_LOSE_PART")),
    T(LSTR("EXCAVATEEXPLAIN.RESOURCES_HAVE_BEEN_MINED_THE_REMAINING_RESOURCES_WILL_BE_TRANSPORTED_BACK_TO_YOUR_WAREHOUSE")),
    T(LSTR("EXCAVATEEXPLAIN.9_SOME_LARGE_RESOURCE_POINTS_CAN_ACCOMMODATE_MORE_THAN_A_COMMON_DEFENSIVE_PLAYER_YOU_CAN_INVITE_THE_SAME_GUILD")),
    T(LSTR("EXCAVATEEXPLAIN.SMALL_PARTNER_WITH_DEFENSE_ALL_DEFENDERS_CAN_EXPLOIT_RESOURCES")),
    T(LSTR("EXCAVATEEXPLAIN.10_IN_THE_TREASURE_CRYPT_BATTLE_THE_HERO_OF_THE_DEFENSE_WILL_GET_SOME_INITIAL_ENERGY"))
  }
  local dy = 3
  local height = 0
  for i, v in ipairs(text_list_1) do
    local label = ed.createttf(v, 16)
    ed.setLabelDimensions(label, self.label_dimensions)
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(ccp(lx, oy - height))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    container:addChild(label)
    height = height + label:getContentSize().height + dy
    ed.setLabelColor(label, ccc3(255, 255, 221))
  end
  local label_2 = ed.createttf(text_2, 16)
  label_2:setAnchorPoint(ccp(1, 1))
  label_2:setPosition(ccp(rx, oy - height))
  height = height + label_2:getContentSize().height + 20
  container:addChild(label_2)
  ed.setLabelColor(label_2, ccc3(255, 255, 221))
  for i, v in ipairs(text_list_3) do
    local label = ed.createttf(v, 16)
    ed.setLabelDimensions(label, self.label_dimensions)
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(ccp(lx, oy - height))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    container:addChild(label)
    height = height + label:getContentSize().height + dy
    ed.setLabelColor(label, ccc3(238, 204, 119))
  end
  self.draglist:initListHeight(height + 20)
end
class.createContent = createContent
local function create()
  local self = base.create()
  setmetatable(self, class.mt)
  self:createContent()
  return self
end
class.create = create
local function pop()
  local window = create()
  window:popWindow()
end
class.pop = pop

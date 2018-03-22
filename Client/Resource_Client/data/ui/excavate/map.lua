local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.excavatemap = class
local ore_offset_y = 0
local ore_points = {
  {
    ed.DGccp(510, 275 + ore_offset_y)
  },
  {
    ed.DGccp(394, 276 + ore_offset_y),
    ed.DGccp(612, 276 + ore_offset_y)
  },
  {
    ed.DGccp(510, 280 + ore_offset_y),
    ed.DGccp(315, 240 + ore_offset_y),
    ed.DGccp(695, 240 + ore_offset_y)
  }
}
local ore_bg_pos = ed.DGccp(510, 285)
local page_width = 700
local getData = function()
  return ed.player.excavate_data
end
class.getData = getData
local function showFog(self)
  local ui = self.ui
  local fog = ui.search_fog
  local fogLayer = CCLayer:create()
  fogLayer:setTouchEnabled(true)
  fogLayer:registerScriptTouchHandler(function()
    return true
  end, false, -100, true)
  self.mainLayer:addChild(fogLayer)
  ui.fogLayer = fogLayer
  local function showSearchIcon()
    ui.search_icon:setVisible(true)
    class.search_icon_pos = class.search_icon_pos or ccp(ui.search_icon:getPosition())
    self:registerUpdateHandler("iconMoveCircle", ed.readaction.getMoveCircleAction({
      palstance = 180,
      node = ui.search_icon,
      center = class.search_icon_pos,
      radius = 20,
      target = 1,
      callback = function()
        ui.search_icon:setVisible(false)
        self:removeUpdateHandler("iconMoveCircle")
        ed.ui.excavate.search(function(param)
          self:destroyFog(param)
        end, function()
          self:destroyFog()
        end)
        self:removeUpdateHandler("iconMoveCircle")
      end
    }))
  end
  self:initPageTitle()
  self:hideArrow()
  self.ui.info_layer:setVisible(false)
  local s = CCFadeIn:create(1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      showSearchIcon()
    end, EDDebug)
  end)
  fog:runAction(ed.readaction.create({
    t = "seq",
    s,
    func
  }))
end
class.showFog = showFog
local destroyFog = function(self, param)
  local ui = self.ui
  local fogLayer = ui.fogLayer
  local fog = ui.search_fog
  self:refreshCostLabel()
  if param then
    self:initMap(ed.ui.excavate.getSearchedID())
  end
  local f = CCFadeOut:create(1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if param then
        self:showSearchText(param)
      end
      fogLayer:removeFromParentAndCleanup(true)
      self:showArrow()
      self.ui.info_layer:setVisible(true)
    end, EDDebug)
  end)
  fog:runAction(ed.readaction.create({
    t = "seq",
    f,
    func
  }))
end
class.destroyFog = destroyFog
local getRow = function(self)
  local id = self.typeid
  local data = ed.getDataTable("ExcavateTreasure")
  local row = data[id]
  if not row then
    print("Invalid id of excavate!")
  end
  return row
end
class.getRow = getRow
local registerTouchHandler = function(self)
  local ui = self.ui
  local param = self.param
  local et = param.type
  self:btRegisterButtonClick({
    button = ui.back_button,
    press = ui.back_button_press,
    key = "back_button",
    clickHandler = function()
      ed.popScene()
    end
  })
  if et ~= "defend" then
    self:btRegisterButtonClick({
      button = ui.histroy_button,
      press = ui.histroy_button_press,
      key = "histroy_button",
      clickHandler = function()
        ed.ui.excavatehistory.pop()
      end
    })
    self:btRegisterButtonClick({
      button = ui.explain_button,
      press = ui.explain_button_press,
      key = "explain_button",
      clickHandler = function()
        ed.ui.excavateexplain.pop()
      end
    })
    self:btRegisterButtonClick({
      button = ui.research_button,
      press = ui.research_button_press,
      key = "search_button",
      pressHandler = function()
        if ui.search_label:isVisible() then
          ui.search_label_press:setVisible(true)
        end
        if ui.research_label:isVisible() then
          ui.research_label_press:setVisible(true)
        end
      end,
      cancelPressHandler = function()
        if ui.search_label:isVisible() then
          ui.search_label_press:setVisible(false)
        end
        if ui.research_label:isVisible() then
          ui.research_label_press:setVisible(false)
        end
      end,
      clickHandler = function()
        if ed.ui.excavate.checkSearchTimeMax() then
          ed.showToast(T(LSTR("MAP.TODAY_THE_SEARCH_HAS_REACHED_THE_MAXIMUM_NUMBER_OF_TIMES_")))
          return
        end
        if ed.ui.excavate.checkMineExcavateMax() then
          if ed.ui.excavate.canMineExcavateBeMore() then
            ed.showHandyDialog("needHighervip", {
              wholeText = LSTR("MAP.THE_TREASURE_HAS_REACHED_THE_MAXIMUM_NUMBER_PLEASE_UPGRADE_YOUR_VIP_LEVEL")
            })
          else
            ed.showToast(T(LSTR("MAP.THE_TREASURE_HAS_REACHED_THE_MAXIMUM_NUMBER_")))
          end
          return
        end
        local cost = ed.player:getExcavateSearchCost()
        local gold = ed.player._money
        local function doSearch()
          if cost > gold then
            ed.showHandyDialog("useMidas", {
              refreshHandler = function()
                self:refreshCostLabel()
              end
            })
          else
            self:showFog()
          end
        end
        local function askSearch()
          local info = {
            text = T(LSTR("MAP.RE_LOOKING_TO_GIVE_UP_PREVIOUSLY_TO_EXPLORE_THE_TREASURES_AND_SPEND__D_GOLD_CONTINUE"), cost),
            rightHandler = function()
              doSearch()
            end
          }
          ed.showConfirmDialog(info)
        end
        if ed.ui.excavate.checkSearching() then
          if ed.player.excavateSearchId == ed.player.excavateAttackId then
            askSearch()
          else
            doSearch()
          end
        else
          doSearch()
        end
      end
    })
  end
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "left_button",
    clickHandler = function()
      if not ui.left_button:isVisible() then
        return
      end
      self:turnPage({mode = "pre"})
    end
  })
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "right_button",
    clickHandler = function()
      if not ui.right_button:isVisible() then
        return
      end
      self:turnPage({mode = "next"})
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function refreshCountTime(self)
  local index = self.currentIndex
  local data = getData()[index]
  if not data then
    return
  end
  local ui = self.ui
  local bw
  local bw_1, bw_2 = 328, 420
  local bh_1, bh_2 = 127, 168
  local x1, y1 = -106, -4
  local x2, y2 = -106, -38
  local x3, y3 = 0, -72
  if data._owner == "mine" then
    x3 = -152
    bw = bw_2
  else
    x3 = -113
    bw = bw_1
  end
  ui.lack_label_container:setVisible(true)
  ui.speed_label_container:setVisible(true)
  ui.count_time_container:setVisible(false)
  ui.lack_label_container:setPosition(ccp(x1, y1))
  ui.speed_label_container:setPosition(ccp(x2, y2))
  ui.count_time_container:setPosition(ccp(x3, y3))
  ui.explain_bg:setContentSize(ed.DGSizeMake(bw, bh_1))
  pp = ui.explain_bg
  local et = data._state_end_ts or 0
  local dt = et - ed.getServerTime()
  if data._owner == "monster" then
    ui.lack_label_container:setVisible(false)
    ui.speed_label_container:setPosition(ccp(x2, y1))
    ui.count_time_container:setPosition(ccp(x3, y2))
  end
  if data._state == "prepare" then
    ui.count_time_container:setVisible(true)
    ui.speed_label_container:setVisible(false)
    ui.count_time_container:setPosition(ccp(x3, y2))
    local text = ed.gethmsCString(dt)
    ed.setLabelString(ui.count_time_label, T(LSTR("MAP._S_AFTER_THE_START_GENERATING_RESOURCES"), text))
  elseif data._state == "battle" then
    ui.count_time_container:setVisible(true)
    if data._owner ~= "monster" then
      ui.explain_bg:setContentSize(ed.DGSizeMake(bw, bh_2))
    end
    local text = ed.gethmsCString(dt)
    ed.setLabelString(ui.count_time_label, T(LSTR("MAP.AFTER_THE_FIGHTING_ENDED__S"), text))
  elseif data._state == "occupy" then
    if data._owner == "mine" then
      ui.count_time_container:setVisible(true)
      ui.explain_bg:setContentSize(ed.DGSizeMake(bw, bh_2))
      local storage = ed.ui.excavate.getStorage(self.currentid)
      local speed = ed.ui.excavate.getProduceSpeed(self.currentid)
      local et
      if speed == 0 then
        et = -1
      else
        et = storage / speed
      end
      local h = et / 60
      local m = et % 60
      local text
      if et > 1 then
        if h then
          if m == 0 then
            text = T(LSTR("MAP.AFTER_MINING_APPROXIMATELY__D_HOURS"), h)
          else
            text = T(LSTR("MAP.ABOUT__D_HOURS__D_MINUTES_AFTER_THE_COMPLETION_OF_MINING"), h, m)
          end
        else
          text = T(LSTR("MAP.AFTER_MINING_APPROXIMATELY__D_MINUTES"), m)
        end
      else
        text = T(LSTR("MAP.THIS_TREASURE_IS_ABOUT_TO_FINISH_MINING"))
      end
      ed.setString(ui.count_time_label, text)
      if et < 0 then
        ui.count_time_container:setVisible(false)
      end
    end
  elseif data._state == "protect" and data._owner == "mine" then
    ui.count_time_container:setVisible(true)
    text = T(LSTR("MAP.THIS_TREASURE_IS_ABOUT_TO_FINISH_MINING"))
    ed.setString(ui.count_time_label, text)
  end
end
class.refreshCountTime = refreshCountTime
local function refreshBaseRecord(self)
  local index = self.currentIndex
  local data = getData()[index]
  if not data then
    return
  end
  local owner = data._owner
  local ui = self.ui
  local storage = ed.ui.excavate.getStorage(self.currentid)
  local unitTime = 60
  ed.setLabelString(ui.cost_label, ed.player:getExcavateSearchCost())
  local storageTitle, speedTitle, storageAmount, speedAmount
  if ed.isElementInTable(owner, {"others", "monster"}) then
    storageTitle = T(LSTR("MAP.YOU_CAN_PLUNDER_"))
    speedTitle = T(LSTR("EXCAVATEMAP.PRODUCTION_SPEED_"))
    storageAmount = ed.ui.excavate.getProduced(self.currentid) * ed.ui.excavate.getRobRatio(self.currentid)
    speedAmount = ed.ui.excavate.getProduceSpeed(self.currentid) * unitTime
  else
    storageTitle = T(LSTR("MAP.MY_ACCUMULATED_RESOURCES_"))
    speedTitle = T(LSTR("MAP.MY_PRODUCTION_SPEED_"))
    storageAmount = ed.ui.excavate.getProduced(self.currentid, ed.getUserid())
    speedAmount = ed.ui.excavate.getProduceSpeed(self.currentid, ed.getUserid()) * unitTime
  end
  storageAmount = math.floor(storageAmount)
  local pstr = "%d/%d"
  if speedAmount - math.floor(speedAmount) > 0 then
    pstr = "%.1f/%d"
  end
  ed.setLabelString(ui.lack_label_title, storageTitle)
  ed.setLabelString(ui.speed_label_title, speedTitle)
  ed.setLabelString(ui.lack_number_label, T("x%s", storageAmount))
  ed.setLabelString(ui.speed_number_label, "x" .. T(pstr, speedAmount, unitTime / 60) .. T(LSTR("TIME.HOUR")))
  local type_id_group = {
    gold = {
      4,
      5,
      6
    },
    diamond = {
      1,
      2,
      3
    },
    exp = {
      7,
      8,
      9
    }
  }
  for k, v in pairs(type_id_group) do
    if ed.isElementInTable(self.typeid, v) then
      ui["lack_icon_" .. k]:setVisible(true)
      ui["speed_icon_" .. k]:setVisible(true)
    else
      ui["lack_icon_" .. k]:setVisible(false)
      ui["speed_icon_" .. k]:setVisible(false)
    end
  end
  self:refreshCountTime()
end
class.refreshBaseRecord = refreshBaseRecord
local refreshHistoryTag = function(self)
  local ui = self.ui
  local tag = ui.history_red_tag
  if ed.player:checkUnreadExcavateHistory() then
    tag:setVisible(true)
  else
    tag:setVisible(false)
  end
end
class.refreshHistoryTag = refreshHistoryTag
local function refresh(self)
  local index = self.currentIndex
  local data = getData()[index]
  if not data then
    return
  end
  local owner = data._owner
  local ui = self.ui
  local param = self.param
  local et = param.type
  if ed.isElementInTable(et, {"defend"}) then
    ui.research_frame:setVisible(false)
    ui.histroy_button:setVisible(false)
    ui.explain_button:setVisible(false)
  else
    ui.research_frame:setVisible(true)
    ui.histroy_button:setVisible(true)
    ui.explain_button:setVisible(true)
    if ed.ui.excavate.checkSearching() then
      self.ui.search_label:setVisible(false)
      self.ui.research_label:setVisible(true)
    else
      self.ui.search_label:setVisible(true)
      self.ui.research_label:setVisible(false)
    end
  end
  self:refreshBaseRecord()
  self:refreshPageTitle()
  self:refreshPageTag()
  self:refreshCostLabel()
  self:refreshHistoryTag()
  self:showArrow()
end
class.refresh = refresh
local getTeamData = function(self, data, index)
  return data._team[index]
end
class.getTeamData = getTeamData
local turnPage = function(self, param)
  self.turnPageQueue = self.turnPageQueue or {}
  table.insert(self.turnPageQueue, param)
end
class.turnPage = turnPage
local function doTurnPage(self, param)
  if #getData() < 2 then
    return
  end
  local param = param or {}
  local mode = param.mode
  if not mode then
    return
  end
  local ratio = 1
  if mode == "next" then
    if not self:doTurnNextPage() then
      self.lockTurnPage = nil
      return
    end
    ratio = 1
  elseif mode == "pre" then
    if not self:doTurnPrePage() then
      self.lockTurnPage = nil
      return
    end
    ratio = -1
  end
  self:refreshPageTag(mode)
  local mapContainer, ui = self:createMap(self.currentIndex)
  local container = self.ui.animLayer
  container:addChild(mapContainer)
  mapContainer:setPosition(page_width * ratio, 0)
  local move = CCMoveTo:create(0.2, ccp(-page_width * ratio, 0))
  move = CCEaseSineOut:create(move)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.ui.mapContainer:removeFromParentAndCleanup(true)
      mapContainer:setPosition(ccp(0, 0))
      container:setPosition(ccp(0, 0))
      self.ui.mapContainer = mapContainer
      self:refresh()
      self.lockTurnPage = nil
    end, EDDebug)
  end)
  container:runAction(ed.readaction.create({
    t = "seq",
    move,
    func
  }))
end
class.doTurnPage = doTurnPage
local function doTurnNextPage(self)
  local index = self.currentIndex
  index = index + 1
  if index > #getData() then
    index = #getData()
    self:showArrow()
    return false
  end
  self.currentIndex = index
  self:showArrow()
  return true
end
class.doTurnNextPage = doTurnNextPage
local doTurnPrePage = function(self)
  local index = self.currentIndex
  index = index - 1
  if index < 1 then
    index = 1
    self:showArrow()
    return false
  end
  self.currentIndex = index
  self:showArrow()
  return true
end
class.doTurnPrePage = doTurnPrePage
local hideArrow = function(self)
  local ui = self.ui
  local leftArrow = ui.left_button
  local rightArrow = ui.right_button
  leftArrow:setVisible(false)
  rightArrow:setVisible(false)
end
class.hideArrow = hideArrow
local function showArrow(self)
  local ui = self.ui
  local leftArrow = ui.left_button
  local rightArrow = ui.right_button
  if #getData() > 1 then
    leftArrow:setVisible(true)
    rightArrow:setVisible(true)
    if self.currentIndex == #getData() then
      rightArrow:setVisible(false)
    end
    if self.currentIndex == 1 then
      leftArrow:setVisible(false)
    end
  else
    leftArrow:setVisible(false)
    rightArrow:setVisible(false)
  end
end
class.showArrow = showArrow
local checkDefended = function(self, excavateId)
  local data = ed.ui.excavate.getData(excavateId)
  local team = data._team or {}
  for i, v in ipairs(team) do
    if v._team_id == ed.getUserid() then
      return true
    end
  end
  return false
end
class.checkDefended = checkDefended
local function createMap(self, index, addition)
  addition = addition or {}
  local isShowReward = addition.isShowReward
  local mapContainer = CCLayer:create()
  local ui = {}
  local data = getData()[index] or getData()[1]
  self.currentid = data._id
  local typeid = data._type_id
  self.typeid = typeid
  local et = ed.getDataTable("ExcavateTreasure")
  local key = et[typeid]["Produce Type"]
  local reward_type = {
    Diamond = "diamond",
    Gold = "gold",
    Item = "item"
  }
  self.rewardType = reward_type[key]
  local owner = data._owner
  for i = 1, self.defensePointAmount or 0 do
    self:btRemoveMainTouchHandler({
      key = "defense_button_" .. i
    })
  end
  local emptyRes
  local pointRes = owner == "mine" and "eff_UI_excavate_flag_blue" or "eff_UI_excavate_flag_red"
  local readnode = ed.readnode.create(mapContainer, ui)
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "ore_bg",
        res = self:getRow().Picture
      },
      layout = {position = ore_bg_pos},
      config = {}
    }
  }
  readnode:addNode(ui_info)
  local isShowArrow
  local function showPointArrow(node)
    local arrow = ed.createSprite("UI/alpha/HVGA/stagepointer.png")
    arrow:setAnchorPoint(ccp(0.5, 0))
    local pos = ed.getTopSidePos(node)
    arrow:setPosition(ccpAdd(pos, ccp(-4, -15)))
    mapContainer:addChild(arrow)
    isShowArrow = true
    local m1 = CCMoveBy:create(1, ccp(0, 10))
    local m2 = m1:reverse()
    arrow:runAction(CCRepeatForever:create(ed.readaction.create({
      t = "seq",
      m1,
      m2
    })))
  end
  local dpAmount = self:getRow()["Max Player"]
  self.defensePointAmount = dpAmount
  local dps = {}
  local pointIndex
  for i = 1, dpAmount do
    do
      local tp = self:getTeamData(data, i) or {}
      local teamid = tp._team_id
      local base = tp._hero_bases or {}
      local dynas = tp._hero_dynas or {}
      local isHeroAlive
      if teamid then
        if #dynas == 0 then
          isHeroAlive = true
        else
          for i = 1, #dynas do
            if 0 < dynas[i]._hp_perc then
              isHeroAlive = true
            end
          end
        end
      end
      local isEmpty
      if owner == "mine" and teamid or owner ~= "mine" and isHeroAlive then
        do
          local dpc = CCSprite:create()
          dpc:setContentSize(ed.DGSizeMake(136, 130))
          dpc:setPosition(ore_points[dpAmount][i])
          mapContainer:addChild(dpc, 1)
          ui["defense_point_" .. i] = dpc
          local node = ed.createFcaActor(pointRes)
          if not isShowReward and ed.ui.excavate.isLastOccupy(data._id) then
            do
              local gap_1 = 0.2
              local gap_2 = 0.5
              local count = 0
              local isShow, isChange
              dpc:setVisible(false)
              self:registerUpdateHandler("playOccupyAnim", function(dt)
                xpcall(function()
                  count = count + dt
                  if count > gap_1 and not isShow then
                    dpc:setVisible(true)
                    node:setAction("Start")
                    self:addFca(node)
                    isShow = true
                  end
                  if count > gap_1 + gap_2 and not isChange then
                    node:setAction("Loop")
                    node:setLoop(true)
                    self:removeUpdateHandler("playOccupyAnim")
                    isChange = true
                  end
                end, EDDebug)
              end)
            end
          else
            node:setAction("Loop")
            node:setLoop(true)
            self:addFca(node)
          end
          node:setPosition(ed.DGccp(68, 40))
          dpc:addChild(node, 20)
          local partnerTagRes = "UI/alpha/HVGA/heroselect_tag_hire.png"
          if owner == "mine" and teamid ~= ed.getUserid() then
            local partnerTag = ed.createSprite(partnerTagRes)
            partnerTag:setPosition(ed.DGccp(95, 35))
            dpc:addChild(partnerTag, 24)
          end
        end
      else
        emptyRes = "UI/alpha/HVGA/excavate/excavate_flag_available.png"
        if owner ~= "mine" and not teamid then
          emptyRes = "UI/alpha/HVGA/excavate/excavate_flag_empty.png"
        end
        ui_info = {
          {
            t = "Sprite",
            base = {
              name = "defense_point_" .. i,
              res = emptyRes,
              z = 1
            },
            layout = {
              position = ore_points[dpAmount][i]
            },
            config = {}
          }
        }
        readnode:addNode(ui_info)
        isEmpty = true
      end
      if isEmpty then
        local res
        if owner == "mine" then
          if self:checkDefended(self.currentid) then
            res = "UI/alpha/HVGA/excavate/excavate_flag_available_text_invite.png"
          else
            res = "UI/alpha/HVGA/excavate/excavate_flag_available_text_send.png"
            if not isShowArrow then
              showPointArrow(ui["defense_point_" .. i])
            end
          end
        end
        if owner ~= "mine" and teamid and not isHeroAlive then
          res = "UI/alpha/HVGA/excavate/excavate_flag_available_text_finished.png"
        end
        if res then
          tag = ed.createSprite(res)
          tag:setPosition(ed.DGccp(62, 90))
          ui["defense_point_" .. i]:addChild(tag)
        end
      elseif owner ~= "mine" and not pointIndex then
        pointIndex = i
      end
      if dpAmount == 1 and owner == "mine" then
        pointIndex = nil
      end
      if dpAmount == 2 and not ed.canTeach("clickExcavatePoint2") then
        pointIndex = nil
      end
      if dpAmount == 3 and not ed.canTeach("clickExcavatePoint3") then
        pointIndex = nil
      end
      if not isShowReward and owner == "mine" then
        if #(data._team or {}) == 0 then
          ed.showToast(T(LSTR("map.1.10.1.001")))
        end
      end
      self:btRegisterButtonClick({
        button = ui["defense_point_" .. i],
        pressScale = 0.95,
        key = "defense_button_" .. i,
        extraCheckHandler = function()
          return not self:checkRevengeShade()
        end,
        cancelPressHandler = function()
          ui["defense_point_" .. i]:setScale(1)
        end,
        clickHandler = function()
          if owner == "mine" and self:checkDefended(self.currentid) and not data._team[i] then
            self:doInvite()
          elseif owner == "mine" or data._team[i] then
            local window = ed.ui.excavateteam.create({
              owner = owner,
              excavateId = data._id,
              teamId = ((data._team or {})[i] or {})._team_id or ed.getUserid(),
              typeid = data._type_id
            })
            if window then
              self.mainLayer:addChild(window.mainLayer, 100)
            end
            if dpAmount == 2 then
              ed.endTeach("clickExcavatePoint2")
            elseif dpAmount == 3 then
              ed.endTeach("clickExcavatePoint3")
            end
          else
            ed.showToast(LSTR("MAP.THIS_DEFENSIVE_POINT_GUARD_UNMANNED"))
          end
        end,
        mcpMode = true,
        force = true
      })
    end
  end
  if pointIndex then
    showPointArrow(ui["defense_point_" .. pointIndex])
  end
  self:clearRevengeShade()
  if ed.ui.excavate.needRevengeCheck(data._id) then
    self:createRevengeShade(data._id)
  end
  return mapContainer, mapui
end
class.createMap = createMap
local initMap = function(self, index, addition)
  if not self:checkWork() then
    return
  end
  if not tolua.isnull(self.ui.mapContainer) then
    self.ui.mapContainer:removeFromParentAndCleanup(true)
  end
  index = index or 1
  addition = addition or {}
  local excavateid = addition.id
  if excavateid then
    data, index = ed.ui.excavate.getData(excavateid)
    index = index or ed.ui.excavate.getFightingID()
  end
  self.currentIndex = index
  local mapContainer, mapui = self:createMap(index, addition)
  local ui = self.ui
  local container = ui.frame_container
  local clipLayer = CCLayer:create()
  clipLayer:setClipRect(ed.DGRectMake(65, 40, 915, 480))
  container:addChild(clipLayer, 2)
  local animLayer = CCLayer:create()
  ui.animLayer = animLayer
  clipLayer:addChild(animLayer)
  animLayer:addChild(mapContainer)
  self.ui.mapContainer = mapContainer
  self:refresh()
  self:registerUpdateHandler("refresh_excavate_information", self:getUpdateHandler())
end
class.initMap = initMap
local getUpdateHandler = function(self)
  local ucount = 1
  local count = 0
  local function handler(dt)
    xpcall(function()
      if not self:checkWork() then
        return
      end
      local data = ed.ui.excavate.getData(self.currentid)
      if data._state == "prepare" then
        if ed.getServerTime() > (data._state_end_ts or 0) then
          data._state = "occupy"
        end
      elseif data._state == "battle" then
        if ed.getServerTime() > (data._state_end_ts or 0) then
          local info = {
            text = LSTR("MAP.COMBAT_HAS_TIMED_OUT_FAILED_TO_CAPTURE"),
            handler = function()
              ed.ui.excavate.removeExcavate(self.currentid)
              self:initMap()
            end
          }
          ed.showAlertDialog(info)
          data._state = "timeout"
        end
      end
      ucount = ucount + dt
      if ucount > 1 then
        self:refreshCountTime()
        ucount = ucount - 1
      end
      count = count + dt
      if count > 60 then
        self:refreshBaseRecord()
        count = count - 60
      end
    end, EDDebug)
  end
  return handler
end
class.getUpdateHandler = getUpdateHandler
local getUpdateMapHandler = function(self)
  local function handler(dt)
    self.turnPageQueue = self.turnPageQueue or {}
    if #self.turnPageQueue > 0 and not self.lockTurnPage then
      self.lockTurnPage = true
      local param = self.turnPageQueue[1]
      self:doTurnPage(param)
      table.remove(self.turnPageQueue, 1)
    end
  end
  return handler
end
class.getUpdateMapHandler = getUpdateMapHandler
local getDragHandler = function(self)
  local px, py
  local function handler(event, x, y)
    if event == "began" then
      px, py = x, y
    elseif event == "ended" then
      if px then
        local dx = x - px
        if math.abs(dx) > 100 then
          if dx < 0 then
            self:turnPage({mode = "next"})
          else
            self:turnPage({mode = "pre"})
          end
        end
      end
      px, py = nil, nil
    end
  end
  return handler
end
class.getDragHandler = getDragHandler
local function create(param)
  param = param or {}
  local self = base.create("excavatemap")
  setmetatable(self, class.mt)
  self.param = param
  self.currentid = param.initId
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.excavatemap)
  mainLayer:addChild(container)
  self:hideArrow()
  self:showArrow()
  self:registerTouchHandler()
  self:registerOnEnterHandler("enter_map", self:enterMap())
  self:registerUpdateHandler("update_map", self:getUpdateMapHandler())
  self:btRegisterHandler({
    handler = self:getDragHandler(),
    key = "drag_map"
  })
  if self.ui.history_button_label:getContentSize().width > 100 then
    self.ui.history_button_label:setScale(100/self.ui.history_button_label:getContentSize().width)
  end
  if ui.explain_button_label:getContentSize().width > 50 then
    ui.explain_button_label:setScale(50/ui.explain_button_label:getContentSize().width)
  end
  return self
end
class.create = create
local function checkWork(self)
  if #getData() < 1 then
    if self.param.type == "defend" then
      ed.popScene()
    elseif self.param.from == "chatLink" then
      ed.popScene()
    else
      ed.replaceScene(ed.ui.excavatesearch.create())
    end
    return false
  end
  return true
end
class.checkWork = checkWork
local showSearchText = function(self, param)
  param = param or {}
  local owner = param.searchOwner or self.param.searchOwner
  local typeid = param.searchTypeid or self.param.searchTypeid
  if owner then
    local text
    local row = ed.getDataTable("ExcavateTreasure")[typeid]
    if owner == "others" then
      text = row["Player Text"]
    elseif owner == "monster" then
      text = row["Wild Text"]
    end
    if text then
      ed.showToast(text)
    end
  end
  self.param.searchOwner = nil
  self.param.searchTypeid = nil
end
class.showSearchText = showSearchText
local showBattleReward = function(self)
  local tt = {
    gold = "Gold",
    diamond = "Diamond",
    item = "item"
  }
  local en = {
    gold = T(LSTR("MAP.GOLDMINE")),
    diamond = T(LSTR("MAP.DIAMOND_MINE")),
    item = T(LSTR("MAP.LABORATORY"))
  }
  local epn = {
    gold = T(LSTR("TASK.GOLD")),
    diamond = T(LSTR("RECHARGE.DIAMOND")),
    item = T(LSTR("EQUIP.EXPERIENCE_CREAMS"))
  }
  local reward = ed.ui.excavate.getBattleReward()
  if reward then
    local id, amount
    local rt = reward._type or self.rewardType
    if ed.isElementInTable(rt, {"gold", "diamond"}) then
      amount = reward._param1
    else
      id = reward._param1
      amount = reward._param2
    end
    local preText = T(LSTR("MAP.YOU_DEFEAT_THE_ENEMY_CAPTURED_THE__S"), en[rt] or "")
    if rt then
      if 0 < (amount or 0) then
        preText = preText .. T(LSTR("MAP.AND_PLUNDER_TO_THE_FOLLOWING_RESOURCES_"))
      end
    end
    local items = {
      {explain = preText}
    }
    if rt then
      if 0 < (amount or 0) then
        table.insert(items, {
          alignment = "leftSide",
          type = tt[rt],
          id = id,
          amount = amount
        })
      end
    end
    table.insert(items, {
      explain = T(LSTR("MAP.PLEASE_SEND_HEROES_TO_GUARD_THIS__S_YOU_WILL_CONTINUE_TO_OUTPUT__S"), en[rt] or "", epn[rt] or ""),
      bottomy = 15
    })
    ed.announce({
      type = "getProp",
      param = {
        title = T(LSTR("MAP.SUCCESSFUL_OCCUPATION")),
        items = items,
        buttonText = T(LSTR("MAP.DISPATCH_HERO")),
        callback = function()
          local data = ed.ui.excavate.getData(self.currentid)
          local window = ed.ui.excavateteam.create({
            owner = data._owner,
            excavateId = data._id,
            teamId = ed.getUserid(),
            typeid = ((data._team or {})[i] or {})._type_id,
            skipWindow = true
          })
          if window then
            self.mainLayer:addChild(window.mainLayer, 100)
          end
        end
      }
    })
    return true
  end
  return false
end
class.showBattleReward = showBattleReward
local enterMap = function(self)
  local function handler()
    if not self:checkWork() then
      return
    end
    self:showSearchText()
    local isShowReward = self:showBattleReward()
    self:initMap(ed.ui.excavate.getFightingID(), {
      id = self.currentid,
      isShowReward = isShowReward
    })
  end
  return handler
end
class.enterMap = enterMap
local page_tag_res = {
  Gold = {
    normal = "UI/alpha/HVGA/excavate/excavate_cycle_gold.png",
    selected = "UI/alpha/HVGA/excavate/excavate_cycle_gold_current.png",
    attack = "UI/alpha/HVGA/excavate/excavate_cycle_gold_engage.png"
  },
  Diamond = {
    normal = "UI/alpha/HVGA/excavate/excavate_cycle_diamond.png",
    selected = "UI/alpha/HVGA/excavate/excavate_cycle_diamond_current.png",
    attack = "UI/alpha/HVGA/excavate/excavate_cycle_diamond_engage.png"
  },
  Item = {
    normal = "UI/alpha/HVGA/excavate/excavate_cycle_potion.png",
    selected = "UI/alpha/HVGA/excavate/excavate_cycle_potion_current.png",
    attack = "UI/alpha/HVGA/excavate/excavate_cycle_potion_engage.png"
  }
}
local function refreshPageTag(self, moveMode)
  local ui = self.ui
  local max_tag_amount = 5
  local ox, oy = 0, 0
  local dx = 50
  local page_tag_pos = {}
  for i = 1, max_tag_amount do
    local poss = {}
    local ci = (i + 1) / 2
    for j = 1, i do
      poss[j] = ed.DGccp(ox + (j - ci) * dx, oy)
    end
    page_tag_pos[i] = poss
  end
  local data = getData()
  if #data < 2 then
    ui.page_tag_container:setVisible(false)
    return
  else
    ui.page_tag_container:setVisible(true)
  end
  local dpAmount = #data
  local poss = page_tag_pos[math.min(max_tag_amount, math.max(dpAmount, 1))]
  local index = self.currentIndex
  if moveMode == "pre" then
    index = index + 1
  elseif moveMode == "next" then
    index = index - 1
  end
  local bi, ei = 1, max_tag_amount
  local pageData = {}
  if max_tag_amount > #data then
    pageData = data
  else
    if index <= (max_tag_amount + 1) / 2 then
      bi = 1
      ei = max_tag_amount
    elseif #data - index <= (max_tag_amount + 1) / 2 - 1 then
      bi = #data - max_tag_amount + 1
      ei = #data
    else
      bi = index - ((max_tag_amount + 1) / 2 - 1)
      ei = index + ((max_tag_amount + 1) / 2 - 1)
    end
    for i = bi, ei do
      table.insert(pageData, data[i])
    end
  end
  if moveMode == "pre" and (index <= (max_tag_amount + 1) / 2 or index > #data - (max_tag_amount + 1) / 2 + 1) then
    return
  end
  if moveMode == "next" and (index < (max_tag_amount + 1) / 2 or index >= #data - (max_tag_amount + 1) / 2 + 1) then
    return
  end
  local container = ui.pageTagContainer
  if not tolua.isnull(container) then
    container:removeFromParentAndCleanup(true)
  end
  local lContainer = CCLayer:create()
  lContainer:setClipRect(ed.DGRectMake(-127, -30, 254, 60))
  ui.page_tag_container:addChild(lContainer, 5)
  ui.pageTagContainer = lContainer
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  lContainer:addChild(container)
  ui.tag = {}
  ui.tag_shade_left:setVisible(true)
  ui.tag_shade_right:setVisible(true)
  if bi == 1 then
    ui.tag_shade_left:setVisible(false)
  end
  if ei == #data then
    ui.tag_shade_right:setVisible(false)
  end
  local function createIcon(i, v)
    local tt = ed.ui.excavate.getTagType(v._id)
    local typeid = v._type_id
    local et = ed.getDataTable("ExcavateTreasure")
    local key = et[typeid]["Produce Type"]
    local res = page_tag_res[key].normal
    local ti = index
    if moveMode == "pre" then
      ti = index - 1
    elseif moveMode == "next" then
      ti = index + 1
    end
    if tt == "attack" then
      res = page_tag_res[key].attack
    elseif ti == i + bi - 1 then
      res = page_tag_res[key].selected
    end
    local icon = ed.createSprite(res)
    container:addChild(icon)
    icon:setCascadeOpacityEnabled(true)
    if tt == "attack" and index == i + bi - 1 then
      icon:setScale(1.1)
    else
      icon:setScale(1)
    end
    local ttres
    if tt == "search" then
      ttres = "UI/alpha/HVGA/excavate/excavate_cycle_search.png"
    elseif tt == "revenge" then
      ttres = "UI/alpha/HVGA/excavate/excavate_cycle_attention.png"
    end
    if ttres then
      local iconTag = ed.createSprite(ttres)
      iconTag:setPosition(ccpAdd(ed.getCenterPos(icon), ed.DGccp(10, 0)))
      icon:addChild(iconTag)
    end
    return icon
  end
  for i, v in ipairs(pageData) do
    local icon = createIcon(i, v)
    icon:setPosition(poss[i])
  end
  if moveMode then
    local m
    if moveMode == "pre" then
      local icon = createIcon(0, data[bi - 1])
      icon:setPosition(ccpAdd(poss[1], ed.DGccp(-dx, 0)))
      m = CCMoveBy:create(0.2, ed.DGccp(dx, 0))
    elseif moveMode == "next" then
      local icon = createIcon(0, data[ei + 1])
      icon:setPosition(ccpAdd(poss[#poss], ed.DGccp(dx, 0)))
      m = CCMoveBy:create(0.2, ed.DGccp(-dx, 0))
    end
    m = CCEaseSineOut:create(m)
    container:runAction(m)
  end
end
class.refreshPageTag = refreshPageTag
local initPageTitle = function(self)
  self:refreshPageTitle("UI/alpha/HVGA/excavate/excavate_main_title.png")
end
class.initPageTitle = initPageTitle
local refreshPageTitle = function(self, res)
  local title_res = {
    "UI/alpha/HVGA/excavate/excavate_name_diamond_1.png",
    "UI/alpha/HVGA/excavate/excavate_name_diamond_2.png",
    "UI/alpha/HVGA/excavate/excavate_name_diamond_3.png",
    "UI/alpha/HVGA/excavate/excavate_name_gold_1.png",
    "UI/alpha/HVGA/excavate/excavate_name_gold_2.png",
    "UI/alpha/HVGA/excavate/excavate_name_gold_3.png",
    "UI/alpha/HVGA/excavate/excavate_name_exp_1.png",
    "UI/alpha/HVGA/excavate/excavate_name_exp_2.png",
    "UI/alpha/HVGA/excavate/excavate_name_exp_3.png"
  }
  local title = self.ui.title
  local id = self.typeid
  ed.initSpriteWithFrame(title, res or title_res[id])
end
class.refreshPageTitle = refreshPageTitle
local refreshCostLabel = function(self)
  local ui = self.ui
  local costLabel = ui.cost_label
  local oriColor = ccc3(255, 174, 53)
  local cost = ed.player:getExcavateSearchCost()
  local gold = ed.player._money
  if cost > gold then
    ed.setLabelColor(costLabel, ccc3(255, 0, 0))
  else
    ed.setLabelColor(costLabel, oriColor)
  end
end
class.refreshCostLabel = refreshCostLabel
local doInvite = function(self)
  local gid = ed.player:getGuildId() or 0
  if gid == 0 then
    ed.showToast(T(LSTR("MAP.YOU_NEED_TO_JOIN_A_GUILDTO_INVITE_MEMBERS_TO_DEFEND")))
    return
  end
  ed.ui.excavateinvite.pop({
    excavateId = self.currentid,
    typeid = self.typeid
  })
end
class.doInvite = doInvite
local clearRevengeShade = function(self)
  local ui = self.ui
  local container = ui.revenge_shade_layer
  if not tolua.isnull(container) then
    container:removeFromParentAndCleanup(true)
  end
  ui.info_layer:setVisible(true)
end
class.clearRevengeShade = clearRevengeShade
local checkRevengeShade = function(self)
  if not tolua.isnull(self.ui.revenge_shade_layer) then
    return true
  end
end
class.checkRevengeShade = checkRevengeShade
local createRevengeShade = function(self, eid)
  local ui = self.ui
  local container = ui.revenge_shade_layer
  if not tolua.isnull(container) then
    container:removeFromParentAndCleanup(true)
  end
  local container = CCLayerColor:create(ccc4(0, 0, 0, 100))
  container:setContentSize(ed.DGSizeMake(900, 490))
  container:setPosition(ed.DGccp(60, 40))
  ui.frame_container:addChild(container, 15)
  ui.revenge_shade_layer = container
  ui.info_layer:setVisible(false)
  local label = ed.createttf(T(LSTR("MAP.HERE_HAS_BEEN_OCCUPIED_BY_THE_ENEMY")), 20)
  ed.setLabelColor(label, ccc3(243, 189, 116))
  ed.setLabelStroke(label, ccc3(116, 60, 21), 1)
  label:setPosition(ed.DGccp(452, 290))
  container:addChild(label)
  local button = ed.createScale9Sprite("UI/alpha/HVGA/sell_number_button.png", ed.DGRectMake(15, 22, 15, 25))
  button:setContentSize(ed.DGSizeMake(150, 68))
  local press = ed.createScale9Sprite("UI/alpha/HVGA/sell_number_button_down.png", ed.DGRectMake(15, 22, 15, 25))
  press:setContentSize(ed.DGSizeMake(150, 68))
  local label = ed.createttf(T(LSTR("MAP.VIEW_DETAILS")), 18)
  label:setPosition(ed.getCenterPos(button))
  ed.setLabelColor(label, ccc3(234, 224, 208))
  button:addChild(label, 5)
  button:addChild(press)
  press:setAnchorPoint(ccp(0, 0))
  press:setVisible(false)
  button:setPosition(ed.DGccp(452, 160))
  container:addChild(button)
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "revenge_check",
    clickHandler = function()
      ed.ui.excavate.revengeCheck(eid)
      self:clearRevengeShade()
    end,
    force = true
  })
end
class.createRevengeShade = createRevengeShade

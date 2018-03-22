local ed = ed
local pvp = {}
pvp.__index = pvp
ed.ui.pvp = pvp
local base = ed.ui.framework
setmetatable(pvp, base.mt)
local pvpEventScope, mainPanelLayer, rankPanelLayer, heroInfoLayer, recordPanelLayer, rewardPanelLayer, rewardInfoPanelLayer
local bDataValid = false
local bEnableResetCD = false
local buyTime = 1
local leftBuyTime = 5
local leftTime = 0
local highestRank = 1024
local sharePanel, enemyList
local lastPvpTime = 0
local rankFrameHeight = 70
local rankFrameLowHeight = 50
local defandHeros
local hasRewarded = false
local currentRank
local reqRecord = true
local reqRank = true
local pvpCD = 600
local resetCDCost = 50
local replayId = 0
local oppsName = ""
local selectChannel = ""
local rankRecource = {
  "UI/alpha/HVGA/pvp/pvp_rank_1st.png",
  "UI/alpha/HVGA/pvp/pvp_rank_2nd.png",
  "UI/alpha/HVGA/pvp/pvp_rank_3rd.png"
}
local rankFrameRecource = {
  {
    maxRank = 1,
    recource = "UI/alpha/HVGA/pvp/pvp_rank_bg_1st.png",
    height = rankFrameHeight,
    iconVisible = true,
    effect = "UI/alpha/HVGA/pvp/pvp_rank_1st_light.png"
  },
  {
    maxRank = 2,
    recource = "UI/alpha/HVGA/pvp/pvp_rank_bg_2nd.png",
    height = rankFrameHeight,
    iconVisible = true,
    effect = "UI/alpha/HVGA/pvp/pvp_rank_2nd_light.png"
  },
  {
    maxRank = 3,
    recource = "UI/alpha/HVGA/pvp/pvp_rank_bg_3rd.png",
    height = rankFrameHeight,
    iconVisible = true,
    effect = "UI/alpha/HVGA/pvp/pvp_rank_3rd_light.png"
  },
  {
    maxRank = 10,
    recource = "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
    height = rankFrameHeight,
    iconVisible = true
  },
  {
    maxRank = 50,
    recource = "UI/alpha/HVGA/pvp/pvp_rank_bg_low.png",
    height = rankFrameLowHeight,
    iconVisible = false
  }
}
local panelLayer = {}
function panelLayer:__index(key)
  object = rawget(panelLayer, key)
  if object then
    return object
  end
  local object = rawget(self.uiControllers, key)
  if object then
    return object
  end
end
function panelLayer:init(pvpScene)
  self.buttonList = {}
  self.pressButtonList = {}
  self.mainLayer = nil
  self.uiControllers = {}
  self.listLayer = nil
  self.pvpScene = pvpScene
end
function panelLayer:new(scene, pvpScene)
  local layer = {}
  setmetatable(layer, self)
  layer:init(pvpScene)
  self.rootScene = scene
  return layer
end
function panelLayer:touch(event, x, y)
  if not self:getVisible() then
    return
  end
  if event == "began" then
    for k, v in pairs(self.buttonList) do
      if ed.checkVisible(v) and ed.containsPoint(v, x, y) then
        if self.pressButtonList[k] ~= nil then
          self.pressButtonList[k]:setVisible(true)
          v:setVisible(false)
        end
        self.currentPressName = k
        return true
      end
    end
  elseif event == "ended" and self.currentPressName ~= nil and self.currentPressName ~= "" then
    self.buttonList[self.currentPressName]:setVisible(true)
    if self.pressButtonList[self.currentPressName] ~= nil then
      self.pressButtonList[self.currentPressName]:setVisible(false)
    end
    if ed.containsPoint(self.buttonList[self.currentPressName], x, y) then
      if pvp[self.currentPressName] then
        pvp[self.currentPressName]()
      end
      self.currentPressName = ""
      return true
    end
  end
  return false
end
function panelLayer:setVisible(visible)
  if self.mainLayer then
    self.mainLayer:setVisible(visible)
  end
end
function panelLayer:getVisible()
  if self.mainLayer then
    return self.mainLayer:isVisible()
  end
  return false
end
function pvp.closeRankInfo()
  rankPanelLayer:setVisible(false)
  mainPanelLayer:setVisible(true)
end
function pvp.closeHeroInfo()
  heroInfoLayer:setVisible(false)
end
function pvp.closeRecordInfo()
  recordPanelLayer:setVisible(false)
  mainPanelLayer:setVisible(true)
end
function pvp.adjustHero()
  ed.playEffect(ed.sound.pvp.clickChangeTeam)
  ed.pushScene(ed.ui.battleprepare.create({
    pvpMode = "defend",
    heros = defandHeros,
    stage_id = -1
  }))
end
function pvp.closeRewardLayer()
  rewardPanelLayer:setVisible(false)
end
local function heroInfoLayerTouch(event, x, y)
  if heroInfoLayer and heroInfoLayer:getVisible() then
    local bDone = heroInfoLayer:touch(event, x, y)
    if bDone == false and not ed.containsPoint(heroInfoLayer.heroInfo, x, y) then
      heroInfoLayer:setVisible(false)
    end
    return true
  end
  return false
end
function pvp.closeRewardInfo()
  if rewardInfoPanelLayer then
    rewardInfoPanelLayer:setVisible(false)
  end
end
local function rewardInfoLayerTouch(event, x, y)
  if rewardInfoPanelLayer and rewardInfoPanelLayer:getVisible() then
    rewardInfoPanelLayer:touch(event, x, y)
    return true
  end
  return false
end
local getRewardResult = function(data)
  if nil == data then
    return
  end
  local result = ""
  if "Diamond" == data["Reward Type 1"] then
    result = string.format("<sprite|UI/alpha/HVGA/rmbicon.png|0.5><text|pressButton| %d >", data["Reward Amount 1"])
  end
  if "Gold" == data["Reward Type 2"] then
    result = result .. string.format("<sprite|UI/alpha/HVGA/goldicon.png|0.5><text|pressButton| %d >", data["Reward Amount 2"])
  end
  if "ArenaPoint" == data["Reward Type 3"] then
    result = result .. string.format("<sprite|UI/alpha/HVGA/money_arenatoken_small.png><text|pressButton| ×%d >", data["Reward Amount 3"])
  end
  if "Item" == data["Reward Type 4"] then
    result = result .. string.format("<item|%d|0.5><text|pressButton| ×%d >", data["Reward ID 4"], data["Reward Amount 4"])
  end
  if "Item" == data["Reward Type 5"] then
    result = result .. string.format("<item|%d|0.5><text|pressButton| ×%d>", data["Reward ID 5"], data["Reward Amount 5"])
  end
  return result
end
local function initRewardList()
  if rewardInfoPanelLayer == nil then
    return
  end
  local list = rewardInfoPanelLayer.uiControllers.listview
  if list == nil then
    return
  end
  list:clear()
  list:changeItemConfig(1)
  local pvpRewardTable = ed.getDataTable("PVPRankReward")
  local selfRewardIndex
  local numString = ""
  for i, v in ipairs(pvpRewardTable) do
    if currentRank <= v["Floor Rank"] and selfRewardIndex == nil then
      local result = ""
      if pvpRewardTable[i - 1] and pvpRewardTable[i - 1]["Floor Rank"] < v["Floor Rank"] - 1 then
        result = T(LSTR("PVP.THE_FIRST_D_TO_THE_D"), pvpRewardTable[i - 1]["Floor Rank"] + 1, v["Floor Rank"])
      else
        result = T(LSTR("PVP.THE_D"), v["Floor Rank"])
      end
      selfRewardIndex = i
      numString = result
      break
    end
  end
  if selfRewardIndex then
    local reward = pvpRewardTable[selfRewardIndex]
    if reward then
      list:addItem({
        T(LSTR("PVP.TEXT_NORMALBUTTON_MAINTAIN_AT_THIS_RANK__S_YOU_CAN_CLAIM___"), numString)
      })
      list:addItem({
        "<text|normalButton| >"
      })
      list:addItem({
        getRewardResult(reward)
      })
    end
  end
  list:changeItemConfig(2)
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    "<text|normalButton|>"
  })
  list:addItem({
    T(LSTR("PVP.TEXT_DARK_WHITE_ARENA_COMBAT_RULES_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_1_IN_AUTOMATIC_ARENA_COMBAT_PLAYERS_CAN_NOT_CAST_SPELLS_MANUALLY"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_2_IN_ARENA_COMBAT_ALL_HEROS_HEALTH_AND_CURE_EFFECTS_WILL_BE_INCREASED_AT_THE_SAME_WIDTH_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_3_IF_YOU_WON_AND_THE_DEFENSE_IS_RANKED_HIGHER_THAN_THE_OFFENSIVE_SIDE_THE_RANKINGS_WILL_SWAP_SIDES"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_4_IF_THE_BATTLE_TIMED_OUT_THEN_THE_OFFENSIVE_SIDE_WILL_BE_TREATED_AS_LOSE_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_5_EACH_PLAYER_HAS_5_FREE_COMBAT_TIMES_PER_DAY_FREE_TIME_WILL_BE_RESET_AT_5AM_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_6_AFTER_EACH_BATTLE_THE_OFFENSIVE_SIDE_WILL_RECEIVE_A_10MINUTE_COOL_DOWN"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_7_ENEMY_WHO_IS_IN_A_FIGHTING_CAN_NOT_BE_SELECTED_AS_THE_OPPONENT"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_8_THE_WHOLE_SETTLEMENT_RANK_AND_RANK_AWARDS_ISSUED_THROUGH_THE_MAIL_AT_9PM_EVERY_DAY"))
  })
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    T(LSTR("PVP.TEXT_DARK_WHITE_HISTORY_HIGHEST_RANKING_AWARD_RULES_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_WHEN_A_PLAYER_SUCCESSFULLY_ROSE_TO_HISHER_HIGHEST_RANK_WILL_BE_AWARDED_A_ONETIME_DIAMOND_REWARDS"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_HIGHEST_RANKING_AWARD_VARIES_ON_THE_RATE_OF_PROGRESS_AT_LEAST_ONE_DIAMOND"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_HIGHEST_RANKING_AWARD_ISSUED_BY_MAIL"))
  })
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    T(LSTR("PVP.TEXT_DARK_WHITE_DAILY_RANK_REWARD_RULES_"))
  })
  list:addItem({
    T(LSTR("PVP.TEXT_NORMALBUTTON_AN_AWARDMAIL_WILL_BE_SENT_OUT_ACCORDING_TO_THE_RANKING_OF_THE_SETTLEMENT_DETAILED_REWARD_RULES_FOLLOWS_"))
  })
  list:addItem({
    "<text|normalButton| >"
  })
  list:changeItemConfig(1)
  for i = 1, 6 do
    local result = ""
    local v = pvpRewardTable[i]
    if pvpRewardTable[i - 1] and pvpRewardTable[i - 1]["Floor Rank"] < v["Floor Rank"] - 1 then
      result = T(LSTR("PVP.THE_FIRST_D_TO_THE_D"), pvpRewardTable[i - 1]["Floor Rank"] + 1, v["Floor Rank"])
    else
      result = T(LSTR("PVP.THE_D"), v["Floor Rank"])
    end
    result = string.format("<text|normalButton|%s: >%s", result, getRewardResult(pvpRewardTable[i]))
    list:addItem({result})
    list:addItem({
      "<text|normalButton|>"
    })
  end
  list:addItem({
    "<text|normalButton| .....>"
  })
  list:addItem({
    "<text|normalButton|>"
  })
end
local function createRewardList()
  if rewardInfoPanelLayer == nil then
    return
  end
  local listInfo = {
    t = "ListView",
    base = {
      name = "listview",
      cliprect = CCRectMake(140, 90, 500, 250),
      priority = -200
    },
    itemConfig1 = {
      {
        t = "RichText",
        base = {name = "name", text = ""},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(20, 0)
        },
        listData = true
      }
    },
    itemConfig2 = {
      {
        t = "RichText",
        base = {name = "name", text = ""},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(20, 0)
        },
        listData = true
      }
    }

  }
  local list = listView:new(listInfo, rewardInfoPanelLayer.mainLayer)
  rewardInfoPanelLayer.uiControllers.listview = list
end
local function createRewardInfoLayer(scene)
  if nil == mainPanelLayer or nil ~= rewardInfoPanelLayer then
    return
  end
  rewardInfoPanelLayer = panelLayer:new(scene)
  rewardInfoPanelLayer.mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 190))
  rewardInfoPanelLayer.mainLayer:registerScriptTouchHandler(rewardInfoLayerTouch, false, -200, true)
  rewardInfoPanelLayer.mainLayer:setTouchEnabled(true)
  scene:addChild(rewardInfoPanelLayer.mainLayer, 20)
  local rewardUIRes = {
    {
      t = "Scale9Sprite",
      base = {
        name = "rewardBg",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 240)
      },
      config = {
        scaleSize = CCSizeMake(550, 360)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.ARENA_RULE_DESCRIPTION")),
        size = 22,
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(270, 320)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "heroInfo",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(275, 320)
      },
      config = {
        scalexy = {x = 1.3, y = 1.1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closeRewardInfo",
        array = rewardInfoPanelLayer.buttonList,
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(670, 390)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closeRewardInfo",
        array = rewardInfoPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(670, 390)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(rewardInfoPanelLayer.mainLayer, rewardInfoPanelLayer.uiControllers)
  readNode:addNode(rewardUIRes)
  createRewardList()
  rewardInfoPanelLayer.mainLayer:setZOrder(100)
end
local function rewardLayerTouch(event, x, y)
  if not rewardPanelLayer then
    return false
  end
  if not rewardPanelLayer:getVisible() then
    return false
  end
  rewardPanelLayer:touch(event, x, y)
  return true
end
local function createRewardLayer(scene)
  if nil == mainPanelLayer or nil ~= rewardPanelLayer then
    return
  end
  rewardPanelLayer = panelLayer:new(scene)
  rewardPanelLayer.mainLayer = CCLayer:create()
  rewardPanelLayer.mainLayer:registerScriptTouchHandler(rewardLayerTouch, false, -1, true)
  rewardPanelLayer.mainLayer:setTouchEnabled(true)
  scene:addChild(rewardPanelLayer.mainLayer, 20)
  local rewardUIRes = {
    {
      t = "Scale9Sprite",
      base = {
        name = "rewardBg",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 240)
      },
      config = {
        scaleSize = CCSizeMake(390, 300)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.AWARD_BY_BILLBOARD")),
        size = 25,
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 270)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "heroInfo",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 270)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "heroInfo", parent = "rewardBg"},
      layout = {
        anchor = ccp(0.5, 0.5)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.SETTLEMENT_RANK_")),
        size = 22,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 210)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = "",
        size = 20,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(250, 220)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_icon",
        res = "UI/alpha/HVGA/goldicon.png",
        parent = "heroInfo"
      },
      layout = {
        position = ccp(200, 135)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "rmb_icon",
        res = "UI/alpha/HVGA/rmbicon.png",
        parent = "heroInfo"
      },
      layout = {
        position = ccp(200, 135)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "reward",
        text = "2323",
        size = 20,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(255, 130)
      },
      config = {
        color = ccc3(233, 150, 44),
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(200, 90)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "closeRewardLayer",
        parent = "rewardBg",
        array = rewardPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 10, 100, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 50)
      },
      config = {
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "closeRewardLayer",
        parent = "rewardBg",
        array = rewardPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 10, 100, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 50)
      },
      config = {
        scaleSize = CCSizeMake(120, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("CHATCONFIG.CONFIRM")),
        size = 20,
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(195, 50)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "rewardBg",
        res = "UI/alpha/HVGA/pvp/pvp_replay_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, 130)
      },
      config = {
        scalexy = ccp(2, 4)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.REWARDED_")),
        size = 22,
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 160)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "RichText",
      base = {
        name = "reward1",
        text = "<text|pressButton|sdsdad>",
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(180, 160)
      }
    },
    {
      t = "RichText",
      base = {
        name = "reward2",
        text = "<text|pressButton|sdsdad>",
        parent = "rewardBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(100, 110)
      }
    }
  }
  local readNode = ed.readnode.create(rewardPanelLayer.mainLayer, rewardPanelLayer.uiControllers)
  readNode:addNode(rewardUIRes)
  local listInfo = {
    t = "ListView",
    base = {
      name = "rewardList",
      cliprect = CCRectMake(250, 150, 300, 150),
      priority = -200,
      colNum = 2,
      widthInner = 80
    },
    itemConfig = {
      {
        t = "RichText",
        base = {name = "name", text = ""},
        layout = {
          anchor = ccp(0, 0),
          position = ccp(20, 0)
        },
        listData = true
      }
    }
  }
  local list = listView:new(listInfo, rewardPanelLayer)
  rewardPanelLayer.uiControllers.rewardList = list
end
local function createHeroInfoLayer(scene)
  if heroInfoLayer ~= nil or mainPanelLayer == nil then
    return
  end
  heroInfoLayer = panelLayer:new(scene)
  heroInfoLayer.mainLayer = CCLayer:create()
  heroInfoLayer.mainLayer:registerScriptTouchHandler(heroInfoLayerTouch, false, -201, true)
  heroInfoLayer.mainLayer:setTouchEnabled(true)
  heroInfoLayer.mainLayer:setZOrder(101)
  scene:addChild(heroInfoLayer.mainLayer)
  local heroUIRes = {
    {
      t = "Scale9Sprite",
      base = {
        name = "heroInfo",
        res = "UI/alpha/HVGA/toast_bg.png",
        capInsets = CCRectMake(17, 10, 200, 46)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 250)
      },
      config = {
        scaleSize = CCSizeMake(268, 240)
      }
    },
    {
      t = "Sprite",
      base = {name = "headIcon", parent = "heroInfo"},
      layout = {
        position = ccp(40, 215)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/tip_detail_bg.png",
        parent = "heroInfo"
      },
      layout = {
        position = ccp(125, 215)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(86, 215)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = "99",
        size = 16,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(86, 215)
      },
      config = {
        color = ccc3(226, 206, 174)
      }
    },
    {
      t = "Label",
      base = {
        name = "heroName",
        text = "",
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(110, 215)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.WINS_")),
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(24, 142)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "winNum",
        text = "2323",
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, 142)
      },
      config = {
        color = ccc3(244, 224, 189)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.RANK_")),
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(24, 174)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "rankNum",
        text = "",
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, 183)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.TOTAL_POWER_")),
        size = 18,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(24, 110)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "gps",
        text = "5656",
        size = 18,
        parent = "heroInfo",
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, 110)
      },
      config = {
        color = ccc3(244, 224, 189)
      }
    },
    {
      t = "Sprite",
      base = {name = "hero1", parent = "heroInfo"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(34, 65)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero2", parent = "heroInfo"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(84, 65)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero3", parent = "heroInfo"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(134, 65)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero4", parent = "heroInfo"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(184, 65)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero5", parent = "heroInfo"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(234, 65)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        parent = "heroInfo",
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(135, 33)
      },
      config = {
        scalexy = {x = 0.6, y = 1}
      }
    },
    {
      t = "Label",
      base = {
        name = "guildHint",
        text = "",
        size = 16,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(24, 21)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "guildName",
        text = "12323",
        size = 16,
        parent = "heroInfo"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(105, 21)
      },
      config = {
        color = ccc3(244, 224, 189),
        visible = false
      }
    }
  }
  local readNode = ed.readnode.create(heroInfoLayer.mainLayer, heroInfoLayer.uiControllers)
  readNode:addNode(heroUIRes)
end
local function showHeroInfo(data)
  if data == nil then
    return
  end
  if heroInfoLayer == nil then
    createHeroInfoLayer(mainPanelLayer.rootScene)
  end
  local winCount = data._win_cnt
  if 1 == data._is_robot then
    winCount = data._summary._level + math.floor((string.byte(data._summary._name) + string.byte(data._summary._name, -1)) / 2)
  end
  ed.setString(heroInfoLayer.heroName, data._summary._name)
  if heroInfoLayer.uiControllers.heroName:getContentSize().width > 150 then
	  heroInfoLayer.uiControllers.heroName:setScale(150/heroInfoLayer.uiControllers.heroName:getContentSize().width)
  end
  local width = ed.createNumbers(heroInfoLayer.rankNum, tostring(data._rank), -2, nil, "small_pvp")
  heroInfoLayer.rankNum:setContentSize(CCSizeMake(width, 20))
  heroInfoLayer.rankNum:setCascadeOpacityEnabled(true)
  ed.setString(heroInfoLayer.winNum, winCount)
  ed.setString(heroInfoLayer.gps, data._gs)
  ed.setString(heroInfoLayer.level, data._summary._level)
  local hero = data._heros
  local param = {
    id = data._summary._avatar,
    vip = data._summary._vip > 0
  }
  local head = ed.getHeroIconByID(param)
  if head then
    heroInfoLayer.headIcon:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    heroInfoLayer.headIcon:addChild(head)
  end
  for i = 1, 5 do
    local hero = string.format("hero%d", i)
    heroInfoLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  if data._heros then
    for i, v in ipairs(data._heros) do
      local hero = string.format("hero%d", i)
      local heroIcon = ed.readhero.createIcon({
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars
      })
      heroIcon.icon:setScale(0.6)
      heroInfoLayer[hero]:addChild(heroIcon.icon)
    end
  end
  if data._summary._guild_name and data._summary._guild_name ~= "" then
    heroInfoLayer.guildName:setVisible(true)
    ed.setString(heroInfoLayer.guildHint, LSTR("CRUSADE.FROM_THE_GUILD"))
    ed.setString(heroInfoLayer.guildName, data._summary._guild_name)
  else
    heroInfoLayer.guildName:setVisible(false)
    ed.setString(heroInfoLayer.guildHint, LSTR("CRUSADE.NOT_IN_GUILDS"))
  end
  heroInfoLayer:setVisible(true)
end
function pvp.enemy1Icon()
  ed.playEffect(ed.sound.pvp.clickEnemyHead)
  if enemyList ~= nil then
    showHeroInfo(enemyList[1])
  end
end
function pvp.enemy2Icon()
  if enemyList ~= nil then
    showHeroInfo(enemyList[2])
  end
end
function pvp.enemy3Icon()
  if enemyList ~= nil then
    showHeroInfo(enemyList[3])
  end
end
local challengeEnemyRsp = function(result)
end
local function challengeEnemy(index)
  if nil == enemyList then
    return
  end
  if nil == enemyList[index] then
    return
  end
  if mainPanelLayer.cdText:isVisible() == true then
    ed.toast.showToast(T(LSTR("PVP.YOU_CANT_JOIN_PVP_COMBAT_RIGHT_NOW")))
    return
  end
  if leftTime == 0 then
    ed.toast.showToast(T(LSTR("PVP.YOU_CANT_JOIN_PVP_COMBAT_RIGHT_NOW")))
    return
  end
  ed.pushScene(ed.ui.battleprepare.create({
    pvpMode = "attack",
    enemyId = enemyList[index]._user_id,
    stage_id = -1
  }))
end
function pvp.challengeEnemy1()
  challengeEnemy(1)
end
function pvp.challengeEnemy2()
  challengeEnemy(2)
end
function pvp.challengeEnemy3()
  challengeEnemy(3)
end
local function rankLayerTouch(event, x, y)
  if rankPanelLayer then
    rankPanelLayer:touch(event, x, y)
  end
  if rankPanelLayer:getVisible() then
    return true
  else
    return false
  end
end
local function recordLayerTouch(event, x, y)
  if recordPanelLayer then
    recordPanelLayer:touch(event, x, y)
  end
  if recordPanelLayer:getVisible() then
    return true
  else
    return false
  end
end
local function createRankInfo(summary, num, uerId)
  if summary == nil or num == nil then
    return
  end
  local rankInfo = {}
  rankInfo.name = summary._name
  rankInfo.level = summary._level
  rankInfo.num = num
  rankInfo.userId = uerId
  local board = {}
  local bg = CCSprite:create()
  board.bg = bg
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {name = "rankBg"},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(150, 71)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = "",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(-50, 82)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Sprite",
      base = {name = "iconParent"},
      layout = {
        position = ccp(40, 71)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "levelBg"},
      layout = {
        position = ccp(105, 71)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(bg, board)
  readNode:addNode(ui_info)
  for k, v in ipairs(rankFrameRecource) do
    if num <= v.maxRank then
      board.rankBg:initWithFile(v.recource)
      board.rankBg:setContentSize(CCSizeMake(475, v.height))
      if v.effect then
        local effect = ed.createSprite(v.effect)
        board.rank:addChild(effect)
        effect:setPosition(0, -10)
      end
      break
    end
  end
  local iconScale = num > 10 and 0.6 or 0.8
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    level = rankInfo.level,
    scale = iconScale,
    name = summary._name,
    vip = 0 < summary._vip
  })
  board.iconParent:addChild(head)
  local spriteName = rankRecource[num]
  if spriteName then
    local rankSprite = ed.createSprite(spriteName)
    board.rank:addChild(rankSprite)
    rankSprite:setPosition(0, -7)
  else
    local numName = num > 10 and "small_pvp" or "big_pvp"
    local width = ed.createNumbers(board.rank, tostring(num), -2, nil, numName)
    board.rank:setContentSize(CCSizeMake(width, 20))
    board.rank:setCascadeOpacityEnabled(true)
  end
  board.info = rankInfo
  rankPanelLayer.listLayer.listLayer:addChild(bg)
  table.insert(rankPanelLayer.listLayer.listData, board)
end
local function createRecordInfo(data)
  if nil == data then
    return
  end
  local recordInfo = data
  local board = {}
  local bg = CCSprite:create()
  board.bg = bg
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "highlightbg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = CCRectMake(45, 20, 400, 35)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(150, 71)
      },
      config = {
        scaleSize = CCSizeMake(485, 70)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "namebg",
        res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(115, 83)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = recordInfo._summary._name,
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, 82)
      },
      config = {
        color = ccc3(255, 255, 255),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "time",
        text = T(LSTR("PVP.1_DAY_AGO")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 55)
      },
      config = {
        color = ccc3(93, 84, 78)
      }
    },
    {
      t = "Sprite",
      base = {name = "iconParent"},
      layout = {
        position = ccp(50, 71)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
      },
      layout = {
        position = ccp(105, 82)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = tostring(data._summary._level),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(105, 82)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "resultEffect"
      },
      layout = {
        position = ccp(-70, 86)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "resultDir"},
      layout = {
        position = ccp(-30, 83)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "record",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(-30, 55)
      },
      config = {
        color = ccc3(150, 6, 6)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "review",
        res = "UI/alpha/HVGA/pvp/pvp_button_replay_1.png"
      },
      layout = {
        position = ccp(350, 71)
      },
      config = {
        visible = data._replay_id ~= 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "share",
        res = "UI/alpha/HVGA/pvp/pvp_replay_share.png"
      },
      layout = {
        position = ccp(290, 71)
      },
      config = {
        visible = data._replay_id ~= 0
      }
    }
  }
  local readNode = ed.readnode.create(bg, board)
  readNode:addNode(ui_info)

  if board.name:getContentSize().width > 140 then
    board.name:setScale(140 / board.name:getContentSize().width)
  end

  if data._deta_rank ~= 0 then
    ed.setString(board.record, tostring(data._deta_rank))
  end
  local effectName = data._bt_result == "victory" and "UI/alpha/HVGA/pvp/pvp_win.png" or "UI/alpha/HVGA/pvp/pvp_lose.png"
  local dirName = data._bt_result == "victory" and "UI/alpha/HVGA/pvp/pvp_up.png" or "UI/alpha/HVGA/pvp/pvp_down.png"
  local frame = ed.getSpriteFrame(effectName)
  if frame then
    board.resultEffect:initWithSpriteFrame(frame)
  end
  frame = ed.getSpriteFrame(dirName)
  if frame then
    board.resultDir:initWithSpriteFrame(frame)
  end
  if math.abs(data._deta_rank) == 0 then
    board.resultDir:setVisible(false)
    board.record:setVisible(false)
  end
  local head = ed.getHeroIconByID({
    id = data._summary._avatar,
    vip = 0 < data._summary._vip
  })
  if head then
    head:setScale(0.9)
    board.iconParent:addChild(head)
  end
  local nowTime = ed.getServerTime()
  local passTime = nowTime - data._bt_time
  local h, m, s = ed.second2hms(passTime)
  if h >= 24 then
    ed.setString(board.time, T(LSTR("PVP.1_DAY_AGO")))
  elseif h >= 1 then
    ed.setString(board.time, T(LSTR("PVP._D_HOURS_AGO"), h))
  elseif m >= 1 then
    ed.setString(board.time, T(LSTR("PVP._D_MINUTES_AGO"), m))
  else
    ed.setString(board.time, T(LSTR("PVP._D_SECONDS_AGO"), s))
  end
  board.info = recordInfo
  recordPanelLayer.listLayer.listLayer:addChild(bg)
  table.insert(recordPanelLayer.listLayer.listData, board)
end
local function doPressRankList(x, y)
  local listData = rankPanelLayer.listLayer.listData
  for i = 1, #listData do
    if ed.containsPoint(listData[i].rankBg, x, y) and rankPanelLayer:getVisible() then
      return i
    end
  end
end
local function doClickRankList(x, y, id)
  local listData = rankPanelLayer.listLayer.listData
  local msg = ed.upmsg.ladder()
  msg._query_oppo = {}
  msg._query_oppo._oppo_user_id = listData[id].info.userId
  ed.send(msg, "ladder")
end
local function cancelPressRankList(x, y, id)
  local listData = rankPanelLayer.listLayer.listData
end
local function cancelClickRankList(x, y, id)
  local listData = rankPanelLayer.listLayer.listData
end
local function createRankList(rankData)
  if nil == rankPanelLayer then
    return
  end
  local info = {
    cliprect = CCRectMake(165, 40, 470, 360),
    container = rankPanelLayer.mainLayer,
    priority = -200,
    doPressIn = doPressRankList,
    doClickIn = doClickRankList,
    cancelPressIn = cancelPressRankList,
    cancelClickIn = cancelClickRankList
  }
  local listLayer = ed.draglist.create(info)
  rankPanelLayer.listLayer = listLayer
end
local function doPressRecordList(x, y)
  local listData = recordPanelLayer.listLayer.listData
  if nil == listData then
    return
  end
  for i = 1, #listData do
    local inSide = ed.containsPoint(listData[i].review, x, y) or ed.containsPoint(listData[i].share, x, y)
    if listData[i].review:isVisible() and inSide and recordPanelLayer:getVisible() then
      return i
    end
  end
end
function pvp.shareToWorld()
  if ed.player:getLevel() < 24 then
    ed.showToast(T(LSTR("CHAT.REACH_LEVEL_24_TO_USE_THE_WORLD_CHANNEL")))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  sharePanel.shareLayer.input:setVisible(true)
  selectChannel = "world_channel"
end
function pvp.shareToUnin()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T(LSTR("CHAT.NEED_TO_JOIN_A_GUILD_FIRST_TO_USE_THE_GUILD_CHANNEL")))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  sharePanel.shareLayer.input:setVisible(true)
  selectChannel = "guild_channel"
end
function pvp.cancelShare()
  sharePanel.shareLayer:setVisible(false)
  sharePanel.shareLayer.input:setVisible(false)
end
function pvp.sendShare()
  sharePanel.shareLayer:setVisible(false)
  sharePanel.shareLayer.input:setVisible(false)
  local result = string.format("<link|pvp|%s>", sharePanel.shareLayer.replayName:getString())
  local content = sharePanel.shareLayer.input:getString()
  if content ~= "" then
    result = string.format("%s<><text|chat_content|%s|400>", result, content)
  end
  ed.ui.chat.sendPvpLink(result, replayId, selectChannel)
end
function pvp.closeShare()
  sharePanel.shareLayer:setVisible(false)
  sharePanel.shareLayer.input:setVisible(false)
end
local function shareReplay()
  if sharePanel == nil then
    sharePanel = panelMeta:new(mainPanelLayer.pvpScene, EDTables.chatConfig.ShareUIRes)
  end
  sharePanel.shareLayer:setVisible(true)
  sharePanel.shareLayer.shareBg:setVisible(true)
  sharePanel.shareLayer.share:setVisible(false)
  sharePanel.shareLayer.input:setVisible(false)
  sharePanel.shareLayer.input.edit:setAnchorPoint(ccp(0, 0))
  local replayName = string.format("[%s VS %s]", ed.player:getName(), oppsName)
  ed.setString(sharePanel.shareLayer.replayName, replayName)
  if sharePanel.shareLayer.replayName:getContentSize().width > 350 then
    sharePanel.shareLayer.replayName:setScale(350 / sharePanel.shareLayer.replayName:getContentSize().width)
  end
end
local function doClickRecordList(x, y, id)
  local listData = recordPanelLayer.listLayer.listData
  if listData[id] == nil then
    return
  end
  if ed.containsPoint(listData[id].review, x, y) then
    local msg = ed.upmsg.ladder()
    msg._query_replay = {}
    msg._query_replay._record_index = listData[id].info._replay_id
    ed.send(msg, "ladder")
  elseif ed.containsPoint(listData[id].share, x, y) then
    replayId = listData[id].info._replay_id
    oppsName = listData[id].name:getString()
    shareReplay()
  end
end
local function createRecordList()
  if nil == recordPanelLayer then
    return
  end
  local info = {
    cliprect = CCRectMake(160, 40, 490, 360),
    container = recordPanelLayer.mainLayer,
    priority = -200,
    doPressIn = doPressRecordList,
    doClickIn = doClickRecordList
  }
  local listLayer = ed.draglist.create(info)
  recordPanelLayer.listLayer = listLayer
end
local function createRankLayer(scene, rankData)
  if rankPanelLayer ~= nil or mainPanelLayer == nil then
    return
  end
  rankPanelLayer = panelLayer:new(scene)
  rankPanelLayer.mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 190))
  rankPanelLayer.mainLayer:registerScriptTouchHandler(rankLayerTouch, false, -200, true)
  rankPanelLayer.mainLayer:setTouchEnabled(true)
  scene:addChild(rankPanelLayer.mainLayer)
  local RankUIRes = {

    {
      t = "Scale9Sprite",
      base = {
        name = "rankFrame",
        res = "UI/alpha/HVGA/pvp/pvp_rank_frame.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 230)
      },
      config = {
        scaleSize = CCSizeMake(530, 415)
      }
    },
    --{
    -- t = "Sprite",
    --  base = {
    --    name = "nameBg",
    --    res = "UI/alpha/HVGA/task_window_title_bg.png"
    -- },
    --  layout = {
    --    position = ccp(400, 440)
    --  },
    -- config = {}
    --},
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/crusade_title_short_bg.png",
        z = 30
      },
      layout = {
        position = ccp(400, 429)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = T(LSTR("PVP.ARMORY")),
        fontinfo = "ui_normal_button",
        size = 24,
        z = 30
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 430)
      },
      config = {
        color = ccc3(243, 196, 16)
      }
    }
  }
  local readNode = ed.readnode.create(rankPanelLayer.mainLayer, rankPanelLayer.uiControllers)
  readNode:addNode(RankUIRes)
  createRankList(rankData)
  RankUIRes = {
    {
      t = "Sprite",
      base = {
        name = "closeRankInfo",
        array = rankPanelLayer.buttonList,
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(650, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closeRankInfo",
        array = rankPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(650, 420)
      },
      config = {visible = false}
    }
  }
  readNode = ed.readnode.create(rankPanelLayer.mainLayer, rankPanelLayer.uiControllers)
  readNode:addNode(RankUIRes)
  rankPanelLayer.mainLayer:setZOrder(100)
end
local function createRecordLayer(scene, data)
  if recordPanelLayer ~= nil or mainPanelLayer == nil then
    return
  end
  recordPanelLayer = panelLayer:new(scene)
  recordPanelLayer.mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 190))
  recordPanelLayer.mainLayer:registerScriptTouchHandler(recordLayerTouch, false, -200, true)
  recordPanelLayer.mainLayer:setTouchEnabled(true)
  scene:addChild(recordPanelLayer.mainLayer)
  local RecordUIRes = {
    {
      t = "Sprite",
      base = {
        name = "nameBg",
        res = "UI/alpha/HVGA/task_window_title_bg.png"
      },
      layout = {
        position = ccp(400, 440)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = T(LSTR("PVP.COMBAT_RECORD")),
        fontinfo = "ui_normal_button",
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 440)
      },
      config = {
        color = ccc3(243, 196, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "rankFrame",
        res = "UI/alpha/HVGA/pvp/pvp_rank_frame.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 214)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(recordPanelLayer.mainLayer, recordPanelLayer.uiControllers)
  readNode:addNode(RecordUIRes)
  createRecordList(data)
  RecordUIRes = {
    {
      t = "Sprite",
      base = {
        name = "closeRecordInfo",
        array = recordPanelLayer.buttonList,
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(670, 390)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closeRecordInfo",
        array = recordPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(670, 390)
      },
      config = {visible = false}
    }
  }
  readNode = ed.readnode.create(recordPanelLayer.mainLayer, recordPanelLayer.uiControllers)
  readNode:addNode(RecordUIRes)
  recordPanelLayer.mainLayer:setZOrder(100)
end
function pvp.reqRecordBoard()
  local msg = ed.upmsg.ladder()
  msg._query_records = {}
  ed.send(msg, "ladder")
end
local function initRecordData(recordData)
  if nil == recordData then
    return
  end
  recordPanelLayer.listLayer:clearList()
  recordPanelLayer.listLayer.listData = {}
  for i, v in ipairs(recordData) do
    createRecordInfo(v)
  end
  for i = 1, #recordPanelLayer.listLayer.listData do
    recordPanelLayer.listLayer.listData[i].bg:setPosition(ccp(250, 290 - (rankFrameHeight + 8) * (i - 1)))
  end
  recordPanelLayer.listLayer:initListHeight((rankFrameHeight + 8) * #recordPanelLayer.listLayer.listData + 20)
end
local function showRecordBoard(recordData)
  if mainPanelLayer == nil then
    return
  end
  if recordPanelLayer == nil then
    createRecordLayer(mainPanelLayer.rootScene, recordData)
  end
  recordPanelLayer:setVisible(true)
  if reqRecord then
    initRecordData(recordData)
    reqRecord = false
    ed.changeNotifyData("PvpNotifyData", "_is_attacked", 0)
  end
end
function pvp.reqRankData()
  --local msg = ed.upmsg.ladder()
  --msg._query_rankboard = {}
  --ed.send(msg, "ladder")
  
  local scene = ed.ui.ranklist.create({index = 2})
  ed.pushScene(scene)
end
function pvp.showRewardInfo()
  if rewardInfoPanelLayer == nil then
    createRewardInfoLayer(mainPanelLayer.rootScene)
  end
  rewardInfoPanelLayer:setVisible(true)
  initRewardList()
end
local function initRankListData(rankData)
  rankPanelLayer.listLayer:clearList()
  rankPanelLayer.listLayer.listData = {}
  if rankData ~= nil then
    for i, v in ipairs(rankData) do
      createRankInfo(v._summary, i, v._user_id)
    end
  end
  local totoalLayer = #rankPanelLayer.listLayer.listData
  for i = 1, totoalLayer do
    local highLayers = math.min(10, i)
    local lowLayers = math.max(0, i - 10)
    local adjust = i > 10 and 8 or 0
    rankPanelLayer.listLayer.listData[i].bg:setPosition(ccp(250, 290 - adjust - (rankFrameHeight + 8) * (highLayers - 1) - (rankFrameLowHeight + 8) * lowLayers))
  end
  local totalHeight = (rankFrameHeight + 8) * math.min(10, #rankPanelLayer.listLayer.listData) + (rankFrameLowHeight + 8) * math.max(0, #rankPanelLayer.listLayer.listData - 10)
  rankPanelLayer.listLayer:initListHeight(totalHeight)
end
local function showRankBoard(rankData)
  if mainPanelLayer == nil then
    return
  end
  if rankPanelLayer == nil then
    createRankLayer(mainPanelLayer.rootScene, rankData)
  end
  rankPanelLayer:setVisible(true)
  if reqRank then
    initRankListData(rankData)
    reqRank = false
  end
end
function pvp.pvpShop()
  ed.pushScene(ed.ui.shop.create(5))
end
local function buyPvpTime()
  local priceTable = ed.getDataTable("GradientPrice")
  local cost = priceTable[buyTime + 1]["PVP Buy"]
  if ed.player._rmb >= resetCDCost then
    local sprite = CCSprite:create()
    local info = {
      sprite = sprite,
      spriteLabel = T(LSTR("PVP.THIS_IS_YOUR__D_TIME_TODAY_TO_BUY_TICKETS\N_NEED_TO_PAY__D_DIAMONDS_TO_ADD_FIVE_CHALLENGE_TIMES"), buyTime + 1, cost),
      leftText = T(LSTR("CHATCONFIG.CANCEL")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = function()
        xpcall(function()
          local msg = ed.upmsg.ladder()
          msg._buy_battle_chance = {}
          ed.send(msg, "ladder")
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
  else
    ed.showHandyDialog("toRecharge")
  end
end
local function resetCD()
  if ed.player._rmb >= resetCDCost then
    local sprite = CCSprite:create()
    local info = {
      sprite = sprite,
      spriteLabel = T(LSTR("PVP.DO_YOU_NEED_TO_PAY_50_DIAMONDS_TO_RESET_THE_COMBAT_COOL_DOWN_TIME_SO_THAT_YOU_CAN_FIGHT_INSTANTLY"), cost),
      leftText = T(LSTR("CHATCONFIG.CANCEL")),
      rightText = T(LSTR("CHATCONFIG.CONFIRM")),
      rightHandler = function()
        xpcall(function()
          local msg = ed.upmsg.ladder()
          msg._clear_battle_cd = {}
          ed.send(msg, "ladder")
        end, EDDebug)
      end
    }
    ed.showConfirmDialog(info)
  else
    ed.showHandyDialog("toRecharge")
  end
end
function pvp.changeEnemy()
  ed.playEffect(ed.sound.pvp.clickChangeEnemy)
  local buttonName = mainPanelLayer.changeEnemyName:getString()
  if buttonName == T(LSTR("PVP.CHANGE_ANOTHER_LIST")) then
    local msg = ed.upmsg.ladder()
    msg._apply_opponent = {}
    ed.send(msg, "ladder")
  elseif buttonName == T(LSTR("PVP.REST_NOW")) then
    resetCD()
  elseif buttonName == T(LSTR("PVP.THE_NUMBER_OF_PURCHASES")) then
    buyPvpTime()
  end
end
local function mainLayerTouch(event, x, y)
  if mainPanelLayer then
    return mainPanelLayer:touch(event, x, y)
  end
  return false
end
local function createMainLayer(self)
  mainPanelLayer = panelLayer:new(self.scene, self)
  mainPanelLayer.mainLayer = CCLayer:create()
  mainPanelLayer.mainLayer:registerScriptTouchHandler(mainLayerTouch, false, 0, false)
  mainPanelLayer.mainLayer:setTouchEnabled(true)
  self.scene:addChild(mainPanelLayer.mainLayer)
  local mainUIRes = {
    {
      t = "Sprite",
      base = {
        name = "pvpBg",
        res = "UI/alpha/HVGA/pvp/pvp_frame.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 210)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = T(LSTR("PVP.MY_RANK_")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(100, 267)
      },
      config = {
		color = ccc3(67, 59, 56),
        shadow = {
                color = ccc3(0, 0, 0),
                offset = ccp(0, 2)
              }
      }
    },
    {
      t = "Sprite",
      base = {name = "myRank"},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(150, 277)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reqRankData",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(461, 267)
      },
      config = {
        scaleSize = CCSizeMake(90, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reqRankData",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(461, 267)
      },
      config = {
        scaleSize = CCSizeMake(90, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "rankBoardName",
        text = T(LSTR("PVP.RANKING_")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(461, 267)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "pvpShop",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(675, 267)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "pvpShop",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(675, 267)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "recordName",
        text = T(LSTR("CRUSADECONFIG.REDEEM")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(685, 267)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/money_arenatoken_small.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(636, 266)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "showRewardInfo",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(361, 267)
      },
      config = {
        scaleSize = CCSizeMake(96, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "showRewardInfo",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(361, 267)
      },
      config = {
        scaleSize = CCSizeMake(96, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "rewardName",
        text = T(LSTR("PVP.RULE_DESCRIPTION")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(361, 267)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reqRecordBoard",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(558, 267)
      },
      config = {
        scaleSize = CCSizeMake(96, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "reqRecordBoard",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(558, 267)
      },
      config = {
        scaleSize = CCSizeMake(96, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "pvpShopName",
        text = T(LSTR("PVP.COMBAT_RECORD")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(558, 267)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Label",
      base = {
        name = "gps",
        text = T(LSTR("ANNOUNCE.COMBAT_")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(645, 368)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "gpsValue",
        text = "200",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(710, 368)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "changeEnemy",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_1.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 52)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "changeEnemy",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_2.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 52)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "changeEnemyName",
        text = T(LSTR("PVP.CHANGE_ANOTHER_LIST")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 52)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Sprite",
      base = {name = "moneyInfo"},
      layout = {
        position = ccp(0, 90)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "changeEnemyIcon",
        res = "UI/alpha/HVGA/pvp/pvp_price_bg.png",
        parent = "moneyInfo"
      },
      layout = {
        position = ccp(126, 5)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "changeEnemyIcon",
        res = "UI/alpha/HVGA/rmbicon.png",
        parent = "moneyInfo"
      },
      layout = {
        position = ccp(80, 4)
      },
      config = {scale = 0.7}
    },
    {
      t = "Label",
      base = {
        name = "changeEnemyCost",
        text = "300",
        size = 20,
        parent = "moneyInfo"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(168, 4)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "leftTime",
        text = T(LSTR("PVP.THE_REMAINING_TIME_OF_TODAY_")),
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 210)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "leftTimeNum",
        text = "10",
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 188)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Label",
      base = {
        name = "cdText",
        text = T(LSTR("PVP.CAN_CHALLENGE_AGAIN")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 130)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "cdTime",
        text = T(LSTR("PVP.AFTER_10_00")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(126, 155)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemy1Bg",
        res = "UI/alpha/HVGA/pvp/pvp_enemy_bg.png"
      },
      layout = {
        position = ccp(290, 130)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy1Icon",
        res = "UI/alpha/HVGA/pvp/main_head_bg.png",
        parent = "enemy1Bg",
        array = mainPanelLayer.buttonList
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy1IconFrame",
        parent = "enemy1Bg"
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
        parent = "enemy1Bg"
      },
      layout = {
        position = ccp(60, 138)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy1Level",
        text = "",
        size = 18,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(60, 138)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy1Id",
        text = "",
        size = 20,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 111)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy1Rank",
        text = T(LSTR("PVP.RANK_")),
        size = 20,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(51, 86)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy1RankValue",
        text = "",
        size = 20,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 86)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy1Gps",
        text = T(LSTR("ANNOUNCE.COMBAT_")),
        size = 20,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(56, 63)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy1GpsValue",
        text = "",
        size = 20,
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 63)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy1",
        array = mainPanelLayer.buttonList,
        parent = "enemy1Bg",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy1",
        array = mainPanelLayer.pressButtonList,
        parent = "enemy1Bg",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "challenge",
        text = T(LSTR("PVP.CHALLENGE")),
        fontinfo = "ui_normal_button",
        parent = "enemy1Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 27)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemy2Bg",
        res = "UI/alpha/HVGA/pvp/pvp_enemy_bg.png"
      },
      layout = {
        position = ccp(475, 130)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy2Icon",
        res = "UI/alpha/HVGA/pvp/main_head_bg.png",
        array = mainPanelLayer.buttonList,
        parent = "enemy2Bg"
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy2IconFrame",
        parent = "enemy2Bg"
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
        parent = "enemy2Bg"
      },
      layout = {
        position = ccp(60, 138)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy2Level",
        text = "",
        parent = "enemy2Bg",
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(60, 138)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy2Id",
        text = "",
        size = 20,
        parent = "enemy2Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 111)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy2Rank",
        text = T(LSTR("PVP.RANK_")),
        size = 20,
        parent = "enemy2Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(51, 86)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy2RankValue",
        text = "",
        size = 20,
        parent = "enemy2Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 86)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy2Gps",
        text = T(LSTR("ANNOUNCE.COMBAT_")),
        size = 20,
        parent = "enemy2Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(56, 63)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy2GpsValue",
        text = "",
        size = 20,
        parent = "enemy2Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 63)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy2",
        parent = "enemy2Bg",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy2",
        parent = "enemy2Bg",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "challenge",
        text = T(LSTR("PVP.CHALLENGE")),
        parent = "enemy2Bg",
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 27)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemy3Bg",
        res = "UI/alpha/HVGA/pvp/pvp_enemy_bg.png"
      },
      layout = {
        position = ccp(660, 130)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy3Icon",
        res = "UI/alpha/HVGA/pvp/main_head_bg.png",
        parent = "enemy3Bg",
        array = mainPanelLayer.buttonList
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "enemy3IconFrame",
        parent = "enemy3Bg"
      },
      layout = {
        position = ccp(84, 162)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png",
        parent = "enemy3Bg"
      },
      layout = {
        position = ccp(60, 138)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy3Level",
        text = "",
        size = 18,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(60, 138)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy3Id",
        text = "",
        size = 20,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 111)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "enemy33Rank",
        text = T(LSTR("PVP.RANK_")),
        size = 20,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(51, 86)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy3RankValue",
        text = "",
        size = 20,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 86)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy3Gps",
        text = T(LSTR("ANNOUNCE.COMBAT_")),
        size = 20,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(56, 63)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy3GpsValue",
        text = "",
        size = 20,
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(120, 63)
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy3",
        array = mainPanelLayer.buttonList,
        parent = "enemy3Bg",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "challengeEnemy3",
        array = mainPanelLayer.pressButtonList,
        parent = "enemy3Bg",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(14, 20, 60, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 26)
      },
      config = {
        scaleSize = CCSizeMake(90, 48),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "challenge",
        text = T(LSTR("PVP.CHALLENGE")),
        fontinfo = "ui_normal_button",
        parent = "enemy3Bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(84, 27)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "adjustHero",
        array = mainPanelLayer.buttonList,
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(675, 327)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "adjustHero",
        array = mainPanelLayer.pressButtonList,
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(50, 20, 66, 23)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(675, 327)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.ADJUSTMENT")),
        fontinfo = "ui_normal_button"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(675, 327)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("PVP.DEFENSIVE_TEAM_")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(100, 344)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {name = "hero1"},
      layout = {
        position = ccp(199, 346)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero2"},
      layout = {
        position = ccp(290, 346)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero3"},
      layout = {
        position = ccp(381, 346)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero4"},
      layout = {
        position = ccp(473, 346)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "hero5"},
      layout = {
        position = ccp(565, 346)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "recordTag",
        res = "UI/alpha/HVGA/main_deal_tag.png",
        z = 10
      },
      layout = {
        position = ccp(600, 280)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(mainPanelLayer.mainLayer, mainPanelLayer.uiControllers)
  readNode:addNode(mainUIRes)
end
local function initDefandHeroList(data)
  defandHeros = data
  if data ~= nil then
    for i = 1, 5 do
      local hero = string.format("hero%d", i)
      mainPanelLayer[hero]:removeAllChildrenWithCleanup(true)
    end
    for i, v in ipairs(data) do
      local hero = string.format("hero%d", i)
      local id = data[#data - i + 1]
      local heroIcon = ed.readhero.createIconByID(id, {state = "idle"})
      mainPanelLayer[hero]:addChild(heroIcon.icon)
    end
  end
end
local function initEnemyList(data)
  if nil == mainPanelLayer then
    return
  end
  enemyList = data
  for i = 1, 3 do
    local bg = string.format("enemy%dBg", i)
    local id = string.format("enemy%dId", i)
    local rank = string.format("enemy%dRankValue", i)
    local gps = string.format("enemy%dGpsValue", i)
    local level = string.format("enemy%dLevel", i)
    ed.setString(mainPanelLayer[id], "")
    ed.setString(mainPanelLayer[rank], "")
    ed.setString(mainPanelLayer[gps], "")
    ed.setString(mainPanelLayer[level], "")
    mainPanelLayer[bg]:setVisible(false)
  end
  if nil == data then
    return
  end
  for i, v in ipairs(data) do
    local bg = string.format("enemy%dBg", i)
    local id = string.format("enemy%dId", i)
    local rank = string.format("enemy%dRankValue", i)
    local gps = string.format("enemy%dGpsValue", i)
    local level = string.format("enemy%dLevel", i)
    local icon = string.format("enemy%dIconFrame", i)
    ed.setString(mainPanelLayer[id], v._summary._name)
    ed.setLabelShadow(mainPanelLayer[id], ccc3(0, 0, 0), ccp(0, 2))
    ed.setString(mainPanelLayer[rank], v._rank)
    ed.setString(mainPanelLayer[gps], v._gs)
    ed.setString(mainPanelLayer[level], v._summary._level)
    mainPanelLayer[bg]:setVisible(true)
    local param = {
      id = v._summary._avatar,
      vip = 0 < v._summary._vip
    }
    local head = ed.getHeroIconByID(param)
    if head then
      mainPanelLayer[icon]:removeAllChildrenWithCleanup(true)
      mainPanelLayer[icon]:addChild(head)
    end
  end
end
local function updateLastTime()
  local nowTime = ed.getServerTime()
  local passTime = nowTime - lastPvpTime
  if passTime < pvpCD then
    ed.setString(mainPanelLayer.cdTime, T(LSTR("PVP.AFTER__S"), ed.getmsNString(pvpCD - passTime)))
    mainPanelLayer.cdText:setVisible(true)
    mainPanelLayer.cdTime:setVisible(true)
    if bEnableResetCD then
      mainPanelLayer.moneyInfo:setVisible(true)
      ed.setString(mainPanelLayer.changeEnemyName, T(LSTR("PVP.REST_NOW")))
      ed.setString(mainPanelLayer.changeEnemyCost, resetCDCost)
      ed.setLabelShadow(mainPanelLayer.changeEnemyCost, ccc3(0, 0, 0), ccp(0, 2))
    end
  else
    mainPanelLayer.cdText:setVisible(false)
    mainPanelLayer.cdTime:setVisible(false)
    mainPanelLayer.moneyInfo:setVisible(false)
    ed.setString(mainPanelLayer.changeEnemyName, T(LSTR("PVP.CHANGE_ANOTHER_LIST")))
  end
  if 0 == leftTime and leftBuyTime > 0 then
    ed.setString(mainPanelLayer.changeEnemyName, T(LSTR("PVP.THE_NUMBER_OF_PURCHASES")))
    local priceTable = ed.getDataTable("GradientPrice")
    local cost = priceTable[buyTime + 1]["PVP Buy"]
    ed.setString(mainPanelLayer.changeEnemyCost, cost)
    ed.setLabelShadow(mainPanelLayer.changeEnemyCost, ccc3(0, 0, 0), ccp(0, 2))
    mainPanelLayer.moneyInfo:setVisible(true)
  end
end
local function initPanel(data)
  if nil == mainPanelLayer then
    return
  end
  buyTime = data._buy_times
  local vipLevel = ed.player:getvip()
  local maxBuyTime = ed.getDataTable("VIP")[vipLevel]["PVP Buy"]
  leftBuyTime = maxBuyTime - buyTime
  bEnableResetCD = ed.getDataTable("VIP")[vipLevel]["PVP CD Reset"]
  leftTime = data._left_count
  local width = ed.createNumbers(mainPanelLayer.myRank, tostring(data._rank), -2, nil, "big_pvp1")  --phan.chen by 2014.11.28 big_pvp 改为 big_pvp1 避免与其他地方冲突
  currentRank = data._rank
  mainPanelLayer.myRank:setContentSize(CCSizeMake(width, 20))
  mainPanelLayer.myRank:setCascadeOpacityEnabled(true)
  ed.setString(mainPanelLayer.gpsValue, data._gs)
  ed.setString(mainPanelLayer.leftTimeNum, string.format("%d/%d", data._left_count, 5))
  lastPvpTime = data._last_bt_time
  --highestRank = data._highestrank
  updateLastTime()
  initDefandHeroList(data._lineup)
  initEnemyList(enemyList or data._oppos)
  bDataValid = true
end
local function OnChatRsp(data)
  if data._say and data._say._result == "success" then
    ed.showToast(T(LSTR("PVP.SHARE_SUCCESSFULLY")))
  end
end
local function onExitWork()
  CloseScope(pvpEventScope)
  pvpEventScope = nil
  bDataValid = false
  StopListenEvent("ChatRsp", OnChatRsp)
end
local function clearEnemyList()
  enemyList = nil
end
local function onPvpNotifyChange(data)
  if nil == data or nil == mainPanelLayer then
    return
  end
  if data._is_attacked == 1 then
    mainPanelLayer.recordTag:setVisible(true)
  else
    mainPanelLayer.recordTag:setVisible(false)
  end
end
local function onPopScene()
  onExitWork()
  mainPanelLayer = nil
  rankPanelLayer = nil
  recordPanelLayer = nil
  heroInfoLayer = nil
  rewardPanelLayer = nil
  bDataValid = false
  rewardInfoPanelLayer = nil
  clearEnemyList()
  StopListenEvent("PvpNotifyData", onPvpNotifyChange)
  sharePanel = nil
end
local function onEnterWork()
  if bDataValid == false then
    local msg = ed.upmsg.ladder()
    msg._open_panel = {}
    ed.send(msg, "ladder")
  end
  reqRecord = true
  reqRank = true
  pvpEventScope = {}
  ListenTimer(Timer:Always(1), updateLastTime, pvpEventScope)
  ListenEvent("PvpNotifyData", onPvpNotifyChange)
  ListenEvent("ChatRsp", OnChatRsp)
  onPvpNotifyChange(ed.queryNotifyData("PvpNotifyData"))
end
function pvp.create()
  local self = base.create("pvp")
  setmetatable(self, pvp)
  createMainLayer(self)
  self:registerOnExitHandler("onExitwork", onExitWork)
  self:registerOnEnterHandler("onEnterwork", onEnterWork)
  self:registerOnPopSceneHandler("onPopScene", onPopScene)
  if ed.player:getName() == "" then
    local bename = ed.ui.bename.create({ispvp = true})
    self:ccScene():addChild(bename.mainLayer, 100)
    function bename.destroyHandler()
      ed.popScene()
    end
  end
  return self
end
local function clearBattleCD(result)
  if "success" == result then
    lastPvpTime = 0
    ed.player:subrmb(resetCDCost)
  end
end
local function buyPvpTimesRsp(data)
  if "success" == data._result then
    ed.setString(mainPanelLayer.leftTimeNum, string.format("%d/%d", 5, 5))
    local priceTable = ed.getDataTable("GradientPrice")
    local cost = priceTable[buyTime + 1]["PVP Buy"]
    ed.player:subrmb(cost)
    buyTime = data._buy_times
    leftTime = 5
  end
end
local function pvpMsgRsp(msg)
  if msg._open_panel then
    if mainPanelLayer == nil then
      ed.pushScene(ed.ui.pvp.create())
    end
    initPanel(msg._open_panel)
  elseif msg._apply_oppo then
    initEnemyList(msg._apply_oppo._oppos)
  elseif msg._start_battle then
  elseif msg._end_battle then
  elseif msg._set_lineup then
    if msg._set_lineup._result == "success" then
      initDefandHeroList(msg._set_lineup._lineup)
      ed.setString(mainPanelLayer.gpsValue, msg._set_lineup._gs)
    end
  elseif msg._query_records then
    showRecordBoard(msg._query_records._records)
  elseif msg._query_replay then
    ed.showReplay(msg._query_replay._record)
  elseif msg._query_rankborad then
    local handler = ed.getNetReply("query_pvp_ranklist")
    if handler then
      handler(msg._query_rankborad)
    else
      showRankBoard(msg._query_rankborad._rank_list)
    end
  elseif msg._query_oppo then
    local handler = ed.getNetReply("query_pvp_oppo")
    if handler then
      handler(msg._query_oppo._user)
    else
      showHeroInfo(msg._query_oppo._user)
    end
  elseif msg._clear_battle_cd then
    clearBattleCD(msg._clear_battle_cd._result)
  elseif msg._buy_battle_chance then
    buyPvpTimesRsp(msg._buy_battle_chance)
  end
end
ListenEvent("pvpRsp", pvpMsgRsp)
ListenEvent("StartPVPBattle", clearEnemyList)

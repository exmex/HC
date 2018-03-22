local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.ranklist = class
class.ranklist_config = {
  [1] = {
    mode = "pvp",
    name = T(LSTR("RANKLIST.ARENADAY")),
    initHandler = function(self, callback)
      if self.pvpRanklist then
        if callback then
          callback()
        else
          self:initListLayer("pvp")
        end
      else
        ed.registerNetReply("query_pvp_ranklist", function(data)
          self.pvpRanklist = data._rank_list
          self.glSelfRank.pvp = data._pos
          self.glSelfPrevPos.pvp = data._prev_pos
          self.glSelfSummary.pvp = data._self_rank._summary
          self.mylselfVal.pvp = data._pos
          if callback then
            callback()
          else
            self:initListLayer("pvp")
          end
        end)
        local msg = ed.upmsg.ladder()
        msg._query_rankboard = ed.upmsg.query_rankboard()
        msg._query_rankboard._type = "static_c"
        ed.send(msg, "ladder")
      end
    end
  },
  [2] = {
    mode = "top_arena",
    name = T(LSTR("RANKLIST.TOPARENADAY")),
    initHandler = function(self, callback)
      if self.superPvpRanklist then
        if callback then
          callback()
        else
          self:initListLayer("top_arena")
        end
      else
        ed.registerNetReply("top_arena", function(data)
          self.superPvpRanklist = data._rank_list
          self.glSelfRank.top_arena = data._pos
          self.glSelfPrevPos.top_arena = data._prev_pos
          self.glSelfSummary.top_arena = data._self_rank._summary
          self.mylselfVal.top_arena = data._pos
          if callback then
            callback()
          else
            self:initListLayer("top_arena")
          end
        end)
        local msg = ed.upmsg.top_arena()
        msg._query_rankboard = ed.upmsg.arena_query_rankboard()
        msg._query_rankboard._type = "static_c"
        ed.send(msg, "top_arena")
      end
    end
  },
  [3] = {
    mode = "guildliveness",
    name = T(LSTR("RANKLIST.GUILDACTIVE")),
    initHandler = function(self, callback)
      if self.glRankList then
        if callback then
          callback()
        else
          self:initListLayer("guildliveness")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.glRankList = self:getRankList(data, "guildliveness")
          self.glSelfRank.guildliveness = data._self_ranking
          self.glSelfPrevPos.guildliveness = data._self_prev_pos
          self.glSelfSummary.guildliveness = data._self_item._user_summary
			local temp =data._self_item
			if temp._guild_summary~=nil then
				self.guildIcon=data._self_item._guild_summary._avatar
			else
				self.guildIcon=1
			end
          self.mylselfVal.guildliveness = data._self_item._param1
          if callback then
            callback()
          else
            self:initListLayer("guildliveness")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "guildliveness"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [4] = {
    mode = "excavaterob",
    name = T(LSTR("RANKLIST.TREASUREPLUNDER")),
    initHandler = function(self, callback)
      if self.evtRobList then
        if callback then
          callback()
        else
          self:initListLayer("excavaterob")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.evtRobList, self.evtRobValueList = self:getRankList(data, "excavaterob")
          self.glSelfRank.excavaterob = data._self_ranking
          self.glSelfPrevPos.excavaterob = data._self_prev_pos
          self.glSelfSummary.excavaterob = data._self_item._user_summary
          self.evtRobValue = data._self_item._param1
          self.mylselfVal.excavaterob = self.evtRobValue
          if callback then
            callback()
          else
            self:initListLayer("excavaterob")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "excavate_rob"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [5] = {
    mode = "excavategold",
    name = T(LSTR("RANKLIST.GOLDDIG")),
    initHandler = function(self, callback)
      if self.evtGoldList then
        if callback then
          callback()
        else
          self:initListLayer("excavategold")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.evtGoldList, self.evtValueList.excavategold = self:getRankList(data, "excavategold")
          self.glSelfRank.excavategold = data._self_ranking
          self.glSelfPrevPos.excavategold = data._self_prev_pos
          self.glSelfSummary.excavategold = data._self_item._user_summary
          self.evtGoldValue = data._self_item._param1
          self.mylselfVal.excavategold = self.evtGoldValue
          if callback then
            callback()
          else
            self:initListLayer("excavategold")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "excavate_gold"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [6] = {
    mode = "excavateexp",
    name = T(LSTR("RANKLIST.EXPDIG")),
    initHandler = function(self, callback)
      if self.evtExpList then
        if callback then
          callback()
        else
          self:initListLayer("excavateexp")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.evtExpList, self.evtValueList.excavateexp = self:getRankList(data, "excavateexp")
          self.glSelfRank.excavateexp = data._self_ranking
          self.glSelfPrevPos.excavateexp = data._self_prev_pos
          self.glSelfSummary.excavateexp = data._self_item._user_summary
          self.evtExpValue = data._self_item._param1
          self.mylselfVal.excavateexp = self.evtExpValue
          if callback then
            callback()
          else
            self:initListLayer("excavateexp")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "excavate_exp"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [7] = {
    mode = "top_gs",
    name = T(LSTR("RANKLIST.TOPFIGHTVALUE")),
    initHandler = function(self, callback)
      if self.topgsRankList then
        if callback then
          callback()
        else
          self:initListLayer("top_gs")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.topgsRankList, self.evtValueList.top_gs = self:getRankList(data, "top_gs")
          self.glSelfRank.top_gs = data._self_ranking
          self.glSelfPrevPos.top_gs = data._self_prev_pos
          self.glSelfSummary.top_gs = data._self_item._user_summary
          self.mylselfVal.top_gs = data._self_item._param1--self.evtValueList.top_gs[data._self_ranking]
          if callback then
            callback()
          else
            self:initListLayer("top_gs")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "top_gs"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [8] = {
    mode = "full_hero_gs",
    name = T(LSTR("RANKLIST.ALLMEMBERFIGHTVALUE")),
    initHandler = function(self, callback)
      if self.fullherogsRankList then
        if callback then
          callback()
        else
          self:initListLayer("full_hero_gs")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.fullherogsRankList, self.evtValueList.full_hero_gs = self:getRankList(data, "full_hero_gs")
          self.glSelfRank.full_hero_gs = data._self_ranking
          self.glSelfPrevPos.full_hero_gs = data._self_prev_pos
          self.glSelfSummary.full_hero_gs = data._self_item._user_summary
          self.mylselfVal.full_hero_gs = data._self_item._param1--self.evtValueList.full_hero_gs[data._self_ranking]
          if callback then
            callback()
          else
            self:initListLayer("full_hero_gs")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "full_hero_gs"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [9] = {
    mode = "hero_team_gs",
    name = T(LSTR("RANKLIST.LITTLETEAMFIGHTVALUE")),
    initHandler = function(self, callback)
      if self.heroteamRankList then
        if callback then
          callback()
        else
          self:initListLayer("hero_team_gs")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.heroteamRankList, self.evtValueList.hero_team_gs = self:getRankList(data, "hero_team_gs")
          self.glSelfRank.hero_team_gs = data._self_ranking
          self.glSelfPrevPos.hero_team_gs = data._self_prev_pos
          self.glSelfSummary.hero_team_gs = data._self_item._user_summary
          self.mylselfVal.hero_team_gs = data._self_item._param1--.evtValueList.hero_team_gs[data._self_ranking]
          if callback then
            callback()
          else
            self:initListLayer("hero_team_gs")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "hero_team_gs"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [10] = {
    mode = "hero_evo_star",
    name = T(LSTR("RANKLIST.HEROSTAR")),
    initHandler = function(self, callback)
      if self.heroevoRankList then
        if callback then
          callback()
        else
          self:initListLayer("hero_evo_star")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.heroevoRankList, self.evtValueList.hero_evo_star = self:getRankList(data, "hero_evo_star")
          self.glSelfRank.hero_evo_star = data._self_ranking
          self.glSelfPrevPos.hero_evo_star = data._self_prev_pos
          self.glSelfSummary.hero_evo_star = data._self_item._user_summary
          self.mylselfVal.hero_evo_star = data._self_item._param1--self.evtValueList.hero_evo_star[data._self_ranking]
          if callback then
            callback()
          else
            self:initListLayer("hero_evo_star")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "hero_evo_star"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [11] = {
    mode = "hero_arousal",
    name = T(LSTR("RANKLIST.EQUIPWASH")),
    initHandler = function(self, callback)
      if self.heroarousalRankList then
        if callback then
          callback()
        else
          self:initListLayer("hero_arousal")
        end
      else
        ed.registerNetReply("query_ranklist", function(data)
          self.heroarousalRankList, self.evtValueList.hero_arousal = self:getRankList(data, "hero_arousal")
          self.glSelfRank.hero_arousal = data._self_ranking
          self.glSelfPrevPos.hero_arousal = data._self_prev_pos
          self.glSelfSummary.hero_arousal = data._self_item._user_summary
          self.mylselfVal.hero_arousal = self.evtValueList.hero_arousal[data._self_ranking]
          if callback then
            callback()
          else
            self:initListLayer("hero_arousal")
          end
        end)
        local msg = ed.upmsg.query_ranklist()
        msg._rank_type = "hero_arousal"
        ed.send(msg, "query_ranklist")
      end
    end
  },
  [12] = {
    mode = "pvp_r",
    name = T(LSTR("RANKLIST.ARENAREALTIME")),
    initHandler = function(self, callback)
      if false then
      else
        ed.registerNetReply("query_pvp_ranklist", function(data)
          self.pvpRanklist_r = data._rank_list
          self.glSelfRank.pvp_r = data._pos
          self.glSelfPrevPos.pvp_r = data._prev_pos
          self.glSelfSummary.pvp_r = data._self_rank._summary
          self.mylselfVal.pvp_r = data._pos
          if callback then
            callback()
          else
            self:initListLayer("pvp_r")
          end
        end)
        local msg = ed.upmsg.ladder()
        msg._query_rankboard = ed.upmsg.query_rankboard()
        msg._query_rankboard._type = "dynamic"
        ed.send(msg, "ladder")
      end
    end
  },
  [13] = {
    mode = "top_arena_r",
    name = T(LSTR("RANKLIST.TOPARENAREALTIME")),
    initHandler = function(self, callback)
      if false then
      else
        ed.registerNetReply("top_arena", function(data)
          self.superPvpRanklist_r = data._rank_list
          self.glSelfRank.top_arena_r = data._pos
          self.glSelfPrevPos.top_arena_r = data._prev_pos
          self.glSelfSummary.top_arena_r = data._self_rank._summary
          self.mylselfVal.top_arena_r = data._pos
          if callback then
            callback()
          else
            self:initListLayer("top_arena_r")
          end
        end)
        local msg = ed.upmsg.top_arena()
        msg._query_rankboard = ed.upmsg.arena_query_rankboard()
        msg._query_rankboard._type = "dynamic"
        ed.send(msg, "top_arena")
      end
    end
  }
}
local ranklisttree = {
  [1] = {
    name = T(LSTR("RANKLIST.ARENA")),
    collapsed = false,
    pos = ccp(0, 0),
    list = {
	--[[
      [1] = {
        rankconfig = 2,
        btn = nil,
        pos = ccp(0, 0)
      },
      [2] = {
        rankconfig = 13,
        btn = nil,
        pos = ccp(0, 0)
      },
	--]]
      [1] = {
        rankconfig = 1,
        btn = nil,
        pos = ccp(0, 0)
      },
      [2] = {
        rankconfig = 12,
        btn = nil,
        pos = ccp(0, 0)
      }
    }
  },
  [2] = {
    name = T(LSTR("RANKLIST.FIGHTVALUE")),
    collapsed = true,
    pos = ccp(0, 0),
    list = {
      [1] = {
        rankconfig = 8,
        btn = nil,
        pos = ccp(0, 0)
      },
	--[[
      [2] = {
        rankconfig = 7,
        btn = nil,
        pos = ccp(0, 0)
      },
	--]]
      [2] = {
        rankconfig = 9,
        btn = nil,
        pos = ccp(0, 0)
      },
      [3] = {
        rankconfig = 10,
        btn = nil,
        pos = ccp(0, 0)
      }
    }
  },
--[[
  [3] = {
    name = T(LSTR("RANKLIST.WASH")),
    collapsed = true,
    pos = ccp(0, 0),
    list = {
      [1] = {
        rankconfig = 11,
        btn = nil,
        pos = ccp(0, 0)
      }
    }
  },
--]]
  [3] = {
    name = T(LSTR("RANKLIST.GUILD")),
    collapsed = true,
    pos = ccp(0, 0),
    list = {
      [1] = {
        rankconfig = 3,
        btn = nil,
        pos = ccp(0, 0)
      }
    }
  },
--[[
  [5] = {
    name = T(LSTR("RANKLIST.TREASUERHOLE")),
    collapsed = true,
    pos = ccp(0, 0),
    list = {
      [1] = {
        rankconfig = 4,
        btn = nil,
        pos = ccp(0, 0)
      },
      [2] = {
        rankconfig = 5,
        btn = nil,
        pos = ccp(0, 0)
      },
      [3] = {
        rankconfig = 6,
        btn = nil,
        pos = ccp(0, 0)
      }
    }
  }
--]]
}
class.title_scale_large = 1
class.title_scale_middle = 0.75
class.title_scale_small = 0
local getRankList = function(self, data, mode)
  local mode_couple = {
    guildliveness = guildliveness,
    excavaterob = excavate_rob,
    excavatermb = excavate_rmb,
    excavategold = excavate_gold,
    excavateexp = excavate_exp,
    top_gs = top_gs,
    full_hero_gs = full_hero_gs,
    hero_team_gs = hero_team_gs,
    hero_evo_star = hero_evo_star,
    hero_arousal = hero_arousal,
    top_arena = top_arena
  }
  if mode_couple[mode] and mode_couple[mode] ~= data._rank_type then
    print("The received ranklist is not matched the one asking for...")
    print("-->>Ask for : " .. mode_couple[mode])
    print("-->>Received : " .. data._rank_type)
  end
  local list, vList = {}, {}
  if ed.isElementInTable(mode, {
    "guildliveness"
  }) then
    for i, v in ipairs(data._ranklist_item or {}) do
      table.insert(list, v._guild_summary)
    end
  elseif ed.isElementInTable(mode, {
    "excavaterob",
    "excavatermb",
    "excavategold",
    "excavateexp",
    "top_gs",
    "full_hero_gs",
    "hero_team_gs",
    "hero_evo_star",
    "hero_arousal"
  }) then
    for i, v in ipairs(data._ranklist_item or {}) do
      table.insert(list, v._user_summary)
      table.insert(vList, v._param1)
    end
  end
  return list, vList
end
class.getRankList = getRankList
local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.back_button,
    press = ui.back_button_press,
    key = "back_button",
    clickHandler = function()
      for i = 1, #ranklisttree do
        ranklisttree[i].collapsed = i ~= 1
      end
      ed.popScene()
    end,
    clickInterval = 0.5
  })
  self:btRegisterRectClick({
    rect = ed.DGRectMake(150, 520, 205, 70),
    key = "title_bg_left",
    clickHandler = function()
    end,
    clickInterval = 0.2
  })
  self:btRegisterRectClick({
    rect = ed.DGRectMake(665, 520, 205, 70),
    key = "title_bg_right",
    clickHandler = function()
    end,
    clickInterval = 0.2
  })
end
class.registerTouchHandler = registerTouchHandler
local initpvpItemHandler = function(self)
  local function handler(param)
    local index = param.index
    local data = param.data
    local summary = data._summary
    local container = param.container
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = data._user_id == ed.getUserid() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < summary._vip
    })
    head:setPosition(ed.DGccp(175, 50))
    board:addChild(head)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250, 52)
      }
    }, board)
    local level = ed.getLevelIcon({
      level = summary._level,
      vip = 0 < summary._vip
    })
    level:setPosition(ed.DGccp(250, 50))
    board:addChild(level)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = summary._name == "NickName" and "" or summary._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280, 52)
      }
    }, board)
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "pvp_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        ed.registerNetReply("query_pvp_oppo", function(data)
          if not tolua.isnull(self.mainLayer) then
            self.mainLayer:addChild(self.userpvpsummary.create(data).mainLayer, 100)
          end
        end)
        local msg = ed.upmsg.ladder()
        msg._query_oppo = {}
        msg._query_oppo._oppo_user_id = data._user_id
        ed.send(msg, "ladder")
      end
    })
    return {
      icon = board,
      ranking = ranking,
      head = head
    }
  end
  return handler
end
class.initpvpItemHandler = initpvpItemHandler
local initTopArenaItemHandler = function(self)
  local function handler(param)
    local index = param.index
    local data = param.data
    local summary = data._summary
    local container = param.container
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = data._user_id == ed.getUserid() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < summary._vip
    })
    head:setPosition(ed.DGccp(175, 50))
    board:addChild(head)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250, 52)
      }
    }, board)
    local level = ed.getLevelIcon({
      level = summary._level,
      vip = 0 < summary._vip
    })
    level:setPosition(ed.DGccp(250, 50))
    board:addChild(level)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = summary._name == "NickName" and "" or summary._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280, 52)
      }
    }, board)
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "pvp_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        ed.registerNetReply("query_toppvp_oppo", function(data)
          if not tolua.isnull(self.mainLayer) then
            self.mainLayer:addChild(self.usertoppvpsummary.create(data).mainLayer, 100)
          end
        end)
        local oppo_id = data._user_id
        local msg = ed.upmsg.top_arena()
        msg._query_oppo = ed.upmsg.arena_query_oppo_info()
        msg._query_oppo._oppo_user_id = oppo_id
        ed.send(msg, "top_arena")
      end
    })
    return {
      icon = board,
      ranking = ranking,
      head = head
    }
  end
  return handler
end
class.initTopArenaItemHandler = initTopArenaItemHandler
local initCommonItemHandler = function(self, mode)
  local function handler(param)
    local index = param.index
    local summary = param.data
    local container = param.container
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = summary._name == ed.player:getName() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < summary._vip
    })
    head:setPosition(ed.DGccp(175, 50))
    board:addChild(head)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250, 67)
      }
    }, board)
    local level = ed.getLevelIcon({
      level = summary._level,
      vip = 0 < summary._vip
    })
    level:setPosition(ed.DGccp(250, 65))
    board:addChild(level)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = summary._name == "NickName" and "" or summary._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280, 67)
      }
    }, board)
    local config = {
      top_gs = {
        vList = self.evtValueList[mode],
        tipsText = T(LSTR("RANKLIST.TOPFIFTEENFIGHTVALUE"))
      },
      full_hero_gs = {
        vList = self.evtValueList[mode],
        tipsText = T(LSTR("RANKLIST.ALLHEROFIGHTVALUE"))
      },
      hero_team_gs = {
        vList = self.evtValueList[mode],
        tipsText = T(LSTR("RANKLIST.TOPFIVEFIGHTVALUE"))
      },
      hero_evo_star = {
        vList = self.evtValueList[mode],
        tipsText = T(LSTR("RANKLIST.HEROALLSTAR")),
        iconres = "UI/alpha/HVGA/detail_star.png"
      },
      hero_arousal = {
        vList = self.evtValueList[mode],
        tipsText = T(LSTR("RANKLIST.WASHATTRIBUTE"))
      }
    }
    local cc = config[mode]
    if cc.vList[index] then
      local record = ed.createNode({
        t = "Label",
        base = {
          text = cc.tipsText,
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(240, 26)
        },
        config = {
          color = ccc3(128, 54, 23)
        }
      }, board)
      local icon
      if cc.iconres then
        icon = ed.createNode({
          t = "Sprite",
          base = {
            res = cc.iconres
          },
          layout = {
            anchor = ccp(0, 0.4),
            position = ed.getRightSidePos(record)
          }
        }, board)
        icon:setScale(0.5)
      end
      local value = ed.createNode({
        t = "Label",
        base = {
          text = ed.formatNumWithComma(cc.vList[index]),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.getRightSidePos(cc.iconres and icon or record)
        },
        config = {
          color = ccc3(128, 54, 23)
        }
      }, board)
    end
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "evtdefend_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        self.mainLayer:addChild(self.usercommonsummary.create(summary).mainLayer, 100)
      end
    })
    return
  end
  return handler
end
class.initCommonItemHandler = initCommonItemHandler
local initglItemHandler = function(self)
  local function handler(param)
    local container = param.container
    local index = param.index
    local data = param.data
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = data._id == ed.player:getGuildId() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.readequip.createIcon(nil, 60, 1, {
      fres = ed.getDataTable("GuildAvatar")[data._avatar].Picture
    })
    head:setPosition(ed.DGccp(175, 48))
    board:addChild(head, 5)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(200, 66)
      }
    }, board)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = data._name == "NickName" and "" or data._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(215, 68)
      }
    }, board)
    local livenessTitle = ed.createNode({
      t = "Label",
      base = {
        text = T(LSTR("RANKLIST.LASTTHREELIVENESS"),tostring(data._liveness or "Unknown")),
        size = 18
      },
      config = {
        color = ccc3(134, 53, 4)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(215, 28)
      }
    }, board)
    if not data._liveness then
      print("-->>Lack parameter : <guild_summary._liveness>")
    end
    local liveness = ed.createNode({
      t = "Label",
      base = {
        text = data._liveness or "Unknown",
        size = 18
      },
      config = {
        color = ccc3(134, 53, 4),
		visible=false
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(480, 28)
      }
    }, board)
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "guildliveness_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        self.mainLayer:addChild(self.guildsummary.create(index, data).mainLayer, 100)
      end
    })
    return {icon = board}
  end
  return handler
end
class.initglItemHandler = initglItemHandler
local initExcavateRobHandler = function(self)
  local function handler(param)
    local index = param.index
    local summary = param.data
    local container = param.container
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = summary._name == ed.player:getName() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < summary._vip
    })
    head:setPosition(ed.DGccp(175, 50))
    board:addChild(head)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250, 67)
      }
    }, board)
    local level = ed.getLevelIcon({
      level = summary._level,
      vip = 0 < summary._vip
    })
    level:setPosition(ed.DGccp(250, 65))
    board:addChild(level)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = summary._name == "NickName" and "" or summary._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280, 67)
      }
    }, board)
    if self.evtRobValueList[index] then
      local record = ed.createNode({
        t = "Label",
        base = {
          text = T(LSTR("RANKLIST.LASTTHREEDIGTIMESWITHS"), self.evtRobValueList[index]),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(240, 26)
        },
        config = {
          color = ccc3(128, 54, 23)
        }
      }, board)
    end
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "evtrob_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        self.mainLayer:addChild(self.usercommonsummary.create(summary).mainLayer, 100)
      end
    })
    return {icon = board}
  end
  return handler
end
class.initExcavateRobHandler = initExcavateRobHandler
local initExcavateDefendHandler = function(self, mode)
  local function handler(param)
    local index = param.index
    local summary = param.data
    local container = param.container
    local board = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = summary._name == ed.player:getName() and "UI/alpha/HVGA/ranklist/ranklist_me_bg.png" or "UI/alpha/HVGA/pvp/pvp_rank_bg_high.png",
        capInsets = ed.DGRectMake(65, 25, 545, 25)
      },
      layout = {
        anchor = ccp(0, 1),
		position=ccp(3,0)
      },
      config = {
        scaleSize = ed.DGSizeMake(650, 95)
      }
    }, container)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    board:addChild(ranking)
    local head = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < summary._vip
    })
    head:setPosition(ed.DGccp(175, 50))
    board:addChild(head)
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250, 67)
      }
    }, board)
    local level = ed.getLevelIcon({
      level = summary._level,
      vip = 0 < summary._vip
    })
    level:setPosition(ed.DGccp(250, 65))
    board:addChild(level)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = summary._name == "NickName" and "" or summary._name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280, 67)
      }
    }, board)
    local config = {
      rmb = {
        vList = self.evtrmbValueList,
        iconres = "UI/alpha/HVGA/task_rmb_icon_2.png"
      },
      gold = {
        vList = self.evtValueList.excavategold,
        iconres = "UI/alpha/HVGA/task_gold_icon_2.png"
      },
      exp = {
        vList = self.evtValueList.excavateexp,
        iconres = "UI/alpha/HVGA/excavate/excavate_exp_icon.png"
      }
    }
    local cc = config[mode]
    if cc.vList[index] then
      local record = ed.createNode({
        t = "Label",
        base = {
          text = T(LSTR("RANKLIST.LASTTHREEDIGAMOUNT")),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(240, 26)
        },
        config = {
          color = ccc3(128, 54, 23)
        }
      }, board)
      local icon = ed.createNode({
        t = "Sprite",
        base = {
          res = cc.iconres
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.getRightSidePos(record)
        }
      }, board)
      local value = ed.createNode({
        t = "Label",
        base = {
          text = ed.formatNumWithComma(cc.vList[index]),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.getRightSidePos(icon)
        },
        config = {
          color = ccc3(128, 54, 23)
        }
      }, board)
    end
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    self:btRegisterButtonClick({
      button = board,
      pressScale = 1,
      mcpMode = true,
      key = "evtdefend_item_" .. index,
      force = true,
      clickInterval = 0.3,
      extraCheckHandler = function(x, y)
        if self.scrollView:checkTouchInList(x, y) then
          return true
        end
        return false
      end,
      clickHandler = function()
        self.mainLayer:addChild(self.usercommonsummary.create(summary).mainLayer, 100)
      end
    })
    return {icon = board}
  end
  return handler
end
class.initExcavateDefendHandler = initExcavateDefendHandler
local getMyselfRankSummary = function(self, mode)
  if mode ~= "guildliveness" then
    return {
      previndex = self.glSelfPrevPos[mode] or -1,
      index = self.glSelfRank[mode] or -1,
      _avatar = self.glSelfSummary[mode]._avatar or -1,
      _vip = self.glSelfSummary[mode]._vip or -1,
      _name = self.glSelfSummary[mode]._name or "",
      _level = self.glSelfSummary[mode]._level or -1
    }
  else
    ed.printTable(self.glSelfSummary[mode])
    return {
      previndex = self.glSelfPrevPos[mode] or -1,
      index = self.glSelfRank[mode] or -1,
      _avatar = self.guildIcon or -1,
      _vip = self.glSelfSummary[mode]._vip or -1,
      _name = self.glSelfSummary[mode]._name or "",
      _level = self.glSelfSummary[mode]._level or -1,
      _guild_name = self.glSelfSummary[mode]._guild_name or "",
      _liveness = self.mylselfVal[mode] or -1
	
    }
  end
end
class.getMyselfRankSummary = getMyselfRankSummary
local getInitEDTHandler = function(self, mode, ignoredelta)
  local function handler()
    local pc = self.pageContainer
    if not tolua.isnull(pc) then
      pc:removeFromParentAndCleanup(true)
    end
    pc = ed.createNode({
      t = "Sprite",
      layout = {
        anchor = ccp(0, 0)
      }
    }, self.container)
    self.pageContainer = pc
    pc:setPosition(245, 400)
    pc:setZOrder(99)
    local index = 1
    local summary = self:getMyselfRankSummary(mode)
    if 0 > summary.index or self.index == 1 or self.index == 2 then
      pc:removeFromParentAndCleanup(true)
      self.pageContainer = nil
      self.rankListMyselfOffsetY = 0
      return
    end
    self.rankListMyselfOffsetY = 80
    index = summary.index
    local board = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/ranklist/ranklist_my_bg.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(8, 7)
      },
      config = {}
    }, pc)
    local ranking
    if index == 1 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
    elseif index == 2 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
    elseif index == 3 then
      ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
    else
      ranking = ed.getNumberNode({text = index, folder = "big_pvp"}).node
    end
    ranking:setPosition(ed.DGccp(60, 50))
    ranking:setScale(math.min(1, 70 / ranking:getContentSize().width))
    board:addChild(ranking)
    local xOffset = 80
    local deltaposvalue = 0
    if summary.previndex == 0 and 0 < summary.index then
      deltaposvalue = summary.index
    elseif 0 < summary.previndex and 0 < summary.index then
      deltaposvalue = summary.previndex - summary.index
    end
    print("title up ", summary.previndex, summary.index)
    if deltaposvalue ~= 0 and summary.previndex ~= 0 then
      local delataPosIco = ed.createNode({
        t = "Sprite",
        base = {
          res = deltaposvalue > 0 and "UI/alpha/HVGA/pvp/pvp_up.png" or "UI/alpha/HVGA/pvp/pvp_down.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ed.DGccp(130, 30)
        }
      }, board)
      local delataPosHint = ed.createNode({
        t = "Label",
        base = {
          text = T(LSTR("RANKLIST.COMPAREYESTERDAY")),
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ed.DGccp(155, 67)
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      }, board)
      if not (deltaposvalue > 0) or not ccc3(99, 192, 0) then
      end
      local delataPos = ed.createNode({
        t = "Label",
        base = {
          text = tostring(math.abs(deltaposvalue)),
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ed.DGccp(173, 30)
        },
        config = {
          color = ccc3(242, 98, 60)
        }
      }, board)
    end
    local head
    if mode == "guildliveness" then
      head = ed.readequip.createIcon(nil, 60, 1, {
        fres = ed.getDataTable("GuildAvatar")[summary._avatar].Picture
      })
    else
      head = ed.getTeamHead({
        id = summary._avatar,
        vip = 0 < summary._vip
      })
    end
    head:setPosition(ed.DGccp(175 + xOffset, 50))
    head:setScale(0.85)
    head:setCascadeOpacityEnabled(true)
    board:addChild(head)
    local itemdispname
    local nameoffset = 0
    local nameBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/task_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(250 + xOffset, 67)
      }
    }, board)
    if mode ~= "guildliveness" then
      local level = ed.getLevelIcon({
        level = summary._level,
        vip = 0 < summary._vip
      })
      level:setPosition(ed.DGccp(250 + xOffset, 65))
      level:setCascadeOpacityEnabled(true)
      board:addChild(level)
      itemdispname = summary._name == "NickName" and "" or summary._name
    else
      itemdispname = summary._guild_name or "Unknown"
      nameoffset = nameoffset - 40
    end
    nameBg:setPosition(ed.DGccp(250 + xOffset + nameoffset, 67))
    local name = ed.createNode({
      t = "Label",
      base = {text = itemdispname, size = 18},
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(280 + xOffset + nameoffset, 67)
      }
    }, board)
    local config = {
      pvp = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.ARENARANKWITHTWODOT"))
      },
      top_arena = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.TOPARENAWITHTWODOT"))
      },
      pvp_r = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.ARENARANKWITHTWODOT"))
      },
      top_arena_r = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.TOPARENAWITHTWODOT"))
      },
      guildliveness = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("ranklist.1.10.1.003"))
      },
      excavaterob = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.LASTTHREEDIGTIMES"))
      },
      excavatermb = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.LASTTHREEDIGAMOUNTWITHDOTS"))
      },
      excavategold = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.LASTTHREEDIGAMOUNTWITHDOTS"))
      },
      excavateexp = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.LASTTHREEDIGAMOUNTWITHDOTS"))
      },
      top_gs = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.TOPFIFTEENFIGHTVALUE"))
      },
      full_hero_gs = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.ALLHEROFIGHTVALUE"))
      },
      hero_team_gs = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.TOPFIVEFIGHTVALUE"))
      },
      hero_evo_star = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.HEROALLSTAR")),
        iconres = "UI/alpha/HVGA/detail_star.png"
      },
      hero_arousal = {
        vList = self.mylselfVal[mode],
        tipsText = T(LSTR("RANKLIST.WASHATTRIBUTE"))
      }
    }
    local cc = config[mode]
    if cc.vList then
      local record = ed.createNode({
        t = "Label",
        base = {
          text = cc.tipsText,
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(240 + xOffset, 26)
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      }, board)
      local icon
      if cc.iconres then
        icon = ed.createNode({
          t = "Sprite",
          base = {
            res = cc.iconres
          },
          layout = {
            anchor = ccp(0, 0.4),
            position = ed.getRightSidePos(record)
          }
        }, board)
        icon:setScale(0.5)
      end
      local value = ed.createNode({
        t = "Label",
        base = {
          text = ed.formatNumWithComma(cc.vList),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.getRightSidePos(cc.iconres and icon or record)
        },
        config = {
          color = ccc3(255, 234, 198),
		visible=true,
        }
      }, board)
    end
    ed.setNodeAnchor(board, ccp(0.5, 0.5))
    board:setCascadeOpacityEnabled(false)
    pc:setCascadeOpacityEnabled(true)
    pc:setOpacity(0)
    pc:runAction(CCFadeIn:create(0.2))
  end
  return handler
end
class.getInitEDTHandler = getInitEDTHandler
local initListLayer = function(self, mode)
  self:doClearPage()
  local config = {
    pvp = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initpvpItemHandler(),
      list = self.pvpRanklist or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    top_arena = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initTopArenaItemHandler(),
      list = self.superPvpRanklist or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    pvp_r = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initpvpItemHandler(),
      list = self.pvpRanklist_r or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    top_arena_r = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initTopArenaItemHandler(),
      list = self.superPvpRanklist_r or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    guildliveness = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initglItemHandler(),
      list = self.glRankList or {},
      rank = self.glSelfRank.guildliveness,
      summary = self.glSelfSummary.guildliveness,
      value = nil
    },
    excavaterob = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initExcavateRobHandler(),
      list = self.evtRobList or {},
      rank = self.glSelfRank.excavaterob,
      summary = self.glSelfSummary.excavaterob,
      value = self.evtRobValue
    },
    excavatermb = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initExcavateDefendHandler("rmb"),
      list = self.evtrmbList or {},
      rank = self.glSelfRank.excavatermb,
      summary = self.glSelfSummary.excavatermb,
      value = self.evtrmbValue
    },
    excavategold = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initExcavateDefendHandler("gold"),
      list = self.evtGoldList or {},
      rank = self.glSelfRank.excavategold,
      summary = self.glSelfSummary.excavategold,
      value = self.evtGoldValue
    },
    excavateexp = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initExcavateDefendHandler("exp"),
      list = self.evtExpList or {},
      rank = self.glSelfRank.excavateexp,
      summary = self.glSelfSummary.excavateexp,
      value = self.evtExpValue
    },
    top_gs = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initCommonItemHandler("top_gs"),
      list = self.topgsRankList or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    full_hero_gs = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initCommonItemHandler("full_hero_gs"),
      list = self.fullherogsRankList or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    hero_team_gs = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initCommonItemHandler("hero_team_gs"),
      list = self.heroteamRankList or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    hero_evo_star = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initCommonItemHandler("hero_evo_star"),
      list = self.heroevoRankList or {},
      rank = nil,
      summary = nil,
      value = nil
    },
    hero_arousal = {
      extraInitHandler = self:getInitEDTHandler(mode),
      initItemHandler = self:initCommonItemHandler("hero_arousal"),
      list = self.heroarousalRankList or {},
      rank = nil,
      summary = nil,
      value = nil
    }
  }
  local cc = config[mode]
  local extraInitHandler = cc.extraInitHandler
  if extraInitHandler then
    extraInitHandler()
  end
  local info = {
    cliprect = cc.cliprect or CCRectMake(249, 26, 512, 380),
    noshade = true,
    zorder = 10,
    container = self.container,
    priority = -10,
    direction = "v",
    pageSize = CCSizeMake(1, 1),
    oriPosition = cc.oriPosition or ed.DGccp(315, 500 - self.rankListMyselfOffsetY),
    itemSize = ed.DGSizeMake(512, 105),
    initHandler = cc.initItemHandler,
    useBar = true,
    barPosition = "left",
    barLenOffset = -10,
    barPosOffset = ccp(-3, -2),
    barThick = 3,
    heightOffset = 10 + self.rankListMyselfOffsetY,
    doPressIn = self:doScrollViewPressIn(),
    doClickIn = self:doScrollViewClickIn(),
    cancelPressIn = self:cancelScrollViewPressIn(),
    cancelClickIn = self:doScrollViewCancelClickIn(),
    autoClip = true
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollView
  local list = cc.list
  for i, v in ipairs(list) do
    scrollView:push({index = i, data = v})
  end
  if cc.rank and cc.rank > #list then
    scrollView:push({
      index = cc.rank,
      data = cc.summary
    })
  end
end
class.initListLayer = initListLayer
local doClearPage = function(self)
  local pc = self.pageContainer
  if not tolua.isnull(pc) then
    pc:removeFromParentAndCleanup(true)
  end
  self.pageContainer = nil
end
class.doClearPage = doClearPage
local doClearList = function(self)
  local psv = self.scrollView
  psv:destroy()
end
class.doClearList = doClearList
local doPushPage = function(self, idx)
  local k = 1
  if idx < self.index then
    k = 1
  end
  if self.index == idx then
    self.lockTurnPage = nil
    return
  end
  self.index = idx
  local config = self.ranklist_config[self.index]
  local handler = config.initHandler
  handler(self, function()
    local psv = self.scrollView
    psv:setTouchEnabled(false)
    self:initListLayer(config.childMode or config.mode)
    self.scrollView:setTouchEnabled(false)
    local sv = self.scrollView
    sv.draglist.listLayer:setPosition(ed.DGccp(725 * k, 0))
    psv:doMoveLayer(ed.DGccp(-725 * k, 0), function()
      psv:destroy()
    end)
    sv:doMoveLayer(ed.DGccp(0, 0), function()
      self.lockTurnPage = nil
      self.scrollView:setTouchEnabled(true)
    end)
    self:refreshArrow()
  end)
end
class.doPushPage = doPushPage
local pushPreTitle = function(self)
end
class.pushPreTitle = pushPreTitle
local pushNextTitle = function(self)
end
class.pushNextTitle = pushNextTitle
local initTitle = function(self)
  local ui = self.ui
  ui.title = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("RANKLIST.RANKLISTTITLE")),
      size = 24
    },
    layout = {
      position = ed.DGccp(512, 567)
    },
    config = {
      color = ccc3(255, 214, 17)
    }
  }, self.container)
end
class.initTitle = initTitle
local initArrow = function(self)
  local ui = self.ui
  ui.left_arrow:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    CCFadeOut:create(1),
    CCFadeIn:create(1)
  }))
  ui.right_arrow:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    CCFadeOut:create(1),
    CCFadeIn:create(1)
  }))
  self:btRegisterCircleClick({
    center = ed.getCenterPos(ui.left_arrow),
    radius = 50,
    parent = ui.left_arrow,
    pressHandler = function()
      ui.left_arrow:setScale(0.95)
    end,
    cancelPressHandler = function()
      ui.left_arrow:setScale(1)
    end,
    key = "left_arrow",
    force = true,
    clickHandler = function()
    end,
    priority = -10
  })
  self:btRegisterCircleClick({
    center = ed.getCenterPos(ui.right_arrow),
    radius = 50,
    parent = ui.right_arrow,
    pressHandler = function()
      ui.right_arrow:setScale(0.95)
    end,
    cancelPressHandler = function()
      ui.right_arrow:setScale(1)
    end,
    key = "right_arrow",
    force = true,
    clickHandler = function()
    end,
    priority = -10
  })
  local px, py
  self:btRegisterHandler({
    key = "drag_horizontal",
    handler = function(event, x, y)
      if event == "began" then
        px, py = x, y
      elseif event ~= "ended" or not (math.abs(x - px) > math.abs(y - py)) or x - px > 100 then
      elseif x - px < -100 then
      end
    end,
    force = true
  })
  self:refreshArrow()
end
class.initArrow = initArrow
local refreshArrow = function(self)
  local ui = self.ui
  ui.left_arrow:setVisible(false)
  ui.right_arrow:setVisible(false)
end
class.refreshArrow = refreshArrow
local registerOperation = function(self, operation)
  self.operations = self.operations or {}
  table.insert(self.operations, operation)
end
class.registerOperation = registerOperation
local removeOperation = function(self)
  self.operations = self.operations or {}
  if #self.operations > 0 then
    table.remove(self.operations, 1)
  end
end
class.removeOperation = removeOperation
local function doTurnPage(self)
  local function handler()
    if self.lockTurnPage then
      return
    end
    self.operations = self.operations or {}
    local operations = self.operations
    if #operations == 0 then
      return
    end
    local idx = operations[1]
    self:removeOperation()
    if idx >= 1 and idx <= #class.ranklist_config then
      self.lockTurnPage = true
      self:doPushPage(idx)
    end
  end
  return handler
end
class.doTurnPage = doTurnPage
local function reCalculateRankBtnPos(self)
  local leftdown = ccp(120, 100)
  local height = 380
  height = height + 5
  for i = 1, #ranklisttree do
    height = height - 5
    ranklisttree[i].pos = ccp(leftdown.x, height)
    ranklisttree[i].rankBtn[1]:setPosition(ranklisttree[i].pos)
    height = height - 47
    if not ranklisttree[i].collapsed then
      for j = 1, #ranklisttree[i].list do
        ranklisttree[i].list[j].btn[1]:setVisible(true)
        ranklisttree[i].list[j].pos = ccp(leftdown.x, height)
        ranklisttree[i].list[j].btn[1]:setPosition(ranklisttree[i].list[j].pos)
        height = height - 47
      end
      height = height - 5
    else
      for j = 1, #ranklisttree[i].list do
        ranklisttree[i].list[j].btn[1]:setVisible(false)
      end
    end
  end
  if self.initdrag ~= nil then
  end
  self.draglistranksel:initListHeight(math.abs(height - 380))
  self.initdrag = 1
end
class.reCalculateRankBtnPos = reCalculateRankBtnPos
local function getSelectPos(self, totalindex)
  local prelistcnt = 0
  for i = 1, #ranklisttree do
    for j = 1, #ranklisttree[i].list do
      if j == totalindex - prelistcnt then
        ranklisttree[i].collapsed = false
        return i, j, ranklisttree[i].list[j].rankconfig
      end
    end
    ranklisttree[i].collapsed = true
    prelistcnt = prelistcnt + #ranklisttree[i].list
  end
end
class.getSelectPos = getSelectPos
local function create(param)
  param = param or {}
  local self = base.create("ranklist")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  self.container, self.ui = ed.editorui(ed.uieditor.ranklistwindow)
  local container = self.container
  self.mainLayer:addChild(container)
  local node = ed.createSprite("UI/alpha/HVGA/ranklist/ranklist_title_bg.png")
  node:setPosition(ed.DGccp(511, 563))
  self.container:addChild(node, 0)
  self.ui.title_bg = node
  self.glSelfRank = {}
  self.glSelfPrevPos = {}
  self.glSelfSummary = {}
  self.mylselfVal = {}
  self.evtValueList = {}
  self.rankListMyselfOffsetY = 0
	self.guildIcon=nil
  self:createRankSelListLayer()
  local initRankTree = -1
  local initRank = 1
  local ranlistconfigIndex = 1
  initRankTree, initRank, ranlistconfigIndex = self:getSelectPos(param.index)
  for i = 1, #ranklisttree do
    local rankBtn = self:createRankBtn(i, -1, not ranklisttree[i].collapsed, ranklisttree[i])
    ranklisttree[i].rankBtn = rankBtn
    for j = 1, #ranklisttree[i].list do
      local subRankBtn = self:createRankBtn(i, j, i == initRankTree and j == initRank, ranklisttree[i])
      ranklisttree[i].list[j].btn = subRankBtn
    end
  end
  self:reCalculateRankBtnPos()
  self:registerUpdateHandler("turn_page", self:doTurnPage())
  self:registerTouchHandler()
  self:registerOnEnterHandler("enter_ranklist", function()
    self.ranklist_config[ranlistconfigIndex].initHandler(self, function()
      self:initListLayer(self.ranklist_config[ranlistconfigIndex].mode)
    end)
    self.index = ranlistconfigIndex
    self:initArrow()
    self:initTitle()
  end)
  return self
end
class.create = create
local function getRealConfigIndex(self, index, subindex)
  local realConfigIndex = 1
  for i = 1, #ranklisttree do
    for j = 1, #ranklisttree[i].list do
      if i == index and subindex == j then
        return ranklisttree[i].list[subindex].rankconfig
      end
    end
  end
  return realConfigIndex
end
class.getRealConfigIndex = getRealConfigIndex
local switchRankList = function(self, index, subindex)
  local index = self:getRealConfigIndex(index, subindex)
  print("#Switch ranklist:", index)
  self:registerOperation(index)
end
class.switchRankList = switchRankList
local function createRankBtn(self, index, subindex, isselected, rankconfig)
  local position, pc
  if subindex > 0 then
    position = rankconfig.list[subindex].pos
    rankconfig.list[subindex].sel = isselected
  else
    position = rankconfig.pos
  end
  pc = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0)
    }
  }, self.draglistranksel.listLayer)
  pc:setPosition(position)
  local resTbl = {
    rank = {
      sel = {
        normal = "UI/alpha/HVGA/ranklist/ranklist_button_current_1.png",
        press = "UI/alpha/HVGA/ranklist/ranklist_button_current_2.png"
      },
      notsel = {
        normal = "UI/alpha/HVGA/ranklist/ranklist_button_normal_1.png",
        press = "UI/alpha/HVGA/ranklist/ranklist_button_nromal_2.png"
      }
    },
    subrank = {
      sel = {
        normal = "UI/alpha/HVGA/ranklist/ranklist_subbutton_current_1.png",
        press = "UI/alpha/HVGA/ranklist/ranklist_subbutton_current_2.png"
      },
      notsel = {
        normal = "UI/alpha/HVGA/ranklist/ranklist_subbutton_normal_1.png",
        press = "UI/alpha/HVGA/ranklist/ranklist_subbutton_normal_2.png"
      }
    }
  }
  local rankType, selectType
  rankType = subindex > 0 and "subrank" or "rank"
  selectType = isselected and "sel" or "notsel"
  local btncolortree = isselected and ccc3(251, 206, 16) or ccc3(234, 225, 205)
  local btncolortreechild = isselected and ccc3(254, 255, 152) or ccc3(222, 222, 222)
  if not (subindex > 0) or not ccp(8, 0) then
  end
	local Ppoint=nil;
	if subindex==-1 then
		Ppoint=ccp(0,0)
	else
		Ppoint=ccp(8,-5)
	end
  local button = ed.createNode({
    t = "Sprite",
    base = {
      res = resTbl[rankType][selectType].normal
    },
    layout = {
      position = Ppoint
    },
    config = {
      scaleSize = ed.DGSizeMake(173, 75)
    }
  })
  local press = ed.createNode({
    t = "Sprite",
    base = {
      res = resTbl[rankType][selectType].press
    },
    layout = {
      position = ccp(0, 0),
      anchor = ccp(0, 0)
    },
    config = {
      visible = false,
      scaleSize = ed.DGSizeMake(173, 75)
    }
  }, button)
  if not (subindex < 0) or not rankconfig.name then
  end
  if not (subindex > 0) or not ccp(82, 25) then
  end
	local btnText;
	if subindex==-1 then
		btnText=ranklisttree[index].name
	else
		btnText=class.ranklist_config[rankconfig.list[subindex].rankconfig].name
	end
  local label = ed.createNode({
    t = "Label",
    base = {
      text = btnText,
      size = 18
    },
    layout = {
      position = ccp(83, 25)
    },
    config = {
      color = subindex > 0 and btncolortreechild or btncolortree,
      shadow = {
        color = ccc3(42, 31, 22),
        offset = ccp(0, 2)
      }
    }
  }, button)
  pc:addChild(button)
  label:setScale(math.min(1, 150 / label:getContentSize().width))
	LegendLog("-----------btRegisterButtonClick index is "..index.."  subindex is "..subindex)
  self:btRegisterButtonClick({
    button = button,
    press = press,
    key = "mode_" .. tostring(index) .. tostring(subindex),
    clickHandler = function()
      for i = 1, #ranklisttree do
        if i == index and subindex > 0 then
          for j = 1, #ranklisttree[i].list do
            if subindex == j then
              for m = 1, #ranklisttree do
                for n = 1, #ranklisttree[m].list do
                  if ranklisttree[m].list[n].sel then
                    ranklisttree[m].list[n].btn[1]:removeFromParentAndCleanup(true)
                    ranklisttree[m].list[n].btn = self:createRankBtn(m, n, false, ranklisttree[m])
                  end
                end
              end
              ranklisttree[i].list[j].btn[1]:removeFromParentAndCleanup(true)
              ranklisttree[i].list[j].btn = self:createRankBtn(i, j, true, ranklisttree[i])
            end
          end
        elseif index == i then
          ranklisttree[i].collapsed = not ranklisttree[i].collapsed
          ranklisttree[i].rankBtn[1]:removeFromParentAndCleanup(true)
          ranklisttree[i].rankBtn = self:createRankBtn(i, -1, not ranklisttree[i].collapsed, ranklisttree[i])
          if ranklisttree[i].collapsed then
            for n = 1, #ranklisttree[i].list do
              if ranklisttree[i].list[n].sel then
                ranklisttree[i].list[n].btn[1]:removeFromParentAndCleanup(true)
                ranklisttree[i].list[n].btn = self:createRankBtn(i, n, false, ranklisttree[i])
              end
            end
          end
        else
          ranklisttree[i].collapsed = true
          ranklisttree[i].rankBtn[1]:removeFromParentAndCleanup(true)
          ranklisttree[i].rankBtn = self:createRankBtn(i, -1, not ranklisttree[i].collapsed, ranklisttree[i])
          for n = 1, #ranklisttree[i].list do
            if ranklisttree[i].list[n].sel then
              ranklisttree[i].list[n].btn[1]:removeFromParentAndCleanup(true)
              ranklisttree[i].list[n].btn = self:createRankBtn(i, n, false, ranklisttree[i])
            end
          end
        end
      end
      self:reCalculateRankBtnPos()
      if subindex > 0 then
        self:switchRankList(index, subindex)
      else
        self:switchRankList(index, 1)
        ranklisttree[index].list[1].btn[1]:removeFromParentAndCleanup(true)
        ranklisttree[index].list[1].btn = self:createRankBtn(index, 1, true, ranklisttree[index])
        ranklisttree[index].list[1].btn[1]:setVisible(not ranklisttree[index].collapsed)
      end
    end,
    force = true,
    clickInterval = 0.3
  })
  return {
    pc,
    button,
    press,
    label
  }
end
class.createRankBtn = createRankBtn
local createRankSelListLayer = function(self)
  local param = {
    cliprect = CCRectMake(50, 26, 210, 380),
    noshade = true,
    container = self.mainLayer,
    zorder = 99,
    priority = -135,
    doClickIn = self:doClickIn(),
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressIn()
  }
  local draglist = ed.draglist.create(param)
  self.draglistranksel = draglist
end
class.createRankSelListLayer = createRankSelListLayer
local doClickIn = function(self)
  local handler = function(x, y, id, parm)
    print(x, y, id, parm)
    return 1
  end
  return handler
end
class.doClickIn = doClickIn
local doPressIn = function(self)
  local handler = function(x, y)
    print("doPressIn;")
    return 1
  end
  return handler
end
class.doPressIn = doPressIn
local cancelPressIn = function(self)
  local handler = function(x, y, id)
    print("cancelPressIn;")
  end
  return handler
end
class.cancelPressIn = cancelPressIn
local doScrollViewClickIn = function(self)
  local handler = function(x, y, id, parm)
    return 1
  end
  return handler
end
class.doScrollViewClickIn = doScrollViewClickIn
local doScrollViewCancelClickIn = function(self)
  local handler = function(x, y)
    return 1
  end
  return handler
end
class.doScrollViewCancelClickIn = doScrollViewCancelClickIn
local doScrollViewPressIn = function(self)
  local function handler(x, y, id)
    if self.pageContainer then
      self.pageContainer:stopAllActions()
      self.pageContainer:runAction(CCFadeTo:create(0.2, 128))
    end
    return 1
  end
  return handler
end
class.doScrollViewPressIn = doScrollViewPressIn
local cancelScrollViewPressIn = function(self)
  local function handler(x, y, id)
    if self.pageContainer then
      self.pageContainer:stopAllActions()
      self.pageContainer:runAction(CCFadeTo:create(0.2, 255))
    end
  end
  return handler
end
class.cancelScrollViewPressIn = cancelScrollViewPressIn

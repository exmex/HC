local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.dailylogin = class
local explain_text = T(LSTR("DAILYLOGIN.\N_PARTICIPATE_IN_MONTHLY_ATTENDANCE_TO_RECEIVE_CORRESPONDING_REWARDS \N\N_IN_PARTICULAR_DAYS_PLAYERS_AT_REQUIRED_VIP_LEVELS_CAN_RECEIVE_DOUBLE_REWARDS YOU_CAN_UPGRAD_VIP_LEVEL_AND_CLAIM_THE_REPLACEMENT_IN_THE_SAME_DAY \N_\N_NOTE__DAILY_ATTENDANCE_REWARDS_RESET_AT_05_00_THE_NEXT_DAY_EXPIRED_REWARDS_CAN_NOT_BE_CLAIMED_THE_NEXT_DAY \N_\N"))
local function getDate()
  local time = ed.serverTime2China()
  local date = ed.getYMDHMS(time)
  local d = tonumber(date.day)
  local h = tonumber(date.hour)
  local m = tonumber(date.minute)
  local s = tonumber(date.second)
  if d == 1 then
    local boa = ed.checkBOA({
      h = h,
      m = m,
      s = s
    })
    if boa == "after" then
    elseif boa == "before" then
      date = ed.getYMDHMS(time - 86400)
    end
  end
  local y = tonumber(date.year)
  local m = tonumber(date.month)
  local d = tonumber(date.day)
  return {
    y = y,
    m = m,
    d = d
  }
end
class.getDate = getDate
ed.getDate = getDate
local function getRewardAt(i)
  local date = getDate()
  local y, m, d  = date.y, date.m, (i or date.d)
  local row = ed.getDataTable("DailyLoginReward")[y][m][d]
  if not row then
    return
  end
  local type = row["Reward Type"]
  local id = row["Reward ID"]
  local amount = row["Reward Amount"]
  local vip = row["Double Reward VIP Level"] or 0
  return {
    type = type,
    id = id,
    amount = amount,
    vip = vip
  }
end
class.getRewardAt = getRewardAt
local function doDailyReward(rewardType, reward)
  local frq = ed.player:getLoginFrequency()
  local rw = getRewardAt(frq)
  local heroAmount = 1
  local stoneAmount = 1
  local hero2Stoneid
  if rw.type == "Hero" then
    hero2Stoneid = ed.readhero.getStoneid(rw.id)
  end
  local amount = rw.amount
  if rw.vip > 0 and rewardType == "all" then
    amount = amount * 2
  end
  local items = reward.items or {}
  local heroes = reward.heroes or {}
  local diamond = reward.diamond or 0
  for i, v in pairs(heroes) do
    ed.player:addHero(v._tid)
  end
  for i, v in pairs(items) do
    local item = ed.analyzeItem(v)
    local id = item.id
    local amount = item.amount
    ed.player:addEquip(id, amount)
    if id == hero2Stoneid then
      stoneAmount = amount
    end
  end
  ed.player:addrmb(diamond)
  if rw.type == "Hero" then
    heroAmount = stoneAmount
    for i, v in pairs(heroes) do
      if rw.id == v._tid then
        heroAmount = 1
      end
    end
  end
  class.createRewardWindow(rewardType, heroAmount)
end
class.doDailyReward = doDailyReward
local function getMonthDayAmount(self)
  local date = getDate()
  local y, m = date.y, date.m
  local dt = ed.getDataTable("DailyLoginReward")[y][m]
  local index = 1
  while dt[index] and dt[index]["Reward Type"] do
    index = index + 1
  end
  return index - 1
end
class.getMonthDayAmount = getMonthDayAmount
local function checkHasDouble()
  local frq = ed.player:getLoginFrequency()
  local row = getRewardAt(frq)
  local vip = row.vip
  if vip > 0 then
    return true
  end
  return false
end
class.checkHasDouble = checkHasDouble
local function getRewardStatus(self, i)
  local frq = ed.player:getLoginFrequency()
  local status = ed.player:getLoginRewardStatus()
  if i < frq then
    return "past"
  elseif frq == i then
    if status == "received" then
      return "past"
    elseif status == "common" then
      return "common"
    elseif status == "vip" then
      return "vip"
    end
  else
    return "future"
  end
end
class.getRewardStatus = getRewardStatus
local function getCheckinNumber(self)
  local frq = ed.player:getLoginFrequency()
  local status = self:getRewardStatus(frq)
  if status ~= "common" then
    return frq
  else
    return frq - 1
  end
end
class.getCheckinNumber = getCheckinNumber
local function getRewardData(self)
  local icon_res = {
    PlayerEXP = "UI/alpha/HVGA/task_exp_icon.png",
    Diamond = "UI/alpha/HVGA/task_rmb_icon.png",
    Gold = "UI/alpha/HVGA/task_gold_icon.png"
  }
  local da = self:getMonthDayAmount()
  self.data = {}
  for i = 1, da do
    local row = getRewardAt(i)
    if row then
      local type = row.type
      local id = row.id
      local amount = row.amount
      local vip = row.vip
      local frameres, iconres
      frameres = ed.readequip.getShapeFrameRes(id)
      if ed.isElementInTable(type, {"Item", "Hero"}) then
      else
        iconres = icon_res[type]
      end
      local d = {
        type = type,
        id = id,
        amount = amount,
        vip = vip,
        frameres = frameres,
        iconres = iconres
      }
      self.data[i] = d
    end
  end
end
class.getRewardData = getRewardData
local beginRefreshCliprect = function(self)
  self.baseScene:registerUpdateHandler("refreshCliprect", self:refreshCliprect())
end
class.beginRefreshCliprect = beginRefreshCliprect
local endRefreshCliprect = function(self)
  self.baseScene:removeUpdateHandler("refreshCliprect")
end
class.endRefreshCliprect = endRefreshCliprect
local refreshCliprect = function(self)
  local function handler()
    if tolua.isnull(self.container) then
      self:endRefreshCliprect()
      return
    end
    self.draglist:refreshClipRect(self.container:getScale())
  end
  return handler
end
class.refreshCliprect = refreshCliprect
local function createvipTag(self, vip, times)
  vip = vip or 0
  times = times or T(LSTR("DAILYLOGIN.DOUBLE"))
  if vip <= 0 then
    return
  end
  local container = CCSprite:create()
  local pre = ed.createSprite(string.format("UI/alpha/HVGA/dailylogin/dailylogin_vip_%d.png", vip))
  pre:setAnchorPoint(ccp(0, 0.5))
  local height = pre:getContentSize().height
  ed.scaleNodeBySideLen(pre, height)
  local width = ed.sumNodeSize({pre})
  container:setContentSize(CCSizeMake(width, height))
  pre:setPosition(ccp(0, height / 2))
  container:addChild(pre)
  container:setPosition(ccp(0, 0))
  container:setRotation(-45)
  return container
end
class.createvipTag = createvipTag
local function createRewardItem(self, i)
  local frq = ed.player:getLoginFrequency()
  local status = ed.player:getLoginRewardStatus()
  local container = self.listContainer
  local rewards = self.rewards
  local rc = (rewards[i] or {}).container
  if not tolua.isnull(rc) then
    rc:removeFromParentAndCleanup(true)
  end
  local ox, oy = 140, 372
  local ox, oy = ox + 58, oy - 56
  local dx, dy = 103, 101
  local data = self.data[i]
  rewards[i] = {}
  local rc = CCSprite:create()
  if not tolua.isnull(container) then
    container:addChild(rc)
  end
  rewards[i].container = rc
  local x = (i - 1) % 5
  local y = math.floor((i - 1) / 5)
  local px, py = ox + dx * x, oy - dy * y
  local readnode = ed.readnode.create(rc, rewards[i])
  local bres = "UI/alpha/HVGA/dailylogin/dailylogin_matrix.png"
  if frq == i then
    if status == "vip" then
      bres = "UI/alpha/HVGA/dailylogin/dailylogin_matrix_purple.png"
    elseif status == "common" then
      bres = "UI/alpha/HVGA/dailylogin/dailylogin_matrix_yellow.png"
    end
  else
  end
  local ui_info = {
    {
      t = "Sprite",
      base = {name = "board", res = bres},
      layout = {
        position = ccp(px, py)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = data.frameres,
        parent = "board"
      },
      layout = {
        position = ccp(51, 50)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  if not (i <= frq) or i == frq and status ~= "received" then
  else
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "get_tag",
          res = "UI/alpha/HVGA/dailylogin/dailylogin_checked.png",
          z = 10
        },
        layout = {
          position = ccp(px, py)
        },
        config = {}
      }
    }
    readnode:addNode(ui_info)
  end
  local board = rewards[i].board
  readnode = ed.readnode.create(board, rewards[i])
  if data.type == "Hero" and (i > frq or frq == i and status == "vip") then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "light",
          res = "UI/alpha/HVGA/tavern_get_item_bg_light_orange.png"
        },
        layout = {
          position = ccp(51, 50)
        },
        config = {}
      }
    }
    readnode:addNode(ui_info)
    local light = rewards[i].light
    local r = CCRotateBy:create(5, 360)
    r = CCRepeatForever:create(r)
    light:runAction(r)
  end
  local icon
  if ed.isElementInTable(data.type, {"Item", "Hero"}) then
    if data.id > 0 then
      icon = ed.readequip.createIcon(data.id)
    else
      icon = CCSprite:create()
    end
  else
    local ires = data.iconres
    if ires then
      icon = ed.createSprite(ires)
    end
  end
  if icon then
    icon:setPosition(ccp(51, 52))
    board:addChild(icon)
    rewards[i].icon = icon
  end
  local vipTag = self:createvipTag(data.vip)
  if vipTag then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "vip_bg",
          res = "UI/alpha/HVGA/dailylogin/dailylogin_vip_bg.png"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(0, 102)
        },
        config = {}
      }
    }
    readnode:addNode(ui_info)
    vipTag:setPosition(ccp(24, 80))
    board:addChild(vipTag)
    rewards[i].vipTag = vipTag
  end
  ui_info = {
    {
      t = "Label",
      base = {
        name = "amount",
        text = string.format("x%d", data.amount or 1),
        size = 24
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(92, 22)
      },
      config = {
        stroke = {
          color = ccc3(95, 64, 43),
          size = 2
        }
      }
    }
  }
  readnode:addNode(ui_info)
  rewards[i].data = data
end
class.createRewardItem = createRewardItem
local function createList(self)
  self:getRewardData()
  local container = CCLayer:create()
  self.listContainer = container
  self.draglist:addItem(container)
  local ui = {}
  self.listui = ui
  local da = self:getMonthDayAmount()
  local wlen = 103
  local hlen = 101
  local wa = 5
  local ha = math.ceil(da / 5)
  local ox, oy = 140, 372
  local w = wlen * wa + 12
  local h = hlen * ha + 14
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "board",
        res = "UI/alpha/HVGA/dailylogin/dailylogin_reward_bg.png",
        capInsets = CCRectMake(15, 15, 24, 25)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(ox, oy)
      },
      config = {
        scaleSize = CCSizeMake(w, h)
      }
    }
  }
  readnode:addNode(ui_info)
  self.draglist:initListHeight(h)
  local rewards = {}
  self.rewards = rewards
  for i = 1, da do
    self:createRewardItem(i)
  end
end
class.createList = createList
local function createRewardDetail(self, reward, param)
  self:destroyRewardDetail()
  param = param or {}
  local index = param.index
  local data = reward.data
  local type = data.type
  local id = data.id
  local container = CCLayer:create()
  self.rdContainer = container
  container:setTouchEnabled(true)
  container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        self:destroyRewardDetail()
      end
    end, EDDebug)
    return true
  end, false, -165, true)
  self.mainLayer:addChild(container)
  local icon = reward.icon
  local pos = ccp(400, 240)
  local did = id
  if type == "Diamond" then
    did = type
  end
  local panel = ed.readequip.getDetailCard(did, {
    ps = T(LSTR("DAILYLOGIN.RECEIVE_THIS_AWARD_AT__D_ATTENDANCE_THIS_MONTH"), index)
  }, {
    noArrow = true,
    anchor = ccp(0.5, 0.5)
  })
  panel:setPosition(pos)
  container:addChild(panel, 50)
  self.rdPanel = panel
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  container:runAction(s)
end
class.createRewardDetail = createRewardDetail
local function createPrompt(self, param)
  if not param then
    return
  end
  local text = param.text or ""
  local ps = param.ps
  local pos = param.pos
  local container = param.container
  local ox, oy = pos.x, pos.y
  local width = 300
  local panel = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  panel:setPosition(pos)
  container:addChild(panel)
  self.rdPanel = panel
  local lh = 15
  if ps then
    local psLabel = ed.createttf(ps, 18)
    ed.setLabelDimensions(psLabel, CCSizeMake(270, 0))
    psLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    ed.setLabelColor(psLabel, ccc3(255, 204, 91))
    local height = psLabel:getContentSize().height
    psLabel:setAnchorPoint(ccp(0, 0))
    psLabel:setPosition(ccp(15, lh))
    panel:addChild(psLabel)
    lh = lh + height + 10
  end
  local label = ed.createttf(text, 18)
  label:setAnchorPoint(ccp(0, 0))
  ed.setLabelDimensions(label, CCSizeMake(270, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setPosition(ccp(15, lh))
  local height = label:getContentSize().height
  lh = lh + height + 10
  height = math.max(lh, 40)
  panel:addChild(label)
  panel:setContentSize(CCSizeMake(width, height))
end
class.createPrompt = createPrompt
local destroyRewardDetail = function(self)
  if not tolua.isnull(self.rdContainer) then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.rdContainer:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, func)
    self.rdContainer:runAction(s)
  end
end
class.destroyRewardDetail = destroyRewardDetail
local function doPressIn(self)
  local function handler(x, y)
    local rs = self.rewards
    for i = 1, #(rs or {}) do
      local r = rs[i]
      local icon = r.icon
      local board = r.board
      if ed.containsPoint(board, x, y) then
        icon:setScale(0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressIn = doPressIn
local cancelPressIn = function(self)
  local function handler(x, y, id)
    local rs = self.rewards
    local r = rs[id]
    local icon = r.icon
    icon:setScale(1)
  end
  return handler
end
class.cancelPressIn = cancelPressIn
local function askRewardReply(self, id, type)
  local function handler(result, reward)
    xpcall(function()
      if result then
        doDailyReward(type, reward)
        self:createRewardItem(id)
        self:refreshSubhead()
      else
        ed.toast.showToast(T(LSTR("DAILYLOGIN.FAILED_TO_RECEIVE")))
      end
    end, EDDebug)
  end
  return handler
end
class.askRewardReply = askRewardReply
local function askCommonReward(self, id)
  local frq = ed.player:getLoginFrequency()
  local row = getRewardAt(frq)
  if not row then
    return
  end
  local vip = row.vip
  local pv = ed.player:getvip()
  local msg = ed.upmsg.ask_daily_login()
  if vip <= pv then
    local type = "all"
    if not checkHasDouble() then
      type = "common"
      msg._status = 2
    else
      msg._status = 1
    end
    ed.netreply.dailylogin = self:askRewardReply(id, type)
    ed.netdata.dailylogin = {type = "all"}
  else
    ed.netreply.dailylogin = self:askRewardReply(id, "common")
    ed.netdata.dailylogin = {type = "common"}
    msg._status = 2
  end
  ed.send(msg, "ask_daily_login")
end
class.askCommonReward = askCommonReward
local function askvipReward(self, id)
  local frq = ed.player:getLoginFrequency()
  local row = getRewardAt(frq)
  if not row then
    return
  end
  local vip = row.vip
  local pv = ed.player:getvip()
  if vip <= pv then
    ed.netdata.dailylogin = {type = "vip"}
    ed.netreply.dailylogin = self:askRewardReply(id, "vip")
    local msg = ed.upmsg.ask_daily_login()
    msg._status = 3
    ed.send(msg, "ask_daily_login")
  else
    ed.showHandyDialog("toRecharge", {
      explaination = T(LSTR("DAILYLOGIN.TODAYS_ATTENDANCE_AWARDS_HAVE_BEEN_RECEIVED \N_UPGRADE_TO_VIP__D_CAN_RECEIVE_DOUBLE_REWARD_UPGRADE_NOW"), vip)
    })
  end
end
class.askvipReward = askvipReward
local function doClickIn(self)
  local function handler(x, y, id)
    local rs = self.rewards
    local r = rs[id]
    local icon = r.icon
    local board = r.board
    icon:setScale(1)
    if ed.containsPoint(board, x, y) then
      local status = self:getRewardStatus(id)
      if ed.isElementInTable(status, {"past", "future"}) then
        self:createRewardDetail(r, {index = id})
      elseif status == "common" then
        self:askCommonReward(id)
      elseif status == "vip" then
        self:askvipReward(id)
      end
    end
  end
  return handler
end
class.doClickIn = doClickIn
local cancelClickIn = function(self)
  local function handler(x, y, id)
    local rs = self.rewards
    local r = rs[id]
    local icon = r.icon
    icon:setScale(1)
  end
  return handler
end
class.cancelClickIn = cancelClickIn
local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(0, 40, 800, 335),
    rect = CCRectMake(140, 40, 520, 335),
    container = self.container,
    zorder = 10,
    priority = -165,
    bar = {
      bglen = 320,
      bgpos = ccp(130, 205)
    },
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressIn(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelClickIn()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local function createSubhead(self)
  local subhead = CCSprite:create()
  local ui = {}
  self.subheadui = ui
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "subhead_pre",
        text = T(LSTR("DAILYLOGIN.THIS_MONTH_HAS_A_TOTAL_ATTENDANCE")),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 10)
      },
      config = {
        color = ccc3(238, 204, 119)
      }
    },
    {
      t = "Label",
      base = {
        name = "subhead",
        text = self:getCheckinNumber(),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {
          array = ui,
          name = "subhead_pre",
          offset = 5
        }
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Label",
      base = {
        name = "subhead_suffix",
        text = T(LSTR("DAILYLOGIN.TIMES")),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {
          array = ui,
          name = "subhead",
          offset = 5
        }
      },
      config = {
        color = ccc3(255, 204, 91)
      }
    }
  }
  local readnode = ed.readnode.create(subhead, ui)
  readnode:addNode(ui_info)
  local w, h = ed.sumNodeSize(ui)
  subhead:setContentSize(CCSizeMake(w + 10, 20))
  self.container:addChild(subhead)
  subhead:setPosition(ccp(400, 386))
  self.ui.subheadContainer = subhead
end
class.createSubhead = createSubhead
local function refreshSubhead(self)
  local ui = self.subheadui
  local number = ui.subhead
  ed.setString(number, self:getCheckinNumber())
  ed.setNodeAnchor(number, ccp(0.5, 0.5))
  local sb = CCScaleTo:create(0.2, 1.5)
  sb = CCEaseSineOut:create(sb)
  local sl = CCScaleTo:create(0.2, 1)
  sl = CCEaseSineIn:create(sl)
  local s = CCSequence:createWithTwoActions(sb, sl)
  number:runAction(s)
end
class.refreshSubhead = refreshSubhead
local function create(param)
  local self = {}
  setmetatable(self, class.mt)
  param = param or {}
  local callback = param.callback
  self.callback = callback
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  self.baseScene = ed.getCurrentScene()
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/dailylogin/dailylogin_frame.png",
        capInsets = CCRectMake(50, 50, 478, 50)
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {
        scaleSize = CCSizeMake(578, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/crusade_title_short_bg.png",
        --z = 30
      },
      layout = {
        position = ccp(400, 441)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(675, 440)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/act/act_popup_bg.png"
      },
      layout = {
        position = ccp(400, 420)
      },
      config = {
        fix_size = CCSizeMake(0, 35)
      }
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = "",
        size = 18
      },
      layout = {
        position = ccp(400, 444)
      },
      config = {
        color = ccc3(231, 206, 19)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "explain",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 88, 19)
      },
      layout = {
        position = ccp(190, 400)
      },
      config = {
        scaleSize = CCSizeMake(105, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "explain_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 88, 19),
        parent = "explain"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(105, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "explain_label",
        text = T(LSTR("DAILYLOGIN.AWARDS_DESCRIPTION")),
        fontinfo = "ui_normal_button",
        size = 18,
        parent = "explain"
      },
      layout = {
        position = ccp(53, 24)
      },
      config = {
        color = ccc3(225, 209, 186)
      }
    }
  }
  readnode:addNode(ui_info)
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -160, true)
  self.mainLayer:registerScriptHandler(self:eeHandler())
  self:createSubhead()
  self:createListLayer()
  self:show()
  
  ed.pop_dailylogin=self
  
  return self
end
class.create = create
local function syncDate(self)
  function ed.netreply.syncTime()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        ed.setString(self.ui.title, T(LSTR("DAILYLOGIN._D_MONTHLY_ATTENDANCE_AWARDS"), T(LSTR("DAILYLOGIN.DAILYLOGIN_MONTH_"..os.date("%m", os.time({year=2014, month=getDate().m, day=1, hour=1,min=0,sec=0})))))  )
        self:createList()
      end
    end, EDDebug)
  end
  local msg = ed.upmsg.get_svr_time()
  ed.send(msg, "get_svr_time")
end
class.syncDate = syncDate
local enterDailyLogin = function(self)
  self:syncDate()
end
class.enterDailyLogin = enterDailyLogin
local eeHandler = function(self)
  local handler = function(event)
    xpcall(function()
      if event == "enter" then
      end
    end, EDDeug)
  end
  return handler
end
class.eeHandler = eeHandler
local show = function(self)
  self:enterDailyLogin()
end
class.show = show
local destroy = function(self)
  self.mainLayer:removeFromParentAndCleanup(true)
  if self.callback then
    self.callback()
  end
end
class.destroy = destroy
local function doOutLayerTouch(self)
  local isPress
  local frame = self.ui.frame
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(frame, x, y) then
        isPress = true
      end
    elseif event == "ended" and isPress and not ed.containsPoint(frame, x, y) then
      self:destroy()
    end
  end
  return handler
end
class.doOutLayerTouch = doOutLayerTouch
local function doCloseTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.close
  local press = ui.close_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCloseTouch = doCloseTouch
local function createExplain(self)
  self:destroyExplain()
  local container = CCLayer:create()
  self.explainContainer = container
  container:setTouchEnabled(true)
  container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        self:destroyExplain()
      end
    end, EDDebug)
    return true
  end, false, -165, true)
  self.mainLayer:addChild(container, 50)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
--[[  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(10, 10, 58, 26)
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "label",
        text = explain_text,
        fontinfo = "dark_yellow"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {
        dimension = CCSizeMake(360, 0),
        horizontalAlignment = kCCTextAlignmentLeft
      }
    }
  }
  readnode:addNode(ui_info)
  local label = ui.label
  local frame = ui.frame
  local size = label:getContentSize()
  frame:setContentSize(CCSizeMake(410, 210))
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  container:runAction(s)--]]
	local param={content=explain_text,title=" "}
	local continuechargedialog = ed.ui.continuechargedialog.create(param)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(continuechargedialog.mainLayer, 101000,43267)
	end
end
class.createExplain = createExplain
local destroyExplain = function(self)
  if not tolua.isnull(self.explainContainer) then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.explainContainer:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.explainContainer:runAction(s)
  end
end
class.destroyExplain = destroyExplain
local doClickExplain = function(self)
  self:createExplain()
end
class.doClickExpalin = doClickExplain
local function doExplainTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.explain
  local press = ui.explain_press
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:doClickExpalin()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doExplainTouch = doExplainTouch
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local outLayerTouch = self:doOutLayerTouch()
  local explainTouch = self:doExplainTouch()
  local function handler(event, x, y)
    xpcall(function()
      closeTouch(event, x, y)
      explainTouch(event, x, y)
      outLayerTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
function class.createRewardWindow(rewardType, heroAmount)
  local frq = ed.player:getLoginFrequency()
  local row = getRewardAt(frq)
  local type = row.type
  local id = row.id
  local amount = row.amount
  local vip = row.vip
  local displayAmount
  if type == "Hero" then
    displayAmount = amount
    amount = heroAmount
  end
  local items
  if rewardType == "all" then
    items = {
      {
        explain = T(LSTR("DAILYLOGIN.REWARDED_"))
      },
      {
        type = type,
        id = id,
        amount = amount,
        displayAmount = displayAmount
      }
    }
    table.insert(items, {
      explain = T(LSTR("DAILYLOGIN.VIP_REWARDS_"))
    })
    table.insert(items, {
      type = type,
      id = id,
      amount = amount,
      displayAmount = displayAmount
    })
  elseif rewardType == "common" then
    items = {
      {
        explain = T(LSTR("DAILYLOGIN.REWARDED"))
      },
      {
        type = type,
        id = id,
        amount = amount,
        displayAmount = displayAmount
      }
    }
    if checkHasDouble() then
      table.insert(items, {
        explain = T(LSTR("DAILYLOGIN.VIP_D_CAN_RECEIVE_DOUBLE_REWARD"), vip),
        offsety = 20
      })
    end
  elseif rewardType == "vip" then
    items = {
      {
        explain = T(LSTR("DAILYLOGIN.VIP_REWARDS_"))
      },
      {
        type = type,
        id = id,
        amount = amount,
        displayAmount = displayAmount
      }
    }
  end
  local titleNode, titleText
  if ed.isElementInTable(rewardType, {"all", "vip"}) then
    local label = ed.createttf(string.format("VIP%d ", vip), 18)
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
    ed.setLabelColor(label, ccc3(231, 206, 19))
    local text = ""
    if rewardType == "all" then
      text = T(LSTR("DAILYLOGIN.EARN_DOUBLE_AWARD"))
    else
      text = T(LSTR("DAILYLOGIN.ADDITIONAL_INCENTIVES"))
    end
    local lt = ed.createttf(text, 18)
    ed.setLabelShadow(lt, ccc3(0, 0, 0), ccp(0, 2))
    titleNode = ed.horizontalArrange({label, lt})
  elseif rewardType == "common" then
    titleText = T(LSTR("DAILYLOGIN.REWARDED"))
  end
  local callback
  if type == "Hero" then
    function callback()
    end
  end
  ed.announce({
    type = "getProp",
    param = {
      titleNode = titleNode,
      title = titleText,
      callback = callback,
      items = items
    }
  })
end

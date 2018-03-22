local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.basetask = class
local lsr = ed.ui.tasklsr.create()
local icon_res = {
  Coin = "UI/alpha/HVGA/task_gold_icon.png",
  Diamond = "UI/alpha/HVGA/task_rmb_icon.png",
  Vitality = "UI/alpha/HVGA/task_vit_icon.png",
  PlayerEXP = "UI/alpha/HVGA/task_exp_icon.png",
  GuildCoin = "UI/alpha/HVGA/money_guildtoken_small.png"
}
local reward_icon_res = {
  Coin = "UI/alpha/HVGA/task_gold_icon_2.png",
  Diamond = "UI/alpha/HVGA/task_rmb_icon_2.png",
  Vitality = "UI/alpha/HVGA/task_vit_icon_2.png",
  PlayerEXP = "UI/alpha/HVGA/task_exp_icon_2.png",
  GuildCoin = "UI/alpha/HVGA/money_guildtoken_small.png"
}
local function checkdbTrigger(id)
  local tdt = ed.getDataTable("Todolist")
  local tdrow = tdt[id]
  if not tdrow then
    return
  end
  local tg = tdrow["Trigger ID"]
  local ids = {}
  tg = tg or {}
  if #tg < 1 then
    return true
  end
  for k, v in pairs(tg) do
    if v > 0 then
      table.insert(ids, v)
    end
  end
  local tt = ed.getDataTable("TodoTriggers")
  for k, v in pairs(ids or {}) do
    local type = tt[v]["Trigger Type"]
    local value = tt[v]["Trigger Condition"]
    if type == "VIPLevel" then
      if value > ed.player:getvip() then
        return false
      end
    elseif type == "VIPLevelLessThan" then
      if value <= ed.player:getvip() then
        return false
      end
    elseif type == "DailyTimeAfter" then
      if not ed.isTimeAfter(value) then
        return false
      end
    elseif type == "DailyTimeBefore" then
      if not ed.isTimeBefore(value) then
        return false
      end
    elseif type == "PlayerLevel" then
      if value > ed.player:getLevel() then
        return false
      end
    elseif type == "VIPLevelEqual" and ed.player:getvip() ~= value then
      return false
    end
  end
  return true
end
class.checkdbTrigger = checkdbTrigger
ed.checkDailyjobTrigger = checkdbTrigger
local function checkDailyjobDisplay(id)
  local row = ed.getDataTable("Todolist")[id]
  if not row then
    return false
  end
  local dts = row["Display Time"]
  if #(dts or {}) == 0 then
    return false
  else
    return ed.checkTimeBetween({rangeString = dts})
  end
  return false
end
class.checkDailyjobDisplay = checkDailyjobDisplay
ed.checkDailyjobDisplay = checkDailyjobDisplay
local function getItemName(type, id)
  if type == "Coin" then
    return T(LSTR("TASK.GOLD"))
  elseif type == "Diamond" then
    return T(LSTR("RECHARGE.DIAMOND"))
  elseif type == "Vitality" then
    return T(LSTR("TASK.ENERGY"))
  elseif type == "Item" then
    local it = ed.getDataTable("equip")
    local name = it[id].Name
    return name
  elseif type == "GuildCoin" then
    return LSTR("Privilege.1.10.1.003")
  end
end
class.getItemName = getItemName
local function doTaskConsume(info)
  local is = info.isConsume
  local type = info.consumeType
  local id = info.consumeID
  local amount = info.consumeAmount
  if not is then
    return
  end
  if type == "Coin" then
    ed.player:addMoney(-amount)
  elseif type == "Vitality" then
  elseif type == "Diamond" then
  elseif type == "Item" then
    ed.player.equip_qunty[id] = ed.player.equip_qunty[id] - amount
  end
end
class.doTaskConsume = doTaskConsume
local function doTaskReward(info)
  local reward = info.reward
  for i = 1, #(reward or {}) do
    local r = reward[i]
    local type = r.type
    local id = r.id
    local amount = r.amount or 0
    if type == "Coin" then
      ed.player:addMoney(amount)
    elseif type == "Vitality" then
      ed.player:addVitality(amount)
    elseif type == "Diamond" then
      ed.player._rmb = ed.player._rmb + amount
    elseif type == "Item" then
      ed.player:addEquip(id, amount)
    elseif type == "GuildCoin" then
      ed.player:addGuildMoney(amount)
    elseif type == "PlayerEXP" then
      local preLevel = ed.player:getLevel()
      ed.player:addExp(amount, "task")
      local level = ed.player:getLevel()
      if preLevel < level then
        ed.announce({
          type = "playerLevelup",
          param = {preLevel = preLevel}
        })
      end
    end
  end
end
class.doTaskReward = doTaskReward
local function getCount(info)
  local chain = info.chain
  local id = info.id
  local pid = info.pid
  local type = info.type
  local target = info.target
  local count = info.count or 0
  local lastTime = info.lastTime
  local limit = info.limit or "login"
  if type == "CompleteStage" then
    for k, v in pairs(pid) do
      if v ~= 0 and 0 < ed.player:getStageStar(v) then
        return target
      end
    end
  elseif type == "KillMonster" then
    return ed.player:getTaskCount(chain, id)
  elseif type == "ItemQuantity" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return ed.player.equip_qunty[v] or 0
      end
    end
  elseif type == "PlayerLevel" then
    return ed.player:getLevel() or 0
  elseif type == "HeroLevel" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return (ed.player.heroes[v] or {})._level or 0
      end
    end
  elseif type == "HeroRank" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return (ed.player.heroes[v] or {})._rank or 0
      end
    end
  elseif type == "MultiHeroRank" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        local index = 0
        for id, hero in pairs(ed.player.heroes) do
          if v <= hero._rank then
            index = index + 1
          end
        end
        return index
      end
    end
  elseif type == "MultiHeroLevel" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        local index = 0
        for id, hero in pairs(ed.player.heroes) do
          if v < hero._level then
            index = index + 1
          end
        end
        return index
      end
    end
  elseif type == "FarmStage" then
    return ed.player:getTaskCount(chain, id)
  end
  return count
end
class.getCount = getCount
local refreshCliprect = function(self)
  local scheduler = self.mainLayer:getScheduler()
  local id
  local function handler(dt)
    xpcall(function()
      if not id then
        id = self.refreshCliprectID
      end
      if tolua.isnull(self.mainLayer) then
        scheduler:unscheduleScriptEntry(id)
        return
      end
      self.draglist:refreshClipRect(self.container:getScale())
    end, EDDebug)
  end
  return handler
end
class.refreshCliprect = refreshCliprect
local function show(self)
  lsr:report("createWindow")
  self.container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:getScheduler():unscheduleScriptEntry(self.refreshCliprectID)
      self.draglist:refreshClipRect(1)
      if self.behindShowHandler then
        self.behindShowHandler()
      end
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  self.container:runAction(sequence)
  self.refreshCliprectID = self.mainLayer:getScheduler():scheduleScriptFunc(self:refreshCliprect(), 0, false)
  ed.tutorial.clear()
end
class.show = show
local function destroy(self)
  lsr:report("closeWindow")
  if self.identity == "task" then
    ed.endTeach("firstTaskClickClose")
  end
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  self.container:runAction(sequence)
  if self.callback then
    self.callback()
  end
  self.refreshCliprectID = self.mainLayer:getScheduler():scheduleScriptFunc(self:refreshCliprect(), 0, false)
end
class.destroy = destroy
local function doClose(self)
  lsr:report("clickClose")
  self:destroy()
end
class.doClose = doClose
local function doCloseTouch(self)
  local isPress
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.close, x, y) then
        isPress = true
        self.ui.close_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        self.ui.close_press:setVisible(false)
        if ed.containsPoint(self.ui.close, x, y) then
          self:doClose()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCloseTouch = doCloseTouch
local doMainLayerTouch = function(self)
  local closeTouch = self:doCloseTouch()
  local function handler(event, x, y)
    xpcall(function()
      closeTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local function doPressInList(self)
  local function handler(x, y)
    for i = 1, #(self.tasks or {}) do
      local bd = self.tasks[i]
      local fb = bd.fastButton
      local fbp = bd.fastButtonPress
      if not tolua.isnull(fb) and ed.containsPoint(fb, x, y) then
        fbp:setVisible(true)
        return -i
      end
      if ed.containsPoint(bd.bg, x, y) then
        lsr:report("pressTaskBoard")
        bd.bg:setScale(0.98)
        return i
      end
    end
  end
  return handler
end
class.doPressInList = doPressInList
local function doClickInList(self, clickHandler)
  local function handler(x, y, id)
    local i = math.abs(id)
    if self.tasks[i] then
      if id > 0 and not ed.containsPoint(self.tasks[i].bg, x, y) then
        return
      end
      if id < 0 and not ed.containsPoint(self.tasks[i].fastButton, x, y) then
        return
      end
    end
    lsr:report("clickTaskBoard")
    if clickHandler then
      clickHandler(id)
    end
  end
  return handler
end
class.doClickInList = doClickInList
local cancelPressInList = function(self)
  local function handler(x, y, id)
    local i = math.abs(id)
    if self.tasks[i] then
      if id > 0 then
        self.tasks[i].bg:setScale(1)
      else
        if self.tasks[i].fastButtonPress then
          self.tasks[i].fastButtonPress:setVisible(false)
        end
      end
    end
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local cancelClickInList = function(self)
  local function handler(x, y, id)
    local i = math.abs(id)
    if self.tasks[i] then
      if id > 0 then
        self.tasks[i].bg:setScale(1)
      else
        self.tasks[i].fastButtonPress:setVisible(false)
      end
    end
  end
  return handler
end
class.cancelClickInList = cancelClickInList
local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(0, 45, 800, 348),
    rect = CCRectMake(155, 47, 490, 346),
    container = self.container,
    priority = -132,
    bar = {
      bglen = 320,
      bgpos = ccp(145, 218)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local orderList = function(self)
  return {}
end
class.orderList = orderList
local refreshList = function(self)
  local list = self:orderList()
  for i = 1, #list do
    if not tolua.isnull(list[i].bg) then
      list[i].bg:setPosition(ccp(400, 318 - 100 * (i - 1)))
    end
  end
  self.draglist:initListHeight(100 * #list + 20)
  self:clearEmptyPrompt()
  if #list <= 0 then
    self:createEmptyPrompt("task")
  end
end
class.refreshList = refreshList
local function createTask(self, task)
  task = task or {}
  if task.isFinished then
    return
  end
  local progressColor = {
    ccc3(70, 114, 0),
    ccc3(138, 56, 1)
  }
  local board = {}
  local name = task.name or ""
  local detail = task.detail or ""
  local target = task.target or 1
  local progress = task.progress or 0
  local isCompleted = (task.target or 1) <= (task.progress or 0)
  task.progress = math.min(task.progress, task.target)
  task.isCompleted = isCompleted
  local bgRes
  if isCompleted then
    bgRes = "UI/alpha/HVGA/task_board_finished.png"
  else
    bgRes = "UI/alpha/HVGA/task_board.png"
  end
  local bg = ed.createSprite(bgRes)
  board.bg = bg
--  if not (target <= progress) or not "" then
--  end
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = name,
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(95, 71)
      },
      config = {
		ccc3(66,45,28),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "progress",
        text = (target <= progress) and "" or  string.format("%d/%d", progress, target),
        size = 18
      },
      layout = {
        position = ccp(450, 71)
      },
      config = {
        color = isCompleted and progressColor[1] or progressColor[2]
      }
    },
    {
      t = "Label",
      base = {
        name = "detail",
        text = detail,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(95, 46)
      },
      config = {
        color = ccc3(0, 0, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "reward_title",
        text = T(LSTR("EXERCISE.AWARDS_")),
        size = 20,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(95, 20)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    }
  }
  local readNode = ed.readnode.create(bg, board)
  readNode:addNode(ui_info)
  local icon, iconBg, iconres
  if task.kind == "task" then
    local tt = ed.getDataTable("Task")[task.chain][task.id]
    iconres = tt.Icon
  elseif task.kind == "dailyjob" then
    local tt = ed.getDataTable("Todolist")[task.id]
    iconres = tt.Icon
  end
  if iconres and iconres ~= "" then
    icon = ed.createSprite(iconres)
    local size = icon:getContentSize()
    local w, h = size.width, size.height
    icon:setScaleX(75 / math.max(w, h))
    icon:setScaleY(75 / math.max(w, h))
    iconBg = ed.createSprite("UI/alpha/HVGA/task_icon_bg.png")
  else
    local r = task.reward[1]
    local type = r.type
    local id = r.id
    if type == "Item" then
      icon = ed.readequip.createIcon(id)
      local cg = ed.getDataTable("equip")[id].Category
      if cg == T(LSTR("EQUIP.FRAGMENT")) or cg == T(LSTR("EQUIP.SOUL_STONE")) then
        iconBg = ed.createSprite("UI/alpha/HVGA/task_fragment_icon_bg.png")
      else
        iconBg = ed.createSprite("UI/alpha/HVGA/task_icon_bg.png")
      end
    else
      icon = ed.createSprite(icon_res[type])
      iconBg = ed.createSprite("UI/alpha/HVGA/task_icon_bg.png")
    end
  end
  iconBg:setPosition(ccp(50, 47))
  bg:addChild(iconBg)
  board.iconBg = iconBg
  icon:setPosition(ccp(50, 48))
  bg:addChild(icon, 1)
  board.icon = icon
  if board.name:getContentSize().width > 300 then
     board.name:setScale(300 / board.name:getContentSize().width)
  end
  if board.detail:getContentSize().width > 280 then
     board.detail:setScale(280 / board.detail:getContentSize().width)
  end
  local reward = task.reward
  local preNode = board.reward_title
  for i = 1, #reward do
    local r = reward[i]
    local type = r.type
    local id = r.id
    local amount = r.amount
    local icon
    local mh = 20
    if type == "Item" then
      icon = ed.readequip.createIcon(id, mh)
    else
      icon = ed.createSprite(reward_icon_res[type])
      icon:setScale(mh / icon:getContentSize().height)
    end
    icon:setPosition(ed.getRightSidePos(preNode, i == 1 and 0 or 10))
    icon:setAnchorPoint(ccp(0, 0.5))
    bg:addChild(icon)
    preNode = icon
    local al = ed.createttf("x" .. amount, 20)
    al:setAnchorPoint(ccp(0, 0.5))
    al:setPosition(ed.getRightSidePos(preNode))
    ed.setLabelColor(al, ccc3(155, 41, 14))
    bg:addChild(al)
    preNode = al
  end
  if isCompleted then
    local completeTag = ed.createSprite("UI/alpha/HVGA/task_get_reward_button.png")
    completeTag:setPosition(ccp(420, 45))
    bg:addChild(completeTag, 1)
    board.completeTag = completeTag
  elseif task.kind == "dailyjob" then
    local type = task.type
    local fb = self:createFastButton(task)
    self:addFastButton(board, fb)
  end
  board.info = task
  self.tasks = self.tasks or {}
  table.insert(self.tasks, board)
  self.draglist:addItem(bg)
  self:refreshDailyjobProgressLabel(board)
  return board
end
class.createTask = createTask
local addFastButton = function(self, board, fb)
  local bg = board.bg
  local button = fb.button
  local press = fb.press
  local handler = fb.handler
  board.fastButton = button
  board.fastButtonPress = press
  board.fastEntry = handler
  if not tolua.isnull(button) then
    button:setPosition(ccp(450, 30))
    bg:addChild(button, 1)
  end
end
class.addFastButton = addFastButton
local function refreshDailyjobProgressLabel(self, board)
  local pg = board.progress
  local task = board.info
  local pid = (task.progressid or {})[1]
  if task.type == "MonthlyCardPeriod" then
    local ls = ""
    local x,y = pg:getPosition()
    if not ed.player:isMonthCardValid(pid) then
      ls = T(LSTR("TASK.NOT_PURCHASED"))
      pg:setPosition(ccp(x - 40, y))
    elseif task.isCompleted then
      ls = ""
    else
      ls = T(LSTR("TASK.CLAIMED_REMAINING_TIME___D_DAY"), ed.player:getMonthCardLeftTimes(pid))
      if ed.player:canMonthCardRenew(pid) then
        local fb = self:createFastButton(task, {
          labelString = T(LSTR("TASK.RENEWALS")),
          showForce = true
        })
        if fb then
          self:addFastButton(board, fb)
        end
      end
      pg:setPosition(ccp(x - 60, y))
    end
    ed.setString(pg, ls)
  elseif task.type == "Login" and not task.isCompleted then
    ed.setString(pg, T(LSTR("TASK.TIME_YET_TO_COME")))
  end
end
class.refreshDailyjobProgressLabel = refreshDailyjobProgressLabel
local function createFastButton(self, task, param)
  local type = task.type
  local pid = task.progressid
  local button, press, handler
  local labelString = (param or {}).labelString
  local showForce = (param or {}).showForce
  local fast_handler = {
    FarmPVEStage = function()
      ed.pushScene(ed.ui.stageselect.create())
      self.isPushingScene = true
    end,
    FarmElitePVEStage = function()
      ed.pushScene(ed.ui.stageselect.create(nil, "elite"))
      self.isPushingScene = true
    end,
    FarmChapter = function()
      for k, v in pairs(pid) do
        if v == 102 then
          ed.pushScene(ed.ui.exercise.create("em"))
          self.isPushingScene = true
        elseif v == 103 then
          ed.pushScene(ed.ui.exercise.create("equip"))
          self.isPushingScene = true
        end
      end
    end,
    PVPBattle = function()
      local msg = ed.upmsg.ladder()
      msg._open_panel = {}
      ed.send(msg, "ladder")
      self.isPushingScene = true
    end,
    PVPWin = function()
      local msg = ed.upmsg.ladder()
      msg._open_panel = {}
      ed.send(msg, "ladder")
      self.isPushingScene = true
    end,
    SkillUpgradeSuccess = function()
      ed.pushScene(ed.ui.heropackage.create())
      self.isPushingScene = true
    end,
    EnhanceLevelUp = function()
      ed.pushScene(ed.ui.equipstrengthen.create())
      self.isPushingScene = true
    end,
    MidasUse = function()
      local midas = ed.ui.midas.create({
        callback = function()
          xpcall(function()
            self:getTaskList()
          end, EDDebug)
        end
      })
      self.mainLayer:addChild(midas.mainLayer, 100)
    end,
    TavernGroupUse = function()
      ed.pushScene(ed.ui.tavern.create())
      self.isPushingScene = true
    end,
    MonthlyCardPeriod = function()
      local rechargeLayer = newrecharge.create()
      self.mainLayer:addChild(rechargeLayer, 200)
    end,
    CompleteCrusadeStage = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("Crusade")
      if ds then
        ed.showToast(ds)
        return
      end
      local msg = ed.upmsg.tbc()
      msg._open_panel = {}
      ed.send(msg, "tbc")
    end,
    SendMercenary = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
      if ds then
        ed.showToast(ds)
        return
      end
      local msg = ed.upmsg.guild()
      msg._open_pannel = {}
      ed.send(msg, "guild")
    end,
    EnterRaid = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
      if ds then
        ed.showToast(ds)
        return
      end
      local msg = ed.upmsg.guild()
      msg._open_pannel = {}
      ed.send(msg, "guild")
    end
  }
  local function isShow()
    if showForce then
      return true
    end
    if task.type == "MonthlyCardPeriod" then
      local pid = task.progressid[1]
      if ed.player:isMonthCardValid(pid) then
        return false
      end
    end
    return true
  end
  handler = fast_handler[type]
  local label
  if handler and isShow() then
    button = ed.createScale9Sprite("UI/alpha/HVGA/task_button.png", CCRectMake(15, 20, 45, 15))
    press = ed.createScale9Sprite("UI/alpha/HVGA/task_button_press.png", CCRectMake(15, 20, 45, 15))
    button:setContentSize(CCSizeMake(60, 45))
    press:setContentSize(CCSizeMake(60, 45))
    press:setAnchorPoint(ccp(0, 0))
    press:setPosition(ccp(0, 0))
    press:setVisible(false)
    button:addChild(press)
    label = ed.createttf(labelString or T(LSTR("TASK.HEAD_TO")), 18, ed.selfFont)
    label:setPosition(ccp(28, 23))
    ed.setLabelShadow(label, ccc3(63, 5, 0), ccp(0, 2))
    button:addChild(label, 1)
  end
  return {
    button = button,
    press = press,
    label = label,
    handler = fast_handler[type]
  }
end
class.createFastButton = createFastButton
local createList = function(self, list)
  self.tasks = {}
  for i = 1, #list do
    self.tasks[i] = self:createTask(list[i])
  end
  self:refreshList()
end
class.createList = createList
local function createEmptyPrompt(self, type)
  type = type or "task"
  local text = ""
  if type == "task" then
    text = T(LSTR("TASK.NO_CURRENT_TASK_CAN_BE_ACCESSED"))
  elseif type == "dailyjob" then
    text = T(LSTR("TASK.YOU_HAVE_DONE_TODAYS_TASKS"))
  end
  local ui = self.ui
  local readnode = ed.readnode.create(ui.frame, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "empty_prompt",
        text = text,
        size = 20
      },
      layout = {
        position = ccp(269, 189)
      },
      config = {
        color = ccc3(238, 204, 119)
      }
    }
  }
  readnode:addNode(ui_info)
end
class.createEmptyPrompt = createEmptyPrompt
local clearEmptyPrompt = function(self)
  local ui = self.ui
  local prompt = ui.empty_prompt
  if not tolua.isnull(prompt) then
    prompt:removeFromParentAndCleanup(true)
  end
end
class.clearEmptyPrompt = clearEmptyPrompt
local function create(identity, callback)
  local self = {}
  setmetatable(self, class.mt)
  self.callback = callback
  self.identity = identity
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 200))
  self.mainLayer = mainLayer
  local container = CCLayer:create()
  container:setAnchorPoint(ccp(0.5, 0.5))
  mainLayer:addChild(container)
  self.container = container
  local titleText = T(LSTR("TASK.TASK"))
  if identity == "dailyTask" then
    titleText = T(LSTR("TASK.DAILY_ACTIVITIES"))
  end
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/package_herolist_bg.png"
      },
      layout = {
        position = ccp(400, 218)
      },
      config = {
        scalexy = {y = 1.0}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/crusade_title_short_bg.png",
        z = 30
      },
      layout = {
        position = ccp(400, 399)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = titleText,
        parent = "title_bg",
        fontinfo = "ui_normal_button",
        size = 24
      },
      layout = {
        position = ccp(175, 35)
      },
      config = {
        color = ccc3(250, 205, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png",
        z = 30
      },
      layout = {
        position = ccp(675, 382)
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
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self.tasks = {}
  self:createListLayer()
  self:show()
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -130, true)
  mainLayer:registerScriptHandler(function(event)
    if self.geteeHandler then
      self.geteeHandler(event)
      self.isPushingScene = nil
    else
    end
  end)
  
  ed.pop_task=self
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basetask
setmetatable(class, base.mt)
ed.ui.task = class
local function doClickInTaskHandler(self)
  local function handler(id)
    if self.tasks[id] then
      self.tasks[id].bg:setScale(1)
      if self.tasks[id].info.isCompleted then
        self:completeTask(id)
        ed.endTeach("firstTaskClickComplete")
      else
        ed.showToast(T(LSTR("TASK.THE_TASK_HAS_NOT_BEEN_COMPLETED")))
      end
    end
  end
  return handler
end
class.doClickInTaskHandler = doClickInTaskHandler
local function triggerTaskReply(self, data)
  local function handler(result)
    local tl = ed.player:getTaskList()
    for i = 1, #data do
      if result[i] == "success" then
        for k, v in pairs(tl) do
          if v._line == data[i].chain then
            table.remove(tl, k)
          end
        end
        ed.player:addTask(data[i].chain, data[i].id)
        local row = ed.getDataTable("Task")[data[i].chain][data[i].id]
        local type = row["Task Progress Type"]
        if type == "KillMonster" then
          local pid = row["Task Progress ID"]
          for k, v in pairs(pid) do
            if v ~= 0 then
              ed.record:reset("login", "killMonster", v)
            end
          end
        elseif type == "FarmStage" then
          local pid = row["Task Progress ID"]
          for k, v in pairs(pid) do
            if v ~= 0 then
              ed.record:reset("login", "farmStage", v)
            end
          end
        end
        if not tolua.isnull(self.mainLayer) then
          local info = self:initTaskData(data[i])
          local task = self:createTask(info)
        end
      end
    end
    if not tolua.isnull(self.mainLayer) then
      self:refreshList()
    end
  end
  return handler
end
class.triggerTaskReply = triggerTaskReply
local function clickTaskCallback(self, info)
  local function handler()
    local chain, id = info.chain, info.id
    self:refreshTaskList(chain, id + 1)
    ed.teach("firstTaskClickClose", self.ui.close, self.container)
  end
  return handler
end
class.clickTaskCallback = clickTaskCallback
local function doClickTask(self, id)
  local info = self.tasks[id].info
  local callback = self:clickTaskCallback(info)
  local items = {}
  local ofy = 0
  if info.consumeName then
    table.insert(items, {
      explain = T(LSTR("TASK.CONSUMPTION_GOODS_"))
    })
    local it = {
      type = info.consumeType,
      id = info.consumeID,
      amount = info.consumeAmount
    }
    table.insert(items, it)
    ofy = 20
    table.insert(items, {
      explain = T(LSTR("DAILYLOGIN.REWARDED_")),
      offsety = ofy
    })
  end
  for i = 1, #(info.reward or {}) do
    local r = info.reward[i]
    local it = {
      type = r.type,
      id = r.id,
      amount = r.amount
    }
    table.insert(items, it)
  end
  local config = {
    type = "getProp",
    param = {
      identity = "task",
      title = T(LSTR("TASK.COMPLETION_")) .. info.name,
      callback = callback,
      items = items
    }
  }
  ed.announce(config)
end
class.doClickTask = doClickTask
local initTaskList = function(self, list)
  local task = {}
  for k, v in pairs(list) do
    local t = self:initTaskData(v)
    table.insert(task, t)
  end
  self:clearEmptyPrompt()
  if #task > 0 then
    self:createList(task)
  else
    self:createEmptyPrompt("dailyjob")
  end
end
class.initTaskList = initTaskList
local function isTaskCompleted(task)
  local t = {
    chain = task._line,
    id = task._id,
    count = task._task_target,
    status = task._status
  }
  local progress = class.getProgress(t)
  local target = ed.getDataTable("Task")[task._line][task._id]["Task Target"]
  return progress >= target and ed.isElementInTable(t.status, {"working", 1})
end
class.isTaskCompleted = isTaskCompleted
local function getProgress(data)
  local chain = data.chain
  local id = data.id
  local count = data.count or 0
  local row = ed.getDataTable("Task")[chain][id]
  local type = row["Task Progress Type"]
  local pid = row["Task Progress ID"]
  local target = row["Task Target"]
  return getCount({
    chain = chain,
    id = id,
    pid = pid,
    type = type,
    count = count,
    target = target
  }) or count
end
class.getProgress = getProgress
local function initTaskData(self, data)
  local tt = ed.getDataTable("Task")
  local row = tt[data.chain][data.id]
  local t = {
    kind = "task",
    chain = data.chain,
    id = data.id,
    isFinished = data.isFinished,
    isConsume = row["Task Need Consume"],
    consumeType = row["Task Consume Type"],
    consumeID = row["Task Consume ID"],
    consumeAmount = row["Task Consume Amount"],
    consumeName = getItemName(row["Task Consume Type"], row["Task Consume ID"]),
    name = row["Task Name"],
    detail = row["Task Detail"],
    target = row["Task Target"],
    progress = getProgress(data)
  }
  t.reward = {
    {
      type = row["Task Reward Type"],
      id = row["Task Reward ID"],
      amount = row["Task Reward Amount"],
      name = getItemName(row["Task Reward Type"], row["Task Reward ID"])
    }
  }
  t.isCompleted = (t.progress or 0) >= t.target
  return t
end
class.initTaskData = initTaskData
local function canTriggerTask(chain, task)
  local trigger = ed.getDataTable("Triggers")
  local task = ed.getDataTable("Task")[chain][task]
  if not task then
    return nil
  end
  local triggers = task["Trigger ID"]
  if type(triggers) == "table" then
    for k, v in pairs(triggers) do
      if type(v) == "number" and v > 0 then
        local row = trigger[v]
        local type = row["Trigger Type"]
        local condition = row["Trigger Condition"]
        if type == "CompleteStage" then
          if 0 >= ed.player:getStageStar(condition) then
            return false
          end
        elseif type == "PlayerLevel" and condition > ed.player:getLevel() then
          return false
        end
      end
    end
  end
  return true
end
class.canTriggerTask = canTriggerTask
local function getCurrentTaskInChain(chain)
  local tasks = ed.player:getTaskList()
  local hasInit = false
  for k, v in pairs(tasks) do
    if v._line == chain then
      hasInit = true
      local isFinished = ed.isElementInTable(v._status, {"finished", 0})
      if not isFinished then
        return {
          id = v._id,
          chain = v._line,
          isFinished = isFinished,
          count = v._task_target
        }
      elseif canTriggerTask(chain, v._id + 1) then
        return {
          id = v._id + 1,
          chain = v._line,
          isFinished = false,
          count = 0,
          noTrigger = true
        }
      end
    end
  end
  if not hasInit and canTriggerTask(chain, 1) then
    return {
      id = 1,
      chain = chain,
      isFinished = false,
      count = 0,
      noTrigger = true
    }
  else
    return nil
  end
end
class.getCurrentTaskInChain = getCurrentTaskInChain
local function classifyTask(self, exception, taskList, msgList)
  local taskTable = ed.getDataTable("Task")
  taskList = taskList or {}
  msgList = msgList or {}
  for k, v in pairs(taskTable) do
    if k ~= "name" and not ed.isElementInTable(k, exception) then
      local t = getCurrentTaskInChain(k)
      if t then
        if t.noTrigger then
          table.insert(msgList, t)
        else
          table.insert(taskList, t)
        end
      end
    end
  end
  return taskList, msgList
end
class.classifyTask = classifyTask
local delayTrigger = function(self, msgList)
  local function handler()
    local delay = CCDelayTime:create(0)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self:doSendTrigger(msgList)
        self.delayTriggerHandler = nil
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(delay, func)
    self.mainLayer:runAction(sequence)
  end
  return handler
end
class.delayTrigger = delayTrigger
local function doSendTrigger(self, msgList)
  if #msgList > 0 then
    ed.netdata.triggerTask = msgList
    ed.netreply.triggerTask = self:triggerTaskReply(msgList)
    local msg = ed.upmsg.trigger_task()
    local ts = {}
    for i = 1, #msgList do
      table.insert(ts, ed.makebits(16, msgList[i].chain, 16, msgList[i].id))
    end
    msg._task = ts
    ed.send(msg, "trigger_task")
  end
end
class.doSendTrigger = doSendTrigger
local doTriggerTask = function(self, msgList)
  if self.isSendRequireRewards then
    self.delayTriggerHandler = self:delayTrigger(msgList)
    self.isSendRequireRewards = false
  else
    self:doSendTrigger(msgList)
  end
end
class.doTriggerTask = doTriggerTask
local function refreshTaskList(self, chain, id)
  local finished = ed.player:getFinishedTask()
  local chainList = {}
  local msgCache = {}
  for k, v in pairs(self.tasks or {}) do
    if not ed.isElementInTable(v.info.chain, finished) then
      table.insert(chainList, v.info.chain)
    end
  end
  for k, v in pairs(finished) do
    table.insert(chainList, v)
  end
  local list, msgTask = self:classifyTask(chainList)
  self:doTriggerTask(msgTask)
end
class.refreshTaskList = refreshTaskList
local function getTaskList(self)
  local finished = ed.player:getFinishedTask()
  local chainList = {}
  for k, v in pairs(finished) do
    table.insert(chainList, v)
  end
  local list = {}
  local msgCache = {}
  list, msgCache = self:classifyTask(chainList, list, msgCache)
  self:doTriggerTask(msgCache)
  self:initTaskList(list)
end
class.getTaskList = getTaskList
local function completeTaskReply(self)
  local function handler(result, index)
    local info = self.tasks[index].info
    if not result then
      ed.showToast(T(LSTR("TASK.TASK_SUBMISSION_FAILED")))
    else
      self:doClickTask(index)
      doTaskConsume(info)
      doTaskReward(info)
      local tl = ed.player:getTaskList()
      for k, v in pairs(tl) do
        if info.chain == v._line and info.id == v._id then
          tl[k]._status = "finished"
        end
      end
      if self.delayTriggerHandler then
        self.delayTriggerHandler()
      end
      if not tolua.isnull(self.tasks[index].bg) then
        self.tasks[index].bg:removeFromParentAndCleanup(true)
      end
      table.remove(self.tasks, index)
      self:refreshList()
    end
  end
  return handler
end
class.completeTaskReply = completeTaskReply
local function doCompleteTask(self, index)
  local info = self.tasks[index].info
  ed.netdata.requireRewards = index
  ed.netreply.requireRewards = self:completeTaskReply()
  local msg = ed.upmsg.require_rewards()
  msg._line = info.chain
  msg._id = info.id
  ed.send(msg, "require_rewards")
end
class.doCompleteTask = doCompleteTask
local completeTask = function(self, index)
  self:doCompleteTask(index)
end
class.completeTask = completeTask
local orderList = function(self)
  local task = self.tasks
  for i = 1, #task do
    for j = i, 2, -1 do
      if task[j].info.isCompleted and not task[j - 1].info.isCompleted then
        local temp = task[j]
        task[j] = task[j - 1]
        task[j - 1] = temp
      elseif task[j].info.isCompleted == task[j - 1].info.isCompleted then
        if task[j].info.chain < task[j - 1].info.chain then
          local temp = task[j]
          task[j] = task[j - 1]
          task[j - 1] = temp
        elseif task[j].info.chain == task[j - 1].info.chain and task[j].info.id < task[j - 1].info.id then
          local temp = task[j]
          task[j] = task[j - 1]
          task[j - 1] = temp
        end
      end
    end
  end
  return task
end
class.orderList = orderList
local function create(callback)
  local self = base.create("task", callback)
  setmetatable(self, class.mt)
  function self.behindShowHandler()
    self:getTaskList()
    for i = 1, #(self.tasks or {}) do
      local t = self.tasks[i]
      if not tolua.isnull(t.completeTag) then
        ed.teach("firstTaskClickComplete", t.completeTag, t.bg)
        break
      end
    end
    function self.geteeHandler(event)
      if event == "enter" then
        self:getTaskList()
      end
    end
  end
  self.draglist.doClickIn = self:doClickInList(self:doClickInTaskHandler())
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.dailyTask = class
local base = ed.ui.basetask
setmetatable(class, base.mt)
local orderList = function(self)
  local list = self.tasks or {}
  for i = 1, #self.tasks do
    for j = i, 2, -1 do
      if list[j].info.isCompleted and not list[j - 1].info.isCompleted then
        local temp = list[j]
        list[j] = list[j - 1]
        list[j - 1] = temp
      elseif list[j].info.isCompleted == list[j - 1].info.isCompleted and list[j].info.id < list[j - 1].info.id then
        local temp = list[j]
        list[j] = list[j - 1]
        list[j - 1] = temp
      end
    end
  end
  return list
end
class.orderList = orderList
local function completeTaskReply(self, id)
  local function handler(result)
    local task = self.tasks[id]
    local info = task.info
    if not result then
      ed.showToast(T(LSTR("TASK.TASK_SUBMISSION_FAILED")))
    else
      local info = self.tasks[id].info
      local items = {}
      for i = 1, #(info.reward or {}) do
        local r = info.reward[i]
        local it = {
          type = r.type,
          id = r.id,
          amount = r.amount
        }
        table.insert(items, it)
      end
      local config = {
        type = "getProp",
        param = {
          identity = "task",
          title = T(LSTR("TASK.COMPLETION_")) .. info.name,
          items = items
        }
      }
      ed.announce(config)
      doTaskReward(info)
      ed.player:resetDailyjobTime(info.id)
      if info.type == "MonthlyCardPeriod" then
        self:refreshTaskBoard(id)
      else
        if not tolua.isnull(task.bg) then
          task.bg:removeFromParentAndCleanup(true)
        end
        table.remove(self.tasks, id)
      end
      self:refreshList()
    end
  end
  return handler
end
class.completeTaskReply = completeTaskReply
local function refreshTaskBoard(self, index)
  local task = self.tasks[index]
  local id = task.info.id
  if not tolua.isnull(task.bg) then
    task.bg:removeFromParentAndCleanup(true)
  end
  table.remove(self.tasks, index)
  local dj = ed.player._dailyjob
  local jobs = {}
  for k, v in pairs(dj or {}) do
    if v._id == id then
      local t = self:initTaskData(v)
      if t then
        local board = self:createTask(t)
      end
    end
  end
  self:refreshList()
end
class.refreshTaskBoard = refreshTaskBoard
local function completeTask(self, id)
  ed.netdata.jobRewards = id
  ed.netreply.jobRewards = self:completeTaskReply(id)
  local msg = ed.upmsg.job_rewards()
  msg._job = self.tasks[id].info.id
  ed.send(msg, "job_rewards")
end
class.completeTask = completeTask
local function doClickInTaskHandler(self, clickHandler)
  local function handler(id)
    local type
    type = id < 0 and "fastEntry" or "board"
    id = math.abs(id)
    local bd = self.tasks[id]
    if type == "board" then
      bd.bg:setScale(1)
      if bd.info.isCompleted then
        self:completeTask(id)
        ed.endTeach("firstTaskClickComplete")
      else
        ed.showToast(T(LSTR("TASK.THE_TASK_HAS_NOT_BEEN_COMPLETED")))
      end
    elseif type == "fastEntry" then
      local fb = bd.fastButton
      local fbp = bd.fastButtonPress
      local handler = bd.fastEntry
      fbp:setVisible(false)
      if not self.isPushingScene then
        handler()
      end
    end
  end
  return handler
end
class.doClickInTaskHandler = doClickInTaskHandler
local function initTaskData(self, info)
  local function isShow(task)
    local lt = task.lastTime
    local nt = ed.getServerTime()
    if not ed.isElementInTable(task.type, {
      "MonthlyCardPeriod"
    }) and not ed.checkTwoDateod(lt, nt) and lt ~= 0 then
      return false
    end
    return checkDailyjobDisplay(task.id) or checkdbTrigger(task.id)
  end
  local id = info._id
  local row = ed.getDataTable("Todolist")[id]
  if not row then
    return
  end
  local pid = {
    row["Task Progress ID"]
  }
  local name = row["Task Name"]
  local trigger = row["Trigger ID"]
  local detail = row["Task Detail"]
  local target = row["Task Target"]
  local lastTime = info._last_rewards_time
  local count = ed.player:getDailyjobCount(id)
  local task = {
    kind = "dailyjob",
    id = id,
    type = row["Task Progress Type"],
    name = name,
    trigger = trigger,
    detail = detail,
    target = target,
    progress = count,
    progressid = pid,
    isCompleted = target <= count,
    lastTime = lastTime,
    reward = {}
  }
  for i = 1, 2 do
    local type = row[string.format("Task Reward %d Type", i)]
    if type then
      task.reward[i] = {
        type = type,
        id = row[string.format("Task Reward %d ID", i)],
        amount = row[string.format("Task Reward %d Amount", i)]
      }
    end
  end
  if isShow(task) then
    return task
  else
    return nil
  end
end
class.initTaskData = initTaskData
local function initTaskList(self)
  local task = {}
  local function addTask(t)
    local t = self:initTaskData(t)
    if t then
      table.insert(task, t)
    end
  end
  local ids = self:getAllTaskid()
  local dj = ed.player._dailyjob
  local jobs = {}
  for k, v in pairs(dj or {}) do
    jobs[v._id] = v._last_rewards_time
    addTask(v)
  end
  self:clearEmptyPrompt()
  if #task > 0 then
    self:createList(task)
  else
    self:createEmptyPrompt("task")
  end
end
class.initTaskList = initTaskList
local function getAllTaskid(self)
  local djt = ed.getDataTable("Todolist")
  local ids = {}
  for k, v in pairs(djt) do
    if type(k) == "number" then
      table.insert(ids, k)
    end
  end
  return ids
end
class.getAllTaskid = getAllTaskid
local getTaskList = function(self)
  self.draglist:clearList()
  self:initTaskList()
end
class.getTaskList = getTaskList
local function create(callback)
  local self = base.create("dailyTask", callback)
  setmetatable(self, class.mt)
  function self.behindShowHandler()
    self:getTaskList()
    function self.geteeHandler(event)
      if event == "enter" then
        self:getTaskList()
      end
    end
  end
  self.draglist.doClickIn = self:doClickInList(self:doClickInTaskHandler())
  return self
end
class.create = create

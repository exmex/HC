local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.excavatebattlereport = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(data, param)
  param = param or {}
  local self = base.create("excavatebattlereport", param)
  setmetatable(self, class.mt)
  self.param = param
  self.data = data
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.excavatebattlereport)
  self:setContainer(container)
  local ui = self.ui
  self:registerTouchHandler()
  self:show({
    callback = function()
      self:createWindow()
    end,
    skipAnim = true
  })
  return self
end
class.create = create
local createWindow = function(self)
  self:createListLayer()
end
class.createWindow = createWindow
local createListLayer = function(self)
  local info = {
    cliprect = ed.DGRectMake(110, 30, 1024, 485),
    noshade = true,
    zorder = 5,
    container = self.container,
    priority = self.param.priority and self.param.priority - 5 or -150,
    direction = "v",
    oriPosition = ed.DGccp(107, 325),
    itemSize = ed.DGSizeMake(800, 194),
    initHandler = self:getInitHandler(),
    useBar = true,
    barPosition = "left",
    barLenOffset = -10,
    barPosOffset = ccp(-5, 0),
    heightOffset = 0
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollView
  local data = self.data
  local function initReport(index)
    if index <= #data then
      scrollView:push({key = index, index = index})
    end
    if index > #data then
      self:getScene():removeUpdateHandler("asyncLoadReport")
    end
  end
  local index = 1
  self:getScene():registerUpdateHandler("asyncLoadReport", function()
    initReport(index)
    index = index + 1
  end)
end
class.createListLayer = createListLayer
local getInitHandler = function(self)
  local function handler(param)
    param = param or {}
    local index = param.index or 1
    local data = self.data[index]
    local container = param.container
    local ui = {}
    ed.editorui(ed.uieditor.itemexcavatebattlereport, {container = container, ui = ui})
    ed.setLabelString(ui.title_label, LSTR("EXCAVATEBATTLEREPORT.THE") .. index .. LSTR("EXCAVATEBATTLEREPORT.BATTLE"))
    self:btRegisterButtonClick({
      button = ui.replay_button,
      press = ui.replay_button_press,
      key = "replay_button_" .. index,
      clickHandler = function()
        ed.registerNetReply("query_replay", ed.showReplay, {mode = "excavate"})
        local recordid = data._record_id
        local svrid = data._record_svrid
        local msg = ed.upmsg.query_replay()
        msg._record_index = recordid
        msg._record_svrid = svrid
        ed.send(msg, "query_replay")
      end,
      clickInterval = 0.5
    })
    local keys = {"left", "right"}
    for i = 1, #keys do
      local teamData
      if keys[i] == "left" then
        teamData = data._oppo_team
      else
        teamData = data._self_team
      end
      local k = keys[i]
      container = ui[k .. "_container"]
      ui[k .. "ui"] = {}
      local cui = ui[k .. "ui"]
      ed.editorui(ed.uieditor.itemexcavatebattleplayer, {container = container, ui = cui})
      cui.tag_win:setVisible(true)
      cui.tag_lose:setVisible(true)
      if keys[i] == "left" then
        if data._result == "victory" then
          cui.tag_win:setVisible(false)
        else
          cui.tag_lose:setVisible(false)
        end
      elseif data._result == "victory" then
        cui.tag_lose:setVisible(false)
      else
        cui.tag_win:setVisible(false)
      end
      local heroData = teamData._hero
      for j = 1, 5 do
        local hero = heroData[j]
        if hero then
          local ct = cui["hicon_container_" .. j]
          local len = ct:getContentSize().width
          local base = hero._base
          local dyna = hero._dyna
          local hicon = ed.readhero.createIcon({
            id = base._tid,
            level = base._level,
            rank = base._rank,
            stars = base._stars,
            hp = dyna._hp_perc,
            mp = dyna._mp_perc,
            length = len
          }).icon
          hicon:setAnchorPoint(ccp(0, 0))
          ct:addChild(hicon)
        end
      end
      local playerData = teamData._player
      local ct = cui.icon_container
      local headIcon = ed.getTeamHead({
        id = playerData._avatar,
        length = ct:getContentSize().width,
        type = 0 < (playerData._vip or 0) and "vip"
      })
      headIcon:setAnchorPoint(ccp(0, 0))
      ct:addChild(headIcon)
      local ct = cui.level_container
      local levelIcon = ed.getLevelIcon({
        level = playerData._level,
        type = 0 < (playerData._vip or 0) and "vip"
      })
      levelIcon:setAnchorPoint(ccp(0, 0))
      ct:addChild(levelIcon)
      local ct = cui.name_label
      ed.setLabelString(ct, playerData._name)
    end
  end
  return handler
end
class.getInitHandler = getInitHandler
local pop = function(id, param)
  local function handler(data)
    data = data or {}
    if #data < 1 then
      ed.showToast(T(LSTR("EXCAVATEBATTLEREPORT.NO_QUERY_TO_THE_RELEVANT_INFORMATION")))
    else
      local window = ed.ui.excavatebattlereport.create(data, param)
      window:popWindow(120)
    end
  end
  ed.registerNetReply("query_excavate_battle", handler)
  local msg = ed.upmsg.excavate()
  local qeb = ed.upmsg.query_excavate_battle()
  qeb._id = id
  msg._query_excavate_battle = qeb
  ed.send(msg, "excavate")
end
class.pop = pop

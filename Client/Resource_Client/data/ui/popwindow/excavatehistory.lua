local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.excavatehistory = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "back_button",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local orderData = function(self)
  local data = self.data
  table.sort(data, function(p, n)
    return p._time > n._time
  end)
end
class.orderData = orderData
local function create(data, param)
  param = param or {}
  local self = base.create("excavatehistory", param)
  setmetatable(self, class.mt)
  self.param = param
  self.data = data or {}
  self:orderData()
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.excavatehistory)
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
local getInitHandler = function(self)
  local function handler(param)
    local data = param.data
    local id = data._id
    local eid = data._excavate_id
    local result = data._result
    local name = data._enemy_name
    local timePoint = data._time
    local hasVitality = 0 < (data._vatility or 0)
    if hasVitality then
      ed.player:setExcavateHistoryRewardTag(id)
    end
    local disName = ed.getDataTable("ExcavateTreasure")[eid]["Display Name"]
    local container = param.container
    local ui = {}
    local readnode = ed.readnode.create(container, ui)
    local ui_info = ed.uieditor.itemexcavatehistory
    readnode:addNode(ui_info)
    ui.tag_win:setVisible(false)
    ui.tag_lose:setVisible(false)
    if result == "win" then
      ui.tag_win:setVisible(true)
    else
      ui.tag_lose:setVisible(true)
    end
    local enemyName = ui.enemy_name_label
    local time = ui.time_label
    ed.setLabelString(enemyName, name)
    local dt = ed.getServerTime() - timePoint
    local dd = dt / 3600 / 24
    local dh = dt / 3600
    local dm = dt / 60
    if dd >= 1 then
      ed.setLabelString(time, T(LSTR("EXCAVATEHISTORY._D_DAYS_AGO"), dd))
    elseif dh >= 1 then
      ed.setLabelString(time, T(LSTR("PVP._D_HOURS_AGO"), dh))
    elseif dm >= 1 then
      ed.setLabelString(time, T(LSTR("PVP._D_MINUTES_AGO"), dm))
    else
      ed.setLabelString(time, T(LSTR("PVP._D_SECONDS_AGO"), dt))
    end
    ui.enemy_svr_name = ed.createNode({
      t = "Label",
      base = {
        text = T(LSTR("excavatehistory.1.10.1.001"), data._enemy_svrid, data._enemy_svrname),
        size = 16
      },
      config = {
        color = ccc3(65, 57, 54)
      }
    }, container)
    ed.right2(ui.enemy_svr_name, enemyName, 10)
    ui.enemy_action_label = ed.createNode({
      t = "Label",
      base = {
        text = T(LSTR("EXCAVATEHISTORY.ATTACK_YOUR__S"), disName),
        size = 16
      },
      config = {
        color = ccc3(65, 57, 54)
      }
    }, container)
    ed.right2(ui.enemy_action_label, time, 10)
    self:btRegisterButtonClick({
      button = ui.check_button,
      press = ui.check_button_press,
      key = param.key,
      clickHandler = function()
        local param
        if self.param.priority then
          param = {
            priority = self.param.priority - 5
          }
        end
        ed.ui.excavatebattlereport.pop(id, param)
      end,
      mcpMode = true
    })
    if hasVitality then
      ui.vit_button:setVisible(true)
      self:btRegisterButtonClick({
        button = ui.vit_button,
        press = ui.vit_button_press,
        key = "vit_button_" .. param.key,
        clickHandler = function()
          ed.ui.excavate.drawDefReward(id, function(result, amount)
            if result then
              ui.vit_button:setVisible(false)
              self:btRemoveMainTouchHandler({
                key = "vit_button_" .. param.key
              })
              ed.player:removeExcavateHistoryRewardTag(id)
              ed.announce({
                type = "getProp",
                param = {
                  title = T(LSTR("DAILYLOGIN.REWARDED")),
                  items = {
                    {
                      explain = T(LSTR("EXCAVATEHISTORY.YOUR_HERO_TO_RESIST_THE_ENEMY__DWAVE_ATTACK_AS_YOU_WIN_THE_PHYSICAL_REWARDS"), math.floor((data._vatility or 0) / 2)),
                      bottomy = -5
                    },
                    {
                      type = "Vitality",
                      amount = amount,
                      alignment = "leftSide"
                    }
                  }
                }
              })
            else
              ed.showToast(T(LSTR("EXCAVATEHISTORY.FAILURE_TO_RECEIVE_AWARDS")))
            end
          end)
        end,
        mcpMode = true
      })
    else
      ui.vit_button:setVisible(false)
    end
    return ui
  end
  return handler
end
class.getInitHandler = getInitHandler
local createWindow = function(self)
  self:createListLayer()
end
class.createWindow = createWindow
local createListLayer = function(self)
  local info = {
    cliprect = ed.DGRectMake(165, 35, 690, 485),
    shaderect = ed.DGRectMake(175, 35, 660, 485),
    zorder = 5,
    container = self.container,
    priority = self.param.priority and self.param.priority - 5 or -135,
    direction = "v",
    oriPosition = ccp(135, 320),
    itemSize = CCSizeMake(512, 82),
    initHandler = self:getInitHandler(),
    useBar = true,
    barPosition = "left",
    barLenOffset = -10,
    heightOffset = 10
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollview
  local function loadItem(index)
    local item = self.data[index]
    if not item then
      self:getScene():removeUpdateHandler("asyncCreateList")
      return
    end
    scrollView:push({key = index, data = item})
  end
  local index = 1
  self:getScene():registerUpdateHandler("asyncCreateList", function()
    loadItem(index)
    index = index + 1
  end)
end
class.createListLayer = createListLayer
local function pop(param)
  local function handler(data)
    local window = create(data, param)
    window:popWindow(100)
    ed.player:readExcavateHistory()
  end
  ed.registerNetReply("query_excavate_history", handler)
  local msg = ed.upmsg.excavate()
  local qeh = ed.upmsg.query_excavate_history()
  msg._query_excavate_history = qeh
  ed.send(msg, "excavate")
end
class.pop = pop

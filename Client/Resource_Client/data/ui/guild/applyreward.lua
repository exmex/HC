local guild = ed.ui.guild
local base = ed.ui.popwindow
local class = newclass(base.mt)
guild.applyreward = class
local getQueueRank = function(self, index)
  local data = self.param.detail
  local count = 0
  for i = 5, index, -1 do
    local t = "type" .. i
    for k, v in ipairs(data._queue_detail) do
      if v.queue_type == t then
        count = count + #(v._summary or {})
      end
    end
  end
  local pIndex = tonumber(string.match(self.param.queueType, "type(.)"))
  if index < pIndex then
    count = count - 1
  end
  return count + 1
end
class.getQueueRank = getQueueRank
local applyConfirm = function(self, callback)
  local param = self.param
  local itemid = param.item.itemId
  local rank = self:getQueueRank(self.index)
  local name = ed.readequip.value(itemid, "Name")
  local cost = ed.ui.guild.apply_cost_list[tonumber(self.index)]
  local qt = param.queueType
  local pIndex = string.match(qt, "type(.)")
  local preCost = ed.ui.guild.apply_cost_list[tonumber(pIndex)]
  local diffCost = cost - preCost
  if diffCost == 0 then
    if callback then
      callback()
    end
    return
  end
  local t1 = diffCost > 0 and T(LSTR("applyreward.1.10.001")) or T(LSTR("applyreward.1.10.002"))
  local width = 400
  local ui_param = {
    t = "VerticalNode",
    ui = {
      {
        t = "Label",
        base = {
          text = T(LSTR("applyreward.1.10.003"), name, rank),
          size = 20
        },
        config = {
          dimensions = CCSizeMake(width, 0),
          color = ccc3(255, 244, 123),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      },
      {
        t = "HorizontalNode",
        base = {offset = 10},
        ui = {
          {
            t = "Label",
            base = {text = t1, size = 20},
            config = {
              color = ccc3(255, 244, 123)
            }
          },
          {
            t = "Sprite",
            base = {
              res = "UI/alpha/HVGA/money_guildtoken_small.png"
            }
          },
          {
            t = "Label",
            base = {
              text = tostring(math.abs(diffCost)),
              size = 20
            },
            config = {
              color = ccc3(255, 188, 63)
            }
          }
        }
      },
      {
        t = "Label",
        base = {
          text = T(LSTR("applyreward.1.10.004")),
          size = 20,
          offset = 10
        },
        config = {
          color = ccc3(255, 244, 123)
        }
      }
    }
  }
  ed.popConfirmDialog({
    node = ed.readnode.getFeralNode(ui_param),
    rightHandler = callback,
    rightText = T(LSTR("guildinstancereward.1.10.009"))
  })
end
class.applyConfirm = applyConfirm
local changeConfirm = function(self, callback)
  local param = self.param
  local applyid = param.applyItemid
  local itemid = param.item.itemId
  local qt = param.queueType
  local pIndex = string.match(qt, "type(.)")
  local index = self.index
  local preName = ed.readequip.value(applyid, "Name")
  local name = ed.readequip.value(itemid, "Name")
  local preCost = ed.ui.guild.apply_cost_list[tonumber(pIndex)]
  local cost = ed.ui.guild.apply_cost_list[tonumber(index)]
  local diffCost = cost - preCost
  local aText = diffCost > 0 and T(LSTR("applyreward.1.10.005")) or T(LSTR("applyreward.1.10.006"))
  aText = diffCost == 0 and "" or T(LSTR("applyreward.1.10.007"), preName, aText)
  local t1 = T(LSTR("applyreward.1.10.008"), preCost, preName, cost, name, aText)
  local width = 400
  local vui = {}
  table.insert(vui, {
    t = "Label",
    base = {text = t1, size = 20},
    layout = {},
    config = {
      color = ccc3(255, 244, 123),
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(width, 0)
    }
  })
  if diffCost ~= 0 then
    table.insert(vui, {
      t = "HorizontalNode",
      base = {
        contentSize = CCSizeMake(width, 30)
      },
      ui = {
        {
          t = "Sprite",
          base = {
            res = "UI/alpha/HVGA/money_guildtoken_small.png"
          }
        },
        {
          t = "Label",
          base = {
            text = tostring(math.abs(diffCost)),
            size = 20
          },
          config = {}
        }
      }
    })
  end
  table.insert(vui, {
    t = "Label",
    base = {
      text = T(LSTR("applyreward.1.10.009")),
      size = 20
    },
    config = {
      color = ccc3(255, 244, 123),
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(width, 0)
    }
  })
  local ui_param = {
    t = "VerticalNode",
    base = {offset = 10},
    layout = {},
    config = {},
    ui = vui
  }
  ed.popConfirmDialog({
    node = ed.readnode.getFeralNode(ui_param),
    rightHandler = callback
  })
end
class.changeConfirm = changeConfirm
local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterButtonClick({
    button = ui.apply_detail_button,
    press = ui.apply_detail_button_press,
    key = "apply_detail_button",
    clickHandler = function()
      ed.registerNetReply("guild_app_queue", function(data)
        if data._queue_detail then
          package.loaded["ui/guild/applydetail"] = nil
          require("ui/guild/applydetail")
          self.mainLayer:addChild(guild.applydetail.create(data).mainLayer)
        else
          ed.showToast(T(LSTR("applyreward.1.10.010")))
        end
      end)
      local msg = ed.upmsg.guild()
      msg._guild_app_queue = {}
      msg._guild_app_queue._item_id = self.param.item.itemId
      ed.send(msg, "guild")
    end,
    clickInterval = 0.2
  })
  local function doApply()
    ed.registerNetReply("guild_instance_apply", function(data)
      local result = data._result == "success"
      if result then
        if self.index then
          ed.showToast(T(LSTR("applyreward.1.10.011")))
        else
          ed.showToast(T(LSTR("applyreward.1.10.012")))
        end
        local param = self.param
        if param.queueType then
          local index = tonumber(string.match(param.queueType, "type(.)"))
          ed.player:addGuildMoney(ed.ui.guild.apply_cost_list[index])
        end
        if self.index then
          ed.player:addGuildMoney(-ed.ui.guild.apply_cost_list[self.index])
        end
        if param.callback then
          param.callback(data._rank, self.index and "type" .. self.index or nil, self.index and param.item.itemId or nil)
        end
        self:destroy()
      elseif self.index then
        ed.showToast(T(LSTR("applyreward.1.10.013")))
      else
        ed.showToast(T(LSTR("applyreward.1.10.014")))
      end
    end)
    local msg = ed.upmsg.guild()
    local ia = ed.upmsg.guild_instance_apply()
    if self.index then
      ia._type = "type" .. self.index
    else
      ia._type = "cancel"
    end
    ia._item_id = self.param.item.itemId
    msg._instance_apply = ia
    ed.send(msg, "guild")
  end
  self:btRegisterButtonClick({
    button = ui.apply_button,
    press = ui.apply_button_press,
    key = "apply_button",
    clickHandler = function()
      if self.index then
        if ed.player:getGuildMoney() < guild.apply_cost_list[self.index] then
          ed.showToast(T(LSTR("applyreward.1.10.015")))
        else
          local param = self.param
          local applyid = param.applyItemid
          if applyid and applyid ~= param.item.itemId then
            self:changeConfirm(doApply)
          elseif param.queueType and param.queueType ~= "text" .. self.index then
            self:applyConfirm(doApply)
          else
            doApply()
          end
        end
      elseif self.param.applyItemid == self.param.item.itemId then
        doApply()
      else
        self:destroy()
      end
    end,
    clickInterval = 0.5
  })
  for i = 1, 5 do
    do
      local checkTag = ui["check_" .. i]
      local checkButton = ui["check_bg_" .. i]
      self:btRegisterRectClick({
        rect = ed.DGRectMake(-10, -10, 54, 56),
        parent = checkButton,
        pressHandler = function()
          checkButton:setScale(0.95)
        end,
        cancelPressHandler = function()
          checkButton:setScale(1)
        end,
        key = "check_button_" .. i,
        clickHandler = function()
          self:doSetCheckboxOn(i)
        end,
        force = true
      })
    end
  end
end
class.registerTouchHandler = registerTouchHandler
local refreshApplyButton = function(self)
  local applyLabel = self.ui.apply_button_label
  if self.index then
    ed.setString(applyLabel, T(LSTR("applyreward.1.10.016")))
  else
    ed.setString(applyLabel, T(LSTR("applyreward.1.10.017")))
  end
end
class.refreshApplyButton = refreshApplyButton
local doSetCheckboxOn = function(self, index)
  local ui = self.ui
  local preIndex = self.index
  self.index = index
  if preIndex == index then
    ui["check_" .. index]:setVisible(false)
    self.index = nil
  else
    if preIndex then
      ui["check_" .. preIndex]:setVisible(false)
    end
    ui["check_" .. index]:setVisible(true)
  end
  self:refreshApplyButton()
end
class.doSetCheckboxOn = doSetCheckboxOn
local initWindow = function(self)
  local param = self.param
  local item = param.item
  local applyid = param.applyItemid
  local queueType = param.queueType
  local itemid = item.itemId
  local ui = self.ui
  for i = 1, 5 do
    ui["check_" .. i]:setVisible(false)
  end
  local name = ed.readequip.value(itemid, "Name")
  ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("applydetail.1.10.002")) .. " " .. name,
      size = 20
    },
    layout = {
      position = ed.DGccp(308, 538)
    },
    config = {}
  }, ui.frame)
  if applyid == itemid then
    local index = tonumber(string.match(queueType, "type(.)"))
    self:doSetCheckboxOn(index)
  else
    self:refreshApplyButton()
  end
end
class.initWindow = initWindow
local function create(param)
  param = param or {}
  local self = base.create("guildapplyreward")
  setmetatable(self, class.mt)
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.applyguildreward)
  self:setContainer(container)
  self:initWindow()
  self:registerTouchHandler()
  return self
end
class.create = create

local guild = ed.ui.guild
local base = ed.ui.popwindow
local class = newclass(base.mt)
guild.applydetail = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    clickInterval = 0.2
  })
end
class.registerTouchHandler = registerTouchHandler
local initQueue = function(self, data)
  self.invalidListCount = self.invalidListCount or 0
  local container = self.draglist.listLayer
  local queueType = data.queue_type
  local index = tonumber(string.match(queueType, "type(.)"))
  local count = #(data._summary or {})
  if count == 0 then
    return
  end
  self.invalidListCount = self.invalidListCount + 1
  if self.invalidListCount > 1 then
    self.list_y = self.list_y - ed.DGLen(25)
    local delimeter = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      layout = {
        position = ed.DGccp(512, self.list_y)
      },
      config = {
        scalexy = {x = 1.1, y = 1}
      }
    }, container)
    self.list_y = self.list_y - ed.DGLen(5)
  end
  self.list_y = self.list_y - ed.DGLen(25)
  local countLabel = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("applydetail.1.10.001"), count),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(350, self.list_y)
    },
    config = {
      color = ccc3(255, 235, 158)
    }
  }, container)
  local icon = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/money_guildtoken_small.png"
    },
    layout = {
      position = ed.DGccp(600, self.list_y)
    }
  }, container)
  local cost = ed.createNode({
    t = "Label",
    base = {
      text = tostring(ed.ui.guild.apply_cost_list[index]),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(628, self.list_y)
    }
  }, container)
  self.list_y = self.list_y - 65
  self.list_y = self.list_y + ed.DGLen(100)
  for i, v in ipairs(data._summary) do
    self.list_y = self.list_y - ed.DGLen(100)
    local board = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/tip_detail_bg.png"
      },
      layout = {
        position = ed.DGccp(512, self.list_y)
      },
      config = {
        scalexy = {x = 3.29, y = 2.34}
      }
    }, container)
    local head = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.getTeamHead({
          id = v._avatar,
          vip = 0 < v._vip
        })
      },
      layout = {
        position = ed.DGccp(355, self.list_y)
      },
      config = {scale = 0.75}
    }, container)
    local level = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.getLevelIcon({
          level = v._level,
          vip = 0 < v._vip
        })
      },
      layout = {
        position = ed.DGccp(420, self.list_y)
      }
    }, container)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = v._name,
        size = 20
      },
      layout = {
        position = ed.DGccp(450, self.list_y),
        anchor = ccp(0, 0.5)
      }
    }, container)
  end
  self.list_y = self.list_y - ed.DGLen(50)
end
class.initQueue = initQueue
local initList = function(self)
  local data = self.param.data
  local queue = data._queue_detail or {}
  self.list_oy, self.list_y = 520, 520
  local index = 1
  while queue[index] do
    self:initQueue(queue[index])
    index = index + 1
  end
  self.draglist:initListHeight(ed.DGLen(self.list_oy - self.list_y) + 20)
end
class.initList = initList
local initListLayer = function(self)
  local param = {
    cliprect = ed.DGRectMake(235, 26, 558, 508),
    noshade = true,
    zorder = 20,
    container = self.mainLayer,
    priority = self.mainTouchPriority - 5,
    bar = {
      bglen = ed.DGLen(485),
      bgpos = ed.DGccp(228, 285)
    }
  }
  self.draglist = ed.draglist.create(param)
end
class.initListLayer = initListLayer
local initWindow = function(self)
  local ui = self.ui
  local data = self.param.data
  local id = data._item_id
  local name = ed.readequip.value(id, "Name")
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
end
class.initWindow = initWindow
local function create(data)
  local param = param or {}
  local self = base.create("guildapplydetail")
  setmetatable(self, class.mt)
  param.data = data
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.applyguildrewarddetail)
  self:setContainer(container)
  self:initWindow()
  self:initListLayer()
  self:registerTouchHandler()
  self.isSkipTransAnim = true
  self:registerOnEnterHandler("enter_apply_detail", function()
    self:initList()
  end)
  return self
end
class.create = create

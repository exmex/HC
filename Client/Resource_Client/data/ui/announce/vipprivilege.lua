local announce = ed.ui.announce
local base = announce.base
local class = newclass(base.mt)
announce.vipPrivilege = class
local getAfterShowHandler = function(self)
  local function handler()
    local ui = self.ui
    local light = ui.title_light
    local title = ui.title_label
    title:setScale(2)
    title:setVisible(true)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        light:setVisible(true)
        local r = CCRotateBy:create(5, 360)
        r = CCRepeatForever:create(r)
        light:runAction(r)
      end, EDDebug)
    end)
    title:runAction(ed.readaction.create({
      t = "seq",
      s,
      f
    }))
    self:stopRefreshCliprect()
  end
  return handler
end
class.getAfterShowHandler = getAfterShowHandler
local getAfterDestroyHandler = function(self)
  local function handler()
    self:stopRefreshCliprect()
  end
  return handler
end
class.getAfterDestroyHandler = getAfterDestroyHandler
local initHandler = function(self)
  function self.preShowHandler()
    self:beginRefreshCliprect()
  end
  function self.preDestroyHandler()
    self:beginRefreshCliprect()
  end
  self:setDestroyHandler(self:getAfterDestroyHandler())
end
class.initHandler = initHandler
local initTouchHandler = function(self)
  self.notClickDestroy = true
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.touchNode = touchNode
  local ui = self.ui
  touchNode:btRegisterButtonClick({
    button = ui.close_button,
    press = ui.close_button_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end
  })
  self.touchNode:btRegisterHandler({
    handler = self.draglist:getListLayerTouchHandler(),
    key = "list_drag"
  })
  self:registerTouchHandler(touchNode:btGetMainTouchHandler(), "main_handler")
end
class.initTouchHandler = initTouchHandler
local initDraglist = function(self)
  local info = {
    cliprect = ed.DGRectMake(10, -440, 542+85, 375),
    noshade = true,
    zorder = 10,
    container = self.ui.window_container
  }
  self.draglist = ed.draglist.create(info)
end
class.initDraglist = initDraglist
local initList = function(self)
  local clip_height = 292
  function createItem(index, data)
    local preText = data.preText
    local midText = data.midText
    local sufText = data.sufText
    local times = data.times
    local container
    local size = ed.DGSizeMake(542, 50)
    if index % 2 == 1 then
      container = ed.createSprite("UI/alpha/HVGA/announce_text_bg_purple.png")
      ed.fixNodeSize(container, size)
    else
      container = CCSprite:create()
      container:setContentSize(size)
    end
    local readnode = ed.readnode.create(container, self.item_ui)
    local ui_info = {
      {
        t = "HorizontalNode",
        base = {name = index},
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(60, 25)
        },
        config = {},
        ui = {
          {
            t = "Label",
            base = {
              name = "pre",
              text = preText .. " ",
              size = 20
            },
            layout = {},
            config = {
              color = ccc3(239, 197, 121)
            }
          },
          {
            t = "Label",
            base = {
              name = "mid",
              text = times or midText,
              size = 20
            },
            layout = {},
            config = {
              color = ccc3(255, 241, 215)
            }
          },
          {
            t = "Label",
            base = {
              name = "suf",
              text = " " .. sufText,
              size = 20
            },
            layout = {},
            config = {
              color = ccc3(239, 197, 121)
            }
          }
        }
      }
    }
    readnode:addNode(ui_info)
    return container
  end
  local previp = self.previp
  local vip = ed.player:getvip()
  local vipData = ed.getDataTable("VIP")
  local row = vipData[vip]
  local preRow = vipData[previp]
  local data = {}
  for i, r in ipairs(ed.getDataTable("Privilege")) do
    if r["Tutorial Display"] then
      local name = r.Name
      if row[name] ~= preRow[name] then
        local preTimes, times
        if type(row[name]) == "number" then
          preTimes = preRow[name]
          times = row[name]
        end
        table.insert(data, {
          preText = r["Pre Display"],
          midText = r["Mid Display"],
          sufText = r["Post Display"],
          preTimes = preTimes,
          times = times
        })
      end
    end
  end
  self.item_ui = {}
  local v_ui = {}
  for i, v in pairs(data) do
    table.insert(v_ui, {
      t = "CCNode",
      base = {
        name = i,
        node = createItem(i, data[i])
      }
    })
  end
  local itemMaxWidth = 0
  for i, v in ipairs(self.item_ui) do
    local width = v:getContentSize().width
    itemMaxWidth = math.max(itemMaxWidth, width)
  end
  if itemMaxWidth > 352+78 then
    local w = 78 - (itemMaxWidth - 352-78)
    for i, v in ipairs(self.item_ui) do
      v:setPosition(ccp(w + 10, 20))
    end
  else
    for i, v in ipairs(self.item_ui) do
      if i % 2 == 1 then
        v:setPosition(ccp(47, 20))
      end
    end
  end
  local ui_info = {
    {
      t = "VerticalNode",
      base = {name = "list_node"},
      layout = {
        anchor = ccp(0, 1),
        position = ccp(0, -56)
      },
      config = {},
      ui = v_ui
    }
  }
  local readnode = ed.readnode.create(self.draglist.listLayer, self.ui)
  readnode:addNode(ui_info)
  local listNode = self.ui.list_node
  local listHeight = listNode:getContentSize().height
  self.draglist:initListHeight(listHeight)
  if clip_height > listHeight then
    local dy = clip_height - listHeight
    local frame = self.ui.frame
    local size = frame:getContentSize()
    local w, h = size.width, size.height
    frame:setContentSize(CCSizeMake(w, h - dy))
    local wc = self.ui.window_container
    local x, y = wc:getPosition()
    wc:setPosition(ccp(x, y - dy / 2))
  end
end
class.initList = initList
local function create(param)
  param = param or {}
  local previp = param.previp or ed.player:getvip() - 1
  if previp < 0 then
    return
  end
  local self = base.create("vipPrivilege")
  setmetatable(self, class.mt)
  self.previp = previp
  local container = self.container
  local ui = {}
  self.ui = ui
  local ui_info = ed.uieditor.vipprivilege
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ui_info)
  self:initDraglist()
  self:initList()
  self:initHandler()
  self:initTouchHandler()
  self:show(self:getAfterShowHandler())
  return self
end
class.create = create

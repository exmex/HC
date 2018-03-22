local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stonedetail = class
local function checkStageOpen(id)
  local star = ed.player:getStageStar(id) or 0
  local preStar = ed.player:getStageStar(id - 1) or 0
  if star + preStar > 0 then
    return true
  else
    return false
  end
end
class.checkStageOpen = checkStageOpen
local registerRefreshCliprect = function(self)
  self.baseScene:registerUpdateHandler("refreshCliprect", self:refreshCliprect())
end
class.registerRefreshCliprect = registerRefreshCliprect
local removeRefreshCliprect = function(self)
  self.baseScene:removeUpdateHandler("refreshCliprect")
end
class.removeRefreshCliprect = removeRefreshCliprect
local refreshCliprect = function(self)
  local function handler()
    if tolua.isnull(self.container) then
      self:removeRefreshCliprect()
      return
    end
    self.draglist:refreshClipRect(self.container:getScale())
  end
  return handler
end
class.refreshCliprect = refreshCliprect
local function getRow(self)
  local id = self.id
  local ut = ed.getDataTable("Unit")
  local row = ut[id]
  return row
end
class.getRow = getRow
local getName = function(self)
  local row = self:getRow()
  return row["Display Name"]
end
class.getName = getName
local show = function(self)
  local container = self.container
  self:registerRefreshCliprect()
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:removeRefreshCliprect()
      self:refreshCliprect()()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  container:runAction(s)
end
class.show = show
local destroy = function(self)
  local container = self.container
  self:registerRefreshCliprect()
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:removeRefreshCliprect()
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.callback then
        self.callback()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  container:runAction(s)
end
class.destroy = destroy
local function createStoneAmount(self)
  if not tolua.isnull(self.amountContainer) then
    self.amountContainer:removeFromParentAndCleanup(true)
  end
  local hid = self.id
  local sid = self.stoneid
  local amount = ed.readhero.getStoneAmount(hid) or 0
  local need = ed.readhero.getStoneNeed(hid)
  if not need then
    return
  end
  local container = CCSprite:create()
  self.infoContainer:addChild(container)
  self.amountContainer = container
  local ec = ccc3(169, 91, 28)
  local nc = ccc3(226, 18, 18)
  local amountui = {}
  self.amountui = amountui
  local readnode = ed.readnode.create(container, amountui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "pre",
        text = "(",
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(100, 275)
      },
      config = {color = ec}
    },
    {
      t = "Label",
      base = {
        name = "amount",
        text = amount,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {array = amountui, name = "pre"}
      },
      config = {
        color = amount < need and nc or ec
      }
    },
    {
      t = "Label",
      base = {
        name = "need",
        text = string.format("/%d)", need),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {array = amountui, name = "amount"}
      },
      config = {color = ec}
    }
  }
  readnode:addNode(ui_info)
end
class.createStoneAmount = createStoneAmount
local function createIcon(self)
  local container = self.infoContainer
  local hid = self.id
  local sid = self.stoneid
  local icon = ed.readequip.createIcon(sid)
  self.ui.icon = icon
  icon:setPosition(ccp(60, 290))
  container:addChild(icon)
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "gw_title",
        text = T(LSTR("STONEDETAIL.WAY_TO_GET_")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(100, 300)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    }
  }
  readnode:addNode(ui_info)
end
class.createIcon = createIcon
local function doPressIn(self)
  local function handler(x, y)
    local gw = self.getways
    for i = 1, #gw do
      local g = gw[i]
      local board = g.board
      local icon = g.icon
      self.origwScale = icon:getScale()
      if ed.containsPoint(board, x, y) then
        icon:setScale(self.origwScale * 0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressIn = doPressIn
local cancelPressIn = function(self)
  local function handler(x, y, id)
    local gw = self.getways
    local g = gw[id]
    local board = g.board
    local icon = g.icon
    icon:setScale(self.origwScale)
  end
  return handler
end
class.cancelPressIn = cancelPressIn
local function doClickIn(self)
  local function handler(x, y, id)
    local gw = self.getways
    local g = gw[id]
    local board = g.board
    local icon = g.icon
    local id = g.id
    icon:setScale(self.origwScale)
    if ed.containsPoint(board, x, y) then
      local st = ed.stageType(id)
      if ed.isElementInTable(st, {"normal", "elite"}) then
        if checkStageOpen(id) then
          ed.pushScene(ed.ui.stageselect.createByStage(id))
        else
          ed.showToast(T(LSTR("EQUIPCRAFT.CHAPTER_YET_TO_OPEN")))
        end
      end
    end
  end
  return handler
end
class.doClickIn = doClickIn
local cancelClickIn = function(self)
  local function handler(x, y, id)
    local gw = self.getways
    local g = gw[id]
    local board = g.board
    local icon = g.icon
    icon:setScale(self.origwScale)
  end
  return handler
end
class.cancelClickIn = cancelClickIn
local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(0, 85, 800, 165),
    noshade = true,
    priority = -165,
    container = self.infoContainer,
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressIn(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelClickIn()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local function createList(self)
  local hid = self.id
  local sid = self.stoneid
  local container = self.draglist:getList()
  local getway = {}
  local et = ed.getDataTable("equip")[sid]
  local st = ed.getDataTable("Stage")
  local index = 1
  while et["Drop " .. index] do
    local s = et["Drop " .. index]
    if s and s > 0 then --ray --Hide Stage > 13
      local row = st[s]
      local chapter = row["Chapter ID"]
      if chapter <= ed.GameConfig.MaxChapter then
        table.insert(getway, s)
      end
    end
    index = index + 1
  end
  self.getways = {}
  local ox, oy = 142, 220
  for i = 1, #(getway or {}) do
    local id = getway[i]
    self.getways[i] = {}
    self.getways[i].id = id
    local readnode = ed.readnode.create(container, self.getways[i])
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "board",
          res = "UI/alpha/HVGA/equip_craft_getway_board.png"
        },
        layout = {
          position = ccp(ox, oy - 50 * (i - 1))
        },
        config = {isCascadeOpacity = true}
      }
    }
    readnode:addNode(ui_info)
    local board = self.getways[i].board
    local st = ed.getDataTable("Stage")
    local row = st[id]
    local isElite = ed.stageType(id) == "elite"
    readnode = ed.readnode.create(board, self.getways[i])
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "icon",
          res = ed.ui.stageselectres.getStageIcon(id)
        },
        layout = {
          position = ccp(35, 25)
        },
        config = {fix_height = 75}
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T(LSTR("EQUIPCRAFT._CHAPTER__D"), row["Chapter ID"]),
          size = 18,
          skipFormat = true
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(65, 35)
        },
        config = {
          color = ccc3(182, 65, 21)
        }
      },
      {
        t = "Label",
        base = {
          name = "elite",
          text = T(LSTR("EQUIPCRAFT.ELITE")),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          right2 = {
            array = self.getways[i],
            name = "title",
            offset = 6
          }
        },
        config = {
          color = ccc3(255, 0, 0),
          visible = isElite
        }
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = row["Stage Name"],
          size = 18,
          max_width = 160
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(68, 12)
        },
        config = {
          color = ccc3(182, 65, 21),
        }
      }
    }
    readnode:addNode(ui_info)
	--[[if self.getways[i].name:getContentSize().width > 160 then
		self.getways[i].name:setScale(160 / self.getways[i].name:getContentSize().width)
	end]]
  end
  self.draglist:initListHeight(50 * #(getway or {}))
  self:refreshGetwayLimit()
  if #getway <= 0 then
    self:createEmptyPrompt()
  end
end
class.createList = createList
local function refreshGetwayLimit(self)
  local ec = ccc3(169, 91, 28)
  local nc = ccc3(226, 18, 18)
  for i = 1, #self.getways do
    local gw = self.getways[i]
    local id = gw.id
    local board = gw.board
    local name = gw.name
    if not tolua.isnull(gw.limitContainer) then
      gw.limitContainer:removeFromParentAndCleanup(true)
    end
    local readnode = ed.readnode.create(board, gw)
    local ui
    local nodes = {}
    if checkStageOpen(id) then
      local limit = ed.getDataTable("Stage")[id]["Daily Limit"] or 0
      local s = ed.elite2NormalStage(id)
      local count = limit - ((ed.player.stage_limit or {})[s] or 0)
      if limit > 0 then
        ui = {
          {
            t = "Label",
            base = {text = "(", size = 16},
            layout = {},
            config = {color = ec}
          },
          {
            t = "Label",
            base = {text = count, size = 16},
            layout = {},
            config = {
              color = count > 0 and ec or nc
            }
          },
          {
            t = "Label",
            base = {
              text = string.format("/%d)", limit),
              size = 16
            },
            layout = {},
            config = {color = ec}
          }
        }
      end
    else
      ui = {
        {
          t = "Label",
          base = {
            text = T(LSTR("STONEDETAIL.NOT_YET_OPEN")),
            size = 16
          },
          layout = {},
          config = {color = nc}
        }
      }
    end
    if ui then
      local ui_info = {
        {
          t = "HorizontalNode",
          base = {
            name = "limitContainer"
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {},
          ui = ui
        }
      }
      readnode:addNode(ui_info)
      gw.limitContainer:setPosition(ed.getRightSidePos(gw.elite))
    end
  end
end
class.refreshGetwayLimit = refreshGetwayLimit
local function createEmptyPrompt(self)
  local ui = self.ui
  local bg = self.infoContainer
  local readnode = ed.readnode.create(bg, ui)
  local text = T(LSTR("STONEDETAIL.THE_HERO_DEBRIS_WILL_NOT_BE_GAINED_FROM_THIS_CROSS_TEMPORARILY"))
  local row = ed.getDataTable("equip")[self.stoneid] or {}
  local gt = row["How To Get"] or text
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "empty_prompt",
        text = gt,
        size = 18
      },
      layout = {
        position = ccp(142, 180)
      },
      config = {
        color = ccc3(109, 62, 0),
        dimension = CCSizeMake(240, 0),
      }
    }
  }
  readnode:addNode(ui_info)
end
class.createEmptyPrompt = createEmptyPrompt
local function create(param)
  local self = {}
  setmetatable(self, class.mt)
  if not param then
    return
  end
  local id = param.id
  self.id = id
  self.stoneid = ed.readhero.getStoneid(id)
  self.callback = param.callback
  self.baseScene = ed.getCurrentScene()
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/fragment_compose_bg.png"
      },
      layout = {
        position = ccp(400, 242)
      }
    }
  }
  readnode:addNode(ui_info)
  local infoContainer = CCSprite:create()
  container:addChild(infoContainer, 5)
  self.infoContainer = infoContainer
  infoContainer:setPosition(400, 242)
  infoContainer:setContentSize(CCSizeMake(285, 388))
  readnode = ed.readnode.create(infoContainer, ui)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = self:getName(),
        size = 18
      },
      layout = {
        position = ccp(142, 350)
      },
      config = {
        color = ccc3(184, 6, 6)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(290, 358)
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
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(142, 43)
      },
      config = {
        scaleSize = CCSizeMake(200, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(200, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T(LSTR("EQUIPCRAFT.RETURN")),
        fontinfo = "ui_normal_button",
        parent = "ok",
        z = 1
      },
      layout = {
        position = ccp(100, 24)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  self:createIcon()
  self:createListLayer()
  self:createList()
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -160, true)
  mainLayer:registerScriptHandler(function(event)
    xpcall(function()
      if event == "enter" then
        self:createStoneAmount()
        self:refreshGetwayLimit()
      end
    end, EDDebug)
  end)
  self:show()
  return self
end
class.create = create
local function dookButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.ok
  local press = ui.ok_press
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
class.dookButtonTouch = dookButtonTouch
local function doOutLayerTouch(self)
  local isPress
  local ui = self.ui
  local frame = ui.frame
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(frame, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not ed.containsPoint(frame, x, y) then
        self:destroy()
      end
      isPress = nil
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
local doMainLayerTouch = function(self)
  closeTouch = self:doCloseTouch()
  outTouch = self:doOutLayerTouch()
  okTouch = self:dookButtonTouch()
  local handler = function(event, x, y)
    xpcall(function()
      closeTouch(event, x, y)
      outTouch(event, x, y)
      okTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch

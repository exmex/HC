local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.midas = class
local getMultiCost = function(self)
  local gt = ed.getDataTable("GradientPrice")
  local cost = self:getCost()
  local count = 0
  local midasTimes = ed.player:getMidasTimes()
  local leftmidasTimes = ed.player:getMidasMaxTimes() -ed.player:getMidasTimes()
  while (gt[midasTimes + count + 1] or {}).Midas == cost and leftmidasTimes > count do
    count = count + 1
  end
  return count, cost, self:getAcquire() * count
end
class.getMultiCost = getMultiCost
local getCost = function(self)
  local gt = ed.getDataTable("GradientPrice")
  return (gt[ed.player:getMidasTimes() + 1] or {}).Midas
end
class.getCost = getCost
local getAcquire = function(self)
  local plt = ed.getDataTable("PlayerLevel")
  local mt = ed.getDataTable("Midas")
  local t = ed.player:getMidasTimes() + 1
  local yd = (mt[t] or {})["Yield 1"]
  if not yd then
    return nil
  else
    local money = plt[ed.player:getLevel()]["Midas Money"] * yd
    return math.floor(money)
  end
end
class.getAcquire = getAcquire
local playGetAcquireAnim = function(self, times, money, playDelay, isLast)
  local function getAction(config)
    if not config then
      return true
    end
    local node = config.node
    if tolua.isnull(node) then
      return true
    end
    local handler = config.handler
    local delay = config.delay
    local endpos = config.endpos or ccp(400, 400)
    local pd
    if playDelay then
      pd = CCDelayTime:create(playDelay)
    end
    local f1 = CCCallFunc:create(function()
      xpcall(function()
        node:setVisible(true)
      end, EDDebug)
    end)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local d
    if delay then
      d = CCDelayTime:create(delay)
    end
    local func1 = CCCallFunc:create(function()
      xpcall(function()
        if handler then
          handler()
        end
      end, EDDebug)
    end)
    local m = CCMoveTo:create(1, endpos)
    local f = CCFadeOut:create(1)
    local func2 = CCCallFunc:create(function()
      xpcall(function()
        node:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    return ed.readaction.create({
      t = "seq",
      pd,
      f1,
      s,
      d,
      func1,
      {
        t = "sp",
        m,
        f
      },
      func2
    })
  end
  local times_res = {
    "",
    "UI/alpha/HVGA/midas/midas_crip2.png",
    "UI/alpha/HVGA/midas/midas_crip3.png",
    "UI/alpha/HVGA/midas/midas_crip10.png"
  }
  if times > 1 then
    local node = ed.createNode({
      t = "Sprite",
      base = {
        res = times_res[times]
      },
      layout = {
        position = ccp(400, 320)
      },
      config = {scale = 3, visible = false}
    }, self.container, 10)
    local a = getAction({
      node = node,
      delay = 0.5,
      endpos = ccp(400, 440)
    })
    node:runAction(a)
  end
  local node = ed.createNode({
    t = "Sprite",
    layout = {
      position = ccp(400, 280)
    },
    config = {
      scale = 3,
      visible = false,
      isCascadeOpacity = true
    }
  }, self.container)
  local title = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/midas/midas_get_money.png"
    },
    layout = {
      anchor = ccp(1, 0.5)
    }
  }, node)
  local sc = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.getNumberNode({
        text = tostring(money),
        path = "UI/alpha/HVGA/midas",
        suffix = ".png"
      }).node
    },
    layout = {
      anchor = ccp(0, 0.5)
    },
    config = {isCascadeOpacity = true}
  }, node)
  local a = getAction({
    node = node,
    delay = 0.2,
    handler = function()
      if isLast then
        self:setUseButtonEnabled(true)
      end
    end
  })
  node:runAction(a)
end
class.playGetAcquireAnim = playGetAcquireAnim
local doUseReply = function(self, data)
  local function handler(acquire, addition)
    xpcall(function()
      addition = addition or {}
      ed.ui.baselsr.create():report("useMidas")
      if self.refreshHandler then
        self.refreshHandler()
      end
      self:refreshTimesBoard()
      self:refreshCost()
      self:refreshButton()
      local history = {}
      for i, v in ipairs(acquire) do
        table.insert(history, {
          cost = data.cost,
          acquire = v._money,
          ratio = v._type
        })
      end
      self:createHistory(history, addition.animOriMoney)
      for i, v in ipairs(acquire) do
        self:playGetAcquireAnim(v._type, v._money, 0.4 * (i - 1), i == #acquire)
      end
    end, EDDebug)
  end
  return handler
end
class.doUseReply = doUseReply
local doUse = function(self, times)
  times = times or 1
  local cost = self:getCost() * times
  if cost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  ed.registerNetReply("use_midas", self:doUseReply({
    cost = self:getCost(),
    times = times
  }), {cost = cost, times = times})
  local msg = ed.upmsg.midas()
  msg._times = times
  ed.send(msg, "midas")
  self:setUseButtonEnabled(false)
end
class.doUse = doUse
local doRecharge = function(self)
  local rechargeLayer = newrecharge.create()
  self.mainLayer:addChild(rechargeLayer, 100)
end
class.doRecharge = doRecharge
local setUseButtonEnabled = function(self, enable)
  local munc = ccc3(255, 255, 255)
  local unc = ccc3(231, 206, 19)
  local dc = ccc3(150, 150, 150)
  local ui = self.ui
  local shade = ui.use_disabled
  local label = ui.use_label
  local mulShade = ui.multi_use_disabled
  local mulLasbel = ui.multi_use_label
  if enable then
    shade:setVisible(false)
    ed.setLabelColor(label, unc)
    ed.setLabelColor(mulLasbel, munc)
    mulShade:setVisible(false)
  else
    shade:setVisible(true)
    ed.setLabelColor(label, dc)
    mulShade:setVisible(true)
    ed.setLabelColor(mulLasbel, dc)
  end
  self.forbidUse = not enable
end
class.setUseButtonEnabled = setUseButtonEnabled
local refreshCostBoard = function(self)
  local ui = self.ui
  if not tolua.isnull(ui.costBoard) then
    ui.costBoard:removeFromParentAndCleanup(true)
  end
  local costItems = {}
  self.costItems = costItems
  ui_info = {
    t = "HorizontalNode",
    base = {nodeArray = costItems},
    layout = {
      position = ccp(213, 120)
    },
    ui = {
      {
        t = "Sprite",
        base = {
          name = "rmb_icon",
          res = "UI/alpha/HVGA/task_rmb_icon_2.png"
        }
      },
      {
        t = "Label",
        base = {
          name = "rmb",
          text = self:getCost(),
          size = 18,
          offset = 10
        },
        config = {
          color = ccc3(49, 219, 255)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "arrow",
          res = "UI/alpha/HVGA/player_levelup_arrow.png",
          offset = 20
        }
      },
      {
        t = "Sprite",
        base = {
          name = "money_icon",
          res = "UI/alpha/HVGA/task_gold_icon_2.png",
          offset = 20
        }
      },
      {
        t = "Label",
        base = {
          name = "money",
          text = self:getAcquire(),
          size = 18,
          offset = 10
        },
        config = {
          color = ccc3(255, 165, 49)
        }
      }
    }
  }
  ui.costBoard = ed.createNode(ui_info, ui.content)
end
class.refreshCostBoard = refreshCostBoard
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.use,
    press = ui.use_press,
    key = "use_button",
    extraCheckHandler = function()
      return not self.forbidUse
    end,
    clickHandler = function()
      if ed.player:getMidasTimes() < ed.player:getMidasMaxTimes() then
        self:doUse()
      else
        self:doRecharge()
      end
    end
  })
  self:btRegisterButtonClick({
    button = ui.multi_use,
    press = ui.multi_use_press,
    key = "multi_use",
    extraCheckHandler = function()
      return not self.forbidUse
    end,
    clickHandler = function()
      self:createMultiWindow()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local refreshTimesBoard = function(self)
  local ui = self.ui
  if not tolua.isnull(ui.timesBoard) then
    ui.timesBoard:removeFromParentAndCleanup(true)
  end
  if not (ed.player:getMidasTimes() < ed.player:getMidasMaxTimes()) or not ccc3(221, 203, 172) then
  end
  local ui_info = {
    t = "HorizontalNode",
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(235, 225)
    },
    ui = {
      {
        t = "Label",
        base = {
          text = T(LSTR("MIDAS.AVAILABLE_TODAY")),
          size = 16
        },
        config = {
          color = ccc3(231, 185, 108)
        }
      },
      {
        t = "Label",
        base = {
          text = ed.player:getMidasMaxTimes() - ed.player:getMidasTimes(),
          size = 16
        },
        config = {
          color = ccc3(255, 0, 0)
        }
      },
      {
        t = "Label",
        base = {
          text = "/" .. ed.player:getMidasMaxTimes(),
          size = 16
        },
        config = {
          color = ccc3(221, 203, 172)
        }
      },
      {
        t = "Label",
        base = {text = ")", size = 16},
        config = {
          color = ccc3(231, 185, 108)
        }
      }
    }
  }
  ui.timesBoard = ed.createNode(ui_info, ui.content)
end
class.refreshTimesBoard = refreshTimesBoard
local refreshCost = function(self)
  if tolua.isnull(self.ui.prompt) or tolua.isnull(self.ui.costBoard) then
    return
  end
  if ed.player:getMidasTimes() < ed.player:getMidasMaxTimes() then
    self.ui.prompt:setVisible(false)
    self.ui.costBoard:setVisible(true)
    self:refreshCostBoard()
  else
    self.ui.prompt:setVisible(true)
    self.ui.costBoard:setVisible(false)
  end
end
class.refreshCost = refreshCost
local refreshButton = function(self)
  local times = ed.player:getMidasTimes()
  local maxTimes = ed.player:getMidasMaxTimes()
  local label = self.ui.use_label
  local str
  if times < maxTimes then
    str = T(LSTR("MIDAS.USE"))
  else
    str = T(LSTR("MIDAS.VIEW_VIP"))
  end
  ed.setString(label, str)
end
class.refreshButton = refreshButton
local initHistoryItemHandler = function(self)
  local handler = function(param)
    if not param then
      return
    end
    local cost = param.cost
    local acquire = param.acquire
    local ratio = param.ratio
    local container = param.container
    local ratio_config = {
      [1] = {
        ratio = 1,
        color = ccc3(255, 104, 174),
        size = 20
      },
      [2] = {
        ratio = 2,
        color = ccc3(255, 104, 174),
        size = 20,
        ratio_res = "UI/alpha/HVGA/midas/midas_crip2.png"
      },
      [3] = {
        ratio = 3,
        color = ccc3(255, 104, 174),
        size = 20,
        ratio_res = "UI/alpha/HVGA/midas/midas_crip3.png"
      },
      [4] = {
        ratio = 10,
        color = ccc3(194, 91, 68),
        size = 21,
        ratio_res = "UI/alpha/HVGA/midas/midas_crip10.png"
      }
    }
    local rc = ratio_config[ratio]
    local ui_info = {
      t = "HorizontalNode",
      layout = {
        anchor = ccp(0, 1)
      },
      ui = {
        {
          t = "Label",
          base = {
            text = T(LSTR("MIDAS.USE")),
            size = 20
          },
          config = {
            color = ccc3(255, 246, 143)
          }
        },
        {
          t = "Label",
          base = {
            text = cost,
            size = 20,
            offset = 5
          },
          config = {
            color = ccc3(50, 223, 253)
          }
        },
        {
          t = "Sprite",
          base = {
            res = "UI/alpha/HVGA/shop_token_icon.png",
            offset = 5
          },
          config = {
            fix_height = ed.DGLen(30)
          }
        },
        {
          t = "Label",
          base = {
            text = T(LSTR("ADDEQUIP.GET")),
            size = 20,
            offset = 10
          },
          config = {
            color = ccc3(255, 246, 143)
          }
        },
        {
          t = "Sprite",
          base = {
            res = "UI/alpha/HVGA/goldicon_small.png",
            offset = 5
          },
          config = {
            fix_height = ed.DGLen(35)
          }
        },
        {
          t = "Label",
          base = {
            text = acquire,
            size = 20,
            offset = 5
          },
          config = {
            color = ccc3(255, 175, 52)
          }
        }
      }
    }
    local icon = ed.createNode(ui_info, container)
    if rc.ratio_res then
      ed.createNode({
        t = "Sprite",
        base = {
          res = rc.ratio_res
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ed.DGccp(330, 13)
        }
		,config = {fix_height = 30}
      }, icon)
    end
    return {icon = icon}
  end
  return handler
end
class.initHistoryItemHandler = initHistoryItemHandler
local createMultiWindow = function(self)
  if ed.player:getMidasTimes() >= ed.player:getMidasMaxTimes() then
    ed.showToast(T(LSTR("midas.1.10.1.001")))
    return
  end
  local count, cost, acquire = self:getMultiCost()
  local ui_info = {
    t = "ChaosNode",
    ui = {
      {
        {
          t = "Label",
          base = {
            text = T(LSTR("midas.1.10.1.002")),
            size = 18
          },
          config = {
            color = ccc3(231, 185, 108)
          }
        },
        {
          t = "Label",
          base = {
            text = count,
            size = 18,
            offset = 5
          },
          config = {
            color = ccc3(255, 243, 206)
          }
        },
        {
          t = "Label",
          base = {
            text = T(LSTR("midas.1.10.1.003")),
            size = 18,
            offset = 5
          },
          config = {
            color = ccc3(231, 185, 108)
          }
        }
      },
      {
        offset = 20,
        {
          t = "Label",
          base = {
            text = T(LSTR("midas.1.10.1.004")),
            size = 18
          },
          config = {
            color = ccc3(231, 185, 108)
          }
        },
        {
          t = "Sprite",
          base = {
            res = "UI/alpha/HVGA/shop_token_icon.png",
            offset = 10
          },
          config = {fix_height = 30}
        },
        {
          t = "Label",
          base = {
            text = "x" .. count * cost,
            size = 18,
            offset = 20
          },
          config = {
            color = ccc3(50, 190, 223)
          }
        }
      },
      {
        offset = 20,
        {
          t = "Label",
          base = {
            text = T(LSTR("midas.1.10.1.005")),
            size = 18
          },
          config = {
            color = ccc3(231, 185, 108)
          }
        },
        {
          t = "Sprite",
          base = {
            res = "UI/alpha/HVGA/goldicon_small.png",
            offset = 10
          },
          config = {fix_height = 30}
        },
        {
          t = "Label",
          base = {
            text = "x" .. acquire,
            size = 18,
            offset = 20
          },
          config = {
            color = ccc3(255, 170, 50)
          }
        }
      }
    }
  }
  ed.popConfirmDialog({
    node = ed.readnode.getFeralNode(ui_info),
    widthMax = true,
    rightHandler = function()
      self:doUse(count)
    end
  })
end
class.createMultiWindow = createMultiWindow
local refreshHistory = function(self, history, animOriMoney)
  local scrollView = self.scrollView
  local function playMoneyAnim(index)
    local acq = history[index].acquire
    if animOriMoney and acq then
      animOriMoney = animOriMoney + acq
      if self:getScene().updateMRV then
        self:getScene():updateMRV("money", animOriMoney)
      end
    end
  end
  local function loadItem(index)
    if index > #history then
      self:removeUpdateHandler("load_history")
      return
    end
    playMoneyAnim(index)
    local v = history[index]
    scrollView:push({
      cost = v.cost,
      acquire = v.acquire,
      ratio = v.ratio or 1
    })
  end
  local count = 0.4
  local index = 1
  self:registerUpdateHandler("load_history", function(dt)
    if tolua.isnull(self.mainLayer) then
      ed.player.addMoneySilent = nil
      self:removeUpdateHandler("load_history")
      return
    end
    count = count + dt
    if count > 0.4 then
      count = count - 0.4
      loadItem(index)
      index = index + 1
      scrollView:move2end(0.4)
    end
  end)
end
class.refreshHistory = refreshHistory
local createHistory = function(self, history, animOriMoney)
  local ui = self.ui
  if not tolua.isnull(ui.history_frame) then
    self:refreshHistory(history, animOriMoney)
    return
  end
  self.isSkipDestroyAnim = true
  local container = self.container
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "history_frame",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(10, 10, 58, 26)
      },
      layout = {
        position = ccp(400, 115)
      },
      config = {
        scaleSize = CCSizeMake(425, 125)
      }
    }
  }
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ui_info)
  local info = {
    cliprect = ed.DGRectMake(35, 10, 480, 145),
    noshade = true,
    zorder = 5,
    container = ui.history_frame,
    priority = self.mainTouchPriority - 5,
    direction = "v",
    oriPosition = ed.DGccp(45, 135),
    itemSize = ed.DGSizeMake(435, 35),
    initHandler = self:initHistoryItemHandler(),
    useBar = true,
    barPosition = "left",
    barLenOffset = -10,
    barPosOffset = ccp(-16, 0),
    barThick = 3,
    heightOffset = 20
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollView
  self:refreshHistory(history, animOriMoney)
end
class.createHistory = createHistory
local function create(param)
  local self = base.create("midas")
  setmetatable(self, class.mt)
  param = param or {}
  self.callback = param.callback
  self.refreshHandler = param.refreshHandler
  function self.destroyCallback()
    if self.callback then
      self.callback()
    end
    ed.ui.baselsr.create():report("closeMidasWindow")
  end
  local mainLayer = self.mainLayer
  local container = self.container
  local ui = self.ui
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/main_vit_tips.png",
        capInsets = CCRectMake(10, 10, 58, 26)
      },
      layout = {
        position = ccp(400, 305)
      },
      config = {
        scaleSize = CCSizeMake(425, 245)
      }
    },
    {
      t = "Sprite",
      base = {name = "content", parent = "frame"},
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, -10)
      }
    }
  }
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ui_info)
  local prompt = T(LSTR("MIDAS.YOUVE_USED_UP_DAILY_GOLDEN_HAND_TIMES_\N_UPGRADING_YOUR_VIP_LEVEL_OFFERS_YOU_MORE_TIMES"))
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "icon_frame",
        res = "UI/alpha/HVGA/equip_frame_white.png"
      },
      layout = {
        position = ccp(100, 205)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "icon",
        res = "UI/alpha/HVGA/midas_icon.png"
      },
      layout = {
        position = ccp(100, 206)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = T(LSTR("MIDAS.GOLDEN_HAND")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(155, 225)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "desc",
        text = T(LSTR("MIDAS.USE_A_SMALL_AMOUNT_OF_DIAMONDS_IN_EXCHANGE_FOR_LARGE_SUMS_OF_MONEY")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(155, 185)
      },
      config = {
        color = ccc3(231, 185, 108)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "cost_board",
        res = "UI/alpha/HVGA/tip_detail_bg.png"
      },
      layout = {
        position = ccp(213, 120)
      },
      config = {
        fix_size = CCSizeMake(425, 76)
      }
    },
    {
      t = "Label",
      base = {
        name = "prompt",
        text = prompt,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(70, 120)
      },
      config = {
        color = ccc3(231, 185, 108),
        horizontalAlignment = kCCTextAlignmentLeft
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "use",
        res = "UI/alpha/HVGA/tavern_button_1.png",
        capInsets = CCRectMake(10, 10, 108, 29)
      },
      layout = {
        position = ccp(125, 50)
      },
      config = {
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "use_press",
        res = "UI/alpha/HVGA/tavern_button_2.png",
        capInsets = CCRectMake(10, 10, 108, 29),
        parent = "use"
      },
      layout = {mediate = true},
      config = {
        visible = false,
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "use_disabled",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(10, 10, 108, 29),
        parent = "use"
      },
      layout = {mediate = true},
      config = {
        visible = false,
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "use_label",
        text = T(LSTR("MIDAS.USE")),
        fontinfo = "ui_normal_button",
        parent = "use",
        z = 10
      },
      layout = {mediate = true},
      config = {
        color = ccc3(231, 206, 19)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "multi_use",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(10, 10, 108, 29)
      },
      layout = {
        position = ccp(300, 50)
      },
      config = {
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "multi_use_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(10, 10, 108, 29),
        parent = "multi_use"
      },
      layout = {mediate = true},
      config = {
        visible = false,
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "multi_use_disabled",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(10, 10, 108, 29),
        parent = "multi_use"
      },
      layout = {mediate = true},
      config = {
        visible = false,
        scaleSize = CCSizeMake(150, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "multi_use_label",
        text = T(LSTR("midas.1.10.1.002")),
        fontinfo = "ui_normal_button",
        parent = "multi_use"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(231, 231, 231)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ed.DGccp(524, 305)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
        parent = "close"
      },
      layout = {mediate = true},
      config = {visible = false}
    }
  }
  readnode = ed.readnode.create(ui.content, ui)
  readnode:addNode(ui_info)
  self:refreshMultiUseButton()
  self:refreshCostBoard()
  self:refreshTimesBoard()
  self:refreshCost()
  self:refreshButton()
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create
local refreshMultiUseButton = function(self)
  local ui = self.ui
  if ed.playerlimit.checkAreaUnlock("Multiple Midas") then
    ui.use:setPosition(ccp(130, 50))
    ui.multi_use:setVisible(true)
  else
    ui.use:setPosition(ccp(210, 50))
    ui.multi_use:setVisible(false)
  end
end
class.refreshMultiUseButton = refreshMultiUseButton
local dealUse = function(reply)
  local acquire = reply._acquire or {}
  local handler, data = ed.getNetReply("use_midas")
  local animOriMoney = ed.player._money
  if data then
    local money = 0
    for i, v in ipairs(acquire) do
      money = money + v._money
    end
    local cost = data.cost
    local times = data.times or 1
    ed.player:addrmb(-cost)
    ed.player:addMoney(money, true)
    ed.player:useMidasTimes(times)
  end
  if handler then
    handler(acquire, {animOriMoney = animOriMoney})
  end
  ed.record:refreshCommonRecord("midasUse")
end
class.dealUse = dealUse

local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.eatexplist = class
local lsr = ed.ui.eatexplistlsr.create()
local useProp = function(self, useAmount)
  self.useAmount = self.useAmount or 0
  if self.useAmount >= self.amount then
    ed.showToast(ed.getDataTable("equip")[self.id].Name .." ".. T(LSTR("EATEXPLIST.ALL_COMSUMED")))
    return false
  end
  self.useAmount = self.useAmount + 1
  return true
end
class.useProp = useProp
local syncAmount = function(self)
  self.amount = self.amount - self.useAmount
  self.useAmount = 0
end
class.syncAmount = syncAmount
local function destroy(self)
  lsr:report("closeWindow")
  base.destroy(self)
end
class.destroy = destroy
local function create(id, amount, param)
  local self = base.create("eatexp", param)
  setmetatable(self, class.mt)
  self.baseScene = ed.getCurrentScene()
  local mainLayer = self.mainLayer
  local container = self.container
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/equip_detail_title_bg.png"
      },
      layout = {
        position = ccp(400, 399)
      },
      config = {}
    },
	  {
		  t = "Sprite",
		  base = {
			  name = "title_bg_1",
			  res = "UI/alpha/HVGA/crusade_title_short_bg.png",
			  z = 10
		  },
		  layout = {
			  position = ccp(400, 379)
		  },
		  config = {}
	  },
    {
      t = "Label",
      base = {
        name = "title",
        text = T(LSTR("EATEXPLIST.CHOOSE_A_HERO")),
		fontinfo = "ui_normal_button",
        size = 24,
		z = 11
      },
      layout = {
        position = ccp(400, 379)
      },
      config = {
        color = ccc3(250, 205, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/package_herolist_bg.png"
      },
      layout = {
        position = ccp(400, 215)
      },
      config = {
        fix_wh = {h = 345}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png",
        z = 1
      },
      layout = {
        position = ccp(668, 360)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "closePress",
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
  readnode:addNode(ui_info)
  self.exp = ed.getDataTable("equip")[id].Exp
  self.id = id
  self.amount = amount
  self.eatLocked = nil
  self:createListLayer()
  self:createList()
  self:registerTouchHandler()
  self.refreshCliprectConfig = {}
  function self.destroyCallback()
    self:doSendConsume()
  end
  self:show()
  return self
end
class.create = create
local registerTouchHandler = function(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  local area = ui.frame
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_frame",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.closePress,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end
  })
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.mainTouchPriority, true)
end
class.registerTouchHandler = registerTouchHandler
local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(0, 55, 800, 320),
    rect = CCRectMake(120, 55, 570, 320),
    container = self.container,
    priority = -135,
    bar = {
      bglen = 290,
      bgpos = ccp(145, 215)
    },
    doClickIn = self:endPressList("doClick"),
    cancelClickIn = self:endPressList("cancelClick"),
    doPressIn = self:doPressList(),
    cancelPressIn = self:endPressList("cancelPress"),
    outoffset = CCSizeMake(30, 20)
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local createList = function(self)
  local list = ed.orderHeroes()
  self.heroes = {}
  local len = #list
  local item_name = ed.getDataTable("equip")[self.id].Name
  local prompt = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("eatexplist.1.10.1.001")) .." ".. item_name,
      size = 20
    },
    layout = {
      position = ccp(400, 330)
    }
  }, self.draglist.listLayer)
  for i = 1, len do
    local info = list[i]
    local hero = self:createHero(i, info)
    hero:setAnchorPoint(ccp(0.5, 0.5))
    hero:setPosition(ccp(158 + 245 * ((i - 1) % 2) + 120, 330 - prompt:getContentSize().height - 100 * math.floor((i - 1) / 2) - 48))
    self.draglist:addItem(hero)
  end
  self.draglist:initListHeight(math.ceil(len / 2) * 100 - 5 + 70)
end
class.createList = createList
local createHero = function(self, i, info)
  local bg = ed.createSprite("UI/alpha/HVGA/package_hero_bg.png")
  local unit = ed.getDataTable("Unit")[info._tid]
  local head = ed.readhero.createIconByID(info._tid, {state = "idle"})
  local headIcon = ed.createNode({
    t = "CCNode",
    base = {
      node = head.icon
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 9)
    }
  }, bg)
  head:setLevelVisible(false)
  local level = ed.createNode({
    t = "Label",
    base = {
      text = T("LV:%d", info._level),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96, 40)
    },
    config = {
      color = ccc3(68, 51, 51)
    }
  }, bg)
  local name = unit["Display Name"]
  local rank = info._rank
  local nameLabel, w = ed.readhero.createHeroNameByInfo({name = name, rank = rank, shadow = { color = ccc3(0, 0, 0), offset = ccp(0, 2) }})
  local ow = 100
  if w > ow then
    nameLabel:setScale(ow / w)
  end
  nameLabel:setPosition(ccp(178 - math.min(ow, w) / 2, 72))
  bg:addChild(nameLabel)
  local type = ed.getDataTable("Unit")[info._tid]["Hero Type"]
  local mark
  if type == T(LSTR("HERO_EQUIP.STRENGTH")) then
    mark = "UI/alpha/HVGA/icon_str.png"
  elseif type == T(LSTR("HERO_EQUIP.AGILITY")) then
    mark = "UI/alpha/HVGA/icon_agi.png"
  elseif type == T(LSTR("HERO_EQUIP.INTELLIGENCE")) then
    mark = "UI/alpha/HVGA/icon_int.png"
  end
  local markIcon = ed.createSprite(mark)
  markIcon:setPosition(ccp(110, 72))
  markIcon:setScale(0.8)
  bg:addChild(markIcon)
  local exp = info._exp
  local maxExp = ed.lookupDataTable("Levels", "Exp", info._level)
  local scaleX = exp / maxExp
  local expBarBg = ed.createSprite("UI/alpha/HVGA/package_exp_bar_bg.png")
  expBarBg:setPosition(ccp(162, 20))
  bg:addChild(expBarBg)
  local data = {
    tid = info._tid,
    bg = bg,
    head = head,
    level = level,
    name = name,
    nameLabel = nameLabel,
    lvNumber = info._level,
    exp = exp,
    maxExp = maxExp,
    expBarBg = expBarBg,
    headPos = ccp(46, 44),
    eatAmount = 0
  }
  self.heroes[i] = data
  local expBar, shade, shadeLabel, expBar, shade, shadeLabel
  if info._level == ed.playerlimit.heroLevelLimit() and maxExp <= info._exp then
    data.isExpMax = true
    self:setExpMax(i, true)
  else
    data.expBar = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/package_exp_bar.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(93.5, 20)
      },
      config = {
        scalexy = {x = scaleX}
      }
    }, bg)
  end
  return bg
end
class.createHero = createHero
local playEatEffect = function(self, id)
  local id = id or self.clickid
  local node = ed.createFcaNode("eff_UI_eatexp")
  self.baseScene:addFca(node)
  node:setPosition(ccp(40, 40))
  self.heroes[id].head.icon:addChild(node)
  self.heroes[id].eatEffects = self.heroes[id].eatEffects or {}
  table.insert(self.heroes[id].eatEffects, node)
  if #self.heroes[id].eatEffects > 4 then
    self.heroes[id].eatEffects[1]:removeFromParentAndCleanup(true)
    table.remove(self.heroes[id].eatEffects, 1)
  end
end
class.playEatEffect = playEatEffect
local playLevelupEffect = function(self, id)
  local id = id or self.clickid
  local node = ed.createFcaNode("eff_UI_levelup")
  self.baseScene:addFca(node)
  node:setPosition(ccp(40, 40))
  self.heroes[id].head.icon:addChild(node, 8)
  self:createCheckLevelupEffect(node)
end
class.playLevelupEffect = playLevelupEffect
local createCheckLevelupEffect = function(self, node)
  self.levelupEffectNode = self.levelupEffectNode or {}
  local list = self.levelupEffectNode
  table.insert(list, node)
  local function handler()
    for k, v in pairs(list) do
      if not tolua.isnull(v) and v:isTerminated() then
        v:removeFromParentAndCleanup(true)
        list[k] = nil
        table.remove(list, k)
        return
      end
    end
    if #(list or {}) == 0 then
      self.baseScene:removeUpdateHandler("checkLevelupEffect")
    end
  end
  self.baseScene:registerUpdateHandler("checkLevelupEffect", handler)
end
class.createCheckLevelupEffect = createCheckLevelupEffect
local refreshExp = function(self, id, addition)
  addition = addition or {}
  if tolua.isnull(self.mainLayer) then
    return
  end
  local animDuration = addition.animDuration
  local id = id or self.clickid
  local addExp = self.exp
  local data = self.heroes[id]
  local hero = ed.player.heroes[data.tid]
  data.oriBarScaleX = data.exp / data.maxExp
  local lvPre = data.lvNumber
  local el, ee = hero:getLevelExp(addExp * self.useAmount)
  if self.useAmount > 1 then
    local pel, pee = hero:getLevelExp(addExp * (self.useAmount - 1))
    if pel < ed.playerlimit.heroLevelLimit() and el >= ed.playerlimit.heroLevelLimit() then
      self:setpvKeepeatMarking()
    end
  end
  self:playEatEffect(id)
  data.exp = ee
  data.lvNumber = el
  data.maxExp = ed.lookupDataTable("Levels", "Exp", el)
  if not data.barActions then
    data.barActions = {}
  end
  local isMax = false
  if el > ed.playerlimit.heroLevelLimit() or el == ed.playerlimit.heroLevelLimit() and ee >= data.maxExp then
    data.isExpMax = true
    isMax = true
  end
  local scaleX = data.exp / data.maxExp
  data.endBarScaleX = scaleX
  local lvAdd = el - lvPre
  data.lvAdd = lvAdd
    table.insert(data.barActions, {
      isMax = isMax,
      id = id,
      oriScale = data.oriBarScaleX,
      endScale = data.endBarScaleX,
      lvAdd = lvAdd,
      lvPre = lvPre,
      animDuration = animDuration
    })
  if not data.barActionRunning then
    data.expBar:runAction(self:getBarAction(data.barActions[1]))
    table.remove(data.barActions, 1)
  end
end
class.refreshExp = refreshExp
local setExpMax = function(self, id, isInit)
  local hero = self.heroes[id]
  if not isInit and not tolua.isnull(hero.expBar) then
    hero.expBar:removeFromParentAndCleanup(true)
  end
  local exp = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/heroxp-progress-full.png"
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(90, 20)
    },
    config = {
      fix_size = CCSizeMake(145, 20)
    }
  }, hero.bg)
  local shade = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/package_hero_shade.png"
    },
    layout = {
      anchor = ccp(0, 0)
    }
  }, hero.bg)
  local shadeLabel = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("EATEXPLIST.EXPERIENCE_FULL")),
      size = 22
    },
    layout = {
      position = ccp(190, 42)
    },
    config = {
      color = ccc3(255, 148, 62)
    }
  }, hero.bg)
end
class.setExpMax = setExpMax
local function getBarAction(self, info)
  addition = addition or {}
  local id = info.id
  local data = self.heroes[id]
  local oriBarScaleX = info.oriScale
  local scaleX = info.endScale
  local lvAdd = info.lvAdd
  local lvPre = info.lvPre
  local animDuration = info.animDuration or 0.5
  local mingap = 0.016666666666666666
  local actions = {t = "seq"}
  local gap = animDuration * (1 / (lvAdd + 1))
  for i = 1, lvAdd do
    if i == 1 then
      local gap = (1 - oriBarScaleX) * gap
      if mingap <= gap then
        table.insert(actions, CCScaleTo:create(gap, 1, 1))
    else
        table.insert(actions, CCCallFunc:create(function()
          xpcall(function()
            data.expBar:setScaleX(1)
          end, EDDebug)
        end))
      end
    elseif mingap <= gap then
      table.insert(actions, CCScaleTo:create(gap, 1, 1))
    else
      table.insert(actions, CCCallFunc:create(function()
        xpcall(function()
          data.expBar:setScaleX(1)
        end, EDDebug)
      end))
    end
    table.insert(actions, CCCallFunc:create(function()
      xpcall(function()
        lsr:report("levelupAnim")
        data.expBar:setScaleX(0)
        ed.setString(data.level, T("LV:%d", lvPre + i))
        self:playLevelupEffect(id)
      end, EDDebug)
    end))
  end
  if lvAdd > 0 then
    local gap = (scaleX - 0) * gap
    if mingap <= gap then
      table.insert(actions, CCScaleTo:create(gap, scaleX, 1))
    else
      table.insert(actions, CCCallFunc:create(function()
        xpcall(function()
          data.expBar:setScaleX(scaleX)
        end, EDDebug)
      end))
    end
  else
    local gap = (scaleX - oriBarScaleX) * gap
    if mingap <= gap then
      table.insert(actions, CCScaleTo:create(gap, scaleX, 1))
    else
      table.insert(actions, CCCallFunc:create(function()
        xpcall(function()
          data.expBar:setScaleX(scaleX)
        end, EDDebug)
      end))
    end
  end
  table.insert(actions, CCCallFunc:create(function()
    xpcall(function()
      data.barActionRunning = nil
      if data.barActions[1] then
        data.barActionRunning = true
        data.expBar:runAction(self:getBarAction(data.barActions[1]))
        table.remove(data.barActions, 1)
      elseif info.isMax then
        self:setExpMax(id)
      end
    end, EDDebug)
  end))
  return ed.readaction.create(actions)
end
class.getBarAction = getBarAction
local showEatAmount = function(self, config)
  config = config or {}
  local id = config.id or self.clickid
  local add = config.addAmount or 1
  local amount = self.useAmount
  local hero = self.heroes[id]
  if not tolua.isnull(hero.amountLabel) then
    hero.amountLabel:stopAllActions()
    hero.amountLabel:removeFromParentAndCleanup(true)
  end
  if hero.isExpMax then
    return
  end
  local ea = hero.eatAmount + add
  hero.eatAmount = ea
  hero.amountLabel = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.getNumberNode({
        text = "x" .. ea,
        folder = "light_orange"
      }).node
    },
    layout = {
      position = ccp(210, 42)
    }
  }, hero.bg)
  hero.amountLabel:runAction(ed.readaction.create({
    t = "seq",
    CCDelayTime:create(0.3),
    CCFadeOut:create(0.2),
    CCCallFunc:create(function()
      xpcall(function()
        hero.amountLabel:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
  }))
end
class.showEatAmount = showEatAmount
local keepeatHandler = function(self, id)
  local count = 0
  local delay = 0.5
  local oriSpeed = 10
  local oriAccSpeed = 15
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  local function handler(dt)
    count = count + dt
    if count <= delay and self.draglist.dragMode then
      self:cancelKeepeatHandler()
      return
    end
    if self.isPreventKeepeat then
      self:cancelKeepeatHandler()
    elseif count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while times > 1 do
        self.isKeepeat = true
        self:doEat(id, {
          animDuration = 1 / speed
        })
        times = times - 1
      end
    end
  end
  return handler
end
class.keepeatHandler = keepeatHandler
local registerKeepeatHandler = function(self, id)
  self.baseScene:registerUpdateHandler("keepeat", self:keepeatHandler(id))
end
class.registerKeepeatHandler = registerKeepeatHandler
local cancelKeepeatHandler = function(self)
  self.baseScene:removeUpdateHandler("keepeat")
end
class.cancelKeepeatHandler = cancelKeepeatHandler
local setpvKeepeatMarking = function(self)
  self.isPreventKeepeat = true
end
class.setpvKeepeatMarking = setpvKeepeatMarking
local resetpvKeepeatMarking = function(self)
  self.isPreventKeepeat = nil
end
class.resetpvKeepeatMarking = resetpvKeepeatMarking
local doPressList = function(self)
  local function handler(x, y)
    self.isKeepeat = nil
    self:resetpvKeepeatMarking()
    if not tolua.isnull(self.ui.keepon_prompt) then
      self.ui.keepon_prompt:removeFromParentAndCleanup(true)
    end
    for i = 1, #self.heroes do
      local hero = self.heroes[i]
      local bg = hero.bg
      local parent = self.draglist:getList()
      if ed.containsPoint(bg, x, y, parent) then
        self:registerKeepeatHandler(i)
        return i
      end
    end
  end
  return handler
end
class.doPressList = doPressList
local doSendConsume = function(self, id)
  id = id or self.clickid
  local amount = self.useAmount
  if not id then
    return
  end
  if (amount or 0) <= 0 then
    return
  end
  local hero = self.heroes[id]
  local hid = hero.tid
  local eid = self.id
  local item_info = ed.packItem(eid, amount)
  ed.registerNetReply("eat_exp", self:refreshAmount(amount), {
    id = self.id,
    amount = self.useAmount
  })
  local msg = ed.upmsg.consume_item()
  msg._hero_id = hid
  msg._item_id = item_info
  ed.send(msg, "consume_item")
  self.eatLocked = true
end
class.doSendConsume = doSendConsume
local doEat = function(self, id, addition)
  if self.eatLocked then
    return
  end
  local hero = self.heroes[id]
  local bg = hero.bg
  if hero.isExpMax then
    ed.showToast(T(LSTR("EATEXPLIST.HERO_EXPERIENCE_FULL")))
    return
  end
  self.clickid = self.clickid or id
  if self.clickid ~= id then
    self:doSendConsume(self.clickid)
    self.clickid = id
    self:syncAmount()
  end
  local canUse = self:useProp()
  if not canUse then
    return
  end
  self:refreshExp(id, addition)
  self:showEatAmount({id = id})
end
class.doEat = doEat
local function endPressList(self, mode)
  local function handler(x, y, id)
    if mode == "cancelPress" then
      self:cancelKeepeatHandler()
    elseif mode == "cancelClick" then
    elseif mode == "doClick" then
      lsr:report("clickHero")
      if not self.isKeepeat then
        local hero = self.heroes[id]
        local bg = hero.bg
        local parent = self.draglist:getList()
        if ed.containsPoint(bg, x, y, parent) then
          self:doEat(id)
        end
      else
        self:cancelKeepeatHandler()
      end
    end
  end
  return handler
end
class.endPressList = endPressList
local refreshAmount = function(self, amount)
  local function handler()
    if not self then
      return
    end
    if self.consumeAmount then
      self.consumeAmount(amount)
    end
    self.eatLocked = nil
  end
  return handler
end
class.refreshAmount = refreshAmount
local setUseEquip = function(self, id, amount)
  self.id = id
  self.amount = amount
  self.exp = ed.getDataTable("equip")[id].Exp
end
class.setUseEquip = setUseEquip

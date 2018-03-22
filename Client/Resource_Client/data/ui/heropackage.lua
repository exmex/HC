local lsr = ed.ui.heropackagelsr.create()
local base = ed.ui.framework
local class = newclass(base.mt)
ed.ui.heropackage = class
local baseItem = ed.ui.baseheroitem
local packageItem = ed.ui.packageheroitem
local function doChangeList(self, listName)
  local normalColor = ccc3(255, 255, 255)
  local pressColor = ccc3(255, 255, 255)
  lsr:report("heropackagelsr")
  self.clid = listName
  for k, v in pairs(self.listButton) do
    if k == listName then
      self.listButton[k]:setVisible(false)
      self.buttonPress[k]:setVisible(true)
      self.listButton[k]:setZOrder(3)
      self.buttonPress[k]:setZOrder(3)
      ed.setLabelColor(self.buttonLabel[k], pressColor)
    else
      self.listButton[k]:setVisible(true)
      self.buttonPress[k]:setVisible(false)
      self.listButton[k]:setZOrder(1)
      self.buttonPress[k]:setZOrder(1)
      ed.setLabelColor(self.buttonLabel[k], normalColor)
    end
  end
  self:createHeroList(self.heroList[listName])
end
class.doChangeList = doChangeList
local doListButtonTouch = function(self)
  local function handler(event, x, y)
    local normalColor = ccc3(255, 255, 255)
    local pressColor = ccc3(250, 200, 0)
    xpcall(function()
      if event == "ended" and not self.pressListButton then
        return
      end
      if event == "began" then
        for k, v in pairs(self.listButton) do
          if ed.containsPoint(v, x, y) then
            if k ~= self.clid then
              if v:isVisible() then
                ed.setLabelColor(self.buttonLabel[k], pressColor)
              else
                ed.setLabelColor(self.buttonLabel[k], normalColor)
              end
              v:setVisible(not v:isVisible())
              self.buttonPress[k]:setVisible(not self.buttonPress[k]:isVisible())
              self.buttonPress[k]:setZOrder(3)
            end
            self.pressListButton = k
            break
          end
        end
      elseif event == "ended" then
        local k = self.pressListButton
        local v = self.listButton[k]
        if k ~= self.clid then
          if v:isVisible() then
            ed.setLabelColor(self.buttonLabel[k], pressColor)
          else
            ed.setLabelColor(self.buttonLabel[k], normalColor)
          end
          v:setVisible(not v:isVisible())
          self.buttonPress[k]:setVisible(not self.buttonPress[k]:isVisible())
          self.buttonPress[k]:setZOrder(1)
        end
        if ed.containsPoint(v, x, y) and k ~= self.clid then
          self:doChangeList(k)
        end
        self.pressListButton = nil
      end
    end, EDDebug)
  end
  return handler
end
class.doListButtonTouch = doListButtonTouch
local doPressInHeroLayer = function(self)
  local function handler(x, y)
    for i = 1, #self.heroList[self.clid] do
      local tid = self.heroList[self.clid][i]._tid
      if not (self.heroIcon or {})[tid] then
        return
      end
      if ed.containsPoint(self.heroIcon[tid].bg, x, y) then
        return tid
      end
    end
  end
  return handler
end
class.doPressInHeroLayer = doPressInHeroLayer
local cancelPressInHeroLayer = function(self)
  local handler = function(x, y, tid)
  end
  return handler
end
class.cancelPressInHeroLayer = cancelPressInHeroLayer
local refreshHeroItem = function(self, tid)
  self:getAllList()
  local item = self.heroIcon[tid]
  item:refreshHead()
  item:refreshEquips()
  self:refreshHeroList(self.heroList[self.clid])
end
class.refreshHeroItem = refreshHeroItem
local function doSummonReply(self, tid)
  local function handler(result)
    if not result then
      lsr:report("summonFailed")
    else
      lsr:report("summonSuccess")
      if tolua.isnull(self.mainLayer) then
        return
      end
      self:refreshHeroItem(tid)
      ed.announce({
        type = "popHeroCard",
        param = {id = tid}
      })
    end
  end
  return handler
end
class.doSummonReply = doSummonReply
local doSummon = function(self, tid)
  local cost = ed.readhero.getSummonCost(tid)
  if cost > ed.player._money then
    ed.showHandyDialog("useMidas")
    return
  end
  ed.netdata.evolve = {
    cost = cost,
    id = ed.readhero.getStoneid(tid),
    amount = ed.readhero.getStoneNeed(tid),
    hid = tid
  }
  ed.netreply.evolve = self:doSummonReply(tid)
  local msg = ed.upmsg.hero_evolve()
  msg._heroid = tid
  ed.send(msg, "hero_evolve")
end
class.doSummon = doSummon
local function doClickInHeroLayer(self)
  local function destroyHandler(tid)
    local function handler()
      xpcall(function()
        local x, y = self.draglist:getListPos()
        self.isPushing = nil
        self:getAllList()
        for k, v in pairs(self.heroIcon) do
          v:refreshEquips()
        end
        self.heroIcon[tid]:refreshHead()
        self:createHeroList(self.heroList[self.clid])
        self.draglist:setListPos(ccp(x, y))
		self.draglist.listLayer:setVisible(true);
        ed.teach("backToStageSelect", self.sb_ui.back, self.mainLayer)
      end, EDDebug)
    end
    return handler
  end
  local function clickMissHero(tid)
    local eno = ed.readhero.checkStoneEnough(tid)
    if eno then
      local cost = ed.readhero.getSummonCost(tid)
      local info = {
        text = T(LSTR("HEROPACKAGE.SUMMON_HERO_TAKES_D_GOLD_COINS_CONFIRM_TO_CALL"), cost),
        rightHandler = function()
          self:doSummon(tid)
        end
      }
      ed.showConfirmDialog(info)
    else
      self.mainLayer:addChild(ed.ui.stonedetail.create({
        id = tid,
        callback = function()
          local item = self.heroIcon[tid]
          local sinfo = item:refreshStone()
          if sinfo.enougth then
            self:getAllList()
            self:refreshHeroList(self.heroList[self.clid])
          end
        end
      }).mainLayer, 200)
    end
    if self.summonTutorialID and self.summonTutorialID == tid then
      ed.endTeach("SHclickHero")
    end
  end
  local function clickHero(tid)
    lsr:report("clickHeroOwned")
    if self.equipTutorialID and self.equipTutorialID == tid then
    --add by xinghui:send dot info when click hero icon 
    if --[[ed.tutorial.checkDone("gotoHeroDetailToEquip")== false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["gotoHeroDetailToEquip"].id)
    end
    --
      ed.endTeach("gotoHeroDetailToEquip")
    end
    ed.endTeach("SUclickHero")
    self.pressHeroID = tid
    local list = self.heroList[self.clid]
    local index = 1
    for k, v in ipairs(list) do
      if v._tid == tid then
        index = k
      end
    end
    local list = {}
    local listIndex = 1
    local tempIndex = 0
    for k, v in ipairs(self.heroList[self.clid]) do
      if ed.player.heroes[v._tid] then
        table.insert(list, v)
        tempIndex = tempIndex + 1
      end
      if v._tid == tid then
        listIndex = tempIndex
      end
    end
    local heroDetailLayer = ed.ui.herodetail.initWindow(self.heroIcon[tid].hero, nil, {
      index = listIndex,
      list = list,
      openMode = "card"
    })
	self.draglist.listLayer:setVisible(false);
    self.scene:addChild(heroDetailLayer.mainLayer, 120)
    heroDetailLayer.destroyHandler = destroyHandler(tid)
    self.heroDetailLayer = heroDetailLayer
    self.isPushing = true
  end
  local function handler(x, y, tid)
    if self.isPushing then
      return
    end
    if ed.containsPoint(self.heroIcon[tid].bg, x, y) then
      if not ed.player.heroes[tid] then
        clickMissHero(tid)
      else
        clickHero(tid)
      end
    end
  end
  return handler
end
class.doClickInHeroLayer = doClickInHeroLayer
local cancelClickInHeroLayer = function(self)
  local handler = function(x, y, tid)
  end
  return handler
end
class.cancelClickInHeroLayer = cancelClickInHeroLayer
local onEnterHandler = function(self)
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        self.isPushing = nil
        self.firstInto = nil
        local listX, listY = 0, 0
        if self.draglist:checknull() then
          listX, listY = self.draglist:getListPos()
          self.draglist:resetScrollbar()
        end
        self.draglist:setListPos(ccp(listX, listY))
      end
    end, EDDebug)
  end
  return handler
end
class.onEnterHandler = onEnterHandler
local createHeroList = function(self, list)
  self:refreshHeroList(list)
  local hasHero = function(tid)
    if ed.player.heroes[tid] then
      return true
    end
    return false
  end
  local preLineAmount = 0
  for i = 1, #list do
    local id = list[i]._tid
    local pid = (list[i - 1] or {})._tid
    if hasHero(pid) and not hasHero(id) then
      preLineAmount = i - 1
    end
  end
  local ta = #list + (2 * math.ceil(preLineAmount / 2) - preLineAmount)
  self.draglist:initListHeight(100 * math.ceil(ta / 2) + 40)
end
class.createHeroList = createHeroList
local refreshHeroList = function(self, list)
  local preLineAmount = 0
  local ox = 255
  local oy = 335
  local function getLinepos()
    local tox = 365
    local toy = 270
    if preLineAmount <= 0 then
      return
    end
    local x = tox
    local y = toy - 100 * math.floor((preLineAmount - 1) / 2)
    return x, y
  end
  local function getpos(i)
    local tox, toy = ox, oy
    if preLineAmount > 0 then
      i = i + (2 * math.ceil(preLineAmount / 2) - preLineAmount)
      toy = toy - 30
    end
    local x = tox + self.offsetx + 260 * ((i - 1) % 2)
    local y = toy - 100 * math.floor((i - 1) / 2)
    return x, y
  end
  for k, v in pairs(self.heroIcon) do
    v.bg:stopAllActions()
    v:hide()
  end
  self.listLine:setVisible(false)
  for i = 1, #list do
    local pt = (list[i - 1] or {})._tid
    local tid = list[i]._tid
    local pi = self.heroIcon[pt] or {}
    local item = self.heroIcon[tid]
    if item then
      if item.hero.miss then
        if not (pi.hero or {}).miss then
          preLineAmount = i - 1
          if getLinepos() then
            self.listLine:setVisible(true)
            self.listLine:setPosition(ccp(getLinepos()))
          end
        end
      end
      self.heroIcon[tid].bg:setAnchorPoint(ccp(0.5, 0.5))
      self.heroIcon[tid].bg:setPosition(ccp(getpos(i)))
      if self.isGotoHeroDetailTutorial and not self.equipTutorialID and self.heroIcon[tid].equipCraftable then
        ed.teach("gotoHeroDetailToEquip", self.heroIcon[tid].bg, self.draglist.listLayer)
        self.equipTutorialID = tid
      end
      if tid == 1 then
        ed.teach("SUclickHero", self.heroIcon[tid].bg, self.draglist.listLayer)
      end
      if (item.hero or {}).miss and ed.readhero.checkStoneEnough(tid) and not self.summonTutorialID then
        ed.teach("SHclickHero", self.heroIcon[tid].bg, self.draglist.listLayer)
        self.summonTutorialID = tid
      end
      self.heroIcon[tid]:show()
    end
  end
  if self.draglist ~= nil then
    self.draglist:updateItemsVisible(true)
  end
end
class.refreshHeroList = refreshHeroList
local function loadHero(self, index)
  local list = self.heroList.all
  if index < 1 then
    return
  end
  if index > #list then
    return "loadHeroEnd"
  end
  local tid = list[index]._tid
  self.heroIcon[tid] = packageItem.create(tid)
  local bgNode = self.heroIcon[tid].bg
  self.draglist:setFrameRect(bgNode, bgNode:getTextureRect())
  self.draglist:setParentClipNode(bgNode, self.draglist.listLayer)
  self.listContainer:addChild(self.heroIcon[tid].bg)
end
class.loadHero = loadHero
local prepareLoad = function(self)
  local listContainer = CCSprite:create()
  self.listContainer = listContainer
  listContainer:setAnchorPoint(ccp(0, 0))
  listContainer:setPosition(ccp(0, 0))
  self.draglist:addItem(listContainer)
  self.heroIcon = {}
  local line = CCSprite:create()
  line:setContentSize(CCSizeMake(300, 16))
  line:setVisible(false)
  self.listContainer:addChild(line)
  self.listLine = line
  local lineicon = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
  line:addChild(lineicon)
  lineicon:setPosition(ccp(150, 8))
  self.lineicon = lineicon
  local lineTitle = ed.createttf(T(LSTR("HEROPACKAGE.THE_FOLLOWING_HEROES_HAVE_NOT_BEEN_SUMMONED")), 20)
  lineTitle:setPosition(ccp(150, 8))
  ed.setLabelColor(lineTitle, ccc3(231, 206, 19))
  line:addChild(lineTitle)
  self.lineTitle = lineTitle
  if ed.tutorial.getRecord("gotoEquipProp") == 1 then
    self.isGotoHeroDetailTutorial = true
  end
end
class.prepareLoad = prepareLoad
local asyncLoadHeroes = function(self)
  local index = 1
  local step = "loadHero"
  self:prepareLoad()
  self:createHeroList(self.heroList[self.clid])
  local preid = self.clid
  local function handler(dt)
    xpcall(function()
      if step == "loadHero" then
        for i = index, index + 1 do
          step = self:loadHero(index) or "loadHero"
          index = index + 1
        end
      end
      if step == "loadHeroEnd" then
        self:removeUpdateHandler("asyncLoadHeroes")
      end
      if preid ~= self.clid then
        self:createHeroList(self.heroList[self.clid])
      else
        self:refreshHeroList(self.heroList[self.clid])
      end
      preid = self.clid
    end, EDDebug)
  end
  return handler
end
class.asyncLoadHeroes = asyncLoadHeroes
local getAllList = function(self)
  local all, front, middle, back = ed.readhero.classify("handbook", "position")
  self.heroList = {
    all = all,
    front = front,
    middle = middle,
    back = back
  }
end
class.getAllList = getAllList
local refreshSplitButton = function(self)
  local endPoint = 0 --ed.player.global_config._hero_split_ending
  local ui = self.ui
  if endPoint and endPoint >= ed.getServerTime() then
    ui.herosplit:setVisible(true)
    if ed.player.hasSplitableHero then
      ui.herosplit_tag:setVisible(false)
    else
      ui.herosplit_tag:setVisible(false)
    end
    self:btRegisterButtonClick({
      button = ui.herosplit,
      press = ui.herosplit_press,
      key = "herosplit_button",
      clickHandler = function()
        ed.ui.herosplit.popMain(function()
          self:refreshSplitButton()
        end)
      end
    })
  else
    ui.herosplit:setVisible(false)
  end
end
class.refreshSplitButton = refreshSplitButton
local function create()
  local self
  self = base.create("heroPackage")
  setmetatable(self, class.mt)
  local ui = self.ui
  local mainLayer = self.mainLayer
  local offsetx = -20
  self.offsetx = -20
  self.listButton = {}
  self.buttonPress = {}
  self.buttonLabel = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "list_bg",
        res = "UI/alpha/HVGA/package_herolist_bg.png",
        z = 2
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(385 + offsetx, 215)
      },
      config = {
        fix_size = CCSizeMake(570, 375)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "all",
        array = self.listButton,
        res = "UI/alpha/HVGA/classbtn.png",
        z = 3
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(707 + offsetx, 365)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "all",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/classbtnselected.png",
        z = 3
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(705 + offsetx, 365)
      }
    },
    {
      t = "Label",
      base = {
        name = "all",
        array = self.buttonLabel,
        text = T(LSTR("BATTLEPREPARE.WHOLE")),
        fontinfo = "ui_normal_button",
        size = 20,
        z = 4
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(710 + offsetx, 365)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "front",
        array = self.listButton,
        res = "UI/alpha/HVGA/classbtn.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(707 + offsetx, 305)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "front",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/classbtnselected.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(705 + offsetx, 305)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "front",
        array = self.buttonLabel,
        text = T(LSTR("UNIT.FRONT_ROW")),
        fontinfo = "ui_normal_button",
        size = 20,
        z = 4
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(710 + offsetx, 304)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "middle",
        array = self.listButton,
        res = "UI/alpha/HVGA/classbtn.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(707 + offsetx, 245)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "middle",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/classbtnselected.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(705 + offsetx, 245)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "middle",
        array = self.buttonLabel,
        text = T(LSTR("UNIT.MIDDLE_ROW")),
        fontinfo = "ui_normal_button",
        size = 20,
        z = 4
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(710 + offsetx, 244)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        array = self.listButton,
        res = "UI/alpha/HVGA/classbtn.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(707 + offsetx, 185)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        array = self.buttonPress,
        res = "UI/alpha/HVGA/classbtnselected.png",
        z = 1
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(705 + offsetx, 185)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "back",
        array = self.buttonLabel,
        text = T(LSTR("UNIT.REAR_ROW")),
        fontinfo = "ui_normal_button",
        size = 20,
        z = 4
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(710 + offsetx, 184)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "herosplit",
        res = "UI/alpha/HVGA/classbtn.png",
        capInsets = CCRectMake(40, 25, 40, 25)
      },
      layout = {
        position = ccp(695, 60)
      },
      config = {
        scaleSize = ed.DGSizeMake(120, 75),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "herosplit_press",
        res = "UI/alpha/HVGA/classbtnselected.png",
        capInsets = CCRectMake(40, 25, 40, 25),
        parent = "herosplit"
      },
      layout = {
        position = ccp(0, 0),
        anchor = ccp(0, 0)
      },
      config = {
        scaleSize = ed.DGSizeMake(120, 75),
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "herosplit_icon",
        res = "UI/alpha/HVGA/equip_soulstone_tag.png",
        parent = "herosplit"
      },
      layout = {
        position = ccp(20, 29)
      },
      config = {fix_height = 24}
    },
    {
      t = "Label",
      base = {
        name = "herosplit_label",
        text = T(LSTR("heropackage.1.10.1.001")),
        size = 24,
        parent = "herosplit"
      },
      layout = {
        position = ed.DGccp(72, 37)
      },
      config = {
        ccc3(255, 255, 255),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "herosplit_tag",
        res = "UI/alpha/HVGA/main_deal_tag.png",
        parent = "herosplit"
      },
      layout = {
        position = ed.DGccp(108, 60)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:refreshSplitButton()
  local info = {
    cliprect = CCRectMake(0, 45, 800, 348),
    rect = CCRectMake(135 + offsetx, 45, 500, 348),
    container = self.mainLayer,
    zorder = 10,
    bar = {
      bglen = 330,
      bgpos = ccp(120 + offsetx, 215)
    },
    doClickIn = self:doClickInHeroLayer(),
    cancelClickIn = self:cancelClickInHeroLayer(),
    doPressIn = self:doPressInHeroLayer(),
    cancelPressIn = self:cancelPressInHeroLayer()
  }
  self.draglist = ed.draglist.create(info)
  if self.draglist then
  end
  self:getAllList()
  self.clid = "all"
  mainLayer:registerScriptHandler(self:onEnterHandler())
  self:registerUpdateHandler("asyncLoadHeroes", self:asyncLoadHeroes())
  self:btRegisterHandler({
    handler = self:doListButtonTouch(),
    key = "list_button"
  })
  return self
end
class.create = create

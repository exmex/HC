local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.poptavernloot = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
local lsr = ed.ui.poptavernlootlsr.create()
local matrix_center_pos = ccp(400, 280)
status = 0

--判断武将是否存在
local isHero = function(loot)
  local convertAmount = {}
  for k, v in pairs(ed.getDataTable("HeroStars")) do
    if type(k) == "number" then
      table.insert(convertAmount, v["Convert Fragments"])
    end
  end
  local id = loot.id
  local amount = loot.amount
  local mhid = ed.readhero.getMakeid(id)
  if mhid and ed.itemType(mhid) == "hero" and ed.isElementInTable(amount, convertAmount) then
    return true, mhid
  end
  if ed.itemType(id) == "hero" then
    return true, id
  end
  return false
end
class.isHero = isHero
local function checkSameHero(loot_1, loot_2)
  local result_1, id_1 = isHero(loot_1)
  local result_2, id_2 = isHero(loot_2)
  if not result_1 or not result_2 then
    return false
  end
  if id_1 ~= id_2 then
    return false
  end
  return true
end
class.checkSameHero = checkSameHero
local magic_loot_pos = {
  ccp(-105, 95),
  ccp(105, 95),
  ccp(215, 10),
  ccp(100, -95),
  ccp(-100, -95),
  ccp(-215, 10),
  ccp(0, 0)
}
local function destroyLootCard(self)
  lsr:report("closeLootCard")
  if not tolua.isnull(self.lootDetailCard) then
    self.lootDetailCard:removeFromParentAndCleanup(true)
    self.lootDetailCard = nil
  end
end
class.destroyLootCard = destroyLootCard
local function createLootCard(self, id)
  lsr:report("createLootCard")
  local panel = ed.readequip.getDetailCard(id)
  self.lootDetailCard = panel
  self.container:addChild(panel, 50)
  return panel
end
class.createLootCard = createLootCard
local function registerLootsTouch(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterClick({
    pressHandler = function(param, x, y)
      local id
      if not self.lootIcons then
        return
      end
      local loots = self.loots
      local lootIcons = self.lootIcons
      for i = 1, #lootIcons do
        local icon = lootIcons[i]
        local loot = loots[i]
        if ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          local panel = self:createLootCard(loot.id)
          local x, y = icon:getPosition()
          if self.type == "magic" then
            panel:setAnchorPoint(ccp(0.5, 0.5))
            panel:setPosition(matrix_center_pos)
          else
            panel:setPosition(ccp(x, y + 35))
          end
          return i
        end
      end
    end,
    clickHandler = function(param, x, y)
      local id = param.clickParam
      if not id then
        return
      end
      local lootIcons = self.lootIcons
      lootIcons[id]:setScale(1)
      self:destroyLootCard()
    end
  })
end
class.registerLootsTouch = registerLootsTouch
local registerTouchHandler = function(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      self:doClickClose()
    end
  })
  if self.teachKey then
    return
  end
  if not tolua.isnull(ui.tavern) then
    self:btRegisterButtonClick({
      button = ui.tavern,
      press = ui.tavern_press,
      key = "tavern_button",
      clickHandler = function()
        self:doClickTavern()
      end
    })
  end
end
class.registerTouchHandler = registerTouchHandler
local function doClickClose(self)
  lsr:report("clickCloseLoots")
  if self.teachKey then
  --add by xinghui:send dot when close the tarven result
    if --[[ed.tutorial.checkDone(self.teachKey)==false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key[self.teachKey].id)
    end
  --
	
    ed.endTeach(self.teachKey)
    self.teachKey = nil
  end
  status = 0
  self:destroy()
end
class.doClickClose = doClickClose
local function doClickTavern(self)
  lsr:report("clickTavernAgain")
  self.isDoTavern = true
  self:destroy()
end
class.doClickTavern = doClickTavern
local function throwLoots(self)
  if #self.loots <= 1 then
    return
  end
  math.randomseed(os.time())
  math.random()
  math.random()
  math.random()
  local r = math.random(1, #self.loots)
  local t = self.loots[1]
  self.loots[1] = self.loots[r]
  self.loots[r] = t
  for i = 1, 20 do
    local r1 = math.random(1, #self.loots)
    local r2 = math.random(1, #self.loots)
    local t = self.loots[r1]
    self.loots[r1] = self.loots[r2]
    self.loots[r2] = t
  end
  for i = 1, #self.loots do
    local loot = self.loots[i]
    if isHero(loot) then
      local id = loot.id
      for j = i, #self.loots do
        local l = self.loots[j]
        if checkSameHero(l, loot) and l.amount < loot.amount then
          local temp = self.loots[i]
          self.loots[i] = l
          self.loots[j] = temp
        end
      end
    end
  end
end
class.throwLoots = throwLoots
local function create(param)
  param = param or {}
  local self = base.create("poptavernloot", param)
  setmetatable(self, class.mt)
  self.baseScene = ed.getCurrentScene()
  local type = param.type
  local times = param.times
  local loots = param.loots
  local addition = param.addition or {}
  self.type = type
  self.boxType = param.boxType or type
  self.times = times
  self.cost = addition.cost
  self.destroyHandler = addition.destroyHandler
  for i = 1, #loots do
    local v = loots[i]
	if status == 1 then
		loots[i] = {
		  id = loots[i].id,
		  amount = loots[i].amount
		}
	else
		loots[i] = {
		  id = ed.bits(v, 0, 10),
		  amount = ed.bits(v, 10, 11)
		}
	end
    
  end
  self.loots = loots
  self:throwLoots()
  local mainLayer = self.mainLayer
  self:registerLootsTouch()
  self:show()
  return self
end
class.create = create
local function pop(param)
  local window = create(param)
  local scene = window:ccScene()
  scene:addChild(window.mainLayer, 150)
end
class.pop = pop
local function show(self)
  lsr:report("createLootsLayer")
  self.container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self:playBoxAnim()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  self.container:runAction(s)
end
class.show = show
local function destroy(self)
  lsr:report("closeLootsLayer")
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.isDoTavern then
        self.tavernHandler()
      end
      if self.destroyHandler then
        self.destroyHandler()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  self.container:runAction(s)
end
class.destroy = destroy
local function playBoxAnim(self)
	local fca_res = {
	bronze = "eff_UI_tarven_open_chest",
	silver = "eff_UI_tarven_open_chest_silver",
	gold = "eff_UI_tarven_open_chest_gold",
	magic = "eff_UI_tavern_open_magicsoul",
	starshop = "eff_UI_tarven_open_chest_gold",
	stone_green = "eff_UI_shop_star_box_green",
	stone_blue = "eff_UI_shop_star_box_blue",
	stone_purple = "eff_UI_shop_star_box_purple"
	}
	local type = self.type
	local times = self.times
	local bscale = 1.5
	local bpos = ccp(400, 240)
	local epos
	local endScale = 0.5
	if times == "one" then
	epos = ccp(0, 110)
	elseif times == "ten" then
	epos = ccp(0, 120)
	end
	if self.type == "magic" then
	bpos = ccp(400, 80)
	epos = bpos
	bscale = 1
	endScale = 1
	end
	if self.type == "starshop" then
	epos = ccp(0, 120)
	bscale = 1
	end
	lsr:report("openBoxAnim")
	local boxContainer
	if self.type == "magic" then
	boxContainer = CCSprite:create()
	boxContainer:setCascadeOpacityEnabled(true)
	else
	boxContainer = CCLayer:create()
	end
	self.boxContainer = boxContainer
	self.container:addChild(boxContainer, 20)
	local boxFcaRes = fca_res[self.boxType]
	local box = ed.createFcaNode(boxFcaRes)
	self.boxContainer:addChild(box)
	self.baseScene:addFca(box)
	box:setPosition(bpos)
	box:setScale(bscale)
	box:setVisible(false)
	self.box = box
	local as = {}
	if self.type == "magic" then
		local func = CCCallFunc:create(function()
		  xpcall(function()
			self:createMatrixContainerAnim()
		  end, EDDeug)
		end)
		as = {
		  t = "seq",
		  func
		}
		else
		local s = CCScaleTo:create(0.3, endScale)
		s = CCEaseSineOut:create(s)
		local m = CCMoveTo:create(0.3, epos)
		m = CCEaseSineOut:create(m)
		s = CCSpawn:createWithTwoActions(s, m)
		local func = CCCallFunc:create(function()
		  xpcall(function()
			self:playLootAnim(1)
		  end, EDDebug)
		end)
		as = {
		  t = "seq",
		  s,
		  func
		}
	end
	boxContainer:runAction(ed.readaction.create(as))
end
class.playBoxAnim = playBoxAnim
local createMatrixAnim = function(self)
  local fo = CCFadeTo:create(2, 100)
  local fi = CCFadeTo:create(2, 255)
  local s = CCSequence:createWithTwoActions(fo, fi)
  s = CCRepeatForever:create(s)
  self.matrixui.matrix:runAction(s)
  self:playLootAnim(1)
end
class.createMatrixAnim = createMatrixAnim
local createMatrixContainerAnim = function(self)
  local matrixContainer = CCSprite:create()
  matrixContainer:setCascadeOpacityEnabled(true)
  matrixContainer:setPosition(ccp(400, 230))
  matrixContainer:setScaleX(1.2)
  matrixContainer:setScaleY(0.6)
  self.container:addChild(matrixContainer)
  self.matrixContainer = matrixContainer
  local matrix = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_circle_1.png")
  matrixContainer:addChild(matrix)
  matrix:setRotation(30)
  local matrixStar = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_circle_2.png")
  matrixStar:setPosition(ccp(0, 60))
  matrixContainer:addChild(matrixStar)
  matrixStar:setRotation(30)
  matrixStar:setVisible(false)
  self.matrixui = {matrix = matrix, star = matrixStar}
  matrixContainer:setOpacity(0)
  local fin = CCFadeIn:create(0.2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:createMatrixAnim()
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(fin, func)
  matrixContainer:runAction(s)
end
class.createMatrixContainerAnim = createMatrixContainerAnim
local function getLootPos(self, index)
  if self.type == "magic" then
    local pos = ccpAdd(matrix_center_pos, magic_loot_pos[index])
    return pos.x, pos.y
  elseif self.type == "starshop" then
    local ox, oy = 305, 250
    local dx, dy = 100, 105
    local x = ox + dx * ((index - 1) % 3)
    local y = oy - dy * math.floor((index - 1) / 3)
    return x, y
  else
    local ox, oy
    local dx, dy = 100, 105
    if self.times == "one" then
      ox, oy = 400, 200
    elseif self.times == "ten" then
      ox, oy = 190, 250
    end
    local x = ox + dx * ((index - 1) % 5)
    local y = oy - dy * math.floor((index - 1) / 5)
    return x, y
  end
end
class.getLootPos = getLootPos
local playMagicLootShadeAnim = function(self, index)
  local x, y = self:getLootPos(index)
  local up = ccp(x, y)
  local dp = ccp(x, y - 60)
  local icon = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_item_bg.png")
  icon:setPosition(dp)
  icon:setScale(0)
  self.container:addChild(icon)
  local a = CCArray:create()
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseSineIn:create(s)
  local m = CCMoveTo:create(0.2, up)
  m = CCEaseSineOut:create(m)
  local f = CCFadeOut:create(1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      icon:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  local as = {
    s,
    m,
    f
  }
  for i = 1, #as do
    a:addObject(as[i])
  end
  s = CCSpawn:create(a)
  s = CCSequence:createWithTwoActions(s, func)
  icon:runAction(s)
end
class.playMagicLootShadeAnim = playMagicLootShadeAnim
local function createLootAnim(self, index, param)
  param = param or {}
  local skipCheckHero = param.skipCheckHero
  local boxType = self.type

  --根据物品的品级显示不同的背景特效
  local function playBurst(icon, quality)
    local light_res = {
      "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
      "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
      "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
      "UI/alpha/HVGA/tavern_get_item_bg_light_purple.png",
      "UI/alpha/HVGA/tavern_get_item_bg_light_purple.png",
      "UI/alpha/HVGA/tavern_get_item_bg_light_orange.png"
    }
    local burst = ed.createFcaNode("eff_UI_tavern_burst")
    burst:setPosition(ccp(35, 35))
    self.baseScene:addFca(burst, 1)
    icon:addChild(burst)
    local light = ed.createSprite(light_res[quality])
    light:setPosition(ccp(33, 35))
    icon:addChild(light, -3)
    light:setScale(1 / icon:getScale())
    local r = CCRotateBy:create(5, 360)
    r = CCRepeatForever:create(r)
    light:runAction(r)
  end
  local loots = self.loots
  local times = self.times
  local loot = loots[index]
  local type = ed.itemType(loot.id)
  local ih, ihid = isHero(loot)
  if not skipCheckHero and ih then
    local handler = function(self, index)
      local function hd()
        self:playLootAnim(index, {skipCheckHero = true})
      end
      return hd
    end
    ed.announce({
      type = "popHeroCard",
      param = {
        id = ihid,
        amount = loot.amount,
        callback = handler(self, index)
      }
    })
    return
  end
  local icon, prop = ed.readequip.createIconWithAmount(loot.id, nil, loot.amount)
  self.container:addChild(icon)
  self.lootIcons[index] = icon
  if boxType ~= "magic" then
    local shadow = ed.createSprite("UI/alpha/HVGA/tavern_get_item_bg_light_white.png")
    shadow:setPosition(ccp(35, 35))
    icon:addChild(shadow)
    local fo = CCFadeOut:create(0.4)
    shadow:runAction(fo)
  end
  local bpos = self.box:getParent():convertToWorldSpace(ccp(self.box:getPosition()))
  local x, y = self:getLootPos(index)
  local epos = ccp(x, y)
  local s
  if isHero(loot) then
    icon:setPosition(epos)
    local gap1 = 0.2
    s = CCScaleTo:create(gap1, 1)
    s = CCEaseBackOut:create(s)
  elseif boxType ~= "magic" then
    icon:setScale(0)
    icon:setPosition(bpos)
    local a1 = CCArray:create()
    local gap1 = 0.2
    s = CCScaleTo:create(gap1, 1)
    s = CCEaseSineOut:create(s)
    local m = CCMoveTo:create(gap1, epos)
    m = CCEaseSineOut:create(m)
    local r = CCRotateBy:create(gap1, 720)
    r = CCEaseSineOut:create(r)
    a1:addObject(s)
    a1:addObject(m)
    a1:addObject(r)
    s = CCSpawn:create(a1)
  else
    icon:setPosition(epos)
    icon:setOpacity(0)
    icon:setScale(0)
    local d = CCDelayTime:create(0.0)
    local f = CCFadeIn:create(0.2)
    s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    s = CCSpawn:createWithTwoActions(f, s)
    s = CCSequence:createWithTwoActions(d, s)
    self:playMagicLootShadeAnim(index)
  end
  local f = CCCallFunc:create(function()
    xpcall(function()
      local name
      local type = ed.itemType(loot.id)
      if type == "hero" then
        name = ed.getDataTable("Unit")[loot.id]["Display Name"]
        playBurst(icon, 6)
      elseif type == "equip" then
        local row = ed.getDataTable("equip")[loot.id]
        name = row.Name
        local cg = row.Category
        local q = row.Quality
        local mq
        if cg == T(LSTR("EQUIP.SOUL_STONE")) then
          if ed.isElementInTable(self.type, {"magic", "starshop"}) then
            playBurst(icon, 6)
          else
			if status == 0 then
				mq = self.baseScene:getExRank(self.type)
			else
				mq = ed.EveryDayHappyPage.getExRank(self.type)
			end
            
            if q >= mq then
              playBurst(icon, q)
            end
          end
        else
          local lootIcon
          if cg == T(LSTR("EQUIP.FRAGMENT")) then
            lootIcon = icon
          else
            lootIcon = prop
          end
          if self.type == "starshop" then
            local tkeys = {
              stone_green = 8,
              stone_blue = 9,
              stone_purple = 10
            }
			mq = 1
			if status == 0 then
				mq = ed.getDataTable("TavernBoxType")[tkeys[self.boxType]][1]["Exhibition Rank"]
			end
			
			
          else
            if status == 0 then
				mq = self.baseScene:getExRank(self.type)
			else
				mq = ed.EveryDayHappyPage.getExRank(self.type)
			end
          end
          if q >= mq then
            playBurst(lootIcon, q)
          end
        end
      end
      name = ed.createttf(name, 18)
      name:setPosition(ccp(x, y - 45))
      ed.setLabelStroke(name, ccc3(0, 0, 0), 2)
      self.container:addChild(name)
      local size = name:getContentSize()
      if size.width > 100 then
        name:setScale(100 / size.width)
      end
      self:playLootAnim(index + 1)
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  icon:runAction(s)
  lsr:report("showLootAnim")
end
class.createLootAnim = createLootAnim
local playLootAnim = function(self, index, param)
  param = param or {}
  local loots = self.loots
  self.lootIcons = self.lootIcons or {}
  if index > #loots then
    self:playButtonAnim()
  else
    self:createLootAnim(index, param)
  end
end
class.playLootAnim = playLootAnim
local playButtonAnim = function(self)
  local tvText
  local  dpText
  local okTxt
  local times = self.times
  if times == "one" then
    tvText = T(LSTR("POPTAVERNLOOT.DRAW_ONCE_AGAIN"))
  elseif times == "ten" then
    tvText = T(LSTR("POPTAVERNLOOT.DRAW_10_AGAIN"))
  end
  if self.type == "magic" then
    tvText = T(LSTR("POPTAVERNLOOT.DRAW_ONCE_AGAIN"))
  end
  if status == 1 then
	okTxt = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_GET"))
    dpText = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_OPEN_GET"))
  else
	okTxt = T(LSTR("CHATCONFIG.CONFIRM"))
	dpText = T(LSTR("CHATCONFIG.SHOW_REWAD_BY_CHEST"))	
  end
  local ui = self.ui
  local ui_info
  if ed.isElementInTable(self.type, {"starshop"}) then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "ok",
          res = "UI/alpha/HVGA/tavern_button_normal_1.png"
        },
        layout = {
          position = ccp(400, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ok_press",
          res = "UI/alpha/HVGA/tavern_button_normal_2.png",
          parent = "ok"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ok_label",
          text = okTxt,
          size = 18,
          parent = "ok"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {}
      },
	  {
		t = "Label",
		base = {
		  name = "reward_label",
		  text = dpText,
		  size = 18,
		},
		layout = {
		  position = ccp(374, 375)
		},
		config = {
			color = ccc3(231, 206, 19)
		}
	  }
    }
    local readNode = ed.readnode.create(self.container, ui)
    readNode:addNode(ui_info)
  else
    local pay = self.cost.pay
    local cost = self.cost.number
	if status == 0 then
	  ui_info = {
      {
        t = "Sprite",
        base = {
          name = "cost_bg",
          res = "UI/alpha/HVGA/tip_detail_bg.png"
        },
        layout = {
          position = ccp(0, 0)
        },
        config = {
          scalexy = {y = 2}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "cost_icon",
          res = pay == "Diamond" and "UI/alpha/HVGA/task_rmb_icon_2.png" or "UI/alpha/HVGA/task_gold_icon_2.png"
        },
        layout = {
          position = ccp(180, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "cost",
          text = cost,
          size = 18
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(240, 50)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "tavern",
          res = "UI/alpha/HVGA/tavern_button_1.png"
        },
        layout = {
          position = ccp(310, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "tavern_press",
          res = "UI/alpha/HVGA/tavern_button_2.png",
          parent = "tavern"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "tavern_label",
          text = tvText,
          fontinfo = "ui_normal_button",
          parent = "tavern"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {
          color = ccc3(231, 206, 19)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ok",
          res = "UI/alpha/HVGA/tavern_button_normal_1.png"
        },
        layout = {
          position = ccp(508, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ok_press",
          res = "UI/alpha/HVGA/tavern_button_normal_2.png",
          parent = "ok"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ok_label",
          text = okTxt,
          fontinfo = "ui_normal_button",
          parent = "ok"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {}
      },
	  {
		t = "Label",
		base = {
		  name = "reward_label",
		  text = dpText,
		  size = 18,
		},
		layout = {
		  position = ccp(374, 375)
		},
		config = {
			color = ccc3(231, 206, 19)
		}
	  }
    }
	else
		ui_info = {
		  --[[{
		    t = "Sprite",
			base = {
			  name = "cost_bg",
			  res = "UI/alpha/HVGA/tip_detail_bg.png"
			},
			layout = {
			  position = ccp(0, 0)
			},
			config = {
			  scalexy = {y = 2}
			}
		  },
		  {
			t = "Sprite",
			base = {
			  name = "cost_icon",
			  res = pay == "Diamond" and "UI/alpha/HVGA/task_rmb_icon_2.png" or "UI/alpha/HVGA/task_gold_icon_2.png"
			},
			layout = {
			  position = ccp(180, 48)
			}
		  },
		  {
			t = "Label",
			base = {
			  name = "cost",
			  text = cost,
			  size = 18
			},
			layout = {
			  anchor = ccp(1, 0.5),
			  position = ccp(240, 50)
			}
		  },
		  {
			t = "Sprite",
			base = {
			  name = "tavern",
			  res = "UI/alpha/HVGA/tavern_button_1.png"
			},
			layout = {
			  position = ccp(310, 50)
			},
			config = {}
		  },
		  {
			t = "Sprite",
			base = {
			  name = "tavern_press",
			  res = "UI/alpha/HVGA/tavern_button_2.png",
			  parent = "tavern"
			},
			layout = {
			  anchor = ccp(0, 0),
			  position = ccp(0, 0)
			},
			config = {visible = false}
		  },
		  {
			t = "Label",
			base = {
			  name = "tavern_label",
			  text = tvText,
			  fontinfo = "ui_normal_button",
			  parent = "tavern"
			},
			layout = {
			  position = ccp(64, 25)
			},
			config = {
			  color = ccc3(231, 206, 19)
			}
		  },--]]
		  {
			t = "Sprite",
			base = {
			  name = "ok",
			  res = "UI/alpha/HVGA/tavern_button_normal_1.png"
			},
			layout = {
			  position = ccp(398, 50)
			},
			config = {}
		  },
		  {
			t = "Sprite",
			base = {
			  name = "ok_press",
			  res = "UI/alpha/HVGA/tavern_button_normal_2.png",
			  parent = "ok"
			},
			layout = {
			  anchor = ccp(0, 0),
			  position = ccp(0, 0)
			},
			config = {visible = false}
		  },
		  {
			t = "Label",
			base = {
			  name = "ok_label",
			  text = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_GET")),
			  fontinfo = "ui_normal_button",
			  parent = "ok"
			},
			layout = {
			  position = ccp(64, 25)
			},
			config = {}
		  },
		  {
			t = "Label",
			base = {
			  name = "reward_label",
			  text = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_OPEN_GET")),
			  size = 18,
			},
			layout = {
			  position = ccp(374, 375)
			},
			config = {
				color = ccc3(231, 206, 19)
			}
		  }
		}
	end
    
    local readNode = ed.readnode.create(self.container, ui)
    readNode:addNode(ui_info)
	if status ~= 0 then
		local tkeys = {
		  "FTBronzeClose",
		  "FTGoldClose"
		}
		for i = 1, #tkeys do
		  local k = tkeys[i]
		  local ist = ed.teach(k, ui.ok, self.container)
		  if ist then
			self.teachKey = k
			break
		  end
		end
		
		if self.type == "magic" then
			ui.reward_label:setVisible(false);
		end
	else
		local cl = ui.cost
		local ci = ui.cost_icon
		local w = cl:getContentSize().width
		ci:setAnchorPoint(ccp(1, 0.5))
		ci:setPosition(ccp(240 - w, 48))
		w = w + ci:getContentSize().width
		local cb = ui.cost_bg
		cb:setPosition(ccp(240 - w / 2, 50))
		local tkeys = {
		  "FTBronzeClose",
		  "FTGoldClose"
		}
		for i = 1, #tkeys do
		  local k = tkeys[i]
		  local ist = ed.teach(k, ui.ok, self.container)
		  if ist then
			self.teachKey = k
			break
		  end
		end
		
		if self.type == "magic" then
			ui.reward_label:setVisible(false);
		end
	end
    
  end
  self:registerTouchHandler()
end
class.playButtonAnim = playButtonAnim

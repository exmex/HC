local herodetail = ed.ui.herodetail
local res = herodetail.res
local base = ed.ui.popwindow
local class = newclass(base.mt)
herodetail.att = class
local getHero = function(self)
  return self.hero
end
class.getHero = getHero
local getHeroStars = function(self)
  local hero = self:getHero()
  return hero._stars
end
class.getHeroStars = getHeroStars
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      if self.closeHandler then
        self.closeHandler()
      end
    end,
    force = true
  })
end
class.registerTouchHandler = registerTouchHandler
local list_left = 24
local list_center = 142
local list_top = 415
local function addListNode(self, ui)
  local height = self.listUpHeight or 0
  local readNode = ed.readnode.create(self.draglist:getList(), self.attui)
  for i = 1, #ui do
    readNode:addNode({
      ui[i]
    })
    self.attui[ui[i].base.name]:setAnchorPoint(ccp(0.5, 1))
    self.attui[ui[i].base.name]:setPosition(ccp(list_center, list_top - height + (ui[i].offsetY or 0)))
    if ui[i].addHeight then
      height = height + self.attui[ui[i].base.name]:getContentSize().height + ui[i].addHeight
    end
  end
  return height
end
class.addListNode = addListNode
local function refreshAttPos(self)
  local height = self.attHeightOffset
  local ui = self.attuiList
  local att = self.attInfo
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    local info = att[k] or {}
    if (info.base or 0) <= 0 and 0 >= (info.add or 0) then
      ui[k].name:setScaleY(0)
    else
      ui[k].name:setScaleY(1)
      local w = 0
      w = list_left
      ui[k].name:setPosition(w + ui[k].name:getContentSize().width / 2, list_top - height)
      w = ui[k].name:getContentSize().width
      ui[k][1]:setPosition(ccp(w + ui[k][1]:getContentSize().width / 2, ui[k].name:getContentSize().height / 2))
      w = w + ui[k][1]:getContentSize().width + 3
      ui[k][2]:setPosition(ccp(w + ui[k][2]:getContentSize().width / 2, ui[k].name:getContentSize().height / 2))
      w = w + ui[k][2]:getContentSize().width
      ui[k][3]:setPosition(ccp(w + ui[k][3]:getContentSize().width / 2, ui[k].name:getContentSize().height / 2))
      w = w + ui[k][3]:getContentSize().width
      ui[k][4]:setPosition(ccp(w + ui[k][4]:getContentSize().width / 2, ui[k].name:getContentSize().height / 2))
      height = height + ui[k][1]:getContentSize().height + 2
    end
  end
  return height
end
class.refreshAttPos = refreshAttPos
local refreshAttLabel = function(self)
  local preAtt = self.attInfo
  self:getAtt()
  self:refreshAtt(preAtt)
  self:refreshAttAddition(preAtt)
  local height = self:refreshAttPos()
  self:refreshVoicePos(height)
end
class.refreshAttLabel = refreshAttLabel
local function refreshAtt(self, list)
  local att = self.attInfo
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    if list[k] and att[k] and att[k].base ~= list[k].base then
      ed.setString(self.attuiList[k][1], att[k].base)
      local scale = CCScaleTo:create(0.4, 1.5)
      scale = CCEaseBackIn:create(scale)
      local reset = CCScaleTo:create(0.2, 1)
      reset = CCEaseBackOut:create(reset)
      local sequence = CCSequence:createWithTwoActions(scale, reset)
      self.attuiList[k][1]:runAction(sequence)
    end
  end
end
class.refreshAtt = refreshAtt
local function refreshAttAddition(self, list)
  local att = self.attInfo
  if self.attuiList == nil then
    return
  end
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    if att[k] then
      if (att[k].add or 0) ~= ((list[k] or {}).add or 0) then
        ed.setString(self.attuiList[k][2], att[k].add > 0 and "+" or "")
        ed.setString(self.attuiList[k][3], att[k].add)
        local scale = CCScaleTo:create(0.4, 1.5)
        scale = CCEaseBackIn:create(scale)
        local reset = CCScaleTo:create(0.2, 1)
        reset = CCEaseBackOut:create(reset)
        local sequence = CCSequence:createWithTwoActions(scale, reset)
        self.attuiList[k][3]:runAction(sequence)
      end
    end
    if att[k] then
      if (att[k].add or 0) == 0 then
        self.attuiList[k][2]:setVisible(false)
        self.attuiList[k][3]:setVisible(false)
      end
    else
      self.attuiList[k][2]:setVisible(true)
      self.attuiList[k][3]:setVisible(true)
    end
  end
end
class.refreshAttAddition = refreshAttAddition
local function createAttDetail(self)
  if self.attContainer then
    self.attContainer:removeFromParentAndCleanup(true)
  end
  local height = self.listUpHeight
  self.attContainer = CCSprite:create()
  self.attContainer:setCascadeOpacityEnabled(true)
  self.attContainer:setAnchorPoint(ccp(0, 0))
  self.attContainer:setPosition(ccp(0, 0))
  if self.draglist:checknull() then
    return
  end
  self.draglist:addItem(self.attContainer)
  local attuiList = {}
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    local w = list_left
    local att = self.attInfo
    local info = att[k] or {}
    local name = ed.createttf(res.att_pre[k] .. ":", 16)
    ed.setLabelColor(name, ed.toccc3(15843697))
    self.attContainer:addChild(name)
    name:setCascadeOpacityEnabled(true)
    local base = ed.createttf(info.base or 0, 16)
    name:addChild(base)
    ed.setLabelColor(base, ed.toccc3(16771782))
    local addIcon = ed.createttf(0 < (info.add or 0) and "+" or "", 16)
    name:addChild(addIcon)
    ed.setLabelColor(addIcon, ed.toccc3(10543386))
    local add = ed.createttf((info.add or 0) == 0 and "" or info.add, 16)
    name:addChild(add)
    ed.setLabelColor(add, ed.toccc3(10543386))
    local suffix = ed.createttf(res.att_suffix[k] or "", 16)
    name:addChild(suffix)
    ed.setLabelColor(suffix, ed.toccc3(15843697))
    attuiList[k] = {
      name = name,
      base,
      addIcon,
      add,
      suffix
    }
  end
  self.attuiList = attuiList
  self.attHeightOffset = height
  local height = self:refreshAttPos()
  self.oriAttHeight = height
  height = height + 20
  self.listUpHeight = height
end
class.createAttDetail = createAttDetail
local refreshVoicePos = function(self, height)
  local dh = self.oriAttHeight - height
  if not tolua.isnull(self.voiceContainer) then
    self.voiceContainer:setPosition(ccp(0, dh))
  end
  self.draglist:initListHeight(self.listUpHeight - dh, false)
end
class.refreshVoicePos = refreshVoicePos
local function createVoiceDetail(self)
  local height = self.listUpHeight
  local ui = {}
  self.voidui = ui
  local container = self.draglist:getList()
  if tolua.isnull(container) then
    return
  end
  local voidDesc = ed.getdat
  if false then -- if self.info.voiceDesc  ray 2014-09-10 hide voice detail
    local voiceContainer = CCSprite:create()
    voiceContainer:setAnchorPoint(ccp(0, 0))
    self.voiceContainer = voiceContainer
    container:addChild(voiceContainer)
    local readnode = ed.readnode.create(voiceContainer, ui)
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "voice_title_bg",
          res = "UI/alpha/HVGA/herodetail-title-mark.png"
        },
        layout = {
          position = ccp(list_center, list_top - height)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "voice_title",
          text = T(LSTR("HERODETAILATT.DUB_STAR")),
          size = 20
        },
        layout = {
          position = ccp(list_center, list_top - height)
        },
        config = {
          color = ccc3(251, 206, 16)
        },
        offsetY = 6,
        addHeight = 4
      },
      {
        t = "Label",
        base = {
          name = "voice_detail",
          text = self.info.voiceDesc,
          size = 16
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(list_left, list_top - height - 20)
        },
        config = {
          color = ed.toccc3(15843697),
          dimension = CCSizeMake(235, 0),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop
        }
      }
    }
    readnode:addNode(ui_info)
    local w, h = ed.sumNodeSize({
      ui.voice_title,
      ui.voice_detail
    })
    height = height + h + 40
  end
  self.listUpHeight = height
  self.draglist:initListHeight(height)
end
class.createVoiceDetail = createVoiceDetail
local waitCreateDetail = function(self)
  local count = 0
  local done
  local scheduler = self.mainLayer:getScheduler()
  local id
  local function handler(dt)
    xpcall(function()
      count = count + dt
      if not id then
        id = self.waitCreateDetailID
      end
      if tolua.isnull(self.mainLayer) then
        scheduler:unscheduleScriptEntry(id)
      end
      if count > 0.4 and not done then
        self:createAttDetail()
        self:createVoiceDetail()
        scheduler:unscheduleScriptEntry(id)
        done = true
      end
    end, EDDebug)
  end
  return handler
end
class.waitCreateDetail = waitCreateDetail
local getAttGrowth = function(self)
  local growth = ed.readhero.getGrowthByHero(self.hero)
  self.growth = growth
  return growth
end
class.getAttGrowth = getAttGrowth
local createGrowth = function(self)
  local names = {
    STR = T(LSTR("HERODETAILATT.STRENGTH_GROWTH_")),
    INT = T(LSTR("HERODETAILATT.INTELLIGENCE_GROWTH_")),
    AGI = T(LSTR("HERODETAILATT.AGILITY_GROWTH_"))
  }
  local gt = self:getAttGrowth()
  self.growthui = {}
  local lsize = 16
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "STR",
        text = names.STR,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ccc3(255, 77, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "INT",
        text = names.INT,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ccc3(255, 77, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "AGI",
        text = names.AGI,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ccc3(255, 77, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "STR_G",
        text = gt.STR,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ed.toccc3(16771782)
      }
    },
    {
      t = "Label",
      base = {
        name = "INT_G",
        text = gt.INT,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ed.toccc3(16771782)
      }
    },
    {
      t = "Label",
      base = {
        name = "AGI_G",
        text = gt.AGI,
        size = lsize
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 0)
      },
      config = {
        color = ed.toccc3(16771782)
      }
    }
  }
  local readNode = ed.readnode.create(self.draglist:getList(), self.growthui)
  readNode:addNode(ui_info)
  self:refreshGrowthPos()
end
class.createGrowth = createGrowth
local function refreshGrowthPos(self)
  local w = list_left
  local h = list_top - self.listUpHeight
  local keys = {
    "STR",
    "INT",
    "AGI"
  }
  local ui = self.growthui
  for i = 1, #keys do
    local k = keys[i]
    local t = ui[k]
    local n = ui[k .. "_G"]
    local ts = ui[k]:getContentSize()
    local th = ts.height / 2
    local tw = ts.width
    t:setPosition(ccp(w, h - th))
    n:setPosition(ccp(w + tw, h - th))
    self.listUpHeight = self.listUpHeight + 2 * th
    h = list_top - self.listUpHeight
  end
  self.listUpHeight = self.listUpHeight + 12
end
class.refreshGrowthPos = refreshGrowthPos
local refreshGrowth = function(self)
  local preGrowth = self.growth
  local growth = self:getAttGrowth()
  for k, v in pairs(preGrowth) do
    if growth[k] ~= v then
      do
        local label = self.growthui[k .. "_G"]
        ed.setString(label, growth[k])
        ed.setNodeAnchor(label, ccp(0.5, 0.5))
        local a = CCArray:create()
        local s1 = CCScaleTo:create(0.2, 1.2)
        s1 = CCEaseBackIn:create(s1)
        local s2 = CCScaleTo:create(0.2, 1)
        s2 = CCEaseBackOut:create(s2)
        local f = CCCallFunc:create(function()
          xpcall(function()
            ed.setNodeAnchor(label, ccp(0, 0.5))
          end, EDDebug)
        end)
        a:addObject(s1)
        a:addObject(s2)
        a:addObject(f)
        local s = CCSequence:create(a)
        label:runAction(s)
      end
    end
  end
end
class.refreshGrowth = refreshGrowth
local createAttList = function(self)
  self.attui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "des_title_bg",
        res = "UI/alpha/HVGA/herodetail-title-mark.png"
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "des_title",
        text = T(LSTR("HERODETAILATT.HERO_INTROUDUCEMENT")),
        size = 20
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {
        color = ccc3(251, 206, 16)
      },
      offsetY = 6,
      addHeight = 4
    },
    {
      t = "Label",
      base = {
        name = "des",
        text = self.info.description,
        size = 18
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {
        dimension = CCSizeMake(235, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        verticalAlignment = kCCVerticalTextAlignmentTop
      },
      addHeight = 10
    }
  }
  local height = self:addListNode(ui_info)
  self.listUpHeight = height
  if self.info.narrative then
    self.listUpHeight = self.listUpHeight + 5
    ui_info = {
      {
        t = "Label",
        base = {
          name = "narrative",
          text = self.info.narrative,
          size = 16
        },
        layout = {
          position = ccp(0, 0)
        },
        config = {
          color = ed.toccc3(15843697),
          dimension = CCSizeMake(235, 0),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop
        },
        addHeight = 10
      }
    }
    local height = self:addListNode(ui_info)
    self.listUpHeight = height + 5
  end
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "des_title_bg",
        res = "UI/alpha/HVGA/herodetail-title-mark.png"
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "des_title",
        text = T(LSTR("HERODETAILATT.HERO_ATTRIBUTES")),
        size = 20
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {
        color = ccc3(251, 206, 16)
      },
      offsetY = 6,
      addHeight = 0
    }
  }
  local height = self:addListNode(ui_info)
  self.listUpHeight = height
  self:createGrowth()
  self.waitCreateDetailID = self.mainLayer:getScheduler():scheduleScriptFunc(self:waitCreateDetail(), 0, false)
end
class.createAttList = createAttList
local getAtt = function(self)
  local attInfo = ed.readhero.getHeroAttByHero(self.hero)
  self.attInfo = attInfo
end
class.getAtt = getAtt
local getInformation = function(self)
  local info = {}
  local hero = self:getHero()
  local heroId = hero._tid
  local heroRank = hero._rank
  local unitInfo = ed.getDataTable("Unit")
  info.description = unitInfo[heroId].Description
  info.narrative = unitInfo[heroId].Narrative
  info.voiceDesc = unitInfo[heroId]["Voice Artist"]
  self.info = info
  self:getAtt()
end
class.getInformation = getInformation
local function create(hero, param)
  param = param or {}
  local self = base.create("herodetailatt")
  setmetatable(self, class.mt)
  self.closeHandler = param.closeHandler
  self.parent = param.parent
  self.hero = hero
  self:getInformation()
  local mainLayer = self.mainLayer
  local container = self.container
  container:setPosition(ccp(48, 0))
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/herodetail-detail-popup.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {isCascadeOpacity = true}
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(545, 430)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png"
      },
      layout = {
        position = ccp(545, 430)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  local info = {
    cliprect = CCRectMake(18, 15, 249, 415),
    container = self.ui.bg,
    zorder = 10,
    priority = -136
  }
  self.draglist = ed.draglist.create(info)
  self:createAttList()
  self:registerTouchHandler()
  self:registerTouchHandler()
  self.parent:addChild(self.mainLayer)
  return self
end
class.create = create
local popBack = function(self, param)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if self.container:numberOfRunningActions() > 0 then
    return
  end
  self.mainLayer:setTouchEnabled(false)
  self.mainLayer:setZOrder(0)
  local move = CCMoveTo:create(0.2, param.endPos)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        self.mainLayer:removeFromParentAndCleanup(true)
      end
      if param.callback then
        param.callback()
      end
    end, EDDebug)
  end)
  self.container:runAction(ed.readaction.create({
    t = "seq",
    move,
    func
  }))
end
class.popBack = popBack
local pop = function(self, param)
  self.mainLayer:setTouchEnabled(false)
  if not param.skipAnim then
    self.container:setPosition(param.oriPos)
    local move = CCMoveTo:create(0.2, param.endPos)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.mainLayer:setTouchEnabled(true)
      end, EDDebug)
    end)
    self.container:runAction(ed.readaction.create({
      t = "seq",
      move,
      func
    }))
  else
    self.container:setPosition(param.endPos)
    self.mainLayer:setTouchEnabled(true)
  end
end
class.pop = pop

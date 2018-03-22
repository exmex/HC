local ed = ed
ed.ui = ed.ui or {}
ed.ui.announce = {}
local announce = ed.ui.announce
local param_notshade = false
local param_notshade_default = false
local param_container, param_container_default
local param_priority_default = -900
local param_priority = param_priority_default
local param_zorder_default = 500
local param_zorder = param_zorder_default
local class = {
  mt = {}
}
class.mt.__index = class
announce.base = class
class.config = {}
class.windowCache = {}
local function refreshWindowCache()
  for i, v in ipairs(class.windowCache) do
    if tolua.isnull(v.mainLayer) then
      table.remove(class.windowCache, i)
      refreshWindowCache()
      break
    end
  end
end
class.refreshWindowCache = refreshWindowCache
local stopRefreshCliprect = function(self, scheduler, id)
  scheduler = scheduler or self.mainLayer:getScheduler()
  id = id or self.refreshCliprectid
  if scheduler and id then
    scheduler:unscheduleScriptEntry(id)
  end
end
class.stopRefreshCliprect = stopRefreshCliprect
local beginRefreshCliprect = function(self)
  self.refreshCliprectid = self.mainLayer:getScheduler():scheduleScriptFunc(self:refreshCliprect(), 0, false)
end
class.beginRefreshCliprect = beginRefreshCliprect
local refreshCliprect = function(self)
  local scheduler = self.mainLayer:getScheduler()
  local id
  local function handler()
    xpcall(function()
      if not id then
        id = self.refreshCliprectid
      end
      if tolua.isnull(self.mainLayer) then
        self:stopRefreshCliprect(scheduler, id)
        return
      end
      self.draglist:refreshClipRect(self.container:getScale())
    end, EDDebug)
  end
  return handler
end
class.refreshCliprect = refreshCliprect
local function create(type)
  local self = {}
  setmetatable(self, class.mt)
  refreshWindowCache()
  self.announceType = type
  local announce_config = class.config[type] or {}
  local mainLayer
  if param_notshade then
    mainLayer = CCLayer:create()
  else
    mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  end
  self.mainLayer = mainLayer
  local container = CCLayer:create()
  self.container = container
  container:setAnchorPoint(ccp(0.5, 0.5))
  mainLayer:addChild(container)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, param_priority, true)
  local scene = param_container or CCDirector:sharedDirector():getRunningScene()
  scene:addChild(mainLayer, param_zorder)
  return self
end
class.create = create
local registerTouchHandler = function(self, handler, key)
  self.touchHandlerList = self.touchHandlerList or {}
  if not key then
    table.insert(self.touchHandlerList, handler)
  else
    self.touchHandlerList[key] = handler
  end
end
class.registerTouchHandler = registerTouchHandler
local removeTouchHandler = function(self, key)
  self.touchHandlerList = self.touchHandlerList or {}
  self.touchHandlerList[key] = nil
end
class.removeTouchHandler = removeTouchHandler
local doMainLayerTouch = function(self)
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.touchHandlerList or {}) do
        v(event, x, y)
      end
      if event == "ended" and not self.notClickDestroy then
        self:destroy()
      end
    end, EDDebug)
    return true
  end
  return handler
end
class.doMainLayerTouch = doMainLayerTouch
local cancelTouchLayer = function(self)
  self.mainLayer:setTouchEnabled(false)
end
class.cancelTouchLayer = cancelTouchLayer
local useTouchLayer = function(self)
  self.mainLayer:setTouchEnabled(true)
end
class.useTouchLayer = useTouchLayer
local setClickDestroyEnabled = function(self, b)
  self.notClickDestroy = not b
end
class.setClickDestroyEnabled = setClickDestroyEnabled
local function show(self, handler)
  local container = self.container
  container:setScale(0)
  if self.preShowHandler then
    self.preShowHandler()
  end
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if handler then
        handler()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
  if self.announceType == "getProp" and self.identity == "task" then
    self.lsr:report("createPopWindow")
  else
    ed.playEffect(ed.sound.announce.createAnnounce)
  end
end
class.show = show
local setDestroyHandler = function(self, handler)
  self.destroyHandler = handler
end
class.setDestroyHandler = setDestroyHandler
local function destroy(self, skipAnim)
  local container = self.container
  local handler = self.destroyHandler
  if self.preDestroyHandler then
    self.preDestroyHandler()
  end
  local function dealHandler()
    if handler then
      handler()
    end
    self.mainLayer:removeFromParentAndCleanup(true)
  end
  if not skipAnim then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        dealHandler()
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    container:runAction(s)
  else
    dealHandler()
  end
  if self.announceType == "getProp" and self.identity == "task" then
    self.lsr:report("closePopWindow")
  else
    ed.playEffect(ed.sound.announce.destroyAnnounce)
  end
end
class.destroy = destroy
local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.close_press
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
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.getNewHero = class
local function dookTouch(self)
  local isPress
  local button = self.ui.ok
  local press = self.ui.ok_press
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
class.dookTouch = dookTouch
local function create(param)
  local self = base.create()
  setmetatable(self, class.mt)
  local container = self.container
  local hid = param.id
  local disp_name = ed.getDataTable("Unit")[hid]["Display Name"]
  local handler = param.handler
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local ui = {}
  self.ui = ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title",
        res = "UI/alpha/HVGA/get_new_hero_title.png",
        z = 1
      },
      layout = {
        position = ccp(400, 370)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/lettherebelight.png"
      },
      layout = {
        position = ccp(400, 250)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/HVGA/get_new_hero_bar.png"
      },
      layout = {
        position = ccp(400, 110)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "name",
        parent = "name_bg",
        text = disp_name,
        fontinfo = "ui_herotitle_stroke",
        max_width = 240,
        size = 30
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(170, 40)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        position = ccp(400, 40)
      },
      config = {
        scaleSize = CCSizeMake(100, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(100, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T(LSTR("CHATCONFIG.CONFIRM")),
        fontinfo = "ui_normal_button",
        parent = "ok"
      },
      layout = {
        position = ccp(50, 24)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  local rotate = CCRotateBy:create(5, 370)
  ui.light:runAction(CCRepeatForever:create(rotate))
  local actor = ed.readhero.getActor(hid, "Move")
  actor:setPosition(ccp(400, 160))
  ed.getCurrentScene():addFca(actor)
  container:addChild(actor, 5)
  local sound = ed.getDataTable("Unit")[hid]["Voice Move"]
  ed.playEffect(sound)
  self:registerTouchHandler(self:dookTouch())
  self:show()
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.heroUpgrade = class
local function getHero(self)
  return ed.player.heroes[self.hid]
end
class.getHero = getHero
local getHeroRank = function(self)
  return self:getHero()._rank
end
class.getHeroRank = getHeroRank
local function unlockSkill(self)
  local sgt = ed.getDataTable("SkillGroup")
  for i = 1, 4 do
    local row = sgt[self.hid][i]
    local rank = row.Unlock
    if self:getHeroRank() == rank then
      return {
        slotid = i,
        sgid = row["Skill Group ID"]
      }
    end
  end
  return nil
end
class.unlockSkill = unlockSkill
local function getSkillInfo(self, slot, sgid)
  local skill_frame = {
    "UI/alpha/HVGA/equip_frame_white.png",
    "UI/alpha/HVGA/equip_frame_green.png",
    "UI/alpha/HVGA/equip_frame_blue.png",
    "UI/alpha/HVGA/equip_frame_purple.png"
  }
  local sgTable = ed.getDataTable("SkillGroup")
  local sTable = ed.getDataTable("Skill")
  local sgRow = sgTable[self.hid][slot]
  local hid = self.hid
  return {
    frame = skill_frame[slot],
    name = sgRow["Display Name"],
    iconres = sgRow.Icon,
    desc = sTable[sgid][0].Description
  }
end
class.getSkillInfo = getSkillInfo
local function getInformation(self, hero)
  local rank = hero._rank
  local unit = ed.UnitCreate(hero)
  local gs = hero._gs
  local hp = math.floor(unit.attribs.HP)
  return rank, unit, gs, hp
end
class.getInformation = getInformation
local function create(param)
  local self = base.create("heroUpgrade")
  setmetatable(self, class.mt)
  local container = self.container
  local handler = param.handler
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local hid = param.id
  self.hid = hid
  local preHero = param.preHero
  local preRank, preUnit, pregs, prehp, prehpAdded, pregsAdded =  preHero.rank, preHero.unit, preHero.gs, preHero.hp, preHero.hpAdded or 0, preHero.gsAdded or 0 
  local preIcon = ed.readhero.createIcon({id = hid, rank = preRank}).icon
  local hero = self:getHero()
  local rank, unit, gs, hp = self:getInformation(hero)
  local icon = ed.readhero.createIcon({id = hid, rank = rank}).icon
  local skill = self:unlockSkill()
  local ui = {}
  self.ui = ui
  ui.pre_icon = preIcon
  ui.icon = icon
  local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  container:addChild(bg)
  self.ui.bg = bg
  local huContainer = CCSprite:create()
  self.huContainer = huContainer
  huContainer:setAnchorPoint(ccp(0, 0))
  huContainer:setPosition(ccp(0, 0))
  bg:addChild(huContainer, 5)
  local readnode = ed.readnode.create(huContainer, self.ui)
  local width = 450
  local height = 0
  if skill then
    local info = self:getSkillInfo(skill.slotid, skill.sgid)
    local len = ed.stringutil.len(info.desc)
    if len > 42 then
      info.desc = ed.stringutil.sub(info.desc, 1, 39) .. "..."
    end
    local sw = 270
    local odx = (width - sw - 100) / 2
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "skill_board",
          res = "UI/alpha/HVGA/announce_text_bg_green.png"
        },
        layout = {
          position = ccp(width / 2, 70)
        },
        config = {
          fix_size = CCSizeMake(width, 120)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "skill_icon",
          res = info.iconres
        },
        layout = {
          position = ccp(odx + 65, 67)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "skill_frame",
          res = info.frame
        },
        layout = {
          position = ccp(odx + 65, 65)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "skill_name",
          text = T(LSTR("ANNOUNCE.NEW_SKILLS_")) .. info.name,
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(odx + 115, 105)
        },
        config = {
          color = ccc3(250, 205, 16)
        }
      },
      {
        t = "Label",
        base = {
          name = "skill_desc",
          text = info.desc,
          size = 18
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(odx + 115, 85)
        },
        config = {
          dimension = CCSizeMake(sw, 0),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop
        }
      }
    }
    readnode:addNode(ui_info)
    local r = CCRotateBy:create(5, 360)
    r = CCRepeatForever:create(r)
    height = height + 120
  end
  local gs_ui = {}
  if not (pregsAdded > 0) or not ccp(0.5, 0.5) then
  end
  if not (pregsAdded <= 0) or not "" then
  end
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "gs", nodeArray = gs_ui},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(pregsAdded > 0 and width / 2 or 115, height + 25)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "title",
            text = T(LSTR("HERODETAIL.POWER_")),
            size = 20
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "pre_gs",
            text = pregs,
            size = 18
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        },
--[[        {
          t = "Label",
          base = {
            name = "pre_gs_added",
            text = "+" .. pregsAdded .. T(LSTR("ANNOUNCE.ENCHANTMENT")),
            size = 18
          },
          config = {
            color = ccc3(0, 255, 0)
          }
        },
--]]        {
          t = "Sprite",
          base = {
            name = "gs_arrow",
            res = "UI/alpha/HVGA/player_levelup_arrow.png",
            offset = 10
          }
        },
        {
          t = "Label",
          base = {
            name = "gs",
            text = gs,
            size = 18,
            offset = 10
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  height = height + 45
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(0, 0)
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
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readnode:addNode(ui_info)
  local hp_ui = {}
--  if not (prehpAdded > 0) or not ccp(0.5, 0.5) then
--  end
--  if not (prehpAdded <= 0) or not "" then
--  end
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "hp_board",
        res = "UI/alpha/HVGA/announce_text_bg_green.png"
      },
      layout = {
        position = ccp(width / 2, height + 20)
      },
      config = {
        fix_size = CCSizeMake(width, 40)
      }
    },
    {
      t = "HorizontalNode",
      base = {name = "hp", nodeArray = hp_ui},
      layout = {
        anchor =  (prehpAdded > 0) and ccp(0.5, 0.5) or  ccp(0, 0.5),
        position = ccp(prehpAdded > 0 and width / 2 or 115, height + 20)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "hp_title",
            text = T(LSTR("ANNOUNCE.HEALTH_")),
            size = 20
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "pre_hp",
            text = prehp,
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(255, 234, 198)
          }
        },
--[[         {
          t = "Label",
          base = {
            name = "pre_hp_added",
            text =  ((prehpAdded <= 0) and ""  or "+" ) .. prehpAdded .. T(LSTR("ANNOUNCE.ENCHANTMENT")),
            size = 18
          },
          config = {
            color = ccc3(0, 255, 0)
          }
        },
--]]        {
          t = "Sprite",
          base = {
            name = "hp_arrow",
            res = "UI/alpha/HVGA/player_levelup_arrow.png",
            offset = 10
          },
          layout = {}
        },
        {
          t = "Label",
          base = {
            name = "hp",
            text = hp,
            size = 18,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  height = height + 40
  preIcon:setPosition(ccp(width / 3, height + 55))
  icon:setPosition(ccp(width / 3 * 2, height + 55))
  local iconArrow = ed.createSprite("UI/alpha/HVGA/player_levelup_arrow.png")
  iconArrow:setPosition(ccp(width / 2, height + 55))
  ui.icon_arrow = iconArrow
  huContainer:addChild(preIcon)
  huContainer:addChild(iconArrow)
  huContainer:addChild(icon)
  height = height + 110 + 40
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(width / 2, height))
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/herodetail_popup_rankup_title.png")
  title:setPosition(ccp(width / 2, height))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  bg:setContentSize(CCSizeMake(width, height))
  bg:setPosition(ccp(400, 240))
  self.ui.close:setPosition(ccp(width - 10, height - 20))
  self:registerTouchHandler(self:doCloseTouch())
  self:show(self:titleAnimHandler())
  return self
end
class.create = create
local titleAnimHandler = function(self)
  local function handler()
    local ui = self.ui
    local title = ui.title
    title:setVisible(true)
    title:setScale(1.5)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        ui.light:setVisible(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    title:runAction(s)
  end
  return handler
end
class.titleAnimHandler = titleAnimHandler
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
announce.heroEvolve = class
setmetatable(class, base.mt)
local function createGrowth(self)
  local container = self.heContainer
  local ui = self.ui
  local growth = self.growth
  local preGrowth = self.preGrowth
  local keys = {
    {
      key = "STR",
      name = T(LSTR("HERO_EQUIP.STRENGTH"))
    },
    {
      key = "INT",
      name = T(LSTR("HERO_EQUIP.INTELLIGENCE"))
    },
    {
      key = "AGI",
      name = T(LSTR("HERO_EQUIP.AGILITY"))
    }
  }
  local readnode = ed.readnode.create(container, ui)
  for i = 1, 3 do
    local key = keys[i].key
    local name = keys[i].name
    if i % 2 == 1 then
      local ui_info = {
        {
          t = "Sprite",
          base = {
            name = key .. "_board",
            res = "UI/alpha/HVGA/announce_text_bg_purple.png"
          },
          layout = {
            position = ccp(200, 120 - 40 * (i - 1))
          },
          config = {
            fix_size = CCSizeMake(400, 40)
          }
        }
      }
      readnode:addNode(ui_info)
    end
    local ofx = 10
    local ui_info = {
      {
        t = "Label",
        base = {
          name = key .. "_title",
          text = name .. " " .. T(LSTR("ANNOUNCE.GROWTH_")),
          size = 20
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(130 + ofx, 120 - 40 * (i - 1))
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      },
      {
        t = "Label",
        base = {
          name = "pre_" .. key,
          text = preGrowth[key],
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(165 + ofx, 120 - 40 * (i - 1))
        },
        config = {
          color = ccc3(255, 234, 198)
        }
      },
      {
        t = "Sprite",
        base = {
          name = key .. "_arrow",
          res = "UI/alpha/HVGA/player_levelup_arrow.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(210 + ofx, 120 - 40 * (i - 1))
        }
      },
      {
        t = "Label",
        base = {
          name = key,
          text = growth[key],
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(255 + ofx, 120 - 40 * (i - 1))
        },
        config = {
          color = ccc3(255, 234, 198)
        }
      },
      {
        t = "Label",
        base = {
          name = key .. "_add",
          text = string.format("(" .. name .. "+%.01f)", self.att[key] - self.preAtt[key].all),
          size = 16
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(285 + ofx, 120 - 40 * (i - 1))
        },
        config = {
          color = ccc3(0, 255, 0)
        }
      }
    }
    readnode:addNode(ui_info)
  end
end
class.createGrowth = createGrowth
local function create(param)
  local self = base.create()
  setmetatable(self, class.mt)
  local hid = param.id
  self.hid = hid
  local preAtt = param.preAtt
  local growth = ed.readhero.getGrowth(hid)
  local preGrowth = ed.readhero.getGrowth(hid, -1)
  self.growth = growth
  self.preGrowth = preGrowth
  self.preAtt = preAtt
  self.att = ed.UnitCreate(ed.player.heroes[hid]).attribs
  local container = self.container
  self:setClickDestroyEnabled(false)
  local ui = {}
  self.ui = ui
  local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  container:addChild(bg)
  self.ui.bg = bg
  bg:setContentSize(CCSizeMake(425, 290))
  bg:setPosition(ccp(400, 240))
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(0, 0)
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
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  local readnode = ed.readnode.create(bg, ui)
  readnode:addNode(ui_info)
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, 0))
  bg:addChild(container, 5)
  self.heContainer = container
  self:createGrowth()
  local preIcon = ed.readhero.createIconByID(hid, {addStar = -1, state = "idle"}).icon
  local icon = ed.readhero.createIconByID(hid, {state = "idle"}).icon
  preIcon:setPosition(ccp(145, 195))
  local iconArrow = ed.createSprite("UI/alpha/HVGA/player_levelup_arrow.png")
  iconArrow:setAnchorPoint(ccp(0, 0.5))
  ui.icon_arrow = iconArrow
  iconArrow:setPosition(ed.getRightSidePos(preIcon))
  icon:setAnchorPoint(ccp(0, 0.5))
  icon:setPosition(ed.getRightSidePos(iconArrow))
  container:addChild(preIcon)
  container:addChild(iconArrow)
  container:addChild(icon)
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(205, 290))
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/herodetail_popup_evolution_title.png")
  title:setPosition(ccp(205, 290))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  bg:setContentSize(CCSizeMake(410, 290))
  bg:setPosition(ccp(400, 240))
  ui.close:setPosition(ccp(400, 270))
  self:registerTouchHandler(self:doCloseTouch())
  self:show(self:titleAnimHandler())
  return self
end
class.create = create
local titleAnimHandler = function(self)
  local function handler()
    local ui = self.ui
    local title = ui.title
    title:setVisible(true)
    title:setScale(1.5)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        ui.light:setVisible(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    title:runAction(s)
  end
  return handler
end
class.titleAnimHandler = titleAnimHandler
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.playerLevelup = class
local function getUnlockDesc(self)
  local info = self.info
  local desc = {}
  table.insert(desc, {
    title = T(LSTR("ANNOUNCE.TEAM_RATING_")),
    desc = {
      now = self.level,
      pre = self.preLevel
    },
    type = "sl"
  })
  local pldt = ed.getDataTable("PlayerLevelDisplay")
  local index = 1
  while pldt[index] do
    local row = pldt[index]
    local key = row.Name
    local ds = row.Display
    local ds2 = row.Display2
    local vl = info[key]
    local tp = type(vl)
    if tp == "table" then
      table.insert(desc, {
        title = ds,
        desc = {
          pre = vl.pre,
          now = vl.now
        },
        type = "sl"
      })
    elseif tp == "number" then
      table.insert(desc, {
        title = ds,
        desc = string.format(ds2, vl),
        type = "sn"
      })
    elseif tp == "boolean" then
      table.insert(desc, {
        title = ds,
        desc = ds2,
        type = "s"
      })
    end
    index = index + 1
  end
  self.desc = desc
end
class.getUnlockDesc = getUnlockDesc
local function getInformation(self, pl)
  local info = {}
  local l = self.level
  local pl = self.preLevel
  local plt = ed.getDataTable("PlayerLevel")
  local row = plt[l]
  local preRow = plt[pl]
  local heroLevel = row["Max Hero Level"]
  local preHeroLevel = preRow["Max Hero Level"]
  if heroLevel > preHeroLevel then
    info["Max Hero Level"] = {now = heroLevel, pre = preHeroLevel}
  end
  local maxVit = row["Max Vitality"]
	
	local viplevel=ed.player:getvip()
	local vipTable=ed.getDataTable("VIP")
	
	
	maxVit=maxVit+(vipTable[viplevel])["User Vitality Max"]

  local preMaxVit = preRow["Max Vitality"]+(vipTable[viplevel])["User Vitality Max"]
  if maxVit > preMaxVit then
    info["Max Vitality"] = {now = maxVit, pre = preMaxVit}
  end
  local vit = ed.player:getVitality()
  local pvit = vit
  for i = pl, l - 1 do
    pvit = pvit - plt[i]["Vitality Reward"]
  end
  info["Vitality Reward"] = {now = vit, pre = pvit}
  local unlock = row.Unlock
  for k, v in pairs(unlock or {}) do
    if type(v) == "string" then
      if v == "Chapter" then
        info[v] = row.Chapter
      else
        info[v] = true
      end
    end
  end
  self.info = info
end
class.getInformation = getInformation
local function create(param)
  local nowLevel = param.level or ed.player:getLevel()
  if param.preLevel and nowLevel <= param.preLevel then
    return
  end
  local self = base.create("playerLevelup")
  setmetatable(self, class.mt)
  self.level = nowLevel
  self.preLevel = param.preLevel or ed.player:getLevel() - 1
  local container = self.container
  self:getInformation()
  self:getUnlockDesc()
  local ui = {}
  self.ui = ui
  local width = 420
  local listContainer = CCSprite:create()
  local readnode = ed.readnode.create(listContainer, ui)
  local height = 0
  local desc = self.desc
  for i = 1, #desc do
    local ds = desc[i]
    if i % 2 == 1 then
      local ui_info = {
        {
          t = "Sprite",
          base = {
            name = "board_" .. i,
            res = "UI/alpha/HVGA/announce_text_bg_blue.png"
          },
          layout = {
            position = ccp(width / 2, height - 15)
          },
          config = {
            fix_size = CCSizeMake(420, 40)
          }
        }
      }
      readnode:addNode(ui_info)
    end
    local tp = ds.type
    if tp == "sl" then
      local ui_info = {
        {
          t = "Label",
          base = {
            name = "title_" .. i,
            text = ds.title,
            fontinfo = "ui_normal_button",
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(width / 2 - 120, height - 15)
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "pre_" .. i,
            text = ds.desc.pre,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "arrow" .. i,
            res = "UI/alpha/HVGA/player_levelup_arrow.png"
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {}
        },
        {
          t = "Label",
          base = {
            name = "now_" .. i,
            text = ds.desc.now,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
      readnode:addNode(ui_info)
      ui["pre_" .. i]:setPosition(ed.getRightSidePos(ui["title_" .. i], 15))
      ui["arrow" .. i]:setPosition(ed.getRightSidePos(ui["pre_" .. i], 15))
      ui["now_" .. i]:setPosition(ed.getRightSidePos(ui["arrow" .. i], 15))
    else
      local ui_info = {
        {
          t = "Label",
          base = {
            name = "title_" .. i,
            text = ds.title,
            fontinfo = "ui_normal_button",
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(width / 2 - 120, height - 15)
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "desc_" .. i,
            text = ds.desc,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
      readnode:addNode(ui_info)
      ui["desc_" .. i]:setPosition(ed.getRightSidePos(ui["title_" .. i]))
    end
    height = height - 40
  end
  local height = -height + 15
  local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  container:addChild(bg)
  self.ui.bg = bg
  bg:setPosition(ccp(400, 240))
  self:setClickDestroyEnabled(false)
  readnode = ed.readnode.create(bg, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(0, 0)
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
    }
  }
  readnode:addNode(ui_info)
  listContainer:setAnchorPoint(ccp(0, 0))
  listContainer:setPosition(ccp(0, height))
  bg:addChild(listContainer, 5)
  height = height + 50
  bg:setContentSize(CCSizeMake(width, height))
  ui.close:setPosition(ccp(width, height - 25))
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(width / 2, height))
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/player_levelup_title.png")
  title:setPosition(ccp(width / 2, height))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  self:registerTouchHandler(self:doCloseTouch())
  self:show(self:titleAnimHandler())
  return self
end
class.create = create
local titleAnimHandler = function(self)
  local function handler()
    local ui = self.ui
    local title = ui.title
    title:setVisible(true)
    title:setScale(1.5)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        ui.light:setVisible(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    title:runAction(s)
  end
  return handler
end
class.titleAnimHandler = titleAnimHandler
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.getProp = class
local default_alignment = "center"
local b_w = 400
local win_height = 165
local o_y = 235
local icon_dy = 35
local function getIconPos(alignment, index, offsety)
  if not index then
    return ccp(0, 0)
  end
  local y = 0
  alignment = alignment or default_alignment
  offsety = offsety or 0
  local x_pos = {
    leftSide = 60,
    left = b_w / 4,
    center = b_w / 2
  }
  local x = x_pos[alignment]
  y = y - icon_dy * (index - 1) - offsety
  return ccp(x, y)
end
local function getItemAnchor(alignment)
  alignment = alignment or default_alignment
  local anchor = {
    leftSide = ccp(0, 0.5),
    left = ccp(0, 0.5),
    center = ccp(0.5, 0.5)
  }
  return anchor[alignment]
end
local function dookTouch(self)
  local isPress
  local button = self.ui.ok
  local press = self.ui.ok_press
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
          if self.identity == "task" then
            self.lsr:report("clickPopWindowok")
          end
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.dookTouch = dookTouch
local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.close_press
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
          if self.identity == "task" then
            self.lsr:report("clickPopWindowok")
          end
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCloseTouch = doCloseTouch
local function createListLayer(self, height)
  local info = {
    cliprect = CCRectMake(55, 88, b_w - 100, height),
    noshade = true,
    zorder = 20,
    container = self.ui.bg
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:addItem(self.rewardContainer)
  return self.draglist:getListLayerTouchHandler()
end
class.createListLayer = createListLayer
local function createContent(self)
  local dalign = self.alignment
  local items = self.items
  local rewardContainer = CCLayer:create()
  self.rewardContainer = rewardContainer
  local listHeight = 0
  local t_offsety = 0
  local contents = {}
  self.heroLoots = {}
  for i = 1, #items do
    local item = items[i]
    local offsety = item.offsety
    local bottomy = item.bottomy
    local preh = 0
    if i > 1 and items[i - 1].explain then
      local preNode = contents[i - 1]
      local preH = preNode:getContentSize().height
      local preAH = preNode:getAnchorPoint().y
      preh = preH * preAH
    end
    t_offsety = t_offsety + (offsety or 0) + preh
    listHeight = listHeight + icon_dy
    local title = item.title
    local id = item.id
    local amount = item.amount
    local displayAmount = item.displayAmount
    local type = item.type or "item"
    local explain = item.explain
    local alignment = item.alignment or dalign
    local ianchor = getItemAnchor(alignment)
    local ipos = getIconPos(alignment, i, t_offsety)
    local nodeAnchor = item.nodeAnchor or ianchor
    if explain then
      nodeAnchor = ccp(0.5, 1)
    end
    local horizontalAlignment = item.horizontalAlignment or kCCTextAlignmentLeft
    local verticalAlignment = item.verticalAlignment or kCCVerticalTextAlignmentTop
    if ed.isElementInTable(type, {"Item", "Hero"}) then
      type = "item"
    end
    local icon, name
    local nodes = {}
    if explain then
      local label = ed.createttf(explain, 18)
      ed.setLabelColor(label, ccc3(238, 196, 117))
      ed.setLabelDimensions(label, CCSizeMake(280, 0))
      label:setHorizontalAlignment(horizontalAlignment)
      label:setVerticalAlignment(verticalAlignment)
      table.insert(nodes, label)
      if i == #items then
        local h = label:getContentSize().height
        local ah = label:getAnchorPoint().y
        listHeight = listHeight + h * ah
      end
    else
      if type == "item" then
        local it = ed.itemType(id)
        if id then
          if it == "equip" or item.type == "Item" then
            name = ed.getDataTable("equip")[id].Name
          elseif it == "hero" or item.type == "Hero" then
            if id ~= nil and id > 0 then
              name = ed.getDataTable("Unit")[id]["Display Name"]
              table.insert(self.heroLoots, {id = id, amount = amount})
            end
          else
            name = ""
          end
        end
        if id ~= nil and id > 0 then
          icon = ed.readequip.createIcon(id, 35)
        end
      else
        name = item.name
        local icon_res = {
          Gold = "UI/alpha/HVGA/task_gold_icon_2.png",
          Coin = "UI/alpha/HVGA/task_gold_icon_2.png",
          Diamond = "UI/alpha/HVGA/task_rmb_icon_2.png",
          PlayerEXP = "UI/alpha/HVGA/task_exp_icon_2.png",
          Vitality = "UI/alpha/HVGA/task_vit_icon_2.png",
          GuildCoin = "UI/alpha/HVGA/money_guildtoken_small.png",
          MonthCard = "UI/alpha/HVGA/recharge_monthlycard_1.png"
        }
        local icon_height = {PlayerEXP = 25}
        name = name or ""
        local ires = icon_res[type]
        if not ires then
          print("wrong type of reward:", type)
        end
        if ires then
          icon = ed.createSprite(ires)
        else
          icon = CCSprite:create()
        end
        ed.scaleNodeBySideLen(icon, "h", icon_height[type] or 30)
      end
      local label
      if title then
        label = ed.createttf(title, 18)
        ed.setLabelColor(label, ccc3(197, 153, 79))
        table.insert(nodes, label)
      end
      table.insert(nodes, {node = icon, offset = 10})
      if name then
        label = ed.createttf(name, 18)
        ed.setLabelColor(label, ccc3(238, 221, 197))
        table.insert(nodes, {node = label, offset = 10})
      end
      label = ed.createttf("x" .. (displayAmount or amount), 18)
      if type == "item" then
        ed.setLabelColor(label, ccc3(238, 221, 197))
      else
        ed.setLabelColor(label, ccc3(217, 161, 100))
      end
      table.insert(nodes, {node = label, offset = 10})
    end
    local node = ed.horizontalArrange(nodes)
    node:setAnchorPoint(nodeAnchor)
    node:setPosition(ipos)
    rewardContainer:addChild(node)
    table.insert(contents, node)
    t_offsety = t_offsety + (bottomy or 0)
  end
  local rh = math.min(win_height, listHeight + t_offsety + 5)
  local prh = rh
  rh = math.max(rh, 50)
  if prh < rh then
    rewardContainer:setPosition(ccp(0, rh + 60))
  else
    rewardContainer:setPosition(ccp(0, rh + 70))
  end
  return rh, listHeight + t_offsety
end
class.createContent = createContent
local function create(param)
  local self = base.create("getProp")
  setmetatable(self, class.mt)
  param = param or {}
  local container = self.container
  local identity = param.identity
  self.identity = identity
  local titleText = param.title or T(LSTR("ANNOUNCE.GAIN_LOOTS"))
  self.buttonText = param.buttonText
  local titleNode = param.titleNode
  local items = param.items or {}
  self.items = items
  self.forbidPopHero = param.forbidPopHero
  local hasCloseButton = param.hasCloseButton
  local alignment = param.alignment or default_alignment
  self.alignment = alignment
  local lsr
  if identity == "task" then
    lsr = ed.ui.tasklsr.create()
  end
  self.lsr = lsr
  local bg = ed.createScale9Sprite("UI/alpha/HVGA/common/common_getitem_bg.png", CCRectMake(70, 84, 325, 10))
  bg:setPosition(ccp(400, 240))
  bg:setContentSize(CCSizeMake(b_w, 322))
  container:addChild(bg)
  local ui = {}
  self.ui = ui
  ui.bg = bg
  local bg = CCSprite:create()
  bg:setAnchorPoint(ccp(0, 0))
  bg:setPosition(ccp(0, 0))
  ui.bg:addChild(bg, 5)
  ui.bgContainer = bg
  local rheight, lheight = self:createContent()
  local bheight = 157 + rheight
  ui.bg:setContentSize(CCSizeMake(b_w, bheight))
  local readnode = ed.readnode.create(bg, ui)
  local ui_info = {
    --[[{
      t = "Scale9Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/detail_title_bg.png",
        capInsets = CCRectMake(80, 5, 340, 5)
      },
      layout = {
        position = ccp(b_w / 2, bheight - 42)
      },
      config = {
        scaleSize = CCSizeMake(b_w - 100, 15)
      }
    },]]--
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(10, 10, 108, 29)
      },
      layout = {
        position = ccp(b_w / 2, 52)
      },
      config = {
        scaleSize = CCSizeMake(128, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(10, 10, 108, 29),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(128, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = self.buttonText or T(LSTR("CHATCONFIG.CONFIRM")),
        fontinfo = "ui_normal_button",
        parent = "ok"
      },
      layout = {
        position = ccp(64, 24)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  if hasCloseButton then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "close",
          res = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
        },
        layout = {
          position = ccp(b_w - 10, bheight - 37)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "close_press",
          res = "UI/alpha/HVGA/common/common_tips_button_close_2.png",
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
    self:registerTouchHandler(self:doCloseTouch())
  end
  if not titleNode then
    ui_info = {
      {
        t = "Label",
        base = {
          name = "title",
          text = titleText,
          fontinfo = "ui_normal_button"
        },
        layout = {
          position = ccp(b_w / 2, bheight - 42)
        },
        config = {
          color = ccc3(225, 208, 40)
        }
      }
    }
    readnode:addNode(ui_info)
	if ui.title:getContentSize().width > 350 then
		ui.title:setScale(350 / ui.title:getContentSize().width)
	end
  else
    titleNode:setPosition(ccp(b_w / 2, bheight - 42))
    ui.bg:addChild(titleNode)
  end
  local dragHandler = self:createListLayer(rheight)
  self:registerTouchHandler(dragHandler)
  self.draglist:initListHeight(lheight)
  self:setClickDestroyEnabled(false)
  self:registerTouchHandler(self:dookTouch())
  function self.preShowHandler()
    self:beginRefreshCliprect()
  end
  function self.preDestroyHandler()
    self:beginRefreshCliprect()
  end
  self:setDestroyHandler(function()
    self:stopRefreshCliprect()
    local function doPopHero(index)
      local callback
      if index == #self.heroLoots then
        function callback()
          if param.callback then
            param.callback()
          end
        end
      else
        function callback()
          doPopHero(index + 1)
        end
      end
      local hl = self.heroLoots[index]
      local id = hl.id
      local amount = hl.amount
      ed.announce({
        type = "popHeroCard",
        param = {
          id = id,
          amount = amount,
          callback = callback
        }
      })
    end
    if #(self.heroLoots or {}) > 0 and not self.forbidPopHero then
      doPopHero(1)
    elseif param.callback then
      param.callback()
    end
  end)
  self:show(function()
    self:stopRefreshCliprect()
  end)
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.popHeroCard = class
local function create(param)
  local self = base.create("popHeroCard")
  setmetatable(self, base.mt)
  local id = param.id
  local amount = param.amount
  local priority = param.priority
  local callback = param.callback
  local function getHandler()
    local function handler()
      if callback then
        callback()
      end
      self:destroy()
    end
    return handler
  end
  local cardWindow = ed.ui.popherocard.create({
    id = id,
    amount = amount,
    handler = getHandler(),
    priority = priority
  })
  self.mainLayer:addChild(cardWindow.mainLayer)
  self:cancelTouchLayer()
  return self
end
class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.announcement = class
local function create(param)
  param_notshade = true
  local self = base.create("announcement")
  setmetatable(self, class.mt)
  self:cancelTouchLayer()
  return self
end
class.create = create
function ed.announce(info)
  xpcall(function()
    local type = info.type
    local param = info.param or {}
    param_notshade = info.notshade or param_notshade_default
    param_container = info.container or param_container_default
    param_priority = (info.priority or 0) + param_priority_default
    param_zorder = info.z or param_zorder_default
    if not type then
      return
    end
    table.insert(class.windowCache, announce[type].create(param))
  end, EDDebug)
end

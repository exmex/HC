local ranklist = ed.ui.ranklist
local base = ed.ui.popwindow
local class = newclass(base.mt)
ranklist.usertoppvpsummary = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    force = true,
    clickInterval = 0.2,
    clickHandler = function()
      self:destroy()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(data)
  local self = base.create("usersummary")
  setmetatable(self, class.mt)
  local summary = data._summary
  local container = self.container
  local ui = self.ui
  local winCount = data._win_cnt
  if 1 == data._is_robot then
    winCount = data._summary._level + math.floor((string.byte(data._summary._name) + string.byte(data._summary._name, -1)) / 2)
  end
  ui.frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/main_vit_tips.png",
      capInsets = ed.DGRectMake(20, 20, 55, 25)
    },
    layout = {
      position = ccp(400, 240)
    },
    config = {
      scaleSize = ed.DGSizeMake(420, 440)
    }
  }, container)
  ui.content = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, ui.frame)
  ui.content:setPosition(20, 80)
  ui.head = ed.getTeamHead({
    id = summary._avatar,
    vip = 0 < summary._vip
  })
  ui.head = ed.createNode({
    t = "CCNode",
    base = {
      node = ui.head
    },
    layout = {
      position = ed.DGccp(52, 272)
    },
    config = {
      fix_size = ed.DGSizeMake(65, 65)
    }
  }, ui.content)
  ui.level = ed.getLevelIcon({
    level = summary._level,
    vip = 0 < summary._vip
  })
  ui.level = ed.createNode({
    t = "CCNode",
    base = {
      node = ui.level
    },
    layout = {
      position = ed.DGccp(110, 272)
    }
  }, ui.content)
  ui.name = ed.createNode({
    t = "Label",
    base = {
      text = summary._name,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.level, 10)
    },
    config = {}
  }, ui.content)
  ui.rankingTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("USERPVPSUMMARY.LASTRANK")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, 222)
    },
    config = {
      color = ccc3(255, 204, 118)
    }
  }, ui.content)
  ui.ranking = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.getNumberNode({
        text = data._rank,
        folder = "big_pvp"
      }).node
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.rankingTitle, 10)
    },
    config = {scale = 0.6}
  }, ui.content)
  ui.winCountTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("USERPVPSUMMARY.VICTORY")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, 178)
    },
    config = {
      color = ccc3(255, 204, 118)
    }
  }, ui.content)
  ui.winCount = ed.createNode({
    t = "Label",
    base = {
      text = tostring(winCount),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(162, 178)
    },
    config = {
      color = ccc3(247, 236, 198)
    }
  }, ui.content)
  ui.teamarry = {}
  ui.teamarrybg = {}
  for i = 1, 3 do
    ui.teamarrybg[i] = ed.createNode({
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/top_pvp/team_" .. tostring(i) .. "_select.png"
      },
      layout = {
        position = ccp(20, 137 - i * 54)
      },
      config = {}
    }, ui.content)
    ui.teamarry[i] = ed.createNode({
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/top_pvp/top_pvp_team_" .. tostring(i) .. ".png"
      },
      layout = {
        position = ccp(20, 137 - i * 54)
      },
      config = {}
    }, ui.content)
  end
  local dummyhero = function()
    local hero = {}
    for i = 1, 5 do
      hero[i] = {}
      hero[i] = {
        _tid = nil,
        _rank = 1,
        _level = nil,
        _stars = nil
      }
    end
    return hero
  end
  local oppo_heroes = data._oppo_heroes
  oppo_heroes = oppo_heroes or {}
  for i = 1, 3 do
    if oppo_heroes[i] == nil then
    else
    end
    oppo_heroes[i] = {
      _heroes = dummyhero()
    } or oppo_heroes[i]
  end
  if oppo_heroes then
    for i, team_heroes in ipairs(oppo_heroes) do
      for j, hero in ipairs(team_heroes._heroes) do
        local heroIcon = ed.readhero.createIcon({
          id = hero._tid,
          rank = hero._rank,
          level = hero._level,
          stars = hero._stars,
          awake = ed.protoAwake(hero)
        })
        heroIcon.icon:setPosition(ccp((j - 1) * 48 + 80, -(i - 1) * 54 + 85))
        heroIcon.icon:setScale(0.6)
        ui.content:addChild(heroIcon.icon)
      end
    end
  end
  ui.guild = ed.createNode({
    t = "Label",
    base = {
      text = summary._guild_name or T(LSTR("CRUSADE.NOT_IN_GUILDS")),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, -77)
    },
    config = {
      color = ccc3(255, 204, 118)
    }
  }, ui.content)
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create

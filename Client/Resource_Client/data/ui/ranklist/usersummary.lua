local ranklist = ed.ui.ranklist
local base = ed.ui.popwindow
local class = newclass(base.mt)
ranklist.usersummary = class
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
      scaleSize = ed.DGSizeMake(345, 305)
    }
  }, container)
  ui.content = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, ui.frame)
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
      text = T(LSTR("guildsummary.1.10.1.001")),
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
      position = ed.DGccp(162, 222)
    },
    config = {scale = 0.6}
  }, ui.content)
  ui.winCountTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("usersummary.1.10.1.001")),
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
      text = data._win_cnt,
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
  ui.gsTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("usersummary.1.10.1.002")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, 134)
    },
    config = {
      color = ccc3(255, 204, 118)
    }
  }, ui.content)
  ui.gs = ed.createNode({
    t = "Label",
    base = {
      text = data._gs,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(162, 134)
    },
    config = {
      color = ccc3(247, 236, 198)
    }
  }, ui.content)
  for i, v in ipairs(data._heros or {}) do
    local icon = ed.readhero.createIcon({
      id = v._tid,
      rank = v._rank,
      level = v._level,
      stars = v._stars,
      length = 50
    })
    ui["icon_" .. i] = ed.createNode({
      t = "CCNode",
      base = {
        node = icon.icon
      },
      layout = {
        position = ed.DGccp(42 + 65 * (i - 1), 75)
      }
    }, ui.content)
  end
  ui.guild = ed.createNode({
    t = "Label",
    base = {
      text = summary._guild_name or T(LSTR("CRUSADE.NOT_IN_GUILDS")),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, 23)
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

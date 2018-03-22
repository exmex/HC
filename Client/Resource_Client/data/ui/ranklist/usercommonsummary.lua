local ranklist = ed.ui.ranklist
local base = ed.ui.popwindow
local class = newclass(base.mt)
ranklist.usercommonsummary = class
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
  local summary = data
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
      scaleSize = ed.DGSizeMake(345, 130)
    }
  }, container)
  ui.content = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ed.DGccp(0, -185)
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
  ui.guild = ed.createNode({
    t = "Label",
    base = {
      text = summary._guild_name and summary._guild_name~="" and T(T(LSTR("USERCOMMONSUMMARY.COMEFROM")), summary._guild_name) or T(LSTR("CRUSADE.NOT_IN_GUILDS")),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(30, 222)
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

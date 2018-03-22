local ranklist = ed.ui.ranklist
local base = ed.ui.popwindow
local class = newclass(base.mt)
ranklist.guildsummary = class
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
local function create(index, data)
  local self = base.create("usersummary")
  setmetatable(self, class.mt)
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
      scaleSize = ed.DGSizeMake(400, 287)
    }
  }, container)
  ui.content = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ed.DGccp(0, -22)
    },
    config = {isCascadeOpacity = true}
  }, ui.frame)
  ui.head = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.readequip.createIcon(nil, 60, 1, {
        fres = ed.getDataTable("GuildAvatar")[data._avatar].Picture
      })
    },
    layout = {
      position = ed.DGccp(70, 255)
    }
  }, ui.content)
  ui.name = ed.createNode({
    t = "Label",
    base = {
      text = data._name,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(130, 255)
    }
  }, ui.content)
  ui.rankTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("GUILDSUMMARY.RANK")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 195)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.rank = ed.createNode({
    t = "Label",
    base = {
      text = tostring(index),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.rankTitle, 10)
    }
  }, ui.content)
  ui.managerTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("GUILDSUMMARY.CHAIRMAN")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 150)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.managerName = ed.createNode({
    t = "Label",
    base = {
      text = data._president._name,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.managerTitle, 10)
    }
  }, ui.content)
  ui.memberTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("GUILDSUMMARY.MEMBERCOUNT")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 105)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.memberAmount = ed.createNode({
    t = "Label",
    base = {
      text = data._member_cnt,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.memberTitle, 10)
    }
  }, ui.content)
  ui.sloganTitle = ed.createNode({
    t = "Label",
    base = {
      text = T(LSTR("GUILDSUMMARY.GUILDDECLARATION")),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 60)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.slogan = ed.createNode({
    t = "Label",
    base = {
      text = data._slogan == "" and T(LSTR("GUILDSUMMARY.NO")) or data._slogan,
      size = 18
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccpAdd(ed.getRightSidePos(ui.sloganTitle), ccp(9, 10))
    },
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCVerticalTextAlignmentTop,
      dimensions = ed.DGSizeMake(200, 0)
    }
  }, ui.content)
  local height = (ui.slogan:getContentSize().height - 18) * 1.28
  ui.frame:setContentSize(ed.DGSizeMake(400, 287 + height))
  ui.content:setPosition(ed.DGccp(0, -22 + height))
  self:registerTouchHandler()
  self:show()
  return self
end
class.create = create

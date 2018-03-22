local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.announcement = class
local board_width = 330
local getAnnouncementAmount = function(self)
  local list = self.announcements
  return #list
end
class.getAnnouncementAmount=getAnnouncementAmount

local getListHeight = function(self)
  local amount = self:getAnnouncementAmount()
  local height = 200 * amount
  return height
end
class.getListHeight = getListHeight

local function create(param)
  local self = base.create("announcement")
  setmetatable(self, class.mt)
 -- param = param or {}
 -- self.callback = param.callback
  local mainLayer = self.mainLayer
  local container = self.container
  local mailContainer = CCLayer:create()
  self.mailContainer = mailContainer
  container:addChild(mailContainer)
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(mailContainer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/mailbox/mailbox_frame.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  readnode = ed.readnode.create(self.ui.frame, ui)
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(395, 420)
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
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/mailbox/mailbox_title_bg.png"
      },
      layout = {
        position = ccp(200, 410)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "title",
        text = T(LSTR("ANNOUNCEMENT.ANNOUNCEMENT")),
        fontinfo = "ui_normal_button",
		size = 26
      },
      layout = {
        position = ccp(200, 410)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    }
  }
  readnode:addNode(ui_info)
  self:createListLayer()
	local jsonData=param.data
	if jsonData~=nil then
		local length=#jsonData.announcementConfig
		for i=1,length do
			LegendLog("create mail before is "..i)
			self:createMail(i,jsonData.announcementConfig[i])
			LegendLog("create mail after is "..i)
		end
	else
		LegendLog("jsonData is null--------------error");
	end		
	 self:registerTouchHandler()
	self.draglist:initListHeight(self:getListHeight())
  return self
end
class.create = create

local registerTouchHandler = function(self)
  local ui = self.ui
  local function destroy()
    self:destroy({
      callback = self.callback,
      skipAnim = true
    })
  end
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      destroy()
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_layer_touch",
    clickHandler = function()
      destroy()
    end,
    force = true
  })
end
class.registerTouchHandler = registerTouchHandler

local createListLayer = function(self)
  local info = {
    cliprect = CCRectMake(20, 20, 360, 370),
    rect = CCRectMake(30, 20, 340, 370),
    container = self.ui.frame,
    priority = self.mainTouchPriority - 5,
    upShade = "UI/alpha/HVGA/mailbox/mailbox_mask_up.png",
    downShade = "UI/alpha/HVGA/mailbox/mailbox_mask_up.png",
    bar = {
      bglen = 345,
      bgpos = ccp(20, 205)
    },
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressIn(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelClickIn()
  }
  self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer

local getMailPos = function(self, index)
  local ox, oy = 200, 290
  local dy = 200
  return ccp(ox, oy - dy * (index - 1))
end
class.getMailPos = getMailPos

local function createMail(self, index,dataInfo)
  local ui = {}
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(340, 180))
  local pos = self:getMailPos(index)
  board:setPosition(pos)
  ui.board = board
  self.draglist:addItem(board)
  --local info = self:getMailAt(index)
  local readnode = ed.readnode.create(board, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/mailbox/mailbox_maillist_unread_bg.png",
		capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
	mediate = true,
	anchor = ccp(0.5, 0.5)
	},
      config = {
		scaleSize = CCSizeMake(340, 180)
		}
    }
  }
  readnode:addNode(ui_info)


  local contentContainer = CCLayer:create()
  contentContainer:setClipRect(CCRectMake(0, 0, board_width, 180))
  board:addChild(contentContainer, 5)
  ui.contentContainer = contentContainer
  readnode = ed.readnode.create(contentContainer, ui)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = dataInfo.Title,
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(165, 160)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "conetntmsg",
        text = dataInfo.Msg,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(10, 75)
      },
      config = {
        color = ccc3(67, 59, 56),	
       -- dimension = CCSizeMake(320, 0),
        -- horizontalAlignment = kCCTextAlignmentLeft,
		--verticalAlignment = kCCVerticalTextAlignmentTop
		
		 dimension = CCSizeMake(320, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        verticalAlignment = kCCVerticalTextAlignmentTop
      }
    },
	--[[
    {
      t = "Label",
      base = {
        name = "from",
        text = info.from,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {array = ui, name = "from_title"}
      },
      config = {
        color = ccc3(138, 56, 1)
      }
    },
	
    {
      t = "Label",
      base = {
        name = "date",
        text = info.date,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(95, 15)
      },
      config = {
        color = ccc3(157, 117, 89)
      }
    }
	--]]
  }
  readnode:addNode(ui_info)
--[[
  if ui.name:getContentSize().width > 200 then
	  ui.name:setScale(200 / ui.name:getContentSize().width)
  end
  if ui.from:getContentSize().width > 180 then
     ui.from:setScale(180 / ui.from:getContentSize().width)
  end
  if info.iconid then
    local icon = ed.readequip.createIcon(info.iconid)
    ui.icon = icon
    icon:setPosition(ccp(45, 46))
    contentContainer:addChild(icon)
  elseif info.iconres then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "icon_frame",
          res = "UI/alpha/HVGA/gocha.png"
        },
        layout = {
          position = ccp(45, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "icon",
          res = info.iconres
        },
        layout = {
          position = ccp(45, 47)
        },
        config = {}
      }
    }
    readnode:addNode(ui_info)
  end
--]]
	if self.announcements==nil then
		self.announcements={}
	end
  self.announcements[index] = ui
  self.announcements[index].data = dataInfo

end
class.createMail = createMail


local function doPressIn(self)
  local function handler(x, y)
	--[[
    local mails = self.mails or {}
    for i = 1, #mails do
      local m = mails[i]
      local board = m.board
      local cc = m.contentContainer
      if ed.containsPoint(board, x, y) then
        board:setScale(0.95)
        cc:setClipRect(CCRectMake(0, 0, board_width * 0.95, 90.25))
        return i
      end
    end
	--]]
  end
  return handler
end
class.doPressIn = doPressIn
local function cancelPressIn(self)
  local function handler(x, y, id)
	--[[
    local m = self.mails[id]
    local board = m.board
    local cc = m.contentContainer
    cc:setClipRect(CCRectMake(0, 0, board_width, 95))
    board:setScale(1)
	--]]
  end
  return handler
end
class.cancelPressIn = cancelPressIn

local function doClickIn(self)
  local function handler(x, y, id)
	--[[
    local m = self.mails[id]
    local board = m.board
    board:setScale(1)
    local cc = m.contentContainer
    cc:setClipRect(CCRectMake(0, 0, board_width, 95))
    if ed.containsPoint(board, x, y) then
      self:doReadMail(id)
    end
	--]]
  end
  return handler
end
class.doClickIn = doClickIn
local function cancelClickIn(self)
  local function handler(x, y, id)
	--[[
    local m = self.mails[id]
    local board = m.board
    local cc = m.contentContainer
    cc:setClipRect(CCRectMake(0, 0, board_width, 95))
    board:setScale(1)
	--]]
  end
  return handler
end
class.cancelClickIn = cancelClickIn
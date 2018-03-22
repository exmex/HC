local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.mailbox = class
local mail = ed.ui.mailcontent
local board_width = 330
local getMailAmount = function(self)
	local list = self.mailList
	return #list
end
class.getMailAmount = getMailAmount
local formatMailData = function(self, data)
	local expireTime = data._expire_time
	local nt = ed.getServerTime()
	if expireTime < nt then
		return "expire"
	end
	local id = data._id
	local status = data._status
	local unread = status == "unread" or status == 0
	status = unread and "unread" or "read"
	local date = data._mail_time
	date = ed.getYMDTime(ed.time2China(date))
	local from, name
	local content = data._content
	local money = data._money or 0
	local diamond = data._diamonds or 0
	local skillPoint = data._skill_point or 0
	local crusadeMoney = ed.getMailPoint(data, "crusadepoint")
	local pvpMoney = ed.getMailPoint(data, "arenapoint")
	local guildMoney = ed.getMailPoint(data, "guildpoint")
	local items = data._items or {}
	local temp = {}
	for i = 1, #items do
		local it = items[i]
		local eid = ed.bits(it, 0, 10)
		local eAmount = ed.bits(it, 10, 11)
		local hadCount = ed.player:getEquipAmount(eid)
		local row = ed.getDataTable("equip")[eid]
		if row ~= nil then
			local maxCount = row["Max Amount"]
			local maxCountInvisible = row["Max Amount Invisible"]
			if not maxCountInvisible or not (hadCount >= maxCount) then
				table.insert(temp, {id = eid, amount = eAmount})
			end
		else
			LegendLog("Item Not Found in equip.lua, ID: " .. eid);
		end
	end
	items = temp
	local attached
	if money + diamond + crusadeMoney + pvpMoney + guildMoney + skillPoint > 0 or #items > 0 then
		attached = true
	end
	local iconbg = "UI/alpha/HVGA/task_icon_bg.png"
	local iconres = "UI/alpha/HVGA/mailbox/mailbox_maillist_letter_icon.png"
	if status == "read" then
		iconres = "UI/alpha/HVGA/mailbox/mailbox_maillist_letter_open_icon.png"
	end
	local iconid
	if items[1] then
		local iid = items[1].id
		iconbg = ed.readequip.getShapeFrameRes(iid)
		iconid = iid
	end
	if content._plain_mail then
		local pm = content._plain_mail
		from = pm._from
		name = pm._title
		content = pm._content
	elseif content._format_mail then
		local fm = content._format_mail
		local mid = fm._mail_cfg_id
		local param = fm._params
		name, from = ed.mailutil.getMailText(mid, param)
		--为防止发送了不存在的邮件进行兼容
		if name==nil then
			mid=0
			name, from = ed.mailutil.getMailText(mid, param)
		end
		content = {
		t = "format_mail",
		mid = mid,
		param = param
		}
	end
	return {
	id = id,
	attached = attached,
	status = status,
	date = date,
	from = from,
	name = name,
	content = content,
	money = money,
	diamond = diamond,
	skillPoint = skillPoint,
	crusadeMoney = crusadeMoney,
	pvpMoney = pvpMoney,
	guildMoney = guildMoney,
	items = items,
	iconres = iconres,
	iconid = iconid,
	iconbg = iconbg
	}
end
class.formatMailData = formatMailData
local getMailAt = function(self, index)
	return self.mailList[index]
end
class.getMailAt = getMailAt
local beginLoadMailList = function(self)
	self:getScene():registerUpdateHandler("asyncLoadMail", self:asyncLoadMail())
end
class.beginLoadMailList = beginLoadMailList
local endLoadMailList = function(self)
	self:getScene():removeUpdateHandler("asyncLoadMail")
end
class.endLoadMailList = endLoadMailList
local function doPressIn(self)
	local function handler(x, y)
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
	end
	return handler
end
class.doPressIn = doPressIn
local function cancelPressIn(self)
	local function handler(x, y, id)
		local m = self.mails[id]
		local board = m.board
		local cc = m.contentContainer
		cc:setClipRect(CCRectMake(0, 0, board_width, 95))
		board:setScale(1)
	end
	return handler
end
class.cancelPressIn = cancelPressIn
local function doClickIn(self)
	local function handler(x, y, id)
		local m = self.mails[id]
		local board = m.board
		board:setScale(1)
		local cc = m.contentContainer
		cc:setClipRect(CCRectMake(0, 0, board_width, 95))
		if ed.containsPoint(board, x, y) then
			self:doReadMail(id)
		end
	end
	return handler
end
class.doClickIn = doClickIn
local function cancelClickIn(self)
	local function handler(x, y, id)
		local m = self.mails[id]
		local board = m.board
		local cc = m.contentContainer
		cc:setClipRect(CCRectMake(0, 0, board_width, 95))
		board:setScale(1)
	end
	return handler
end
class.cancelClickIn = cancelClickIn
local function doReadMail(self, id)
	local m = self.mails[id]
	local board = m.board
	local data = m.data
	local attach = {}
	if data.money > 0 then
		table.insert(attach, {
		type = "Gold",
		amount = data.money
		})
	end
	if 0 < data.diamond then
		table.insert(attach, {
		type = "Diamond",
		amount = data.diamond
		})
	end
	if 0 < data.crusadeMoney then
		table.insert(attach, {
		type = "CrusadeMoney",
		amount = data.crusadeMoney
		})
	end
	if 0 < data.pvpMoney then
		table.insert(attach, {
		type = "PvpMoney",
		amount = data.pvpMoney
		})
	end
	if 0 < data.guildMoney then
		table.insert(attach, {
		type = "GuildMoney",
		amount = data.guildMoney
		})
	end
	if 0 < data.skillPoint then
		table.insert(attach, {
		type = "SkillPoint",
		amount = data.skillPoint
		})
	end
	for i = 1, #data.items do
		table.insert(attach, {
		type = "Item",
		id = data.items[i].id,
		amount = data.items[i].amount
		})
	end
	local mailLayer = mail.create({
	id = data.id,
	status = data.status,
	attached = data.attached,
	content = {
	title = data.name,
	body = data.content,
	from = data.from,
	attach = attach
	},
	callback = function()
		xpcall(function()
			self:refreshMailAt(id)
			end, EDDebug)
		end
		})
		self.container:addChild(mailLayer.mainLayer, 100)
end
class.doReadMail = doReadMail
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
local initMailData = function(self, isCheck)
	if isCheck then
		local needSync = ed.player:checkSyncMailData()
		if needSync then
			function ed.netreply.getMail()
				xpcall(function()
					self:initMailData()
					end, EDDebug)
				end
				local msg = ed.upmsg.get_maillist()
				ed.send(msg, "get_maillist")
				return
			end
		end
		local data = ed.player:getMailData()
		self:orderMailData(data or {})
		self:beginLoadMailList()
end
class.initMailData = initMailData
local orderMailData = function(self, data)
	local list = {}
	self.mailList = {}
	data = data or {}
	for i = 1, #data do
		local md = self:formatMailData(data[i])
		list[i] = md
	end
	for i = 1, #list do
		if list[i] ~= "expire" then
			table.insert(self.mailList, list[i])
		end
	end
	local ml = self.mailList
	local function moveup(j)
		local i = j - 1
		local temp = ml[j]
		ml[j] = ml[i]
		ml[i] = temp
	end
	for i = 1, #ml do
		for j = i, 2, -1 do
			local pre = ml[j - 1]
			local c = ml[j]
			if c.status == "unread" and pre.status ~= "unread" then
				moveup(j)
			elseif c.status == pre.status and c.id > pre.id then
				moveup(j)
			end
		end
	end
end
class.orderMailData = orderMailData
local asyncLoadMail = function(self)
	local index = 1
	self.draglist:initListHeight(self:getListHeight())
	local amount = self:getMailAmount()
	self.mails = {}
	local function handler()
		if tolua.isnull(self.mainLayer) then
			self:endLoadMailList()
		end
		if index <= amount then
			self:createMail(index)
			index = index + 1
		else
			self:endLoadMailList()
		end
	end
	return handler
end
class.asyncLoadMail = asyncLoadMail
local getListHeight = function(self)
	local amount = self:getMailAmount()
	local height = 100 * amount
	return height
end
class.getListHeight = getListHeight
local getMailPos = function(self, index)
	local ox, oy = 200, 335
	local dy = 100
	return ccp(ox, oy - dy * (index - 1))
end
class.getMailPos = getMailPos
local refreshMailAt = function(self, index)
	local mail = self.mails[index]
	local data = mail.data
	if data.attached then
		if not tolua.isnull(mail.board) then
			mail.board:removeFromParentAndCleanup(true)
		end
		table.remove(self.mails, index)
		for i = 1, #self.mailList do
			if self.mailList[i].id == data.id then
				table.remove(self.mailList, i)
				break
			end
		end
		self:refreshMailList()
	else
		local preStatus = data.status
		data.status = "read"
		if preStatus == "unread" then
			mail.bg:removeFromParentAndCleanup(true)
			local board = mail.board
			local ui_info = {
			{
			t = "Sprite",
			base = {
			name = "bg",
			res = data.status == "unread" and "UI/alpha/HVGA/mailbox/mailbox_maillist_unread_bg.png" or "UI/alpha/HVGA/mailbox/mailbox_maillist_read_bg.png"
			},
			layout = {mediate = true},
			config = {}
			}
			}
			local readnode = ed.readnode.create(board, mail)
			readnode:addNode(ui_info)
			local icon = mail.icon
			if not tolua.isnull(icon) then
				icon:removeFromParentAndCleanup(true)
				readnode = ed.readnode.create(mail.contentContainer, mail)
				ui_info = {
				{
				t = "Sprite",
				base = {
				name = "icon",
				res = "UI/alpha/HVGA/mailbox/mailbox_maillist_letter_open_icon.png"
				},
				layout = {
				position = ccp(45, 47)
				},
				config = {}
				}
				}
				readnode:addNode(ui_info)
			end
		end
		self:refreshMailList()
	end
end
class.refreshMailAt = refreshMailAt
local orderMail = function(self)
	local ml = self.mails
	local function moveup(j)
		local i = j - 1
		local temp = ml[j]
		ml[j] = ml[i]
		ml[i] = temp
	end
	for i = 1, #ml do
		for j = i, 2, -1 do
			local pre = ml[j - 1].data
			local c = ml[j].data
			if c.status == "unread" and pre.status ~= "unread" then
				moveup(j)
			elseif c.status == pre.status and c.date > pre.date then
				moveup(j)
			end
		end
	end
end
class.orderMail = orderMail
local refreshMailList = function(self)
	local ml = self.mails or {}
	self:orderMail()
	for i = 1, #ml do
		local pos = self:getMailPos(i)
		if not tolua.isnull(ml[i].board) then
			ml[i].board:setPosition(pos)
		end
	end
	self.draglist:initListHeight(self:getListHeight())
end
class.refreshMailList = refreshMailList
local function createMail(self, index)
	if index > self:getMailAmount() then
		return
	end
	local ui = {}
	local board = CCSprite:create()
	board:setContentSize(CCSizeMake(340, 90))
	local pos = self:getMailPos(index)
	board:setPosition(pos)
	ui.board = board
	self.draglist:addItem(board)
	local info = self:getMailAt(index)
	local readnode = ed.readnode.create(board, ui)
	local ui_info = {
	{
	t = "Sprite",
	base = {
	name = "bg",
	res = info.status == "unread" and "UI/alpha/HVGA/mailbox/mailbox_maillist_unread_bg.png" or "UI/alpha/HVGA/mailbox/mailbox_maillist_read_bg.png"
	},
	layout = {mediate = true},
	config = {}
	}
	}
	readnode:addNode(ui_info)
	local contentContainer = CCLayer:create()
	contentContainer:setClipRect(CCRectMake(0, 0, board_width, 95))
	board:addChild(contentContainer, 5)
	ui.contentContainer = contentContainer
	readnode = ed.readnode.create(contentContainer, ui)
	ui_info = {
	{
	t = "Sprite",
	base = {
	name = "icon_bg",
	res = info.iconbg
	},
	layout = {
	position = ccp(45, 45)
	},
	config = {}
	},
	{
	t = "Label",
	base = {
	name = "name",
	text = info.name,
	size = 20
	},
	layout = {
	anchor = ccp(0, 0.5),
	position = ccp(95, 70)
	},
	config = {
	color = ccc3(67, 59, 56)
	}
	},
	{
	t = "Label",
	base = {
	name = "from_title",
	text = T(LSTR("MAILBOX.FROM_")).." ",
	size = 18
	},
	layout = {
	anchor = ccp(0, 0.5),
	position = ccp(95, 40)
	},
	config = {
	color = ccc3(67, 59, 56)
	}
	},
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
	}
	readnode:addNode(ui_info)
	if ui.name~=nil and ui.name:getContentSize().width > 200 then
		ui.name:setScale(200 / ui.name:getContentSize().width)
	end
	if ui.from~=nil and ui.from:getContentSize().width > 180 then
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
	self.mails[index] = ui
	self.mails[index].data = info
end
class.createMail = createMail
local function create(param)
	local self = base.create("mailbox")
	setmetatable(self, class.mt)
	param = param or {}
	self.callback = param.callback
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
	text = T(LSTR("MAILBOX.MAILBOX")),
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
	self:registerTouchHandler()
	self:show({
	callback = function()
		self:initMailData(true)
	end,
	skipAnim = true
	})
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
		
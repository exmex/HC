local class = newclass({__index = _G})
ed.mailutil = class
setfenv(1, class)
local widgets = {
"v_number",
"v_string",
"v_icon",
"v_self_hero_avatar",
"v_button_excavate_history"
}
local keyString = {"br"}
function initNumber(param)
	if not param then
		return
	end
	local v = param._value or ""
	local node = ed.createttf(v, 16)
	ed.setLabelColor(node, ccc3(146, 91, 51))
	return node
end
function initString(param)
	if not param then
		return
	end
	local t = param._type
	local v = param._value or ""
	if t == "hero_name" then
		v = tonumber(v)
		v = ed.getDataTable("Unit")[v]["Display Name"]
	end
	local node = ed.createttf(v, 16)
	ed.setLabelColor(node, ccc3(146, 91, 51))
	return node
end
function initIcon(param)
	if not param then
		return
	end
	local v = param._value or ""
	local t = param._type
	if t == "money" then
		local res = {
		gold = "UI/alpha/HVGA/goldicon_small.png",
		diamond = "UI/alpha/HVGA/shop_token_icon.png",
		arenapoint = "UI/alpha/HVGA/money_dragonscale_big.png",
		crusadepoint = "UI/alpha/HVGA/money_arenatoken_big.png",
		guildpoint = "UI/alpha/HVGA/money_guildtoken_big.png"
		}
		local icon = ed.createSprite(res[v])
		icon:setScale(30 / icon:getContentSize().width)
		return icon
	elseif t == "item" then
		local id = tonumber(v)
		local icon = ed.readequip.createIcon(id)
		icon:setScale(30 / icon:getContentSize().width)
		return icon
	elseif t == "mine" then
		local id = tonumber(v)
		local et = ed.getDataTable("ExcavateTreasure")[id]["Produce Type"]
		local res = {
		Gold = "UI/alpha/HVGA/chat/chat_icon_treasure_gold.png",
		Diamond = "UI/alpha/HVGA/chat/chat_icon_treasure_diamond.png",
		Item = "UI/alpha/HVGA/chat/chat_icon_treasure_exp.png"
		}
		local icon = ed.creayeSprite(res[et])
		icon:setScale(30 / icon:getContentSize().width)
		return icon
	elseif t == "self_hero" then
		local id = tonumber(v)
		local icon = ed.readhero.createIconByID(id, {state = "idle"}).icon
		icon:setScale(50 / icon:getContentSize().width)
		return icon
	end
end
function initAvatar(param)
	if not param then
		return
	end
	local id = param._value or 1
	local icon = ed.getHeroIconByID({
	id = tonumber(id),
	vip = ed.player:getvip() > 0
	})
	return icon
end
function initExcavHistoryButton(param)
	if not param then
		return
	end
	local id = param._value
	local ui = {}
	local readnode = ed.readnode.create(nil, ui)
	local ui_info = {
	{
	t = "Scale9Sprite",
	base = {
	name = "button",
	res = "UI/alpha/HVGA/sell_number_button.png",
	capInsets = ed.DGRectMake(20, 20, 24, 24),
	feral = true,
	feralArray = ui
	},
	layout = {},
	config = {
	scaleSize = ed.DGSizeMake(150, 68)
	}
	},
	{
	t = "Scale9Sprite",
	base = {
	name = "press",
	res = "UI/alpha/HVGA/sell_number_button_down.png",
	capInsets = ed.DGRectMake(20, 20, 24, 24),
	parent = "button"
	},
	layout = {
	anchor = ccp(0, 0),
	position = ccp(0, 0)
	},
	config = {
	scaleSize = ed.DGSizeMake(150, 68),
	visible = false
	}
	},
	{
	t = "Label",
	base = {
	name = "label",
	text = LSTR("MAP.VIEW_DETAILS"),
	size = 20,
	parent = "button"
	},
	layout = {
	position = ed.DGccp(75, 34)
	},
	config = {
	color = ccc3(234, 225, 205)
	}
	}
	}
	readnode:addNode(ui_info)
	local isPress, px, py
	local function callback(event, x, y)
		if event == "began" then
			px, py = x, y
			if ed.containsPoint(ui.button, x, y) then
				ui.press:setVisible(true)
				isPress = true
			end
		elseif event == "moved" then
			local dx = px - x
			local dy = py - y
			if dx * dx + dy * dy > 25 then
				isPress = nil
				ui.press:setVisible(false)
			end
		elseif event == "ended" then
			if isPress then
				ui.press:setVisible(false)
				if ed.containsPoint(ui.button, x, y) then
					ed.ui.excavatehistory.pop({priority = -200})
				end
			end
			isPress = nil
		end
	end
	return ui.button, callback
end
initHandler = {
v_number = initNumber,
v_string = initString,
v_icon = initIcon,
v_self_hero_avatar = initAvatar,
v_button_excavate_history = initExcavHistoryButton
}
function getMailText(mid, params)
	local row = ed.getDataTable("Maillist")[mid]
	local from = nil
	local name = nil
	if row~=nil then
		if row.Sender~=nil then
			from=row.Sender
		end
		
		if row.Sender~=nil then
			name=row.Title
		end
	else
		LegendLog("[mainutil.lua|getMailText] DataTable#Maillist,mid:"..tostring(mid).."is nil!")
	end
	return name, from
end
function create(mid, params)
	local row = ed.getDataTable("Maillist")[mid]
	local body, touchHandlers = nil
	if row~=nil then
		body, touchHandlers=getBody(row.Content, params)
	end
	return body, touchHandlers
end
function getWidget(config, params)
	local function getParam(index)
		for i, v in ipairs(params) do
			if v._idx == index then
				return v
			end
		end
	end
	local t = config.key
	local index = tonumber(config.index)
	local param = getParam(index)
	return initHandler[t](param)
end
function getBody(text, params)
	local touchHandlers = {}
	local itemList = split(text)
	local vui = {}
	for i, v in ipairs(itemList) do
		local hui = {}
		for li, lv in ipairs(v) do
			if lv.t == "Label" then
				table.insert(hui, {
				t = "Label",
				base = {
				text = lv.text,
				size = 16
				},
				layout = {},
				config = {
				color = ccc3(67, 59, 56)
				}
				})
			elseif lv.t == "widget" then
				local button, callback = getWidget(lv, params)
				if not tolua.isnull(button) then
					if ed.isElementInTable(lv.key, {
						"v_button_excavate_history"
						}) and callback then
						table.insert(touchHandlers, callback)
					end
					table.insert(hui, {
					t = "CCNode",
					base = {node = button},
					layout = {}
					})
				end
			end
		end
		local conf = {
		t = "HorizontalNode",
		base = {name = "line"},
		layout = {},
		ui = hui
		}
		table.insert(vui, conf)
	end
	local conf = {
	t = "VerticalNode",
	base = {name = "body", offset = 5},
	layout = {},
	ui = vui
	}
	local body = ed.readnode.getFeralNode(conf)
	return body, touchHandlers
end
function analyzeBody(text, width)
	local ui, handlers = ed.mailanalyze.analyze(text)
	local param = {
	t = "ChaosNode",
	base = {name = "node", width = width},
	layout = {},
	config = {},
	ui = ui
	}
	local node = ed.readnode.getFeralNode(param)
	return node, handlers
end
function split(text)
	local list = {}
	for s in string.gmatch(text, "[^#]*") do
		if s ~= "" then
			table.insert(list, s)
		end
	end
	local itemList = {}
	local index = 1
	for i, v in ipairs(list) do
		if v == "br" then
			index = index + 1
		end
		itemList[index] = itemList[index] or {}
		if ed.isElementInTable(v, widgets) then
			table.insert(itemList[index], {
			t = "widget",
			index = list[i - 1],
			key = v
			})
		elseif not ed.isElementInTable(list[i + 1] or "", widgets) and not ed.isElementInTable(v, keyString) then
			table.insert(itemList[index], {t = "Label", text = v})
		end
	end
	return itemList
end

local base = ed.ui.framework
local class = newclass(base.mt)
ed.ui.package = class
local res = ed.ui.packageres
local lsr = ed.ui.packagelsr.create()
local spineContainer=nil
local armature=nil
local richLabel=nil
local function downSell(self, result, amount)
	if result then
		lsr:report("sellPropSuccess")
		local ca = self:consumeAmount(amount)
		if not self.sellLayer:checknull() then
			self.sellLayer:destroy()
		end
	else
		lsr:report("sellPropFailed")
	end
end
class.downSell = downSell
local function downFragmentCompose(self)
	local function handler(result, amount)
		if not self then
			return
		end
		if result then
			lsr:report("composeFragmentSuccess")
			local makeId = self.equips[self.selectid].makeId
			self.composeLayer:destroy()
			self:consumeAmount(amount)
			local id = self.selectid
			if self.equips and self.equips[id] then
				if not ed.readequip.isFragmentEnough(id) and self.equips[id].tag then
					self.equips[id].tag:setVisible(false)
				end
				if ed.itemType(self.equips[id].makeId or 0) == "hero" and ed.player.heroes[self.equips[id].makeId] and self.equips[id].tag then
					self.equips[id].tag:setVisible(false)
				end
			end
		else
			lsr:report("composeFragmentFailed")
		end
	end
	return handler
end
class.downFragmentCompose = downFragmentCompose
local consumeAmount = function(self, amount)
	self:getListData()
	local id = self.selectid
	if self.equipLayer == nil then
		return
	end
	local currentAmount = self.equipLayer:refreshAmount()
	self.equips[id].amount = currentAmount
	if currentAmount <= 0 then
		self.equipLayer:popout()
		self.equipLayer = nil
		if not tolua.isnull(self.equips[id].bg) then
			self.equips[id].bg:removeFromParentAndCleanup(true)
		end
		self.equips[id] = nil
	elseif currentAmount > 1 then
		ed.refreshNumberNode(self.equips[id].amountLabel, currentAmount)
	else
		if self.equips[id].amountLabel and self.equips[id].amountLabel.node and not tolua.isnull(self.equips[id].amountLabel.node) then
			self.equips[id].amountLabel.node:setVisible(false)
		end
	end
	if not self.clid then
		self.clid = "all"
	end
	self:createList(self.bothList[self.identity][self.clid], true)
	return currentAmount
end
class.consumeAmount = consumeAmount
local function getSellHandler(self)
	local function handler()
		lsr:report("clickSellButton")
		local price = ed.getDataTable("equip")[self.selectid]["Sell Price"]
		if price > 0 then
			if self.sellLayer and not self.sellLayer:checknull() then
				self.sellLayer:destroy({skipAnim = true})
			end
			self.sellLayer = ed.ui.equipboard.init("ofsell", {
				id = self.selectid
			})
			if self.sellLayer then
				self.scene:addChild(self.sellLayer.mainLayer, 120)
			end
		else
			ed.showToast(T(LSTR("PACKAGE.NO_BUSINESSMAN_IS_WILLING_TO_BUY_SUCH_ITEMS")))
		end
	end
	return handler
end
class.getSellHandler = getSellHandler
local function getUseHandler(self)
	local function handler()
		lsr:report("clickUseProp")
		local exp = ed.getDataTable("equip")[self.selectid].Exp
		if exp and exp > 0 and self.equips[self.pressId] then
			local amount = self.equips[self.pressId].amount
			self.heroList = ed.ui.eatexplist.create(self.selectid, amount)
			function self.heroList.consumeAmount(amount)
				self:consumeAmount(amount)
			end
			self.scene:addChild(self.heroList.mainLayer, 120)
		end
	end
	return handler
end
class.getUseHandler = getUseHandler
local getComposeHandler = function(self)
	local function handler()
		local composeLayer = ed.ui.fragmentcompose.create(self.selectid)
		composeLayer.package = self
		self.scene:addChild(composeLayer.mainLayer, 120)
		self.composeLayer = composeLayer
		function self.composeLayer.destroyHandler()
			xpcall(function()
				if self.equipLayer then
					self.equipLayer:refreshAmount()
				end
			end, EDDebug)
		end
	end
	return handler
end
class.getComposeHandler = getComposeHandler
local function getCheckHandler(self)
	local function handler()
		lsr:report("clickCheckDetail")
		local detailLayer = ed.ui.equipdetail.create(self.selectid)
		self.scene:addChild(detailLayer.mainLayer, 120)
		self.detailLayer = detailLayer
	end
	return handler
end
class.getCheckHandler = getCheckHandler
local doPressInList = function(self)
	local function handler(x, y)
		for k, v in pairs(self.equips or {}) do
			if ed.containsPoint(v.bg, x, y) and v.bg:isVisible() then
				v.bg:setScale(0.95)
				return v.id
			else
			end
		end
	end
	return handler
end
class.doPressInList = doPressInList
local cancelPressInList = function(self)
	local function handler(x, y, id)
		if self.equips[id] then
			self.equips[id].bg:setScale(1)
		end
	end
	return handler
end
class.cancelPressInList = cancelPressInList
local function doClickInList(self)
	local function handler(x, y, id)
		if ed.containsPoint(self.equips[id].bg, x, y) then
			if self.equips[id].id == self.composeTutorialID then
				ed.endTeach("composeFragment")
			end
			lsr:report("clickProp")
			self.equips[id].bg:setScale(1)
			self.pressId = id
			self:doSelectEquip(self.equips[id].id)
		else
		end
	end
	return handler
end
class.doClickInList = doClickInList
local cancelClickInList = function(self)
	local function handler(x, y, id)
		self.equips[id].bg:setScale(1)
	end
	return handler
end
class.cancelClickInList = cancelClickInList
local doSelectEquip = function(self, id)
	self.selectid = id
	if not self.equipLayer then
		self.equipLayer = ed.ui.equipboard.init("ofpackage", {
			id = id,
			doSell = self:getSellHandler(),
			doUse = self:getUseHandler(),
			doCheck = self:getCheckHandler(),
			doCompose = self:getComposeHandler()
		})
		self.mainLayer:addChild(self.equipLayer.mainLayer)
		self.equipLayer:popin()
	else
		self.equipLayer:refresh(id)
	end
end
class.doSelectEquip = doSelectEquip
local function doChangeList(self, name)
	local normalColor = ccc3(255, 255, 255)
	local pressColor = ccc3(255, 255, 255)
	local ui = self.ui
	self.draglist:reset()
	lsr:report("clickChangeList")
	self.clid = name
	local info = res.list_key
	for k, v in pairs(info) do
		local key = v.key
		local normal = ui[key .. "_normal"]
		local press = ui[key .. "_press"]
		local label = ui[key .. "_label"]
		if normal ~= nil then
			if key == name then
				normal:setVisible(false)
				press:setVisible(true)
				ed.setLabelColor(label, pressColor)
			else
				normal:setVisible(true)
				press:setVisible(false)
				ed.setLabelColor(label, normalColor)
			end
		end
	end
	self:createList(self.bothList[self.identity][name])
end
class.doChangeList = doChangeList
local doClickHandbook = function(self)
	local draglist = self.draglist
	local listLayer = (draglist or {}).listLayer
	if not tolua.isnull(listLayer) then
		listLayer:stopAllActions()
	end
	local scene = ed.ui.handbook.create()
	ed.pushScene(scene)
end
class.doClickHandbook = doClickHandbook
local createList = function(self, list, notreset)
	ed.breakTeach("composeFragment")
	local dy = self:refreshList(list)
	local listHeight = dy * math.floor((#list - 1) / 4) + 85
	if not notreset then
		self.draglist:initListHeight(listHeight)
	else
		self.draglist:initListHeight(listHeight, false)
	end
end
class.createList = createList
local refreshList = function(self, list)
	for k, v in pairs(self.equips or {}) do
		if not tolua.isnull(v.bg) then
			v.bg:setVisible(false)
		end
	end
	-- 背包列表位置 Ray --
	local beginX, beginY = 393, 343
	local dx, dy = 75, 80
	for i = 1, #(list or {}) do
		local v = list[i]
		local px = beginX + dx * ((i - 1) % 4)
		local py = beginY - dy * math.floor((i - 1) / 4)
		if self.equips[v.id] and (not tolua.isnull(self.equips[v.id].bg)) then
			self.equips[v.id].bg:setPosition(ccp(px, py))
			if v.id == self.composeTutorialID then
				ed.teach("composeFragment", self.equips[v.id].bg, self.mainLayer)
			end
			self.equips[v.id].bg:setVisible(true)
		end
	end
	if self.draglist ~= nil then
		self.draglist:updateItemsVisible(true)
	end
	return dy
end
class.refreshList = refreshList
local loadEquip = function(self, index)
	if index < 1 then
		return
	end
	local list = self.bothList[self.identity].all
	if index > #list then
		return "loadEquipEnd"
	end
	local data = list[index]
	if self.identity == "package" then
		local bg, equip, amountLabel = ed.readequip.createIconWithAmount(data.id)
		self.equips[data.id] = {
			id = data.id,
			bg = bg,
			equip = equip,
			amountLabel = amountLabel,
			amount = data.amount
		}
		self.draglist:addItem(bg)
		self.draglist:setFrameRect(bg, bg:getTextureRect())
		self.draglist:setParentClipNode(bg, self.draglist.listLayer)
	elseif self.identity == "fragment" then
		local bg, equip, amountLabel, tag = ed.readequip.createIconWithTag(data.makeId)
		if not self.composeTutorialID and tag then
			self.composeTutorialID = data.id
		end
		self.equips[data.id] = {
			id = data.id,
			bg = bg,
			equip = equip,
			amountLabel = amountLabel,
			amount = data.amount,
			tag = tag,
			makeId = data.makeId
		}
		self.draglist:addItem(bg)
		self.draglist:setFrameRect(bg, bg:getTextureRect())
		self.draglist:setParentClipNode(bg, self.draglist.listLayer)
	end
end
class.loadEquip = loadEquip
local prepareLoad = function(self)
	self.equips = {}
	self.clid = "all"
end
class.prepareLoad = prepareLoad
local asyncLoadEquips = function(self)
	local index = 1
	local step = "loadEquip"
	self:prepareLoad()
	self:createList(self.bothList[self.identity][self.clid])
	local preid = self.clid
	local function handler()
		if step == "loadEquip" then
			for i = index, index + 3 do
				step = self:loadEquip(index) or "loadEquip"
				index = index + 1
			end
		end
		if step == "loadEquipEnd" then
			self:removeUpdateHandler("asyncLoadEquips")
		end
		if preid ~= self.clid then
			self:createList(self.bothList[self.identity][self.clid])
		else
			self:refreshList(self.bothList[self.identity][self.clid])
		end
		preid = self.clid
	end
	return handler
end
class.asyncLoadEquips = asyncLoadEquips
local createListLayer = function(self)
	local info = {
		cliprect = CCRectMake(0, 35, 800, 355),
		rect = CCRectMake(355, 35, 295, 355),
		container = self.mainLayer,
		zorder = 10,
		-- 背包列表滚动条位置 Ray --
		bar = {
			bglen = 330,
			bgpos = ccp(350, 212)
		},
		priority = 5,
		doClickIn = self:doClickInList(),
		cancelClickIn = self:cancelClickInList(),
		doPressIn = self:doPressInList(),
		cancelPressIn = self:cancelPressInList()
	}
	self.draglist = ed.draglist.create(info)
end
class.createListLayer = createListLayer
local getListData = function(self)
	self.propList, self.fragmentList = ed.readequip.classify()
	self.bothList = {
		package = self.propList,
		fragment = self.fragmentList
	}
end
class.getListData = getListData
local function createListButton(self)
	local ox, oy = 706, 363
	local dy = 60
	local info = res.list_key
	local ui = self.ui
	for i = 1, #info do
		do
			local v = info[i]
			local key = v.key
			if i ~= 1 or not ccc3(250, 200, 0) then
			end
			local ui_info = {
				{
					t = "Sprite",
					base = {
						name = key .. "_normal",
						res = "UI/alpha/HVGA/classbtn.png",
						z = i == 1 and 3 or 1
					},
					layout = {
						position = ccp(ox + 4, oy - dy * (i - 1))
					},
					config = {
						visible = i ~= 1
					}
				},
				{
					t = "Sprite",
					base = {
						name = key .. "_press",
						res = "UI/alpha/HVGA/classbtnselected.png",
						z = 20
					},
					layout = {
						position = ccp(ox, oy - dy * (i - 1))
					},
					config = {
						visible = i == 1
					}
				},
				{
					t = "Label",
					base = {
						name = key .. "_label",
						text = v.name,
						fontinfo = "ui_normal_button",
						size = 20,
						z = 24
					},
					layout = {
						position = ccp(ox + 5, oy - dy * (i - 1))
					},
					config = {
						color = ccc3(255, 255, 255),
						shadow = {
							color = ccc3(42, 31, 22),
							offset = ccp(0, 2)
						}
					}
				}
			}
			local readnode = ed.readnode.create(self.mainLayer, ui)
			readnode:addNode(ui_info)
			local normal = ui[key .. "_normal"]
			local press = ui[key .. "_press"]
			local label = ui[key .. "_label"]
			self:btRegisterButtonClick({
				button = normal,
				press = press,
				key = key .. "_listbutton",
				pressHandler = function()
					press:setVisible(true)
					press:setZOrder(20)
				end,
				cancelPressHandler = function()
					press:setVisible(false)
				end,
				clickHandler = function()
					self:doChangeList(key)
				end
			})
		end
	end
end
class.createListButton = createListButton
local createHandbookButton = function(self)
	local ui = self.ui
	local readnode = ed.readnode.create(self.mainLayer, ui)
	local ui_info = {
		{
			t = "Scale9Sprite",
			base = {
				name = "handbook",
				res = "UI/alpha/HVGA/sell_number_button.png",
				capInsets = CCRectMake(15, 22, 15, 25)
			},
			layout = {
				position = ccp(716, 55)
			},
			config = {
				scaleSize = CCSizeMake(92, 58)
			}
		},
		{
			t = "Scale9Sprite",
			base = {
				name = "handbook_press",
				res = "UI/alpha/HVGA/sell_number_button_down.png",
				capInsets = CCRectMake(15, 22, 15, 25),
				parent = "handbook"
			},
			layout = {
				position = ccp(0, 0),
				anchor = ccp(0, 0)
			},
			config = {
				scaleSize = CCSizeMake(92, 58),
				visible = false
			}
		},
		{
			t = "Sprite",
			base = {
				name = "handbook_icon",
				res = "UI/alpha/HVGA/package_handbook_icon.png",
				parent = "handbook"
			},
			layout = {
				position = ccp(18, 31)
			},
			config = {}
		},
		{
			t = "Label",
			base = {
				name = "handbook_label",
				text = T(LSTR("HERODETAIL.BOOK")),
				fontinfo = "ui_normal_button",
				parent = "handbook"
			},
			layout = {
				position = ccp(50, 29)
			},
			config = {
				ccc3(255, 255, 255)
			}
		}
	}
	if self.identity == "package" then
		readnode:addNode(ui_info)
	end
	self:btRegisterButtonClick({
		button = ui.handbook,
		press = ui.handbook_press,
		key = "hondbook_button",
		clickHandler = function()
			self:doClickHandbook()
		end
	})
end
class.createHandbookButton = createHandbookButton

--测试DragoneBone,Spine,HTMLLable
local function testAnimation(self)
	local mainLayer = self.scene
	spineContainer = SpineContainer:create('spine/MonthCard', 'MonthCardSpine');
	spineContainer:runAnimation(0, 'TheThirdStage', 1);
	local spineNode = tolua.cast(spineContainer, 'CCNode');
	spineNode:setPosition(ccp(600, 100));
	mainLayer:addChild(spineNode);
	spineContainer:registerLuaListener(function(eventName, trackIndex, aniName, loopCount)
		if eventName == "Complete" then
			spineContainer:runAnimation(0, aniName == 'MilkShake' and 'TheThirdStage' or aniName, 1);
		end
	end);
	armature = ArmatureContainer:create('dragonBone/levelUp', 'levelUp', mainLayer);
	local armatureNode = tolua.cast(armature, 'CCNode');
	armatureNode:setPosition(ccp(200, 300));
	armature:registerLuaListener(function(aniEventName, eventName, eventInfo)
		if aniEventName == "AnimationDone" then
			local test = true;
		elseif aniEventName == "FrameEvent" then
			if eventName == "BeforeLevel" then
				local label = CCLabelTTF:create("23", "Helvetica", 28);
				local bone = tolua.cast(eventInfo, 'CCBone');
				armature:changeSkin(bone, label, false);
			elseif eventName == "ResultLevel" then
				local label = CCLabelTTF:create("24", "Helvetica", 30);
				local bone = tolua.cast(eventInfo, 'CCBone');
				armature:changeSkin(bone, label, false);
			end
		end
	end);
	armature:runAnimation('Upgrade', 10);

	local str = CCString:createWithContentsOfFile('html/html.htm');
	local vSize = CCDirector:sharedDirector():getVisibleSize();
	richLabel = CCHTMLLabel:createWithString(str:getCString(), CCSizeMake(vSize.width * 0.8, vSize.height));
	richLabel:setPosition(ccp(vSize.width * 0.5, vSize.height * 0.5));
	richLabel:setAnchorPoint(ccp(0.5, 0.5));
	mainLayer:addChild(richLabel);
	richLabel:registerLuaClickListener(function(id, name, value)
		if id == 1002 then
			richLabel:setVisible(false);
		elseif id == 2000 then
			local str = CCString:createWithContentsOfFile('html/html.htm');
			richLabel:setString(str:getCString());
		end
	end);

	richLabel:registerLuaMovedListener(function(id, name, value, posX, posY, deltaX, deltaY)
		if id == 1001 then
			local posX, posY = richLabel:getPosition();
			richLabel:setPosition(ccp(posX + deltaX, posY + deltaY));
		end
	end);
end
class.testAnimation = testAnimation;

local function create(identity)
	local self
	if identity == "package" then
		self = base.create("package")
	elseif identity == "fragment" then
		self = base.create("fragment")
	else
		print("illegal identity")
		return
	end
	setmetatable(self, class.mt)
	res = ed.ui.packageres[identity]
	local scene = self.scene
	local mainLayer = self.mainLayer
	self.ui = {}
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "equipbg",
				res = "UI/alpha/HVGA/package_equip_bg.png",
				z = 2
			},
			layout = {
				-- 背包面板位置 Ray --
				position = ccp(500, 213)
			},
			config = {}
		}
	}
	local readNode = ed.readnode.create(mainLayer, self.ui)
	readNode:addNode(ui_info)
	--[[ui_info = {
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
		}
		
	}
	readNode:addNode(ui_info)
	]]--
	--self:testAnimation()
	self:createHandbookButton()
	self:createListButton()
	self:createListLayer()
	self:getListData()
	self:registerUpdateHandler("asyncLoadEquips", self:asyncLoadEquips())
	self:registerTouchHandler()
	self:btRegisterHandler({
		handler = function(event, x, y)
			if self.draglist and event == "moved" and self.draglist:getDragMode() then
				ed.breakTeach("composeFragment")
			end
		end,
		key = "break_teach_compose"
	})
	return self
end
class.create = create
local registerTouchHandler = function(self)
	local ui = self.ui
	local function destroy()
		if spineContainer~=nil then				
			tolua.cast(spineContainer, "CCNode"):removeFromParentAndCleanup(true)
			spineContainer = nil;
		end
		if armature~=nil then		
			tolua.cast(armature, "CCNode"):removeFromParentAndCleanup(true)
			armature = nil;
		end
		if richLabel~=nil then
			richLabel:removeFromParentAndCleanup(true)
			richLabel=nil
		end
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

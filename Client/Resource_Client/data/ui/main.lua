local ed = ed
local class = {
	mt = {}
}
class.mt.__index = class
local base = ed.ui.framework
setmetatable(class, base.mt)
ed.ui.main = class

local res = ed.ui.mainres
local lsr = ed.ui.mainlsr.create()
local res_pos = res.res_pos
local map_min_x = res.drag_range.x.min
local map_max_x = res.drag_range.x.max
local map_min_y = res.drag_range.y.min
local map_max_y = res.drag_range.y.max
local offset_x = res.offset_x
local verytopmap_max_x=res.drag_range.x.maxverytop
local verttopmap_min_x=res.drag_range.x.minverytop
local redLightUI = {}
local bgOffset=-300
local teachGetHeros=-600
local goToFightOffset=-130
local getMainCount = function(self)
	return self.mainCount or 0
end
class.getMainCount = getMainCount

local doMainCount = function(self)
	self.mainCount = 0
	local function handler(dt)
		self.mainCount = self.mainCount + dt
	end
	return handler
end
class.doMainCount = doMainCount

local function getMainButtonTouchConfig(self, key)
	local ui = self.ui
	local tp = ui[key .. "_title_press"]
	local p = ui[key .. "_press"]
	local nodes = {tp, p}
	local function checkClickHandler(x, y)
		local title = ui[key .. "_title"]
		local button = ui[key]
		if tolua.isnull(button) then
			return false
		end
		if not button:isVisible() then
			return false
		end
		if not tolua.isnull(title) and title:isVisible() and ed.containsPoint(title, x, y) then
			return true
		end
		local info = res_pos[key]
		local offset = info.touchCenter or ccp(0, 0)
		local center = info.pos or ccp(0, 0)
		local radius = info.touchRadius or 0
		local scale = res_pos[key].scale or 1
		local parent = self.topContainer
		if info.parent_index then
			local p_container = {
				self.topContainer,
				self.middleContainer,
				self.bottomContainer,
				self.subContainer
			}
			parent = p_container[info.parent_index]
		end
		local tc = ccpAdd(center, offset)
		if ed.isPointInCircle(tc, radius * scale, x, y, parent) then
			return true
		end
		return false
	end
	local function pressHandler()
		for k, v in pairs(nodes) do
			if not tolua.isnull(v) then
				v:setVisible(true)
			end
		end
	end
	local function cancelPressHandler()
		self:cancelPress(nodes)
	end
	local function clickHandler()
		lsr:report("clickMainButton", {key = key})
		local handler = self:getMainButtonHandler(key)
		handler()
	end
	local mcpMode = true
	return {
		key = key,
		checkClickHandler = checkClickHandler,
		pressHandler = pressHandler,
		cancelPressHandler = cancelPressHandler,
		clickHandler = clickHandler,
		mcpMode = mcpMode,
		force = true
	}
end
class.getMainButtonTouchConfig = getMainButtonTouchConfig

local cancelPress = function(self, nodes)
	for k, v in pairs(nodes or {}) do
		if not tolua.isnull(v) then
			v:setVisible(false)
		end
	end
	self.currentPos = nil
end
class.cancelPress = cancelPress

local function doDragMapTouch(self)
	local preMode, dragMode, dragPressx, dragPressy, mapOrix, mapOriy, speed, count, validCount, dt, premx, premy
	local function handler(event, x, y)
		local bms = res.sky_coefficient
		local mms = res.sea_coefficient
		if event == "began" then
			self:stopScrollMap()
			dragPressx, dragPressy = x, y
			premx, premy = x, y
			mapOrix, mapOriy = self.topContainer:getPosition()
			count = self.mainCount
			validCount = self.mainCount
			speed = 0
		elseif event == "moved" then
			dt = self.mainCount - count
			count = self.mainCount
			if premx == x and premy == y or dt == 0 then
				return
			end
			local mdx, mdy = x - premx, y - premy
			premx, premy = x, y
			dragPressx = dragPressx or x
			dragPressy = dragPressy or y
			local px, py = dragPressx, dragPressy
			preMode = dragMode
			if (x - px) * (x - px) + (y - py) * (y - py) > res.drag_mode_judge_range then
				dragMode = true
			end
			if dragMode then
				local mx, my = mapOrix, mapOriy
				local dx, dy = x - px, y - py
				my = my + dy
				mx = mx + dx
				self.topContainer:setPosition(ccp(mx, my))
				self:refreshMapPos()
				local s = mdx / dt
				if speed / s <= 0 then
					speed = s
				else
					speed = (s + speed) / 2
				end
				validCount = self.mainCount
			end
		elseif event == "ended" then
			local dpx = dragPressx
			dragPressx, dragPressy = nil, nil
			dt = self.mainCount - validCount
			if dt > 0.05 then
				speed = 0
			end
			local dx = self.topContainer:getPositionX()
			gap = 0.6
			dx = dx + speed * gap / 2
			self:bgHorizontalScroll(dx, {gap = gap})
			if ed.debug_mode then
				if (mapOrix or 0) == map_max_x and dpx and x - dpx > 100 then
					ed.gggggm()
				end
			end
		end
	end
	return handler
end
class.doDragMapTouch = doDragMapTouch

local stopScrollMap = function(self)
	self.topContainer:stopAllActions()
	self.middleContainer:stopAllActions()
	self.veryTopContainer:stopAllActions()
	self.bottomContainer:stopAllActions()
end
class.stopScrollMap = stopScrollMap

local function getValidx(self, x)
	local minx, maxx = map_min_x, map_max_x
	return math.min(maxx, math.max(x, minx))
end
class.getValidx = getValidx

local function bgHorizontalScroll(self, dx, addition)
	dx = self:getValidx(dx)
	addition = addition or {}
	local gap = addition.gap or 0.2
	local bms = res.sky_coefficient
	local mms = res.sea_coefficient
	local vtms= res.verytop_coefficient
	local omx, omy = self.topContainer:getPosition()
	local obmx, obmy = self.bottomContainer:getPosition()
	local ommx, ommy = self.middleContainer:getPosition()
	local vtmx,vtmy = self.veryTopContainer:getPosition()
	local mx = dx
	local mmx = mms * dx
	local bmx = bms* dx
	local vmx = vtms* dx
	mx = math.min(map_max_x, math.max(mx, map_min_x))
	mmx = math.min(mms * map_max_x, math.max(mmx, mms * map_min_x))
	bmx = math.min(bms * map_max_x, math.max(bmx, bms * map_min_x))
	vmx = math.min(vtms*verytopmap_max_x, math.max(vmx,vtms*(map_min_x+verttopmap_min_x)))
	local m1 = CCMoveTo:create(gap, ccp(mx, omy))
	self.topContainer:stopAllActions()
	self.topContainer:runAction(CCEaseSineOut:create(m1))
	local m2 = CCMoveTo:create(gap, ccp(mmx, ommy))
	self.middleContainer:stopAllActions()
	self.middleContainer:runAction(CCEaseSineOut:create(m2))
	local m3 = CCMoveTo:create(gap, ccp(bmx, obmy))
	self.bottomContainer:stopAllActions()
	self.bottomContainer:runAction(CCEaseSineOut:create(m3))
	local m4=CCMoveTo:create(gap,ccp(vmx,vtmy))
	self.veryTopContainer:stopAllActions()
	self.veryTopContainer:runAction(CCEaseSineOut:create(m4))
end
class.bgHorizontalScroll = bgHorizontalScroll

local function setbgOffset(self, dx, dy)
	local bms = res.sky_coefficient
	local mms = res.sea_coefficient
	local dx, dy = dy or dx or 0, 0
	self.topContainer:setPosition(ccp(dx, dy))
	self:refreshMapPos()
end
class.setbgOffset = setbgOffset

local function refreshMapPos(self)
	local bms = res.sky_coefficient
	local mms = res.sea_coefficient
	local vtms= res.verytop_coefficient
	local top = self.topContainer
	local middle = self.middleContainer
	local bottom = self.bottomContainer
	local verytop= self.veryTopContainer
	local minx, maxx = map_min_x, map_max_x
	local miny, maxy = map_min_y, map_max_y
	local x, y = top:getPosition()
	x = math.min(maxx, math.max(x, minx))
	y = math.min(maxy, math.max(y, miny))
	top:setPosition(ccp(x, y))
	local mx, my = mms * x, mms * y
	mx = math.min(mms * maxx, math.max(mx, mms * minx))
	my = math.min(mms * maxy, math.max(my, mms * miny))
	middle:setPosition(ccp(mx, my))
	local bx, by = bms * x, bms * y
	bx = math.min(bms * maxx, math.max(bx, bms * minx))
	by = math.min(bms * maxy, math.max(by, bms * miny))
	bottom:setPosition(ccp(bx, by))
	local vx,vy=vtms*x,vtms*y
	vx=math.min(vtms*verytopmap_max_x,math.max(vx,vtms*(minx+verttopmap_min_x)))
	vy=math.min(vtms*maxy,math.max(vy,vtms*miny))
	verytop:setPosition(ccp(vx,vy))
end
class.refreshMapPos = refreshMapPos

local getbgOffset = function(self)
	return self.topContainer:getPosition()
end
class.getbgOffset = getbgOffset

local function doTeachTavernEnch(self)
	if ed.player.heroes[45] then
		return
	end
	if ed.readhero.getStoneNeed(45) - ed.readhero.getStoneAmount(45) == 1 then
		self:setbgOffset(goToFightOffset)
		ed.teach("gotoTavernEnch", ccpAdd(res_pos.tavern.touchCenter, res_pos.tavern.pos), res_pos.tavern.touchRadius, self.topContainer, {
			self.topContainer,
			self.mainLayer
		})
	end
end
class.doTeachTavernEnch = doTeachTavernEnch

local function checkTavernTag(self)
	local keys = {"bronze", "gold"}
	local isShow
	for k, v in pairs(keys) do
		local blt, bcd
		blt = ed.ui.tavern.getLeftTimes(v) or 0
		if not ed.ui.tavern.getCountdown(v) then
			bcd = true
		end
		if blt > 0 and bcd then
			isShow = true
		end
	end
	return isShow
end
class.checkTavernTag = checkTavernTag

local function refreshTavernTag(self)
	local tag = self.ui.tavern_deal_tag
	if not tolua.isnull(tag) then
		tag:removeFromParentAndCleanup(true)
	end
	local title = self.ui.tavern_title
	if self:checkTavernTag() then
		local readnode = ed.readnode.create(title, self.ui)
		local ui_info = {
			{
				t = "Sprite",
				base = {
					name = "tavern_deal_tag",
					res = "UI/alpha/HVGA/main_deal_tag.png",
					z = 10
				},
				layout = {
					position = ccp(113, 27)
				},
				config = {}
			}
		}
		readnode:addNode(ui_info)
	end
end
class.refreshTavernTag = refreshTavernTag

local function onEnterHandler(self)
	local function handler(event)
		xpcall(function()
			if event == "enter" then
				lsr:report("enterScene")
				self:refreshButtons()
				self:refreshMailbox()
				if self.isFirstTimeInGame and self.isFirstTimeBackToMain then
					self.isFirstTimeInGame = false
					self.isFirstTimeBackToMain = false
					self:scShowSwitch()
					self:doShortcut()
				end
				if self.isFirstTimeInGame then
					self.isFirstTimeBackToMain = true
				end
				self:refreshTavernTag()
				self.isPushScene = nil
				if ed.tutorial.checkDone("FTGoldOne") then
					ed.endTeach("FTintoMain")
					ed.endTeach("FTGoldClose")
					ed.endTeach("FTbackToMain")
					if not tolua.isnull(self.teachLayer) then
						self.teachLayer:removeFromParentAndCleanup(true)
					end
				end
				ed.teach("gotoSelectStage", ccpAdd(res_pos.pve.touchCenter, res_pos.pve.pos), res_pos.pve.touchRadius, self.topContainer, {
					self.veryTopContainer,
					self.mainLayer
				})
				
				self:doTeachTavernEnch()
				if self:checkFirstInMain() then
					local chatPanel = ed.getChatPanel()
					chatPanel:setVisible(false)
				else
					local chatPanel = ed.getChatPanel()
					chatPanel.mainLayer:setVisible(false)
				end
				self:registerUpdateHandler("main_count", self:doMainCount())
			end
			if event == "exit" then
				lsr:report("exitScene")
			end
		end, EDDebug)
	end
	return handler
end
class.onEnterHandler = onEnterHandler

local doLoginReply = function(self)
	local function handler()
		xpcall(function()
			if not self then
				return
			end
			if tolua.isnull(self.mainLayer) then
				return
			end
			self:refreshButtons()
		end, EDDebug)
	end
	return handler
end
class.doLoginReply = doLoginReply

local function createMainFca(self)
	for k, v in pairs(self.mainFcas or {}) do
		v:removeFromParentAndCleanup(true)
	end
	self:clearFca()
	self.mainFcas = {}
	self.fcaGaps = {}
	math.randomseed(os.time())
	for k, v in pairs(res_pos) do
		if v.res then
			do
				local node = ed.createFcaNode(v.res, v.aniType)
				if v.default_action then
					node:setAction(v.default_action)
				end
				node:setScale(v.scale or 1)
				self:addFca(node)
				node:setPosition(v.pos or ccp(0, 0))
				local parent
				local parent_index = v.parent_index or 1
				if self.ui[k] then
					parent = self.ui[k]
				else
					local pc = {
						self.topContainer,
						self.middleContainer,
						self.bottomContainer,
						self.subContainer
					}
					parent = pc[parent_index] or self.topContainer
				end
				parent:addChild(node, v.fcaz or 5)
				self.mainFcas[k] = node
				local gmin = v.gap_min or 0
				local gmax = v.gap_max or 0
				local lg = v.loop_gap or 0
				local lmin = v.loop_times_min or 0
				local lmax = v.loop_times_max or 0
				local isGap = v.gap_min and v.gap_max
				local isLoop = lg > 0 and lmin and lmax
				if isGap or isLoop then
					local function handler(dt)
						local function resetGap()
							local gg = gmax - gmin
							local gt = gg and math.random(0, gg) or 0
							local lt = lmin and lmax and math.random(lmin, lmax) or 0
							self.fcaGaps[k] = gg * gt + gmin + lg * lt
						end
						if not self.fcaGaps[k] then
							resetGap()
						end
						if self.fcaGaps[k] < 0 then
							node:setAction("Start")
							resetGap()
						end
						self.fcaGaps[k] = self.fcaGaps[k] - dt
					end
					self:registerUpdateHandler(k, handler)
				end
			end
		end
	end
end
class.createMainFca = createMainFca

local function createShopTitle(self, config)
	if not config then
		return
	end
	local key = config.shopType
	local type = config.titleType
	self.shopTitleType = self.shopTitleType or {}
	if self.shopTitleType[key] == type then
		return
	end
	self.shopTitleType[key] = type
	local ui = self.ui
	local b = ui[key]
	local br = res_pos[key]
	local title = ui[key .. "_title"]
	local titlePress = ui[key .. "_title_press"]
	local titleNotOpen = ui[key .. "_not_open"]
	local titleres = br.titleres
	local pressres = br.titlePressres
	local notopenres = br.titlenotopenres
	if type == "summon" then
		titleres = br.summonTitleres
		pressres = br.summonTitlePressres
		notopenres = br.summonTitlenotopenres
	end
	if not tolua.isnull(title) then
		title:removeFromParentAndCleanup(true)
	end
	if not tolua.isnull(titlePress) then
		titlePress:removeFromParentAndCleanup(true)
	end
	if not tolua.isnull(titleNotOpen) then
		titleNotOpen:removeFromParentAndCleanup(true)
	end
	local function setPos(node, pos)
		node:setPosition(ccpAdd(pos, br.pos))
	end
	local title = ed.createSprite(titleres)
	setPos(title, br.titlePos)
	title:setZOrder(10)
	b:addChild(title)
	ui[key .. "_title"] = title
	local titlePress = ed.createSprite(pressres)
	titlePress:setAnchorPoint(ccp(0, 0))
	titlePress:setPosition(ccp(0, 0))
	title:addChild(titlePress)
	titlePress:setVisible(false)
	ui[key .. "_title_press"] = titlePress
	local notitle = ed.createSprite(notopenres)
	setPos(notitle, br.titlePos)
	b:addChild(notitle)
	notitle:setVisible(false)
	notitle:setZOrder(10)
	if type == "into" then 
		if br.title then
			titleLabel = ed.createLabelWithFontInfo(br.title, "ui_main_button_normal", br.titleSize or 17)
			titleLabel:setAnchorPoint(ccp(0.5, 0.5))
			titleLabel:setPosition(ccp(63, 17))
			if titleLabel:getContentSize().width > 100 then
				titleLabel:setScale(100 / titleLabel:getContentSize().width)
			end
			title:addChild(titleLabel)
			ui[key .. "_not_open"] = titleLabel
		end
	elseif type=="summon" then
		if br.summonTitle then
			titleLabel = ed.createLabelWithFontInfo(br.summonTitle, "ui_main_button_normal", br.titleSize or 17)
			titleLabel:setAnchorPoint(ccp(0.5, 0.5))
			titleLabel:setPosition(ccp(60, 30))
			if titleLabel:getContentSize().width > 100 then
				titleLabel:setScale(100 / titleLabel:getContentSize().width)
			end
			title:addChild(titleLabel)
			ui[key .. "_not_open"] = titleLabel
		end
	end
end
class.createShopTitle = createShopTitle

local function createMainButton(self)
	local ui = self.ui
	local container = self.topContainer
	local pressres = "UI/alpha/HVGA/main_button_press.png"
	local bkeys = res.button_key
	for i = #bkeys, 1, -1 do
		do
			local key = bkeys[i]
			local br = res_pos[key]
			local res = br.res
			local z = br.z
			if not res then
				print("*Attention* you have not set the res yet.", "KEY: ", key)
			else
				local function setPos(node, pos)
					if not pos then
						return
					end
					node:setPosition(ccpAdd(pos, br.pos or ccp(0, 0)))
				end
				local parent_index = br.parent_index or 1
				local pc = {
					self.topContainer,
					self.middleContainer,
					self.bottomContainer,
					self.subContainer
				}
				local parent = pc[parent_index] or self.topContainer
				local b = CCSprite:create()
				parent:addChild(b)
				b:setZOrder(10)
				ui[key] = b
				if z then
					b:setZOrder(z)
				end
				local press = ed.createSprite(pressres)
				local tposition = br.lightPos
				if key == "ssshop" or key == "estren"  then
					tposition.y =tposition.y - 30;
				end

				setPos(press, br.lightPos)
				press:setVisible(false)
				local size = press:getContentSize()
				local fs = br.lightSize or CCSizeMake(0, 0)
				press:setScaleX(fs.width * (br.scale or 1) / size.width)
				press:setScaleY(fs.height * (br.scale or 1) / size.height)
				b:addChild(press)
				ui[key .. "_press"] = press
				local title, titlePress, titleLabel
				if br.titleres then
					title = ed.createSprite(br.titleres)
					setPos(title, br.titlePos)
					title:setZOrder(10)
					b:addChild(title)
					ui[key .. "_title"] = title
					if br.titlePressres then
						titlePress = ed.createSprite(br.titlePressres)
						titlePress:setAnchorPoint(ccp(0, 0))
						titlePress:setPosition(ccp(0, 0))
						title:addChild(titlePress)
						titlePress:setVisible(false)
						ui[key .. "_title_press"] = titlePress
					end
					if br.title then
						titleLabel = ed.createLabelWithFontInfo(br.title, "ui_main_button_normal", br.titleSize or 17)
						titleLabel:setAnchorPoint(ccp(0.5, 0.5))
						titleLabel:setPosition(ccp(60, 18))
						if titleLabel:getContentSize().width > 100 then
							titleLabel:setScale(100 / titleLabel:getContentSize().width)
						end
						title:addChild(titleLabel)
						ui[key .. "_not_open"] = titleLabel
					end
				end
			end
			local info = self:getMainButtonTouchConfig(key)
			self:btRegisterClick(info)
		end
	end
end
class.createMainButton = createMainButton

local function createBottomMap(self)
	local ui = self.ui
	local container = CCSprite:create()
	self.bottomContainer = container
	self.mainLayer:addChild(container)
	local offset = -200
	--[[
	local readNode = ed.readnode.create(container, ui)
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "bg2",
				res = "UI/alpha/HVGA/main_bg_mountain.jpg"
			},
			layout = {
				anchor = ccp(0, 0),
				position = ccp(offset, 0)
			},
			config = {}
		}
	}
	--readNode:addNode(ui_info)
	--]]
	--添加spine动画
	local spineContainer4 = SpineContainer:create('spine/main_bg_mountain', 'main_bg_mountain')
	spineContainer4:runAnimation(0, 'BG', -1)
	local spineNode4= tolua.cast(spineContainer4, 'CCNode')
	spineNode4:setAnchorPoint(ccp(0, 0))
	spineNode4:setPosition(ccp(res.animationX, res.animationY))
	container:addChild(spineNode4)
	--self:playWhiteCloudAnim()
end
class.createBottomMap = createBottomMap

local function playWhiteCloudAnim(self)
	local cloud = self.ui.cloud3
	local bms = res.sky_coefficient
	local function reset()
		cloud:setPosition(ccp(1650 * (1 - bms), 370))
		local m = CCMoveTo:create(180, ccp(-185 - offset_x, 370))
		local f = CCCallFunc:create(function()
			xpcall(function()
				cloud:setPosition(ccp(1650 * (1 - bms), 370))
			end, EDDebug)
		end)
		local s = CCSequence:createWithTwoActions(m, f)
		cloud:runAction(CCRepeatForever:create(s))
	end
	local m = CCMoveTo:create(80, ccp(-185 - offset_x, 370))
	local f = CCCallFunc:create(function()
		xpcall(function()
			reset()
		end, EDDebug)
	end)
	local s = CCSequence:createWithTwoActions(m, f)
	cloud:runAction(s)
end
class.playWhiteCloudAnim = playWhiteCloudAnim

local function createMiddleMap(self)
	local ui = self.ui
	local container = CCSprite:create()
	self.middleContainer = container
	self.mainLayer:addChild(container)
	--[[
	local offset = -200
	local readNode = ed.readnode.create(container, ui)
	local ui_info = {
	{
	t = "Sprite",
	base = {
	name = "bg2",
	res = "UI/alpha/HVGA/main_bg_mountain.png"
	},
	layout = {
	anchor = ccp(0, 0),
	position = ccp(offset, 250)
	},
	config = {}
	}
	}
	readNode:addNode(ui_info)]]--
end
class.createMiddleMap = createMiddleMap

local function createVeryTopMap(self)
	local ui = self.ui
	local container = CCSprite:create()
	local subContainer=CCSprite:create()
	container:addChild(subContainer)
	self.veryTopContainer = container
	self.subContainer=subContainer
	self.mainLayer:addChild(container)
	local offsetX = res.CampaignX
	local offsetY=  res.CampaignY
	local readNode = ed.readnode.create(subContainer, ui)
	local ui_info = {
	{
	t = "Sprite",
	base = {
	name = "bg3",
	res = "UI/alpha/HVGA/main_bg_Up.png"
	},
	layout = {
	anchor = ccp(0, 0),
	position = ccp(offsetX, offsetY)
	},
	config = {}
	}
	}
	readNode:addNode(ui_info)
end
class.createVeryTopMap=createVeryTopMap

local function createTopMap(self)
	local ui = self.ui
	local container = CCSprite:create()
	self.topContainer = container
	self.mainLayer:addChild(container)
	local readnode = ed.readnode.create(container, ui)
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "bg3_left",
				res = "UI/alpha/HVGA/main_bg_grass_left.png"
			},
			layout = {
				anchor = ccp(0, 0),
				position = ccp(-212, 0)
			},
			config = {fix_height = 480}
		},
		{
			t = "Sprite",
			base = {
				name = "bg3_right",
				res = "UI/alpha/HVGA/main_bg_grass_right.png"
			},
			layout = {
				anchor = ccp(0, 0),
				position = ccp(716, 0)
			},
			config = {fix_height = 480}
		},
		{
			t = "Sprite",
			base = {
				name = "cloud4",
				res = "UI/alpha/HVGA/main_cloud_4.png",
				z = -10
			},
			layout = {
				anchor = ccp(0, 0),
				position = res.cloud_res.cloud4.pos
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "cloud5",
				res = "UI/alpha/HVGA/main_cloud_5.png",
				z = -10
			},
			layout = {
				anchor = ccp(0, 0),
				position = res.cloud_res.cloud5.pos
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "cloud6",
				res = "UI/alpha/HVGA/main_cloud_6.png"
			},
			layout = {
				anchor = ccp(0, 0),
				position = res.cloud_res.cloud6.pos
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "left_side",
				res = "UI/alpha/HVGA/main_left_side.png",
				z = 20
			},
			layout = {
				position = ccp(-offset_x, 240)
			}
		},
		{
			t = "Sprite",
			base = {
				name = "right_side",
				res = "UI/alpha/HVGA/main_right_side.png",
				z = 20
			},
			layout = {
				position = ccp(1646, 240)
			}
		}
	}
	readnode:addNode(ui_info)
	--加一个粒子效果
	local lizi={}
	local liziLayer = ed.loadccbi(lizi,"ccbi/Particle_Waterfall.ccbi") 
	liziLayer:setPosition(ccp(res.waterFallX,res.waterFallY))
	container:addChild(liziLayer)
	self:playBlackCloudAnim(self)
	--再添加一朵云彩
	--添加spine动画
	local spineContainer4 = SpineContainer:create('spine/eff_UI_Main_Fog', 'eff_UI_Main_Fog')
	spineContainer4:runAnimation(0, 'Loop', -1)
	local spineNode4= tolua.cast(spineContainer4, 'CCNode')
	spineNode4:setAnchorPoint(ccp(0, 0))
	spineNode4:setPosition(ccp(res.mainFogX, res.mainFogY))
	container:addChild(spineNode4,2)
	
end
class.createTopMap = createTopMap

local function playBlackCloudAnim(self)
	local m1 = CCMoveBy:create(res.cloud_res.cloud4.move_duration, res.cloud_res.cloud4.move_distance)
	local m2 = m1:reverse()
	local sequence = CCSequence:createWithTwoActions(m1, m2)
	self.ui.cloud4:runAction(CCRepeatForever:create(sequence))
	local m1 = CCMoveBy:create(res.cloud_res.cloud5.move_duration, res.cloud_res.cloud5.move_distance)
	local m2 = m1:reverse()
	local sequence = CCSequence:createWithTwoActions(m1, m2)
	self.ui.cloud5:runAction(CCRepeatForever:create(sequence))
	local m1 = CCMoveBy:create(res.cloud_res.cloud5.move_duration, res.cloud_res.cloud6.move_distance)
	local m2 = m1:reverse()
	local sequence = CCSequence:createWithTwoActions(m1, m2)
	self.ui.cloud6:runAction(CCRepeatForever:create(sequence))
end
class.playBlackCloudAnim = playBlackCloudAnim

local OnStoryEnd = function(self)
	local function handler(name)
		if name == "OpeningMain" then
			self:createTavernTeach()
		end
	end
	return handler
end

local function SDKLogin(success)
	if success then
		local text = T(LSTR("MAIN.LOGIN_SUCCESSFULLY_PLEASE_RESTART_THE_GAME"))
		local info = {
			text = text,
			buttonText = T(LSTR("CHATCONFIG.CONFIRM")),
			handler = function()
				xpcall(function()
					LegendExit()
				end, EDDebug)
			end
		}
		ed.showAlertDialog(info)
	end
end

local function SDKLogOut()
	local text = T(LSTR("MAIN.LOGOUT_SUCCESSFULLY_PLEASE_RESTART_THE_GAME"))
	local info = {
		text = text,
		buttonText = T(LSTR("CHATCONFIG.CONFIRM")),
		handler = function()
			xpcall(function()
				LegendExit()
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function pvpNotifyChange(data)
	if not ed.playerlimit.checkAreaUnlock("PVP") then
		if redLightUI.pvpRedLight then
			redLightUI.pvpRedLight:setVisible(false)
		end
		return
	end
	if ed.getNotifyDataValue("PvpNotifyData") then
		if redLightUI.pvpRedLight then
			redLightUI.pvpRedLight:setVisible(true)
		end
	elseif redLightUI.pvpRedLight then
		redLightUI.pvpRedLight:setVisible(false)
	end
end
class.pvpNotifyChange = pvpNotifyChange

local function onEnterWork(self)
	if LegendSDKType == 1 then
		LegendEnableSDKUI(1)
	end
	if CCUserDefault:sharedUserDefault():getBoolForKey("OpeningMain") == true then
		self:createTavernTeach()
	end
	FireEvent("EnterMainUI")
	ListenEvent("StoryEnd", function(name)
		OnStoryEnd(self)(name)
	end)
	ListenEvent("SDKLogin", SDKLogin)
	ListenEvent("SDKLogOut", SDKLogOut)
	ListenEvent("PvpNotifyData", pvpNotifyChange)
	pvpNotifyChange(ed.queryNotifyData("PvpNotifyData"))
end

local function onExitWork()
	LegendEnableSDKUI(0)
	CloseEvent("StoryEnd")
	StopListenEvent("PvpNotifyData", pvpNotifyChange)
end

local function createRedLight(self)
	redLightUI = {}
	local readnode = ed.readnode.create(self.topContainer, redLightUI)
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "pvpRedLight",
				res = "UI/alpha/HVGA/main_deal_tag.png",
				z = 10
			},
			layout = {
				position = ccp(680, 52)
			},
			config = {visible = false}
		}
	}
	readnode:addNode(ui_info)
	class.pvpNotifyChange()
end

local function initChatPanel(self)
	local chatpanel = ed.getChatPanel()
	chatpanel:getRootLayer():setParent(nil)
	self.scene:addChild(chatpanel:getRootLayer(), 200)
end

local function create(addition)
	--notify C++ not is in loading page
	SeverConsts:getInstance():setIsInLoading(false);
	--by chenpanhua
	LegendUpdateSvr(1,tonumber(game_server_id),ed.player:getName(),ed.getUserid(),ed.player:getLevel(),ed.player:getvip(),ed.player._money,ed.player._rmb,1);

	local self = base.create("main")
	setmetatable(self, class.mt)
	local scene = self.scene
	addition = addition or {}
	local ps = addition.ps or ""
	if ps == "5v5" then
		self.from5v5 = true
	end
	local mainLayer = self.mainLayer
	local ui = self.ui
	self:createBottomMap()
	self:createMiddleMap()
	self:createTopMap()
	self:createVeryTopMap()
	self:createMainButton()
	self:createMainFca()
	createRedLight(self)
	local mapLeft = ui.bg3_left
	local mapRight = ui.bg3_right
	local mapWidth = mapLeft:getContentSize().width + mapRight:getContentSize().width
	map_min_x = 800 - mapWidth + offset_x
	self:setbgOffset(bgOffset)
	mainLayer:registerScriptHandler(self:onEnterHandler())
	self:btRegisterHandler({
		handler = self:doDragMapTouch(),
		key = "drag_map"
	})
	self:registerUpdateHandler("commonRefresh", self:commonRefreshHandler())
	self:registerOnExitHandler("onExitwork", onExitWork)
	self:registerOnEnterHandler("onEnterwork", function()
		onEnterWork(self)
	end)
	initChatPanel(self)
	--小岛的动画
	local islandx,islandy=self.subContainer:getPosition()
	local moveUp=CCEaseSineInOut:create(CCMoveTo:create(4,ccp(islandx,islandy+10)))
	local moveDown=CCEaseSineInOut:create(CCMoveTo:create(4,ccp(islandx,islandy-10)))
	local sc=CCSequence:createWithTwoActions(moveUp,moveDown)
	local forever=CCRepeatForever:create(sc)
	self.subContainer:runAction(forever)
	return self
end
class.create = create

local commonRefreshHandler = function(self)
	local count = 0
	local isTavernTag = self:checkTavernTag()
	local function handler(dt)
		count = count + dt
		if count > 60 then
			count = count - 60
			local tt = self:checkTavernTag()
			if tt ~= isTavernTag then
				self:refreshTavernTag()
				isTavernTag = self:checkTavernTag()
			end
		end
	end
	return handler
end
class.commonRefreshHandler = commonRefreshHandler

local function createTavernTeach(self)
	if self.isTavernTeaching then
		return
	end
	local function teachTavern()
		local r = res.res_pos.tavern
		local ist = ed.teach("FTintoMain", ccpAdd(r.touchCenter, r.pos), r.touchRadius, self.topContainer, {
			self.topContainer,
			self.mainLayer
		})
		if ist then
			local teachLayer = CCLayer:create()
			local touchNode = ed.ui.basetouchnode.btCreate()
			local touchHandler = self:getMainButtonTouchConfig("tavern")
			touchNode:btRegisterClick(touchHandler)
			teachLayer:setTouchEnabled(true)
			self:setbgOffset(teachGetHeros)
			teachLayer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -200, true)
			self.teachLayer = teachLayer
			self.mainLayer:addChild(teachLayer)
		end
	end
	if self.from5v5 then
		ed.announce({
			type = "popHeroCard",
			param = {
				id = 1,
				callback = function()
					xpcall(function()
						teachTavern()
					end, EDDebug)
				end
			}
		})
	else
		teachTavern()
	end
	self.isTavernTeaching = true
end
class.createTavernTeach = createTavernTeach

local function refreshButtons(self)
	local keys = {
		defence = "COT",
		pvp = "PVP",
		shop = "shop",
		estren = "Enhance",
		exercise = "Exercise",
		volcano = "Crusade",
		handbook = "Guild"
	}
	for k, v in pairs(keys) do
		local ul = ed.playerlimit.checkAreaUnlock(v)
		local ott = self.ui[k .. "_title"]
		local nott = self.ui[k .. "_not_open"]
		if ul then
			--ott:setVisible(true)
			ed.setLabelFontInfo(nott, "ui_main_button_normal")
			ed.setLabelColor(nott, ccc3(244, 221, 90))
		else
			--ott:setVisible(false)
			ed.setLabelFontInfo(nott, "ui_main_button_disable")
		end
	end
	self:refreshShop()
	self:refreshStarshop()
	self:refreshMailbox()
end
class.refreshButtons = refreshButtons

local function refreshMailbox(self, isEmpty)
	local actor
	if isEmpty then
		actor = "Empty"
		ed.player:resetNewMail()
	elseif ed.player:checkunreadMail() then
		actor = "Full"
	else
		actor = "Empty"
	end
	self.mainFcas.mailbox:setAction(actor)
	self:refreshMailboxTag(isEmpty)
end
class.refreshMailbox = refreshMailbox

local function refreshMailboxTag(self, isEmpty)
	if tolua.isnull(self.ui.mailbox_tag) then
		local container = self.ui.mailbox_title
		local readnode = ed.readnode.create(container, self.ui)
		local pos = res_pos.mailbox.pos
		local ui_info = {
			{
				t = "Sprite",
				base = {
					name = "mailbox_tag",
					res = "UI/alpha/HVGA/main_deal_tag.png",
					z = 10
				},
				layout = {
					position = ccp(113, 27)
				},
				config = {}
			}
		}
		readnode:addNode(ui_info)
	end
	local tag = self.ui.mailbox_tag
	local hasMail = ed.player:checkunreadMail()
	if isEmpty then
		tag:setVisible(false)
	elseif hasMail then
		tag:setVisible(true)
	else
		tag:setVisible(false)
	end
end
class.refreshMailboxTag = refreshMailboxTag

local function refreshStarshop(self)
	local ui = self.ui
	local starshop = ui.starshop
	local key = "starshop"
	local has = ed.player:checkShopValid("starshop")
	if not has then
		ui[key]:setVisible(false)
		self:btRemoveMainTouchHandler({key = key})
	elseif ed.player:checkShopGoodsEmpty("starshop") then
		ui[key]:setVisible(false)
		self:btRemoveMainTouchHandler({key = key})
		ed.breakTeach("openStarshop")
	else
		ui[key]:setVisible(true)
		self:btRegisterClick(self:getMainButtonTouchConfig(key))
	end
end
class.refreshStarshop = refreshStarshop

local function refreshShop(self, key)
	self.shopButtonType = self.shopButtonType or {}
	if not key then
		self:refreshShop("sshop")
		self:refreshShop("ssshop")
		return
	end
	local button = self.ui[key]
	self.shopButtonType[key] = "into"
	local vk = {
		sshop = "Summon Special Shop",
		ssshop = "Summon So Special Shop"
	}
	local id = {sshop = 2, ssshop = 3}
	local has = ed.player:checkShopValid(id[key])
	local k = vk[key]
	local ul = ed.getDataTable("VIP")[ed.player:getvip()][k]
	if not has then
		if ul then
			button:setVisible(true)
			self.shopButtonType[key] = "summon"
			self.mainFcas[key]:useShader("GrayScalingShader")
			self:createShopTitle({shopType = key, titleType = "summon"})
		else
			button:setVisible(false)
		end
	else
		self.mainFcas[key]:useDefaultShader()
		button:setVisible(true)
		self:createShopTitle({shopType = key,titleType = "into"})
	end
end
class.refreshShop = refreshShop

local function openShopReply(self)
	local function handler(result)
		if not result then
			ed.showToast(T(LSTR("MAIN.SUMMON_MYSTERIOUS_STORE_FAILED")))
		else
			self:refreshShop()
		end
	end
	return handler
end
class.openShopReply = openShopReply

local function summonShop(self, type)
	local keys = {
		sshop = {
			id = 2,
			key = "Summon Special Shop"
		},
		ssshop = {
			id = 3,
			key = "Summon So Special Shop"
		}
	}
	local price = ed.getDataTable("GradientPrice")[1][keys[type].key]
	if price > ed.player._rmb then
		ed.showHandyDialog("toRecharge")
		return
	end
	ed.netdata.openShop = {cost = price}
	ed.netreply.openShop = self:openShopReply()
	local msg = ed.upmsg.open_shop()
	msg._shopid = keys[type].id
	ed.send(msg, "open_shop")
end
class.summonShop = summonShop

local function getMainButtonHandler(self, key)
	local pl = ed.playerlimit
	local cpl = pl.getAreaUnlockPrompt
	local function showShopSummonWindow(type)
		local keys = {
			sshop = {
				name = T(LSTR("MERCHANTTALK.GOBLIN_BUSINESSMAN")),
				key = "Summon Special Shop"
			},
			ssshop = {
				name = T(LSTR("MERCHANTTALK.BLACK_MARKET_MERCHANT")),
				key = "Summon So Special Shop"
			}
		}
		local price = ed.getDataTable("GradientPrice")[1][keys[type].key]
		local text = T(LSTR("MAIN.SPEND__D_DIAMONDS_ON__S"), price, keys[type].name)
		local function rightHandler()
			self:summonShop(type)
		end
		local info = {text = text, rightHandler = rightHandler}
		ed.showConfirmDialog(info)
	end

	local handler = {
		defence = function()
			local ds = cpl("COT")
			if ds then
				ed.showToast(ds)
				return
			end
			lsr:report("clickcot")
			ed.pushScene(ed.ui.exercise.create("em"))
			self.isPushScene = true
		end,
		pve = function()
			-- LegendRestartApplication()
			--  senddumpfile("fasdfsadfsadfsad")
            --add by xinghui:send dot info when enter stage
            if --[[ed.tutorial.checkDone("gotoSelectStage") == false--]] ed.tutorial.isShowTutorial then
                ed.sendDotInfoToServer(ed.tutorialres.t_key["gotoSelectStage"].id)
            end
            --
			ed.endTeach("gotoSelectStage")
			lsr:report("clickpve")
			ed.pushScene(ed.ui.stageselect.create())
			self.isPushScene = true
		end,
		pvp = function()
			local ds = cpl("PVP")
			if ds then
				ed.showToast(ds)
				return
			else
				local msg = ed.upmsg.ladder()
				msg._open_panel = {}
				ed.send(msg, "ladder")
			end
			lsr:report("clickpvp")
		end,
		shop = function()
			local ds = cpl("shop")
			if ds then
				ed.showToast(ds)
				return
			end
			if not ed.player:getShopData(1) then
				print("Hava not the data of shop!")
				return
			end
			lsr:report("clickshop")
			ed.pushScene(ed.ui.shop.create())
			self.isPushScene = true
			ed.endTeach("openShop")
		end,
		sshop = function()
			local type = self.shopButtonType.sshop
			if type == "into" then
				lsr:report("clicksshop")
				ed.pushScene(ed.ui.shop.create(2))
				self.isPushScene = true
				ed.endTeach("openSpecialShop")
			elseif type == "summon" then
				showShopSummonWindow("sshop")
			end
		end,
		ssshop = function()
			local type = self.shopButtonType.ssshop
			if type == "into" then
				lsr:report("clickssshop")
				ed.pushScene(ed.ui.shop.create(3))
				self.isPushScene = true
				ed.endTeach("openSoSpecialShop")
			elseif type == "summon" then
				showShopSummonWindow("ssshop")
			end
		end,
		starshop = function()
			lsr:report("clickstarshop")
			ed.pushScene(ed.ui.shop.create("starshop"))
			self.isPushScene = true
			ed.endTeach("openStarshop")
		end,
		handbook = function()
			local ds = cpl("Guild")
			if ds then
				ed.showToast(ds)
				return
			end
			local msg = ed.upmsg.guild()
			msg._open_pannel = {}
			ed.send(msg, "guild")
		end,
		estren = function()
			local ds = cpl("Enhance")
			if ds then
				ed.showToast(ds)
				return
			end
			lsr:report("clickestren")
			ed.pushScene(ed.ui.equipstrengthen.create())
			self.isPushScene = true
		end,
		tavern = function()
			lsr:report("clicktavern")
			ed.endTeach("gotoTavernEnch")
            --add by xinghui:send dot when enter tarven
            if --[[ed.tutorial.checkDone("FTintoMain") == false--]] ed.tutorial.isShowTutorial then
                ed.sendDotInfoToServer(ed.tutorialres.t_key["FTintoMain"].id)
            end
            --
			ed.pushScene(ed.ui.tavern.create())
			self.isPushScene = true
		end,
		exercise = function()
			local ds = cpl("Exercise")
			if ds then
				ed.showToast(ds)
				return
			end
			lsr:report("clickexercise")
			ed.pushScene(ed.ui.exercise.create("equip"))
			self.isPushScene = true
		end,
		mailbox = function()
			lsr:report("clickMailbox")
			local mailbox = ed.ui.mailbox.create({
				callback = function()
					xpcall(function()
						self:refreshMailbox(ed.player:getMailAmount() == 0)
					end, EDDebug)
				end
			})
			self.mainLayer:addChild(mailbox.mainLayer, 160)
		end,
		volcano = function()
			local ds = cpl("Crusade")
			if ds then
				ed.showToast(ds)
				return
			end
			local msg = ed.upmsg.tbc()
			msg._open_panel = {}
			ed.send(msg, "tbc")
		end,
		excavate = function()
			local ds = cpl("Excavate")
			if ds then
				ed.showToast(ds)
				return
			end
			ed.ui.excavate.initialize()
			ed.endTeach("openExcavate")
		end,
		ranklist = function()
		--[[
			local ds = cpl("Guild")
			if ds then
				ed.showToast(ds)
				return
			end
		--]]
			local scene = ed.ui.ranklist.create({index = 2})
			ed.pushScene(scene)
		end
	}
	local hd = handler[key] or function()
		print("can not find the function")
	end
	if self.isPushScene then
		function hd()
		end
	end
	return hd
end
class.getMainButtonHandler = getMainButtonHandler

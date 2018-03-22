local ed = ed
local class = {
mt = {}
}
class.mt.__index = class
ed.draglist = class
local k_both = 0
local k_horizontal = 1
local k_vertical = 2
local k_coefficient = 0.4
local vertical_shade_res = "UI/alpha/HVGA/package_list_shade.png"
local horinzontal_shade_res = "UI/alpha/HVGA/list_shade_left.png"
local bar_bg_res = "UI/alpha/HVGA/scroll_bar_bg.png"
local bar_res = "UI/alpha/HVGA/scroll_bar.png"
local bar_bg_thick = 2
local bar_thick = 4
local getRunScene = function()
	return CCDirector:sharedDirector():getRunningScene()
end
local checknull = function(self)
	return tolua.isnull(self.mainLayer)
end
class.checknull = checknull
local getListPos = function(self)
	return self.listLayer:getPosition()
end
class.getListPos = getListPos
local setListPos = function(self, pos)
	self.listLayer:setPosition(pos)
	if self.noshade then
		return
	end
	local x, y = pos.x, pos.y
	if self.canDragY then
		if y > 0 then
			self:setShadeupVisible(true)
		end
		if y + self.height < self.listHeight then
			self:setShadedownVisible(true)
		end
	end
	if self.canDragX then
		if x < 0 then
			self:setShadeleftVisible(true)
		end
		if self.width - x < self.listWidth then
			self:setShaderightVisible(true)
		end
	end
end
class.setListPos = setListPos
local getDragMode = function(self)
	return self.dragMode
end
class.getDragMode = getDragMode
local getItemWorldPos = function(self, pos)
	return self.listLayer:convertToWorldSpace(pos)
end
class.getItemWorldPos = getItemWorldPos
local getList = function(self)
	return self.listLayer
end
class.getList = getList
local isNodeAtClipRect = function(self, node)
	local isRet = false
	if node ~= nil then
		local downPosY = self.cliprect.origin.y
		local upPosY = self.cliprect.origin.y + self.cliprect.size.height
		local tmpPos = ccp(node:getPosition())
		local tmpWorldItemPos = self:getItemWorldPos(tmpPos)
		local posRect = node:getTextureRect()
		if downPosY <= tmpWorldItemPos.y + posRect.size.height / 2 and upPosY >= tmpWorldItemPos.y - posRect.size.height / 2 then
			isRet = true
		end
	end
	return isRet
end
class.isNodeAtClipRect = isNodeAtClipRect
local addItem = function(self, node, pos)
	if pos then
		node:setPosition(pos)
	end
	if not tolua.isnull(self.listLayer) then
		self.listLayer:addChild(node)
	end
end
class.addItem = addItem
local setUpdateListItemVisibleEnable = function(self, isEnable)
	if self.listLayer.getVisibleChildren ~= nil then
		self.isEnableUpdateListItemVisible = isEnable
	else
		self.isEnableUpdateListItemVisible = false
	end
end
class.setUpdateListItemVisibleEnable = setUpdateListItemVisibleEnable
local setNodeDrawDependRenderble = function(self, node, isDepend)
	if node ~= nil then
		if self.listLayer.getVisibleChildren == nil then
			node:setDrawDependRenderble(false)
		else
			node:setDrawDependRenderble(isDepend)
		end
	end
end
class.setNodeDrawDependRenderble = setNodeDrawDependRenderble
local setListNumOneRow = function(self, listNum)
	self.listNumOneRow = listNum
end
class.setListNumOneRow = setListNumOneRow
local setItemDirectParent = function(self, parentNode)
	self.itemDirectParent = parentNode
end
class.setItemDirectParent = setItemDirectParent
local updateItemsVisible = function(self, isForceUpdateAll)
	local bSuc = false
	return bSuc
end
class.updateItemsVisible = updateItemsVisible
local clearList = function(self)
	self.listLayer:removeAllChildrenWithCleanup(true)
end
class.clearList = clearList
local function create(param)
	local self = {}
	setmetatable(self, class.mt)
	self.oriPosX = 0
	self.oriPosY = 0
	self.width = 800
	self.height = 480
	self.dragMode = false
	self.canDragX = false
	self.canDragY = false
	self.pressPos = nil
	self.offset = nil
	self.getSpeedid = nil
	self.dragSpeed = nil
	self:init(param)
	return self
end
class.create = create
local reset = function(self)
	if tolua.isnull(self.listLayer) then
		return
	end
	self.listLayer:stopAllActions()
	self.listLayer:setPosition(ccp(self.oriPosX, self.oriPosY))
end
class.reset = reset
local update = function(self)
	local scheduler = self.mainLayer:getScheduler()
	local id
	local function handler(dt)
		xpcall(function()
			if not id then
				id = self.updateID
			end
			if tolua.isnull(self.mainLayer) then
				scheduler:unscheduleScriptEntry(id)
				self.updateID = nil
				return
			end
			if self.listLayer ~= nil then
				self:updateItemsVisible()
			end
			end, EDDebug)
		end
		return handler
	end
	class.update = update
	local init = function(self, info)
		self:initParams(info)
	end
	class.init = init
	local function initParams(self, info)
		local cliprect = info.cliprect
		local rect = info.rect
		local anchor = info.anchor
		local position = info.position
		local noshade = info.noshade
		local size = info.size
		local noshade = info.noshade
		local shadeRes = {
		up = info.upShade,
		down = info.downShade,
		left = info.leftShade,
		right = info.rightShade
		}
		local tp = info.priority or 0
		local swallow = info.swallow or false
		local z = info.zorder or 0
		local container = info.container or getRunScene()
		local listInfo = {
		cliprect = cliprect,
		rect = rect,
		noshade = noshade,
		shadeRes = shadeRes,
		touchPriority = tp,
		swallow = swallow,
		zorder = z,
		container = container,
		message = info.message
		}
		local layer = self:initLayer(listInfo)
		self:initLayout(anchor, position, size)
		local barInfo = info.bar
		local bar = barInfo or {}
		local bgres = bar.bgres or bar_bg_res
		local barres = bar.barres or bar_res
		local barthick = bar.barthick or bar_thick
		local bgthick = bar.bgthick or bar_bg_thick
		local bglen = bar.bglen
		local bgpos = bar.bgpos
		local direction = bar.direction
		bar = {
		bgres = bgres,
		barres = barres,
		barthick = barthick,
		bgthick = bgthick,
		bglen = bglen,
		bgpos = bgpos,
		direction = direction
		}
		if barInfo then
			self:initScrollbar(bar)
		end
		self.doClickIn = info.doClickIn
		self.cancelClickIn = info.cancelClickIn
		self.doPressIn = info.doPressIn
		self.cancelPressIn = info.cancelPressIn
		self.outoffset = info.outoffset
		self.isEnableUpdateListItemVisible = false
		self.listNumOneRow = 0
		self.preListLayerPos = {x = -1, y = -1}
		self.firstItemWordPos = nil
		self.itemDistance = nil
		self.itemRect = nil
		self.visibleItems = {}
		self.waitForUpdateItems = {}
		self.itemDirectParent = nil
		self:initListWidth(0)
		self:initListHeight(0)
		return layer
end
class.initParams = initParams
local setClipRect = function(self, cliprect)
	self.clipLayer:setClipRect(cliprect)
end
class.setClipRect = setClipRect
local setLayerPos = function(self, pos)
	self.layer:setPosition(pos)
end
class.setLayerPos = setLayerPos
local runLayerAction = function(self, action)
	self.layer:runAction(action)
end
class.runLayerAction = runLayerAction
local refreshClipRect = function(self, s)
	local rect = self.cliprect
	local x = rect.origin.x
	local y = rect.origin.y
	local w = rect.size.width
	local h = rect.size.height
	s = s or self.layer:getScale()
	local nx = x * s
	local ny = y * s
	local nw = w * s
	local nh = h * s
	if nw < 0 then
		nw = 0
	end
	if nh < 0 then
		nh = 0
	end
	self:setClipRect(CCRectMake(nx, ny, nw, nh))
end
class.refreshClipRect = refreshClipRect
local initClipRect = function(self, rect)
	local layer = self.clipLayer
	self.cliprect = rect
	self.width = rect.size.width
	self.height = rect.size.height
	layer:setClipRect(rect)
end
class.initClipRect = initClipRect
local function initShade(self, shadeRes, rect, noshade)
	local layer = self.layer
	local clipLayer = self.clipLayer
	local listLayer = self.listLayer
	local srect = rect or self.cliprect
	local rx = srect.origin.x
	local ry = srect.origin.y
	local rw = srect.size.width
	local rh = srect.size.height
	local upres = shadeRes.up or vertical_shade_res
	local upShade = ed.createSprite(upres)
	local downres = shadeRes.down or vertical_shade_res
	local downShade = ed.createSprite(downres)
	downShade:setFlipY(true)
	local scaleX = rw / upShade:getContentSize().width * 1.06
	upShade:setScaleX(scaleX)
	downShade:setScaleX(scaleX)
	downShade:setPosition(ccp(rx + rw / 2, ry + downShade:getContentSize().height / 2 - 2))
	upShade:setPosition(ccp(rx + rw / 2, ry + rh - upShade:getContentSize().height / 2))
	local leftres = shadeRes.left or horinzontal_shade_res
	local rightres = shadeRes.right or horinzontal_shade_res
	local leftShade = ed.createSprite(leftres)
	local rightShade = ed.createSprite(rightres)
	local scaleY = rh / leftShade:getContentSize().height * 1.06
	leftShade:setScaleY(scaleY)
	rightShade:setScaleY(scaleY)
	rightShade:setFlipX(true)
	leftShade:setPosition(ccp(rx + leftShade:getContentSize().width / 2 - 2, ry + rh / 2))
	rightShade:setPosition(ccp(rx + rw - leftShade:getContentSize().width / 2, ry + rh / 2))
	self.upShade = upShade
	self.downShade = downShade
	self.leftShade = leftShade
	self.rightShade = rightShade
	layer:addChild(upShade, 20)
	layer:addChild(downShade, 20)
	layer:addChild(leftShade, 20)
	layer:addChild(rightShade, 20)
	upShade:setVisible(false)
	downShade:setVisible(false)
	leftShade:setVisible(false)
	rightShade:setVisible(false)
	self.noshade = noshade
	self.actualrect = rect
end
class.initShade = initShade
local initLayer = function(self, info)
	local cliprect = info.cliprect
	local rect = info.rect
	local noshade = info.noshade
	local shadeRes = info.shadeRes
	local tp = info.touchPriority
	local swallow = info.swallow
	local z = info.zorder
	local container = info.container
	local layer = CCLayer:create()
	self.layer = layer
	self.mainLayer = self.layer
	local clipLayer = CCLayer:create()
	self.clipLayer = clipLayer
	self:initClipRect(cliprect)
	layer:addChild(clipLayer, 10)
	local listLayer = CCLayer:create()
	self.listLayer = listLayer
	self.listScheduler = self.listLayer:getScheduler()
	clipLayer:addChild(listLayer)
	self:initShade(shadeRes, rect, noshade)
	if info.message == true or info.message == nil then
		layer:setTouchEnabled(true)
		layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, tp, swallow)
	end
	container:addChild(layer, z)
	return layer
end
class.initLayer = initLayer
local initAnchor = function(self, anchor)
	if not anchor then
		return
	end
	self.listLayer:setAnchorPoint(anchor)
end
class.initAnchor = initAnchor
local initPosition = function(self, position)
	if not position then
		return
	end
	self.listLayer:setPosition(position)
	self.oriPosX = position.x
	self.oriPosY = position.y
end
class.initPosition = initPosition
local initSize = function(self, size)
	if not size then
		return
	end
	self.listLayer:setContentSize(size)
end
class.initSize = initSize
local initLayout = function(self, anchor, position, size)
	self:initAnchor(anchor)
	self:initPosition(position)
	self:initSize(size)
end
class.initLayout = initLayout
local function initListWidth(self, listWidth, needReset)
	self.listWidth = listWidth
	local layerWidth = self.width
	self.canDragX = false
	self:setHShadeVisible(false, false)
	if listWidth > layerWidth then
		self.canDragX = true
		if not self.noshade then
			self:setHShadeVisible(false, true)
		end
	end
	if needReset ~= false then
		self:reset()
	end
	local sb = self.scrollbar
	for i = 1, #(sb or {}) do
		if sb[i].barDirection == k_horizontal then
			self:resetScrollbar(i, needReset)
		end
	end
end
class.initListWidth = initListWidth
local function initListHeight(self, listHeight, needReset)
	self.listHeight = listHeight
	local layerHeight = self.height
	self.canDragY = false
	self:setVShadeVisible(false, false)
	if listHeight > layerHeight then
		self.canDragY = true
		if not self.noshade then
			self:setVShadeVisible(false, true)
		end
	end
	if needReset ~= false then
		self:reset()
	end
	local sb = self.scrollbar
	for i = 1, #(sb or {}) do
		if sb[i].barDirection == k_vertical then
			self:resetScrollbar(i, needReset)
		end
	end
end
class.initListHeight = initListHeight
local setShadeupVisible = function(self, b)
	if tolua.isnull(self.upShade) then
		return
	end
	b = b or false
	self.upShade:setVisible(b)
end
class.setShadeupVisible = setShadeupVisible
local setShadedownVisible = function(self, b)
	if tolua.isnull(self.downShade) then
		return
	end
	b = b or false
	self.downShade:setVisible(b)
end
class.setShadedownVisible = setShadedownVisible
local setShadeleftVisible = function(self, b)
	if tolua.isnull(self.leftShade) then
		return
	end
	b = b or false
	self.leftShade:setVisible(b)
end
class.setShadeleftVisible = setShadeleftVisible
local setShaderightVisible = function(self, b)
	if tolua.isnull(self.rightShade) then
		return
	end
	b = b or false
	self.rightShade:setVisible(b)
end
class.setShaderightVisible = setShaderightVisible
local setHShadeVisible = function(self, lv, rv)
	lv = lv or false
	rv = rv or false
	self:setShadeleftVisible(lv)
	self:setShaderightVisible(rv)
end
class.setHShadeVisible = setHShadeVisible
local setVShadeVisible = function(self, uv, dv)
	uv = uv or false
	dv = dv or false
	self:setShadeupVisible(uv)
	self:setShadedownVisible(dv)
end
class.setVShadeVisible = setVShadeVisible
local showShade = function(self)
	if self.canDragY then
		self:setVShadeVisible(true, true)
	end
	if self.canDragX then
		self:setHShadeVisible(true, true)
	end
end
class.showShade = showShade
local refreshShade = function(self)
	local x, y = self.listLayer:getPosition()
	local ox, oy = self.oriPosX, self.oriPosY
	local lh, rh = self.listHeight, self.height
	local lw, rw = self.listWidth, self.width
	if self.canDragY and not self.noshade and lh >= rh then
		if y <= oy then
			self:setVShadeVisible(false, true)
		elseif y >= oy + (lh - rh) then
			self:setVShadeVisible(true, false)
		else
			self:setVShadeVisible(true, true)
		end
	end
	if self.canDragX and not self.noshade and lw >= rw then
		if x >= ox then
			self:setHShadeVisible(false, true)
		elseif x <= ox - (lw - rw) then
			self:setHShadeVisible(true, false)
		else
			self:setHShadeVisible(true, true)
		end
	end
end
class.refreshShade = refreshShade
local initListSize = function(self, size, needReset)
	self:initListWidth(size.width, needReset)
	self:initListHeight(size.height, needReset)
end
class.initListSize = initListSize
local drag = function()
	local preX, preY
	local function offset(x, y)
		local dx, dy
		if preX then
			dx = x - preX
		else
			dx = 0
		end
		if preY then
			dy = y - preY
		else
			dy = 0
		end
		preX = x
		preY = y
		return dx, dy
	end
	return offset
end
class.drag = drag
local stopGetSpeed = function(self)
	if self.getSpeedid then
		self.listScheduler:unscheduleScriptEntry(self.getSpeedid)
		self.getSpeedid = nil
	end
end
class.stopGetSpeed = stopGetSpeed
local function getSpeed(self)
	self.speedX = 0
	self.speedY = 0
	local countX, countY, preX, preY
	local scheduler = self.listScheduler
	local id
	local scene = getRunScene()
	local function speed(dt)
		xpcall(function()
			if not id and self.getSpeedid then
				id = self.getSpeedid
			end
			if getRunScene() ~= scene then
				self:stopGetSpeed()
				return
			end
			if tolua.isnull(self.listLayer) then
				scheduler:unscheduleScriptEntry(id)
				return
			end
			if self.listLayer:numberOfRunningActions() == 0 and not self.isPressInRect then
				self:stopGetSpeed()
				return
			end
			if countX == nil then
				countX = 0
			end
			if countY == nil then
				countY = 0
			end
			if preX == nil then
				self.speedX = 0
				preX = self.listLayer:getPositionX()
			end
			if preY == nil then
				self.speedY = 0
				preY = self.listLayer:getPositionY()
			end
			local nx = self.listLayer:getPositionX()
			local dx = nx - preX
			local speedX = dx / dt
			if math.abs(speedX) < 60 then
				countX = countX + 1
			end
			if math.abs(speedX) > 60 then
				countX = 0
			end
			if countX > 20 then
				self.speedX = 0
			else
				self.speedX = (self.speedX + speedX) / 2
			end
			preX = nx
			local ny = self.listLayer:getPositionY()
			local dy = ny - preY
			local speedY = dy / dt
			if math.abs(speedY) < 60 then
				countY = countY + 1
			end
			if math.abs(speedY) > 60 then
				countY = 0
			end
			if countY > 20 then
				self.speedY = 0
			else
				self.speedY = (self.speedY + speedY) / 2
			end
			preY = ny
			end, EDDebug)
		end
		return speed
end
class.getSpeed = getSpeed
local listEaseBackOut = function(self, x, y)
	local lx, ly = self.listLayer:getPosition()
	local pressx, pressy = self.pressPos.x, self.pressPos.y
	local speedx, speedy = 0, 0
	if self.speedX then
		speedx = self.speedX
	end
	if self.speedY then
		speedy = self.speedY
	end
	local endx, endy = lx, ly
	local isBackOut = false
	if self.canDragX then
		local maxx = self.oriPosX
		local minx = self.oriPosX + self.width - self.listWidth
		if lx < minx then
			endx = minx
			isBackOut = true
		elseif lx > maxx then
			endx = maxx
			isBackOut = true
		else
			endx = lx + speedx / 2
			if maxx < endx then
				endx = maxx
			end
			if minx > endx then
				endx = minx
			end
		end
	end
	if self.canDragY then
		local miny = self.oriPosY
		local maxy = self.oriPosY + self.listHeight - self.height
		if ly < miny then
			endy = miny
			isBackOut = true
		elseif ly > maxy then
			endy = maxy
			isBackOut = true
		else
			endy = ly + speedy / 2
			if maxy < endy then
				endy = maxy
			end
			if miny > endy then
				endy = miny
			end
		end
	end
	if not tolua.isnull(self.listLayer) then
		self.listLayer:stopAllActions()
	end
	local ease
	if isBackOut then
		local action = CCMoveTo:create(0.5, ccp(endx, endy))
		ease = CCEaseBackOut:create(action)
	else
		local action = CCMoveTo:create(2, ccp(endx, endy))
		ease = CCEaseExponentialOut:create(action)
	end
	if (endx ~= lx or endy ~= ly) and not tolua.isnull(self.listLayer) then
		self.listLayer:runAction(ease)
	end
end
class.listEaseBackOut = listEaseBackOut
local registerLongPressHandler = function(self, key, handler, delay)
	if not self.longPressHandler then
		self.longPressHandler = {}
	end
	self.longPressHandler[key] = {handler = handler, delay = delay}
end
class.registerLongPressHandler = registerLongPressHandler
local clearLongPressHandler = function(self)
	self.longPressHandler = {}
end
class.clearLongPressHandler = clearLongPressHandler
local function longPress(self, x, y)
	local count = 0
	local done = {}
	for k, v in pairs(self.longPressHandler or {}) do
		done[k] = false
	end
	local scheduler = self.listScheduler
	local id
	local scene = getRunScene()
	local function handler(dt)
		xpcall(function()
			count = count + dt
			if not id and self.longPressId then
				id = self.longPressId
			end
			if getRunScene() ~= scene then
				scheduler:unscheduleScriptEntry(id)
				return
			end
			if tolua.isnull(self.listLayer) then
				scheduler:unscheduleScriptEntry(id)
				return
			end
			local allDone = true
			for k, v in pairs(self.longPressHandler or {}) do
				if not done[k] then
					if count > v.delay then
						v.handler(x, y)
						done[k] = true
						self.isLongPress = true
					else
						allDone = false
					end
				end
			end
			if allDone then
				scheduler:unscheduleScriptEntry(id)
			end
			end, EDDebug)
		end
		return handler
	end
	class.longPress = longPress
	local doLongPress = function(self, x, y)
		self:cancelLongPress()
		self.longPressId = self.listScheduler:scheduleScriptFunc(self:longPress(x, y), 0, false)
	end
	class.doLongPress = doLongPress
	local cancelLongPress = function(self)
		if self.longPressId then
			self.listScheduler:unscheduleScriptEntry(self.longPressId)
			self.longPressId = nil
		end
	end
	class.cancelLongPress = cancelLongPress
	local getTouchArea = function(self)
		local rect = self.actualrect or self.cliprect
		local pos = rect.origin
		pos = self.layer:convertToWorldSpace(pos)
		local wRect = CCRectMake(pos.x, pos.y, rect.size.width, rect.size.height)
		return wRect
	end
	class.getTouchArea = getTouchArea
	local getTouchAreaWithOffset = function(self)
		local actualrect = self.actualrect or self.cliprect
		local apos = actualrect.origin
		apos = self.layer:convertToWorldSpace(apos)
		local asize = actualrect.size
		local oo = self.outoffset or {}
		local outw = oo.width or 0
		local outh = oo.height or 0
		local newRect = CCRectMake(apos.x - outw, apos.y - outh, asize.width + 2 * outw, asize.height + 2 * outh)
		return newRect
	end
	class.getTouchAreaWithOffset = getTouchAreaWithOffset
	local function doListLayerTouch(self, event, x, y)
		if tolua.isnull(self.listLayer) then
			return
		end
		self:doScrollbarTouch(event, x, y)
		local wRect = self:getTouchArea()
		if event == "began" then
			self.isPressing = true
			self.dragMode = false
			if not wRect:containsPoint(ccp(x, y)) then
				return
			end
			self.isPressInRect = true
			self:doLongPress(x, y)
			local actionNumber = self.listLayer:numberOfRunningActions()
			self.listLayer:stopAllActions()
			if self.doPressIn then
				if actionNumber == 0 then
					self.pressElement, self.pressParam = self.doPressIn(x, y)
				elseif math.abs(self.speedX or 0) < 60 then
					if 60 > math.abs(self.speedY or 0) then
						self.pressElement, self.pressParam = self.doPressIn(x, y)
						self.speedX = 0
						self.speedY = 0
					end
				end
			end
			self.offset = drag()
			self.pressPos = ccp(x, y)
			if not self.getSpeedid then
				local speed = self:getSpeed()
				self.getSpeedid = self.listScheduler:scheduleScriptFunc(speed, 0, false)
			end
		elseif event == "moved" then
			if not self.isPressInRect then
				return
			end
			if not self.getSpeedid then
				local speed = self:getSpeed()
				self.getSpeedid = self.listScheduler:scheduleScriptFunc(speed, 0, false)
			end
			if not self.pressPos then
				self.pressPos = ccp(x, y)
			end
			local dx = x - self.pressPos.x
			local dy = y - self.pressPos.y
			local dis = math.sqrt(dx * dx + dy * dy)
			if dis > 7 and (self.canDragX or self.canDragY) then
				self.dragMode = true
			end
			if self.dragMode then
				self:cancelLongPress()
				if self.onSwitchToDragMode then
					self.onSwitchToDragMode()
				end
				if self.canDragY and not self.noshade then
					self:setVShadeVisible(true, true)
				end
				if self.canDragX and not self.noshade then
					self:setHShadeVisible(true, true)
				end
				if self.cancelClickIn and self.pressElement then
					self.cancelClickIn(x, y, self.pressElement, self.pressParam)
				end
				if not self.offset then
					self.offset = drag()
				end
				local lox = self.oriPosX
				local loy = self.oriPosY
				local rw = self.width
				local rh = self.height
				local lw = self.listWidth
				local lh = self.listHeight
				local dx, dy = self.offset(x, y)
				local px, py = self.listLayer:getPosition()
				local coefficient = k_coefficient
				if self.canDragY then
					if loy > py or py > lh - rh + loy then
						if loy > py then
							coefficient = coefficient * (1 - (loy - py) / rh)
						end
						if py > lh - rh + loy then
							coefficient = coefficient * (1 - (py - (lh - rh + loy)) / rh)
						end
						dy = dy * coefficient
					end
					self.listLayer:setPosition(px, py + dy)
				end
				coefficient = k_coefficient
				px, py = self.listLayer:getPosition()
				if self.canDragX then
					if lox < px or px < lox + rw - lw then
						if lox < px then
							coefficient = coefficient * (1 - (px - lox) / rw)
						end
						if px < lox + rw - lw then
							coefficient = coefficient * (1 - (lox + rw - lw - px) / rw)
						end
						dx = dx * coefficient
					end
					self.listLayer:setPosition(px + dx, py)
				end
			end
		elseif event == "ended" then
			self.isPressing = nil
			self:cancelLongPress()
			self:refreshShade()
			if self.cancelPressIn and self.pressElement then
				self.cancelPressIn(x, y, self.pressElement, self.pressParam)
			end
			if not self.dragMode and wRect:containsPoint(ccp(x, y)) and not self.isLongPress and self.doClickIn and self.pressElement then
				self.doClickIn(x, y, self.pressElement, self.pressParam)
			end
			local newRect = self:getTouchAreaWithOffset()
			local isPressIn
			if not self.pressPos then
				isPressIn = false
			else
				isPressIn = newRect:containsPoint(self.pressPos)
			end
			if not newRect:containsPoint(ccp(x, y)) and not isPressIn and self.doClickOut then
				self.doClickOut(x, y)
			end
			if self.pressPos then
				self:listEaseBackOut(x, y)
			end
			self.offset = nil
			self.pressPos = nil
			self.pressElement = nil
			self.pressParam = nil
			self.isPressInRect = nil
			self.isLongPress = nil
		end
	end
	class.doListLayerTouch = doListLayerTouch
	local getListLayerTouchHandler = function(self)
		self:setTouchEnabled(false)
		local function handler(event, x, y)
			self:doListLayerTouch(event, x, y)
		end
		return handler
	end
	class.getListLayerTouchHandler = getListLayerTouchHandler
	local setTouchEnabled = function(self, b)
		b = b or false
		self.mainLayer:setTouchEnabled(b)
	end
	class.setTouchEnabled = setTouchEnabled
	local doMainLayerTouch = function(self)
		local function handler(event, x, y)
			xpcall(function()
				self:doListLayerTouch(event, x, y)
				end, EDDebug)
				return true
			end
			return handler
		end
		class.doMainLayerTouch = doMainLayerTouch
		local showScrollbar = function(self, index)
			index = index or 1
			local sb = self.scrollbar[index]
			sb.barBg:setVisible(true)
			sb.bar:setVisible(true)
		end
		class.showScrollbar = showScrollbar
		local hideScrollbar = function(self, index)
			index = index or 1
			local sb = self.scrollbar[index]
			sb.barBg:setVisible(false)
			sb.bar:setVisible(false)
		end
		class.hideScrollbar = hideScrollbar
		local initScrollbar = function(self, info)
			self:createScrollbar(info)
		end
		class.initScrollbar = initScrollbar
		local resetScrollbar = function(self, index, needReset)
			local function resetScrollbarByid(i)
				local sb = self.scrollbar[i]
				self:setBarSize(i, needReset)
				self:setBarPosition(i, needReset)
				if needReset ~= false then
					if not tolua.isnull(sb.barBg) then
						sb.barBg:stopAllActions()
					end
					if not tolua.isnull(sb.bar) then
						sb.bar:stopAllActions()
						self:setBarVisible(false, i)
						if sb.updateBar then
							sb.bar:getScheduler():unscheduleScriptEntry(sb.updateBar)
						end
					end
					sb.updateBar = nil
				end
			end
			if not self.noshade then
				if self.canDragY then
					self:setVShadeVisible(false, false)
					if self.listHeight > self.height then
						self:setShadedownVisible(true)
					end
				end
				if self.canDragX then
					self:setHShadeVisible(false, false)
					if self.listWidth > self.width then
						self:setShaderightVisible(true)
					end
				end
			end
			if not index then
				for i = 1, #(self.scrollbar or {}) do
					resetScrollbarByid(i)
				end
			else
				resetScrollbarByid(index)
			end
		end
		class.resetScrollbar = resetScrollbar
		local setBarVisible = function(self, isVisible, index)
			index = index or 1
			local opacity = 0
			if isVisible then
				opacity = 255
			else
				opacity = 0
			end
			local sb = self.scrollbar[index]
			sb.barBg:setOpacity(opacity)
			sb.bar:setOpacity(opacity)
		end
		class.setBarVisible = setBarVisible
		local function setBarPosition(self, index, needReset)
			index = index or 1
			local sb = self.scrollbar[index]
			if not sb.bgAnchor then
				sb.bgAnchor = ccp(0.5, 0.5)
			end
			if tolua.isnull(sb.barBg) or tolua.isnull(sb.bar) then
				print("scrollbar has not been create yet")
				return
			end
			sb.barBg:setAnchorPoint(sb.bgAnchor)
			sb.barBg:setPosition(sb.bgPos)
			local anchor = sb.bgAnchor
			local bgPos = sb.bgPos
			local bd = sb.barDirection
			sb.bar:setAnchorPoint(ccp(0.5, 0.5))
			if bd == k_vertical then
				local bbh = sb.barBgHeight
				local bh = sb.barHeight
				local center = bgPos.y + bbh * (0.5 - anchor.y)
				sb.center = center
				sb.top = center + bbh / 2
				sb.bottom = center - bbh / 2
				sb.barOriX = bgPos.x
				sb.barOriY = sb.top - bh / 2
				sb.barTop = sb.top - bh / 2
				sb.barBottom = sb.bottom + bh / 2
				if needReset ~= false then
					sb.bar:setPosition(bgPos.x, sb.top - bh / 2)
				end
			elseif bd == k_horizontal then
				local bbw = sb.barBgWidth
				local bw = sb.barWidth
				local center = bgPos.x + bbw * (0.5 - anchor.x)
				sb.center = center
				sb.left = center - bbw / 2
				sb.right = center + bbw / 2
				sb.barOriX = sb.left + bw / 2
				sb.barOriY = bgPos.y
				sb.barLeft = sb.left + bw / 2
				sb.barRight = sb.right - bw / 2
				if needReset ~= false then
					sb.bar:setPosition(sb.left + bw / 2, bgPos.y)
				end
			end
		end
		class.setBarPosition = setBarPosition
		local function setBarSize(self, index, needReset)
			index = index or 1
			if not self.scrollbar then
				return
			end
			local sb = self.scrollbar[index]
			if not sb then
				return
			end
			if tolua.isnull(sb.barBg) or tolua.isnull(sb.bar) then
				print("scrollbar has not been create yet")
				return
			end
			local bd = sb.barDirection
			if bd == k_vertical then
				local listHeight = self.listHeight or self.height
				local height = self.height
				listHeight = math.max(listHeight, height)
				local bbh = sb.barBgHeight
				local bh = bbh * (height / listHeight)
				sb.oriScale = bh / sb.bar:getContentSize().height
				if needReset ~= false then
					sb.bar:setScaleY(sb.oriScale)
				end
				sb.barHeight = bh
				sb.canShow = height < listHeight
			elseif bd == k_horizontal then
				local listWidth = self.listWidth or self.width
				local width = self.width
				listWidth = math.max(listWidth, width)
				local sb = self.scrollbar[index]
				local bbw = sb.barBgWidth
				local bw = bbw * (width / listWidth)
				sb.oriScale = bw / sb.bar:getContentSize().width
				if needReset ~= false then
					sb.bar:setScaleX(sb.oriScale)
				end
				sb.barWidth = bw
				sb.canShow = self.listWidth > self.width
			end
		end
		class.setBarSize = setBarSize
		local function createScrollbar(self, info)
			local direction = info.direction
			local index = info.index
			index = index or 1
			if not self.scrollbar then
				self.scrollbar = {}
			end
			if not self.scrollbar[index] then
				self.scrollbar[index] = {}
			end
			local sb = self.scrollbar[index]
			direction = direction or k_vertical
			if direction == "horizontal" then
				direction = k_horizontal
			elseif direction == "vertical" then
				direction = k_vertical
			end
			sb.barDirection = direction
			local bgres = info.bgres
			local barres = info.barres
			local barThick = info.barthick
			local bgThick = info.bgthick
			local bgLength = info.bglen
			local bgPos = info.bgpos or ccp(0, 0)
			local bgAnchor = info.bganchor or ccp(0.5, 0.5)
			sb.bgPos = bgPos
			sb.bgAnchor = bgAnchor
			if tolua.isnull(sb.barBg) then
				sb.barBg = ed.createSprite(bgres)
			else
				sb.barBg:removeFromParentAndCleanup(true)
				sb.barBg = ed.createSprite(bgres)
			end
			if tolua.isnull(sb.bar) then
				sb.bar = ed.createSprite(barres)
			else
				sb.bar:removeFromParentAndCleanup(true)
				sb.bar = ed.createSprite(barres)
			end
			local function recreateNode(array, key)
				local node = CCSprite:create()
				local size = array[key]:getContentSize()
				size = ed.swapSizewh(size)
				node:setContentSize(size)
				array[key]:setRotation(90)
				array[key]:setPosition(ed.getCenterPos(node))
				node:addChild(array[key])
				array[key] = node
				node:setCascadeOpacityEnabled(true)
			end
			if direction == k_horizontal then
				recreateNode(sb, "barBg")
				recreateNode(sb, "bar")
			end
			if direction == k_horizontal then
				local bgWidth = bgLength or self.width
				local barWidth = bgWidth
				local bg = sb.barBg
				local bar = sb.bar
				local size = bg:getContentSize()
				bg:setScaleX(bgWidth / size.width)
				bg:setScaleY(bgThick / size.height)
				size = bar:getContentSize()
				bar:setScaleX(barWidth / size.width)
				bar:setScaleY(barThick / size.height)
				sb.barBgWidth = bgWidth
				sb.barBgHeight = bgThick
				sb.barWidth = barWidth
				sb.barHeight = barThick
			elseif direction == k_vertical then
				local bgHeight = bgLength or self.height
				local barHeight = bgHeight
				local bg = sb.barBg
				local bar = sb.bar
				local size = bg:getContentSize()
				bg:setScaleX(bgThick / size.width)
				bg:setScaleY(bgHeight / size.height)
				size = bar:getContentSize()
				bar:setScaleX(barThick / size.width)
				bar:setScaleY(barHeight / size.height)
				sb.barBgWidth = bgThick
				sb.barBgHeight = bgHeight
				sb.barWidth = barThick
				sb.barHeight = barHeight
			end
			self.layer:addChild(sb.barBg)
			self.layer:addChild(sb.bar)
		end
		class.createScrollbar = createScrollbar
		local function refreshBar(self, index)
			index = index or 1
			local sb = self.scrollbar[index]
			if not sb.canShow then
				return
			end
			local px, py = self:getListPos()
			local bd = sb.barDirection
			local countStop = 0
			local scheduler = sb.bar:getScheduler()
			local id
			local function refresh(dt)
				xpcall(function()
					if tolua.isnull(self.listLayer) then
						if id then
							scheduler:unscheduleScriptEntry(id)
						end
						return
					end
					if bd == k_vertical then
						if not self.listHeight then
							return
						end
						if self.listLayer:getPositionY() == py then
							countStop = countStop + 1
						else
							countStop = 0
						end
						if not id and sb.updateBar then
							id = sb.updateBar
						end
						if countStop > 5 and self.scrollbar.isEnded and self.listLayer:numberOfRunningActions() == 0 then
							if sb.updateBar then
								scheduler:unscheduleScriptEntry(sb.updateBar)
							end
							sb.updateBar = nil
							local fadeout = CCFadeOut:create(0.5)
							sb.barBg:runAction(fadeout)
							fadeout = CCFadeOut:create(0.5)
							sb.bar:runAction(fadeout)
						end
						local dy = (self.listLayer:getPositionY() - self.oriPosY) * (sb.barBgHeight / self.listHeight)
						local pos = ccp(sb.barOriX, sb.barOriY - dy)
						self:refreshBarPosition(index, pos)
					elseif bd == k_horizontal then
						if not self.listWidth then
							return
						end
						if self.listLayer:getPositionX() == px then
							countStop = countStop + 1
						else
							countStop = 0
						end
						if not id and sb.updateBar then
							id = sb.updateBar
						end
						if countStop > 5 and self.scrollbar.isEnded and self.listLayer:numberOfRunningActions() == 0 then
							if sb.updateBar then
								scheduler:unscheduleScriptEntry(sb.updateBar)
							end
							sb.updateBar = nil
							local fadeout = CCFadeOut:create(0.5)
							sb.barBg:runAction(fadeout)
							fadeout = CCFadeOut:create(0.5)
							sb.bar:runAction(fadeout)
						end
						local dx = (self.listLayer:getPositionX() - self.oriPosX) * (sb.barBgWidth / self.listWidth)
						local pos = ccp(sb.barOriX - dx, sb.barOriY)
						self:refreshBarPosition(index, pos)
					end
					px, py = self.listLayer:getPosition()
					end, EDDebug)
				end
				return refresh
		end
		class.refreshBar = refreshBar
		local refreshBarScroll = function(self, isVisible, index)
			local index = index or 1
			local sb = self.scrollbar[index]
			local bar = sb.bar
			local bg = sb.barBg
			local scheduler = bar:getScheduler()
			if isVisible then
				if not sb.isFadeIn and bar:getOpacity() ~= 255 then
					sb.isFadeIn = true
					local fade = CCFadeIn:create(0.5)
					local func = CCCallFunc:create(function()
						xpcall(function()
							sb.isFadeIn = false
							end, EDDebug)
						end)
						local s1 = CCSequence:createWithTwoActions(fade, func)
						bar:runAction(s1)
						fade = CCFadeIn:create(0.5)
						func = CCCallFunc:create(function()
							xpcall(function()
								sb.isFadeIn = false
								end, EDDebug)
							end)
							local s2 = CCSequence:createWithTwoActions(fade, func)
							bg:runAction(s2)
						end
						if not sb.updateBar then
							local refresh = self:refreshBar(index)
							if refresh then
								sb.updateBar = scheduler:scheduleScriptFunc(refresh, 0, false)
							end
						end
					end
			end
			class.refreshBarScroll = refreshBarScroll
			local function refreshBarPosition(self, index, pos)
				index = index or 1
				local list = self.listLayer
				local sb = self.scrollbar[index]
				local bar = sb.bar
				local bg = sb.barBg
				local bd = sb.barDirection
				local rw, rh = self.width, self.height
				local lw, lh = self.listWidth, self.listHeight
				local lx, ly = list:getPosition()
				local ox, oy = self.oriPosX, self.oriPosY
				local box, boy = sb.barOriX, sb.barOriY
				local bw, bh = sb.barWidth, sb.barHeight
				local osc = sb.oriScale
				if bd == k_vertical then
					if ly < oy then
						local scaleExtra = 1 - (oy - ly) / rh
						bar:setAnchorPoint(ccp(0.5, 1))
						bar:setPosition(box, boy + bh / 2)
						bar:setScaleY(osc * scaleExtra)
					elseif ly > oy + lh - rh then
						local scaleExtra = 1 - (ly - (oy + lh - rh)) / rh
						bar:setAnchorPoint(ccp(0.5, 0))
						bar:setPosition(box, sb.barBottom - bh / 2)
						bar:setScaleY(osc * scaleExtra)
					else
						bar:setAnchorPoint(ccp(0.5, 0.5))
						bar:setPosition(pos)
						bar:setScaleY(osc)
					end
				elseif bd == k_horizontal then
					if lx > ox then
						local scaleExtra = 1 - (lx - ox) / rw
						bar:setAnchorPoint(ccp(0, 0.5))
						bar:setPosition(sb.barLeft - bw / 2, boy)
						bar:setScaleX(osc * scaleExtra)
					elseif lx < ox - lw + rw then
						local scaleExtra = 1 - (ox - lw + rw - lx) / rw
						bar:setAnchorPoint(ccp(1, 0.5))
						bar:setPosition(sb.barRight + bw / 2, boy)
						bar:setScaleX(osc * scaleExtra)
					else
						bar:setAnchorPoint(ccp(0.5, 0.5))
						bar:setPosition(pos)
						bar:setScaleX(osc)
					end
				end
			end
			class.refreshBarPosition = refreshBarPosition
			local doScrollbarTouch = function(self, event, x, y)
				if #(self.scrollbar or {}) == 0 then
					return
				end
				local sb = self.scrollbar
				local rect = self:getTouchArea()
				local isin = rect:containsPoint(ccp(x, y))
				if event == "began" then
					if not isin then
						return
					end
					sb.isEnded = false
				elseif event == "moved" then
					if not isin then
						return
					end
					sb.isEnded = false
					if self.dragMode then
						for i = 1, #sb do
							self:refreshBarScroll(true, i)
						end
					end
				elseif event == "ended" then
					sb.isEnded = true
				end
			end
			class.doScrollbarTouch = doScrollbarTouch
			local setFrameRect = function(self, node, rect)
				if node ~= nil and node.setFrameRect ~= nil then
					node:setFrameRect(rect)
				end
			end
			class.setFrameRect = setFrameRect
			local setParentClipRect = function(self, node, rect)
				if node ~= nil and node.setParentClipRect ~= nil then
					node:setParentClipRect(rect)
				end
			end
			class.setParentClipRect = setParentClipRect
			local setParentClipNode = function(self, node, parentClipNode)
				if node ~= nil and node.setParentClipNode ~= nil then
					node:setParentClipNode(parentClipNode)
				end
				self:setParentClipRect(node, self.cliprect)
			end
			class.setParentClipNode = setParentClipNode
			local setClipItemAnchorPt = function(self, node, pt)
				if node ~= nil and node.setClipItemAnchorPt then
					node:setClipItemAnchorPt(pt)
				end
			end
			class.setClipItemAnchorPt = setClipItemAnchorPt
			local function checkTouchInList(self, x, y)
				local rect = self.cliprect
				if ed.isPointInRect(rect, x, y) then
					return true
				end
				return false
			end
			class.checkTouchInList = checkTouchInList
							
local size = (CCEGLView and CCEGLView:sharedOpenGLView():getFrameSize()) or {width = 800, height = 480}

local antiAlias = (size.width ~= 800 and size.height ~= 480) or (size.width ~= 480 and size.height ~= 800)
local ed = ed
ed.cha_scale = 0.09
ed.cha_ui_scale = 0.39
if LegendSetAniScaleFactor then
	LegendSetAniScaleFactor(ed.cha_scale)
end
local function getSpriteFrame(resource, isUI)
	if not resource then
		return nil
	end
	local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resource)
	if not frame then
		local format
		local config = ed.lookupDataTable("TextureConfig", resource)
		local doCache = true
		if config then
			format = config.PixelFormat
			format = format and _G[format]
			doCache = not config.NoCache
		end
		local texture
		if format then
			texture = CCTextureCache:sharedTextureCache():addImage(resource, format)
		else
			texture = CCTextureCache:sharedTextureCache():addImage(resource)
		end
		if not texture then
			return nil
		end
		local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
		frame = CCSpriteFrame:createWithTexture(texture, rect)
		if doCache then
			CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFrame(frame, resource)
		else
			CCTextureCache:sharedTextureCache():removeTextureForKey(resource)
		end
	end
	return frame
end
ed.getSpriteFrame = getSpriteFrame
local function getSpriteOriginalScale(resource)
	local config = ed.lookupDataTable("TextureConfig", resource)
	if not config then
		return 1
	end
	if EDFLAGWIN32 and not config.Prescaled then
		return 1
	end
	if config.ContentScale == 0 then
		return 1
	end
	return config.ContentScale
end
ed.getSpriteOriginalScale = getSpriteOriginalScale
local function createSprite(resource)
	local frame = ed.getSpriteFrame(resource)
	if frame then
		local spr = CCSprite:createWithSpriteFrame(frame)
		local scale = getSpriteOriginalScale(resource)
		spr:setScale(scale)
		return spr
	else
		LegendLog("Failed to creating sprite from " .. (resource or "nil"))
		return CCSprite:create()
	end
end
ed.createSprite = createSprite
local function initSpriteWithFrame(sprite, resource)
	local frame = ed.getSpriteFrame(resource)
	if frame then
		sprite:initWithSpriteFrame(frame)
	end
end
ed.initSpriteWithFrame = initSpriteWithFrame
local function createScale9Sprite(res, capInsets)
	local frame = ed.getSpriteFrame(res)
	if not capInsets then
		local size = frame:getRect().size
		capInsets = CCRectMake(size.width / 3, size.height / 3, size.width / 3, size.height / 3)
	end
	local sprite = CCScale9Sprite:createWithSpriteFrame(frame, capInsets)
	return sprite
end
ed.createScale9Sprite = createScale9Sprite
local function createMultiSprite(resource)
	local frame = ed.getSpriteFrame(resource)
	if frame then
		return CCMultiSprite:createWithSpriteFrame(frame)
	else
		LegendLog("[resource_manager.lua|createMultiSprite] Failed to creating sprite from " .. (resource or "nil"))
		return CCMultiSprite:create()
	end
end
ed.createMultiSprite = createMultiSprite
local function createFcaNode(resource, aniType)
	local isUI = string.match(resource, "^eff_UI")
	if isUI then
		LegendSetAniScaleFactor(ed.cha_ui_scale)
	else
		LegendSetAniScaleFactor(ed.cha_scale)
	end
	print("[resource_manager.lua|createFcaNode] "..resource)
	local node = nil;
	if aniType and aniType == Type_Spine then
		node = ed.createAnimation(resource, 1.0, aniType);
		node:setAction("Start");
		node:setNextAction("Loop");
		node:setLoop(true);
	else
		node = LegendAminationEffect:create(resource)
	end
	LegendSetAniScaleFactor(ed.cha_scale)
	return node
end
ed.createFcaNode = createFcaNode
local function createFcaActor(resource)
	local isUI = string.match(resource, "^eff_UI")
	if isUI then
		resource = "effect/" .. resource
		LegendSetAniScaleFactor(ed.cha_ui_scale)
	else
		LegendSetAniScaleFactor(ed.cha_scale)
	end
	local node = LegendAnimation:create(resource, 1)
	LegendSetAniScaleFactor(ed.cha_scale)
	return node
end
ed.createFcaActor = createFcaActor
local function createClippingNodeOnly(stencil, alphaThreshold)
	if nil == stencil then
		return
	end
	alphaThreshold = alphaThreshold or 0.5
	local cn = CCClippingNode:create()
	local stencil = ed.createSprite(stencil)
	cn:setStencil(stencil)
	cn:setAlphaThreshold(alphaThreshold)
	cn:setCascadeOpacityEnabled(true)
	return cn
end
ed.createClippingNodeOnly = createClippingNodeOnly
local function createClippingNode(res, stencil, alphaThreshold, setSize)
	local ClippingNode = createClippingNodeOnly(stencil, alphaThreshold)
	if nil == ClippingNode then
		return
	end
	local sprite = ed.createSprite(res)
	sprite:setAnchorPoint(ccp(0.5, 0.5))
	local size = sprite:getContentSize()
	local ow, oh = 0, 0
	if setSize then
		ow = setSize.width
		oh = setSize.height
	end
	local stencil = ClippingNode:getStencil()
	local ss = stencil:getContentSize()
	stencil:setScaleX((size.width + ow) / ss.width)
	stencil:setScaleY((size.height + oh) / ss.height)
	ClippingNode:addChild(sprite)
	return ClippingNode, sprite
end
ed.createClippingNode = createClippingNode
local function createLabelTTF(text, size, font, skipFormat)
	if not skipFormat then
		text = ed.formatText(text)
	end
	text = text or ""
	assert(text, "the text of the label must not be nil. @ resource_manager")
	local label
	if not font then
		label = CCLabelTTF:create(text, ed.font, size)
	else
		label = CCLabelTTF:create(text, font, size)
	end
	return label
end
ed.createLabelTTF = createLabelTTF
local function setLabelFontInfo(label, info)
	if nil == label then
		return
	end
	if nil == info then
		return
	end
	local fontInfo = EDTables.fontconfigs[info]
	if fontInfo == nil then
		print("fontInfo:" .. info .. "no found!!")
		return
	end
	if fontInfo.color then
		label:setColor(fontInfo.color)
	end
	if fontInfo.strokeColor then
		ed.setLabelStroke(label, fontInfo.strokeColor, fontInfo.strokeSize)
	end
	if fontInfo.shadowColor then
		ed.setLabelShadow(label, fontInfo.shadowColor, fontInfo.shadowOffset)
	end
end
ed.setLabelFontInfo = setLabelFontInfo
local function createLabelWithFontInfo(text, info, size)
	if nil == info then
		return
	end
	local fontInfo = EDTables.fontconfigs[info]
	if fontInfo == nil then
		print("fontInfo:" .. info .. "no found!!")
		return
	end
	font = ed.font
	if fontInfo.font then
		font = fontInfo.font
	end
	
	if not size then
		size = fontInfo.size
	end
	
	local label = ed.createLabelTTF("", size,font)
	setLabelFontInfo(label, info)
	ed.setLabelString(label, text)
	return label
end
ed.createLabelWithFontInfo = createLabelWithFontInfo
local function setLabelString(label, text, skipFormat)
	if tolua.isnull(label) then
		return
	end
	if not text then
		return
	end
	if not skipFormat then
		text = ed.formatText(text)
	end
	label:setString(text)
end
ed.setLabelString = setLabelString
local function createttf(text, size, font)
	return ed.createLabelTTF(text, size, font, true)
end
ed.createttf = createttf
local function setString(label, text)
	if not label then
		return
	end
	if not text then
		return
	end
	if not label.setString then
		return
	end
	if type(label) == "userdata" then
		ed.setLabelString(label, text, true)
	elseif type(label) == "table" then
		label:setString(text)
	end
end
ed.setString = setString
local setLabelShadow = function(label, color, offset)
	if tolua.isnull(label) then
		return
	end
	label:setShadow(color, offset)
end
ed.setLabelShadow = setLabelShadow
local setLabelStroke = function(label, color, size)
	if tolua.isnull(label) then
		return
	end
	label:setStroke(color, size)
end
ed.setLabelStroke = setLabelStroke
local setLabelColor = function(label, color)
	if tolua.isnull(label) then
		return
	end
	label:setColor(color)
end
ed.setLabelColor = setLabelColor
local setLabelDimensions = function(label, dimensions)
	if tolua.isnull(label) then
		return
	end
	label:setDimensions(dimensions)
end
ed.setLabelDimensions = setLabelDimensions
local function createFrameAnim(list, delay)
	delay = delay or 0.041666666666666664
	local spr
	local array = CCArray:createWithCapacity(#list)
	for i, v in ipairs(list) do
		spr = spr or createSprite(v)
		local frame = ed.getSpriteFrame(v)
		array:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(array, delay)
	local anim = CCAnimate:create(animation)
	return spr, anim
end
ed.createFrameAnim = createFrameAnim
local loadSpriteSheet = function(xml_file)
	local xfile = xml.load(xml_file)
	local xaltas = xfile:find("TextureAtlas")
	local texture = CCTextureCache:sharedTextureCache():addImage(xaltas.imagePath)
	for i = 1, #xaltas do
		local xsprite = xaltas[i]
		local rect = CCRectMake(xsprite.x, xsprite.y, xsprite.w, xsprite.h)
		xsprite.oX = xsprite.oX or 0
		xsprite.oY = xsprite.oY or 0
		local offset = ccp(xsprite.oX, xsprite.oY)
		xsprite.oW = xsprite.oW or xsprite.w
		xsprite.oH = xsprite.oH or xsprite.h
		local originSize = CCSize(xsprite.oW, xsprite.oH)
		local rotated = xsprite.r == "y"
		local frame = CCSpriteFrame:createWithTexture(texture, rect, rotated, offset, originSize)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFrame(frame, xsprite.n)
	end
end
function createAnimateWithFrameNames(name_list, delay)
	if not name_list then
		return nil
	end
	delay = delay or 0.08333333333333333
	local array = CCArray:create()
	for i = 1, #name_list do
		local frame = ed.getSpriteFrame(name_list[i])
		array:addObject(frame)
	end
	local animation = CCAnimation:createWithSpriteFrames(array, delay)
	return CCAnimate:create(animation)
end
ed.createAnimateWithFrameNames = createAnimateWithFrameNames
local setSpriteGray = function(sprite)
	local shader = CCShaderCache:sharedShaderCache():programForKey("GrayScalingShader")
	sprite:setShaderProgram(shader)
	sprite:getShaderProgram():use()
end
ed.setSpriteGray = setSpriteGray
local resetSpriteShader = function(sprite)
	local s = CCSprite:create()
	sprite:setShaderProgram(s:getShaderProgram())
	sprite:getShaderProgram():use()
end
ed.resetSpriteShader = resetSpriteShader
local setSpriteBlur = function(sprite, radius)
	local shader = CCShaderCache:sharedShaderCache():programForKey("Blur")
	sprite:setShaderProgram(shader)
	sprite:getShaderProgram():use()
	local size = sprite:getTexture():getContentSizeInPixels()
	local width = size.width
	local height = size.height
	local location = sprite:getShaderProgram():getUniformLocationForName("blurSize")
	sprite:getShaderProgram():setUniformsForBuiltins()
	sprite:getShaderProgram():setUniformLocationWith2f(location, 1 / width * radius, 1 / height * radius)
end
ed.setSpriteBlur = setSpriteBlur
local createSpriteBlur = function(sprite, radius)
	local shader = CCGLProgram:createWithFileName("shader/Blur.vsh", "shader/Blur.fsh")
	sprite:setShaderProgram(shader)
	sprite:getShaderProgram():use()
	local size = sprite:getTexture():getContentSizeInPixels()
	local width = size.width
	local height = size.height
	local location = sprite:getShaderProgram():getUniformLocationForName("blurSize")
	sprite:getShaderProgram():setUniformsForBuiltins()
	sprite:getShaderProgram():setUniformLocationWith2f(location, 1 / width * radius, 1 / height * radius)
end
ed.setSpriteBlur = setSpriteBlur
local function horizontalArrange(nodes, param)
	param = param or {}
	local mode = param.type or "center"
	local fix_height = param.fix_height
	local fix_width = param.fix_width
	local fix_size
	if fix_height or fix_width then
		fix_size = CCSizeMake(fix_width or 0, fix_height or 0)
	end
	local n1
	if type(nodes[1]) == "table" then
		n1 = nodes[1].node
	else
		n1 = nodes[1]
	end
	local height = param.height or n1:getContentSize().height * math.min(n1:getScale(), n1:getScaleY())
	local ns = {}
	local container = CCSprite:create()
	container:setCascadeOpacityEnabled(true)
	local addWidth = 0
	for i = 1, #(nodes or {}) do
		local node = nodes[i]
		local offset = 0
		if type(node) == "table" then
			offset = node.offset
			node = node.node
		end
		node:setAnchorPoint(ccp(0, 0.5))
		ed.fixNodeSize(node, fix_size)
		if i == 1 then
			node:setPosition(ccp(0, height / 2))
		else
			local pn
			if type(nodes[i - 1]) == "table" then
				pn = nodes[i - 1].node
			else
				pn = nodes[i - 1]
			end
			ed.right2(node, pn, offset)
			addWidth = addWidth + (offset or 0)
		end
		table.insert(ns, node)
		container:addChild(node)
	end
	local width = ed.sumNodeSize(ns) + addWidth
	container:setContentSize(CCSizeMake(width, height))
	return container
end
ed.horizontalArrange = horizontalArrange
local function verticalArrange(nodes, param)
	param = param or {}
	local mode = param.type or "center"
	local fix_height = param.fix_height
	local fix_width = param.fix_width
	local fix_size
	if fix_height or fix_width then
		fix_size = CCSizeMake(fix_width or 0, fix_height or 0)
	end
	local n1
	if type(nodes[1]) == "table" then
		n1 = nodes[1].node
	else
		n1 = nodes[1]
	end
	local ns = {}
	local container = CCSprite:create()
	container:setCascadeOpacityEnabled(true)
	local addHeight = 0
	local maxWidth = 0
	for i = 1, #(nodes or {}) do
		local node = nodes[i]
		local offset = 0
		if type(node) == "table" then
			offset = node.offset
			node = node.node
		end
		node:setAnchorPoint(ccp(0, 1))
		ed.fixNodeSize(node, fix_size)
		local nodeSize = node:getContentSize()
		local w = nodeSize.width
		maxWidth = math.max(w, maxWidth)
		if i == 1 then
			node:setPosition(ccp(0, 0))
		else
			local pn
			if type(nodes[i - 1]) == "table" then
				pn = nodes[i - 1].node
			else
				pn = nodes[i - 1]
			end
			ed.below2(node, pn, offset)
			addHeight = addHeight + (offset or 0)
		end
		table.insert(ns, node)
		container:addChild(node)
	end
	local tw, height = ed.sumNodeSize(ns)
	height = height + addHeight
	local vNode = CCSprite:create()
	vNode:setContentSize(CCSizeMake(maxWidth, height))
	container:setAnchorPoint(ccp(0, 0))
	container:setPosition(ccp(0, height))
	vNode:addChild(container)
	vNode:setCascadeOpacityEnabled(true)
	return vNode
end
ed.verticalArrange = verticalArrange
local function getHeadIcon(param)
	param = param or {}
	local id = param.id
	local res
	if id then
		local row = ed.getDataTable("Avatar")[id]
		if not row then
			return
		end
		res = row.Picture
	else
		res = param.res or ed.player:getHeadIconRes()
	end
	local length = param.length or 70
	local head, headicon = ed.createClippingNode(res, "UI/alpha/HVGA/main_head_mask.png", nil, CCSizeMake(-10, -10))
	local size = headicon:getContentSize()
	local len = size.width
	head:setScale(length / size.width)
	return head, headicon
end
ed.getHeadIcon = getHeadIcon
local function getTeamHead(param)
	param = param or {}
	local state = param.type
	local vip = param.vip
	local length = param.length
	param.length = nil
	local head, headicon = ed.getHeadIcon(param)
	if tolua.isnull(headicon) then
		return
	end
	local container = CCSprite:create()
	local size = headicon:getContentSize()
	container:setContentSize(size)
	local center = ed.getCenterPos(container)
	local frameres = vip and "UI/alpha/HVGA/main_head_frame_gold.png" or "UI/alpha/HVGA/main_head_frame_silver.png"
	frameres = --[[not state or state == "vip" and --]]"UI/alpha/HVGA/main_head_frame_gold.png" or "UI/alpha/HVGA/main_head_frame_silver.png"
	local frame = ed.createSprite(frameres)
	head:setPosition(ccp(center.x-3,center.y+2))
	container:addChild(head)
	frame:setPosition(ccpAdd(center, ccp(13, -1)))
	container:addChild(frame)
	if length then
		container:setScale(length / size.width)
	end
	return container
end
ed.getTeamHead = getTeamHead
local function getLevelIcon(param)
	param = param or {}
	if not param.level then
		return
	end
	local level = param.level or 1
	local state = param.type or "common"
	local vip = param.vip
	local frameres = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
	if vip then
		frameres = "UI/alpha/HVGA/pvp/main_head_level_bg_gold.png"
	end
	local frame = ed.createSprite(frameres)
	local size = frame:getContentSize()
	local container = CCSprite:create()
	container:setContentSize(size)
	local center = ed.getCenterPos(container)
	frame:setPosition(center)
	container:addChild(frame)
	local levelLabel = ed.createLabelTTF(level, 20)
	center.y = center.y + 1
	levelLabel:setPosition(center)
	container:addChild(levelLabel)
	ed.setLabelColor(levelLabel, ccc3(255, 255, 228))
	return container, levelLabel
end
ed.getLevelIcon = getLevelIcon
local function getHeroIconByID(param)
	param = param or {}
	local hid = param.hid
	local id = param.id or 1
	local vip = param.vip
	local length = param.length
	local head = CCSprite:create()
	head:setContentSize(CCSizeMake(80, 80))
	local res
	if hid then
		local ut = ed.getDataTable("Unit")
		local row = ut[hid]
		if not row then
			return
		end
		res = row.Portrait
	else
		local at = ed.getDataTable("Avatar")
		local row = at[id]
		if not row then
			return
		end
		res = row.Picture
	end
	local param = {res = res, length = length}
	local icon = ed.getHeadIcon(param)
	icon:setPosition(ccp(40, 40))
	head:addChild(icon)
	local fres = "UI/alpha/HVGA/main_head_frame_silver.png"
	if vip then
		fres = "UI/alpha/HVGA/main_head_frame_gold.png"
	end
	local frame = ed.createSprite(fres)
	frame:setPosition(ccp(55, 38))
	head:addChild(frame)
	return head, frame
end
ed.getHeroIconByID = getHeroIconByID
local getPosition = function(icon)
	return icon:getPosition()
end
local getContentSize = function(icon)
	return icon:getContentSize()
end
local function getWholeHeadIcon(param)
	local node = CCNode:create()
	local headIcon = getHeroIconByID(param)
	if param.scale then
		headIcon:setScale(param.scale)
	end
	node:addChild(headIcon)
	local x, y = getPosition(headIcon)
	local size = getContentSize(headIcon)
	if param.name then
		local nameBg = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_name_bg.png")
		nameBg:setAnchorPoint(ccp(0, 0.5))
		nameBg:setPosition(ccp(x + 8 + size.width / 2, y + 2))
		local paration = 28
		local font = "guild_join_list_guildname"
		if param.config then
			paration = param.config.nameposition
			font = param.config.namefont
		end
		
		local name = ed.createLabelWithFontInfo(param.name, font)
		name:setAnchorPoint(ccp(0, 0.5))
		name:setPosition(ccp(x + paration + size.width / 2, y + 2))
		if param.nameWidth and name:getContentSize().width > param.nameWidth then
			name:setScale(param.nameWidth / name:getContentSize().width)
		end
		node:addChild(nameBg)
		node:addChild(name)
	end
	local levelIcon = getLevelIcon(param)
	if levelIcon then
		local paration = 8
		if param.config then
			paration = param.config.levelposition
		end
		levelIcon:setAnchorPoint(ccp(0.5, 0.5))
		levelIcon:setPosition(ccp(x + paration + size.width / 2, y + 2))
		node:addChild(levelIcon)
	end
	return node
end
ed.getWholeHeadIcon = getWholeHeadIcon
local scaleNodeBySideLen = function(node, type, len)
	local size = node:getContentSize()
	local w = size.width
	local h = size.height
	if type == "w" then
		node:setScale(len / w)
	elseif type == "h" then
		node:setScale(len / h)
	end
end
ed.scaleNodeBySideLen = scaleNodeBySideLen
local fixNodeSize = function(node, size)
	if not size then
		return
	end
	local ns = node:getContentSize()
	local nw, nh = ns.width, ns.height
	local w, h = size.width, size.height
	if w > 0 then
		node:setScaleX(w / nw)
	end
	if h > 0 then
		node:setScaleY(h / nh)
	end
end
ed.fixNodeSize = fixNodeSize
local sumNodeSize = function(nodes)
	local w, h = 0, 0
	for k, v in pairs(nodes) do
		local size = v:getContentSize()
		local sx = v:getScaleX()
		local sy = v:getScaleY()
		w = w + size.width * sx
		h = h + size.height * sy
	end
	return w, h
end
ed.sumNodeSize = sumNodeSize
local getCenterPos = function(node)
	if tolua.isnull(node) then
		print("getCenterPos : invalid node")
		return
	end
	local size = node:getContentSize()
	local w, h = size.width, size.height
	return ccp(w / 2, h / 2)
end
ed.getCenterPos = getCenterPos
local left2Point = function(node, pos, offset)
	if tolua.isnull(node) then
		print("left2Point : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	local sx = node:getScaleX()
	node:setPosition(ccpAdd(pos, ccp(-size.width * sx * (1 - anchor.x) - offset, 0)))
end
ed.left2Point = left2Point
local function left2(node, refer, offset)
	if tolua.isnull(node) then
		print("left2 : invalid node")
		return
	end
	local pos = ed.getLeftSidePos(refer, offset)
	ed.left2Point(node, pos)
end
ed.left2 = left2
local getLeftSidePos = function(node, offset)
	if tolua.isnull(node) then
		print("getLeftSidePos : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local x, y = node:getPosition()
	local size = node:getContentSize()
	local sx = node:getScaleX()
	x = x - anchor.x * size.width * sx - offset
	return ccp(x, y)
end
ed.getLeftSidePos = getLeftSidePos
local right2Point = function(node, pos, offset)
	if tolua.isnull(node) then
		print("right2Point : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	local sx = node:getScaleX()
	node:setPosition(ccpAdd(pos, ccp(size.width * sx * anchor.x + offset, 0)))
end
ed.right2Point = right2Point
local function right2(node, refer, offset)
	if tolua.isnull(node) then
		print("right2 : invalid node")
		return
	end
	local pos = ed.getRightSidePos(refer, offset)
	ed.right2Point(node, pos)
end
ed.right2 = right2
local getRightSidePos = function(node, offset)
	if tolua.isnull(node) then
		print("getRightSidePos : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local x, y = node:getPosition()
	local size = node:getContentSize()
	local sx = node:getScaleX()
	x = x + (1 - anchor.x) * size.width * sx + offset
	return ccp(x, y)
end
ed.getRightSidePos = getRightSidePos
local below2Point = function(node, pos, offset)
	if tolua.isnull(node) then
		print("below2Point : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	local sy = node:getScaleY()
	node:setPosition(ccpAdd(pos, ccp(0, -size.height * sy * (1 - anchor.y) - offset)))
end
ed.below2Point = below2Point
local function below2(node, refer, offset)
	if tolua.isnull(node) then
		print("below2 : invalid node")
		return
	end
	local pos = ed.getBottomPos(refer, offset)
	ed.below2Point(node, pos)
end
ed.below2 = below2
local getBottomPos = function(node, offset)
	if tolua.isnull(node) then
		print("getBottomPos : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local x, y = node:getPosition()
	local size = node:getContentSize()
	local sy = node:getScaleY()
	y = y - anchor.y * size.height * sy - offset
	return ccp(x, y)
end
ed.getBottomPos = getBottomPos
local above2Point = function(node, pos, offset)
	if tolua.isnull(node) then
		print("above2Point : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	local sy = node:getScaleY()
	node:setPosition(ccpAdd(pos, ccp(0, size.height * sy * anchor.y + offset)))
end
ed.above2Point = above2Point
local function above2(node, refer, offset)
	if tolua.isnull(node) then
		print("above2 : invalid node")
		return
	end
	local pos = ed.getTopSidePos(refer, offset)
	ed.above2Point(node, pos)
end
ed.above2 = above2
local getTopSidePos = function(node, offset)
	if tolua.isnull(node) then
		print("getTopSidePos : invalid node")
		return
	end
	offset = offset or 0
	local anchor = node:getAnchorPoint()
	local x, y = node:getPosition()
	local size = node:getContentSize()
	local sy = node:getScaleY()
	y = y + anchor.y * size.height * sy + offset
	return ccp(x, y)
end
ed.getTopSidePos = getTopSidePos
local setNodeAnchor = function(node, anchor)
	if node == nil then
		return
	end
	local a = node:getAnchorPoint()
	local ax, ay = a.x, a.y
	local x, y = node:getPosition()
	local size = node:getContentSize()
	local w, h = size.width, size.height
	local cax, cay = anchor.x, anchor.y
	local cx, cy = x, y
	cx = cx - w * (ax - cax)
	cy = cy - h * (ay - cay)
	node:setAnchorPoint(anchor)
	node:setPosition(ccp(cx, cy))
end
ed.setNodeAnchor = setNodeAnchor
local function getExcavateNameTag(typeid)
	local row = ed.getDataTable("ExcavateTreasure")[typeid]
	if not row then
		return nil
	end
	local tag_res = {
	Diamond = "UI/alpha/HVGA/chat/chat_icon_treasure_diamond.png",
	Gold = "UI/alpha/HVGA/chat/chat_icon_treasure_gold.png",
	Item = "UI/alpha/HVGA/chat/chat_icon_treasure_exp.png"
	}
	local container = CCSprite:create()
	container:setCascadeOpacityEnabled(true)
	local produce = row["Produce Type"]
	local name = row["Display Name"]
	local scope = row["Max Player"] or 1
	local ui = {}
	local readnode = ed.readnode.create(container, ui)
	local ui_info = {
	{
	t = "HorizontalNode",
	base = {name = "tag"},
	layout = {
	anchor = ccp(0, 0),
	layout = ccp(0, 0)
	},
	config = {},
	ui = {
	{
	t = "Label",
	base = {
	name = "1",
	text = "【",
	size = 20
	},
	config = {
	color = ccc3(255, 255, 102)
	}
	},
	{
	t = "Sprite",
	base = {
	name = "2",
	res = tag_res[produce]
	}
	},
	{
	t = "Label",
	base = {
	name = "3",
	text = name .. "】",
	size = 20
	},
	config = {
	color = ccc3(255, 255, 102)
	}
	},
	{
	t = "Label",
	base = {
	name = "4",
	text = T("(%d", scope) .. LSTR("RESOURCE_MANAGER.HUMAN_BEINGS") .. ")",
	size = 20
	},
	config = {
	color = ccc3(255, 255, 102)
	}
	}
	}
	}
	}
	readnode:addNode(ui_info)
	container:setContentSize(ui.tag:getContentSize())
	return container
end
ed.getExcavateNameTag = getExcavateNameTag
local function createNode(param, parent, z)
	local node = ed.readnode.getFeralNode(param)
	if not tolua.isnull(parent) then
		parent:addChild(node, z or 0)
	end
	return node
end
ed.createNode = createNode

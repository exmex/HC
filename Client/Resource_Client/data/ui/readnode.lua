local ed = ed
local class = {
mt = {}
}
class.mt.__index = class
ed.readnode = class

local DGLen = function(len)
	return len / 1.28
end
ed.DGLen = DGLen

local DGRectMake = function(x, y, w, h)
	local s = 0.78125
	return CCRectMake(x * s, y * s, w * s, h * s)
end
ed.DGRectMake = DGRectMake

local DGSizeMake = function(w, h)
	local s = 0.78125
	return CCSizeMake(w * s, h * s)
end
ed.DGSizeMake = DGSizeMake

local DGccp = function(x, y)
	local s = 0.78125
	local pos = ccp(x, y)
	return ccpMult(pos, s)
end
ed.DGccp = DGccp

local function create(root, array)
	local self = {}
	setmetatable(self, class.mt)
	if root then
		self:initRoot(root)
	end
	if array then
		self:initArray(array)
	end
	return self
end
class.create = create

function class.createWithLayer(layer)
	local self = {}
	setmetatable(self, class.mt)
	if layer.mainLayer then
		self:initRoot(layer.mainLayer)
	end
	if layer.uiControllers then
		self:initArray(layer.uiControllers)
	end
	self.panelLayer = layer
	return self
end

function class:setListItemPanel(panel)
	self.listItemPanel = panel
end

local init = function(self, root, array)
	self.root = root
	self.array = array
end
class.init = init

local initRoot = function(self, root)
	self.root = root
end
class.initRoot = initRoot

local initArray = function(self, array)
	self.array = array
end
class.initArray = initArray

local function set(self, node, info)
	if not node then
		print("node can not be nil![readnode.lua-set] : " .. (info.base.name or ""))
		return
	end
	local base = info.base
	self:setConfig(node, info)
	if not base.feral then
		self:setBase(node, info)
	else
		if base.feralArray then
			base.feralArray[base.name] = node
		end
		if ed.isElementInTable(base.extraType, {"horizontal", "vertical"}) then
			self:setBaseArrange(node, info)
		end
	end
	if base.isGetFeral then
		self.feralNode = node
	end
	self:setLayout(node, info)
end
class.set = set

local setBaseArrange = function(self, node, info)
	local base = info.base
	local n = {
	node = node,
	offset = base.offset
	}
	if base.array then
		table.insert(base.array, n)
	else
		table.insert(self.array, n)
	end
end
class.setBaseArrange = setBaseArrange

local function setConfig(self, node, info)
	local config = info.config
	local ttype = info.t
	if not config then
		return
	end
	if config.isCascadeOpacity then
		node:setCascadeOpacityEnabled(true)
	end
	if config.opacity and node.setOpacity then
		node:setOpacity(config.opacity)
	end
	if config.visible ~= nil then
		if config.visible then
			node:setVisible(true)
		else
			node:setVisible(false)
		end
	end
	if config.flip then
		if config.flip == "x" then
			node:setFlipX(true)
		elseif config.flip == "y" then
			node:setFlipY(true)
		elseif config.flip == "xy" then
			node:setFlipX(true)
			node:setFlipY(true)
		end
	end
	if config.scale then
		local os = node:getScale()
		node:setScale(config.scale * os)
	end
	if config.scalexy then
		local osx, osy = node:getScaleX(), node:getScaleY()
		node:setScaleX((config.scalexy.x or 1) * osx)
		node:setScaleY((config.scalexy.y or 1) * osy)
	end
	if config.dimension then
		node:setDimensions(config.dimension)
	end
	if config.dimensions then
		node:setDimensions(config.dimensions)
	end
	if config.color then
		node:setColor(config.color)
	end
	if config.horizontalAlignment then
		node:setHorizontalAlignment(config.horizontalAlignment)
	end
	if config.verticalAlignment then
		node:setVerticalAlignment(config.verticalAlignment)
	end
	if config.scaleSize then
		node:setContentSize(config.scaleSize)
	end
	if config.messageRect then
		node:setMessageRect(config.messageRect)
	end
	if config.rotation then
		node:setRotation(config.rotation)
	end
	if config.textureRect then
		node:setTextureRect(config.textureRect)
	end
	if config.shadow then
		node:setShadow(config.shadow.color, config.shadow.offset)
	end
	if config.stroke then
		ed.setLabelStroke(node, config.stroke.color, config.stroke.size)
	end
	if ttype ~= "Label" then
		if config.fix_size then
			node:setScaleX(config.fix_size.width / node:getContentSize().width)
			node:setScaleY(config.fix_size.height / node:getContentSize().height)
		end
		if config.fix_height then
			local ss = config.fix_height / node:getContentSize().height
			node:setScale(ss)
		end
		if config.fix_width then
			local ss = config.fix_width / node:getContentSize().width
			node:setScale(ss)
		end
		if config.fix_wh then
			local wh = config.fix_wh
			if wh.w then
				local sw = wh.w / node:getContentSize().width
				node:setScaleX(sw)
			end
			if wh.h then
				local sh = wh.h / node:getContentSize().height
				node:setScaleY(sh)
			end
		end
	end
end
class.setConfig = setConfig

local function setLayout(self, node, info)
	local layout = info.layout
	if not layout then
		return
	end
	if layout.anchor then
		node:setAnchorPoint(layout.anchor)
	end
	if layout.position then
		node:setPosition(layout.position)
	end
	if layout.rect then
		node:setTextureRect(layout.rect)
	end
	if layout.mediate then
		local offset = layout.offset or ccp(0, 0)
		local parent = node:getParent()
		local size = parent:getContentSize()
		node:setPosition(ccpAdd(ccp(size.width / 2, size.height / 2), offset))
	end
	if layout.right2 then
		local info = layout.right2
		local array = info.array or self.array
		local refer = array[info.name]
		local offset = info.offset or 0
		ed.right2(node, refer, offset)
	end
end
class.setLayout = setLayout

local setBase = function(self, node, info)
	local base = info.base
	if not base then
		return
	end
	if base.parent then
		if base.parentArray then
			local parent = base.parentArray[base.parent]
			if not tolua.isnull(parent) then
				parent:addChild(node, base.z or 0)
			end
		elseif self.array then
			local parent = self.array[base.parent]
			if parent and not tolua.isnull(parent) then
				parent:addChild(node, base.z or 0)
			end
		end
	else
		if not tolua.isnull(self.root) then
			self.root:addChild(node, base.z or 0)
		end
	end
	if base.name then
		if base.array then
			base.array[base.name] = node
		elseif self.array then
			self.array[base.name] = node
		end
	else
	end
end
class.setBase = setBase

local addCCNode = function(self, info)
	local base = info.base
	local node = base.node
	self:set(node, info)
end
class.addCCNode = addCCNode

local function addSprite(self, info)
	local base = info.base or {}
	local node
	if not base.res or type(base.res) ~= "string" then
		node = CCSprite:create()
	else
		node = ed.createSprite(base.res)
	end
	self:set(node, info)
end
class.addSprite = addSprite

local function addScale9Sprite(self, info)
	local base = info.base
	local node
	if not base.res then
		node = CCScale9Sprite:create()
	elseif type(base.res) == "string" then
		local sf = ed.getSpriteFrame(base.res)
		node = CCScale9Sprite:createWithSpriteFrame(sf, base.capInsets)
	end
	self:set(node, info)
end
class.addScale9Sprite = addScale9Sprite

local function addLabel(self, info)
	local base = info.base
	local font, size
	if not base.font then
		font = ed.font
	else
		font = base.font
	end
	if not base.size then
		size = 30
	else
		size = base.size
	end
	if not base.text then
		return
	end
	local node
	if info.base.fontinfo then
		if base.size then
			node = ed.createLabelWithFontInfo("", info.base.fontinfo, base.size)
		else
			node = ed.createLabelWithFontInfo("", info.base.fontinfo)
		end
	else
		node = CCLabelTTF:create("", font, size)
	end
	self:set(node, info)
	ed.setString(node, base.text)
	local nodeW = node:getContentSize().width
	if base.max_width and nodeW > base.max_width then
		local ww = base.max_width / nodeW
		node:setScale(ww)
	end
end
class.addLabel = addLabel

--add by xinghui
local function addHtmlLabel(self, info)
	local base =  info.base	
	local vsize = CCDirector:sharedDirector():getVisibleSize()
	local text = ""
	if base.size then
		vsize = base.size
	end
	if (base.text~=nil) and ("" ~= base.text) then
		text = base.text					
	else			
		str_utf8 = CCString:createWithContentsOfFile(LegendFindFileForLua(base.file))	
		text = 	str_utf8:getCString()				
	end		
	local size = CCSize(vsize.width, vsize.height)	
	local node = CCHTMLLabel:createWithString(text, size)		
	self:set(node, info)	
	local nodeW = node:getContentSize().width
    if base.max_width and nodeW > base.max_width then
	  local ww = base.max_width / nodeW
	  node:setScale(ww)
    end	
end
class.addHtmlLabel = addHtmlLabel
--

local addRichText = function(self, info)
	local text = richText:new()
	local rootNode = text:getRootNode()
	local base = info.base
	if base.parent then
		if base.parentArray then
			base.parentArray[base.parent]:addChild(rootNode, base.z or 0)
		elseif self.array and self.array[base.parent] then
			self.array[base.parent]:addChild(rootNode, base.z or 0)
		end
	else
		self.root:addChild(rootNode, base.z or 0)
	end
	if info.base.name and self.array then
		self.array[info.base.name] = text
	end
	self:setLayout(text:getRootNode(), info)
	if info.base.middle == true then
		text:setMiddle(true)
	end
	if info.layout and info.layout.anchor then
		text:setAnchor(info.layout.anchor)
	end
	if info.base.text ~= nil and info.base.text ~= "" then
		text:setString(info.base.text)
	end
end
class.addRichText = addRichText

local function addButton(self, info)
	local base = info.base
	local normalres, pressres, disabledres = base.normal, base.press, base.disabled
	pressres = pressres or normalres
	disabledres = disabledres or normalres
	local sf, normal, press, disabled
	local sf = ed.getSpriteFrame(normalres)
	normal = CCSprite:createWithSpriteFrame(sf)
	sf = ed.getSpriteFrame(pressres)
	press = CCSprite:createWithSpriteFrame(sf)
	sf = ed.getSpriteFrame(disabledres)
	disabled = CCSprite:createWithSpriteFrame(sf)
	local item = CCMenuItemSprite:create(normal, press, disabled)
	if base.name then
		if base.array then
			base.array[base.name .. "_item"] = item
		elseif self.array then
			self.array[base.name .. "_item"] = item
		end
	else
	end
	self:setConfig(item, info)
	if info.layout.anchor then
		item:setAnchorPoint(info.layout.anchor)
	end
	local node = CCMenu:createWithItem(item)
	self:setBase(node, info)
	self:setLayout(node, info)
end
class.addButton = addButton

local addColorLayer = function(self, info)
	local base = info.base
	local node = CCLayerColor:create(base.color)
	self:set(node, info)
end

class.addColorLayer = addColorLayer

local addLayer = function(self, info)
	local node = CCLayer:create()
	self:set(node, info)
end
class.addLayer = addLayer

function class:addClippingNode(info)
	if nil == info then
		return
	end
	local base = info.base
	if nil == base then
		return
	end
	local clippNode = ed.createClippingNodeOnly(base.stencil, base.alphaThreshold)
	if nil == clippNode then
		return
	end
	local stencil = clippNode:getStencil()
	if stencil and base.scalexy then
		stencil:setScaleX(base.scalexy.x)
		stencil:setScaleY(base.scalexy.y)
	end
	if stencil and info.layout and info.layout.anchor then
		stencil:setAnchorPoint(info.layout.anchor)
	end
	self:set(clippNode, info)
end

function class:addSpriteButton(info)
	local button = spriteButton:new(info)
	local base = info.base
	if self.panelLayer then
		self.panelLayer:addButton(button, base)
	elseif self.listItemPanel then
		self.listItemPanel:addButton(button, base)
	end
end

function class:addCheckButton(info)
	local button = checkButton:new(info)
	local base = info.base
	if self.panelLayer then
		self.panelLayer:addButton(button, base)
	end
end

function class:addScale9CheckButton(info)
	local button = Scale9CheckButton:new(info)
	local base = info.base
	if self.panelLayer then
		self.panelLayer:addButton(button, base)
	end
end

function class:addScale9Button(info)
	local button = Scale9Button:new(info)
	local base = info.base
	if self.panelLayer then
		self.panelLayer:addButton(button, base)
	elseif self.listItemPanel then
		self.listItemPanel:addButton(button, base)
	end
	return button
end

function class:addListView(info)
	if self.panelLayer then
		local parent = self.panelLayer.mainLayer
		local base = info.base
		if base.parent and self.panelLayer.uiControllers[base.parent] then
			parent = self.panelLayer.uiControllers[base.parent]
		end
		local list = listView:new(info, parent)
		self.panelLayer:addListView(list, info.base)
	end
end

function class:addEditTTF(info)
	local edit = editTTF:new(info)
	local base = info.base
	if base.parent then
		if self.array and self.array[base.parent] then
			self.array[base.parent]:addChild(edit.edit, base.z or 0)
		end
	else
		self.root:addChild(edit.edit, base.z or 0)
	end
	if self.panelLayer then
		self.panelLayer:addEditTTF(edit, info.base)
	end
end

function class:addEditBox(info)
	local edit = editBox:new(info)
	local base = info.base
	self.root:addChild(edit.edit, base.z or 0)
	if self.panelLayer then
		self.panelLayer:addEditBox(edit, info.base)
	end
end

function class:addFcaEffect(info)
	local scene = ed.getCurrentScene()
	local scale
	if info.config then
		scale = info.config.scale
	end
	local node = ed.createFcaNode(info.base.res)
	if info.base.action then
		node:setStartAction(info.base.action)
	end
	if self.panelLayer then
		self.panelLayer.panelData.scene:addFca(node)
	end
	self:set(node, info)
end

function class:addFacActor(info)
	local actor = LegendAnimation:create(info.base.res, 1)
	self:set(actor, info)
	if self.panelLayer then
		self.panelLayer.panelData.scene:addFca(actor)
	end
end

local function addHorizontalNode(self, info)
	if #(info.ui or {}) < 1 then
		return
	end
	local base = info.base or {}
	local ui_info = info.ui
	local array = base.nodeArray
	local nodes = {}
	local readnode = ed.readnode.create(nil, nodes)
	for i = 1, #ui_info do
		local nu = ui_info[i]
		nu.base.oriName = nu.base.name or i
		nu.base.name = i
		nu.base.feral = true
		nu.base.extraType = "horizontal"
		nu.base.offset = nu.base.offset or base.offset
	end
	readnode:addNode(ui_info)
	local node = ed.horizontalArrange(nodes)
	if base.contentSize then
		local pn = CCSprite:create()
		pn:setContentSize(base.contentSize)
		node:setPosition(ed.getCenterPos(pn))
		pn:addChild(node)
		node = pn
	end
	if base.contentWidth then
		local pn = CCSprite:create()
		local size = node:getContentSize()
		pn:setContentSize(CCSizeMake(base.contentWidth, size.height))
		node:setPosition(ed.getCenterPos(pn))
		pn:addChild(node)
		node = pn
	end
	self:set(node, info)
	for i = 1, #ui_info do
		if array then
			array[ui_info[i].base.oriName] = type(nodes[i]) == "table" and nodes[i].node or nodes[i]
		end
	end
end
class.addHorizontalNode = addHorizontalNode

local function addVerticalNode(self, info)
	if #(info.ui or {}) < 1 then
		return
	end
	local base = info.base or {}
	local ui_info = info.ui
	local array = base.nodeArray
	local nodes = {}
	local readnode = ed.readnode.create(nil, nodes)
	for i = 1, #ui_info do
		local nu = ui_info[i]
		nu.base = nu.base or {}
		nu.base.oriName = nu.base.name or i
		nu.base.name = i
		nu.base.feral = true
		nu.base.extraType = "vertical"
		nu.base.offset = nu.base.offset or base.offset
	end
	readnode:addNode(ui_info)
	local node = ed.verticalArrange(nodes)
	self:set(node, info)
	for i = 1, #ui_info do
		if array then
			array[ui_info[i].base.oriName] = type(nodes[i]) == "table" and nodes[i].node or nodes[i]
		end
	end
end
class.addVerticalNode = addVerticalNode

local function addChaosNode(self, info)
	local base = info.base
	local width = base.width or 800
	local array = base.nodeArray or {}
	local padding = base.offset
	local ui_info = info.ui
	for li, lv in ipairs(ui_info) do
		for i, v in ipairs(lv) do
			if v.t ~= "Label" then
				local node = class.getFeralNode(v)
				ui_info[li][i] = {
				t = "CCNode",
				base = {
				name = v.base.name,
				node = node,
				offset = v.base.offset
				}
				}
			end
		end
	end
	local index = 1
	while index <= #ui_info do
		do
			local line = ui_info[index]
			local function splitLine(ii)
				if ii > 1 then
					local newLine = {}
					for i = ii, #line do
						table.insert(newLine, line[i])
						line[i] = nil
					end
					table.insert(ui_info, index + 1, newLine)
				end
			end
			local w = 0
			local it = 1
			while it <= #line do
				local info = line[it]
				if info.t == "CCNode" then
					local node = info.base.node
					local nw = node:getContentSize().width * node:getScaleX()
					if width < w + nw then
						if w == 0 then
							splitLine(it + 1)
							break
						end
						splitLine(it)
						break
					else
						w = w + nw + (info.base.offset or 0)
						if width < w then
							splitLine(it)
							break
						end
					end
				elseif info.t == "Label" then
					local text = info.base.text
					text = tostring(text)
					local size = info.base.size
					local len = ed.stringutil.len(text)
					local multiline = false
					if info.config.dimension or info.config.dimensions then
						multiline = true
					end
					
					if not multiline and width < w + ed.stringutil.getTextureLen(text, size) then
						local iit = ed.stringutil.getSplitPoint(text, size, width - w)
						if iit == 0 then
							if w == 0 then
								splitLine(it + 1)
								break
							end
							splitLine(it)
							break
						else
							local new_info = ed.copyTable(info)
							local text_1, text_2 = ed.stringutil.splitString(text, iit)
							info.base.text = text_1
							new_info.base.text = text_2
							info.base.baseName = info.base.baseName or info.base.name
							info.base.nameIndex = info.base.nameIndex or 1
							new_info.base.baseName = info.base.baseName
							new_info.base.nameIndex = info.base.nameIndex + 1
							new_info.base.name = new_info.base.baseName .. "_" .. new_info.base.nameIndex
							if text_2 then
								table.insert(line, it + 1, new_info)
							end
							splitLine(it + 1)
							break
						end
					else
						w = w + size * len + (info.base.offset or 0)
					end
				end
				it = it + 1
			end
			index = index + 1
		end
	end
	local vui = {}
	for i, v in ipairs(ui_info) do
		local hui = v
		local param = {
		t = "HorizontalNode",
		base = {
		name = "line_" .. i,
		nodeArray = array,
		offset = hui.offset,
		contentSize = hui.contentSize
		},
		layout = {},
		config = {},
		ui = hui
		}
		table.insert(vui, param)
	end
	local param = {
	t = "VerticalNode",
	base = {
	name = "node",
	nodeArray = array,
	offset = padding
	},
	layout = info.layout,
	config = info.config,
	ui = vui
	}
	local node = class.getFeralNode(param)
	self:set(node, info)
end
class.addChaosNode = addChaosNode

local function addDGButton(self, info)
	local ui_info = {}
	local base = info.base
	local layout = info.layout
	local config = info.config
	local labelConfig = config.labelConfig
	local pressConfig = config.pressConfig
	pressConfig = pressConfig or {}
	pressConfig.visible = pressConfig.visible or false
	pressConfig.scaleSize = pressConfig.scaleSize or config.scaleSize
	local ct = base.capInsets and "Scale9Sprite" or "Sprite"
	local cb = {
	name = base.name,
	res = base.normal,
	capInsets = base.capInsets,
	parent = base.parent,
	z = base.z
	}
	local cl = {
	anchor = layout.anchor,
	position = layout.position
	}
	local cc = config
	table.insert(ui_info, {
	t = ct,
	base = cb,
	layout = cl,
	config = cc
	})
	cb = {
	name = base.name .. "_press",
	res = base.press,
	capInsets = base.capInsets,
	parent = base.name
	}
	cl = {
	anchor = ccp(0, 0),
	position = ccp(0, 0)
	}
	cc = pressConfig
	pressConfig.flip = config.flip
	local node = ed.createSprite(base.press)
	table.insert(ui_info, {
	t = ct,
	base = cb,
	layout = cl,
	config = cc
	})
	if base.text then
		ct = "Label"
		cb = {
		name = base.name .. "_label",
		text = base.text,
		size = base.size,
		fontinfo = base.fontinfo,
		parent = base.name
		}
		local size = node:getContentSize()
		cl = {
		mediate = true,
		offset = layout.offset
		}
		cc = labelConfig
		table.insert(ui_info, {
		t = ct,
		base = cb,
		layout = cl,
		config = cc
		})
	end
	self:addNode(ui_info)
end
class.addDGButton = addDGButton

local function addNode(self, node, z)
	z = z or 0
	for k, v in pairs(node) do
		if type(v) == "table" then
			local zOrder
			zOrder = v.base and (v.base.z or z)
			if not ed.readnode["add" .. v.t] then
				print("the method add" .. v.t .. " is not existed![readNode.lua-addNode]")
			else
				ed.readnode["add" .. v.t](self, v)
			end
		end
	end
end
class.addNode = addNode

local function getFeralNode(param)
	param.base = param.base or {}
	param.base.isGetFeral = true
	param.base.feral = true
	if not ed.readnode["add" .. param.t] then
		print("the method add" .. param.t .. " is not existed![readNode.lua-addNode]")
	else
		local self = ed.readnode.create()
		ed.readnode["add" .. param.t](self, param)
		return self.feralNode
	end
end
class.getFeralNode = getFeralNode

local function editorui(config, addition)
	addition = addition or {}
	local isShade = addition.isShade
	local container = addition.container or isShade and CCLayerColor:create(ccc4(0, 0, 0, 150)) or CCLayer:create()
	local ui = addition.ui or {}
	local readnode = ed.readnode.create(container, ui)
	readnode:addNode(config)
	return container, ui
end
ed.editorui = editorui

local function addNode(self, node, z)
	z = z or 0
	if not self.cn then
		self.cn = {}
	end
	for k, v in pairs(node) do
		local zorder = z
		if v.z then
			zorder = v.z
		end
		ed["read" .. v.t](self, v, zorder)
	end
end
ed.addNode = addNode

local function loadccbi(target,ccbifile)
	if target == nil then
		return nil;
	end
	local ccb = CCBContainer:create();
	ccb:loadCcbiFile(ccbifile);
	if target.onRegisterFunction ~= nil then
		ccb:registerFunctionHandler(target.onRegisterFunction);
	end
	
	return ccb;
end
ed.loadccbi = loadccbi;

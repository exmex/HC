local class = newclass()
ed.ui.shortcut = class
local res = ed.ui.uires
local sc_touch_priority = -16
local button_ori_pos = ccp(res.shortcut_pos_x, res.shortcut_pos_y)

local function getButtonPos(index)
	return ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[index])
end

local button_info = {
						{
						key = "heroPackage",
						normal = "UI/alpha/HVGA/main_hero_button.png",
						press = "UI/alpha/HVGA/main_hero_button_shade.png",
						buttonPos = getButtonPos(1),
						tagPos = ccp(75, 65)
						},
						{
						key = "package",
						normal = "UI/alpha/HVGA/main_package_button.png",
						press = "UI/alpha/HVGA/main_package_button_shade.png",
						buttonPos = getButtonPos(2),
						tagPos = ccp(75, 65)
						},
						{
						key = "fragment",
						normal = "UI/alpha/HVGA/main_fragment_button.png",
						press = "UI/alpha/HVGA/main_fragment_button_shade.png",
						buttonPos = getButtonPos(3),
						tagPos = ccp(68, 60)
						},
						{
						key = "task",
						identity = "a window",
						normal = "UI/alpha/HVGA/main_task_button.png",
						press = "UI/alpha/HVGA/main_task_button_shade.png",
						buttonPos = getButtonPos(4),
						tagPos = ccp(75, 65)
						},
						{
						key = "todoList",
						identity = "task",
						normal = "UI/alpha/HVGA/main_menu_todolist_1.png",
						press = "UI/alpha/HVGA/main_menu_todolist_2.png",
						buttonPos = getButtonPos(5),
						tagPos = ccp(70, 60)
						}
}

local getTouchNode = function(self)
	if not self.scTouchNode then
		local touchNode = ed.ui.basetouchnode.btCreate()
		self.scTouchNode = touchNode
	end
	return self.scTouchNode
end

local getuiList = function(self)
	self.sc_ui = self.sc_ui or {}
	return self.sc_ui
end

local getContainer = function(self)
	if tolua.isnull(self.frameworkLayer) then
		self.frameworkLayer = CCLayer:create()
		self.mainLayer:addChild(self.frameworkLayer, 100)
	end
	return self.frameworkLayer
end

local function getInfoContainer(self)
	local container = getContainer(self)
	if tolua.isnull(self.infoLayer) then
		local infoLayer = CCSprite:create()
		infoLayer:setCascadeOpacityEnabled(true)
		container:addChild(infoLayer, 100)
		self.infoLayer = infoLayer
	end
	return self.infoLayer
end

local getSCContainer = function(self)
	if tolua.isnull(self.scContainer) then
		local container = CCSprite:create()
	end
end

local destroyShadeLayer = function(self)
	if not tolua.isnull(self.scShadeLayer) then
		self.scShadeLayer:removeFromParentAndCleanup(true)
	end
end
class.destroyShortcutLayer = destroyShortcutLayer

local function createShadeLayer(self)
	destroyShadeLayer(self)
	local layer
	if self.identity == "main" then
		layer = CCLayer:create()
	else
		layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
		do
			local handler = self:doShortcut()
			local touchNode = getTouchNode(self)
			touchNode:btRegisterOutClick({
			rectArea = res.shortcut_board_rect,
			key = "out_board",
			clickHandler = function()
				if self.isShortcutOpen then
					handler()
				end
			end,
			priority = sc_touch_priority,
			force = true
			})
			layer:setTouchEnabled(true)
			layer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -10, true)
		end
	end
	self.infoLayer:addChild(layer, 50)
	layer:setTouchEnabled(true)
	self.scShadeLayer = layer
end

local function refreshTags(self)
	local ui = getuiList(self)
	local info = button_info
	local isShowTag = false
	for i = 1, #info do
		local element = info[i]
		key = element.key
		local handler = self:getCheckSCTagHandler(key)
		local isShow = handler()
		isShowTag = isShowTag or isShow
		ui[key .. "_tag"]:setVisible(isShow)
	end
	local tag = ui.tag
	if self.isShortcutOpen then
		tag:setVisible(false)
	else
		tag:setVisible(isShowTag)
	end
end

local function registerButtonTouchHandler(self)
	local ui = getuiList(self)
	local info = button_info
	for i = 1, #info do
		do
			local element = info[i]
			local key = element.key
			if self.identity ~= key then
				local info = {
				button = ui[key],
				press = ui[key .. "_press"],
				key = key,
				clickHandler = function()
					local handler = self:getSCButtonTouchHandler(key)
					handler()
				end,
				priority = sc_touch_priority - i
				}
				self:btRegisterButtonClick(info)
				getTouchNode(self):btRegisterButtonClick(info)
			end
		end
	end
end

local function getButtons(self)
	local ui = getuiList(self)
	local buttons = {}
	for i = 1, #button_info do
		table.insert(buttons, ui[button_info[i].key])
	end
	return buttons
end

local function createButtons(self)
	local ui = getuiList(self)
	local container = self.shortcutLayer
	local isOpen = self.isShortcutOpen
	local info = button_info
	local readnode = ed.readnode.create(container, ui)
	local ui_info = {}
	for i = 1, #info do
		local element = info[i]
		local key = element.key
		local identity = element.identity or key
		local normal = element.normal
		local press = element.press
		local tag = "UI/alpha/HVGA/main_deal_tag.png"
		local bpos = element.buttonPos
		local tPos = element.tagPos
		table.insert(ui_info, {
		t = "Sprite",
		base = {
		name = key,
		res = normal,
		z = 10
		},
		layout = {
		position = isOpen and bpos or button_ori_pos
		},
		config = {isCascadeOpacity = true}
		})
		table.insert(ui_info, {
		t = "Sprite",
		base = {
		name = key .. "_press",
		res = press,
		parent = key
		},
		layout = {
		anchor = ccp(0, 0),
		position = ccp(0, 0)
		},
		config = {
		visible = self.identity == key
		}
		})
		table.insert(ui_info, {
		t = "Sprite",
		base = {
		name = key .. "_tag",
		res = tag,
		parent = key
		},
		layout = {position = tPos}
		})
	end
	readnode:addNode(ui_info)
	registerButtonTouchHandler(self)
	if not isOpen then
		for i = 1, #info do
			ui[info[i].key]:setOpacity(0)
		end
	else
		createShadeLayer(self)
	end
	container:registerScriptHandler(function(event)
		if event == "enter" then
			local ui = getuiList(self)
			local info = button_info
			if not self.isShortcutOpen then
				for i = 1, #info do
					ui[info[i].key]:setOpacity(0)
				end
			end
		end
	end)
	refreshTags(self)
end

local function createBoard(self)
	local ui = getuiList(self)
	self.shortcutButton = nil
	self.isShortcutOpen = nil
	self.isShortcutOpen = self.identity == "main"
	if self:checkFirstInMain() then
		self.isShortcutOpen = false
	end
	local shortcutContainer = CCSprite:create()
	self.infoLayer:addChild(shortcutContainer, 60)
	self.shortcutLayer = shortcutContainer
	local readNode = ed.readnode.create(shortcutContainer, ui)
	local ui_info = {
						{
						t = "Scale9Sprite",
						base = {
						name = "shortcut_board",
						res = "UI/alpha/HVGA/main_shortcut_board.png",
						capInsets = CCRectMake(0, 25, 62, 26)
						},
						layout = {
						anchor = ccp(0.5, 1),
						position = res.shortcut_board_pos
						},
						config = {
						scaleSize = self.isShortcutOpen and CCSizeMake(res.shortcut_board_width, res.shortcut_board_height_max) or CCSizeMake(res.shortcut_board_width, res.shortcut_board_height_min)
						}
						},
						{
						t = "Sprite",
						base = {
						name = "down",
						res = "UI/alpha/HVGA/main_down_button.png",
						z = 10
						},
						layout = {
						position = ccp(res.shortcut_pos_x, res.shortcut_pos_y)
						},
						config = {}
						},
						{
						t = "Sprite",
						base = {
						name = "up",
						res = "UI/alpha/HVGA/main_up_button.png",
						z = 10
						},
						layout = {
						position = ccp(res.shortcut_pos_x, res.shortcut_pos_y)
						},
						config = {
						visible = self.isShortcutOpen
						}
						},
						{
						t = "Sprite",
						base = {
						name = "tag",
						res = "UI/alpha/HVGA/main_deal_tag.png",
						z = 10
						},
						layout = {
						position = ccp(res.shortcut_pos_x + 28, res.shortcut_pos_y + 22)
						},
						config = {visible = false}
						}
					}
	readNode:addNode(ui_info)
	local info = {
					button = ui.down,
					pressScale = 0.95,
					clickHandler = self:doShortcut(),
					priority = sc_touch_priority
				}
	self:btRegisterButtonClick(info)
	getTouchNode(self):btRegisterButtonClick(info)
end

local hideSwitch = function(self)
	self.shortcutLayer:setVisible(false)
end

local showSwitch = function(self)
	self.shortcutLayer:setVisible(true)
end

class.interface = 
{
	scGetuiList = getuiList,
	scGetContainer = getContainer,
	scGetInfoContainer = getInfoContainer,
	scRefreshTags = refreshTags,
	scCreateBoard = createBoard,
	scCreateButtons = createButtons,
	scGetButtons = getButtons,
	scCreateShadeLayer = createShadeLayer,
	scDestroyShadeLayer = destroyShadeLayer,
	scHideSwitch = hideSwitch,
	scShowSwitch = showSwitch
}

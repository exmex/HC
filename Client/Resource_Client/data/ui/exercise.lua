local ed = ed
local lsr = ed.ui.exerciselsr.create()
local class = {
	mt = {}
}
class.mt.__index = class
local degreeWindow = class
local function getStageRow(self, id)
	local st = ed.getDataTable("Stage")
	return st[id]
end
class.getStageRow = getStageRow
local getUnlockLevel = function(self, id)
	local row = self:getStageRow(id)
	return row["Unlock Level"]
end
class.getUnlockLevel = getUnlockLevel
local function checkUnlockLevel(self, id)
	local ul = self:getUnlockLevel(id)
	if ul <= ed.player:getLevel() then
		return true
	else
		return false
	end
end
class.checkUnlockLevel = checkUnlockLevel
local function getLeftTimes(self)
	local times = ed.player:getActTimes(self.baseScene:getsgid(self.key))
	return math.max(0, self.baseScene:getDailyLimit(self.key) - times)
end
class.getLeftTimes = getLeftTimes
local function getcd(self)
	local id = self.baseScene:getsgid(self.key)
	local cd = self.baseScene:getActcd(self.key) - (ed.getServerTime() - ed.player:getActcd(id))
	return cd
end
class.getcd = getcd
local function getcdms(self)
	local cd = self:getcd()
	return ed.getmsNString(cd)
end
class.getcdms = getcdms
local function getStage(self)
	local key = self.key
	local s = self.baseScene:getExerciseInfo(key).stage
	local stage = {}
	local st = ed.getDataTable("Stage")
	for i = 1, #s do
		if s[i] > 0 then
			local id = s[i]
			table.insert(stage, {
				id = id,
				vit = st[id]["Vitality Cost"]
			})
		end
	end
	for i = 1, #stage do
		for j = i, 2, -1 do
			if stage[j].id < stage[j - 1].id then
				local temp = stage[j]
				stage[j] = stage[j - 1]
				stage[j - 1] = temp
			end
		end
	end
	return stage
end
class.getStage = getStage
local function doGotoStage(self, stage)
	if not self:checkUnlockLevel(stage.id) then
		ed.showToast(T(LSTR("EXERCISE.YOU_CAN_ACCESS_HERE_ONCE_YOUR_CLAN_LEVEL_REACHES__D"), self:getUnlockLevel(stage.id)))
		return
	end
	if self:getLeftTimes() <= 0 then
		ed.showToast(T(LSTR("EXERCISE.YOUVE_REACHED_OUT_THE_MAXIMUM_NUMBERS_TODAY")))
		return
	end
	if ed.player:getVitality() < stage.vit then
		ed.showHandyDialog("buyVitality")
		return
	end
	if 0 < self:getcd() then
		ed.showToast(T(LSTR("EXERCISE.COOL_DOWN_TIME_IS_NOT_END_YOU_CAN_NOT_ACCESS_IT")))
		return
	end
	local scene = ed.ui.stagedetail.createForExercise(stage.id, {
		heroLimit = self.baseScene:getHeroLimit(self.key),
		actType = self.baseScene.type
	})
	ed.pushScene(scene)
end
class.doGotoStage = doGotoStage
local function doDegreeTouch(self)
	local stage = self.stage
	local degree = self.degree
	local id
	local function getButton(id)
		local d = degree[id]
		local s = stage[id]
		return d.button, d.button_press, d.title_press, s
	end
	local function handler(event, x, y)
		if event == "began" then
			for i = 1, 4 do
				local button, press, title_press = getButton(i)
				if ed.containsPoint(button, x, y) then
					id = i
					if self:checkUnlockLevel(stage[id].id) then
						press:setVisible(true)
						title_press:setVisible(true)
						do break end
					end
				end
			end    
		elseif event == "ended" then
			for i = 1, 4 do
				id = i
				if id then
					local button, press, title_press, s = getButton(id)
					press:setVisible(false)
					title_press:setVisible(false)
					if ed.containsPoint(button, x, y) then
						lsr:report("clickDegreeButton")
						self:doGotoStage(s)
					end
				end
				id=nil
			end
		end
	end --end of function

	return handler
end
class.doDegreeTouch = doDegreeTouch
local doClickClose = function(self)
	self:destroy()
end
class.doClickClose = doClickClose
local function doCloseTouch(self)
	local isPress
	local button = self.ui.close
	local press = self.ui.close_press
	local function handler(event, x, y)
		if event == "began" then
			if ed.containsPoint(button, x, y) then
				isPress = true
				press:setVisible(true)
			end
		elseif event == "ended" then
			if isPress and ed.containsPoint(button, x, y) then
				self:doClickClose()
			end
			isPress = nil
		end
	end
	return handler
end
class.doCloseTouch = doCloseTouch
local function doOutLayerTouch(self)
	local isPress
	local frame = self.ui.frame
	local function handler(event, x, y)
		if event == "began" then
			if not ed.containsPoint(frame, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and not ed.containsPoint(frame, x, y) then
				self:destroy()
			end
			isPress = nil
		end
	end
	return handler
end
class.doOutLayerTouch = doOutLayerTouch
local doMainLayerTouch = function(self)
	local outLayerTouch = self:doOutLayerTouch()
	local closeTouch = self:doCloseTouch()
	local degreeTouch = self:doDegreeTouch()
	local function handler(event, x, y)
		xpcall(function()
			outLayerTouch(event, x, y)
			closeTouch(event, x, y)
			degreeTouch(event, x, y)
		end, EDDebug)
		return true
	end
	return handler
end
class.doMainLayerTouch = doMainLayerTouch
local removeCountdownHandler = function(self)
	self.baseScene:removeUpdateHandler("refreshCountdown")
end
class.removeCountdownHandler = removeCountdownHandler
local function refreshCountdown(self)
	local count = 0
	local ui = self.cdui
	local function handler(dt)
		if tolua.isnull(self.cdContainer) then
			return
		end
		count = count + dt
		if count > 1 then
			count = count - 1
			if self:getcd() > 0 then
				ed.setString(ui.cd, self:getcdms())
			else
				ed.setString(ui.cd_title, "")
				if not tolua.isnull(ui.cd) then
					ui.cd:setVisible(false)
				end
				self:removeCountdownHandler()
				local tx, ty = 200, 232
				local dx = 146
				local tt = self.cdui.times_title
				local t = self.cdui.times
				tt:setPosition(ccp(tx + 60, ty))
				t:setPosition(ccp(tx + 146 + 40, ty))
			end
		end
	end
	return handler
end
class.refreshCountdown = refreshCountdown
local removeOnEnterHandler = function(self)
	self.baseScene:removeOnEnterHandler("onEnterDegree")
end
class.removeOnEnterHandler = removeOnEnterHandler
local onEnterHandler = function(self)
	local function handler()
		self:createcdBoard()
	end
	return handler
end
class.onEnterHandler = onEnterHandler

local function createcdBoard(self)
	local times = self:getLeftTimes()
	if not tolua.isnull(self.cdContainer) then
		self.cdContainer:removeFromParentAndCleanup(true)
		self.cdContainer = nil
	end
	local container = CCSprite:create()
	self.cdContainer = container
	container:setAnchorPoint(ccp(0, 0))
	container:setPosition(ccp(0, 0))
	self.ui.frame:addChild(container)
	local tx, ty = 324, 232
	if 0 >= self:getcd() then
		tx = 200
	end
	self.cdui = {}
	if times <= 0 then
		local ui_info = {
			{
				t = "Label",
				base = {
					name = "times_title",
					text = T(LSTR("EXERCISE.YOUVE_REACHED_OUT_THE_MAXIMUM_NUMBERS_TODAY")),
					size = 20
				},
				layout = {
					position = ccp(352, 232)
				},
				config = {
					color = ccc3(241, 193, 113)
				}
			}
		}
		local readNode = ed.readnode.create(container, self.cdui)
		readNode:addNode(ui_info)
	else
		local ui_info = {
			{
				t = "Label",
				base = {
					name = "cd_title",
					text = 0 < self:getcd() and T(LSTR("EXERCISE.YOU_CAN_ACCESS_HERE_NEXT_TIME_")) or "",
					size = 20
				},
				layout = {
					anchor = ccp(0, 0.5),
					position = ccp(75, 232)
				},
				config = {
					color = ccc3(241, 193, 113)
				}
			},
			{
				t = "Label",
				base = {
					name = "cd",
					text = self:getcdms(),
					size = 20
				},
				layout = {
					anchor = ccp(0, 0.5),
					position = ccp(180, 232)
				},
				config = {
					color = ccc3(233, 214, 181),
					visible = 0 < self:getcd()
				}
			},
			{
				t = "Label",
				base = {
					name = "times_title",
					text = T(LSTR("EXERCISE.REMAINING_TIMES_FOR_TODAY_"), self:getLeftTimes()),
					size = 20
				},
				layout = {
					anchor = ccp(0, 0.5),
					position = ccp(tx + 60, ty)
				},
				config = {
					color = ccc3(241, 193, 113)
				}
			},
			{
				t = "Label",
				base = {
					name = "times",
					text = T(LSTR("EXERCISE._D"), self:getLeftTimes()),
					size = 20
				},
				layout = {
					anchor = ccp(0, 0.5),
					position = ccp(tx + 146 + 40, ty)
				},
				config = {
					color = ccc3(233, 214, 181),
                    visible = false
				}
			}
		}
		local readNode = ed.readnode.create(container, self.cdui)
		readNode:addNode(ui_info)
		self.baseScene:registerUpdateHandler("refreshCountdown", self:refreshCountdown())
		self.baseScene:registerOnEnterHandler("onEnterDegree", self:onEnterHandler())
	end
end
class.createcdBoard = createcdBoard

local function createDegree(self)
	local iconres = {
		"UI/alpha/HVGA/act/act_icon_difficulty_1.png",
		"UI/alpha/HVGA/act/act_icon_difficulty_2.png",
		"UI/alpha/HVGA/act/act_icon_difficulty_3.png",
		"UI/alpha/HVGA/act/act_icon_difficulty_4.png"
	}
	local titleres_normal = {
		"UI/alpha/HVGA/act/act_select_difficulty_i_1.png",
		"UI/alpha/HVGA/act/act_select_difficulty_ii_1.png",
		"UI/alpha/HVGA/act/act_select_difficulty_iii_1.png",
		"UI/alpha/HVGA/act/act_select_difficulty_iv_1.png"
	}
	local titleres_chosen = {
		"UI/alpha/HVGA/act/act_select_difficulty_i_2.png",
		"UI/alpha/HVGA/act/act_select_difficulty_ii_2.png",
		"UI/alpha/HVGA/act/act_select_difficulty_iii_2.png",
		"UI/alpha/HVGA/act/act_select_difficulty_iv_2.png"
	}
	local stage = self.stage
	local degree = {}
	local ox, oy = 97, 140
	local dx = 170
	local ly = 45
	for i = 1, 4 do
		local s = self.stage[i]
		local isUnlock = self:checkUnlockLevel(s.id)
		degree[i] = {}
		local ui_info = {
			{
				t = "Sprite",
				base = {
					name = "button",
					res = "UI/alpha/HVGA/act/act_select_bg.png"
				},
				layout = {
					position = ccp(ox + dx * (i - 1), oy)
				},
				config = {}
			},
			{
				t = "Sprite",
				base = {
					name = "button_press",
					res = "UI/alpha/HVGA/act/act_select_bg_chosen.png",
					parent = "button"
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
					name = "title_normal",
					res = isUnlock and titleres_normal[i] or "UI/alpha/HVGA/act/act_select_lock.png"
				},
				layout = {
					position = ccp(ox + dx * (i - 1), oy - 45)
				},
				config = {}
			},
			{
				t = "Sprite",
				base = {
					name = "title_press",
					res = titleres_chosen[i],
					parent = "title_normal"
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
					name = "button_icon",
					res = iconres[i],
					parent = "button"
				},
				layout = {mediate = true},
				config = {}
			},
			{
				t = "Sprite",
				base = {
					name = "vit_bg",
					res = "UI/alpha/HVGA/act/act_comment_bg.png"
				},
				layout = {
					position = ccp(ox + dx * (i - 1), ly)
				},
				config = {}
			},
			{
				t = "Label",
				base = {
					name = "vit_number",
					text = stage[i].vit,
					size = 18
				},
				layout = {
					anchor = ccp(1, 0.5),
					position = ccp(ox + dx * (i - 1) - 5, ly)
				},
				config = {
					color = ccc3(233, 214, 181)
				}
			},
			{
				t = "Sprite",
				base = {
					name = "vit_icon",
					res = "UI/alpha/HVGA/vitalityicon.png"
				},
				layout = {
					anchor = ccp(0, 0.5),
					position = ccp(ox + dx * (i - 1) + 5, ly)
				},
				config = {fix_height = 35}
			}
		}
		local readNode = ed.readnode.create(self.ui.frame, degree[i])
		readNode:addNode(ui_info)
		local ui = degree[i]
		if not isUnlock then
			ed.setSpriteGray(ui.button)
			ed.setSpriteGray(ui.button_icon)
		end
	end
	self.degree = degree
end
class.createDegree = createDegree

local function create(key)
	local self = {}
	setmetatable(self, class.mt)
	local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
	self.mainLayer = mainLayer
	self.key = key
	self.baseScene = ed.getCurrentScene()
	self.stage = self:getStage()
	local container = CCLayer:create()
	container:setAnchorPoint(ccp(0.5, 0.5))
	self.container = container
	mainLayer:addChild(container)
	self.ui = {}
	local ui_info = {
		{
			t = "Scale9Sprite",
			base = {
				name = "frame",
				res = "UI/alpha/HVGA/main_vit_tips.png",
				capInsets = CCRectMake(10, 10, 58, 26)
			},
			layout = {
				position = ccp(400, 220)
			},
			config = {
				scaleSize = CCSizeMake(705, 300)
			}
		},
		{
			t = "Sprite",
			base = {
				name = "close",
				res = "UI/alpha/HVGA/herodetail-detail-close.png"
			},
			layout = {
				position = ccp(750, 350)
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
		}
	}
	local readNode = ed.readnode.create(self.container, self.ui)
	readNode:addNode(ui_info)
	ui_info = {
		{
			t = "Sprite",
			base = {
				name = "title_bg",
				res = "UI/alpha/HVGA/act/act_popup_bg.png"
			},
			layout = {
				position = ccp(352, 272)
			},
			config = {
				visible = false
			}
		},
		{
			t = "Label",
			base = {
				name = "title",
				text = T(LSTR("EXERCISE.PLEASE_SELECT_DIFFICULTY_LEVEL")),
				fontinfo = "ui_normal_button"
			},
			layout = {
				position = ccp(352, 272)
			},
			config = {
				color = ccc3(231, 206, 19)
			}
		}
	}
	local readNode = ed.readnode.create(self.ui.frame, self.ui)
	readNode:addNode(ui_info)
	self:createcdBoard()
	self:createDegree()
	self.mainLayer:setTouchEnabled(true)
	self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -135, true)
	self:show()
	return self
end
class.create = create

local destroy = function(self)
	self:removeCountdownHandler()
	self:removeOnEnterHandler()
	local s = CCScaleTo:create(0.2, 0)
	s = CCEaseBackIn:create(s)
	local f = CCCallFunc:create(function()
		xpcall(function()
			self.mainLayer:removeFromParentAndCleanup(true)
		end, EDDebug)
	end)
	s = CCSequence:createWithTwoActions(s, f)
	self.container:runAction(s)
end
class.destroy = destroy
local show = function(self)
	self.container:setScale(0)
	local action = CCScaleTo:create(0.2, 1)
	action = CCEaseBackOut:create(action)
	self.container:runAction(action)
end
class.show = show


local class = {
	mt = {}
}
class.mt.__index = class
local detailWindow = class
local function createDetailCard(self, id)
	local card = ed.readequip.getDetailCard(id)
	self.detailCard = card
	self.ui.frame:addChild(card)
	return card
end
class.createDetailCard = createDetailCard
local destroyDetailCard = function(self)
	if not tolua.isnull(self.detailCard) then
		self.detailCard:removeFromParentAndCleanup(true)
		self.detailCard = nil
	end
end
class.destroyDetailCard = destroyDetailCard

local function doRewardTouch(self)
	local pid
	local reward = self.reward
	local oriScale
	local function handler(event, x, y)
		if event == "began" then
			for i = 1, #reward do
				local r = reward[i]
				local id = r.id
				local icon = r.icon
				oriScale = icon:getScale()
				if ed.containsPoint(icon, x, y) then
					pid = i
					icon:setScale(oriScale * 0.95)
					local card = self:createDetailCard(id)
					local x, y = icon:getPosition()
					card:setPosition(ccp(x, y + 20))
					break
				end
			end
		elseif event == "ended" then
			if pid then
				local r = reward[pid]
				local icon = r.icon
				icon:setScale(oriScale)
				self:destroyDetailCard()
			end
			pid = nil
		end
	end
	return handler
end
class.doRewardTouch = doRewardTouch

local function doOutLayerTouch(self)
	local isPress
	local frame = self.ui.frame
	local function handler(event, x, y)
		if event == "began" then
			if not ed.containsPoint(frame, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and not ed.containsPoint(frame, x, y) then
				self:destroy()
			end
			isPress = nil
		end
	end
	return handler
end
class.doOutLayerTouch = doOutLayerTouch

local doMainLayerTouch = function(self)
	local outLayerTouch = self:doOutLayerTouch()
	local rewardTouch = self:doRewardTouch()
	local function handler(event, x, y)
		xpcall(function()
			outLayerTouch(event, x, y)
			rewardTouch(event, x, y)
		end, EDDebug)
		return true
	end
	return handler
end
class.doMainLayerTouch = doMainLayerTouch

local function createReward(self, list)
	local reward = {}
	local ox, oy = 30, 30
	local dx = 45
	for i = 1, #list do
		local icon = ed.readequip.createIcon(list[i], 40)
		icon:setPosition(ccp(ox + dx * (i - 1), oy))
		self.ui.frame:addChild(icon)
		reward[i] = {
			icon = icon,
			id = list[i]
		}
	end
	self.reward = reward
end
class.createReward = createReward

local function create(key)
	local self = {}
	setmetatable(self, class.mt)
	local mainLayer = CCLayer:create()
	self.mainLayer = mainLayer
	self.baseScene = ed.getCurrentScene()
	local container = CCLayer:create()
	container:setAnchorPoint(ccp(0.5, 0.5))
	self.container = container
	mainLayer:addChild(container)
	local info = self.baseScene:getExerciseInfo(key)
	self.ui = {}
	local f_w = 370
	local frame = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
	frame:setPosition(ccp(400, 240))
	self.container:addChild(frame)
	self.ui.frame = frame
	local height = 60
	local title = ed.createttf(T(LSTR("EXERCISE.AWARDS_")), 18)
	title:setAnchorPoint(ccp(0, 0))
	title:setPosition(ccp(10, 60))
	frame:addChild(title)
	height = height + title:getContentSize().height + 5
	if info.advise then
		local bg = ed.createSprite("UI/alpha/HVGA/act/act_comment_bg.png")
		local h = bg:getContentSize().height / 2
		height = height + h
		bg:setPosition(ccp(180, height))
		bg:setScaleX(f_w / bg:getContentSize().width)
		frame:addChild(bg)
		title = ed.createttf(info.advise, 18)
		title:setAnchorPoint(ccp(0, 0.5))
		title:setPosition(ccp(10, height))
		frame:addChild(title)
		height = height + h + 5
	end
	title = ed.createttf(info.des, 18)
	title:setAnchorPoint(ccp(0, 0))
	title:setPosition(ccp(10, height))
	ed.setLabelDimensions(title, CCSizeMake(f_w - 16, 0))
	title:setHorizontalAlignment(kCCTextAlignmentLeft)
	title:setVerticalAlignment(kCCVerticalTextAlignmentTop)
	frame:addChild(title)
	height = height + title:getContentSize().height + 5
	title = ed.createSprite(self.baseScene:getEntryres()[key].descres)
	title:setAnchorPoint(ccp(0.5, 0))
	title:setPosition(ccp(f_w / 2, height))
	frame:addChild(title)
	height = height + title:getContentSize().height + 10
	frame:setContentSize(CCSizeMake(f_w, height))
	self:createReward(info.reward)
	mainLayer:setTouchEnabled(true)
	mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -130, true)
	self:show()
	return self
end
class.create = create

local destroy = function(self)
	local s = CCScaleTo:create(0.2, 0)
	s = CCEaseBackIn:create(s)
	local f = CCCallFunc:create(function()
		xpcall(function()
			self.mainLayer:removeFromParentAndCleanup(true)
		end, EDDebug)
	end)
	s = CCSequence:createWithTwoActions(s, f)
	self.container:runAction(s)
end
class.destroy = destroy

local show = function(self)
	self.container:setScale(0)
	local s = CCScaleTo:create(0.2, 1)
	s = CCEaseBackOut:create(s)
	self.container:runAction(s)
end
class.show = show


local class = {
	mt = {}
}
class.mt.__index = class
ed.ui.exercise = class
local base = ed.ui.framework
setmetatable(class, base.mt)
local res
local entryStage = ed.ui.exerciseres.entry_stage
local function getres(self)
	self.uires = res.uires
	return self.uires
end
class.getres = getres
local function getEntryres(self)
	self.entryres = res.entry
	return self.entryres
end
class.getEntryres = getEntryres
local function getsgid(self, key)
	return entryStage[key]
end
class.getsgid = getsgid
local function getasRow(self, key)
	local ast = ed.getDataTable("ActStageGroup")
	local row = ast[self:getsgid(key)]
	return row
end
class.getasRow = getasRow
local getDailyLimit = function(self, key)
	return self:getasRow(key).DailyLimit
end
class.getDailyLimit = getDailyLimit
local getActcd = function(self, key)
	return self:getasRow(key).CD
end
class.getActcd = getActcd
local function checkOpenAllExercise(self, time)
	local t = time or ed.serverTime2China()
	local dayKey = ed.getGameDayKey(t)
	local activities = ed.getDataTable("DailyActivity")
	local openRules = activities['open_all_exercise']
	if openRules ~= nil and openRules[dayKey] ~= nil and openRules[dayKey] == 1 then
		return true
	end
	return false
end
class.checkOpenAllExercise = checkOpenAllExercise
local function checkExerciseEnabled(self, key)
	local row = self:getasRow(key)
	local wn = ed.getWeekdayName()
	local pwn = ed.getPreWeekdayName()
	local nt = ed.serverTime2China()
	if self:checkOpenAllExercise(nt) then
		return true
	end
	local y, m, d, h, mi, s = ed.time2YMDHMS(nt)
	local ntt = {
		d = d,
		h = h,
		m = mi,
		s = s
	}
	local boa = ed.checkBOA(ntt)
	local ckday = row[wn]
	local ckhour = boa == "after"
	local ck1 = ckday and ckhour
	local pckday = row[pwn]
	local pckhour = boa == "before"
	local ck2 = pckday and pckhour
	return ck1 or ck2
end
class.checkExerciseEnabled = checkExerciseEnabled
local getExerciseInfo = function(self, key)
	local row = self:getasRow(key)
	local reward = {}
	for i = 1, 3 do
		table.insert(reward, row["UI reward" .. i])
	end
	return {
		name = row["Group Name"],
		des = row["Display Time Schedule"],
		amountLimit = row.DailyLimit,
		stage = row.Stages,
		advise = row["Display Special Limit"],
		reward = reward
	}
end
class.getExerciseInfo = getExerciseInfo
local getHeroLimit = function(self, key)
	local row = self:getasRow(key)
	return {
		type = row["Limit Type"],
		detail = row["Limit Detail"]
	}
end
class.getHeroLimit = getHeroLimit
local function doClickExerciseButton(self, key)
	lsr:report("clickActButton")
	if self:checkExerciseEnabled(key) then
		local degree = degreeWindow.create(key)
		self.container:addChild(degree.mainLayer, 100)
	else
		local detail = detailWindow.create(key)
		self.container:addChild(detail.mainLayer, 100)
	end
end
class.doClickExerciseButton = doClickExerciseButton
local function doExpTouch(self)
	local isPress
	local info = res.entry.exp
	local center = info.center
	local radius = info.radius
	local function handler(event, x, y)
		if event == "began" then
			if ed.isPointInCircle(center, radius, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and ed.isPointInCircle(center, radius, x, y) then
				self:doClickExerciseButton("exp")
			end
			isPress = nil
		end
	end
	return handler
end
class.doExpTouch = doExpTouch
local doClickMoney = function(self)
end
class.doClickMoney = doClickMoney
local function doMoneyTouch(self)
	local isPress
	local info = res.entry.money
	local center = info.center
	local radius = info.radius
	local function handler(event, x, y)
		if event == "began" then
			if ed.isPointInCircle(center, radius, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and ed.isPointInCircle(center, radius, x, y) then
				self:doClickExerciseButton("money")
			end
			isPress = nil
		end
	end
	return handler
end
class.doMoneyTouch = doMoneyTouch
local doClickStr = function(self)
end
class.doClicKStr = doClickStr
local function doStrTouch(self)
	local isPress
	local info = res.entry.str
	local center = info.center
	local radius = info.radius
	local function handler(event, x, y)
		if event == "began" then
			if ed.isPointInCircle(center, radius, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and ed.isPointInCircle(center, radius, x, y) then
				self:doClickExerciseButton("str")
			end
			isPress = nil
		end
	end
	return handler
end
class.doStrTouch = doStrTouch
local doClickAgi = function(self)
end
class.doClickAgi = doClickAgi
local function doAgiTouch(self)
	local isPress
	local info = res.entry.agi
	local center = info.center
	local radius = info.radius
	local function handler(event, x, y)
		if event == "began" then
			if ed.isPointInCircle(center, radius, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and ed.isPointInCircle(center, radius, x, y) then
				self:doClickExerciseButton("agi")
			end
			isPress = nil
		end
	end
	return handler
end
class.doAgiTouch = doAgiTouch
local doClickInt = function(self)
end
class.doClickInt = doClickInt
local function doIntTouch(self)
	local isPress
	local info = res.entry.int
	local center = info.center
	local radius = info.radius
	local function handler(event, x, y)
		if event == "began" then
			if ed.isPointInCircle(center, radius, x, y) then
				isPress = true
			end
		elseif event == "ended" then
			if isPress and ed.isPointInCircle(center, radius, x, y) then
				self:doClickExerciseButton("int")
			end
			isPress = nil
		end
	end
	return handler
end
class.doIntTouch = doIntTouch
local registerButtonTouchHandler = function(self, handler)
	self.buttonTouchHandler = self.buttonTouchHandler or {}
	table.insert(self.buttonTouchHandler, handler)
end
class.registerButtonTouchHandler = registerButtonTouchHandler
local doMainLayerTouch = function(self)
	local function handler(event, x, y)
		xpcall(function()
			for i = 1, #self.buttonTouchHandler do
				local handler = self.buttonTouchHandler[i]
				handler(event, x, y)
			end
		end, EDDebug)
		return true
	end
	return handler
end
class.doMainLayerTouch = doMainLayerTouch
local onEnterHandler = function(self)
	local function handler()
		for k, v in pairs(self.entry or {}) do
			for i = 1, #v.node do
				v.node[i]:setAction("Idle")
			end
		end
	end
	return handler
end
class.onEnterHandler = onEnterHandler
local function createExerciseButton(self)
	local container = self.container
	local entry = {}
	for k, v in pairs(res.entry) do
		local fca = {}
		local name = {}
		local node = {}
		local action = {}
		for i = 1, #v.fca do
			local f = v.fca[i]
			local n = string.gsub(f, "%.cha$", "")
			table.insert(fca, f)
			table.insert(name, n)
			local fn = LegendAnimation:create(n, v.scale[i])
			local fa = "Idle"
			fn:setAction(fa)
			fn:setLoop(true)
			fn:setPosition(v.pos[i])
			container:addChild(fn, 10)
			self:addFca(fn)
			table.insert(node, fn)
			table.insert(action, fa)
			if not self:checkExerciseEnabled(k) then
				fn:useShader("StoneShader")
				self:delayPauseFca(fn)
			end
		end
		local uires = self:getres()
		entry[k] = {
			fca = fca,
			name = name,
			node = node,
			action = action
		}
	end
	if self.type == "em" then
		self:registerButtonTouchHandler(self:doExpTouch())
		self:registerButtonTouchHandler(self:doMoneyTouch())
	elseif self.type == "equip" then
		self:registerButtonTouchHandler(self:doStrTouch())
		self:registerButtonTouchHandler(self:doAgiTouch())
		self:registerButtonTouchHandler(self:doIntTouch())
	end
	self.entry = entry
end
class.createExerciseButton = createExerciseButton
local function create(type)
	local self = base.create(type)
	setmetatable(self, class.mt)
	if not ed.isElementInTable(type, {"em", "equip"}) then
		print("illegal key of exercise , please input \"em\" or \"equip\" ")
		return self
	end
	res = ed.ui.exerciseres
	res = res[type]
	self.type = type
	local scene = self.scene
	local mainLayer = self.mainLayer
	self:btRegisterHandler({
		handler = self:doMainLayerTouch()
	})
	local container = CCSprite:create()
	mainLayer:addChild(container, 5)
	self.container = container
	local clipLayer = CCLayer:create()
	clipLayer:setClipRect(CCRectMake(44, 20, 712, 370))
	self.clipLayer = clipLayer
	mainLayer:addChild(clipLayer)
	self.ui = {}
	local ur = self:getres()
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "map",
				res = ur.map
			},
			layout = {
				position = ccp(400, 212)
			},
			config = {}
		}
	}
	local readNode = ed.readnode.create(clipLayer, self.ui)
	readNode:addNode(ui_info)
	ui_info = {
		{
			t = "Sprite",
			base = {
				name = "title_shadow",
				res = ur.titleShadow
			},
			layout = {
				anchor = ccp(0.5, 1),
				position = ccp(400, 397)
			},
			config = {scale = 0.99}
		},
		{
			t = "Sprite",
			base = {
				name = "frame",
				res = ur.frame
			},
			layout = {
				position = ccp(400, 205)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "title_bg",
				res = ur.titleBg
			},
			layout = {
				position = ccp(400, 355)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "title",
				res = ur.title
			},
			layout = {
				position = ccp(400, 355)
			},
			config = {}
		}
	}
	readNode = ed.readnode.create(container, self.ui)
	readNode:addNode(ui_info)
	self:createExerciseButton()
	self:registerOnEnterHandler("enter", self:onEnterHandler())
	return self
end
class.create = create

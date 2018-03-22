local ed = ed
local class = {
	mt = {}
}
class.mt.__index = class
local base = ed.ui.framework
ed.ui.stageselect = class
setmetatable(class, base.mt)
local res = ed.ui.stageselectres
local lsr = ed.ui.stageselectlsr.create()
local drag_dis = 60
local drag_gap = 1
local CHAPTER_MAX = ed.GameConfig.MaxChapter or 13;
local CHAPTER_MIN = 1
local KEY_STAGE_RADIUS = 45
local NOT_KEY_STAGE_RADIUS = 45
local change_chapter_gap = 0.5
local map_ori_pos = ccp(400, 205)
local function getEliteProgress(self)
	return ed.player:getEliteStageProgress()
end
class.getEliteProgress = getEliteProgress
local function getNormalProgress(self)
	return ed.player:getStageProgress()
end
class.getNormalProgress = getNormalProgress
local function getMaxEliteChapter(self)
	local st = ed.getDataTable("Stage")
	local progress = self:getEliteProgress()
	return st[st[progress]["Stage Group"]]["Chapter ID"]
end
class.getMaxEliteChapter = getMaxEliteChapter
local function getMaxNormalChapter(self)
	local st = ed.getDataTable("Stage")
	local progress = self:getNormalProgress()
	return st[progress]["Chapter ID"]
end
class.getMaxNormalChapter = getMaxNormalChapter
local function getMinGuildInstanceChapter(self)
	for i = 1, CHAPTER_MAX do
		local info = res.map["chapter" .. i]
		if info and info.guildInstance == true then
			return i
		end
	end
end
class.getMinGuildInstanceChapter = getMinGuildInstanceChapter
local function getMaxGuildInstanceChapter(self)
	for i = getMaxNormalChapter(self), 1, -1 do
		local info = res.map["chapter" .. i]
		if info and info.guildInstance == true then
			return i
		end
	end
	return getMinGuildInstanceChapter(self)
end
class.getMaxGuildInstanceChapter = getMaxGuildInstanceChapter
local getMaxChapter = function(self)
	if self.mode == "elite" then
		return self.eliteInfo.maxChapter
	elseif self.mode == "normal" then
		return self.normalInfo.maxChapter
	else
		return self.guildInfo.maxChapter
	end
end
class.getMaxChapter = getMaxChapter
local function getMinChapter(self)
	if self.mode == "guild" then
		return getMinGuildInstanceChapter(self)
	else
		return CHAPTER_MIN
	end
end
class.getMinChapter = getMinChapter
local function getDotPos(self, max, current)
	local dx = res.chapter_dot_gap_x
	local y
	if self.isElite then
		y = res.elite_chapter_dot_y
	else
		y = res.normal_chapter_dot_y
	end
	local center = (max + 1) / 2
	local x = 400 + dx * (current - center)
	return ccp(x, y)
end
class.getDotPos = getDotPos
local getChapter = function(self)
	if self.mode == "elite" then
		return self.eliteInfo.chapter
	elseif self.mode == "normal" then
		return self.normalInfo.chapter
	else
		return self.guildInfo.chapter
	end
end
class.getChapter = getChapter
local setChapter = function(self, chapter)
	self.lastOperation = "changeChapter"
	if self.mode == "elite" then
		self.preChapter = self.eliteInfo.chapter
		self.eliteInfo.chapter = chapter
	elseif self.mode == "normal" then
		self.preChapter = self.normalInfo.chapter
		self.normalInfo.chapter = chapter
	else
		self.preChapter = self.guildInfo.chapter
		self.guildInfo.chapter = chapter
	end
end
class.setChapter = setChapter
local function doStageTouch(self)
	local function handler(event, x, y)
		if self.mapContainer:getOpacity() ~= 255 then
			return
		end
		if self.mapContainer:numberOfRunningActions() > 0 then
			return
		end
		xpcall(function()
			if event == "began" then
				for i = 1, #self.stageIcon do
					local info = self.stageIcon[i]
					if info.type == "current" or info.type == "passed" and info.eid or self.mode == "guild" and info.eid then
						if info.eid or info.guildInstanceId then
							if ed.isPointInCircle(info.pos, KEY_STAGE_RADIUS, x, y) then
								self.pressStageID = i
								self.pressStageChapterID = self:getChapter()
								info.icon:setScale(0.95)
							end
						elseif ed.isPointInCircle(info.pos, NOT_KEY_STAGE_RADIUS, x, y) then
							self.pressStageID = i
							self.pressStageChapterID = self:getChapter()
							info.icon:setScale(0.95)
						end
					end
				end
			elseif event == "ended" then
				local preChapter = self.pressStageChapterID
				self.pressStageChapterID = nil
				local id = self.pressStageID
				self.pressStageID = nil
				if id then
					if self:getChapter() ~= preChapter then
						return
					end
					local info = self.stageIcon[id]
					info.icon:setScale(1)
					if self.isSelectStageTutorial and id == 1 then
                        --add by xinghui:send dot info when click the stage
                        if --[[ed.tutorial.checkDone("selectStage")== false--]] ed.tutorial.isShowTutorial then
                            ed.sendDotInfoToServer(ed.tutorialres.t_key["selectStage"].id)
                        end
                        --
						ed.endTeach("selectStage")
						self.showTutorial = false
						self:refresh()
					end
					if info.eid or info.guildInstanceId then
						if ed.isPointInCircle(info.pos, KEY_STAGE_RADIUS, x, y) and not self.isClickChangeChapterButton and not self.intoStageDetail then
							lsr:report("clickKeyStage")
							if self.isElite then
								if (ed.player:getStageStar(info.id) or 0) == 0 then
									ed.showToast(T(LSTR("STAGESELECT.IT_WILL_BE_OPEN_ONCE_COMPLETE_THE_NORMAL_MODE")))
								else
									self:gotoDetailScene(info, id)
								end
							elseif self.mode == "guild" then
								if (ed.player:getStageStar(info.id) or 0) == 0 then
									ed.showToast(T(LSTR("STAGESELECT.IT_WILL_BE_OPEN_ONCE_COMPLETE_THE_NORMAL_MODE")))
								else
									self:gotoGuildInstance(info)
								end
							else
								self:gotoDetailScene(info, id)
							end
						end
					elseif ed.isPointInCircle(info.pos, NOT_KEY_STAGE_RADIUS, x, y) and not self.isClickChangeChapterButton and not self.intoStageDetail then
						lsr:report("clickNotKeyStage")
						self:gotoDetailScene(info, id)
					end
				end
			end
		end, EDDebug)
	end
	return handler
end
class.doStageTouch = doStageTouch
local getCurrentStageId = function(self, info)
	if nil == info then
		return
	end
	if self.mode == "elite" then
		return info.eid
	elseif self.mode == "guild" then
		return info.guildInstanceId
	else
		return info.id
	end
end
local gotoGuildInstance = function(self, info)
	if info.guildInstanceId then
		local instanceInfo = ed.ui.guild.getInstanceInfo(self:getChapter())
		if instanceInfo then
			local msg = ed.upmsg.guild()
			msg._instance_detail = {}
			msg._instance_detail._stage_id = info.guildInstanceId
			ed.send(msg, "guild")
		end
	end
end
class.gotoGuildInstance = gotoGuildInstance
local function gotoDetailScene(self, info)
	local isGetWay = self.identity == "stageSelectGWMode" and true or nil
	ed.pushScene(ed.ui.stagedetail.create(getCurrentStageId(self, info), {isGetWay = isGetWay}, self.mode))
	self.intoStageDetail = true
	if self.getWayStage == info.id or self.getWayStage == info.eid or self.getWayStage == info.guildInstanceId then
		if self.circle and tolua.cast(self.circle, 'CCSprite') then
			self.circle:setVisible(false)
			self.circle = nil
		end
		if self.finger and tolua.cast(self.finger, 'CCSprite')then
			self.finger:setVisible(false)
			self.finger = nil
		end
		self.getWayMode = nil
	end
end
class.gotoDetailScene = gotoDetailScene
local modePressColor = ccc3(255, 255, 255)
local modeNormalColor = ccc3(255, 255, 255)
local function refreshModeButtonPosition(self)
	if self.modeui == nil then
		return
	end
	if self.modeui.guild:isVisible() then
		self.modeui.normal:setPosition(ccp(309, 350))
		self.modeui.elite:setPosition(ccp(399, 350))
	else
		self.modeui.normal:setPosition(ccp(345, 350))
		self.modeui.elite:setPosition(ccp(455, 350))
	end

	self.modeui.normal:setScale(0.9)
	self.modeui.elite:setScale(0.9)
	self.modeui.guild:setScale(0.9)

end
local function updateGuildInstanceButton(self)
	if self.modeui == nil then
		return
	end
	self.modeui.guild:setVisible(false)
	self.modeui.guild_label:setVisible(false)
	if self.modeui.elite:isVisible() == false then
		refreshModeButtonPosition(self)
		return
	end
	if ed.player:getGuildId() == 0 then
		refreshModeButtonPosition(self)
		return
	end
	local chapter
	if self.mode == "guild" then
		--self.modeui.guild:setVisible(true)
		--self.modeui.guild_label:setVisible(true)
		--屏蔽团队副本
		self.modeui.guild:setVisible(false)
		self.modeui.guild_label:setVisible(false)
		refreshModeButtonPosition(self)
		return
	elseif self.mode == "elite" then
		chapter = self.eliteInfo.chapter
	else
		chapter = self.normalInfo.chapter
	end
	if chapter then
		local mapInfo = res.map
		local info = mapInfo["chapter" .. chapter]
		if info and info.guildInstance == true then
			--self.modeui.guild_label:setVisible(true)
			--self.modeui.guild:setVisible(true)
			--屏蔽团队副本
			self.modeui.guild_label:setVisible(false)
			self.modeui.guild:setVisible(false)

		end
	end
	refreshModeButtonPosition(self)
end
local function updateModeButtonState(self)
	if not ed.playerlimit.checkAreaUnlock("Elite") then
		return
	end
	if self.mode == "elite" then
		self.modeui.normal_press:setVisible(false)
		ed.setLabelColor(self.modeui.normal_label, modeNormalColor)
		self.modeui.elite_press:setVisible(true)
		ed.setLabelColor(self.modeui.elite_label, modePressColor)
		self.modeui.guild_press:setVisible(false)
		ed.setLabelColor(self.modeui.guild_label, modeNormalColor)
	elseif self.mode == "guild" then
		self.modeui.normal_press:setVisible(false)
		ed.setLabelColor(self.modeui.normal_label, modeNormalColor)
		self.modeui.elite_press:setVisible(false)
		ed.setLabelColor(self.modeui.elite_label, modeNormalColor)
		self.modeui.guild_press:setVisible(true)
		ed.setLabelColor(self.modeui.guild_label, modePressColor)
	else
		self.modeui.normal_press:setVisible(true)
		ed.setLabelColor(self.modeui.normal_label, modePressColor)
		self.modeui.elite_press:setVisible(false)
		ed.setLabelColor(self.modeui.elite_label, modeNormalColor)
		self.modeui.guild_press:setVisible(false)
		ed.setLabelColor(self.modeui.guild_label, modeNormalColor)
	end
end
local function doChangeMode(self, mode)
	local isElite = (mode or "") == "elite"
	local preChapter = self:getChapter()
	self.isElite = isElite
	self.mode = mode
	self.lastOperation = "changeMode"
	self:createFrame(self:getChapter(), mode)
	self:createMap(self:getChapter(), mode)
	if self:getChapter() ~= preChapter then
		self:createTitle(self:getChapter())
	end
	self:setChapterButtonState()
	updateModeButtonState(self)
end
class.doChangeMode = doChangeMode
local function doModeButtonTouch(self)
	local pressNormal, pressElite, pressGuild
	local normal = self.modeui.normal
	local normalPress = self.modeui.normal_press
	local normalLabel = self.modeui.normal_label
	local elite = self.modeui.elite
	local elitePress = self.modeui.elite_press
	local eliteLabel = self.modeui.elite_label
	local guild = self.modeui.guild
	local guildPress = self.modeui.guild_press
	local guildLabel = self.modeui.guild_label
	local function handler(event, x, y)
		xpcall(function()
			if event == "began" then
				if normal:isVisible() and not normalPress:isVisible() and ed.containsPoint(normal, x, y) then
					pressNormal = true
					normalPress:setVisible(true)
					ed.setLabelColor(normalLabel, modePressColor)
				end
				if elite:isVisible() and not elitePress:isVisible() and ed.containsPoint(elite, x, y) then
					pressElite = true
					elitePress:setVisible(true)
					ed.setLabelColor(eliteLabel, modePressColor)
				end
				if guild:isVisible() and not guildPress:isVisible() and ed.containsPoint(guild, x, y) then
					pressGuild = true
					guildPress:setVisible(true)
					ed.setLabelColor(guildLabel, modePressColor)
				end
			elseif event == "ended" then
				if pressNormal then
					if ed.containsPoint(normal, x, y) then
						lsr:report("cliclNormalMode")
						self:doChangeMode("normal")
					else
						normalPress:setVisible(false)
						ed.setLabelColor(normalLabel, modeNormalColor)
					end
				end
				pressNormal = nil
				if pressElite then
					if ed.containsPoint(elite, x, y) then
						lsr:report("clickEliteMode")
						self:doChangeMode("elite")
						ed.endTeach("clickEliteModeButton")
						self.showTutorial = false
						self:refresh()
					else
						elitePress:setVisible(false)
						ed.setLabelColor(eliteLabel, modeNormalColor)
					end
				end
				pressElite = nil
				if pressGuild then
					if ed.containsPoint(guild, x, y) then
						ed.ui.guild.guildInstance()
					else
						guildPress:setVisible(false)
						ed.setLabelColor(guildLabel, modeNormalColor)
					end
				end
				pressGuild = nil
			end
		end, EDDebug)
	end
	return handler
end
class.doModeButtonTouch = doModeButtonTouch
local function getGuildInstanceId(self, chapter)
	local max = CHAPTER_MAX
	max = math.min(max, self:getMaxChapter())
	local preChapter = self:getChapter()
	if chapter > 0 then
		for i = preChapter + 1, max do
			local info = res.map["chapter" .. i]
			if info and info.guildInstance == true then
				return i
			end
		end
	else
		for i = preChapter - 1, CHAPTER_MIN, -1 do
			local info = res.map["chapter" .. i]
			if info and info.guildInstance == true then
				return i
			end
		end
	end
	return preChapter
end
local function doChangeChapter(self, chapter)
	local preChapter
	preChapter = self:getChapter()
	if chapter == "+" or chapter == 1 then
		local max = CHAPTER_MAX
		max = math.min(max, self:getMaxChapter())
		local c
		if self.mode == "guild" then
			c = getGuildInstanceId(self, chapter)
		else
			c = math.min(preChapter + 1, max)
		end
		if c > ed.playerlimit.maxChapter() then
			local ul = ed.playerlimit.chapterUnlockLevel(c)
			ed.showToast(T(LSTR("STAGESELECT.CLAN_LEVEL_TOLD_LEVEL_TO_UNLOCK_THE_NEXT_CHAPTER"), ul))
		else
			self:setChapter(c)
		end
	end
	if chapter == "-" or chapter == -1 then
		if self.mode == "guild" then
			local c = getGuildInstanceId(self, chapter)
			if c then
				self:setChapter(c)
			end
		else
			self:setChapter(math.max(self:getChapter() - 1, CHAPTER_MIN))
		end
	end
	if self:getChapter() ~= preChapter then
		self:createMap(self:getChapter(), self.mode)
		self:createTitle(self:getChapter())
		self:setChapterButtonState()
	end
	updateGuildInstanceButton(self)
end
class.doChangeChapter = doChangeChapter
local function doChapterDrag(self)
	local rect = CCRectMake(60, 35, 690, 325)
	local press, pressPos, pressTime
	local function handler(event, x, y)
		xpcall(function()
			if event == "began" then
				if ed.isPointInRect(rect, x, y) then
					press = true
					pressPos = ccp(x, y)
					pressTime = ed.getSystemTime()
				end
			elseif event == "ended" then
				if press then
					local pos = pressPos
					local time = pressTime
					if math.abs(x - pos.x) > math.abs(y - pos.y) and math.abs(x - pos.x) > drag_dis and ed.getSystemTime() - time < drag_gap then
						self.dragMode = true
						if x > pos.x then
							self:doChangeChapter(-1)
						else
							self:doChangeChapter(1)
						end
					end
				end
				press = nil
				pressPos = nil
				pressTime = nil
			end
		end, EDDebug)
	end
	return handler
end
class.doChapterDrag = doChapterDrag
local function doChangeChapterButtonTouch(self)
	local pressLeft, pressRight
	local left = self.leftArrow
	local right = self.rightArrow
	local function handler(event, x, y)
		xpcall(function()
			if event == "began" then
				if left:isVisible() and ed.containsPoint(left, x, y) then
					pressLeft = true
					left:setScale(0.95)
				end
				if right:isVisible() and ed.containsPoint(right, x, y) then
					pressRight = true
					right:setScale(0.95)
				end
			elseif event == "ended" then
				if pressLeft then
					left:setScale(1)
					if ed.containsPoint(left, x, y) and not self.dragMode then
						lsr:report("clickChangeChapter")
						self.isClickChangeChapterButton = true
						self:doChangeChapter(-1)
					end
				end
				pressLeft = nil
				if pressRight then
					right:setScale(1)
					if ed.containsPoint(right, x, y) and not self.dragMode then
						lsr:report("clickChangeChapter")
						self.isClickChangeChapterButton = true
						self:doChangeChapter(1)
					end
				end
				pressRight = nil
			end
		end, EDDebug)
	end
	return handler
end
class.doChangeChapterButtonTouch = doChangeChapterButtonTouch
local function getRaidIdByChapter(chapter)
	if nil == chapter then
		return
	end
	local raidTable = ed.getDataTable("Raid")
	for i = 1, #raidTable do
		if raidTable[i]["Chapter ID"] == chapter then
			return i
		end
	end
end
local function showGuildReward(self)
	local raidId = getRaidIdByChapter(self:getChapter())
	if raidId then
		local msg = ed.upmsg.guild()
		msg._instance_drop = {}
		msg._instance_drop._raid_id = raidId
		ed.send(msg, "guild")
	end
end
local function doGuildButtonTouch(self)
	local pressGuild
	local self = self
	local function handler(event, x, y)
		local guildButton = self.guildUI and self.guildUI.reward or nil
		if guildButton == nil then
			return
		end
		if self.mode ~= "guild" then
			return
		end
		if event == "began" then
			if guildButton:isVisible() and ed.containsPoint(guildButton, x, y) then
				pressGuild = true
				guildButton:setScale(0.95)
			end
		elseif event == "ended" then
			if pressGuild then
				guildButton:setScale(1)
				if ed.containsPoint(guildButton, x, y) then
					showGuildReward(self)
				end
			end
			pressGuild = nil
		end
	end
	return handler
end
class.doGuildButtonTouch = doGuildButtonTouch
local function doRecordTouch(self)
	local isPress
	local self = self
	local function handler(event, x, y)
		local button = self.guildUI and self.guildUI.record or nil
		if button == nil then
			return
		end
		if self.mode ~= "guild" then
			return
		end
		if event == "began" then
			if button:isVisible() and ed.containsPoint(button, x, y) then
				isPress = true
				button:setScale(0.95)
			end
		elseif event == "ended" then
			if isPress then
				button:setScale(1)
				if ed.containsPoint(button, x, y) then
					local raidId = getRaidIdByChapter(self:getChapter())
					if raidId then
						local msg = ed.upmsg.guild()
						msg._instance_damage = {}
						msg._instance_damage._raid_id = raidId
						ed.send(msg, "guild")
					end
				end
			end
			isPress = nil
		end
	end
	return handler
end
class.doRecordTouch = doRecordTouch
local getMainTouchHandler = function(self)
	local modeButtonTouch = self:doModeButtonTouch()
	local chapterDrag = self:doChapterDrag()
	local changeChapterButtonTouch = self:doChangeChapterButtonTouch()
	local guildButtonTouch = self:doGuildButtonTouch()
	local recordTouch = self:doRecordTouch()
	local function handler(event, x, y)
		xpcall(function()
			modeButtonTouch(event, x, y)
			chapterDrag(event, x, y)
			changeChapterButtonTouch(event, x, y)
			self:doStageTouch()(event, x, y)
			guildButtonTouch(event, x, y)
			if recordTouch then
				recordTouch(event, x, y)
			end
			if event == "ended" then
				self.dragMode = nil
				self.isClickChangeChapterButton = nil
			end
		end, EDDebug)
		return true
	end
	return handler
end
class.getMainTouchHandler = getMainTouchHandler
local function setChapterButtonState(self)
	local max = CHAPTER_MAX
	max = math.min(max, self:getMaxChapter())
	local min = self:getMinChapter()
	local chapter
	chapter = self:getChapter()
	if chapter == min then
		self.leftArrow:setVisible(false)
		self.rightArrow:setVisible(true)
	end
	if chapter == max then
		self.leftArrow:setVisible(true)
		self.rightArrow:setVisible(false)
	end
	if min < chapter and max > chapter then
		self.leftArrow:setVisible(true)
		self.rightArrow:setVisible(true)
	end
	if max == min then
		self.leftArrow:setVisible(false)
		self.rightArrow:setVisible(false)
	end
end
class.setChapterButtonState = setChapterButtonState
local refreshDot = function(self, showAnim)
	self:createDot(showAnim)
	if showAnim then
		self.dotContainer:setOpacity(0)
		local fadein = CCFadeIn:create(0.2)
		self.dotContainer:runAction(fadein)
	end
end
class.refreshDot = refreshDot
local function createDot(self)
	if self.dotContainer then
		self.dotContainer:removeFromParentAndCleanup(true)
	end
	local max = self:getMaxChapter()
	local current = self:getChapter()
	local dotContainer = CCSprite:create()
	self.dotContainer = dotContainer
	self.mainLayer:addChild(dotContainer, 30)
	dotContainer:setCascadeOpacityEnabled(true)
	local dotIcon = {}
	for i = 1, max do
		local icon
		if i == current then
			icon = ed.createSprite(res.dotRes.current)
		else
			icon = ed.createSprite(res.dotRes.normal)
		end
		icon:setPosition(self:getDotPos(max, i))
		dotContainer:addChild(icon)
	end
	self.dotIcon = dotIcon
	if self.mode == "guild" then
		self.dotContainer:setVisible(false)
	else
		self.dotContainer:setVisible(true)
	end
end
class.createDot = createDot
local function createChapterButton(self)
	local left = ed.createSprite("UI/alpha/HVGA/prevchap.png")
	local right = ed.createSprite("UI/alpha/HVGA/nextchap.png")
	left:setPosition(ccp(78, 215))
	right:setPosition(ccp(720, 215))
	self.leftArrow = left
	self.rightArrow = right
	self.mainLayer:addChild(left, 30)
	self.mainLayer:addChild(right, 30)
	local lmove = CCMoveTo:create(1, ccp(68, 215))
	local lreverse = CCMoveTo:create(1, ccp(78, 215))
	local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
	self.leftArrow:runAction(CCRepeatForever:create(lsequence))
	local rmove = CCMoveTo:create(1, ccp(730, 215))
	local rreverse = CCMoveTo:create(1, ccp(720, 215))
	local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
	self.rightArrow:runAction(CCRepeatForever:create(rsequence))
	self:setChapterButtonState()
end
class.createChapterButton = createChapterButton
local function createModeButton(self)
	local modeContainer = CCSprite:create()
	self.modeContainer = modeContainer
	self.mainLayer:addChild(modeContainer, 20)
	self.modeui = {}
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "buttonBg",
				res = "UI/alpha/HVGA/crusade_Button_bg.png"
			},
			layout = {
				position = ccp(400, 355)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "normal",
				res = "UI/alpha/HVGA/elitetoggle-ns.png"
			},
			layout = {
				position = ccp(550, 385)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "normal_press",
				parent = "normal",
				res = "UI/alpha/HVGA/elitetoggle-s.png",
			},
			layout = {
				position = ccp(50, 25)
			},
			config = {visible = false}
		},
		{
			t = "Label",
			base = {
				name = "normal_label",
				parent = "normal",
				text = T(LSTR("STAGESELECT.NORMAL")),
				fontinfo = "ui_normal_button",
				size = 18,
			},
			layout = {
				position = ccp(50, 25)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "elite",
				res = "UI/alpha/HVGA/elitetoggle-ns.png"
			},
			layout = {
				position = ccp(600, 385)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "elite_press",
				parent = "elite",
				res = "UI/alpha/HVGA/elitetoggle-s.png",
			},
			layout = {
				position = ccp(50, 25)
			},
			config = {visible = false}
		},
		{
			t = "Label",
			base = {
				name = "elite_label",
				text = T(LSTR("EQUIPCRAFT.ELITE")),
				fontinfo = "ui_normal_button",
				parent = "elite",
				size = 18,
			},
			layout = {
				position = ccp(50, 25)
			},
			config = {visible=false}
		},
		{
			t = "Sprite",
			base = {
				name = "guild",
				res = "UI/alpha/HVGA/elitetoggle-ns.png"
			},
			layout = {
				position = ccp(489, 350)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "guild_press",
				parent = "guild",
				res = "UI/alpha/HVGA/elitetoggle-s.png"
			},
			layout = {
				position = ccp(60, 25)
			},
			config = {visible = false}
		},
		{
			t = "Label",
			base = {
				name = "guild_label",
				text = T(LSTR("STAGESELECT.RAID")),
				fontinfo = "ui_normal_button",
				size = 18
			},
			layout = {
				position = ccp(489, 349)
			},
			config = {}
		}
	}
	local readNode = ed.readnode.create(modeContainer, self.modeui)
	readNode:addNode(ui_info)
end
class.createModeButton = createModeButton
local getTitleRes = function(self, chapter)
	return string.format("UI/alpha/HVGA/maptitle-chapter%d.png", chapter)
end
class.getTitleRes = getTitleRes
local function createTitleText(self,container,chapter)
	local chapterTable = ed.getDataTable("Chapter")
	local chapterName = chapterTable[chapter]["Pre Chapter Name"] .. "   " ..chapterTable[chapter]["Chapter Name"]
	self.chapterTitleUI = {}
	local ui_info = {
		{
			t = "Label",
			base = {
				name = "chapterName",
				text = chapterName,
				fontinfo = "ui_normal_button"
			},
			layout = {
				position = ccp(397, 393)
			},
			config = {
				color = ccc3(250, 205, 16)
			}
		}
	}
	local readNode = ed.readnode.create(container, self.chapterTitleUI)
	readNode:addNode(ui_info)
end
class.createTitleText = createTitleText
local function createTitle(self, chapter)
	local preTitle
	if not tolua.isnull(self.titleContainer) then
		if not tolua.isnull(self.preTitle) then
			self.preTitle:removeFromParentAndCleanup(true)
		end
		preTitle = self.titleContainer
		self.preTitle = preTitle
	end
	local titleui = {}
	local titleContainer = CCSprite:create()
	self.titleContainer = titleContainer
	titleContainer:setCascadeOpacityEnabled(true)
	self.mainLayer:addChild(titleContainer, 22)

	--local title = ed.createSprite(self:getTitleRes(chapter))
	self:createTitleText(titleContainer,chapter)
	titleui.title = self.chapterTitleUI.chapterName
	--title:setPosition(ccp(265, 380))
	--titleContainer:addChild(title)
	self.titleui = titleui
	if preTitle then
		titleContainer:setOpacity(0)
		local fadeout = CCFadeOut:create(0.2)
		local func = CCCallFunc:create(function()
			xpcall(function()
				if not tolua.isnull(titleContainer) then
					local fadein = CCFadeIn:create(0.2)
					titleContainer:runAction(fadein)
				end
				if not tolua.isnull(preTitle) then
					preTitle:removeFromParentAndCleanup(true)
					self.preTitle = nil
				end
			end, EDDebug)
		end)
		local sequence = CCSequence:createWithTwoActions(fadeout, func)
		preTitle:runAction(sequence)
	end
end
class.createTitle = createTitle
local function createTitleBg(self)
	local res
	if self.mode == "elite" then
		res = "UI/alpha/HVGA/Elite_title_bg.png"
	elseif self.mode == "guild" then
		res = "UI/alpha/HVGA/guild_title_bg.png"
	else
		res = "UI/alpha/HVGA/Normal_title_bg.png"
	end
	if self.titleBg then
		self.titleBg:removeFromParentAndCleanup(true)
	end
	local titleBg = ed.createSprite(res)
	titleBg:setPosition(ccp(397, 393))
	self.titleBg = titleBg
	self.mainLayer:addChild(titleBg, 21)
end
class.createTitleBg = createTitleBg
local function createFrame(self, chapter, mode)
	self:createTitleBg()
	local preFrame
	if not tolua.isnull(self.frameContainer) then
		preFrame = self.frameContainer
		preFrame:setZOrder(6)
	end
	local frameui = {}
	local frameContainer = CCSprite:create()
	self.frameContainer = frameContainer
	frameContainer:setCascadeOpacityEnabled(true)
	self.mainLayer:addChild(frameContainer, 5)
	local res
	if mode == "elite" then
		res = "UI/alpha/HVGA/stage-map-elite-frame.png"
	elseif mode == "guild" then
		res = "UI/alpha/HVGA/stage_map_guild_frame.png"
	else
		res = "UI/alpha/HVGA/stage-map-frame.png"
	end
	local frame = ed.createSprite(res)
	frameui.frame = frame
	if mode ~= "normal" then
		frame:setPosition(ccp(400, 207))
	else
		frame:setPosition(ccp(400, 205))
	end
	frameContainer:addChild(frame)
	self.frameui = frameui
	if preFrame then
		frameContainer:setOpacity(0)
		if not tolua.isnull(frameContainer) then
			local fadein = CCFadeIn:create(0.2)
			frameContainer:runAction(fadein)
		end
		local fade = CCFadeOut:create(0.2)
		local func = CCCallFunc:create(function()
			xpcall(function()
				if not tolua.isnull(preFrame) then
					preFrame:removeFromParentAndCleanup(true)
				end
			end, EDDebug)
		end)
		local sequence = CCSequence:createWithTwoActions(fade, func)
		preFrame:runAction(sequence)
	end
end
class.createFrame = createFrame
local function getStageRes(info, tag, mode, chapter)
	local stageRes = res.stageRes
	local keyStageRes = res.keyStageRes
	local id = info.id
	local eid = info.eid
	local resid = info.resid or id
	local guildInstanceId = info.guildInstanceId
	local stageInfo = ed.getDataTable("Stage")
	local iskey = stageInfo[id]["Key Stage"]
	if mode == "elite" then
		if iskey then
			if id > 1 and ed.player:getStageStar(eid) <= 0 and ed.player:getStageStar(eid - 1) <= 0 then
				return "locked", string.format(keyStageRes.icon.locked, resid)
			elseif ed.player:getStageStar(eid) <= 0 then
				return "current", string.format(keyStageRes.icon.current, resid), string.format(keyStageRes.mask.current, resid)
			else
				return "passed", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
			end
		else
			return "locked", stageRes.elite
		end
	elseif mode == "normal" then
		if iskey then
			if id > 1 and ed.player:getStageStar(id) <= 0 and ed.player:getStageStar(id - 1) <= 0 then
				return "locked", string.format(keyStageRes.icon.locked, resid)
			elseif ed.player:getStageStar(id) <= 0 then
				return "current", string.format(keyStageRes.icon.current, resid), string.format(keyStageRes.mask.current, resid)
			else
				return "passed", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
			end
		elseif id > 1 and ed.player:getStageStar(id) <= 0 and ed.player:getStageStar(id - 1) <= 0 then
			return "locked", string.format(stageRes.locked, tag)
		elseif ed.player:getStageStar(id) <= 0 then
			return "current", stageRes.current
		else
			return "passed", stageRes.passed
		end
	else
		local info = ed.ui.guild.getInstanceInfo(chapter)
		if iskey then
			if info == nil or guildInstanceId > info.stageId then
				return "locked", string.format(keyStageRes.icon.locked, resid)
			elseif guildInstanceId == info.stageId and info.RaidProgress ~= 10000 then
				return "current", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
			else
				return "passed", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
			end
		else
			return "locked", stageRes.elite
		end
	end
end
class.getStageRes = getStageRes
local function createGuildUI(self, container, chapter)
	if self.mode ~= "guild" then
		return
	end
	if nil == container then
		return
	end
	self.guildUI = {}
	local ui_info = {
		{
			t = "Scale9Sprite",
			base = {
				name = "bottomframe",
				res = "UI/alpha/HVGA/crusade/crusade_reset_bg.png",
				capInsets = CCRectMake(20, 20, 18, 18)
			},
			layout = {
				position = ccp(402, 55)
			},
			config = {
				scaleSize = CCSizeMake(500, 58)
			}
		},
		{
			t = "RichText",
			base = {name = "leftNum", text = ""},
			layout = {
				anchor = ccp(0, 0.5),
				position = ccp(185, 55)
			}
		},
		{
			t = "RichText",
			base = {name = "leftTime", text = ""},
			layout = {
				anchor = ccp(0, 0.5),
				position = ccp(185, 42)
			}
		},
		{
			t = "Scale9Sprite",
			base = {
				name = "reward",
				res = "UI/alpha/HVGA/elitetoggle-ns.png",
				capInsets = CCRectMake(40, 20, 60, 23)
			},
			layout = {
				position = ccp(570, 55)
			},
			config = {
				scaleSize = CCSizeMake(140, 50)
			}
		},
		{
			t = "Scale9Sprite",
			base = {
				name = "reward_press",
				res = "UI/alpha/HVGA/elitetoggle-s.png",
				capInsets = CCRectMake(40, 20, 60, 23),
				parent = "reward"
			},
			layout = {
				anchor = ccp(0, 0),
				position = ccp(0, 0)
			},
			config = {
				visible = false,
				scaleSize = CCSizeMake(140, 50)
			}
		},
		{
			t = "Label",
			base = {
				name = "reward_label",
				text = T(LSTR("stageselect.1.10.1.001")),
				fontinfo = "ui_normal_button",
				parent = "reward",
				size = 16
			},
			layout = {
				position = ccp(70, 24)
			},
			config = {}
		},
		{
			t = "Scale9Sprite",
			base = {
				name = "record",
				res = "UI/alpha/HVGA/elitetoggle-ns.png",
				capInsets = CCRectMake(40, 20, 60, 23)
			},
			layout = {
				position = ccp(450, 55)
			},
			config = {
				scaleSize = CCSizeMake(140, 50)
			}
		},
		{
			t = "Scale9Sprite",
			base = {
				name = "record_press",
				res = "UI/alpha/HVGA/elitetoggle-s.png",
				capInsets = CCRectMake(40, 20, 60, 23),
				parent = "record"
			},
			layout = {
				anchor = ccp(0, 0),
				position = ccp(0, 0)
			},
			config = {
				visible = false,
				scaleSize = CCSizeMake(140, 50)
			}
		},
		{
			t = "Label",
			base = {
				name = "record_label",
				text = T(LSTR("stageselect.1.10.1.002")),
				fontinfo = "ui_normal_button",
				parent = "record",
				z = 1,
				size = 14
			},
			layout = {
				position = ccp(70, 24)
			}
		}
	}
	local readNode = ed.readnode.create(container, self.guildUI)
	readNode:addNode(ui_info)
	local info = ed.ui.guild.getInstanceInfo(chapter)
	if info == nil then
		self.guildUI.leftNum:setString(T(LSTR("stageselect.1.10.1.003")))
		self.guildUI.leftNum:setPosition(ccp(350, 55))
		self.guildUI.reward:setVisible(false)
		self.guildUI.record:setVisible(false)
		self.guildUI.reward_label:setVisible(false)
		self.guildUI.record_label:setVisible(false)
		self.guildUI.leftTime:setVisible(false)
	elseif info.RaidProgress == 10000 then
		self.guildUI.leftNum:setPosition(ccp(185, 55))
		self.guildUI.leftNum:setString(T(LSTR("stageselect.1.10.1.004")))
		self.guildUI.leftTime:setVisible(false)
	else
		self.guildUI.leftNum:setPosition(ccp(185, 65))
		local viplevel = ed.player:getvip()
		local maxTime = ed.getDataTable("VIP")[viplevel]["Raid Enter Times"]
		local leftNum = T(LSTR("stageselect.1.10.1.005"), info.leftTime, maxTime)
		self.guildUI.leftNum:setString(leftNum)
		self.guildUI.leftTime:setVisible(true)
		local hintInfo = ""
		local passTime = ed.getServerTime() - info.startTime
		local h, m, s = ed.second2hms(math.max(0, EDTables.guildConfig.guildInstanceTime - passTime))
		local d = math.floor(h / 24)
		h = h % 24
		if d > 0 then
			hintInfo = T(LSTR("stageselect.1.10.1.006"), d, h)
		elseif h > 0 then
			hintInfo = T(LSTR("stageselect.1.10.1.007"), h, m)
		else
			hintInfo = T(LSTR("stageselect.1.10.1.008"), m, s)
		end
		self.guildUI.leftTime:setString(hintInfo)
	end
end
local function createStage(self, chapter, mode, skipAnim)
	local stageContainer = CCSprite:create()
	self.stageContainer = stageContainer
	stageContainer:setCascadeOpacityEnabled(true)
	local mapInfo = res.map
	local info = mapInfo["chapter" .. chapter]
	if self.currentTag then
		self.currentTag:removeFromParentAndCleanup(true)
		self.currentTag = nil
	end
	local stageIcon = {}
	local stageMask = {}
	for i = 1, #info.stage do
		local t = info.stage[i]
		local type, iconRes, iconMask = self.getStageRes(t, info.tag, mode, chapter)
		local z = t.z or 0
		if iconMask then
			local mask = ed.createSprite(iconMask)
			mask:setPosition(t.pos)
			stageMask[t.id] = mask
			stageContainer:addChild(mask)
			local action = CCFadeTo:create(1, 0)
			local reverse = CCFadeTo:create(1, 255)
			local sequence = CCSequence:createWithTwoActions(action, reverse)
			mask:runAction(CCRepeatForever:create(sequence))
		end
		local icon = ed.createSprite(iconRes)
		icon:setPosition(t.pos)
		stageContainer:addChild(icon, z)
		local spos = {
			{
				ccp(37, 15)
			},
			{
				ccp(26, 18),
				ccp(48, 18)
			},
			{
				ccp(17, 18),
				ccp(37, 15),
				ccp(57, 18)
			}
		}
		local stars = {}
		local starBg
		if mode ~= "guild" then
			local id = mode == "elite" and t.eid or t.id
			local sn = ed.player:getStageStar(id)
			if sn > 0 and t.eid then
				starBg = ed.createSprite("UI/alpha/HVGA/stageselect_star_bg.png")
				starBg:setPosition(ccp(82, 38))
				icon:setCascadeOpacityEnabled(true)
				icon:addChild(starBg)
				starBg:setCascadeOpacityEnabled(true)
				for i = 1, sn do
					local star = ed.createSprite("UI/alpha/HVGA/stageselect_star.png")
					star:setPosition(spos[sn][i])
					starBg:addChild(star)
					stars[i] = star
				end
			end
		end
		table.insert(stageIcon, {
			icon = icon,
			id = t.id,
			eid = t.eid,
			guildInstanceId = t.guildInstanceId,
			type = type,
			pos = t.pos,
			stars = stars,
			starBg = starBg
		})
		if i == 1 then
			local ist = ed.teach("selectStage", icon, self.scene, true)
			if ist then
				self.isSelectStageTutorial = true
				self.showTutorial = true
				self:refresh()
			end
		end
		if type == "current" then
			self.currentStageIcon = icon
			if self.isElite then
			else
			end
			if 0 < (ed.player:getStageStar(t.id) or 0) or not self.isElite then
				local currentTag = ed.createSprite("UI/alpha/HVGA/stagepointer.png")
				local cpos
				if t.eid then
					cpos = ccp(t.pos.x, t.pos.y + 60)
				else
					cpos = ccp(t.pos.x - 1, t.pos.y + 30)
				end
				currentTag:setPosition(cpos)
				self.mainLayer:addChild(currentTag, 50)
				local move = CCMoveTo:create(0.5, ccp(cpos.x, cpos.y + 10))
				local back = CCMoveTo:create(0.5, cpos)
				local sequence = CCSequence:createWithTwoActions(move, back)
				currentTag:runAction(CCRepeatForever:create(sequence))
				self.currentTag = currentTag
				if self.forGetWay or self.showTutorial then
					currentTag:setVisible(false)
				end
			end
			if self.mode == "guild" then
				local processBg = ed.createSprite("UI/alpha/HVGA/guild/guildraid_stageselect_progress_bg.png")
				processBg:setAnchorPoint(ccp(0, 0))
				processBg:setPosition(ccp(40, 60))
				icon:addChild(processBg)
				local info = ed.ui.guild.getInstanceInfo(chapter)
				local layer = CCLayer:create()
				layer:setAnchorPoint(ccp(0, 0))
				layer:setPosition(ccp(40, 60))
				icon:addChild(layer)
				local process = ed.createSprite("UI/alpha/HVGA/guild/guildraid_stageselect_progress_done.png")
				process:setAnchorPoint(ccp(0, 0))
				process:setPosition(ccp(2, 3))
				layer:addChild(process)
				local size = process:getContentSize()
				local width = size.width * info.progress / 10000
				layer:setClipRect(CCRectMake(0, 0, width, size.height * 1.5))
			end
		end
		local isElite = mode == "elite"
		if t.id == self.getWayStage and isElite == self.getWayMode then
			local circle = ed.createSprite("UI/alpha/HVGA/tutorial_circle.png")
			circle:setPosition(t.pos)
			stageContainer:addChild(circle)
			local s1 = CCScaleTo:create(0.65, 1.35)
			local s2 = CCScaleTo:create(0.65, 1)
			local action = CCSequence:createWithTwoActions(s1, s2)
			action = CCRepeatForever:create(action)
			circle:runAction(action)
			self.circle = circle
			local finger = ed.createSprite("UI/alpha/HVGA/tutorial_finger.png")
			finger:setPosition(ccp(t.pos.x - 4, t.pos.y + 4))
			finger:setAnchorPoint(ccp(0, 1))
			stageContainer:addChild(finger)
			local m1 = CCMoveTo:create(0.65, ccp(t.pos.x + 13.5, t.pos.y - 13.5))
			local m2 = CCMoveTo:create(0.65, ccp(t.pos.x - 4, t.pos.y + 4))
			local action = CCSequence:createWithTwoActions(m1, m2)
			action = CCRepeatForever:create(action)
			finger:runAction(action)
			self.finger = finger
		end
	end
	self.stageIcon = stageIcon
	self.stageMask = stageMask
	createGuildUI(self, stageContainer, chapter)
	self.mapContainer:addChild(stageContainer, 15)
end
class.createStage = createStage
local function createMap(self, chapter, mode, skipAnim)
	local preMap
	if not tolua.isnull(self.mapContainer) then
		if not tolua.isnull(self.preMap) then
			self.preMap:removeFromParentAndCleanup(true)
		end
		preMap = self.mapContainer
		preMap:setZOrder(1)
		self.preMap = preMap
	end
	local mapInfo = res.map
	local ui = {}
	local info = mapInfo["chapter" .. chapter]
	local mapContainer = CCSprite:create()
	self.mapContainer = mapContainer
	mapContainer:setCascadeOpacityEnabled(true)
	local bg = ed.createSprite(info.bg.res)
	bg:setPosition(info.bg.pos)
	mapContainer:addChild(bg)
	ui.bg = bg
	local route = ed.createSprite(info.route.res)
	route:setPosition(info.route.pos)
	mapContainer:addChild(route)
	ui.route = route
	self.mapui = ui
	self.clipLayer:addChild(self.mapContainer)
	self:createStage(chapter, mode, skipAnim)
	if preMap then
		if not skipAnim then
			do
				local action, showDotAnim
				if self.lastOperation == "changeChapter" then
					local ox, oy = 0, 0
					local cx, cy = ox, oy
					local gx, gy = ox, oy
					if self.preChapter > self:getChapter() then
						gx = ox + 720
						cx = ox - 720
					elseif self.preChapter < self:getChapter() then
						gx = ox - 720
						cx = ox + 720
					end
					mapContainer:setPosition(ccp(cx, cy))
					action = CCMoveTo:create(change_chapter_gap, ccp(gx, gy))
					action = CCEaseSineOut:create(action)
					local come = CCMoveTo:create(change_chapter_gap, ccp(ox, oy))
					come = CCEaseSineOut:create(come)
					mapContainer:runAction(come)
					preMap:stopAllActions()
					preMap:setPosition(ccp(ox, oy))
				elseif self.lastOperation == "changeMode" then
					action = CCFadeOut:create(0.5)
					showDotAnim = true
					self:refreshDot(true)
				end
				local func = CCCallFunc:create(function()
					xpcall(function()
						if not tolua.isnull(preMap) then
							preMap:removeFromParentAndCleanup(true)
							if not showDotAnim then
								self:refreshDot()
							end
							self.preMap = nil
						end
					end, EDDebug)
				end)
				local sequence = CCSequence:createWithTwoActions(action, func)
				preMap:runAction(sequence)
			end
		else
			preMap:removeFromParentAndCleanup(true)
		end
	end
	updateGuildInstanceButton(self)
end
class.createMap = createMap
local function getNormalInformation(self)
	local normalInfo = {}
	normalInfo.progress = self:getNormalProgress()
	normalInfo.chapter = math.min(self:getMaxNormalChapter(), ed.playerlimit.maxChapter())
	normalInfo.maxChapter = math.min(self:getMaxNormalChapter(), ed.GameConfig.MaxChapter);
	self.normalInfo = normalInfo
end
class.getNormalInformation = getNormalInformation
local function getEliteInformation(self)
	local eliteInfo = {}
	eliteInfo.progress = self:getEliteProgress()
	local stageInfo = ed.getDataTable("Stage")
	eliteInfo.chapter = math.min(self:getMaxEliteChapter(), ed.playerlimit.maxChapter())
	eliteInfo.maxChapter = math.min(self:getMaxEliteChapter(), ed.GameConfig.MaxChapter);
	self.eliteInfo = eliteInfo
end
class.getEliteInformation = getEliteInformation
local getGuildInfomation = function(self)
	local guildInfo = {}
	guildInfo.chapter = self:getMinGuildInstanceChapter()
	guildInfo.maxChapter = math.min(self:getMaxGuildInstanceChapter(), ed.GameConfig.MaxChapter);
	self.guildInfo = guildInfo
end
class.getGuildInfomation = getGuildInfomation
local getInformation = function(self)
	self:getNormalInformation()
	self:getEliteInformation()
	self:getGuildInfomation()
end
class.getInformation = getInformation
local function onEnterHandler(self)
	local function handler(event)
		xpcall(function()
			if event == "enter" then
				self.intoStageDetail = false
				local preNormal, preElite, preGuildInstance
				local preNormalChapter = self.normalInfo.chapter
				local preEliteChapter = self.eliteInfo.chapter
				local preMaxChapter
				if self.mode == "elite" then
					if self.eliteInfo then
						preElite = self.eliteInfo.progress
						preMaxChapter = self.eliteInfo.maxChapter
					end
				elseif self.mode == "normal" then
					if self.normalInfo then
						preNormal = self.normalInfo.progress
						preMaxChapter = self.normalInfo.maxChapter
					end
				else
					self:createMap(self.guildInfo.chapter, "guild", true)
				end
				if preNormal or preElite then
					self:getInformation()
					if preNormalChapter then
						self.normalInfo.chapter = preNormalChapter
					end
					if preEliteChapter then
						self.eliteInfo.chapter = preEliteChapter
					end
					if preNormal and preNormal ~= self.normalInfo.progress then
						if preMaxChapter ~= self.normalInfo.maxChapter and self:getMaxNormalChapter() <= ed.playerlimit.maxChapter() then
							self.normalInfo.chapter = self.normalInfo.maxChapter
							self:createMap(self.normalInfo.maxChapter, "normal", true)
							self:createTitle(self.normalInfo.maxChapter)
							self:refreshDot()
						else
							self:createMap(self.normalInfo.chapter, "normal", true)
						end
					elseif preNormal then
						self:createMap(self.normalInfo.chapter, "normal", true)
					end
					if preElite and preElite ~= self.eliteInfo.progress then
						if preMaxChapter ~= self.eliteInfo.maxChapter and self:getMaxEliteChapter() <= ed.playerlimit.maxChapter() then
							self.eliteInfo.chapter = self.eliteInfo.maxChapter
							self:createMap(self.eliteInfo.maxChapter, "elite", true)
							self:createTitle(self.eliteInfo.maxChapter)
							self:refreshDot()
						else
							self:createMap(self.eliteInfo.chapter, "elite", true)
						end
					elseif preElite then
						self:createMap(self.eliteInfo.chapter, "elite", true)
					end
				end
				self:setChapterButtonState()
				if ed.playerlimit.checkAreaUnlock("Elite") then
					self.modeui.normal:setVisible(true)
					self.modeui.normal_label:setVisible(true)
					self.modeui.elite:setVisible(true)
					self.modeui.elite_label:setVisible(true)
					self.modeui.buttonBg:setVisible(true)
					updateGuildInstanceButton(self)
					local ist = ed.teach("clickEliteModeButton", self.modeui.elite, self.mainLayer)
					if ist then
						self.showTutorial = true
						self:refresh()
					end
				else
					self.modeui.normal_label:setVisible(false)
					self.modeui.normal:setVisible(false)
					self.modeui.elite:setVisible(false)
					self.modeui.elite_label:setVisible(false)
					self.modeui.guild:setVisible(false)
					self.modeui.buttonBg:setVisible(false)
				end
			end
		end, EDDebug)
	end
	return handler
end
class.onEnterHandler = onEnterHandler
local function getGuildInstanceChapter(self)
	local min = self.guildInfo.chapter
	local max = self.guildInfo.maxChapter
	local st = ed.getDataTable("Stage")
	local progress = ed.player:getStageProgress()
	local maxChapter = st[progress]["Chapter ID"]
	for i = max, min, -1 do
		local id = ed.ui.guild.getInstanceInfo(i)
		if id and i <= maxChapter then
			self.guildInfo.chapter = i
			return
		end
	end
end
class.getGuildInstanceChapter = getGuildInstanceChapter
local function create(chapter, mode, stage)
	local identity
	if stage then
		identity = "stageSelectGWMode"
	else
		identity = "stageSelect"
	end
	local self = base.create(identity)
	setmetatable(self, class.mt)
	self:getInformation()
	chapter = chapter or self.normalInfo.chapter
	local mode = mode or "normal"
	self.isElite = mode == "elite"
	self.mode = mode
	if stage then
		if self.mode ~= "guild" then
			self.getWayStage = stage
			self.getWayMode = self.isElite
			self.forGetWay = true
		end
		if mode == "elite" then
			self.eliteInfo.chapter = chapter
		elseif mode == "normal" then
			self.normalInfo.chapter = chapter
		else
			self.guildInfo.chapter = chapter
		end
	elseif mode == "elite" then
		chapter = self.eliteInfo.chapter
	elseif mode == "normal" then
		chapter = self.normalInfo.chapter
	elseif mode == "guild" then
		self.guildInfo.chapter = chapter
	end
	local mainLayer = self.mainLayer
	local clipLayer = CCLayer:create()
	self.clipLayer = clipLayer
	mainLayer:addChild(clipLayer)
	clipLayer:setClipRect(CCRectMake(44, 20, 712, 372))
	self:registerRefreshHandler("refreshCurrentTag", self:refreshCurrentTag())
	self:createMap(chapter, mode)
	self:createFrame(chapter, mode)
	self:createTitle(chapter)
	self:createModeButton()
	self:createChapterButton()
	self:createDot()
	updateModeButtonState(self)
	self:btRegisterHandler({
		handler = self:getMainTouchHandler(),
		key = "stage_select_main"
	})
	mainLayer:registerScriptHandler(self:onEnterHandler())
	self:registerOnPopSceneHandler("onPop", function()
		CloseEvent("GuildInstanceQuery")
	end)
	ListenEvent("GuildInstanceQuery", function(stagePass)
		if stagePass == nil then
			self:getGuildInstanceChapter()
		end
		self:doChangeMode("guild")
	end)
	updateGuildInstanceButton(self)
	return self
end
class.create = create
local function createByStage(stage)
	local chapter, mode
	local stageTable = ed.getDataTable("Stage")
	local type = ed.stageType(stage)
	if type == "normal" then
		mode = "normal"
		local row = stageTable[stage]
		chapter = row["Chapter ID"]
	elseif type == "raid" then
		mode = "guild"
		stage = stageTable[stage]["Stage Group"]
		local row = stageTable[stage]
		chapter = row["Chapter ID"]
	else
		mode = "elite"
		stage = stageTable[stage]["Stage Group"]
		local row = stageTable[stage]
		chapter = row["Chapter ID"]
	end
	local self = create(chapter, mode, stage)
	return self
end
class.createByStage = createByStage
local refreshCurrentTag = function(self)
	local function handler()
		if tolua.isnull(self.currentTag) then
			return
		end
		if self.showTutorial then
			self.currentTag:setVisible(false)
		else
			self.currentTag:setVisible(true)
		end
	end
	return handler
end
class.refreshCurrentTag = refreshCurrentTag

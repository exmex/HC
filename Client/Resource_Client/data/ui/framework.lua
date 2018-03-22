local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.framework = class
setimplements(class, ed.ui.statusbar, ed.ui.shortcut)
local res = ed.ui.uires
local lsr = ed.ui.frameworklsr.create()
local checkFirstInMain = function(self)
	return not ed.tutorial.checkDone("gotoSelectStage") and self.identity == "main"
end
class.checkFirstInMain = checkFirstInMain
local function doClickBack(self)
    --add by xinghui:send dot info when back to main from tarwin
    if --[[ed.tutorial.checkDone("FTbackToMain")== false--]] ed.tutorial.isShowTutorial then
        if ed.tutorial.checkDone("FTbackToMain")== false then
            ed.sendDotInfoToServer(ed.tutorialres.t_key["FTbackToMain"].id)
        elseif ed.tutorial.checkDone("backToStageSelect")== false then
            ed.sendDotInfoToServer(ed.tutorialres.t_key["backToStageSelect"].id)
        end
    end
    ed.endTeach("FTbackToMain")
  --
    --add by xinghui:send dot info when back to main from equip
--    if ed.tutorial.checkDone("backToStageSelect")== false then
--        ed.sendDotInfoToServer()
--    end
  --
	ed.endTeach("backToStageSelect")
	lsr:report("clickBack")
	ed.popScene()
end
class.doClickBack = doClickBack

local doClickDailyjob = function(self)
	self.scene:addChild(ed.ui.dailyTask.create(function()
		xpcall(function()
			self:checkShortcutButtonTag()
			end, EDDebug)
			end).mainLayer, 101)
end
class.doClickDailyjob = doClickDailyjob

local function doShortcut(self)
	local function handler(skipAnim)
		if self.isPopsb or self.isPushsb then
			return
		end
		self.isShortcutOpen = not self.isShortcutOpen
		self:scRefreshTags()
		local upButton = self.sc_ui.up
		local downButton = self.sc_ui.down
		if self.isShortcutOpen then
			lsr:report("openShortcut")
			upButton:setVisible(true)
			self:openShortcutBoard(skipAnim)
		else
			lsr:report("closeShortcut")
			upButton:setVisible(false)
			self:closeShortcutBoard(skipAnim)
		end
		local ist = self:createEquipPropTT()
		if not ist then
			self:createCompleteTaskTT()
		end
	end
	return handler
end
class.doShortcut = doShortcut

local function getVitalityPromptText(self)
	local gap = res.sync_vitality_gap
	local lt = math.max(ed.playerlimit.maxVitality() - ed.player:getVitality() - 1, 0)
	local vnu = ed.player:getVitalityNextUpdate()
	local nextText = ed.gethmsNString(vnu)
	local totalText = ed.gethmsNString(gap * lt + vnu)
	local gapText = res.vit_gap .. T(LSTR("TIME.MINUTE"))
	local prompt = T(LSTR("FRAMEWORK.CURRENT_TIME")) .. ed.serverTime2HMS() .. "\n"
	prompt = prompt .. T(LSTR("FRAMEWORK.BOUGHT_ENERGY_TIMES___D_D"), ed.player:getVitalityBuyTimes(), ed.getDataTable("VIP")[ed.player:getvip()]["Buy Vit Max"])
	prompt = prompt .. "\n"
	local alignment = "left"
	if ed.playerlimit.maxVitality() <= ed.player:getVitality() then
		prompt = prompt .. T(LSTR("FRAMEWORK.ALREADY_BACK_TO_FULL_STRENGTH"))
	else
		prompt = prompt .. T(LSTR("FRAMEWORK.ENERGY_BACKS_IN__")) .. nextText
		prompt = prompt .. "\n"
		prompt = prompt .. T(LSTR("FRAMEWORK.RESTORE_FULL_STRENGTH_")) .. totalText
		prompt = prompt .. "\n"
		prompt = prompt .. T(LSTR("FRAMEWORK.RECOVERY_INTERVAL_")) .. gapText
	end
	return prompt, alignment
end
class.getVitalityPromptText = getVitalityPromptText

local createPromptCard = function(self, text, alignment)
	self:destroyPromptCard()
	local container = CCSprite:create()
	self.ppContainer = container
	local pos = ccp(400, 400)
	local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(15, 20, 45, 15))
	bg:setAnchorPoint(ccp(0.5, 1))
	bg:setPosition(pos)
	container:addChild(bg)
	local label = ed.createttf(text, 20)
	if alignment == "center" then
	else
		label:setHorizontalAlignment(kCCTextAlignmentLeft)
	end
	ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
	container:addChild(label)
	local size = label:getContentSize()
	bg:setContentSize(CCSizeMake(size.width + 30, size.height + 28))
	label:setPosition(ccp(pos.x, pos.y - (size.height + 24) / 2))
	self.infoLayer:addChild(container, 60)
	return label
end
class.createPromptCard = createPromptCard

local createVitalityPrompt = function(self)
	local prompt, alignment = self:getVitalityPromptText()
	local label = self:createPromptCard(prompt, alignment)
	self:registerUpdateHandler("refreshVitalityPrompt", self:refreshVitalityPromptHandler())
	self.vitPromptLabel = label
end
class.createVitalityPrompt = createVitalityPrompt

local createPlayerPrompt = function(self)
	local tlevel = ed.player:getLevel()
	local hlevel = ed.playerlimit.heroLevelLimit()
	local exp = ed.player:getExp()
	local maxexp = ed.player:getMaxExp()
	local text = T(T(LSTR("FRAMEWORK.TEAM_LEVEL__D_\N")), tlevel)
	text = T(text .. T(LSTR("FRAMEWORK.TEAM_EXPERIENCE__D__D_\N")), exp, maxexp)
	text = T(text .. T(LSTR("FRAMEWORK.HERO_LEVEL_CAP__D_\N")), hlevel)
	text = T(text .. T(LSTR("FRAMEWORK.ACCOUNT_ID__D")), ed.getUserid())
	self:createPromptCard(text)
end
class.createPlayerPrompt = createPlayerPrompt

local refreshVitalityPromptHandler = function(self)
	local count = 0
	local function handler(dt)
		if tolua.isnull(self.ppContainer) or tolua.isnull(self.vitPromptLabel) then
			self:removeUpdateHandler("refreshVitalityPrompt")
			return
		end
		count = count + dt
		if count > 1 then
			local prompt = self:getVitalityPromptText()
			ed.setString(self.vitPromptLabel, prompt)
			count = count - 1
		end
	end
	return handler
end
class.refreshVitalityPromptHandler = refreshVitalityPromptHandler

local destroyPromptCard = function(self)
	if not tolua.isnull(self.ppContainer) then
		self.ppContainer:removeFromParentAndCleanup(true)
		self.ppContainer = nil
	end
end
class.destroyPromptCard = destroyPromptCard

local function doClickMidas(self)
	lsr:report("clickMoney")
	local pl = ed.playerlimit
	local ds = pl.getAreaUnlockPrompt("Midas")
	if ds then
		ed.showToast(ds)
	else
		local midas = ed.ui.midas.create()
		self.mainLayer:addChild(midas.mainLayer, 300)
	end
end
class.doClickMidas = doClickMidas

local function doClickrmb(self)
	--[[
	lsr:report("clickrmb")
	local rechargeLayer = ed.ui.recharge.create()
	self.mainLayer:addChild(rechargeLayer.mainLayer, 150)
	--]]
	local rechargeLayer = newrecharge.create()
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		scene:addChild(rechargeLayer, 101000)
	end
end
class.doClickrmb = doClickrmb

local showDailyLogin = function(self)
	LegendLog("popScene showDailyLogin")
	self.mainLayer:addChild(ed.ui.dailylogin.create({
	callback = function()
		self:sbRefreshDailyloginTag()
	end
	}).mainLayer, 200)
end
class.showDailyLogin = showDailyLogin

--add by cooper.x for activity
local function GotoActivity(self)
    local function handler(data)
        xpcall(
        function()
            local activityIndex = 1--add by cooper.x

            if (#data._last_activity_info)<=0 then
                ed.showToast(LSTR("ACTIVITY.EMPTY"))
                return
            else 
                ed.activitys.ActivityPage.activityIds = data._last_activity_info
            end

            local ccb_container = ed.loadccbi(ed.activitys.ActivityPage, "ccbi/ActivePage.ccbi")
            ed.ccb_container = ccb_container
            ccb_container:setPosition(ccp(0,0));
            
            self.mainLayer:setTouchEnabled(false)
            self.mainLayer:addChild(ccb_container, 200)

            --time
            local timeNode = ccb_container:getCCNodeFromCCB("mActiveTitleNode")
            if timeNode then
--                local x, y = timeNode:getPosition();
--                timeNode:setPosition(ccp(x+75, y-45))
            end
            local titleNode = ccb_container:getCCNodeFromCCB("mTitleNode")
            if titleNode then
--                local x, y = titleNode:getPosition()
--                titleNode:setPosition(x, y-60)
            end
            local closeBtnNode = ccb_container:getCCNodeFromCCB("mCloseNode")
            if closeBtnNode then
--                local x, y = closeBtnNode:getPosition();
--                closeBtnNode:setPosition(ccp(x-95, y-55))
            end
            --set activity ccb root node position
            local ccbNode = ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
            if ccbNode then
--                local x, y = ccbNode:getPosition()
--                ccbNode:setPosition(ccp(x+40, y+55))
                --ccbNode:setScale(1.25)
            end

            local ccbSprite = ccb_container:getCCSpriteFromCCB("mActivePageBG")
            if ccbSprite then
               -- ccbSprite:setScale(1.25)
            end
            ccbSprite = ccb_container:getCCSpriteFromCCB("mTimeBG")
            if ccbSprite then
                --ccbSprite:setScale(1.25)
            end
            ccbSprite = ccb_container:getCCSpriteFromCCB("mActivePageTitleBG")
            if ccbSprite then
                --ccbSprite:setScale(1.25)
            end

            local activityTitleLabel = ccb_container:getCCLabelTTFFromCCB("mTitle")
            if activityTitleLabel then
                activityTitleLabel:setString(LSTR("ACTIVITIESLISTCONFIG.EXCITING_ACTIVITIES"))
            end

            local year, month, day = ed.time2YMD()
            local sprite_day = ccb_container:getCCSpriteFromCCB("mDay1")
            local sprite_day2 = ccb_container:getCCSpriteFromCCB("mDay2")
            if sprite_day and sprite_day2 then
                local bitIndex = day % 10
                local tenIndex = day / 10
                tenIndex = math.floor(tenIndex)
                local tenStr = "UI/alpha/HVGA/digits/ActiveTime/"..tenIndex..".png"
                local bitStr = "UI/alpha/HVGA/digits/ActiveTime/"..bitIndex..".png"
                local tenTex = CCTextureCache:sharedTextureCache():addImage(tenStr);
                local bitTex = CCTextureCache:sharedTextureCache():addImage(bitStr);
                sprite_day:setTexture(tenTex)
                sprite_day2:setTexture(bitTex)
            end
            elemCcb = ccb_container:getCCSpriteFromCCB("mMonth")
            if elemCcb then
                local monthStr = "UI/alpha/HVGA/activity/Month_"..tonumber(month)..".png"
                local monthTex = CCTextureCache:sharedTextureCache():addImage(monthStr);
                elemCcb:setTexture(monthTex)
            end
            local weekDay = ed.getWeekdayIndex()
            elemCcb = ccb_container:getCCSpriteFromCCB("mWeek")
            if elemCcb then
                local weekStr = "UI/alpha/HVGA/activity/Week_"..weekDay..".png"
                local weekTex = CCTextureCache:sharedTextureCache():addImage(weekStr);
                elemCcb:setTexture(weekTex)
            end

            --activity btn
            local lastActivityIds = nil
            local btn_container = ccb_container:getCCNodeFromCCB("mBtnNode")
            if btn_container then
                local x,y = btn_container:getPosition()
                --btn_container:setPosition(ccp(x + 75, y -35))
            end
            local nextBtnPositionY = btn_container and (btn_container:getContentSize().height)+10 or 0
            local btnXVertex = btn_container:getContentSize().width/2
            table.sort(data._last_activity_info,ed.activitys.ActivitySort)
--            for i=(#(data._last_activity_info)), 1, -1 do  
--                v = data._last_activity_info[i]
            for i, v in ipairs(data._last_activity_info) do
                local groupId = v._group_id
                lastActivityIds = v._activity_ids
                local lastActivityBtn = ed.loadccbi(ed.activitys[groupId], "ccbi/ActiveBtnContent.ccbi")
                if lastActivityBtn and btn_container then
                    --lastActivityBtn:setScale(1.25)
                    ed.activitys.activityBtnTree[groupId] = {}
                    ed.activitys.activityBtnTree[groupId][1] = lastActivityBtn--save btn ui
                    local btnText = lastActivityBtn:getCCLabelTTFFromCCB("mMainActivityName")
                    if btnText then
                        btnText:setString(LSTR("ACTIVITY.GROUPNAME."..groupId--[[((#(data._last_activity_info))-i+1)--]]))
                    end
                    lastActivityBtn:setAnchorPoint(ccp(0.5, 1))
                    btn_container:addChild(lastActivityBtn)
                    local pos = ccp(btnXVertex, nextBtnPositionY)
                    lastActivityBtn:setPosition(pos)
                    nextBtnPositionY = pos.y - lastActivityBtn:getContentSize().height + 0
                end
                if lastActivityIds and (#lastActivityIds) > 0 then
                    for k, v in ipairs(lastActivityIds) do
                        local activityCfgs = ed.getDataTable("activity/ActivityConfig")
                        local activityCfg = activityCfgs[groupId][v]
                        if activityCfg==nil then
                            return
                        end
                        local activityBtn = ed.loadccbi(activityCfg.page, "ccbi/ActiveBtnContent2.ccbi")
                        if activityBtn then
                            --activityBtn:setScale(1.25)
                            --默认调用第一个活动的onRegisterFunction函数进入活动
                            if activityIndex == 1 and k == 1 then
                                activityCfg.page.onRegisterFunction("onActivityBtn", nil)
                                activityIndex = activityIndex+1
                            end

                            ed.activitys.activityBtnTree[groupId][k+1] = activityBtn--save btn ui
                            local text = activityBtn:getCCLabelTTFFromCCB("mActivityName")
                            if text then
                                text:setString(activityCfg.show_name)
                            end
                            if activityBtn and btn_container then
                                activityBtn:setAnchorPoint(ccp(0.5, 1))
                                btn_container:addChild(activityBtn)
                                local pos = ccp(btnXVertex, nextBtnPositionY)
                                activityBtn:setPosition(pos)
                                nextBtnPositionY = pos.y - activityBtn:getContentSize().height + 0
                            end
                        end
                    end
                end
            end
        end , EDDebug
        )
    end
    return handler
end
class.GotoActivity = GotoActivity

local showActivity = function(self)
    LegendLog("popScene ShowActivity")
    local msg = ed.upmsg.activity_info()
    msg._version = 1--[[ed.ui.serverlogin.getServerVersion()--]]
    msg._player_name = ed.player:getName()
    ed.send(msg, "activity_info")
    --local ccb_container = ed.loadccbi(ed.activitys.ActivityPage ,"ccbi/ActivePage.ccbi")
    --self.mainLayer:addChild(ccb_container,200)
    ed.netreply.GotoActivity = GotoActivity(self)

end
class.showActivity = showActivity
--

local showFbattention = function(self)
	LegendLog("popScene showFbattention")
	local fbattentionLayer=ed.ui.fbattention.create()
	self.mainLayer:addChild(fbattentionLayer.mainLayer,200)
end
class.showFbattention = showFbattention

local showAppremark = function(self)
      local appremarkLayer = ed.ui.appremark.create()
      self.mainLayer:addChild(appremarkLayer.mainLayer,200)
end
class.showAppremark = showAppremark

local setInfoLayerVisible = function(self, visible)
	self.infoLayer:setVisible(visible)
end
class.setInfoLayerVisible = setInfoLayerVisible

local function pushBoardWithoutAnim(self)
	local buttons = self:scGetButtons()
	local ui = self.sc_ui
	local board = ui.shortcut_board
	for i = 1, #buttons do
		buttons[i]:setPosition(ccp(res.shortcut_pos_x, res.shortcut_pos_y))
		buttons[i]:setOpacity(0)
		local size = board:getContentSize()
		local bw = size.width
		board:setContentSize(CCSizeMake(bw, res.shortcut_board_height_min))
	end
	self:scDestroyShadeLayer()
end
class.pushBoardWithoutAnim = pushBoardWithoutAnim

local function pushBoard(self)
	local ui = self.sc_ui
	local board = ui.shortcut_board
	if not self.shortcutBoardScheduler then
		self.shortcutBoardScheduler = board:getScheduler()
	end
	self.isPushsb = true
	local count = 0
	local gap = res.shortcut_board_pop_time
	local step = 1
	local sMax = -1 * (res.shortcut_board_height_max - res.shortcut_board_height_min + res.shortcut_board_height_min / 5) / gap * 2
	local as = -1 * sMax / gap
	local bsMax = res.shortcut_board_height_min / 5 / gap * 2
	local ms = bsMax / gap * 2
	local speed = sMax
	local ds = as
	local size = board:getContentSize()
	local bw = size.width
	local bh = size.height
	local height = bh
	local currentScene = CCDirector:sharedDirector():getRunningScene()
	local function handler(dt)
		xpcall(function()
			if CCDirector:sharedDirector():getRunningScene() ~= currentScene then
				self:stopPushBoard()
				return
			end
			if step == 1 and speed >= 0 then
				step = 2
				ds = ms
				self:scDestroyShadeLayer()
			end
			if step == 2 and speed >= bsMax then
				step = 3
				ds = -1 * ms
			end
			local preHeight = height
			height = height + speed * dt
			speed = speed + ds * dt
			if step == 1 then
				local buttons = self:scGetButtons()
				for i = 1, #buttons do
					if preHeight > res.shortcutBoardButtonHeight[i] and height <= res.shortcutBoardButtonHeight[i] then
						buttons[i]:setPosition(ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[i]))
						local fade = CCFadeOut:create(0.05)
						local move = CCMoveTo:create(0.2, ccp(res.shortcut_pos_x, res.shortcut_pos_y))
						move = CCEaseBackOut:create(move)
						local spawn = CCSpawn:createWithTwoActions(fade, move)
						buttons[i]:runAction(spawn)
					end
				end
			end
			if step == 1 and speed >= 0 then
				height = res.shortcut_board_height_min
				self:stopPushBoard()
				local buttons = self:scGetButtons()
				for i = 1, #buttons do
					buttons[i]:setOpacity(0)
				end
				self:scDestroyShadeLayer()
			end
			if height < res.shortcut_board_height_min * 4 / 5 then
				height = res.shortcut_board_height_min * 4 / 5
			end
			if step == 3 and height > res.shortcut_board_height_min then
				height = res.shortcut_board_height_min
			end
			board:setContentSize(CCSizeMake(bw, height))
			end, EDDebug)
		end
		return handler
end
class.pushBoard = pushBoard

local function popBoardWithoutAnim(self)
	local buttons = self:scGetButtons()
	local ui = self.sc_ui
	for i = 1, #buttons do
		buttons[i]:setPosition(ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[i]))
		buttons[i]:setOpacity(1)
		local sb = ui.shortcut_board
		local size = sb:getContentSize()
		local bw = size.width
		sb:setContentSize(CCSizeMake(bw, res.shortcut_board_height_max))
	end
end
class.popBoardWithoutAnim = popBoardWithoutAnim

local function popBoard(self)
	local ui = self.sc_ui
	local board = ui.shortcut_board
	if not self.shortcutBoardScheduler then
		self.shortcutBoardScheduler = board:getScheduler()
	end
	self.isPopsb = true
	local count = 0
	local gap = res.shortcut_board_pop_time
	local step = 1
	local sMax = (res.shortcut_board_height_max - res.shortcut_board_height_min) * 1.1111111111111112 / gap * 2
	local as = -1 * sMax / gap
	local ms = as / 10
	local speed = sMax
	local ds = as
	local size = board:getContentSize()
	local bw = size.width
	local bh = size.height
	local height = bh
	local currentScene = CCDirector:sharedDirector():getRunningScene()
	local function handler(dt)
		xpcall(function()
			if CCDirector:sharedDirector():getRunningScene() ~= currentScene then
				self:stopPopBoard()
				return
			end
			if step == 1 and speed <= 0 then
				step = 2
				ds = ms
			end
			if step == 2 and speed <= sMax / 10 then
				step = 3
				ds = -1 * ms
			end
			local preHeight = height
			height = height + speed * dt
			speed = speed + ds * dt
			if step == 1 then
				local buttons = self:scGetButtons()
				for i = 1, #buttons do
					if preHeight < res.shortcutBoardButtonHeight[i] and height >= res.shortcutBoardButtonHeight[i] then
						buttons[i]:setPosition(ccp(res.shortcut_pos_x, res.shortcut_pos_y))
						local fade = CCFadeIn:create(0.2)
						local move = CCMoveTo:create(0.2, ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[i]))
						move = CCEaseBackOut:create(move)
						local spawn = CCSpawn:createWithTwoActions(fade, move)
						buttons[i]:runAction(spawn)
					end
				end
			end
			if step == 3 and speed >= 0 then
				height = res.shortcut_board_height_max
				self:stopPopBoard()
			end
			board:setContentSize(CCSizeMake(bw, height))
			end, EDDebug)
		end
		return handler
end
class.popBoard = popBoard

local registerPopBoard = function(self)
	self:registerUpdateHandler("popBoard", self:popBoard())
end
class.registerPopBoard = registerPopBoard

local function stopPopBoard(self)
	self:removeUpdateHandler("popBoard")
	local ui = self.sc_ui
	local board = ui.shortcut_board
	if not tolua.isnull(sb) then
		board:setContentSize(CCSizeMake(res.shortcut_board_width, res.shortcut_board_height_max))
	end
	self.isPopsb = false
end
class.stopPopBoard = stopPopBoard

local registerPushBoard = function(self)
	self:registerUpdateHandler("pushBoard", self:pushBoard())
end
class.registerPushBoard = registerPushBoard

local function stopPushBoard(self)
	self:removeUpdateHandler("pushBoard")
	local board = self.sc_ui.shortcut_board
	if not tolua.isnull(sb) then
		board:setContentSize(CCSizeMake(res.shortcut_board_width, res.shortcut_board_height_min))
	end
	self.isPushsb = false
end
class.stopPushBoard = stopPushBoard

local openShortcutBoard = function(self, skipAnim)
	self:scCreateShadeLayer()
	if not skipAnim then
    --add by xinghui
        if ed.tutorial.isShowTutorial then
            ed.sendDotInfoToServer(ed.tutorialres.t_key["openShortcutToEquip"].id)
        end
    --
		self:registerPopBoard()
	else
		self:popBoardWithoutAnim()
	end
end
class.openShortcutBoard = openShortcutBoard

local closeShortcutBoard = function(self, skipAnim)
	if not skipAnim then
		self:registerPushBoard()
	else
		self:pushBoardWithoutAnim()
	end
end
class.closeShortcutBoard = closeShortcutBoard

local function getSCButtonTouchHandler(self, key)
	local function isReplace()
		local replaceIdentity = {
		"heroPackage",
		"package",
		"fragment"
		}
		local id = self.identity
		if ed.isElementInTable(id, replaceIdentity) then
			return true
		else
			return false
		end
	end
	local handlers = {
	heroPackage = function()
		xpcall(function()
			if self.identity == "heroPackage" then
				return
			end
			local iset
			if ed.readhero.checkEquipableProp() then
                --add by xinghui:send dot info when click the hero in arrow
                if --[[ed.tutorial.checkDone("gotoEquipProp")==false--]] ed.tutorial.isShowTutorial then
                    ed.sendDotInfoToServer(ed.tutorialres.t_key["gotoEquipProp"].id)
                end
                --
				iset = ed.endTeach("gotoEquipProp")
				ed.endTeach("openShortcutToEquip")
				self.showTutorial = false
				self:refresh()
			end
			if self:checkSummonableHero() and not iset then
				ed.endTeach("SHopenShortcut")
				iset = ed.endTeach("SHclickHeroPackage")
				self.showTutorial = false
				self:refresh()
			end
			if ed.playerlimit.checkAreaUnlock("SkillUpgrade") and not iset then
				ed.endTeach("SUopenShortcut")
				iset = ed.endTeach("SUclickHeroPackage")
				self.showTutorial = false
				self:refresh()
			end
			lsr:report("clickHeroPackage")
			if isReplace() then
				ed.replaceScene(ed.ui.heropackage.create())
			else
				ed.pushScene(ed.ui.heropackage.create())
			end
			end, EDDebug)
		end,
		package = function()
			xpcall(function()
				if self.identity == "package" then
					return
				end
				lsr:report("clickPackage")
				if isReplace() then
					ed.replaceScene(ed.ui.package.create("package"))
				else
					ed.pushScene(ed.ui.package.create("package"))
				end
				end, EDDebug)
			end,
			fragment = function()
				xpcall(function()
					if self.identity == "fragment" then
						return
					end
					lsr:report("clickFragment")
					if isReplace() then
						ed.replaceScene(ed.ui.package.create("fragment"))
					else
						ed.pushScene(ed.ui.package.create("fragment"))
					end
					end, EDDebug)
				end,
				task = function()
					xpcall(function()
						if self.identity == "task" then
							return
						end
						lsr:report("clickTask")
						ed.endTeach("firstTaskOpenShortcut")
						ed.endTeach("firstTaskOpenTaskWindow")
						self.showTutorial = false
						self:refresh()
						self.scene:addChild(ed.ui.task.create(function()
							self:scRefreshTags()
							end).mainLayer, 101)
							end, EDDebug)
						end,
						todoList = function()
							xpcall(function()
								lsr:report("clickRecharge")
								self:doClickDailyjob()
								end, EDDebug)
							end
							}
							return handlers[key]
end
class.getSCButtonTouchHandler = getSCButtonTouchHandler

local checkSummonableHero = function(self)
	if ed.readhero.canSummonHero() then
		return true
	end
	return false
end
class.checkSummonableHero = checkSummonableHero

local checkHeroPackageTag = function(self)
	local function handler()
		if self.identity == "heroPackage" then
			return false
		end
		if ed.readhero.checkEquipableProp() then
			return true
		end
		if self:checkSummonableHero() then
			return true
		end
		return false
	end
	return handler
end
class.checkHeroPackageTag = checkHeroPackageTag

local checkPackageTag = function(self)
	local handler = function()
		return false
	end
	return handler
end
class.checkPackageTag = checkPackageTag

local checkFragmentPackageTag = function(self)
	local handler = function()
		return false
	end
	return handler
end
class.checkFragmentPackageTag = checkFragmentPackageTag

local checkCompletedTask = function(self)
	for k, v in pairs(ed.player._task) do
		if ed.ui.task.isTaskCompleted(v) then
			return true
		end
	end
	return false
end
class.checkCompletedTask = checkCompletedTask

local checkTaskTag = function(self)
	local function handler()
		return self:checkCompletedTask()
	end
	return handler
end
class.checkTaskTag = checkTaskTag

local checkDailyjob = function(self)
	local handler = function()
		return ed.player:checkDailyjobCount()
	end
	return handler
end
class.checkDailyjob = checkDailyjob

local getCheckSCTagHandler = function(self, key)
	local handlers = {
	heroPackage = self:checkHeroPackageTag(),
	package = self:checkPackageTag(),
	fragment = self:checkFragmentPackageTag(),
	task = self:checkTaskTag(),
	todoList = self:checkDailyjob()
	}
	return handlers[key]
end
class.getCheckSCTagHandler = getCheckSCTagHandler

local checkShortcutButtonTag = function(self)
	self:scRefreshTags()
end
class.checkShortcutButtonTag = checkShortcutButtonTag

local function create(identity, addition)
	local self = base.create(identity, addition)
	setmetatable(self, class.mt)
	local mainLayer = self.mainLayer
	if self.identity ~= "main" then
		local bg = ed.createSprite("UI/alpha/HVGA/bg.jpg")
		bg:setPosition(ccp(400, 240))
		self:ccScene():addChild(bg, -1)
	end
	--self:sbCreateSDKIcon()
	self:sbCreateHead()
	self:sbCreateTitle()
	self:sbCreateBack()
	self:sbCreateTitleButton()
	self:scCreateBoard()
	self:scCreateButtons()
	self:registerUpdateHandler("updateFramework", self:updateFramework())
	self:registerOnEnterHandler("onEnterFramework", self:onEnterFramework())
	self:registerOnExitHandler("onExitFramework", self:onExitFramework())
	return self
end
class.create = create

local function getRefreshAction()
	local larger = CCScaleTo:create(0.2, res.mrv_scale_large)
	local reverse = CCScaleTo:create(0.2, res.mrv_scale)
	local sequence = CCSequence:createWithTwoActions(larger, reverse)
	return sequence
end

local refreshHeadVip = function(self)
	local vip = ed.player:getvip()
	if vip ~= self.vip then
		local ui = self.sb_ui
		if not tolua.isnull(ui.vip) then
			ed.setString(ui.vip, vip)
		end
		if not tolua.isnull(ui.vip_bg) and not tolua.isnull(ui.vip_icon) and not tolua.isnull(ui.vip) then
			if vip > 0 then
				ui.vip_bg:setVisible(true)
				ui.vip_icon:setVisible(true)
				ui.vip:setVisible(true)
			else
				ui.vip_bg:setVisible(false)
				ui.vip_icon:setVisible(false)
				ui.vip:setVisible(false)
			end
		end
		self.vip = vip
	end
end
class.refreshHeadVip = refreshHeadVip

local refreshHeadName = function(self)
	local ui = self.sb_ui
	local name = ed.player:getName()
	if name ~= self.playerName then
		local nb = ui.name_bg
		if not tolua.isnull(nb) then
			nb:setVisible(true)
			ed.setString(ui.name, ed.player:getName())
		end
		self.playerName = name
	end
end
class.refreshHeadName = refreshHeadName

local refreshAvatar = function(self)
	local id = ed.player:getAvatar()
	local preid = self.avatarid
	if id ~= preid then
		self:sbRefreshHead()
		self.avatarid = id
	end
end
class.refreshAvatar = refreshAvatar

local refreshHeadLevel = function(self)
	local ui = self.sb_ui
	local level = ed.player:getLevel()
	if level ~= self.playerLevel then
		if not tolua.isnull(ui.level) then
			ed.setString(ui.level, level)
		end
		self.playerLevel = level
	end
end
class.refreshHeadLevel = refreshHeadLevel

local function updateMRV(self, name, value)
	local ui = self.sb_ui
	local bc = self:sbGetBarConfig(name)
	bc.preValue = value or bc.value()
	if not bc then
		print("Wrong name of the bar_config key : " .. (name or "nil"))
		return
	end
	local action
	if tolua.isnull(ui[bc.bgNode]) then
		return
	end
	if not tolua.isnull(ui[bc.textNode]) then
		ui[bc.textNode]:removeFromParentAndCleanup(true)
	end
	if bc.hasInit then
		action = getRefreshAction()
	end
	bc.hasInit = true
	local text = ed.getNumberNode({
	text = value and bc.text(value) or bc.text(),
	padding = bc.padding,
	folder = bc.folder and bc.folder() or nil
	}).node
	if bc.rightNode then
		if not tolua.isnull(ui[bc.rightNode]) then
			ed.left2(text, ui[bc.rightNode])
		end
	elseif bc.rightPoint then
		ed.left2Point(text, bc.rightPoint)
	end
	ui[bc.textNode] = text
	ui[bc.bgNode]:addChild(text)
	if bc.refreshKeys then
		for i, v in ipairs(bc.refreshKeys) do
			local cbc = self:sbGetBarConfig(v)
			if not tolua.isnull(ui[cbc.textNode]) then
				if cbc.rightNode then
					if not tolua.isnull(ui[cbc.rightNode]) then
						ed.left2(ui[cbc.textNode], ui[cbc.rightNode])
					end
				elseif cbc.rightPoint then
					ed.left2Point(ui[cbc.textNode], cbc.rightPoint)
				end
			end
		end
	end
	if action then
		text:runAction(action)
	end
end
class.updateMRV = updateMRV

local updateFramework = function(self, force)
	local function handler(dt)
		if ed.player.initialized then
			local bc = self:sbGetBarConfig()
			for k, v in pairs(bc) do
				if v.preValue ~= v.value() then
					if k == "money" and not force and ed.player.addMoneySilent then
					else
						self:updateMRV(k)
					end
					if k == "vitality" and ed.isElementInTable(self.identity, {
						"stageDetailGWMode",
						"stageDetail"
						}) then
						self:refresh()
					end
				end
			end
			self:refreshHeadVip()
			self:refreshHeadName()
			self:refreshAvatar()
			self:refreshHeadLevel()
			--self:sbRefreshWorldcupButton()
		end
	end
	return handler
end
class.updateFramework = updateFramework

local function createEquipPropTT(self)
	local ist
	local ui = self.sc_ui
	local down = ui.down
	if self.identity ~= "heroPackage" then
		if self.isShortcutOpen then
			if ed.readhero.checkEquipableProp() then
				ed.breakTeach("openShortcutToEquip")
				ist = ed.teach("gotoEquipProp", ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[1]), 50, self.infoLayer)
			end
			if self:checkSummonableHero() then
				ed.breakTeach("SHopenShortcut")
				ist = ist or ed.teach("SHclickHeroPackage", ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[1]), 50, self.infoLayer)
			end
			if ed.playerlimit.checkAreaUnlock("SkillUpgrade") then
				ed.breakTeach("SUopenShortcut")
				ist = ist or ed.teach("SUclickHeroPackage", ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[1]), 50, self.infoLayer)
			end
			if ist then
				self.showTutorial = true
				self:refresh()
			end
		else
			if ed.readhero.checkEquipableProp() then
				ed.breakTeach("gotoEquipProp")
				ist = ed.teach("openShortcutToEquip", down, self.infoLayer)
			end
			if self:checkSummonableHero() then
				ed.breakTeach("SHclickHeroPackage")
				ist = ist or ed.teach("SHopenShortcut", down, self.infoLayer)
			end
			if ed.playerlimit.checkAreaUnlock("SkillUpgrade") then
				ed.breakTeach("SUclickHeroPackage")
				ist = ist or ed.teach("SUopenShortcut", down, self.infoLayer)
			end
		end
	end
	if ist then
		self.showTutorial = true
		self:refresh()
	end
	return ist
end
class.createEquipPropTT = createEquipPropTT

local function createCompleteTaskTT(self)
	local ist
	local ui = self.sc_ui
	local down = ui.down
	if self:checkCompletedTask() then
		if self.isShortcutOpen then
			ed.breakTeach("firstTaskOpenShortcut")
			ist = ed.teach("firstTaskOpenTaskWindow", ccp(res.shortcut_pos_x, res.shortcutBoardButtonPosY[4]), 50, self.infoLayer)
		else
			ed.breakTeach("firstTaskOpenTaskWindow")
			ist = ed.teach("firstTaskOpenShortcut", down, self.infoLayer)
		end
	end
	if ist then
		self.showTutorial = true
		self:refresh()
	end
	return ist
end
class.createCompleteTaskTT = createCompleteTaskTT

local onEnterFramework = function(self)
	local function handler()
		self.showTutorial = false
		self:refresh()
		local ist = self:createEquipPropTT()
		if not ist then
			self:createCompleteTaskTT()
		end
		if self.isShortcutOpen and self.identity ~= "main" then
			local handler = self:doShortcut()
			handler(true)
		end
		self:checkShortcutButtonTag()
		if self:checkFirstInMain() or self.identity == "crusade" then
			self:scHideSwitch()
		else
			self:scShowSwitch()
		end
		if ed.isElementInTable(self.identity, {
			"stageSelectGWMode",
			"stageDetailGWMode"
			}) then
			self:scHideSwitch()
		end
		ed.ui.activitiesButton.refesh()
		self:sbRefreshHead()
		self:sbRefreshDailyloginTag()
		self:updateFramework(true)()
	end
	return handler
end
class.onEnterFramework = onEnterFramework

local onExitFramework = function(self)
	local function handler()
		self:sbInitBarConfig()
	end
	return handler
end
class.onExitFramework = onExitFramework
										
--Author : chenpanhua 充值返利活动
ActiveRechargeRebatePage = {}
base = ed.activitys.ActivityPage
local remain_time = 0
local rechargeRebateCBB = nil
local activityStatus = 1
local spineAniRecharge = nil
local spineAniRebate = nil
local buttonStatus = 0
local getStatus = 0
--刷新标识符
rechargeRebateID = 0

--表
local activityCfg = nil

local function onRegisterFunction(eventName,container)
	if eventName == "onActivityBtn" then
        base.onEnter("OpenServerActivity", 1)
        ed.ActiveRechargeRebatePage.create()
    elseif eventName == "onExplainBtn" then
        ActiveRechargeRebatePage.onExplainBtn(container)
	elseif eventName == "onRechargeBtn" then
		if activityStatus == 1 and buttonStatus == 0 then
			ActiveRechargeRebatePage.onRechargeBtn(container)	
		elseif buttonStatus == 1 then
			local info = {
				text = T(LSTR("RECHARGE_REBATE.DOC1")),
				leftText = T(LSTR("CHATCONFIG.CANCEL")),
				rightText = T(LSTR("CHATCONFIG.CONFIRM")),
				rightHandler = function()
				xpcall(function()
				end, EDDebug)
			end
		}
		ed.showConfirmDialog(info)
		elseif buttonStatus == 0 then
			local info = {
				text = T(LSTR("RECHARGE_REBATE.DOC2")),
				leftText = T(LSTR("CHATCONFIG.CANCEL")),
				rightText = T(LSTR("CHATCONFIG.CONFIRM")),
				rightHandler = function()
				xpcall(function()
					ActiveRechargeRebatePage.onGetBtn(container)
				end, EDDebug)
			end
		}
		ed.showConfirmDialog(info)
		else	
				
		end
    end
end
ActiveRechargeRebatePage.onRegisterFunction = onRegisterFunction

function ActiveRechargeRebatePage.onExplainBtn(container)
	
	local param={content=T(LSTR("RECHARGE_REBATE.CONTENT")),title=T(LSTR("RECHARGE_REBATE.TITLE"))}
	local continuechargedialog = ed.ui.continuechargedialog.create(param)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(continuechargedialog.mainLayer, 101000,43267)
	end
end

--充值
function ActiveRechargeRebatePage.onRechargeBtn(container)
	
	--说明活动开启的，进充值返利活动页面了
	rechargeRebateID = 1

	local rechargeLayer = newrecharge.create()
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		scene:addChild(rechargeLayer, 101000)
	end
end

--返利
function ActiveRechargeRebatePage.onGetBtn(container)
	--注册
	ed.registerNetReply("GetBtnInfoHandler", ed.ActiveRechargeRebatePage.GetBtnInfoHandler)
	
	--先去请求数据
	local msg = ed.upmsg.recharge_rebate()
    msg._recharge_rebate = 2	--点击领取按钮
    ed.send(msg, "recharge_rebate")
end

local function create()
	ActiveRechargeRebatePage.loadCCBI()
end
ed.ActiveRechargeRebatePage.create = create

function ActiveRechargeRebatePage.loadCCBI()	
	
	--先读表，拿数据
	local activityCfgs = ed.getDataTable("activity/ActivityConfig")
    activityCfg = activityCfgs["OpenServerActivity"][1]
	if activityCfg == nil then
		ed.showToast(T(LSTR("RECHARGE_REBATE.EXCEPTION")))
		return
	end
	--注册
	ed.registerNetReply("RechargeRebateInfoHandler", ActiveRechargeRebatePage.RechargeRebateInfoHandler)
	
	--先去请求数据
	local msg = ed.upmsg.recharge_rebate()
    msg._recharge_rebate = 1	--请求数据
    ed.send(msg, "recharge_rebate")
	
end

function ActiveRechargeRebatePage.RechargeRebateInfoHandler(msg)
	
	--注册
	ed.registerNetReply("GetRebateInfoHandler", ActiveRechargeRebatePage.GetRebateInfoHandler)
	
	rechargeRebateCBB = ed.loadccbi(ActiveRechargeRebatePage,"ccbi/ActiveRechargeRebate.ccbi");
	if rechargeRebateCBB then
		--rechargeRebateCBB:setPosition(30,50)
		local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
		if container then
			container:removeAllChildrenWithCleanup(true)
			container:addChild(rechargeRebateCBB)
		end
		
		local RebateEventScope = {}
		if msg and msg._status == 1 then	--存储阶段
			--赋值当前状态
			activityStatus = msg._status
			remain_time = msg._time
			ListenTimer(Timer:Always(1, "ActiveRechargeRebateTimer"), ed.ActiveRechargeRebatePage.updateRemainTime, RebateEventScope)

			local todayReceiveNum = rechargeRebateCBB:getCCLabelTTFFromCCB("mTodayReceiveNum");
			if todayReceiveNum ~= nil then
				todayReceiveNum:setVisible(false)				
			end
			
			local cdTitle = rechargeRebateCBB:getCCLabelTTFFromCCB("mCDTitle");
			if cdTitle ~= nil then
				cdTitle:setString(T(LSTR("RECHARGE_REBATE.RECHARGE_LAST")))
			end
	
			--存储阶段的node
			local cdNode = rechargeRebateCBB:getCCNodeFromCCB("mCDNode")
			if cdNode ~= nil then
				cdNode:setVisible(true);			
			end
			
			local expNode = rechargeRebateCBB:getCCNodeFromCCB("mExpNode")
			if expNode ~= nil then
				expNode:setVisible(true);			
			end
			
			--返利阶段的node
			local receiveNode = rechargeRebateCBB:getCCNodeFromCCB("mReceiveNode")
			if receiveNode ~= nil then
				receiveNode:setVisible(false);			
			end
			
			--2个按钮
			local explainBtnTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mExplainBtnTex")
			if explainBtnTex ~= nil then
				
				explainBtnTex:setString(T(LSTR("RECHARGE_REBATE.EXPLAIN")));			
			end
			
			local rechargeBtnTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mRechargeBtnTex")
			if rechargeBtnTex ~= nil then
				rechargeBtnTex:setString(T(LSTR("RECHARGE_REBATE.RECHARGE")));			
			end

			local expBar = rechargeRebateCBB:getCCScale9SpriteFromCCB("mExpBar")
			if expBar then
				expBar:setVisible(true)
				expBar:setScaleX(0.5)
			end
			
			local stageTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mStageTex")
			if stageTex ~= nil and activityCfg ~= nil then
				stageTex:setString(T(LSTR("RECHARGE_REBATE.DESCRIPTION"),tonumber(activityCfg["min_values"]),tonumber(activityCfg["min_values"]),tonumber(activityCfg["return_days"]),tonumber(activityCfg["max_values"])));			
			end
			
			local rechargeMoney = msg._recharge_money
			local diamondMin = activityCfg["min_values"]
			diamondMin = tonumber(diamondMin)
			
			--动画
			local spineNode = rechargeRebateCBB:getCCNodeFromCCB("mSpineNode")
			if spineNode ~= nil then
				spineAniRecharge = SpineContainer:create('spine/RechargeRebate_Pig', 'pig')
				spineNode:addChild(spineAniRecharge)
				if rechargeMoney ~= 0 then
					if rechargeMoney < diamondMin and is_RechargeRebate == 1  then
						if  is_RechargeRebate == 1 then
							spineAniRecharge:runAnimation(0, 'Recharge_Ani', 1)
							spineAniRecharge:registerLuaListener(function(eventName, trackIndex, aniName, loopCount)
							if eventName == "Complete" then
								spineAniRecharge:runAnimation(0, 'Recharge_Stand', 1)
							end
							end);
						else
							spineAniRecharge:runAnimation(0, 'Recharge_Stand', 1);	
						end
						
					elseif rechargeMoney > diamondMin then
						if  is_RechargeRebate == 1 then
							spineAniRecharge:runAnimation(0, 'Recharge_Max_Ani', 1);
							spineAniRecharge:registerLuaListener(function(eventName, trackIndex, aniName, loopCount)
							if eventName == "Complete" then
								spineAniRecharge:runAnimation(0, 'Recharge_Max_Stand', 1)
							end
							end);
						else
							spineAniRecharge:runAnimation(0, 'Recharge_Max_Stand', 1);	
						end
					end	
				else
					spineAniRecharge:runAnimation(0, 'Recharge_Stand', 1)
				end
			end	

			if rechargeMoney <= diamondMin then
				local progress = rechargeMoney % 10
				for curr = 1,progress do
					local experienceValue = rechargeRebateCBB:getCCSpriteFromCCB("mExperienceValue"..curr)
					if experienceValue then
						experienceValue:setVisible(true)
					end
				end
			else
				for curr = 1,10 do
					local experienceValue = rechargeRebateCBB:getCCSpriteFromCCB("mExperienceValue"..curr)
					if experienceValue then
						experienceValue:setVisible(true)
					end
				end
			end
		
			local diamondMax = activityCfg["max_values"]
			diamondMax = tonumber(diamondMax)

			if rechargeMoney < diamondMin then
				rechargeMoney = diamondMin
			elseif rechargeMoney > diamondMax then
				rechargeMoney = diamondMax	
			end
			for j = 1 ,5 do
				local expNum1 = rechargeRebateCBB:getCCSpriteFromCCB("mExpNum"..j)
				if expNum1 then
					expNum1:setVisible(false)
				end
			end	
			
			local a = #tostring(rechargeMoney)
			for index = 1, a do
				local i = index
				local c = string.sub(rechargeMoney, i, i)
				local expNum2 = rechargeRebateCBB:getCCSpriteFromCCB("mExpNum"..i)
				if expNum2 then
					local localPic = "UI/alpha/HVGA/digits/silver/"..c..".png"
					local tenTex = CCTextureCache:sharedTextureCache():addImage(localPic);
					expNum2:setVisible(true)
					expNum2:setTexture(tenTex)
				end
			end
			
			local stagePic = rechargeRebateCBB:getCCSpriteFromCCB("mStagePic")
			if stagePic then
				local localPic = "UI/alpha/HVGA/activity/Activity_Recharge_Tex01.png"
                local tenTex = CCTextureCache:sharedTextureCache():addImage(localPic);
                stagePic:setTexture(tenTex)
			end
			
		elseif msg and msg._status == 2 then	--返利阶段
			
			remain_time = msg._time
			getStatus = msg._get_status
			local days = msg._get_day
			
			local diamond = msg._recharge_money
			
			ListenTimer(Timer:Always(1, "ActiveRechargeRebateTimer2"), ed.ActiveRechargeRebatePage.updateRemainTime, RebateEventScope)
			
			local todayReceiveNum = rechargeRebateCBB:getCCLabelTTFFromCCB("mTodayReceiveNum");
			if todayReceiveNum ~= nil then
				todayReceiveNum:setVisible(true)
				if getStatus == 0 then
					todayReceiveNum:setString(T(LSTR("RECHARGE_REBATE.GET"),diamond))
				else
					todayReceiveNum:setString(T(LSTR("RECHARGE_REBATE.NOTGET"),diamond))
				end	
			end
			
			--返利阶段的node
			local cdNode = rechargeRebateCBB:getCCNodeFromCCB("mCDNode")
			if cdNode ~= nil then
				cdNode:setVisible(false);			
			end
			
			local receivedTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mReceivedTex");
			if receivedTex ~= nil then
				receivedTex:setString(T(LSTR("RECHARGE_REBATE.HASBEEN")))	
			end
			
			local remainingTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mRemainingTex");
			if remainingTex ~= nil then
				remainingTex:setString(T(LSTR("RECHARGE_REBATE.SURPLUS")))	
			end
			
			local receiveDayTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mReceiveDayTex");
			if receiveDayTex ~= nil then
				receiveDayTex:setString(tostring(days)..T(LSTR("RECHARGE_REBATE.DAYS")))	
			end
			
			local remainingDayTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mRemainingDayTex");
			if remainingDayTex ~= nil then
				local day = math.floor(remain_time / 86400)
				remainingDayTex:setString(tostring(day)..T(LSTR("RECHARGE_REBATE.DAYS")))
			end
			
			--topinfo 背景
			local ccsprite = rechargeRebateCBB:getCCSpriteFromCCB("mRebateInfoBG")
			if ccsprite then
				--ccsprite:setScale(1.25)
			end
						
			--存储阶段的node
			local receiveNode = rechargeRebateCBB:getCCNodeFromCCB("mReceiveNode")
			if receiveNode ~= nil then
				receiveNode:setVisible(true);			
			end
			
			local expNode = rechargeRebateCBB:getCCNodeFromCCB("mExpNode")
			if expNode ~= nil then
				expNode:setVisible(false);			
			end
			
			local expBar = rechargeRebateCBB:getCCScale9SpriteFromCCB("mExpBar")
			if expBar then
				expBar:setVisible(false)
			end
			
			--2个按钮
			local explainBtnTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mExplainBtnTex")
			if explainBtnTex ~= nil then
				explainBtnTex:setString(T(LSTR("RECHARGE_REBATE.EXPLAIN")))
			end
			
			local rechargeBtnTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mRechargeBtnTex")
			if rechargeBtnTex ~= nil then
				if msg._get_status == 1 then
					rechargeBtnTex:setString(T(LSTR("RECHARGE_REBATE.HAVEGET")))
				else
					rechargeBtnTex:setString(T(LSTR("RECHARGE_REBATE.GO")))	
				end	
			end
			
			local cdTitle = rechargeRebateCBB:getCCLabelTTFFromCCB("mCDTitle");
			if cdTitle ~= nil then
				local status = msg._status
				buttonStatus = msg._get_status
				cdTitle:setString("stauts:"..status)		
			end
			
			local stagePic = rechargeRebateCBB:getCCSpriteFromCCB("mStagePic")
			if stagePic then
				local localPic = "UI/alpha/HVGA/activity/Activity_Recharge_Tex02.png"
                local tenTex = CCTextureCache:sharedTextureCache():addImage(localPic);
                stagePic:setTexture(tenTex)
			end
			
			local stageTex = rechargeRebateCBB:getCCLabelTTFFromCCB("mStageTex")
			if stageTex ~= nil and activityCfg ~= nil then
				stageTex:setString(T(LSTR("RECHARGE_REBATE.REBATEEXPLAIN"),activityCfg["return_days"]));			
			end
			
			--动画
			local spineNode = rechargeRebateCBB:getCCNodeFromCCB("mSpineNode")
			if spineNode ~= nil then
				spineAniRebate = SpineContainer:create('spine/RechargeRebate_Pig', 'pig');
				if getStatus == 1 and activityStatus == 5 then
					--飘字，领取成功
					ed.showToast(LSTR("RECHARGE_REBATE.SUCCESS"))
					spineAniRebate:runAnimation(0, 'Rebate_Ani', 1);
					spineNode:addChild(spineAniRebate);
					spineAniRebate:registerLuaListener(function(eventName, trackIndex, aniName, loopCount)
					if eventName == "Complete" then
						spineAniRebate:runAnimation(0, 'Rebate_Stand', 1);
					end
					end);
					--刷新钻石
					ed.player:addrmb(diamond)
				else
					spineAniRebate:runAnimation(0, 'Rebate_Stand', 1);
					spineNode:addChild(spineAniRebate);
				end		
			end
			
			activityStatus = msg._status			
		end
	end
	
end

local function updateRemainTime()
	
	remain_time = math.max(0, remain_time - 1)
    if remain_time == 0 then
        return
    else
		local timeStr = ed.getdhmsCString2(remain_time)
        if rechargeRebateCBB then
            local time_ui = rechargeRebateCBB:getCCLabelTTFFromCCB("mCD")
            if time_ui then
                time_ui:setString(timeStr)
            end
        end
    end
end
ActiveRechargeRebatePage.updateRemainTime = updateRemainTime

local function GetBtnInfoHandler(msg)
	if msg then
		activityStatus = 5
		ActiveRechargeRebatePage.RechargeRebateInfoHandler(msg)
	end
end
ed.ActiveRechargeRebatePage.GetBtnInfoHandler = GetBtnInfoHandler

local function onExit()
    base.onExit()
    CloseTimer("ActiveRechargeRebateTimer")
    CloseTimer("ActiveRechargeRebateTimer2")
end
ed.ActiveRechargeRebatePage.onExit = onExit
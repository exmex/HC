--Author : zhycheng  --连续登录活动
ContinueCharge={}
ContinueChargeContent={}
local dataState={}
local ContinueChargeRes = {
    PlayerEXP = "UI/alpha/HVGA/task_exp_icon.png",
    Diamond = "UI/alpha/HVGA/task_rmb_icon.png",
    Gold = "UI/alpha/HVGA/task_gold_icon.png"
  }
function onRegisterFunction(eventName,container)
	LegendLog("-----------------------")
    if eventName == "onExplainBtn" then
        ContinueCharge.onExplainBtn(container)
	elseif eventName=="onRechargeBtn" then
		ContinueCharge.onRechargeBtn(container)
	elseif eventName == "onActivityBtn" then
		base.onEnter("OpenServerActivity", 2)
		ed.registerNetReply("continuerecharge", ContinueCharge.onNetworkReply)
		local msg = ed.upmsg.continue_pay()
		msg._continue_pay = 1
		ed.send(msg, "continue_pay")
    end
end
ContinueCharge.onRegisterFunction = onRegisterFunction

local dealClick=function(container,data)
	ContinueCharge:destroyRewardDetail()
	  local container = CCLayer:create()
	ContinueCharge.rdContainer = container
	container:setTouchEnabled(true)
	container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        ContinueCharge:destroyRewardDetail()
      end
    end, EDDebug)
    return true
  end, false, -165, true)
	local type=data["type"]
	local id=data["id"]
	local did=id
	if type == "Diamond" then
		did = type
	elseif type=="Gold" then
		did=type
	end
	local panel = ed.readequip.getDetailCard(did, {
    ps = ""
  }, {
    noArrow = true,
    anchor = ccp(0.5, 0.5)
  })
	local pos = ccp(400, 240)
	panel:setPosition(pos)
	container:addChild(panel)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		scene:addChild(container, 101000,77976)
	end
end
ContinueChargeContent.dealClick=dealClick

local destroyRewardDetail = function(self)
  if not tolua.isnull(self.rdContainer) then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.rdContainer:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, func)
    self.rdContainer:runAction(s)
  end
end
ContinueCharge.destroyRewardDetail = destroyRewardDetail

function onRegisterFunction(eventName,container)
		if eventName=="onFrame1" then
			LegendLog("--------------------onFrame1")
			local mIndex=container.mIndex
			local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
			local itemCharge = chargeConfig[mIndex]
			local reward={["id"]=itemCharge["id1"],["count"]=itemCharge["count1"],["type"]=itemCharge["type1"]}
			ContinueChargeContent.dealClick(container,reward)
		elseif eventName=="onFrame2" then
			LegendLog("--------------------onFrame2")
			local mIndex=container.mIndex
			local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
			local itemCharge = chargeConfig[mIndex]
			local reward={["id"]=itemCharge["id2"],["count"]=itemCharge["count2"],["type"]=itemCharge["type2"]}
			ContinueChargeContent.dealClick(container,reward)
		elseif eventName=="onFrame3" then
			LegendLog("--------------------onFrame3")
			local mIndex=container.mIndex
			local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
			local itemCharge = chargeConfig[mIndex]
			local reward={["id"]=itemCharge["id3"],["count"]=itemCharge["count3"],["type"]=itemCharge["type3"]}
			ContinueChargeContent.dealClick(container,reward)
		elseif eventName=="onFrame4" then
			LegendLog("--------------------onFrame4")
			local mIndex=container.mIndex
			local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
			local itemCharge = chargeConfig[mIndex]
			local reward={["id"]=itemCharge["id4"],["count"]=itemCharge["count4"],["type"]=itemCharge["type4"]}
			ContinueChargeContent.dealClick(container,reward)
		elseif eventName=="onFrame5" then
			LegendLog("--------------------onFrame5")
			local mIndex=container.mIndex
			local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
			local itemCharge = chargeConfig[mIndex]
			local reward={["id"]=itemCharge["id5"],["count"]=itemCharge["count5"],["type"]=itemCharge["type5"]}
			ContinueChargeContent.dealClick(container,reward)
		end
	
end
ContinueChargeContent.onRegisterFunction=onRegisterFunction

function initCellContent(container)
	--拉伸背景
	local bgy=container:getCCSpriteFromCCB("mContentBG2")
	--bgy:setScaleX(1.25)
	--bgy:setScaleY(1.25)
	local bgw=container:getCCSpriteFromCCB("mContentBg1")
	--bgw:setScaleX(1.25)
	--bgw:setScaleY(1.25)
	local stateNode=container:getCCNodeFromCCB("mTagNode")
	--stateNode:setScale(1.25)
	stateNode:setPosition(ccp(stateNode:getPositionX()+4,stateNode:getPositionY()))
	local mIndex=container.mIndex
	local chargeConfig = ed.getDataTable("activity/ContinueChargeConfig")
    local itemCharge = chargeConfig[mIndex]
	local iconpath=itemCharge["indexicon"]
	local description=itemCharge["description"]
	local rewardcount=itemCharge["rewardcount"]
	--icon index
	local spriteIcon=container:getCCSpriteFromCCB("mDatePic")
	spriteIcon:setTexture(iconpath)
	--label 
	local ttfLabel=container:getCCLabelTTFFromCCB("mSingleChargingTex")
	ttfLabel:setString(description)
	--state
	local state=dataState._status[mIndex] --状态 1=已领取 2=过期 3=未开启 4=正在进行
	
	local receivedSprite=container:getCCSpriteFromCCB("mReceivedPic")
	local invalidSprite=container:getCCSpriteFromCCB("mExpiredPic")
	local willReceiveSprite=container:getCCSpriteFromCCB("mExpectingPic")
	if state==1 then
		receivedSprite:setVisible(true)
		invalidSprite:setVisible(false)
		willReceiveSprite:setVisible(false)
	elseif state==2 then
		receivedSprite:setVisible(false)
		invalidSprite:setVisible(true)
		willReceiveSprite:setVisible(false)
	elseif state==3 then
		receivedSprite:setVisible(false)
		invalidSprite:setVisible(false)
		willReceiveSprite:setVisible(true)
	elseif state==4 then
		receivedSprite:setVisible(false)
		invalidSprite:setVisible(false)
		willReceiveSprite:setVisible(false)
	end
	--奖励的东西
	for k=1,5 do
		local iconSprite=container:getCCNodeFromCCB("mItemPic"..k)
		iconSprite:setAnchorPoint(ccp(0,0))
		local stringTTF=container:getCCLabelTTFFromCCB("mItemNum"..k)
		local parentNode=container:getCCNodeFromCCB("mItemNode"..k)
		if k<=rewardcount then
			parentNode:setVisible(true)
			local iconId=itemCharge["id"..k]
			local iconCount=itemCharge["count"..k]
			local iconType=itemCharge["type"..k]
			if iconType=="Item" or iconType=="Hero" then
				local row = ed.getDataTable("equip")[iconId]
				local frame=ed.readequip.createIcon(iconId)
				iconSprite:addChild(frame)
			else
				local frame=ed.createSprite(ContinueChargeRes[iconType])
				iconSprite:addChild(frame)
			end
			stringTTF:setString(tostring(iconCount))
			
		else
			parentNode:setVisible(false)
		end
	end
end

local function updateRemainTime()
	if ContinueCharge.container~=nil then
		if dataState._time>0 then
			dataState._time=dataState._time-1
		end
		local CDTTF=ContinueCharge.container:getCCLabelTTFFromCCB("mCD")
		local timeStr = ed.getdhmsCString2(dataState._time)
		CDTTF:setString(timeStr)
	end
end
ContinueChargeContent.updateRemainTime=updateRemainTime

local create=function()
	local container = ed.loadccbi(ContinueCharge,"ccbi/ActiveDailyRecharge.ccbi");
	ContinueCharge.container = container
	--初始化一些控件
	container.scrollview=container:getCCScrollViewFromCCB("mContent")
	container.scrollViewRootNode=container.scrollview:getContainer()	
	local contentHeight=0
	local contentWidth=0
	for k=1,#dataState._status do
		local itemContainer=ed.loadccbi(ContinueChargeContent,"ccbi/ActiveDailyRechargeContent.ccbi")
		contentWidth=itemContainer:getContentSize().width
		contentHeight=itemContainer:getContentSize().height
		itemContainer.mIndex=#dataState._status+1-k
		initCellContent(itemContainer)
		itemContainer:setPosition(ccp(0,(k-1)*contentHeight))
		container.scrollViewRootNode:addChild(itemContainer)
	end
	container.scrollViewRootNode:setContentSize(CCSizeMake(contentWidth,(#dataState._status)*contentHeight))
	container.scrollview:setBounceable(true)
	local index=1
	for cv=1,#dataState._status do
		if dataState._status[cv]==4 then
			index=cv
		end
	end
	--计算offset
	--最大offset
	local maxOffset=container.scrollview:getViewSize().height-container.scrollview:getContentSize().height*container.scrollview:getScaleY()
	local nowOffset=container.scrollview:getViewSize().height-(container.scrollview:getContentSize().height-(index-1)*contentHeight)*container.scrollview:getScaleY()
	if nowOffset>=0 then
		nowOffset=0
	end
	if maxOffset<nowOffset then
		container.scrollview:setContentOffset(ccp(0,nowOffset))
	else
		container.scrollview:setContentOffset(ccp(0,maxOffset))
	end
	
	--北京拉伸
	local bg=container:getCCSpriteFromCCB("mContentBG")
	--bg:setScaleX(1.25)
	--说明按钮的名字啊
	local explanationLabel=container:getCCLabelTTFFromCCB("mExplainBtnTex")
	explanationLabel:setString(T(LSTR("CONTINUECHARGE_EXPLANATION")))
	--充值按钮的名字
	local chargeLabel=container:getCCLabelTTFFromCCB("mRechargeBtnTex")
	chargeLabel:setString(T(LSTR("CONTINUECHARGE_GOTOCHARGE")))
	--倒计时
	local leftText=container:getCCLabelTTFFromCCB("mCDTitle")
	leftText:setString(T(LSTR("CONTINUECHARGE_LETFTIMETEXT")))
	--清空倒计时
	local leftTimeNumber=container:getCCLabelTTFFromCCB("mCD")
	leftTimeNumber:setString("")
	local continueTimer = {}
    ListenTimer(Timer:Always(1,"ContiuneChargeTimer"), ContinueChargeContent.updateRemainTime, continueTimer)
	return container;
end
ContinueCharge.create = create

local onExplainBtn=function(container)
	local param={content=T(LSTR("CONTINUECHARGE_CONTENT")),title=T(LSTR("CONTINUECHARGE_TITLE"))}
	local continuechargedialog = ed.ui.continuechargedialog.create(param)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(continuechargedialog.mainLayer, 101000,43267)
	end
end
ContinueCharge.onExplainBtn=onExplainBtn

local onRechargeBtn=function(container)
	local rechargeLayer = newrecharge.create()
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		scene:addChild(rechargeLayer, 101000)
	end
end
ContinueCharge.onRechargeBtn=onRechargeBtn

local onNetworkReply=function(data)
	LegendLog("--------------------onNetworkReply")
	dataState=data
	local currentNode=ContinueCharge.create()
	--消息回来了
	 local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
     if container then
		container:removeAllChildrenWithCleanup(true)
        container:addChild(currentNode)
     end
end
ContinueCharge.onNetworkReply=onNetworkReply

local function onExit()
    base.onExit()
    CloseTimer("ContiuneChargeTimer")
end
ContinueCharge.onExit = onExit
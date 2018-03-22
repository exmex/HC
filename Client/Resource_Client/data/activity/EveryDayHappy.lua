--Author : chenpanhua 天天乐活动
EveryDayHappyPage = {}
EveryDayHappyPageContent = {}
base = ed.activitys.ActivityPage

local happyEveryDayCBB = nil
local popUpCBB = nil
local everyDayHappyConfig = nil
local isCard = nil
local goldcard_number = 0
local silvercard_number = 0
local coppercard_number = 0
local mContainer = nil
require("ui/popwindow/poptavernloot")

local cardMap = {
    471,
    472,
    473
}
--品级关键词
local ex_rank_key = {
  bronze = "Bronze",
  silver = "Silver",
  gold = "Gold",
  magic = "MagicSoul"
}

local cardPic_res = {
	"UI/alpha/HVGA/activity/ChristmasActivities/Activity_HappyEveryDay/GoldenCard.png",
	"UI/alpha/HVGA/activity/ChristmasActivities/Activity_HappyEveryDay/SilverCard.png",
	"UI/alpha/HVGA/activity/ChristmasActivities/Activity_HappyEveryDay/CopperCard.png",
}

local function onRegisterFunction(eventName,container)
	if eventName == "onActivityBtn" then
		base.onEnter("ChristmasActivity", 2)
		ed.EveryDayHappyPage.create()
    elseif eventName == "onGoldenCardBtn" then	--金卡兑换
		ed.EveryDayHappyPage.onCardEvent(container,1)
	elseif eventName == "onSilverCardBtn" then	--银卡兑换
		ed.EveryDayHappyPage.onCardEvent(container,2)
	elseif eventName == "onCopperCardBtn" then	--铜卡兑换	
		ed.EveryDayHappyPage.onCardEvent(container,3)
	elseif eventName == "onExplainBtn" then	--活动说明
		ed.EveryDayHappyPage.onExplainBtn()
	elseif eventName == "onOpenBtn" then	--活动说明
		ed.EveryDayHappyPage.onOpenBtn(container)	
	elseif eventName == "onClose" then	--活动说明
		ed.EveryDayHappyPage.onClose(container)	
    end
end
ed.EveryDayHappyPage.onRegisterFunction = onRegisterFunction

local function onRegisterFunction(eventName,container)
	if eventName == "onFrame" then
		local id=container:getTag()
		local data={["id"] = everyDayHappyConfig[isCard][id]["id"],["count"] = everyDayHappyConfig[isCard][id]["count"],["type"]=everyDayHappyConfig[isCard][id]["type"]}
		ed.EveryDayHappyPage.itemsClick(container,data)
    end
end
ed.EveryDayHappyPageContent.onRegisterFunction = onRegisterFunction

--说明
function onExplainBtn(container)

	local param={content=T(LSTR("ACTIVITY.EVERYDAYHAPPY_CONTENR")),title=T(LSTR("ACTIVITY.EVERYDAYHAPPY_ACTIVITYTITLE"))}
	local continuechargedialog = ed.ui.continuechargedialog.create(param)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(continuechargedialog.mainLayer, 101000,43267)
	end
end
ed.EveryDayHappyPage.onExplainBtn = onExplainBtn


local function create()
	--注册
	ed.registerNetReply("EveryDayHappyInfoHandler", ed.EveryDayHappyPage.EveryDayHappyInfoHandler)
	
	everyDayHappyConfig = ed.getDataTable("activity/EveryDayHappyConfig")
	
	--先去请求数据
	local msg = ed.upmsg.every_day_happy()
    msg._every_day_happy = 1	--请求数据
    ed.send(msg, "every_day_happy")
	
end
ed.EveryDayHappyPage.create = create

function EveryDayHappyInfoHandler(msg)
    CCLuaLog("ActiveRechargeRebatePage.onEnter")

	everyDayHappyConfig = ed.getDataTable("activity/EveryDayHappyConfig")
	
	--获得数据	
	local status = msg._status
	goldcard_number = msg._goldcard_number
	silvercard_number = msg._silvercard_number
	coppercard_number = msg._coppercard_number
	
	--init page
	happyEveryDayCBB = ed.loadccbi(EveryDayHappyPage,"ccbi/ActiveHappyEveryDay.ccbi")
	if happyEveryDayCBB then
		local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
		if container then
			container:removeAllChildrenWithCleanup(true)
			container:addChild(happyEveryDayCBB)
		end
		
		--init page
		local subtitle = happyEveryDayCBB:getCCLabelTTFFromCCB("mSubtitle")
		if subtitle then
			subtitle:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_TITLE")))
		end
		local explainBtnTex = happyEveryDayCBB:getCCLabelTTFFromCCB("mExplainBtnTex")--说明
		if explainBtnTex then
			explainBtnTex:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_EXPLAIN")))
		end
		local goldCardName = happyEveryDayCBB:getCCNodeFromCCB("mGoldCardName")--金卡兑换
		local label1 = nil
		if goldCardName then
			  label1 = ed.createLabelTTF(T(LSTR("ACTIVITY.EVERYDAYHAPPY_GOLDCARD"),tonumber(goldcard_number)), 15)
			  label1:setAnchorPoint(ccp(0.5, 0.5))
			  ed.setLabelColor(label1, ccc3(164, 41, 6))
			  label1:setPosition(ccp(0, 0))
			  goldCardName:addChild(label1)
		end
		local silverCardName = happyEveryDayCBB:getCCNodeFromCCB("mSilverCardName")--银卡兑换
		local label2 = nil
		if silverCardName then
			  label2 = ed.createLabelTTF(T(LSTR("ACTIVITY.EVERYDAYHAPPY_SILVERCARD"),tonumber(silvercard_number)), 15)
			  label2:setAnchorPoint(ccp(0.5, 0.5))
			  ed.setLabelColor(label2, ccc3(164, 41, 6))
			  label2:setPosition(ccp(0, 0))
			  silverCardName:addChild(label2)
		end
		local copperCardName = happyEveryDayCBB:getCCNodeFromCCB("mCopperCardName")--铜卡兑换
		local label3 = nil
		if copperCardName then
			  label3 = ed.createLabelTTF(T(LSTR("ACTIVITY.EVERYDAYHAPPY_BRONZECARD"),tonumber(coppercard_number)), 15)
			  label3:setAnchorPoint(ccp(0.5, 0.5))
			  ed.setLabelColor(label3, ccc3(164, 41, 6))
			  label3:setPosition(ccp(0, 0))
			  copperCardName:addChild(label3)
		end
		local activityTime = happyEveryDayCBB:getCCLabelTTFFromCCB("mActivityTime")--活动时间
		if activityTime then
			activityTime:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_ACTIVITYTIME"))..everyDayHappyConfig["ActivityTime"])
		end
	end
	
	if status == 2 then
		local items = msg._rewards
		local data = {}
		local addition = {}
		for i = 1,#items do
			data[i] = {
				id = items[i]._id,
				amount = items[i]._amount
			}
            local v = items[i]
            if v._type == "money" then
                ed.player._money = ed.player._money + v._amount
            elseif v._type == "rmb" then
                ed.player._rmb = ed.player._rmb + v._amount
            elseif v._type == "item" then
                ed.player:addEquip(v._id, v._amount)
            elseif v._type == "hero" then
                ed.player:addHero(v._id)
            end
		end
        if cardMap[isCard] then
            ed.player:addEquip(cardMap[isCard], -1)
        end
		addition = {cost={pay = Diamond ,number = 288}}
		ed.EveryDayHappyPage.playButtonAnim(mContainer,data,addition)  --顯示獎勵
	end
	
end
ed.EveryDayHappyPage.EveryDayHappyInfoHandler = EveryDayHappyInfoHandler

local function onCardEvent(container,cardType)
	--这里要来个CCBI
	popUpCBB = ed.loadccbi(EveryDayHappyPage,"ccbi/ActiveHappyEveryDayPopUp.ccbi")
	local popUpExplain = nil
	local contentCCBI = nil
	if popUpCBB then
		
		popUpCBB:setPosition(ccp(-85, -25))
		--popUpCBB:registerTouchDispatcherSelf(-128) --防止穿透
		container:addChild(popUpCBB)
		
		popUpExplain = popUpCBB:getCCLabelTTFFromCCB("mPopUpExplain")
		local oPenBtnTex = popUpCBB:getCCLabelTTFFromCCB("mOPenBtnTex")
		if oPenBtnTex then
			oPenBtnTex:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_OPEN")))
		end

		if everyDayHappyConfig ~= nil then
			for curr = 1,#everyDayHappyConfig[cardType] do
				local id = everyDayHappyConfig[cardType][curr]["id"]
				local position = everyDayHappyConfig[cardType][curr]["position"]
				contentCCBI = ed.loadccbi(EveryDayHappyPageContent,"ccbi/ActiveHappyEveryDayContent.ccbi")
				if contentCCBI ~= nil and id ~= nil then
					local itemNode = popUpCBB:getCCNodeFromCCB("mItemNode")
					local addItemNode = contentCCBI:getCCNodeFromCCB("mAddItemNode")
					local frameButton = contentCCBI:getCCMenuItemImageFromCCB("mFrame")
					frameButton:setPosition(ccp(position[1],position[2]))
					local icon = ed.readequip.createIcon(id)
					icon:setPosition(ccp(position[1],position[2]))
					icon:setScale(0.8)
					addItemNode:addChild(icon)
					contentCCBI:setTag(curr)
					itemNode:addChild(contentCCBI)	

                    ed.EveryDayHappyPage.enbaleBtn(false)
				end
			end
		end
	end
	isCard = cardType
	
	local existingNum = popUpCBB:getCCLabelTTFFromCCB("mExistingNum")
	local cardIcon = popUpCBB:getCCSpriteFromCCB("mCardIcon")
	
	local x = "x"
	--点击兑换按钮的处理时间
	if cardType == 1 then	--金卡
		if popUpExplain and existingNum then
			popUpExplain:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_GOLDCARD")))
			existingNum:setString(x..tostring(goldcard_number))
		end
	elseif cardType == 2 then  --银卡
		if popUpExplain and existingNum then
			popUpExplain:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_SILVERCARD")))
			existingNum:setString(x..tostring(silvercard_number))
		end
	else	--铜卡
		if popUpExplain and existingNum then
			popUpExplain:setString(T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_BRONZECARD")))
			existingNum:setString(x..tostring(coppercard_number))
		end
	end
	if cardIcon then
		local localPic = cardPic_res[cardType]
		local tenTex = CCTextureCache:sharedTextureCache():addImage(localPic);
		cardIcon:setTexture(tenTex)
	end
end
ed.EveryDayHappyPage.onCardEvent = onCardEvent

local function onOpenBtn(container)
    ed.EveryDayHappyPage.enbaleBtn(true)
	if isCard == 1 and goldcard_number <= 0 then
		local info = {
			text = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_GOLDCARDLACK")),
			leftText = T(LSTR("CHATCONFIG.CANCEL")),
			rightText = T(LSTR("CHATCONFIG.CONFIRM")),
			rightHandler = function()
			xpcall(function()
				--todo...
			end, EDDebug)
		end
		}
		ed.showConfirmDialog(info)
		return
	elseif isCard == 2 and silvercard_number <= 0 then
		local info = {
			text = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_SILVERCARDLACK")),
			leftText = T(LSTR("CHATCONFIG.CANCEL")),
			rightText = T(LSTR("CHATCONFIG.CONFIRM")),
			rightHandler = function()
			xpcall(function()
				--todo...
			end, EDDebug)
		end
		}
		ed.showConfirmDialog(info)
		return
	elseif isCard == 3 and coppercard_number <= 0 then
		local info = {
			text = T(LSTR("ACTIVITY.EVERYDAYHAPPY_POPUP_BRONZECARDLACK")),
			leftText = T(LSTR("CHATCONFIG.CANCEL")),
			rightText = T(LSTR("CHATCONFIG.CONFIRM")),
			rightHandler = function()
			xpcall(function()
				--todo...
			end, EDDebug)
		end
		}
		ed.showConfirmDialog(info)
		return
	end
	mContainer = container
	ed.registerNetReply("EveryDayHappyExchangeInfoHandler", ed.EveryDayHappyPage.EveryDayHappyExchangeInfoHandler)
	--點擊兌換
	local msg = ed.upmsg.every_day_happy()
	local cardId = 0
	if isCard ==1 then
		cardId = 2
	elseif isCard == 2 then
		cardId = 3
	elseif isCard == 3 then
		cardId = 4
	end
    msg._every_day_happy = cardId	--请求数据 2,3,4 分別表示金銀銅
    ed.send(msg, "every_day_happy")
end
ed.EveryDayHappyPage.onOpenBtn = onOpenBtn

local function EveryDayHappyExchangeInfoHandler(msg)
	ed.EveryDayHappyPage.EveryDayHappyInfoHandler(msg)
end
ed.EveryDayHappyPage.EveryDayHappyExchangeInfoHandler = EveryDayHappyExchangeInfoHandler

local function onClose(container)
	--container:unregisterTouchDispatcherSelf()
    ed.EveryDayHappyPage.enbaleBtn(true)
	container:removeAllChildrenWithCleanup(true)
end
ed.EveryDayHappyPage.onClose = onClose

local itemsClick = function(container,data)
	ed.EveryDayHappyPage:destroyRewardDetail()
	local container = CCLayer:create()
	EveryDayHappyPage.rdContainer = container
	container:setTouchEnabled(true)
	container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        ed.EveryDayHappyPage:destroyRewardDetail()
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
ed.EveryDayHappyPage.itemsClick = itemsClick

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
ed.EveryDayHappyPage.destroyRewardDetail = destroyRewardDetail

local playButtonAnim = function(container,data,addition)
  status = 1
  local mType = "gold"
  if #data > 1 then
	mType = "starshop"
  end
  
  local popWindow = ed.ui.poptavernloot.create({
      type = mType,
      times = "one",
      loots = data,
      addition = addition
    })
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(popWindow.mainLayer, 150)
	end
end
ed.EveryDayHappyPage.playButtonAnim = playButtonAnim

local function getTable()
  return ed.getDataTable("TavernType")
end
ed.EveryDayHappyPage.getTable = getTable

local function getExRank(box)
  local tn = ex_rank_key
  local tt = ed.EveryDayHappyPage.getTable()
  return tt[tn[box]]['true']['false'][0]["Exhibition Rank"]
end
ed.EveryDayHappyPage.getExRank = getExRank

local function onExit()
    base.onExit()
end
ed.EveryDayHappyPage.onExit = onExit

local function enbaleBtn(isEnable)
    
    if happyEveryDayCBB then
        local goldBtn = happyEveryDayCBB:getCCMenuItemImageFromCCB("mGoldenCardBtn")
        local silverBtn = happyEveryDayCBB:getCCMenuItemImageFromCCB("mSilverCardBtn")
        local copperBtn = happyEveryDayCBB:getCCMenuItemImageFromCCB("mCopperCardBtn")
        local explainBtn = happyEveryDayCBB:getCCMenuItemImageFromCCB("mExplainBtn")
        if goldBtn then
            goldBtn:setEnabled(isEnable)
        end
        if silverBtn then
            silverBtn:setEnabled(isEnable)
        end
        if copperBtn then
            copperBtn:setEnabled(isEnable)
        end
        if explainBtn then
            explainBtn:setEnabled(isEnable)
        end
    end
end
ed.EveryDayHappyPage.enbaleBtn = enbaleBtn
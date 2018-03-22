--Author : xinghui
base = ed.activitys.ActivityPage
LottoPage = {}
LottoPage.info = {}
LottoPage.ui = {}
LottoPage.info.scrollTexts = {}
LottoPage.ui.numberScrolls = {}
local scrollTextOffsetHeight = 0
local numberStop = true
local maxWaitTime = 0
local currWaitTime = 0
local numIsInsert = false
local function onRegisterFunction(eventName,container)
    if eventName == "onActivityBtn" then
        base.onEnter("NearActivity", 1)
        local msg = ed.upmsg.activity_lotto_info()
        msg._activity_id = 1
        msg._group_id = "NearActivity"
        ed.send(msg, "activity_lotto_info")
        ed.netreply.LottoInfoHandler = ed.LottoPage.LottoInfoHandler()
--        local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
--        container:removeAllChildrenWithCleanup(true)
    elseif eventName == "onEnterBtn" then
        local msg = ed.upmsg.activity_lotto_reward()
        msg._group_id = "NearActivity"
        msg._activity_id = 1
        ed.send(msg, "activity_lotto_reward")
        currWaitTime = maxWaitTime
        ed.netreply.LottoRewardHandler = ed.LottoPage.LottoRewardHandler()
        local btnNode = LottoPage.ui.ccb_lotto:getCCMenuItemImageFromCCB("mEnterBtn")
        if btnNode then
            LottoPage.ui.enterBtnNode = btnNode
            btnNode:setEnabled(false)
        end
    elseif eventName == "onConfirm" then
        local rewardNode = ed.ccb_container:getCCNodeFromCCB("mMsgNode")
        if rewardNode then
            rewardNode:setVisible(false)
            local needDiamondNode = LottoPage.ui.ccb_lotto:getCCNodeFromCCB("mPayGoldNode")
            if needDiamondNode then
                needDiamondNode:setVisible(true)
            end 
            if LottoPage.ui.ccb_lotto then
                local diamondTex = LottoPage.ui.ccb_lotto:getCCLabelTTFFromCCB("mNeedNum")
                if diamondTex then
                    if LottoPage.info.have_next_round then
                        diamondTex:setString(tostring(LottoPage.info.need_diamond_num))
                    else
                        diamondTex:setString(tostring(LottoPage.info.rewardNum))
                    end
                end
            end
            for i=1, 5 do 
                --LottoPage.ui.numberScrolls[i]:setContentOffset(ccp(0, 0))
            end
        end
    end
end
ed.LottoPage.onRegisterFunction = onRegisterFunction

local function LottoInfoHandler()
    local function handler(msg)
        xpcall(
        function()
        --活动基本信息
            local remain_time = msg._remain_time
            remain_time = remain_time and remain_time or 0
            LottoPage.info.remain_time = remain_time
            LottoPage.info._current_step = msg._current_step

            local scrollTexts = SplitEx(LSTR("ACTIVITY.BIGLOTTO_REWARD_CONTENT"), "_")
            scrollTexts = scrollTexts and scrollTexts or {}
            LottoPage.info.scrollTexts = scrollTexts
            if ed.ccb_container then
                local ccb_lotto = ed.loadccbi(ed.LottoPage, "ccbi/ActiveLotoPage.ccbi")
                LottoPage.ui.ccb_lotto = ccb_lotto
                local diamonContent = ccb_lotto:getCCLabelTTFFromCCB("mExisting")
                if diamonContent then
                    diamonContent:setString(LSTR("ACTIVITY.BIGLOTTO_NOWHAVE"))
                end
                local fortuneAwayContent = ccb_lotto:getCCLabelTTFFromCCB("mLottoCDTex")
                if fortuneAwayContent then
                    fortuneAwayContent:setString(LSTR("ACTIVITY.BIGLOTTO_FORTUNEAWAY"))
                end
                local fortuneEnterContent = ccb_lotto:getCCLabelTTFFromCCB("mEnterTex")
                if fortuneEnterContent then
                    fortuneEnterContent:setString(LSTR("ACTIVITY.BIGLOTTO_FORTUNECOME"))
                end
                local diamondNeedContent = ccb_lotto:getCCLabelTTFFromCCB("mNeed")
                if diamondNeedContent then
                    diamondNeedContent:setString(LSTR("ACTIVITY.BIGLOTTO_NEED"))
                end

                for i = 1, 5 do
                    local scrollNode = ccb_lotto:getCCNodeFromCCB("mNumNode" .. i)
                    if scrollNode then
                        --scrollNode:setScale(1.25)
                    end
                    local scroll = ccb_lotto:getCCScrollViewFromCCB("mNumAni"..i)
                    if scroll then
                        --scroll:setScale(0.8)
                    end
                end
                local enterBtnMenu = ccb_lotto:getCCMenuItemImageFromCCB("mEnterBtn")
                if enterBtnMenu then
                    --enterBtnMenu:setScale(1.25)
                end

                local dimondNum = ccb_lotto:getCCLabelTTFFromCCB("mGold")
                if dimondNum then
                    dimondNum:setString(tostring(msg._diamond_num))
                    LottoPage.info.current_diamond_num = msg._diamond_num
                end
                local lottoEventScope = {}
                ListenTimer(Timer:Always(1, "LottoPageTimer"), ed.LottoPage.updateRemainTime, lottoEventScope)
                if ccb_lotto then
                    local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
                    if container then
						container:removeAllChildrenWithCleanup(true)
                        container:addChild(ccb_lotto)
                    end
                end
                --need diamond
                if ccb_lotto then
                    local diamondTex = ccb_lotto:getCCLabelTTFFromCCB("mNeedNum")
                    if diamondTex then
                        diamondTex:setString(msg._need_diamond_num)
                    end
                end
                LottoPage.info.need_diamond_num = msg._need_diamond_num
                --scroll text
                local scrollTextScroll = ccb_lotto:getCCScrollViewFromCCB("mTexAutoRollSV")
                LottoPage.ui.scrollTextScroll = scrollTextScroll
                scrollTextScroll:setContentOffset(ccp(0, 0))
                scrollTextScroll:setTouchEnabled(false)
                local scrollTextScrollContainer = scrollTextScroll:getContainer()
                local contentSizeWidth = 0
                local contentSizeHeight = 0
                for i, v in ipairs(LottoPage.info.scrollTexts) do
                    local ccb_ttf = CCLabelTTF:create(v, "Helvetica", 20)
                    if ccb_lotto then
                        if scrollTextScrollContainer and ccb_ttf then
                            ccb_ttf:setAnchorPoint(ccp(0.5, 1))
                            scrollTextScrollContainer:addChild(ccb_ttf)
                            ccb_ttf:setPosition(ccp(scrollTextScroll:getViewSize().width/2, 0-(i-1)*(ccb_ttf:getContentSize().height)-5))
                        end
                    end
                    if contentSizeWidth < ccb_ttf:getContentSize().width then
                        contentSizeWidth = ccb_ttf:getContentSize().width
                    end
                    contentSizeHeight = contentSizeHeight + (ccb_ttf:getContentSize().height)+5
                end
                scrollTextScroll:setContentSize(CCSize(contentSizeWidth, contentSizeHeight))
                scrollTextOffsetHeight = scrollTextScroll:getContentSize().height +scrollTextScroll:getViewSize().height +5
                scrollTextScroll:setContentOffsetInDuration(ccp(0, scrollTextOffsetHeight), 10)
            end
        end
        , EDDebug)
    end
    return handler
end
ed.LottoPage.LottoInfoHandler = LottoInfoHandler

local function onExit()
    base.onExit()
    CloseTimer("LottoPageTimer")
end
ed.LottoPage.onExit = onExit

local function LottoRewardHandler()
    local function handler(msg)
        xpcall(
            function()
                if msg._status == 1 then
                    local needDiamondNode = LottoPage.ui.ccb_lotto:getCCNodeFromCCB("mPayGoldNode")
                    if needDiamondNode then
                        needDiamondNode:setVisible(false)
                    end 
                    LottoPage.info.current_diamond_num = msg._diamond_num + msg._reward_diamon_num - LottoPage.info.need_diamond_num
                    
                    LottoPage.info.have_next_round = msg._have_next_round
                    local rewardNum = msg._reward_diamon_num
                    LottoPage.info.rewardNum = rewardNum
                    LottoPage.info.need_diamond_num = msg._need_diamond_num
                    local rewardArray = {}
                    for i=1, 5 do 
                        local num = rewardNum % 10
                        table.insert(rewardArray, num)
                        rewardNum = math.floor(rewardNum / 10)
                    end
                    for j=1, 5 do
                        ed.LottoPage.initScrollNumText(6-j, rewardArray[6-j], j)
                    end

                    numIsInsert = true
                    numberStop=false
                elseif msg._status == 0 then
                    --todo:钻石不足
                    ed.showToast(LSTR("ACTIVITY.BIGLOTTO_DIAMONDNOTENOUGH"))
                    if LottoPage.ui.enterBtnNode then
                        LottoPage.ui.enterBtnNode:setEnabled(true)
                    end
                elseif  msg._status == 3 then
                    ed.showToast(LSTR("ACTIVITY.BIGLOTTO_ONMORE"))
                    if LottoPage.ui.enterBtnNode then
                        LottoPage.ui.enterBtnNode:setEnabled(true)
                    end
                elseif msg._status == 4 then
                    ed.showToast(LSTR("ACTIVITY.BIGLOTTO_SERVERWRONG"))
                    if LottoPage.ui.enterBtnNode then
                        LottoPage.ui.enterBtnNode:setEnabled(true)
                    end
                end
            end, EDDebug
        )
    end
    return handler
end
ed.LottoPage.LottoRewardHandler = LottoRewardHandler

local function initScrollNumText(circleNum, stopNum, scrollIndex)
    local scroll_num = LottoPage.ui.ccb_lotto:getCCScrollViewFromCCB("mNumAni"..scrollIndex)
    scroll_num:setContentSize(CCSizeMake(0, 0))
    scroll_num:setContentOffset(ccp(0, 0))
    scroll_num:setTouchEnabled(false)
    --table.insert(LottoPage.ui.numberScrolls, scroll_num)
    local scroll_layer = scroll_num:getContainer()
    scroll_layer:removeAllChildrenWithCleanup(true)
    local scroll_size = scroll_num:getViewSize()
    
    if scroll_num then
        --if numIsInsert== false then
            for i=0, 10*circleNum+stopNum do
                local j = i % 10
                local numPic = "UI/alpha/HVGA/activity/Activity_Lotto/Activity_Lotto_Num_"..j..".png"
                local numSprite = CCSprite:create(numPic)
                numSprite:setAnchorPoint(ccp(0.5, 0.5))
                scroll_layer:addChild(numSprite)
                local size = scroll_layer:getContentSize()
                numSprite:setPosition(ccp(scroll_size.width/2,scroll_size.height/2 + i*(scroll_size.height/2+numSprite:getContentSize().height/2)))
                local width = numSprite:getContentSize().width
                local tmpsize = scroll_num:getContentSize()
                if tmpsize.width< width then
                    tmpsize.width = width
                end
                if i>0 then
                    tmpsize.height = tmpsize.height + scroll_size.height/2+numSprite:getContentSize().height/2
                end
                scroll_num:setContentSize(tmpsize)
            end
        --end
       
        scroll_num:setContentOffset(ccp(0, 0))
        local tmp = scroll_num:getContentSize().height
        scroll_num:setContentOffsetInDuration(ccp(0, 0-scroll_num:getContentSize().height), circleNum*1.5)
        if maxWaitTime<circleNum*1.5 then
            maxWaitTime = circleNum*1.5
            currWaitTime = maxWaitTime
        end
    end
end
ed.LottoPage.initScrollNumText = initScrollNumText

local function updateRemainTime()
--deal deadline
    LottoPage.info.remain_time = math.max(0, LottoPage.info.remain_time - 1)
    if LottoPage.info.remain_time == 0 then
        return
    else
        local timeStr = ed.getdhmsCString2(LottoPage.info.remain_time)
        if LottoPage.ui.ccb_lotto then
            local time_ui = LottoPage.ui.ccb_lotto:getCCLabelTTFFromCCB("mCD")
            if time_ui then
                time_ui:setString(timeStr)
            end
        end
    end
    --deal scroll text
    if LottoPage.ui.scrollTextScroll then
        local offset = LottoPage.ui.scrollTextScroll:getContentOffset()
        if scrollTextOffsetHeight <= offset.y then
            LottoPage.ui.scrollTextScroll:setContentOffset(ccp(0, 0))
            LottoPage.ui.scrollTextScroll:setContentOffsetInDuration(ccp(0, scrollTextOffsetHeight), 10)
        end
    end

    if numberStop==false then
        currWaitTime = currWaitTime-1
        if currWaitTime<-1.4 then
            if LottoPage.ui.enterBtnNode then
                LottoPage.ui.enterBtnNode:setEnabled(true)
            end
            --todo:show reward ui
            local dimondNum = LottoPage.ui.ccb_lotto:getCCLabelTTFFromCCB("mGold")
            if dimondNum then
                dimondNum:setString(tostring(LottoPage.info.current_diamond_num))
            end
            ed.player._rmb = LottoPage.info.current_diamond_num
            local rewardCcbi = ed.loadccbi(ed.LottoPage, "ccbi/ActiveLotoPopUp.ccbi")
            if rewardCcbi then
                local rewardNode = ed.ccb_container:getCCNodeFromCCB("mMsgNode")
                if rewardNode then
                    rewardNode:removeAllChildrenWithCleanup(true)
                    local rewardContent = rewardCcbi:getCCLabelTTFFromCCB("mActiveLottoPopUpTitle")
                    if rewardContent then
                        rewardContent:setString(LSTR("ACTIVITY.BIGLOTTO_LUCK"))
                    end
                    local congraContent = rewardCcbi:getCCLabelTTFFromCCB("mGetGoldTex")
                    if congraContent then
                        congraContent:setString(T(LSTR("ACTIVITY.BIGLOTTO_CONGRATULATION"), LottoPage.info.rewardNum))
                    end
                    local btnContent = rewardCcbi:getCCLabelTTFFromCCB("mConfirm")
                    if btnContent then
                        btnContent:setString(LSTR("ACTIVITY.BIGLOTTO_OK"))
                    end
                    rewardCcbi:setPosition(ccp(-400, -250))
                    rewardNode:addChild(rewardCcbi)
                    rewardNode:setVisible(true)
                end
            end
            numberStop = true
        end
    end
end
ed.LottoPage.updateRemainTime = updateRemainTime

--Author : cooper.x
--Date   : 2014/12/15

base = ed.activitys.ActivityPage
BigPackagePage = {}
BigPackagePage.info = {}
BigPackagePage.info.alreadyget = {}
bigpackage_ccb_container = nil
currentBtnIndex = 0
alreadyRewardCount = 0
local function BigPackageInfoHandler()
    local function handler(msg)
        xpcall(
            function()
                --活动基本信息
                alreadyRewardCount = 0
                local activityCfgs = ed.getDataTable("activity/ActivityConfig")
                local activityCfg = activityCfgs["ChristmasActivity"][1]
                BigPackagePage.info._people_count = msg._people_count
                BigPackagePage.info._remain_times = msg._remain_times
                BigPackagePage.info._next_reset_price = msg._next_reset_price
                BigPackagePage.info._current_ranking = msg._current_ranking
                BigPackagePage.info._distance_score_20 = msg._distance_score_20
                if msg._get_box_ids then
                    for i=1, (#msg._get_box_ids) do
                        local index = msg._get_box_ids[i]
                        if index ~=0 then
                            BigPackagePage.info.alreadyget[tostring(index)] = 1
                            alreadyRewardCount = alreadyRewardCount +1
                        end
                        --todo:给box换图片
                    end
                else
                    alreadyRewardCount = 0
                    BigPackagePage.info.alreadyget = {}
                end
                

                if bigpackage_ccb_container == nil then
                    bigpackage_ccb_container = ed.loadccbi(ed.BigPackagePage, "ccbi/ActiveChristmasBall.ccbi")
                end
                if bigpackage_ccb_container then
                    local container = ed.ccb_container:getCCNodeFromCCB("mActiveDetailPageNode")
                    if container then
						container:removeAllChildrenWithCleanup(true)
                        container:addChild(bigpackage_ccb_container)
                    end

                    local titleContentLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mSubtitle")
                    if titleContentLabel then
                        titleContentLabel:setString(LSTR("ACTIVITY.BIGPACKAGE.SUBTITLE"));
                    end
                    local explainBtnLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mExplainBtnTex")
                    if explainBtnLabel then
                        explainBtnLabel:setString(LSTR("ACTIVITY.BIGPACKAGE.EXPLAIN"))
                    end
                    local explainBtnLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mResetBtnTex")
                    if explainBtnLabel then
                        explainBtnLabel:setString(LSTR("ACTIVITY.BIGPACKAGE.RESET"))
                    end
                    local peopleCountLable = bigpackage_ccb_container:getCCLabelTTFFromCCB("mIntegralTex")
                    if peopleCountLable then
                        peopleCountLable:setString(LSTR("ACTIVITY.BIGPACKAGE.SCORE"))
                    end
                    if msg._people_count>0 then
                        local count = msg._people_count
                        for i=1, 6 do
                            local index = count % 10
                            local countSprite = bigpackage_ccb_container:getCCSpriteFromCCB("mIntegralNum"..(6-i+1))
                            if countSprite then
                                local picPath = "UI/alpha/HVGA/activity/ChristmasActivities/Activity_ChristmasBall/Activity_ChristmasBall_Num0"..index..".png"
                                local picTexture = CCTextureCache:sharedTextureCache():addImage(picPath);
                                if picTexture then
                                    countSprite:setTexture(picTexture)
                                    count = math.floor(count / 10)
                                end
                            end
                        end
                    end

                    local peopleCountLable = bigpackage_ccb_container:getCCLabelTTFFromCCB("mRankTex")
                    if peopleCountLable then
                        peopleCountLable:setString(LSTR("ACTIVITY.BIGPACKAGE.RANK"))
                    end
                    if msg._current_ranking>0 then
                        local rank = msg._current_ranking
                        for i=1, 6 do
                            local index = rank % 10
                            local rankSprite = bigpackage_ccb_container:getCCSpriteFromCCB("mRankNum"..(6-i+1))
                            if rankSprite then
                                local picPath = "UI/alpha/HVGA/activity/ChristmasActivities/Activity_ChristmasBall/Activity_ChristmasBall_Num0"..index..".png"
                                local picTexture = CCTextureCache:sharedTextureCache():addImage(picPath);
                                if picTexture then
                                    rankSprite:setTexture(picTexture)
                                    rank = math.floor(rank / 10)
                                end
                            end
                        end
                    end
                    --
                    local bigRewardRank = tonumber(activityCfg["big_reward_rank"]) or 0
                    local rankLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mIntegralTargetTex")
                    if msg._current_ranking <= bigRewardRank then
                        if msg._current_ranking > 1 then
                            if rankLabel then
                                rankLabel:setString(T(LSTR("ACTIVITY.BIGPACKAGE.DIATANCESCORE"), 1, msg._distance_score_20))
                            end
                        else
                            if rankLabel then
                                rankLabel:setString(LSTR("ACTIVITY.BIGPACKAGE.GOTFIRST"))
                            end
                        end
                    else
                        if rankLabel then
                            rankLabel:setString(T(LSTR("ACTIVITY.BIGPACKAGE.DIATANCESCORE"), bigRewardRank, msg._distance_score_20))
                        end
                    end

                    local alreadyBoxNumLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mGetGiftNum")
                    if alreadyBoxNumLabel then
                        alreadyBoxNumLabel:setString(alreadyRewardCount.."/3")
                    end

                    local activityLable = bigpackage_ccb_container:getCCLabelTTFFromCCB("mExchangeExplain")
                    if activityLable then
                        activityLable:setString(LSTR("ACTIVITY.BIGPACKAGE.EXCHANGE_EXPLAIN"))
                    end
                    local timeDurTex = ""
                    if activityCfg then
                        local startTimeY, startTimeM, startTimeD = ed.getDateByStr(activityCfg["start_time"])
                        local startTime = os.time({year = startTimeY, month = startTimeM, day = startTimeD})

                        local dur = tonumber(activityCfg["during_time"])--以天为单位
                        local offSet = 60*60*24*dur
                        local endTime = os.date("*t", startTime + tonumber(offSet))
                        
                        timeDurTex = startTimeY.."."..startTimeM.."."..startTimeD.." - "..endTime.year.."."..endTime.month.."."..endTime.day

                    end
                    local timeLable = bigpackage_ccb_container:getCCLabelTTFFromCCB("mActivityTime")
                    if timeLable then
                        timeLable:setString(LSTR("ACTIVITY.BIGPACKAGE.TIME")..timeDurTex)
                    end
                else
                    local info = {
			          text = "load ActiveChristmasBall.ccbi error!!!",
			          leftText = T(LSTR("CHATCONFIG.CANCEL")),
			          rightText = T(LSTR("CHATCONFIG.CONFIRM")),
			          rightHandler = function()
				        xpcall(function()
				          --currentSelectDropIndex = index
				          --guild.conformDistribute()
				        end, EDDebug)
			          end
			        }
			        ed.showConfirmDialog(info)
                end
            end, EDDebug
        )
    end
    return handler
end
ed.BigPackagePage.BigPackageInfoHandler = BigPackageInfoHandler

local function getActivityInfo()
    base.onEnter("ChristmasActivity", 1)
    local msg = ed.upmsg.activity_bigpackage_info()
    msg._group_id = "ChristmasActivity"
    msg._activity_id = 1
    ed.send(msg, "activity_bigpackage_info")
    ed.netreply.BigPackageInfoHandler = ed.BigPackagePage.BigPackageInfoHandler()
end
ed.BigPackagePage.getActivityInfo = getActivityInfo

local function BigPackageRewardInfoHandler()
    local function handler(msg)
        xpcall(
            function ()
                if msg._status == 1 then
                    if msg._people_count then
                        BigPackagePage.info._people_count = msg._people_count
                        local count = msg._people_count
                        for i=1, 6 do
                            local index = count % 10
                            local countSprite = bigpackage_ccb_container:getCCSpriteFromCCB("mIntegralNum"..(6-i+1))
                            if countSprite then
                                local picPath = "UI/alpha/HVGA/activity/ChristmasActivities/Activity_ChristmasBall/Activity_ChristmasBall_Num0"..index..".png"
                                local picTexture = CCTextureCache:sharedTextureCache():addImage(picPath);
                                if picTexture then
                                    countSprite:setTexture(picTexture)
                                    count = math.floor(count / 10)
                                end
                            end
                        end
                    end
                    BigPackagePage.info.alreadyget[currentBtnIndex] = 1
                    alreadyRewardCount = alreadyRewardCount + 1
                    ----------------
                    local activityCfgs = ed.getDataTable("activity/ActivityConfig")
                    local activityCfg = activityCfgs["ChristmasActivity"][1]
                    BigPackagePage.info._current_ranking = msg._current_ranking
                    if msg._current_ranking>0 then
                        local rank = msg._current_ranking
                        for i=1, 6 do
                            local index = rank % 10
                            local rankSprite = bigpackage_ccb_container:getCCSpriteFromCCB("mRankNum"..(6-i+1))
                            if rankSprite then
                                local picPath = "UI/alpha/HVGA/activity/ChristmasActivities/Activity_ChristmasBall/Activity_ChristmasBall_Num0"..index..".png"
                                local picTexture = CCTextureCache:sharedTextureCache():addImage(picPath);
                                if picTexture then
                                    rankSprite:setTexture(picTexture)
                                    rank = math.floor(rank / 10)
                                end
                            end
                        end
                    end

                    BigPackagePage.info._distance_score_20 = msg._distance_score_20
                    local bigRewardRank = tonumber(activityCfg["big_reward_rank"]) or 0
                    local rankLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mIntegralTargetTex")
                    if msg._current_ranking <= bigRewardRank then
                        if msg._current_ranking > 1 then
                            if rankLabel then
                                rankLabel:setString(T(LSTR("ACTIVITY.BIGPACKAGE.DIATANCESCORE"), 1, msg._distance_score_20))
                            end
                        else
                            if rankLabel then
                                rankLabel:setString(LSTR("ACTIVITY.BIGPACKAGE.GOTFIRST"))
                            end
                        end
                    else
                        if rankLabel then
                            rankLabel:setString(T(LSTR("ACTIVITY.BIGPACKAGE.DIATANCESCORE"), bigRewardRank, msg._distance_score_20))
                        end
                    end

                    local alreadyBoxNumLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mGetGiftNum")
                    if alreadyBoxNumLabel then
                        alreadyBoxNumLabel:setString(alreadyRewardCount.."/3")
                    end
                    -----------------
                    local itemIds = msg._item_ids
                    local rewards = msg._rewards
                    local tmpItems = {}
                    for i, v in ipairs(rewards) do
                        if v._type == "money" then
                            ed.player._money = ed.player._money + v._amount
                        elseif v._type == "rmb" then
                            ed.player._rmb = ed.player._rmb + v._amount
                        elseif v._type == "item" then
                            ed.player:addEquip(v._id, v._amount)
                        elseif v._type == "hero" then
                            ed.player:addHero(v._id)
                        end
                        tmpItems[i] = {}
                        tmpItems[i].id = itemIds[i]
                        tmpItems[i].amount = v._amount
                    end
                    status = 1
                    local popWindow = ed.ui.poptavernloot.create({
                      type = "starshop",
                      times = "one",
                      loots = tmpItems,
                      addition = {cost={pay = Diamond ,number = 0}}
                    })
                    local scene = CCDirector:sharedDirector():getRunningScene()
                    if scene then
                        scene:addChild(popWindow.mainLayer, 150)
                    end
                else
                    ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.REWARD_FAILED"))
                end
            end, EDDebug
        )
    end
    return handler
end
ed.BigPackagePage.BigPackageRewardInfoHandler = BigPackageRewardInfoHandler

local function getTreeReward(boxIndex)
    local msg = ed.upmsg.activity_bigpackage_reward_info()
    msg._group_id = "ChristmasActivity"
    msg._activity_id = 1
    msg._box_id = tonumber(boxIndex)
    ed.send(msg, "activity_bigpackage_reward_info")
    ed.netreply.BigPackageRewardInfoHandler = ed.BigPackagePage.BigPackageRewardInfoHandler()
end
ed.BigPackagePage.getTreeReward = getTreeReward

local function BigPackageResetHandler()
    local function handler(msg)
        xpcall(
            function()
                if msg._status == 1 then
                    for k, v in pairs(BigPackagePage.info.alreadyget) do
                        table.remove(BigPackagePage.info.alreadyget, k)
                    end
                    BigPackagePage.info.alreadyget = {}
                    alreadyRewardCount = 0
                    if BigPackagePage.info._next_reset_price and BigPackagePage.info._next_reset_price>0 then
                        --ed.player:addMoney(0-BigPackagePage.info._next_reset_price)
                        ed.player._rmb = ed.player._rmb - BigPackagePage.info._next_reset_price
                    end
                    BigPackagePage.info._next_reset_price = msg._next_reset_price
                    local alreadyBoxNumLabel = bigpackage_ccb_container:getCCLabelTTFFromCCB("mGetGiftNum")
                    if alreadyBoxNumLabel then
                        alreadyBoxNumLabel:setString(alreadyRewardCount.."/3")
                    end
                elseif msg._status == 2 then
                    ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.RESETOVER"))
                else
                    ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.RESETERROR"))
                end
            end, EDDebug
        )
    end
    return handler
end
ed.BigPackagePage.BigPackageResetHandler = BigPackageResetHandler

local function resetInfo()
    if BigPackagePage.info._next_reset_price > 0 then
        if BigPackagePage.info._next_reset_price > ed.player._rmb then
            ed.showHandyDialog("toRecharge")
        else
            local info = {
			text = T(LSTR("ACTIVITY.BIGPACKAGE.RESET_MAKESURE"), BigPackagePage.info._next_reset_price),
			leftText = T(LSTR("CHATCONFIG.CANCEL")),
			rightText = T(LSTR("CHATCONFIG.CONFIRM")),
			rightHandler = function()
			    xpcall(function()
				    -----------------------------------------------
                    local msg = ed.upmsg.activity_bigpackage_reset()
                    msg._group_id = "ChristmasActivity"
                    msg._activity_id = 1
                    ed.send(msg, "activity_bigpackage_reset")
                    ed.netreply.BigPackageResetHandler = ed.BigPackagePage.BigPackageResetHandler()
                    -----------------------------------------------
			    end, EDDebug)
			end
		    }
		    ed.showConfirmDialog(info)
        end
    else
        --所有次数都结束了
        ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.ALLCOUNT_OVER"))
    end
end
ed.BigPackagePage.resetInfo = resetInfo

local function showExplain()
    local param={content=LSTR("ACTIVITY.BIGPACKAGE.DETAILEXPLAIN"),title=LSTR("ACTIVITY.BIGPACKAGE.EXPLAIN")}
	local continuechargedialog = ed.ui.continuechargedialog.create(param)
	local scene=CCDirector:sharedDirector():getRunningScene()
	if scene~=nil then
		 scene:addChild(continuechargedialog.mainLayer, 101000,43267)
	end
end
ed.BigPackagePage.showExplain = showExplain

local function onRegisterFunction(eventName,container)
    if eventName == "onActivityBtn" then
        ed.BigPackagePage.getActivityInfo()
        -------------------------------------------------------
--        status = 1
--        local popWindow = ed.ui.poptavernloot.create({
--                      type = "gold",
--                      times = "one",
--                      loots = {104, 105, 106},
--                      addition = {cost={pay = Diamond ,number = 0}}
--                    })
--                    local current_scene = ed.getCurrentScene()
--                    if current_scene then
--                        current_scene:addChild(popWindow.mainLayer)
--                    end

        -------------------------------------------------------
    elseif string.find(eventName, "onGiftPackageBtn") then
        currentBtnIndex = string.sub(eventName, -1)
        if BigPackagePage.info.alreadyget[currentBtnIndex] then
            ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.REWARD_GOT"))
        else
            if alreadyRewardCount>=3 then
                ed.showToast(LSTR("ACTIVITY.BIGPACKAGE.GOTORESET"))
            else 
                ed.BigPackagePage.getTreeReward(currentBtnIndex)
            end
        end
    elseif eventName == "onResetBtn" then
        ed.BigPackagePage.resetInfo()
    elseif eventName == "onExplainBtn" then
        ed.BigPackagePage.showExplain()
    end
end
ed.BigPackagePage.onRegisterFunction = onRegisterFunction

local function onExit()
    base.onExit()
    if bigpackage_ccb_container then
        bigpackage_ccb_container:removeFromParentAndCleanup(true)
        bigpackage_ccb_container = nil
    end
end
ed.BigPackagePage.onExit = onExit
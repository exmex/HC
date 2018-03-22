--Author : xinghui
local ActivityPage = {}
ed.activitys.ActivityPage = ActivityPage
ActivityPage.groupId = nil
ActivityPage.activityId = nil
ActivityPage.activityIds = {}
ed.activitys.activityBtnTree = {}
btnIndex = 1
local function onRegisterFunction(eventName,container)
    if eventName == "onClose" then
        ActivityPage.onClose()
    end
end
ActivityPage.onRegisterFunction = onRegisterFunction

local function onEnter(groupId, activityId)
    local activityCfgs = ed.getDataTable("activity/ActivityConfig")
    if ActivityPage.groupId and ActivityPage.activityId then
        if activityCfgs and activityCfgs[ActivityPage.groupId][ActivityPage.activityId] then
            activityCfgs[ActivityPage.groupId][ActivityPage.activityId].page.onExit()
        end
    end
    ActivityPage.groupId = groupId
    ActivityPage.activityId = activityId
end
ActivityPage.onEnter = onEnter

local function onExit()
end
ActivityPage.onExit = onExit


local function onClose()
    if ed.ccb_container then
        local activityCfgs = ed.getDataTable("activity/ActivityConfig")
        if ActivityPage.groupId and ActivityPage.activityId then
            if activityCfgs and activityCfgs[ActivityPage.groupId][ActivityPage.activityId] then
                activityCfgs[ActivityPage.groupId][ActivityPage.activityId].page.onExit()
            end
        end
        ActivityPage.groupId = nil
        ActivityPage.activityId = nil

        local parent = ed.ccb_container:getParent()
        if parent then
            parent:setTouchEnabled(true)
        end
        ed.ccb_container:setVisible(false)
        ed.ccb_container:retain()
        ed.ccb_container:removeAllChildrenWithCleanup(true)
        ed.ccb_container:removeFromParentAndCleanup(true)
    end
end
ActivityPage.onClose = onClose

--近期活动组按钮
function pairsByKeys(t)      
    local a = {}      
    for n in pairs(t) do          
        a[#a+1] = n      
    end      
    table.sort(a, ed.activitys.ActivitySort)      
    local i = 0      
    return function()          
    i = i + 1          
    return a[i], t[a[i]]      
    end  
end
--用来排序，按照这个froupid顺序显示activity tree
local ActivityGroupMap = {
    NearActivity = 1,
    OpenServerActivity = 2,
    ChristmasActivity = 3
}
ed.activitys.ActivityGroupMap = ActivityGroupMap

local function ActivitySort(a, b)
    if a._group_id and b._group_id then
        return ed.activitys.ActivityGroupMap[a._group_id]<ed.activitys.ActivityGroupMap[b._group_id]
    else
        return ed.activitys.ActivityGroupMap[a]<ed.activitys.ActivityGroupMap[b]
    end
end
ed.activitys.ActivitySort = ActivitySort

local function reCalaulatePositionOfActivityTree(btnName)
    local pos = ccp(0, 0)
    local posY = 0
    btnIndex = 1
    for i,v in pairsByKeys(ed.activitys.activityBtnTree) do
        for j,btn in ipairs(v) do
            if btnIndex == 1 then
                pos.x, pos.y = btn:getPosition()
            end
            if i == btnName then
                btn:setPosition(pos)
                btn:setVisible(true)
                pos.y = pos.y - btn:getContentSize().height + 0
            else
                if j == 1 then
                    btn:setPosition(pos)
                    btn:setVisible(true)
                    pos.y = pos.y - btn:getContentSize().height + 0
                else 
                    btn:setVisible(false)
                end
            end
            btnIndex = btnIndex + 1
        end
    end
end

ed.activitys.NearActivity = {}
local function onNearActivityBtn(eventName, container)
    if eventName == "onMainActivityBtn" then
        btnIndex = 1
        reCalaulatePositionOfActivityTree("NearActivity")
    end
end
ed.activitys.NearActivity.onRegisterFunction = onNearActivityBtn

ed.activitys.OpenServerActivity = {}
local function onOpenServerActivityBtn(eventName, container)
    if eventName == "onMainActivityBtn" then
        --btnIndex = 1
        reCalaulatePositionOfActivityTree("OpenServerActivity")
    end
end
ed.activitys.OpenServerActivity.onRegisterFunction = onOpenServerActivityBtn

ed.activitys.ChristmasActivity = {}
local function oChristmasActivityBtn(eventName, container)
    if eventName == "onMainActivityBtn" then
        --btnIndex = 1
        reCalaulatePositionOfActivityTree("ChristmasActivity")
    end
end
ed.activitys.ChristmasActivity.onRegisterFunction = oChristmasActivityBtn

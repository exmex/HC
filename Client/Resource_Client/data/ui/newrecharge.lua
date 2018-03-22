require "activity/ActiveRechargeRebate"
is_RechargeRebate = 0
newrecharge={}
newrechargevipcontent={}
newvipprivilegecontent={}
local goodInfos=nil
local width=0
local recharge_item
local function getItems(self)
  local items = {}
  local rt = ed.getDataTable("Recharge")
  for k, v in pairs(rt) do
    if type(k) == "number" and ed.player:checkRechargeItemValid(k) then
      local t = {
        id = v.ID,
        type = v.Type,
        order = v.Order,
        title = v["Display Name"],
        cost = v.Cost,
        get = v["Get Diamond"],
        tag = v.Recommended,
        des = v.Description,
        icon = v.Icon,
        limit = v.Limit
      }
      if t.type == "MonthlyCard" and ed.player:isMonthCardValid(t.id) then
        t.des = T(LSTR("RECHARGE.MONTH_CARD_IS_IN_EFFECT_THE_REMAINING_D_DAYS"), ed.player:getMonthCardLeftTimes(t.id))
      end
      table.insert(items, t)
    end
  end
  self.items = items
  self:orderItems()
  goodInfos = self.items
end
newrecharge.getItems = getItems

local orderItems = function(self)
  local list = self.items
  for i = 1, #list do
    for j = i, 2, -1 do
        if list[j].order < list[j - 1].order then
        local t = list[j]
        list[j] = list[j - 1]
        list[j - 1] = t      
      end
    end
  end
end
newrecharge.orderItems = orderItems

local function getKeys(self)
  if self.keys_pre and self.keys_mid and self.keys_post then
    return self.keys_pre, self.keys_mid, self.keys_post
  else
    local prv = ed.getDataTable("Privilege")
    local list_pre = {}
    local list_mid = {}
    local list_post = {}
    for k, v in pairs(prv) do
      if type(k) == "number" and v.Display then
        table.insert(list_pre, {
          id = k,
          key = v.Name,
          detail = v["Pre Display"]
        })
        table.insert(list_mid, {
          id = k,
          key = v.Name,
          detail = v["Mid Display"]
        })
        table.insert(list_post, {
          id = k,
          key = v.Name,
          detail = v["Post Display"]
        })
      end
    end
    for i = 1, #list_pre do
      for j = i, 2, -1 do
        if list_pre[j].id < list_pre[j - 1].id then
          local t = list_pre[j]
          list_pre[j] = list_pre[j - 1]
          list_pre[j - 1] = t
        end
      end
    end
    for i = 1, #list_mid do
      for j = i, 2, -1 do
        if list_mid[j].id < list_mid[j - 1].id then
          local t = list_mid[j]
          list_mid[j] = list_mid[j - 1]
          list_mid[j - 1] = t
        end
      end
    end
    for i = 1, #list_post do
      for j = i, 2, -1 do
        if list_post[j].id < list_post[j - 1].id then
          local t = list_post[j]
          list_post[j] = list_post[j - 1]
          list_post[j - 1] = t
        end
      end
    end
    self.keys_pre = list_pre
    self.keys_mid = list_mid
    self.keys_post = list_post
    return list_pre, list_mid, list_post
  end
end
newrecharge.getKeys = getKeys

local function getDetail(self,vip)
  local ks_pre, ks_mid, ks_post = self:getKeys()
  local vt = ed.getDataTable("VIP")
  local row = vt[vip]
  local prerow = vt[vip - 1]
  local details_pre = {}
  local details_mid = {}
  local details_post = {}
  for i = 1, #ks_pre do
    local k = ks_pre[i].key
    local d = ks_pre[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_pre, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_pre, d)
    end
  end
  for i = 1, #ks_mid do
    local k = ks_mid[i].key
    local d = ks_mid[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_mid, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_mid, string.format(d, v))
    end
  end
  for i = 1, #ks_post do
    local k = ks_post[i].key
    local d = ks_post[i].detail
    local v = row[k]
    local prev = (prerow or {})[k]
    if type(v) == "boolean" then
      if v and not prev then
        table.insert(details_post, d)
      end
    elseif type(v) == "number" and v > 0 and v ~= prev then
      table.insert(details_post, d)
    end
  end
  if vip > 1 then
    table.insert(details_pre, 2, LSTR("RECHARGE.INCLUDE"))
    table.insert(details_mid, 2, string.format("VIP%d", vip - 1))
    table.insert(details_post, 2, LSTR("RECHARGE.ALL_LEVEL_PRIVILEGES"))
  end
  return details_pre, details_mid, details_post
end
newrecharge.getDetail = getDetail

function onRegisterFunction(eventName,container)

	if eventName=="onClose" then
		local parent=newrecharge.container:getParent()
		if parent~=nil then
			newrecharge.container:retain()
			newrecharge.container:unregisterTouchDispatcherSelf()
			newrecharge.container:removeFromParentAndCleanup(true)
		end
	elseif eventName=="onPrivLegeBtn" then
		if newrecharge.pageFlag==1 then
			newrecharge.pageFlag=2
			newrecharge:setPageToShow()
		else
			newrecharge.pageFlag=1
			newrecharge:setPageToShow()
		end
	elseif eventName=="onLastBtn" then
		if newrecharge.curentPrivilegePage>1 then
			newrecharge.curentPrivilegePage=newrecharge.curentPrivilegePage-1
			newrecharge:setLeftRightButtonVisible(true)
		end
	elseif eventName=="onNextBtn" then
		if newrecharge.curentPrivilegePage<15 then
			newrecharge.curentPrivilegePage=newrecharge.curentPrivilegePage+1
			newrecharge:setLeftRightButtonVisible(true)
		end
	end
end
newrecharge.onRegisterFunction = onRegisterFunction

local function setPageToShow(self)
	local rechargeNode=self.container:getCCNodeFromCCB("mRechargeListNode")
	local vipPrivilegeNode=self.container:getCCNodeFromCCB("mVipInfomationNode")
	local btnLabel=self.container:getCCLabelTTFFromCCB("mBtnTex")
	if self.pageFlag==1 then
		rechargeNode:setVisible(true)
		vipPrivilegeNode:setVisible(false)
		btnLabel:setString(T(LSTR("RECHARGE.PRIVILEGE")))
	else
		rechargeNode:setVisible(false)
		vipPrivilegeNode:setVisible(true)
		btnLabel:setString(T(LSTR("RECHARGE.CHARGE")))
	end
end
newrecharge.setPageToShow=setPageToShow

local function onChargeRsp(self)
  local function handler(data)
    print("do onchargersp")
    if data._charge_id then
      print("onChargeRsp   ........." .. data._charge_id)
    end
    if data._serial_id then
      print("data._serial_id ............  " .. data._serial_id)
    end
    local goodInfo
    for i, v in ipairs(goodInfos) do
      if v.id == data._charge_id then
        goodInfo = v
        break
      end
    end
    if goodInfo == nil then
      return
    end
    if 3 == LegendSDKType then
      LegendBuyDiamond(1, goodInfo.title, goodInfo.cost, data._serial_id, string.format("%s:%d:%s", game_server_ip, data._charge_id, ed.getUserid()))
    end
    --刷新连续充值页面
	local msg = ed.upmsg.continue_pay()
	msg._continue_pay = 1
	ed.send(msg, "continue_pay")
	
    if 117 == LegendSDKType then
      local pInfo = {
        id = ed.getUserid(),
        userid = ed.getDeviceId(),
        extraData = data._serial_id,
        item = data._charge_id,
        serverid = game_server_id,
        gameName = LSTR("RECHARGE.TURRET_LEGEND"),
        currentCost = goodInfo.cost,
        item = goodInfo.id,
        itemName = goodInfo.title,
        cost = goodInfo.cost
      }
      LegendAndroidPurchase(ed.getJson(pInfo))
    end
	end
  return handler
end
newrecharge.onChargeRsp = onChargeRsp

function onRegisterFunction(eventName,container)
	if eventName=="onRechargeBtn" then
		local index=container.mIndex
		local info=newrecharge.items[index]
		if info.type == "MonthlyCard" then
			local id = info.id
			if not ed.player:canMonthCardRenew(id) then
			  ed.showToast(LSTR("RECHARGE.MONTH_CARD_CAN_BE_RENEWED_ONCE_THE_REMAINING_EFFECTIVE_TIME_IS_LESS_THEN_3_DAYS"))
			  return
			end
		end
		recharge_item = info
		CloseEvent("chargeRsp")
		ListenEvent("chargeRsp", newrecharge:onChargeRsp())
		local scene=CCDirector:sharedDirector():getRunningScene()
		if scene~=nil then
			scene:addChild(ed.ui.buyconfirm.create(info).mainLayer, 101001)
		end
	end
	
end
newrechargevipcontent.onRegisterFunction=onRegisterFunction

function onRegisterFunction(eventName,container)
	
end
newvipprivilegecontent.onRegisterFunction=onRegisterFunction

local onQueryRsp = function(self)
  local function handler(data)
    self:refreshBar()
  end
  return handler
end
newrecharge.onQueryRsp = onQueryRsp

local function addChargeItem(self)
	--首先获得数据
	self:getItems()
	local scrollview=self.container:getCCScrollViewFromCCB("mRechargeSV")
	local scrollviewContainer=scrollview:getContainer()
	local items = self.items
	local contentWidth=0
	local contentHeight=0
	for i = 1, #items do
		local itemContainer=ed.loadccbi(newrechargevipcontent,"ccbi/RechargeListContent.ccbi")
		itemContainer.mIndex=i
		local v = items[i]
		contentWidth=itemContainer:getContentSize().width
		contentHeight=itemContainer:getContentSize().height
		itemContainer:setPosition(ccp(contentWidth*(i-1),0))
		scrollviewContainer:addChild(itemContainer)
		--设置sprite的缩放
		local bgsprite=itemContainer:getCCSpriteFromCCB("mRechargeListBG")
		bgsprite:setScale(1.25)
		--icon
		local iconNode=itemContainer:getCCNodeFromCCB("mRechargePic")
		local icon = ed.createSprite(v.icon)
		icon:setPosition(ccp(0, 0))
		iconNode:addChild(icon)
		--下面奖励钻石的文字
		local bonusTex=itemContainer:getCCNodeFromCCB("mBottomTexNode")
		local des=nil
		if v.des then
		  des = ed.createLabelTTF(v.des, 15)
		  des:setAnchorPoint(ccp(0.5, 0.5))
		  ed.setLabelColor(des, ccc3(255, 255, 255))
		  des:setPosition(ccp(0, 0))
		  bonusTex:addChild(des)
		end
		--上面的文字
		local topNode=itemContainer:getCCNodeFromCCB("mTopTexNode")
		local title = ed.createLabelTTF(v.title, 17)
		title:setAnchorPoint(ccp(0.5, 0.5))
		title:setPosition(ccp(0, 0))
		if title:getContentSize().width > 135 then
		  title:setScale(135 / title:getContentSize().width)
		end
		ed.setLabelColor(title, ccc3(255,255,255))
		--ed.setLabelShadow(title, ccc3(0, 0, 0), ccp(0, 2))
		topNode:addChild(title)
		--下面的价格
		local costTextNode=itemContainer:getCCNodeFromCCB("mMoneyNode")
		local cost = ed.createLabelTTF(T(LSTR("RECHARGE.$_F"), v.cost), 17, nil, true)
		cost:setAnchorPoint(ccp(0.5, 0.5))
		cost:setPosition(ccp(0, 0))
		ed.setLabelColor(cost, ccc3(237, 235, 3))
		costTextNode:addChild(cost)
		--hot图片
		local hotSprite=itemContainer:getCCNodeFromCCB("mHotNode")
		if v.tag ==true then
		 hotSprite:setVisible(true)
		else
		 hotSprite:setVisible(false)
		end
	end
	scrollviewContainer:setContentSize(CCSizeMake((#items)*contentWidth,contentHeight))
	scrollview:setBounceable(true)
	local maxOffset=scrollview:getViewSize().width-scrollview:getContentSize().width*scrollview:getScaleX()
	scrollview:setContentOffset(ccp(maxOffset,0))
end
newrecharge.addChargeItem=addChargeItem
--action number类型，0表示不跑动画，-1表示向左跑动画，1表示向右跑动画
local function setLeftRightButtonVisible(self,isAction)
	local currentVipNumLabel=self.container:getCCLabelTTFFromCCB("mVipListLevel")
	currentVipNumLabel:setString(tostring(self.curentPrivilegePage))
	local leftVipnumLabel=self.container:getCCLabelTTFFromCCB("mLastVipTex")
	leftVipnumLabel:setString(tostring(self.curentPrivilegePage-1))
	local rightVipnumLabel=self.container:getCCLabelTTFFromCCB("mNextVipTex")
	rightVipnumLabel:setString(tostring(self.curentPrivilegePage+1))
	
	local leftNode=self.container:getCCNodeFromCCB("mLastInfoNode")
	local rightNode=self.container:getCCNodeFromCCB("mRightInfoNode")
	local now=self.curentPrivilegePage
	leftNode:setVisible(true)
	rightNode:setVisible(true)
	if now==1 then
		leftNode:setVisible(false)
	elseif now==15 then
		rightNode:setVisible(false)
	end
	local scrollview =self.container:getCCScrollViewFromCCB("mVipInfoSV")
	local scContainer=scrollview:getContainer()
	local offsetCount=self.curentPrivilegePage
	if isAction then
		local nowOffset=scrollview:getViewSize().width * (1 - offsetCount)
		--local m=CCMoveTo:create(0.2,ccp(nowOffset,0))
		--scContainer:runAction(m)
		scrollview:setContentOffsetInDuration(ccp(nowOffset,0), 0.2)
	end
end
newrecharge.setLeftRightButtonVisible=setLeftRightButtonVisible

local function initSecondView(self)
	local vip, ne, me = ed.player:getvip()
	newrecharge.curentPrivilegePage=vip
	if vip==0 then
		newrecharge.curentPrivilegePage=1
	end
	local priviLabel=self.container:getCCLabelTTFFromCCB("mVipListTex")
	priviLabel:setString(T(LSTR("RECHARGE.LEVEL_PRIVILEGES")))
	local leftViewLabel=self.container:getCCLabelTTFFromCCB("mLastViewTex")
	leftViewLabel:setString(T(LSTR("RECHARGE.VIEW")))
	local rightViewLabel=self.container:getCCLabelTTFFromCCB("mNextViewTex")
	rightViewLabel:setString(T(LSTR("RECHARGE.VIEW")))
	newrecharge:setLeftRightButtonVisible(false)

	--接下来是设置scrollview的了，设置内容和offset
	local scrollView = self.container:getCCScrollViewFromCCB('mVipInfoSV');
	scrollView:setDirection(kCCScrollViewDirectionHorizontal);
	local oriViewSize = scrollView:getViewSize();
	
	local size = 15;
	local width, height = oriViewSize.width, oriViewSize.height;
	local svHeight = height;
	for i = 1, size do
		local details_pre, details_mid, details_post = self:getDetail(i);
		local textTb = {};
		for j = 1, #details_pre do
			local text = string.format("<font color='#EFC579'>%s</font><font color='#FFFFFF'>%s</font><font color='#EFC579'>%s</font><br/>"
				, details_pre[j], details_mid[j], details_post[j]);
			table.insert(textTb, text);
		end
		local detaols = '<p style="margin: 20px">' .. table.concat(textTb) .. '</p>';
		
		local txtScrollView = CCScrollView:create();
		txtScrollView:setViewSize(oriViewSize);
		txtScrollView:setDirection(kCCScrollViewDirectionVertical);
		
		local label = ed.createNode({
			t = "HtmlLabel",
			base = {
				name = "vipPrivilege",
				text = detaols or "",
				size = oriViewSize
			},
			layout = {
				size = 18,
				anchor = ccp(0, 0),
				position = ccp(0, 0)
			}
		}	
		, txtScrollView);
		local labelHeight = label:getContentSize().height;
		
		txtScrollView:setContentSize(CCSizeMake(width, labelHeight));
		txtScrollView:setContentOffset(ccp(0, height - labelHeight));	
		
		txtScrollView:setPosition(ccp((i - 1) * width, 0));
		scrollView:addChild(txtScrollView);
		
		svHeight = math.max(height, labelHeight);		
	end
	
	scrollView:setContentSize(CCSizeMake(size * width, svHeight));
	scrollView:setContentOffset(ccp(width * (1 - newrecharge.curentPrivilegePage), 0));
	
	--[==[
	local scrollview =self.container:getCCScrollViewFromCCB("mVipInfoSV")
	local scContainer=scrollview:getContainer()
	local height=0
	local index = 0
	for i=1,15 do
		local oh = 0
		local details_pre, details_mid, details_post = self:getDetail(i)
		local container = ed.loadccbi(newvipprivilegecontent,"ccbi/RechargeVipInfoContent.ccbi")
		container:setScale(1.25)
		scContainer:addChild(container)
		width=container:getContentSize().width
		height=container:getContentSize().height
		local ox, oy = 50, 255
		--local dy = 25
		local icon_len = 80
		oy = oy - oh
		local sumbefore = {}
		local detaols = ""
		local html = '<p style="margin: 10px">'
		local htmlend = "</p>"
		for i = 1, #details_pre do
			index = i
			--[[local label = ed.createLabelTTF(details_pre[i]..details_mid[i]..details_post[i], 18)
			label:setAnchorPoint(ccp(0, 0.5))
			label:setPosition(ccp(ox, oy - dy * (i - 1)))
			ed.setLabelColor(label, ccc3(239, 197, 121))
			container:addChild(label)
			sumbefore[i] = label:getContentSize().width--]]
			detaols = detaols ..  "<font color='#EFC579'>"..details_pre[i].."</font>".."<font color='#FFFFFF'>"..details_mid[i].."</font><font color='#EFC579'>"..details_post[i] .. "</font><br/>"	
		end
		detaols = html..detaols..htmlend
		local content = ed.createNode({
				t = "HtmlLabel",
				base = {
				  name = "htmlLabelTest",
				  file = "html/html.htm",
				  text = detaols or "",--details_pre[i]..a..details_post[i] or "",	
				  size = CCSize(495, 255)
				},
				layout = {
				  size = 18,
				  anchor = ccp(0, 1),
				  position = ccp(50, 255)
				}
			}	
			, container)
		--[[for i = 1, #details_mid do
			local label = ed.createLabelTTF(details_mid[i], 18)
			label:setAnchorPoint(ccp(0, 0.5))
			label:setPosition(ccp(ox + sumbefore[i] + 3, oy - dy * (i - 1)))
			ed.setLabelColor(label, ccc3(255, 241, 215))
			ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
			container:addChild(label)
			sumbefore[i] = sumbefore[i] + label:getContentSize().width
		end
		for i = 1, #details_post do
			local label = ed.createLabelTTF(details_post[i], 18)
			label:setAnchorPoint(ccp(0, 0.5))
			label:setPosition(ccp(ox + sumbefore[i] + 6, oy - dy * (i - 1)))
			ed.setLabelColor(label, ccc3(239, 197, 121))
			ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
			container:addChild(label)
			sumbefore[i] = sumbefore[i] + label:getContentSize().width
		end--]]
		
		container:setPosition(ccp((i-1)*width,0))
	end
	scContainer:setContentSize(CCSizeMake(width,height+65))
	scrollview:setBounceable(true)
	--初始化完成，设置偏移
	local offsetCount=1
	if vip==0 then
		offsetCount=1
	else
		offsetCount=vip
	end
	local maxOffset=scrollview:getViewSize().height-scrollview:getContentSize().height*scrollview:getScaleY()
	local nowOffset=scrollview:getViewSize().height-(scrollview:getContentSize().height-(index-1)*height)*scrollview:getScaleY()
	if nowOffset>=0 then
		nowOffset=0
	end
	if maxOffset<nowOffset then
		scrollview:setContentOffset(ccp(0,nowOffset))
	else
		scrollview:setContentOffset(ccp(0,maxOffset))
	end
	--local nowOffset=scrollview:getViewSize().height-offsetCount*height*scrollview:getScaleX()
	--scrollview:setContentOffset(ccp(nowOffset,0))
	scrollview:setDirection(kCCScrollViewDirectionVertical)
	scrollview:setTouchEnabled(true)
	
	--]==]
end
newrecharge.initSecondView=initSecondView

local function refreshBar(self)
	local container=self.container
	--设置顶部的文字
	local vip, ne, me = ed.player:getvip()
	local currentVIPLevel=container:getCCLabelTTFFromCCB("mVipTex")
	currentVIPLevel:setString(vip.."")
	--进度条上面的文字
	local progressLabel=container:getCCLabelTTFFromCCB("mExpNum")
	progressLabel:setString(tostring(me-ne).."/"..tostring(me))
	--进度条的进度
	local progressBar=container:getCCScale9SpriteFromCCB("mExp")
	progressBar:setScaleX((me-ne)/me*1.0)
	--后面的文字
	local needvipLabel=container:getCCLabelTTFFromCCB("mVipLvNum")
	local nextVipLevelLabel=container:getCCLabelTTFFromCCB("mNextVipTex")
	needvipLabel:setString(vip.."")
	nextVipLevelLabel:setString(tostring(vip+1))
	local vipNode=container:getCCNodeFromCCB("mNextVipInfoNode")
	if vip==15 then
		vipNode:setVisible(false)
	else
		vipNode:setVisible(true)
	end
	
end
newrecharge.refreshBar=refreshBar


local create=function()
	local container = ed.loadccbi(newrecharge,"ccbi/RechargePage.ccbi")
	newrecharge.container = container
	--container:registerScriptTouchHandler(newrecharge:doMainLayerTouch(), false, -190, true)
	--CCDirector:sharedDirector():getTouchDispatcher():addTargetedDelegate(container, -190, true)
	container:registerTouchDispatcherSelf()
	--初始化一些控件，对一些控件进行缩放
	local bg=container:getCCSpriteFromCCB("mRechargePageBG")
	bg:setScale(1.25)
	newrecharge.pageFlag=1
	newrecharge:setPageToShow()
	--设置顶部的文字
	local vip, ne, me = ed.player:getvip()
	local currentVIPLevel=container:getCCLabelTTFFromCCB("mVipTex")
	currentVIPLevel:setString(vip.."")
	--进度条上面的文字
	local progressLabel=container:getCCLabelTTFFromCCB("mExpNum")
	progressLabel:setString(tostring(me-ne).."/"..tostring(me))
	--进度条的进度
	local progressBar=container:getCCScale9SpriteFromCCB("mExp")
	progressBar:setScaleX((me-ne)/me*1.0)
	--后面的文字
	local needLabel=container:getCCLabelTTFFromCCB("mExpInfoTex1")
	local needvipLabel=container:getCCLabelTTFFromCCB("mVipLvNum")
	local languagePointLabel=container:getCCLabelTTFFromCCB("mExpInfoTex2")
	local nextVipLevelLabel=container:getCCLabelTTFFromCCB("mNextVipTex")
	needLabel:setString(T(LSTR("RECHARGE.CHARGE_ANOTHER")))
	languagePointLabel:setString(T(LSTR("RECHARGE.CAN_BECOME")))
	needvipLabel:setString(vip.."")
	nextVipLevelLabel:setString(tostring(vip+1))
	local vipNode=container:getCCNodeFromCCB("mNextVipInfoNode")
	if vip==15 then
		vipNode:setVisible(false)
	else
		vipNode:setVisible(true)
	end
	CloseEvent("QueryDataRsp")
	ListenEvent("QueryDataRsp", newrecharge:onQueryRsp())
	--底下文字
	local bottomText=container:getCCLabelTTFFromCCB("mFirstRechargeTex")
	bottomText:setString(T(LSTR("NEWRECHARGE.BOTTOMTEXT")))
	--加载充值内容
	newrecharge:addChargeItem()
	--
	newrecharge:initSecondView()
	return container
end
newrecharge.create = create

local function reqRmbData()
  local msg = ed.upmsg.query_data()
  msg._type = {
    "rmb",
    "recharge",
    "monthcard"
  }
  if recharge_item ~= nil and recharge_item.type == "MonthlyCard" then
    msg._month_card_id = {
      recharge_item.id
  }
  end
  ed.send(msg, "query_data")
end

local function onPayResult(sucess)
  reqRmbData()
  if rechargeRebateID == 1 then
	is_RechargeRebate = 1
	ed.ActiveRechargeRebatePage.create()
  end
end
ListenEvent("91PayResult", onPayResult)
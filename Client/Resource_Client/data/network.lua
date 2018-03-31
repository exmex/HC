local ed = ed
require("lua_socket")
require("config")
require("mycrypto")
local connect = socket.connect
local connection
local connect_succ = false
local close
local bSendblock = false
local currentMsg, currentMsgType
local up = pb_loader("up")()
local down = pb_loader("down")()
local upmsg = up.up_msg
local downmsg = down.down_msg
local insert = table.insert
local ipairs = ipairs
local tostring = tostring;
local logSaveId = 0
local logString
local up_code
ed.upmsg = up
ed.downmsg = down
ed.isDebug = true

local cryptkey = "0"
local user_id = 0
local puid = '';
local device_id = ed.config.uin or LegendGetDeviceID()
local sessionKey = nil;

local accessToken, rechargeURL
local function getAccessToken()
	return accessToken
end
ed.getAccessToken = getAccessToken

local function getRechargeURL()
	return rechargeURL
end
ed.getRechargeURL = getRechargeURL

local function setDeviceId(id)
	device_id = id
end
ed.setDeviceId = setDeviceId

local function getDeviceId()
	return device_id
end
ed.getDeviceId = getDeviceId

local function setCryptKey(key)
	cryptkey = string.sub(key, 1, 16)
end
ed.setCryptKey = setCryptKey

local function getUserid()
	return user_id
end
ed.getUserid = getUserid
local function setUserid(id)
	user_id = id
end
ed.setUserid = setUserid

local function getPuid()
	return puid
end
ed.getPuid = getPuid
local function setPuid(id)
	puid = id
end
ed.setPuid = setPuid

local function getSessionKey()
	if ed.sessionKey == nil then
		--ed.sessionKey = tostring(os.time());
        ed.sessionKey = "3333333333"
	end
	return ed.sessionKey;
end
ed.getSessionKey = getSessionKey;

local function setSessionKey(key)
	ed.sessionKey = tostring(key);
end
ed.setSessionKey = setSessionKey;

device_id = device_id or "visitor"
local configData = {}
local replyHandler = {}
ed.netdata = configData
ed.netreply = replyHandler
local loadLayer = {}
local loadFunc = {}
local doTouchLoad = function()
	return true
end

local isLoginFirst = true
local pingTimerId = nil
local lastHeartBeatTime = 0
local lostConnectInterval = 120
local loginProxyData = "0x1D 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x02 0x00 0x00 0x00 0x32 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00"
local pingProxyData = "0x0E 0x00 0x00 0x00 0x22 0x00 0x00 0x00 0x02 0x00 0x00 0x00 0x30 0x00"
local pongProxyData = "0x0E 0x00 0x00 0x00 0x2E 0x00 0x00 0x00 0x02 0x00 0x00 0x00 0x30 0x00"

function doLoginProxy()
	if not connection then
		return false
	end
	if isLoginFirst then
		isLoginFirst = false

		local userId = ed.getUserid()
		local serverId = game_server_id
		sz = XPACKET_DoLogin:_Size(userId, serverId, "", "")
		buf = string.rep("a", sz)
		ret = XPACKET_DoLogin:_ToBuffer(buf, sz, userId, serverId, "", "")

		--local loginCode = typeStringToBuffer(loginProxyData)
		local r1, r2 = connection:send(buf)
		if not r1 then
			ed.showToast(T(LSTR("NETWORK.SENDING_FAILED_PLEASE_CHECK_THE_NETWORK_SETTING")))
			close()
			return false
		end

		if not pingTimerId then
			pingTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(doPingProxy, 60, false)
		end
	end
	return true
end

function doPingProxy()
	if not connection then
		return
	end

	local nowTime = ed.getSystemTime()
	LegendLog("[network.lua|doPingProxy]  doPingProxy : " .. nowTime)
	local passTime = nowTime - lastHeartBeatTime
	if (passTime >= lostConnectInterval) then
		close()
		return
	end

	nowTime = nowTime * 1000
	sz = XPACKET_SendPing:_Size(nowTime);
	buf = string.rep("a", sz);
	ret = XPACKET_SendPing:_ToBuffer(buf, sz, nowTime);
	LegendLog(print_bytes(buf))

	local r1, r2 = connection:send(buf)
	if not r1 then
		ed.showToast(T(LSTR("NETWORK.SENDING_FAILED_PLEASE_CHECK_THE_NETWORK_SETTING")))
		close()
	end
end

local function load(noflower, bReSend)
	local count = 0
	local countRotate = 0
	local count_gap = 0.1
	local resend = true
	if bReSend ~= nil then
		resend = bReSend
	end
	local isLoading
	local function createFlower(scene)
		if not tolua.isnull(loadLayer.layer) then
			return
		end
		local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
		layer:setTouchEnabled(true)
		layer:registerScriptTouchHandler(doTouchLoad, false, -240, true)
		scene:addChild(layer, 600)
		loadLayer.layer = layer
		if not tolua.isnull(loadLayer.flower) then
			return true
		end
		local flower = ed.createSprite("installer/load_flower.png")
		layer:addChild(flower, 10)
		flower:setPosition(ccp(328, 240))
		loadLayer.flower = flower
		local text = ed.createttf(T(LSTR("NETWORK.CONNECTING")), 20)
		layer:addChild(text, 10)
		text:setPosition(ccp(408, 240))
		local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(15, 20, 45, 15))
		layer:addChild(bg, 9)
		bg:setPosition(ccp(393, 238))
		bg:setContentSize(CCSizeMake(180, 60))
	end
	local function handler(dt)
		dt = dt or 0
		count = count + dt
		countRotate = countRotate + dt
		if count > 16 and resend then
			loadFunc.loadEnd()
			close()
			FireEvent("SendMsgFail")
		end
		if noflower then
			return
		end
		local scene = CCDirector:sharedDirector():getRunningScene()
		if isLoading and tolua.isnull(loadLayer.layer) then
			return
		end
		if count > 1.0 then
			createFlower(scene)
			isLoading = true
		end
		if countRotate > count_gap then
			local flower = loadLayer.flower
			if not tolua.isnull(flower) then
				flower:setRotation((flower:getRotation() + 30) % 360)
			end
			countRotate = countRotate - count_gap
		end
	end
	return handler
end

local function loadBegin(noflower, bReSend)
	loadFunc.loadEnd()
	if not loadLayer.id then
		local loading = load(noflower, bReSend)
		local scene = CCDirector:sharedDirector():getRunningScene()
		if not tolua.isnull(scene) then
			loadLayer.scheduler = scene:getScheduler()
			loadLayer.id = loadLayer.scheduler:scheduleScriptFunc(loading, 0, false)
		end
	end
end
loadFunc.loadBegin = loadBegin
ed.loadBegin = loadBegin

local function loadEnd()
	if loadLayer.id then
		loadLayer.scheduler:unscheduleScriptEntry(loadLayer.id)
		loadLayer.id = nil
	end
	if not tolua.isnull(loadLayer.layer) then
		loadLayer.layer:removeFromParentAndCleanup(true)
	end
	loadLayer = {}
end
loadFunc.loadEnd = loadEnd
ed.loadEnd = loadEnd

local function pack_size(code, ttype)
	local device = puid --device_id
	--if not EDFLAGWIN32 and not EDFLAGWP8 then
	-- device = string.format("%d-%s", LegendSDKType, device_id)
	--end
	local device_len = string.len(device)
	local third = string.char(device_len % 256)
	local fourth = string.char(math.floor(device_len / 256))
	local mode = 0
	if ttype == "login" then
		mode = 1
	end
	local length = #code + device_len + 2 + 1
	local second = string.char(length % 256)
	local first = string.char(math.floor(length / 256))

	device_len = string.len(device)
	third = string.char(device_len % 256)
	fourth = string.char(math.floor(device_len / 256))

	local pkglength = #code + 12 + 3 + device_len
	local reservedLength = 35 -- OnProtoBuff ID
	local dataSize = #code +3 + device_len
	return int_to_bytes(pkglength, nil, "signed") .. int_to_bytes(reservedLength, nil, "signed") .. int_to_bytes(dataSize, nil, "signed").. string.char(mode) .. third .. fourth .. device.. code
end

function close()
	LegendLog("[network.lua|close]  close socket")
	if connection then
		connection:close()
	end
	isLoginFirst = true
	connection = nil
	connect_succ = false
	up_code = nil
end
ed.closeConnect = close

local function connect(block)
	--LegendLog("function connect call \n" .. debug.traceback())
	local err
	if not connection then
		connection, err = socket.tcp()
		if not connection then
			LegendLog(string.format("[network.lua|connect] ERROR | Connect failed when creating socket | %s", err))
			return false
		end
	end

	local err
	if not connect_succ then
		connection:settimeout(block and 5 or 0)
		connect_succ, err = connection:connect(game_server_ip, game_server_port)
	end

	if not ed.isElementInTable(currentMsgType, {
		"suspend_report"
	})
	then
		local notShowFlower = true
		if not ed.isElementInTable(currentMsgType, {
			"reset_elite",
			"query_data"
		})
		then
			notShowFlower = nil
		end
		loadBegin(notShowFlower)
	end

	if connect_succ then
		LegendLog("[netword.lua|connect] connect succ")
		connection:settimeout(0)
		local proxyLogin = doLoginProxy()
		if not proxyLogin then
			return false
		end
		local r1, r2 = connection:send(up_code)
		if r1 then
			LegendLog("[network.lua|connect]  Message Sent  @ " .. ed.getYMDTime())
		else
			LegendLog(string.format("[network.lua|connect]  ERROR | connection:send failed | %s", r2))
			close()
		end
		--close()
	elseif block then
		LegendLog(string.format("[network.lua|connect]  ERROR | Blocked Connect failed | %s", err))
		return false
	else
		LegendLog("[netword.lua|connect] connect start")
		return true
	end
end

local function connect_resume()
	if connect_succ or not connection then
		return
	end
	local r, w, e = socket.select({connection}, {connection}, 0.02)
	if not w or e == "timeout" then
		return
	end
	local ret, errstr = connection:connect(game_server_ip, game_server_port)
	if errstr ~= "already connected" then
		return
	end
	connect_succ = true
	LegendLog("[netword.lua|connect_resume]   connect_resume succ")
	--重连成功
	reConnectTimes=0
	local proxyLogin = doLoginProxy()
	if not proxyLogin then
		return false
	end
	local r1, r2 = connection:send(up_code)
	if not r1 then
		ed.showToast(T(LSTR("NETWORK.SENDING_FAILED_PLEASE_CHECK_THE_NETWORK_SETTING")))
		close()
		return
	end
	LegendLog("[netword.lua|connect_resume]   Message Sent  @ " .. ed.getYMDTime())
end

local sendCache = {}
local deleteCache = {}
local function delaySend(obj, ttype, deleteOnSent)
	LegendLog("[netword.lua|delaySend]   Delay send msg: " .. ttype)
	sendCache[ttype] = obj
	if deleteOnSent then
		deleteCache[ttype] = obj
	end
end
ed.delaySend = delaySend

local function doSend(block, ttype)
	if nil == currentMsg then
		return false
	end
	local code, err = currentMsg:Serialize()

	local cipher_code
	if code then
		cipher_code = mycrypto.encrypt(code, cryptkey)
	else
		EDDebug(err)
	end

	up_code = pack_size(cipher_code, ttype)
	LegendLog("============Send Msg Key: "..cryptkey)
	LegendLog("[netword.lua|doSend]   Msg Type: "..ttype)
	LegendLog(print_bytes(code))
	LegendLog("encrypt data============")
	LegendLog(print_bytes(up_code))
	print_Log(up_code,"packets/" .. tostring(logSaveId)..ttype)

	logSaveId = logSaveId+1

	local r = false
	if block then
		r = connect(block)
	else
		r = connect()
		if not r then
			return r
		end
	end
	return true
end

local function reSend()
	if nil == currentMsg then
		return
	end
	currentMsg._repeat = 1
	doSend(bSendblock, currentMsgType)
end

local send_time_record = {}
local function checkSendIllegal()
	local gap = 15
	local frequency = 10
	local nt = ed.getSystemTime()
	if frequency > #send_time_record then
		table.insert(send_time_record, nt)
		return true
	else
		local t = send_time_record[1]
		if gap < nt - t then
			table.remove(send_time_record, 1)
			table.insert(send_time_record, nt)
			return true
		else
			return false
		end
	end
	return true
end

local function send(obj, ttype, block)
	-- if connection then
	--   return false
	-- end
	LegendLog("[netword.lua|doSend] Sending msg: " .. ttype)
	LegendLog(var_dump(obj));
	LegendLog("<<<<<<<<<<<<<<<<<<<<<<<<<<");

	currentMsg = nil
	currentMsg = upmsg()
	currentMsg._repeat = 0
	currentMsg._user_id = user_id

	local sdkInfo = ed.upmsg.sdk_login()
	sdkInfo._session_key = ed.getSessionKey();--SeverConsts:getInstance():getBaseVersion()
	sdkInfo._plat_id = 0
	if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
		sdkInfo._plat_id = 1
	elseif LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
		sdkInfo._plat_id = 2
	end
	currentMsg._sdk_login = sdkInfo

	currentMsg["_" .. ttype] = obj
	bSendblock = block or false
	currentMsgType = ttype
	for k, v in pairs(sendCache or {}) do
		currentMsg["_" .. k] = v
		if deleteCache[k] then
			sendCache[k] = nil
			deleteCache[k] = nil
		end
	end
	return doSend(block, ttype)
end
ed.send = send

local function recv_buffer(size_left, buffer)
	if size_left <= 0 then
		return buffer
	end
	local content, err, partial = connection:receive(size_left)
	if err == "closed" then
		LegendLog("[netword.lua|recv_buffer]  socket closed")
		close()
		return nil
	elseif err == "timeout" then
		buffer = buffer .. partial
		return recv_buffer(size_left - #partial, buffer)
	else
		buffer = buffer .. content
		return recv_buffer(size_left - #content, buffer)
	end
end

local function recv_remain(proto_head_str)
	--[[for i = 1, 12 do
	LegendLog("    recv_remain " .. string.byte(proto_head_str, i))
	end
	--]]
	local remainLen1 = tonumber(string.byte(proto_head_str, 1))
	local remainLen2 = tonumber(string.byte(proto_head_str, 2))
	local remainLen3 = tonumber(string.byte(proto_head_str, 3))
	local remainLen4 = tonumber(string.byte(proto_head_str, 4))

	local allRemainlen = remainLen1 + remainLen2 * 256 + remainLen3 * 65536 + remainLen4 * 16777216 - 8

	local buffer, err = connection:receive(allRemainlen)
	LegendLog("    recv_remain " .. buffer)
end

local function kickOutProcess()
	local text = T(LSTR("KICKOUT.NOTICE"))
	local info = {
		--text = text .. ":" .. cryptkey,
		text = text,
		buttonText = T(LSTR("ERRORNET.RETRY")),
		handler = function()
			xpcall(function()
				LegendRestartApplication()
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function reloadProcess()
	local text = T(LSTR("RELOAD.NOTICE"))
	local info = {
		text = text,
		buttonText = T(LSTR("RELOAD.BUTTON")),
		handler = function()
			xpcall(function()
				LegendRestartApplication()
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function grayServerProcess()
	local text = SeverConsts:getInstance():getServerInGrayMsg();
	local info = {
		text = text,
		buttonText = T(LSTR("SERVERLOGIN.SELECT.SERVER.OK")),
		handler = function()
			xpcall(function()
				ed.replaceScene(ed.ui.serverlogin.create());
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function loginErrorProcess()
	local text = Language:getInstance():getString("@LOGIN_PLAYER_DATA_ERROR");
	local info = {
		text = text,
		buttonText = T(LSTR("SERVERLOGIN.SELECT.SERVER.OK")),
		handler = function()
			xpcall(function()
				ed.replaceScene(ed.ui.serverlogin.create());
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function fullServerProcess()
	local text = Language:getInstance():getString("@ServerIsFull");
	local info = {
		text = text,
		buttonText = T(LSTR("SERVERLOGIN.SELECT.SERVER.OK")),
		handler = function()
			xpcall(function()
				ed.replaceScene(ed.ui.serverlogin.create());
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function serverInUpdate()
	local text = SeverConsts:getInstance():getServerInUpdateMsg()
	local info = {
		text = text,
		buttonText = T(LSTR("SERVERLOGIN.SELECT.SERVER.OK")),
		handler = function()
			xpcall(function()
				reSend()
			end, EDDebug)
		end
	}
	ed.showAlertDialog(info)
end

local function recv()
	if not connection then
		return
	end

	local proto_head_str, err = connection:receive(8)
	if not proto_head_str then
		return
	end

	-- record latest heart beat time
	lastHeartBeatTime = ed.getSystemTime()

	-- get protocol head (4 total len + 4 cmd id)
	local commandId = tonumber(string.byte(proto_head_str, 5))
	if (commandId == 1) then
		LegendLog("[netword.lua|recv]   proxy timeout close : " .. lastHeartBeatTime)
		close()
		return
	elseif (commandId == 46) then
		LegendLog("[netword.lua|recv]   onPongProxy : " .. lastHeartBeatTime)
		recv_remain(proto_head_str)
		return
	elseif (commandId ~= 47) then
		LegendLog("[netword.lua|recv]   other message : " .. lastHeartBeatTime)
		recv_remain(proto_head_str)
		return
	end

	-- get error code
	local errorStr, err = connection:receive(4)
	if not errorStr then
		return
	end
	local errorCode = tonumber(string.byte(errorStr, 1))
	if errorCode ~= 0 then
		close()
		if errorCode == 3 then
			reloadProcess()
		elseif errorCode == 4 then
			grayServerProcess();
		elseif errorCode == 5 then
			loginErrorProcess();
		elseif errorCode == 6 then
			fullServerProcess();
		else
			kickOutProcess()
		end
		return
	end

	-- get protobuf len
	local protobufLen, err = connection:receive(4)
	if not protobufLen then
		return
	end

	local protoLen1 = tonumber(string.byte(protobufLen, 1))
	local protoLen2 = tonumber(string.byte(protobufLen, 2))
	local protoLen3 = tonumber(string.byte(protobufLen, 3))
	local protoLen4 = tonumber(string.byte(protobufLen, 4))

	local buffer_size = protoLen1 + protoLen2 * 256 + protoLen3 * 65536 + protoLen4 * 16777216
	local buffer = recv_buffer(buffer_size, "")

	--close()

	if buffer then
		LegendLog("[netword.lua|recv]  Data Received @ " .. ed.getYMDTime())
		loadEnd()
		local plaincode = mycrypto.decrypt(buffer, cryptkey)

		logString = plaincode

		LegendLog("Msg Data Received Begin============")
		LegendLog(print_bytes(buffer))
		LegendLog("=====")
		LegendLog(print_bytes(plaincode))
		LegendLog("Msg Data Received End============")

		local msg, err = downmsg():Parse(plaincode)
		if msg then
			LegendLog(var_dump(msg));
			LegendLog("++++++++++++++++++");
			ed.dispatch(msg)
		else
			LegendLog("[netword.lua|recv] ERROR | Decode message failed | " .. err)
			EDDebug()
		end
	end
end

local function proc_net()
	connect_resume()
	recv()
end
ed.proc_net = proc_net

local function registerNetReply(key, handler, data)
	ed.netreply[key] = handler
	ed.netdata[key] = data
end
ed.registerNetReply = registerNetReply

local function dealNetReply(key, result, addition)
	local reply = ed.netreply[key]
	local data = ed.netdata[key] or {}
	data.netResult = result
	data.netAddition = addition
	if reply then
		reply(data)
	end
	ed.netreply[key] = nil
	ed.netdata[key] = nil
end
ed.dealNetReply = dealNetReply

local function getNetReply(key)
	if not key then
		print("getNetReply : no key , no return")
		return
	end
	local handler = ed.netreply[key]
	local data = ed.netdata[key]
	ed.netreply[key] = nil
	ed.netdata[key] = nil
	return handler, data
end
ed.getNetReply = getNetReply

local function dispatch(msg)
	local msgName = ""
	for k, v in pairs(msg[".data"]) do
		LegendLog("[netword.lua|dispatch]  down msg: " .. k)
		msgName = msgName..k
		--print_Log("Down Msg: "..k.." ")
	end

	--print_Log(logString,tostring(logSaveId)..msgName)
	--logSaveId = logSaveId+1
	logString = ""

	if msg._login_reply then
		
		if msg._login_reply._result == "fail" then
			FireEvent("LoginFail")
			return
		end
		ed.serverTimeZone = tonumber(msg._login_reply._time_zone)
		local userId = ed.getUserid()
		local firstLogin = CCUserDefault:sharedUserDefault():getStringForKey(userId)
		if firstLogin == "" and userId ~= "" then
			CCUserDefault:sharedUserDefault():setStringForKey(userId, "no")
		end
		local user = msg._login_reply._user
		user_id = user._userid
		if user._praise ~= "" then -- url 地址
			apprIsVisiable = true
			praise_url = user._praise
		else
			apprIsVisiable = false
		end
		if user._facebook_follow == 0 then --0是未关注 1 是关注
			fb_flag = true
		else
			fb_flag=false
		end
		if user._sessionid and user._sessionid > 0 then
			ed.setSessionKey(user._sessionid);
		end
		ed.player:setup(user)
		ed.setUserid(user_id);
		if ed.netreply.loginReply then
			ed.netreply.loginReply()
			ed.netreply.loginReply = nil
		end
		FireEvent("LoginSuc")
		checkLanguageUpdate()
	end
	if msg._system_setting_reply then
		FireEvent("SystemSettingReply", msg._system_setting_reply)
	end
	if msg._reset then
		LegendLog("[netword.lua|dispatch] Client data reset by server!")
		if ed.debug_mode then
		end
		local user = msg._reset._user
		user_id = user._userid
		ed.player:setup(user)
	end
	if msg._svr_time then
		local reply = msg._svr_time
		ed.player:initNativeTimeDiff(reply)
		local handler = ed.netreply.syncTime
		if handler then
			handler()
			ed.netreply.syncTime = nil
		end
	end
	if msg._enter_stage_reply then
		if ed.netreply.enterStage then
			ed.netreply.enterStage()
			ed.netreply.enterStage = nil
		end
		ed.srand(msg._enter_stage_reply._rseed)
		ed.player.loots = msg._enter_stage_reply._loots or {}
	end
	if msg._exit_stage_reply then
		local reply = msg._exit_stage_reply
		local shop = reply._shop
		local sshop = reply._sshop
		local result = reply._result == "known"
		if shop then
			local state
			if shop._id > 1 then
				state = "trigger"
			end
			ed.player:refreshShopData(shop, state)
		end
		if sshop then
			ed.player:refreshStarShopData(sshop, "trigger")
		end
		local data = ed.netdata.exitStageReply
		if data then
			local stage = data.stage
			local r = data.result
			if result then
				ed.record:chaosFarmStage(stage)
				if r == 0 then
					ed.record:successFarmStage(stage)
				end
			end
			ed.netdata.exitStageReply = nil
		end
		if ed.netreply.exitStageReply then
			ed.netreply.exitStageReply(result)
			ed.netreply.exitStageReply = nil
		end
	end
	if msg._consume_item_reply then
		local reply = msg._consume_item_reply
		local hero = reply._hero
		local handler, data = ed.getNetReply("eat_exp")
		if data then
			ed.player:consumeEquip(data.id, data.amount)
			ed.player:resetHero(hero)
		end
		if handler then
			handler()
		end
	end
	if msg._equip_synthesis_reply then
		local reply = msg._equip_synthesis_reply
		local result = reply._result == "success"
		local data = ed.netdata.equipCraft
		if result then
			ed.player:addMoney(-data.expense)
			local na = data.consume
			for k, v in pairs(data.node) do
				ed.player:consumeEquip(v, na[k] or 1)
			end
			ed.player:addEquip(data.id)
		end
		if ed.netreply.craftReply then
			ed.netreply.craftReply(result)
			ed.netreply.craftReply = nil
		end
	end
	if msg._wear_equip_reply then
		local reply = msg._wear_equip_reply
		local result = reply._result == "success"
		local gs = reply._gs
		if ed.netdata.putonReply then
			local data = ed.netdata.putonReply
			local hid = data.hid
			local sid = data.sid
			local eid = data.eid
			ed.player:consumeEquip(eid, 1)
			ed.player.heroes[hid]:equip(sid)
			ed.player.heroes[hid]:resetgs(gs)
			ed.netdata.putonReply = nil
		end
		if ed.netreply.putonReply then
			ed.netreply.putonReply(result)
			ed.netreply.putonReply = nil
		end
	end
	if msg._shop_refresh_reply then
		ed.ui.market.dealRefresh(msg._shop_refresh_reply)
	end
	if msg._shop_consume_reply then
		ed.ui.market.dealConsume(msg._shop_consume_reply)
	end
	if msg._sell_item_reply then
		local reply = msg._sell_item_reply
		local result = reply._result
		local handler, data = ed.getNetReply("sell_item")
		if result and data then
			ed.player._money = ed.player._money + data.income
			for k, v in pairs(data.items) do
				local id = v.id
				local amount = v.amount
				ed.player:consumeEquip(id, amount)
			end
		end
		if handler and data then
			handler(result, data.amount)
		end
	end
	if msg._fragment_compose_reply then
		local reply = msg._fragment_compose_reply
		local result = reply._result == "success"
		local info = ed.netdata.fragmentCompose
		if result then
			ed.player:addMoney(-info.cost)
			ed.player:consumeEquip(info.id, info.fragmentAmount)
			local ua = info.universalAmount or 0
			if ua > 0 then
				ed.player:consumeEquip(ed.parameter.universal_fragment_id, ua)
			end
			if info.makeId > 100 then
				ed.player:addEquip(info.makeId)
			else
				ed.player:addHero(info.makeId)
			end
		end
		if ed.netreply.composeFragmentReply then
			ed.netreply.composeFragmentReply(result, info.fragmentAmount)
			ed.netreply.composeFragmentReply = nil
		end
	end
	if msg._hero_equip_upgrade_reply then
		local reply = msg._hero_equip_upgrade_reply
		local result = reply._result == "success"
		local hero = reply._hero
		if hero then
			local handler = ed.netreply.equipUpgrade
			local data = ed.netdata.equipUpgrade
			if data then
				local hid = data.hid
				local sid = data.slot
				local pree = ed.player.heroes[hid]._items[sid]._exp
				local e = hero._items[sid]._exp
				local prel = ed.readequip.getEquipLevel(hid, sid, pree)
				local l = ed.readequip.getEquipLevel(hid, sid, e)
				if prel < l then
					ed.record:refreshCommonRecord("enhanceLevelup")
				end
			end
			if result then
				ed.player:resetHero(hero)
			end
			if handler then
				handler(result)
				ed.netreply.equipUpgrade = nil
			end
			if data then
				local type = data.type
				local cost = data.cost
				local mts = data.mts
				if type == "rmb" then
					ed.player:addrmb(-cost)
				elseif type == "money" then
					ed.player:addMoney(-cost)
					for k, v in pairs(mts) do
						ed.player:consumeEquip(v.id, v.amount)
					end
				end
			end
		end
	end
	if msg._hero_upgrade_reply then
		local reply = msg._hero_upgrade_reply
		local result = reply._result == "success"
		local hero = reply._hero
		local items = reply._items
		local props = {}
		for i = 1, #(items or {}) do
			local item = items[i]
			local id = ed.bits(item, 0, 10)
			local amount = ed.bits(item, 10, 11)
			ed.player:addEquip(id, amount)
			props[i] = {id = id, amount = amount}
		end
		if result then
			ed.player:resetHero(hero)
		end
		if ed.netreply.heroUpgradeReply then
			ed.netreply.heroUpgradeReply(result, props)
			ed.netreply.heroUpgradeReply = nil
		end
	end
	if msg._open_shop_reply then
		local reply = msg._open_shop_reply
		local result = reply._result
		local shop = reply._shop
		result = result == "success" or result == 0
		if shop then
			ed.player:refreshShopData(shop)
		end
		local data = ed.netdata.openShop
		if data then
			local cost = data.cost
			ed.player:addrmb(-cost)
		end
		local handler = ed.netreply.openShop
		if handler then
			handler(result)
			ed.netreply.openShop = nil
		end
	end
	if msg._error_info then
		local reply = msg._error_info
		local error = reply._info
		if EDTables.errorinfo[error] then
			error = EDTables.errorinfo[error]
		end
		if reply._exit == "force" then
			ed.showAlertDialog({
				text = error,
				buttonText = T(LSTR("NETWORK.QUIT")),
				handler = function()
					LegendExit()
				end
			})
		else
			ed.showAlertDialog({text = error})
		end
	end
	if msg._super_link then
		local reply = msg._super_link
		local info = reply._info
		info = EDTables.errorinfo[info] or info
		local addr = reply._addr
		ed.popSuperLinkAlertDialog(info, addr)
	end
	if msg._battle_check_fail then
		if ed.engine.battleLog then
			local battleLog = ed.engine.battleLog
			local compressData = CCFileUtils:sharedFileUtils():compressDataQuickLz(battleLog)
			if compressData then
				local battle_msg = ed.upmsg.report_battle()
				battle_msg._id = msg._battle_check_fail._checkid
				battle_msg._data = compressData
				ed.send(battle_msg, "report_battle", true)
			end
		end
		ed.showAlertDialog({
			text = T(LSTR("network.1.10.1.001")),
			buttonText = T(LSTR("NETWORK.QUIT")),
			handler = function()
				LegendExit()
			end
		})
	end
	if msg._sync_vitality_reply then
		local reply = msg._sync_vitality_reply
		ed.player._vitality = reply._vitality
		local data = ed.netdata.buyVitality
		if data and data.isBuy then
			local cost = data.cost
			ed.player._rmb = ed.player._rmb - cost
			if ed.netreply.buyVitalityReply then
				ed.netreply.buyVitalityReply()
				ed.netreply.buyVitalityReply = nil
			end
			ed.netdata.buyVitality = nil
		end
	end
	if msg._trigger_task_reply then
		local reply = msg._trigger_task_reply
		local result = reply._result
		if ed.netreply.triggerTask then
			ed.netreply.triggerTask(result)
			ed.netreply.triggerTask = nil
		end
	end
	if msg._require_rewards_reply then
		local reply = msg._require_rewards_reply
		local result = reply._result
		result = result == "success" or result == 0
		if ed.netreply.requireRewards then
			ed.netreply.requireRewards(result, ed.netdata.requireRewards)
			ed.netreply.requireRewards = nil
			ed.netdata.requireRewards = nil
		end
	end
	if msg._get_vip_gift_reply then
		local reply = msg._get_vip_gift_reply
		local result = reply._result
		result = result == "success" or result == 0
		local handler = ed.netreply.getvipGift
		local data = ed.netdata.getvipGift
		if result then
			local vip = data.vip
			ed.player:addvipGift(vip)
		end
		if handler then
			handler(result)
		end
		ed.netreply.getvipGift = nil
		ed.netdata.getvipGift = nil
	end
	if msg._user_check then
	end
	if msg._job_rewards_reply then
		local reply = msg._job_rewards_reply
		local result = reply._result
		result = result == "success" or result == 0
		if ed.netreply.jobRewards then
			ed.netreply.jobRewards(result, ed.netdata.jobRewards)
			ed.netreply.jobRewards = nil
			ed.netdata.jobRewards = nil
		end
		if "1" == ed.netreply.tenPumping then
			FireEvent("getPrize", reply)
			ed.netreply.tenPumping = nil
		end
		if "2" == ed.netreply.tenPumping then
			FireEvent("getTemPuming", reply)
			ed.netreply.tenPumping = nil
		end
	end
	if msg._reset_elite_reply then
		local reply = msg._reset_elite_reply
		local result = reply._result
		result = result == "success" or result == 0
		if result then
			local data = ed.netdata.resetElite
			local isPay, cost, stage
			if data then
				isPay = data.isPay
				cost = data.cost
				stage = data.stage
			end
			ed.player:refreshEliteResetTime()
			if not isPay then
				ed.player:resetEliteLimit()
			else
				ed.player:refreshStageEliteLimit(stage)
				ed.player:addrmb(-cost)
			end
		end
		if ed.netreply.resetElite then
			ed.netreply.resetElite(result)
			ed.netreply.resetElite = nil
			ed.netdata.resetElite = nil
		end
	end
	if msg._sweep_stage_reply then
		local reply = msg._sweep_stage_reply
		local shop = reply._shop
		local sshop = reply._sshop
		local function addSweepLoot(info)
			local wave = info._loot
			for k, v in pairs(wave) do
				ed.player:addExp(v._exp, "sweep")
				ed.player:addMoney(v._money)
				for ck, cv in pairs(v._items or {}) do
					local id = ed.bits(cv, 0, 10)
					local amount = ed.bits(cv, 10, 11)
					ed.player:addEquip(id, amount)
				end
			end
			for k, v in pairs(info._items or {}) do
				local id = ed.bits(v, 0, 10)
				local amount = ed.bits(v, 10, 11)
				ed.player:addEquip(id, amount)
			end
		end
		addSweepLoot(reply)
		local data = ed.netdata.sweep
		if data then
			local st = data.type
			local times = data.times
			local power = data.power
			local cost = data.cost
			local stage = data.stage
			ed.player:addVitality(-power * times)
			if st == "free" then
				ed.player:useSweepTimes(times)
			else
				ed.player._rmb = ed.player._rmb - cost or 0
			end
			if ed.stageType(stage) == "elite" then
				ed.player:addStageLimit(ed.elite2NormalStage(stage), times)
			end
			ed.netdata.sweep = nil
			ed.record:successFarmStage(stage, times)
		end
		if ed.netreply.sweep then
			ed.netreply.sweep(reply)
			ed.netreply.sweep = nil
		end
		if shop then
			local type
			local id = shop._id
			if id > 1 then
				type = "trigger"
			end
			ed.player:refreshShopData(shop, type)
			if ed.player:hasTriggerShop() then
				local ltid = ed.player:getLastTriggerShopid()
				if ltid == 2 then
					ed.teach("unlockSpecialShop")
				elseif ltid == 3 then
					ed.teach("unlockSoSpecialShop")
				end
			end
		end
		if sshop then
			ed.player:refreshStarShopData(sshop)
			ed.teach("unlockStarShop")
		end
	end
	if msg._skill_levelup_reply then
		ed.ui.herodetail.dealSkillLevelup(msg._skill_levelup_reply)
	end
	if msg._sync_skill_stren_reply then
		local reply = msg._sync_skill_stren_reply
		local skill = reply._skill_level_up
		ed.player._skill_level_up = skill
		local handler, data = ed.getNetReply("sync_skill_stren_chance")
		if data then
			ed.player:addrmb(-data.cost)
		end
		if handler then
			handler()
		end
	end
	if msg._tavern_draw_reply then
		local reply = msg._tavern_draw_reply
		local loot = reply._item_ids
		local heroes = reply._new_heroes
		local willOpenEvaluate
		for k, v in pairs(loot or {}) do
			local id, amount = ed.bits(v, 0, 10), ed.bits(v, 10, 11)
			local it = ed.itemType(id)
			if it == "hero" then
				if not ed.player.heroes[id] and 3 <= ed.readhero.getHeroInitStars(id) then
					willOpenEvaluate = true
				end
				ed.player:addHero(id)
			elseif it == "equip" then
				ed.player:addEquip(id, amount)
			end
		end
		for i = 1, #(heroes or {}) do
			local h = heroes[i]
			ed.player:resetHero(h)
		end
		local data = ed.netdata.tavern
		if data and data.type ~= "stone" then
			local isFree = data.isFree
			local box = data.type
			local times = data.times
			if not isFree then
				local pay = data.cost.pay
				local number = data.cost.number
				if pay == "Gold" then
					ed.player:addMoney(-number)
				elseif pay == "Diamond" then
					ed.player:addrmb(-number)
				end
				ed.player:refreshFirstTavern(box, times)
			else
				ed.player:useFreeTavern(box)
				--if willOpenEvaluate then
				--  ed.openEvaluate()
				--end
			end
			if times == "one" then
				ed.record:refreshCommonRecord("tavernGroupUse")
			elseif times == "ten" then
				if box == "magic" then
					ed.record:refreshCommonRecord("tavernGroupUse")
				else
					ed.record:refreshCommonRecord("tavernGroupUse", 10)
				end
			end
			ed.netdata.tavern = nil
		end
		local handler = ed.netreply.tavern
		if handler then
			if data and data.type == "stone" then
				handler(loot, heroes)
			else
				handler(loot)
			end
			ed.netreply.tavern = nil
		end
	end
	if msg._ask_daily_login_reply then
		local reply = msg._ask_daily_login_reply
		local result = reply._result
		local reward = {
			items = reply._items,
			heroes = reply._hero,
			diamond = reply._diamond
		}
		result = result == "success" or result == 0
		local data = ed.netdata.dailylogin
		if result then
			ed.player:recievedDailyLoginReward(data.type)
		end
		local handler = ed.netreply.dailylogin
		if handler then
			handler(result, reward)
			ed.netreply.dailylogin = nil
		end
	end
	if msg._query_data_reply then
		local reply = msg._query_data_reply
		local heroes = reply.heroes
		for i = 1, #(heroes or {}) do
			local h = heroes[i]
			ed.player:resetHero(h)
		end
		if reply.recharge_limit then
			ed.player:syncRechargeLimit(reply.recharge_limit)
		end
		if msg._query_data_reply.charge_sum then
			ed.player:setRechargeSum(msg._query_data_reply.charge_sum)
			ed.player:setrmb(msg._query_data_reply.rmb)
			FireEvent("QueryDataRsp", msg._query_data_reply)
		end
		if reply._month_card then
			for k, v in pairs(reply._month_card) do
				ed.player:refreshMonthCardData(v)
			end
		end
	end
	if msg._charge_reply then
		FireEvent("chargeRsp", msg._charge_reply)
	end
	if msg._hero_evolve_reply then
		local reply = msg._hero_evolve_reply
		local result = reply._result
		local hero = reply._hero
		result = result == "success" or result == 0
		local data = ed.netdata.evolve
		if data and result then
			local cost = data.cost or 0
			local id = data.id
			local amount = data.amount
			local hid = data.hid
			ed.player:addMoney(-cost)
			ed.player:consumeEquip(id, amount)
			if ed.player.heroes[hid] then
				ed.player.heroes[hid]:evolve()
			else
				ed.player:addHero(hid)
			end
			ed.player:resetHero(hero)
			ed.netdata.evolve = nil
		end
		local handler = ed.netreply.evolve
		if handler then
			handler(result)
			ed.netreply.evolve = nil
		end
	end
	if msg._ladder_reply then
		FireEvent("pvpRsp", msg._ladder_reply)
		if ed.netreply.gotoPvpBattleReply and msg._ladder_reply._start_battle then
			local enemyList = msg._ladder_reply._start_battle._heroes
			local selfList = msg._ladder_reply._start_battle._self_heroes
			local isBot = msg._ladder_reply._start_battle._is_robot
			isBot = isBot and isBot > 0
			ed.netreply.gotoPvpBattleReply(enemyList, isBot, selfList)
			ed.srand(msg._ladder_reply._start_battle._rseed)
			FireEvent("StartPVPBattle")
		end
		if ed.netreply.exitStageReply and msg._ladder_reply._end_battle then
			ed.netreply.exitStageReply(msg._ladder_reply._end_battle._result, msg._ladder_reply._end_battle)
			ed.netreply.exitStageReply = nil
		end
		local data = ed.netdata.exitStageReply
		local endBattle = msg._ladder_reply._end_battle
		if data and endBattle then
			local stage = data.stage
			local r = data.result
			ed.record:chaosFarmStage(stage)
			if endBattle._result == "victory" then
				ed.record:successFarmStage(stage)
			end
			ed.netdata.exitStageReply = nil
		end
	end
	if msg._tbc_reply then
		FireEvent("CrusadeRsp", msg._tbc_reply)
	end
	if msg._set_name_reply then
		local reply = msg._set_name_reply
		local result = reply._result
		local data = ed.netdata.setname
		if result == "success" and data then
			local name = data.name or ""
			local cost = data.cost or 0
			ed.player:setName(name)
			ed.player:addrmb(-cost)
			ed.player:refreshSetNameTime()
			ed.netdata.setname = nil
		end
		local handler = ed.netreply.setname
		if handler then
			handler(result)
			ed.netreply.setname = nil
		end
	end
	if msg._set_avatar_reply then
		local reply = msg._set_avatar_reply
		local result = reply._result
		result = result == "success" or result == 0
		local data = ed.netdata.setAvatar
		if data and result then
			local id = data.id
			ed.player:setAvatar(id)
		end
		local handler = ed.netreply.setAvatar
		if handler then
			handler(result)
		end
	end
	if msg._midas_reply then
		ed.ui.midas.dealUse(msg._midas_reply)
	end
	if msg._get_maillist_reply then
		local reply = msg._get_maillist_reply
		local data = reply._sys_mail_list
		local handler = ed.netreply.getMail
		ed.player:refreshMailData(data)
		if handler then
			handler()
		end
	end
	if msg._read_mail_reply then
		local reply = msg._read_mail_reply
		local result = reply._result
		result = result == "success" or result == 0
		local handler = ed.netreply.readMail
		local data = ed.netdata.readMail
		if result then
			if data then
				ed.player:readMail(data.id)
			end
			if handler then
				handler()
			end
			ed.netreply.readMail = nil
			ed.netdata.readMail = nil
		end
	end
	if msg._sdk_login_reply then
		FireEvent("SDKLoginRsp", msg._sdk_login_reply._result)
		local uin = msg._sdk_login_reply._uin
		if uin then
			ed.setDeviceId(uin)
		end
		if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
			accessToken = msg._sdk_login_reply._access_token
			rechargeURL = msg._sdk_login_reply._recharge_url
		end
	end
	if msg._cdkey_gift_reply then
		local reply = msg._cdkey_gift_reply
		local result = reply._result
		local pack = reply._pack
		local handler = ed.netreply.cdkeyGift
		if handler then
			handler(result, pack)
		end
	end
	if msg._change_server_reply then
		if msg._change_server_reply._result == "get_ok" then
			ed.ui.selectserverwin:updateServerList(msg._change_server_reply._server_info)
		elseif msg._change_server_reply._result == "change_ok" then
			LegendRestartApplication()
		elseif msg._change_server_reply._result == "fail" then
			local text = T(LSTR("SELECT.SERVER.CHANGE.FAILED"))
			local info = {
				text = text,
			}
			ed.showAlertDialog(info)
		end
	end
	if msg._notify_msg then
		LegendLog("[netword.lua|dispatch] _notify_msg");
		LegendLog(var_dump(msg._notify_msg));
		FireEvent("NotifyMsgRsp", msg._notify_msg)
		local reply = msg._notify_msg
		local newMail = reply._new_mail or 0
		ed.player:setNewMailAmount(newMail)
		ed.player:setExcavateHistoryAmount(reply._excav_record or 0)
		ed.player:releaseHeroes(reply._release_heroes)
	end
	if msg._guild_reply then
		FireEvent("GuildRsp", msg._guild_reply)
	end
	if msg._chat_reply then
		FireEvent("ChatRsp", msg._chat_reply)
	end
	if msg._ask_magicsoul_reply then
		local reply = msg._ask_magicsoul_reply
		local ids = reply._id
		local handler = ed.netreply.askMagicsoul
		if handler then
			handler(ids)
		end
	end
	if msg._excavate_reply then
		ed.ui.excavate.dealReply(msg._excavate_reply)
	end
	if msg._query_split_data_reply then
		ed.ui.herosplit.dealQueryData(msg._query_split_data_reply)
	end
	if msg._query_split_return_reply then
		ed.ui.herosplit.dealQueryReturn(msg._query_split_return_reply)
	end
	if msg._split_hero_reply then
		ed.ui.herosplit.dealSplitHero(msg._split_hero_reply)
	end
	if msg._worldcup_reply then
		ed.ui.worldcup.dealReply(msg._worldcup_reply)
	end
	if msg._continue_pay_reply then
		local msg=msg._continue_pay_reply
		local handler=ed.getNetReply("continuerecharge")
		if handler then
			handler(msg)
		end
	end
	if msg._query_replay then
		local reply = msg._query_replay
		local record = reply._record
		local handler, data = ed.getNetReply("query_replay")
		if handler then
			handler(record, (data or {}).mode)
		end
	end
	if msg._query_ranklist_reply then
		local handler = ed.getNetReply("query_ranklist")
		if handler then
			handler(msg._query_ranklist_reply)
		end
	end
    --add by cooper.x
    if msg._activity_info_reply then
        local handler = ed.getNetReply("GotoActivity")
        if handler then
            handler(msg._activity_info_reply)
        end
    end
    if msg._activity_lotto_info_reply then
        local handler = ed.getNetReply("LottoInfoHandler")
        if handler then
            handler(msg._activity_lotto_info_reply)
        end
    end
    if msg._activity_lotto_reward_reply then
        local handler = ed.getNetReply("LottoRewardHandler")
        if handler then
            handler(msg._activity_lotto_reward_reply)
        end
    end
    if msg._activity_bigpackage_info_reply then
        local handler = ed.getNetReply("BigPackageInfoHandler")
        if handler then
            handler(msg._activity_bigpackage_info_reply)
        end
    end
    if msg._activity_bigpackage_reward_reply then
        local handler = ed.getNetReply("BigPackageRewardInfoHandler")
        if handler then
            handler(msg._activity_bigpackage_reward_reply)
        end
    end
    if msg._activity_bigpackage_reset_reply then
        local handler = ed.getNetReply("BigPackageResetHandler")
        if handler then
            handler(msg._activity_bigpackage_reset_reply)
        end
    end
    --
	if msg._ask_activity_info_reply then
		local reply = msg._ask_activity_info_reply
		FireEvent("getActivities", reply._activity_info or {})
	end
	if msg._fb_attention_reply then 
		local reply = msg._fb_attention_reply
		local attention = reply._attention
		--ed.ui.statusbar:hide_fb_botton()
		if buttonUI~=nil and  buttonUI.fbattention~=nil then
			buttonUI.fbattention:setVisible(false)
			fb_flag=false
			local delay = CCDelayTime:create(0.5)
			local callfunc=function()
				libOS:getInstance():openURL("http://www.facebook.com/we4dota")
			end
			local sequence = CCSequence:createWithTwoActions(delay, CCCallFunc:create(callfunc))
			buttonUI.fbattention:runAction(sequence)				
		end
		
	end 
	if msg._recharge_rebate_reply then
		local handler = ed.getNetReply("RechargeRebateInfoHandler")
        if handler then
            handler(msg._recharge_rebate_reply)
        end
		local handler2 = ed.getNetReply("GetBtnInfoHandler")
		if handler2 then
			handler2(msg._recharge_rebate_reply)
		end
	end
	if msg._every_day_happy_reply then
		local handler = ed.getNetReply("EveryDayHappyInfoHandler")
        if handler then
            handler(msg._every_day_happy_reply)
        end
		local handler2 = ed.getNetReply("EveryDayHappyExchangeInfoHandler")
		if handler2 then
			handler2(msg._every_day_happy_reply)
		end
	end
	if sendCache then
		if sendCache.tutorial then
			local reply = msg._tutorial_reply
			if reply then
				local result = reply._result
				sendCache.tutorial = nil
				local handler = ed.netreply.tutorial
				if handler then
					handler()
					ed.netreply.tutorial = nil
				end
			end
		end
		if sendCache.sync_vitality then
			local reply = msg._sync_vitality_reply
			if reply then
				ed.player._vitality = reply._vitality
				sendCache.sync_vitality = nil
			end
		end
	end
end
ed.dispatch = dispatch

local function OnSendMsgFail()
	--联网失败啊
	if reConnectTimes==nil then
		reConnectTimes=0
	end
	reConnectTimes=reConnectTimes+1
	if reConnectTimes<2 then
		errorNet.showError(reSend)
	elseif reConnectTimes < 8 then--add by xinghui:显示停服公告
		serverInUpdate()
	else
		reConnectTimes=0
		--去登录页面
		ed.replaceScene(ed.ui.platformlogo.create())
	end

end
ListenEvent("SendMsgFail", OnSendMsgFail)


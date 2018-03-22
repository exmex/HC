---

pcall(function()
	if EDFLAGWIN32 then
		logfile = io.open("log_client.log", "w")
	end
	require("LocalString")
	require("tools")
	require("edebug")
	require("maingameproject")
end)

--EDFLAGWIN32=false
local debug_mode=false
if LegendPlatformFLAG==3 then
	--EDFLAGWIN32=true
	debug_mode =true
end
ed.debug_mode = debug_mode
EDLanguage = EDLanguage or "chinese"
local initFont = function()
	font = "arial_unicode_ms.ttf"
	fontBold = "arial_unicode_ms.ttf"
	selfFont = "arial_unicode_ms.ttf"
	local language = CCUserDefault:sharedUserDefault():getStringForKey("client_language")
	if language == "en-US" then
		font = "arial_unicode_ms.ttf"
		fontBold = "arial_unicode_ms.ttf"
		if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID or EDFLAGWP8 then
			font = "arial_unicode_ms.ttf"
			fontBold = "arial_unicode_ms.ttf"
		end
	elseif language == "zh-CN" then
		font = "Arial"
		fontBold = "Arial"
		if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID or EDFLAGWP8 then
			font = "Arial"
			fontBold = "Arial"
		end
	elseif language == "ko-KR" then
		font = "arial_unicode_ms.ttf"
		fontBold = "arial_unicode_ms.ttf"
		if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID or EDFLAGWP8 then
			font = "arial_unicode_ms.ttf"
			fontBold = "arial_unicode_ms.ttf"
		end
		selfFont = "arial_unicode_ms.ttf"
	elseif language == "de-DE" then
		font = "arial_unicode_ms.ttf"
		fontBold = "arial_unicode_ms.ttf"
		if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID or EDFLAGWP8 then
			font = "arial_unicode_ms.ttf"
			fontBold = "arial_unicode_ms.ttf"
		end
		selfFont = "arial_unicode_ms.ttf"
	end
	ed.font = font
	ed.fontBold = fontBold
	ed.selfFont = selfFont
end
function loadAllFiles()
	for i, v in ipairs(ed.needLoadFiles) do
		require(v)
	end
end
local scene_stack = {}
ed.scene_stack = scene_stack

--add by xinghui
local function registerFont()
	local platformTag=GetPlatformOS()
	local name, win32FontFile, iosFontFile, androidFontFile, fontColor, size, fontStyle, targetFontFile	
	for k, v in pairs(EDTables.fontcfg.annfonts) do	
		name = v.name
		win32FontFile = v.win32
		iosFontFile = v.ios
		androidFontFile = v.android
		fontColor = v.color
		size = v.size
		fontStyle = v.style
		if platformTag == 3 then
			targetFontFile = win32FontFile
		elseif platformTag == 2 then
			targetFontFile =  androidFontFile
		elseif platformTag == 1 then
			targetFontFile =  iosFontFile
		end
		FontFactory:instance():create_font(name, targetFontFile, fontColor, size, fontStyle)
	end
end
--

local main = function()
	local list = {
	["WVGA"] = {800, 480},
	["720p"] = {1280, 720},
	["1080p"] = {1920, 1080},
	["iPhone"] = {1024, 615},
	["iPad"] = {2048, 1230}
	}
	
	local resource_resolution="iPhone"
	
	local rr = list[resource_resolution]
	local lowres = 1
	
	if false then
		EDSwitchToResolutionDir(1)
		lowres = 0.5
	end
	
	CCDirector:sharedDirector():setContentScaleFactor(lowres * rr[2] / 480)
	LegendLog("[hello.lua|main]-------------------------------------------start")
	
	LegendLog("[hello.lua|main]Current Version: " .. SeverConsts:getInstance():getBaseVersion())
	LegendLog("[hello.lua|main]-------------------------------------------end")
	
	if LegendLuaReset then
		LegendLog("[hello.lua|main]LegendLuaReset is set")
	end
	
	--add by xinghui
	registerFont()
	--
	
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)
	LegendLuaReset = LegendLuaReset or 0
	if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID and LegendLuaReset == 1 then
		LegendLog("[hello.lua|main] go to ed.ui.platformlogo.create()")
		ed.pushScene(ed.ui.platformlogo.create())
	else
		LegendLog("[hello.lua|main] go to ed.ui.serverlogin.create()")
		ed.pushScene(ed.ui.serverlogin.create())
		--ed.pushScene(ed.ui.logo.create(sessionId))
		--ed.replaceScene(ed.ui.logo.create(sessionId))
	end
	local update_entry_id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(ed.gameUpdate, 0, false)
end

local function pushScene(scene)
	table.insert(scene_stack, scene)
	--modify by xinghui
	--在c++增加了内更新的检测，所以这里就不能调用runWithScene
	--[[if #scene_stack == 1 then
	CCDirector:sharedDirector():runWithScene(scene:ccScene())
else
	CCDirector:sharedDirector():pushScene(scene:ccScene())
end--]]
CCDirector:sharedDirector():pushScene(scene:ccScene())
end
ed.pushScene = pushScene
local function popScene()
	LegendLog("popScene ")
	if #scene_stack > 0 then
		if scene_stack[#scene_stack].identity == "main" then
			return
		end
		local scene = table.remove(scene_stack, #scene_stack)
		if scene.OnPopScene then
			scene:OnPopScene()
		end
	end
	CCDirector:sharedDirector():popScene()
end
ed.popScene = popScene

local function popScene2()
	LegendLog("popScene2 ")
	if #scene_stack > 0 then
		if scene_stack[#scene_stack].identity == "main" or scene_stack[#scene_stack].identity == "serverlogin" or scene_stack[#scene_stack].identity == "logo" then
			return
		end
		local scene = table.remove(scene_stack, #scene_stack)
		if scene.OnPopScene then
			scene:OnPopScene()
		end
	end
	CCDirector:sharedDirector():popScene()
end
ed.popScene2 = popScene2

local function replaceScene(scene)
	if #scene_stack > 0 then
		if scene_stack[#scene_stack].identity == "main" then
			pushScene(scene)
			return
		end
		local scene = table.remove(scene_stack, #scene_stack)
		if scene.OnPopScene then
			scene:OnPopScene()
		end
	end
	table.insert(scene_stack, scene)
	scene.pushed = false
	CCDirector:sharedDirector():replaceScene(scene:ccScene())
end
ed.replaceScene = replaceScene

local function getSceneCount()
	
	if #scene_stack > 0 then
		if scene_stack[#scene_stack].identity == "main" or scene_stack[#scene_stack].identity == "serverlogin" or scene_stack[#scene_stack].identity == "logo" then
			return 0
		end
	end
	return #scene_stack
end
ed.getSceneCount=getSceneCount

local applicationDidEnterBackground = function()
	print("applicationDidEnterBackground")
	LegendLog("applicationDidEnterBackground")
	
	ed.loadEnd()
	ed.closeConnect()
	if ed.player.initialized then
		--modify by xinghui:进入游戏的时候已经刷新
		--ed.localnotify.refresh()
	end
	if resume_timestamp and game_server_ip then
		local msg = ed.upmsg.suspend_report()
		msg._gametime = ed.getMillionTime() - resume_timestamp
		resume_timestamp = nil
		ed.send(msg, "suspend_report")
	end
end
ed.applicationDidEnterBackground = applicationDidEnterBackground
local applicationWillEnterForeground = function()
	LegendLog("applicationWillEnterForeground 31")
	ed.loadEnd()
	ed.closeConnect()
	--ed.playMusic(ed.music.map)
	resume_timestamp = ed.getMillionTime()
	if ed.checkSoundSwitch then
		ed.checkSoundSwitch()
	end
end
ed.applicationWillEnterForeground = applicationWillEnterForeground
local runScriptString = function()
	local temp = LegendGetScriptString()
	if temp ~= nil then
		local func = loadstring(temp)
		if func ~= nil then
			xpcall(func, EDDebug)
		end
	end
end
local gcPassTime = 0
local function memeryGC(fDelTime)
	gcPassTime = gcPassTime + fDelTime
	if gcPassTime > 10 then
		CCSpriteFrameCache:sharedSpriteFrameCache():gc(gcPassTime)
		CCTextureCache:sharedTextureCache():gc(gcPassTime)
		LegendAnimation:gc(gcPassTime)
		gcPassTime = 0
	end
end
local function getCurrentScene()
	return scene_stack[#scene_stack]
end
ed.getCurrentScene = getCurrentScene
local update_timestamp = ed.getMillionTime()
local resume_timestamp
local game_update_handler_list = {}
local function gameUpdate()
	xpcall(function()
		local time = ed.getMillionTime()
		if not resume_timestamp then
			resume_timestamp = time
		end
		local dt = update_timestamp ~= 0 and time - update_timestamp or 0
		--dt = dt * 2;
		dt = math.min(dt, ed.tick_interval)
		ed.proc_net()
		local scene = scene_stack[#scene_stack] or {}
		if scene.update then
			scene:update(dt)
		end
		update_timestamp = time
		runScriptString()
		UpdateEventSystem(dt)
		memeryGC(dt)
		for k, v in pairs(game_update_handler_list or {}) do
			v(dt)
		end
		end, EDDebug)
end
ed.gameUpdate = gameUpdate
local function registerGameUpdateHandler(key, handler)
	game_update_handler_list = game_update_handler_list or {}
	game_update_handler_list[key] = handler
end
ed.registerGameUpdateHandler = registerGameUpdateHandler
local function removeGameUpdateHandler(key)
	game_update_handler_list = game_update_handler_list or {}
	game_update_handler_list[key] = nil
end
ed.removeGameUpdateHandler = removeGameUpdateHandler
local initGcTime = function()
	CCSpriteFrameCache:sharedSpriteFrameCache():setGcTime(60)
	CCTextureCache:sharedTextureCache():setGcTime(60)
	LegendAnimation:setgcTime(120)
end

function OnRestartGame()
	local function handler()
		--CloseEvent("RestartGame")
		ed.replaceScene(ed.ui.platformlogo.create())
	end
	return handler
end

function createAnimation(resource, scale, aniType)
    local scale = scale or 1.0;
    local aniType = aniType or Type_LegendAnimation;
    if aniType == Type_LegendAnimation then
        return LegendAnimation:create(resource, scale);
    elseif aniType == Type_Spine then
        return SpineContainer:create('spine/' .. resource, resource ,scale)
    elseif aniType==Type_DragonBone then
    	return ArmatureContainer:create("dragbone/"..resource,resource,nil)
    end
end
ed.createAnimation = createAnimation;

xpcall(function()
	local ed = ed
	ed.run_with_scene = true
	loadAllFiles()
	initFont()
	initGcTime()
	main()
end, EDDebug)
		
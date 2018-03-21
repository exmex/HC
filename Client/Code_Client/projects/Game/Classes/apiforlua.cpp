//
//  apiforlua.c
//  HelloLua
//
//  Created by eboz on 14-4-26.
//
//
#include "CCStdC.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "AssetsManager.h"
#include "platform/platform.h"
#include <stdio.h>
#include "libPlatform.h"
#include <openssl/aes.h>

#include "CCLuaEngine.h"
#include "AssetsManager.h"
#include "LegendAnimationFileInfo.h"
#include "HeroFileUtils.h"
#include "../../protocol/game_idl.h"
#include "GateKeeper.h"
#include "SimpleAudioEngine.h"
#include "libOS.h"
#include "SeverConsts.h"
#include "com4loves.h"
#include "Base64.h"
#include "md5.h"
#include "rc4.h"
#include "DataTableManager.h"
#include "StringConverter.h"

#ifdef __cplusplus
extern "C"
{
#endif
#include "lua.h"
#include "lauxlib.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "../gzio/lgziolib.h"
#endif
	LUALIB_API int luaopen_struct(lua_State *L);
	int luaopen_lpeg(lua_State *L);
	LUALIB_API int luaopen_bit(lua_State *L);
	int luaopen_md5_core(lua_State *L);

	LUALIB_API int luaopen_socket_core(lua_State *L);
	LUALIB_API int luaopen_mime_core(lua_State *L);
    void md5 (const char *message, long len, char *output);

#ifdef __cplusplus
}
#endif

USING_NS_CC;
USING_NS_CC_EXT;

#define LegendSDKType 4

//globals
//
double g_ani_scale_factor = 1.0;
int    g_soundSwitch = 1;
double g_time_factor = 1.0;



extern "C" void setUserID(int isOk, const char* session,
               const char * uin, const char* userId,
               const char* serverId,const char* serverIP,const char* serverPort)
{
	CCLog("##################setUserID is called");
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "SDKLogin");
		lua_pushboolean(L, isOk);
		lua_pushstring(L, session);
		lua_pushstring(L, uin);
		lua_pushstring(L, userId);
		lua_pushstring(L, serverId);
		lua_pushstring(L, serverIP);
		lua_pushstring(L, serverPort);
		lua_pcall(L, 8, 1, 0);
	}

	lua_settop(L, top);
}

extern "C" void OnPayResult()
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
	lua_State *L = pEngine->getLuaStack()->getLuaState();
    
	int top = lua_gettop(L);
    
	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "91PayResult");
		lua_pushboolean(L, true);
		lua_pcall(L, 2, 1, 0);
	}
	lua_settop(L, top);
}


extern "C" void OnFacebookConnectResult(int result)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "FacebookConnectResult");
		lua_pushinteger(L, result);
		lua_pcall(L, 2, 1, 0);
	}

	lua_settop(L, top);
}




extern "C" void didEnterGround(int enterType)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "EnterGroud");
		lua_pushinteger(L, enterType);
		lua_pcall(L, 2, 1, 0);
	}

	lua_settop(L, top);
}

extern "C" void showAnnouncement(std::string fileContent)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
	lua_State *L = pEngine->getLuaStack()->getLuaState();
	int top = lua_gettop(L);
	lua_getglobal(L, "showAnnouncement");
	if (!lua_isfunction(L, -1))
	{
		CCLog("------------return");
	}
	lua_pushstring(L, fileContent.c_str());
	lua_pcall(L, 1, 0, 0);
	lua_settop(L, top);
}
//add by cooper.x
extern "C" void showAnnouncement2(std::string annStr)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
	lua_State *L = pEngine->getLuaStack()->getLuaState();
	int top = lua_gettop(L);
	lua_getglobal(L, "showAnnouncement2");
	if (!lua_isfunction(L, -1))
	{
		CCLog("------------return");
	}
	lua_pushstring(L, annStr.c_str());
	lua_pcall(L, 1, 0, 0);
	lua_settop(L, top);
}

extern "C" void showAnnouncementDownloadFailed()
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();
	int top = lua_gettop(L);
	lua_getglobal(L, "showAnnouncementDownloadFailed");
	if (!lua_isfunction(L, -1))
	{
		CCLog("------------return");
	}
	lua_pcall(L, 0, 0, 0);
	lua_settop(L, top);
}
extern "C" void printErrorInLua(const char* errorInfo)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "PrintError");
		lua_pushstring(L, errorInfo);
		lua_pcall(L, 2, 1, 0);
	}

	lua_settop(L, top);
}


extern "C" void doGoogleConnectResponse(const char* state)
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
	lua_State *L = pEngine->getLuaStack()->getLuaState();
	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "GoogleConnectResponse");
		lua_pushstring(L, state);
		lua_pcall(L, 2, 1, 0);
	}

	lua_settop(L, top);
}

void startGameForDebug()
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "DebugLogin");
		lua_pcall(L, 1, 1, 0);
	}

	lua_settop(L, top);
}

void restartGame()
{
	CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();

	lua_State *L = pEngine->getLuaStack()->getLuaState();

	int top = lua_gettop(L);

	lua_pushstring(L, "FireEvent");
	lua_gettable(L, LUA_GLOBALSINDEX);
	int t = lua_type(L, -1);
	if (t == LUA_TFUNCTION)
	{
		lua_pushstring(L, "RestartGame");
		lua_pcall(L, 1, 1, 0);
	}

	lua_settop(L, top);
}

static int LegendLog(lua_State *L) {
	
	const char* x = luaL_checkstring(L, 1);
#if defined(DEBUG) || (COCOS2D_DEBUG==1) 
	CCLOG("[LegendLog] %s", x);
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//CCLog("[LegendLog] %s", x);
#endif

	/*
	 0x753a7e95:	push	{r3, lr}
	 0x753a7e97:	movs	r1, #1
	 0x753a7e99:	movs	r2, #0
	 0x753a7e9b:	bl	0x753cab60 <luaL_checklstring>
	 0x753a7e9f:	ldr	r1, [pc, #20]	; (0x753a7eb4)
	 0x753a7ea1:	ldr	r2, [pc, #20]	; (0x753a7eb8)
	 0x753a7ea3:	adds	r3, r0, #0
	 0x753a7ea5:	add	r1, pc
	 0x753a7ea7:	add	r2, pc
	 0x753a7ea9:	movs	r0, #6
	 0x753a7eab:	blx	0x753a5be4
	 0x753a7eaf:	movs	r0, #0
	 0x753a7eb1:	pop	{r3, pc}
	 */
	return  0;
}

static int LegendGetFileData(lua_State *L)
{
	return 0;
}
static int LegendGetEncryptedFileData(lua_State *L){
	    
	const char* xf = luaL_checkstring(L, 1);

	std::string pathfile = LegendFindFileCpp(xf);
    if(pathfile.empty())
    {
        lua_pushlstring(L, "", 1);
        return 1;
    }

	unsigned long sz = 0;
	unsigned char* data = cocos2d::CCFileUtils::sharedFileUtils()->getFileData(pathfile.c_str(), "rb", &sz);

	lua_pushlstring(L, (const char *)data, sz);

	delete[]data;

	return 1;

}

static int LegendGetDeviceID(lua_State *L)
{

	////printf("apiforlua is call %s\n","LegendGetDeviceID");
	lua_pushstring(L, "");
	return 1;
}

static int LegendSetAniScaleFactor(lua_State *L)
{

	double scale = luaL_checknumber(L, 1);
	g_ani_scale_factor = scale;
	//printf("apiforlua is call %s %0.2f\n","LegendSetAniScaleFactor",scale);
	return 0;
}

static int LegendLoadShader(lua_State *L){

	const char *shaderName = luaL_checkstring(L, 1);
	//printf("apiforlua is call %s ->%s\n","LegendLoadShader",shaderName);
	std::string vsh = "shader/";
	vsh = vsh + shaderName + ".vsh";
	std::string fsh = "shader/";
	fsh = fsh + shaderName + ".fsh";
	CCShaderCache::sharedShaderCache()->addAutoReloadingProgram(shaderName, vsh.c_str(), fsh.c_str());
	return 0;
}

extern "C" int LegendTime(lua_State *L){
	// printf("call %s\n","LegendTime")
	
	struct cc_timeval  tv = { 0 };
	CCTime::gettimeofdayCocos2d(&tv, 0);

	struct tm  *p = localtime((const time_t *)&tv.tv_sec);
	double million = ((double)tv.tv_usec) / 1000000.0 + (double)tv.tv_sec;
	time_t clock = tv.tv_sec;

	lua_pushinteger(L, (p->tm_year + 1900));
	lua_pushinteger(L, (p->tm_mon + 1));
	lua_pushinteger(L, p->tm_mday);
	lua_pushinteger(L, p->tm_hour);
	lua_pushinteger(L, p->tm_min);
	lua_pushinteger(L, p->tm_sec);
	lua_pushinteger(L, clock);
	lua_pushnumber(L, million + 1000);

	return 8;
}
static int LegendSetSoundSwitch(lua_State *L)
{
	//printf("apiforlua is call %s\n","LegendSetSoundSwitch");
	g_soundSwitch = luaL_checkint(L, 1) ? 0:1;

	//同步设置JAVA中的声音开关
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//setSoundSwitchJNI(g_soundSwitch);
#endif
	return 0;
}
static int LegendGetScriptString(lua_State *L)
{
	lua_pushnil(L);
	return 1;
}
static int LegendClearLoaded(lua_State *L)
{
	return 0;
}

static int LegendFileFromPatchServer(lua_State *L)
{
	const char *file = luaL_checkstring(L, 1);
	size_t sz = 0;
	unsigned char * p = AssetsManager::sharedManager()->getFileFromVersionServer(file, &sz);

	if (p != NULL && sz > 0)
	{
		lua_pushlstring(L, (const char*)p, sz);
	}
	else
	{
		lua_pushnil(L);
	}

	return 1;
}

static int LegendBuyDiamond(lua_State *L){
	//CCLog("apiforlua is call %s\n","LegendBuyDiamond");
	int parame = luaL_checkinteger(L, 1);
	int productCount = luaL_checkint(L, 2);
	const char * productName = luaL_checkstring(L, 3);
	std::string productID = luaL_checkstring(L, 4);
	std::string userId = luaL_checkstring(L, 5);
	std::string productPrice = luaL_checkstring(L, 6);
	int serverID = luaL_checkint(L, 7);
	//CCLog("LegendBuyDiamond -> open win32 recharge!!! parame:%d,productCount:%d,productName:%s,productID:%s,userId:%s,productPrice:%s,serverID:%d", parame, productCount, productName, productID.c_str(), userId.c_str(),productPrice.c_str(), serverID);
	BUYINFO buyinfo;
	buyinfo.productCount = productCount;
	buyinfo.productName = productName;
	buyinfo.productId = productID;
	float money = atof(productPrice.c_str());
	buyinfo.productPrice = money;
	buyinfo.productOrignalPrice = money;
	char severIDStr[64];
	sprintf(severIDStr, "%d_%s", serverID, userId.c_str());  //把userId和Serverid拼一起传过去
	buyinfo.description = severIDStr;
	libPlatformManager::getPlatform()->buyGoods(buyinfo);

	return 0;
}

static int LegendSwitchAccount(lua_State *L)
{
	libPlatformManager::getPlatform()->switchUsers();
	return 0;
}

static int LegendListenPayEvent(lua_State *L){
	//printf("apiforlua is call %s\n","LegendListenPayEvent");
	return 0;
}

static int LegendClosePayEvent(lua_State *L){
	//printf("apiforlua is call %s\n","LegendClosePayEvent");
	return 0;
}

static int LegendSDKLogin(lua_State *L)
{
	CCLog("[apiforlua|LegendSDKLogin] CC_TARGET_PLATFORM is %d", CC_TARGET_PLATFORM);
	startGameForDebug();
	/*if (!libPlatformManager::getPlatform()->getLogined())
	{
	libPlatformManager::getPlatform()->login();
	}*/
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	//startGameForDebug();
#endif
	return 0;
}

static int GetPlatformOS(lua_State *L)
{
	CCLog("[apiforlua|GetPlatformOS] CC_TARGET_PLATFORM is %d", CC_TARGET_PLATFORM);
#ifdef PROJECT91Quasi
	CC_TARGET_PLATFORM = CC_PLATFORM_WIN32;
#endif
	lua_pushinteger(L, CC_TARGET_PLATFORM);
	return 1;
}

//add by xinghui
static int LegendFindFileForLua(lua_State* L)
{
	std::string s = luaL_checkstring(L, 1);
	std::string pc = LegendFindFileCpp(s.c_str());
	lua_pushstring(L, pc.c_str());
	return 1;
}

static int LegendUpdateSvr(lua_State *L)
{
	//by chenpanhua
	int parame = luaL_checkinteger(L, 1);
	int severId = luaL_checkint(L, 2);
	std::string userName = luaL_checkstring(L, 3);
	int playerId = luaL_checkint(L, 4);
	int level = luaL_checkint(L, 5);
	int viplevel = luaL_checkint(L, 6);
	int silvercoins = luaL_checkint(L, 7);
	int goldcoins = luaL_checkint(L, 8);
	int putSvr = luaL_checkint(L, 9);
	bool isPutSvr = false;
	if (putSvr==1)
	{
		isPutSvr = true;
	}
	
	//CCLog("LegendUpdateSvr::severId:%d,%s,%d,%d,%d,%d,%d,%d", severId,userName.c_str(),playerId,level,viplevel,silvercoins,goldcoins,putSvr);
	com4loves::updateServerInfo(severId,userName, playerId, level,
		viplevel, silvercoins, goldcoins, isPutSvr);
	
	return 1;
}

static int LegendRefreshServerInfo(lua_State *L)
{
	int parame = luaL_checkinteger(L, 1);
	std::string projectName = luaL_checkstring(L, 2);
	std::string userId = luaL_checkstring(L, 3);
	int putSvr = luaL_checkint(L, 4);
	bool getSvr = false;
	if (putSvr == 1)
	{
		getSvr = true;
	}
	com4loves::refreshServerInfo(projectName, userId, getSvr);
	return 1;
}

static int LegendEnableSDKUI(lua_State *L){
	int inputParam = luaL_checkint(L, 1);
	return 0;
}

static int LegendExit(lua_State *L)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#else
	CCLog("apiforlua is call %s\n","LegendExit");
    exit(0);
#endif


	return 0;
}
static int LegendAndroidPurchase(lua_State *L){
	//printf("apiforlua is call %s\n","LegendAndroidPurchase");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//const char * purchaseInfo = luaL_checkstring(L, 1);
	//doPaymentJNI(purchaseInfo);
#endif
	return 0;
}

static int LegendGoogleConnectResponse(lua_State *L){
	CCLog("apiforlua is call %s\n","LegendGoogleConnectResponse");
	return 0;
}
static int LegendGoogleConnect(lua_State *L){
	CCLog("apiforlua is call %s\n","LegendGoogleConnect");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//androidDoGooglePlayLogin();
#endif
	return 0;
}

static int LegendCheckWifi(lua_State *L)
{
	return ((libOS::getInstance()->getNetWork() == ReachableViaWWAN))?0:1;
}

static int LegendAndroidExtra(lua_State *L){

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	printf("apiforlua is call %s\n","LegendAndroidExtra");

	const char * key = luaL_checkstring(L, 1);
	const char * text = luaL_checkstring(L, 2);

	//doExtraJNI(key, text);
#endif
	return 0;

}

static int LegendOpenURL(lua_State *L)
{
	const char * key = luaL_checkstring(L, 1);
	if(key)
	{
		libOS::getInstance()->openURL(key);
	}
	return 0;
}

static int LegendGetSecondsFromGMT(lua_State* L)
{
	lua_pushinteger(L, libOS::getInstance()->getSecondsFromGMT());
	return 0;
}

static int LegendSendMailIssue(lua_State *L){
	//printf("apiforlua is call %s\n","LegendOpenURL");
    std::string version = cocos2d::CCUserDefault::sharedUserDefault()->getStringForKey("current-version");
    const char * issueType = luaL_checkstring(L, 1);
    const char* playerID =luaL_checkstring(L, 2);
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

    //CCLuaObjc::sendMailReportIssue(issueType,version.c_str(),playerID);
#elif( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    //sendMailReportIssueJNI(issueType,version.c_str(),playerID);
#endif
	return 0;
}

static int LegendAddNotification(lua_State *L){
	//printf("apiforlua is call %s\n","LegendAddNotification");
	const char * key = luaL_checkstring(L, 1);
	const char * text = luaL_checkstring(L, 2);
	const char * tag = luaL_checkstring(L, 3);
	long          date = luaL_checkinteger(L, 4);

	//CCLog("LegendAddNotification******key:%s,******text:%s,******tag:%s,******date:%d",key, text, tag, date);
	libOS::getInstance()->addNotification(text,date,true);


	return 0;
}


static int LegendGetResourcePath(lua_State *L)
{
    std::string path = CCFileUtils::sharedFileUtils()->getResourcePath();
    
    lua_pushlstring(L, path.c_str(), path.size());
    return 1;
}

static int LegendCancelNotification(lua_State *L){
	//printf("apiforlua is call %s\n","LegendCancelNotification");

	libOS::getInstance()->clearNotification();
	return 0;
}


static int LegendEnterGameNotifiy(lua_State *L){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    //CCLuaObjc::LuaEnterGameNotify();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    int isFinishTutorial = luaL_checkint(L,1);
	std::string urls="";
	urls  += GK_ANDROID_PAYMENT_REUQEST;
	urls  +="\n";
	urls  += GK_ANDROID_PAYMENT_GETKEY;
	urls  +="\n";
	urls  += GK_ANDROID_PAYMENT_DELIVER;
    //initPaymentJNI(urls.c_str());

    CCLog("apiforlua is call for function: %s with param isFinishTutorial: %d\n","LegendEnterGameNotifiy", isFinishTutorial);
    //if(isFinishTutorial)
    	//initGooglePlay();
#endif
	return 0;
}

static int LegendGetShopPriceInfo(lua_State *L){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    const char * items = luaL_checkstring(L, 1);
    //CCLuaObjc::getShopPriceInfo(items);
#endif
	return 0;
}

static int LegendRedoLogin(lua_State *L){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
    //CCLuaObjc::dologin();
    restartGame();
#else
	
#endif
	return 0;
}

static int LegendRestartApplication(lua_State *L){
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//	restartApplicationJNI();
//#else
	g_restartFlag = 1;

	CCUserDefault::sharedUserDefault()->setBoolForKey("restartGame", true);

	CocosDenshion::SimpleAudioEngine::sharedEngine()->stopBackgroundMusic(false);
    CCApplication::sharedApplication()->restart();

//#endif
    return 0;
}


static int LegendConnectFacebook(lua_State *L)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//connectFacebookJNI();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
    //CCLuaObjc::connectFacebook();
#endif
	return 0;
}


static int LegendDisconnectFacebook(lua_State *L)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//disconnectFacebookJNI();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
    //CCLuaObjc::disConnectFacebook();
#endif
	return 0;
}


static int LegendIsFacebookConnected(lua_State *L)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//int ret = isFacebookConnectedJNI();
	//lua_pushinteger(L, ret);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
    //int ret = CCLuaObjc::isFacebookConnected();
    //lua_pushinteger(L, ret);
#else
	lua_pushinteger(L, 0);
#endif
	return 1;
}

static int LegendGetLoginPwd(lua_State* L)
{
	const char* puid = libPlatformManager::getPlatform()->loginUin().c_str();
	const std::string deviceId = libOS::getInstance()->getDeviceID();
	const char* version = SeverConsts::Get()->getVersion().c_str();
	static char* key = "pfldhzbycglblftgzhlcxlyc";
	const char* source = CCString::createWithFormat("%s_%s_%s_%s", puid, deviceId.c_str(), version, key)->getCString();
	
	const std::string pwd = core_base64Encode((const unsigned char*)(source), strlen(source));
	MD5 md5_encryptor(pwd);
	const std::string ret = md5_encryptor.md5();

	lua_pushstring(L, ret.c_str());

	return 1;
}


char* aes_cbc_do_crypt_data(int mod, const char*key,
	size_t okeylen, const char *input, size_t inputLen, size_t * pOutputLen)
{

	unsigned char aeskey[16] = "darogn";
	unsigned char iv[16] = {0};
	//memcpy(aeskey, key, okeylen > 16 ? 16 : okeylen);
	memcpy(aeskey + 6, key, okeylen > 9 ? 9 : okeylen);

	int bits = 128;

	size_t finalLen = inputLen;

	if (mod == AES_ENCRYPT)
	{
		finalLen += 4;
	}

#define ALIGN_SIZE  16

	size_t bytesInData = (finalLen % ALIGN_SIZE) == 0 ? finalLen : (int(finalLen / ALIGN_SIZE) + 1) * ALIGN_SIZE;

	unsigned char *output = new unsigned char[bytesInData];
	unsigned char *myinput = new unsigned char[bytesInData];
	// memset(output, 0, bytesInData);
	// memset(myinput, 0, bytesInData);

	AES_KEY kt = { 0 };

	if (mod == AES_ENCRYPT)
	{
		AES_set_encrypt_key(aeskey, bits, &kt);
		memcpy(myinput + 4, input, inputLen);
		memcpy(myinput, &inputLen, 4);
	}
	else
	{
		memcpy(myinput, input, inputLen);
		AES_set_decrypt_key(aeskey, bits, &kt);
	}

	AES_cbc_encrypt((const unsigned char *)myinput,
		output,
		bytesInData, &kt, iv, mod);

	delete[]myinput;
	*pOutputLen = bytesInData;
	return (char*)output;

}

unsigned char* rc4_proto(unsigned char* in, unsigned long inSize)
{
	unsigned char* out = new unsigned char[inSize];

	static bool useRc4 = StringConverter::parseBool(VaribleManager::Get()->getSetting("OpenRc4Encrypt", "", "false"), false);
	if ( !useRc4 )
	{
		memcpy(out, in, inSize);
		return out;
	}

	const char* key = "gota123|}{";
	AVRC4 rc4_key;
	memset(&rc4_key, 0, sizeof(AVRC4));
	av_rc4_init(&rc4_key, (const unsigned char*)key, strlen(key) * 8);

	av_rc4_crypt(&rc4_key, out, in, inSize);
	return out;
}

static int encrypt(lua_State *L){
	//printf("encrypt is call");
	size_t size = 0;
	const char* input = luaL_checklstring(L, 1, &size);
	size_t okeylen = 0;
	const char* key = luaL_checklstring(L, 2, &okeylen);

	size_t outLen = 0;
	char *output = aes_cbc_do_crypt_data(AES_ENCRYPT, key, okeylen, input, size, &outLen);
	char* outStr = (char *)rc4_proto((unsigned char*)output, outLen);
	delete[] output;

	lua_pushlstring(L, outStr, outLen);
	delete[]outStr;
	return 1;
}

static int decrypt(lua_State *L)
{
	//printf("encrypt is call");
	size_t size = 0;
	const char* input = luaL_checklstring(L, 1, &size);
	input = (const char*)rc4_proto((unsigned char*)input, size);

	size_t okeylen = 0;
	const char* key = luaL_checklstring(L, 2, &okeylen);

	size_t outLen = 0;
	char *output = aes_cbc_do_crypt_data(AES_DECRYPT, key, okeylen, input, size, &outLen);
	delete[] input;
	unsigned int pblen = *(unsigned int*)output;
	lua_pushlstring(L, (const char*)(output + 4), pblen);
	delete[]output;
	return 1;

}

static int show(lua_State *L){
	size_t size = 0;
	unsigned int i;
	const unsigned char* input = (const unsigned char*)luaL_checklstring(L, 1, &size);
	for (i = 0; i < size; i++)
	{
		printf("%02x ", input[i]);
	}

	printf("\n");

	return 0;
}


static const struct luaL_Reg libmycrypto[] = {
	{ "encrypt", encrypt },
	{ "decrypt", decrypt },
	{ "show", show },
	{ NULL, NULL }
};


int luaopen_mycrypto(lua_State *L)
{
	luaL_register(L, "mycrypto", libmycrypto);
	return 0;
}


void luaopen_LegendLuaInterface(lua_State *L)
{
	lua_pushcclosure(L, LegendLog, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendLog");
	lua_pushcclosure(L, LegendGetFileData, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetFileData");
	lua_pushcclosure(L, LegendGetEncryptedFileData, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetEncryptedFileData");
	lua_pushcclosure(L, LegendGetDeviceID, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetDeviceID");
	lua_pushcclosure(L, LegendSetAniScaleFactor, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSetAniScaleFactor");
	lua_pushcclosure(L, LegendLoadShader, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendLoadShader");
	lua_pushcclosure(L, LegendTime, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendTime");
	lua_pushcclosure(L, LegendSetSoundSwitch, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSetSoundSwitch");
	lua_pushcclosure(L, LegendGetScriptString, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetScriptString");
	lua_pushcclosure(L, LegendClearLoaded, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendClearLoaded");
	lua_pushcclosure(L, LegendFileFromPatchServer, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendFileFromPatchServer");
	lua_pushcclosure(L, LegendBuyDiamond, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendBuyDiamond");
	lua_pushcclosure(L, LegendSwitchAccount, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSwitchAccount");
	lua_pushcclosure(L, LegendListenPayEvent, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendListenPayEvent");
	lua_pushcclosure(L, LegendClosePayEvent, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendClosePayEvent");
	lua_pushcclosure(L, LegendEnableSDKUI, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendEnableSDKUI");
	lua_pushcclosure(L, LegendSDKLogin, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSDKLogin");
	//add by xinghui
	lua_pushcclosure(L, GetPlatformOS, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "GetPlatformOS");
	lua_pushcclosure(L, LegendFindFileForLua, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendFindFileForLua");
	lua_pushcclosure(L, LegendExit, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendExit");
	lua_pushcclosure(L, LegendAndroidPurchase, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendAndroidPurchase");
	lua_pushcclosure(L, LegendGoogleConnect, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGoogleConnect");
	lua_pushcclosure(L, LegendGoogleConnectResponse, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGoogleConnectResponse");
	lua_pushcclosure(L, LegendCheckWifi, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendCheckWifi");
	lua_pushcclosure(L, LegendAndroidExtra, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendAndroidExtra");
	
	lua_pushcclosure(L, LegendOpenURL, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendOpenURL");
	lua_pushcclosure(L, LegendGetSecondsFromGMT, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetSecondsFromGMT");
    lua_pushcclosure(L, LegendSendMailIssue, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSendMailIssue");
	lua_pushcclosure(L, LegendAddNotification, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendAddNotification");
	lua_pushcclosure(L, LegendCancelNotification, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendCancelNotification");
	lua_pushcclosure(L, LegendEnterGameNotifiy, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendEnterGameNotifiy");
	lua_pushcclosure(L, LegendGetShopPriceInfo, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetShopPriceInfo");
    
	lua_pushcclosure(L, LegendRedoLogin, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendRedoLogin");

    lua_pushcclosure(L, LegendRestartApplication, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendRestartApplication");
  
    lua_pushcclosure(L, LegendGetResourcePath, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetResourcePath");
    
    lua_pushcclosure(L, LegendConnectFacebook, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendConnectFacebook");

    lua_pushcclosure(L, LegendDisconnectFacebook, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendDisconnectFacebook");

    lua_pushcclosure(L, LegendIsFacebookConnected, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendIsFacebookConnected");
    
	lua_pushinteger(L, LegendSDKType);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendSDKType");

	//by chenpanhua
	lua_pushcclosure(L, LegendUpdateSvr, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendUpdateSvr");

	lua_pushcclosure(L, LegendRefreshServerInfo, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendRefreshServerInfo");

	lua_pushcclosure(L, LegendGetLoginPwd, 0);
	lua_setfield(L, LUA_GLOBALSINDEX, "LegendGetLoginPwd");

	//end

	luaopen_struct(L);
	luaopen_lpeg(L);
	luaopen_bit(L);
	luaopen_md5_core(L);
	luaopen_socket_core(L);
	luaopen_mime_core(L);
	luaopen_mycrypto(L);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    lua_pushcfunction(L, luaopen_gzio);
    lua_pushstring(L, LUA_GZIOLIBNAME);
    lua_call(L, 1, 0);
#endif

}

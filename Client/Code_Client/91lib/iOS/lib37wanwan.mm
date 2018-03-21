#include "lib37wanwan.h"
#include "lib37wanwanObj.h"
#include <string>
#include "libOS.h"
#include "37wanwan/GameLib.h"
#include "Custom37SDK.h"
#include <com4lovesSDK.h>

lib37wanwanObj* s_lib37wanwanOjb;


void lib37wanwan::init(bool isPrivateLogin )
{

     mEnableLogin = false;
    
    
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_37wan"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    
    [Custom37SDK initSDK];

    s_lib37wanwanOjb = [lib37wanwanObj new];
    [s_lib37wanwanOjb registerNotification];
    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
}

void lib37wanwan::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/37wanwan/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_lib37wanwanOjb];
    //[s_lib37wanwanOjb updateApp];
}
void lib37wanwan::final()
{
    //[s_lib37wanwanOjb unregisterNotification];
}
bool lib37wanwan::getLogined()
{
    return [Custom37SDK isLogin];//[[NdComPlatform defaultPlatform] isLogined];
}
void lib37wanwan::login()
{
    if (![Custom37SDK isLogin]) {
        [Custom37SDK showLoginView];
    }
}
void lib37wanwan::logout()
{
    [Custom37SDK logout];
	//[[NdComPlatform defaultPlatform] NdLogout:0];
}
void lib37wanwan::switchUsers()
{
    [Custom37SDK showPlatformView];
}

void lib37wanwan::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *billNO = [[NSString alloc] initWithUTF8String:info.cooOrderSerial.c_str()];
    NSString *pname = [[NSString alloc] initWithUTF8String:info.productName.c_str()];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];
    NSString* productid = [NSString stringWithUTF8String:info.productId.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
   
    NSString* orderId = [NSString stringWithFormat:@"%@-%@-%@",serverid,productid,uin];
    mBuyInfo = info;
    [Custom37SDK showPayViewWithOrderID:orderId productID:productid title:pname money:(int)info.productPrice playerID:uin serverID:serverid];
    //[Custom37SDK showPayViewWithOrderID:orderId productID:productid title:pname money:(int)1 playerID:uin serverID:serverid];

}
const std::string& lib37wanwan::loginUin()
{
    NSString *userID = [Custom37SDK getUserId];
    static std::string retStr;
    if(userID) retStr = [userID UTF8String];
    retStr = "37WANUSR_"+retStr;
    return retStr;
}
const std::string& lib37wanwan::sessionID()
{
    
    NSString *sessionID = [Custom37SDK getSessionId];
    static std::string retStr;
    if(sessionID) retStr = (const char*)[sessionID UTF8String];
    return retStr;
}
const std::string& lib37wanwan::nickName()
{
    NSString* retNS = [Custom37SDK getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void lib37wanwan::openBBS()
{
	 //[[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
    //libOS::getInstance()->openURL("http://bbs.996.com/forum-mxhzw-1.html");
}


void lib37wanwan::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void lib37wanwan::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string lib37wanwan::getClientChannel()
{
    return "37WAN";
}
const unsigned int lib37wanwan::getPlatformId()
{
    return 0u;
}

std::string lib37wanwan::getPlatformMoneyName()
{
    return "RMB";
}
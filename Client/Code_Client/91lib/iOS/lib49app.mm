#include "lib49app.h"
#include "lib49appObj.h"
#include <string>
#include "libOS.h"
#include "Custom49SDK.h"
#include <com4lovesSDK.h>

lib49appObj* s_lib49appOjb;


void lib49app::init(bool isPrivateLogin )
{

     mEnableLogin = false;
    
    
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_49app"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    
    [Custom49SDK initSDK];

    s_lib49appOjb = [lib49appObj new];
    [s_lib49appOjb registerNotification];
    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
}

void lib49app::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/49wanwan/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_lib49appOjb];
    //[s_lib49appOjb updateApp];
}
void lib49app::final()
{
    //[s_lib49appOjb unregisterNotification];
}
bool lib49app::getLogined()
{
    return [Custom49SDK isLogin];//[[NdComPlatform defaultPlatform] isLogined];
}
void lib49app::login()
{
    if (![Custom49SDK isLogin]) {
        [Custom49SDK showLoginView];
    }
}
void lib49app::logout()
{
    [Custom49SDK logout];
	//[[NdComPlatform defaultPlatform] NdLogout:0];
}
void lib49app::switchUsers()
{
    [Custom49SDK showPlatformView];
}

void lib49app::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *pname = [[NSString alloc] initWithUTF8String:info.productName.c_str()];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];
    NSString* productid = [NSString stringWithUTF8String:info.productId.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
   
    NSString* orderId = [NSString stringWithFormat:@"%@-%@-%@",productid,serverid,uin];
    mBuyInfo = info;
    [Custom49SDK showPayViewWithOrderID:orderId productID:productid title:pname money:(int)info.productPrice playerID:uin serverID:serverid];
//    [Custom49SDK showPayViewWithOrderID:orderId productID:productid title:pname money:1 playerID:uin serverID:serverid];

}
const std::string& lib49app::loginUin()
{
    NSString *userID = [Custom49SDK getUserId];
    static std::string retStr;
    if(userID) retStr = [userID UTF8String];
    retStr = "49APPUSR_"+retStr;
    return retStr;
}
const std::string& lib49app::sessionID()
{
    
    NSString *sessionID = [Custom49SDK getSessionId];
    static std::string retStr;
    if(sessionID) retStr = (const char*)[sessionID UTF8String];
    return retStr;
}
const std::string& lib49app::nickName()
{
    NSString* retNS = [Custom49SDK getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void lib49app::openBBS()
{
	 //[[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
    //libOS::getInstance()->openURL("http://bbs.996.com/forum-mxhzw-1.html");
}


void lib49app::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void lib49app::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string lib49app::getClientChannel()
{
    return "49APP";
}
const unsigned int lib49app::getPlatformId()
{
    return 0u;
}

std::string lib49app::getPlatformMoneyName()
{
    return "RMB";
}
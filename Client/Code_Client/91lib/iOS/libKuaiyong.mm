#include "libKuaiyong.h"
#include "libKuaiyongObj.h"
#include <string>
#import "CustomKYSDK.h"
#include <com4lovesSDK.h>
#include <libOS.h>
libKuaiyongObj* s_libKuaiyongOjb;



void libKuaiyong::init(bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"dragonball_ios" ChannelID:@"901" PlatformID:@"ios_ky"];
    [com4lovesSDK  setAppId:@"dragonball"];
    [[CustomKYSDK shareSDK] initSDK];


    s_libKuaiyongOjb = [libKuaiyongObj new];
    [s_libKuaiyongOjb registerNotification];
    
  //[s_libKuaiyongOjb updateApp];
    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
}

void libKuaiyong::updateApp()
{
    //libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/iosyouaikuaiyong/index_ios.html");

}
void libKuaiyong::final()
{
    //[s_libPPOjb unregisterNotification];
}
bool libKuaiyong::getLogined()
{
   return [[CustomKYSDK shareSDK] isLogin];//[[
}
void libKuaiyong::login()
{
    if (![[CustomKYSDK shareSDK] isLogin]) {
        [[CustomKYSDK shareSDK] showLoginView];
    }}
void libKuaiyong::logout()
{
    [[CustomKYSDK shareSDK] logout];
}
void libKuaiyong::switchUsers()
{
    [[CustomKYSDK shareSDK] showPlatformView];
}

void libKuaiyong::buyGoods(BUYINFO& info)
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
    
//    NSString* orderId = [NSString stringWithFormat:@"%@-%@-%@",serverid,productid,uin];
    mBuyInfo = info;
    //   [Custom37SDK showPayViewWithOrderID:orderId productID:productid title:pname money:(int)info.productPrice playerID:uin serverID:serverid];
    [[CustomKYSDK shareSDK] showPayViewWithOrderID:billNO productID:productid title:pname money:(int)info.productPrice playerID:[[CustomKYSDK shareSDK] getUserId] serverID:serverid];
}
const std::string& libKuaiyong::loginUin()
{
    NSString *userID = [[CustomKYSDK shareSDK] getUserId];
    static std::string retStr;
    if(userID) retStr = [userID UTF8String];
    retStr = "KuaiyongUSR_"+retStr;
    return retStr;
}
const std::string& libKuaiyong::sessionID()
{
    
    NSString *sessionID = [[CustomKYSDK shareSDK] getSessionId];
    static std::string retStr;
    if(sessionID) retStr = (const char*)[sessionID UTF8String];
    return retStr;
}
const std::string& libKuaiyong::nickName()
{
    NSString* retNS = [[CustomKYSDK shareSDK] getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libKuaiyong::openBBS()
{
	 //[[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
}


void libKuaiyong::userFeedBack()
{
    
        [[com4lovesSDK sharedInstance] showFeedBack];
   
}
void libKuaiyong::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libKuaiyong::getClientChannel()
{
    return "KY";
}
const unsigned int libKuaiyong::getPlatformId()
{
    return 0u;
}

std::string libKuaiyong::getPlatformMoneyName()
{
    return "RMB";
}
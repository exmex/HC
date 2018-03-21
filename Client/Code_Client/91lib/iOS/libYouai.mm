#include "libYouai.h"
#include "libYouaiObj.h"
#include <string>
#include "libOS.h"

#include <com4lovesSDK.h>

libYouaiObj* s_libYouaiOjb;


void libYouai::init(bool isPrivateLogin )
{
    s_libYouaiOjb  =  [[libYouaiObj alloc]init];
    [s_libYouaiOjb initRegister];

    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"1000" PlatformID:@"ios_youai"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    
    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");

}

void libYouai::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/youai/index_ios.html");

#warning 小渠道的更新
#ifdef YOUAI_KUAIYONG
#endif
}
void libYouai::final()
{
    
}
bool libYouai::getLogined()
{
    return [[com4lovesSDK sharedInstance] getLogined] == YES;
}
void libYouai::login()
{
    if([[com4lovesSDK sharedInstance] getLogined] == NO)
        [[com4lovesSDK sharedInstance] Login];
}
void libYouai::logout()
{
    [[com4lovesSDK sharedInstance] showAccountManager];
}
void libYouai::switchUsers()
{
    [[com4lovesSDK sharedInstance] showAccountManager];
}

void libYouai::buyGoods(BUYINFO& info)
{
    NSString* productid = [NSString stringWithUTF8String:info.productId.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
    [[com4lovesSDK sharedInstance] iapBuy:productid serverID:serverid totalFee:info.productPrice orderId:@""];
    [s_libYouaiOjb setBuyInfo:info];
}
const std::string& libYouai::loginUin()
{
    static std::string ret;
    ret = std::string([[com4lovesSDK  getYouaiID] UTF8String]);
    return ret;
}
const std::string& libYouai::sessionID()
{
    static std::string ret = "";
    
   return ret;
}
const std::string& libYouai::nickName()
{
    static std::string ret;
    ret = std::string([[[com4lovesSDK sharedInstance] getLoginedUserName] UTF8String]);
    return ret;
}

void libYouai::openBBS()
{
    [[com4lovesSDK sharedInstance] showWeb:@"http://www.mxhzw.com"];
}


void libYouai::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libYouai::gamePause()
{
    
}
bool libYouai::getIsTryUser()
{
   return [[com4lovesSDK sharedInstance] getIsTryUser];
}
void libYouai::notifyEnterGame(){
    [[com4lovesSDK sharedInstance] notifyEnterGame];
};


const std::string libYouai::getClientChannel()
{
    return "youai";
}
const unsigned int libYouai::getPlatformId()
{
    return 0u;
}

std::string libYouai::getPlatformMoneyName()
{
    return "RMB";
}
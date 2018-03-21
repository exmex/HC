#include "libYouaiKY.h"
#include "libYouaiKYObj.h"
#include <string>
#include "libOS.h"

#include <com4lovesSDK.h>

libYouaiKYObj* s_libYouaiKYOjb;


void libYouaiKY::init(bool isPrivateLogin )
{
    s_libYouaiKYOjb  =  [libYouaiKYObj alloc];
    [s_libYouaiKYOjb initRegister];

    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"901" PlatformID:@"ios_ky"];
    [com4lovesSDK  setAppId:@"mxhzw"];
     [s_libYouaiKYOjb updateApp];
    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
}

void libYouaiKY::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/iosyouaikuaiyong/index_ios.html");
}
void libYouaiKY::final()
{
    
}
bool libYouaiKY::getLogined()
{
    return [[com4lovesSDK sharedInstance] getLogined] == YES;
}
void libYouaiKY::login()
{
    if([[com4lovesSDK sharedInstance] getLogined] == NO)
        [[com4lovesSDK sharedInstance] Login];
}
void libYouaiKY::logout()
{
    [[com4lovesSDK sharedInstance] showAccountManager];
}
void libYouaiKY::switchUsers()
{
    [[com4lovesSDK sharedInstance] showAccountManager];
}

void libYouaiKY::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    NSString* productid = [NSString stringWithUTF8String:info.productId.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
    NSString *billNO = [[NSString alloc] initWithUTF8String:info.cooOrderSerial.c_str()];
    [[com4lovesSDK sharedInstance] iapBuy:productid serverID:serverid totalFee:info.productPrice orderId:billNO];
    [s_libYouaiKYOjb setBuyInfo:info];
}
const std::string& libYouaiKY::loginUin()
{
    static std::string ret;
    ret = std::string([[com4lovesSDK  getYouaiID] UTF8String]);
    return ret;
}
const std::string& libYouaiKY::sessionID()
{
    static std::string ret = "";
    
   return ret;
}
const std::string& libYouaiKY::nickName()
{
    static std::string ret;
    ret = std::string([[[com4lovesSDK sharedInstance] getLoginedUserName] UTF8String]);
    return ret;
}

void libYouaiKY::openBBS()
{
    [[com4lovesSDK sharedInstance] showWeb:@"http://www.mxhzw.com"];
}


void libYouaiKY::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libYouaiKY::gamePause()
{
    
}
bool libYouaiKY::getIsTryUser()
{
   return [[com4lovesSDK sharedInstance] getIsTryUser];
}
void libYouaiKY::notifyEnterGame(){
    [[com4lovesSDK sharedInstance] notifyEnterGame];
};


const std::string libYouaiKY::getClientChannel()
{
    return "KY";
}
const unsigned int libYouaiKY::getPlatformId()
{
    return 0u;
}

std::string libYouaiKY::getPlatformMoneyName()
{
    return "RMB";
}
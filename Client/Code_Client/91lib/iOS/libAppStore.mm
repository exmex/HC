#include "libAppStore.h"
#include "libAppStoreObj.h"
#include <string>
#include "libOS.h"

#include <com4lovesSDK.h>

libAppStoreObj* s_libAppStoreOjb;


void libAppStore::init(bool isPrivateLogin )
{
    s_libAppStoreOjb  =  [[libAppStoreObj alloc]init];
    [s_libAppStoreOjb initRegister];

    [com4lovesSDK  setSDKAppID:@"26" SDKAPPKey:@"champions_app" ChannelID:@"902" PlatformID:@"ios_appstore"];
    [com4lovesSDK  setAppId:@"champions_app"];

    libPlatformManager::getPlatform()->_boardcastInitDone(true,"");
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
    
}

void libAppStore::updateApp()
{
    //libOS::getInstance()->openURL("https://itunes.apple.com/us/app/meng-xiang-hai-zei-wang/id659822566?ls=1&mt=8");
}
void libAppStore::final()
{
    
}
bool libAppStore::getLogined()
{
    return [[com4lovesSDK sharedInstance] getLogined] == YES;
}
void libAppStore::login()
{
    if([[com4lovesSDK sharedInstance] getLogined] == NO)
        [[com4lovesSDK sharedInstance] Login];
}
void libAppStore::logout()
{
    [[com4lovesSDK sharedInstance] showAccountManager];
}
void libAppStore::switchUsers()
{
    if([[com4lovesSDK sharedInstance] getLogined] == NO)
        [[com4lovesSDK sharedInstance] Login];
    else
        [[com4lovesSDK sharedInstance] showChooseBinding];
}

void libAppStore::buyGoods(BUYINFO& info)
{
    std::string pductID = info.productId/*+".nuclear.leagueofchampions"*/;
    NSString* productid = [NSString stringWithUTF8String:pductID.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
    NSLog(@"pd:%@",productid);
    [[com4lovesSDK sharedInstance] appStoreBuy:productid serverID:serverid totalFee:info.productPrice orderId:@""];
    [s_libAppStoreOjb setBuyInfo:info];
}
const std::string& libAppStore::loginUin()
{
    static std::string ret;
    ret = std::string([[com4lovesSDK  getYouaiID] UTF8String]);
    return ret;
}
const std::string& libAppStore::sessionID()
{
    static std::string ret = "";
    
   return ret;
}
const std::string& libAppStore::nickName()
{
    static std::string ret;
    ret = std::string([[[com4lovesSDK sharedInstance] getLoginedUserName] UTF8String]);
    return ret;
}

void libAppStore::openBBS()
{
    //[[com4lovesSDK sharedInstance] showWeb:@"http://www.mxhzw.com"];
    [s_libAppStoreOjb onPresent];
}


void libAppStore::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libAppStore::gamePause()
{
    
}
bool libAppStore::getIsTryUser()
{
   return [[com4lovesSDK sharedInstance] getIsTryUser];
}
void libAppStore::notifyEnterGame(){
    [[com4lovesSDK sharedInstance] notifyEnterGame];
};


const std::string libAppStore::getClientChannel()
{
#ifdef LibAppStoreTW
    return "tw";
#else
    return "AppStore";
#endif
}
const unsigned int libAppStore::getPlatformId()
{
    return 0u;
}

std::string libAppStore::getPlatformMoneyName()
{
#ifdef LibAppStoreTW
    return "NT$";
#else
    return "RMB";
#endif
}
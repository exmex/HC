#include "libCmge.h"
#include "libCmgeObj.h"
#include <string>
#include "libOS.h"
#import <Cmge/Cmge.h>
#include <com4lovesSDK.h>

libCmgeObj* s_libCmgeOjb;


void libCmge::init(bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_cmge"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    CmgeProject *project = [[[CmgeProject alloc] init] autorelease];
    project.projectId = @"P10025";
    project.gameId = @"D10011";
    project.isOnlineGame = YES;
    [[CmgePlatform defaultPlatform] setProject:project];
    [[CmgePlatform defaultPlatform] setViewOrientation:UIInterfaceOrientationMaskLandscape];

    s_libCmgeOjb = [libCmgeObj new];
    [s_libCmgeOjb registerNotification];

    [s_libCmgeOjb SNSInitResult:0];
}

void libCmge::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/huoying/download/pp/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libPPOjb];
    //[s_libPPOjb updateApp];
}
void libCmge::final()
{
    //[s_libPPOjb unregisterNotification];
}
bool libCmge::getLogined()
{
    return mEnableLogin;//[[NdComPlatform defaultPlatform] isLogined];
}
void libCmge::login()
{
   [[CmgePlatform defaultPlatform] enterLoginView];
}
void libCmge::logout()
{
	//[[NdComPlatform defaultPlatform] NdLogout:0];
}
void libCmge::switchUsers()
{
    [[CmgePlatform defaultPlatform] enterLoginView];
}

void libCmge::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *billNO = [[NSString alloc] initWithUTF8String:info.cooOrderSerial.c_str()];
    NSString *pname = [[NSString alloc] initWithUTF8String:info.productName.c_str()];
    NSString *priStr = [NSString stringWithFormat:@"%.2lf",info.productPrice ];
    NSString *_price = [[NSString alloc] initWithFormat:@"%@",priStr];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];
    int zoneID = 0;
    sscanf(info.description.c_str(),"%d",&zoneID);
    mBuyInfo = info;
    //调出充值并且兑换接口
    //[[PPWebView sharedInstance] rechargeAndExchangeWebShow:billNO BillNoTitle:pname PayMoney:_price
                                                    //RoleId:uin ZoneId:zoneID];

}
const std::string& libCmge::loginUin()
{
    int userID = 01;
    [[CmgePlatform defaultPlatform] enterLoginView];
    NSString* retNS = [[NSString alloc] initWithFormat:@"%d",userID];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "CMGEUSR_"+retStr;
    return retStr;
}
const std::string& libCmge::sessionID()
{
    
    int sessionID = 01;
    
    NSString* retNS = [[NSString alloc] initWithFormat:@"%d",sessionID];
    static std::string retStr;
    if(retNS) retStr = (const char*)[retNS UTF8String];
    return retStr;
}
const std::string& libCmge::nickName()
{
    NSString* retNS = [[CmgePlatform defaultPlatform] getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libCmge::openBBS()
{
	 //[[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
}


void libCmge::userFeedBack()
{
    //[[NdComPlatform defaultPlatform] NdUserFeedBack];
}
void libCmge::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libCmge::getClientChannel()
{
    return "CMGE";
}
const unsigned int libCmge::getPlatformId()
{
    return 0u;
}

std::string libCmge::getPlatformMoneyName()
{
    return "RMB";
}
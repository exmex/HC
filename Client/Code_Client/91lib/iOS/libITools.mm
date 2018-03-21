#include "libITools.h"
#include "libIToolsObj.h"
#include <string>
#include "libOS.h"
#import "IToolsSDK/HXAppPlatformKitPro.h"
#include <com4lovesSDK.h>

libIToolsObj* s_libIToolsOjb;


void libITools::init(bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"dragonball_ios" ChannelID:@"0" PlatformID:@"ios_ito"];
    [com4lovesSDK  setAppId:@"dragonball"];
    mEnableLogin=false;
    //设置支持的方向
    [HXAppPlatformKitPro setAppId:104 appKey:@"A341FA1280368E88BAEB096D6774F308"];
    [HXAppPlatformKitPro setSupportOrientationPortrait:YES portraitUpsideDown:NO landscapeLeft:NO landscapeRight:NO];
    
    s_libIToolsOjb = [libIToolsObj new];

    [s_libIToolsOjb SNSInitResult:0];

}

void libITools::updateApp()
{
    //libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/itools/index_ios.html");
}
void libITools::final()
{
    [s_libIToolsOjb unregisterNotification];
}
bool libITools::getLogined()
{
    return mEnableLogin;//[[NdComPlatform defaultPlatform] isLogined];
}
void libITools::login()
{
   [HXAppPlatformKitPro showLoginView];
}
void libITools::logout()
{
    [HXAppPlatformKitPro logout];
}
void libITools::switchUsers()
{
    if (mEnableLogin)
    {
      [HXAppPlatformKitPro showPlatformView];
    }
    else
    {
      [HXAppPlatformKitPro showLoginView];
    }
	
}

void libITools::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *billNO = [[NSString alloc] initWithUTF8String:info.cooOrderSerial.c_str()];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];
    int zoneID = 0;
    sscanf(info.description.c_str(),"%d",&zoneID);
    NSString *payDes=[NSString stringWithFormat:@"%d_%@",zoneID,billNO];
    mBuyInfo = info;
    //调出充值并且兑换接口
    /*
     [[PPWebView sharedInstance] rechargeAndExchangeWebShow:billNO BillNoTitle:pname PayMoney:_price
     RoleId:uin ZoneId:zoneID];
    */
    //[[TBPlatform defaultPlatform] TBUniPayForCoin:billNO needPayRMB:info.productPrice payDescription:payDes delegate:s_libTBOjb];
    //[HXAppPlatformKitPro setPayViewAccount:@"test" amount:1.0 orderIdCom:orderId];
    [HXAppPlatformKitPro setPayViewAmount:info.productPrice orderIdCom:payDes];

}
const std::string& libITools::loginUin()
{
    NSString* retNS = [HXAppPlatformKitPro getUserId];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "ITOUSR_"+retStr;
    return retStr;
}
const std::string& libITools::sessionID()
{
    NSString* retNS = [HXAppPlatformKitPro getSessionId];
    static std::string retStr;
    if(retNS) retStr = (const char*)[retNS UTF8String];
    return retStr;
}
const std::string& libITools::nickName()
{
    //NSString* retNS = [[TBPlatform defaultPlatform] nickName];
    NSString* retNS = [HXAppPlatformKitPro getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libITools::openBBS()
{
    /*在进入用户中心后，有配置论坛的情况下可以选择）;*/
//	int bbsResult = [[TBPlatform defaultPlatform] TBEnterAppBBS:0];
//	if (bbsResult == TB_PLATFORM_NO_BBS)
//    {
//		//[self showMessage:@"该游戏未配置论坛"];
//	}
}


void libITools::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libITools::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libITools::getClientChannel()
{
    return "ITO";
}
const unsigned int libITools::getPlatformId()
{
    return 0u;
}

std::string libITools::getPlatformMoneyName()
{
    return "RMB";
}
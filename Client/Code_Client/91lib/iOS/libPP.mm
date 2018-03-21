#include "libPP.h"
#include "libPPObj.h"
#include <string>
#include "libOS.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#include <com4lovesSDK.h>

libPPObj* s_libPPOjb;


void libPP::init(bool isPrivateLogin )
{

     mEnableLogin = false;
    /**
     *必须写在程序window初始化之后。详情请commad + 鼠标左键 点击查看接口注释
     *初始化应用的AppId和AppKey。从开发者中心游戏列表获取（https://pay.25pp.com）
     *设置是否打印日志在控制台
     *设置充值页面初始化金额
     *是否需要客户端补发订单（详情请查阅接口注释）
     *用户注销后是否自动push出登陆界面
     *是否开放充值页面【操作在按钮被弹窗】
     *若关闭充值响应的提示语
     *初始化SDK界面代码
     */
    
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"dragonball_ios" ChannelID:@"0" PlatformID:@"ios_pp"];
    [com4lovesSDK  setAppId:@"dragonball"];
    
    [[PPAppPlatformKit sharedInstance] setAppId:3055 AppKey:@"3f5d47f23e35affdf85bb316f1f0ad3d"];
    [[PPAppPlatformKit sharedInstance] setIsNSlogData:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:YES];
    [[PPUIKit sharedInstance] checkGameUpdate];
    
    [[PPAppPlatformKit sharedInstance] setRechargeAmount:10];
    [[PPAppPlatformKit sharedInstance] setIsLongComet:YES];
    
    
    s_libPPOjb = [libPPObj new];
    [s_libPPOjb SNSInitResult:0];
    [s_libPPOjb registerNotification];
    [[PPAppPlatformKit sharedInstance] setDelegate:s_libPPOjb];
    
}

void libPP::updateApp()
{
    //libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/pp/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libPPOjb];
    //[s_libPPOjb updateApp];
}
void libPP::final()
{
    //[s_libPPOjb unregisterNotification];
}
bool libPP::getLogined()
{
    return mEnableLogin;//[[NdComPlatform defaultPlatform] isLogined];
}
void libPP::login()
{
    [[PPAppPlatformKit sharedInstance] showLogin];
//   [[PPLoginView sharedInstance] showLoginViewByRight];
}
void libPP::logout()
{
	//[[NdComPlatform defaultPlatform] NdLogout:0];
}
void libPP::switchUsers()
{
    if(mEnableLogin)
    {
//        [[PPCenterView sharedInstance] showCenterViewByRight];
        [[PPAppPlatformKit sharedInstance] showCenter];
    }
    else
    {
//        [[PPLoginView sharedInstance] showLoginViewByRight];
        [[PPAppPlatformKit sharedInstance] showLogin];
    }
}

void libPP::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *billNO = [[NSString alloc] initWithUTF8String:info.cooOrderSerial.c_str()];
    NSString *pname = [[NSString alloc] initWithUTF8String:info.productName.c_str()];
    //    NSString *priStr = [NSString stringWithFormat:@"%.2lf",info.productPrice ];
    //    NSString *_price = [[NSString alloc] initWithFormat:@"%@",priStr];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];
    int zoneID = 0;
    sscanf(info.description.c_str(),"%d",&zoneID);
    mBuyInfo = info;
    //调出充值并且兑换接口
    //    [[PPWebView sharedInstance] rechargeAndExchangeWebShow:billNO BillNoTitle:pname PayMoney:_price    RoleId:uin ZoneId:zoneID];
    //    NSLog(@"%f  %@  %@  %@  %d",info.productPrice ,billNO,pname,uin,zoneID);
    [[PPAppPlatformKit sharedInstance] exchangeGoods:info.productPrice BillNo:billNO BillTitle:pname RoleId:uin ZoneId:zoneID];
}
const std::string& libPP::loginUin()
{
    NSString* retNS = [s_libPPOjb getUserID];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "PPUSR_"+retStr;
    return retStr;
}
const std::string& libPP::sessionID()
{
    static std::string retStr = "";
    return retStr;
}
const std::string& libPP::nickName()
{
    NSString* retNS = [s_libPPOjb getUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libPP::openBBS()
{
	 //libOS::getInstance()->openURL("http://bbs.996.com/forum-mxhzw-1.html");
}


void libPP::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libPP::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libPP::getClientChannel()
{
    return "PP";
}
const unsigned int libPP::getPlatformId()
{
    return 0u;
}

std::string libPP::getPlatformMoneyName()
{
    return "PP币";
}
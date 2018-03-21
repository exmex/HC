#include "libAG.h"
#include "libAGObj.h"
#include <string>
#include "libOS.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#include <com4lovesSDK.h>

libAGObj* s_libAGOjb;


void libAG::init(bool isPrivateLogin )
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
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_ag"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    [[PPAppPlatformKit sharedInstance] setAppId:1075 AppKey:@"10e34c505d9c7c15936de41bfe67b413"];
    [[PPAppPlatformKit sharedInstance] setIsNSlogData:YES];

    //[[PPAppPlatformKit sharedInstance] setIsLogOutPushLoginView:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:YES];
    //[[PPAppPlatformKit sharedInstance] setCloseRechargeAlertMessage:@"关闭充值提示语"];
    
    [[PPAppPlatformKit sharedInstance] setRechargeAmount:10];
    [[PPAppPlatformKit sharedInstance] setIsLongComet:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:YES];
    [PPUIKit sharedInstance];

    s_libAGOjb = [libAGObj new];
  
    [[PPUIKit sharedInstance] checkGameUpdate];

    
    [s_libAGOjb SNSInitResult:0];
    [s_libAGOjb registerNotification];
    [[PPAppPlatformKit sharedInstance] setDelegate:s_libAGOjb];
    
}

void libAG::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/ag/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libAGOjb];
    //[s_libAGOjb updateApp];
}
void libAG::final()
{
    //[s_libAGOjb unregisterNotification];
}
bool libAG::getLogined()
{
    return mEnableLogin;//[[NdComPlatform defaultPlatform] isLogined];
}
void libAG::login()
{
    [[PPAppPlatformKit sharedInstance] showLogin];
//   [[PPLoginView sharedInstance] showLoginViewByRight];
}
void libAG::logout()
{
	//[[NdComPlatform defaultPlatform] NdLogout:0];
}
void libAG::switchUsers()
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

void libAG::buyGoods(BUYINFO& info)
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
    [[PPAppPlatformKit sharedInstance] exchangeGoods:info.productPrice BillNo:billNO BillTitle:pname RoleId:uin ZoneId:zoneID];
}
const std::string& libAG::loginUin()
{
    int userID = [[PPAppPlatformKit sharedInstance] currentUserId];

    NSString* retNS = [[NSString alloc] initWithFormat:@"%d",userID];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "AGUSR_"+retStr;
    return retStr;
}
const std::string& libAG::sessionID()
{
    static std::string retStr = "";
    return retStr;
}
const std::string& libAG::nickName()
{
    NSString* retNS = [[PPAppPlatformKit sharedInstance] currentUserName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libAG::openBBS()
{
	 libOS::getInstance()->openURL("http://bbs.996.com/forum-mxhzw-1.html");
}


void libAG::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libAG::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libAG::getClientChannel()
{
    return "AppleGarden";
}

const unsigned int libAG::getPlatformId()
{
    return 0u;
}
std::string libAG::getPlatformMoneyName()
{
    return "PP币";
}
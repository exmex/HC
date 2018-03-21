#include "libUC.h"
#include "libUCObj.h"
#include <string>
#include "libOS.h"
#import <CommonCrypto/CommonDigest.h>
#import <UCGameSdk/UCGameSdk.h>
#include <com4lovesSDK.h>


libUCObj* s_libUCOjb;


void libUC::init(bool isPrivateLogin )
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
    
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_uc"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    
    
    UCGameSdk *sdk = [UCGameSdk defaultSDK];
    
    sdk.cpId = uccpid;          // 将 UC 分配的 Cp ID 赋值给 sdk.cpId 属性
    sdk.gameId = ucgameId;       // 将 UC 分配的 Game ID 赋值给 sdk.gameId 属性
    sdk.serverId = ucserverId;     // 将 UC 分配的 Server ID 赋值给 sdk.serverId 属性

#warning DEBUG
    sdk.isDebug = NO;  // 是否启用调试模式，如果启用调试模式，SDK访问的服务器将SDK的测试服务器
    sdk.logLevel = UCLOG_LEVEL_DEBUG;   // 日志级别，控制sdk自身日志的输出
    sdk.gameName = @"梦想海贼王";
    sdk.allowGameUserLogin = NO;  // 是否允许官方账号登录，如果允许，请传 YES
    sdk.gameUserName = @"梦想海贼王";           // 游戏名称
    sdk.allowChangeAccount = YES;   // 是否允许切换帐号，YES 为允许，NO 为不允许。如果允许，请处理用户注销的情况
    
    sdk.orientation = UC_PORTRAIT_UP;
    
    //设置悬浮按钮是否显示,默认不显示
    sdk.isShowFloatButton = YES;
    //设置悬浮按钮的初始位置，x只能是0或100，0代表左边，100代表右边；y为0~100，0表示最上面，100表示最下面
    //默认是在屏幕右边的中间，即(100,50)，如果设置的范围不对，也按此值显示
    CGPoint floatPosition = CGPointMake(100, 20);
   
    sdk.floatButtonPosition = floatPosition;
    
    [sdk initSDK];      // 开始初始化操作

    s_libUCOjb = [libUCObj new];
    [s_libUCOjb registerNotification];

    [s_libUCOjb SNSInitResult:0];
}

void libUC::updateApp()
{
    libOS::getInstance()->openURL("http://1251001040.imgcache.qzoneapp.com/1251001040/download/uc/index_ios.html");
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libUCOjb];
    //[s_libUCOjb updateApp];
}
void libUC::final()
{
    //[s_libUCOjb unregisterNotification];
}
bool libUC::getLogined()
{
    return [[s_libUCOjb getNickName] length]>0;//[[NdComPlatform defaultPlatform] isLogined];
}
void libUC::login()
{
    if (!getLogined())
    {
        [[UCGameSdk defaultSDK] login];
    }
}
void libUC::logout()
{
    if ([UCGameSdk defaultSDK].sid != nil && [UCGameSdk defaultSDK].sid.length >= 1)
    {
        [[UCGameSdk defaultSDK] logout];
    }
}
void libUC::switchUsers()
{
    if (getLogined()) {
        [[UCGameSdk defaultSDK] enterUserCenter];
    }else{
        [[UCGameSdk defaultSDK] login];
    }
}

void libUC::buyGoods(BUYINFO& info)
{
    if(info.cooOrderSerial=="")
    {
        info.cooOrderSerial = libOS::getInstance()->generateSerial();
    }
    //设置订单号
    NSString *pname = [[NSString alloc] initWithUTF8String:info.productName.c_str()];
    NSString *priStr = [NSString stringWithFormat:@"%.2lf",info.productPrice ];
//    NSString *priStr = [NSString stringWithFormat:@"%.2lf",1.0 ];
    NSString *uin = [[NSString alloc] initWithUTF8String:loginUin().c_str()];

    //设置订单号
    NSString* productid = [NSString stringWithUTF8String:info.productId.c_str()];
    NSString* serverid = [NSString stringWithUTF8String:info.description.c_str()];
    
    mBuyInfo = info;
    //调出充值并且兑换接口
    NSString* orderId = [NSString stringWithFormat:@"%@-%@-%@",serverid,productid,uin];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:YES],
                          UCG_SDK_KEY_PAY_ALLOW_CONTINUOUS_PAY,
                          orderId, UCG_SDK_KEY_PAY_CUSTOM_INFO,
                          uin, UCG_SDK_KEY_PAY_ROLE_ID,
                          pname, UCG_SDK_KEY_PAY_ROLE_NAME,
                          priStr, UCG_SDK_KEY_PAY_AMOUNT, nil];
    NSLog(@"order %@",dict);
    [[UCGameSdk defaultSDK] payWithPaymentInfo:dict];
}
const std::string& libUC::loginUin()
{
    NSString* retNS = [s_libUCOjb getUserID];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "IUCUSR_"+retStr;
    return retStr;
}
const std::string& libUC::sessionID()
{
    NSString* retNS = [[UCGameSdk defaultSDK] sid];
    static std::string retStr;
    if(retNS) retStr = (const char*)[retNS UTF8String];
    return retStr;
}
const std::string& libUC::nickName()
{
    NSString* retNS = [s_libUCOjb getNickName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libUC::openBBS()
{
	 //[[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
    libOS::getInstance()->openURL("http://bbs.9game.cn/forum-1019-1.html");
}

void libUC::userFeedBack()
{
    //[[com4lovesSDK sharedInstance] showFeedBack];
    libOS::getInstance()->openURL("http://bbs.9game.cn/forum-1019-1.html");
}
void libUC::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libUC::getClientChannel()
{
    return "UC";
}
const unsigned int libUC::getPlatformId()
{
    return 0u;
}

std::string libUC::getPlatformMoneyName()
{
    return "RMB";
}
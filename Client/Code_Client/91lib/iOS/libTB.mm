#include "libTB.h"
#include "libTBObj.h"
#include <string>
#include "libOS.h"
#import <TBPlatform/TBPlatform.h>
#include <com4lovesSDK.h>

libTBObj* s_libTBOjb;


void libTB::init(bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"dragonball_ios" ChannelID:@"0" PlatformID:@"ios_tb"];
    [com4lovesSDK  setAppId:@"dragonball"];
    mEnableLogin = false;
    NSLog(@"SDK Version:%@",[TBPlatform  version]);
    /*开启调试模式，正式发布前需要注释该行代码*/
    //[[TBPlatform defaultPlatform] TBSetDebugMode:0];
    
    /*~~~~~~~~~~调用其他平台接口前，必须先对平台进行初始化~~~~~~~~~~*/
    [[TBPlatform defaultPlatform] TBInitPlatformWithAppID:140317
                                        screenOrientation:UIDeviceOrientationPortrait
                          isContinueWhenCheckUpdateFailed:NO];
    
	/* 游戏开发者应在游戏启动时优先设置申请的AppID*/
	//[[TBPlatform defaultPlatform] setAppId:130729];
    
	/* 设置是否支持自动旋转 （新增接口）*/
    [[TBPlatform defaultPlatform] TBSetAutoRotation:YES];
//    if ([[UIDevice currentDevice]systemVersion].floatValue >= 6.0){
        [[TBPlatform defaultPlatform] TBSetAutoRotation:NO];
//    }
    
	/* 设置界面初始方向*/
    //[[TBPlatform defaultPlatform] TBSetScreenOrientation:UIDeviceOrientationPortrait];
    
    s_libTBOjb = [libTBObj new];

    [s_libTBOjb SNSInitResult:0];
    
    //[[TBPlatform defaultPlatform] TBAppVersionUpdate:0 delegate:s_libTBOjb];

}

void libTB::updateApp()
{
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libPPOjb];
    /*新接口*/
    /*
    [[TBPlatform defaultPlatform] TBAppVersionUpdate:0 delegate:s_libTBOjb];
    [s_libTBOjb updateApp];
    */
    
}
void libTB::final()
{
    [s_libTBOjb unregisterNotification];
}
bool libTB::getLogined()
{
    return [[TBPlatform defaultPlatform] TBIsLogined];//[[NdComPlatform defaultPlatform] isLogined];
}
void libTB::login()
{
   [[TBPlatform defaultPlatform] TBLogin:0];
}
void libTB::logout()
{
    [[TBPlatform defaultPlatform] TBSwitchAccount];
}
void libTB::switchUsers()
{
     
    if ([[TBPlatform defaultPlatform] TBIsLogined])
    {
        [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
    }
    else
    {
        [[TBPlatform defaultPlatform] TBLogin:0];
    }
	
}

void libTB::buyGoods(BUYINFO& info)
{
    NSString *urlString = [NSString stringWithFormat:@"http://tgi.tongbu.com/check.aspx?k=%@",
                           [[TBPlatform defaultPlatform] sessionID]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:15.f];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:s_libTBOjb];
    if (!conn)
    {
        NSString *title = @"核对Session失败，请检查网络";
        std::string out = [title UTF8String];
        libPlatformManager::getPlatform()->_boardcastLoginResult(false,out);
        [[TBPlatform defaultPlatform] TBSwitchAccount];
    }
    else
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
        NSString *payDes=[NSString stringWithFormat:@"ID:%@|SERVER:%d",uin,zoneID];
        mBuyInfo = info;
        //调出充值并且兑换接口
        /*
         [[PPWebView sharedInstance] rechargeAndExchangeWebShow:billNO BillNoTitle:pname PayMoney:_price
         RoleId:uin ZoneId:zoneID];
         */
        [[TBPlatform defaultPlatform] TBUniPayForCoin:billNO needPayRMB:info.productPrice payDescription:payDes delegate:s_libTBOjb];
    }

}
const std::string& libTB::loginUin()
{
    NSString* retNS = [[[TBPlatform defaultPlatform] TBGetMyInfo] userID];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "TBUSR_"+retStr;
    return retStr;
}
const std::string& libTB::sessionID()
{
    NSString* retNS = [[TBPlatform defaultPlatform] sessionID];
    static std::string retStr;
    if(retNS) retStr = (const char*)[retNS UTF8String];
    return retStr;
}
const std::string& libTB::nickName()
{
    NSString* retNS = [[TBPlatform defaultPlatform] nickName];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return retStr;
}

void libTB::openBBS()
{
    /*在进入用户中心后，有配置论坛的情况下可以选择）;*/
	int bbsResult = [[TBPlatform defaultPlatform] TBEnterAppBBS:0];
//	if (bbsResult == TB_PLATFORM_NO_BBS)
//    {
//		//[self showMessage:@"该游戏未配置论坛"];
//	}
}


void libTB::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libTB::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libTB::getClientChannel()
{
    return "TB";
}
const unsigned int libTB::getPlatformId()
{
    return 0u;
}

std::string libTB::getPlatformMoneyName()
{
    return "推币";
}
#include "libDownJoy.h"
#include "libDownJoyObj.h"
#include <string>
#include "libOS.h"
#import <DownjoySDK/DJPlatform.h>
#import <DownjoySDK/DJPlatformNotification.h>
#import <DownjoySDK/UserInfomation.h>
#include <com4lovesSDK.h>
libDownJoyObj* s_libDownJoyOjb;


void libDownJoy::init(bool isPrivateLogin )
{
    [com4lovesSDK  setSDKAppID:@"1" SDKAPPKey:@"mxhzw_ios" ChannelID:@"0" PlatformID:@"ios_idl"];
    [com4lovesSDK  setAppId:@"mxhzw"];
    
    mEnableLogin = false;
    [[DJPlatform defaultDJPlatform] setAppId:AppId];
    [[DJPlatform defaultDJPlatform] setAppKey:AppKey];
    [[DJPlatform defaultDJPlatform] setMerchantId:MerchantId];
    [[DJPlatform defaultDJPlatform] setServerId:@"1"];
    [[DJPlatform defaultDJPlatform] setAppScheme:@"haizeiwangDownjoy"];
    [[DJPlatform defaultDJPlatform] setTapBackgroundHideView:YES];
    
    s_libDownJoyOjb = [libDownJoyObj new];

    [s_libDownJoyOjb SNSInitResult:0];

}

void libDownJoy::updateApp()
{
    //[[NdComPlatform defaultPlatform] NdAppVersionUpdate:0 delegate:s_libPPOjb];
    /*新接口*/
    /*
    [[TBPlatform defaultPlatform] TBAppVersionUpdate:0 delegate:s_libTBOjb];
    [s_libTBOjb updateApp];
    */
    
}
void libDownJoy::final()
{
    [s_libDownJoyOjb unregisterNotification];
}
bool libDownJoy::getLogined()
{
    return [[DJPlatform defaultDJPlatform] DJCheckLoginStatus];
}
void libDownJoy::login()
{
   [[DJPlatform defaultDJPlatform] DJLogin];
}
void libDownJoy::logout()
{
    [[DJPlatform defaultDJPlatform] DJLogout];
}
void libDownJoy::switchUsers()
{
    if ([[DJPlatform defaultDJPlatform] DJCheckLoginStatus])
    {
        [[DJPlatform defaultDJPlatform] appearDJMemberCenter];
    }
    else
    {
        [[DJPlatform defaultDJPlatform] DJLogin];
    }
	
}

void libDownJoy::buyGoods(BUYINFO& info)
{
    if(![[DJPlatform defaultDJPlatform] DJCheckLoginStatus])
    {
        NSString *title = @"核对Token失败，请检查网络";
        std::string out = [title UTF8String];
        libPlatformManager::getPlatform()->_boardcastLoginResult(false,out);
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
        
        mBuyInfo = info;
        NSString *payDes=[NSString stringWithFormat:@"%d-%@",zoneID,[NSString stringWithUTF8String:info.productId.c_str()]];
        //调出充值并且兑换接口
        [[DJPlatform defaultDJPlatform] DJPayment:info.productPrice productName:[NSString stringWithUTF8String:info.productName.c_str()] extInfo:payDes];
    }

}
const std::string& libDownJoy::loginUin()
{
    NSString* retNS = [[DJPlatform defaultDJPlatform] currentMemberId];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    retStr = "IDLUSR_"+mUin;
    return retStr;
}
const std::string& libDownJoy::sessionID()
{
    //￼NSString* retNS = [[DJPlatform defaultDJPlatform] currentToken];
    //static std::string retStr;
    //if(retNS) retStr = (const char*)[retNS UTF8String];
    return nil;
}
const std::string& libDownJoy::nickName()
{
    NSString* retNS = [[DJPlatform defaultDJPlatform] currentMemberId];
    static std::string retStr;
    if(retNS) retStr = [retNS UTF8String];
    return mNickName;
}



void libDownJoy::openBBS()
{
    /*在进入用户中心后，有配置论坛的情况下可以选择）;*/
	/*
     int bbsResult = [[TBPlatform defaultPlatform] TBEnterAppBBS:0];
	if (bbsResult == TB_PLATFORM_NO_BBS)
    {
		//[self showMessage:@"该游戏未配置论坛"];
	}
     */
}


void libDownJoy::userFeedBack()
{
    [[com4lovesSDK sharedInstance] showFeedBack];
}
void libDownJoy::gamePause()
{
    //[[NdComPlatform defaultPlatform] NdPause];
}

const std::string libDownJoy::getClientChannel()
{
    return "dl";
}
const unsigned int libDownJoy::getPlatformId()
{
    return 0u;
}

std::string libDownJoy::getPlatformMoneyName()
{
    return "￥";
}
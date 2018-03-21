//
//  lib91Obj.m
//  lib91
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "lib91.h"
#import "lib91Obj.h"



@implementation lib91Obj
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
	lib91* plat91 = dynamic_cast<lib91*>(libPlatformManager::getPlatform());
	if(plat91)
	{
		plat91->_enableLogin();
	}
	libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:(NSString*)kNdCPLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NdUniPayAysnResult:) name:(NSString*)kNdCPBuyResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlatformLogout:) name:(NSString*)kNdCPLeavePlatformNotification object:nil];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    //[self.view addSubview:waitView];//添加该waitView
    if ([[UIDevice currentDevice] systemVersion].floatValue<=4.4) {
        [waitView setBounds:CGRectMake(0, 0, 50, 50)];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
}

-(void) unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPBuyResultNotification object:nil];
}

- (void)PlatformLogout:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}
//登录
- (void)SNSLoginResult:(NSNotification *)notify
{
	NSDictionary *dict = [notify userInfo];
	BOOL success = [[dict objectForKey:@"result"] boolValue];
	NdGuestAccountStatus* guestStatus = (NdGuestAccountStatus*)[dict objectForKey:@"NdGuestAccountStatus"];
	
	
	//登录成功后处理
	if([[NdComPlatform defaultPlatform] isLogined] && success) {
		
		//也可以通过[[NdComPlatform defaultPlatform] getCurrentLoginState]判断是否游客登录状态
		if (guestStatus) {
			NSString* strTip = nil;
            bool ret = true;
			if ([guestStatus isGuestLogined]) {
				strTip = [NSString stringWithFormat:@"游客账号登录成功"];
                ret = false;
			}
			else if ([guestStatus isGuestRegistered]) {
				strTip = [NSString stringWithFormat:@"游客成功注册为普通账号"];
			}
            std::string out = [strTip UTF8String];
           libPlatformManager::getPlatform()->_boardcastLoginResult(ret, out);
			
		}
		else {
            NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
			std::string out = [strTip UTF8String];
            libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
		}
	}
	//登录失败处理和相应提示
	else {
		int error = [[dict objectForKey:@"error"] intValue];
		NSString* strTip = [NSString stringWithFormat:@"登录失败, error=%d", error];
		switch (error) {
			case ND_COM_PLATFORM_ERROR_USER_CANCEL://用户取消登录
				if (([[NdComPlatform defaultPlatform] getCurrentLoginState] == ND_LOGIN_STATE_GUEST_LOGIN)) {
					strTip =  @"当前仍处于游客登录状态";
				}
				else {
					strTip = @"用户未登录";
				}
				break;
				
				// {{ for demo tip
			case ND_COM_PLATFORM_ERROR_APP_KEY_INVALID://appId未授权接入, 或appKey 无效
				strTip = @"登录失败, 请检查appId/appKey";
				break;
			case ND_COM_PLATFORM_ERROR_CLIENT_APP_ID_INVALID://无效的应用ID
				strTip = @"登录失败, 无效的应用ID";
				break;
			case ND_COM_PLATFORM_ERROR_HAS_ASSOCIATE_91:
				strTip = @"有关联的91账号，不能以游客方式登录";
				break;
				
				// }}
			default:
				break;
		}
		
        std::string out = [strTip UTF8String];
        libPlatformManager::getPlatform()->_boardcastLoginResult(false, out);
	}
}

-(void)NdUniPayAysnResult:(NSNotification*)notify
{
    NSDictionary *dic = [notify userInfo];
    NdBuyInfo* buyinfo = (NdBuyInfo*)[dic objectForKey:@"buyInfo"];
    BUYINFO info;
    info.cooOrderSerial = [buyinfo.cooOrderSerial UTF8String];
    info.description = [buyinfo.payDescription UTF8String];
    info.productId = [buyinfo.productId UTF8String];
    info.productName = [buyinfo.productName UTF8String];
    info.productPrice = buyinfo.productPrice;
    info.productOrignalPrice = buyinfo.productOrignalPrice;
    info.productCount = buyinfo.productCount;
    
    BOOL bSucess = [[dic objectForKey:@"result"] boolValue];
    if (!bSucess) {
        NSString* strError = nil;
        int nErrorCode = [[dic objectForKey:@"error"] intValue];
        switch (nErrorCode) {
            case ND_COM_PLATFORM_ERROR_USER_CANCEL:
                strError = @"您已经取消支付操作";
                break;
            case ND_COM_PLATFORM_ERROR_NETWORK_ERROR:
                strError = @"网络错误";
                break;
            case ND_COM_PLATFORM_ERROR_SERVER_RETURN_ERROR:
                strError = @"服务器处理失败";
                break;
            case ND_COM_PLATFORM_ERROR_ORDER_SERIAL_SUBMITTED:
                strError = @"支付订单已经提交";
                break;
            default:
                strError = @"购买过程发生错误";
                break;
        }
        std::string log = [strError UTF8String];
        libPlatformManager::getPlatform()->_boardcastBuyinfoSent(false, info, log);
    }
    else
    {
        std::string log("购买成功");
        libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
    }
}

/*
-(void) appVersionUpdateDidFinish:(ND_APP_UPDATE_RESULT)updateResult
{
    NSString *title = nil;
    switch (updateResult) {
        case ND_APP_UPDATE_NO_NEW_VERSION:
            title = @"无可用更新"; //正常进入游戏
            break;
        case ND_APP_UPDATE_FORCE_UPDATE_CANCEL_BY_USER:
            title = @"下载强制更新被取消,\n请重新启动游戏！";  //退出游戏，退出前可以弹出相关版本更新说明等内容；
            break;
        case ND_APP_UPDATE_NORMAL_UPDATE_CANCEL_BY_USER:
            title = @"下载普通更新被取消,\n请重新启动游戏！";  //进入游戏，需要的话，可以提示进一步提示玩家更新的好处和目的；
            break;
        case ND_APP_UPDATE_NEW_VERSION_DOWNLOAD_FAIL:
            title = @"下载新版本失败,\n请重新启动游戏！"; //可以正常进入游戏；
            break;
        case ND_APP_UPDATE_CHECK_NEW_VERSION_FAIL:
            title = @"检测新版本信息失败,\n请重新启动游戏！";  //可能是网络问题，如果是单机游戏，那么就直接进入游戏，如果是网络游戏，那么建议检查下网络，也可以直接进入游戏，这边的风险在于如果是客户端与服务器版本不兼容，容易引起客户端异常
            break;
        default:
            break;
    }
    
    std::string outstr([title UTF8String]);
    
    if (ND_APP_UPDATE_NO_NEW_VERSION == updateResult) {
        [self registerNotification];
		lib91* plat91 = dynamic_cast<lib91*>(libPlatformManager::getPlatform());
		if(plat91)
		{
			plat91->_enableLogin();
		}
        libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
    }
    else {
        libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(false,outstr);
    }
    
}
 */
-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
 
}

@end

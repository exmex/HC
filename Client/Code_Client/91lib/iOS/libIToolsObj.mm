//
//  libIToolsObj.m
//  libITools
//
//  Created by lvjc on 13-8-06.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libITools.h"
#include "libIToolsObj.h"
#import "IToolsSDK/HXAppPlatformKitPro.h"

@implementation libIToolsObj
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
    //监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:HX_NOTIFICATION_LOGIN object:nil];
    
    //视图关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewNotification:) name:HX_NOTIFICATION_CLOSEVIEW object:nil];
    
    //注销通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlatformLogout:) name:HX_NOTIFICATION_LOGOUT object:nil];
    
    //注册完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterSuccess:) name:HX_NOTIFICATION_REGISTER object:nil];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//关闭窗口通知
- (void)closeViewNotification:(NSNotification *)notification
{
 //   libPlatformManager::getPlatform()->_boardcastPlatformLogout();
//    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
//    std::string out = [strTip UTF8String];
//    libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
}

/**
 *	@brief	平台关闭通知，监听离开平台通知以对游戏界面进行重新调整
 */	
- (void)PlatformLogout:(NSNotification *)notify
{
    libITools* plat = dynamic_cast<libITools*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_disableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}

/**
 *	@brief	登录通知监听方法，登录成功、失败都在这个方法处理
 *
 *	@param 	notification 	通知的userInfo包含登录结果信息
 */
- (void)SNSLoginResult:(NSNotification *)notify
{
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    libITools* plat = dynamic_cast<libITools*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_enableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
}

- (void)RegisterSuccess:(NSNotification *)notify
{
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    libITools* plat = dynamic_cast<libITools*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_enableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
}

-(void)NdUniPayAysnResult:(NSNotification*)notify
{
    //回调购买成功。其余都是失败
    if ([[notify object] isEqualToString:@"购买成功"])
    {
//		libTB* plat = dynamic_cast<libTB*>(libPlatformManager::getPlatform());
//		if(plat)
//		{
//			BUYINFO info = plat->getBuyInfo();
//			std::string log("购买成功");
//			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
//		}
        
    }
}


-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
 
}

@end

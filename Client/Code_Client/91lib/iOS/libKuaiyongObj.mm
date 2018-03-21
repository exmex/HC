//
//  libKuaiyongObj.m
//  libKuaiyong
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libKuaiyong.h"
#include "libOS.h"
#import "libKuaiyongObj.h"
#import "CustomKYSDK.h"

@implementation libKuaiyongObj
-(void) SNSInitResult:(NSNotification *)notify
{
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
    //添加监听请求登陆【只成功有效】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:)
                                                 name:CUSTOMSDK_LOGIN object:nil];
    //添加监听兑换结果返回信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NdUniPayAysnResult:)
                                                 name:CUSTOMSDK_BUYDONE object:nil];
    //添加监听注销
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlatformLogout:)
                                                 name:CUSTOMSDK_LOGOUT object:nil];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    //[self.view addSubview:waitView];//添加该waitView
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
}

-(void) unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOMSDK_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOMSDK_BUYDONE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOMSDK_LOGIN object:nil];
}

- (void)PlatformLogout:(NSNotification *)notify
{
	static int leaveCount=1;
    if(leaveCount%2!=0)
    {
        libKuaiyong* plat = dynamic_cast<libKuaiyong*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_disableLogin();
        }
        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
    }
    leaveCount++;
}
//登录
- (void)SNSLoginResult:(NSNotification *)notify
{
    
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, "登录成功");
	
}

-(void)NdUniPayAysnResult:(NSNotification*)notify
{
    //回调购买成功。其余都是失败
    if ([[notify object] isEqualToString:@"购买成功"])
    {
		libKuaiyong* plat = dynamic_cast<libKuaiyong*>(libPlatformManager::getPlatform());
		if(plat)
		{
			BUYINFO info = plat->getBuyInfo();
			std::string log("购买成功");
			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
           
		}
        
    }
}

-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
    [[KYSDK instance]showUserView];
}

@end

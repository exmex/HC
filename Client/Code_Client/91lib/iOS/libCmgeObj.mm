//
//  libCmgeObj.m
//  libCmge
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libCmge.h"
#import "libCmgeObj.h"



@implementation libCmgeObj
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
    
    
    
    //监听平台退出的通知（点击SDK右上角的X时）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlatformLogout:) name:Cmge_kNotificationLoginOutPlatform object:nil];
    
    //监听用户登陆成功的通知 单机版游戏不用监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:Cmge_kNotificationUserLoginSuccess object:nil];
    
    //监听充值成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NdUniPayAysnResult:) name:Cmge_kNotificationUserPayOver object:nil];
    

    
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
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPBuyResultNotification object:nil];
}

- (void)PlatformLogout:(NSNotification *)notify
{
    
    
    static int leaveCount=1;
    if(leaveCount%2!=0)
    {
        libCmge* plat = dynamic_cast<libCmge*>(libPlatformManager::getPlatform());
        if(plat)
        {
            NSString* retNS = [[CmgePlatform defaultPlatform] getUserName];
            if (retNS){
            }else{
                plat->_disableLogin();
            }

        }
        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
    }
    leaveCount++;
    
}
//登录
- (void)SNSLoginResult:(NSNotification *)notify
{

    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    libCmge* plat = dynamic_cast<libCmge*>(libPlatformManager::getPlatform());
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
		libCmge* plat = dynamic_cast<libCmge*>(libPlatformManager::getPlatform());
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
 
}

@end

//
//  libPPObj.m
//  libPP
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libAG.h"
#import "libAGObj.h"



@implementation libAGObj
-(void) SNSInitResult:(NSNotification *)notify
{
    //libPlatformManager::getPlatform()->_boardcastInitDone(true, "");

}

-(void) registerNotification
{
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
    libAG* plat = dynamic_cast<libAG*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_disableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();

}
//登录
- (void)SNSLoginResult:(NSNotification *)notify
{
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    libAG* plat = dynamic_cast<libAG*>(libPlatformManager::getPlatform());
	if(plat)
	{
		plat->_enableLogin();
	}
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
	
}

-(void)NdUniPayAysnResult:(NSNotification*)notify
{
//    if (PP_ISNSLOG) {
//        NSLog(@"兑换的回调%@",notify.object);
//    }
    //回调购买成功。其余都是失败
	libAG* plat = dynamic_cast<libAG*>(libPlatformManager::getPlatform());
	if(plat)
	{
		BUYINFO info = plat->getBuyInfo();
		std::string log("购买成功");
		libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
	}
}

-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
 
}

#pragma mark    ---------------SDK CALLBACK---------------
//字符串登录成功回调【实现其中一个就可以】
- (void)ppLoginStrCallBack:(NSString *)paramStrToKenKey{
    //字符串token验证方式
    
    [self SNSLoginResult:nil];
    
}

//关闭客户端页面回调方法
-(void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode{
    //可根据关闭的VIEW页面做你需要的业务处理
    NSLog(@"当前关闭的VIEW页面回调是%d", paramPPPageCode);
}



//关闭WEB页面回调方法
- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode{
    //可根据关闭的WEB页面做你需要的业务处理
    NSLog(@"当前关闭的WEB页面回调是%d", paramPPWebViewCode);
}

//注销回调方法
- (void)ppLogOffCallBack
{
    NSLog(@"注销的回调");
    [self PlatformLogout:nil];
}

//兑换回调接口【只有兑换会执行此回调】
- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode
{
    NSLog(@"兑换回调返回编码%d",paramPPPayResultCode);
    //回调购买成功。其余都是失败
    if(paramPPPayResultCode == PPPayResultCodeSucceed){
        //购买成功发放道具
        [self NdUniPayAysnResult:nil];
    }else{
        
    }
}

-(void)ppVerifyingUpdatePassCallBack
{
    NSLog(@"验证游戏版本完毕回调");
    //[[PPAppPlatformKit sharedInstance] showLogin];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

@end

//
//  libAppStoreObj.m
//  libAppStore
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libAppStore.h"
#import "libAppStoreObj.h"
#import "AdverView.h"
#include "libOS.h"
#include <com4lovesSDK.h>
#include "SDKUtility.h"
#ifndef WIN32
#include <sys/utsname.h>
#endif


@interface libAppStoreObj ()
{
    BUYINFO buyInfo;
  //  DMInterstitialAdController *_dmInterstitial;
}
@property (nonatomic,retain)AdverView *adverView;
@end

@implementation libAppStoreObj

-(void) initRegister
{
    [AppsFlyerTracker sharedTracker].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDone:) name:(NSString*)com4loves_loginDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyDone:) name:(NSString*)com4loves_buyDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:(NSString*)com4loves_logout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryUser2OkSuccess:) name:(NSString*)com4loves_tryuser2OkSucess object:nil];
}

- (void)LoginDone:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, "登录成功");
    [[AppsFlyerTracker sharedTracker] trackEvent:@"registration" withValue:@""];
}


- (void)buyDone:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, buyInfo, "购买成功");
    [[AppsFlyerTracker sharedTracker] trackEvent:@"purchase" withValue:[NSString stringWithFormat:@"%f",buyInfo.productPrice]];
}

-(void) setBuyInfo:(BUYINFO) info
{
    buyInfo = info;
}

-(void) logout:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}

-(void) tryUser2OkSuccess:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastOnTryUserRegistSuccess();
}

-(void)onPresent
{
//    if(_dmInterstitial.isReady)
//    {
//        [_dmInterstitial present];
//    }
//    else
//    {
//        [_dmInterstitial loadAd];
//    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if(self.adverView == nil)
    {
        self.adverView = [[AdverView alloc]initWithFrame:window.rootViewController.view.bounds];
    }
    [window.rootViewController.view addSubview:self.adverView];
    self.adverView.hidden = NO;

}

//- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial
//{
//    // 插屏⼲⼴广告关闭后,加载⼀一条新⼲⼴广告⽤用于下次呈现
//    [_dmInterstitial loadAd];
//}
-(void)dealloc
{
    self.adverView = nil;
    [super dealloc];
}

//----------------------------------AppsFlyer-----------------------------------
-(void)onConversionDataReceived:(NSDictionary*) installData {
    id status = [installData objectForKey:@"af_status"];
    NSString *CollectDataUrl = @"http://203.90.236.18/index.php?g=home&m=apiRequest&a=collectData";
    
    if([status isEqualToString:@"Non-organic"]) {
        
        id media_source = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        id clickTime = [installData objectForKey:@"click_time"];
        id installTime = [installData objectForKey:@"install_time"];
        
        std::string deviceID = libOS::getInstance()->getDeviceID();
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        NSString *url = [NSString stringWithFormat:@"%@/&android_id=%@&imei=%@&game_id=%@&platform=%@&package=%@&media_source=%@&ip=%@&mac=%@&decvice_type=%@&sdk_version=%@&os_version=%@&click_url=%@&click_time=%@&install_time=%@&country_code=%@&city=%@",CollectDataUrl,@"",[NSString stringWithUTF8String:deviceID.c_str()],[com4lovesSDK getSDKAppKey],[com4lovesSDK getPlatformID],[[NSBundle mainBundle] bundleIdentifier],media_source,@"",[[SDKUtility sharedInstance] getMacAddress],deviceString,@"",@"",@"",clickTime,installTime,@"",@""];
        NSLog(@"url = %@",url);
        
        [[SDKUtility sharedInstance] httpPut:url postData:nil md5check:nil];
        
    } else if([status isEqualToString:@"Organic"]) {
        
        NSLog(@"This is an organic install.");
    }
    
}

-(void)onConversionDataRequestFailure:(NSError *) error {
    
    NSLog(@"%@",error);
    
}

@end

//
//  libYouaiKYObj.m
//  libYouaiKY
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libYouaiKY.h"
#import "libYouaiKYObj.h"


@interface libYouaiKYObj ()
{
    BUYINFO buyInfo;
    KY_UpdataSDK * sdk;

}
@end

@implementation libYouaiKYObj

-(void) initRegister
{
    
    sdk = [[KY_UpdataSDK alloc]init];
    sdk.updataDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDone:) name:(NSString*)com4loves_loginDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyDone:) name:(NSString*)com4loves_buyDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:(NSString*)com4loves_logout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryUser2OkSuccess:) name:(NSString*)com4loves_tryuser2OkSucess object:nil];
}

- (void)LoginDone:(NSNotification *)notify
{

    libPlatformManager::getPlatform()->_boardcastLoginResult(true, "登录成功");
}


- (void)buyDone:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, buyInfo, "购买成功");
    
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

-(void) updateApp
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app build %@ ",app_build);
    [sdk checkVersionOfAppId:@"com.loves.kuaiyonghaizeiwang" nowVersion:app_build];
}
- (void) updataCheckResult:(BOOL)result serVer:(NSString *)serVer{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    BOOL oldVersion = [self isVersion:app_build olderThan:serVer];
    if(!result&&oldVersion){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"是否升级" message:@"最新版本上线\n是否升级" delegate:self cancelButtonTitle:nil otherButtonTitles:@"升级", nil];
        alert.tag = 11;
        [alert show];
    }else{
        libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
    }
    
}
-(BOOL) isVersion:(NSString *) nowVersion olderThan:(NSString*)otherVersion
{
    return ([nowVersion compare:otherVersion options:NSNumericSearch] == NSOrderedAscending);
}


- (void) updataHappenError:(NSError *)error
{
    [sdk installNewVersion];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 11)
    {
        [sdk installNewVersion];
    }
    else
    {
        libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,"");
    }
}
@end

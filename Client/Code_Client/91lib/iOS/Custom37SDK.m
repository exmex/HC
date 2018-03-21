//
//  Custom37SDK.m
//  lib91
//
//  Created by ljc on 13-11-13.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import "Custom37SDK.h"
#import "37wanwan/GameLib.h"
#import "CustomSDKViewController.h"

static CustomSDKViewController *sdkView = nil;
static UINavigationController *nav = nil;
@interface Custom37SDK()
{
}

@property (retain,nonatomic) CustomSDKViewController *sdkView;

@end

@implementation Custom37SDK
//设置游戏的appId 和 appKey, 合作接入时分配, 可以找联系客服获取
+ (void)initSDK
{
    [GameLib initWithGameClient:@"34" gameSecret:@"1958ce778e57a72666fc19e6c7ac599e" vendorName:@"Beijing Com4loves Interactive Co,.Ltd" channelName:@"4"];
   
    if (sdkView==nil) {
        sdkView = [[CustomSDKViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:sdkView];
        nav.navigationBar.hidden = YES;
        [nav setNavigationBarHidden:YES];
    }
}
//显示登录界面
+ (void)showLoginView
{
   
    [Custom37SDK showView:nav.view];
    [sdkView loginAction:nil];
}

+ (BOOL)isLogin
{
    return [sdkView isLogin];
}

+ (void)showView:(UIView *)view
{
    [Custom37SDK hideAllView];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
 
    [view setHidden:NO];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    [view setFrame:rect];

}
+ (void)hideAllView

{
    [nav.view removeFromSuperview];
    [nav.view setHidden:YES];
}

//显示平台界面
+ (void)showPlatformView
{
    [Custom37SDK logout];
    [Custom37SDK showLoginView];
}

//获取当前用户ID
+ (NSString *)getUserId
{
    return [sdkView userID];
}

//获取当前用户名
+ (NSString *)getUserName
{
    return @"切换账号";
}

//获取当前用户的SessionId
+ (NSString *)getSessionId
{
    return @"";
}

//注销登录
+ (void)logout
{
    [sdkView logoutAction:nil];
}

+ (void)showPayViewWithOrderID:(NSString *)orderID productID:(NSString *)productID title:(NSString *)title money:(int)money playerID:(NSString *) playID serverID:(NSString*) serverID
{
    [Custom37SDK showView:nav.view];
    [sdkView payForProductName:title productId:productID price:money orderId:orderID];
}

@end

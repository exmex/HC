//
//  Custom49SDK.m
//  lib91
//
//  Created by ljc on 13-11-13.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import "Custom49SDK.h"
#import <49AppKit/main_view.h>
#import <49AppKit/ep_uinavigation.h>
#import <49AppKit/pay_view.h>
#import <49AppKit/rmb_options_view.h>
#import "Custom49SDKViewController.h"

static Custom49SDKViewController *sdkView = nil;
static BOOL isShowUserView;

@interface Custom49SDK()
{
}


@end

@implementation Custom49SDK
//设置游戏的appId 和 appKey, 合作接入时分配, 可以找联系客服获取
+ (void)initSDK
{
    if (sdkView==nil) {
        sdkView = [[Custom49SDKViewController alloc] init];
        [sdkView.view setBackgroundColor:[UIColor clearColor]];
        isShowUserView = NO;
    }
}
//显示登录界面
+ (void)showLoginView
{
//    [sdkView release];
    [Custom49SDK showView:sdkView];
    [sdkView loginAction:nil];
}

+ (BOOL)isLogin
{
    return [sdkView isLogin];
}

+ (void)showView:(UIViewController *)view
{
    if (!isShowUserView) {
        [[[[UIApplication sharedApplication]keyWindow] rootViewController]  presentViewController:view animated:NO completion:nil];
        isShowUserView = YES;
    }
}
+ (void)hideAllView

{
    isShowUserView = NO;
    [sdkView dismissViewControllerAnimated:NO completion:nil];
}

//显示平台界面
+ (void)showPlatformView
{
    [Custom49SDK logout];
    [Custom49SDK showLoginView];
}

//获取当前用户ID
+ (NSString *)getUserId
{
    return [sdkView userID];
}

//获取当前用户名
+ (NSString *)getUserName
{
    if ([[sdkView userName] length]>0) {
        return [sdkView userName];
    }
    return [sdkView userID];
}

//获取当前用户的SessionId
+ (NSString *)getSessionId
{
    return @"";
}

//注销登录
+ (void)logout
{
//    [sdkView logoutAction:nil];
}

+ (void)showPayViewWithOrderID:(NSString *)orderID productID:(NSString *)productID title:(NSString *)title money:(float)money playerID:(NSString *) playID serverID:(NSString*) serverID
{
    [sdkView release];
    sdkView = [[Custom49SDKViewController alloc] init];
    [sdkView.view setBackgroundColor:[UIColor clearColor]];
    [Custom49SDK showView:sdkView];
    [sdkView payForProductName:title productId:productID price:money orderId:orderID serverID:serverID];
}

@end

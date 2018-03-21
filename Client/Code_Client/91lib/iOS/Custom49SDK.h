//
//  Custom49SDK.h
//  lib91
//
//  Created by ljc on 13-11-13.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CUSTOMSDK_LOGIN                 @"com4loves_loginDone"
#define CUSTOMSDK_LOGOUT                @"com4loves_loginOut"
#define CUSTOMSDK_BUYDONE               @"com4loves_buyDone"

@interface Custom49SDK : NSObject

//设置游戏的appId 和 appKey, 合作接入时分配, 可以找联系客服获取
+ (void)initSDK;

//显示登录界面
+ (void)showLoginView;

//显示平台界面
+ (void)showPlatformView;

+ (void)hideAllView;

//获取当前用户ID
+ (NSString *)getUserId;

//获取当前用户名
+ (NSString *)getUserName;

//获取当前用户的SessionId
+ (NSString *)getSessionId;

//注销登录
+ (void)logout;

+ (BOOL)isLogin;

+ (void)showPayViewWithOrderID:(NSString *)orderID productID:(NSString *)productID title:(NSString *)title money:(float)money playerID:(NSString *) playID serverID:(NSString*) serverID;

@end

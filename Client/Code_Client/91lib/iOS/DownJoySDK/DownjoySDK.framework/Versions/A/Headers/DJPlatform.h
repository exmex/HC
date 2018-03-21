//
//  DJPlatform.h
//  DownjoySDK2.0
//
//  Created by soon on 13-9-27.
//  Copyright (c) 2013年 downjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfomation.h"
@interface DJPlatform : UIViewController
{
    
}

@property (retain, nonatomic) NSString *merchantId;
@property (retain, nonatomic) NSString *appId;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *serverId;
@property (retain, nonatomic) NSString *channelId;
@property (retain, nonatomic) NSString *appScheme;
@property (retain, nonatomic) NSString *token;
@property (retain, nonatomic) UserInfomation *userInfomation;
@property (assign, nonatomic) UIInterfaceOrientation screenOrientation;
@property (assign, nonatomic) BOOL tapBackgroundHideView;

//返回一个SDK对象
+(DJPlatform *) defaultDJPlatform;

//登陆状态
- (BOOL) DJCheckLoginStatus;

//登陆
- (void) DJLogin;

//获取用户Mid
- (NSString *) currentMemberId;

//获取用户Token
- (NSString *) currentToken;

//注销
- (void) DJLogout;

//个人中心
- (void) appearDJMemberCenter;

//隐藏个人中心
- (void) disappearDJMemberCenterWithNotification:(BOOL) flag;

//请求会员信息
-(void) DJReadMemberInfo;

//充值&消费
-(void) DJPayment:(float)money productName:(NSString *)productName extInfo:(NSString *)extInfo;

//直充
- (void) DJpaymentForDJWallet:(NSString *) extInfo;

//点击背景，关闭SDK当前页面
- (void) setTapBackgroundHideView : (BOOL) hidden;

/***兼容5.x的系统不能横屏的问题
   **以[window addSubView: viewController.view] 这种方初始化app的需要加一句:
   **[[DJPlatform defaultDJPlatform] setDJRootView:_viewController.view];
 ***/
- (void) setDJRootView:(UIView *)DJRootView;

//*********************************
- (UIView*) welcomeView;
- (void) setIsLogin:(BOOL)isLogin;


@end

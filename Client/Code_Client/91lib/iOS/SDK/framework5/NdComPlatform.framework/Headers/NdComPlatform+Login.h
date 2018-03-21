//
//  NdComPlatform+Login.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"
#import "NdComPlatformAPIResponse.h"

@interface NdComPlatform(Login)

/**
 @brief 判断是否已经登录平台
 */
- (BOOL)isLogined;

/**
 @brief 是否配置了自动登录
 */
- (BOOL)isAutoLogin;

/**
 @brief 登录平台,进入登录或者注册界面入口
 @param nFlag 标识（按位标识）预留，默认为0
 @result 错误码
 */
- (int)NdLogin:(int) nFlag;

/**
 @brief 登录平台,默认自动登陆，支持游客账号登陆
 @param nFlag 标识（按位标识）预留，默认为0
 @result 错误码
 */
- (int)NdLoginEx:(int)nFlag;

/**
 @brief 获取当前登陆账户的状态
 @result 登录类型
 */
- (ND_LOGIN_STATE)getCurrentLoginState;

/**
 @brief 进入游客账号转正式账号界面
 @param nFlag 标识（按位标识）预留，默认为0
 */
- (void)NdGuestRegist:(int)nFlag;

/**
 @brief 注销
 @param nFlag 标识（按位标识）0,表示注销；1，表示注销，并清除自动登录
 @result 错误码 
 */
- (int)NdLogout:(int) nFlag;

/**
 @brief 切换账号（logout+login），会注销当前登录的账号。
 */
- (void)NdSwitchAccount;

/**
 @brief 进入账号管理界面，用户可以选择其它账号登录。如果没有新账号登录，当前登录的账号仍然有效。
 @result 错误码
 */
- (int)NdEnterAccountManage;



#pragma mark -
/**
 @brief 获取本次登录的sessionId，需要登录后才能获取
 */
- (NSString *)sessionId;

/**
 @brief 获取登录后的Uin
 */
- (NSString *)loginUin;

/**
 @brief 获取登录后的昵称
 */
- (NSString *)nickName;

/**
 @brief 获取登录账户的信息
 @result 当前登录账户的信息，包含uin，昵称等。
 @note 该接口在登录后立即返回
 */
- (NdMyUserInfo *)NdGetMyInfo;

/**
 @brief 获取登录账户的详细信息
 @param delegate 回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdGetMyInfoDetail:(id)delegate;



@end


#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_Login

/**
 @brief NdGetMyInfoDetail 的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param userInfo 获取到的用户信息
 */
- (void)getUserInfoDidFinish:(int)error userInfo:(NdUserInfo *)userInfo;

@end
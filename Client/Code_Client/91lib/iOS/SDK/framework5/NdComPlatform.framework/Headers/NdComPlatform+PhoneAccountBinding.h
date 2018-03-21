//
//  NdComPlatform+PhoneAccountBinding.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"


@interface NdComPlatform(PhoneAccountBinding)


@property (nonatomic, assign) BOOL shouldGuideToPhoneBindingWhenLogined;		/**< 登录成功后，是否需要引导用户去绑定手机号，默认是YES */


/**
 @brief 查询91通行证是否已经绑定手机号码
 @param delegate 回调对象，回调接口参见 NdComPlatformUIProtocol(NdHasBindPhoneNumberDidFinish...)
 @result 错误码
 */
- (int)NdHasBindPhoneNumber:(id)delegate;


/**
 @brief 进入绑定界面，引导91通行证绑定手机号。只有当前账号未绑定手机的情况下，调用才有效。在退出界面时，再调用NdHasBindPhoneNumber查询一下，看用户是否绑定成功。
 @param nFlag 默认为0。如果想直接进入手机号绑定界面，设置为1。
 @result 错误码，如果 < 0，可能是未检查绑定信息，请先调用NdHasBindPhoneNumber查询，也有可能是当前账号已经绑定手机。
 */
- (int)NdBindPhoneNumber:(int)nFlag;


/**
 @brief 进入绑定界面，引导91通行证绑定手机号。只有当前账号未绑定手机的情况下，调用才有效。在退出界面时，再调用NdHasBindPhoneNumber查询一下，看用户是否绑定成功。
 @param nFlag 默认为0。如果想直接进入手机号绑定界面，设置为1。
 @param phoneNumber 默认的电话号码，将会出现在绑定界面的编辑框里。
 @returns 错误码，如果 < 0，可能是未检查绑定信息，请先调用NdHasBindPhoneNumber查询，也有可能是当前账号已经绑定手机。
 */
- (int)NdBindPhoneNumber:(int)nFlag withNumber:(NSString*)phoneNumber;


/**
 @brief 请求服务端下发 短信验证码，（发到欲绑定的手机号上）
 @param phoneNumber 欲绑定的手机号
 @param delegate 回调对象，回调接口参见 NdComPlatformUIProtocol(NdGetSMSVerifyCodeForBindDidFinish...)
 @result 错误码
 */
- (int)NdGetSMSVerifyCodeForBind:(NSString*)phoneNumber  delegate:(id)delegate;


/**
 @brief 请求绑定手机号，需要手机号和服务端下发到该手机号上的验证码
 @param phoneNumber  欲绑定的手机号
 @param verifyCode   由服务端下发到手机号（phoneNumber）上的短信验证码
 @param delegate 回调对象，回调接口参见 NdComPlatformUIProtocol(NdBindPhoneNumberDidFinish...)
 @result 错误码
 */
- (int)NdBindPhoneNumber:(NSString*)phoneNumber  SMSVerifyCode:(NSString*)verifyCode  delegate:(id)delegate;


@end




#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_PhoneAccountBinding


/**
 @brief NdHasBindPhoneNumber的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 @param bHasBind YES为已经绑定手机号码。
 */
- (void)NdHasBindPhoneNumberDidFinish:(int)error  hasBind:(BOOL)bHasBind;


/*!
 NdGetSMSVerifyCodeForBind的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 */
- (void)NdGetSMSVerifyCodeForBindDidFinish:(int)error;


/*!
 NdBindPhoneNumber的回调
 @param error		错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 @param resultDesc  错误描述，如果error < 0时，描述绑定失败的原因
 */
- (void)NdBindphoneNumberDidFinish:(int)error  resultDesc:(NSString*)resultDesc;


@end
//
//  KYMobilePay.h
//  KYSDK
//
//  Created by KY_ljf on 14-2-19.
//  Copyright (c) 2014年 KY_ljf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    BillingResultSucceed = 0x1000,
    BillingResultFailed,
    BillingResultCanceled
} BillingResultType;

@protocol KYMobilePayDelegate;

@interface KYMobilePay : NSObject

@property (nonatomic,assign) id <KYMobilePayDelegate> delegate;


+ (KYMobilePay *)initializeGameBilling;
+ (KYMobilePay *)initializeGameBillingWithGameName:(NSString *)gameName provider:(NSString *)provider serviceTel:(NSString *)serviceTel;

/**
 *  购买结果本地保存功能及接口
 *  @param billingIndex 计费点Id
 *  @param state 已计费:YES,未计费:NO
 */
- (void)setPayState:(NSString *)billingIndex withState:(BOOL)state;

/**
 *  购买结果本地获取功能及接口
 *  @param billingIndex 计费点Id
 *  @returns 已计费:YES,未计费:NO
 */
- (BOOL)getPayState:(NSString *)billingIndex;

/**
 *  计费方法(无UI)
 *  @param billingIndex 三位计费点Id
 *  @param isRepeated 是否重复计费点
 *  @param phoneNum 联网付费手机号
 *  @param veriCode 联网付费手机短信验证码
 
 说明：
 1、手机号码和验证码都为空：直接发短信付费
 2、手机号码不为空，验证码为空：获取验证码
 3、手机号码和验证码都不为空：联网付费
 
 */
- (void)doBillingWithBillingIndex:(NSString *)billingIndex isRepeated:(BOOL)isRepeated phoneNum:(NSString *)phoneNum veriCode:(NSString *)veriCode;

/**
 *  计费方法(带UI)
 *  @param billingIndex 三位计费点Id
 *  @param isRepeated 是否重复计费点
 *  @param useSms 是否优先使用短信计费
 */
- (void)doBillingWithUIAndBillingIndex:(NSString *)billingIndex isRepeated:(BOOL)isRepeated useSms:(BOOL)useSms;

/**
 *  设置UI计费对话框支持的方向，默认UIInterfaceOrientationMaskAll。
 如果游戏只支持横屏或者只支持竖屏，请一定要设置相应的UI计费对话框的方向
 */
-(void)setDialogOrientationMask:(UIInterfaceOrientationMask)orientationMask;
@end


@protocol KYMobilePayDelegate<NSObject>
@required
- (void)onBillingResult:(BillingResultType)resultCode billingIndex:(NSString *)index message:(NSString *)message;
@end

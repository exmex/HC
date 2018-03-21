//
//  NdComPlatform+PayAndRecharge.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"
#import "NdComPlatformAPIResponse+PayAndRecharge.h"


@interface NdComPlatform(PayAndRecharge)

#pragma mark -
#pragma mark Pay

/**
 @brief 进入虚拟币充值界面
 @param cooOrderSerial 合作商订单号，必须保证唯一，双方对账的唯一标记, 用GUID生成，32位
 @param needPayCoins 需支付虚拟币个数，开发者不关注可以传零
 @param payDescription 支付描述，发送支付通知时，原样返回给开发者，默认为空串
 @result 错误码
 */
- (int)NdUniPayForCoin:(NSString*)cooOrderSerial needPayCoins:(int)needPayCoins payDescription:(NSString*)payDescription;

/**
 @brief 向通用业务服务器发起支付请求,必须登录后才能使用
 @param buyInfo 购买信息
 @result 若未登录调用则返回错误码，否则返回0
 */
- (int)NdUniPay:(NdBuyInfo *)buyInfo;

/**
 @brief 如果余额足够的情况下，进行购买；余额不足的情况下，先充值，然后再购买
 @param buyInfo	购买信息
 @result 若未登录调用则返回错误码，否则返回0
 @note 
 1:开发者根据自己的需要和自己的业务服务器确认支付结果
 2:若余额充足，购买完成后会通知购买结果。
 3:若余额不足，选择短信充值并发送短信成功，会通知短信发送成功
 */
- (int)NdUniPayAsyn:(NdBuyInfo *)buyInfo;

/**
 @brief 判断支付是成功
 @param strCooOrderSerial	支付订单号
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdCheckPaySuccess:(NSString*)strCooOrderSerial delegate:(id)delegate;

/**
 @brief 判断支付是成功
 @param strCooOrderSerial	支付订单号
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdSearchPayResultInfo:(NSString*)strCooOrderSerial delegate:(id)delegate;

@end




#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_PayAndRecharge


/**
 @brief NdCheckPaySuccess回调
 @param error  错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 @param bSuccess 返回支付是否成功
 */
- (void)checkPaySuccessDidFinish:(int)error cooOrderSerial:(NSString*)cooOrderSerial bSuccess:(BOOL)bSuccess;


/**
 @brief NdSearchPayResultInfo回调,
 @param error  错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 @param bSuccess 返回支付是否成功
 @param buyInfo 订单信息 （productPrice、productOrignalPrice 字段无效）
 */
- (void)searchPayResultInfoDidFinish:(int)error bSuccess:(BOOL)bSuccess buyInfo:(NdBuyInfo*)buyInfo;



@end
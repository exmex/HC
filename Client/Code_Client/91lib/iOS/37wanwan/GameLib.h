//
//  GameLib.h
//  GameLib
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GameLibDelegate;

@interface GameLib : NSObject{
    
}

@property (nonatomic, assign) id<GameLibDelegate> gamelibDelegate;
/*
 *初始化信息
 *@param (NSString *) gameId 游戏在平台上分配的唯一标识
 *@param (NSString *) gameSecret 游戏平台给游戏分配的一个私密字符串
 *@param (NSString *) vendorName 开发商名称
 *@param (NSString *) channelName 渠道ID
 */
+ (void)initWithGameClient : (NSString *)gameId gameSecret:(NSString *)gameSecret vendorName:(NSString *)vendorName channelName:(NSString *)channelName;

/*显示登录页面*/
- (void)showLogin:(UIViewController *)viewController;

/*显示支付页面
 *@param (UIViewController) viewController 点击支付的viewController
 *@param (NSString *) productName 购买物品的名称
 *@param (NSString *) productId 购买物品的id
 *@param (int) price 物品单价。用人民币表示的物品价格
 *@param (int) quantity 购买数量
 *@param (NSString *) orderId 订单号。游戏厂商平台的订单号，不可重复
 */
- (void)showPay:(UIViewController *)viewController productName:(NSString *)productName productId:(NSString *)productId price:(int)price quantity:(int)quantity orderId:(NSString *)orderId;

/*
 *登出接口
 *@param (NSString *) token
 */
- (void)logoutAction:(NSString *)token;

@end

@protocol GameLibDelegate

@optional
//登录成功callback
- (void)onLoginSuccess:(NSString *)token;
//取消登录callback
- (void)onCancel:(id)sender;
//取消支付callback
- (void)onClose:(id)sender;

@end
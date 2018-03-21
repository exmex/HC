//
//  TBPlatformDefines.h
//  tbGameSDK
//
//  Created by YLo. on 13-12-5.
//  Copyright (c) 2013年 tongbu.com. All rights reserved.
//

#ifndef tbGameSDK_TBPlatformDefines_h
#define tbGameSDK_TBPlatformDefines_h

#pragma mark - 相关Key ********************************************************

extern NSString * const TBLeavedPlatformTypeKey;  /*离开平台时UserInfo字典中离开类型Key*/

extern NSString * const TBLeavedPlatformOrderKey; /*离开平台时UserInfo字典中充值订单Key*/

extern NSString * const TBCheckUpdateResultKey;   /*检查更新结果（BOOL、是否成功）*/

#pragma mark - 通知 ************************************************************

extern NSString * const kTBInitDidFinishNotification; /* 初始化完毕时发出的通知 */

extern NSString * const kTBLoginNotification;         /* 登录完成的通知(登录成功后发出) */

extern NSString * const kTBLeavePlatformNotification; /* 离开平台界面时，会发送该通知 */

extern NSString * const kTBUserLogoutNotification;    /* 用户注销通知*/

#pragma mark - 枚举 ************************************************************

/**
 *  悬浮工具栏位置
 */
typedef enum  _TBToolBarPlace{

	TBToolBarAtTopLeft = 1,   /* 左上 */

	TBToolBarAtTopRight,      /* 右上 */

    TBToolBarAtMiddleLeft,    /* 左中 */

	TBToolBarAtMiddleRight,   /* 右中 */

	TBToolBarAtBottomLeft,    /* 左下 */

	TBToolBarAtBottomRight,   /* 右下 */

}TBToolBarPlace;

/**
 *	离开平台的类型
 */
typedef enum _TB_LeavedPlatform_Type_{

    TBPlatformLeavedDefault = 0,    /* 离开未知平台（预留状态）*/

    TBPlatformLeavedFromLogin,      /* 离开注册、登录页面 */

    TBPlatformLeavedFromUserCenter, /* 包括个人中心、游戏推荐、论坛 */

    TBPlatformLeavedFromUserPay,    /* 离开充值页（包括成功、失败）*/

}TBPlatformLeavedType;

/**
 *  充值订单状态
 */
typedef enum{

    TBCheckOrderStatusWaitingForPay = 0, /* 待支付（已经创建第三方充值订单，但未支付）*/

    TBCheckOrderStatusPaying        = 1, /* 充值中（用户支付成功，正在通知开发者服务器，未收到处理结果）*/

    TBCheckOrderStatusFailed        = 2, /* 失败 */

    TBCheckOrderStatusSuccess       = 3, /* 成功（通知开发者服务器并收到处理成功结果，充值完毕））*/

}TBCheckOrderStatusType;

#pragma mark - 信息类 **********************************************************

/**
 *	@brief	用户的基础信息（登录后获得）
 */
@interface TBPlatformUserInfo : NSObject

@property (nonatomic, copy) NSString *sessionID;	/* 登录会话id,用于登录验证 */

@property (nonatomic, copy) NSString *userID;       /* 用户id */

@property (nonatomic, copy) NSString *nickName;     /* 用户昵称 */

@end

#pragma mark - 协议 *************************************************************
/**
 *  @brief 指定金额购买回调，通知购买结果
 */
@protocol TBBuyGoodsProtocol <NSObject>

typedef enum {
    /*余额不足*/
    kBuyGoodsBalanceNotEnough,

    /*服务器错误*/
    kBuyGoodsServerError,
    
    /*订单号为空*/
    kBuyGoodsOrderEmpty,

    /*网络不流畅（有可能已经购买成功但客户端已超时,建议进行订单查询）*/
    kBuyGoodsNetworkingError,

    /*其他错误*/
    kBuyGoodsOtherError,

}TB_BUYGOODS_ERROR;

@optional

/**
 *	@brief	使用推币直接购买商品成功
 *
 *	@param 	order 	订单号
 */
- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order;

/**
 *	@brief	使用推币直接购买商品失败
 *
 *	@param 	order 	订单号
 *	@param 	errorType  错误类型，见TB_BUYGOODS_ERROR
 */
- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType;

/**
 *	@brief	推币余额不足，进入充值页面（开发者需要手动查询订单以获取充值购买结果）
 *
 *	@param 	order 	订单号
 */
- (void)TBBuyGoodsDidStartRechargeWithOrder:(NSString*)order;

/**
 *	@brief  跳提示框时，用户取消
 *
 *	@param	order	订单号
 */
- (void)TBBuyGoodsDidCancelByUser:(NSString *)order;

@end

/**
 @brief 手动查询充值结果回调协议
 */
@protocol TBCheckOrderDelegate <NSObject>

@optional

/**
 *  查询订单结束
 *
 *  @param orderString 订单号
 *  @param amount      订单金额（单位：分）
 *  @param statusType  订单状态（详细说明见TBCheckOrderStatusType定义）
 */
- (void)TBCheckOrderFinishedWithOrder:(NSString *)orderString
                               amount:(int)amount
                               status:(TBCheckOrderStatusType)statusType;
/**
 *  @brief 查询订单失败（网络不通畅，或服务器返回错误）
 */
- (void)TBCheckOrderDidFailed:(NSString*)order;

@end

#endif

//
//  NdComPlatformAPIResponse+VirtualGoods.h
//  NdComPlatformInt
//
//  Created by xujianye on 11-7-14.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark  ------------ Virtual Goods ------------

/**
 @brief 虚拟商品计费类型
 */
typedef enum _ND_VG_FEE_TYPE 
{
	ND_VG_FEE_TYPE_INVALID	= 0,					/**< 无效类型 */
	ND_VG_FEE_TYPE_POSSESS	= 1,					/**< 非消费型（一次购买，终身使用） */
	ND_VG_FEE_TYPE_SUBSCRIBE= 2,					/**< 订阅  型（按时段、可能按次/数量） */
	ND_VG_FEE_TYPE_CONSUME	= 4,					/**< 消费  型（按次/数量） */
}	ND_VG_FEE_TYPE;

/**
 @brief 虚拟商品计费币种
 */
typedef enum  _ND_VG_VC_MONEY_FLAG
{
	ND_VG_VC_MONEY_91BEAN    = 0,			/**< 91豆 */
	ND_VG_VC_MONEY_CUSTOM_VC = 1,			/**< 虚拟币 */
}	ND_VG_VC_MONEY_FLAG;

/**
 @brief 虚拟商品信息(基类)
 */
@interface NdVGInfoBase : NSObject
{
	ND_VG_FEE_TYPE		vgFeeType;
}
@property (nonatomic, assign, readonly)		ND_VG_FEE_TYPE		vgFeeType;
@end


#pragma mark  ------------ VG Fee Info ------------
/**
 @brief 虚拟商品计费信息(基类)
 */
@interface NdVGFeeInfoBase : NdVGInfoBase
{
	ND_VG_VC_MONEY_FLAG		moneyFlag;
	BOOL					bind2Imei;
}

@property (nonatomic, assign) ND_VG_VC_MONEY_FLAG	moneyFlag;		/**< 计费币种 */
@property (nonatomic, assign) BOOL					bind2Imei;		/**< 商品是否只能在购买的手机设备上使用 */

@end

/**
 @brief 虚拟商品计费信息(ND_VG_FEE_TYPE_POSSESS)
 */
@interface NdVGFeeInfoPossess : NdVGFeeInfoBase {
}
@end


/**
 @brief 虚拟商品计费信息(ND_VG_FEE_TYPE_SUBSCRIBE)
 */
@interface NdVGFeeInfoSubscribe : NdVGFeeInfoBase
{
	int			nAuthCntPerGoods;
	int			nAuthDays;
}
@property (nonatomic, assign) int			nAuthCntPerGoods;		/**< 商品可用次数 */
@property (nonatomic, assign) int			nAuthDays;				/**< 可使用的天数 */

@end


/**
 @brief 虚拟商品计费信息(ND_VG_FEE_TYPE_CONSUME)
 */
@interface NdVGFeeInfoConsume : NdVGFeeInfoBase
{
	int			nBuyLimitPerUser;
	int			nStockCnt;
	NSString*	strTimePeriod;
}
@property (nonatomic, assign) int			nBuyLimitPerUser;		/**< 每个用户限购额 */
@property (nonatomic, assign) int			nStockCnt;				/**< 商品剩余数量 */
@property (nonatomic, retain) NSString*		strTimePeriod;			/**< 每日限购时间段 */

- (BOOL)isBuyLimitPerUserInfinite;									/**< 用户限购额没有限制时，返回YES，否则NO */
- (BOOL)isStockCountInfinite;										/**< 商品剩余数量无限时，返回YES，否则NO */

@end



#pragma mark  ------------ VG Auth Info ------------
/**
 @brief 虚拟商品授权信息(基类)
 */
@interface NdVGAuthInfoBase : NdVGInfoBase
{
	BOOL					canUseInThisImei;		
}

@property (nonatomic, assign) BOOL			canUseInThisImei;		/**< 商品是否可以在当前手机设备上使用 */

@end

/**
 @brief 虚拟商品授权信息(ND_VG_FEE_TYPE_POSSESS)
 */
@interface NdVGAuthInfoPossess : NdVGAuthInfoBase {
}
@end


/**
 @brief 虚拟商品授权信息(ND_VG_FEE_TYPE_SUBSCRIBE)
 */
@interface NdVGAuthInfoSubscribe : NdVGAuthInfoBase
{
	int			nRemainCnt;
	NSString*	strStartTime;
	NSString*	strEndTime;
}

@property (nonatomic, assign) int			nRemainCnt;			/**< 剩余可用商品数 */
@property (nonatomic, retain) NSString*		strStartTime;		/**< 可用起始时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, retain) NSString*		strEndTime;			/**< 可用终止时间 yyyy-MM-dd HH:mm:ss */

- (BOOL)isRemainCountInfinite;			/**< 剩余可用商品数为无限时返回YES，否则NO */
- (NSDate*)dateWithStartTime;			/**< 可用终止时间的NSDate格式 */
- (NSDate*)dateWithEndTime;				/**< 可用终止时间的NSDate格式 */

@end


/**
 @brief 虚拟商品授权信息(ND_VG_FEE_TYPE_CONSUME)
 */
@interface NdVGAuthInfoConsume : NdVGAuthInfoBase
{
	int			nRemainCnt;
}
@property (nonatomic, assign) int			nRemainCnt;			/**< 剩余可用商品数 */
@end


#pragma mark  ------------ VG list ------------

/**
 @brief 商品类别
 */
@interface NdVGCategory : NSObject
{
	NSString*	strCateId;
	NSString*	strCateName;
}
@property (nonatomic, retain) NSString*		strCateId;			/**< 类别id */
@property (nonatomic, retain) NSString*		strCateName;		/**< 类别名称 */
@end




typedef enum  _ND_VG_SELL_FLAG
{
	ND_VG_SELL_FLAG_NONE,				/**< 没有标记 */
	ND_VG_SELL_FLAG_NO_STOCK,			/**< 已售完 */
	ND_VG_SELL_FLAG_LIMIT_STOCK,		/**< 限量版 */
	ND_VG_SELL_FLAG_LIMIT_TIME,			/**< 限时抢购 */
	ND_VG_SELL_FLAG_CUT_DOWN_PRICE,		/**< 降价 */
} ND_VG_SELL_FLAG;




/**
 @brief 商品信息
 */
@interface NdVGCommodityInfo : NSObject
{
	NSString*		strProductId;
	NSString*		strProductName;
	NSString*		strCateId;
	NSString*		strOriginPrice;
	NSString*		strSalePrice;
	NSString*		strChecksum;
	NSString*		strUnit;
	NSString*		strGoodsDesc;
	NdVGFeeInfoBase*	vgFeeInfo;
}

@property (nonatomic, retain) NSString*		strProductId;		/**< 开发者商品编号 */
@property (nonatomic, retain) NSString*		strProductName;		/**< 商品名称 */
@property (nonatomic, retain) NSString*		strCateId;			/**< 类别id */
@property (nonatomic, retain) NSString*		strOriginPrice;		/**< 原价 */
@property (nonatomic, retain) NSString*		strSalePrice;		/**< 销售价 */
@property (nonatomic, retain) NSString*		strChecksum;		/**< 商品图标checksum */
@property (nonatomic, retain) NSString*		strUnit;			/**< 计数单位，如：个、件 */
@property (nonatomic, retain) NSString*		strGoodsDesc;		/**< 描述信息 */
@property (nonatomic, retain) NdVGFeeInfoBase*	vgFeeInfo;		/**< 商品计费信息（需要根据计费类型，转为对应的具体类） */

- (ND_VG_SELL_FLAG)vgSellFlag;

@end


/**
 @brief 已购买的商品信息
 */
@interface NdVGHoldingInfo : NSObject
{
	NSString*		strProductId;
	NSString*		strProductName;
	NdVGAuthInfoBase*	vgAuthInfo;
}

@property (nonatomic, retain) NSString*		strProductId;		/**< 开发者商品编号 */
@property (nonatomic, retain) NSString*		strProductName;		/**< 商品名称 */
@property (nonatomic, retain) NdVGAuthInfoBase*	vgAuthInfo;		/**< 商品授权信息（需要根据计费类型，转为对应的具体类） */

@end


#pragma mark  ------------ VG order/use ------------
/**
 @brief 购买商品  请求信息
 */
@interface NdVGSimpleOrderRequest : NSObject
{
	NSString*		strProductId;
	int				productCount;
	NSString*		strPayDescription;	
	NSString*		strExtParam;
}

@property(nonatomic, retain) NSString*		strProductId;		/**< 虚拟商品id */
@property(nonatomic, assign) int			productCount;		/**< 虚拟商品数量 */
@property(nonatomic, retain) NSString*		strPayDescription;	/**< 支付描述（可选） */
@property(nonatomic, retain) NSString*		strExtParam;		/**< 扩展参数信息（暂时不用） */
@end


/**
 @brief 购买商品 请求信息（可以包含商品详情）
 */
@interface NdVGOrderRequest : NSObject
{
	int				nBuyCount;
	NSString*		strExtParam;
	NSString*		strPayDescription;
	NdVGCommodityInfo*	vgCommodityInfo;
}

@property (nonatomic, assign) int			nBuyCount;					/**< 购买数量；如果是非消费型商品或订阅型商品，传1。 */
@property (nonatomic, retain) NSString*		strExtParam;				/**< 扩展参数信息（暂时不用） */
@property (nonatomic, retain) NSString*		strPayDescription;			/**< 支付描述（可选） */
@property (nonatomic, retain) NdVGCommodityInfo*	vgCommodityInfo;	/**< 虚拟商品信息 */

/**
 @brief 最简的购买请求信息
 @param productId	虚拟商品id
 @param count		购买数量；如果是非消费型商品或订阅型商品，传1。
 @param payDescription 支付描述（可选）
 */
+ (id)orderRequestWithProductId:(NSString*)productId  productCount:(NSUInteger)count   payDescription:(NSString*)payDescription;

@end


/**
 @brief 购买虚拟商品的失败信息
 */
@interface NdVGErrorInfo : NSObject
{
	int				nErrCode;
	NSString*		strErrDesc;
}

@property (nonatomic, retain) NSString*		strErrDesc;			/**< nErrCode的说明信息 */
@property (nonatomic, assign) int			nErrCode;			/**< 可能的错误码：
																 0＝无错误，
																 1＝商品不存在，
																 2＝商品不在销售期内，
																 3＝商品已下架，
																 4＝商品已售完，
																 5＝此商品已购买，无需重复购买（非消费型），
																 6＝此商品已购买，无需重复购买（订阅型），
																 7＝消费型商品购买数量超过限制，
																 8＝此商品不在购买时间段内，
																 9＝此商品正在购买支付中，无需重复购买（非消费型），
																 10＝此商品正在购买支付中，无需重复购买（订阅型）
																 11＝虚拟币(不是91豆)余额不足，请充值
																 */
- (BOOL)isBalanceNotEnough;		/**< return (nErrCode == 11) */

@end


/**
 @brief 请求虚拟商品的订单信息
 */
@interface NdVGOrderResult : NSObject
{
	BOOL			bCanBuy;
	NSString*		strOrderSerial;
	NdVGErrorInfo*	vgErrorInfo;
}

@property (nonatomic, assign) BOOL				bCanBuy;			/**< 商品可以购买时为YES，否则NO */
@property (nonatomic, retain) NSString*			strOrderSerial;		/**< 服务端生成的订单号，用以支付时使用 */
@property (nonatomic, retain) NdVGErrorInfo*	vgErrorInfo;		/**< bCanBuy为NO时的错误信息 */

@end



/**
 @brief 使用已购买商品 请求信息
 */
@interface NdVGUseRequest : NSObject
{
	int				nUseCount;
	NSString*		strProductId;
	NSString*		strExtParam;
}

@property (nonatomic, assign) int			nUseCount;			/**< 使用数量 */
@property (nonatomic, retain) NSString*		strProductId;		/**< 开发者商品编号 */
@property (nonatomic, retain) NSString*		strExtParam;		/**< 扩展参数信息（暂时不用）*/

@end


/**
 @brief 使用已购买商品 返回结果
 */
@interface NdVGUseResult : NSObject
{
	BOOL			bCanUse;
	int				nErrCode;
	NSString*		strErrDesc;
	NdVGAuthInfoBase*	vgAuthInfo;
}
@property (nonatomic, assign) BOOL			bCanUse;			/**< 商品使用成功时为YES，否则NO */
@property (nonatomic, assign) int			nErrCode;			/**< bCanUse为NO时的错误码，
																 1＝商品不存在，
																 2＝还未购买该商品或者购买的商品已过期，
																 3＝购买的商品可用数量不足，
																 4＝其它错误 */
@property (nonatomic, retain) NSString*			strErrDesc;		/**< nErrCode的说明信息 */
@property (nonatomic, retain) NdVGAuthInfoBase*	vgAuthInfo;		/**< 商品授权信息（需要根据计费类型，转为对应的具体类） */

@end

/**
 @brief 使用已购买商品 返回结果（new，增加了UseSign）
 */
@interface NdVGUseResultNew : NdVGUseResult
{
	NSString*		strUseSign;
}
@property (nonatomic, assign) NSString*		strUseSign;			/**< 虚拟物品使用标志（用于确认接口609） */

@end


@interface NdVGVirtualCurrencyBalance : NSObject
{
	NSString			*currencyName;
	NSString			*ratio;
	ND_VG_VC_MONEY_FLAG	money;
	NSString			*unit;
	NSString			*balance;
	
}

@property (nonatomic,retain) NSString				*currencyName;	/**< 虚拟币名称 */
@property (nonatomic,retain) NSString				*ratio;			/**< 1个91豆等于多少个虚拟币 */
@property (nonatomic,assign) ND_VG_VC_MONEY_FLAG	money;			/**< 使用的货币 0=91豆，1＝自定义 */
@property (nonatomic,retain) NSString				*unit;			/**< 虚拟币单位 */
@property (nonatomic,retain) NSString				*balance;		/**< 虚拟币余额 */

@end


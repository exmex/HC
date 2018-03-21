//
//  NdComPlatform+VirtualGoods.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 11-7-14.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"
#import "NdComPlatformAPIResponse+VirtualGoods.h"


@interface NdComPlatform(VirtualGoods)


/**
 @brief 进入虚拟商店
 @param strCateId	商品类别id，传空为全部类别
 @param feeType		可取值有：ND_VG_FEE_TYPE_POSSESS，ND_VG_FEE_TYPE_SUBSCRIBE，ND_VG_FEE_TYPE_CONSUME，以及三者的 位或 组合。
 @result 错误码
 */
- (int)NdEnterVirtualShop:(NSString*)strCateId  feeType:(int)feeType;




/**
 @brief 获取商品类别信息列表
 @param delegate 回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetCategoryList:(id)delegate;




/**
 @brief 获取应用促销信息
 @param delegate 回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetAppPromotion:(id)delegate;




/**
 @brief 获取商品信息列表
 @param cateId	 类别id，传nil,或者为空串，代表取所有商品
 @param feeType	 可取值有：ND_VG_FEE_TYPE_POSSESS，ND_VG_FEE_TYPE_SUBSCRIBE，ND_VG_FEE_TYPE_CONSUME，以及三者的 位或 组合。
 @param nAppId	 应用id，传0表示当前应用
 @param pagination 分页信息（pageSize为5的倍数，最大50）
 @param packageId	虚拟商品包id, 默认传nil
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetCommodityList:(NSString*)cateId  feeType:(int)feeType pagination:(NdPagination*)pagination packageId:(NSString*)packageId  delegate:(id)delegate;




/**
 @brief 获取单个商品信息
 @param productId	商品id等
 @param delegate	回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetCommodityInfo:(NSString*)productId  delegate:(id)delegate;




/**
 @brief 虚拟商品购买
 @param orderRequest	包含数量，商品id等
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdBuyCommodity:(NdVGOrderRequest*)orderRequest;





/**
 @brief 使用已购买的商品
 @param useRequest		包含数量，商品id等
 @param delegate		回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdUseHolding:(NdVGUseRequest*)useRequest  delegate:(id)delegate;




/**
 @brief 判断非消费型商品是否已经购买
 @param strProductId	非消费型商品id
 @param delegate		回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdProductIsPayed:(NSString*)strProductId  delegate:(id)delegate;




/**
 @brief 判断订阅型商品是否已经过期失效（如时间到期，使用次数耗尽，或者未购买）
 @param strProductId	订阅型商品id
 @param delegate		回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdProductIsExpired:(NSString*)strProductId  delegate:(id)delegate;




/**
 @brief 查询某个商品的购买信息
 @param strProductId	商品id（不限制类型）
 @param delegate		回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetUserProduct:(NSString*)strProductId  delegate:(id)delegate;




/**
 @brief 获取已购买的商品列表
 @param pagination	分页信息（pageSize为5的倍数，最大50）
 @param delegate	回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetUserProductsList:(NdPagination*)pagination delegate:(id)delegate;




/**
 @brief 获取虚拟商店中的游戏币余额
 @param delegate	回调对象
 @result 请求成功返回值大于等于0，失败返回错误码
 */
- (int)NdGetVirtualBalance:(id)delegate;




@end




#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_VirtualGoods


/**
 @brief NdGetCategoryList的回调
 @param error	错误码
 @param records 类别信息，存放 NdVGCategory*
 */
- (void)getCategoryListDidFinish:(int)error  records:(NSArray*)records;


/**
 @brief NdGetAppPromotion的回调
 @param error	错误码
 @param promotion 促销信息
 */
- (void)getAppPromotionDidFinish:(int)error  promotion:(NSString*)promotion;


/**
 @brief NdGetCommodityList的回调
 @param error	错误码
 @param cateId  促销信息
 @param feeType 商品类型
 @param packageId 虚拟商品包id
 @param result	分页的信息列表，records存放NdVGCommodityInfo*
 */
- (void)getCommodityListDidFinish:(int)error  cateId:(NSString*)cateId  feeType:(int)feeType 
						packageId:(NSString*)packageId result:(NdBasePageList*)result;


/*!
 NdGetCommodityInfo的回调
 @param commodityInfo	虚拟商品信息
 @param error	错误码
 */
- (void)getCommodityInfoDidFinish:(int)error commodityInfo:(NdVGCommodityInfo*)commodityInfo;


/**
 @brief NdUseHolding的回调
 @param error	错误码
 @param useRequest	请求的信息
 @param useResult	返回的结果
 */
- (void)useHoldingDidFinish:(int)error  useRequest:(NdVGUseRequest*)useRequest  useResult:(NdVGUseResult*)useResult;


/**
 @brief NdProductIsPayed的回调
 @param error	错误码
 @param isPayed		商品是否已经购买
 @param canUse		商品是否可以在当前设备上使用
 @param errCode		isPayed为NO时的错误码，1＝商品不存在，2＝还未购买该商品或者购买的商品已过期，3＝其它错误
 @param strErrDesc	nErrCode的描述文本
 */
- (void)NdProductIsPayedDidFinish:(int)error  isPayed:(BOOL)isPayed  canUseInThisImei:(BOOL)canUse  errCode:(int)errCode  errDesc:(NSString*)errDesc;


/**
 @brief NdProductIsExpired的回调
 @param error	错误码
 @param isExpired	商品是否已经过期
 @param canUse		商品是否可以在当前设备上使用
 @param errCode		isExpired为YES时的错误码，1＝商品不存在，2＝还未购买该商品或者购买的商品已过期，3＝其它错误
 @param strErrDesc	nErrCode的描述文本
 */
- (void)NdProductIsExpiredDidFinish:(int)error   isExpired:(BOOL)isExpired  canUseInThisImei:(BOOL)canUse  errCode:(int)errCode  errDesc:(NSString*)errDesc;


/**
 @brief NdGetUserProduct的回调
 @param error	错误码
 @param canUse		是否可用
 @param errCode		canUse为NO时的错误码，1＝商品不存在，2＝还未购买该商品或者购买的商品已过期，3＝其它错误
 @param strErrDesc	nErrCode的描述文本
 @param vgAuthInfo	商品具体授权信息，可能是下面的某一种：NdVGAuthInfoPossess, NdVGAuthInfoSubscribe, NdVGAuthInfoConsume
 */
- (void)NdGetUserProductDidFinish:(int)error   canUse:(BOOL)canUse  errCode:(int)errCode  errDesc:(NSString*)errDesc  authInfo:(NdVGAuthInfoBase*)vgAuthInfo;


/**
 @brief NdGetUserProductsList的回调
 @param error	错误码
 @param result	分页的信息列表，records存放NdVGHoldingInfo*
 */
- (void)NdGetUserProductsListDidFinish:(int)error  result:(NdBasePageList*)result;


/**
 @brief NdGetVirtualBalance的回调
 @param error	错误码
 @param balance	虚拟币余额
 */
- (void)NdGetVirtualBalanceDidFinish:(int)error  balance:(NSString*)balance;


@end


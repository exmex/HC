//
//  NdComPlatformAPIResponse.h
//  NdComPlatform_SNS
//
//  Created by Sie Kensou on 10-10-8.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 @brief 91豆支付信息
 @note 购买价格保留2位小数
 */
@interface NdBuyInfo : NSObject
{
	NSString *cooOrderSerial;
	NSString *productId;
	NSString *productName;
	float	 productPrice;			
	float	 productOrignalPrice;	
	unsigned int productCount;			
	NSString *payDescription;			
}

@property (nonatomic, retain) NSString *cooOrderSerial;				/**< 合作商的订单号，必须保证唯一，双方对账的唯一标记（用GUID生成，32位）*/
@property (nonatomic, retain) NSString *productId;					/**< 商品Id */
@property (nonatomic, retain) NSString *productName;				/**< 商品名字 */
@property (nonatomic, assign) float productPrice;					/**< 商品价格，两位小数 */
@property (nonatomic, assign) float productOrignalPrice;			/**< 商品原始价格，保留两位小数 */
@property (nonatomic, assign) unsigned int productCount;			/**< 购买商品个数 */
@property (nonatomic, retain) NSString *payDescription;				/**< 购买描述，可选，没有为空 */

- (BOOL)isValidBuyInfo;						/**<  判断支付信息是否有效 */
- (BOOL)isCostGreaterThanThreshold;			/**<  返回（总价>100W || 单价> 100W || 数量 > 100W*100） */
- (BOOL)isCostGreaterThanValue:(float)fValue;/**<  返回（productPrice * productCount > fValue) */

@end




/**
 @brief 购买记录
 */
@interface NdPayRecord : NSObject
{
	NSString	*cooOrderSerial;
	NSString	*buyTime;
	NSString	*productName;
	unsigned int	productCount;
	float		pay91Bean;
	//NSString	*status;
	NSString	*appName;
}

@property (nonatomic, retain) NSString *cooOrderSerial;		/**< 购买订单号 */
@property (nonatomic, retain) NSString *buyTime;			/**< 购买时间（yyyy-MM-dd HH:mm:ss) */
@property (nonatomic, retain) NSString *productName;		/**< 商品名称 */
@property (nonatomic, assign) unsigned int productCount;	/**< 购买商品个数 */
@property (nonatomic, assign) float		pay91Bean;			/**< 购买所消费91豆,保留2位小数 */
//@property (nonatomic, retain) NSString *status;			/**< 发货状态 */
@property (nonatomic, retain) NSString *appName;			/**< 应用软件名称 */

@end




/**
 @brief 充值记录类
 */
@interface NdRechargingRecord : NSObject 
{
	NSString			*cooOrderSerial;
	NSString			*rechargingTime;
	NSString			*rechargingType;
	float				recharging91Bean;
}

@property (nonatomic, retain) NSString	*cooOrderSerial;			/**< 充值订单号（默认为空）*/
@property (nonatomic, retain) NSString	*rechargingTime;			/**< 充值时间（yyyy－MM－dd HH：mm：ss）*/
@property (nonatomic, retain) NSString	*rechargingType;			/**< 充值渠道 */
@property (nonatomic, assign) float		recharging91Bean;			/**< 充值91豆,保留2位小数*/

@end



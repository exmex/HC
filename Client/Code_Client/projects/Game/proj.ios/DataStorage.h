//
//  DataStorage.h
//  hero
//
//  Created by Lyon on 18/6/14.
//
//

#import <Foundation/Foundation.h>

@interface DataStorage : NSObject

+(NSString*)getUUID;

+(NSString*)getDeviceId;

+(void)setDeviceId:(NSString*)deviceId;

+(void)setServerId:(NSString*)serverId;

+(NSString*)getTimeZone;

+(NSString*)getLocalTime;
    
+(void)savePaymentOrdersInfo:(NSString*)uin
                    ServerID:(NSString*)serverId
                     OrderID:(NSString*)orderId;

//获取订单信息
+(NSMutableDictionary*)getPaymentOrdersInfo;

//清除订单信息
+(void)clearPaymentOrdersInfo;

+(void)setGameCenterNickName:(NSString*)nickName;

+(NSString*)getDeviceAndOSInfo;

+(NSMutableDictionary*)getFinishPaymentOrders:(NSString*)orderId;
    
+(NSMutableDictionary*)getFirstFinishPaymentOrders;

+(NSString*)addFinishPaymentOrders:(NSString*)uin
               ServerID:(NSString*)serverId
                OrderID:(NSString*)orderId
                Receipt:(NSString*)receipt;

+(void)removeFinishPaymentOrders:(NSString*)orderId;

+(void)wirteShopPriceInfo:(NSMutableDictionary*)itemsInfo;

+(NSString*)getCurrentLanguage;

+(NSString*)getDeviceInfo;

@end

//
//  StatService.h
//  TA-SDK
//
//  Created by WQY on 12-11-5.
//  Copyright (c) 2012年 WQY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MTA_SDK_VERSION @"1.2.4"
#define MTA_APP_USER_VERSION  @"MTA_USER_APP_VER" 

typedef enum {
    MTA_SUCCESS = 0,
    MTA_FAILURE = 1,
    MTA_LOGIC_FAILURE = 2
} MTAAppMonitorErrorType;

@interface MTAAppMonitorStat : NSObject
@property (nonatomic, retain) NSString* interface;  //监控业务接口名
@property uint32_t requestPackageSize;              //上传请求包量，单位字节
@property uint32_t responsePackageSize;             //接收应答包量，单位字节
@property uint64_t consumedMilliseconds;            //消耗的时间，单位毫秒
@property int32_t returnCode;                       //业务返回的应答码
@property MTAAppMonitorErrorType resultType;        //业务返回类型
@property uint32_t sampling;                        //上报采样率，默认0含义为无采样
@end 


@interface MTA : NSObject
+(void) startWithAppkey:(NSString*) appkey;
+(BOOL) startWithAppkey:(NSString*) appkey checkedSdkVersion:(NSString*)ver;

+(void) trackPageViewBegin:(NSString*) page;
+(void) trackPageViewEnd:(NSString*) page;

+(void) trackError:(NSString*)error;
+(void) trackException:(NSException*)exception;

+(void) trackCustomEvent:(NSString*)event_id args:(NSArray*) array;
+(void) trackCustomEventBegin:(NSString*)event_id args:(NSArray*) array;
+(void) trackCustomEventEnd:(NSString*)event_id args:(NSArray*) array;
+(void) trackCustomKeyValueEvent:(NSString*)event_id props:(NSDictionary*) kvs;
+(void) trackCustomKeyValueEventBegin:(NSString*)event_id props:(NSDictionary*) kvs;
+(void) trackCustomKeyValueEventEnd:(NSString*)event_id props:(NSDictionary*) kvs;

+(void) commitCachedStats:(int32_t) maxStatCount;

+(void) startNewSession;
+(void) stopSession;

+(void) reportAppMonitorStat:(MTAAppMonitorStat*)stat;
+(void) reportQQ:(NSString*)qq;

+(void) trackGameUser:(NSString*)uid world:(NSString*)wd level:(NSString*)lev;

@end

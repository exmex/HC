//
//  NdComPlatformAPIResponse+GameCenter.h
//  NdComPlatformInt
//
//  Created by  hiyo on 13-3-12.
//  Copyright 2013 Nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 启动
@interface StartupADInfo : NSObject
@property (nonatomic, assign) int configId;
@property (nonatomic, assign) int belongAppId;
@property (nonatomic, retain) NSString *primaryImageUrl;
@property (nonatomic, retain) NSString *backgroundImageUrl;
@property (nonatomic, retain) NSString *beginTime;
@property (nonatomic, retain) NSString *endTime;

@property (nonatomic, retain) UIImage *primaryImage;
@property (nonatomic, retain) UIImage *backgroundImage;

+ (StartupADInfo *)objectFromDictionary:(NSDictionary *)dict;
@end

@interface StartupActADInfo : NSObject
@property (nonatomic, assign) int activityId;
@property (nonatomic, assign) int belongAppId;
@property (nonatomic, retain) NSString *activityImageUrl;
@property (nonatomic, retain) NSString *activityText;
@property (nonatomic, retain) NSString *textColor;
@property (nonatomic, retain) NSString *activityLink;
@property (nonatomic, retain) NSString *beginTime;
@property (nonatomic, retain) NSString *endTime;

@property (nonatomic, retain) UIImage *activityImage;

+ (StartupActADInfo *)objectFromDictionary:(NSDictionary *)dict;
@end

@interface StartupADInfoList : NSObject 
@property (nonatomic, retain) NSArray *adList;
@property (nonatomic, retain) NSArray *actAdList;
@property (nonatomic, retain) NSString *adLastModifyDate;
@property (nonatomic, retain) NSString *actAdLastModifyDate;

+ (StartupADInfoList *)listFromDictionary:(NSDictionary *)dict;
@end

#pragma mark - 暂停
typedef enum  _ND_GC_AD_TYPE_FLAG
{
	ND_GC_AD_TYPE_GAME_DETAIL = 1,			/**< 游戏专区页 */
	ND_GC_AD_TYPE_GAME_CENTER = 2,			/**< 游戏中心宣传页 */
	ND_GC_AD_TYPE_GAME_RECOMMEND = 3,		/**< 游戏推荐页 */
	ND_GC_AD_TYPE_ANYONE = 4,				/**< 任意页 */
}	ND_GC_AD_TYPE_FLAG;

@interface SuspendADInfo : NSObject
@property (nonatomic, assign) int adId;
@property (nonatomic, assign) int belongAppId;
@property (nonatomic, assign) int adType;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, assign) int gameCenterTargetType;
@property (nonatomic, retain) NSString *gameCenterTargetAction;
@property (nonatomic, assign) int normalTargetType;
@property (nonatomic, retain) NSString *normalTarget;
@property (nonatomic, assign) int itemRank;
@property (nonatomic, retain) NSString *targetAppIdentifier;
@property (nonatomic, retain) NSString *adSummary;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL isClicked; //用户是否点击过了

+ (SuspendADInfo *)objectFromDictionary:(NSDictionary *)dict;
@end

@interface SuspendRank : NSObject
@property (nonatomic, assign) int adType;
@property (nonatomic, assign) int pageRank;
+ (SuspendRank *)objectFromDictionary:(NSDictionary *)dict;
@end

@interface SuspendADInfoList : NSObject 
@property (nonatomic, retain) NSArray *adList;
@property (nonatomic, retain) NSString *lastModifyDate;
@property (nonatomic, retain) NSArray *rankList;

+ (SuspendADInfoList *)listFromDictionary:(NSDictionary *)dict;
@end

#pragma mark - 消息
@interface StartupNewsInfo : NSObject
@property (nonatomic, assign) int msgCount;
@property (nonatomic, retain) NSString *msgSummary;
@property (nonatomic, assign) int msgId;
@property (nonatomic, assign) int showTimes;
@property (nonatomic, assign) int showInterval;
@property (nonatomic, assign) int requestCycle;

@property (nonatomic, assign) int actualShowTimes;
@property (nonatomic, assign) BOOL bNeedShowBadge;
+ (StartupNewsInfo *)objectFromDictionary:(NSDictionary *)dict;

@end


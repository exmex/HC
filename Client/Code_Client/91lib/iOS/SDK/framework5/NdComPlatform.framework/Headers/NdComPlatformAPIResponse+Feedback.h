//
//  NdComPlatformAPIResponse+Feedback.h
//  NdComPlatformInt
//
//  Created by sun pinqun on 13-03-11.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformAPIResponse.h"
#import "NdComPlatformAPIResponse+UserInfo.h"
#import "NdComPlatformAPI+SysInfo.h"

#pragma mark -
#pragma mark  ------------ Feedback ------------

/**
 @brief 意见反馈的菜单
 */
@interface NdFeedbackMenuItem : NSObject <NSCoding>
{
    NSString		*menuName;
    NSString		*menuValue;
	NSInteger		menuType;
}

@property (nonatomic, retain) NSString *menuName;       /**< 菜单名称 */
@property (nonatomic, retain) NSString *menuValue;		/**< 菜单值 */
@property (nonatomic, assign) NSInteger menuType;		/**< 菜单类型（0=客户端跟Value的Url跳转到页面，1=客户端根据Value的值获取二级菜单）*/

@end



/**
 @brief 常见问题列表
 */
@interface NdFeedbackFAQItem : NSObject <NSCoding>
{
    NSString		*title;
    NSString		*content;
	NSString		*createTime;
}

@property (nonatomic, retain) NSString *title;          /**< 常见问题标题 */
@property (nonatomic, retain) NSString *content;		/**< 常见问题内容 */
@property (nonatomic, retain) NSString *createTime;		/**< 创建时间 */

@end




/**
 @brief 用户反馈类型
 */
@interface NdFeedbackTypeItem : NSObject <NSCoding>
{
    int             feedbackTypeId;
	NSString		*feedbackTypeName;
    int             feedbackBelong;
}

@property (nonatomic, assign) int feedbackTypeId;           /**< 反馈类型id */
@property (nonatomic, retain) NSString *feedbackTypeName;	/**< 反馈类型名称 */
@property (nonatomic, assign) int feedbackBelong;           /**< 反馈所属 */

@end




/**
 @brief 客服说明
 */
@interface NdFeedbackServiceInfo : NSObject <NSCoding>
{
    NSString		*servicePhone;
	NSString		*serviceNote;
    NSString		*otherContactWay;
    int             infoBelong;
}

@property (nonatomic, retain) NSString *servicePhone;       /**< 电话号码 */
@property (nonatomic, retain) NSString *serviceNote;        /**< 服务说明 */
@property (nonatomic, retain) NSString *otherContactWay;	/**< 其他联系方式 */
@property (nonatomic, assign) int infoBelong;               /**< 信息所属 */

@end


typedef enum _Feedback_Status
{
    FEEDBACK_INCOMPLETED = 0,   /**< 未完成 */
    FEEDBACK_UNEVALUATED = 1,   /**< 待评价 */
    FEEDBACK_EVALUATED = 2,     /**< 已评价 */
}Feedback_Status;


/**
 @brief 用户反馈建议列表项
 */
@interface NdFeedbackItem : NSObject <NSCoding>
{
    int             feedbackId;
	NSString		*content;
	int             status;
	NSString		*feedbackTime;
}

@property (nonatomic, assign) int feedbackId;           /**< 反馈id */
@property (nonatomic, retain) NSString *content;		/**< 反馈内容 */
@property (nonatomic, assign) int status;               /**< 反馈状态(0=未完成，1=已完成/待评价，2=已评价) */
@property (nonatomic, retain) NSString *feedbackTime;	/**< 反馈时间 */

@end




/**
 @brief 用户反馈的回复详细信息
 */
@interface NdFeedbackReplyInfo : NSObject 
{
	NSString		*content;
	int             itemType;
	NSString		*feedbackTime;
}

@property (nonatomic, retain) NSString *content;		/**< 反馈内容 */
@property (nonatomic, assign) int      itemType;        /**< 内容类型（0=玩家反馈，1=客服反馈） */
@property (nonatomic, retain) NSString *feedbackTime;	/**< 反馈时间 */

@end

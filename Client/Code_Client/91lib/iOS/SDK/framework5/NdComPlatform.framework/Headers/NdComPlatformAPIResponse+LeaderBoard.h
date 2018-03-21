//
//  NdComPlatformAPIResponse+LeaderBoard.h
//  NdComPlatformInt
//
//  Created by xujianye on 11-12-5.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformAPIResponse.h"

#pragma mark -
#pragma mark  ------------ LeaderBoard ------------
/**
 @brief 排行榜榜单信息
 */
@interface NdLeaderBoardInfo : NSObject 
{
	NSString*	leaderBoardId;					
	NSString*	leaderBoardName;				
	NSString*	description;					
	NSString*	checksum;						
}

@property (nonatomic, retain) NSString*	leaderBoardId;		/**< 排行榜编号 */
@property (nonatomic, retain) NSString*	leaderBoardName;	/**< 排行榜名称 */
@property (nonatomic, retain) NSString*	description;		/**< 排行榜描述 */
@property (nonatomic, retain) NSString*	checksum;			/**< 排行榜图校验码 */

@end




/**
 @brief 提交排行榜分数信息
 */
@interface NdSendLeaderBoardInfo : NSObject 
{
	int		nLeaderBoardId;					
	int		nCurrentScore;					
	int		nHighScore;						
	int		nLowScore;						
	NSString*	displayText;				
}

@property (nonatomic, assign) int		nLeaderBoardId;		/**< 排行榜编号 */
@property (nonatomic, assign) int		nCurrentScore;		/**< 当前分值 */
@property (nonatomic, assign) int		nHighScore;			/**< 最高分 */
@property (nonatomic, assign) int		nLowScore;			/**< 最低分 */
@property (nonatomic, retain) NSString*	displayText;		/**< 显示替换字符 */

@end




/**
 @brief 排行榜中用户信息
 */
@interface NdUserInfoOfLeaderBoard : NSObject 
{
	NSString*	uin;								
	NSString*	nickName;							
	NSString*	checksumOfUserIcon;					
	NSString*	score;								
	NSString*	userRank;							
	NSString*	dateCommited;						
	NSString*	displayText;						
}

- (void)replaceNickNameWithFriendRemark;					/**< 把好友的昵称替换为好友备注 */

@property (nonatomic, retain) NSString*	uin;				/**< 用户编号 */
@property (nonatomic, retain) NSString*	nickName;			/**< 用户昵称 */
@property (nonatomic, retain) NSString*	checksumOfUserIcon;	/**< 用户头像图标校验码 */
@property (nonatomic, retain) NSString*	score;				/**< 分值 */
@property (nonatomic, retain) NSString*	userRank;			/**< 排名 */
@property (nonatomic, retain) NSString*	dateCommited;		/**< 用户提交排行数据时间 */
@property (nonatomic, retain) NSString*	displayText;		/**< 显示替换字符 */

@end




/**
 @brief 排行榜中用户信息列表
 @note  records 存放的是NdUserInfoOfLeaderBoard类型对象
 */
@interface NdUserInfoOfLeaderBoardList : NdBasePageList  
{
	NdUserInfoOfLeaderBoard*	myself;
	NSString*					strShareText;
}

@property (nonatomic, retain)	NdUserInfoOfLeaderBoard*	myself;		/**< 返回请求者在排行榜中的信息 */
@property (nonatomic, retain)   NSString*		strShareText;	/**< 当前用户排行榜分享信息，SDK内部使用 */

- (void)replaceNickNameWithFriendRemark;				/**< 把列表中好友的昵称替换为好友备注 */

@end



#pragma mark -
#pragma mark  ------------ Achievement ------------
/**
 @brief 成就榜信息
 */
@interface NdAchievementInfo : NSObject  
{
	NSString*	achievementId;						
	NSString*	achievementName;					
	NSString*	description;						
	NSString*	displayText;						
	NSString*	dateUnlock;							
	NSString*	checksum;							
	NSString*	currentValue;						
	NSString*	completValue;						
	BOOL		isUnLock;							
}

@property (nonatomic, retain) NSString*	achievementId;		/**< 成就编号 */
@property (nonatomic, retain) NSString*	achievementName;	/**< 成就名称 */
@property (nonatomic, retain) NSString*	description;		/**< 成就描述 */
@property (nonatomic, retain) NSString*	displayText;		/**< 成就描述，用来替换分值显示的文本 */
@property (nonatomic, retain) NSString*	dateUnlock;			/**< 成就解锁时间 */
@property (nonatomic, retain) NSString*	checksum;			/**< 成就图标校验码*/
@property (nonatomic, retain) NSString*	currentValue;		/**< 当前达成的进度，提交解锁的分值 */
@property (nonatomic, retain) NSString*	completValue;		/**< 完成的总数值，完成解锁所需的分值（由后台定义是否支持）*/
@property (nonatomic, assign) BOOL		isUnLock;			/**< 当前用户是否解锁 */

@end




/**
 @brief 解锁成就榜信息
 */
@interface NdAchievementInfoCommited : NSObject 
{
	NSString*	achievementId;							
	NSString*	currentValue;							
	NSString*	displayText;							
}	

@property (nonatomic, retain) NSString*	achievementId;	/**< 成就编号 */
@property (nonatomic, retain) NSString*	currentValue;	/**< 当前解锁的分值（0不传），如果后台有定义解锁所需的分值，该值用来判断解锁进度 */
@property (nonatomic, retain) NSString*	displayText;	/**< 替代分值显示的文本，可以为空 */

@end




#pragma mark -
#pragma mark  ------------ Other Info ------------

/**
 @brief 应用模块启用信息
 */
@interface NdModule : NSObject	
{
	int		moduleId;
	BOOL	isEnabled;
}

@property (nonatomic, assign) int		moduleId;		/**< 模块id，1＝排行榜，2＝成就榜 */
@property (nonatomic, assign) BOOL		isEnabled;		/**< 0＝未启用，1＝启用 */

@end




/**
 @brief 应用模块启用信息列表
 */
@interface NdModuleList : NSObject 
{
	NSArray*	arrModule;
}

@property (nonatomic, retain)	NSArray*	arrModule;	/**< 存放NdModule* 对象 */

- (BOOL)isEnabledAchievement;		/**< 判断成就榜是否启用 */
- (BOOL)isEnabledLeaderBoard;		/**< 判断排行榜是否启用 */

@end




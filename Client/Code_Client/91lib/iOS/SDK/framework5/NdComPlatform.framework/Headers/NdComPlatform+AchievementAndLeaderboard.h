//
//  NdComPlatform+AchievementAndLeaderboard.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"
#import "NdComPlatformAPIResponse+LeaderBoard.h"


@interface NdComPlatform(AchievementAndLeaderboard)

#pragma mark -
#pragma mark Achievement

/**
 @brief 解锁某个成就
 @param nAchievementId	成就榜Id
 @param nCurrentValue	当前成就进度值
 @param displayText		替换进度值显示的文本，可以传空
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdUnLockAchievement:(int)nAchievementId value:(int)nCurrentValue displayText:(NSString*)displayText delegate:(id)delegate;

/**
 @brief 打开成就榜界面
 @param nFlag 标记位，默认为0
 @result 错误码
 */
- (int)NdOpenAchievement:(int)nFlag;

/**
 @brief 获取当前应用的指定用户的成就列表
 @param uin				用户uin
 @param pagination		分页信息，pageIndex从1开始
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdGetAchievementInfoList:(NSString*)uin pagination:(NdPagination*)pagination  delegate:(id)delegate;




#pragma mark -
#pragma mark LeaderBoard

/**
 @brief 提交排行榜分数
 @param nLeaderBoardId	排行榜Id
 @param nCurrentScore	当前提交的分数值
 @param displayText		替换排行名次显示的文本，可以传空
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdSubmitScore:(int)nLeaderBoardId  score:(int)nCurrentScore  displayText:(NSString*)displayText delegate:(id)delegate;

/**
 @brief 打开排行榜界面
 @param nLeaderBoardId 排行榜ID, 默认为0
 @param nFlag 标记位，默认为0
 @result 错误码
 */
- (int)NdOpenLeaderBoard:(int)nLeaderBoardId  flag:(int)nFlag;

/**
 @brief 获取当前应用所有排行榜榜单列表
 @param delegate 回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdGetLeaderBoard:(id)delegate;

/**
 @brief 获取某个排行榜中的用户排行信息列表
 @param uin				用户uin，会附加返回该用户的排行信息
 @param leaderBoardId	排行榜id
 @param userType		参与排行的用户类型：0＝所有用户；1＝我的好友
 @param subType			参与排行的时间范围：0＝所有时间；1＝日排行，当天有提交数据的用户；2＝周排行，最近七天有提交数据的用户；3＝月排行，最近一个月有提交数据的用户
 @param pagination		分页信息，pageIndex从1开始
 @param delegate		回调对象，回调接口参见 NdComPlatformUIProtocol
 @result 错误码
 */
- (int)NdGetUserLeaderBoardInfoList:(NSString*)uin leaderBoardId:(int)leaderBoardId  
							   type:(int)userType  subType:(int)subType 
						 pagination:(NdPagination*)pagination  delegate:(id)delegate;


@end


#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_AchievementAndLeaderboard

/**
 @brief NdUnLockAchievement的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 */
- (void)unlockAchievementDidFinish:(int)error;

/**
 @brief NdGetAchievementInfoList的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param achievementList 返回分页的成就列表信息，achievementList.records存放NdAchievementInfo*
 */
- (void)getAllAchievementsDidFinish:(int)error result:(NdBasePageList*)achievementList;

/**
 @brief NdSubmitScore的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param userRank  返回所提交的数据在排行榜中的排名。
 @param img 图标
 */
- (void)submitScoreDidFinish:(int)error;

/**
 @brief NdGetLeaderBoard的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param leaderboardInfoList  返回所有的排行榜榜单列表，leaderboardInfoList.records存放NdLeaderBoardInfo*
 */
- (void)getAllLeaderBoardsDidFinish:(int)error  result:(NdBasePageList*)leaderboardInfoList;

/**
 @brief NdGetUserLeaderBoardInfoList的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param result 返回分页的排行榜的用户数据。
 */
- (void)getLeaderBoardWithBoardIdDidFinish:(int)error type:(NSUInteger)userType	 subType:(NSUInteger)subType  
									result:(NdUserInfoOfLeaderBoardList*)userInfoOfLeaderBoardList;


@end
//
//  NdComPlatformAPIResponse+Message.h
//  NdComPlatformInt
//
//  Created by xujianye on 11-12-5.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformAPIResponse.h"
#import "NdComPlatformAPIResponse+UserInfo.h"
#import "NdComPlatformAPI+SysInfo.h"

#pragma mark -
#pragma mark  ------------ Message ------------

@interface NdMsgContent(SNS)
- (NSString*) replayceNickNameByContactName:(NSString*)showContent  cmdArray:(NSArray*)cmdArray;
@end



/**
 @brief 用户消息
 */
@interface NdUserMsgInfo : NSObject 
{
	NSString		*msgId;
	NdBaseUserInfo	*baseUserInfo;
	NdMsgContent	*msgContent;
	NSString		*sendTime;
	int				newCount;
	BOOL			bRead;
}

@property (nonatomic, retain) NSString			*msgId;				/**< 用户消息id */
@property (nonatomic, retain) NdBaseUserInfo	*baseUserInfo;		/**< 用户基本信息 */
@property (nonatomic, retain) NdMsgContent		*msgContent;		/**< 消息内容 */
@property (nonatomic, retain) NSString			*sendTime;			/**< 发送时间 */
@property (nonatomic, assign) int				newCount;			/**< 该用户的新消息数 */
@property (nonatomic, assign) BOOL				bRead;				/**< 消息状态，0＝未读，1＝已读 */

@end




#pragma mark NDCP_FANGLE_TYPE
/**
 @brief 消息类型定义
 */
typedef enum _NDCP_FANGLE_TYPE 
{
	NDCP_FANGLE_TYPE_ADD_FRIEND = 1,
	NDCP_FANGLE_TYPE_UPDATE_PHOTO = 2,
	NDCP_FANGLE_TYPE_UPDATE_EMOTION= 3,
	NDCP_FANGLE_TYPE_RECOMMEND_APP = 10001,
	NDCP_FANGLE_TYPE_RECOMMEND_SW = 10002,
	NDCP_FANGLE_TYPE_COMMENT_APP = 10003,
	NDCP_FANGLE_TYPE_COMMENT_SW = 10004 ,
	NDCP_FANGLE_TYPE_SCORING_APP = 10005 ,
	NDCP_FANGLE_TYPE_SCORING_SW = 10006 ,
	NDCP_FANGLE_TYPE_DOWNLOAD_APP = 10007 ,
	NDCP_FANGLE_TYPE_DOWNLOAD_SW = 10008 ,
	NDCP_FANGLE_TYPE_TOP_APP = 10009 ,
	NDCP_FANGLE_TYPE_GAME_ACTION = 10010 ,
} NDCP_FANGLE_TYPE;




/**
 @brief 新鲜事内容
 */
@interface NdFangleInfo : NSObject 
{
	NSString *msgId;
	NSString *friendUin;
	NSString *nickName;
	NDCP_FANGLE_TYPE msgtype;
	NdMsgContent *msgContent;
	NSString *sendTime;
}

- (void)replaceNickNameWithFriendRemark;					/**< 把好友昵称替换为备注 */

@property (nonatomic, retain)NSString		*msgId;			/**< 消息id */
@property (nonatomic, retain)NSString		*friendUin;		/**< 好友uin */
@property (nonatomic, retain)NSString		*nickName;		/**< 好友昵称 */
@property (nonatomic, assign)NDCP_FANGLE_TYPE msgtype;		/**< 消息类型 */
@property (nonatomic, retain)NdMsgContent	*msgContent;	/**< 消息内容 */
@property (nonatomic, retain)NSString		*sendTime;		/**< 发送时间 */

@end




/**
 @brief 简要消息
 */
@interface NdTinyMsgInfo : NSObject 
{
	NSString		*msgId;
	NSString		*senderUin;
	NdMsgContent	*msgContent;
	NSString		*sendTime;
	NDCP_FANGLE_TYPE	msgType;
}

@property (nonatomic, retain) NSString		*msgId;			/**< 消息Id */
@property (nonatomic, retain) NSString		*senderUin;		/**< 发送者Uin */
@property (nonatomic, retain) NdMsgContent	*msgContent;	/**< 消息内容 */
@property (nonatomic, retain) NSString		*sendTime;		/**< 发送时间 */
@property (nonatomic, assign) NDCP_FANGLE_TYPE	msgType;	/**< 消息类型 */

@end




/**
 @brief 动态消息
 */
@interface NdActivityMsgInfo : NSObject 
{
	NdUserMsgInfo	*userMsgInfo;
	int				type;
}

@property (nonatomic, retain) NdUserMsgInfo *userMsgInfo;	/**< 用户消息 */
@property (nonatomic, assign) int type;						/**< 动态类型，1＝评论应用，2＝更新头像，3＝更新心情，4＝新增好友，5＝下载应用，6＝推荐应用 */

@end




/**
 @brief 所有好友动态列表
 @note  records 存放的是NdActivityMsgInfo类型对象
 */
@interface NdAllFriendActivityMsgList : NdBasePageList 
{
	int		newMsgCount;
	int		newSysMsgCount;
}

@property (nonatomic, assign) int newMsgCount;		/**< 用户新消息数 */
@property (nonatomic, assign) int newSysMsgCount;	/**< 系统新消息数 */

- (void)replaceNickNameWithFriendRemark;			/**< 把好友列表中的昵称替换为好友备注 */

@end






/**
 @brief 所有好友最新消息列表
 @note  records 存放的是NdUserMsgInfo类型对象
 */
@interface NdAllFriendMsgList : NdBasePageList {
}

- (void)replaceNickNameWithFriendRemark;	/**< 把好友列表中的昵称替换为好友备注 */

@end




/**
 @brief 简要动态消息
 */
@interface NdTinyActivityMsgInfo : NSObject 
{
	NSString		*msgId;
	NdMsgContent	*msgContent;
	NSString		*sendTime;
}

@property (nonatomic, retain) NSString *msgId;			/**< 消息id */
@property (nonatomic, retain) NdMsgContent *msgContent;	/**< 消息内容 */
@property (nonatomic, retain) NSString  *sendTime;		/**< 发送时间 */

@end


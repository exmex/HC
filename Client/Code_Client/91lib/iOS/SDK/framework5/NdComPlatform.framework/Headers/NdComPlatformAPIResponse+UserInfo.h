//
//  NdComPlatformAPIResponse.h
//  NdComPlatform_SNS
//
//  Created by Sie Kensou on 10-10-8.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NdComPlatformAPIResponse.h"

/**
 @brief 好友详细信息 
 */
@interface NdFriendRemarkUserInfo : NdUserInfo 
{
	NSString*	friendRemark;
	NSString*	updateTime;	
	NSString*	strTip_aux;	
}

@property (nonatomic, retain) NSString*	friendRemark;	/**< 好友备注 */
@property (nonatomic, retain) NSString*	updateTime;		/**< 好友最后更新标志 */
@property (nonatomic, retain) NSString*	strTip_aux;		/**< 搜索辅助标志 */

- (void)updateFriendContactName;						/**< 通用平台内部使用 */
- (void)updateRemarkToPinyinInitial;					/**< 通用平台内部使用 */
- (NSString*)friendName;								/**< 优先返回备注，如果没有备注，返回昵称 */

@end




/**
 @brief 用户基础信息
 */
@interface NdBaseUserInfo : NSObject 
{
	NSString *uin;
	NSString *nickName;
	NSString *checkSum;
	BOOL	  bMyFriend;
}

- (void)replaceNickNameWithFriendRemark;				/**< 如果是我的好友，把昵称替换为备注（有备注的情况） */

@property (nonatomic, retain) NSString *uin;			/**< 好友的uin */
@property (nonatomic, retain) NSString *nickName;		/**< 好友的昵称 */
@property (nonatomic, retain) NSString *checkSum;		/**< 好友头像的Md5值 */
@property (nonatomic, assign) BOOL		bMyFriend;		/**< 该用户是否是我的好友 */

@end




/**
 @brief 陌生人信息
 */
@interface NdStrangerUserInfo : NSObject 
{
	NdBaseUserInfo	*baseUserInfo;
	NSString		*province;
	NSString		*city;
	int				sex;
	int				age;
	int				onlineStatus;
}

@property (nonatomic, retain) NdBaseUserInfo *baseUserInfo;	/**< 基础信息 */
@property (nonatomic, retain) NSString *province;			/**< 省份 */
@property (nonatomic, retain) NSString *city;				/**< 城市 */
@property (nonatomic, assign) int sex;						/**< 0＝未设置，1＝男，2＝女 */
@property (nonatomic, assign) int age;						/**< 年龄 */
@property (nonatomic, assign) int onlineStatus;				/**< 在线状态，0＝未知，1＝在线，2＝离线 */

@end




/**
 @brief 陌生人信息列表
 @note  records 存放的是NdStrangerUserInfo类型对象
 */
@interface NdStrangerUserInfoList : NdBasePageList {
}

+ (NSArray *)createUserListArray:(NSString *)users;			/**< 通用平台内部使用 */
- (void)replaceNickNameWithFriendRemark;					/**< 把列表中的好友昵称换成好友备注 */

@end




/**
 @brief 好友信息
 */
@interface NdFriendUserInfo : NSObject 
{
	NdBaseUserInfo	*baseUserInfo;
	NSString		*point;
	NSString		*emotion;
	int				onlineStatus;
}

@property (nonatomic, retain) NdBaseUserInfo *baseUserInfo;		/**< 基础信息 */
@property (nonatomic, retain) NSString		 *point;			/**< 积分 */
@property (nonatomic, retain) NSString		 *emotion;			/**< 心情 */
@property (nonatomic, assign) int			 onlineStatus;		/**< 在线状态：0＝未知，1＝在线，2＝离线 */

@end




/**
 @brief 查找到的好友信息列表
 @note  records 存放的是NdFriendUserInfo类型对象
 */
@interface NdFriendUserInfoList : NdBasePageList {
}

+ (NSArray *)createFriendInfo:(NSString *)friends;		/**< 通用平台内部使用 */
- (void)replaceNickNameWithFriendRemark;				/**< 把列表中的好友昵称换成好友备注 */

@end




/**
 @brief 好友应用信息
 */
@interface NdFriendAppInfo : NSObject 
{
	NdBaseAppInfo	*baseAppInfo;
	int				grade;
	NSString		*description;
	NSString		*opinion;
}

@property (nonatomic, retain) NdBaseAppInfo *baseAppInfo;		/**< 应用程序基础信息 */
@property (nonatomic, assign) int grade;						/**< 应用评级 */
@property (nonatomic, retain) NSString *description;			/**< 应用简介 */
@property (nonatomic, retain) NSString *opinion;				/**< 好友对应用评价 */

@end




/**
 @brief 高级查找参数
 */
@interface NdAdvanceSearch : NSObject 
{
	int ageBegin;
	int ageEnd;
	int sex;
	NSString *province;
	NSString *city;
}

@property (nonatomic, assign) int ageBegin;			/**< 若值为－1，则不使用该搜索条件 */
@property (nonatomic, assign) int ageEnd;			/**< 若值为－1，则不使用该搜索条件 */
@property (nonatomic, assign) int sex;				/**< 若值为－1，则不使用该搜索条件 , 0=未设置，1＝男，2＝女*/
@property (nonatomic, retain) NSString *province;	/**< 若值为nil，则不使用该搜索条件 */
@property (nonatomic, retain) NSString *city;		/**< 若值为nil，则不使用该搜索条件 */

@end


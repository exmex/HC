//
//  NdComPlatformAPIResponse.h
//  NdComPlatform_SNS
//
//  Created by Sie Kensou on 10-10-8.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ND_PHOTO_SIZE  {
	ND_PHOTO_SIZE_TINY = 0,		/**< 16 * 16像素		*/
	ND_PHOTO_SIZE_SMALL,		/**< 48 * 48像素		*/
	ND_PHOTO_SIZE_MIDDLE,		/**< 120*120像素		*/
	ND_PHOTO_SIZE_BIG,			/**< 200*200像素		*/
}   ND_PHOTO_SIZE_TYPE;

typedef enum _ND_LOGIN_STATE {
	ND_LOGIN_STATE_NOT_LOGIN = 0,	/**< 未登录		*/
	ND_LOGIN_STATE_GUEST_LOGIN,		/**< 游客账号登陆	*/
	ND_LOGIN_STATE_NORMAL_LOGIN,	/**< 普通账号登陆	*/
}ND_LOGIN_STATE;


typedef enum _ND_VERSION_CHECK_LEVEL {
	ND_VERSION_CHECK_LEVEL_STRICT = 0,     /**< 默认，严格等级，版本检测失败卡界面 */
	ND_VERSION_CHECK_LEVEL_NORMAL,         /**< 正常等级	*/
}ND_VERSION_CHECK_LEVEL;

typedef enum  _NdToolBarPlace
{
	NdToolBarAtTopLeft = 1,			/**< 左上 */
	NdToolBarAtTopRight,              /**< 右上 */
    NdToolBarAtMiddleLeft,            /**< 左中 */
	NdToolBarAtMiddleRight,           /**< 右中 */
	NdToolBarAtBottomLeft,            /**< 左下 */
	NdToolBarAtBottomRight,           /**< 右下 */
}	NdToolBarPlace;

/**
 @brief 分页信息
 */
@interface NdPagination : NSObject
{
	int pageIndex;
	int pageSize;
}

@property (nonatomic, assign) int pageIndex;		/**< 要获取的第几页记录，从1开始*/
@property (nonatomic, assign) int pageSize;			/**< 每页记录的个数（5的倍数），最大为50*/

@end

/**
 @brief 按页获取信息列表
 */
@interface NdBasePageList : NSObject
{
	NdPagination	*pagination;
	int				totalCount;
	NSArray*		records;
}

@property (nonatomic, retain) NdPagination *pagination;		/**< 分页结构体 */
@property (nonatomic, assign) int			totalCount;		/**< 总个数 */
@property (nonatomic, retain) NSArray*		records;		/**< 根据具体接口存放对应的数据 */

@end




#pragma mark -
#pragma mark  ------------ Guest Account ------------

typedef enum  _ND_GUEST_ACCOUNT_STATUS {
	ND_GUEST_ACCOUNT_STATUS_UNKNOWN = 0,	/**< 未知状态 */
	ND_GUEST_ACCOUNT_STATUS_LOGINED,		/**< 游客登录状态 */
	ND_GUEST_ACCOUNT_STATUS_REGISTERED,		/**< 游客注册为普通账号状态 */
} ND_GUEST_ACCOUNT_STATUS;

@interface NdGuestAccountStatus : NSObject
{
	int  guestAccountStatus;
}

@property (nonatomic, readonly) int  guestAccountStatus;	/**< 返回ND_GUEST_ACCOUNT_STATUS枚举值 */

- (BOOL)isGuestLogined;			/**< (guestAccountStatus == ND_GUEST_ACCOUNT_STATUS_LOGINED) */
- (BOOL)isGuestRegistered;		/**< (guestAccountStatus == ND_GUEST_ACCOUNT_STATUS_REGISTERED) */

+ (id)statusWithGuestLogined;
+ (id)statusWithGuestRegistered;

@end


#pragma mark -
#pragma mark  ------------ User Info ------------

/**
 @brief 用户详细信息
 */
@interface NdUserInfo : NSObject<NSCoding> 
{
	NSString	*uin;
	NSString	*nickName;
	int			bornYear;
	int			bornMonth;
	int			bornDay;
	int			sex;
	NSString	*province;
	NSString	*city;
	NSString	*trueName;
	NSString	*point;
	NSString	*emotion;
	NSString	*checkSum;
}

- (void)copyDataFromUserInfo:(NdUserInfo*)info;		/**< 浅复制 */
- (NSString*)provinceName;	/**< 通过province(ID)查询 获取省份名称 */
- (NSString*)cityName;		/**< 通过city(ID) 查询 获取城市名称 */
- (NSString*)provinceAndCityNameWithSplit:(NSString*)split;		/**< 把省份和城市名称合并，中间用分隔符。该方法的效率会比分别查询再自己合并来得高。 */


@property (nonatomic, retain) NSString *uin;		/**< 用户uin */
@property (nonatomic, retain) NSString *nickName;	/**< 昵称（1－20个字符，不可为空）*/
@property (nonatomic, assign) int bornYear;			/**< 出生年份，未知为空 */
@property (nonatomic, assign) int bornMonth;		/**< 出生月份，未知为空 */
@property (nonatomic, assign) int bornDay;			/**< 出生日，未知为空 */
@property (nonatomic, assign) int sex;				/**< 0＝未设置，1＝男，2＝女 */
@property (nonatomic, retain) NSString *province;	/**< 省份ID，未知为空 */
@property (nonatomic, retain) NSString *city;		/**< 城市ID，未知未空 */
@property (nonatomic, retain) NSString *trueName;	/**< 真实姓名（2－4个汉字），未知为空 */
@property (nonatomic, retain) NSString *point;		/**< 积分 */
@property (nonatomic, retain) NSString *emotion;	/**< 心情 */
@property (nonatomic, retain) NSString *checkSum;	/**< 好友头像的Md5值 */

@end




/**
 @brief 我的基础信息
 */
@interface NdMyBaseInfo : NSObject 
{
	NSString *uin;
	NSString *nickName;
	NSString *checkSum;
}

@property (nonatomic, retain) NSString *uin;			/**< 自己的uin */
@property (nonatomic, retain) NSString *nickName;		/**< 自己的昵称 */
@property (nonatomic, retain) NSString *checkSum;		/**< 自己的头像的checkSum */

@end




/**
 @brief 我的用户信息
 */
@interface NdMyUserInfo : NSObject 
{
	NdMyBaseInfo *baseInfo;
}

@property (nonatomic, retain) NdMyBaseInfo *baseInfo;	/**< 基础信息 */

@end




#pragma mark -
#pragma mark  ------------ Permission ------------


/**
 @brief 添加好友权限定义值
 */
typedef enum _ND_FRIEND_AUTHORIZE_TYPE 
{
	ND_FRIEND_AUTHORIZE_TYPE_READ = -1,					/**< 读取 */
	ND_FRIEND_AUTHORIZE_TYPE_NEED_AUTHORIZE,			/**< 需要验证才能添加 */
	ND_FRIEND_AUTHORIZE_TYPE_EVERYONE_CAN_ADD,			/**< 允许任何人添加 */
	ND_FRIEND_AUTHORIZE_TYPE_NO_ONE_CAN_ADD,			/**< 不允许任何人添加 */
} ND_FRIEND_AUTHORIZE_TYPE;

/**
 @brief 是否启用支付密码权限定义值
 */
typedef enum _ND_PAY_AUTHORIZE_TYPE
{
	ND_PAY_AUTHORIZE_TYPE_READ = -1,					/**< 读取*/
	ND_PAY_AUTHORIZE_TYPE_CLOSE,						/**< 关闭 */
	ND_PAY_AUTHORIZE_TYPE_OPEN,							/**< 启用 */
}ND_PAY_AUTHORIZE_TYPE;

/**
 @brief 是否已经设置帐号登录密码权限定义值
 */
typedef enum _ND_ACCOUNTS_AUTHORIZE_TYPE
{
	ND_ACCOUNTS_AUTHORIZE_TYPE_READ = -1,					/**< 读取*/
	ND_ACCOUNTS_AUTHORIZE_TYPE_CLOSE,						/**< 未设置 */
	ND_ACCOUNTS_AUTHORIZE_TYPE_OPEN,						/**< 已设置 */
}ND_ACCOUNTS_AUTHORIZE_TYPE;


/**
 @brief 用户的添加好友权限信息
 */
@interface NdAddFriendPermission : NSObject 
{
	ND_FRIEND_AUTHORIZE_TYPE		canAddFriend;
	NSString*						uin;
}

@property (nonatomic, assign) ND_FRIEND_AUTHORIZE_TYPE canAddFriend;			/**< uin对应的权限 */	
@property (nonatomic, retain) NSString*		uin;								/**< 用户uin, 为空时代表自己 */	

@end

/**
 @brief 是否启用支付密码权限信息
 */
@interface NdPayPasswordPermission : NSObject 
{
	ND_PAY_AUTHORIZE_TYPE			canPayPassword;
	NSString*						uin;
}

@property (nonatomic, assign) ND_PAY_AUTHORIZE_TYPE canPayPassword;				/**< uin对应的权限 */	
@property (nonatomic, retain) NSString*		uin;								/**< 用户uin, 为空时代表自己 */	

@end

/**
 @brief 是否已经设置帐号登录密码权限信息
 */
@interface NdPasswordPermission : NSObject 
{
	ND_ACCOUNTS_AUTHORIZE_TYPE		canPassword;
	NSString*						uin;
}

@property (nonatomic, assign) ND_ACCOUNTS_AUTHORIZE_TYPE canPassword;			/**< uin对应的权限 */	
@property (nonatomic, retain) NSString*		uin;								/**< 用户uin, 为空时代表自己 */	

@end


/**
 @brief 用户的权限信息
 */
@interface NdPermission : NSObject
{
	NdAddFriendPermission*	addFriendPermission;	
	NdPayPasswordPermission* payPasswordPermission;
	NdPasswordPermission* passwordPermission;
}

@property (nonatomic, retain) NdAddFriendPermission*	addFriendPermission;	/**< 添加好友权限 */
@property (nonatomic, retain) NdPayPasswordPermission*	payPasswordPermission;	/**< 是否启用支付密码权限 */ 
@property (nonatomic, retain) NdPasswordPermission*	passwordPermission;			/**< 设置帐号登录密码权限 */

@end



#pragma mark -
#pragma mark  ------------ App Info ------------

/**
 @brief 应用程序基础信息
 */
@interface NdBaseAppInfo : NSObject 
{
	int			appId;
	NSString	*appName;
	NSString	*checkSum;
}

@property (nonatomic, assign) int		appId;			/**< 应用程序Id */
@property (nonatomic, retain) NSString  *appName;		/**< 应用程序名称 */
@property (nonatomic, retain) NSString  *checkSum;		/**< 应用程序Icon的Md5值 */

- (NSString*)stringAppId;		/**< appId 以string的方式返回 */

@end




/**
 @brief 最新应用总数信息
 */
@interface NdProductNumInfo : NSObject
{
    NSString *currentTime;
    int      newProductNum;
}

@property (nonatomic, retain) NSString *currentTime;
@property (nonatomic, assign) int newProductNum;

@end




/**
 @brief 获取应用分享信息及其在资源中心的url地址
 */
@interface NdSharedMessageInfo : NSObject 
{
	NSString*	strAppInfo;
	NSString*	strAppUrl;
	NSString*	strTime;
}

@property (nonatomic, retain) NSString*	strAppInfo;	/**< 分享的信息 */
@property (nonatomic, retain) NSString*	strAppUrl;	/**< 应用在资源中心的页面地址 */
@property (nonatomic, retain) NSString*	strTime;	/**< 当前时间 */

@end



#pragma mark -
#pragma mark  ------------ Others ------------


/**
 @brief 版本升级信息
 */
@interface NdAppUpdateInfo : NSObject
{
	int updateType;
	NSString *theNewVersion;
	unsigned long softSize;
	NSString *updateUrl;
	NSString *resourceId;
}

@property (nonatomic,assign) int updateType;		/**< 更新类型，0＝版本一致，无须更新，1＝需要强制更新，2＝不需要强制更新 */
@property (nonatomic,retain) NSString *theNewVersion;	/**< 新版本号名称 */
@property (nonatomic,assign) unsigned long softSize;/**< 软件大小 */
@property (nonatomic,retain) NSString *updateUrl;	/**< 新版本下载url */
@property (nonatomic,retain) NSString *resourceId;	/**< 软件资源id */

@end




//
//  NdComPlatformAPIResponse+ThirdPlatform.h
//  NdComPlatformInt
//
//  Created by xujianye on 11-12-5.
//  Copyright 2011 NetDragon WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark  ------------ Third Platform ------------
/**
 @brief 第三方好友信息
 */
@interface Nd3rdFriendUserInfo : NSObject 
{
	NSString*	strFriendId;
	NSString*	strNickName;
	NSString*	strIconUrl;
	BOOL		isInvited;
}

@property (nonatomic, retain) NSString*	strFriendId;	/**< 好友id */
@property (nonatomic, retain) NSString*	strNickName;	/**< 好友昵称 */
@property (nonatomic, retain) NSString*	strIconUrl;		/**< 好友头像地址 */
@property (nonatomic, assign) BOOL		isInvited;		/**< 是否已经邀请过该好友 */

@end



/**
 @brief 第三方平台信息
 */
@interface Nd3rdPlatformInfo : NSObject 
{
	int			platformId;
	NSString	*platformName;
	NSString	*checkSum;
}

@property (nonatomic, assign) int		platformId;		/**< 平台id */
@property (nonatomic, retain) NSString *platformName;	/**< 平台名称 */
@property (nonatomic, retain) NSString *checkSum;		/**< 平台图标校验码 */

@end




/**
 @brief 第三方账号信息
 */
@interface Nd3rdAccountInfo : NSObject 
{
	BOOL		authorized;
	int			platformId;
	NSString*	str3rdAccount;
}

@property (nonatomic, assign) BOOL			authorized;			/**< 是否已授权，为NO时需要用户登录授权后才能使用该平台的功能，如发消息到该平台 */
@property (nonatomic, assign) int			platformId;			/**< 第三方平台id */
@property (nonatomic, retain) NSString*		str3rdAccount;		/**< 第三方账号 */

@end

/**
 @brief 第三方平台配置信息，用于授权
 */
@interface Nd3rdPlatformConfig : NSObject
{
	NSString *authorizeURL;
	NSString *callBackURL;
	NSString *backupURL;
}

@property (nonatomic, retain) NSString *authorizeURL;
@property (nonatomic, retain) NSString *callBackURL;
@property (nonatomic, retain) NSString *backupURL;

- (NSString*)stringForBackupUrlWith3rdPlatform:(int)platformId  thirdUserName:(NSString*)thirdUserName;

@end


#pragma mark -
#pragma mark  ------------ Others ------------

@interface NdImageInfo : NSObject
{
	BOOL		bScreenShot;
	UIImage*	imgCustomed;
	NSString*	strImgFile;
}

@property (nonatomic, readonly) BOOL		bScreenShot;		/**< 是否指定为当前屏幕图像，是为YES，否则NO */
@property (nonatomic, readonly) UIImage*	imgCustomed;		/**< 指定的内存图像 */
@property (nonatomic, readonly) NSString*	strImgFile;			/**< 指定的图片文件名 */

+ (id)imageInfoWithScreenShot;						/**< 使用当前屏幕的图像 */
+ (id)imageInfoWithImage:(UIImage*)image;			/**< 使用指定的image */
+ (id)imageInfoWithFile:(NSString*)file;			/**< 使用指定的图片文件 */

@end


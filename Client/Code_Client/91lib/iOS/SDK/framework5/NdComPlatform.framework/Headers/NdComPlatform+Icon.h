//
//  NdComPlatform+Icon.h
//  NdComPlatform_SNS
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"

@interface NdComPlatform(Icon)


/**
 @brief 获取默认图标
 @param nType 1＝默认用户头像，2＝默认应用图标，3＝默认商品图标
 @result 返回的头像
 */
- (UIImage *)NdGetDefaultPhoto:(int)nType;




/**
 @brief 获取用户头像
 @param uin			要获取的头像的uin
 @param checkSum	预期的头像checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新头像。
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getPortraitDidFinish:(int)error uin:(NSString *)uin portrait:(UIImage *)portrait checkSum:(NSString *)checkSum;
 @result 错误码
 */
- (int)NdGetPortrait:(NSString *)uin checkSum:(NSString *)checkSum delegate:(id)delegate;

/**
 @brief 获取用户头像UIImage
 @param uin			要获取的头像的uin
 @param imageType	图标大小类型
 @param checkSum	预期的头像checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新头像。
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getPortraitDidFinish:(int)error uin:(NSString *)uin portrait:(UIImage *)portrait checkSum:(NSString *)checkSum;
 @result 错误码
 */
- (int)NdGetPortraitEx:(NSString *)uin imageType:(ND_PHOTO_SIZE_TYPE)imgType checkSum:(NSString *)checkSum delegate:(id)delegate;

/**
 @brief 获取用户头像缓存文件
 @param uin			要获取的头像的uin
 @param imageType	图标大小类型
 @param checkSum	预期的头像checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新头像。
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getPortraitPathDidFinish:(int)error uin:(NSString *)uin portraitPath:(NSString *)portraitPath checkSum:(NSString *)checkSum;
 @result 错误码
 */
- (int)NdGetPortraitPath:(NSString *)uin imageType:(ND_PHOTO_SIZE_TYPE)imgType checkSum:(NSString *)checkSum delegate:(id)delegate;




/**
 @brief 获取应用图标UIImage(目前只支持ND_PHOTO_SIZE_SMALL类型)
 @param strAppId	指定的appId
 @param checkSum	预期的头像checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新图标
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getAppIconDidFinish:(int)error appId:(NSString *)appId icon:(UIImage *)icon checkSum:(NSString *)checkSum;
 @result 错误码
 */
- (int)NdGetAppIcon:(NSString*)strAppId  checkSum:(NSString*)checksum  delegate:(id)delegate;

/**
 @brief 获取应用图标缓存文件(目前只支持ND_PHOTO_SIZE_SMALL类型)
 @param strAppId	指定的appId
 @param checkSum	预期的头像checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新图标
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getAppIconPathDidFinish:(int)error appId:(NSString *)appId iconPath:(NSString *)iconPath checkSum:(NSString *)checkSum;
 @result 错误码
 */
- (int)NdGetAppIconPath:(NSString*)strAppId  checkSum:(NSString*)checksum  delegate:(id)delegate;




typedef	enum  _ND_SNS_BOARD_TYPE {
	ND_SNS_BOARD_LEADERBOARD = 0,		/**< 排行榜图标		*/
	ND_SNS_BOARD_ACHIEVEMENT = 1,		/**< 成就榜图标		*/
	ND_SNS_BOARD_VIRTUALGOODS= 8,		/**< 虚拟商品图标		*/
}	ND_SNS_BOARD_TYPE;

/**
 @brief下载榜图标
 @param strId		图标对应boardType的id（如排行榜id，成就榜id，虚拟商品id）
 @param boardType	图标种类
 @param photoType	图标大小类型
 @param checkSum	预期的图标checkSum, 如果为空，则优先使用本地缓存文件；如果与缓存checkSum不一致，则网络获取新图标。
 @param delegate	回调对象，回调接口参见 NdComPlatformUIProtocol
 @note 回调函数为：	- (void)getBoardIconDidFinish:(int)error strId:(NSString*)strId boardType:(ND_SNS_BOARD_TYPE)boardType photoType:(ND_PHOTO_SIZE_TYPE)photoType checksum:(NSString*)checksum image:(UIImage*)img;
 @result 错误码
 */
- (int)NdGetBoardIcon:(NSString*)strId boardType:(ND_SNS_BOARD_TYPE)boardType 
			photoType:(ND_PHOTO_SIZE_TYPE)photoType  checksum:(NSString*)checksum  delegate:(id)delegate;


@end




#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol_Icon

/**
 @brief NdGetPortrait 和 NdGetPortraitEx的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param uin 获取头像对应用户的uin
 @param portrait 获取到的头像
 @param checkSum 获取到的头像的checkSum
 */
- (void)getPortraitDidFinish:(int)error uin:(NSString *)uin portrait:(UIImage *)portrait checkSum:(NSString *)checkSum;

/**
 @brief NdGetPortraitPath的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param uin 获取头像对应用户的uin
 @param portraitPath 获取到的头像文件
 @param checkSum 获取到的头像的checkSum
 */
- (void)getPortraitPathDidFinish:(int)error uin:(NSString *)uin portraitPath:(NSString *)portraitPath checkSum:(NSString *)checkSum;

/*!
 NdGetAppIcon的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param appId 获取图标的对应应用程序的id
 @param icon 获取到的应用程序的图标
 @param checkSum 获取到的应用的checkSum 
 */
- (void)getAppIconDidFinish:(int)error appId:(NSString *)appId icon:(UIImage *)icon checkSum:(NSString *)checkSum;

/*!
 NdGetAppIconPath的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param appId 获取图标的对应应用程序的id
 @param iconPath 获取到的应用程序的图标文件
 @param checkSum 获取到的应用的checkSum 
 */
- (void)getAppIconPathDidFinish:(int)error appId:(NSString *)appId iconPath:(NSString *)iconPath checkSum:(NSString *)checkSum;

/**
 @brief NdGetBoardIcon的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件
 @param strId		图标对应boardType的id（如排行榜id，成就榜id，虚拟商品id）
 @param boardType	图标种类
 @param photoType	图标大小类型
 @param checksum	图标checksum
 @param img			图标
 */
- (void)getBoardIconDidFinish:(int)error strId:(NSString*)strId boardType:(ND_SNS_BOARD_TYPE)boardType photoType:(ND_PHOTO_SIZE_TYPE)photoType checksum:(NSString*)checksum image:(UIImage*)img;

@end
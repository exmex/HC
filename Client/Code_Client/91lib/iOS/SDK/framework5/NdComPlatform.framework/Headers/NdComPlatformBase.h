//
//  NdComPlatform.h
//  NdComPlatform_SNS
//
//  Created by Sie Kensou on 10-9-15.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NdComPlatformError.h"
#import "NdComPlatformAPIResponse.h"

@interface NdInitConfigure : NSObject
@property (nonatomic, assign) int appid;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, assign) ND_VERSION_CHECK_LEVEL versionCheckLevel;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL autoRotate;
@end


@interface NdComPlatform : NSObject {
	NSDictionary		*m_stepDict;
	id					m_updateDelegate;
	NdMyUserInfo		*m_myUserInfo;
	UIInterfaceOrientation	m_orientation;
	BOOL				m_shouldAutoRotate;
	BOOL				m_showLoadingWhenAutoLogin;
	BOOL				m_isPayDebugMode;
	BOOL				m_isUpdateDebugMode;
	UIViewController	*m_unRotateBaseCtrl;
    ND_VERSION_CHECK_LEVEL versionCheckLevel;
}

@property (nonatomic, assign) BOOL showLoadingWhenAutoLogin;					/**< 如果自动登录的时候不希望出现loading界面，请将该参数设置为NO */
@property (nonatomic, readonly, assign) UIInterfaceOrientation orientation;		/**< 当前平台的UI方向 */

/**
 @brief 获取NdComPlatform的实例对象
 */
+ (NdComPlatform *)defaultPlatform;

/**
 @brief 获取NdComPlatform的版本号
 */
+ (NSString *)version;

/**
 @brief 获取屏幕截图
 */
+ (UIImage *)NdGetScreenShot;

/**
 @brief 获取某视图的局域截图
 @param view 要截图的UIView
 @param captureRect 要截取的区域
 */
+ (UIImage *)NdGetViewCapture:(UIView *)view captureRect:(CGRect)captureRect;

/**
 @brief 设定平台为横屏或者竖屏
 */
- (void)NdSetScreenOrientation:(UIInterfaceOrientation)orientation;

/**
 @brief 设置是否自动旋转。
 @note 
 1:iPad默认开启自动旋转，iPhone默认关闭自动旋转
 2设置NO后，使用NdSetScreenOrientation设置的方向
 3设置Yes后，iPad支持4个方向切换自适应旋转；iPhone不支持横竖屏切换自适应旋转，仅支持横屏自适应旋转或者竖屏自适应旋转。
 */
- (void)NdSetAutoRotation:(BOOL)isAutoRotate;

/**
 @brief 设定调试模式
 @param nFlag 预留，默认为0
 */
- (void)NdSetDebugMode:(int)nFlag;




#pragma mark -
#pragma mark SDK接入时需要的验证信息

/**
 @brief 应用初始化 初始化完成后会发送kNdCPInitDidFinishNotification
 @param configure 初始化配置类
 */
- (int)NdInit:(NdInitConfigure *)configure;

/**
 @brief 暂停 暂停页消失后会发送kNdCPPauseDidExitNotification
 */
- (int)NdPause;

/**
 @brief 获取appId，需要预先设置
 */
- (int)appId;

/**
 @brief 获取应用软件名称，需要登录后才能获取
 */
- (NSString *)appName;


#pragma mark -
#pragma mark AssistantView And Toolbar
/**
 @brief 显示工具栏
 */
- (void)NdShowToolBar:(NdToolBarPlace)place;

/**
 @brief 隐藏工具栏
 */
- (void)NdHideToolBar;


#pragma mark -
#pragma mark Feedback 

/**
 @brief 用户反馈
 @result 错误码
 */
- (int)NdUserFeedBack;


#pragma mark -
#pragma mark Local Notification 

/**
 @brief 设置本地通知
 @param fireDate notification的倒计时时间，单位秒
 @param alertBody notification的消息内容
 @result 设置结果
 */
- (BOOL)NdSetLocalNotification:(NSTimeInterval)fireDate alertBody:(NSString*)alertBody;

/**
 @brief 取消所有已设置的本地通知
 */
- (void)NdCancelAllLocalNotification;




#pragma mark -
#pragma mark ChannelId

/**
 @brief 上传渠道id，需要先设置appId，无须登录
 @param delegate 回调对象
 @result 错误码
 */
- (int)NdUploadChannelId:(id)delegate;

@end




#pragma mark -
#pragma mark -

@protocol NdComPlatformUIProtocol

/**
 @brief NdUploadChannelId的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。错误码涵义请查看NdComPlatformError文件 
 */
- (void)uploadChannelIdDidFinish:(int)error;


@end


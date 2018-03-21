//
//  TBPlatform.h
//  tbGameSDK
//
//  Created by YLo. on 13-12-5.
//  Copyright (c) 2013年 tongbu.com. All rights reserved.
//
//  SDK Version : 3.2.2

#import <UIKit/UIKit.h>
#import "TBPlatformDefines.h"
#define DEPRECATED(_version) __attribute__((deprecated))

#pragma mark - 平台基本信息获取 **************************************************

@interface TBPlatform : NSObject

/**
 *  获取TBPlatform实例对象
 */
+ (TBPlatform *)defaultPlatform;

/**
 *  获取SDK的版本号
 */
+ (NSString *)version;

@end

#pragma mark - SDK基本选项设置接口 ***********************************************

@interface TBPlatform(BaseConfig)

/**
 *  配置是否打印SDK流程日志
 *
 *  @param isShow 是否打印控制台日志
 */
- (void)TBSetShowSDKLog:(BOOL)isShow;

/**
 *  @brief 设置是否自动旋转。
 *
 *  @note
 *
 *  1、默认开启自动旋转（横屏转横屏，竖屏转竖屏）
 *
 *  2、设置NO后，使用TBSetScreenOrientation设置的方向
 *
 *  3、游戏本身不能旋转的情况下请关闭！
 */
- (void)TBSetAutoRotation:(BOOL)isAutoRotate;

/**
 *	@brief	打开检查更新调试模式（提测前请注释该方法）
 *          打开调试模式后，平台检查更新默认会返回有更新；
 *          返回的更新是否强制，由开发商在dev.tongbu.com/game设置
 *
 *	@param 	nFlag 	预留，0
 */
- (void)TBSetUpdateDebugMode:(int)nFlag;

/**
 *	@brief	设置是否显示欢迎标题（默认为打开）
 *
 *	@param 	isShow 	BOOL，是否显示
 *
 */
- (void)TBSetWelcomeTipShow:(BOOL)isShow;

@end

#pragma mark - 平台初始化 *******************************************************

@interface TBPlatform(Init)

/**
 *	平台初始化方法
 *
 *	@param	appid       游戏ID
 *
 *	@param	orientation	平台初始方向
 *
 *	@param	isAccept	检查更新失败后是否允许进入游戏(网络不通或服务器异常可能导致检测失败)
 *                      若为允许，可能导致玩家跳过强制更新，一般情况下建议不允许
 */
- (void)TBInitPlatformWithAppID:(int)appid
              screenOrientation:(UIInterfaceOrientation)orientation
isContinueWhenCheckUpdateFailed:(BOOL)isAccept;

/**
 *  @brief 获取appId，需要预先设置
 */
- (int)appId;

@end

#pragma mark - 平台登录相关方法 **************************************************

@interface TBPlatform(UserAccountManager)

/**
 * 判断玩家是否已经登录平台
 */
- (BOOL)TBIsLogined;

/**
 *  @brief 注册界面入口
 *
 *  @param nFlag 标识（按位标识）预留，默认为0
 *
 *  @result 错误码
 */
- (int)TBRegister:(int) nFlag;

/**
 *  @brief 登录平台,进入登录或者注册界面入口
 *
 *  @param nFlag 标识（按位标识）预留，默认为0
 *
 *  @result 错误码
 */
- (int)TBLogin:(int) nFlag;

/**
 *  @brief 注销
 *
 *  @param nFlag 标识（按位标识）0,表示注销但保存本地信息；1，表示注销，并清除自动登录
 *
 *  @result 错误码
 */
- (int)TBLogout:(int) nFlag;

/**
 *  @brief 切换账号（logout+login），会注销当前登录的账号，取消自动登录。
 */
- (void)TBSwitchAccount;

@end

#pragma mark - 悬浮工具条控制 *****************************************************

@interface TBPlatform(ToolBar)
/**
 *  显示悬浮工具条
 *
 *  @param place         位置
 *
 *  @param isUseOldPlace 在有历史位置的情况是否使用历史位置
                        （包括使用上次退出游戏前浮动按钮的最后位置，建议YES）
 */
- (void)TBShowToolBar:(TBToolBarPlace)place isUseOldPlace:(BOOL)isUseOldPlace;

/**
 *  隐藏悬浮工具条
 */
- (void)TBHideToolBar;

@end

#pragma mark - 用户信息获取（登录完成后）*******************************************

@interface TBPlatform(UserInformation)

/**
 *  @brief  获取登录帐户的信息
 *
 *  @result 当前登录帐户的信息，包含用户ID，昵称等。
 *
 *  @note   该接口在登录后立即返回
 */
- (TBPlatformUserInfo *)TBGetMyInfo;

/**
 *  @brief 获取本次登录的sessionId，需要登录后才能获取(时效2分钟)
 */
- (NSString *)sessionID;

/**
 *  @brief 获取登录后的昵称
 */
- (NSString *)nickName;

/**
 *	@brief	获取用户ID（唯一标识）
 */
- (NSString *)userID;

@end

#pragma mark - 支付充值、订单查询 *************************************************

@interface TBPlatform(Payment)

/**
 *  @brief 进行虚拟币充值或商品购买（需登录，同步后台记录充值账号记录）
 *
 *  @param orderSerial     合作商订单号，必须保证唯一，双方对帐的唯一标记(最大长度255)
 *
 *  @param needPayRMB      需要支付的金额，单位：元（大于0，否则进入自选金额界面）
 *
 *  @param payDescription  支付描述，发送支付成功通知时，返回给开发者(最大长度255)
 *
 *  @param delegate        回调对象，见TBBuyGoodsProtocol协议
 *
 *  @result 错误码
 */
- (int)TBUniPayForCoin:(NSString*)orderSerial
            needPayRMB:(int)needPayRMB
        payDescription:(NSString*)payDescription
              delegate:(id<TBBuyGoodsProtocol>)buyDelegate;

/**
 *  @brief 进行充值。该接口直接进入Web页充值，无回调，开发者可以使用TBCheckPaySuccess:delegate:接口进行订单查询
 *
 *  @param orderSerial     合作商订单号，必须保证唯一，双方对帐的唯一标记(最大长度255)
 *
 *  @param payDescription  支付描述，发送支付成功通知时，返回给开发者
 *
 *  @result 错误码
 */
- (int)TBUniPayForCoin:(NSString*)orderSerial
        payDescription:(NSString*)payDescription;

/**
 *  @brief 查询支付是成功
 *
 *  @param strCooOrderSerial	支付订单号
 *
 *  @param delegate	    	回调对象，回调接口参见 TBPayDelegate
 *
 *  @result 错误码
 */
- (int)TBCheckPaySuccess:(NSString*)strCooOrderSerial
                delegate:(id<TBCheckOrderDelegate>)delegate;
@end

#pragma mark - 进入各种中心 *********************************************************

@interface TBPlatform (Center)

/**
 *	@brief	进入用户中心
 *
 *	@param 	nFlag 	预留，默认为0
 */
- (void)TBEnterUserCenter:(int)nFlag;

/**
 *  @brief 进入游戏大厅
 *
 *  @param nFlag 预留，默认为0。
 */
- (void)TBEnterAppCenter:(int) nFlag;

/**
 *  @brief 进入短信箱
 *
 *  @param nFlag 预留，默认为0。
 */
- (void)TBEnterUserMessageBox:(int)nFlag;

/**
 *  @brief  进入应用论坛 （论坛需要找同步商务配置，具体联系接入专员）
 *
 *  @param  nFlag 预留，目前传0即可
 *
 *  @result 错误码
 */
- (int)TBEnterAppBBS:(int)nFlag;

@end

#pragma mark -
#pragma mark - 废弃、或即将废弃的方法，勿用 *********************************************

@interface TBPlatform(Deprecated)

/**
 *  处理打开程序的URL
 *
 *  @param url 打开的url
 */
- (void)TBHandleOpenURL:(NSURL *)url DEPRECATED(3_2_2);

/**
 *  @brief 设置应用Id
 *
 *  @deprecated 使用 -TBInitPlatformWithAppID:screenOrientation:isContinueWhenCheckUpdateFailed:
 *
 *  @param appId 应用程序id，需要向用户中心申请，合法的id大于0
 */
- (BOOL)setAppId:(int)appId DEPRECATED(3_2_2);

/**
 *  @brief 设定平台初始方向
 *
 *  @deprecated 使用 -TBInitPlatformWithAppID:screenOrientation:isContinueWhenCheckUpdateFailed:
 */
- (void)TBSetScreenOrientation:(UIInterfaceOrientation)orientation DEPRECATED(3_2_2);

/**
 *  设置是否支持iOS7，使用iPhoneSDK 7.0（Xcode5.0以上）编译工程时请打开此选项
 */
- (void)TBSetSupportIOS7:(BOOL)isSupport DEPRECATED(3_2_1);

/**
 *  设置是否保存游戏窗口
 *
 *  @param isSave 是否保存
 */
- (void)TBSetIsSaveGameWindow:(BOOL)isSave DEPRECATED(3_2_2);

/**
 *  设置是否安全提示
 */
- (void)TBSetIsShowSafetyAlert:(BOOL)isShow DEPRECATED(3_2_2);

/**
 *  获取用户登录账号（预留方法，随时可能关闭，不要用作用户唯一标识）
 */
- (NSString *)accountStr DEPRECATED(3_2_1);

@end

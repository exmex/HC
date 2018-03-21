//
//  UCGameSdk.h
//
//  本文件主要包含两部分声明：
//  1 SDK NSNotification名称
//  2 sdk入口api的定义 UCGameSdk
//  3 部分API回调的协议 UCGameSdkUIProtocol
//
//  Created by Xiao Lei on 13年2月26日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 常量定义

//SDK 初始化，在 SDK 初始化完成后进行通知
#define UCG_SDK_MSG_SDK_INIT_FIN        @"ucg_sdk_msg_init_fin"

//用户登陆，在用户登陆或者用户完成注册点击“马上加入”后进行通知
#define UCG_SDK_MSG_LOGIN_FIN           @"ucg_sdk_msg_login_fin"

//用户支付，在用户完成充值后进行通知
#define UCG_SDK_MSG_PAY_FIN             @"ucg_sdk_msg_pay_fin"

//SDK 未登录退出，在SDK退出后进行通知
#define UCG_SDK_MSG_EXIT_WITHOUT_LOGIN  @"ucg_sdk_msg_exit_without_login"

//SDK 支付界面退出，在游戏调用SDK支付界面，退出支付界面后进行通知
#define UCG_SDK_MSG_PAY_EXIT            @"ucg_sdk_msg_pay_exit"

//SDK 个人中心界面退出，在游戏调用SDK个人中界面，退出个人中心界面后进行通知
#define UCG_SDK_MSG_USER_CENTER_EXIT    @"ucg_sdk_msg_user_center_exit"

//SDK 进入SDK页面
#define UCG_SDK_MSG_SDK_ENTER           @"ucg_sdk_msg_sdk_enter"
//SDK 退出SDK页面
#define UCG_SDK_MSG_SDK_EXIT            @"ucg_sdk_msg_sdk_exit"

//SDK 用户注销当前登录账号，在用户注销当前登录账号时进行通知
#define UCG_SDK_MSG_LOGOUT              @"ucg_sdk_msg_logout"


//SDK 


// 调用 payWithPaymentInfo: 时paymentInfo这个字典的有效的key值
// 是否支持连续充值功能，默认为YES，即支持连续充值
#define UCG_SDK_KEY_PAY_ALLOW_CONTINUOUS_PAY    @"allowContinuousPay"
// 游戏合作商自定义参数，在充值完成后会回调给游戏服务器
#define UCG_SDK_KEY_PAY_CUSTOM_INFO             @"customInfo"
// 游戏角色id，在充值完成后会回调给游戏服务器
#define UCG_SDK_KEY_PAY_ROLE_ID                 @"roleId"
// 游戏角色名，在充值完成后会回调给游戏服务器
#define UCG_SDK_KEY_PAY_ROLE_NAME               @"roleName"
// 角色等级，在充值完成后会回调给游戏服务器
#define UCG_SDK_KEY_PAY_GRADE                   @"grade"
// 定额支付金额，单位为元，最小单位为1元
#define UCG_SDK_KEY_PAY_AMOUNT                  @"payAmount"

/*
 控制sdk自身日志的输出，范围从大到小：UCLOG_LEVEL_DEBUG > UCLOG_LEVEL_WARNING > UCLOG_LEVEL_ERR
 UCLOG_LEVEL_DEBUG：debug日志，warning日志，error日志都会输出
 UCLOG_LEVEL_WARNING：忽略debug日志，只输出warning及error日志
 UCLOG_LEVEL_ERR：忽略debug及warning日志，只输出error日志
 */
typedef enum {
    UCLOG_LEVEL_ERR = 0,
    UCLOG_LEVEL_WARNING = 1,
    UCLOG_LEVEL_DEBUG = 2
} UCLogLevel;

/*
 设置SDK横竖屏方向，请将SDK的屏幕方向与游戏的屏幕方向设置一致
 UC_PORTRAIT                :   竖屏，包含竖屏正方向，竖屏反方向
 UC_LANDSCAPE               :   横屏，包含横屏向右，横屏向左
 UC_PORTRAIT_UP             :   竖屏正方向
 UC_PORTRAIT_UPSIDE_DOWN    :   竖屏反方向
 UC_LANDSCAPE_RIGHT         :   横屏向右
 UC_LANDSCAPE_LEFT          :   横屏向左
 */
typedef enum {
    UC_PORTRAIT                 =       0,
    UC_LANDSCAPE                =       1,
    UC_PORTRAIT_UP              =       2,
    UC_PORTRAIT_UPSIDE_DOWN     =       3,
    UC_LANDSACPE_RIGHT          =       4,
    UC_LANDSACPE_LEFT           =       5
} UCOrientation;


#pragma mark - 数据模型

/**
 @brief 结果数据模型
 */
@interface UCResult : NSObject

@property (assign, nonatomic) BOOL isSuccess;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) id data;
@property (assign, nonatomic) int statusCode;

+ (UCResult *)resultWithIsSuccess:(BOOL)isSuccess message:(NSString *)message data:(id)data;

@end

/**
 @brief 好友信息
 */
@interface UCFriendInfo : NSObject
{
    int ucid;
}

/*
 ucid:UC帐号标识
 */
@property (nonatomic, assign) int ucid;


@end

/**
 @brief 查找到的好友信息列表
 @note  entityList存放的是UCFriendInfo类型对象
 */

@interface UCFriendList : NSObject {
    int	totalCount;
    NSArray* entityList;
}

/*
 用户好友总数
 */
@property (nonatomic, assign) int totalCount;

/*
 当次获取的用户某页好友列表
 */
@property (nonatomic, retain) NSArray* entityList;

@end



#pragma mark - 协议

@protocol UCGameSdkProtocol<NSObject>

@optional
/**
 @brief getUCZoneFriendList的回调
 @param error 错误码，如果error为0，则代表API执行成功，否则失败。
 @param pageIndex  页索引, 索引从1开始
 @param pageSize 每页好友个数
 @param friendList 应用好友信息列表
 */
- (void)getUCZoneFriendListDidFinish:(int)error pageIndex: (int) pageIndex pageSize: (int)pageSize friendList:(UCFriendList *)friendList;

/**
 @brief 同步游戏官方帐号登录校验，在游戏方支持官方帐号登录，即UCGameSdk类中的allowGameUserLogin=YES时，必须实现此函数
 @param gameUser 游戏官方帐号
 @param gamePassword  游戏官方帐号密码
 @return 如果校验通过，返回的字典中包括处理结果标识 resultCode，处理结果描述 resultMsg，如果校验通过的话，还会有会话标识 sid；
 其中resultCode=0表示校验通过，此时需要将SDK Server返回的sid一并返回给SDK；
 其他非0情况则代表校验不通过，而resultMsg 则是结果的字符描述，在校验不通过的情况下，会将resultMsg显示到对话框中提示用户，请确保此resultMsg友好，并能正确的提示用户.
 */
- (UCResult *)verifyGameUser:(NSString *)gameUser gamePassword:(NSString *)gamePassword;

/**
 @brief 异步游戏官方帐号登录校验，在游戏方支持官方帐号登录，即UCGameSdk类中的allowGameUserLogin=YES时，必须实现此函数
 @param gameUser 游戏官方帐号
 @param gamePassword  游戏官方帐号密码
 @return 如果校验通过，返回的字典中包括处理结果标识 resultCode，处理结果描述 resultMsg，如果校验通过的话，还会有会话标识 sid；
 其中resultCode=0表示校验通过，此时需要将SDK Server返回的sid一并返回给SDK；
 其他非0情况则代表校验不通过，而resultMsg 则是结果的字符描述，在校验不通过的情况下，会将resultMsg显示到对话框中提示用户，请确保此resultMsg友好，并能正确的提示用户.
 */
- (void)verifyAsynGameUser:(NSString *)gameUser gamePassword:(NSString *)gamePassword;


@end


#pragma mark - SDK类（主要的逻辑调用都在此类中）

@interface UCGameSdk : NSObject

/*
 cp在UC标识的ID，由UC分配
 */
@property(assign, nonatomic) int cpId;

/*
 游戏在UC标识的ID，由UC分配
 */
@property(assign, nonatomic) int gameId;

/*
 游戏在UC标识的名称
 */
@property(retain, nonatomic) NSString *gameName;


/*
 游戏的区服标识，如需改变此值，只需直接设置即可起作用，不必再次初始化
 */
@property(assign, nonatomic) int serverId;

/*
 游戏的渠道标识
 */
@property(retain, readonly, nonatomic) NSString *channelId;

/*
 是否允许官方帐号登录，如置成YES，请务必实现 UCGameSdkProtocol 协议中的- (NSDictionary *)verifyGameUser:gamePassword:方法
 */
@property(assign, nonatomic) BOOL allowGameUserLogin;

/*
 游戏官方帐号名称，如果设置此参数，在SDK的登录界面中，将使用此参数显示，如可设置此参数为“三国号”，如果未设置此参数，则默认使用“游戏官方帐号”显示
 */
@property(retain, nonatomic) NSString *gameUserName;

/*
 是否为调试模式，如果置为YES，代表是调试模式，将连接SDK Server的测试环境进行调试；置为NO，表示正式运营模式，将连接SDK Server的正式环境；
 请确保此参数的设置与游戏服务器连接的SDK Server的环境保持一致
 */
@property(assign, nonatomic) BOOL isDebug;

/*
 控制sdk自身日志的输出，范围从大到小：UCLOG_LEVEL_DEBUG > UCLOG_LEVEL_WARNING > UCLOG_LEVEL_ERR，
 具体的取值说明可参见 UCLogLevel 类型
 */
@property(assign, nonatomic) UCLogLevel logLevel;

/*
 是否允许用户在个人中心中更换账号（更换账号是指：先注销已登录账号，然后显示登录界面供用户登录新账号），默认不支持更换账号
 */
@property(assign, nonatomic) BOOL allowChangeAccount;

/*
 在个人中心是否隐藏充值记录入口，此属性应用场景:上App Stroe的游戏，不包含充值功能，所以可选择性去除个人中心中充值记录的入口，默认不隐藏
 */
@property(assign, nonatomic) BOOL isHidePayHistoryEntrance;

/*
 设置SDK横竖屏方向，请将SDK的屏幕方向与游戏的屏幕方向设置一致
 UC_PORTRAIT                :   竖屏，包含竖屏正方向，竖屏反方向
 UC_LANDSCAPE               :   横屏，包含横屏向右，横屏向左
 UC_PORTRAIT_UP             :   竖屏正方向
 UC_PORTRAIT_UPSIDE_DOWN    :   竖屏反方向
 UC_LANDSCAPE_RIGHT         :   横屏向右
 UC_LANDSCAPE_LEFT          :   横屏向左
 */
@property(assign, nonatomic) UCOrientation orientation;

/*
 是否显示悬浮按钮，YES为显示，NO为不显示
 */
@property(assign, nonatomic) BOOL isShowFloatButton;

/*
 设置悬浮按钮的初始位置
 x,y的值为百分比
 x只能是0或100，0表示屏幕左边，100表示屏幕右边
 y可以是0~100,0表示屏幕上面，100表示屏幕下面
 */
@property(assign, nonatomic)CGPoint floatButtonPosition;


/*
 exInfo 个人中心消息Info类，现其中的属性包括:
 cpServiceContact:NSString cp服务客服电话，使用“\n”进行还行，可传类似的文字：三国争霸\n客服电话：020-1234567
 */
// @property(retain, nonatomic) ExInfo *exInfo;  // 此属性已经取消，意见反馈已经统一接入游戏中心的玩家客服系统

/**
 @brief 获取UCGameSdk的实例对象
 */
+ (UCGameSdk *)defaultSDK;

/**
 *@brief 初始化sdk.
 */
- (void)initSDK;

/**
 *@brief 获取游戏参数.
 */
- (NSDictionary *)getGameParams;

/**
 *@brief 获取当前登录用户的会话标识 session id，如果此标识不为空，则代表已有用户登录
 */
- (NSString *)sid;


#pragma mark - UI

/**
 *@brief 进入登录界面，默认不支持官方帐号登录
 */
- (void)login;

- (void)logout;

/**
 *@brief 进入登录界面，如果支持官方帐号登陆，请调用此登录方法，官方帐号的校验会通过调用delegate中的- verifyGameUser：gamePassword:方法进行校验，请确保此方法正确的实现
 */
- (void)loginWithDelegate:(id<UCGameSdkProtocol>)delegate;

/**
 @brief 进入支付页面，并带上所需的参数
 @param paymentInfo 可定制性字典，现支持的参数包括:
 allowContinuousPay:BOOL 是否支持连续充值功能，默认为YES，即支持连续充值
 customInfo:NSString 游戏合作商自定义参数
 roleId:NSString 游戏角色id
 roleName:NSString 游戏角色名
 grade:NSString 角色等级
 payAmount:float 默认为0, 如果大于0则表示用户不可选择金额
 @result 暂无，支付成功后，订单信息将通过NSNotification进行通知；
 而在用户退出支付界面时，也会发起NSNotification通知，具体请参考文档
 */
- (void)payWithPaymentInfo:(NSDictionary *) paymentInfo;


/**
 @brief 进入个人管理界面
 @result 暂无，在用户退出个人管理界面时，会发起NSNotification通知，具体请参考文档
 */
- (void)enterUserCenter;

/**
 @brief 显示/隐藏悬浮按钮, 此方法是在设置 isShowFloatButton 为 YES 的情况下才有作用。
 @param visible YES:显示悬浮按钮; NO:隐藏悬浮按钮.
 @result 无
 */

- (void)showFloatButton:(BOOL)visible;


#pragma mark - Sns api
/**
 @brief 获取UC小乐园好友
 @param pageIndex  页索引, 索引从1开始
 @param pageSize 每页好友个数
 @param type  好友关系 目前仅有1 表示为熟人
 @param delegate 回调对象，回调接口参见 UCGameSdkProtocol
 @result 暂固定返回0，方便以后进行扩展
 */
- (int)getUCZoneFriendList:(int)pageIndex pageSize:(int)pageSize type:(int)type delegate:(id<UCGameSdkProtocol>)delegate;



#pragma mark - Extend data
/**
 @brief 游戏数据收集通用接口，登录成功后才可调用
 @param type  NSString 表示数据种类
 @param data  NSDictionary 表示数据内容
 
 现有使用场景：
 场景：游戏中为用户成功创建游戏角色时，提交该“创建游戏角色”数据。
 type取值：createGameRole
 data取值：
 {
 "roleId":"string",     //必填，角色ID
 "roleName":"string",  //必填，角色名称
 "serverId":int,         //必填，游戏服务器ID
 "serverName":"string", //可选，游戏服务器名称
 }
 */
- (void)submitExtendDataWithType:(NSString *)type data:(NSDictionary *)data;

#pragma mark - Alipay app url handle
/**
 @brief 支付宝app支付完成后，跳回游戏，支付结果处理接口
 @param url             NSURL
 @param application     UIApplication
 
 请在程序的 xxxAppDelegate 类中的
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 方法中调用此接口，从而能支付宝app中正确的跳回游戏中
 
 */
- (void)parseAliPayResultWithURL:(NSURL *)url application:(UIApplication *)application;

#pragma mark - Asyn game account result
/**
 @brief 异步校验游戏账号结果回调
 @param result             UCResult
 
 使用异步的游戏老账号校验接口时，请校验完成后请调用此方法将校验结果通知回SDK
 
 */
- (void)postVerifyGameUserReuslt:(UCResult *)result;

@end
//
//  KYSDK.h
//  KYSDK
//
//  Created by MTang0589 on 14-2-24.
//  Copyright (c) 2014年 MTang0589. All rights reserved.
// sdk版本-----1.6.1

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KYMobilePay.h"

enum{
    SERVICE_CHECK = -1,     //等待服务器验证
    PAY_SUCCESS = 0,        //结果正确
    PAY_FAILE = 1,          //结果错误
    PAY_ERROR = 2          //验证失败
}typedef CHECK;

enum{
    USER_UNIPAY_SUCCESS,  //用户银联支付成功
    USER_UNIPAY_FAIL,    //用户银联支付失败
    USER_UNIPAY_CANCEL,    //用户取消银联支付
    USER_UNIPAY_ERROR    //银联没有返回结果
}typedef UNIPAYTYPE;

enum{
    KYLOG_ONGAMENAME,//显示游戏账号登录
    KYLOG_OFFGAMENAME//不显示游戏账号登录
}typedef KYLOGOPTION;

@protocol KYSDKDelegate <NSObject>
@optional
/**
 *  @method -(void)UPPayPluginResult:(UNIPAYTYPE *)result
 *  银联支付回调函数
 *  @param  result 支付结果
 */
-(void)UPPayPluginResult:(UNIPAYTYPE)result;

/**
 *  @method - (void)onBillingResult:(BillingResultType)resultCode billingIndex:(NSString *)index message:(NSString *)message
 *  中国移动支付回调
 *  @param  resultCode
 *  @param  index
 *  @param  message 
 */
- (void)onBillingResult:(BillingResultType)resultCode billingIndex:(NSString *)index message:(NSString *)message;

/**
 *  @method - (void)submitMobilePay
 *  中国移动支付需用户自行调用响应方法，SDK仅通过回调方法告知用户
 */
- (void)submitMobilePay;

/**
 *  @method - (void)submitMobilePay
 *  关闭支付界面回调，可以在此时向服务器查询支付结果
 */
-(void)closePayCallback;


/**
 *  @method-(void)logCallBack:(NSString *)tokenKey
 *  用户登录回调
 *  @param  tokenKey
 **/
-(void)loginCallBack:(NSString *)tokenKey;

/**
 *  @method-(void)quickLogCallBack:(NSString *)tokenKey
 *  用户快速登录回调
 *  @param  tokenKey
 **/
-(void)quickLogCallBack:(NSString *)tokenKey;

/**
 *游戏账号登陆成功回调
 **/
-(void)gameLoginSuc;

/**
 *  @method-(void)logOutCallBack:(NSString *)guid
 *  注销方法，userLogOut该方法回调
 *  @param  guid
 **/
-(void)logOutCallBack:(NSString *)guid;

/**
 *  @method-(void)cancelUpdateCallBack
 *  游戏取消更新回调（单独使用更新时）
 **/
-(void)cancelUpdateCallBack;

/**
 *  @method-(void)gameLoginCallback:(NSString *)username password:(NSString *)password
 *  游戏账号登陆回调
 **/
-(void)gameLoginCallback:(NSString *)username password:(NSString *)password;

/**
 *-(void)callBackForgetGamePwd
 *游戏账号忘记密码回调
 **/
-(void)callBackForgetGamePwd;

/*
 *游戏账号发送验证码回调
 */
-(void)logSendSMSCallback:(NSString *)phoneNO;


@end

@interface KYSDK : NSObject
@property(assign, nonatomic)id<KYSDKDelegate> sdkdelegate;

+(id)instance;

/**
设置是否只支持iphone
 **/
-(void)setOnlySupportIPhone:(BOOL)isOnlySupportIPhone;

/**
 显示支付
 dealseq：订单号
 fee：金额，默认填写6位小数点，建议保存2位
 game：http://payquery.bppstore.com上面对应ID
 gamesvr：若游戏存在多通告地址，通知@快用-技术支持在后台录入，然后在此传入数字gamesvr的值
 md5Key：http://payquery.bppstore.com该网址对应的密匙
 userid:账户名，单机游戏必须传入值，网游填空
 **/
-(void)showPayWith:(NSString *)dealseq fee:(NSString *)fee game:(NSString *)game gamesvr:(NSString *)gamesvr subject:(NSString *)subject md5Key:(NSString *)md5Key userId:(NSString*)userId;
/**
显示用户界面
 **/
-(void)showUserView;

/**
 显示用户中心界面
 **/
-(void)setUpUser;

/**
 记住上次用户直接登录
 **/
-(void)logWithLastUser;

/**
 注销当前用户，回调游戏
 **/
-(void)userLogOut;
/**
 注销当前用户，返回登录界面
 **/
-(void)userBackToLog;
/**
 主动调用检查更新。若无须在游戏启动时调用，则忽略此方法；若使用，则必须处理回调-(void)cancelUpdateCallBack;
 **/
-(void)checkUpdate;

/**
 控制登陆界面是否含有游戏账号的选项（新游戏没有老用户时，可将游戏账号关掉）
 **/
-(void)changeLogOption:(KYLOGOPTION)option;

/**
 *游戏账号登陆时，传入用户名密码
 **/
-(void)gameLoginWithArray:(NSMutableArray *)array;

/**
 *是否需要输入邀请码（如，游戏封测时需要输入邀请码,默认不需要）
 *参数isShowVerifycdKey：YES，需要邀请码。NO，不需要邀请码
 **/
-(void)verifycdKeyOption:(BOOL)isShowVerifycdKey;

/**
 *游戏账号是否错误
 */
-(void)showStateGame:(NSString *)state;

/**
 *设置是否开启游戏账号忘记密码功能
 **/
-(void)setISShowForgetGamePwd:(BOOL)isShowForgetGamePwd;

/**
 *是否开启游戏账号登录发送短息功能
 */
-(void)setISSendSMS:(BOOL)isShowSendSMS;


@end

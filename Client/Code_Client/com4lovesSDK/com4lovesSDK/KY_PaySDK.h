//
//  KY_PaySDK.h
//  KY_PaySDK
//
//  Created by 悠然天地 on 13-6-3.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEALSEQ @"dealseq"

#define RESULT_CODE @"code"
#define RESULT_STR @"resultStr"

#define STATE_SELECT @"select"

#define BOUNDS [[UIApplication sharedApplication].delegate window].rootViewController.view.bounds
#define FRAME [[UIApplication sharedApplication].delegate window].rootViewController.view.frame

enum{
    SERVICE_CHECK = -1,     //等待服务器验证
    PAY_SUCCESS = 0,        //结果正确
    PAY_FAILE = 1,          //结果错误
    PAY_ERROR = 2          //验证失败
}typedef CHECK;

enum{
    USER_DOUNIONPAY = 0,    //用户进行银联支付
    USER_DOCARDPAY = 1,     //用户提交了卡类订单
    USER_CLOSEVIEW = 2,     //用户关闭了支付界面
    USER_DOALIPAY = 3       //用户使用了支付宝wap
}typedef BEHAVIOR;

@protocol KY_PaySDKDelegate <NSObject>

//银联支付结果
- (void)unionpayResult:(NSDictionary *)resultMap;

//切换到 快捷支付 时, 界面按钮点击通知
- (void)payStateClick:(NSDictionary *)stateMap;

//快捷支付 验证
- (void)checkResult:(CHECK)result;

//用户行为
-(void)userBehavior:(BEHAVIOR)kind;

@end

@interface KY_PaySDK : UIView


@property (nonatomic, retain) id<KY_PaySDKDelegate> ky_delegate;

//得到SDK规格的字符串(加密MD5用)
+ (NSString *)getMD5Str:(NSDictionary *)map;

//获得MD5字符串
+ (NSString *)getMD5:(NSString *)str;

//单例对象
+ (KY_PaySDK *) instance;

//设置参数并打开支付
- (void) setValue:(NSDictionary *)valueMap;

//设置银联所需的UIViewController, 以及"快捷支付"需要的urlScheme
- (void) setViewController:(UIViewController *) viewCtrl andAppScheme:(NSString *)appScheme;

//检测支付宝"快捷支付"结果
- (CHECK) checkAlipayResult:(NSURL *)url;

@end

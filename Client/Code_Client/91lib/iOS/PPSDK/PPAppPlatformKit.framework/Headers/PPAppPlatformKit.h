//
//  PPAppPlatformKit
//  Created by 张熙文 on 1/11/13.
//  Copyright (c) 2013 张熙文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAppPlatformKitConfig.h"
#import "PPUIKit.h"

@class PPAppPlatformKit;

/**
 * @protocol   PPAppPlatformKitDelegate
 * @brief   SDK接口回调协议
 */
@protocol PPAppPlatformKitDelegate <NSObject>
@required

/**
 * @brief   余额大于所购买道具
 * @param   INPUT   paramPPPayResultCode       接口返回的结果编码
 * @return  无返回
 */
- (void) ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode;

/**
 * @brief   验证更新成功后
 * @noti    分别在非强制更新点击取消更新和暂无更新时触发回调用于通知弹出登录界面
 * @return  无返回
 */
- (void) ppVerifyingUpdatePassCallBack;

/**
 * @brief   登录成功回调【任其一种验证即可】
 * @param   INPUT   paramStrToKenKey       字符串token
 * @return  无返回
 */
- (void) ppLoginStrCallBack:(NSString *)paramStrToKenKey;

/**
 * @brief   关闭Web页面后的回调
 * @param   INPUT   paramPPWebViewCode    接口返回的页面编码
 * @return  无返回
 */
- (void) ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode;

/**
 * @brief   关闭SDK客户端页面后的回调
 * @param   INPUT   paramPPPageCode       接口返回的页面编码
 * @return  无返回
 */
- (void) ppClosePageViewCallBack:(PPPageCode)paramPPPageCode;

/**
 * @brief   注销后的回调
 * @return  无返回
 */
- (void) ppLogOffCallBack;

@optional
/**
 * @brief   登录成功回调【任其一种验证即可】
 * @param   INPUT   paramHexToKen          2进制token
 * @return  无返回
 */
- (void) ppLoginHexCallBack:(char *)paramHexToKen;
@end


@interface PPAppPlatformKit : NSObject
{
    
}
/**
 *  代理
 */
@property (nonatomic, retain) id<PPAppPlatformKitDelegate> delegate;

/**
 * @brief     初始化SDK信息
 * @return    PPAppPlatformKit    生成的PPAppPlatformKit对象实例
 */
+ (PPAppPlatformKit *) sharedInstance;

/**
 * @brief  处理支付宝客户端唤回后的回调数据
 * @note   处理支付宝客户端通过URL启动App时传递的数据,需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @note   需同时在 URL Types 里面添加urlscheme 为PPAppPlatformKit,
 * @param  INPUT  paramURL     启动App的URL
 * @return    无返回
 */
- (void) alixPayResult:(NSURL *)paramURL;

/**
 * @brief     弹出PP登录页面
 * @return    无返回
 */
- (void) showLogin;

/**
 * @brief     弹出PP中心页面
 * @return    无返回
 */
- (void) showCenter;

/**
 * @brief     兑换道具
 * @noti      只有余额大于道具金额时候才有客户端回调。余额不足的情况取决与paramIsLongComet参数，paramIsLongComet = YES，则为充值兑换。回调给服务端，paramIsLongComet = NO ，则只是打开充值界面
 * @param     INPUT paramPrice      商品价格，价格必须为大于等于1的int类型
 * @param     INPUT paramBillNo     商品订单号，订单号长度请勿超过30位，参有特殊符号
 * @param     INPUT paramBillTitle  商品名称
 * @param     INPUT paramRoleId     角色id，回传参数若无请填0
 * @param     INPUT paramZoneId     开发者中心后台配置的分区id，若无请填写0
 * @return    无返回
 */
- (void) exchangeGoods:(int)paramPrice
                BillNo:(NSString *)paramBillNo
             BillTitle:(NSString *)paramBillTitle
                RoleId:(NSString *)paramRoleId
                ZoneId:(int)paramZoneId;

/**
 * @brief     设置关闭充值提示语
 * @param     INPUT paramCloseRechargeAlertMessage      关闭充值时弹窗的提示语
 * @return    无返回
 */
- (void) setCloseRechargeAlertMessage:(NSString *)paramCloseRechargeAlertMessage;

/**
 * @brief     充值状态设置
 * @param     INPUT paramIsOpenRecharge      YES为开启，NO为关闭。
 * @return    无返回
 */
- (void) setIsOpenRecharge:(BOOL)paramIsOpenRecharge;

/**
 * @brief     注销用户，清除自动登录状态
 * @return    无返回
 */
- (void) PPlogout;

/**
 * @brief     设定充值页面默认充值数额
 * @note      paramAmount 大于等于1的整数
 * @param     INPUT paramAmount      充值金额
 * @return    无返回
 */
- (void) setRechargeAmount:(int)paramAmount;

/**
 * @brief     设定打印SDK日志
 * @note      发布时请务必改为NO
 * @param     INPUT paramIsNSlogDatad     YES为开启，NO为关闭
 * @return    无返回
 */
- (void) setIsNSlogData:(BOOL)paramIsNSlogData;

/**
 * @brief     设置该游戏的AppKey和AppId。从开发者中心游戏列表获取
 * @param     INPUT paramAppId     游戏Id
 * @param     INPUT paramAppKey    游戏Key
 * @return    无返回
 */
- (void) setAppId:(int)paramAppId
           AppKey:(NSString *)paramAppKey;

/**
 * @brief     设置注销用户后是否弹出的登录页面
 * @param     INPUT paramIsLogOutPushLoginView    YES为自动弹出登 页面，NO为不弹出登录页面
 * @return    无返回
 */
- (void) setIsLogOutPushLoginView:(BOOL)paramIsLogOutPushLoginView;

/**
 * @brief     设置游戏客户端与游戏服务端链接方式【如果游戏服务端能主动与游戏客户端交互。例如发放道具则为长连接。此处设置影响充值并兑换的方式】
 * @param     INPUT paramIsLongComet    YES 游戏通信方式为长链接，NO 游戏通信方式为长链接
 * @return    无返回
 */
- (void) setIsLongComet:(BOOL)paramIsLongComet;

/**
 * @brief     获取帐号的安全级别[登录验证成功时必须调用]
 * @return    无返回
 */
- (void) getUserInfoSecurity;

/**
 *  设置银联加载的父类ViewController，不设置默认是 [[UIWindow keyWindow] rootViewController]，[[UIWindow keyWindow] rootViewController]与ViewControllerForUnionPay 必须设置一个
 *
 *  @param vc 父类ViewController
 */
- (void) setViewControllerForUnionPay:(UIViewController *)vc;
/**
 *  获取当前用户登录状态
 *
 *  @return 0为未登录，1为登录
 */
- (int)loginState;

@end

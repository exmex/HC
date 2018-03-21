//
//  GameTestViewController.m
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import "Custom49SDKViewController.h"
//#import "DropDownList.h"
#import "Custom49SDK.h"
#import <CommonCrypto/CommonDigest.h>
#import <49AppKit/ep_uinavigation.h>
#import <49AppKit/pay_view.h>
#import <49AppKit/rmb_options_view.h>


static NSString* uid = @"";

static NSString *_productTitle;
static NSString *_productID;
static NSString *_orderID;
static NSString *_serverID;
static float _money;

@interface Custom49SDKViewController (){

}
    
@end

@implementation Custom49SDKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init{
    self.isViewLoad = false;
    self.needShowPay = false;
    self.needShowLogin = false;
    _main_view = [[main_view alloc] init];

    return [super init];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isViewLoad) {
        if (self.needShowLogin) {
            [self loginAction:nil];
            self.needShowLogin = false;
        }
        if (self.needShowPay) {
            [self payForProductName:_productTitle productId:_productID price:_money orderId:_orderID serverID:_serverID];
            self.needShowPay = false;
        }
    }
}

- (NSString *)userName
{
    return @"";
}

- (NSString *)userID
{
    return uid;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isViewLoad = true;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isViewLoad = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginAction:(UIButton *)button{
    if (!self.isViewLoad) {
        self.needShowLogin = true;
        return;
    }
    NSDictionary *_argv_dic = [[[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         (id)self, @"self",/* 当前焦点xib */
                                                                         @"49app", @"Agent",/* 渠道安装包 */
                                                                         @"33", @"AppID",/* 应用 ID */
                                                                         @"0b889c6c2aa7d81caf43b78722878b33", @"AppKey",/* 应用 KEY */
                                                                         @"", @"Server_id",/* ￼登录游戏服 ID */
                                                                         nil]] autorelease];
    /* { --main view-- } */
    _main_view._main_info_dic = [[[NSMutableDictionary alloc] initWithDictionary:_argv_dic] autorelease];
    [_main_view.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_main_view.view];
}

- (void)payForProductName:(NSString *) title productId:(NSString *)productID price:(float)money orderId:(NSString *)orderID serverID:(NSString *)serverID{
    /* { 充值界面的传参（+了参数，对应着+） } */
    if (!self.isViewLoad) {
        self.needShowPay = true;
        _productTitle = title;
        _productID = productID;
        _orderID = orderID;
        _serverID = serverID;
        _money = money;

        return;
    }
    NSDictionary *_argv_dic = [[[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         (id)self, @"self",/* 当前self */
                                                                         @"33", @"appid",/* 应用 ID */
                                                                         @"0b889c6c2aa7d81caf43b78722878b33", @"appkey",/* 应用 KEY */
                                                                         @"0b889c6c2aa7d81caf43b78722878b33", @"gid",/* 游戏ID */
                                                                         @"", @"user",/* 用户账号（内部订单传UID，外部订单传第三方账号或UID） */
                                                                        [NSString stringWithFormat:@"%.2f",money], @"amount",/* 金额 */
                                                                         @"10", @"rate", /* 游戏币比例(金额*其为所得游戏币) */
                                                                         @"钻石", @"sp", /* 商品名称 */
                                                                         @"49app", @"subject",/* 充值产品名称 */
                                                                         @"49app", @"agent",/* 渠道包ID */
                                                                         @"1003", @"server_id",/* 服务区标识 */
                                                                         @"", @"billno",/* 支付宝订单号（留空系统将自动分配支付宝订单号） */
                                                                         title, @"product_name",/* 商品标题 */
                                                                         title, @"product_description",/* 商品描述 */
                                                                         orderID, @"extrainfo",/* 扩展信息 */
                                                                         @"0", @"tester",/* 1为测试 0或者空为正常 */
                                                                         @"49apphaizeiwang", @"app_scheme",/* URL types,支付宝退出后返回哪个应用 */
                                                                         nil]] autorelease];
    
    pay_view *_pay_view = [[[pay_view alloc] init] autorelease];

    _ep_uinavigation = [[[Custom49SDKPayViewController alloc] initWithRootViewController:_pay_view] autorelease];
    _pay_view._payment_info_dic = [[[NSMutableDictionary alloc] initWithDictionary:_argv_dic] autorelease];
    [self presentViewController:_ep_uinavigation animated:NO completion:nil];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)_login_succeed:(NSString *)_uid withTimestamp:(NSString *)_timestamp withSign:(NSString *)_sign
{
    [_main_view.view removeFromSuperview];
    
    [Custom49SDK hideAllView];

    uid = [_uid retain];
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSDK_LOGIN object:nil];
}

#pragma mark - IOS 6 Rotation
- (BOOL)shouldAutorotate { return NO; }
- (NSUInteger)supportedInterfaceOrientations { return UIInterfaceOrientationMaskPortrait; }


- (BOOL)isLogin
{
    return [uid length]>1;
}


@end

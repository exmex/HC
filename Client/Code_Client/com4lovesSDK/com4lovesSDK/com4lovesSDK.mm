

//
//  com4lovesSDK.m
//  com4lovesSDK
//
//  Created by fish on 13-8-20.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "com4lovesSDK.h"
#import "DDAlertPrompt.h"
#import "JSON.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "AccountManagerView.h"
#import "AccountCenterView.h"
#import "ChangePasswordView.h"
#import "UserListView.h"
#import "SelfPayView.h"
#import "InAppPurchaseManager.h"
#import "com4loves.h"
#import "IndexViewViewController.h"
#import "WebView.h"
#import "ChooseBindingView.h"
#import "GTMBase64.h"
#import "GTMDefines.h"
#import "SDKUtility.h"
#import "ServerLogic.h"
#import "YouaiUser.h"
#import "YouaiServerInfo.h"
#import "SimpleIni.h"


#import "c4lSelfPay.h"


#ifdef YOUAI_KUAIYONG
#import "OtherViewController.h"
#endif


static NSString*   SDKAppKey = @"gjwow_ios";
static NSString*   SDKAppID = @"1";
static NSString*   channelID = @"1000";
static NSString*   platFormID = @"ios_appstore";
static NSString*   appKey = @"gjwow_ios";
static BOOL        isNeedNet;

static NSString*   SDKAlipaySchemeUrl = @"qmwow.com4loves.com";
static NSString*   SDKSecret = @"gjwowappstoreeleilcoqodcq";

static NSMutableArray * userLoginedServers = [[NSMutableArray alloc] init];
static NSString*   currentServierID;
static YouaiServerInfo *serverInfo = [[YouaiServerInfo alloc] init];
#define APPSTORE_VERIFY_ORDER

@interface com4lovesSDK()
{
    NSString*   productID;
    float       productPrice;
    float       productCount;
    BOOL        userLogout;
    BOOL        defautlLoginFalse;
}
@property (nonatomic)    BOOL        isEnterGame;
#ifndef C4L_PURE_WITHOUT_INTERFACE

@property (retain,nonatomic) LoginView*             viewLogin;
@property (retain,nonatomic) RegisterView*          viewRegister;
@property (retain,nonatomic) WebView* viewWeb;
@property (retain,nonatomic) AccountManagerView*    viewAccountManager;
@property (retain,nonatomic) AccountCenterView*     viewAccountCenter;
@property (retain,nonatomic) ChangePasswordView*    viewChangePassword;
@property (retain,nonatomic) UserListView*          viewUserList;
@property (retain,nonatomic) SelfPayView*           viewSelfPay;
@property (retain,nonatomic) IndexViewViewController* viewIndex;
@property (retain,nonatomic) ChooseBindingView *viewChooseBind;
#ifdef YOUAI_KUAIYONG
@property (retain,nonatomic) OtherViewController*   viewKyPay;
#endif
@property (retain,nonatomic) UIViewController*      viewCurrent;
@property (retain,nonatomic) NSBundle               *mainBundle;

#endif

@end

@implementation com4lovesSDK

+(id) sharedInstance {
    static com4lovesSDK *_instance = nil;
    if (_instance == nil) {
        _instance = [[com4lovesSDK alloc] init];
        [_instance initSDK];
    }
    return _instance;
}

- (BOOL)initSDK
{
#ifndef C4L_PURE_WITHOUT_INTERFACE
    self.viewCurrent = nil;
#endif
    defautlLoginFalse = false;
    _isEnterGame = false;
    userLogout = NO;
    [[InAppPurchaseManager sharedInstance] loadStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iapBuyDone) name:@"kInAppPurchaseManagerTransactionSucceededNotification" object:nil];
  
    return YES;
}

+(NSString *)getPropertyFromIniFile:(NSString *)section andAttr:(NSString *)attr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/_additionalSearchPath/dynamic.ini"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"dynamic" ofType:@"ini"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    NSLog(@"filePath  %@",filePath);
    CSimpleIniA ini;
    ini.SetUnicode();
    ini.LoadFile([filePath UTF8String]);
    const char * pVal = ini.GetValue([section cStringUsingEncoding:NSASCIIStringEncoding],[attr cStringUsingEncoding:NSASCIIStringEncoding] );
    if (pVal==NULL) {
        return nil;
    }
    return [NSString stringWithString:[NSString stringWithCString:pVal encoding:NSUTF8StringEncoding]];
}
- (NSBundle *)mainBundle
{
    if (!_mainBundle) {
        NSString* fullpath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"GamesBundle.bundle"]
                                                              ofType:nil
                                                         inDirectory:[NSString stringWithUTF8String:""]];
        self.mainBundle = [NSBundle bundleWithPath:fullpath1];
        //NSBundle *buddle = [NSBundle bundleWithIdentifier:@"com.loves.com4lovesBundle"];
        [_mainBundle load];
    }
    
    return _mainBundle;
}
+(NSString*)getLang:(NSString *)key
{
    return NSLocalizedStringFromTableInBundle(key, nil, [[com4lovesSDK sharedInstance] mainBundle], nil);
}
#ifndef C4L_PURE_WITHOUT_INTERFACE


#ifdef YOUAI_KUAIYONG
- (OtherViewController *)viewKyPay
{
    if (!_viewKyPay) {
        self.viewKyPay =  [[[OtherViewController alloc]init] autorelease];
    }
    return _viewKyPay;
}
#endif
- (IndexViewViewController *)viewIndex
{
    if (!_viewIndex) {
        self.viewIndex = [[[IndexViewViewController alloc] initWithNibName:@"IndexViewViewController" bundle:self.mainBundle] autorelease];
    }
    return _viewIndex;
}

- (LoginView *)viewLogin
{
    if (!_viewLogin) {
        self.viewLogin = [[[LoginView alloc] initWithNibName:@"LoginView" bundle:self.mainBundle] autorelease];
    }
    return _viewLogin;
}

- (RegisterView *)viewRegister
{
    if (!_viewRegister) {
        self.viewRegister = [[[RegisterView alloc] initWithNibName:@"RegisterView" bundle:self.mainBundle] autorelease];
    }
    return _viewRegister;
}
- (WebView *)viewWeb
{
    if (!_viewWeb) {
        self.viewWeb = [[[WebView alloc] initWithNibName:@"WebView" bundle:self.mainBundle] autorelease];
    }
    return _viewWeb;
}
- (AccountCenterView *)viewAccountCenter
{
    if (!_viewAccountCenter) {
        self.viewAccountCenter = [[[AccountCenterView alloc] initWithNibName:@"AccountCenter" bundle:self.mainBundle] autorelease];
    }
    return _viewAccountCenter;
}
-(AccountManagerView *)viewAccountManager
{
    if (!_viewAccountManager) {
        self.viewAccountManager = [[[AccountManagerView alloc] initWithNibName:@"AccountManager" bundle:self.mainBundle] autorelease];
    }
    return _viewAccountManager;
}
-(ChangePasswordView *)viewChangePassword
{
    if (!_viewChangePassword) {
        self.viewChangePassword = [[[ChangePasswordView alloc] initWithNibName:@"ChangePassword" bundle:self.mainBundle] autorelease];
    }
    return _viewChangePassword;
}
-(UserListView *)viewUserList
{
    if (!_viewUserList) {
        self.viewUserList = [[[UserListView alloc] initWithNibName:@"UserListView" bundle:self.mainBundle] autorelease];
    }
    return _viewUserList;
}
-(SelfPayView *)viewSelfPay
{
    if (!_viewSelfPay) {
        self.viewSelfPay = [[[SelfPayView alloc] initWithNibName:@"SelfPayView" bundle:self.mainBundle] autorelease];
    }
    return  _viewSelfPay;
}

-(ChooseBindingView*)viewChooseBind
{
    if (!_viewChooseBind) {
        self.viewChooseBind = [[[ChooseBindingView alloc] initWithNibName:@"ChooseBindingView" bundle:self.mainBundle] autorelease];
    }
    return  _viewChooseBind;
}
#endif
- (BOOL)getIsInGame
{
    return _isEnterGame;
}
- (BOOL)getIsTryUser
{
    return [[[ServerLogic sharedInstance] getLoginUserType] intValue]==2;
}
- (BOOL)getLogined
{
    if([[ServerLogic sharedInstance] getYouaiID]!=nil &&
       [[[ServerLogic sharedInstance] getYouaiID] length]>0 &&
       [[ServerLogic sharedInstance] getLoginedUserName]!=nil &&
       [[[ServerLogic sharedInstance] getLoginedUserName] length]>0)
        return YES;
    else
        return  NO;
}
-(void)tryUser2SucessNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_tryuser2OkSucess object:nil];
}
-(void)logout
{
    [self clearLoginInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_logout object:nil];
}
-(void)logoutInGame
{
    [self clearLoginInfo];
    //[self LoginTryUser];
    [self hideAll];
}
-(void) showWeb:(NSString*)url
{
#ifndef C4L_PURE_WITHOUT_INTERFACE
    [self.viewWeb showWeb:url];
#endif
}

+ (void)setSDKAppID:(NSString *) SDKID
          SDKAPPKey:(NSString *) SDKKey
          ChannelID:(NSString *) channel
         PlatformID:(NSString *) platform;
{
    [SDKAppKey release];
    [SDKAppID release];
    [channelID release];
    [platFormID release];
    SDKAppKey   = [SDKKey retain];
    SDKAppID    = [SDKID retain];
    channelID   = [channel retain];
    platFormID  = [platform retain];
    [com4lovesSDK statisticsInfo];
}

+ (void)setAlipayUrlScheme:(NSString *)scheme andSignSecret:(NSString *)sign
{
    [SDKAlipaySchemeUrl release];
    [SDKSecret release];
    
    SDKAlipaySchemeUrl = [scheme retain];
    SDKSecret = [sign retain];
}

+ (NSString *)getAlipayScheme //支付宝快捷支付的url scheme
{
    return SDKAlipaySchemeUrl;
}

+ (NSString *)getSignSecret    //自有平台支付的密钥
{
    return SDKSecret;
}

+ (NSString *)getSDKAppID
{
    return SDKAppID;
}
+ (NSString *)getSDKAppKey
{
    return SDKAppKey;
}

+ (NSString *)getPlatformID
{
    return platFormID;
}

+ (NSString *)getChannelID
{
    return channelID;
}
+(void)setAppIdDirectly:(NSString *)paramAppKey
{
    appKey = [NSString stringWithString:paramAppKey];
    [appKey retain];
}
+ (void)setAppId:(NSString *)paramAppKey
{
    [com4lovesSDK setAppIdDirectly:paramAppKey];
}
+(NSString*)getYouaiID
{
    return [[ServerLogic sharedInstance] getYouaiID];
}
+(NSString*)getAppID
{
    //return appKey;  //guodongdong
    return SDKAppKey;
}

-(NSString*)getLoginedUserName
{
    return [[ServerLogic sharedInstance] getLoginedUserName];
}

- (BOOL)getNeedNet
{
    return isNeedNet;
}
+ (void)setNeedNet:(BOOL)needNet
{
    isNeedNet = needNet;
}

#ifndef C4L_PURE_WITHOUT_INTERFACE

-(void) showPage: (UIViewController*) viewPage
{
    if(viewPage == self.viewCurrent)
    {
        return;
    }
  //  UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [self hideAll];
   
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    viewPage.view.center = window.rootViewController.view.center;
    viewPage.view.frame = window.rootViewController.view.bounds;
    [window.rootViewController.view addSubview:viewPage.view];
    //[window addSubview:viewPage.view];
    [viewPage.view setHidden:NO];
    self.viewCurrent = viewPage;
  
//    CGRect rect = [[UIScreen mainScreen] applicationFrame];
//    if (rect.size.width>=768) {
//        rect.origin.x = rect.size.width*0.125;
//        rect.origin.y = 150;
//        rect.size.width = rect.size.width*0.75;
//        rect.size.height = 568;
//    }
 //   [viewPage.view setFrame:rect];
}

-(void)LoginTryUser{
    [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
}

-(void) Login
{
    
    BOOL logined = NO;

    [[ServerLogic sharedInstance] initUserList];
     NSMutableDictionary *users = [[ServerLogic sharedInstance] getUserList];
    int userCount = [users count];
    YALog(@"users %@  userCount %d",users,userCount);

    //本地没有用户，显示注册界面
    if (userCount == 0) {
        [self showIndex];
        //logined = [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
    // 如果本地有一个用户
    } else if (userCount == 1) {
        NSString *tryUser = [[ServerLogic sharedInstance] getTryUser];
        if (tryUser!=nil) {
            //试玩账户登录
            [self showIndex];
        //    logined = [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
        } else {
            //本地有一个正式账户
            if(userLogout)
            {
                [self showIndex];
            }
            else
            {
                logined = [self loginLastestUser];
                if (!logined) {

                //logined = [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
                    [self showIndex];
                }
            }
        }
    }
    else if (userCount>=2) {
        if(userLogout)
        {
            [self showIndex];
        }
        else
        {
            logined = [self loginLastestUser];
            if (!logined) {
                // logined = [[ServerLogic sharedInstance] createOrLoginTryUser:@""];
                [self showIndex];
            }
        }
        
    }

    if(!logined)
    {
        if(self.viewCurrent==nil)
        {
            [self showIndex];
        }
        defautlLoginFalse = true;
    }else{
        [self hideAll];
    }
}

-(BOOL)loginLastestUser
{
    NSString* latestUser = [[ServerLogic sharedInstance] getLatestUser];
    if (latestUser!=nil && defautlLoginFalse == false)
    {
        NSString* password = [[ServerLogic sharedInstance] getLatestUserPassword];
        if(password && [password length]>0)
        {
            return [[ServerLogic sharedInstance] login:latestUser password:password];
        }
    }
    return NO;
}

-(void)showIndex
{
    [self showPage:self.viewIndex];
//[self.viewLogin initWithViewStyle:styleLoginWithRegister];
//    NSString* latestUser = [[ServerLogic sharedInstance] getLatestUser];
//    if (latestUser!=nil && [[[ServerLogic sharedInstance] getLoginUserType] intValue]!=2)
//    {
//        [self.viewLogin.plainTextField setText:latestUser];
//        NSString* password = [[ServerLogic sharedInstance] getLatestUserPassword];
//        YALog(@"password %@",password);
//        
//        if(password)
//        {
//            [self.viewLogin.secretTextField setText:password];
//        }
//        
//    }

}

-(void)showLogin
{
    [self showPage:self.viewLogin];
    [self.viewLogin initWithViewStyle:styleLoginWithRegister];
    NSString* latestUser = [[ServerLogic sharedInstance] getLatestUser];
    if (latestUser!=nil && [[[ServerLogic sharedInstance] getLoginUserType] intValue]!=2)
    {
        [self.viewLogin.plainTextField setText:latestUser];
        NSString* password = [[ServerLogic sharedInstance] getLatestUserPassword];
        YALog(@"password %@",password);

        if(password)
        {
            [self.viewLogin.secretTextField setText:password];
        }
        
    }
}
-(void)showRegister
{
    [self showPage:self.viewRegister];
    [self.viewRegister initWithViewStyle:styleRegister];
//    一秒注册
//    NSString* preName = [[ServerLogic sharedInstance] getPrecreatedYouaiName];
//    NSString* prePassword = [[ServerLogic sharedInstance] getPrecreatedPassword];
//    [self.viewRegister.plainTextField setText:preName];
//    [self.viewRegister.secretTextField setText:prePassword];

    
}

-(void)showBinding
{
    [self showPage:self.viewRegister];
    [self.viewRegister initWithViewStyle:stylePositive];
}

-(void)showChooseBinding
{
    if (self.isEnterGame) {
        //在游戏内部并且是使用用户
        if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2) {
            //            [self showPage:self.viewRegister];
            //            [self.viewRegister initWithViewStyle:stylePositive];
            //  [self showPage:self.viewIndex];
            
            //  [self.viewLogin initWithViewStyle:styleLogin];
            // 先添加界面，在更改界面元素，保证界面生成之后在设置，而不是设置之后在生成
            
            [self showPage:self.viewChooseBind];
        }
        else if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==3) {
            
            [self showPage:self.viewIndex];
        }
        else{
            [self showPage:self.viewAccountManager];
        }
    }else{
        if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2) {
            //            [self showPage:self.viewIndex];
            [self showPage:self.viewChooseBind];
            //      [self.viewLogin initWithViewStyle:styleLogin];
            //            [self.viewRegister initWithViewStyle:stylePositive];
            // 先添加界面，在更改界面元素，保证界面生成之后在设置，而不是设置之后在生成
        }
        else if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==3) {
            
            [self showPage:self.viewIndex];
        }
        else
        {
            [self showPage:self.viewAccountManager];
        }
    }
}

-(void)showAccountManager
{
     if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==3)
         [self showPage:self.viewIndex];
     else
         [self showPage:self.viewAccountManager];
//如果已经进入游戏内部
//    if (self.isEnterGame) {
//        //在游戏内部并且是使用用户
//        if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2) {
////            [self showPage:self.viewRegister];
////            [self.viewRegister initWithViewStyle:stylePositive];
//          //  [self showPage:self.viewIndex];
//            
//          //  [self.viewLogin initWithViewStyle:styleLogin];
//            // 先添加界面，在更改界面元素，保证界面生成之后在设置，而不是设置之后在生成
//            
//            [self showPage:self.viewChooseBind];
//        }else{
//            [self showPage:self.viewAccountManager];
//        }
//    }else{
//        if ([[[ServerLogic sharedInstance] getLoginUserType] intValue]==2) {
////            [self showPage:self.viewIndex];
//             [self showPage:self.viewChooseBind];
//      //      [self.viewLogin initWithViewStyle:styleLogin];
////            [self.viewRegister initWithViewStyle:stylePositive];
//            // 先添加界面，在更改界面元素，保证界面生成之后在设置，而不是设置之后在生成
//        }else{
//            [self showPage:self.viewAccountManager];
//        }
//    }
//    NSString* username = [[ServerLogic sharedInstance] getLoginedUserName];
//    if (username) {
//   //     [self.viewAccountManager.accountLabel setText:[NSString stringWithFormat:@"%@：%@",[com4lovesSDK getLang:@"account"], username]];
//    } else {
//    //    [self.viewAccountManager.accountLabel setText:@""];
//    }
    
}
-(void)showAccountCenter
{
    [self showPage:self.viewAccountCenter];
    
    NSString* username = [[ServerLogic sharedInstance] getLoginedUserName];
    [self.viewAccountCenter.accountLabel setText:username];
    
}
-(void)showChangePassword
{
    [self showPage:self.viewChangePassword];
    [self.viewChangePassword.oriSecretText setText:@""];
    [self.viewChangePassword.newSecretText setText:@""];
    [self.viewChangePassword.makesureText setText:@""];
    
}
-(void)showUserList
{
    //[viewUserList refresh];
    //[self showPage:viewUserList];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.viewUserList.view];
    [self.viewUserList refresh];
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    [self.viewUserList.view setFrame:rect];
}
-(void)showPay
{
#ifdef YOUAI_KUAIYONG
    [self showPage:self.viewKyPay];
#else
    [self showPage:self.viewSelfPay];
#endif
}

-(void)hideAll
{
    [_viewRegister.view removeFromSuperview];
    [_viewLogin.view removeFromSuperview];
    [_viewAccountCenter.view removeFromSuperview];
    [_viewAccountManager.view removeFromSuperview];
    [_viewChangePassword.view removeFromSuperview];
    [_viewSelfPay.view removeFromSuperview];
    [_viewIndex.view removeFromSuperview];
    [_viewChooseBind.view removeFromSuperview];
    //[_viewBinding.view removeFromSuperview];
#ifdef YOUAI_KUAIYONG 
    [_viewKyPay.view removeFromSuperview];
    [_viewKyPay.view setHidden:YES];
#endif
    //[_viewBinding.view setHidden:YES];
    [_viewRegister.view setHidden:YES];
    [_viewLogin.view  setHidden:YES];
    [_viewAccountCenter.view  setHidden:YES];
    [_viewAccountManager.view  setHidden:YES];
    [_viewChangePassword.view  setHidden:YES];
    [_viewSelfPay.view setHidden:YES];
    [_viewIndex.view setHidden:YES];
    [_viewChooseBind.view setHidden:YES];
    self.viewCurrent = nil;

}
#endif
-(void)notifyEnterGame
{
    self.isEnterGame = YES;
#ifdef APPSTORE_VERIFY_ORDER
    [self enterGameVerifyOder];
#endif
}

-(void)notifyLogoutGame
{
    userLogout = YES;
    self.isEnterGame = NO;
}
#define ORDER_2_VERIFY          @"ORDER_2_VERIFY"
#define ORDER_2_VERIFY_SERVERID @"ORDER_2_VERIFY_SERVERID"
#define ORDER_2_VERIFY_USERID   @"ORDER_2_VERIFY_USERID"
//把severid存到本地,防止付款的时候程序崩溃或者突然退出,下次继续付款的时候没有serverid
-(void)appStoreBuy:(NSString*)_productID serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId
{
    NSString *payMethod = nil;
    payMethod = [com4lovesSDK getPropertyFromIniFile:@"Pay_Method" andAttr:@"payMethod"];
    if(payMethod == nil || [payMethod isEqualToString:@"appPay"])
        [self appBuy:_productID  serverID:description totalFee:fee orderId:orderId];
    else
        [self iapBuy:_productID  serverID:description totalFee:fee orderId:orderId];
}
-(void)appBuy:(NSString*)_productID  serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId
{
    NSLog(@"%@",description);
    if(description == nil)
    {
        return;
    }
    
//    NSString* youaiID = [[ServerLogic sharedInstance] getYouaiID];
//    if (youaiID == nil) {
//        return;
//    }
    NSArray *array = [description componentsSeparatedByString:@"_"];
    productID =  [NSString stringWithString: _productID];
    NSString* youaiID = [array objectAtIndex:1];
    currentServierID = [array objectAtIndex:0];//[NSString stringWithString: description];
    [productID retain];
    [currentServierID retain];
    [[NSUserDefaults standardUserDefaults] setObject:currentServierID forKey:ORDER_2_VERIFY_SERVERID];
    [[NSUserDefaults standardUserDefaults] setObject:youaiID forKey:ORDER_2_VERIFY_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //检测是否有未完成的交易 有的话去掉
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased)
        {
            [[InAppPurchaseManager sharedInstance] completeTransaction:transaction];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }  
    }
    
    [[InAppPurchaseManager sharedInstance] purchaseProduct:productID];
    
}

-(void)iapBuy:(NSString*)_productID  serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId
{
#ifdef YOUAI_KUAIYONG
    [self showPay];
    [self.viewKyPay setDesc:_productID];
    [self.viewKyPay setServerId:description];
    NSString* desc = [NSString stringWithFormat:@"%d%@",(int)(fee*10),[com4lovesSDK getLang:@"zuanshi"]];
    [self.viewKyPay setSubject:desc];
    [self.viewKyPay setTotalFee:fee];
    [self.viewKyPay setOrderId:orderId];
    [self.viewKyPay showPay];
#else
    [self showPay];
    [self.viewSelfPay setMDesc:_productID];
    [self.viewSelfPay setMServerID:description];
    NSString* desc = [NSString stringWithFormat:@"%d%@",(int)(fee*10),[com4lovesSDK getLang:@"zuanshi"]];
//    fee = 0.01;
    [self.viewSelfPay setMSubject:desc];
    [self.viewSelfPay setMBody:desc];
    [self.viewSelfPay setMTotalFee:fee];
    [self.viewSelfPay.payRMB setText:[NSString stringWithFormat:@"%.2f",fee]];
    //[[c4lSelfPay sharedInstance] buyProduct:_productID serverID:description];
#endif
}




-(void) iapBuyDone
{

    NSString* youaiID = [[NSUserDefaults standardUserDefaults] objectForKey:ORDER_2_VERIFY_USERID];
    currentServierID = [[NSUserDefaults standardUserDefaults] objectForKey:ORDER_2_VERIFY_SERVERID];
    if(currentServierID != nil)
        [currentServierID retain];
    NSString *receiptBase64= [GTMBase64 stringByEncodingData:[[InAppPurchaseManager sharedInstance] getRecept]] ;
    
    
    NSString* postStr =[[NSString alloc]initWithFormat:@"uin=%@&serverID=%@&receipt=%@",youaiID,currentServierID,receiptBase64];
    
    //新订单添加到本地
    NSArray *orders = [[NSUserDefaults standardUserDefaults] objectForKey:ORDER_2_VERIFY];
    NSMutableArray *addOrders = [[NSMutableArray alloc] initWithArray:orders];
    [addOrders addObject:postStr];
    [[NSUserDefaults standardUserDefaults] setObject:addOrders forKey:ORDER_2_VERIFY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [addOrders release];
    [postStr release];

    //如果现在在游戏里面 那么去服务器验证,如果不在服务器里面即使验单成功也不会加钻
   // if ([self isEnterGame]) {
        [self verifyOrders];
   // }

}

- (void)enterGameVerifyOder
{
    [self verifyOrders];
}
- (NSString *)getRechargeUrl
{
    NSString* addressUrl = [com4lovesSDK getPropertyFromIniFile:@"RechargeAddressBak" andAttr:@"addressUrl"];
    NSString* projectName = [com4lovesSDK getPropertyFromIniFile:@"Project" andAttr:@"projectName"];

    if (addressUrl&&[addressUrl hasPrefix:@"http"]&&projectName)
    {
        return [NSString stringWithFormat:@"%@%@",addressUrl,projectName];
    }
    return nil;
}
- (NSString *)getRechargeIP
{
    NSString* addressIp = [com4lovesSDK getPropertyFromIniFile:@"RechargeAddressBak" andAttr:@"addressIp"];
    NSString* projectName = [com4lovesSDK getPropertyFromIniFile:@"Project" andAttr:@"projectName"];

    if (addressIp&&[addressIp hasPrefix:@"http"]&&projectName)
    {
        return [NSString stringWithFormat:@"%@%@",addressIp,projectName];
    }
    return nil;
}

- (void) verifyOrders
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *orders = [[NSUserDefaults standardUserDefaults] objectForKey:ORDER_2_VERIFY];
        NSMutableArray *addOrders = [[NSMutableArray alloc] init];
        NSString *rechargeUrl = [self getRechargeUrl];
        for (NSString* temp in orders) {
            
            BOOL success = false;
            if (rechargeUrl)
            {
                [self verifyOneOrder:rechargeUrl andData:temp];
            }
            else
            {
                rechargeUrl=@"http://182.254.201.94/callback/applepay/";
            }
            success = [self verifyOneOrder:rechargeUrl andData:temp];
            if (!success)
            {
                [addOrders addObject:temp];
            }
        }
        //剩余订单再存储
        [[NSUserDefaults standardUserDefaults] setObject:addOrders forKey:ORDER_2_VERIFY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [addOrders release];
    });
   
}

-(void)buyDone
{
    if ([[NSThread mainThread] isMainThread])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_buyDone object:nil userInfo:nil];
    }
}
//验单失败返回NO,成功返回YES
- (BOOL)verifyOneOrder:(NSString *)actionUrl andData:(NSString *)postStr
{
    //验证的时候 用户肯定在游戏内  一定要取得当前的userid和serverID 不然的话验单不好使
    NSString* youaiID = [com4lovesSDK  getYouaiID];
    //serverID
    NSLog(@"%@",currentServierID);
    if (!youaiID||!currentServierID) {
        return NO;
    }
//    uin=%@&serverID=
    //如果不在当前用户, 或者是当前服务器 取消验单
//    if ([postStr rangeOfString:[NSString stringWithFormat:@"uin=%@",youaiID]].location==NSNotFound||[postStr rangeOfString:[NSString stringWithFormat:@"serverID=%@",currentServierID]].location==NSNotFound ) {
//        YALog(@"不是当前用户或者服务器  --->  跳过验单");
//        return NO;
//    }
    NSData *postdata=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* verifyUrl = actionUrl;
    for (int i = 1; i<=6; i++)
    {
        if (i==4)
        {
            NSString *addressIp = [self getRechargeIP];
            if (addressIp)
            {
                verifyUrl = addressIp;
            }
            else
            {
                verifyUrl = @"http://182.254.201.94/callback/applepay/";  //后3次改为IP验证
            }
        }
        int httpCode = [[SDKUtility sharedInstance]httpPostForStatus:verifyUrl postData:postdata md5check:nil];
        if (httpCode==200)
        {
            YALog(@"第  %d  次验证 成功 %@",i,verifyUrl);
            
            //send notification
            if ([NSThread isMainThread])
            {
                [self buyDone];
            }
            else
            {
                [self performSelector:@selector(buyDone) onThread:[NSThread mainThread] withObject:nil waitUntilDone:false];
            }
            return YES;
        }
        else
        {
            YALog(@"第  %d  次验证 失败 %@ ",i,verifyUrl);
        }
    }
    return NO;
}


#ifndef C4L_PURE_WITHOUT_INTERFACE
-(void)clearLoginInfo
{
    [[ServerLogic sharedInstance] updateUserList];
    [self.viewLogin.plainTextField setText:@""];
    [self.viewLogin.secretTextField setText:@""];
    [self.viewLogin clearInfo];
    [[ServerLogic sharedInstance] clearLoginInfo];
}
#endif

+(NSString*) getServerListUserDefaultKey
{
    NSMutableString* str = [NSMutableString stringWithString:com4loves_serverList];
    NSString* youaiId = [[ServerLogic sharedInstance] getYouaiID];
    if (youaiId) {
        [str appendFormat:@"_%@", youaiId];
    }
    YALog(@"getServerListUserDefaultKey %@",str);
    return str;
}

+(void)updateServerInfo:(int)serverID playerName:(NSString*)playerName playerID:(int)playerID lvl:(int)lvl vipLvl:(int)vipLvl coin1:(int)coin1 coin2:(int)coin2 pushSer:(BOOL) isPush
{
    //local save
    YALog(@"serverID %d ",serverID);
    YALog(@"[com4lovesSDK sharedInstance].userLoginedServers %@",userLoginedServers);
    currentServierID = [[NSString stringWithFormat:@"%d",serverID] retain];
    NSMutableArray* serversSave = [[NSMutableArray alloc] initWithCapacity:[userLoginedServers count]];
    NSNumber* num = [NSNumber numberWithInt:serverID];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"aaa",@"name",num,@"serverId", nil];
    [serversSave addObject:dic];
    for (NSDictionary* dic in userLoginedServers) {
        NSNumber* num = [dic objectForKey:@"serverId"];
        if([num intValue]!=serverID)
        {
            [serversSave addObject:dic];
        }
    }
    [userLoginedServers release];
    userLoginedServers = [serversSave retain];
    [serversSave release];
    
    [[NSUserDefaults standardUserDefaults] setObject:userLoginedServers forKey:[com4lovesSDK getServerListUserDefaultKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (isPush) {
        [[ServerLogic sharedInstance] pushForClient:serverID playername:playerName playerID:playerID rmbMoney:coin1 gameCoin:coin2 vipLevel:vipLvl playerLevel:lvl pushSer:isPush];
    }

}

+(void)refreshServerInfo:(NSString*) gameID puid:(NSString*)puid pushSer:(BOOL) isPush
{
    
    [com4lovesSDK setNeedNet:isPush];
    [[ServerLogic sharedInstance] setYouaiID:puid];
   // [com4lovesSDK  setAppIdDirectly:gameID];
    [userLoginedServers release];
    userLoginedServers  = [[[NSUserDefaults standardUserDefaults] objectForKey:[com4lovesSDK getServerListUserDefaultKey]] retain] ;
    //本地没有存储
    if(!userLoginedServers)
    {
        NSArray * servers = [[ServerLogic sharedInstance] getUserLoginedServers];
        [userLoginedServers release];
        userLoginedServers = [[NSMutableArray alloc] initWithCapacity:[servers count]];
        [userLoginedServers addObjectsFromArray:servers];
//        [com4lovesSDK sharedInstance].userLoginedServers = [[[NSMutableArray alloc] init] autorelease];

    }
}
+(int)getServerInfoCount
{
    if (userLoginedServers) {
        return [userLoginedServers count];
    } else {
        return 0;
    }
}
+(int)getServerUserByIndex:(int)index
{
    if(userLoginedServers)
    {
        if ([userLoginedServers count]>index) {
            NSDictionary* dic = [userLoginedServers objectAtIndex:index];
            NSNumber* num = [dic objectForKey:@"serverId"];
            return [num intValue];
        }
    }else{
        return -1;
    }
     return -1;
}
- (void)dealloc{
#ifndef C4L_PURE_WITHOUT_INTERFACE
    [_viewLogin release];
    [_viewRegister release];
    [_viewWeb release];
    [_viewAccountManager release];
    [_viewAccountCenter release];
    [_viewChangePassword release];
    [_viewUserList release];
    [_viewSelfPay release];
#endif
    [super dealloc];
}
- (void)parseURL:(NSURL *)url
{
#ifdef YOUAI_KUAIYONG
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KY_NOTIFICATION" object:url];
#else
    #ifndef C4L_PURE_WITHOUT_INTERFACE
        [self.viewSelfPay parseURL:url];
    #endif
#endif
}

+(YouaiServerInfo *)getServerInfo
{
    return serverInfo;
}
- (void) showFeedBack
{
    NSString* enableFeedback = [com4lovesSDK getPropertyFromIniFile:@"FeedBackEnable" andAttr:@"feedback"];
    if (enableFeedback&&[enableFeedback isEqualToString:@"1"]) {
    NSString *url = [NSString stringWithFormat:@"%@nuclear/feedback/querydetailbygameinfo?puid=%@&gameId=%@&serverId=%d&playerId=%d&playerName=%@&vipLvl=%d&platformId=%@",[[ServerLogic sharedInstance]getServerUrl],[com4lovesSDK getServerInfo].puid,[com4lovesSDK getAppID],[com4lovesSDK getServerInfo].serverID,[com4lovesSDK getServerInfo].playerID,[com4lovesSDK getServerInfo].playerName,[com4lovesSDK getServerInfo].vipLvl,platFormID];
    [[com4lovesSDK sharedInstance] showWeb:[self urlEncode:url]];
    }
}
- (void) showSdkFeedBack
{
    NSString* enableFeedback = [com4lovesSDK getPropertyFromIniFile:@"FeedBackEnable" andAttr:@"feedback"];
    if (enableFeedback&&[enableFeedback isEqualToString:@"1"]) {
        NSString *url = [NSString stringWithFormat:@"%@nuclear/feedback/querylist?gameId=%@&platformId=%@&puid=%@&nickName=%@",[[ServerLogic sharedInstance]getServerUrl],[com4lovesSDK getServerInfo].gameid,platFormID,[com4lovesSDK getServerInfo].puid,[[com4lovesSDK sharedInstance] getLoginedUserName]];
        [[com4lovesSDK sharedInstance] showWeb:[self urlEncode:url]];
    }
  
}
- (NSString *) urlEncode:(NSString *) url
{
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, nil, nil, kCFStringEncodingUTF8);
}

+(void)statisticsInfo
{
    [[ServerLogic sharedInstance] putToServerForDeviceInfo];
}
@end


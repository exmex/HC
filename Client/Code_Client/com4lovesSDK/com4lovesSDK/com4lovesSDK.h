//
//  com4lovesSDK.h
//  com4lovesSDK
//
//  Created by fish on 13-8-20.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YouaiServerInfo;
#define com4loves_loginDone             @"com4loves_loginDone"
#define com4loves_logout                @"com4loves_loginOut"
#define com4loves_tryuser2OkSucess      @"com4loves_tryuser2OkSucess"
#define com4loves_buyDone               @"com4loves_buyDone"
#define com4loves_serverList            @"com4loves_serverList"


@interface com4lovesSDK : NSObject

+ (com4lovesSDK *)sharedInstance;

+ (NSString *)getChannelID;  //platform_youai  下的各个小渠道区分
+ (NSString *)getPlatformID;  //平台区分 platform 91，pp，appstore，youai等等

+ (NSString *)getSDKAppID;   //有爱 后台统计用的appid
+ (NSString *)getSDKAppKey;  //有爱 后台统计用的appkey
+ (NSString *)getAlipayScheme;  //支付宝快捷支付的url scheme
+ (NSString *)getSignSecret;    //自有平台支付的密钥

+ (void)setSDKAppID:(NSString *) SDKID
          SDKAPPKey:(NSString *) SDKKey
          ChannelID:(NSString *) channel
         PlatformID:(NSString *) platform;
+ (void)setAlipayUrlScheme:(NSString *)scheme
             andSignSecret:(NSString *)sign;
+ (void)setAppId:(NSString *)paramAppKey;
- (BOOL)getLogined;
- (BOOL)getIsInGame;
- (BOOL)getIsTryUser;

+(NSString*)getYouaiID;
-(NSString*)getLoginedUserName;
+(NSString*)getAppID;

-(void) showWeb:(NSString*)url;

-(void)Login;
-(void)LoginTryUser;
-(void)showLogin;
-(void)showRegister;
-(void)showAccountManager;
-(void)showChooseBinding;
-(void)showAccountCenter;
-(void)showIndex;
-(void)showChangePassword;
-(void)showUserList;
-(void)showPay;
-(void)showBinding;
-(void)notifyEnterGame;
-(void)notifyLogoutGame;
-(void)hideAll;

-(void)clearLoginInfo;
-(void)logout;
-(void)logoutInGame;
-(void)tryUser2SucessNotify;
//-(void)iapBuy:(NSString*)productID serverID:(NSString*)description ;
-(void)iapBuy:(NSString*)_productID serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId;
-(void)appStoreBuy:(NSString*)_productID serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId;
-(void)appBuy:(NSString*)_productID  serverID:(NSString*)description totalFee:(float)fee orderId:(NSString *)orderId;
+(void)updateServerInfo:(int)serverID playerName:(NSString*)playerName playerID:(int)playerID lvl:(int)lvl vipLvl:(int)vipLvl coin1:(int)coin1 coin2:(int)coin2 pushSer:(BOOL) isPush;
+(void)refreshServerInfo:(NSString*) gameID puid:(NSString*)puid pushSer:(BOOL) isPush;
+(int)getServerInfoCount;
+(int)getServerUserByIndex:(int)index;
+(YouaiServerInfo *)getServerInfo;
- (void)parseURL:(NSURL *)url;
-(void)showFeedBack;
-(void)showSdkFeedBack;
+(NSString *)getPropertyFromIniFile:(NSString *)section andAttr:(NSString *)attr;
- (NSBundle *)mainBundle;
+(NSString*)getLang:(NSString *)key;
-(void)buyDone;
@end


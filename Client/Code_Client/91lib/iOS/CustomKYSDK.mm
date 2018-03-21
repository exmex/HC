//
//  CustomKYSDK.m
//  lib91
//
//  Created by ljc on 13-11-13.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import "CustomKYSDK.h"
//#import "OtherViewController.h"
#include "libKuaiyong.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import <CommonCrypto/CommonDigest.h>

#define RequestTimeOut 4

#define BASE_URL @"http://f_signin.bppstore.com/loginCheck.php"




@interface CustomKYSDK()
{
}
@property (copy,nonatomic)NSString* uid;
@property (copy,nonatomic)NSString* uname;
@end

@implementation CustomKYSDK
//@synthesize uid = _uid;
//@synthesize uname = _uname;

+ (CustomKYSDK *)shareSDK
{
    static CustomKYSDK* sharedSdk;
    if (!sharedSdk) {
        sharedSdk = [[CustomKYSDK alloc] init];
    }
    return sharedSdk;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.uid = nil;
        self.uname = nil;
    }
    return self;
}

-(void)dealloc
{
    self.uid = nil;
    self.uname = nil;
    [super dealloc];
}
//设置游戏的appId 和 appKey, 合作接入时分配, 可以找联系客服获取
- (void)initSDK
{
    [[KYSDK instance]setSdkdelegate:self];
    [[KYSDK instance] changeLogOption:KYLOG_OFFGAMENAME];
}
//显示登录界面
- (void)showLoginView
{
    [[KYSDK instance]showUserView];
}

- (BOOL)isLogin
{
    if(self.uid != nil)
        return [self.uid length]>0;
    else
        return FALSE;
}

//显示平台界面
- (void)showPlatformView
{
    [[KYSDK instance]setUpUser];
}

//获取当前用户ID
- (NSString *)getUserId
{
    return self.uid;
}

//获取当前用户名
- (NSString *)getUserName
{
    return self.uname;
}

//获取当前用户的SessionId
- (NSString *)getSessionId
{
    return @"";
}

//注销登录
- (void)logout
{
    [[KYSDK instance]userLogOut];
    libKuaiyong* plat = dynamic_cast<libKuaiyong*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_disableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}

- (void)showPayViewWithOrderID:(NSString *)orderID productID:(NSString *)productID title:(NSString *)title money:(int)money playerID:(NSString *) playID serverID:(NSString*) serverID
{
    NSString* desc = [NSString stringWithFormat:@"%d钻石",(int)(money*10)];
    NSString *tempDesc = [productID substringToIndex:[productID rangeOfString:@"."].location];
    [[KYSDK instance]showPayWith:[NSString stringWithFormat:@"%@-%@-%@",serverID,tempDesc,orderID]
                     fee:[NSString stringWithFormat:@"%.2f",(float)money]
                     game:@"4039"
                     gamesvr:@""
                     subject:desc
                     md5Key:@"7Ld5gIwY1yFLTKvwUWrGWSD4HHYXjWEq"
                    appScheme:@"com.nuclear.kuaiyongdragonball" ];
}


#pragma mark
#pragma mark -------------------- KyPaySDKDelegate ----------------------------

- (void)checkResult:(CHECK)result{
    if(SERVICE_CHECK == result){
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"等待支付结果"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else if(PAY_SUCCESS == result){
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"支付成功"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSDK_BUYDONE object:nil];
    }else if (PAY_FAILE == result){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"支付失败"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }else if(PAY_ERROR == result){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"支付异常"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark
#pragma mark -------------------- KyUserSDKDelegate ----------------------------
-(void)loginCallBack:(NSString *)tokenKey
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        NSString *postStr = [self buildData:data];
        NSMutableString* actionUrl = [NSMutableString stringWithString:BASE_URL];
        NSString *sign = [self md5sign:[NSString stringWithFormat:@"052eedc1929bb9c1594783f5a2479ada%@",tokenKey]];
        [actionUrl appendString:[NSString stringWithFormat:@"?tokenKey=%@&sign=%@",tokenKey,sign]];
        NSString *retValue = [self httpPost:actionUrl postData:tokenKey md5check:nil];
        NSLog(@"token back %@",retValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            id repr = retValue.JSONValue;
            if (repr)
            {
                if(self.uid != nil)
                {
                    self.uid = nil;
                }
                if(self.uname != nil)
                {
                    self.uname = nil;
                }
                NSDictionary *dic = repr;
                NSNumber* resultObj = [dic objectForKey:@"code"];
                if(resultObj&&[resultObj integerValue]==0){
                    NSDictionary *dataDic = [dic objectForKey:@"data"];
                    self.uname = [NSString stringWithFormat:[dataDic objectForKey:@"username"]];
                    self.uid = [NSString stringWithFormat:[dataDic objectForKey:@"guid"]];
                }
            }
            else
            {
                NSLog(@"解析失败");
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSDK_LOGIN object:nil];
        });
    });
}
/**
 快速登录成功回调
 **/
-(void)quickLogCallBack:(NSString *)tokenKey
{
    [self loginCallBack:tokenKey];
}

/**
 *游戏账号登陆成功回调
 **/
-(void)gameLoginSuc
{
}
/**
 注销成功回调
 **/
-(void)logOutCallBack:(NSString *)guid
{
    
    self.uid = nil;
    self.uname = nil;
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}

/**
 *  @method-(void)cancelUpdateCallBack
 *  游戏取消更新回调（单独使用更新时）
 **/
-(void)cancelUpdateCallBack
{
    
}

/**
 *  @method-(void)gameLoginCallback:(NSString *)username password:(NSString *)password
 *  游戏账号登陆回调
 **/
-(void)gameLoginCallback:(NSString *)username password:(NSString *)password
{
    
}

/**
 *-(void)callBackForgetGamePwd
 *游戏账号忘记密码回调
 **/
-(void)callBackForgetGamePwd
{
    
}

#pragma mark
#pragma mark -------------------- 验证tokenKey ----------------------------
-(void)userNotLogin{
    
    
}

-(void)userLoginTimeOut:(NSString *)guid{
    
}

-(NSString*) httpPost: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check
{
    return [self httpRequest:actionUrl postData:postStr md5check:check method:@"GET"];
}
-(NSString*) httpRequest: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check method:(NSString*) method
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//
    NSMutableData *mutabledata = [[NSMutableData alloc] init];
    NSURLResponse *response;
    NSError *err;
    [mutabledata appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err]];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSString *datastr=[[[NSString alloc]initWithData:mutabledata encoding:NSUTF8StringEncoding] autorelease];//data数据转换成string类型
    [request release];
    [mutabledata release];
    NSLog(@"token datastr %@",datastr);
    return datastr;
}

- (NSString *) md5sign:(NSString *) data
{
    const char *original_str = [data UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [NSString stringWithFormat:@"%@GMT", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"date :%@",currentDateStr);
    return currentDateStr;
}
@end

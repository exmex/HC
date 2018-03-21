//
//  libDownJoyObj.m
//  libDownJoy
//
//  Created by lvjc on 13-11-19.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libDownJoy.h"
#import "libDownJoyObj.h"
#import <DownjoySDK/DJPlatform.h>
#import <DownjoySDK/DJPlatformNotification.h>
#import <DownjoySDK/UserInfomation.h>
#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#define RequestTimeOut 4

#define BASE_URL  @"http://connect.d.cn/open/member/info/"

@implementation libDownJoyObj
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
 
    /* 监听登录结果通知（新版接口统一成功和失败的通知）*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SNSLoginResult:)
                                                 name:(NSString *)kDJPlatformLoginResultNotification
                                               object:nil];
    /* 监听用户注销通知*/

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlatformLogout:)
                                                 name:(NSString *)kDJPlatformLogoutResultNotification
                                               object:nil];
    /*监听初始化结果通知（3.0.1新增），该通知userInfo字典中带有检查更新结果*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tbInitFinished:)
                                                 name:kDJPlatformErrorNotification
                                               object:nil];
    /* 监听离开平台通知（3.0.1版本开始，该通知userInfo字典中带有离开的类型及订单号 */
	
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LeavePlatform:)
                                                 name:(NSString *)kDJPlatformMemberCenterCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealDJPlatformPaymentResultNotify:)
                                                 name:(NSString *)kDJPlatformPaymentResultNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealDJPlatformReadMemberInfoResultNotify:)
                                                 name:kDJPlatformReadMemberInfoResultNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerDJPlatformReadMemberInfoResultNotify:)
                                                 name:kDJPlatformRigisterNotification
                                               object:nil];
    
    
    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    //[self.view addSubview:waitView];//添加该waitView
    if ([[UIDevice currentDevice] systemVersion].floatValue<=4.4) {
        [waitView setBounds:CGRectMake(0, 0, 50, 50)];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
}

-(void) unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *	@brief	平台关闭通知，监听注销平台通知以对游戏界面进行重新调整
 */	
- (void)PlatformLogout:(NSNotification *)notify
{
    if(![[DJPlatform defaultDJPlatform] DJCheckLoginStatus])
    {
        libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_disableLogin();
            plat->setNickName("");
            plat->setLoginUin("");
        }
        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
    }
}

/**
 *	@brief	平台关闭通知，监听离开平台通知以对游戏界面进行重新调整
 */
- (void)LeavePlatform:(NSNotification *)notify
{
    if(![[DJPlatform defaultDJPlatform] DJCheckLoginStatus])
    {
        libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_disableLogin();
            plat->setNickName("");
            plat->setLoginUin("");
        }
        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
    }
}

/**
 *	@brief	登录通知监听方法，登录成功、失败都在这个方法处理
 *
 *	@param 	notification 	通知的userInfo包含登录结果信息
 */
- (void)SNSLoginResult:(NSNotification *)notify
{
    UserInfomation *information = notify.object;
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    if(information&&information.errorCode==nil)
    {
        libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_enableLogin();
            plat->setLoginUin([information.mid UTF8String]);
            plat->setNickName([information.nickName UTF8String]);
        }
        [self setWaiting:YES];
        [self verifyToken:information.token andMid:information.mid];
    }
    else
    {
        out=(information&&information.errorCode!=nil)?[information.errorMsg UTF8String]:"登录失败！";
        libPlatformManager::getPlatform()->_boardcastLoginResult(false,out);
    }
    //libPlatformManager::getPlatform()->_boardcastLoginResult(true,out);
    //[[DJPlatform defaultDJPlatform] DJReadMemberInfo];
}

-(void) dealDJPlatformReadMemberInfoResultNotify:(NSNotification *) notify
{
    UserInfomation *memberInfo = [notify object];
    NSString *content=[NSString stringWithFormat:@"mid:%@,username:%@,nickname:%@,token:%@,avatar_url:%@, gender:%@, level:%@", memberInfo.mid, memberInfo.userName, memberInfo.nickName, memberInfo.token, memberInfo.avatarUrl, memberInfo.gender, memberInfo.level];
    libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->setNickName([memberInfo.nickName UTF8String]);
    }
    libPlatformManager::getPlatform()->_boardcastLoginResult(true,[content UTF8String]);
}

-(void) registerDJPlatformReadMemberInfoResultNotify:(NSNotification *) notify
{
    UserInfomation *information = notify.object;
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    if(information&&information.errorCode==nil)
    {
        libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_enableLogin();
            plat->setLoginUin([information.mid UTF8String]);
            plat->setNickName([information.nickName UTF8String]);
        }
        [self setWaiting:YES];
        [self verifyToken:information.token andMid:information.mid];
    }
    else
    {
        out=(information&&information.errorCode!=nil)?[information.errorMsg UTF8String]:"登录失败！";
        libPlatformManager::getPlatform()->_boardcastLoginResult(false,out);
    }
}

-(void)dealDJPlatformPaymentResultNotify:(NSNotification*)notify
{
    NSDictionary *dict = notify.userInfo;
    NSString *orderNo = [dict objectForKey:@"orderNo"];
    NSNumber *code = [dict objectForKey:@"code"];
    NSString *msg = [dict objectForKey:@"msg"];
    NSString *content=[NSString stringWithFormat:@"orderNo:%@,code:%@,msg:%@", orderNo, code, msg];
	libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
    if(plat)
    {
        BUYINFO info = plat->getBuyInfo();
           
        if ([code isEqualToNumber:0])
        {
            std::string log("购买成功！");
            libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
        }
        else
        {
            std::string log([content UTF8String]);
            libPlatformManager::getPlatform()->_boardcastBuyinfoSent(false, info, log);
        }

    }
}

#pragma mark - 监听通知方法
- (void)tbInitFinished:(NSNotification *)notification
{
}

-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
 
}
#pragma     必须重写的验证相关的函数
-(void) onTokenResult:(NSString *)result
{
    id json = [result JSONValue];
    if (json)
    {
        NSDictionary *data = json;
        NSNumber *errCode =[data objectForKey:@"error_code"];
        if(![errCode isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            std::string out="验证token失败!";
            libPlatformManager::getPlatform()->_boardcastLoginResult(false, out);
        }
        else
        {
            NSNumber *userid =[data objectForKey:@"memberId"];
            NSString *nickname =[data objectForKey:@"nickname"];
            NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
            std::string out = [strTip UTF8String];
            libDownJoy* plat = dynamic_cast<libDownJoy*>(libPlatformManager::getPlatform());
            if(plat)
            {
                plat->_enableLogin();
                plat->setLoginUin([[NSString stringWithFormat:@"%@",userid] UTF8String]);
                plat->setNickName([[NSString stringWithFormat:@"%@",nickname] UTF8String]);
                libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
            }
        }
    }
    [self setWaiting:NO];
    
}

-(NSDictionary *) getVerifyHeader
{
    NSDictionary *headers = @{@"Content-Type": @"application/x-www-form-urlencoded"};
    return headers;
}

-(NSString *) getVerifyBody:(NSString *)token andMid:(NSString *)mid
{
    NSString *signStr = [NSString stringWithFormat:@"%@|%@",token,AppKey];
    NSString *sign = [self md5sign:signStr];
    NSString *bodyStr = [NSString stringWithFormat:@"app_id=%@&mid=%@&token=%@&sig=%@",AppId,mid,token,sign];
    return bodyStr;
}

-(NSString *) getVerifyUrl
{
    return BASE_URL;
}

#pragma     验证过程中可能用到的工具方法

/*
 验证的http请求会在其他线程中运行,验证结果返回后,会调用 onTokenResult 方法
 在onTokenResult 里面来处理验证结果
 */

- (void) verifyToken:(NSString *)token andMid:(NSString *)mid
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *result = [[self verifyTokenWithURL:[self getVerifyUrl] andToken:token andMid:mid] retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onTokenResult:[result autorelease]];
        });
    });
    
}
/*
 验证的HTTP请求,使用的是Post方法
 */
-(NSString*) verifyTokenWithURL: (NSString*) actionUrl andToken:(NSString *)token andMid:(NSString *)mid
{
    NSString *httpBody = [[self getVerifyBody:token andMid:mid] retain];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",actionUrl,httpBody]];//把相关的网络请求的接口存放到url里
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:RequestTimeOut];
    //第三步，连接服务器,发送同步请求
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *datastr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return datastr;
}

/*
 URLencode 编码
 */
- (NSString *) urlEncode:(NSString *) url
{
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, nil, nil, kCFStringEncodingUTF8);
}
/*
 MD5 加密并返回
 */
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
/*
 返回当前的时间,时间格式可以自己改
 默认 格式  format =@"EEE, dd MMM yyyy HH:mm:ss";
 默认 时区  en_US
 */
- (NSString *)getCurrentDateWith:(NSString *)format andLocation:(NSString *)location
{
    if (!format) {
        format =@"EEE, dd MMM yyyy HH:mm:ss";
    }
    if (!location) {
        location = @"en_US";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:location] autorelease]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}
/*
 返回当前的UNIX 时间戳
 */
-(NSString *)getUnixTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

/*
 转菊花的方法
 */
-(void) setWaiting:(BOOL) isWait
{
    if(waitView)
    {
        if(isWait == YES)
        {
            [waitView startAnimating];
        }
        else
        {
            [waitView stopAnimating];
        }
    }
    
}

@end

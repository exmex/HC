//
//  libUCObj.m
//  libUC
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//  接入的平台需要token验证 请参考这个demo
//
//  验证的http请求会在其他线程中运行,验证结果返回后,会调用 onTokenResult 方法
//  在onTokenResult 里面来处理验证结果


#include "libUC.h"
#import "libUCObj.h"
#import <UCGameSdk/UCGameSdk.h>

#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#define RequestTimeOut 4

#define BASE_URL  @"http://sdk.g.uc.cn/ss"


static NSString* userName = @"";  //验证返回的UserName
static NSString* uid      = @"";  //验证返回的UID

@implementation libUCObj


#pragma must overwrite
-(void) SNSInitResult:(NSNotification *)notify
{
    [self registerNotification];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
    //添加监听注销
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlatformLogout:)
                                                 name:UCG_SDK_MSG_LOGOUT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SNSLoginResult:)
                                                 name:UCG_SDK_MSG_LOGIN_FIN
                                               object:nil];

    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    if ([[UIDevice currentDevice] systemVersion].floatValue<=4.4) {
        [waitView setBounds:CGRectMake(0, 0, 50, 50)];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
}

- (void)PlatformLogout:(NSNotification *)notify
{
    static int leaveCount=1;
    if(leaveCount%2!=0)
    {
        userName = @"";
        uid = @"";
        libPlatformManager::getPlatform()->_boardcastPlatformLogout();
    }
    leaveCount++;
}

- (void)SNSLoginResult:(NSNotification *)notify
{
    UCResult *result = (UCResult *)notify.object;
    // 判断是否成功登录
    if (!result.isSuccess) {
        libPlatformManager::getPlatform()->_boardcastLoginResult(false, "");
        return;
    }
    [self setWaiting:YES];
    NSString *token = [[UCGameSdk defaultSDK] sid];
    NSDictionary *params = @{@"token":token};
    [self verifyToken:params];
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
        NSDictionary *dic = json;
        NSDictionary *userInfo = [dic objectForKey:@"data"];
        userName = [[userInfo objectForKey:@"nickName"] retain];
        NSNumber *userid =[userInfo objectForKey:@"ucid"];
        uid = [[NSString stringWithFormat:@"%@",userid] retain];
        
        NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
        std::string out = [strTip UTF8String];
        libUC* plat = dynamic_cast<libUC*>(libPlatformManager::getPlatform());
        if(plat)
        {
            plat->_enableLogin();
        }
        libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
    }
    [self setWaiting:NO];

}

-(NSDictionary *) getVerifyHeader
{
    NSDictionary *headers = @{@"Content-Type": @"application/x-www-form-urlencoded"};
    return headers;
}

-(NSString *) getVerifyBody:(NSDictionary *)params
{
    NSString *token = [[params objectForKey:@"token"] retain];
    NSString *time = [self getUnixTimeStamp];
    NSString *signStr = [NSString stringWithFormat:@"%dsid=%@%@",uccpid,token,ucappkey];
    NSString *sign = [self md5sign:signStr];
    NSString *bodyStr = [NSString stringWithFormat:@"{\"id\":%@,\"service\":\"ucid.user.sidInfo\",\"data\":{\"sid\":\"%@\"},\"game\":{\"cpId\":%d,\"gameId\":%d,\"channelId\":\"%@\",\"serverId\":%d},\"sign\":\"%@\",\"encrypt\":\"md5\"}",time,token,uccpid,ucgameId,@"2",ucserverId,sign];
    [token release];
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
- (void) verifyToken:(NSDictionary *)token
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *result = [[self verifyTokenWithURL:[self getVerifyUrl] andToken:token] retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onTokenResult:[result autorelease]];
        });
    });
    
}
/*
 验证的HTTP请求,使用的是Post方法
 */
-(NSString*) verifyTokenWithURL: (NSString*) actionUrl andToken:(NSDictionary *)params
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//创建一个可变请求，并且请求的接口为url
    [request setHTTPMethod:@"POST"];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时
    
    NSDictionary *headers = [self getVerifyHeader];
    if (headers) {
        for (NSString *akey in [headers allKeys]) {
            [request setValue:[headers objectForKey:akey] forHTTPHeaderField:akey];
        }
    }
    NSString *httpBody = [[self getVerifyBody:params] retain];
    NSData *body =[httpBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:@"Content-Length"];
    
    NSMutableData *mutabledata = [[NSMutableData alloc] init];
    NSURLResponse *response;
    NSError *err;
    [mutabledata appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err]];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSString *datastr=[[[NSString alloc]initWithData:mutabledata encoding:NSUTF8StringEncoding] autorelease];//data数据转换成string类型
    [request release];
    [mutabledata release];
    [httpBody release];
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
/*
 验证成功后,可以从这里取得 用户名
 */
-(NSString *) getNickName
{
    return userName;
}
/*
 验证成功之后可以从这里取得用户uid
 */
-(NSString *) getUserID
{
    return uid;
}
@end

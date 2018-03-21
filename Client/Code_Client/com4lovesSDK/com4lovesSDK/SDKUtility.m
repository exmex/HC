//
//  SDKUtility.m
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "SDKUtility.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "com4lovesSDK.h"
#import "SvUDIDTools.h"
#define RequestTimeOut 4

@interface SDKUtility()
{

    SEL asynHttpSel;
    id asynHttpObj;
    
}
@property (nonatomic, retain) NSMutableData* mData;
@property (nonatomic, retain) UIActivityIndicatorView *waitView;
@end

@implementation SDKUtility
@synthesize waitView = _waitView;
@synthesize mData;

+ (SDKUtility *)sharedInstance
{
    static SDKUtility *_instance = nil;
    if (_instance == nil) {
        _instance = [[SDKUtility alloc] init];
    }
    return _instance;
}
- (id)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
       CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
        _waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
        [self.waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
        [self.waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
        [self.waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
        if ([[UIDevice currentDevice] systemVersion].floatValue<=4.4) {
            [self.waitView setBounds:CGRectMake(0, 0, 50, 50)];
        }
        //[self.view addSubview:waitView];//添加该waitView
    return self;
}

- (NSString*)encodeURL:(NSString *)urlString
{
    //把NSString 转 CFStringRef
    CFStringRef originalURLString = (__bridge CFStringRef)urlString;
    CFStringRef preprocessedString =
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, originalURLString, CFSTR(""), kCFStringEncodingUTF8);
    CFStringRef urlString1 =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedString, NULL, NULL, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, urlString1, NULL);
    //CFStringRef 转 NSString
    NSString* urlStringret = (__bridge NSString*) url;
    
    //转换后，发现并非NSString 而是NSURL 这很奇怪 所以再转一次
    if ([urlStringret isKindOfClass:[NSURL class]]) {
        NSURL *url2 = (__bridge NSURL*) url;;
        urlStringret = [url2 absoluteString];
    }
    YALog(@"nsstring:%@",urlStringret);
    return urlStringret;
}
-(void) setWaiting:(BOOL) isWait
{
    if(self.waitView)
    {
        if(isWait == YES)
        {
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.waitView];
            [self.waitView startAnimating];
        }
        else
        {
            [self.waitView stopAnimating];
            [self.waitView removeFromSuperview];
        }
    }
    
}


-(NSString*) httpRequest: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check method:(NSString*) method
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//创建一个可变请求，并且请求的接口为url
    [request setHTTPMethod:method];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时

    if(check)
    {
        [request setValue:check forHTTPHeaderField:@"Game-Checksum"];
    }
    [request setHTTPBody:postStr];
    //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
      NSMutableData *mutabledata = [[NSMutableData alloc] init];
    NSURLResponse *response;
    NSError *err;
    [mutabledata appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err]];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSString *datastr=[[[NSString alloc]initWithData:mutabledata encoding:NSUTF8StringEncoding] autorelease];//data数据转换成string类型
    [request release];
    [mutabledata release];
    return datastr;
}

-(int) httpForStatus: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check method:(NSString *)method
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//创建一个可变请求，并且请求的接口为url
    [request setHTTPMethod:method];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时
    
    if(check)
    {
        [request setValue:check forHTTPHeaderField:@"Game-Checksum"];
    }
    [request setHTTPBody:postStr];
    NSURLResponse *response;
    NSError *err;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode];
    YALog(@"status %d",statusCode);
    [request release];
    return  statusCode;
    
}

-(NSString*) httpPost: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check
{
    return [self httpRequest:actionUrl postData:postStr md5check:check method:@"POST"];
}
-(NSString*) httpPost: (NSString*) actionUrl postData:(NSData *)postStr
{
    return [self httpPost:actionUrl postData:postStr md5check:nil];
}

-(NSString*) httpPut: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check
{
    return [self httpRequest:actionUrl postData:postStr md5check:check method:@"PUT"];
}
-(NSString*) httpPut: (NSString*) actionUrl postData:(NSData *)postStr
{
    return [self httpPut:actionUrl postData:postStr md5check:nil];
}
-(int) httpPostForStatus: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check
{
    return [self httpForStatus:actionUrl postData:postStr md5check:check method:@"POST"];
}

-(int) httpPutForStatus: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check
{
    return [self httpForStatus:actionUrl postData:postStr md5check:check method:@"PUT"];
}

-(NSString*) getMacAddress
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 )
    {
        return [SvUDIDTools UDID] ;
    }
    
    return [self getMacAddressOnly];
}
-(NSString*) getMacAddressOnly
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex errorn");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%X:%X:%X:%X:%X:%X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
-(NSString *) md5HexDigest :(NSString*) str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

-(void) showAlertMessage: (NSString*)message
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                        otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(BOOL)checkInput:(NSString*) userName password:(NSString*)password email:(NSString*)email
{
    if([userName length]>12)
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_username_toolong"]];
        return NO;
    }
    if([userName length]<6)
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_username_tooshoot"]];
        return NO;
    }
    if([password length]<6 || [password length]>12)
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_password_length"]];
        return NO;
    }
    if(email && [email length]>64)
    {
        [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_email_toolong"]];
        return NO;
    }
    
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9]" options:0 error:nil];
    if (regex2) {
        NSTextCheckingResult *result2 = [regex2 firstMatchInString:userName options:0 range:NSMakeRange(0, [userName length])];
        if (result2) {
            [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_username_ilegl"]];
            return NO;
        }
        NSTextCheckingResult *result3 = [regex2 firstMatchInString:password options:0 range:NSMakeRange(0, [password length])];
        if (result3) {
            [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_password_ilegl"]];
            return NO;
        }
    }
    
    if(email)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b" options:0 error:nil];
        NSInteger count = [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
        if(count==0 && [email length]>0 && ![email isEqualToString:[com4lovesSDK getLang:@"email_optional"]])
        {
            [[SDKUtility sharedInstance] showAlertMessage:[com4lovesSDK getLang:@"notice_email_ilegl"]];
            return NO;
        }
    }
    
    return YES;
}

////////////// asynic http request //////////////
-(void) httpAsynPut: (NSString*) actionUrl postData:(NSData *)postStr md5check:(NSString*) check selector:(SEL)selector object:(id)object
{
    asynHttpSel = selector;
    asynHttpObj = object;
    
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//创建一个可变请求，并且请求的接口为url
    [request setHTTPMethod:@"PUT"];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时

    if(check)
    {
        [request setValue:check forHTTPHeaderField:@"Game-Checksum"];
    }
    [request setHTTPBody:postStr];
    //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    mData = nil;
    [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
}
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    
//    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    //YALog(@"response length=%lld  statecode%d", [response expectedContentLength],responseCode);
}


// A delegate method called by the NSURLConnection as data arrives.  The
// response data for a POST is only for useful for debugging purposes,
// so we just drop it on the floor.
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    if (self.mData == nil) {
        mData = [[[NSMutableData alloc] initWithData:data] autorelease];
    } else {
        [self.mData appendData:data];
    }
    //YALog(@"response connection");
}

// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self showAlertMessage:[error localizedFailureReason]];
    //YALog(@"response error%@", [error localizedFailureReason]);
}

// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *responseString = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    //YALog(@"response body%@", responseString);
    [asynHttpObj performSelector:asynHttpSel withObject:responseString];
}

- (void)dealloc{
    [_waitView release];
    
    [super dealloc];
}
@end

//
//  GameTestViewController.m
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import "CustomSDKViewController.h"
//#import "DropDownList.h"
#import "Custom37SDK.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#define RequestTimeOut 4

#define BASE_URL @"http://gop.37wanwan.com/api/verifyUser"

static NSString* gameId = @"34";
static NSString* gameSecret = @"1958ce778e57a72666fc19e6c7ac599e";
static NSString* vendor = @"Beijing Com4loves Interactive Co,.Ltd";
static NSString* apiName = @"verifyUser";
static NSString* uid = @"";



@interface CustomSDKViewController (){
    GameLib *_tools;
}
    
@end

@implementation CustomSDKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];

}
- (NSString *)userID
{
    return uid;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginAction:(UIButton *)button{
    _tools = [[GameLib alloc] init];
    _tools.gamelibDelegate = self;
    [_tools showLogin:self];
    
}

- (void)payForProductName:(NSString *) title productId:(NSString *)productID price:(int)money orderId:(NSString *)orderID{
    GameLib *tools = [[GameLib alloc] init];
    tools.gamelibDelegate = self;
    [tools showPay:self productName:title productId:productID price:money*100 quantity:1 orderId:orderID];
}

- (void)logoutAction:(UIButton *)button{
    GameLib *tools = [[GameLib alloc] init];
    [tools logoutAction:@""];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark- gamelibdelegate
- (void)onClose:(id)sender{
    NSLog(@"***支付取消回调***");
    [Custom37SDK hideAllView];

}

- (void)onCancel:(id)sender{
    NSLog(@"***登录取消回调***");
    [Custom37SDK hideAllView];
}

- (void)onLoginSuccess:(NSString *)token{
    NSLog(@"***登录成功回调callback.token=%@***",token);
    
    [Custom37SDK hideAllView];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *postStr = [self buildData:data];
        NSMutableString* actionUrl = [NSMutableString stringWithString:BASE_URL];

        NSString *retValue = [self httpPost:actionUrl postData:token md5check:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            id repr = retValue.JSONValue;
            if (repr)
            {
                NSDictionary *dic = repr;
                NSString* resultObj = [dic objectForKey:@"usergameid"];
                if(resultObj){
                    [uid release];
                    uid = [resultObj retain];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSDK_LOGIN object:nil];

                } else {
                    NSNumber *errcode = [dic objectForKey:@"errcode"];
                    if ([errcode intValue]==1000) {
                        NSLog(@"Authentication验证不通过");
                    } else if ([errcode intValue]==1001) {
                        NSLog(@"缺少的参数");
                    } else if ([errcode intValue]==1002) {
                        [self logoutAction:nil];
                        [self loginAction:nil];
                        NSLog(@"token不正确或者已过期");
                    }
                    
                }
            } else {
                NSLog(@"解析失败");
            }
        });
    });

}
- (BOOL)isLogin
{
    return [uid length]>1;
}
-(NSString*) httpPost: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check
{
    return [self httpRequest:actionUrl postData:postStr md5check:check method:@"POST"];
}
-(NSString*) httpRequest: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check method:(NSString*) method
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//创建一个可变请求，并且请求的接口为url
    NSString *datestr = [self getCurrentDate];
    NSString *auth = [self getAuthentication:[NSString stringWithFormat:@"token=%@",postStr] withDate:datestr];
    [request setHTTPMethod:method];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"gop_37wanwan" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json; version=1.0" forHTTPHeaderField:@"Accept"];
   
    [request setValue:auth forHTTPHeaderField:@"Authentication"];
    [request setValue:datestr forHTTPHeaderField:@"Date"];
    NSString *sUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)postStr, nil, nil, kCFStringEncodingUTF8);
    NSString *bodyStr = [NSString stringWithFormat:@"token=%@",sUrl];
    NSData *body =[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:@"Content-Length"];

    [request setHTTPBody:body];
    //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *mutabledata = [[NSMutableData alloc] init];
    NSURLResponse *response;
    NSError *err;
    [mutabledata appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err]];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSString *datastr=[[[NSString alloc]initWithData:mutabledata encoding:NSUTF8StringEncoding] autorelease];//data数据转换成string类型
    [request release];
    [mutabledata release];
    NSLog(@"datastr %@",datastr);
    return datastr;
}

- (NSString *) getAuthentication:(NSString *)params withDate:(NSString *)date
{
    NSString* authentication = [NSString stringWithFormat:@"%@ %@:%@",vendor,gameId,[self getRequestSign:params withDate:date]];
    NSLog(@"getAuthentication %@",authentication);
    return authentication;
}

- (NSString *) getRequestSign:(NSString *)params withDate:(NSString *)date
{
    NSString *str =[NSString stringWithFormat:@"%@:%@:%@:%@",date,apiName,params,gameSecret];
    NSLog(@"getRequestSign %@",str);
    return [self md5sign:str];
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

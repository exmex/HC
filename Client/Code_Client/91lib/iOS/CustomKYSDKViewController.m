//
//  GameTestViewController.m
//  GameLibTest
//
//  Created by M an on 13-8-6.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import "CustomKYSDKViewController.h"
//#import "DropDownList.h"
#import "CustomKYSDK.h"
#import <CommonCrypto/CommonDigest.h>
#define RequestTimeOut 4

static NSString* gameId = @"3308";
static NSString* gameSecret = @"07846a896bf96b0ff34dc3ec469b86b6";
static NSString* vendor = @"Beijing Com4loves Interactive Co,.Ltd";
static NSString* apiName = @"verifyUser";
static NSString* uid = @"";



@interface CustomKYSDKViewController (){
//    GameLib *_tools;
    KyUserSDK * sdk;

}

@end

@implementation CustomKYSDKViewController

-(id)init{
    self = [super init];
    if(self){
        sdk = [[KyUserSDK alloc]init];
        sdk.kyUserSDKDelegate = self;
        //        sdk.frame = CGRectMake(0, 0, 320, 480);
        //        [self.view addSubview:sdk];
    }
    return self;
    
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
    [sdk showLoginView];
}

- (void)payForProductName:(NSString *) title productId:(NSString *)productID price:(int)money orderId:(NSString *)orderID{
//    GameLib *tools = [[GameLib alloc] init];
//    tools.gamelibDelegate = self;
//    [tools showPay:self productName:title productId:productID price:money*100 quantity:1 orderId:orderID];
}

- (void)logoutAction:(UIButton *)button{
//    GameLib *tools = [[GameLib alloc] init];
//    [tools logoutAction:@""];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark- gamelibdelegate
- (void)onClose:(id)sender{
    NSLog(@"***支付取消回调***");
//    [Custom37SDK hideAllView];

}

- (void)onCancel:(id)sender{
//    NSLog(@"***登录取消回调***");
//    [Custom37SDK hideAllView];
}

- (void)onLoginSuccess:(NSString *)token{
    NSLog(@"***登录成功回调callback.token=%@***",token);
    
//    [Custom37SDK hideAllView];
}

-(void)userLogin:(NSString *)infoMap serviceTokenKey:(NSString *)tokenKey{
    
    [CustomKYSDK hideAllView];
    
    uid = [NSString stringWithString:tokenKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSDK_LOGIN object:nil];

    
    UIAlertView * tip = [[UIAlertView alloc]initWithTitle:@"登陆成功" message:infoMap delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip show];
    [tip release];
    
    UIAlertView * tip2 = [[UIAlertView alloc]initWithTitle:@"key" message:tokenKey delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip2 show];
    [tip2 release];
    
    //    [sdk closeUserSystem];
}

-(void)quickGame:(NSString *)infoMap serviceTokenKey:(NSString *)tokenKey{
    UIAlertView * tip = [[UIAlertView alloc]initWithTitle:@"快速登陆成功" message:infoMap delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip show];
    [tip release];
    
    UIAlertView * tip2 = [[UIAlertView alloc]initWithTitle:@"key" message:tokenKey delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip2 show];
    [tip2 release];
    
    [sdk closeUserSystem];
}

-(void)userLoginOut:(NSString *)infoMap{
    UIAlertView * tip = [[UIAlertView alloc]initWithTitle:@"退出成功" message:infoMap delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip show];
    [tip release];
    
    //    [sdk closeUserSystem];
}

-(void)userNotLogin{
    
    UIAlertView * tip = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登陆" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip show];
    [tip release];
}

-(void)userLoginTimeOut:(NSString *)guid{
    
    UIAlertView * tip = [[UIAlertView alloc]initWithTitle:@"登陆超时, 请重新登陆" message:guid delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [tip show];
    [tip release];
    
    //    [sdk closeUserSystem];
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

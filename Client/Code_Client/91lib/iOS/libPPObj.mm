//
//  libPPObj.m
//  libPP
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libPP.h"
#import "libPPObj.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import <CommonCrypto/CommonDigest.h>

#define RequestTimeOut 4

#define BASE_URL @"http://passport_i.25pp.com:8080/index?tunnel-command=2852126756"

@interface libPPObj()
{
    NSString *_uid;
    NSString *_uname;
}
@end
@implementation libPPObj

-(void) SNSInitResult:(NSNotification *)notify
{
//    [self registerNotification];
    //std::string outstr = "";
    //libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}

-(void) registerNotification
{
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
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNdCPBuyResultNotification object:nil];
}

- (void)PlatformLogout:(NSNotification *)notify
{
    libPP* plat = dynamic_cast<libPP*>(libPlatformManager::getPlatform());
    if(plat)
    {
        plat->_disableLogin();
    }
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();

}
//登录
- (void)SNSLoginResult:(NSNotification *)notify
{
    NSString* strTip = [NSString stringWithFormat:@"游客账号登录成功"];
    std::string out = [strTip UTF8String];
    libPP* plat = dynamic_cast<libPP*>(libPlatformManager::getPlatform());
	if(plat)
	{
		plat->_enableLogin();
	}
    libPlatformManager::getPlatform()->_boardcastLoginResult(true, out);
	
}



-(void)NdUniPayAysnResult:(NSNotification*)notify
{
//    if (PP_ISNSLOG) {
//        NSLog(@"兑换的回调%@",notify.object);
//    }
    //回调购买成功。其余都是失败
    
		libPP* plat = dynamic_cast<libPP*>(libPlatformManager::getPlatform());
		if(plat)
		{
			BUYINFO info = plat->getBuyInfo();
			std::string log("购买成功");
			libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, info, log);
		}
}

-(void) uploadChannelIdDidFinish:(int)error
{
}

-(void) updateApp
{
    
}
-(NSString *) getUserName
{
    return _uname;
}
-(NSString *) getUserID
{
    return _uid;
}
-(bool) getIsLogin
{
    return  0==[[PPAppPlatformKit sharedInstance] loginState];
}
#pragma mark    ---------------SDK CALLBACK---------------
//字符串登录成功回调【实现其中一个就可以】
- (void)ppLoginStrCallBack:(NSString *)tokenKey{
    //字符串token验证方式
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        NSString *postStr = [self buildData:data];
        NSMutableString* actionUrl = [NSMutableString stringWithString:BASE_URL];
        NSString *retValue = [self httpPost:actionUrl postData:tokenKey md5check:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            id repr = retValue.JSONValue;
            if (repr)
            {
                if(_uid != nil)
                {
                    _uid = nil;
                }
                if(_uname != nil)
                {
                    _uname = nil;
                }
                NSDictionary *dic = repr;
                NSNumber* resultObj = [dic objectForKey:@"status"];
                if(resultObj&&[resultObj integerValue]==0){
                    _uname = [NSString stringWithString:[dic objectForKey:@"username"]];
                    _uid = [NSString stringWithFormat:@"%lld",[(NSNumber *)[dic objectForKey:@"userid"]longLongValue]];
                }
                [[PPAppPlatformKit sharedInstance] getUserInfoSecurity];
                [self SNSLoginResult:nil];

            }
            else
            {
                NSLog(@"解析失败");
                UIAlertView *alert = [[UIAlertView alloc] init];
                [alert setTitle:@"错误"];
                [alert setMessage:@"Token 校验错误请重试！"];
                [alert show];
            }
        });
    });
    
}

//关闭客户端页面回调方法
-(void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode{
    //可根据关闭的VIEW页面做你需要的业务处理
    NSLog(@"当前关闭的VIEW页面回调是%d", paramPPPageCode);
}



//关闭WEB页面回调方法
- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode{
    //可根据关闭的WEB页面做你需要的业务处理
    NSLog(@"当前关闭的WEB页面回调是%d", paramPPWebViewCode);
}

//注销回调方法
- (void)ppLogOffCallBack
{
    NSLog(@"注销的回调");
    [self PlatformLogout:nil];
}

//兑换回调接口【只有兑换会执行此回调】
- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode
{
    NSLog(@"兑换回调返回编码%d",paramPPPayResultCode);
    //回调购买成功。其余都是失败
    if(paramPPPayResultCode == PPPayResultCodeSucceed){
        //购买成功发放道具
        [self NdUniPayAysnResult:nil];
    }else{
        
    }
}

-(void)ppVerifyingUpdatePassCallBack
{
    NSLog(@"验证游戏版本完毕回调");
    //[[PPAppPlatformKit sharedInstance] showLogin];
    std::string outstr = "";
    libPlatformManager::getPlatform()->_boardcastUpdateCheckDone(true,outstr);
}
#pragma mark
#pragma mark -------------------- 验证tokenKey ----------------------------
-(void)userNotLogin{
    
    
}

-(void)userLoginTimeOut:(NSString *)guid{
    
}

-(NSString*) httpPost: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check
{
    return [self httpRequest:actionUrl postData:postStr md5check:check method:@"POST"];
}
-(NSString*) httpRequest: (NSString*) actionUrl postData:(NSString *)postStr md5check:(NSString*) check method:(NSString*) method
{
    NSURL *url=[NSURL URLWithString:actionUrl];//把相关的网络请求的接口存放到url里
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//
    [request setHTTPMethod:method];//请求方式设置为POST
    [request setTimeoutInterval:RequestTimeOut];//设置4秒超时
    
    [request setValue:@"User_Agent" forHTTPHeaderField:@"25PP"];
    [request setValue:@"Connection" forHTTPHeaderField:@"close"];
    [request setValue:@"Content-Length" forHTTPHeaderField:[NSString stringWithFormat:@"%d",[postStr length]]];
    
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableData *mutabledata = [[NSMutableData alloc] init];
    NSURLResponse *response;
    NSError *err;
    [mutabledata appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err]];//同步请求连接服务器，并且告诉服务器，请求的内容是什么，把同步方法返回的NSData加到刚刚创建的可变数组mutabledata中
    NSString *datastr=[[NSString alloc]initWithData:mutabledata encoding:NSUTF8StringEncoding];//data数据转换成string类型
   
    NSLog(@"token datastr %@",datastr);
    return [NSString stringWithFormat:@"{%@}",datastr];
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
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [NSString stringWithFormat:@"%@GMT", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"date :%@",currentDateStr);
    return currentDateStr;
}

@end

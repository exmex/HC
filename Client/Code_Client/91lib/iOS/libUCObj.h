//
//  libUCObj.h
//  libUC
//
//  Created by 王帅廷 on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface libUCObj : NSObject
{
    UIActivityIndicatorView *waitView;
}
-(void) registerNotification;
-(void) SNSLoginResult:(NSNotification *)notify;
-(void) SNSInitResult:(NSNotification *)notify;
-(void) updateApp;

#pragma     验证通过之后用户名和UID

-(NSString *) getNickName; //验证通过后 取得userName
-(NSString *) getUserID;   //验证通过后,取得userId

#pragma     验证时必须重写的函数
-(void) onTokenResult:(NSString *)result;          //必须重写   验证请求发送完成后用来返回结果
-(NSString *) getVerifyBody:(NSDictionary *)params;     //必须重写   返回验证的httpbody
-(NSDictionary *) getVerifyHeader;                 //必须重新   返回验证的httpparams
-(NSString *) getVerifyUrl;                        //必须重写   返回验证的URL

#pragma     验证过程中可能用到的工具方法
-(NSString *) urlEncode:(NSString *) url;          //urlencode编码
-(NSString *) md5sign:(NSString *) data;           //md5加密
-(NSString *) getCurrentDateWith:(NSString *)format andLocation:(NSString *)location;  //按格式取得当前时间
-(NSString *) getUnixTimeStamp;                    //取得当前Unix时间戳

@end

//
//  UseSDKView.m
//  PayDemo
//
//  Created by 悠然天地 on 13-9-22.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import "UseSDKView.h"
#import "com4lovesSDK.h"
@implementation UseSDKView

@synthesize    isOrientation = isOrientation;
@synthesize    mTotalFee;
@synthesize    mServerID;
@synthesize    mDesc;
@synthesize    mSubject;
@synthesize    mOrderId;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        isOrientation = YES;
        
        [KY_PaySDK instance].hidden = YES;
        
        [KY_PaySDK instance].ky_delegate = self;
        
        [self addSubview:[KY_PaySDK instance]];
        
        //注册支付宝通知接收
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"KY_NOTIFICATION" object:nil];
    }
    return self;
}

-(void)setControllerAndUrlScheme:(UIViewController*)vc urlScheme:(NSString*)urlScheme{
    
    [[KY_PaySDK instance] setViewController:vc andAppScheme:urlScheme];
}

//支付宝 '直接' 通知结果
- (void)payResult:(NSNotification*)notification{
    
    [KY_PaySDK instance].hidden = YES;
    
    id obj = [notification object];
    NSURL * url = obj;
    CHECK result = [[KY_PaySDK instance] checkAlipayResult:url];
    
    [self checkCode:result];
}

- (void) showPay{
    
    NSString *tempDesc = [mDesc substringToIndex:[mDesc rangeOfString:@"."].location];
//    NSLog(@"fee %f  serverid %@ msubject %@ mDesc %@",mTotalFee,mServerID,mSubject,tempDesc);
    NSMutableDictionary * map = [NSMutableDictionary dictionaryWithObjectsAndKeys:

                                 mOrderId, @"dealseq",
                                 [NSString stringWithFormat:@"%.2f",mTotalFee], @"fee",
                                 @"mengxianghaizeiwang", @"game",
                                 @"", @"gamesvr",
                                 mSubject, @"subject",
                                 @"1.3", @"v",
#warning 疑问   //serverid-10.haizeiwang.youai-uid
                                 [NSString stringWithFormat:@"%@-%@-%@",mServerID,tempDesc,[com4lovesSDK getYouaiID]], @"uid",
                                 @"alipaywap", @"paytype",
                                 nil];
//    NSLog(@"kuaiyong Map %@",map);
    NSString * ss = [KY_PaySDK getMD5Str:map];
    NSString * sign = [KY_PaySDK getMD5:[NSString stringWithFormat:@"%@6Hyxm8NcLJX4kr55y7kvNWgXEVmGEZfK",ss]];
    sign = [sign lowercaseString];
    
    [map setObject:sign forKey:@"sign"];
    
    [[KY_PaySDK instance] setValue:map];
}

//回调
/*银联回调
 seq        : dealseq
 code       : 银联状态码 1为成功,-1为失败
 resultStr  : 状态码描述
 */
- (void)unionpayResult:(NSDictionary *)result{
    
    isOrientation = YES;
//    NSLog(@"unionpayResult %@",result);
    NSString *resultNum = [result objectForKey:RESULT_CODE];
    if ([resultNum isEqualToString:@"-1"]) {
       
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                           message:[com4lovesSDK getLang:@"order_faild"]
                                                          delegate:nil
                                                 cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_buyDone object:nil];
    }

    [[com4lovesSDK sharedInstance] hideAll];

}

//支付状态点击
/*
 select : @"success" 点击支付成功
 @"fail" 点击支付失败
 seq    : dealseq
 */
-(void)userBehavior:(BEHAVIOR)kind{
    
    switch (kind) {
        case USER_DOUNIONPAY:
            
            [self userSelectUnionpay];
            break;
        case USER_DOCARDPAY:
            
            [self userPayCardSuccess];
            break;
        case USER_CLOSEVIEW:
            
            [self userCloseView];
            break;
        default:
            break;
    }
    
}

- (void)payStateClick:(NSDictionary *)stateMap{

    [[com4lovesSDK sharedInstance] hideAll];

}


-(void)userPayCardSuccess{
    [[com4lovesSDK sharedInstance] hideAll];
}

//支付宝 '服务器' 回调通知
- (void)checkResult:(CHECK)result{
    
    [self checkCode:result];
}

//是否使用银联支付 (在其中处理屏幕横屏时, 将屏幕竖起)
-(void)userSelectUnionpay{

    isOrientation = YES;
}

//状态码对应
- (void)checkCode:(CHECK)result{
    
    if(SERVICE_CHECK == result){
        
    
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                           message:[com4lovesSDK getLang:@"order_wait_result"]
                                                          delegate:nil
                                                 cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else if(PAY_SUCCESS == result){
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                       message:[com4lovesSDK getLang:@"order_success"]
                                                      delegate:nil
                                             cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                             otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:com4loves_buyDone object:nil];
    }else if (PAY_FAILE == result){

        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                           message:[com4lovesSDK getLang:@"order_faild"]
                                                          delegate:nil
                                                 cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];

    }else if(PAY_ERROR == result){
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                           message:[com4lovesSDK getLang:@"order_exception"]
                                                          delegate:nil
                                                 cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [[com4lovesSDK sharedInstance] hideAll];

}

- (void)userCloseView{
    [[com4lovesSDK sharedInstance] hideAll];

}

-(void)layoutSubviews{
    [KY_PaySDK instance].frame = BOUNDS;
}

-(void)dealloc{
    
    [KY_PaySDK instance].ky_delegate = nil;
    
    [super dealloc];
}

@end

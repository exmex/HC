//
//  AlixPayClient.m
//  AliPay
//
//  Created by WenBi on 11-5-16.
//  Copyright 2011 Alipay. All rights reserved.
//

#import <UIKit/UIApplication.h>
#import "AlixPay.h"
#import "JSON.h"
static AlixPay * safepayClient = nil;

#define ALIPAY_SAFEPAY     @"SafePay"
#define ALIPAY_DATASTRING  @"dataString"
#define ALIPAY_SCHEME      @"fromAppUrlScheme"
#define ALIPAY_TYPE        @"requestType"

#pragma mark -
#pragma mark AlixPay
@implementation AlixPay

+ (AlixPay *)shared {
	if (safepayClient == nil) {
		safepayClient = [[AlixPay alloc] init];
	}
	return safepayClient;
}



- (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme {
	
	int ret = kSPErrorOK;
	NSDictionary * oderParams = [NSDictionary dictionaryWithObjectsAndKeys:
							 orderString,ALIPAY_DATASTRING,
							 scheme, ALIPAY_SCHEME,
							 ALIPAY_SAFEPAY, ALIPAY_TYPE,
							 nil];
	
	//采用SBjson将params转化为json格式的字符串
	SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
	NSString * jsonString = [OderJsonwriter stringWithObject:oderParams];
	[OderJsonwriter release];
	
	//将数据拼接成符合alipay规范的Url
    //注意：这里改为接入独立安全支付客户端
	NSString * urlString = [NSString stringWithFormat:@"safepay://alipayclient/?%@", 
							[jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL * dataUrl = [NSURL URLWithString:urlString];
	
	//通过打开Url调用安全支付服务
	//实质上,外部商户只需保证把商品信息拼接成符合规范的字符串转为Url并打开,其余任何函数代码都可以自行优化
	if ([[UIApplication sharedApplication] canOpenURL:dataUrl]) {
		[[UIApplication sharedApplication] openURL:dataUrl];
	}
	else {
		ret = kSPErrorAlipayClientNotInstalled;
	}	
	return ret;
}

//将url数据封装成AlixPayResult使用,允许外部商户自行优化
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[[AlixPayResult alloc] initWithResultString:query] autorelease];
}

//将安全支付回调url解析数据
- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] isEqualToString:@"safepay"]) {
		result = [self resultFromURL:url];
	}
		
	return result;
}

@end

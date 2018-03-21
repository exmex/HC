//
//  AccountManagerView.m
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "SelfPayView.h"
#import "com4lovesSDK.h"
#import "SDKUtility.h"
#import "JSON.h"
#import "ServerLogic.h"


#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"




@interface SelfPayView ()
@property (retain, nonatomic) IBOutlet UILabel *labelViewTitle;
@property (retain, nonatomic) IBOutlet UILabel *lable1;
@property (retain, nonatomic) IBOutlet UILabel *lable2;
@property (retain, nonatomic) IBOutlet UILabel *lable3;
@property (retain, nonatomic) IBOutlet UILabel *lable4;
@property (retain, nonatomic) IBOutlet UILabel *lable5;
@property (retain, nonatomic) IBOutlet UILabel *lable6;
@property (retain, nonatomic) IBOutlet UILabel *lable7;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation SelfPayView

@synthesize    mTotalFee;
@synthesize    mServerID;
@synthesize    mDesc;
@synthesize    mSubject;
@synthesize    mBody;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"com4lovesBundle" ofType:@"bundle"]];
//        NSString *alertImagePath = [bundle pathForResource:@"background" ofType:@"png"];
//        UIImage* backImage =  [UIImage imageWithContentsOfFile:alertImagePath];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lable1 setText:[com4lovesSDK getLang:@"payview_laybel1"]];
    [self.lable2 setText:[com4lovesSDK getLang:@"payview_laybel2"]];
    [self.lable3 setText:[com4lovesSDK getLang:@"payview_laybel3"]];
    [self.lable4 setText:[com4lovesSDK getLang:@"payview_laybel4"]];
    [self.lable5 setText:[com4lovesSDK getLang:@"payview_laybel5"]];
    [self.lable6 setText:[com4lovesSDK getLang:@"payview_laybel6"]];
    [self.lable7 setText:[com4lovesSDK getLang:@"payview_laybel7"]];
    
    [self.labelViewTitle setText:[com4lovesSDK getLang:@"viewtitle"]];
    
    [self.backBtn setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateNormal];
    [self.backBtn setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateSelected];
    [self.backBtn setTitle:[com4lovesSDK getLang:@"back"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [[com4lovesSDK sharedInstance] hideAll];
}
-(NSString*) getContentStringWithDec:(NSString *)dec
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
	CFRelease(guid);
    
    NSString* youaiId = [com4lovesSDK  getYouaiID];
    NSString* totalFee = @"";
    NSString* appKey = [com4lovesSDK getSDKAppKey];
    NSString* orderID = uuidString;
    NSString* desc = @"";
    NSString* channel = [com4lovesSDK getChannelID];
    NSString* appid = [com4lovesSDK getSDKAppID];

    NSString* subject = @"";
    NSString* body = @"";
    
    totalFee = [NSString stringWithFormat:@"%.2f",mTotalFee ];
    //if(mExtraInfo!=nil)extraInfo = mExtraInfo;
    if([self mDesc]!=nil)
    {
        if (dec) {
            desc =[NSString stringWithString:dec];
        }else{
            desc = [NSString stringWithString:mSubject];
        }
    }
    if(mSubject!=nil)subject = [NSString stringWithString:mSubject];
    if(mBody!=nil)body = [NSString stringWithString: mBody];
    NSString* extraInfo = [NSString stringWithFormat:@"%@-%@-%@",mDesc,mServerID,youaiId];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:youaiId forKey:@"nuclearId"];
    [dic setObject:totalFee forKey:@"totalFee"];
    [dic setObject:appKey forKey:@"appKey"];
    [dic setObject:appid forKey:@"appid"];
    [dic setObject:orderID forKey:@"orderId"];
    [dic setObject:extraInfo forKey:@"extraInfo"];
    [dic setObject:desc forKey:@"desc"];
    [dic setObject:channel forKey:@"channel"];
    
    [dic setObject:subject forKey:@"subject"];
    [dic setObject:body forKey:@"body"];

    NSMutableString *resultString = [NSMutableString string];
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    for (NSString* key in sortedKeys)
    {
        if ([resultString length]>0)
            [resultString appendString:@"&"];
        [resultString appendFormat:@"%@=%@", key, [dic objectForKey:key]];
    }
    return resultString;
}

-(NSString*) getMD5SignedContentWithDec:(NSString *)dec
{
    NSMutableString* content = [NSMutableString stringWithString:[self getContentStringWithDec:dec]];
    NSMutableString* contentMD5 = [NSMutableString stringWithString:content];
    [contentMD5 appendString:[com4lovesSDK getSignSecret]];
    YALog(@"string before md5:%@",contentMD5);
    NSString* md5 = [[SDKUtility sharedInstance] md5HexDigest:contentMD5];
    [content appendFormat:@"&signature=%@",md5];
    NSString* ret = [[SDKUtility sharedInstance] encodeURL:content];
    return ret;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d?mt=8", 535715926];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	}
}
- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                 kCFAllocatorDefault,
                                                                                                 (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease]);
    if (newString) {
        return newString;
    }
    return @"";
}
- (IBAction)zhifubao:(id)sender {
  
    NSString* content = [self getMD5SignedContentWithDec:nil];
    
    NSData *postdata=[content dataUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:@"%@alipay/trade",[[ServerLogic sharedInstance] getServerUrl]];
    NSString *ret = [[SDKUtility sharedInstance] httpPost:url postData:postdata];
    YALog(@"serverReturn:%@",ret);
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:ret];
    if (!repr)
    {
        YALog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
    }
    [jsonParser release];
    
    NSDictionary *dic = repr;
    
    NSDecimalNumber* isSuccess = [dic objectForKey:@"isSuccess"];
    if([isSuccess isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSString* content = [dic objectForKey:@"content"];
        NSString* sign0 = [dic objectForKey:@"sign"];
        NSString* sign = [self encodeURL:sign0];
        NSString* orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       content, sign, @"RSA"];
        AlixPay * alixpay = [AlixPay shared];
               int retValue = [alixpay pay:orderString applicationScheme:[com4lovesSDK getAlipayScheme]];
        
        if (retValue == kSPErrorAlipayClientNotInstalled) {
      
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                               message:[com4lovesSDK getLang:@"notice_alipay_notinstall"]
                                                              delegate:nil
                                                     cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                     otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (retValue == kSPErrorSignError) {
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                               message:[com4lovesSDK getLang:@"notice_sign_error"]
                                                              delegate:nil
                                                     cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                     otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
    }
    [[com4lovesSDK sharedInstance] hideAll];
    [self.view removeFromSuperview];
    //YALog(@"ret:%@",dic);

}


- (void)parseURL:(NSURL *)url
{
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			[[NSNotificationCenter defaultCenter] postNotificationName:com4loves_buyDone object:nil];
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[com4lovesSDK getLang:@"notice"]
                                                               message:result.statusMessage
                                                              delegate:nil
                                                     cancelButtonTitle:[com4lovesSDK getLang:@"ok"]
                                                     otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}
}

- (IBAction)caifutong:(id)sender {
    NSString* content = [self getMD5SignedContentWithDec:nil];
    
    NSString* url = [NSString stringWithFormat:@"%@tenpay/trade?%@",[[ServerLogic sharedInstance] getServerUrl],content];
    [[com4lovesSDK sharedInstance] hideAll];
    
    [[com4lovesSDK sharedInstance] showWeb:url];
//    [self.view removeFromSuperview];
}

- (IBAction)chongzhika:(id)sender {
    
    NSString* content = [self getMD5SignedContentWithDec:@"chongzhika"];
    NSString* url = [NSString stringWithFormat:@"%@yeepay/trade?%@",[[ServerLogic sharedInstance] getServerUrl],content];
    
    YALog(@"openURL:%@",url);
    [[com4lovesSDK sharedInstance] showWeb:url];
    [self.view removeFromSuperview];
}

- (IBAction)alipayWeb:(id)sender {
    NSString* content = [self getMD5SignedContentWithDec:nil];
    NSString* url = [NSString stringWithFormat:@"%@alipayweb/trade?%@",[[ServerLogic sharedInstance] getServerUrl],content];
    
    YALog(@"openURL:%@",url);
    [[com4lovesSDK sharedInstance] showWeb:url];
    [self.view removeFromSuperview];
}
- (void)dealloc {
    [_lable1 release];
    [_lable2 release];
    [_lable3 release];
    [_lable4 release];
    [_lable5 release];
    [_lable6 release];
    [_lable7 release];
    [_backBtn release];
    [_labelViewTitle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLable1:nil];
    [self setLable2:nil];
    [self setLable3:nil];
    [self setLable4:nil];
    [self setLable5:nil];
    [self setLable6:nil];
    [self setLable7:nil];
    [self setBackBtn:nil];
    [self setLabelViewTitle:nil];
    [super viewDidUnload];
}
@end

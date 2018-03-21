//
//  WebView.m
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "WebView.h"
#import "SDKUtility.h"
#import "com4lovesSDK.h"

@implementation WebView

-(void) showWeb:(NSString*)url
{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [self.btnClose setTitle:[com4lovesSDK getLang:@"close"] forState:UIControlStateNormal];
    [self.btnClose setTitle:[com4lovesSDK getLang:@"close"] forState:UIControlStateSelected];
    [self.btnClose setTitle:[com4lovesSDK getLang:@"close"] forState:UIControlStateHighlighted];
    [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *reqObject =  [NSURLRequest requestWithURL:nsurl];
    [self.mWebView setUserInteractionEnabled: YES ]; //是否支持交互
    [self.mWebView loadRequest:reqObject];
    [self.mWebView setDelegate:self];
}

-(void) hideWeb
{
    [[com4lovesSDK sharedInstance] hideAll];
    [self.view removeFromSuperview];
}

- (IBAction)onEnd:(id)sender
{
    [self hideWeb];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[SDKUtility sharedInstance] setWaiting:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[SDKUtility sharedInstance] setWaiting:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //;
    YALog(@"%@",request);
    NSString* rurl=[[request URL] absoluteString];
    if ([rurl hasPrefix:@"objc://cmd/close"]) {
        [self hideWeb];
    }
    return true;
}

- (void)dealloc {
    [_btnClose release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnClose:nil];
    [super viewDidUnload];
}
@end

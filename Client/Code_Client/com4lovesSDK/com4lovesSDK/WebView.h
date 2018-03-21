//
//  WebView.h
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebView : UIViewController<UIWebViewDelegate>
{
    UIViewController * mOriRootViewController;
}

-(void) showWeb:(NSString*)url;
-(void) hideWeb;
@property (retain, nonatomic) IBOutlet UIButton *btnClose;

- (IBAction)onEnd:(id)sender;


@property(nonatomic, retain) IBOutlet UIWebView * mWebView;
@end

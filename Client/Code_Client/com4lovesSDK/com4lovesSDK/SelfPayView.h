//
//  AccountManagerView.h
//  com4lovesSDK
//
//  Created by fish on 13-8-28.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfPayView : UIViewController

@property    float mTotalFee;
@property(nonatomic,retain)    NSString* mServerID;
@property(nonatomic,retain)    NSString* mDesc;
@property(nonatomic,retain)    NSString* mSubject;
@property(nonatomic,retain)    NSString* mBody;

- (IBAction)close:(id)sender;
- (IBAction)zhifubao:(id)sender;
- (IBAction)caifutong:(id)sender;
- (IBAction)chongzhika:(id)sender;
- (IBAction)alipayWeb:(id)sender;

- (void)parseURL:(NSURL *)url;

@property(nonatomic, retain) IBOutlet UILabel *payRMB;
@end

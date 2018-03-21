//
//  UseSDKView.h
//  PayDemo
//
//  Created by 悠然天地 on 13-9-22.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KY_PaySDK.h"

@interface UseSDKView : UIView<KY_PaySDKDelegate>
@property    float mTotalFee;
@property(nonatomic,retain)    NSString* mServerID;
@property(nonatomic,retain)    NSString* mDesc;
@property(nonatomic,retain)    NSString* mSubject;
@property(nonatomic,retain)    NSString* mOrderId;

@property (nonatomic, assign) BOOL isOrientation;

-(void)setControllerAndUrlScheme:(UIViewController*)vc urlScheme:(NSString*)urlScheme;
- (void) showPay;

@end

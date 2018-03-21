//
//  UseSDKView.h
//  PayDemo
//
//  Created by 悠然天地 on 13-9-22.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYSDK/KY_PaySDK.h"

@interface UseSDKView : UIView<KY_PaySDKDelegate>

- (void) setTotalFee:(float) fee;
- (void) setServerId:(NSString*) serverId;
- (void) setDesc:(NSString *) desc;
- (void) setSubject:(NSString *)subject;
- (void) setOrderId:(NSString *)orderId;
- (void) setUserID:(NSString *)userId;


-(void)setControllerAndUrlScheme:(UIViewController*)vc urlScheme:(NSString*)urlScheme;
- (void) showPay;

@end

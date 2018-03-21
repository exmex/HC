
//
//  OtherViewController.h
//  PayDemo
//
//  Created by 呼啦呼啦圈 on 13-9-13.
//  Copyright (c) 2013年 吕冬剑. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KYViewController.h"

@interface OtherViewController : UIViewController{
    KYViewController *view;
}
- (void) setTotalFee:(float) fee;
- (void) setServerId:(NSString*) serverId;
- (void) setDesc:(NSString *) desc;
- (void) setSubject:(NSString *)subject;
- (void) setOrderId:(NSString *)orderId;
- (void) setUserID:(NSString *)userId;
- (void) showPay;

@end

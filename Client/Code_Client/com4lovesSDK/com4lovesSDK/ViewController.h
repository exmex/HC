//
//  Created by 悠然天地 on 13-6-3.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseSDKView.h"

@interface ViewController : UIViewController{

    UseSDKView * view;
}

- (void) setTotalFee:(float) fee;
- (void) setServerId:(NSString*) serverId;
- (void) setDesc:(NSString *) desc;
- (void) setSubject:(NSString *)subject;
- (void) setOrderId:(NSString *)orderId;
- (void) showPay;

@end

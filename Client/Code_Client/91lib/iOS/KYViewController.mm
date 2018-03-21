//
//  Created by 悠然天地 on 13-6-3.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import "KYViewController.h"

@interface KYViewController (){
    
}

@end

@implementation KYViewController


-(id)init{
    self = [super init];
    if(self){
        
        sdkview = [[UseSDKView alloc]init];
        [sdkview setControllerAndUrlScheme:self urlScheme:@"ky-com.loves.kuaiyongsds"];
        self.view = sdkview;
    }
    return self;
}
- (void) setUserID:(NSString *)userId
{
    [sdkview setUserID:userId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) setTotalFee:(float) fee
{
    [sdkview setTotalFee:fee];
}
- (void) setServerId:(NSString*) serverId
{
    [sdkview setServerId:serverId];
}
- (void) setDesc:(NSString *) desc
{
    [sdkview setDesc:desc];
}
- (void) setSubject:(NSString *)subject
{
    [sdkview setSubject:subject];
}
- (void) setOrderId:(NSString *)orderId
{
    [sdkview setOrderId:orderId];
}
- (void)showPay
{
    [sdkview showPay];
}

//-(void)dealloc{
//
//    [sdkview release];
//
//    [super dealloc];
//}



@end

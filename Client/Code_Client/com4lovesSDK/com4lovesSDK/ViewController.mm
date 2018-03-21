//
//  Created by 悠然天地 on 13-6-3.
//  Copyright (c) 2013年 悠然天地. All rights reserved.
//

#import "ViewController.h"




@interface ViewController (){
    
}

@end

@implementation ViewController


-(id)init{
    self = [super init];
    if(self){
        
        view = [[UseSDKView alloc]init];
        [view setControllerAndUrlScheme:self urlScheme:@"dragonball.com4loves.com"];
        self.view = view;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) setTotalFee:(float) fee
{
    [view setMTotalFee:fee];
}
- (void) setServerId:(NSString*) serverId
{
    [view setMServerID:serverId];
}
- (void) setDesc:(NSString *) desc
{
    [view setMDesc:desc];
}
- (void) setSubject:(NSString *)subject
{
    [view setMSubject:subject];
}
- (void) setOrderId:(NSString *)orderId
{
    [view setMOrderId:orderId];
}
- (void)showPay
{
    [view showPay];
}

-(void)dealloc{

    [view release];

    [super dealloc];
}



@end

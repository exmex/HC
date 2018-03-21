//
//  c4lSelfPay.m
//  com4lovesSDK
//
//  Created by fish on 13-9-23.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "c4lSelfPay.h"

@implementation c4lSelfPay

+ (c4lSelfPay *)sharedInstance
{
    static c4lSelfPay *_instance = nil;
    if (_instance == nil) {
        _instance = [[c4lSelfPay alloc] init];
    }
    return _instance;
}

-(void) buyProduct:(NSString*)productID serverID:(NSString*)description
{

}
@end

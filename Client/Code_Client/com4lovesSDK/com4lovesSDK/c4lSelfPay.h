//
//  c4lSelfPay.h
//  com4lovesSDK
//
//  Created by fish on 13-9-23.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface c4lSelfPay : NSObject
{
}

+ (c4lSelfPay *)sharedInstance;

-(void) buyProduct:(NSString*)productID serverID:(NSString*)description;
@end

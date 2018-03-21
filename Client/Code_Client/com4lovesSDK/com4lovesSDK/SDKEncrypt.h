//
//  com4lovesEncrypt.h
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKEncrypt : NSObject

+(SDKEncrypt*) sharedInstance;

-(NSString*) rsaEncrypt:(NSString*) plain;
-(NSString*) rsaDecrypt:(NSString*) secret;

-(NSString*) base64Encrypt:(NSString*) plain;
-(NSString*) base64Decrypt:(NSString*) secret;

@end


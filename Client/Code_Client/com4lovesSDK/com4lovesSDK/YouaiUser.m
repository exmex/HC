//
//  YouaiUser.m
//  com4lovesSDK
//
//  Created by ljc on 13-10-4.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "YouaiUser.h"
#import "SDKEncrypt.h"

@implementation YouaiUser

- (void) initWithJsonString:(NSString *) json
{
    
}
- (NSDictionary*) proxyForJson {
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.name,@"name",
                          self.youaiId,@"nuclearId",
                          [NSNumber numberWithInteger:self.userType] ,@"userType",
                          nil==self.password?@"":[[SDKEncrypt sharedInstance] base64Encrypt:[NSString stringWithString:self.password]],@"password",
                          nil];
    return dict;
}
@end

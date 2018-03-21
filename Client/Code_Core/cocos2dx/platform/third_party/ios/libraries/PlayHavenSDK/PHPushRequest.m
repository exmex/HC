/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2013 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PHPushRequest.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/11/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushRequest.h"
#import "PHConstants.h"
#import "PHStringUtil.h"

static NSString *const kPHPushTokenKey = @"push_token";

@interface PHPushRequest ()
@property (nonatomic, retain) NSData *pushNotificationDeviceToken;
@end

@implementation PHPushRequest

+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken
{
    return [[[[self class] alloc] initWithApp:aToken secret:aSecret
                pushNotificationDeviceToken:aDeviceToken] autorelease];
}

- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken
{
    if ((self = [super initWithApp:aToken secret:aSecret]))
    {
        _pushNotificationDeviceToken = [aDeviceToken retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_pushNotificationDeviceToken release];
    
    [super dealloc];
}

#pragma mark - PHAPIRequest

- (NSString *)urlPath
{
    return PH_URL(/v3/publisher/push/);
}

- (NSDictionary *)additionalParameters
{
    // nil device token means unregistration for push notifications
    NSString *thPushTokenHexRep = nil == self.pushNotificationDeviceToken ? @"" :
                [PHStringUtil hexEncodedStringForData:self.pushNotificationDeviceToken];

    return @{kPHPushTokenKey : thPushTokenHexRep};
}

@end

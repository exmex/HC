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

 PHPushDeliveryRequest.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/25/13
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushDeliveryRequest.h"
#import "PHConstants.h"

static NSString *const kPHRequestParameterMessageID = @"message_id";
static NSString *const kPHRequestParameterContentID = @"content_id";

@interface PHPushDeliveryRequest ()
@property (nonatomic, retain) NSString *messageID;
@property (nonatomic, retain) NSString *contentID;
@end

@implementation PHPushDeliveryRequest

+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID
{
    return [[[[self class] alloc] initWithApp:aToken secret:aSecret
                pushNotificationDeviceToken:aDeviceToken messageID:aMessageID contentUnitID:
                aContentID] autorelease];
}

- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID
{
    if (nil == aDeviceToken || nil == aMessageID)
    {
        PH_LOG(@"ERROR: Cannot initialize request with nil argument. (aDeviceToken - %@;"
                    " aMessageID - %@)",aDeviceToken, aMessageID, nil);
        [self release];
        return nil;
    }
    
    self = [super initWithApp:aToken secret:aSecret pushNotificationDeviceToken:aDeviceToken];
    if (nil != self)
    {
        _messageID = [aMessageID retain];
        _contentID = [aContentID retain];
    }

    return self;
}

- (void)dealloc
{
    [_messageID release];
    [_contentID release];

    [super dealloc];
}

#pragma mark - PHAPIRequest

- (NSDictionary *)additionalParameters
{
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionaryWithDictionary:[super
                additionalParameters]];

    [theParameters setObject:self.messageID forKey:kPHRequestParameterMessageID];

    if (nil != self.contentID)
    {
        [theParameters setObject:self.contentID forKey:kPHRequestParameterContentID];
    }

    return theParameters;
}

@end

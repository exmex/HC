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

 PHPushDeliveryRequest.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/25/13
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushRequest.h"

/**
 * Request used to track delivery of the push notifications.
 **/
@interface PHPushDeliveryRequest : PHPushRequest

/**
 * Convenience method creating an autoreleased request object.
 **/
+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID;

/**
 * Constructs a request which is used to track delivery of the push notifications.
 * @param aToken
 *  Application token
 * @param aSecret
 *  Application secret
 * @param aDeviceToken
 *  Token provided by Apple Push Service to identify destination device of a push notification.
 *  This parameter must be a valid device token.
 * @param aMessageID
 *  Identifier of a push notification sent by PlayHaven server. This id is internal to PlayHaven
 *  server and it is sent with each notification as a part of its payload.
 * @return
 *  Identifier of a content associated with a push notification. When push notification is
 *  associated with some content, identifier of that content is sent in the notification payload.
 **/
- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken messageID:(NSString *)aMessageID
            contentUnitID:(NSString *)aContentID;

@end

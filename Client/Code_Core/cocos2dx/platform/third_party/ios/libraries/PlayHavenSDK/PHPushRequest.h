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

 PHPushRequest.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/11/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHAPIRequest.h"

@interface PHPushRequest : PHAPIRequest

/**
 * @brief Request designed to pass device token registered with Apple Push Notifications Service to
 *  a server representing push notifications provider.
 **/
+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken;
/**
 * Constructs a request which is used to register/unregister for push notifications on
 * PlayHaven server which provides notifications to Apple Push Service.
 * @param aToken
 *   Application token
 * @param aSecret
 *   Application secret
 * @param aDeviceToken
 *   Token provided by Apple Push Service identifying destination device of a push
 *   notification. Request has different effect depending on this parameter. If aDeviceToken is not
 *   nil then request registers for push notification, otherwise if it is nil then request performs 
 *   unregistration.
 * @return
 *   An initialized request
 **/
- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret
            pushNotificationDeviceToken:(NSData *)aDeviceToken;
/**
 * Device token passed to the request during initialization.
 **/
@property (nonatomic, retain, readonly) NSData *pushNotificationDeviceToken;

@end

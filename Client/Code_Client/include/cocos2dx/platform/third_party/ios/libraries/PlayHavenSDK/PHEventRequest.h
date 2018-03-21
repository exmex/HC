/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2014 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PHEventRequest.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 2/25/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHAPIRequest.h"

@class PHEvent;

/**
 * @brief PHEventRequest represents object that is used to send events to PlayHaven's server.
 **/
@interface PHEventRequest : PHAPIRequest

/**
 * Convenience class method for creating autoreleased event request object.
 **/
+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret event:(PHEvent *)anEvent;

/**
 * Constructs an event request with the given application token, secret and event object. All the
 * parameters of the method are mandatory and must not be nil, otherwise object initialization will
 * fail and the initializer will return nil.
 **/
- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret event:(PHEvent *)anEvent;
@end

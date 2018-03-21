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

 PHEvent.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 2/25/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

/**
 * @brief PHEvent class provides ability to create an object representing an event that happens
 * within your application. An event could be anything that is of some interest in your application,
 * e.g. when a user clicks a specific button, adds a friend, etc. You create event objects and send
 * them to PlayHaven's server by means of PHEventRequest class to track those events on your
 * dashboard.
 **/
@interface PHEvent : NSObject

/**
 * Convenience class method for creating autoreleased event object.
 **/
+ (instancetype)eventWithProperties:(NSDictionary *)aProperties;

/**
 * Constructs an event object that encapsulates data representing an event in your application.
 * @param aProperties
 *  A dictionary with event properties. You are free to define what properties should be included
 *  in the event object. The only restriction is imposed on the data type of the objects that can be
 *  passed within this dictionary, in particular the keys of this dictionary as well as the keys of
 *  all nested sub-dictionaries (if any) must be strings, the values can be of any type from the
 *  following list:
 *
 *  @li NSString
 *  @li NSDictionary
 *  @li NSNumber
 *
 *  If you pass values with other data types within the properties dictionary, the event object will
 *  be successfully created but PlayHaven's server may return an error on attempt to send such an
 *  event. Here is an example of a parameters dictionary that can be passed on event creation:
 *  @{@"inventory" : @{@"swords" : @{@"katanas" : @(3)}}}
 *
 *  Note, at the moment PlayHaven's server has a limitation on the size of the events that can be
 *  passed from the SDK to the server. As of PH SDK 1.22.0 this limit is 100 KB (to be accurate
 *  102000 bytes). In most cases you should not worry about the size of the event object but if you
 *  plan to pass a lot of data within aProperties dictionary and you are unsure about the size of
 *  the event object, you can check it by writing the following code:
 *
 *  NSUInteger theSize = [[[[theEvent JSONRepresentation] stringByEncodingURLFormat]
 *  dataUsingEncoding:NSUTF8StringEncoding] length];
 *
 * @return
 *   An event object.
 **/
- (instancetype)initWithProperties:(NSDictionary *)aProperties;

/**
 * Event properties which are the same that were passed on event creation.
 **/
@property (nonatomic, retain, readonly) NSString *properties;

/**
 * Returns JSON representation of the event object.
 **/
@property (nonatomic, retain, readonly) NSString *JSONRepresentation;
@end

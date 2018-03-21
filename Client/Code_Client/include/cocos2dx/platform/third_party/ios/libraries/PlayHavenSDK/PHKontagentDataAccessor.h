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

 PHKontagentDataAccessor.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 1/31/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

@interface PHKontagentDataAccessor : NSObject
/**
 * Returns singleton instance.
 **/
+ (instancetype)sharedAccessor;

/**
 * Returns the list of all Kontagent API Key - Sender ID pairs stored at predefined locations.
 **/
- (NSDictionary *)allAPIKeySenderIDPairs;

/**
 * Retrieves Sender ID selected on the PH server as a primary one that should be sent on each
 * request.
 **/
- (NSString *)primarySenderID;

/**
 * Stores sender ID for given API key. The stored sender ID will be returned by
 * - [PHKontagentDataAccessor primarySenderID] method. Neither of the input arguments should be nil.
 * If sender ID for the given API key is already present in KT location this method doesn't override
 * the old value.
 **/
- (void)storePrimarySenderID:(NSString *)aSenderID forAPIKey:(NSString *)anAPIKey;
@end

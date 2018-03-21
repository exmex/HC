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

 PHPublisherContentRequest+Private.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 9/6/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface PHPublisherContentRequest ()
/**
 * Checks if a given dictionary is a valid reward dictionary containing all the expected key-values
 * and valid signature.
 **/
- (BOOL)isValidReward:(NSDictionary *)rewardData;

/**
 * Checks if a given dictionary is a valid purchase dictionary containing all the expected
 * key-values and valid signature.
 **/
- (BOOL)isValidPurchase:(NSDictionary *)purchaseData;
@end

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

 PHError.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/26/13
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

/**
 * The error domain of errors returned by the PlayHaven SDK
 **/
extern NSString *const kPHSDKErrorDomain;

/**
 * Error codes returned by the PlayHaven SDK in NSError.
 **/
typedef enum PHErrorCode
{
    PHErrorIncompleteWorkflow = 0

} PHErrorCode;

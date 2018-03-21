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

 PHAdRequest.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/17/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHAdRequest.h"
#import "PHConstants.h"
#import "PHAPIRequest+Private.h"

@implementation PHAdRequest
+ (NSDictionary *)identifiers
{
    NSMutableDictionary *theIdentifiers = [NSMutableDictionary dictionaryWithDictionary:
                [super identifiers]];
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#if PH_USE_AD_SUPPORT == 1
    if (![PHAPIRequest optOutStatus] && [ASIdentifierManager class])
    {
        NSUUID *uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        NSString *uuidString = [uuid UUIDString];

        if (0 < [uuidString length])
        {
            theIdentifiers[@"ifa"] = uuidString;
        }
    }
#endif
#endif
#endif
    
    return theIdentifiers;
}
@end

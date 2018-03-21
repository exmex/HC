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

 PHEventRequest.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 2/25/14.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHEventRequest.h"
#import "PHConstants.h"
#import "PHAPIRequest+Private.h"
#import "PHEvent.h"
#import "NSObject+QueryComponents.h"

static NSString *const kPHRequestParameterDataKey = @"data";
static NSString *const kPHRequestParameterDataSignatureKey = @"data_sig";
static NSString *const kPHRequestParameterEventTypeKey = @"type";
static NSString *const kPHRequestParameterEventVersionKey = @"version";

static NSString *const kPHRequestParameterEventTypeValue = @"event";
static NSString *const kPHRequestParameterEventVersionValue = @"1";

@interface PHEventRequest ()
@property (nonatomic, retain, readonly) NSArray *events;
@end

@implementation PHEventRequest

+ (id)requestForApp:(NSString *)aToken secret:(NSString *)aSecret event:(PHEvent *)anEvent
{
    return [[[self alloc] initWithApp:aToken secret:aSecret event:anEvent] autorelease];
}

- (id)initWithApp:(NSString *)aToken secret:(NSString *)aSecret event:(PHEvent *)anEvent;
{
    if (nil == anEvent)
    {
        PH_LOG(@"[%s]ERROR: Cannot initialize request with nil event.", __PRETTY_FUNCTION__);
        [self release];
        return nil;
    }
    
    self = [super initWithApp:aToken secret:aSecret];
    if (nil != self)
    {
        _events = [[NSArray alloc] initWithObjects:anEvent, nil];
    }
    
    return self;
}

- (void)dealloc
{
    [_events release];
    
    [super dealloc];
}

#pragma mark - Overridden PHAPIRequest methods

- (NSString *)urlPath
{
    return PH_URL(/v4/publisher/event/);
}

- (PHRequestHTTPMethod)HTTPMethod
{
    return PHRequestHTTPPost;
}

- (NSDictionary *)additionalParameters
{
    NSMutableArray *theEventsJSON = [NSMutableArray arrayWithCapacity:[self.events count]];

    for (PHEvent *theEvent in self.events)
    {
        NSString *theJSONRepresentation = [theEvent JSONRepresentation];
        if (nil != theJSONRepresentation)
        {
            [theEventsJSON addObject:theJSONRepresentation];
        }
    }

    NSString *theResultingJSON = [NSString stringWithFormat:@"[%@]", [theEventsJSON
                componentsJoinedByString:@","]];
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionaryWithDictionary:
                @{kPHRequestParameterDataKey : theResultingJSON}];
    
    NSString *theEventsSignature = [[self class] v4SignatureWithMessage:theResultingJSON
                signatureKey:self.secret];
    if (nil != theEventsSignature)
    {
        theParameters[kPHRequestParameterDataSignatureKey] = theEventsSignature;
    }
    else
    {
        PH_LOG(@"[%s]ERROR: Cannot generate events signature!", __PRETTY_FUNCTION__);
    }
    
    theParameters[kPHRequestParameterEventTypeKey] = kPHRequestParameterEventTypeValue;
    theParameters[kPHRequestParameterEventVersionKey] = kPHRequestParameterEventVersionValue;
    
    return theParameters;
}

@end

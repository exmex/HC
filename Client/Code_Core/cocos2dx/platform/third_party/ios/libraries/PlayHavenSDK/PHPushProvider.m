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

 PHPushProvider.m
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHPushProvider.h"
#import "PHPushRequest.h"
#import "PHPublisherContentRequest.h"
#import "PHPushDeliveryRequest.h"
#import "PHConstants.h"
#import "PHError.h"

static NSString *const kPHMessageIDKey = @"mi";
static NSString *const kPHContentIDKey = @"ci";
static NSString *const kPHURIKey = @"uri";

@interface PHPushProvider ()
@property (nonatomic, retain) NSData *APNSDeviceToken;
@property (nonatomic, readonly) CFMutableArrayRef registrationObservers;
@end

@implementation PHPushProvider

+ (PHPushProvider *)sharedInstance
{
    static PHPushProvider *sPHPushProviderInsatnce = nil;
    @synchronized (self)
    {
        if (nil == sPHPushProviderInsatnce)
        {
            sPHPushProviderInsatnce = [PHPushProvider new];
        }
    }
    
    return sPHPushProviderInsatnce;
}

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        _registrationObservers = CFArrayCreateMutable(kCFAllocatorDefault, 10, NULL);
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_registrationObservers);
    [_APNSDeviceToken release];
    [_applicationToken release];
    [_applicationSecret release];
    
    [super dealloc];
}

- (void)registerForPushNotifications
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert];
}

- (void)unregisterForPushNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [self registerAPNSDeviceToken:nil];
}

- (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)aUserInfo
{
    NSNumber *theMessageID = [aUserInfo objectForKey:kPHMessageIDKey];
    if (nil == theMessageID || ![theMessageID isKindOfClass:[NSNumber class]])
    {
        // No further actions if required field is absent or has unexpected type.
        return;
    }
    
    // Note content ID is expected to be integer, but also can be a string.
    NSString *theContentID = [[aUserInfo objectForKey:kPHContentIDKey] description];
    NSString *theMessageIDString = [theMessageID stringValue];
    
    if (nil != theContentID)
    {
        PHPublisherContentRequest *theContentRquest = [PHPublisherContentRequest requestForApp:
                    self.applicationToken secret:self.applicationSecret contentUnitID:theContentID
                    messageID:theMessageIDString];
        
        if (![self.delegate respondsToSelector:@selector(pushProvider:shouldSendRequest:)] ||
                    ([self.delegate respondsToSelector:@selector(pushProvider:shouldSendRequest:)]
                    && [self.delegate pushProvider:self shouldSendRequest:theContentRquest]))
        {
            [theContentRquest send];
        }
    }
    else
    {
        // NB: Push Notification cannot target a specific content unit and URL at the same time.
        // That is why URL processing part is put in the else branch.
        
        NSString *theNotificationURLString = [aUserInfo objectForKey:kPHURIKey];
        
        if ([theNotificationURLString isKindOfClass:[NSString class]])
        {
            theNotificationURLString = [theNotificationURLString
                        stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *theNotificationURL = [NSURL URLWithString:theNotificationURLString];
            
            if (nil != theNotificationURL)
            {
                [self handleRemoteNotificationURL:theNotificationURL];
            }
            else
            {
                PH_DEBUG(@"Cannot create URL with string: %@", [aUserInfo objectForKey:kPHURIKey]);
            }
        }
    }
    
    PHPushDeliveryRequest *thePushDeliveryRequest = [PHPushDeliveryRequest requestForApp:
                 self.applicationToken secret:self.applicationSecret pushNotificationDeviceToken:
                 self.APNSDeviceToken messageID:theMessageIDString contentUnitID:theContentID];
    [thePushDeliveryRequest send];
}

- (void)registerAPNSDeviceToken:(NSData *)aToken
{
    self.APNSDeviceToken = aToken;
    
    PHPushRequest *theRequest = [PHPushRequest requestForApp:self.applicationToken secret:
                self.applicationSecret pushNotificationDeviceToken:aToken];
    if (nil != aToken && nil == theRequest)
    {
        NSError *theError = [NSError errorWithDomain:kPHSDKErrorDomain code:
                    PHErrorIncompleteWorkflow userInfo:@{NSLocalizedDescriptionKey :
                    @"Cannot create push notification registration request to register device "
                    "token."}];
        [self didFailToRegisterAPNSDeviceTokenWithError:theError];
    }
    
    theRequest.delegate = self;
    [theRequest send];
}

- (void)addObserver:(id<PHPushRegistrationObserver>)anObserver
{
    if (!CFArrayContainsValue(self.registrationObservers, CFRangeMake(0,
                CFArrayGetCount(self.registrationObservers)), anObserver))
    {
        CFArrayAppendValue(self.registrationObservers, anObserver);
    }
}

- (void)removeObserver:(id<PHPushRegistrationObserver>)anObserver
{
    if (CFArrayContainsValue(self.registrationObservers, CFRangeMake(0,
                CFArrayGetCount(self.registrationObservers)), anObserver))
    {
        CFArrayRemoveValueAtIndex(self.registrationObservers, CFArrayGetFirstIndexOfValue(
                    self.registrationObservers, CFRangeMake(0, CFArrayGetCount(
                    self.registrationObservers)), anObserver));
    }
}

#pragma mark - PHAPIRequestDelegate

- (void)request:(PHAPIRequest *)aRequest
            didSucceedWithResponse:(NSDictionary *)aResponseData
{
    if (![aRequest isKindOfClass:[PHPushRequest class]])
    {
        return;
    }
    
    PHPushRequest *theRegistrationRequest = (PHPushRequest *)aRequest;
    if (nil == theRegistrationRequest.pushNotificationDeviceToken)
    {
        // No need to report the results of unregisteration request.
        return;
    }
    
    for (unsigned theIndex = 0; theIndex < CFArrayGetCount(self.registrationObservers);
                ++theIndex)
    {
        id<PHPushRegistrationObserver> theObserver = CFArrayGetValueAtIndex(
                    self.registrationObservers, theIndex);
        
        if ([theObserver respondsToSelector:@selector(
                    providerDidRegisterAPNSDeviceToken:)])
        {
            [theObserver providerDidRegisterAPNSDeviceToken:self];
        }
    }
}

- (void)request:(PHAPIRequest *)aRequest didFailWithError:(NSError *)anError
{
    if (![aRequest isKindOfClass:[PHPushRequest class]])
    {
        return;
    }
    
    PHPushRequest *theRegistrationRequest = (PHPushRequest *)aRequest;
    if (nil == theRegistrationRequest.pushNotificationDeviceToken)
    {
        // No need to report the results of unregisteration request.
        return;
    }

    [self didFailToRegisterAPNSDeviceTokenWithError:anError];
}


#pragma mark - Private

- (void)didFailToRegisterAPNSDeviceTokenWithError:(NSError *)anError
{
    for (unsigned theIndex = 0; theIndex < CFArrayGetCount(self.registrationObservers);
                ++theIndex)
    {
        id<PHPushRegistrationObserver> theObserver = CFArrayGetValueAtIndex(
                    self.registrationObservers, theIndex);

        if ([theObserver respondsToSelector:@selector(
                    provider:didFailToRegisterAPNSDeviceTokenWithError:)])
        {
            [theObserver provider:self didFailToRegisterAPNSDeviceTokenWithError:anError];
        }
    }
}

- (void)handleRemoteNotificationURL:(NSURL *)anURL
{
    if (![self.delegate respondsToSelector:@selector(pushProvider:shouldOpenURL:)] ||
                ([self.delegate respondsToSelector:@selector(pushProvider:shouldOpenURL:)] &&
                [self.delegate pushProvider:self shouldOpenURL:anURL]))
    {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [[UIApplication sharedApplication] openURL:anURL];
        });
    }
}

@end

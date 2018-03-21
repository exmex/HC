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

 PHPushProvider.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/15/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "PHAPIRequest.h"

@protocol PHPushRegistrationObserver;
@protocol PHPushProviderDelegate;

@class PHPublisherContentRequest;

/**
 * @brief Central object used to add push notifications support in your application. It provides
 *  convenience methods to register/unregister for push notification and is responsible for handling
 *  incoming push notifications.
 **/
@interface PHPushProvider : NSObject <PHAPIRequestDelegate>
+ (PHPushProvider *)sharedInstance;

/**
 * Token used to identify application when it communicates with PlayHaven server. Publishers get
 * a token for each game registered in Publisher Dashboard. This is mandatory property which must be
 * assigned before other calls to the provider instance.
 **/
@property (nonatomic, retain) NSString *applicationToken;

/**
 * Secret used to identify application when it communicates with PlayHaven server. Publishers get
 * a secret for each game registered in Publisher Dashboard. This is mandatory property which must
 * assigned before other calls to the provider instance.
 **/
@property (nonatomic, retain) NSString *applicationSecret;

@property (nonatomic, assign) id<PHPushProviderDelegate> delegate;

/**
 * Registers device token with PlayHaven's push server. This call completes the
 * push notification registration procedure and after that the application will be able to
 * receive remote notification. This is the last point in registering for push notifications which
 * can be sent from PlayHaven dashboard. Observers are informed of the results of the registration.
 **/
- (void)registerAPNSDeviceToken:(NSData *)aToken;

/**
 * Registers for push notifications by passing APNS which kind of notifications the
 * application accepts.
 **/
- (void)registerForPushNotifications;

/**
 * Unregisters for push notifications received from Apple Push Service and also tells
 * PlayHaven's server to stop sending push notifications for this application instance.
 **/
- (void)unregisterForPushNotifications;

/**
 * Handles incoming push notifications which system provides in form of dictionary containing
 * information about notification, for more details on the dictionary content see
 * application:didReceiveRemoteNotification: of UIApplicationDelegate.
 **/
- (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)aUserInfo;

/**
 * Adds new observer which will be notified about the results of registration/
 * unregistration events.
 *
 * @param anObserver
 *  Observers are not retained and caller is responsible for removing observer at before
 *  it is released.
 **/
- (void)addObserver:(id<PHPushRegistrationObserver>)anObserver;
- (void)removeObserver:(id<PHPushRegistrationObserver>)anObserver;
@end

@protocol PHPushRegistrationObserver <NSObject>
@optional

- (void)providerDidRegisterAPNSDeviceToken:(PHPushProvider *)aProvider;
- (void)provider:(PHPushProvider *)aProvider
            didFailToRegisterAPNSDeviceTokenWithError:(NSError *)anError;
@end

@protocol PHPushProviderDelegate <NSObject>
@optional
/**
 * Provider calls this method when it handles push notification initiated by
 * handleRemoteNotificationWithUserInfo: to check if it should load content associated with the push
 * notification. Delegates should implement this method and return NO to prevent content loading
 * and displaying. Another reason why delegate might want to implement this method is to take
 * control over content loading and displaying by assigning own delegate to the request object.
 * Delegate also can trigger a context-depending action of the application (f.e. pause a game) at
 * the time this method is called.
 *
 * @param aProvider
 *  aProvider which initiated this call
 *
 * @param aRequest
 *  aRequest - request object created by the provider to load content associated with the push
 *  notification.
 **/
- (BOOL)pushProvider:(PHPushProvider *)aProvider
            shouldSendRequest:(PHPublisherContentRequest *)aRequest;

/**
 * Provider calls this method when it handles push notification initiated by
 * handleRemoteNotificationWithUserInfo: to check if it should open URL specified in the push
 * notification info dictionary. By default, URL is opened by the provider.
 *
 * @param aProvider
 *  aProvider which initiated this call
 *
 * @param anURL
 *  anURL - URL that was specified in the push notification on PlayHaven Push Dashboard.
 * 
 * @return
 *  If delegate returns NO, the URL specified in the incoming push notification will not be opened.
 *  Otherwise, the URL will be opened.
 **/
- (BOOL)pushProvider:(PHPushProvider *)aProvider shouldOpenURL:(NSURL *)anURL;

@end

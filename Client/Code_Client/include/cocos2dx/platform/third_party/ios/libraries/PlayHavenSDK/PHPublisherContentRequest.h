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

 PHPublisherContentRequest.h (formerly PHPublisherAdUnitRequest.h)
 playhaven-sdk-ios

 Created by Jesus Fernandez on 4/5/11.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PHAdRequest.h"
#import "PHContentView.h"

@class PHPublisherContentRequest;
@class PHContent;
@class PHReward;
@class PHPurchase;
@protocol PHPublisherContentRequestDelegate;

/** @file */
/**
 * Content request states in order from beginning to end. This is used to
 * support preloading new requests and continuing preloaded requests.
 **/
typedef enum {
    PHPublisherContentRequestInitialized,       /**< Default state */
    PHPublisherContentRequestPreloading,        /**< API content request sent */
    PHPublisherContentRequestPreloaded,         /**< API content request response received */
    PHPublisherContentRequestDisplayingContent, /**< First content unit visible */
    PHPublisherContentRequestDone               /**< All content units have been dismissed */
} PHPublisherContentRequestState;

/**
 * Content request dismiss types are used in the PHPublisherContentRequestDelegate method
 * PHPublisherContentRequestDelegate#request:contentDidDismissWithType:()
 * To explain what caused a content unit to be dismissed. It is not necessary
 * for implementations to use this information.
 **/
typedef NSString PHPublisherContentDismissType;

extern PHPublisherContentDismissType * const PHPublisherContentUnitTriggeredDismiss;           /**< Request was dismissed with a content unit dismiss dispatch. */
extern PHPublisherContentDismissType * const PHPublisherNativeCloseButtonTriggeredDismiss;     /**< Request was dismissed by the user tapping the native close button. */
extern PHPublisherContentDismissType * const PHPublisherApplicationBackgroundTriggeredDismiss; /**< Request was dismissed by the application entering the background */
extern PHPublisherContentDismissType * const PHPublisherNoContentTriggeredDismiss;             /**< Request was dismissed before it was shown because the API response did not contain a content unit. */

/**
 * @internal
 *
 * @brief Delegate protocol. Content request delegates will get notified at various
 * points in the content unit session.
 **/
@protocol PHPublisherContentRequestDelegate <PHAPIRequestDelegate>
@optional

/**
 * A request is being sent to the API. Only sent for the first content unit
 * for a given request
 *
 * @param request
 *   The request
 **/
- (void)requestWillGetContent:(PHPublisherContentRequest *)request;

/**
 * A response containing a valid content unit was received from the API. Only
 * sent for the first content unit for a given request
 *
 * @param request
 *   The request
 **/
- (void)requestDidGetContent:(PHPublisherContentRequest *)request;

/**
 * The first content unit in the session is about to be shown
 *
 * @param request
 *   The request
 *
 * @param content
 *   The content
 **/
- (void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;

/**
 * The first content unit in the session has been displayed
 *
 * @param request
 *   The request
 *
 * @param content
 *   The content
 **/
- (void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;

/**
 * @deprecated
 * The last content unit in the session has been dismissed
 *
 * @param request
 *   The request
 **/
- (void)requestContentDidDismiss:(PHPublisherContentRequest *)request DEPRECATED_ATTRIBUTE;

/**
 * The last content unit in the session has been dismissed. The \c type argument will
 * specify a specific \c PHPublisherContentDismissType
 *
 * @param request
 *   The request
 *
 * @param type
 *   The type
 **/
- (void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type;

///**
// * The request encountered an error and cannot continue
// *
// * @param request
// *   The request
// *
// * @param error
// *   The error
// **/
//- (void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;

/**
 * @deprecated
 * The content unit encountered an error and cannot continue.
 * Errors that would have been sent here are now sent through the other
 * error delegate.
 *
 * @param request
 *   The request
 *
 * @param error
 *   The error
 **/
- (void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error DEPRECATED_ATTRIBUTE;

#pragma mark - Content customization methods
/**
 * Customization delegate. Replace the default native close button image with
 * a custom image for the given button state. Images should be smaller than
 * 40x40 (screen coordinates)
 *
 * @param request
 *   The request
 *
 * @param state
 *   The UIControlState state
 *
 * @param content
 *   The content
 *
 * @return
 *   A custom close button image
 **/
- (UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;

/**
 * Customization delegate. Replace the default border color with a different
 * color for dialog-type content units.
 *
 * @param request
 *   The request
 *
 * @param content
 *   The content
 *
 * @return
 *   A new color for the border
 **/
- (UIColor *)request:(PHPublisherContentRequest *)request borderColorForContent:(PHContent *)content;

#pragma mark - Reward unlocking methods
/**
 * A content unit delivers the reward specified in PHReward. Please consult
 * "Unlocking rewards with the SDK" in README.mdown for more information on
 * how to implement this delegate method.
 *
 * @param request
 *   The request
 *
 * @param content
 *   The content
 **/
- (void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward;

#pragma mark - Purchase unlocking methods
/**
 * A content unit is initiating an IAP transaction. Please consult
 * "Triggering in-app purchases" in README.mdown for more information on
 * how to implement this delegate method.
 *
 * @param request
 *   The request
 *
 * @param purchase
 *   The purchase
 **/
- (void)request:(PHPublisherContentRequest *)request makePurchase:(PHPurchase *)purchase;
@end

/**
 * @internal
 *
 * @brief Request class for starting a content unit session. Manages the initial API
 * request, display of content unit, subcontent unit requests, native close
 * button, and overlay window.
 **/
@interface PHPublisherContentRequest : PHAdRequest <PHContentViewDelegate, PHAPIRequestDelegate> {
    NSString       *_placement;
    BOOL            _animated;
    NSMutableArray *_contentViews;
    BOOL            _showsOverlayImmediately;
    UIButton       *_closeButton;

    UIView    *_overlayWindow;
    PHContent *_content;

    PHPublisherContentRequestState _state;
    PHPublisherContentRequestState _targetState;
}

/**
 * Returns a PHPublisherContentRequest instance for a given token secret and
 * placement. If a request was preloaded for the same placement, this method
 * will return that instance instead
 *
 * @param token
 *   The token
 *
 * @param secret
 *   The secret
 *
 * @param placement
 *   The placement
 *
 * @param delegate
 *   The delegate
 *
 * @return
 *   A PHPublisherContentRequest instance
 **/
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate;

/**
 * Returns a PHPublisherContentRequest instance for a given token, secret and content unit ID.
 *
 * @param token
 *  The token
 *
 * @param secret
 *  The secret
 *
 * @param placement
 *  The placement
 *
 * @param aContentID
 *  Identifier uniquely identifying content unit which is to be requested.
 *
 * @param messageID
 *  Identifier of a push notification sent by PlayHaven server. Message id is assigned to each push
 *  notification sent from the server and its is passed as a separate field in in the push
 *  notification payload. This property should be set for a content request that is created as a
 *  result of incoming push notification.
 *
 * @return
 *   A PHPublisherContentRequest instance
 **/
+ (id)requestForApp:(NSString *)token secret:(NSString *)secret contentUnitID:(NSString *)contentID
            messageID:(NSString *)messageID;

@property (nonatomic, retain)    NSString       *placement;               /**< Placement id for this content request, this should correspond to one of the
                                                                              placements set up for this game on the PlayHaven Dashboard */
@property (nonatomic,assign)    BOOL            animated;                /**< Controls whether content unit transitions will be animated for this request */
@property (nonatomic,readonly)  NSMutableArray *contentViews;            /**< Collection of PHContentViews being managed by this request */
@property (nonatomic, assign)   BOOL            showsOverlayImmediately; /**< Controls whether or not the overlay will be shown immediately after PHAPIRequest#send.
                                                                              Defaults to NO */
@property (nonatomic, readonly) UIView         *overlayWindow;           /**< Overlay view instance */

@property (nonatomic, assign) id<PHPublisherContentRequestDelegate> delegate;

/**
 * Request the content unit from the API, but stop before actually displaying it until PHAPIRequest#send is called
 **/
- (void)preload;
@end

@interface PHPublisherContentRequest (PHCustomDimensions)
/**
 * Provides ability to set a custom dimension for the receiver.
 * Dimensions is a means to define new user segments that can be used to target content to specific
 * users. By setting your own dimensions on a content request object you get ability to distinguish
 * requests coming from different users. For example, as a dimension you can use current user
 * location, gender, etc.. For more information on custom dimensions feature, see a documentation on
 * the Upsight Dashboard.
 *
 * @param aKey
 *  A string that identifies your dimension. This key should be one of the dimension names that you
 *  define on the Upsight Dashboard.
 *
 * @param aDimension
 *  Value of the dimension. When setting a dimension you need to know the following rules:
 *  - aDimension parameter must be an object of NSString, NSNumber or NSNull class.
 *  - The Upsight's server stores all custom dimensions received from each device.
 *  - You can remove a dimension for a given key on the server, by passing NSNull as a dimension
 *  value.
 *  - Sending the same key with different value will update the custom dimension stored server-side.
 **/
- (void)setDimension:(id)aDimension forKey:(NSString *)aKey;

/**
 * Convenience method that provides ability to set multiple custom dimension at a time. For more
 * information see the documentation on -[PHPublisherContentRequest setDimension:forKey:] method.
 **/
- (void)addDimensionsFromDictionary:(NSDictionary *)aDimensions;
@end

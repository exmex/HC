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

 PHStoreProductViewController.m
 playhaven-sdk-ios

 Created by Jesus Fernandez on 9/18/12.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

//  This will ensure the PH_USE_STOREKIT macro is properly set.
#import "PHConstants.h"

#if PH_USE_STOREKIT != 0
#import "PHStoreProductViewController.h"

static PHStoreProductViewController *_storeController = nil;

@interface PHStoreProductViewController()
@property (nonatomic, retain) SKStoreProductViewController *storeController;
@property (nonatomic, retain) NSString *productID;
- (UIViewController *)visibleViewController;
@end

@implementation PHStoreProductViewController
+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_storeController == nil) {
            _storeController = [[super allocWithZone:NULL] init];
            [[NSNotificationCenter defaultCenter] addObserver:_storeController
                                                     selector:@selector(appDidEnterBackground)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
    });

    return _storeController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}
 
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
 
- (id)retain
{
    return self;
}
 
- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}
 
- (oneway void)release
{
}
 
- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    [_productID release];
    [_storeController release];
    [_visibleViewController release];

    [super dealloc];
}

- (UIViewController *)visibleViewController
{
    if (_visibleViewController == nil) {
        _visibleViewController = [[UIViewController alloc] init];
    }

    UIWindow *applicationWindow = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
    [applicationWindow addSubview:_visibleViewController.view];

    return _visibleViewController;
}

- (BOOL)showProductId:(NSString *)productId
{
    if ([SKStoreProductViewController class] && nil != productId)
    {
        self.productID = productId;
        
        if (nil == self.storeController)
        {
            self.storeController = [[SKStoreProductViewController new] autorelease];
            self.storeController.delegate = self;
            
            [[self visibleViewController] presentViewController:self.storeController animated:YES
                        completion:NULL];
        }
        
        if ([self.delegate respondsToSelector:@selector(
                    storeProductViewController:willPresentProductWithID:)])
        {
            [self.delegate storeProductViewController:self willPresentProductWithID:productId];
        }

        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier : productId};
        [self.storeController loadProductWithParameters:parameters completionBlock:nil];
        
        return YES;
    }

    return NO;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^(void){
        [_visibleViewController.view removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(
                    storeProductViewController:didDismissProductWithID:)])
        {
            [self.delegate storeProductViewController:self didDismissProductWithID:self.productID];
        }
        
        self.storeController = nil;
        self.productID = nil;
    }];
}

#pragma mark -
#pragma NSNotification Observers
- (void)appDidEnterBackground
{
    // This will automatically dismiss the view controller when the app is backgrounded
    if ([_visibleViewController respondsToSelector:@selector(presentedViewController)] &&
                _visibleViewController.presentedViewController)
    {
        [_visibleViewController dismissViewControllerAnimated:NO completion:NULL];
        
        if ([self.delegate respondsToSelector:@selector(
                    storeProductViewController:didDismissProductWithID:)])
        {
            [self.delegate storeProductViewController:self didDismissProductWithID:self.productID];
        }
    }

    [_visibleViewController.view removeFromSuperview];
    self.storeController = nil;
    self.productID = nil;
}
@end
#endif

/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#import <UIKit/UIKit.h>
#include <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

#import "Chartboost.h"
#import "AppController.h"
#import "InMobi.h"
#import "PlayHavenSDK.h"
#import "cocos2d.h"
#import "EAGLView.h"
#import "AppDelegate.h"
#import "apiforlua.h"
#import "RootViewController.h"
#import "PlatformSupport.h"
#import "CCLuaEngine.h"
#import "ModuleAppStore.h"
#import "ACTReporter.h"


@interface AppController () <ChartboostDelegate>
@end

@implementation AppController



// cocos2d application instance
static AppDelegate s_sharedApplication;

static PlatformSupport* platformSupport;

static AppController* appController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *InMobiAppID = [dict objectForKey:@"InMobiAppID"];
    NSLog(@"InMobiAppID-----: %@",InMobiAppID);
    [InMobi setLogLevel:IMLogLevelDebug];
    [InMobi initialize:InMobiAppID];
    
    NSString *PlayHavenToken = [dict objectForKey:@"PlayHavenToken"];
    NSString *PlayHavenSecret = [dict objectForKey:@"PlayHavenSecret"];
    NSLog(@"PlayHavenToken-----: %@",PlayHavenToken);
    NSLog(@"PlayHavenSecret-----: %@",PlayHavenSecret);
    [[PHPublisherOpenRequest requestForApp:PlayHavenToken secret:PlayHavenSecret] send];
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"PlayHavenadId-----: %@",adId);
    
    
    PHPublisherContentRequest *request = [PHPublisherContentRequest
                                          requestForApp:PlayHavenToken
                                          secret:PlayHavenSecret
                                          placement:@"app_launch"
                                          delegate:self];
    request.showsOverlayImmediately = NO;
    [request send];
    
    
    // Enable automated usage reporting.
    [ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"966380435"];
    [ACTConversionReporter reportWithConversionID:@"966380435" label:@"aSdRCIiq_FUQk5fnzAM" value:@"0.00" isRepeatable:NO];
    [ACTConversionReporter reportWithConversionID:@"966380435" label:@"9_2hCLb6_VUQk5fnzAM" value:@"0.00" isRepeatable:NO];
    
    // Override point for customization after application launch.
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:[UIDevice currentDevice]];
    [self batteryChanged:nil];
    
    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    EAGLView *__glView = [EAGLView viewWithFrame: [window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH24_STENCIL8_OES//GL_DEPTH_COMPONENT16
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];
    
    // Use RootViewController manage EAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = __glView;
    appController = self;
    platformSupport = [PlatformSupport alloc];
    
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    //    [AppController postAndGetData];
    
    [window makeKeyAndVisible];
    
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
    
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    //在后台运行 - 用户可以看到类似Push Notification的提醒，若用户选择查看提醒详情，则应用通
    //
//    UILocalNotification *localNotification =
//    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (localNotification) {
//        NSLog(@"Notification Body: %@",localNotification.alertBody);
//        NSLog(@"%@", localNotification.userInfo);
//       
//    }
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications ) {
        
        NSLog(@"Notification userinfo:%@", notification.userInfo);
         [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    cocos2d::CCApplication::sharedApplication()->run();
    
    [ModuleAppStore shared];
    
   // [platformSupport postWebLogin];
    
    return YES;
}

void didLogIn(bool bLoggedIn) {
    NSLog(@"facebook didLogIn calback");
    if(bLoggedIn){
        NSLog(@"facebook didLogIn :true");
    }else{
        NSLog(@"facebook didLogIn :false");
    }
    
    //FacebookController::SetLoggedIn(bLoggedIn);
}

+(PlatformSupport*)getPlatformSupport{
    return platformSupport;
}
+(AppController*)shared{
    return appController;
}

-(RootViewController*)getViewController{
    return  viewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::CCDirector::sharedDirector()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::CCDirector::sharedDirector()->resume();
    
    NSLog(@"applicationDidBecomeActive-----");

    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *FacebookAppID = [dict objectForKey:@"FacebookAppID"];
    
    //for facebook
    [FBAppCall handleDidBecomeActive];
    [FBSettings setDefaultAppID: FacebookAppID];
    [FBAppEvents activateApp];
    
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    NSString *ChartboostAppId = [dict objectForKey:@"ChartboostAppId"];
    NSString *ChartboostAppSignature = [dict objectForKey:@"ChartboostAppSignature"];
    [Chartboost startWithAppId:ChartboostAppId appSignature:ChartboostAppSignature delegate:self];
    //[Chartboost sharedChartboost];
    [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::CCApplication::sharedApplication()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    application.applicationIconBadgeNumber = 0;
    cocos2d::CCApplication::sharedApplication()->applicationWillEnterForeground();
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *PlayHavenToken = [dict objectForKey:@"PlayHavenToken"];
    NSString *PlayHavenSecret = [dict objectForKey:@"PlayHavenSecret"];
    NSLog(@"PlayHavenToken-----: %@",PlayHavenToken);
    NSLog(@"PlayHavenSecret-----: %@",PlayHavenSecret);
    [[PHPublisherOpenRequest requestForApp:PlayHavenToken secret:PlayHavenSecret] send];
    
}

- (void)batteryChanged:(NSNotification *)notification
{
    UIDevice *device = [UIDevice currentDevice];
    if (device.batteryState < 2)
    {

        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];  //启动锁屏
        
    }
    else
    {
        //连接电源
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];  //取消锁屏
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    
    
    //一般需要应用程序后台运行时才会显示提示，前台运行时一般不显示提示。如果想要当应用程序前台应行时也显示提示，则可以通过将下面函数加到appDelegate中实现
    
//    UIApplicationState state = application.applicationState;
//    //    NSLog(@"%@,%d",notification,state);
//    if (state == UIApplicationStateActive) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:notification.alertBody
//                                                       delegate:self
//                                              cancelButtonTitle:@"Close"
//                                              otherButtonTitles:@"OK",nil];
//        [alert show];
//        [alert release];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */

    [[FBSession activeSession] close];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    cocos2d::CCDirector::sharedDirector()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}


/**********Chartboost begin......****************************************/

/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return NO;
}

- (BOOL)shouldDisplayMoreApps {
    return NO;
}

- (BOOL)shouldDisplayLoadingViewForMoreApps {
    return NO;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasCachedInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load More Apps, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load More Apps, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load More Apps, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load More Apps, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load More Apps, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load More Apps, first session !");
        } break;
        case CBLoadErrorNoAdFound: {
            NSLog(@"Failed to load More Apps, Apps not found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load More Apps, unknown error !");
        }
    }
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache interstitials
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache the more apps page
 */

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    [[Chartboost sharedChartboost] cacheMoreApps:CBLocationHomeScreen];
}

/*
 * shouldRequestInterstitialsInFirstSession
 *
 * This sets logic to prevent interstitials from being displayed until the second startSession call
 *
 * The default is YES, meaning that it will always request & display interstitials.
 * If your app displays interstitials before the first time the user plays the game, implement this method to return NO.
 */

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {

        if (call.appLinkData && call.appLinkData.targetURL) {
            [[NSNotificationCenter defaultCenter] postNotificationName:APP_HANDLED_URL object:call.appLinkData.targetURL];
        }

    }];

    return YES;
}


@end


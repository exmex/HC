//
//  GameAppController.mm
//  Game
//
//  Created by fish on 13-2-18.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppController.h"
#import "cocos2d.h"
#import "EAGLView.h"
#import "AppDelegate.h"
#import "libOS.h"
#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#define YOUR_APP_ID @"259327124273283"
#ifdef C4L_SELFPAY
#import "com4lovesSDK.h"
#endif

#ifdef PROJECTUC
#import <UCGameSdk/UCGameSdk.h>
#endif


#ifdef PROJECTDownJoy
#import <DownjoySDK/DJPlatform.h>
#import <DownjoySDK/DJPlatformNotification.h>
#endif

#ifdef PROJECT49APP
#import <49AppKit/pay_form_of_alipay_subview.h>
#endif 

#ifdef PROJECTPP
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#endif

#ifdef PROJECTPPZB
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#endif

#ifdef PROJECTAG
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#endif


#ifdef PROJECTTB
#import <TBPlatform/TBPlatform.h>
#endif

#ifdef PROJECTAPPSTORE
#import "AppsFlyerTracker.h"
#endif

@implementation AppController

@synthesize window;
@synthesize viewController;

@synthesize theMovie = _theMovie;
//-end

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   
    [FBLoginView class];
    application.applicationSupportsShakeToEdit= YES; //在ios6.0后，这里其实都可以不写了
    // Override point for customization after application launch.
    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
//    NSLog(@"%f,%f,%f,%f",[window bounds].origin.x,[window bounds].origin.x,[window bounds].size.height,[window bounds].size.wide);
    EAGLView *__glView = [EAGLView viewWithFrame: [window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH24_STENCIL8_OES
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples:0 ];

    // Use RootViewController manage EAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = __glView;
    
    [window setRootViewController:viewController];

    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];    //防止进入屏保状态
    
    
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        //[_viewController logMsg:record];
    }
    //-end
    #ifdef PROJECTAPPSTORE
    [AppsFlyerTracker sharedTracker].appleAppID = @"934675002";
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"xTe4FqvHxdVJTTVj8xQPKa";
    #endif

    cocos2d::CCApplication::sharedApplication()->run();
    return YES;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if(libOS::getInstance()->getShareWeChatCallBack())
    {
    		[WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        #ifdef C4L_SELFPAY
        		[[com4lovesSDK sharedInstance] parseURL:url];
		    #endif
		        
		    #ifdef PROJECTUC
		        [[UCGameSdk defaultSDK] parseAliPayResultWithURL:url
		                                             application:application];
		    #endif
		        
		    #ifdef PROJECT49APP
		        [[pay_form_of_alipay_subview _self] parseURL:url];
		    #endif
		        
		    #ifdef PROJECTPP
		        [[PPAppPlatformKit sharedInstance] alixPayResult:url];
		    #endif
		        
		    #ifdef PROJECTPPZB
		        [[PPAppPlatformKit sharedInstance] alixPayResult:url];
		    #endif
		        
		    #ifdef PROJECTAG
		        [[PPAppPlatformKit sharedInstance] alixPayResult:url];
		    #endif
		        
		    #ifdef PROJECTTB
		        [[TBPlatform defaultPlatform] handleOpenURL:url];
		    #endif
    }
    
	return YES;
}



//支付宝快捷支付，游戏厂商的开发大神记得把这个方法加入AppDelegate.m
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(libOS::getInstance()->getShareWeChatCallBack())
    {
    		[WXApi handleOpenURL:url delegate:self];
    }
    else
    {
       #ifdef PROJECTDownJoy
        [[NSNotificationCenter defaultCenter] postNotificationName:kDJPlatfromAlixQuickPayEnd object:url];
       #endif
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [FBSettings setDefaultAppID:YOUR_APP_ID];
    [FBAppEvents activateApp];
    cocos2d::CCDirector::sharedDirector()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    #ifdef PROJECTAPPSTORE
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    #endif
   
    cocos2d::CCDirector::sharedDirector()->resume();
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
    cocos2d::CCApplication::sharedApplication()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
 return UIInterfaceOrientationMaskAll;
}

#endif

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     //cocos2d::CCApplication::sharedApplication()->purgeCachedData();
     cocos2d::CCDirector::sharedDirector()->purgeCachedData();
}


- (void)dealloc
{
    [_theMovie release];
    //-end
    
    [super dealloc];
}

//weixin share callback start

-(void) onReq:(BaseReq*)req
{
    /*
    
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
     */
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
                libOS::getInstance()->boardcastMessageShareEngine(true,"");
                break;
            default:
                libOS::getInstance()->boardcastMessageShareEngine(false,"");
                break;
        }
    }
}

//weixin share callback end

/**
 for plat play movie file
 **/
-(void)playMovie:(NSString *)movie needSkip:(int)skipFlag
{
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    NSString* src = [NSString stringWithFormat:@"movie/%@",movie];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:src ofType:@"mp4"];
    NSLog(@"movie filepath  %@",filepath);
    if (!filepath)
    {
        libOS::getInstance()->boardcastMessageOnPlayEnd();
        return;
    }
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.theMovie = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    self.theMovie.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [self.viewController.view addSubview:self.theMovie.view];
    self.theMovie.fullscreen = false;
    [self.theMovie setScalingMode:MPMovieScalingModeAspectFill];
    self.theMovie.controlStyle = MPMovieControlStyleNone;
    
    //add by xinghui
    [window addSubview:self.viewController.view];
    [window makeKeyAndVisible];
    
    //button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    CGRect frame;
    if (skipFlag == 1)//skip for full screen
    {
        frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
    else if (skipFlag == 2)//skip for button
    {
        frame = CGRectMake(rect.size.width*3/4, rect.size.height / 15, rect.size.width / 7, rect.size.width / 7 / 2);
    }
    
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];

	if (!skipFlag)
	{
	 [button setHidden:YES];
	}
    
    //skip for button
    if (skipFlag == 2)
    {
        NSString* btnBackImageSrc = @"movie/Skip";
        NSString* btnBackImagePath = [[NSBundle mainBundle] pathForResource:btnBackImageSrc ofType:@"png"];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:btnBackImagePath]) {
            UIImage* btnImg = [UIImage imageWithContentsOfFile:btnBackImagePath];
            [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        }
    }
    
    button.tag = 2000;
    [button addTarget:self action:@selector(jumpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
    
    //
    
    if ([self.theMovie respondsToSelector:@selector(prepareToPlay)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onPlayFinished:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.theMovie];
        [self.theMovie prepareToPlay];
    }
}

//add by xinghui
-(IBAction)jumpBtnClicked:(id)sender{
    libOS::getInstance()->boardcastMessageOnPlayEnd();
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.theMovie];
    
    [self.theMovie pause];
    [self.theMovie.view removeFromSuperview];
    [self.theMovie release];
    [button removeFromSuperview];
}
//


-(void)stopMovie
{
    libOS::getInstance()->boardcastMessageOnPlayEnd();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.theMovie];
    [self.theMovie pause];
    [self.theMovie.view removeFromSuperview];
    [self.theMovie release];
}
-(void)onPlayFinished:(NSNotification*)aNotification
{
    libOS::getInstance()->boardcastMessageOnPlayEnd();
    [button removeFromSuperview];//add by xinghui
    //[button release];//add by xinghui
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:theMovie];
    
    [theMovie.view removeFromSuperview];
    [theMovie release];
}

@end


@implementation UIWindow (shake)

//这里很重要，因为大部分视图 默认 的  canBecomeFirstResponder 是 NO的

-(BOOL)canBecomeFirstResponder
{
    return NO;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (motion ==UIEventSubtypeMotionShake )
    {
        libOS::getInstance()->boardcastMotionShakeMessage();
    }
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    
}

@end



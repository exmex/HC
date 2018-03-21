//
//  GameAppController.h
//  Game
//
//  Created by fish on 13-2-18.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "WXApi.h"
#import <MediaPlayer/MediaPlayer.h>


@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate,
                                        UITextFieldDelegate, UIApplicationDelegate,WXApiDelegate> {
    UIWindow *window;
    UIButton *button;//add by xinghui
    RootViewController    *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

@property (retain, nonatomic) MPMoviePlayerController* theMovie;

@end


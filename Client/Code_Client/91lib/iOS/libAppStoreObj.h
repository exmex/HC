//
//  libAppStoreObj.m
//  libAppStore
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>
#import "com4lovesSDK.h"
#import "AppsFlyerTracker.h"

//#import "DMInterstitialSampleViewController.h"
//#import "DMInterstitialAdController.h"

@interface libAppStoreObj : NSObject <AppsFlyerTrackerDelegate>//<DMInterstitialAdControllerDelegate>
//@property (nonatomic,retain)DMInterstitialSampleViewController *DMcontroller;
-(void) initRegister;
-(void) setBuyInfo:(BUYINFO) info;
-(void)onPresent;

//-(void) appVersionUpdateDidFinish:(ND_APP_UPDATE_RESULT)updateResult;
@end

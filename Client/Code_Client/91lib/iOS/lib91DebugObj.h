//
//  lib91Obj.h
//  lib91
//
//  Created by wzy on 13-3-5.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <NdComPlatform/NdComPlatform.h>
#import <NdComPlatform/NdComPlatformAPIResponse.h>
#import <NdComPlatform/NdCPNotifications.h>

@interface lib91DebugObj : NSObject
{
    UIActivityIndicatorView *waitView;
}
-(void) registerNotification;
-(void) SNSLoginResult:(NSNotification *)notify;
-(void) SNSInitResult:(NSNotification *)notify;
-(void) NdUniPayAysnResult:(NSNotification *)notify;
-(void) unregisterNotification;
-(void) updateApp;
//-(void) appVersionUpdateDidFinish:(ND_APP_UPDATE_RESULT)updateResult;
@end

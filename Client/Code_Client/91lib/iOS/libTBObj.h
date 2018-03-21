//
//  libTBObj.m
//  libTB
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TBPlatform/TBPlatform.h>

@interface libTBObj : NSObject<TBBuyGoodsProtocol>
{
    UIActivityIndicatorView *waitView;
}
-(void) registerNotification;
-(void) SNSLoginResult:(NSNotification *)notify;
-(void) SNSInitResult:(NSNotification *)notify;
-(void) NdUniPayAysnResult:(NSNotification *)notify;
-(void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order;
-(void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType;
-(void)tbInitFinished:(NSNotification *)notification;

-(void) unregisterNotification;
-(void) updateApp;
//-(void) appVersionUpdateDidFinish:(ND_APP_UPDATE_RESULT)updateResult;
@end

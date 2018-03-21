//
//  libYouaiObj.m
//  libYouai
//
//  Created by lvjc on 13-7-25.
//  Copyright (c) 2013年 youai. All rights reserved.
//
#include "libYouai.h"
#import "libYouaiObj.h"


@interface libYouaiObj ()
{
    BUYINFO buyInfo;
}
@end

@implementation libYouaiObj

-(void) initRegister
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDone:) name:(NSString*)com4loves_loginDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyDone:) name:(NSString*)com4loves_buyDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:(NSString*)com4loves_logout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryUser2OkSuccess:) name:(NSString*)com4loves_tryuser2OkSucess object:nil];
}

- (void)LoginDone:(NSNotification *)notify
{

    libPlatformManager::getPlatform()->_boardcastLoginResult(true, "登录成功");
}


- (void)buyDone:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastBuyinfoSent(true, buyInfo, "购买成功");
    
}

-(void) setBuyInfo:(BUYINFO) info
{
    buyInfo = info;
}

-(void) logout:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastPlatformLogout();
}

-(void) tryUser2OkSuccess:(NSNotification *)notify
{
    libPlatformManager::getPlatform()->_boardcastOnTryUserRegistSuccess();
}

-(void)dealloc
{
    [super dealloc];
}

@end

//
//  YouaiServerInfo.h
//  com4lovesSDK
//
//  Created by ljc on 13-11-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouaiServerInfo : NSObject

@property (nonatomic) int serverID;
@property (nonatomic, retain) NSString *playerName;
@property (nonatomic, retain) NSString *gameid;
@property (nonatomic, retain) NSString *puid;
@property (nonatomic) int playerID;
@property (nonatomic) int lvl;
@property (nonatomic) int vipLvl;
@property (nonatomic) int coin1;
@property (nonatomic) int coin2;

@end

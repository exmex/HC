//
//  com4loves.cpp
//  com4lovesSDK
//
//  Created by fish on 13-8-31.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#include "com4loves.h"
#import "com4lovesSDK.h"
#import "YouaiServerInfo.h"


void com4loves::updateServerInfo(int serverID, const std::string& playerName, int playerID, int lvl, int vipLvl, int coin1, int coin2, bool pushSvr)
{
    NSString* name = [NSString stringWithUTF8String:playerName.c_str()];
   [com4lovesSDK updateServerInfo:serverID  playerName:name playerID:playerID lvl:lvl vipLvl:vipLvl coin1:coin1 coin2:coin2 pushSer:pushSvr];
   [com4lovesSDK getServerInfo].serverID = serverID;
    [com4lovesSDK getServerInfo].playerName = name;
    [com4lovesSDK getServerInfo].playerID  = playerID;
    [com4lovesSDK getServerInfo].lvl = lvl;
    [com4lovesSDK getServerInfo].vipLvl = vipLvl;
    [com4lovesSDK getServerInfo].coin1 = coin1;
    [com4lovesSDK getServerInfo].coin2 = coin2;
}
void com4loves::refreshServerInfo(const std::string& gameid,const std::string& puid, bool getSvr)
{
    NSString* gameID = [NSString stringWithUTF8String:gameid.c_str()];
    NSString* PUID = [NSString stringWithUTF8String:puid.c_str()];
    [com4lovesSDK getServerInfo].gameid = gameID;
    [com4lovesSDK getServerInfo].puid = PUID;
    [com4lovesSDK refreshServerInfo:gameID puid:PUID pushSer:getSvr];
}
int com4loves::getServerInfoCount()
{
    return [com4lovesSDK getServerInfoCount];
}
int com4loves::getServerUserByIndex(int index)
{
    return [com4lovesSDK getServerUserByIndex:index];
}
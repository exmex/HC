//
//  CmgeProject.h
//  CmgeIosClient
//
//  Created by zhouqing on 13-5-20.
//  Copyright (c) 2013年 zhouqing. All rights reserved.


#import <Foundation/Foundation.h>

@interface CmgeProject : NSObject {
//    NSString *_projectId;  //projectId 项目id，需要向CMGE商务申请，合法的id不为空(必填)
//    NSString *_gameId;  //gameId 游戏id，需要向CMGE商务申请，合法的id不为空 (必填)
//    BOOL _isOnlineGame;  //是否是网游 YES-是，NO-否(必填)
//    NSString *_serverId;  //玩家所选游戏服务器ID(可选)
}

@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, assign) BOOL isOnlineGame;
@property (nonatomic, strong) NSString *serverId;

@end

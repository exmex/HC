//
//  CmgeRechargeParameters.h
//  CmgeIosClient
//
//  Created by zhouqing on 13-5-15.
//  Copyright (c) 2013年 zhouqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmgeRechargeParameters : NSObject {
//    NSString *_serverId;  //玩家所选游戏服务器ID
//    NSString *_roleName;  //玩家在游戏中的角色名
//    NSString *_rechargeAmount;  //本次充值金额
}

@property (nonatomic, strong) NSString *serverId;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSString * rechargeAmount;


@end

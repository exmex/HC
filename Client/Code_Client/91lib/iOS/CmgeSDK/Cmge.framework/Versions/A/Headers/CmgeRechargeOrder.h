//
//  CmgeRechargeOrder.h
//  CmgeIosClient
//
//  Created by zhouqing on 13-5-15.
//  Copyright (c) 2013年 zhouqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmgeRechargeOrder : NSObject {
//    NSString *_cmgeRechargeOrderId;  //充值订单号
//    NSString *_cmgeRechargeOrderMoney; //充值金额
}

@property (nonatomic, strong) NSString *cmgeRechargeOrderId;
@property (nonatomic, strong) NSString *cmgeRechargeOrderMoney;

@end

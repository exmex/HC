//
//  NdComPlatform+Center.h
//  NdComPlatform_Center
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"

@interface NdComPlatform(Center)




#pragma mark -
#pragma mark Platform

/**
 @brief 进入平台中心
 @param nFlag 预留, 默认为0
 */
- (void)NdEnterPlatform:(int) nFlag;

typedef	enum  _NDCP_SETTING_FLAG {
	NDCP_SETTING_DEFAULT  =  0,         /**< 进入平台中心“更多”界面	*/
	NDCP_SETTING_PERSONAL_INFO,         /**< 进入“个人信息管理”界面	*/
	NDCP_SETTING_ACCOUNT,               /**< 进入“通行证管理”界面	*/
	NDCP_SETTING_AUTHORITY,             /**< 进入“权限管理”界面	*/
	NDCP_SETTING_RECORD_TRADE,          /**< 进入“91豆充值消费记录”界面	*/
	NDCP_SETTING_RECHARGE_RECORD,		/**< 进入“91豆充值记录”界面	*/
	NDCP_SETTING_CONSUME_RECORD,		/**< 进入“91豆消费记录”界面	*/
}	NDCP_SETTING_FLAG;
/**
 @brief 进入设置界面
 @param nFlag 参照NDCP_SETTING_FLAG值。
 @result 错误码
 */
- (int)NdEnterUserSetting:(int) nFlag;




#pragma mark -
#pragma mark App Center

/**
 @brief 进入游戏大厅
 @param nFlag 预留，默认为0。
 */
- (void)NdEnterAppCenter:(int) nFlag;

/**
 @brief 进入指定AppId的应用主页
 @param nFlag 预留，默认为0。
 @param appId 指定应用或游戏的appid，
 @note 传入的appid小于等于0时直接进入游戏大厅
 */
- (void)NdEnterAppCenter:(int) nFlag appId:(int)appId;

/**
 @brief 进入应用论坛
 @param nFlag 预留，目前传0即可
 @result 错误码
 */
- (int)NdEnterAppBBS:(int)nFlag;



@end
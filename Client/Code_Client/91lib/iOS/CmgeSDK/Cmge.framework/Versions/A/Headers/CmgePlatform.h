//
//  CmgePlatform.h
//  Cmge
//
//  Created by lory qing on 10/05/13.
//  Copyright (c) 2012 Cmge. All rights reserved.
//

@protocol CmgePlatformProtocol;

@class CmgeRechargeParameters;
@class CmgeProject;

@interface CmgePlatform : NSObject

/**
 @brief 获取CmgePlatform的实例对象
 */
+ (CmgePlatform *)defaultPlatform;

#pragma mark -
#pragma mark set Interface Config

/**
 @brief 设置项目参数
 @param project 项目设置参数对象 请参考CmgeProject.h文件
 @result YES表示设置成功  NO失败
 @note 调用SDK之前必须保证CmgeProject对象的各项参数正确设置
 */
- (BOOL)setProject:(CmgeProject *)project;

/**
 @brief 设定View方向
 @note	默认方向为UIInterfaceOrientationMaskPortrait
 */
- (void)setViewOrientation:(UIInterfaceOrientationMask)orientation;

#pragma mark - View Interfaces

/**
 @brief  调用SDK默认的登陆界面
 @result 0表示方法调用成功  其他结果请参考CmgePlatformError.h
 @note   如果开发者想自定义用户登陆界面，请调用后序用户相关的接口方法
 */
- (int)enterLoginView;

/**
 @brief  注销、退出登陆
 @result 0表示方法调用成功  其他结果请参考CmgePlatformError.h
 */
- (int)logout;

/**
 @brief 调用SDK默认的充值界面
 @param rechargeParameters 充值参数对象 请参考CmgeRechargeParameters.h
 @result 0表示方法调用成功  其他结果请参考CmgePlatformError.h
 */
- (int)enterRechargeCenterView:(CmgeRechargeParameters *)rechargeParameters;


#pragma mark - Data Interfaces

/**
 @brief 获取登录用户名
 @result 若用户没登录，则返回nil
 */
- (NSString *)getUserName;

@end

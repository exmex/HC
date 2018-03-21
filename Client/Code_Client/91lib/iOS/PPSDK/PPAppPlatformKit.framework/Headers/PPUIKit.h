//
//  PPUserUIKit.h
//  PPUserUIKit
//
//  Created by seven  mr on 1/14/13.
//  Copyright (c) 2013 张熙文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PPUIKit : NSObject
{
}
/**
 * @brief     初始化SDK界面,必须写在window makeKeyAndVisible方法之后。
 * @return    PPUIKit    生成的PPUIKit对象实例
 */
+ (PPUIKit *)sharedInstance;

/**
 * @brief     SDK检查游戏版本更新
 * @return    无返回
 */
- (void)checkGameUpdate;

/**
 * @brief     设置SDK是否允许竖立设备Home键在下方向
 * @param     INPUT paramDeviceOrientationPortrait: YES 支持 ，NO 不支持， 默认为YES
 * @return    无返回
 */
+ (void)setIsDeviceOrientationPortrait:(BOOL)paramDeviceOrientationPortrait;


/**
 * @brief     设置SDK是否允许竖立设备Home键在上方向
 * @param     INPUT paramDeviceOrientationPortraitUpsideDown: YES 支持 ，NO 不支持， 默认为YES
 * @return    无返回
 */
+ (void)setIsDeviceOrientationPortraitUpsideDown:(BOOL)paramDeviceOrientationPortraitUpsideDown;



/**
 * @brief     设置SDK是否允许竖立设备Home键在左方向
 * @param     INPUT paramDeviceOrientationLandscapeLeft: YES 支持 ，NO 不支持， 默认为YES
 * @return    无返回
 */
+ (void)setIsDeviceOrientationLandscapeLeft:(BOOL)paramDeviceOrientationLandscapeLeft;


/**
 * @brief     设置SDK是否允许竖立设备Home键在右方向
 * @param     INPUT paramDeviceOrientationLandscapeRight: YES 支持 ，NO 不支持， 默认为YES
 * @return    无返回
 */
+ (void)setIsDeviceOrientationLandscapeRight:(BOOL)paramDeviceOrientationLandscapeRight;
@end

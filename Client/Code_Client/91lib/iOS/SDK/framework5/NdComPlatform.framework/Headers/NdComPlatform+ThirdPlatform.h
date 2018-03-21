//
//  NdComPlatform+ThirdPlatform.h
//  NdComPlatform_ThirdPlatform
//
//  Created by xujianye on 12-5-24.
//  Copyright 2012 NetDragon WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NdComPlatformBase.h"
#import "NdComPlatformAPIResponse+ThirdPlatform.h"


@interface NdComPlatform(ThirdPlatform)


#pragma mark -
#pragma mark Share Message

/**
 @brief 进入分享到第三方平台的界面，如果没有绑定指定的平台，则会跳到绑定界面。
 @param strContent	预分享的内容（最大140个字符），第三方平台可能会对重复内容进行屏蔽处理（如新浪微博禁止发重复内容）
 @param imageInfo	预分享的图片，可以是当前屏幕，指定的UIImage 或者 图片名称（支持全路径，或者只有文件名。如果为文件名，load from main bundle）
 @result 错误码
 */
- (int)NdShareToThirdPlatform:(NSString*)strContent  imageInfo:(NdImageInfo*)imageInfo;


@end




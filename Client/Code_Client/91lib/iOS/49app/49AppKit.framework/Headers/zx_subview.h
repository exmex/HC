//
//  zx_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zmd_uilabel.h"

@protocol _zx_delegate;
@interface zx_subview : UIView < UIWebViewDelegate >
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_zx_delegate> __zx_delegate;

- (void)_loadlinks:(NSString *)_links;

@end

@protocol _zx_delegate <NSObject>
    - (void)_zx2pev_action;
@end

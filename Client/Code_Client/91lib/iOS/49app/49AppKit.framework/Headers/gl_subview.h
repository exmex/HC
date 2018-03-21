//
//  gl_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zmd_uilabel.h"

@protocol _gl_delegate;
@interface gl_subview : UIView < UIWebViewDelegate >
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_gl_delegate> __gl_delegate;

- (void)_loadlinks:(NSString *)_links;

@end

@protocol _gl_delegate <NSObject>
    - (void)_gl2pev_action;
@end

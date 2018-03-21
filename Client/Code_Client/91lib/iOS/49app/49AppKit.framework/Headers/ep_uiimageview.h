//
//  ep_uiimageview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-25.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _epuiimageview_delegate;
@interface ep_uiimageview : UIImageView

@property (nonatomic, assign) id <_epuiimageview_delegate> __epuiimageview_delegate;

@end

@protocol _epuiimageview_delegate <NSObject>
    - (void)_imageview_touchupinside;
@end

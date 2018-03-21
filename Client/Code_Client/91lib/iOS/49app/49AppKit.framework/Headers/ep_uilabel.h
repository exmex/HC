//
//  ep_uilabel.h
//  49AppKit
//
//  Created by 14zynr on 13-7-24.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _epuilabel_delegate;
@interface ep_uilabel : UILabel

@property (nonatomic, assign) id <_epuilabel_delegate> __epuilabel_delegate;
@property int _style;

- (id)initWithFrame:(CGRect)frame withColor:(int)_color withFontSize:(int)_fontsize withTag:(int)_active_tag;

@end

@protocol _epuilabel_delegate <NSObject>
    - (void)_label_touchupinside:(int)_active_tag;
@end

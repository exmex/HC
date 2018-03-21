//
//  zmd_uilabel.h
//  49AppKit
//
//  Created by 14zynr on 13-7-25.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zmd_uilabel : UIView
{
    NSArray *_arr_zmdtitle;
    UILabel *_zmd_label;
}

- (id)initWithFrame:(CGRect)frame withText:(NSString *)_zmd_text withTextColor:(UIColor *)color;
- (void)_set_zmd_text:(NSString *)_zmd_text;

@end

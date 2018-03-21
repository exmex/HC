//
//  pay_form_of_yl_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-8-13.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "upomp_lthj/LTInterface.h"

@interface pay_form_of_yl_subview : UIView <LTInterfaceDelegate>
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, retain) NSDictionary *_payment_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;

@end

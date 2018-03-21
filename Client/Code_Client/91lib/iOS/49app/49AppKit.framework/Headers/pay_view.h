//
//  pay_view.h
//  49App
//
//  Created by kernelnr on 13-5-23.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ep_uinavigation.h"
#import "pay_pattern_subview.h"
#import "pay_form_of_alipay_subview.h"
#import "pay_form_of_yeepay_subview.h"
#import "pay_form_of_jx_subview.h"
#import "pay_form_of_yl_subview.h"
#import "pay_form_of_dx_subview.h"

@interface pay_view : UIViewController <_pay_pattern_delegate, _pay_form_of_alipay_delegate, _pay_form_of_yeepay_delegate, _pay_form_of_jx_delegate, UIScrollViewDelegate>
{
    pay_pattern_subview *_pay_pattern_subview;
    pay_form_of_yeepay_subview *_pay_form_of_yeepay_subview;
    pay_form_of_alipay_subview *_pay_form_of_alipay_subview;
    pay_form_of_jx_subview *_pay_form_of_jx_subview;
    pay_form_of_yl_subview *_pay_form_of_yl_subview;
    pay_form_of_dx_subview *_pay_form_of_dx_subview;
    
    CGRect _rect_left, _rect_right;
    
    ep_uinavigation *_ep_uinavigation;
    
    UIView *_payts_alertview, *_paysucceed_alertview;
}

@property (nonatomic, retain) NSDictionary *_payment_info_dic;

- (void)_alipay_result:(int)_result;

@end

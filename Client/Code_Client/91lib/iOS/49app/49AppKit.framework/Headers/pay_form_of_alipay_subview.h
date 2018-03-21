//
//  pay_form_of_alipay_subview.h
//  49App
//
//  Created by kernelnr on 13-5-24.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _pay_form_of_alipay_delegate;
@interface pay_form_of_alipay_subview : UIView
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_pay_form_of_alipay_delegate> __pay_form_of_alipay_delegate;
@property (nonatomic, retain) NSDictionary *_payment_info_dic;

+ (pay_form_of_alipay_subview *)_self;
- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (BOOL)isSingleTask;
- (void)parseURL:(NSURL *)url;

@end

@protocol _pay_form_of_alipay_delegate <NSObject>
    - (void)_alipay_result:(int)_result;
@end

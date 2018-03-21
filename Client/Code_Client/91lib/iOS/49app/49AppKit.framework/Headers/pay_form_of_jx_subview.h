//
//  pay_form_of_jx_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-8-12.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _pay_form_of_jx_delegate;
@interface pay_form_of_jx_subview : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *_cardid_textfield;
    UITextField *_cardpass_textfield;
    
    /* transform */
    CGAffineTransform textloadview_transform;
    
    UIView *_cardtype_alertview;
}

@property (nonatomic, assign) id <_pay_form_of_jx_delegate> __pay_form_of_jx_delegate;
@property (nonatomic, retain) NSDictionary *_payment_info_dic;
@property (nonatomic, retain) NSMutableArray *_marr_cardtypelog;
@property (nonatomic, retain) NSString *_cardtype;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_load_data;

@end

@protocol _pay_form_of_jx_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField withParentView:(UIView *)viewParent;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (void)_jxpay_succeed:(NSString *)_result;
@end

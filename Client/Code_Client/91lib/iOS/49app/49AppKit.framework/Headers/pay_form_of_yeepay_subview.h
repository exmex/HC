//
//  pay_form_of_yeepay_subview.h
//  49App
//
//  Created by kernelnr on 13-5-23.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _pay_form_of_yeepay_delegate;
@interface pay_form_of_yeepay_subview : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *_cardrmb_textfield;
    UITextField *_cardid_textfield;
    UITextField *_cardpass_textfield;
    
    /* transform */
    CGAffineTransform textloadview_transform;
    
    UIView *_rmb_alertview, *_cardtype_alertview;
}

@property (nonatomic, assign) id <_pay_form_of_yeepay_delegate> __pay_form_of_yeepay_delegate;
@property (nonatomic, retain) UITableView *_rmblog_tableview;
@property (nonatomic, retain) NSMutableArray *_marr_typelog;
@property (nonatomic, retain) NSDictionary *_payment_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;

@end

@protocol _pay_form_of_yeepay_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField withParentView:(UIView *)viewParent;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (void)_yeepay_succeed:(NSString *)_result;
@end

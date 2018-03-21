//
//  bound_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-11-19.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _bound_delegate;
@interface bound_subview : UIView <UITextFieldDelegate>
{
    UITextField *_zh_textfield;
    UITextField *_sjhm_textfield;
    UITextField *_yzm_textfield;
}

@property (nonatomic, assign) id <_bound_delegate> __bound_delegate;

- (void)_update_userid:(NSString *)_userid;
- (NSString *)_get_userid;

@end

@protocol _bound_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_hqyzm_action;
    - (void)_bound2fh_action;
    - (void)_bound2qd_action;
@end

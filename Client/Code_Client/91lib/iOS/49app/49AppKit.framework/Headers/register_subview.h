//
//  register_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-24.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _register_delegate;
@interface register_subview : UIView <UITextFieldDelegate>
{
    UITextField* _userid_textfield;
    UITextField* _userpass_textfield;
}

@property (nonatomic, assign) id <_register_delegate> __register_delegate;

@end

@protocol _register_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_ljregister_action;
    - (void)_register2login_action;
@end

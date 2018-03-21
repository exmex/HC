//
//  modify_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-25.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zmd_uilabel.h"
#import "ep_uilabel.h"

@protocol _modify_delegate;
@interface modify_subview : UIView <UITextFieldDelegate>
{
    UITextField* _oldpass_textfield;
    UITextField* _newpass_textfield;
    
    ep_uilabel *_userid_label;
}

@property (nonatomic, assign) id <_modify_delegate> __modify_delegate;

- (void)_update_userid:(NSString *)_userid;
- (NSString *)_get_userid;
- (void)_update_userpass:(NSString *)_userpass;
- (NSString *)_get_userpass;

@end

@protocol _modify_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_commit_action;
    - (void)_modify2login_action;
@end

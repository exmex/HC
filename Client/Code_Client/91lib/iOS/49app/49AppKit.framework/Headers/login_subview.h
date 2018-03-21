//
//  login_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-23.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ep_uilabel.h"
#import "zmd_uilabel.h"

@protocol _login_delegate;
@interface login_subview : UIView <UITextFieldDelegate, _epuilabel_delegate>

@property (nonatomic, assign) id <_login_delegate> __login_delegate;
@property (nonatomic, assign) UITextField* _userid_textfield;
@property (nonatomic, assign) UITextField* _userpass_textfield;
@property (nonatomic, retain) NSDictionary *_main_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_update_userid:(NSString *)_userid;
- (void)_update_userpass:(NSString *)_userpass;

@end

@protocol _login_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_xgpass_action;
    - (void)_wjpass_action;
    - (void)_ljlogin_action;
    - (void)_quicklogin_action;
    - (void)_qwregister_action;
    - (void)_bdmobile_action;
    - (void)_xzkhd_action;
@end

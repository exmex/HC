//
//  jcbound_subview.h
//  49AppKit
//
//  Created by 14zyNR on 13-11-21.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _jcbound_delegate;
@interface jcbound_subview : UIView <UITextFieldDelegate>
{
    UITextField *_zh_textfield;
    UITextField *_sjhm_textfield;
    UITextField *_yzm_textfield;
}

@property (nonatomic, assign) id <_jcbound_delegate> __jcbound_delegate;

- (void)_update_userid:(NSString *)_userid;
- (NSString *)_get_userid;
- (void)_update_mobile:(NSString *)_mobile;
- (NSString *)_get_mobile;

@end

@protocol _jcbound_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_jchqyzm_action;
    - (void)_jcbound2fh_action;
    - (void)_jcbound2qd_action;
@end

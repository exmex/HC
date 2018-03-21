//
//  found_subview.h
//  49AppKit
//
//  Created by 14zyNR on 13-11-21.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _found_delegate;
@interface found_subview : UIView <UITextFieldDelegate>
{
    UITextField *_zh_textfield;
}

@property (nonatomic, assign) id <_found_delegate> __found_delegate;
@property (nonatomic) int _from;

- (void)_update_userid:(NSString *)_userid;
- (NSString *)_get_userid;

@end

@protocol _found_delegate <NSObject>
    - (void)textFieldDidBeginEditing:(UITextField *)textField;
    - (void)textFieldDidEndEditing:(UITextField *)textField;
    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
    - (BOOL)textFieldShouldClear:(UITextField *)textField;
    - (BOOL)textFieldShouldReturn:(UITextField *)textField;
    - (void)_found2fh_action;
    - (void)_found2qd_action;
@end

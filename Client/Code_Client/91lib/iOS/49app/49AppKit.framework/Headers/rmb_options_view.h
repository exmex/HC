//
//  rmb_options_view.h
//  49App
//
//  Created by kernelnr on 13-5-30.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rmb_options_view : UIViewController <UITextFieldDelegate>
{
    UITextField* _rmb_textfield;
    UILabel *_rmb_title_2;
    
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, retain) NSMutableDictionary *_rmboption_info_dic;

@end

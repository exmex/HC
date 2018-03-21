//
//  quicklogin_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zmd_uilabel.h"

@protocol _quicklogin_delegate;
@interface quicklogin_subview : UIView
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, assign) id <_quicklogin_delegate> __quicklogin_delegate;
@property (nonatomic, retain) NSMutableArray *_marr_userinfo;
@property (nonatomic) int _focus_userlogtag;
@property (nonatomic, retain) NSDictionary *_main_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_set_focususerlog:(int)_index;

@end

@protocol _quicklogin_delegate <NSObject>
    - (void)_userlog_action:(int)_index;
    - (void)_quickloginselect_action;
    - (void)_qwlogin_action;
@end

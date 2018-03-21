//
//  pay_form_of_dx_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-8-15.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pay_form_of_dx_subview : UIView <UITableViewDataSource, UITableViewDelegate>
{
    /* transform */
    CGAffineTransform textloadview_transform;
    
    UIView *_cardtype_alertview;
}

@property (nonatomic, retain) NSDictionary *_payment_info_dic;
@property (nonatomic, retain) NSMutableArray *_marr_cardtypelog;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;
- (void)_load_data;

@end

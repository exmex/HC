//
//  pay_pattern_subview.h
//  49App
//
//  Created by kernelnr on 13-5-23.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _pay_pattern_delegate;
@interface pay_pattern_subview : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_pay_tableview;
}

@property (nonatomic, assign) id <_pay_pattern_delegate> __pay_pattern_delegate;
@property (nonatomic, retain) NSMutableArray *_marr_payment_pattern;
@property (nonatomic, retain) NSMutableArray *_marr_cell;

- (id)initWithFrame:(CGRect)frame withPaymentPattern:(NSArray *)marr_payment_pattern;
- (void)_set_payment_pattern:(NSMutableArray *)__marr_payment_pattern;

@end

@protocol _pay_pattern_delegate <NSObject>
    - (void)_select_indexpath_row:(NSIndexPath *)__index_path;
@end

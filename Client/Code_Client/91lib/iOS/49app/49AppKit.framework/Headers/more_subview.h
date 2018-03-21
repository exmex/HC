//
//  more_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol _more_delegate;
@interface more_subview : UIView < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, assign) id <_more_delegate> __more_delegate;
@property (nonatomic, retain) UITableView *_49more_tableview;
@property (nonatomic, retain) NSMutableArray *_marr_appdata;
@property (nonatomic, retain) NSMutableArray *_marr_cell;

@end

@protocol _more_delegate <NSObject>
    - (void)_more_select:(NSIndexPath *)_indexPath;
@end

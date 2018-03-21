//
//  gift_subview.h
//  49AppKit
//
//  Created by 14zynr on 13-7-26.
//  Copyright (c) 2013年 __jc_49app__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyimage_view.h"
#import "PullingRefreshTableView.h"

@interface gift_subview : asyimage_view < UIScrollViewDelegate, _asyimage_delegate, PullingRefreshTableViewDelegate >
{
    /* transform */
    CGAffineTransform textloadview_transform;
}

@property (nonatomic, retain) PullingRefreshTableView *_49gift_tableview;
@property (nonatomic, retain) NSMutableArray *_marr_appdata;
@property (nonatomic) BOOL _refreshing;
@property (nonatomic, retain) NSMutableArray *_marr_cell;
@property (nonatomic, retain) NSDictionary *_main_info_dic;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)_info_dic;

@end

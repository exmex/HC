//
//  UserListView.h
//  com4lovesSDK
//
//  Created by fish on 13-8-30.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol userListDelegate <NSObject>
-(void)hideListViewUser:(NSString*)name andPassWord:(NSString*)password;
@end

@interface UserListView : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, assign) id<userListDelegate> delegate;

//- (IBAction)goBack:(id)sender;

-(void) refresh;

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

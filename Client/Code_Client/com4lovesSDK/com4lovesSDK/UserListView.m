//
//  UserListView.m
//  com4lovesSDK
//
//  Created by fish on 13-8-30.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "UserListView.h"
#import "ServerLogic.h"
#import "com4lovesSDK.h"
#import "SDKUtility.h"
#import "YouaiUser.h"
#import "SDKEncrypt.h"

@interface UserListView ()
{
    NSMutableArray * listData;
 //   IBOutlet UILabel *lableTitle;
 //   IBOutlet UIButton *btnCancle;
}
@property (retain, nonatomic) IBOutlet UIImageView *backGroundView;
@end

@implementation UserListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setEditing:YES];
//    [lableTitle setText:[com4lovesSDK getLang:@"userlist_title"]];
//    [btnCancle setTitle:[com4lovesSDK getLang:@"userlist_cancle"] forState:UIControlStateNormal];
//    [btnCancle setTitle:[com4lovesSDK getLang:@"userlist_cancle"] forState:UIControlStateSelected];
//    [btnCancle setTitle:[com4lovesSDK getLang:@"userlist_cancle"] forState:UIControlStateHighlighted];
//    
    CALayer *layer = self.backGroundView.layer;
    layer.cornerRadius = 3;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)goBack:(id)sender {
//    //YALog(@"goback");
//    //[self removeFromParentViewController];
//    [self.view removeFromSuperview];
//}

-(void) refreshResp
{
    NSDictionary* dic = [[ServerLogic sharedInstance] getUserList];
    NSArray *values = [dic allValues];
    listData = [[NSMutableArray alloc] initWithCapacity:[dic count]];
    for (YouaiUser *user in values) {
        if (user.userType!=2) {
            [listData addObject:user.youaiId];
        }
    }
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    [[SDKUtility sharedInstance] setWaiting:NO];
}
-(void) refresh
{
    [[SDKUtility sharedInstance] setWaiting:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshResp) userInfo:nil repeats:NO] ;
}
//返回总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(listData == nil){
        [self refresh];
    }
     return [listData count ];
}

// 添加每一行的信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(listData == nil)  [self refresh];
    
    NSString *tag=@"tag";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tag];
    
    if (cell==nil ) {
        //cell=[[[ UITableViewCell alloc ] initWithFrame : CGRectZero                                        reuseIdentifier:tag] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tag] autorelease];
    }
    
    NSUInteger row=[indexPath row];
    
    //设置文本
//    NSString* fullpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"com4lovesBundle.bundle"]
//                                                         ofType:nil
//                                                    inDirectory:[NSString stringWithUTF8String:""]];
//    NSBundle *buddle = [NSBundle bundleWithPath:fullpath];
//    //NSBundle *buddle = [NSBundle bundleWithIdentifier:@"com.loves.com4lovesBundle"];
//    [buddle load];
//    
//    NSString* fullpath1 = [buddle pathForResource:@"accountIcon.png"
//                                           ofType:nil
//                                      inDirectory:@""];
//    UIImage* img =  [[UIImage alloc] initWithContentsOfFile:fullpath1];
//    [cell.imageView setImage:img];
    NSString* cellname = [listData objectAtIndex :row];
    YouaiUser *user = [[[ServerLogic sharedInstance] getUserList] objectForKey:cellname];
    cellname = user.name;
    NSString* defaultname = [[ServerLogic sharedInstance] getLatestUser];
    if ([cellname isEqualToString:defaultname]) {
            [cell.detailTextLabel setText:[com4lovesSDK getLang:@"defualt"]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.8]];
    }
    else
    {
        [cell.detailTextLabel setText:@""];
    }
    [cell.textLabel setText:@""];
    //[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    
    UIButton *downbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downbutton setFrame:CGRectMake(0, 5, 160, 30)];
    [downbutton setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = [UIColor clearColor];
    [downbutton setTitle:cellname forState:UIControlStateNormal];
    
    [downbutton setTag:indexPath.row];
    
    [downbutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [downbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    while ([cell.contentView.subviews count]>0) {
        [[cell.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    [cell.contentView addSubview:downbutton];
    
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    //选中后的颜色又不发生改变，进行下面的设置
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //不需要分割线
    //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    return cell;
    
}
-(void)buttonclick:(id)sender
{
    int row = [sender tag];
    NSString* theKey = [listData objectAtIndex:row];
    YouaiUser *user = [[[ServerLogic sharedInstance] getUserList] objectForKey:theKey];
    [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:LatestUserUserDefault];

    [[NSUserDefaults standardUserDefaults] setObject:[[SDKEncrypt sharedInstance] base64Encrypt:user.password] forKey:LatestUserUserPasswordDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.delegate)
        [self.delegate hideListViewUser:user.name andPassWord:user.password];
   // [self.view removeFromSuperview];
   // [[com4lovesSDK sharedInstance]showLogin];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* theKey = [listData objectAtIndex:row];
        NSMutableDictionary*dic = [[ServerLogic sharedInstance] getUserList];
        [dic removeObjectForKey: theKey];
        
        if([theKey isEqualToString:[[ServerLogic sharedInstance] getLatestUser]])
        {
            [[com4lovesSDK sharedInstance] clearLoginInfo];
        }
        [[ServerLogic sharedInstance] updateUserList];
        listData = [NSMutableArray arrayWithArray:[dic allKeys]];

        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [self refresh];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString* theKey = [listData objectAtIndex:row];
    YouaiUser *user = [[[ServerLogic sharedInstance] getUserList] objectForKey:theKey];

    [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:LatestUserUserDefault];
    [[NSUserDefaults standardUserDefaults] setObject:[[SDKEncrypt sharedInstance] base64Encrypt:user.password] forKey:LatestUserUserPasswordDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.delegate)
       [self.delegate hideListViewUser:user.name andPassWord:user.password];
   // [self.view removeFromSuperview];
   // [[com4lovesSDK sharedInstance]showLogin];
}
- (void)dealloc {
  //  [lableTitle release];
  //  [btnCancle release];
 //   [_backGroundView release];
    [super dealloc];
}
- (void)viewDidUnload {
 //   [lableTitle release];
 //   lableTitle = nil;
 //   [btnCancle release];
 //   btnCancle = nil;
    [self setBackGroundView:nil];
    [super viewDidUnload];
}
@end

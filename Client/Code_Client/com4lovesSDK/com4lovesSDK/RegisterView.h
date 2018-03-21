//
//  ViewController.h
//  test3
//
//  Created by fish on 13-8-21.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    //以下是枚举成员
    styleRegister = 0,
    stylePositive,
    sytleBingding,
} RegisterViewStyle;

@interface RegisterView : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *selectImageView;


- (IBAction)gobackLogin:(id)sender;
- (IBAction)click:(id)sender;
- (IBAction)didEnd:(id)sender;
- (IBAction)initEmail:(id)sender;
- (void)initWithViewStyle:(RegisterViewStyle)style;
- (IBAction)selectUserAgreement:(id)sender;
- (IBAction)gotoUserAgreement:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton* button;
//@property (nonatomic, retain) IBOutlet UIView* frame;
@property (nonatomic, retain) IBOutlet UITextField *plainTextField;
@property (nonatomic, retain) IBOutlet UITextField *secretTextField;
//@property (retain, nonatomic) IBOutlet UILabel *viewTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;

@property (nonatomic,assign) BOOL bSelected;
@property (nonatomic,copy)   NSString *agreeImagePath;
@property (nonatomic,copy)   NSString *disAgreeImagePath;

@end


#include "libOS.h"
#import "libOSObj.h"



@implementation libOSObj

- (id)init
{
    CGRect rect = [UIScreen mainScreen].applicationFrame; //获取屏幕大小
    waitView = [[UIActivityIndicatorView alloc] initWithFrame:rect];//定义图标大小，此处为32x32
    [waitView setCenter:CGPointMake(rect.size.width/2,rect.size.height/2)];//根据屏幕大小获取中心点
    [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置图标风格，采用灰色的，其他还有白色设置
    [waitView setBackgroundColor:[ UIColor colorWithWhite: 0.0 alpha: 0.5 ]];
    if ([[UIDevice currentDevice] systemVersion].floatValue<=4.4) {
        [waitView setBounds:CGRectMake(0, 0, 50, 50)];
    }
    //[self.view addSubview:waitView];//添加该waitView
    [[[UIApplication sharedApplication] keyWindow] addSubview:waitView];
    
    return [super init];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView) {
        
        NSString* str = nil;
        
        NSString * sysVersion = [[UIDevice currentDevice] systemVersion];
        
        
        float sysFloat = [sysVersion floatValue];
        
        
        if ( sysFloat >= 7.0 )
        {
            //如果不是输入框类型的AlertView，则不处理

            
            @try {
                UITextField * textFiled = [alertView textFieldAtIndex:0];
                
                str = [textFiled text];

            }
            @catch (NSException *exception) {
                str = nil;
            }
            @finally {
                
            }
                        
            
        }
        else
        {
            
            UITextField* txtf = (UITextField *)[alertView viewWithTag:1001];
            if (txtf) {
                str = [txtf text];
            }
            else
            {
                UITextView* txtv = (UITextView *)[alertView viewWithTag:1002];
                if(txtv)
                {
                    str = [txtv text];
                }
                
            }
        }
        
        
        static std::string outstr;
        if(str!=nil)
        {
            
            outstr = ([str UTF8String]);
            libOS::getInstance()->_boardcastInputBoxOK(outstr);
        }
        else
        {
            libOS::getInstance()->_boardcastMessageboxOK([alertView tag]);
        }
        
    }
}

-(void) showWait
{
    if(waitView)[waitView startAnimating];
}
-(void) hideWait;
{
    if(waitView)[waitView stopAnimating];
}

@end

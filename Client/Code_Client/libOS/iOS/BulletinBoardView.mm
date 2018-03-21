
#import <string>
#import "BulletinBoardView.h"
#import "BulletinBoardPage.h"

#define kUserLoginInfoFileName @"userLoginInfoFile"
#define kLoginStatusSucceed YES
#define kLoginStatusFailed  NO

@implementation BulletinBoardView

@synthesize m_webView;
@synthesize navBar;
@synthesize canselItem;
@synthesize canselBtn;
@synthesize imageView;
@synthesize button;
@synthesize webKitDelegate;
@synthesize shouldLoadRequest;
@synthesize webTile;
@synthesize HUD;
@synthesize timer;
@synthesize isClose;
@synthesize loadingTimeOut;
#define VIEW_HEIGHT 916
#define VIEW_WIDTH  564
#define VIEW_HEIGHT_PAD 974
#define VIEW_WIDTH_PAD  664

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

- (id)initWithFrame:(CGRect)frame isNavBarHiden:(BOOL)isNavBarHiden
{
    CGRect screen = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;
    self = [super initWithFrame:screen];
    self.center = CGPointMake(screen.size.width/2,screen.size.height/2);
    isClose = FALSE;
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"Creat a webKit!");
        shouldLoadRequest = YES;
        webKitDelegate = NULL;
        timer = nil;
       //init background imageview
        UIImage *image = [UIImage imageNamed:@"loadingScene/u_announcement.png"];
        imageView = [[UIImageView alloc] initWithImage:image];
        CGRect webviewFrame;
        CGRect buttonFrame;
        if(isPad == true){
            [imageView setFrame:CGRectMake(0, 0, VIEW_WIDTH_PAD, VIEW_HEIGHT_PAD)];
            webviewFrame = CGRectMake(38, 80, 585, 705);
            buttonFrame = CGRectMake((VIEW_WIDTH_PAD-332/2)/2, VIEW_HEIGHT_PAD-115,  332/2, 142/2);
        }else{
            [imageView setFrame:CGRectMake(0, 0, VIEW_WIDTH/2, VIEW_HEIGHT/2)];
            webviewFrame = CGRectMake(18, 40, 490/2, 330);
            buttonFrame = CGRectMake((VIEW_WIDTH/2-332/4)/2, VIEW_HEIGHT/2-55, 332/4, 142/4);
        }
        imageView.center = CGPointMake(screen.size.width/2,screen.size.height/2);
        [self addSubview:imageView];
        
        //init webview
        m_webView = [[UIWebView alloc] initWithFrame:webviewFrame];
        m_webView.opaque = NO;  //alph = 0
        m_webView.backgroundColor = [UIColor clearColor];
        m_webView.delegate = self;
        m_webView.scalesPageToFit = YES;
        [m_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [m_webView setAllowsInlineMediaPlayback:YES];
        [imageView addSubview:m_webView];
        [imageView setUserInteractionEnabled:YES];
        
        //init ok button
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        UIImage *image1 = [UIImage imageNamed:@"loadingScene/u_announcementB.png"];
        [button setBackgroundImage:image1 forState:UIControlStateNormal];
        UIImage *image2 = [UIImage imageNamed:@"loadingScene/u_announcementC.png"];
        [button setBackgroundImage:image2 forState:UIControlStateSelected];
        [button addTarget:self action:@selector(canselBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
        
        //show view
        HUD = [[MBProgressHUD alloc] initWithView:self];
        HUD.labelText = @"操作成功";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = self;  //设置自定义view
        [HUD show:YES];

        loadingTimeOut = 50;

        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ALSystemConfig" ofType:@"plist"];
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
        if(dict) {
            NSString* value = [dict valueForKey:@"loadingTimeOut"];
            if (value) {
                loadingTimeOut = [value integerValue];
            }
            else {
                NSLog(@"Cannot find value for loadingTimeOut, loadingTimeOut will be set to 50");
            }
        }
        else {
            NSLog(@"Cannot Find  ALSystemConfig.plist, loadingTimeOut will be set to 50");
        }
        NSLog(@"loadingTimeOut = %d",loadingTimeOut);
        
        //[self addObservers]; 

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    if (mOrientation == ALSystem::WK_OrientationDefualt) {
//        return;
//    }

    //[self rotateViewToOrientation:mOrientation];
}

- (void) canselBtnAction:(id)sender
{
    if (timer) {
        if ([timer isValid] == TRUE) {
            [timer invalidate];
        }
        timer = nil;
    }    
    if (webKitDelegate != NULL) {
        webKitDelegate->onBtnAction();
    }
}

- (void)webViewOpenURL:(NSString *)URL
{
  //  URL = @"http://203.195.181.90/shengdoushi_dev/1.1.0/android_1.2/web.html";
    //[targetURL setString:URL];
    //if (webKitDelegate != NULL) {
    [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
#ifdef PROJECTITools
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(delayShow) userInfo:nil repeats:NO];
#endif
}

-(void)delayShow
{
    if (isClose) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view bringSubviewToFront:self];
    [self setHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{      
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"WebKit will open URL: %@",requestString);    
    //[preChangeURL setString:targetURL];
    //[targetURL setString:requestString];
    //std::string stdPreChangeURL([preChangeURL UTF8String]);
    //std::string stdTargetURL([targetURL UTF8String]);
    //if (webKitDelegate != NULL) {
    //    webKitDelegate->onWebKitWillChangeURL(stdPreChangeURL, stdTargetURL);
    //}
    return shouldLoadRequest;
}
- (void)timeOut
{
    [m_webView stopLoading];

    [HUD hide:NO];
    [self closeTimer];
    
    const std::string stdErrorStr("WebKit loading time out!");
    NSLog(@"WebKit loading time out! %d seconds", loadingTimeOut);
    if (webKitDelegate != NULL) {
        webKitDelegate->onLoadingTimeOut();
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [HUD show:NO];
    [self closeTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)loadingTimeOut target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    //if (m_bIsNavBarNeedHide) {
    //    if (m_bIsNavBarHidden) {
    //        [self webKitShowNavigationBar];
    //    }
    //}
    if (webKitDelegate != NULL) {
        webKitDelegate->onStartLoad();
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{    
    [HUD hide:NO];
    [self closeTimer];
    //if (m_bIsNavBarNeedHide) {
    //    if (!m_bIsNavBarHidden) {
    //        [self webKitHideNavigationBar];
    //    }
    //}

    if (webKitDelegate != NULL) {
        webKitDelegate->onFinishLoad();
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HUD hide:NO];
    [self closeTimer];

    if (webKitDelegate != NULL) {        
        NSString* errorStr = [NSString stringWithString:[error description]];
        const std::string stdErrorStr([errorStr UTF8String]);
        webKitDelegate->onFailLoadWithError(stdErrorStr);
    }
}

- (void)webViewEvaluatingJavaScriptFromString:(NSString *)jsString
{
    if (m_webView != NULL) {
        [m_webView stringByEvaluatingJavaScriptFromString:jsString];  
    }
}

- (void)closeTimer
{
    if (timer) {
        if ([timer isValid] == TRUE) {
            [timer invalidate];
        }
        timer = nil;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	if([touch tapCount]>0)
	{
	}
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint  lastpoint = [touch locationInView:self];
}


- (void) dealloc
{
    NSLog(@"Close a webKit!");
    webKitDelegate = NULL;
    [HUD release]; HUD = nil;
    //[targetURL release]; targetURL = nil;
    //[preChangeURL release]; preChangeURL = nil;
    [navBar release]; navBar = nil;
    [canselItem release]; canselItem = nil;
    [canselBtn release]; canselBtn = nil;
    [m_webView release]; m_webView = nil;
    [imageView release]; imageView = nil;
    [super dealloc];
}

@end
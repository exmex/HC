
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

class BulletinBoardPageListener;

@interface BulletinBoardView : UIView <UIWebViewDelegate,MBProgressHUDDelegate>
{
    UIWebView* m_webView;
    UINavigationBar* navBar;
    UINavigationItem* canselItem;
    UIBarButtonItem* canselBtn;
    UIImageView* imageView;
    UIButton* button;
    BulletinBoardPageListener *webKitDelegate;
    bool shouldLoadRequest;
    NSMutableString* webTile;
    MBProgressHUD* HUD;
    NSTimer* timer;
    NSInteger loadingTimeOut;
}
@property(nonatomic,retain) UIWebView* m_webView;
@property(nonatomic,retain) UINavigationBar* navBar;
@property(nonatomic,retain) UINavigationItem* canselItem;
@property(nonatomic,retain) UIBarButtonItem* canselBtn;
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UIButton* button;
@property(readwrite) BulletinBoardPageListener *webKitDelegate;
@property(readwrite) bool shouldLoadRequest;
@property(nonatomic,retain) NSMutableString* webTile;
@property(nonatomic,retain) MBProgressHUD* HUD;
@property(nonatomic, retain) NSTimer* timer;
@property(nonatomic, assign) NSInteger loadingTimeOut;
@property(nonatomic, assign) BOOL isClose;



- (id)initWithFrame:(CGRect)frame isNavBarHiden:(BOOL)isNavBarHiden;
- (void)webViewOpenURL:(NSString *)URL;
- (void)closeTimer;

@end

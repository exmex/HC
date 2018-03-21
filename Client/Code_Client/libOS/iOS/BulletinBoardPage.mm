
#import <string>
#import "BulletinBoardPage.h"
#import "BulletinBoardView.h"
#import <iostream>

BulletinBoardPage* BulletinBoardPage::mInstance = 0;

BulletinBoardView* pBulletinBoardView = 0;

void BulletinBoardPage::init(float left,float top, float width, float height, BulletinBoardPageListener *listener)
{
    close();
    
    pBulletinBoardView = [[BulletinBoardView alloc] initWithFrame:CGRectMake(left, top, width, height) isNavBarHiden:NO];
    pBulletinBoardView.webKitDelegate = listener;
#ifndef PROJECTITools
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:pBulletinBoardView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view bringSubviewToFront:pBulletinBoardView];
#endif
}

/*
void BulletinBoardPage::show()
{
    if (pBulletinBoardView == nil) {
        std::cout<<"Webview does not open, cancel open URL: "<<std::endl;
        return;
    }
    std::string url = "www.mxhzw.com";
    [pBulletinBoardView webViewOpenURL:[NSString stringWithCString:url.c_str() encoding:[NSString defaultCStringEncoding]]];
}
*/
void BulletinBoardPage::show(const std::string& url)
{
    if (pBulletinBoardView == nil) {
        std::cout<<"Webview does not open, cancel open URL: "<<url<<std::endl;
        return;
    }
    [pBulletinBoardView webViewOpenURL:[NSString stringWithCString:url.c_str() encoding:[NSString defaultCStringEncoding]]];
}

void BulletinBoardPage::close()
{
    if (pBulletinBoardView != nil) {
        [pBulletinBoardView setIsClose:TRUE];
        pBulletinBoardView.webKitDelegate = NULL;
        [pBulletinBoardView closeTimer];
        [pBulletinBoardView removeFromSuperview];
        [pBulletinBoardView release];
        pBulletinBoardView = nil;
    }
}

void BulletinBoardPage::webKitSetLoadingTimeOut(int seconds)
{
    if (pBulletinBoardView) {
        pBulletinBoardView.loadingTimeOut = seconds;
    }
}


#include "main.h"
#include "AppDelegate.h"
#include "cocos2d.h"

USING_NS_CC;

// uncomment below line, open debug console
#ifdef DEBUG
#define USE_WIN32_CONSOLE
#endif

int APIENTRY _tWinMain(HINSTANCE hInstance,
                       HINSTANCE hPrevInstance,
                       LPTSTR    lpCmdLine,
                       int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

#ifdef WIN32
    AllocConsole();
    freopen("CONIN$", "r", stdin);
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
#else
	freopen(".\\game.log", "r", stdin);
	freopen(".\\game.log", "w", stdout);
	freopen(".\\game.log", "w", stderr);
#endif

    // create the application instance
    AppDelegate app;
    CCEGLView* eglView = CCEGLView::sharedOpenGLView();
    eglView->setViewName("League Of Champions");
	eglView->setFrameSize(960, 640);

    int ret = CCApplication::sharedApplication()->run();

#ifdef WIN32
    FreeConsole();
#endif

    return ret;
}

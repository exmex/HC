/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "CCCommon.h"

#include <stdarg.h>
#include <stdio.h>

#ifdef COCOS2D_DEBUG
#include <sys/time.h>
#endif
#import <UIKit/UIAlert.h>
#include "CCFileUtils.h"
NS_CC_BEGIN

class AutoReleaseLog
{
	FILE *g_fpLog;
	static AutoReleaseLog* sLog;
public:
	
	AutoReleaseLog()
	{
        std::string path = cocos2d::CCFileUtils::sharedFileUtils()->getWritablePath();
		g_fpLog = fopen((path+"/game.log").c_str(), "a+");
		fprintf(g_fpLog,"Game started!\n");
	}
	~AutoReleaseLog()
	{
		fprintf(g_fpLog,"Game closed!\n\n");
		fclose(g_fpLog);
	}
	void Log(char* log)
	{
		time_t t = time(0); 
		char tmp[64]; 
		strftime( tmp, sizeof(tmp), "%Y/%m/%d %X",localtime(&t) ); 
		fprintf(g_fpLog,"%s\t\t",tmp);
		fprintf(g_fpLog,"%s\n",log);
		fflush(g_fpLog);
	}
	static AutoReleaseLog& getInstance(){
        if(sLog)
            return *sLog;
        else
        {
            sLog = new AutoReleaseLog;
            return *sLog;
        }
    }
};

AutoReleaseLog* AutoReleaseLog::sLog = 0;

void CCLog(const char * pszFormat, ...)
{
#ifdef COCOS2D_DEBUG
    struct timeval tv;
    gettimeofday(&tv,NULL);
    printf(" %ld.%d | Cocos2d: ",tv.tv_sec,tv.tv_usec / 1000);
#else
    printf(" Cocos2d: ");
#endif
    char szBuf[kMaxLogLen+1] = {0};
    va_list ap;
    va_start(ap, pszFormat);
    vsnprintf(szBuf, kMaxLogLen, pszFormat, ap);
    va_end(ap);
    printf("%s", szBuf);
    printf("\n");
	
	AutoReleaseLog::getInstance().Log(szBuf);
}

// ios no MessageBox, use CCLog instead
void CCMessageBox(const char * pszMsg, const char * pszTitle)
{
    NSString * title = (pszTitle) ? [NSString stringWithUTF8String : pszTitle] : nil;
    NSString * msg = (pszMsg) ? [NSString stringWithUTF8String : pszMsg] : nil;
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle: title
                                                          message: msg
                                                         delegate: nil
                                                cancelButtonTitle: @"OK"
                                                otherButtonTitles: nil];
    [messageBox autorelease];
    [messageBox show];
	CCLog("%s! %s",pszTitle,pszMsg);
}

void CCLuaLog(const char * pszFormat)
{
#ifdef COCOS2D_DEBUG
    struct timeval tv;
    gettimeofday(&tv,NULL);
    printf(" %ld.%d | LuaEngine: ",tv.tv_sec,tv.tv_usec / 1000);
#else
    printf(" LuaEngine: ");
#endif
    puts(pszFormat);
}

NS_CC_END

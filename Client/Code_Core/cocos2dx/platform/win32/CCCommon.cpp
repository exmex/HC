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
#include "platform/CCCommon.h"
#include "CCStdC.h"
#include <sys/timeb.h>

NS_CC_BEGIN
//--context difference from version 2.1.3 at com4loves@2013
#define MAX_LEN         (cocos2d::kMaxLogLen + 1)

class AutoReleaseLog
{
	FILE *g_fpLog;
	static AutoReleaseLog sLog;
public:
	
	AutoReleaseLog()
	{
		g_fpLog = fopen("game.log", "a+");
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
	static AutoReleaseLog& getInstance(){return sLog;}
};

AutoReleaseLog AutoReleaseLog::sLog;



static const int k_cclog_buff_len = 128 * 1024;
static char s_szBuf[k_cclog_buff_len];
static WCHAR s_wszBuf[k_cclog_buff_len] = {0};
void CCLog(const char * pszFormat, ...)
{
	//
	memset(s_szBuf, 0, sizeof(s_szBuf));
	memset(s_wszBuf, 0, sizeof(s_wszBuf));

    va_list ap;
    va_start(ap, pszFormat);
    vsnprintf_s(s_szBuf, k_cclog_buff_len, k_cclog_buff_len, pszFormat, ap);
    va_end(ap);
	
	//add by xinghui
	char tmp[64];
	struct timeb t1;
	ftime(&t1);
	strftime(tmp,sizeof(tmp),"%X",localtime(&t1.time));
	printf("%s.%.3d | Cocos2d:",tmp, t1.millitm);
// 	long second = t1.time;
// 	int millSecond = t1.millitm; 	
// 	printf("%ld.%d | Cocos2d: ", second, millSecond);
    
    MultiByteToWideChar(CP_UTF8, 0, s_szBuf, -1, s_wszBuf, sizeof(s_wszBuf));
    OutputDebugStringW(s_wszBuf);
    OutputDebugStringA("\n");

    WideCharToMultiByte(CP_ACP, 0, s_wszBuf, sizeof(s_wszBuf), s_szBuf, sizeof(s_szBuf), NULL, FALSE);
    printf("%s\n", s_szBuf);

	AutoReleaseLog::getInstance().Log(s_szBuf);
	/*
#ifdef DEBUG
	if (strlen(s_szBuf) > 3)
	{
		char* p = s_szBuf;
		while (*p != '\0')
		{
			if (*p == '.' && *(p+1) == 'l' && *(p+2) == 'u' && *(p+3) == 'a')
			{
				MessageBoxA(NULL, s_szBuf, ".lua error", MB_OK);
				break;
			}
			++p;
		}
	}
#endif
	*/

}

void CCMessageBox(const char * pszMsg, const char * pszTitle)
{
    MessageBoxA(NULL, pszMsg, pszTitle, MB_OK);
	CCLog("%s! %s",pszTitle,pszMsg);
}

void CCLuaLog(const char *pszMsg)
{

	//add by xinghui
	char tmp[64];
	struct timeb t1;
	ftime(&t1);
	strftime(tmp,sizeof(tmp),"%X",localtime(&t1.time));
	printf("%s.%.3d | Cocos2d:",tmp, t1.millitm);
// 	long second = t1.time;
// 	int millSecond = t1.millitm;
// 	printf("%ld.%d | LuaEngine: ", second, millSecond);

    int bufflen = MultiByteToWideChar(CP_UTF8, 0, pszMsg, -1, NULL, 0);
    WCHAR* widebuff = new WCHAR[bufflen + 1];
    memset(widebuff, 0, sizeof(WCHAR) * (bufflen + 1));
    MultiByteToWideChar(CP_UTF8, 0, pszMsg, -1, widebuff, bufflen);

    OutputDebugStringW(widebuff);
    OutputDebugStringA("\n");

	bufflen = WideCharToMultiByte(CP_ACP, 0, widebuff, -1, NULL, 0, NULL, NULL);
	char* buff = new char[bufflen + 1];
	memset(buff, 0, sizeof(char) * (bufflen + 1));
	WideCharToMultiByte(CP_ACP, 0, widebuff, -1, buff, bufflen, NULL, NULL);
	puts(buff);

	delete[] widebuff;
	delete[] buff;
}

NS_CC_END

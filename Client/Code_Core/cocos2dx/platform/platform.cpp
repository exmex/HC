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

#include "platform.h"

#include "CCStdC.h"

NS_CC_BEGIN

int CCTime::gettimeofdayCocos2d(struct cc_timeval *tp, void *tzp)
{
#ifdef WIN32
    
	time_t tclock;
	struct tm tm;
	SYSTEMTIME wtm;
    
	GetLocalTime(&wtm);
	tm.tm_year = wtm.wYear - 1900;
	tm.tm_mon = wtm.wMonth - 1;
	tm.tm_mday = wtm.wDay;
	tm.tm_hour = wtm.wHour;
	tm.tm_min = wtm.wMinute;
	tm.tm_sec = wtm.wSecond;
	tm.tm_isdst = -1;
	tclock = mktime(&tm);
    tp->tv_sec  =  tclock;
    tp->tv_usec =  wtm.wMilliseconds * 1000;
#else
    CC_UNUSED_PARAM(tzp);
    if (tp)
    {
        struct timeval tval ;
        gettimeofday(&tval,  0);
        tp->tv_sec = tval.tv_sec;
        tp->tv_usec = tval.tv_usec;
    }
#endif
    return 0;
}

double CCTime::timersubCocos2d(struct cc_timeval *start, struct cc_timeval *end)
{
    if (! start || ! end)
    {
        return 0;
    }
    
    return ((end->tv_sec*1000.0+end->tv_usec/1000.0) - (start->tv_sec*1000.0+start->tv_usec/1000.0));
}

NS_CC_END

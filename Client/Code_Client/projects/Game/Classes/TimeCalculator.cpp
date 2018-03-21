
#include "stdafx.h"

#include "TimeCalculator.h"
#include "cocos2d.h"
#include "Language.h"
USING_NS_CC;

void TimeCalculator::init()
{

	struct cc_timeval now;
	if (CCTime::gettimeofdayCocos2d(&now, NULL) != 0)
	{
		CCMessageBox("Error in gettimeofday",Language::Get()->getString("@ShowMsgBoxTitle").c_str());
		return;
	}
	mCurrentSeconds = now.tv_sec;
}

void TimeCalculator::update()
{
	struct cc_timeval now;
	CCTime::gettimeofdayCocos2d(&now, NULL);
	mCurrentSeconds = now.tv_sec;

}


void TimeCalculator::createTimeCalcultor( std::string key, long timeleft )
{
	TIME_INFO info;
	info.timeleft = timeleft;
	info.registerTime = mCurrentSeconds;
	info.lastGetTime = 0;

	std::map<std::string ,TIME_INFO>::iterator it = mTimes.find(key);

	if(mTimes.find(key)!=mTimes.end())
		it->second = info;	
	else
		mTimes.insert(std::make_pair(key,info));

}

void TimeCalculator::removeTimeCalcultor( std::string key )
{
	if( mTimes.find(key) != mTimes.end() )
		mTimes.erase(key);
}

bool TimeCalculator::getTimeLeft( std::string key, long& timeleft )
{
	std::map<std::string ,TIME_INFO>::iterator it = mTimes.find(key);
	if(it==mTimes.end())
	{
		//CCMessageBox(("failed to get time! key:"+key).c_str(),Language::Get()->getString("@ShowMsgBoxTitle").c_str());
#if defined _DEBUG && defined _WIN32
		std::string msg = "failed to get time! key:" + key;
		CCMessageBox(msg.c_str(), Language::Get()->getString("@ShowMsgBoxTitle").c_str());
#endif		
		return false;
	}

	timeleft = it->second.timeleft - (mCurrentSeconds - it->second.registerTime);


	if(it->second.lastGetTime==mCurrentSeconds)
		return false;
	else 
		return true;
}

long TimeCalculator::getTimeLeft( std::string str)
{
	long ret;
	if(getTimeLeft(str,ret))
	{
		if(ret>0)
			return ret;
		else
			return 0;
	}
	else
		return -1;
}

bool TimeCalculator::hasKey(std::string key)
{
	std::map<std::string ,TIME_INFO>::iterator it = mTimes.find(key);
	if(it==mTimes.end())
	{
		return false;
	}
	return true;
}
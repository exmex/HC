#include "GameNotification.h"
#include "lib91.h"
#include <time.h>
#include "TimeCalculator.h"
#include "libOS.h"
#include "StringConverter.h"
#include "Language.h"

const int ONE_DAY_LONG = 24*60*60;

GameNotification::GameNotification(void)
{
}


GameNotification::~GameNotification(void)
{
}

void GameNotification::addNotification()
{
	//power recovered
	long timeleft = 0;
	if(TimeCalculator::Get()->getTimeLeft("allPowerRecoverTime",timeleft))
	{
		libOS::getInstance()->clearNotification();

		{
			//eat chicken and add power

#if defined(ANDROID)
			/*
				暂时以东八时区 local
			*/
			addDailyNotification(12,0,0,Language::Get()->getString("@NotificationEatChicken"));
			addDailyNotification(18,0,0,Language::Get()->getString("@NotificationEatChicken"));
#else
			addDailyNotification(4,0,0,Language::Get()->getString("@NotificationEatChicken"));
			addDailyNotification(10,0,0,Language::Get()->getString("@NotificationEatChicken"));
#endif
		}
		
		
		if(1)
		{
			if(timeleft>0)
			{
				CCLOG("notification at %d seconds later: %s",timeleft,Language::Get()->getString("@NotificationPowerRecover").c_str());
				libOS::getInstance()->addNotification(Language::Get()->getString("@NotificationPowerRecover"),timeleft,false);        
			}
		}
	}
}


void GameNotification::addDailyNotification( int hour, int min, int second, const std::string& msg )
{

	time_t tempt = time(0); 
	time_t t = tempt;
#if defined(ANDROID)
	struct tm* tm = localtime(&t);
#else
	struct tm* tm=gmtime(&t);
#endif
	struct tm tt = *tm;
	tt.tm_hour = hour;
	tt.tm_min = min;
	tt.tm_sec = second;
#if defined(WIN32)
	time_t targettime = _mkgmtime(&tt);
#elif defined(ANDROID)
	time_t targettime = mktime(&tt);
#else
    time_t targettime = timegm(&tt);
#endif
	if(targettime<t)
		targettime+=ONE_DAY_LONG;
	if(targettime-t>ONE_DAY_LONG)
		targettime-=ONE_DAY_LONG;
//#undef ANDROID
	int timedelay = targettime - t;

	CCLOG("notification at %d seconds later(loop): %s",timedelay,msg.c_str());
	libOS::getInstance()->addNotification(msg,timedelay,true);

//#endif
}

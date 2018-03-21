#pragma once
#include "Singleton.h"
#include <map>
#include <string>

class TimeCalculator: public Singleton<TimeCalculator>
{
private:
	long mCurrentSeconds;
	struct TIME_INFO
	{
		long timeleft;
		long registerTime;
		long lastGetTime;
	};
	std::map<std::string,TIME_INFO> mTimes;

public:
	void init();
	void update();

	//interface
	static TimeCalculator* getInstance(){return TimeCalculator::Get();}
	void createTimeCalcultor(std::string key, long timeleft);
	void removeTimeCalcultor(std::string key);
	bool getTimeLeft(std::string, long& timeleft);
	long getTimeLeft(std::string);
	bool hasKey(std::string key);

};


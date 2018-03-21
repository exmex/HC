#pragma once
#include "Singleton.h"
#include <string>

class GameNotification : public Singleton<GameNotification>
{
public:
	GameNotification(void);
	~GameNotification(void);

	void addNotification();
private:
	void addDailyNotification(int hour, int min, int second, const std::string& msg);
};


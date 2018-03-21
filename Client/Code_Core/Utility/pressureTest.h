#pragma once
#include <string>
#include <list>
#include <map>
#include "google/protobuf/message.h"
#include "Concurrency.h"
#include "Singleton.h"

class pressureTest:public Singleton<pressureTest>
{
public:
	pressureTest(void);
	~pressureTest(void);
	void testLogin();
	void testPlay();
	void testAmount();

	void session();


	std::string mIP;
	int mPort;
	int mWaitBetweenPackage;


};


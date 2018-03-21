#pragma once

#include "platform/CCPlatformMacros.h"

NS_CC_BEGIN

class CCObject;

class CC_DLL CCResourceObject : public CCObject
{
public:
	CCResourceObject();
	~CCResourceObject();

public:
	double getLastDrawTime(void);
	void updateLastDrawTime(double val);

protected:
	double  _lastDrawTime;

};

NS_CC_END
#include "CCObject.h"
#include "CCResourceObject.h"

NS_CC_BEGIN

CCResourceObject::CCResourceObject()
:_lastDrawTime(0)
{
}


CCResourceObject::~CCResourceObject()
{
}

double CCResourceObject::getLastDrawTime(void)
{
	return _lastDrawTime;
}

void CCResourceObject::updateLastDrawTime(double val)
{
	if (this->retainCount() == 1)
	{
		_lastDrawTime += val;
	}
	else
	{
		_lastDrawTime = 0;
	}
}

NS_CC_END
#pragma once

#include "platform/CCPlatformMacros.h"

NS_CC_BEGIN

class CCDictionary;

class CC_DLL CCResourceCache : public CCDictionary
{
public:
	CCResourceCache();
	CCResourceCache(double fTime);
	~CCResourceCache();

public:
	void gc(double passTime, unsigned int type);
	void setGCTime(double time);

protected:
	double m_dGcTime;
};

NS_CC_END
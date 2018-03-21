#pragma once

#include "cocoa/CCObject.h"

class CC_DLL CDebugMag
{
protected:
	CDebugMag() {};
	static CDebugMag* m_Inst;
public:
	static CDebugMag* GetInst();

	void debugMemory(char* pTag = NULL);

	double _bytes_to_m(unsigned long long _bytes);
};
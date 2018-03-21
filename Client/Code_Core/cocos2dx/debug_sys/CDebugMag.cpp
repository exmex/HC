#include "CDebugMag.h"
#include "cocos2d.h"


CDebugMag* CDebugMag::m_Inst = nullptr;

CDebugMag* CDebugMag::GetInst()
{
	if(!m_Inst)
		m_Inst = new CDebugMag();
	return m_Inst;
}

double CDebugMag::_bytes_to_m(unsigned long long _bytes)
{
	double _k = (double)_bytes / 1024.0;
	return double(_k / 1024.0);
}

void CDebugMag::debugMemory(char* pTag)
{
	unsigned long long comitBytes =  Windows::Phone::System::Memory::MemoryManager::ProcessCommittedBytes;
	double cmt_byte_m = _bytes_to_m(comitBytes);
	if (pTag)
	{
		CCLOG("%s : sys use memory %f \n", pTag, cmt_byte_m);
	}
	else
	{
		CCLOG("sys use memory %f \n", cmt_byte_m);
	}
}

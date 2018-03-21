#include "..\include\lib91.h"
#include <windows.h>
#include "libOS.h"
#include "libPlatform.h"
bool lib91_mLogined = false;
DWORD lib91_mLoginTime = 0;



void lib91::init(bool privateLogin)
{
	lib91_mLogined = false;
	_boardcastUpdateCheckDone(true,"");
}
bool lib91::getLogined()
{
	//change the offset of the time to be 0.5s, not 2s by zhenhui 2014/5/22
	if(lib91_mLoginTime>0 && timeGetTime() - lib91_mLoginTime>500)
	{
		lib91_mLogined = true;
		//_boardcastLoginResult(true,"success");
	}
	return lib91_mLogined;
}

static std::string loginName = "";


#ifdef WIN32
void lib91::setLoginName(const std::string content){
	lib91_mLoginTime = timeGetTime();
	loginName = content;
}
#endif


void lib91::login()
{
	class myListener: public libOSListener
	{
	public:
		virtual void onInputboxEnter(const std::string& content)
		{
			loginName = content;
			libPlatformManager::getPlatform()->_boardcastLoginResult(true,"");
		}
	}_listener;
	lib91_mLoginTime = timeGetTime();
	if(loginName == "")
	{
		
		libOS::getInstance()->registerListener(&_listener);
		libOS::getInstance()->showInputbox(false);//_InputBox(L"input your uin");
		libOS::getInstance()->removeListener(&_listener);
		
	}
	
}

//in win32 return a number caculated by computer name
const std::string& lib91::loginUin()
{	
	return loginName;
}
const std::string& lib91::sessionID()
{
	static TCHAR chBuf[128];
	DWORD dwRet=128;
	GetComputerName(chBuf,&dwRet);
    static std::string ret;
    ret = (char*)chBuf;
	return ret;
}
const std::string& lib91::nickName()
{
	if (loginName.length()==0)
	{
		static TCHAR chBuf[128];
		DWORD dwRet=128;
		GetComputerName(chBuf,&dwRet);
		static std::string ret;
		ret = (char*)chBuf;
		return ret;
	} 
	else
	{
		return loginName;
	}
	
}
void lib91::switchUsers()
{
	loginName="";
    login();
}
void lib91::logout()
{

}

void lib91::buyGoods( BUYINFO& info)
{
	MessageBox(0,L"Bought a item!!",L"shop",MB_OK);
	char ser[128];
	sprintf(ser,"%d",timeGetTime());
	info.cooOrderSerial = ser;
	_boardcastBuyinfoSent(true,info,"success");
}


void lib91::openBBS()
{
	MessageBox(0,L"open a bbs!!",L"url",MB_OK);
}

void lib91::userFeedBack()
{

}

void lib91::gamePause()
{

}

void lib91::updateApp()
{

}

void lib91::final()
{

}

const std::string lib91::getClientChannel()
{
	return "91";
}

void lib91::_enableLogin()
{

}

const unsigned int lib91::getPlatformId()
{
	return 0u;
}

std::string lib91::getPlatformMoneyName()
{
	return "91dou";
}

void lib91::notifyEnterGame()
{
}

void lib91::setToolBarVisible(bool isShow)
{

}

bool lib91::getIsTryUser()
{
	return false;
}

void lib91::callPlatformBindUser()
{
	
}

void lib91::notifyGameSvrBindTryUserToOkUserResult( int result )
{
	
}

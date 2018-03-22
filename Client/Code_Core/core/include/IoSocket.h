#pragma once
#include "SocketBase.h"
#define OUTPUT_DLL

class OUTPUT_DLL IoSocket  
{
public:
	IoSocket();
	virtual ~IoSocket();
	static void sleep(unsigned long ms);	

	virtual bool onCreate(const char *ipaddr = 0, int port = 0);
	virtual bool onConnect(const char * ipaddr, int port) = 0;
	virtual bool onShutdown(int nHow);
	virtual void onClose();
	virtual bool onAttach(SOCKET hSocket);
	virtual SOCKET onDetach();

	virtual int onReceive(void* lpBuf, int nBufLen) = 0;
	virtual int onForceReceive(void* lpBuf, int nBufLen) = 0;	
	virtual int onSend(const void* lpBuf, int nBufLen) = 0;
		
protected:
	SOCKET mSocket;
};

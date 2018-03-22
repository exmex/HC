#pragma once
#include "IoSocket.h"

#define ASYNC_SOCKET_TIMEOUT_MS 3000
#define ASYNC_SOCKET_SELLECT_TIMEOUT_MS 3000

#define  OUTPUT_DLL

class OUTPUT_DLL AsyncSocket : public IoSocket
{
public:
	AsyncSocket();
	virtual ~AsyncSocket();

	virtual bool onCreate(const char *ipaddr = 0, int port = 0);
	virtual bool onConnect(const char * ipaddr, int port, unsigned long timeout_ms);
	virtual int onReceive(void* lpBuf, int nBufLen, unsigned long timeout_ms);
	virtual int onForceReceive(void* lpBuf, int nBufLen, unsigned long timeout_ms);	
	virtual int onSend(const void* lpBuf, int nBufLen, unsigned long timeout_ms);

	virtual bool onConnect(const char * ipaddr, int port);
	virtual int onReceive(void* lpBuf, int nBufLen);
	virtual int onForceReceive(void* lpBuf, int nBufLen);	
	virtual int onSend(const void* lpBuf, int nBufLen);
};

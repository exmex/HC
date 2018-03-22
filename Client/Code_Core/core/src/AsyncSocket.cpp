
#include "SocketBase.h"
#include "AsyncSocket.h"
#include <stdio.h>
#include "errno.h"

AsyncSocket::AsyncSocket()
	: IoSocket()
{
}

AsyncSocket::~AsyncSocket()
{
	onClose();
}

bool AsyncSocket::onCreate(const char *ipaddr /* = 0 */, int port /* = 0 */)
{
	bool ret = IoSocket::onCreate(ipaddr, port);
	if(ret)
	{
		if(GameCommon::setnonblocking(mSocket, 1) < 0)
		{
			ret = false;
			onClose();
		}
	}
	return ret;
}

bool AsyncSocket::onConnect(const char * ipaddr, int port, unsigned long timeout_ms)
{
	if(mSocket == INVALID_SOCKET)
	{
		fprintf(stderr,"AsyncSocket::connect::(mSocket == INVALID_SOCKET)\n");
		return false;
	}

	bool ret = true;
	if(GameCommon::tcpconnect(mSocket, ipaddr, port) < 0)
	{
		int errorno = MYERRNO; 
#ifdef WIN32
		if (errorno == WSAEWOULDBLOCK)//等待状态
#else
		if (errorno == EINPROGRESS)//等待状态
#endif
		{
			fd_set fdwrite,fdread;
			FD_ZERO(&fdwrite);
			FD_SET(mSocket, &fdwrite);
			fdread = fdwrite;

			struct timeval tv;
			tv.tv_sec = timeout_ms / 1000;
			tv.tv_usec = (timeout_ms % 1000) * 1000;

			int retvalue = 0;
			if ((retvalue = select(mSocket+1, &fdread, &fdwrite, 0, &tv)) == 0)
			{
				fprintf(stderr,"AsyncSocket::connect(%s:%d) timeout, ret(%d).\n", ipaddr, port, retvalue);
				ret = false;
			}

			if (FD_ISSET(mSocket, &fdread) || FD_ISSET(mSocket, &fdwrite))
			{
				if(GameCommon::geterror(mSocket) < 0)
				{
					int so_error = MYERRNO;
					fprintf(stderr,"AsyncSocket::connect(%s:%d) error = %d.\n", ipaddr, port, so_error);
					return false;
				}
			}
			else
			{
				fprintf(stderr,"AsyncSocket::connect(%s:%d) error, sockfd not set\n", ipaddr, port);
				ret = false;
			}
		}
		else//非等待状态
		{
			fprintf(stderr,"AsyncSocket::connect(%s:%d) error = %d.\n", ipaddr, port, errorno);
			ret = false;
		}
	}

	return ret;
}

int AsyncSocket::onReceive(void* lpBuf, int nBufLen, unsigned long timeout_ms)
{
	if (lpBuf == NULL)
	{
		fprintf(stderr,"AsyncSocket::Receive::(lpBuf == NULL)\n");
		return -1;
	}

	if(mSocket == INVALID_SOCKET)
	{
		fprintf(stderr,"AsyncSocket::Receive::(mSocket == INVALID_SOCKET)\n");
		return -1;
	}

	struct timeval tv;
	tv.tv_sec = timeout_ms / 1000;
	tv.tv_usec = (timeout_ms % 1000) * 1000;

	fd_set fdread; 
	FD_ZERO(&fdread); 
	FD_SET(mSocket, &fdread);    

	select(mSocket+1, &fdread, 0, 0, &tv); 

	int len = -1;
	if(FD_ISSET(mSocket, &fdread)) 
	{ 
		len = recv(mSocket, static_cast<char*>(lpBuf), nBufLen, 0);
	}

	return len;
}

int AsyncSocket::onForceReceive(void* lpBuf, int nBufLen, unsigned long timeout_ms)
{
	GameCommon::setnonblocking(mSocket, 0);
	int ret = onReceive(lpBuf, nBufLen, timeout_ms);
	GameCommon::setnonblocking(mSocket, 1);

	return ret;
}

int AsyncSocket::onSend(const void* lpBuf, int nBufLen, unsigned long timeout_ms)
{
	if (lpBuf == NULL)
	{
		fprintf(stderr,"AsyncSocket::Send::(lpBuf == NULL)\n");
		return -1;
	}

	if(mSocket == INVALID_SOCKET)
	{
		fprintf(stderr,"AsyncSocket::Send::(mSocket == INVALID_SOCKET)\n");
		return -1;
	}

	int sendlen = 0;
	int times = 1;	
	
	do{
		struct timeval tv;
		tv.tv_sec = timeout_ms / 1000;
		tv.tv_usec = (timeout_ms % 1000) * 1000; 

		fd_set fdwrite; 
		FD_ZERO(&fdwrite); 
		FD_SET(mSocket, &fdwrite);

		//handle exception
		fd_set fdexcept; 
		FD_ZERO(&fdexcept); 
		FD_SET(mSocket, &fdexcept); 

		select(mSocket+1, 0, &fdwrite, &fdexcept, &tv); 

		if(FD_ISSET(mSocket, &fdexcept))
		{
			fprintf(stderr,"socket has error! need reconnect");
			return -1;
		}

		int newsend = send(mSocket, (char*)(lpBuf) + sendlen, nBufLen - sendlen, 0);
		if(newsend < 0 )
		{
			int errorno = MYERRNO; 
#ifdef WIN32
			//WSAECONNRESET
			if(errorno !=  WSAEWOULDBLOCK)
			{
				fprintf(stderr,"sendlen = %d, errorno = %d",newsend, errorno);
				return -1;
			}

			//WSAEINVAL == EINVAL ENOMEM==WSAEFAULT EINTR == WSAEINTR EAGAIN == EWOULDBLOCK
#else
			if(errorno !=  EINTR && errorno != EAGAIN)
			{
				fprintf(stderr,"sendlen = %d, errorno = %d",newsend, errorno);
				return -1;
			}
#endif
		}
		
		sendlen += (newsend>0?newsend:0);
		fprintf(stderr,"sendtime = %d, newsend len != %d, cursendlen = %d",times,newsend,sendlen);

		//发送无效果,算超时一次,算一次失败
		if(newsend <= 0)
		{
			times++;
		}
	}while(sendlen < nBufLen && times <= 5);

	if(sendlen != nBufLen)
	{
		fprintf(stderr,"send len != BufLen");
		return -1;
	}

	return sendlen;
}

bool AsyncSocket::onConnect(const char * ipaddr, int port)
{
	return AsyncSocket::onConnect(ipaddr, port, ASYNC_SOCKET_SELLECT_TIMEOUT_MS);
}

int AsyncSocket::onReceive(void* lpBuf, int nBufLen)
{
	return AsyncSocket::onReceive(lpBuf, nBufLen, ASYNC_SOCKET_SELLECT_TIMEOUT_MS);
}

int AsyncSocket::onForceReceive(void* lpBuf, int nBufLen)
{
	return AsyncSocket::onForceReceive(lpBuf, nBufLen, ASYNC_SOCKET_TIMEOUT_MS);
}

int AsyncSocket::onSend(const void* lpBuf, int nBufLen)
{
	return AsyncSocket::onSend(lpBuf, nBufLen, ASYNC_SOCKET_SELLECT_TIMEOUT_MS);
}

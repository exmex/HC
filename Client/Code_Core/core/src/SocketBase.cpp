
#include "SocketBase.h"
#include <stdio.h>

namespace GameCommon
{

	SOCKET udpsocket(const char *ipaddr, int port, int reuseaddr /* = 0 */)
	{
		SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
		if(sock < 0)
		{
			fprintf(stderr,"socket() error!\n");
			return INVALID_SOCKET;
		}

		if(reuseaddr)
		{
			int opt = 1;
			setreuseaddr(sock, opt);
		}

		struct sockaddr_in addr;
		int len = sizeof(addr);
		memset(&addr, 0, len);
		addr.sin_family = AF_INET;
		addr.sin_port = htons(port);
		if(ipaddr)
		{
			addr.sin_addr.s_addr = inet_addr(ipaddr);
		}
		else 
		{
			addr.sin_addr.s_addr = htonl(0);
			//addr.sin_addr.s_addr = INADDR_ANY;
		}

		int status = bind(sock, (struct sockaddr*)&addr, len);
		if(status < 0)
		{
			fprintf(stderr, "bind address err!\n");
			closesocket(sock);	
			return INVALID_SOCKET;
		}

		return sock;
	}

	int udpsendto(SOCKET sock, const char *ipaddr, int port, const char *buf, int len, int flag)
	{
		struct sockaddr_in remote_sin;

		memset(&remote_sin, 0, sizeof(remote_sin));
		remote_sin.sin_family = AF_INET;
		remote_sin.sin_port = htons((short)port);
		if(ipaddr)
		{
			remote_sin.sin_addr.s_addr = inet_addr(ipaddr);
		}
		else
		{
			remote_sin.sin_addr.s_addr = htonl(0);
		}

		return sendto(sock, buf, len, flag, (struct sockaddr*)&remote_sin, sizeof(remote_sin));
	}

	int udprecvfrom(SOCKET sock,char *ipaddr,unsigned int *port,char *buf,int len,int flag)
	{
		struct sockaddr_in remote_sin;

#ifdef CC_TARGET_OS_IPHONE
		unsigned int addlen = sizeof(remote_sin);
#else
		int addlen = sizeof(remote_sin);
#endif
		memset(&remote_sin, 0, addlen);

		int ret = recvfrom(sock, buf, len, flag, (struct sockaddr*)&remote_sin, &addlen);
		if(port)
		{
			*port = ntohs(remote_sin.sin_port);
		}
		if(ipaddr)
		{
			strcpy(ipaddr, inet_ntoa(remote_sin.sin_addr));
		}

		return ret;
	}

	SOCKET tcpsocket(const char *ipaddr, int port, int reuseaddr /* = 0 */)
	{
		SOCKET sock;
		struct sockaddr_in local_sin;

		sock = socket(AF_INET, SOCK_STREAM, 0);
		if(sock < 0)
		{
			fprintf(stderr,"socket() error!\n");
			return INVALID_SOCKET;
		}

		if(reuseaddr)
		{
			int opt = 1;
			setreuseaddr(sock, opt);
		}

		memset(&local_sin, 0, sizeof(local_sin));
		local_sin.sin_family = AF_INET;
		local_sin.sin_port = htons((short)port);
		if(ipaddr)
		{
			local_sin.sin_addr.s_addr = inet_addr(ipaddr);
		}
		else
		{
			local_sin.sin_addr.s_addr = htonl(0);
		}

		int ret = bind(sock, (struct sockaddr *)&local_sin, sizeof(local_sin));
		if(ret < 0)
		{
			fprintf(stderr, "bind address err! ret = %d \n", ret);
			closesocket(sock);
			return INVALID_SOCKET;
		}

		return sock;
	}

	int tcpconnect(SOCKET sock, const char *ipaddr, int port)
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}

		struct addrinfo *result, hints;
		memset(&hints, 0, sizeof(struct addrinfo));
		hints.ai_family = AF_INET;
		hints.ai_socktype = SOCK_STREAM;
		//hints.ai_flags = 0;
		//hints.ai_protocol = 0;

		char port_str[16];
		sprintf(port_str, "%d", port);
		int ret = getaddrinfo(ipaddr, port_str, &hints, &result);
		if (ret != 0) {

			fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret));

			return INVALID_SOCKET;
		}

		ret = connect(sock, result->ai_addr, result->ai_addrlen);

		freeaddrinfo(result);

// 		if (ret < 0)
// 		{
// 			#ifdef WIN32
// 				fprintf(stderr, "socket connect failed: %d\n", GetLastError());
// 			#else
// 				//extern int errno;
// 				//fprintf(stderr, "socket connect failed: %d	%s\n", errno, strerror(errno));
// 				fprintf(stderr, "socket connect failed\n");
// 			#endif
// 		}

		return ret;

// 		struct sockaddr_in remote_sin;
// 
// 		memset(&remote_sin, 0, sizeof(remote_sin));
// 		remote_sin.sin_family = AF_INET;
// 		remote_sin.sin_port = htons((short)port);
// 		if(ipaddr)
// 		{
// 			remote_sin.sin_addr.s_addr = inet_addr(ipaddr);
// 		}
// 		else
// 		{
// 			remote_sin.sin_addr.s_addr = htonl(0);
// 		}

//		return connect(sock, (struct sockaddr*)&remote_sin, sizeof(remote_sin));
	}

	SOCKET tcpaccept(SOCKET sock, char *ipaddr, int *port)
	{
		if(sock == INVALID_SOCKET)
		{
			return INVALID_SOCKET;
		}
		int newsock;
		struct sockaddr_in remote_sin;
#ifdef CC_TARGET_OS_IPHONE
		unsigned int len = sizeof(remote_sin);
#else
		int len = sizeof(remote_sin);
#endif

		memset(&remote_sin, 0, len);
		newsock = accept(sock, (struct sockaddr*)&remote_sin, &len);
		if(newsock < 0)
		{
			return INVALID_SOCKET;
		}
		if(port)
		{
			*port = ntohs(remote_sin.sin_port);
		}
		if(ipaddr)
		{
			strcpy(ipaddr, inet_ntoa(remote_sin.sin_addr));
		}

		return newsock;
	}

	int setnonblocking(SOCKET sock, int nonblock)
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}

#ifdef WIN32
		unsigned long opt = nonblock;
		if(SOCKET_ERROR == ioctlsocket(sock, FIONBIO, &opt))
		{
			return -1;
		}
		else
		{
			return 0;
		}
#else
		int opts = fcntl(sock, F_GETFL);
		if(opts < 0) 
		{
			return -1;
		}

		if(nonblock)
		{
			opts |= O_NONBLOCK;
		}
		else
		{
			opts &= ~O_NONBLOCK;
		}

		if(fcntl(sock,F_SETFL,opts) < 0)
		{
			return -1;
		}
		else
		{
			return 0;
		}
#endif
	}

	int setreuseaddr(SOCKET sock, int opt)
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}
		return setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (const char*)&opt, sizeof(opt));
	}

	int getpeeraddr(SOCKET sock, char* ip, int* port)
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}

		struct sockaddr addr;
#ifdef CC_TARGET_OS_IPHONE
		unsigned int addrlen = sizeof(addr);
#else
		int addrlen = sizeof(addr);
#endif
		int ret = getpeername(sock, &addr, &addrlen);
		if(ret < 0)
		{
			return ret;
		}

		unsigned char *pp = (unsigned char*)(addr.sa_data);
		if(port)
		{
			*port = ((unsigned int)pp[0]<<8)|(pp[1]);
		}
		if(ip)
		{
			sprintf(ip,"%d.%d.%d.%d",pp[2],pp[3],pp[4],pp[5]);
		}

		return 0;
	}

	int getlocaladdr(SOCKET sock, char* ip, int* port)
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}

		struct sockaddr addr;
#ifdef CC_TARGET_OS_IPHONE
		unsigned int addrlen = sizeof(addr);
#else
		int addrlen = sizeof(addr);
#endif
		int ret = getsockname(sock, &addr, &addrlen);
		if(ret < 0)
		{
			return ret;
		}

		unsigned char *pp = (unsigned char*)(addr.sa_data);
		if(port)
		{
			*port = ((unsigned int)pp[0]<<8)|(pp[1]);
		}
		if(ip)
		{
			sprintf(ip,"%d.%d.%d.%d",pp[2],pp[3],pp[4],pp[5]);
		}

		return 0;
	}

	int geterror(SOCKET sock)
	{
		int so_error = 0;
#ifdef CC_TARGET_OS_IPHONE
		unsigned int len = sizeof(so_error);
#else
		int len = sizeof(so_error);
#endif
		return getsockopt(sock, SOL_SOCKET, SO_ERROR, reinterpret_cast<char*>(&so_error), &len);
	}

	int setkeepalive( SOCKET sock, int keepalive /*= 1*/, int keepidle /*= 30*/, int keepinterval /*= 1*/, int keepcount /*= 5*/ )
	{
		if(sock == INVALID_SOCKET)
		{
			return -1;
		}

		if(setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, (const char*)&keepalive, sizeof(keepalive)) != 0)
		{
			return -1;
		}

#ifdef WIN32
		struct tcp_keepalive kavars = {    
			keepalive,    
			keepidle * 1000,
			keepinterval * 1000    
		};
		DWORD dwReturn(0);
		DWORD dwTransBytes(0);
		if (WSAIoctl(sock, SIO_KEEPALIVE_VALS, &kavars, sizeof(kavars), &dwReturn, sizeof(dwReturn), &dwTransBytes, NULL,NULL) == SOCKET_ERROR)
		{
			return -1;
		}
#else
// 		if(setsockopt(sock, IPPROTO_TCP, TCP_KEEPALIVE, (const char*)&keepidle, sizeof(keepidle)) != 0)
// 		{
// 			return -1;
// 		}
// 		if(setsockopt(sock, IPPROTO_TCP, TCP_KEEPINTVL, (const char *)&keepinterval, sizeof(keepinterval)) != 0)
// 		{
// 			return -1;
// 		}
// 		if(setsockopt(sock, IPPROTO_TCP, TCP_KEEPCNT, (const char *)&keepcount, sizeof(keepcount)) != 0)
// 		{
// 			return -1;
// 		}

#endif
		return 0;
	}

}


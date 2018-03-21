#pragma once
#include "Singleton.h"
#include "Concurrency.h"
#include "AsyncSocket.h"

#include <string>
#include <set>

class SocketTask : public ThreadTask
{
public:
	enum SOCKETTYPE
	{
		ST_CONNECT,
		ST_SEND,
		ST_RECEIVED,
	};
	virtual SOCKETTYPE getType() = 0;
};

class SocketListener
{
public:
	virtual void onReceivePacket(void* buffer, int size){}
	virtual void onReceiveFailed(){}
	virtual void onSendFailed(unsigned int opcode){}
	virtual void onConnectionFailed(std::string ip, unsigned int port){}
	virtual void onConnectionSuccess(std::string ip, unsigned int port){}
};

class ThreadSocket : public Singleton<ThreadSocket>
{
public:
	enum SOCKET_STATE
	{
		SS_UNINITIALIZED,
		SS_WAIT,
		SS_CONNECTING,
		SS_CONNECT_SUCCUSS,
		SS_CONNECT_FAILED,
		SS_SENDING,
		SS_SEND_FAILED,
		SS_RECEIVING,
		SS_RECEIVE_DONE,
		SS_RECEIVE_FAILED
	};

private:
	AsyncSocket mSocket;
	SingleThreadExecuter mThread;

	SOCKET_STATE mState;
	Mutex _socketMutex;
	Mutex _stateMutex;

	std::list<SocketTask*> mTaskList;
	SocketTask* mCurrentTask;

	bool mForceShutDone;
    
  bool mConnectionOk;
  
    std::string mIp;
    int mPort;

	std::set<SocketListener*> mSocketListenerList;
public:
	ThreadSocket(void);
	~ThreadSocket(void);

	struct PacketData
	{
		void* buffer;
		int length;
	};
	
	void SetConnectionOK(bool connOK) { mConnectionOk = connOK; } ;
	void connect( const std::string& ip ,int port );
    void reconnect();
	void disconnect();
	void sendPacket(PacketData data, int opcode);
	void update();

	AsyncSocket& lockSocket(){_socketMutex.lock();return mSocket;}
	void releaseSocket(){_socketMutex.unlock();}

	void setState(SOCKET_STATE state){_stateMutex.lock();mState = state;_stateMutex.unlock();}
	SOCKET_STATE getState(){return mState;}

	bool registerSocketListener(SocketListener*);
	void removeSocketListener(SocketListener*);

private:
	void addSocketTask(SocketTask* task);
	void cleanSocketTask(void);
};


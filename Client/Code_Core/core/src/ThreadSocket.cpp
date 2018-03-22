#include "stdafx.h"
#include "ThreadSocket.h"
#include "PacketManager.h"
#include "cocos2d.h"

class SocketConnectTask : public SocketTask
{
public:
	std::string mIP;
	int mPort;

	virtual SOCKETTYPE getType(){return ST_CONNECT;}
	SocketConnectTask(const std::string & ipaddress, int port)
	{
		mIP = ipaddress;
		mPort = port;
	}

	virtual int run()
	{
		AsyncSocket& socket = ThreadSocket::Get()->lockSocket();
		bool ret = true;
		do
		{
#ifdef WIN32
			WSADATA wsaData;   
			if (WSAStartup(MAKEWORD(2,1), &wsaData))
			{ 
				printf("Windows socket initialize error!\n"); 
				WSACleanup(); 
				ret = false;
				break; 
			}
#endif
			if(! socket.onCreate())
			{
				printf("create SyncSocket error.\n");
				ret = false;
				break;
			}
			if(! socket.onConnect(mIP.c_str(), mPort))
			{
				printf("connect server error.\n");
				ret = false;
				socket.onClose();
				break;
			}
		}while(0);

		ThreadSocket::Get()->releaseSocket();
		if(ret)
			ThreadSocket::Get()->setState(ThreadSocket::SS_CONNECT_SUCCUSS);
		else
			ThreadSocket::Get()->setState(ThreadSocket::SS_CONNECT_FAILED);

		return 0;
	} 
};


class SocketSendTask : public SocketTask
{
private:
	ThreadSocket::PacketData mData;
public:
	int opcode;
	virtual SOCKETTYPE getType(){return ST_SEND;}
	SocketSendTask(ThreadSocket::PacketData data, int Opcode)
	{
		mData = data;
		opcode = Opcode;
	}
	virtual int run()
	{
		if(mData.buffer != 0)
		{
			if(mData.length<=0 )
			{
				//delete[] (char*)mData.buffer;
				//break;
				ThreadSocket::Get()->setState(ThreadSocket::SS_SEND_FAILED);
			}
			else
			{
				AsyncSocket& socket = ThreadSocket::Get()->lockSocket();
				bool sendOK = (socket.onSend(mData.buffer,mData.length) > 0);
				ThreadSocket::Get()->releaseSocket();

				if(sendOK)
				{
					ThreadSocket::Get()->setState(ThreadSocket::SS_WAIT);

				}
				else
				{
					ThreadSocket::Get()->setState(ThreadSocket::SS_SEND_FAILED);
				}
			}
		}
		else
		{
			ThreadSocket::Get()->setState(ThreadSocket::SS_SEND_FAILED);
		}
		delete[] (char*) mData.buffer;
		return 0;
	} 
};

class SocketReceiveTask : public SocketTask
{
private:
	ThreadSocket::PacketData mData;
public:
	virtual SOCKETTYPE getType(){return ST_RECEIVED;}
	SocketReceiveTask()
	{
		mData.buffer = new char[PacketManager::DEFAULT_BUFFER_LENGTH];
		mData.length = -1;
	}
	~SocketReceiveTask()
	{
		if(mData.buffer)
			delete [](char*)mData.buffer;
	}
	virtual int run()
	{
		AsyncSocket& socket = ThreadSocket::Get()->lockSocket();
		mData.length = socket.onReceive(mData.buffer,PacketManager::DEFAULT_BUFFER_LENGTH,0);
		ThreadSocket::Get()->releaseSocket();
		if(mData.length > 0)
		{
			ThreadSocket::Get()->setState(ThreadSocket::SS_RECEIVE_DONE);
			//ThreadSocket::Get()->releaseSocket();
			//return 0;
		}
		else if (mData.length == 0)
		{
			//ThreadSocket::Get()->setState(ThreadSocket::SS_RECEIVE_FAILED);
			//ThreadSocket::Get()->releaseSocket();
			//return 0;				
		}
		else
		{
			ThreadSocket::Get()->setState(ThreadSocket::SS_WAIT);
		}

		//ThreadSocket::Get()->setState(ThreadSocket::SS_WAIT);
		//ThreadSocket::Get()->releaseSocket();
		return 0;
	} 

	ThreadSocket::PacketData getData(){return mData;}
};


ThreadSocket::ThreadSocket(void)
	:mState(SS_UNINITIALIZED)
	,mCurrentTask(0)
	,mForceShutDone(false)
	,mConnectionOk(false)
{
	mTaskList.clear();
}


ThreadSocket::~ThreadSocket(void)
{
}

bool ThreadSocket::registerSocketListener( SocketListener* listener)
{
	if(mSocketListenerList.find(listener) == mSocketListenerList.end())
		mSocketListenerList.insert(listener);
	return true;
}

void ThreadSocket::removeSocketListener( SocketListener* listener)
{
	if(mSocketListenerList.find(listener)!=mSocketListenerList.end())
		mSocketListenerList.erase(listener);
}

void ThreadSocket::update()
{
	if(getState() == SS_WAIT)
	{
		
		//if(mCurrentTask && mCurrentTask->getType() != SocketTask::ST_CONNECT)//last task finished
		if(mCurrentTask)
		{
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		/*
		//should after delete current task
		if(mForceShutDone)
		{
			AsyncSocket& socket = lockSocket();
			socket.onClose();
#ifdef WIN32
			WSACleanup();
#endif
			releaseSocket();
			setState(SS_UNINITIALIZED);
			mForceShutDone = false;
		}
		*/
		if(mTaskList.empty())
		{
			mCurrentTask = new SocketReceiveTask;
			setState(SS_RECEIVING);
			mThread.execute(mCurrentTask);
		}
		else
		{
			mCurrentTask = mTaskList.front();
			mTaskList.pop_front();

			///* why skip connect?
			while (!mTaskList.empty() && mCurrentTask->getType() == SocketTask::ST_CONNECT)
			{
				delete mCurrentTask;
				mCurrentTask = 0;

				mCurrentTask = mTaskList.front();
				mTaskList.pop_front();
			}
			//*/

			if (mCurrentTask)
			{
				if (mCurrentTask->getType() == SocketTask::ST_SEND)
					setState(SS_SENDING);
				if (mCurrentTask->getType() == SocketTask::ST_RECEIVED)
					setState(SS_RECEIVING);
				if (mCurrentTask->getType() == SocketTask::ST_CONNECT)
					setState(SS_CONNECTING);

				mThread.execute(mCurrentTask);
			}
		}
	}
	else if(getState() == SS_RECEIVE_DONE)
	{
		//if(mCurrentTask && mCurrentTask->getType() == SocketTask::ST_RECEIVED)//last task finished
		if(mCurrentTask)
		{
			SocketReceiveTask* reTask = dynamic_cast<SocketReceiveTask*>(mCurrentTask);
			if(reTask)
			{
				//PacketManager::Get()->_onReceivedPacket(reTask->getData().buffer,reTask->getData().length);
				std::set<SocketListener*>::iterator it = mSocketListenerList.begin();
				for (;it!=mSocketListenerList.end();it++)
				{
					(*it)->onReceivePacket(reTask->getData().buffer,reTask->getData().length);
				}
				//PacketManager::Get()->_boardcastPacketToHandler((*itr).mOpcode, NULL, (*itr).mStr);
			}
			
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		setState(SS_WAIT);
	}
	else if(getState() == SS_RECEIVE_FAILED)
	{
		if(mCurrentTask)
		{
			//SocketReceiveTask* conn = dynamic_cast<SocketReceiveTask*>(mCurrentTask);
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		setState(SS_WAIT);
		std::set<SocketListener*>::iterator it = mSocketListenerList.begin();
		for (;it!=mSocketListenerList.end();it++)
		{
			(*it)->onReceiveFailed();
		}
		//PacketManager::Get()->_boardcastReceiveFailed();
	}
	else if(getState() == SS_SEND_FAILED)
	{
		int opcode = 0;
		if(mCurrentTask)
		{
			SocketSendTask* conn = dynamic_cast<SocketSendTask*>(mCurrentTask);
			if(conn)
			{
				opcode = conn->opcode;
			}
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		setState(SS_WAIT);
		std::set<SocketListener*>::iterator it = mSocketListenerList.begin();
		for (;it!=mSocketListenerList.end();it++)
		{
			(*it)->onSendFailed(opcode);
		}
		//PacketManager::Get()->_boardcastSendFailed(opcode);
	}
	else if(getState() == SS_CONNECT_FAILED)
	{
		//ThreadSocket::Get()->SetConnectionOK(false);

		std::string ip;
		int port = 0;
		if(mCurrentTask)
		{
			SocketConnectTask* conn = dynamic_cast<SocketConnectTask*>(mCurrentTask);
			if(conn)
			{
				ip = conn->mIP;
				port = conn->mPort;
			}
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		setState(SS_UNINITIALIZED);		
		std::set<SocketListener*>::iterator it = mSocketListenerList.begin();
		for (;it!=mSocketListenerList.end();it++)
		{
			(*it)->onConnectionFailed(ip,port);
		}
		//PacketManager::Get()->_boardcastConnectionFailed(ip,port);
	}
	else if(getState() == SS_CONNECT_SUCCUSS)
	{
		std::string ip;
		int port = 0;
		if(mCurrentTask)
		{
			SocketConnectTask* conn = dynamic_cast<SocketConnectTask*>(mCurrentTask);
			if(conn)
			{
				ip = conn->mIP;
				port = conn->mPort;
			}
		}
		setState(SS_WAIT);
		std::set<SocketListener*>::iterator it = mSocketListenerList.begin();
		for (;it!=mSocketListenerList.end();it++)
		{
			(*it)->onConnectionSuccess(ip,port);
		}
	}
	else if(getState() == SS_UNINITIALIZED)
	{
		if(mCurrentTask)
		{
			delete mCurrentTask;//mThread.shutdown();
			mCurrentTask = 0;
		}
		std::list<SocketTask*>::iterator it = mTaskList.begin();
		for(;it!=mTaskList.end();++it)
		{
			if((*it)->getType() ==SocketTask::ST_CONNECT)
			{
				SocketConnectTask* conn = dynamic_cast<SocketConnectTask*>(*it);
				if(conn)
				{
					mCurrentTask = conn;
					setState(SS_CONNECTING);	
					mThread.execute(mCurrentTask);//mCurrentTask->run();
					//mCurrentTask->run();
					mTaskList.erase(it);
					CCLOG("[NetWork] [ThreadSocket::update] state = SS_UNINITIALIZED, TaskListSize = %d", mTaskList.size());
					return;
				}
			}
		}
	}
}

void ThreadSocket::addSocketTask( SocketTask* task )
{
	mTaskList.push_back(task);
	CCLOG("[NetWork] [ThreadSocket::addSocketTask] add task type = %d, TaskListSize = %d", task->getType(), mTaskList.size());
}

void ThreadSocket::cleanSocketTask( void )
{
	CCLOG("[NetWork] [ThreadSocket::cleanSocketTask]");

	std::list<SocketTask*>::iterator it = mTaskList.begin();
	for(;it!=mTaskList.end();++it)
	{
		delete (*it);
	}
	mTaskList.clear();
}

void ThreadSocket::connect( const std::string& ip ,int port )
{
	CCLOG("[NetWork] [ThreadSocket::connect] ip = %s, port = %d",ip.c_str(), port);

	mIp = ip;
	mPort = port;

	SocketConnectTask* task = new SocketConnectTask(ip,port);
	addSocketTask(task);
}

void ThreadSocket::reconnect()
{
	if (mTaskList.size() && (*mTaskList.begin())->getType() == SocketTask::ST_CONNECT)
	{
		CCLOG("[NetWork] [ThreadSocket::reconnect] error! already in connect");
		return;
	}

	CCLOG("[NetWork] [ThreadSocket::reconnect]");

	disconnect();

	SocketConnectTask* task = new SocketConnectTask(mIp,mPort);
	addSocketTask(task);
}

void ThreadSocket::sendPacket( PacketData data, int opcode )
{
	CCLOG("[NetWork] [ThreadSocket::sendPacket] opcode = %d",opcode);

	SocketSendTask* task = new SocketSendTask(data, opcode);
	addSocketTask(task);
}

void ThreadSocket::disconnect()
{
	if (getState() == SS_UNINITIALIZED)
	{
		CCLOG("[NetWork] [ThreadSocket::disconnect] info state = SS_UNINITIALIZED");
		return;
	}

	CCLOG("[NetWork] [ThreadSocket::disconnect]");

	mThread.shutdown(); 

	if(mCurrentTask)
	{
		delete mCurrentTask;
		mCurrentTask = 0;
	}

	cleanSocketTask();

	AsyncSocket& socket = lockSocket();
	socket.onClose();

#ifdef WIN32
	WSACleanup();
#endif
	
	//setState(SS_UNINITIALIZED);

	CCLOG("[NetWork]  [ThreadSocket::disconnect] Disconnected!");

	fprintf(stderr,"ThreadSocket::disconnect\n");
	//mForceShutDone = true;

	releaseSocket();

	setState(SS_UNINITIALIZED);
}
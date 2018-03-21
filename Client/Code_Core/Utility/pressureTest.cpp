#include "pressureTest.h"
#include "AsyncSocket.h"
#include "PacketBase.h"
#include "PacketManager.h"
#include "StringConverter.h"
#include "GamePackets.h"

#include "CCStdC.h"

class LoginTask:public ThreadTask
{
public:
	int id;
	typedef std::list<std::pair<int,void*>> MESSAGE_LIST;
	MESSAGE_LIST mMessages;
	 

	 virtual int run()
	 {
		 std::string logs;
		logs.append("task start in thread! id:%d\n",id);
		 do
		 {
			 AsyncSocket socket;
			 WSADATA wsaData;   
			 if (WSAStartup(MAKEWORD(2,1), &wsaData))
			 { 

				 WSACleanup();
				 logs.append("%d:failed to StartUp!\n",id);
				 break; 
			 }
			 if(! socket.onCreate())
			 {
				 logs.append("%d:failed to create socket!\n",id);
				 break;
			 }
			 if(! socket.onConnect(pressureTest::Get()->mIP.c_str(), pressureTest::Get()->mPort))
			 {
				 logs.append("%d:failed to get connected!\n",id);
				 socket.onClose();
				 break;
			 }

			 MESSAGE_LIST::iterator it = mMessages.begin();
			 for(;it!=mMessages.end();++it)
			 {
				 if(it->first>=0)
				 {
					 if(socket.onSend(it->second,it->first)<0)
					 {
						 logs.append("failed to send package! opcode:"+StringConverter::toString(it->first));
					 }
					 delete it->second;
				 }
				 long waittime = 0;
				 bool waitReceived = false;
				 while(1)
				 {
					Sleep(10);
					waittime+=10;
					if(waittime>=10000)
					{
						logs.append("receive failed! id:%d", id);
						break;
					}
					char receiveBuffer[65536];
					if(socket.onReceive(receiveBuffer,65536,0)>0)
					{
						logs.append("receive package! time Delay: %d ms",waittime);
						waitReceived = true;
					}
					if(waitReceived && waittime>=pressureTest::Get()->mWaitBetweenPackage)
						break;
				 }
			 }


			 socket.onClose();
			 WSACleanup();
			 if(logs.empty())
				 printf("%d:session closed successfully!\n",id);
			 else
				 printf("%d:%s",id,logs.c_str());

		 }while(0);
		 delete this;
		 return 0;
	 }
};

pressureTest::pressureTest(void)
{
	mWaitBetweenPackage = 100;
}


pressureTest::~pressureTest(void)
{
}


void pressureTest::testLogin()
{
	mWaitBetweenPackage = 100;

	mPort = 25523;
	mIP = "youaihuyu01.1251001040-lbs.twsapp.com";
	
	timeval now;
	
	ThreadService mThreadService[10000];
	while(1)
	{
		for(int i=0;i<2000;++i)
		{
			LoginTask *task = new LoginTask;
			task->id = i;
			printf("start task! id:%d\n",i);

			//gettimeofday(&now,  0);

			PacketBase* pkt = PacketManager::Get()->createPacket(OPCODE_PLAYER_LOGIN_C);
			if(pkt)
			{
				OPLogin *msg = new OPLogin;
				msg->set_pwd("pswd");
				msg->set_version(1);
				std::string nameStr = StringConverter::toString(now.tv_sec)+StringConverter::toString(now.tv_usec);
				msg->set_puid(nameStr);
				printf("create task! name: %s\n",nameStr.c_str());
				int size;
				void* buffer = pkt->PackPacket(size,msg);

				task->mMessages.push_back(std::make_pair(size,buffer));

				delete pkt;
				delete msg;
			}

			mThreadService[i].execute(task);
			Sleep(200);
		}
		Sleep(15*60*1000);
	}
}

#define ADD_PACKET_BEGIN(opcode) \
	pkt = PacketManager::Get()->createPacket(opcode); \
	if(pkt){

#define ADD_PACKET_END \
	int size;void* buffer = pkt->PackPacket(size,msg); \
	task->mMessages.push_back(std::make_pair(size,buffer)); \
	delete pkt;delete msg;pkt=0;msg=0;}



void pressureTest::testPlay()
{
	mWaitBetweenPackage = 3000;//30*60/3 = 600 packets

	mIP = "youaihuyu01.1251001040-lbs.twsapp.com";
	mPort = 25523;


	struct timeval now;

	//printf("\ninput rank 1 player id(ask from database)!");
	int mChallangeID = 101500000;
	//scanf("%d",&mChallangeID);
	ThreadService mThreadService[10000];
	while(1)
	{
		for(int i=0;i<500;++i)
		{
			LoginTask *task = new LoginTask;
			task->id = i;
			PacketBase* pkt = 0;


			//gettimeofday(&now,  0);

			ADD_PACKET_BEGIN(OPCODE_PLAYER_LOGIN_C)
			OPLogin *msg = new OPLogin;
			msg->set_pwd("pswd");
			msg->set_version(1);
			std::string nameStr = StringConverter::toString(now.tv_sec)+StringConverter::toString(now.tv_usec);
			msg->set_puid(nameStr);
			ADD_PACKET_END

				printf("start task!\n");

			/*ADD_PACKET_BEGIN(OPCODE_INSTRUCTION_C)
			OPInstruction* msg = new OPInstruction;
			msg->set_name(StringConverter::toString(rand()));
			msg->set_version(1);
			pkt->set_selectsex(1);
			PacketManager::Get()->sendPakcet(_getOpcode() - 1,&pkt);
			ADD_PACKET_END*/

			for(int i=0;i<20;++i)
			{
				ADD_PACKET_BEGIN(OPCODE_MARKET_RECRUIT_DISCIPLE_C)
					OPMarketRecruitDisciple* msg = new OPMarketRecruitDisciple;
				msg->set_type(2);
				msg->set_kind(rand()%3+1);
				ADD_PACKET_END
			}

			int stages[]={101,101,102,102,103,103,104,104,105,105};
			for(int i=0;i<300;++i)
			{
//				//106 207 309 410
//				ADD_PACKET_BEGIN(OPCODE_USER_BATTLE_C)
//					OPUserBattle * msg = new OPUserBattle;;
//#ifdef OLD_BATTLE
//				msg->set_opponentid(0);
//#endif
//				msg->set_version(1);
//				msg->set_type(OPUserBattle_Type_CARRER);
//				msg->set_stage(stages[i%10]);
//				ADD_PACKET_END
			}

			for(int i=0;i<200;++i)
			{
				ADD_PACKET_BEGIN(OPCODE_CHALLENGE_OPPONENT_C)
					OPChallengeOpponent * msg = new OPChallengeOpponent;
				msg->set_opponentid(mChallangeID);
				msg->set_opponentrank(1);
				ADD_PACKET_END
			}

			
			mThreadService[i].execute(task);
			Sleep(100);
		}
		Sleep(32*60*1000);
	}
}

void pressureTest::testAmount()
{
	mWaitBetweenPackage = 5000;//90*60/30 = 180 packets
	mPort = 25523;
	mIP = "youaihuyu01.1251001040-lbs.twsapp.com";

	struct timeval now;
	
	ThreadService mThreadService[10000];
	while(1)
	{
		for(int i=0;i<1000;++i)
		{

			printf("start task!\n");

			LoginTask *task = new LoginTask;
			task->id = i;
			PacketBase* pkt = 0;

			//gettimeofday(&now,  0);

			ADD_PACKET_BEGIN(OPCODE_PLAYER_LOGIN_C)
				OPLogin *msg = new OPLogin;
			msg->set_pwd("pswd");
			msg->set_version(1);
			std::string nameStr = StringConverter::toString(now.tv_sec)+StringConverter::toString(now.tv_usec);
			msg->set_puid(nameStr);
			ADD_PACKET_END;

			/*ADD_PACKET_BEGIN(OPCODE_INSTRUCTION_C)
			OPInstruction* msg = new OPInstruction;
			msg->set_name(StringConverter::toString(rand()));
			msg->set_version(1);
			msg->set_discipleselecteditemid(1);
			ADD_PACKET_END;*/
			ADD_PACKET_BEGIN(OPCODE_UPDATE_USERINFO_BY_GM_C)
				OPUpdateUserInfoByGM* msg = new OPUpdateUserInfoByGM;
			msg->set_version(1);
			msg->set_msg("/additem tool 3002004 1000");
			ADD_PACKET_END;

			ADD_PACKET_BEGIN(OPCODE_UPDATE_USERINFO_BY_GM_C)
				OPUpdateUserInfoByGM* msg = new OPUpdateUserInfoByGM;
			msg->set_version(1);
			msg->set_msg("/additem tool 3001004 1000");
			ADD_PACKET_END

			for(int i=0;i<100;++i)
			{
				/*ADD_PACKET_BEGIN(OPCODE_USE_TOOL_C)
					OPUseTool* msg = new OPUseTool;
				msg->set_id(3001004);
				msg->set_num(10);
				ADD_PACKET_END*/
			}


			for(int i=0;i<100;++i)
			{
				/*ADD_PACKET_BEGIN(OPCODE_UPDATE_USERINFO_BY_GM_C)
					OPUpdateUserInfoByGM* msg = new OPUpdateUserInfoByGM;
				msg->set_version(1);
				char outStr[128];
				sprintf(outStr,"/additem hero %d 1", i);
				msg->set_msg(outStr);
				ADD_PACKET_END*/
			}

			mThreadService[i].execute(task);
			Sleep(500);
		}
		Sleep(90*60*1000);
	}
}

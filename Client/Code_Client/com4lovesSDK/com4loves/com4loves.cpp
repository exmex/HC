#include "com4loves.h"


//客户端向服务器同步服务器id
void com4loves::updateServerInfo(int serverID, const std::string& playerName, int playerID, int lvl, int vipLvl, int coin1, int coin2, bool pushSvr)
{
}

//刷新游戏服务器信息，用于切换用户后重置服务器列表
void com4loves::refreshServerInfo(const std::string& gameid, const std::string& puid, bool getSvr)
{


}

//获得账号服务器上记录的游戏服务器数量
int com4loves::getServerInfoCount()
{

	return 0;
}
//根据顺序获得账号服务器上第n个游戏服务器的服务器ID
int com4loves::getServerUserByIndex(int index)
{
	return 1;

}

#pragma once
#include "inifile.h"
#include "Singleton.h"
#include "TableReader.h"
#include <map>

class VaribleManager : public ConfigFile, public Singleton<VaribleManager>
{
public:
	VaribleManager(){ reload(); };
	~VaribleManager();
	void reload(){ load("txt/Varible.txt"); }
	static VaribleManager* getInstance();
private:

};

class PlatformRoleItem
{
public:
	unsigned int	id;//渠道编号
	std::string		name;//平台名称
	unsigned int	attentionStatus;//关注微信开关
	std::string		loadingFrameSeversConnection;//服务器开服提示各平台差异
	std::string		rechargeMaxLimit;//首冲翻倍额度
	unsigned int	bbsOpenStatus;//bbs开启状态
	std::string		showFeedBack;//反馈信息跳转页面规则
	unsigned int	webkitOpenStatus;//webkit公告页面开启状态
	std::string		aboutSetting;//关于页面设置
	std::string excludedAboutIds;//排除掉的关于页面条目id, 多个id用逗号分隔，形式如："1,2,3" 
	std::string excludedAnnoucementIds;//排除掉的公告页面条目id 多个id用逗号分隔，形式如："1,2,3" 
	unsigned int	isUsePrivateBigVersionUpdate;
	unsigned int	isUseSDKBBS;
	std::string		openBBSUrl;
	std::string		loadinScenceMsg;
	unsigned int	exit2platlogout;
	unsigned int    shareSwitch;//微信分享开关
private:
	void readline(std::stringstream& _stream)
	{
		_stream
			>> id
			>> name
			>> attentionStatus
			>> loadingFrameSeversConnection
			>> rechargeMaxLimit
			>> bbsOpenStatus
			>> showFeedBack
			>> webkitOpenStatus
			>> aboutSetting
			>> excludedAboutIds
			>> excludedAnnoucementIds
			>> isUsePrivateBigVersionUpdate
			>> isUseSDKBBS
			>> openBBSUrl
			>> loadinScenceMsg
			>> exit2platlogout
			>> shareSwitch;
	}
	friend class PlatformRoleTableManager;
};
class PlatformRoleTableManager
	: public TableReader
	, public Singleton<PlatformRoleTableManager>
{
public:

	PlatformRoleTableManager()
	{
		init("txt/PlatformRoleConfig.txt");
	}

	typedef std::map<unsigned int, PlatformRoleItem* > PlatformRoleList;

	void init(const std::string& filename);
	const PlatformRoleItem * getPlatformRoleByID(unsigned int id);
	const PlatformRoleItem * getPlatformRoleByName(std::string name);

	inline unsigned int getTotalNum() { return mPlatformRoleList.size(); };

	static PlatformRoleTableManager* getInstance();

private:
	virtual void readline(std::stringstream& _stream);
	PlatformRoleList mPlatformRoleList;
};
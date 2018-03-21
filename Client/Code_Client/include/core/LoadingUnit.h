#pragma once

#include <string>
#include "cocos2d.h"

class LoadingUnit : public cocos2d::CCObject
{
public:
	enum LOADSTATE
	{
		LS_OK,
		LS_FAILED,
		LS_DOING,
	};
	virtual LOADSTATE load() = 0;	
};

class LoadingGroup :  public LoadingUnit
{
public: 
	class LoadingGroupData
	{
	public:
		void addImageAsync(const std::string & imagefile){
			mlist.push_back(std::make_pair(TP_ImageFileAsync,imagefile));}
		void addImageSync(const std::string & imagefile){
			mlist.push_back(std::make_pair(TP_ImageFileSync,imagefile));}
		void addSound(const std::string & soundfile){
			mlist.push_back(std::make_pair(TP_SoundFile,soundfile));}
		friend class LoadingGroup;
	private:
		enum type
		{
			TP_ImageFileAsync,
			TP_ImageFileSync,
			TP_SoundFile,
		};
		typedef std::pair<type,std::string> LoadingGroupDatePair;
		typedef std::list<LoadingGroupDatePair> LoadingGroupDataList;
		LoadingGroupDataList mlist;
	};

	LoadingGroup(const LoadingGroupData &data);
	LoadingGroup(const std::string &configfile);
	LOADSTATE checkLoadState();

	LOADSTATE load();
	void loadAuto();

	unsigned int getTotalCount(){return mTotalCount;}
	unsigned int getFinishedCount(){return mFinishedCount;}
private:
	LoadingGroupData::LoadingGroupDataList mList;
	std::list<LoadingUnit*> mLoadingUnits;
	std::list<std::string> mCCBs;
	unsigned int mTotalCount;
	unsigned int mFinishedCount;

	friend class cocos2d::CCScheduler;
	void update(float dt);
	void pushLoadingUnit();
};

class LoadingImageAsync :  public LoadingUnit
{
public:
	LoadingImageAsync(const std::string & imagefile);
	LOADSTATE load();
	void loaddone(cocos2d::CCObject* texture);
private:
	std::string mImage;
	bool mLoaddone;
};

class LoadingImageSync : public LoadingUnit
{
public:
	LoadingImageSync(const std::string & imagefile);
	LOADSTATE load();

private:
	std::string mImage;
};

class LoadingSound : public LoadingUnit
{
public:
	LoadingSound(const std::string & soundfile);
	LOADSTATE load();

private:
	std::string mSound;
};

#include "stdafx.h"

#include "LoadingUnit.h"
#include "cocos2d.h"
#include "SimpleAudioEngine.h"
#include "json/json.h"
#include "GamePlatform.h"
#include "Language.h"
USING_NS_CC;

LoadingImageSync::LoadingImageSync( const std::string & imagefile )
{
	mImage = imagefile;
}

LoadingGroup::LOADSTATE LoadingImageSync::load()
{
	if(cocos2d::CCTextureCache::sharedTextureCache()->addImage(mImage.c_str()))
		return LS_OK;
	else
		return LS_FAILED;
}


LoadingImageAsync::LoadingImageAsync( const std::string & imagefile )
{
	mImage = imagefile;
	mLoaddone = false;
	cocos2d::CCTextureCache::sharedTextureCache()->addImageAsync(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(mImage.c_str()).c_str(),
		this,
		callfuncO_selector(LoadingImageAsync::loaddone)
		);
}

LoadingGroup::LOADSTATE LoadingImageAsync::load()
{
	if(mLoaddone)
	{
		if(cocos2d::CCTextureCache::sharedTextureCache()->addImage(mImage.c_str()))
			return LS_OK;
		else
			return LS_FAILED;
	}
	
	return LS_DOING;
}

void LoadingImageAsync::loaddone( cocos2d::CCObject* texture )
{
	mLoaddone = true;
}

LoadingSound::LoadingSound( const std::string & soundfile )
{
	mSound = soundfile;
}

LoadingGroup::LOADSTATE LoadingSound::load()
{
	CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(mSound.c_str()).c_str() );
	return LS_OK;
}


LoadingGroup::LoadingGroup( const LoadingGroupData &data )
	:mLoadingUnits()
{
	mList.assign(data.mlist.begin(),data.mlist.end());
	mTotalCount = mList.size();
	mFinishedCount = 0;
}

LoadingGroup::LoadingGroup( const std::string &configfile )
	:mLoadingUnits()
{

 	Json::Reader jreader;
 	Json::Value root;
 	unsigned long filesize;
 	char* pBuffer = (char*)getFileData(cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(configfile.c_str()).c_str(),"rt",&filesize);
	
	if(!pBuffer)
	{
		char msg[256];
		sprintf(msg,"Failed open file: %s !!",configfile.c_str());
		cocos2d::CCMessageBox(msg,Language::Get()->getString("@ShowMsgBoxTitle").c_str());
	}
	else
	{
		jreader.parse(pBuffer,root,false);
		CC_SAFE_DELETE_ARRAY(pBuffer);

		if(root["version"].asInt()<=1)
		{
			Json::Value files = root["files"];
			if(!files.empty() && files.isArray())
			{
				for(int i = 0;i < files.size();++i)
				{
					Json::Value unit = files[i];
					if(unit["file"].empty()) continue;
					if(unit["type"].asString() == std::string("imageAsync"))
					{
						mList.push_back(std::make_pair(LoadingGroup::LoadingGroupData::TP_ImageFileAsync,unit["file"].asString()));
					}
					if(unit["type"].asString() == std::string("imageSync"))
					{
						mList.push_back(std::make_pair(LoadingGroup::LoadingGroupData::TP_ImageFileSync,unit["file"].asString()));
					}
					if(unit["type"].asString() == std::string("sound"))
					{
						mList.push_back(std::make_pair(LoadingGroup::LoadingGroupData::TP_SoundFile,unit["file"].asString()));
					}
				}
			}

			mTotalCount = mList.size();
			mFinishedCount = 0;
		}
	}
 	CC_SAFE_DELETE_ARRAY(pBuffer);
}

LoadingGroup::LOADSTATE LoadingGroup::load()
{
	update(0);
	return checkLoadState();
}

void LoadingGroup::loadAuto()
{
	CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this,0,false);
}

void LoadingGroup::update( float dt )
{
	std::list<LoadingUnit*>::iterator it = mLoadingUnits.begin();
	for(;it!=mLoadingUnits.end();++it)
	{
		LoadingUnit* unit = *it;
		if(unit && unit->load()!=LS_DOING)
		{
			mFinishedCount++;
			unit->release();

			it = mLoadingUnits.erase(it);
			break;
		}
	}
	if(mLoadingUnits.empty() && !mList.empty())
	{
		pushLoadingUnit();
	}

	if(checkLoadState()==LS_OK)
	{
		CCDirector::sharedDirector()->getScheduler()->unscheduleUpdateForTarget(this);
	}
	
}

LoadingGroup::LOADSTATE LoadingGroup::checkLoadState()
{
	if(mLoadingUnits.empty() && mList.empty())
		return LS_OK;

	return LS_DOING;
}

void LoadingGroup::pushLoadingUnit()
{
	unsigned int mThreadCount = 0;
	//LoadingGroupData::LoadingGroupDataList::const_iterator it;
	
	while( !mList.empty())
	{
		mThreadCount++;
		if(mThreadCount>1)
			break;

		const LoadingGroupData::LoadingGroupDatePair& it = mList.front();

		if(!it.second.empty())
		{
			switch (it.first)
			{
			case LoadingGroupData::TP_ImageFileAsync:
				{
					LoadingImageAsync * img = new LoadingImageAsync(it.second);
					mLoadingUnits.push_back(img);
					mTotalCount++;
				}
				break;
			case LoadingGroupData::TP_ImageFileSync:
				{
					LoadingImageSync * snd = new LoadingImageSync(it.second);
					mLoadingUnits.push_back(snd);
					mTotalCount++;
				}
				break;
			case LoadingGroupData::TP_SoundFile:
				{
					LoadingSound * snd = new LoadingSound(it.second);
					mLoadingUnits.push_back(snd);
					mTotalCount++;
				}
				break;
			}
		}
		mList.pop_front();
	}
}

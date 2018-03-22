
#include "stdafx.h"

#include "AsyncSprite.h"
#include "cocos2d.h"


USING_NS_CC;

void AsyncSprite::setAsyncTexture( const std::string & texturename )
{
	mTextureName = texturename;

	const char * name = texturename.c_str();
	std::string path = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(texturename.c_str()).c_str();
	cocos2d::CCTexture2D* tex = cocos2d::CCTextureCache::sharedTextureCache()->textureForKey(path.c_str());
	if(tex!=0)
	{
		CCNode* _node = getChildByTag(TAG_SPRITE);
		if(_node)
			removeChildByTag(TAG_SPRITE);
		cocos2d::CCSprite *spirte = cocos2d::CCSprite::createWithTexture(tex);
		addChild(spirte,0,TAG_SPRITE);
	}
	else
	{
		cocos2d::CCTextureCache::sharedTextureCache()->addImageAsync(
			path.c_str(),
			this,
			callfuncO_selector(AsyncSprite::loadImageDone)
			);
	}

}


void AsyncSprite::setAsyncFrame( const std::string & frameName,const std::string & plistname )
{
	mFrameName = frameName;
	mTextureName ="";
	mPlistName = plistname;

	cocos2d::CCSpriteFrame* frame = cocos2d::CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName(frameName.c_str());
	if(frame)
	{
		CCNode* _node = getChildByTag(TAG_SPRITE);
		if(_node)
			removeChildByTag(TAG_SPRITE);
		cocos2d::CCSprite *spirte = cocos2d::CCSprite::createWithSpriteFrame(frame);
		addChild(spirte,0,TAG_SPRITE);
	}
	else
	{
		const char *pszPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(plistname.c_str()).c_str();
		cocos2d::CCDictionary* mDict = CCDictionary::createWithContentsOfFileThreadSafe(pszPath);
		mDict->retain();

		std::string texturePath("");

		CCDictionary* metadataDict = (CCDictionary*)mDict->objectForKey("metadata");
		if (metadataDict)
		{
			// try to read  texture file name from meta data
			texturePath = metadataDict->valueForKey("textureFileName")->getCString();
		}

		if (! texturePath.empty())
		{
			// build texture path relative to plist file
			texturePath = CCFileUtils::sharedFileUtils()->fullPathFromRelativeFile(texturePath.c_str(), pszPath);
		}
		else
		{
			// build texture path by replacing file extension
			texturePath = pszPath;

			// remove .xxx
			size_t startPos = texturePath.find_last_of("."); 
			texturePath = texturePath.erase(startPos);

			// append .png
			texturePath = texturePath.append(".png");

			CCLOG("cocos2d: CCSpriteFrameCache: Trying to use file %s as texture", texturePath.c_str());
		}

		mTextureName = texturePath;
		cocos2d::CCTextureCache::sharedTextureCache()->addImageAsync(
			texturePath.c_str(),
			this,
			callfuncO_selector(AsyncSprite::loadFrameDone)
			);
	}

}
void AsyncSprite::setColor(const cocos2d::ccColor3B color){
	mColor = color;
}


void AsyncSprite::loadImageDone( cocos2d::CCObject* texture )
{
	if(texture)
	{
		std::string path = cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(mTextureName.c_str()).c_str();
		cocos2d::CCTexture2D* tex = cocos2d::CCTextureCache::sharedTextureCache()->textureForKey(path.c_str());
		if(tex!=0)
		{
			CCNode* _node = getChildByTag(TAG_SPRITE);
			if(_node)
				removeChildByTag(TAG_SPRITE);
			cocos2d::CCSprite *spirte = cocos2d::CCSprite::createWithTexture(tex);
			spirte->setColor(mColor);
			addChild(spirte,0,TAG_SPRITE);
		}
	}
}

void AsyncSprite::loadFrameDone( cocos2d::CCObject* texture )
{
	if(texture && !mPlistName.empty())
	{
		CCTexture2D *pTexture = CCTextureCache::sharedTextureCache()->addImage(mTextureName.c_str());

		if (pTexture)
		{
			cocos2d::CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile(mPlistName.c_str(), pTexture);
			cocos2d::CCSpriteFrame* frame = cocos2d::CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName(mFrameName.c_str());
			if(frame)
			{
				CCNode* _node = getChildByTag(TAG_SPRITE);
				if(_node)
					removeChildByTag(TAG_SPRITE);
				cocos2d::CCSprite *spirte = cocos2d::CCSprite::createWithSpriteFrame(frame);
				addChild(spirte,0,TAG_SPRITE);
			}
		}
	}
}

AsyncSprite* AsyncSprite::createWithSprite( cocos2d::CCSprite *pSprite )
{
	AsyncSprite *pobSprite = new AsyncSprite();
//	pobSprite->childSprite = pSprite;
	if (pobSprite &&pobSprite->initWithSprite(pSprite))
	{
		pobSprite->autorelease();
		return pobSprite;
	}
	CC_SAFE_DELETE(pobSprite);
	return NULL;
}

bool AsyncSprite::initWithSprite( cocos2d::CCSprite* pSprite)
{
	if(!pSprite)
		return false;
	addChild(pSprite,0,TAG_SPRITE);
	return true;
}

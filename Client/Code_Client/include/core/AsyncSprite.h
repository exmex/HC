#pragma once
#include "cocos2d.h"

/************************************************************************/
/* Usage:
	Call createWithSprite to create a AsyncSprite, then call either of
	setAsyncTexture or setAsyncFrame to make it load it in background.
	When loaded done, the sprite will change it's display automatically.
*/
/************************************************************************/
class AsyncSprite : public cocos2d::CCNode
{

public:
	bool initWithSprite(cocos2d::CCSprite*);
	static AsyncSprite* createWithSprite(cocos2d::CCSprite *pSprite);
																		   
	void setAsyncTexture(const std::string & texturename);
	void setAsyncFrame(const std::string & frameName,const std::string & plistname);
	void setColor(const cocos2d::ccColor3B color);
private:
	std::string mTextureName;
	std::string mFrameName;
	std::string mPlistName;
	cocos2d::ccColor3B mColor;

	enum TAG
	{
		TAG_SPRITE,
	};
public:
	void loadImageDone(cocos2d::CCObject* texture);
	void loadFrameDone(cocos2d::CCObject* texture);
};


/**
 @author eboz
 */

#ifndef __HelloLua__LegendAnimationFILEINFO__
#define __HelloLua__LegendAnimationFILEINFO__

#include <iostream>
#include <vector>



namespace cocos2d{


class LegendAnimationEvent
{
public:
    enum _ETYPE
    {
        EVENT_SOUND=1, 
        EVENT_ADD_EFFECT=2,
        EVENT_REMOVE_EFFECT=3,
    };
	unsigned int type;   //-0x2C   
	std::string arg;//-0x28  + 0x4
	float x1; //-0x24   +0x8
	float x2; //-0x20   +0xC
	CCAffineTransform transform;//-0x1c  + 0x10
	int zorder;//-0x04   +0x28
};

typedef std::vector<LegendAnimationEvent> LegendAnimationEventArray;

class LegendAnimationFrameElement
{
public:
	unsigned short index;             //-#0x1C
	unsigned char alpha;	         //-#0x1A
	CCAffineTransform transform;     //-0x18  +4
};

typedef std::vector<LegendAnimationFrameElement> LegendAminationFrameElementArray;

class LegendAnimationFrame
{
public:
	LegendAnimationEventArray events; //+0x00 -> +0x08
	LegendAminationFrameElementArray elements;//+0x0C->+0x14
};

typedef std::vector<LegendAnimationFrame> LegendAnimationFrameArray;

class LegendAnimationElement
{
public:
	std::string layerName;    //+0
	std::string resouceName;  //+4
	unsigned int index;  //+8
	int width;     //+0c
    int height;    //+10
};
typedef std::vector<LegendAnimationElement> LegendAnimationElementArray;

class LegendAnimationAction
{
public:
	std::string name;//+0
	float		fps;  //+4
	LegendAnimationFrameArray frames;//+8
};
typedef std::vector<LegendAnimationAction> LegendAnimationActionArray;

class LegendAnimationFileInfo :public CCResourceObject
{
public:
	static LegendAnimationFileInfo *getAniFileInfo(std::string  const& filename);
	static void removeUnusedInfo();
	static void readFrames(LegendAnimationFileInfo * info, unsigned char* data, unsigned long dataSize);
	LegendAnimationFileInfo(std::string  const& filename);
	virtual ~LegendAnimationFileInfo();
	void dealSoundResource(bool isLoad);
	CCSpriteFrame* getSpriteFrame(char  const* frameName);


	static CCResourceCache  _cacheAniFileInfo;
	
	std::string		    _name;  //+0x18
	float				_scalefactor;//+0x1C
	LegendAnimationElementArray    _elements; //+0x20 - 0x28

	LegendAnimationActionArray     _actions;  //+0x2C - 0x34
    
    CCSpriteFrameCache   *_spriteCache; // +0x38
    
   // text:001494D8                 LDR     R6, [R3,#0x3C]
   // .text:001494DA                 LDR     R3, [R3,#0x40]
};

}

#endif /* defined(__HelloLua__LegendAnimationFILEINFO__) */


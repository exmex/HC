/**
 @author dany
 */

#ifndef __HelloLua__HGAnimationFILEINFO__
#define __HelloLua__HGAnimationFILEINFO__

#include <iostream>
#include <vector>



namespace cocos2d{


class HGAnimationEvent
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

typedef std::vector<HGAnimationEvent> HGAnimationEventArray;

class HGAnimationFrameElement
{
public:
	unsigned short index;             //-#0x1C
	unsigned char alpha;	         //-#0x1A
	CCAffineTransform transform;     //-0x18  +4
};

typedef std::vector<HGAnimationFrameElement> HGAminationFrameElementArray;

class HGAnimationFrame
{
public:
	HGAnimationEventArray events; //+0x00 -> +0x08
	HGAminationFrameElementArray elements;//+0x0C->+0x14
};

typedef std::vector<HGAnimationFrame> HGAnimationFrameArray;

class HGAnimationElement
{
public:
	std::string layerName;    //+0
	std::string resouceName;  //+4
	unsigned int index;  //+8
	int width;     //+0c
    int height;    //+10
};
typedef std::vector<HGAnimationElement> HGAnimationElementArray;

class HGAnimationAction
{
public:
	std::string name;//+0
	float		fps;  //+4
	HGAnimationFrameArray frames;//+8
};
typedef std::vector<HGAnimationAction> HGAnimationActionArray;

class HGAnimationFileInfo :public CCResourceObject
{
public:
	static HGAnimationFileInfo *getAniFileInfo(std::string  const& filename);
	static void removeUnusedInfo();
	static void readFrames(HGAnimationFileInfo * info, unsigned char* data, unsigned long dataSize);
	HGAnimationFileInfo(std::string  const& filename);
	virtual ~HGAnimationFileInfo();
	void dealSoundResource(bool isLoad);
	CCSpriteFrame* getSpriteFrame(char  const* frameName);


	static CCResourceCache  _cacheAniFileInfo;
	
	std::string		    _name;  //+0x18
	float				_scalefactor;//+0x1C
	HGAnimationElementArray    _elements; //+0x20 - 0x28

	HGAnimationActionArray     _actions;  //+0x2C - 0x34
    
    CCSpriteFrameCache   *_spriteCache; // +0x38
    
   // text:001494D8                 LDR     R6, [R3,#0x3C]
   // .text:001494DA                 LDR     R3, [R3,#0x40]
};

}

#endif /* defined(__HelloLua__HGAnimationFILEINFO__) */


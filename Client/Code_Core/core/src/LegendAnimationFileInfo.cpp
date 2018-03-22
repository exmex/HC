#include "cocos2d.h"
#include "LegendAnimationFileInfo.h"
#include "SimpleAudioEngine.h"
#include "apiforlua.h"
#include "HeroFileUtils.h"
#include "GameEncryptKey.h"
USING_NS_CC;


CCResourceCache LegendAnimationFileInfo::_cacheAniFileInfo;

LegendAnimationFileInfo *LegendAnimationFileInfo::getAniFileInfo(std::string  const& name)
{
	LegendAnimationFileInfo * obj = (LegendAnimationFileInfo *)_cacheAniFileInfo.objectForKey(name);
	if (obj)
	{
		return obj;
	}
	obj = new LegendAnimationFileInfo(name);
	_cacheAniFileInfo.setObject(obj, name);
	obj->release();

	return obj;
}




void LegendAnimationFileInfo::removeUnusedInfo()
{
    if(_cacheAniFileInfo.count() ==0)
        return;
    
    CCDictElement* pElement = NULL;
	CCResourceCache * pdict = &_cacheAniFileInfo;
    std::list< CCDictElement*> unusedInfoList;
    CCDICT_FOREACH(pdict, pElement){
        if( ((CCObject *)pElement)->retainCount()==1)
        {
            unusedInfoList.push_back(pElement);
        }
    }
    
    for(std::list< CCDictElement*>::iterator it=unusedInfoList.begin();it!=
        unusedInfoList.end();it++)
    {
        pdict->removeObjectForElememt(*it);
    }
    
}


void readAffineTransform(unsigned char *& data, CCAffineTransform & out)
{
	memcpy(&out, data, sizeof(CCAffineTransform));
	data += sizeof(CCAffineTransform);
}


void readfloat(unsigned char *& data, float & out)
{
	memcpy(&out, data, sizeof(float));
	data += sizeof(float);
}

void readInt(unsigned char *& data, unsigned int & out)
{
	memcpy(&out, data, sizeof(unsigned int));
	data += sizeof(unsigned int);
}


void readString(unsigned char *&data, std::string & out)
{

	unsigned int sz = 0;
	readInt(data, sz);
	out = std::string((char*)data, (char*)data + sz);
	data += sz;
}



void LegendAnimationFileInfo::readFrames(LegendAnimationFileInfo * info, unsigned char* data, unsigned long dataSize)
{
    
    unsigned char *pdataEnd  = data + dataSize;
	float factor = 1.0f / g_ani_scale_factor;

	readString(data, info->_name);
	
	unsigned int elementCount = 0;
	readInt(data, elementCount);
	info->_elements.resize(elementCount);

	for (unsigned int i = 0; i < elementCount; i++)
	{
		LegendAnimationElement &ele = info->_elements[i];
		readString(data, ele.layerName);
		readString(data, ele.resouceName);
		readInt(data, ele.index);
		


		CCSpriteFrame *frame = info->getSpriteFrame(ele.resouceName.c_str());
		if (frame != NULL)
		{
			/*

			CCPoint m_obOffset;
			CCSize m_obOriginalSize; +0x20 , +0x24
			CCRect m_obRectInPixels;
			bool   m_bRotated;
			CCRect m_obRect;
			CCPoint m_obOffsetInPixels;
			CCSize m_obOriginalSizeInPixels;
			CCTexture2D *m_pobTexture;
			std::string  m_strTextureFilename;
			};
			*/
			info->_elements[i].width = frame->getOriginalSize().width;
            info->_elements[i].height = frame->getOriginalSize().height;
		}
	}

	unsigned int actionCount = 0;

	readInt(data, actionCount);
	info->_actions.resize(actionCount);
	for (unsigned int i = 0; i < actionCount; i++)
	{
		LegendAnimationAction &action = info->_actions[i];
		readString(data, action.name);
		readfloat(data, action.fps);
		
		unsigned int frameCount = 0;
		readInt(data, frameCount);
		action.frames.resize(frameCount);
		for (unsigned int j = 0; j < frameCount; j++)
		{
			LegendAnimationFrame &frame = action.frames[j];

			unsigned int eventCount = 0;
			readInt(data, eventCount);
			frame.events.resize(eventCount);

			for (unsigned int k = 0; k < eventCount; k++)
			{
				LegendAnimationEvent &evt = frame.events[k];
				readInt(data, evt.type);
				readString(data, evt.arg);
				readfloat(data, evt.x1);
				readfloat(data, evt.x2);
				readAffineTransform(data, evt.transform);
				readInt(data, (unsigned int &)evt.zorder);
			}


			unsigned int felemCount = 0;
			readInt(data, felemCount);
			frame.elements.resize(felemCount);
			for (unsigned int k = 0; k < felemCount; k++)
			{
				LegendAnimationFrameElement &felem = frame.elements[k];
				felem.index = *(unsigned short*)data;
				data += 2;
				felem.alpha = *data;
				data += 1;
				readAffineTransform(data, felem.transform);
				
				float dstA = felem.transform.a * factor;
				float dstB = felem.transform.b * factor;
				float dstC = felem.transform.c * factor;
				float dstD = felem.transform.d * factor;
				float fwidth = info->_elements[felem.index - 1].width;
				float fheight = info->_elements[felem.index - 1].height;
				float dstTX = (dstC * fheight * 0.5f - dstA * 0.5f * fwidth) + felem.transform.tx;
				float dstTY = (dstD * -0.5f *fheight + dstB * 0.5f * fwidth) - felem.transform.ty;
				felem.transform = CCAffineTransformMake(dstA, -dstB, -dstC, dstD, dstTX, dstTY);
                
//                printf("%s frame %d , index:%d : %f %f %f %f %f %f \n",action.name.c_str(),j, k, dstA, dstB, dstC, dstD, dstTX, dstTY);
//                printf("\n");
			}

		}
	}

	info->dealSoundResource(true);
    
    if(pdataEnd != data)
    {
        CCLog("READ Animation File Info FAILED %s\n",info->_name.c_str());
    }

}


LegendAnimationFileInfo::LegendAnimationFileInfo(std::string  const& name)
{
    _spriteCache = new CCSpriteFrameCache();
	_spriteCache->init();
	_scalefactor = g_ani_scale_factor;

	CCFileUtils *fu = CCFileUtils::sharedFileUtils();
	
	std::string  filename = "anim/" + name + ".ani";

	filename = LegendFindFileCpp(filename.c_str());

	bool isCompatible = false;
	if (filename == "") 
	{
		//temp 兼容格式，后面动画替换完成后，将此处代码去掉 modify by dylan
		filename = "anim/" + name + ".abc";
		filename = LegendFindFileCpp(filename.c_str());
		isCompatible = true;
		if (filename == "")
		{
			std::string errorLog = "[LegendAnimationFileInfo|LegendAnimationFileInfo] Anim file not found:" + name + ".ani !";
			printErrorInLua(errorLog.c_str());
			bool isShowErrorBox = false;
#ifdef _DEBUG 
			isShowErrorBox = true;
#endif	
#ifdef WIN32 
			isShowErrorBox = true;
#endif	
			if (isShowErrorBox)CCMessageBox(errorLog.c_str(), "File Not Found");
			return;
		}
	}
    
	this->_name = name;

	unsigned long  dataSize = 0;
	unsigned char * zipData = fu->getFileData(filename.c_str(), "rb", &dataSize,true,0);

	unsigned long plistSize = 0;
	unsigned char * plistData = fu->getFileDataFromZipData(zipData, dataSize, isCompatible?"plist":"sheet.plist", &plistSize, "");
    
	CCDictionary *dict = fu->createCCDictionaryWithData(plistData, plistSize);


	unsigned long pvrSize = 0;
	unsigned char * pvrData= fu->getFileDataFromZipData(zipData, dataSize, "sheet.pvr", &pvrSize, "");
	bool isPVR = true;
	if (pvrData == NULL)
	{
		pvrData = fu->getFileDataFromZipData(zipData, dataSize, "sheet.png", &pvrSize, "");
		if (!pvrData)
		{
			CCLog("[LegendAnimationFileInfo|LegendAnimationFileInfo ]pvrData is null %p  of %s\n", pvrData, name.c_str());
		}
		isPVR = false;
	}
    
	CCTexture2D *texture = new  CCTexture2D();
	if (isPVR)
	{
		bool isok = texture->initWithPVRData(pvrData, pvrSize);

		if(isok)
		{
			//ANDROID TODO:
#if CC_ENABLE_CACHE_TEXTURE_DATA
			VolatileTexture::addZipPVRTexture(texture, filename.c_str());
#endif

		}
	}
	else
	{
		CCImage* image = new CCImage();
		image->initWithImageData(pvrData, pvrSize);
		bool isok = texture->initWithImage(image);
		if (isok)
		{
			//ANDROID TODO:
#if CC_ENABLE_CACHE_TEXTURE_DATA
			VolatileTexture::addZipPVRTexture(texture,filename.c_str());
#endif

		}
		image->release();
	}
	

	_spriteCache->addSpriteFramesWithDictionary(dict, texture);

	unsigned long chaSize = 0;
	unsigned char * chaData = fu->getFileDataFromZipData(zipData, dataSize, isCompatible?"cha":"sheet.key", &chaSize, "");

	readFrames(this, chaData, chaSize);

	texture->release();
	dict->release();

	CC_SAFE_DELETE_ARRAY(plistData);
	//delete[] pvrData;
	CC_SAFE_DELETE_ARRAY(chaData);

	CC_SAFE_DELETE_ARRAY(zipData);
}

LegendAnimationFileInfo::~LegendAnimationFileInfo()
{
	this->_actions.clear();
	this->_elements.clear();
	_spriteCache->removeSpriteFrames();
    _spriteCache->release();
}

void LegendAnimationFileInfo::dealSoundResource(bool isLoad)
{
    for(size_t i= 0; i< _actions.size();i++)
    {
        LegendAnimationAction const&  act = _actions[i];
        for(size_t j=0;j<act.frames.size();j++)
        {
            LegendAnimationFrame const &frm = act.frames[j];
            for(size_t k=0;k<frm.events.size();k++)
            {
                LegendAnimationEvent const & evt = frm.events[k];
                if(evt.type==LegendAnimationEvent::EVENT_SOUND)
                {
                    std::string soundFile = "sound/"+evt.arg;
                    CocosDenshion::SimpleAudioEngine *ae = CocosDenshion::SimpleAudioEngine::sharedEngine();
                    if(isLoad)
                    {
                        ae->preloadEffect(soundFile.c_str());
                    }
                    else{
                        ae->unloadEffect(soundFile.c_str());
                    }
                    
                    
                }
            }
        }
    }
}

CCSpriteFrame* LegendAnimationFileInfo::getSpriteFrame(char  const* frameName)
{
    std::string fmtName = frameName;
    fmtName+=".png";
	return _spriteCache->spriteFrameByName(fmtName.c_str());
}


/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2011      Zynga Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

// ideas taken from:
//     . The ocean spray in your face [Jeff Lander]
//        http://www.double.co.nz/dust/col0798.pdf
//     . Building an Advanced Particle System [John van der Burg]
//        http://www.gamasutra.com/features/20000623/vanderburg_01.htm
//   . LOVE game engine
//        http://love2d.org/
//
//
// Radius mode support, from 71 squared
//        http://particledesigner.71squared.com/
//
// IMPORTANT: Particle Designer is supported by cocos2d, but
// 'Radius Mode' in Particle Designer uses a fixed emit rate of 30 hz. Since that can't be guaranteed in cocos2d,
//  cocos2d uses a another approach, but the results are almost identical. 
//

#include "CCParticleSystem.h"
#include "CCParticleBatchNode.h"
#include "ccTypes.h"
#include "textures/CCTextureCache.h"
#include "textures/CCTextureAtlas.h"
#include "support/base64.h"
#include "support/CCPointExtension.h"
#include "platform/CCFileUtils.h"
#include "platform/CCImage.h"
#include "platform/platform.h"
#include "support/zip_support/ZipUtils.h"
#include "CCDirector.h"
#include "support/CCProfiling.h"
// opengl
#include "CCGL.h"

#include <string>

using namespace std;


NS_CC_BEGIN

// ideas taken from:
//     . The ocean spray in your face [Jeff Lander]
//        http://www.double.co.nz/dust/col0798.pdf
//     . Building an Advanced Particle System [John van der Burg]
//        http://www.gamasutra.com/features/20000623/vanderburg_01.htm
//   . LOVE game engine
//        http://love2d.org/
//
//
// Radius mode support, from 71 squared
//        http://particledesigner.71squared.com/
//
// IMPORTANT: Particle Designer is supported by cocos2d, but
// 'Radius Mode' in Particle Designer uses a fixed emit rate of 30 hz. Since that can't be guaranteed in cocos2d,
//  cocos2d uses a another approach, but the results are almost identical. 
//

CCParticleSystem::CCParticleSystem()
: m_sPlistFile("")
, m_fElapsed(0)
, m_pParticles(NULL)
, m_fEmitCounter(0)
, m_uParticleIdx(0)
, m_pBatchNode(NULL)
, m_uAtlasIndex(0)
, m_bTransformSystemDirty(false)
, m_bPrepareSystemDirty(false)
, m_uAllocatedParticles(0)
, m_bIsActive(true)
, m_uParticleCount(0)
, m_fDuration(0)
, m_tSourcePosition(CCPointZero)
, m_tPosVar(CCPointZero)
, m_fLife(0)
, m_fLifeVar(0)
, m_fMiddleLife(0)
, m_fColorMiddleLife(0)
, m_fAngle(0)
, m_fAngleVar(0)
, m_fStartSize(0)
, m_fStartSizeVar(0)
, m_fMiddleSize(0)
, m_fMiddleSizeVar(0)
, m_fEndSize(0)
, m_fEndSizeVar(0)
, m_fStartSpin(0)
, m_fStartSpinVar(0)
, m_fEndSpin(0)
, m_fEndSpinVar(0)
, m_fEmissionRate(0)
, m_uTotalParticles(0)
, m_pTexture(NULL)
, m_bOpacityModifyRGB(false)
, m_bPrepare(false)
, m_bIsBlendAdditive(false)
, m_ePositionType(kCCPositionTypeFree)
, m_bIsAutoRemoveOnFinish(false)
, m_nEmitterMode(kCCParticleModeGravity)
, m_fMiddSpeed(20.0f)
, m_fMiddSpeedVar(0.0f)
, m_fEndSpeed(0.0f)
, m_fEndSpeedVar(0.0f)
, m_fMiddldSpeedLife(1.0f)
{
    modeA.gravity = CCPointZero;
    modeA.speed = 0;
    modeA.speedVar = 0;
    modeA.tangentialAccel = 0;
    modeA.tangentialAccelVar = 0;
    modeA.radialAccel = 0;
    modeA.radialAccelVar = 0;
    modeA.rotationIsDir = false;
	modeA.dirAngle = 0.0;
	modeA.dirAngleVar = 0.0;
    modeB.startRadius = 0;
    modeB.startRadiusVar = 0;
    modeB.endRadius = 0;
    modeB.endRadiusVar = 0;            
    modeB.rotatePerSecond = 0;
    modeB.rotatePerSecondVar = 0;
    m_tBlendFunc.src = CC_BLEND_SRC;
    m_tBlendFunc.dst = CC_BLEND_DST;
	m_fParScaleX = 1.0;
	m_fParScaleY = 1.0;
}
// implementation CCParticleSystem

CCParticleSystem * CCParticleSystem::create(const char *plistFile)
{
    CCParticleSystem *pRet = new CCParticleSystem();
    if (pRet && pRet->initWithFile(plistFile))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return pRet;
}

CCParticleSystem* CCParticleSystem::createWithTotalParticles(unsigned int numberOfParticles)
{
    CCParticleSystem *pRet = new CCParticleSystem();
    if (pRet && pRet->initWithTotalParticles(numberOfParticles))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return pRet;
}

bool CCParticleSystem::init()
{
    return initWithTotalParticles(150);
}

bool CCParticleSystem::initWithFile(const char *plistFile)
{
    bool bRet = false;
    m_sPlistFile = CCFileUtils::sharedFileUtils()->fullPathForFilename(plistFile);
    CCDictionary *dict = CCDictionary::createWithContentsOfFileThreadSafe(m_sPlistFile.c_str());

    CCAssert( dict != NULL, "Particles: file not found");
    
    // XXX compute path from a path, should define a function somewhere to do it
    string listFilePath = plistFile;
    if (listFilePath.find('/') != string::npos)
    {
        listFilePath = listFilePath.substr(0, listFilePath.rfind('/') + 1);
        bRet = this->initWithDictionary(dict, listFilePath.c_str());
    }
    else
    {
        bRet = this->initWithDictionary(dict, "");
    }
    
    dict->release();

    return bRet;
}

bool CCParticleSystem::initWithDictionary(CCDictionary *dictionary)
{
    return initWithDictionary(dictionary, "");
}

bool CCParticleSystem::initWithDictionary(CCDictionary *dictionary, const char *dirname)
{
    bool bRet = false;
    unsigned char *buffer = NULL;
    unsigned char *deflated = NULL;
    CCImage *image = NULL;
    do 
    {
        int maxParticles = dictionary->valueForKey("maxParticles")->intValue();
        // self, not super
        if(this->initWithTotalParticles(maxParticles))
        {
            // angle
            m_fAngle = dictionary->valueForKey("angle")->floatValue();
            m_fAngleVar = dictionary->valueForKey("angleVariance")->floatValue();

            // duration
            m_fDuration = dictionary->valueForKey("duration")->floatValue();

            // blend function 
            m_tBlendFunc.src = dictionary->valueForKey("blendFuncSource")->intValue();
            m_tBlendFunc.dst = dictionary->valueForKey("blendFuncDestination")->intValue();

            // color
            m_tStartColor.r = dictionary->valueForKey("startColorRed")->floatValue();
            m_tStartColor.g = dictionary->valueForKey("startColorGreen")->floatValue();
            m_tStartColor.b = dictionary->valueForKey("startColorBlue")->floatValue();
            m_tStartColor.a = dictionary->valueForKey("startColorAlpha")->floatValue();

            m_tStartColorVar.r = dictionary->valueForKey("startColorVarianceRed")->floatValue();
            m_tStartColorVar.g = dictionary->valueForKey("startColorVarianceGreen")->floatValue();
            m_tStartColorVar.b = dictionary->valueForKey("startColorVarianceBlue")->floatValue();
            m_tStartColorVar.a = dictionary->valueForKey("startColorVarianceAlpha")->floatValue();

            m_tEndColor.r = dictionary->valueForKey("finishColorRed")->floatValue();
            m_tEndColor.g = dictionary->valueForKey("finishColorGreen")->floatValue();
            m_tEndColor.b = dictionary->valueForKey("finishColorBlue")->floatValue();
            m_tEndColor.a = dictionary->valueForKey("finishColorAlpha")->floatValue();

            m_tEndColorVar.r = dictionary->valueForKey("finishColorVarianceRed")->floatValue();
            m_tEndColorVar.g = dictionary->valueForKey("finishColorVarianceGreen")->floatValue();
            m_tEndColorVar.b = dictionary->valueForKey("finishColorVarianceBlue")->floatValue();
            m_tEndColorVar.a = dictionary->valueForKey("finishColorVarianceAlpha")->floatValue();

            // particle size
            m_fStartSize = dictionary->valueForKey("startParticleSize")->floatValue();
            m_fStartSizeVar = dictionary->valueForKey("startParticleSizeVariance")->floatValue();
            m_fEndSize = dictionary->valueForKey("finishParticleSize")->floatValue();
            m_fEndSizeVar = dictionary->valueForKey("finishParticleSizeVariance")->floatValue();

            // position
            float x = dictionary->valueForKey("sourcePositionx")->floatValue();
            float y = dictionary->valueForKey("sourcePositiony")->floatValue();
            this->setPosition( ccp(x,y) );            
            m_tPosVar.x = dictionary->valueForKey("sourcePositionVariancex")->floatValue();
            m_tPosVar.y = dictionary->valueForKey("sourcePositionVariancey")->floatValue();

            // Spinning
            m_fStartSpin = dictionary->valueForKey("rotationStart")->floatValue();
            m_fStartSpinVar = dictionary->valueForKey("rotationStartVariance")->floatValue();
            m_fEndSpin= dictionary->valueForKey("rotationEnd")->floatValue();
            m_fEndSpinVar= dictionary->valueForKey("rotationEndVariance")->floatValue();

            m_nEmitterMode = dictionary->valueForKey("emitterType")->intValue();

            // Mode A: Gravity + tangential accel + radial accel
            if( m_nEmitterMode == kCCParticleModeGravity ) 
            {
                // gravity
                modeA.gravity.x = dictionary->valueForKey("gravityx")->floatValue();
                modeA.gravity.y = dictionary->valueForKey("gravityy")->floatValue();

                // speed
                modeA.speed = dictionary->valueForKey("speed")->floatValue();
                modeA.speedVar = dictionary->valueForKey("speedVariance")->floatValue();

				//add by xinghui
				m_fMiddSpeed = dictionary->valueForKey("middSpeed")->floatValue();
				m_fMiddSpeedVar = dictionary->valueForKey("middSpeed")->floatValue();
				m_fEndSpeed = dictionary->valueForKey("middSpeed")->floatValue();
				m_fEndSpeedVar = dictionary->valueForKey("middSpeed")->floatValue();
				m_fMiddldSpeedLife = dictionary->valueForKey("middSpeed")->floatValue();


                // radial acceleration
                modeA.radialAccel = dictionary->valueForKey("radialAcceleration")->floatValue();
                modeA.radialAccelVar = dictionary->valueForKey("radialAccelVariance")->floatValue();

                // tangential acceleration
                modeA.tangentialAccel = dictionary->valueForKey("tangentialAcceleration")->floatValue();
                modeA.tangentialAccelVar = dictionary->valueForKey("tangentialAccelVariance")->floatValue();
                
                // rotation is dir
                modeA.rotationIsDir = dictionary->valueForKey("rotationIsDir")->boolValue();
            }

            // or Mode B: radius movement
            else if( m_nEmitterMode == kCCParticleModeRadius ) 
            {
                modeB.startRadius = dictionary->valueForKey("maxRadius")->floatValue();
                modeB.startRadiusVar = dictionary->valueForKey("maxRadiusVariance")->floatValue();
                modeB.endRadius = dictionary->valueForKey("minRadius")->floatValue();
                modeB.endRadiusVar = 0.0f;
                modeB.rotatePerSecond = dictionary->valueForKey("rotatePerSecond")->floatValue();
                modeB.rotatePerSecondVar = dictionary->valueForKey("rotatePerSecondVariance")->floatValue();

            } else {
                CCAssert( false, "Invalid emitterType in config file");
                CC_BREAK_IF(true);
            }

            // life span
            m_fLife = dictionary->valueForKey("particleLifespan")->floatValue();
            m_fLifeVar = dictionary->valueForKey("particleLifespanVariance")->floatValue();

            // emission Rate
            m_fEmissionRate = m_uTotalParticles / m_fLife;

            //don't get the internal texture if a batchNode is used
            if (!m_pBatchNode)
            {
                // Set a compatible default for the alpha transfer
                m_bOpacityModifyRGB = false;

                // texture        
                // Try to get the texture from the cache
                std::string textureName = dictionary->valueForKey("textureFileName")->getCString();
                
                size_t rPos = textureName.rfind('/');
               
                if (rPos != string::npos)
                {
                    string textureDir = textureName.substr(0, rPos + 1);
                    
                    if (dirname != NULL && textureDir != dirname)
                    {
                        textureName = textureName.substr(rPos+1);
                        textureName = string(dirname) + textureName;
                    }
                }
                else
                {
                    if (dirname != NULL)
                    {
                        textureName = string(dirname) + textureName;
                    }
                }
                
                CCTexture2D *tex = NULL;
                
                if (textureName.length() > 0)
                {
                    // set not pop-up message box when load image failed
                    bool bNotify = CCFileUtils::sharedFileUtils()->isPopupNotify();
                    CCFileUtils::sharedFileUtils()->setPopupNotify(false);
                    tex = CCTextureCache::sharedTextureCache()->addImage(textureName.c_str());
                    // reset the value of UIImage notify
                    CCFileUtils::sharedFileUtils()->setPopupNotify(bNotify);
                }
                
                if (tex)
                {
                    setTexture(tex);
                }
                else
                {                        
                    const char *textureData = dictionary->valueForKey("textureImageData")->getCString();
                    CCAssert(textureData, "");
                    
                    int dataLen = strlen(textureData);
                    if(dataLen != 0)
                    {
                        // if it fails, try to get it from the base64-gzipped data    
                        int decodeLen = base64Decode((unsigned char*)textureData, (unsigned int)dataLen, &buffer);
                        CCAssert( buffer != NULL, "CCParticleSystem: error decoding textureImageData");
                        CC_BREAK_IF(!buffer);
                        
                        int deflatedLen = ZipUtils::ccInflateMemory(buffer, decodeLen, &deflated);
                        CCAssert( deflated != NULL, "CCParticleSystem: error ungzipping textureImageData");
                        CC_BREAK_IF(!deflated);
                        
                        // For android, we should retain it in VolatileTexture::addCCImage which invoked in CCTextureCache::sharedTextureCache()->addUIImage()
                        image = new CCImage();
                        bool isOK = image->initWithImageData(deflated, deflatedLen);
                        CCAssert(isOK, "CCParticleSystem: error init image with Data");
                        CC_BREAK_IF(!isOK);
                        
                        setTexture(CCTextureCache::sharedTextureCache()->addUIImage(image, textureName.c_str()));

                        image->release();
                    }
                }
                CCAssert( this->m_pTexture != NULL, "CCParticleSystem: error loading the texture");
            }
            bRet = true;
        }
    } while (0);
    CC_SAFE_DELETE_ARRAY(buffer);
    CC_SAFE_DELETE_ARRAY(deflated);
    return bRet;
}

bool CCParticleSystem::initWithTotalParticles(unsigned int numberOfParticles)
{
    m_uTotalParticles = numberOfParticles;

    CC_SAFE_FREE(m_pParticles);
    
    m_pParticles = (tCCParticle*)calloc(m_uTotalParticles, sizeof(tCCParticle));

    if( ! m_pParticles )
    {
        CCLOG("Particle system: not enough memory");
        this->release();
        return false;
    }
    m_uAllocatedParticles = numberOfParticles;

    if (m_pBatchNode)
    {
        for (unsigned int i = 0; i < m_uTotalParticles; i++)
        {
            m_pParticles[i].atlasIndex=i;
        }
    }
    // default, active
    m_bIsActive = true;

    // default blend function
    m_tBlendFunc.src = CC_BLEND_SRC;
    m_tBlendFunc.dst = CC_BLEND_DST;

    // default movement type;
    m_ePositionType = kCCPositionTypeFree;

    // by default be in mode A:
    m_nEmitterMode = kCCParticleModeGravity;

    // default: modulate
    // XXX: not used
    //    colorModulate = YES;

    m_bIsAutoRemoveOnFinish = false;

    // Optimization: compile updateParticle method
    //updateParticleSel = @selector(updateQuadWithParticle:newPosition:);
    //updateParticleImp = (CC_UPDATE_PARTICLE_IMP) [self methodForSelector:updateParticleSel];
    //for batchNode
    m_bTransformSystemDirty = false;
    // update after action in run!
    this->scheduleUpdateWithPriority(1);

    return true;
}

CCParticleSystem::~CCParticleSystem()
{
    // Since the scheduler retains the "target (in this case the ParticleSystem)
	// it is not needed to call "unscheduleUpdate" here. In fact, it will be called in "cleanup"
    //unscheduleUpdate();
    CC_SAFE_FREE(m_pParticles);
    CC_SAFE_RELEASE(m_pTexture);
}

tCCParticle* CCParticleSystem::addParticle()
{
    if (this->isFull())
    {
        return 0;
    }

    tCCParticle * particle = &m_pParticles[ m_uParticleCount ];
    this->initParticle(particle);
    ++m_uParticleCount;

    return particle;
}

void CCParticleSystem::initParticle(tCCParticle* particle)
{
    // timeToLive
    // no negative life. prevent division by 0
    particle->timeToLive = m_fLife + m_fLifeVar * CCRANDOM_MINUS1_1();
    particle->timeToLive = MAX(0, particle->timeToLive);
	particle->livedTime = 0.0f;

	//should be in [0,timeToLive]
	m_fMiddleLife = MAX(0, m_fMiddleLife);
	m_fMiddleLife = MIN(particle->timeToLive, m_fMiddleLife);

	m_fColorMiddleLife = MAX(0, m_fColorMiddleLife );
	m_fColorMiddleLife = MIN(particle->timeToLive, m_fColorMiddleLife );

    // position
    particle->pos.x = m_tSourcePosition.x + m_tPosVar.x * CCRANDOM_MINUS1_1();

    particle->pos.y = m_tSourcePosition.y + m_tPosVar.y * CCRANDOM_MINUS1_1();


    // Color
    ccColor4F start;
    start.r = clampf(m_tStartColor.r + m_tStartColorVar.r * CCRANDOM_MINUS1_1(), 0, 1);
    start.g = clampf(m_tStartColor.g + m_tStartColorVar.g * CCRANDOM_MINUS1_1(), 0, 1);
    start.b = clampf(m_tStartColor.b + m_tStartColorVar.b * CCRANDOM_MINUS1_1(), 0, 1);
    start.a = clampf(m_tStartColor.a + m_tStartColorVar.a * CCRANDOM_MINUS1_1(), 0, 1);

	ccColor4F colorMiddle;
	colorMiddle.r = clampf(m_tMiddleColor.r + m_tMiddleColorVar.r * CCRANDOM_MINUS1_1(), 0, 1);
	colorMiddle.g = clampf(m_tMiddleColor.g + m_tMiddleColorVar.g * CCRANDOM_MINUS1_1(), 0, 1);
	colorMiddle.b = clampf(m_tMiddleColor.b + m_tMiddleColorVar.b * CCRANDOM_MINUS1_1(), 0, 1);
	colorMiddle.a = clampf(m_tMiddleColor.a + m_tMiddleColorVar.a * CCRANDOM_MINUS1_1(), 0, 1);

    ccColor4F end;
    end.r = clampf(m_tEndColor.r + m_tEndColorVar.r * CCRANDOM_MINUS1_1(), 0, 1);
    end.g = clampf(m_tEndColor.g + m_tEndColorVar.g * CCRANDOM_MINUS1_1(), 0, 1);
    end.b = clampf(m_tEndColor.b + m_tEndColorVar.b * CCRANDOM_MINUS1_1(), 0, 1);
    end.a = clampf(m_tEndColor.a + m_tEndColorVar.a * CCRANDOM_MINUS1_1(), 0, 1);

    particle->color = start;
    //delta color
    //case 1. if middle life is invalidate
    if (m_fColorMiddleLife == 0.0f || m_fColorMiddleLife >= particle->timeToLive) {
        particle->deltaOneColor =ccc4f(1, 1, 1, 1);
        
        particle->deltaTwoColor.r = (end.r - start.r) / particle->timeToLive;
        particle->deltaTwoColor.g = (end.g - start.g) / particle->timeToLive;
        particle->deltaTwoColor.b = (end.b - start.b) / particle->timeToLive;
        particle->deltaTwoColor.a = (end.a - start.a) / particle->timeToLive;
    }else{
        //case 2. middle life is validate
        particle->deltaOneColor.r = (colorMiddle.r - start.r) / m_fColorMiddleLife;
        particle->deltaOneColor.g = (colorMiddle.g - start.g) / m_fColorMiddleLife;
        particle->deltaOneColor.b = (colorMiddle.b - start.b) / m_fColorMiddleLife;
        particle->deltaOneColor.a = (colorMiddle.a - start.a) / m_fColorMiddleLife;
        
        particle->deltaTwoColor.r = (end.r - colorMiddle.r) / (particle->timeToLive - m_fColorMiddleLife);
        particle->deltaTwoColor.g = (end.g - colorMiddle.g) / (particle->timeToLive - m_fColorMiddleLife);
        particle->deltaTwoColor.b = (end.b - colorMiddle.b) / (particle->timeToLive - m_fColorMiddleLife);
        particle->deltaTwoColor.a = (end.a - colorMiddle.a) / (particle->timeToLive - m_fColorMiddleLife);
        
        
    }


    // size
    float startS = m_fStartSize + m_fStartSizeVar * CCRANDOM_MINUS1_1();
    startS = MAX(0, startS); // No negative value
	float middleS = m_fMiddleSize + m_fMiddleSizeVar * CCRANDOM_MINUS1_1();
	middleS = MAX(0, middleS); // No negative values
    particle->size = startS;

    if( m_fEndSize == kCCParticleStartSizeEqualToEndSize )
    {
        particle->deltaOneSize = 0;
		particle->deltaTwoSize = 0;
    }
    else
    {
		float endS = m_fEndSize + m_fEndSizeVar * CCRANDOM_MINUS1_1();
		endS = MAX(0, endS); // No negative values


		if (m_fMiddleLife == 0.0f || m_fMiddleLife >= particle->timeToLive) {
			particle->deltaOneSize =0.0;
			particle->deltaTwoSize = (endS - startS) / (particle->timeToLive);

		} else {
			if (middleS == startS ) {
				particle->deltaOneSize = 0.0;
			} else {
				particle->deltaOneSize = (middleS - startS) / (m_fMiddleLife);
			}

			if (endS == middleS || particle->timeToLive - m_fMiddleLife <0.0001f) {
				particle->deltaTwoSize =0.0;
			} else {
				particle->deltaTwoSize = (endS - middleS) / (particle->timeToLive - m_fMiddleLife);
			}
		}

    }



    // rotation
    float startA = m_fStartSpin + m_fStartSpinVar * CCRANDOM_MINUS1_1();
    float endA = m_fEndSpin + m_fEndSpinVar * CCRANDOM_MINUS1_1();
    particle->rotation = startA;
    particle->deltaRotation = (endA - startA) / particle->timeToLive;

    // position
    if( m_ePositionType == kCCPositionTypeFree )
    {
        particle->startAffineTransform = this->nodeToWorldTransform();
    }
//     else if ( m_ePositionType == kCCPositionTypeRelative )
//     {
//         particle->startPos = m_obPosition;
//     }

    // direction
    float a = CC_DEGREES_TO_RADIANS( m_fAngle + m_fAngleVar * CCRANDOM_MINUS1_1() );    

    // Mode Gravity: A
    if (m_nEmitterMode == kCCParticleModeGravity) 
    {
        CCPoint v(cosf( a ), sinf( a ));
        float s = modeA.speed + modeA.speedVar * CCRANDOM_MINUS1_1();
		//add by xinghui
		if (m_fEndSpeed == kCCParticleStartSpeedEqualToEndSpeed)
		{
			particle->deltaOneSpeedVex = CCPointZero;
			particle->deltaTwoSpeedVex = CCPointZero;
		}else
		{
			float startSpeed = s;
			//startSpeed = MAX(0, startSpeed);
			float middSpeed = m_fMiddSpeed + m_fMiddSpeedVar * CCRANDOM_MINUS1_1();
			//middSpeed = MAX(0, middSpeed);
			float endSpeed = m_fEndSpeed + m_fEndSpeedVar * CCRANDOM_MINUS1_1();
			//endSpeed = MAX(0, endSpeed);
			if (m_fMiddldSpeedLife <= 0.0f)
			{
				particle->deltaOneSpeedVex = CCPointZero;
				particle->deltaTwoSpeedVex =ccpSub(ccpMult(v, endSpeed), ccpMult(v, startSpeed));
				particle->deltaTwoSpeedVex = ccpMult(particle->deltaTwoSpeedVex, 1/m_fLife);
			}else if (m_fMiddldSpeedLife >= m_fLife)
			{
				particle->deltaOneSpeedVex =ccpSub(ccpMult(v, middSpeed), ccpMult(v, startSpeed));
				particle->deltaOneSpeedVex = ccpMult(particle->deltaOneSpeedVex, 1 / m_fLife);
				particle->deltaTwoSpeedVex = CCPointZero;
			}else
			{
				particle->deltaOneSpeedVex = ccpSub(ccpMult(v, middSpeed), ccpMult(v, startSpeed));
				particle->deltaOneSpeedVex = ccpMult(particle->deltaOneSpeedVex, 1 / m_fMiddldSpeedLife);
				particle->deltaTwoSpeedVex = ccpSub(ccpMult(v, endSpeed), ccpMult(v, middSpeed));
				particle->deltaTwoSpeedVex = ccpMult(particle->deltaTwoSpeedVex, 1/(m_fLife - m_fMiddldSpeedLife));
			}
		}

        // direction
        particle->modeA.dir = ccpMult( v, s );

        // radial accel
        particle->modeA.radialAccel = modeA.radialAccel + modeA.radialAccelVar * CCRANDOM_MINUS1_1();
 

        // tangential accel
        particle->modeA.tangentialAccel = modeA.tangentialAccel + modeA.tangentialAccelVar * CCRANDOM_MINUS1_1();

        // rotation is dir
        if(modeA.rotationIsDir)
            particle->rotation = -CC_RADIANS_TO_DEGREES(ccpToAngle(particle->modeA.dir)) + modeA.dirAngle + modeA.dirAngleVar *  CCRANDOM_MINUS1_1();
    }

    // Mode Radius: B
    else 
    {
        // Set the default diameter of the particle from the source position
        float startRadius = modeB.startRadius + modeB.startRadiusVar * CCRANDOM_MINUS1_1();
        float endRadius = modeB.endRadius + modeB.endRadiusVar * CCRANDOM_MINUS1_1();

        particle->modeB.radius = startRadius;

        if(modeB.endRadius == kCCParticleStartRadiusEqualToEndRadius)
        {
            particle->modeB.deltaRadius = 0;
        }
        else
        {
            particle->modeB.deltaRadius = (endRadius - startRadius) / particle->timeToLive;
        }

        particle->modeB.angle = a;
        particle->modeB.degreesPerSecond = CC_DEGREES_TO_RADIANS(modeB.rotatePerSecond + modeB.rotatePerSecondVar * CCRANDOM_MINUS1_1());
    }    
}

void CCParticleSystem::stopSystem()
{
    m_bIsActive = false;
    m_fElapsed = m_fDuration;
    m_fEmitCounter = 0;
}

void CCParticleSystem::resetSystem()
{
    m_bIsActive = true;
    m_fElapsed = 0;
    for (m_uParticleIdx = 0; m_uParticleIdx < m_uParticleCount; ++m_uParticleIdx)
    {
        tCCParticle *p = &m_pParticles[m_uParticleIdx];
        p->timeToLive = 0;
    }

	this->unscheduleUpdate();
	this->scheduleUpdateWithPriority(1);

	if(m_bPrepare)
	{
		m_bPrepareSystemDirty = true;
	}
}
bool CCParticleSystem::isFull()
{
    return (m_uParticleCount == m_uTotalParticles);
}

// ParticleSystem - MainLoop
void CCParticleSystem::update(float dt)
{
    CC_PROFILER_START_CATEGORY(kCCProfilerCategoryParticles , "CCParticleSystem - update");

    if (m_bIsActive && m_fEmissionRate)
    {
        float rate = 1.0f / m_fEmissionRate;
        //issue #1201, prevent bursts of particles, due to too high emitCounter
        if (m_uParticleCount < m_uTotalParticles)
        {
            m_fEmitCounter += dt;
        }
		
		if(m_bPrepare && m_bPrepareSystemDirty)
		{
			m_fEmitCounter = m_fLife;
			dt=0;
		}
		
        while (m_uParticleCount < m_uTotalParticles && m_fEmitCounter > rate) 
        {
            tCCParticle* p = this->addParticle();
			p->timeToLive = p->timeToLive - m_fEmitCounter;
            m_fEmitCounter -= rate;
        }

        m_fElapsed += dt;
        if (m_fDuration != -1 && m_fDuration < m_fElapsed)
        {
            this->stopSystem();
        }
    }

    m_uParticleIdx = 0;

    CCAffineTransform curAffineTransform = CCAffineTransformIdentity;
    if (m_ePositionType == kCCPositionTypeFree)
    {
        curAffineTransform = worldToNodeTransform();
    }
//     else if (m_ePositionType == kCCPositionTypeRelative)
//     {
//         currentPosition = m_obPosition;
//     }

    if (m_bVisible)
    {
        while (m_uParticleIdx < m_uParticleCount)
        {
            tCCParticle *p = &m_pParticles[m_uParticleIdx];

            // life
           
			
			float prepareTimeDt = dt;
			if(m_bPrepare && m_bPrepareSystemDirty)
				prepareTimeDt = dt + m_fLife - p->timeToLive;
			if(prepareTimeDt<0)prepareTimeDt = 0;

			 p->timeToLive -= prepareTimeDt;

            if (p->timeToLive > 0) 
            {
				p->livedTime+=dt;
                // Mode A: gravity, direction, tangential accel & radial accel
                if (m_nEmitterMode == kCCParticleModeGravity) 
                {
                    CCPoint tmp, radial, tangential;

                    radial = CCPointZero;
                    // radial acceleration
                    if (p->pos.x || p->pos.y)
                    {
                        radial = ccpNormalize(p->pos);
                    }
                    tangential = radial;
                    radial = ccpMult(radial, p->modeA.radialAccel);

                    // tangential acceleration
                    float newy = tangential.x;
                    tangential.x = -tangential.y;
                    tangential.y = newy;
                    tangential = ccpMult(tangential, p->modeA.tangentialAccel);

                    // (gravity + radial + tangential) * dt
                    tmp = ccpAdd( ccpAdd( radial, tangential), modeA.gravity);
					tmp = ccpMult( tmp, prepareTimeDt);

                    p->modeA.dir = ccpAdd( p->modeA.dir, tmp);
					//add by xinghui
					if (m_nEmitterMode == kCCParticleModeGravity)
					{
						CCPoint deltaSpeedVex = CCPointZero;
						if (p->livedTime <= m_fMiddldSpeedLife)
						{
							deltaSpeedVex = p->deltaOneSpeedVex;
						}else
						{
							deltaSpeedVex = p->deltaTwoSpeedVex;
						}
						p->modeA.dir = ccpAdd(p->modeA.dir, ccpMult(deltaSpeedVex, dt));
					}
					
                    tmp = ccpMult(p->modeA.dir, prepareTimeDt);
                    p->pos = ccpAdd( p->pos, tmp );
                }

                // Mode B: radius movement
                else 
                {                
                    // Update the angle and radius of the particle.
					p->modeB.angle += p->modeB.degreesPerSecond * prepareTimeDt;
					p->modeB.radius += p->modeB.deltaRadius * prepareTimeDt;
					
                    p->pos.x = - cosf(p->modeB.angle) * p->modeB.radius;
                    p->pos.y = - sinf(p->modeB.angle) * p->modeB.radius;
                }

                // color
				
				

				CCAffineTransform newAffineTransform = CCAffineTransformIdentity;
				if (m_ePositionType == kCCPositionTypeFree) 
					newAffineTransform = CCAffineTransformConcat(p->startAffineTransform,curAffineTransform);
				else
					newAffineTransform = curAffineTransform;

				//color
				ccColor4F deltaColor;
				if (p->livedTime < m_fColorMiddleLife)
				{
					deltaColor = p->deltaOneColor;
				}else{
					deltaColor = p->deltaTwoColor;
				}

				// size
				float deltaSize = p->deltaOneSize;
				if (p->livedTime < m_fMiddleLife)
				{
					deltaSize = p->deltaOneSize;
				}else{
					deltaSize = p->deltaTwoSize;
				}


				p->color.r += (deltaColor.r * prepareTimeDt);
				p->color.g += (deltaColor.g * prepareTimeDt);
				p->color.b += (deltaColor.b * prepareTimeDt);
				p->color.a += (deltaColor.a * prepareTimeDt);
				
				p->size += (deltaSize * prepareTimeDt);
				p->size = MAX( 0, p->size );

				// angle
				p->rotation += (p->deltaRotation * prepareTimeDt);
				

                //
                // update values in quad
                //

//                 CCPoint    newPos;
// 
//                 if (m_ePositionType == kCCPositionTypeFree || m_ePositionType == kCCPositionTypeRelative) 
//                 {
//                     CCPoint diff = ccpSub( currentPosition, p->startPos );
//                     newPos = ccpSub(p->pos, diff);
//                 } 
//                 else
//                 {
//                     newPos = p->pos;
//                 }
// 
// 				newPos = p->pos;
                // translate newPos to correct position, since matrix transform isn't performed in batchnode
                // don't update the particle with the new position information, it will interfere with the radius and tangential calculations
                if (m_pBatchNode)
                {
                    newAffineTransform.tx+=m_obPosition.x;
                    newAffineTransform.ty+=m_obPosition.y;
                }

                updateQuadWithParticle(p, newAffineTransform);
                //updateParticleImp(self, updateParticleSel, p, newPos);

                // update particle counter
                ++m_uParticleIdx;
            } 
            else 
            {
                // life < 0
                int currentIndex = p->atlasIndex;
				p->livedTime =0;
                if( m_uParticleIdx != m_uParticleCount-1 )
                {
                    m_pParticles[m_uParticleIdx] = m_pParticles[m_uParticleCount-1];
                }
                if (m_pBatchNode)
                {
                    //disable the switched particle
                    m_pBatchNode->disableParticle(m_uAtlasIndex+currentIndex);

                    //switch indexes
                    m_pParticles[m_uParticleCount-1].atlasIndex = currentIndex;
                }


                --m_uParticleCount;

                if( m_uParticleCount == 0 && m_bIsAutoRemoveOnFinish )
                {
                    this->unscheduleUpdate();
					m_pParent->removeChild(this, true);
					m_bPrepareSystemDirty = false;
                    return;
                }
            }
        } //while
        m_bTransformSystemDirty = false;
    }
    if (! m_pBatchNode)
    {
        postStep();
    }

	m_bPrepareSystemDirty = false;
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategoryParticles , "CCParticleSystem - update");
}

void CCParticleSystem::updateWithNoTime(void)
{
    this->update(0.0f);
}

void CCParticleSystem::updateQuadWithParticle(tCCParticle* particle, const CCAffineTransform& newAffineTransform)
{
    CC_UNUSED_PARAM(particle);
    CC_UNUSED_PARAM(newAffineTransform);
    // should be overridden
}

void CCParticleSystem::postStep()
{
    // should be overridden
}

// ParticleSystem - CCTexture protocol
void CCParticleSystem::setTexture(CCTexture2D* var)
{
    if (m_pTexture != var)
    {
        CC_SAFE_RETAIN(var);
        CC_SAFE_RELEASE(m_pTexture);
        m_pTexture = var;
        updateBlendFunc();
    }
}

void CCParticleSystem::updateBlendFunc()
{
    CCAssert(! m_pBatchNode, "Can't change blending functions when the particle is being batched");

    if(m_pTexture)
    {
        bool premultiplied = m_pTexture->hasPremultipliedAlpha();
        
        m_bOpacityModifyRGB = false;
        
        if( m_pTexture && ( m_tBlendFunc.src == CC_BLEND_SRC && m_tBlendFunc.dst == CC_BLEND_DST ) )
        {
            if( premultiplied )
            {
                m_bOpacityModifyRGB = true;
            }
            else
            {
                m_tBlendFunc.src = GL_SRC_ALPHA;
                m_tBlendFunc.dst = GL_ONE_MINUS_SRC_ALPHA;
            }
        }
    }
}

CCTexture2D * CCParticleSystem::getTexture()
{
    return m_pTexture;
}

// ParticleSystem - Additive Blending
void CCParticleSystem::setBlendAdditive(bool additive)
{
    if( additive )
    {
        m_tBlendFunc.src = GL_SRC_ALPHA;
        m_tBlendFunc.dst = GL_ONE;
    }
    else
    {
        if( m_pTexture && ! m_pTexture->hasPremultipliedAlpha() )
        {
            m_tBlendFunc.src = GL_SRC_ALPHA;
            m_tBlendFunc.dst = GL_ONE_MINUS_SRC_ALPHA;
        } 
        else 
        {
            m_tBlendFunc.src = CC_BLEND_SRC;
            m_tBlendFunc.dst = CC_BLEND_DST;
        }
    }
}

bool CCParticleSystem::isBlendAdditive()
{
    return( m_tBlendFunc.src == GL_SRC_ALPHA && m_tBlendFunc.dst == GL_ONE);
}

// ParticleSystem - Properties of Gravity Mode 
void CCParticleSystem::setTangentialAccel(float t)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.tangentialAccel = t;
}

float CCParticleSystem::getTangentialAccel()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.tangentialAccel;
}

void CCParticleSystem::setTangentialAccelVar(float t)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.tangentialAccelVar = t;
}

float CCParticleSystem::getTangentialAccelVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.tangentialAccelVar;
}    

void CCParticleSystem::setRadialAccel(float t)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.radialAccel = t;
}

float CCParticleSystem::getRadialAccel()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.radialAccel;
}

void CCParticleSystem::setRadialAccelVar(float t)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.radialAccelVar = t;
}

float CCParticleSystem::getRadialAccelVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.radialAccelVar;
}

void CCParticleSystem::setDirAngle(float t)
{
	modeA.dirAngle = t;
}

float CCParticleSystem::getDirAngle()
{
	return modeA.dirAngle;
}

void CCParticleSystem::setDirAngleVar(float t)
{
	modeA.dirAngleVar = t;
}

float CCParticleSystem::getDirAngleVar()
{
	return modeA.dirAngleVar;
}

void CCParticleSystem::setRotationIsDir(bool t)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.rotationIsDir = t;
}

bool CCParticleSystem::getRotationIsDir()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.rotationIsDir;
}

void CCParticleSystem::setGravity(const CCPoint& g)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.gravity = g;
}

const CCPoint& CCParticleSystem::getGravity()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.gravity;
}

void CCParticleSystem::setSpeed(float speed)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.speed = speed;
}

float CCParticleSystem::getSpeed()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.speed;
}

void CCParticleSystem::setSpeedVar(float speedVar)
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    modeA.speedVar = speedVar;
}

float CCParticleSystem::getSpeedVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeGravity, "Particle Mode should be Gravity");
    return modeA.speedVar;
}

// ParticleSystem - Properties of Radius Mode
void CCParticleSystem::setStartRadius(float startRadius)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.startRadius = startRadius;
}

float CCParticleSystem::getStartRadius()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.startRadius;
}

void CCParticleSystem::setStartRadiusVar(float startRadiusVar)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.startRadiusVar = startRadiusVar;
}

float CCParticleSystem::getStartRadiusVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.startRadiusVar;
}

void CCParticleSystem::setEndRadius(float endRadius)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.endRadius = endRadius;
}

float CCParticleSystem::getEndRadius()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.endRadius;
}

void CCParticleSystem::setEndRadiusVar(float endRadiusVar)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.endRadiusVar = endRadiusVar;
}

float CCParticleSystem::getEndRadiusVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.endRadiusVar;
}

void CCParticleSystem::setRotatePerSecond(float degrees)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.rotatePerSecond = degrees;
}

float CCParticleSystem::getRotatePerSecond()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.rotatePerSecond;
}

void CCParticleSystem::setRotatePerSecondVar(float degrees)
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    modeB.rotatePerSecondVar = degrees;
}

float CCParticleSystem::getRotatePerSecondVar()
{
    CCAssert( m_nEmitterMode == kCCParticleModeRadius, "Particle Mode should be Radius");
    return modeB.rotatePerSecondVar;
}

bool CCParticleSystem::isActive()
{
    return m_bIsActive;
}

unsigned int CCParticleSystem::getParticleCount()
{
    return m_uParticleCount;
}

float CCParticleSystem::getDuration()
{
    return m_fDuration;
}

void CCParticleSystem::setDuration(float var)
{
    m_fDuration = var;
}

float CCParticleSystem::getParScaleX()
{
	return m_fParScaleX;
}

void CCParticleSystem::setParScaleX(float var)
{
	m_fParScaleX= var;
}

//add by xinghui
void CCParticleSystem::setMiddSpeed(float middSpeed)
{
	this->m_fMiddSpeed = middSpeed;
}
float CCParticleSystem::getMiddSpeed()
{
	return this->m_fMiddSpeed;
}

void CCParticleSystem::setMiddSpeedVar(float middSpeedVar)
{
	this->m_fMiddSpeedVar = middSpeedVar;
}
float CCParticleSystem::getMiddSpeedVar()
{
	return this->m_fMiddSpeedVar;
}

void CCParticleSystem::setEndSpeed(float endSpeed)
{
	this->m_fEndSpeed = endSpeed;
}

float CCParticleSystem::getEndSpeed()
{
	return this->m_fEndSpeed;
}

void CCParticleSystem::setEndSpeedVar(float endSpeedVar)
{
	this->m_fEndSpeedVar = endSpeedVar;
}

float CCParticleSystem::getEndSpeedVar()
{
	return this->m_fEndSpeedVar;
}

void CCParticleSystem::setMiddleSpeedLife(float middSpeedLife)
{
	this->m_fMiddldSpeedLife = middSpeedLife;
}

float CCParticleSystem::getMiddleSpeedLife()
{
	return this->m_fMiddldSpeedLife;
}

float CCParticleSystem::getParScaleY()
{
	return m_fParScaleY;
}

void CCParticleSystem::setParScaleY(float var)
{
	m_fParScaleY= var;
}

const CCPoint& CCParticleSystem::getSourcePosition()
{
    return m_tSourcePosition;
}

void CCParticleSystem::setSourcePosition(const CCPoint& var)
{
    m_tSourcePosition = var;
}

const CCPoint& CCParticleSystem::getPosVar()
{
    return m_tPosVar;
}

void CCParticleSystem::setPosVar(const CCPoint& var)
{
    m_tPosVar = var;
}

float CCParticleSystem::getLife()
{
    return m_fLife;
}

void CCParticleSystem::setLife(float var)
{
    m_fLife = var;
}

float CCParticleSystem::getLifeVar()
{
    return m_fLifeVar;
}

void CCParticleSystem::setLifeVar(float var)
{
    m_fLifeVar = var;
}

float CCParticleSystem::getMiddleLife()
{
	return m_fMiddleLife;
}

void CCParticleSystem::setMiddleLife(float var)
{
	m_fMiddleLife = var;
}

float CCParticleSystem::getColorMiddleLife()
{
	return m_fColorMiddleLife;
}

void CCParticleSystem::setColorMiddleLife(float var)
{
	m_fColorMiddleLife = var;
}

float CCParticleSystem::getAngle()
{
    return m_fAngle;
}

void CCParticleSystem::setAngle(float var)
{
    m_fAngle = var;
}

float CCParticleSystem::getAngleVar()
{
    return m_fAngleVar;
}

void CCParticleSystem::setAngleVar(float var)
{
    m_fAngleVar = var;
}

float CCParticleSystem::getStartSize()
{
    return m_fStartSize;
}

void CCParticleSystem::setStartSize(float var)
{
    m_fStartSize = var;
}

float CCParticleSystem::getStartSizeVar()
{
    return m_fStartSizeVar;
}

void CCParticleSystem::setStartSizeVar(float var)
{
    m_fStartSizeVar = var;
}

float CCParticleSystem::getMiddleSize()
{
	return m_fMiddleSize;
}

void CCParticleSystem::setMiddleSize(float var)
{
	m_fMiddleSize = var;
}

float CCParticleSystem::getMiddleSizeVar()
{
	return m_fMiddleSizeVar;
}

void CCParticleSystem::setMiddleSizeVar(float var)
{
	m_fMiddleSizeVar = var;
}

float CCParticleSystem::getEndSize()
{
    return m_fEndSize;
}

void CCParticleSystem::setEndSize(float var)
{
    m_fEndSize = var;
}

float CCParticleSystem::getEndSizeVar()
{
    return m_fEndSizeVar;
}

void CCParticleSystem::setEndSizeVar(float var)
{
    m_fEndSizeVar = var;
}

const ccColor4F& CCParticleSystem::getStartColor()
{
    return m_tStartColor;
}

void CCParticleSystem::setStartColor(const ccColor4F& var)
{
    m_tStartColor = var;
}

const ccColor4F& CCParticleSystem::getStartColorVar()
{
    return m_tStartColorVar;
}

void CCParticleSystem::setStartColorVar(const ccColor4F& var)
{
    m_tStartColorVar = var;
}

const ccColor4F& CCParticleSystem::getMiddleColor()
{
    return m_tMiddleColor;
}

void CCParticleSystem::setMiddleColor(const ccColor4F& var)
{
    m_tMiddleColor = var;
}

const ccColor4F& CCParticleSystem::getMiddleColorVar()
{
    return m_tMiddleColorVar;
}

void CCParticleSystem::setMiddleColorVar(const ccColor4F& var)
{
    m_tMiddleColorVar = var;
}

const ccColor4F& CCParticleSystem::getEndColor()
{
    return m_tEndColor;
}

void CCParticleSystem::setEndColor(const ccColor4F& var)
{
    m_tEndColor = var;
}

const ccColor4F& CCParticleSystem::getEndColorVar()
{
    return m_tEndColorVar;
}

void CCParticleSystem::setEndColorVar(const ccColor4F& var)
{
    m_tEndColorVar = var;
}

float CCParticleSystem::getStartSpin()
{
    return m_fStartSpin;
}

void CCParticleSystem::setStartSpin(float var)
{
    m_fStartSpin = var;
}

float CCParticleSystem::getStartSpinVar()
{
    return m_fStartSpinVar;
}

void CCParticleSystem::setStartSpinVar(float var)
{
    m_fStartSpinVar = var;
}

float CCParticleSystem::getEndSpin()
{
    return m_fEndSpin;
}

void CCParticleSystem::setEndSpin(float var)
{
    m_fEndSpin = var;
}
float CCParticleSystem::getEndSpinVar()
{
    return m_fEndSpinVar;
}

void CCParticleSystem::setEndSpinVar(float var)
{
    m_fEndSpinVar = var;
}

float CCParticleSystem::getEmissionRate()
{
    return m_fEmissionRate;
}

void CCParticleSystem::setEmissionRate(float var)
{
    m_fEmissionRate = var;
}

unsigned int CCParticleSystem::getTotalParticles()
{
    return m_uTotalParticles;
}

void CCParticleSystem::setTotalParticles(unsigned int var)
{
    CCAssert( var <= m_uAllocatedParticles, "Particle: resizing particle array only supported for quads");
    m_uTotalParticles = var;
}

ccBlendFunc CCParticleSystem::getBlendFunc()
{
    return m_tBlendFunc;
}

void CCParticleSystem::setBlendFunc(ccBlendFunc blendFunc)
{
    if( m_tBlendFunc.src != blendFunc.src || m_tBlendFunc.dst != blendFunc.dst ) {
        m_tBlendFunc = blendFunc;
        this->updateBlendFunc();
    }
}

bool CCParticleSystem::getOpacityModifyRGB()
{
    return m_bOpacityModifyRGB;
}

void CCParticleSystem::setOpacityModifyRGB(bool bOpacityModifyRGB)
{
    m_bOpacityModifyRGB = bOpacityModifyRGB;
}

bool CCParticleSystem::getPrepare()
{
	return m_bPrepare;
}

void CCParticleSystem::setPrepare(bool bPrepare)
{
	m_bPrepare = bPrepare;
}

tCCPositionType CCParticleSystem::getPositionType()
{
    return m_ePositionType;
}

void CCParticleSystem::setPositionType(tCCPositionType var)
{
    m_ePositionType = var;
}

bool CCParticleSystem::isAutoRemoveOnFinish()
{
    return m_bIsAutoRemoveOnFinish;
}

void CCParticleSystem::setAutoRemoveOnFinish(bool var)
{
    m_bIsAutoRemoveOnFinish = var;
}

int CCParticleSystem::getEmitterMode()
{
    return m_nEmitterMode;
}

void CCParticleSystem::setEmitterMode(int var)
{
    m_nEmitterMode = var;
}


// ParticleSystem - methods for batchNode rendering

CCParticleBatchNode* CCParticleSystem::getBatchNode(void)
{
    return m_pBatchNode;
}

void CCParticleSystem::setBatchNode(CCParticleBatchNode* batchNode)
{
    if( m_pBatchNode != batchNode ) {

        m_pBatchNode = batchNode; // weak reference

        if( batchNode ) {
            //each particle needs a unique index
            for (unsigned int i = 0; i < m_uTotalParticles; i++)
            {
                m_pParticles[i].atlasIndex=i;
            }
        }
    }
}

//don't use a transform matrix, this is faster
void CCParticleSystem::setScale(float s)
{
    m_bTransformSystemDirty = true;
    CCNode::setScale(s);
}

void CCParticleSystem::setRotation(float newRotation)
{
    m_bTransformSystemDirty = true;
    CCNode::setRotation(newRotation);
}

void CCParticleSystem::setScaleX(float newScaleX)
{
    m_bTransformSystemDirty = true;
    CCNode::setScaleX(newScaleX);
}

void CCParticleSystem::setScaleY(float newScaleY)
{
    m_bTransformSystemDirty = true;
    CCNode::setScaleY(newScaleY);
}

void CCParticleSystem::setVisible( bool visible )
{
	if(!isVisible() && visible)
	{
		CCNode::setVisible(visible);
		resetSystem();
	}
	else
		CCNode::setVisible(visible);
}

NS_CC_END


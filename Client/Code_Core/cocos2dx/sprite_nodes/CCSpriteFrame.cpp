/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2011 Ricardo Quesada
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
#include "textures/CCTextureCache.h"
#include "CCSpriteFrame.h"
#include "CCDirector.h"

NS_CC_BEGIN

// implementation of CCSpriteFrame

CCSpriteFrame* CCSpriteFrame::create(const char* filename, const CCRect& rect)
{
    CCSpriteFrame *pSpriteFrame = new CCSpriteFrame();
    pSpriteFrame->initWithTextureFilename(filename, rect);
    pSpriteFrame->autorelease();
#if COCOS2D_DEBUG > 0
	pSpriteFrame->setSourceInfo(filename);
#endif
    return pSpriteFrame;
}

CCSpriteFrame* CCSpriteFrame::createWithTexture(CCTexture2D *pobTexture, const CCRect& rect)
{
    CCSpriteFrame *pSpriteFrame = new CCSpriteFrame();
    pSpriteFrame->initWithTexture(pobTexture, rect);
    pSpriteFrame->autorelease();
#if COCOS2D_DEBUG > 0
	pSpriteFrame->setSourceInfo(pobTexture->sourceInfo());
#endif
    return pSpriteFrame;
}

CCSpriteFrame* CCSpriteFrame::createWithTexture(CCTexture2D* pobTexture, const CCRect& rect, bool rotated, const CCPoint& offset, const CCSize& originalSize)
{
    CCSpriteFrame *pSpriteFrame = new CCSpriteFrame();
    pSpriteFrame->initWithTexture(pobTexture, rect, rotated, offset, originalSize);
    pSpriteFrame->autorelease();
#if COCOS2D_DEBUG > 0
	pSpriteFrame->setSourceInfo(pobTexture->sourceInfo());
#endif
    return pSpriteFrame;
}

CCSpriteFrame* CCSpriteFrame::create(const char* filename, const CCRect& rect, bool rotated, const CCPoint& offset, const CCSize& originalSize)
{
    CCSpriteFrame *pSpriteFrame = new CCSpriteFrame();
    pSpriteFrame->initWithTextureFilename(filename, rect, rotated, offset, originalSize);
    pSpriteFrame->autorelease();
#if COCOS2D_DEBUG > 0
	pSpriteFrame->setSourceInfo(filename);
#endif
    return pSpriteFrame;
}

bool CCSpriteFrame::initWithTexture(CCTexture2D* pobTexture, const CCRect& rect)
{
    CCRect rectInPixels = CC_RECT_POINTS_TO_PIXELS(rect);
    return initWithTexture(pobTexture, rectInPixels, false, CCPointZero, rectInPixels.size);
}

bool CCSpriteFrame::initWithTextureFilename(const char* filename, const CCRect& rect)
{
    CCRect rectInPixels = CC_RECT_POINTS_TO_PIXELS( rect );
    return initWithTextureFilename(filename, rectInPixels, false, CCPointZero, rectInPixels.size);
}

bool CCSpriteFrame::initWithTexture(CCTexture2D* pobTexture, const CCRect& rect, bool rotated, const CCPoint& offset, const CCSize& originalSize)
{
	if ( m_pobTexture != pobTexture )
	{
		CC_SAFE_RETAIN(pobTexture);
		CC_SAFE_RELEASE(m_pobTexture);
		m_pobTexture = pobTexture;
	}

    m_obRectInPixels = rect;
    m_obRect = CC_RECT_PIXELS_TO_POINTS(rect);
    m_obOffsetInPixels = offset;
    m_obOffset = CC_POINT_PIXELS_TO_POINTS( m_obOffsetInPixels );
    m_obOriginalSizeInPixels = originalSize;
    m_obOriginalSize = CC_SIZE_PIXELS_TO_POINTS( m_obOriginalSizeInPixels );
    m_bRotated = rotated;

    return true;
}

bool CCSpriteFrame::initWithTextureFilename(const char* filename, const CCRect& rect, bool rotated, const CCPoint& offset, const CCSize& originalSize)
{
	CC_SAFE_RELEASE(m_pobTexture);
    m_pobTexture = NULL;
    m_strTextureFilename = filename;
    m_obRectInPixels = rect;
    m_obRect = CC_RECT_PIXELS_TO_POINTS( rect );
    m_obOffsetInPixels = offset;
    m_obOffset = CC_POINT_PIXELS_TO_POINTS( m_obOffsetInPixels );
    m_obOriginalSizeInPixels = originalSize;
    m_obOriginalSize = CC_SIZE_PIXELS_TO_POINTS( m_obOriginalSizeInPixels );
    m_bRotated = rotated;

    return true;
}

CCSpriteFrame::CCSpriteFrame()
	: m_pobTexture(NULL)
	, m_bRotated(false)
{
#if COCOS2D_DEBUG > 0
	memset(m_cstrSpriteFrameName, 0, sizeof(m_cstrSpriteFrameName));
	memset(m_cstrSourceInfo, 0, sizeof(m_cstrSourceInfo));
#endif
}

CCSpriteFrame::~CCSpriteFrame(void)
{
#if COCOS2D_DEBUG > 0
	if (strlen(m_cstrSpriteFrameName) || strlen(m_cstrSourceInfo))
	{
		//TODO::先注释掉，太影响调试了
		//CCLOG("cocos2d: deallocing CCSpriteFrame %s(%s)", m_cstrSpriteFrameName, m_cstrSourceInfo);
	}
#endif
    //CCLOGINFO("cocos2d: deallocing CCSpriteFrame %p", this);
    CC_SAFE_RELEASE(m_pobTexture);
}

CCObject* CCSpriteFrame::copyWithZone(CCZone *pZone)
{
    CC_UNUSED_PARAM(pZone);
    CCSpriteFrame *pCopy = new CCSpriteFrame();
#if COCOS2D_DEBUG > 0
	pCopy->setSourceInfo(m_cstrSourceInfo);
#endif
    pCopy->initWithTextureFilename(m_strTextureFilename.c_str(), m_obRectInPixels, m_bRotated, m_obOffsetInPixels, m_obOriginalSizeInPixels);
    pCopy->setTexture(m_pobTexture);
    return pCopy;
}

void CCSpriteFrame::setRect(const CCRect& rect)
{
    m_obRect = rect;
    m_obRectInPixels = CC_RECT_POINTS_TO_PIXELS(m_obRect);
}

void CCSpriteFrame::setRectInPixels(const CCRect& rectInPixels)
{
    m_obRectInPixels = rectInPixels;
    m_obRect = CC_RECT_PIXELS_TO_POINTS(rectInPixels);
}

const CCPoint& CCSpriteFrame::getOffset(void)
{
    return m_obOffset;
}

void CCSpriteFrame::setOffset(const CCPoint& offsets)
{
    m_obOffset = offsets;
    m_obOffsetInPixels = CC_POINT_POINTS_TO_PIXELS( m_obOffset );
}

const CCPoint& CCSpriteFrame::getOffsetInPixels(void)
{
    return m_obOffsetInPixels;
}

void CCSpriteFrame::setOffsetInPixels(const CCPoint& offsetInPixels)
{
    m_obOffsetInPixels = offsetInPixels;
    m_obOffset = CC_POINT_PIXELS_TO_POINTS( m_obOffsetInPixels );
}

void CCSpriteFrame::setTexture(CCTexture2D * texture)
{
    if( m_pobTexture != texture ) {
        CC_SAFE_RELEASE(m_pobTexture);
        CC_SAFE_RETAIN(texture);
        m_pobTexture = texture;
    }
}

CCTexture2D* CCSpriteFrame::getTexture(void)
{
    if( m_pobTexture ) {
        return m_pobTexture;
    }

    if( m_strTextureFilename.length() > 0 ) {
        return CCTextureCache::sharedTextureCache()->addImage(m_strTextureFilename.c_str());
    }
    // no texture or texture filename
    return NULL;
}

#if COCOS2D_DEBUG > 0
void CCSpriteFrame::setSpriteFrameName( const char* name )
{
	memset(m_cstrSpriteFrameName, 0, sizeof(m_cstrSpriteFrameName));
	memcpy(m_cstrSpriteFrameName, name, strlen(name));
}

void CCSpriteFrame::setSourceInfo( const char* info )
{
	memset(m_cstrSourceInfo, 0, sizeof(m_cstrSourceInfo));
	memcpy(m_cstrSourceInfo, info, strlen(info));
}

void CCSpriteFrame::loginfo()
{
	//CCLOG("CCSpriteFrame loginfo:	%s	ref:%lu	%s", m_cstrSpriteFrameName, this->m_uReference, m_cstrSourceInfo);
}
#endif


NS_CC_END


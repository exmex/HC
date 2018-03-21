/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada

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
#include "CCLabelTTF.h"
#include "CCDirector.h"
#include "shaders/CCGLProgram.h"
#include "shaders/CCShaderCache.h"
#include "CCApplication.h"

#include "shaders/shaderhelper/CCTextShadowSH.h"
#include "shaders/shaderhelper/CCTextFadeSH.h"
#include "shaders/shaderhelper/CCTextBorderSH.h"
#include "textures/CCTextureCache.h"

NS_CC_BEGIN

//#if CC_USE_LA88_LABELS
#define SHADER_PROGRAM kCCShader_PositionTextureColor
//#else
//#define SHADER_PROGRAM kCCShader_PositionTextureA8Color
//#endif

#define SHADER_TEXT_SHADOW	kCCShader_Text_Shadow
#define SHADER_TEXT_FADE	kCCShader_Text_Fade
#define SHADER_TEXT_BORDER	kCCShader_Text_Border

//
//CCLabelTTF
//
CCLabelTTF::CCLabelTTF()
: m_hAlignment(kCCTextAlignmentCenter)
, m_vAlignment(kCCVerticalTextAlignmentTop)
, m_pFontName(NULL)
, m_fFontSize(0.0)
, m_string("")
, m_shadowEnabled(false)
, m_strokeEnabled(false)
,m_textShadowFourDirEnabled(false)
, m_textFillColor(ccWHITE)
, m_fadeTexture(NULL)
,m_fShadowOffsetX(1.0)
,m_fShadowOffsetY(1.0)
,m_fShadowOffsetX2(1.0)
,m_fShadowOffsetY2(1.0)
,m_fShadowOffsetX3(1.0)
,m_fShadowOffsetY3(1.0)
,m_fShadowOffsetX4(1.0)
,m_fShadowOffsetY4(1.0)
{
	m_textShadowEnabled=false;
	m_textFadeEnabled=false;
	m_textBorderEnabled=false;
	m_textFadeImageURL="";
	m_shadowColor = ccc4f(1.0,1.0,1.0,1.0);
	m_borderColor = ccc4f(1.0,1.0,1.0,1.0);
}

CCLabelTTF::~CCLabelTTF()
{
	updateStrokeNode();
    CC_SAFE_DELETE(m_pFontName);
	CC_SAFE_RELEASE(m_fadeTexture);
}

CCLabelTTF * CCLabelTTF::create()
{
    CCLabelTTF * pRet = new CCLabelTTF();
    if (pRet && pRet->init())
    {
        pRet->autorelease();
    }
    else
    {
        CC_SAFE_DELETE(pRet);
    }
    return pRet;
}

CCLabelTTF * CCLabelTTF::create(const char *string, const char *fontName, float fontSize)
{
    return CCLabelTTF::create(string, fontName, fontSize,
                              CCSizeZero, kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop);
}

CCLabelTTF * CCLabelTTF::create(const char *string, const char *fontName, float fontSize,
                                const CCSize& dimensions, CCTextAlignment hAlignment)
{
    return CCLabelTTF::create(string, fontName, fontSize, dimensions, hAlignment, kCCVerticalTextAlignmentTop);
}

CCLabelTTF* CCLabelTTF::create(const char *string, const char *fontName, float fontSize,
                               const CCSize &dimensions, CCTextAlignment hAlignment, 
                               CCVerticalTextAlignment vAlignment,
							   bool bBold /*= false*/, bool bUnderline /*= false*/)
{
    CCLabelTTF *pRet = new CCLabelTTF();
    if(pRet && pRet->initWithString(string, fontName, fontSize, dimensions, hAlignment, vAlignment, bBold, bUnderline))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

CCLabelTTF * CCLabelTTF::createWithFontDefinition(const char *string, ccFontDefinition &textDefinition)
{
    CCLabelTTF *pRet = new CCLabelTTF();
    if(pRet && pRet->initWithStringAndTextDefinition(string, textDefinition))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CCLabelTTF::init()
{
    return this->initWithString("", "Helvetica", 12);
}

bool CCLabelTTF::initWithString(const char *label, const char *fontName, float fontSize, 
                                const CCSize& dimensions, CCTextAlignment alignment)
{
    return this->initWithString(label, fontName, fontSize, dimensions, alignment, kCCVerticalTextAlignmentTop);
}

bool CCLabelTTF::initWithString(const char *label, const char *fontName, float fontSize)
{
    return this->initWithString(label, fontName, fontSize, 
                                CCSizeZero, kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop);
}

bool CCLabelTTF::initWithString(const char *string, const char *fontName, float fontSize,
                                const cocos2d::CCSize &dimensions, CCTextAlignment hAlignment,
                                CCVerticalTextAlignment vAlignment,
								bool bBold /*= false*/, bool bUnderline /*= false*/)
{
    if (CCSprite::init())
    {
        // shader program
        this->setShaderProgram(CCShaderCache::sharedShaderCache()->programForKey(SHADER_PROGRAM));
        
        m_tDimensions = CCSizeMake(dimensions.width, dimensions.height);
        m_hAlignment  = hAlignment;
        m_vAlignment  = vAlignment;
        m_pFontName   = new std::string(fontName);
        m_fFontSize   = fontSize;
        
        this->setStringWithFontInfo(string, bBold, bUnderline);
        
        return true;
    }
    
    return false;
}

bool CCLabelTTF::initWithStringAndTextDefinition(const char *string, ccFontDefinition &textDefinition)
{
    if (CCSprite::init())
    {
        // shader program
        this->setShaderProgram(CCShaderCache::sharedShaderCache()->programForKey(SHADER_PROGRAM));
        
        // prepare everythin needed to render the label
        _updateWithTextDefinition(textDefinition, false);
        
        // set the string
        this->setString(string);
        
        //
        return true;
    }
    else
    {
        return false;
    }
}

void CCLabelTTF::setString(const char *string)
{
    CCAssert(string != NULL, "Invalid string");
    
    if (m_string.compare(string))
    {
        m_string = string;
        
        this->updateTexture();
    }
}

void CCLabelTTF::setStringWithFontInfo(const char* string, bool bBold, bool bUnderline)
{
	CCAssert(string != NULL, "Invalid string");

	if (m_string.compare(string))
	{
		m_string = string;

		this->updateTexture(bBold, bUnderline);
	}
}

const char* CCLabelTTF::getString(void)
{
    return m_string.c_str();
}

const char* CCLabelTTF::description()
{
    return CCString::createWithFormat("<CCLabelTTF | FontName = %s, FontSize = %.1f>", m_pFontName->c_str(), m_fFontSize)->getCString();
}

CCTextAlignment CCLabelTTF::getHorizontalAlignment()
{
    return m_hAlignment;
}

void CCLabelTTF::setHorizontalAlignment(CCTextAlignment alignment)
{
    if (alignment != m_hAlignment)
    {
        m_hAlignment = alignment;
        
        // Force update
        if (m_string.size() > 0)
        {
            this->updateTexture();
        }
    }
}

CCVerticalTextAlignment CCLabelTTF::getVerticalAlignment()
{
    return m_vAlignment;
}

void CCLabelTTF::setVerticalAlignment(CCVerticalTextAlignment verticalAlignment)
{
    if (verticalAlignment != m_vAlignment)
    {
        m_vAlignment = verticalAlignment;
        
        // Force update
        if (m_string.size() > 0)
        {
            this->updateTexture();
        }
    }
}

CCSize CCLabelTTF::getDimensions()
{
    return m_tDimensions;
}

void CCLabelTTF::setDimensions(const CCSize &dim)
{
    if (dim.width != m_tDimensions.width || dim.height != m_tDimensions.height)
    {
        m_tDimensions = dim;
        
        // Force update
        if (m_string.size() > 0)
        {
            this->updateTexture();
        }
    }
}

float CCLabelTTF::getFontSize()
{
    return m_fFontSize;
}

void CCLabelTTF::setFontSize(float fontSize)
{
    if (m_fFontSize != fontSize)
    {
        m_fFontSize = fontSize;
        
        // Force update
        if (m_string.size() > 0)
        {
            this->updateTexture();
        }
    }
}

const char* CCLabelTTF::getFontName()
{
    return m_pFontName->c_str();
}

void CCLabelTTF::setFontName(const char *fontName)
{
    if (m_pFontName->compare(fontName))
    {
        delete m_pFontName;
        m_pFontName = new std::string(fontName);
        
        // Force update
        if (m_string.size() > 0)
        {
            this->updateTexture();
        }
    }
}
//CCTexture2D *CCLabelTTF::getStringTexture(ccColor3B * clr)
//{
//    CCTexture2D *tex;
//    
//    // let system compute label's width or height when its value is 0
//    // refer to cocos2d-x issue #1430
//    tex = new CCTexture2D();
//    if (!tex)
//    {
//		return NULL;
//    }
//    
//    tex->initWithString( m_string.c_str(),
//                        m_pFontName->c_str(),
//                        m_fFontSize * CC_CONTENT_SCALE_FACTOR(),
//                        CC_SIZE_POINTS_TO_PIXELS(m_tDimensions),
//                        m_hAlignment,
//                        m_vAlignment);
//    
//    return tex;
//}


void CCLabelTTF::updateContent()
{

	if (_textSprite)
	{
		CCNode::removeChild(_textSprite, true);
		_textSprite = NULL;
		if (_shadowNode)
		{
			CCNode::removeChild(_shadowNode, true);
			_shadowNode = NULL;
		}

		bSetOpacity = false;
	}
	
	//createSpriteWithFontDefinition();

}

void CCLabelTTF::updateColorTTF()
{
	CCLOG("%s %d: CCLabelTTF::updateColorTTF 1", __FILE__, __LINE__);


	ccColor4B color4;
	color4.r = _displayedColor.r;
	color4.g = _displayedColor.g;
	color4.b = _displayedColor.b;
	color4.a = _displayedOpacity;

	// special opacity for premultiplied textures
	//if (_isOpacityModifyRGB)
	//{
	//	color4.r *= _displayedOpacity / 255.0f;
	//	color4.g *= _displayedOpacity / 255.0f;
	//	color4.b *= _displayedOpacity / 255.0f;
	//}

	cocos2d::CCTextureAtlas* textureAtlas;
	ccV3F_C4B_T2F_Quad *quads;
	
	CCLOG("%s %d: CCLabelTTF::updateColorTTF2", __FILE__, __LINE__);

	if (_textSprite)
	{
		textureAtlas = _textSprite->getTextureAtlas();

		if (textureAtlas)
		{
			CCLOG("%s %d: CCLabelTTF::updateColorTTF3", __FILE__, __LINE__);

			quads = textureAtlas->getQuads();
			int count = textureAtlas->getTotalQuads();

			for (int index = 0; index < count; ++index)
			{
				quads[index].bl.colors = color4;
				quads[index].br.colors = color4;
				quads[index].tl.colors = color4;
				quads[index].tr.colors = color4;
				textureAtlas->updateQuad(&quads[index], index);
			}
		}
	}

	if (_shadowNode)
	{
		cocos2d::CCTextureAtlas* textureAtlas2;
		ccV3F_C4B_T2F_Quad *quads2;

		textureAtlas2 = _shadowNode->getTextureAtlas();

		if (textureAtlas2)
		{
			quads2 = textureAtlas2->getQuads();
			int count2 = textureAtlas2->getTotalQuads();

			for (int index = 0; index < count2; ++index)
			{
				quads2[index].bl.colors = color4;
				quads2[index].br.colors = color4;
				quads2[index].tl.colors = color4;
				quads2[index].tr.colors = color4;
				textureAtlas2->updateQuad(&quads2[index], index);
			}
		}
	}
}


//void CCLabelTTF::updateDisplayedColor(const ccColor3B& parentColor)
//{
//	_displayedColor.r = _realColor.r * parentColor.r / 255.0;
//	_displayedColor.g = _realColor.g * parentColor.g / 255.0;
//	_displayedColor.b = _realColor.b * parentColor.b / 255.0;
//	updateColor();
//
//	if (_textSprite)
//	{
//		_textSprite->updateDisplayedColor(_displayedColor);
//		if (_shadowNode)
//		{
//			_shadowNode->updateDisplayedColor(_displayedColor);
//		}
//	}
//}
//
void CCLabelTTF::updateDisplayedOpacity(GLubyte parentOpacity)
{
	//CCLOG("%s %d: CCLabelTTF::updateDisplayedOpacity 1", __FILE__, __LINE__);

	CCSprite::updateDisplayedOpacity(parentOpacity);

	_displayedOpacity = _realOpacity * parentOpacity / 255.0;
	//updateColor();

	//updateColorTTF();

	if (_textSprite)
	{
		//_textSprite->updateColor();
		//if (_displayedOpacity < 255)
		//{
			updateContent();

			//CCNode::removeAllChildrenWithCleanup(true);
		//}
			
		//CCNode::removeChild(_textSprite);
		//CCNodeRGBA::updateDisplayedOpacity(_displayedOpacity);

		//_textSprite->updateDisplayedOpacity(_displayedOpacity);
		//if (_shadowNode)
		//{

		//	_shadowNode->updateDisplayedOpacity(_displayedOpacity);
		//	//CCNodeRGBA::updateDisplayedOpacity(_displayedOpacity);
		//}
	}

	updateStrokeNode();
	//bSetOpacity = true;
}



void CCLabelTTF::updateShaderProgram()
{
	//setGLServerState(ccGLServerState::CC_GL_ALL);
	//_uniformEffectColor = glGetUniformLocation(getGLProgram()->getProgram(), "u_effectColor");
}
 
void CCLabelTTF::enableOutline(const ccColor4B& outlineColor, int outlineSize /* = -1 */)
{

	ccColor4B _effectColor = outlineColor;
	_effectColorF.r = _effectColor.r / 255.0f;
	_effectColorF.g = _effectColor.g / 255.0f;
	_effectColorF.b = _effectColor.b / 255.0f;
	_effectColorF.a = _effectColor.a / 255.0f;

	if (outlineSize > 0)
	{
		//_outlineSize = outlineSize;
		//if (_currentLabelType == LabelType::TTF)
		//{
		//	if (_fontConfig.outlineSize != outlineSize)
		//	{
		//		auto config = _fontConfig;
		//		config.outlineSize = outlineSize;
		//		setTTFConfig(config);
				updateShaderProgram();
		//	}
		//}

		//_currLabelEffect = LabelEffect::OUTLINE;
		//_contentDirty = true;
	}
}

void CCLabelTTF::setPosition(const CCPoint& pos)
{
	CCSprite::setPosition(pos);

	if (_displayedOpacity <= 100)
	{

		updateStrokeNode();
	}

}

void CCLabelTTF::updateStrokeNode()
{

	//clear node
	if (_strokeTextNode)
	{
		CCNode::removeChild(_strokeTextNode, true);
		_strokeTextNode = NULL;
	}

	if (_strokeNode1)
	{
		CCNode::removeChild(_strokeNode1, true);
		_strokeNode1 = NULL;
	}

	if (_strokeNode2)
	{
		CCNode::removeChild(_strokeNode2, true);
		_strokeNode2 = NULL;
	}

	if (_strokeNode3)
	{
		CCNode::removeChild(_strokeNode3, true);
		_strokeNode3 = NULL;
	}

	if (_strokeNode4)
	{
		CCNode::removeChild(_strokeNode4, true);
		_strokeNode4 = NULL;
	}
}

void CCLabelTTF::drawStroke(CCTexture2D *tex)
{
	//return;
	updateStrokeNode();

	//if (_displayedOpacity < 255) return;

	//CCSLEEP(1000);

	CCPoint pt1(0, 0);
	_strokeTextNode = CCSprite::createWithTexture(tex);
	_strokeTextNode->setAnchorPoint(pt1);
	this->setContentSize(_strokeTextNode->getContentSize());
	CCNode::addChild(_strokeTextNode, 4, 0x99);

	_strokeTextNode->updateDisplayedColor(_displayedColor);
	//_strokeTextNode->updateDisplayedOpacity(_displayedOpacity);
	
	m_strokeSize = 1.0;
	//up
	_strokeNode1 = CCSprite::createWithTexture(tex);
	_strokeNode1->setAnchorPoint(pt1);
	_strokeNode1->setColor(ccBLACK);
	//_strokeNode1->setOpacity(m_shadowOpacity * _displayedOpacity);
	_strokeNode1->setPosition(0,  m_strokeSize);
	//_strokeNode1->setPosition(m_shadowOffset.width, m_shadowOffset.height + m_strokeSize);
	CCNode::addChild(_strokeNode1, 0, 0x100);

	CCLOG("%f %f %f: CCLabelTTF::drawStroke 3", _strokeTextNode->getContentSize().width, _strokeTextNode->getContentSize().height, m_strokeSize);
	
	_strokeNode2 = CCSprite::createWithTexture(tex);
	_strokeNode2->setAnchorPoint(pt1);
	_strokeNode2->setColor(ccBLACK);
	//_strokeNode2->setOpacity(m_shadowOpacity * _displayedOpacity);
	_strokeNode2->setPosition(0, -m_strokeSize);
	//_strokeNode2->setPosition(m_shadowOffset.width, m_shadowOffset.height - m_strokeSize);
	CCNode::addChild(_strokeNode2, 1, 0x101);

	//CCLOG("%f %f %f: CCLabelTTF::drawStroke 2", _strokeTextNode->getContentSize().width, _strokeTextNode->getContentSize().height, m_strokeSize);


	//left
	_strokeNode3 = CCSprite::createWithTexture(tex);
	_strokeNode3->setAnchorPoint(pt1);
	_strokeNode3->setColor(ccBLACK);
	//_strokeNode3->setOpacity(m_shadowOpacity * _displayedOpacity);
	_strokeNode3->setPosition( - m_strokeSize, 0 );
	//_strokeNode3->setPosition(m_shadowOffset.width - m_strokeSize, m_shadowOffset.height);
	CCNode::addChild(_strokeNode3, 2, 0x102);

	//CCLOG("%f %f %f: CCLabelTTF::drawStroke 3", _strokeTextNode->getContentSize().width, _strokeTextNode->getContentSize().height, m_strokeSize);

	_strokeNode4 = CCSprite::createWithTexture(tex);
	_strokeNode4->setAnchorPoint(pt1);
	_strokeNode4->setColor(ccBLACK);
	//_strokeNode4->setOpacity(m_shadowOpacity * _displayedOpacity);
	_strokeNode4->setPosition(m_strokeSize, 0);
	//_strokeNode4->setPosition(m_shadowOffset.width + m_strokeSize, m_shadowOffset.height);
	CCNode::addChild(_strokeNode4, 3, 0x103);

	//CCLOG("%f %f %f: CCLabelTTF::drawStroke 4", _strokeTextNode->getContentSize().width, _strokeTextNode->getContentSize().height, m_strokeSize);

	if (_strokeNode4)
	{
		_strokeNode4->visit();
	}
	if (_strokeNode3)
	{
		_strokeNode3->visit();
	}
	if (_strokeNode2)
	{
		_strokeNode2->visit();
	}
	if (_strokeNode1)
	{
		_strokeNode1->visit();
	}


	if (_strokeTextNode)
	{
		_strokeTextNode->visit();
	}
}


// Helper
bool CCLabelTTF::updateTexture(bool bBold /*= false*/, bool bUnderline /*= false*/)
{
	CCTexture2D *tex;
	tex = new CCTexture2D();

	if (!tex)
		return false;

#ifdef ENABLE_TEXT_SHADOW_AND_STROKE

	ccFontDefinition texDef = _prepareTextDefinition(true);
	tex->initWithString(m_string.c_str(), &texDef);

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) || (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	//CCLOGERROR("updateTexture shadow:2");

	updateStrokeNode();

	//添加阴影层m_shadowEnabled
	if (m_shadowEnabled)
	{
		updateContent();

//		CCLOG("%s %d: CCLabelTTF::updateTexture 5", __FILE__, __LINE__);

		//if(_displayedOpacity==255)
		//{
			CCPoint pt1(0, 0);	
			_textSprite = CCSprite::createWithTexture(tex);
			_textSprite->setAnchorPoint(pt1);
			this->setContentSize(_textSprite->getContentSize());
			CCNode::addChild(_textSprite, 1, -1);
			
			_textSprite->updateDisplayedColor(_displayedColor);
			_textSprite->updateDisplayedOpacity(_displayedOpacity);

			_textSprite->setCascadeOpacityEnabled(true);

			_shadowNode = CCSprite::createWithTexture(tex);
			if (_shadowNode)
			{
				_shadowNode->setCascadeOpacityEnabled(true);
				_shadowNode->setAnchorPoint(pt1);
				_shadowNode->setColor(ccBLACK);
				_shadowNode->setOpacity(m_shadowOpacity * _displayedOpacity);
				_shadowNode->setPosition(m_shadowOffset.width, 0);
				CCNode::addChild(_shadowNode, 0, -1);
			}

			if (_shadowNode)
			{
				_shadowNode->visit();
			}

			_textSprite->visit();
		//}
	}

	if (m_strokeEnabled)
	{
		//CCLOG("%s %d: CCLabelTTF::updateTexture m_strokeEnabled", __FILE__, __LINE__);

		ccColor4B color4;
		color4.r = m_strokeColor.r;
		color4.g = m_strokeColor.g;
		color4.b = m_strokeColor.b;
		color4.a = _displayedOpacity;

		enableOutline(color4,m_strokeSize);
		drawStroke(tex);
	}
#endif

#else
    
    tex->initWithString( m_string.c_str(),
                        m_pFontName->c_str(),
                        m_fFontSize * CC_CONTENT_SCALE_FACTOR(),
                        CC_SIZE_POINTS_TO_PIXELS(m_tDimensions),
                        m_hAlignment,
                        m_vAlignment);
    
#endif
    
    // set the texture
    this->setTexture(tex);
    // release it
    tex->release();
    
    // set the size in the sprite
    CCRect rect =CCRectZero;
    rect.size   = m_pobTexture->getContentSize();
    this->setTextureRect(rect);

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	/*Ray 还有许多细节要处理暂时屏蔽
	if (texDef.m_stroke.m_strokeEnabled)
	{
		CCGLProgram *program = CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColorBlur);
		GLint blurSizeLocation = glGetUniformLocation(program->getProgram(), kCCUniformBlurSize_s);
		CHECK_GL_ERROR_DEBUG();
		program->use();
		CHECK_GL_ERROR_DEBUG();
		program->setUniformLocationWith2f(blurSizeLocation, 1.0f / rect.size.width * texDef.m_stroke.m_strokeSize, 1.0f / rect.size.height * texDef.m_stroke.m_strokeSize);
		CHECK_GL_ERROR_DEBUG();
		this->setShaderProgram(program);
	}*/
#endif
    //ok
    return true;
}





void CCLabelTTF::enableShadow(ccColor3B tintColor, const CCSize &shadowOffset, float shadowOpacity, float shadowBlur, bool updateTexture)
{
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
    
    bool valueChanged = false;
    
    if (false == m_shadowEnabled)
    {
        m_shadowEnabled = true;
        valueChanged    = true;
    }
    
    if ( (m_shadowOffset.width != shadowOffset.width) || (m_shadowOffset.height!=shadowOffset.height) )
    {
        m_shadowOffset.width  = shadowOffset.width;
        m_shadowOffset.height = shadowOffset.height;
        
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
        m_shadowOffset.width = m_shadowOffset.width/2.0f;
        m_shadowOffset.height = m_shadowOffset.height/2.0f;
#endif
        valueChanged = true;
    }
    
    if (m_shadowOpacity != shadowOpacity )
    {
        m_shadowOpacity = shadowOpacity;
        valueChanged = true;
    }
    
    if (m_shadowBlur    != shadowBlur)
    {
        m_shadowBlur = shadowBlur;
        valueChanged = true;
    }
    
    if ( (m_shadowColor.r != tintColor.r) || (m_shadowColor.g != tintColor.g) || (m_shadowColor.b != tintColor.b) )
    {
        
		m_shadowColor.r = tintColor.r;
		m_shadowColor.g = tintColor.g;
		m_shadowColor.b = tintColor.b;
		valueChanged = true;

    }
    
    if ( valueChanged && updateTexture )
	//if (true)
    {
        this->updateTexture();
    }



    
#else
    CCLOGERROR("Currently only supported on iOS and Android!");
#endif
    
}

void CCLabelTTF::disableShadow(bool updateTexture)
{
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
    
    if (m_shadowEnabled)
    {
        m_shadowEnabled = false;
        
        if (updateTexture)
            this->updateTexture();
        
    }
    
#else
    CCLOGERROR("Currently only supported on iOS and Android!");
#endif
}

void CCLabelTTF::enableStroke(const ccColor3B &strokeColor, float strokeSize, bool updateTexture)
{
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
    
    bool valueChanged = false;
    
    if(m_strokeEnabled == false)
    {
        m_strokeEnabled = true;
        valueChanged = true;
    }
    
    if ( (m_strokeColor.r != strokeColor.r) || (m_strokeColor.g != strokeColor.g) || (m_strokeColor.b != strokeColor.b) )
    {
        m_strokeColor = strokeColor;
        valueChanged = true;
    }
    
    if (m_strokeSize!=strokeSize)
    {
        m_strokeSize = strokeSize;
        valueChanged = true;
    }
    
    if ( valueChanged && updateTexture )
    {
        this->updateTexture();
    }
    
#else
    CCLOGERROR("Currently only supported on iOS and Android!");
#endif
    
}

void CCLabelTTF::disableStroke(bool updateTexture)
{
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
    
    if (m_strokeEnabled)
    {
        m_strokeEnabled = false;
        
        if (updateTexture)
            this->updateTexture();
    }
    
#else
    CCLOGERROR("Currently only supported on iOS and Android!");
#endif
    
}

void CCLabelTTF::setTextDefinition(ccFontDefinition *theDefinition)
{
    if (theDefinition)
    {
        _updateWithTextDefinition(*theDefinition, true);
    }
}

ccFontDefinition *CCLabelTTF::getTextDefinition()
{
    ccFontDefinition *tempDefinition = new ccFontDefinition;
    *tempDefinition = _prepareTextDefinition(false);
    return tempDefinition;
}

void CCLabelTTF::setFontFillColor(const ccColor3B &tintColor, bool updateTexture)
{
#ifdef ENABLE_TEXT_SHADOW_AND_STROKE
    if (m_textFillColor.r != tintColor.r || m_textFillColor.g != tintColor.g || m_textFillColor.b != tintColor.b)
    {
        m_textFillColor = tintColor;
        
        if (updateTexture)
            this->updateTexture();
    }
#else
    CCLOGERROR("Currently only supported on iOS and Android!");
#endif
}


void CCLabelTTF::_updateWithTextDefinition(ccFontDefinition & textDefinition, bool mustUpdateTexture)
{
    m_tDimensions = CCSizeMake(textDefinition.m_dimensions.width, textDefinition.m_dimensions.height);
    m_hAlignment  = textDefinition.m_alignment;
    m_vAlignment  = textDefinition.m_vertAlignment;
    
    m_pFontName   = new std::string(textDefinition.m_fontName);
    m_fFontSize   = textDefinition.m_fontSize;
    
    
    // shadow
    if ( textDefinition.m_shadow.m_shadowEnabled )
    {
        enableShadow(textDefinition.m_shadow.m_shadowColor, textDefinition.m_shadow.m_shadowOffset, textDefinition.m_shadow.m_shadowOpacity, textDefinition.m_shadow.m_shadowBlur, false);
    }
    
    // stroke
    if ( textDefinition.m_stroke.m_strokeEnabled )
    {
        enableStroke(textDefinition.m_stroke.m_strokeColor, textDefinition.m_stroke.m_strokeSize, false);
    }
    
    // fill color
    setFontFillColor(textDefinition.m_fontFillColor, false);
    
    if (mustUpdateTexture)
        updateTexture();
}

ccFontDefinition CCLabelTTF::_prepareTextDefinition(bool adjustForResolution)
{
    ccFontDefinition texDef;
    
    if (adjustForResolution)
        texDef.m_fontSize       =  m_fFontSize * CC_CONTENT_SCALE_FACTOR();
    else
        texDef.m_fontSize       =  m_fFontSize;
    
    texDef.m_fontName       = *m_pFontName;
    texDef.m_alignment      =  m_hAlignment;
    texDef.m_vertAlignment  =  m_vAlignment;
    
    
    if (adjustForResolution)
        texDef.m_dimensions     =  CC_SIZE_POINTS_TO_PIXELS(m_tDimensions);
    else
        texDef.m_dimensions     =  m_tDimensions;
    
    
    // stroke
    if ( m_strokeEnabled )
    {
        texDef.m_stroke.m_strokeEnabled = true;
        texDef.m_stroke.m_strokeColor   = m_strokeColor;
        
        if (adjustForResolution)
            texDef.m_stroke.m_strokeSize = m_strokeSize * CC_CONTENT_SCALE_FACTOR();
        else
            texDef.m_stroke.m_strokeSize = m_strokeSize;
        
        
    }
    else
    {
        texDef.m_stroke.m_strokeEnabled = false;
    }
    
    
    // shadow
    if ( m_shadowEnabled )
    {
        texDef.m_shadow.m_shadowEnabled         = true;
        texDef.m_shadow.m_shadowBlur            = m_shadowBlur;
        texDef.m_shadow.m_shadowOpacity         = m_shadowOpacity;
        texDef.m_shadow.m_shadowColor.r           = m_shadowColor.r;
        texDef.m_shadow.m_shadowColor.g           = m_shadowColor.g;
        texDef.m_shadow.m_shadowColor.b           = m_shadowColor.b;
        
        if (adjustForResolution)
            texDef.m_shadow.m_shadowOffset = CC_SIZE_POINTS_TO_PIXELS(m_shadowOffset);
        else
            texDef.m_shadow.m_shadowOffset = m_shadowOffset;
    }
    else
    {
        texDef.m_shadow.m_shadowEnabled = false;
    }
    
    // text tint
    texDef.m_fontFillColor = m_textFillColor;
    
    return texDef;
}

void CCLabelTTF::setTextShadowEnabled(bool textShadowEnabled)
{
	this->m_textShadowEnabled=textShadowEnabled;
}

bool CCLabelTTF::getTextShadowEnabled()
{
	return m_textShadowEnabled;
}

void CCLabelTTF::setTextFadeEnabled(bool textFadeEnabled)
{
	this->m_textFadeEnabled=textFadeEnabled;
}

bool CCLabelTTF::getTextFadeEnabled()
{
	return m_textFadeEnabled;
}

void CCLabelTTF::setTextBorderEnabled(bool textBorderEnabled)
{
	this->m_textBorderEnabled=textBorderEnabled;
}
void CCLabelTTF::setShadow(ccColor3B  color, const CCPoint &pt,float shadowBlur)
{
    CCSize shadowOffset ;
    shadowOffset.width = -pt.x;
    shadowOffset.height = -pt.y;
    
    this->enableShadow(color,shadowOffset, 1.0f, shadowBlur);
}

void CCLabelTTF::setStroke(ccColor3B color, float size)
{
    this->enableStroke(color, size);
}
void CCLabelTTF::setTextShadowColor(float _r, float _g, float _b, float _a)
{
	m_shadowColor = ccc4f(_r,_g,_b,_a);
}

void CCLabelTTF::setTextBorderColor(float _r, float _g, float _b, float _a)
{
	m_borderColor = ccc4f(_r,_g,_b,_a);
}

bool CCLabelTTF::getTextBorderEnabled()
{
	return m_textBorderEnabled;
}

void CCLabelTTF::setTextShadowFourDirEnabled(bool fourDirEnable){
	m_textShadowFourDirEnabled = fourDirEnable;
}
bool CCLabelTTF::getTextShadowFourDirEnabled(){
	return m_textShadowFourDirEnabled;
}

void CCLabelTTF::setTexShadowOffset(float shadowOffsetX,float shadowOffsetY){
	m_fShadowOffsetX = shadowOffsetX;
	m_fShadowOffsetY = shadowOffsetY;

}

void CCLabelTTF::setTexShadowOffset2(float shadowOffsetX,float shadowOffsetY){
	m_fShadowOffsetX2 = shadowOffsetX;
	m_fShadowOffsetY2 = shadowOffsetY;

}

void CCLabelTTF::setTexShadowOffset3(float shadowOffsetX,float shadowOffsetY){
	m_fShadowOffsetX3 = shadowOffsetX;
	m_fShadowOffsetY3 = shadowOffsetY;

}

void CCLabelTTF::setTexShadowOffset4(float shadowOffsetX,float shadowOffsetY){
	m_fShadowOffsetX4 = shadowOffsetX;
	m_fShadowOffsetY4 = shadowOffsetY;

}

void CCLabelTTF::setFadeTexture(CCTexture2D * tex){
	if (tex)
	{
		tex->retain();
		if (m_fadeTexture)
		{
			m_fadeTexture->release();
		}
		m_fadeTexture = tex;
		
	}	
}

void CCLabelTTF::setTextFadeImageURL(std::string fadeImageUrl)
{
	this->m_textFadeEnabled=true;
	this->m_textFadeImageURL=fadeImageUrl;

	if (m_fadeTexture)
	{
		m_fadeTexture->release();
	}
	m_fadeTexture = CCTextureCache::sharedTextureCache()->addImage(m_textFadeImageURL.c_str());
	m_fadeTexture->retain();
}

void CCLabelTTF::renderShadow(void)
{
	CCTextShadowSH t_shader_helper(CCShaderCache::sharedShaderCache()->programForKey(SHADER_TEXT_SHADOW));
	t_shader_helper.init();
	t_shader_helper.setColor(m_shadowColor.r,m_shadowColor.g,m_shadowColor.b,m_shadowColor.a);
	float offsetx = m_fShadowOffsetX/m_pobTexture->getPixelsWide();
	float offsety = m_fShadowOffsetY/m_pobTexture->getPixelsWide();
	t_shader_helper.setOff(offsetx,offsety);
	t_shader_helper.begin();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	CC_INCREMENT_GL_DRAWS(1);
	
	//four direction offset to mimic the bord effect
	if (m_textShadowFourDirEnabled)
	{
 		offsetx = m_fShadowOffsetX2/m_pobTexture->getPixelsWide();
		offsety = m_fShadowOffsetY2/m_pobTexture->getPixelsWide();
		t_shader_helper.setOff(offsetx,offsety);
		t_shader_helper.begin();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		offsetx = m_fShadowOffsetX3/m_pobTexture->getPixelsWide();
		offsety = m_fShadowOffsetY3/m_pobTexture->getPixelsWide();
		t_shader_helper.setOff(offsetx,offsety);
		t_shader_helper.begin();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		offsetx = m_fShadowOffsetX4/m_pobTexture->getPixelsWide();
		offsety = m_fShadowOffsetY4/m_pobTexture->getPixelsWide();
		t_shader_helper.setOff(offsetx,offsety);
		t_shader_helper.begin();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		CC_INCREMENT_GL_DRAWS(3);
	}
	t_shader_helper.end();

	CCShaderHelper t_ori_shader(CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor));
	t_ori_shader.init();
	t_ori_shader.begin();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	t_ori_shader.end();
	CC_INCREMENT_GL_DRAWS(1);
}

void CCLabelTTF::renderFade(void)
{
	CCTextFadeSH t_shader_helper(CCShaderCache::sharedShaderCache()->programForKey(kCCShader_Text_Fade));
	t_shader_helper.init();
	t_shader_helper.setSrcTexture(m_pobTexture);
	t_shader_helper.setFadeTexture(m_fadeTexture);
	t_shader_helper.begin();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	t_shader_helper.end();
	CC_INCREMENT_GL_DRAWS(1);
}

void CCLabelTTF::renderBorder(void)
{
	CCTextBorderSH tshaderHelper(CCShaderCache::sharedShaderCache()->programForKey(kCCShader_Text_Border));
	tshaderHelper.init();
	static float tAlph = 0.0;
	tshaderHelper.setBorderColor(m_borderColor.r,m_borderColor.g,m_borderColor.b,tAlph);
	tshaderHelper.setBorderWidth(1.0/512.0,1.0/512.0);
	tAlph+= 0.0005;
	if(tAlph>1.0)
		tAlph = 0.0;
	tshaderHelper.begin();

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	tshaderHelper.end();
	CC_INCREMENT_GL_DRAWS(1);
}

void CCLabelTTF::draw(void)
{
	CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");

	CCAssert(!m_pobBatchNode, "If CCSprite is being rendered by CCSpriteBatchNode, CCSprite#draw SHOULD NOT be called");

	CC_NODE_DRAW_SETUP();

	ccGLBlendFunc(m_sBlendFunc.src, m_sBlendFunc.dst);

	if(m_pobTexture)
		ccGLBindTexture2D(m_pobTexture->getName());
	ccGLEnableVertexAttribs(kCCVertexAttribFlag_PosColorTex);

#define kQuadSize sizeof(m_sQuad.bl)
#ifdef EMSCRIPTEN
	long offset = 0;
	setGLBufferData(&m_sQuad, 4 * kQuadSize, 0);
#else
	long offset = (long)&m_sQuad;
#endif // EMSCRIPTEN

	// vertex
	int diff = offsetof(ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));

	// texCoods
	diff = offsetof(ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));

	// color
	diff = offsetof(ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));

	//right now, turn off the border effect since the result is not good enough, using four direction shadow instead by zhenhui
	if(m_textBorderEnabled && false)
	{
		renderBorder();
	}

	if (m_textShadowEnabled)
	{
		renderShadow();

	}

	if (m_textFadeEnabled)
	{
		renderFade();
	}

	

	if(!m_textShadowEnabled&&!m_textFadeEnabled&&!m_textBorderEnabled)
	{
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		CC_INCREMENT_GL_DRAWS(1);
	}

	CHECK_GL_ERROR_DEBUG();


#if CC_SPRITE_DEBUG_DRAW == 1
	// draw bounding box
	CCPoint vertices[4] = {
		ccp(m_sQuad.tl.vertices.x, m_sQuad.tl.vertices.y),
		ccp(m_sQuad.bl.vertices.x, m_sQuad.bl.vertices.y),
		ccp(m_sQuad.br.vertices.x, m_sQuad.br.vertices.y),
		ccp(m_sQuad.tr.vertices.x, m_sQuad.tr.vertices.y),
	};
	ccDrawPoly(vertices, 4, true);
	CC_INCREMENT_GL_DRAWS(1);
#elif CC_SPRITE_DEBUG_DRAW == 2
	// draw texture box
	CCSize s = this->getTextureRect().size;
	CCPoint offsetPix = this->getOffsetPosition();
	CCPoint vertices[4] = {
		ccp(offsetPix.x, offsetPix.y), ccp(offsetPix.x + s.width, offsetPix.y),
		ccp(offsetPix.x + s.width, offsetPix.y + s.height), ccp(offsetPix.x, offsetPix.y + s.height)
	};
	ccDrawPoly(vertices, 4, true);
	CC_INCREMENT_GL_DRAWS(1);
#endif // CC_SPRITE_DEBUG_DRAW


	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");
}

NS_CC_END

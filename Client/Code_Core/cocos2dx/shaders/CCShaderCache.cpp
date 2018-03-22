/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Ricardo Quesada
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

#include "CCShaderCache.h"
#include "CCGLProgram.h"
#include "ccMacros.h"
#include "ccShaders.h"
#include "platform/CCFileUtils.h"
#include "HeroFileUtils.h"
NS_CC_BEGIN

enum {
    kCCShaderType_PositionTextureColor,
    kCCShaderType_PositionTextureColorAlphaTest,
    kCCShaderType_PositionColor,
    kCCShaderType_PositionTexture,
    kCCShaderType_PositionTexture_uColor,
    kCCShaderType_PositionTextureA8Color,
    kCCShaderType_Position_uColor,
    kCCShaderType_PositionLengthTexureColor,
	kCCShaderType_PositionTextureColorBlur,
    kCCShaderType_ControlSwitch,
	kCCShaderType_ShaderTextShadow,
	kCCShaderType_ShaderTextFade,
	kCCShaderType_ShaderTextBorder,
	kCCShaderType_ShaderBlur,
	kCCShaderType_ShaderBMFontFade,
	kCCShaderType_ShaderInverseColor,
    kCCShaderType_MAX,
};

static CCShaderCache *_sharedShaderCache = 0;

CCShaderCache* CCShaderCache::sharedShaderCache()
{
    if (!_sharedShaderCache) {
        _sharedShaderCache = new CCShaderCache();
        if (!_sharedShaderCache->init())
        {
            CC_SAFE_DELETE(_sharedShaderCache);
        }
        
    }
    return _sharedShaderCache;
}

void CCShaderCache::purgeSharedShaderCache()
{
    CC_SAFE_RELEASE_NULL(_sharedShaderCache);
}

CCShaderCache::CCShaderCache()
: m_pPrograms(0)
{

}

CCShaderCache::~CCShaderCache()
{
    CCLOGINFO("cocos2d deallocing 0x%X", this);
    m_pPrograms->release();
}

bool CCShaderCache::init()
{
    m_pPrograms = new CCDictionary();
    loadDefaultShaders();
    return true;
}

void CCShaderCache::loadDefaultShaders()
{
    // Position Texture Color shader
    CCGLProgram *p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionTextureColor);

    m_pPrograms->setObject(p, kCCShader_PositionTextureColor);
    p->release();

    // Position Texture Color alpha test
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionTextureColorAlphaTest);

    m_pPrograms->setObject(p, kCCShader_PositionTextureColorAlphaTest);
    p->release();

	// Position Texture Color Blur
	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_PositionTextureColorBlur);

	m_pPrograms->setObject(p, kCCShader_PositionTextureColorBlur);
	p->release();

    //
    // Position, Color shader
    //
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionColor);

    m_pPrograms->setObject(p, kCCShader_PositionColor);
    p->release();

    //
    // Position Texture shader
    //
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionTexture);

    m_pPrograms->setObject(p, kCCShader_PositionTexture);
    p->release();

    //
    // Position, Texture attribs, 1 Color as uniform shader
    //
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionTexture_uColor);

    m_pPrograms->setObject(p ,kCCShader_PositionTexture_uColor);
    p->release();

    //
    // Position Texture A8 Color shader
    //
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionTextureA8Color);
    
    m_pPrograms->setObject(p, kCCShader_PositionTextureA8Color);
    p->release();

    //
    // Position and 1 color passed as a uniform (to simulate glColor4ub )
    //
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_Position_uColor);
    
    m_pPrograms->setObject(p, kCCShader_Position_uColor);
    p->release();
    
    //
	// Position, Legth(TexCoords, Color (used by Draw Node basically )
	//
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_PositionLengthTexureColor);
    
    m_pPrograms->setObject(p, kCCShader_PositionLengthTexureColor);
    p->release();

    //
	// ControlSwitch
	//
    p = new CCGLProgram();
    loadDefaultShader(p, kCCShaderType_ControlSwitch);
    
    m_pPrograms->setObject(p, kCCShader_ControlSwitch);
    p->release();

	//
	// ShaderTextShadow
	//
	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderTextShadow);

	m_pPrograms->setObject(p, kCCShader_Text_Shadow);
	p->release();

	//
	// ShaderTextFade
	//
	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderTextFade);
	m_pPrograms->setObject(p, kCCShader_Text_Fade);
	p->release();

	//
	// ShaderTextBorder
	//
	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderTextBorder);
	m_pPrograms->setObject(p, kCCShader_Text_Border);
	p->release();

	//
	// ShaderBlur
	//
	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderBlur);
	m_pPrograms->setObject(p, kCCShader_Blur);
	p->release();


	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderBMFontFade);
	m_pPrograms->setObject(p, kCCShader_Text_Bmfont_fade);
	p->release();

	p = new CCGLProgram();
	loadDefaultShader(p, kCCShaderType_ShaderInverseColor);
	m_pPrograms->setObject(p, kCCShader_Inverse_Color);
	p->release();


}

void CCShaderCache::reloadDefaultShaders()
{
    // reset all programs and reload them
    
    // Position Texture Color shader
    CCGLProgram *p = programForKey(kCCShader_PositionTextureColor);    
    p->reset();
    loadDefaultShader(p, kCCShaderType_PositionTextureColor);

    // Position Texture Color alpha test
    p = programForKey(kCCShader_PositionTextureColorAlphaTest);
    p->reset();    
    loadDefaultShader(p, kCCShaderType_PositionTextureColorAlphaTest);

	// Position Texture Color Blur
	p = programForKey(kCCShader_PositionTextureColorBlur);
	p->reset();
	loadDefaultShader(p, kCCShaderType_PositionTextureColorBlur);
    
    //
    // Position, Color shader
    //
    p = programForKey(kCCShader_PositionColor);
    p->reset();
    loadDefaultShader(p, kCCShaderType_PositionColor);
    
    //
    // Position Texture shader
    //
    p = programForKey(kCCShader_PositionTexture);
    p->reset();
    loadDefaultShader(p, kCCShaderType_PositionTexture);
    
    //
    // Position, Texture attribs, 1 Color as uniform shader
    //
    p = programForKey(kCCShader_PositionTexture_uColor);
    p->reset();
    loadDefaultShader(p, kCCShaderType_PositionTexture_uColor);
    
    //
    // Position Texture A8 Color shader
    //
    p = programForKey(kCCShader_PositionTextureA8Color);
    p->reset();
    loadDefaultShader(p, kCCShaderType_PositionTextureA8Color);
    
    //
    // Position and 1 color passed as a uniform (to simulate glColor4ub )
    //
    p = programForKey(kCCShader_Position_uColor);
    p->reset();
    loadDefaultShader(p, kCCShaderType_Position_uColor);
    
    //
	// Position, Legth(TexCoords, Color (used by Draw Node basically )
	//
    p = programForKey(kCCShader_PositionLengthTexureColor);
    p->reset();
    loadDefaultShader(p, kCCShaderType_Position_uColor);
    
    for(ShaderSourceMapIter it = m_sourceMap.begin();it!=m_sourceMap.end();it++)
    {
        p = programForKey(it->first.c_str());
        if(p)
        {
            p->reset();
            loadAutoReloadingProgram(p, it->first.c_str());
        }
    }
}

void CCShaderCache::loadDefaultShader(CCGLProgram *p, int type)
{
    switch (type) {
        case kCCShaderType_PositionTextureColor:
            p->initWithVertexShaderByteArray(ccPositionTextureColor_vert, ccPositionTextureColor_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
            
            break;
        case kCCShaderType_PositionTextureColorAlphaTest:
            p->initWithVertexShaderByteArray(ccPositionTextureColor_vert, ccPositionTextureColorAlphaTest_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

            break;
		case kCCShaderType_PositionTextureColorBlur:
			p->initWithVertexShaderByteArray(ccPositionTextureColorBlur_vert, ccPositionTextureColorBlur_frag);

			p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
			p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
			p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

			break;
        case kCCShaderType_PositionColor:  
            p->initWithVertexShaderByteArray(ccPositionColor_vert ,ccPositionColor_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);

            break;
        case kCCShaderType_PositionTexture:
            p->initWithVertexShaderByteArray(ccPositionTexture_vert ,ccPositionTexture_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

            break;
        case kCCShaderType_PositionTexture_uColor:
            p->initWithVertexShaderByteArray(ccPositionTexture_uColor_vert, ccPositionTexture_uColor_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

            break;
        case kCCShaderType_PositionTextureA8Color:
            p->initWithVertexShaderByteArray(ccPositionTextureA8Color_vert, ccPositionTextureA8Color_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

            break;
        case kCCShaderType_Position_uColor:
            p->initWithVertexShaderByteArray(ccPosition_uColor_vert, ccPosition_uColor_frag);    
            
            p->addAttribute("aVertex", kCCVertexAttrib_Position);    
            
            break;
        case kCCShaderType_PositionLengthTexureColor:
            p->initWithVertexShaderByteArray(ccPositionColorLengthTexture_vert, ccPositionColorLengthTexture_frag);
            
            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
            
            break;

       case kCCShaderType_ControlSwitch:
            p->initWithVertexShaderByteArray(ccPositionTextureColor_vert, ccExSwitchMask_frag);

            p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
            p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
            p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

            break;

	   case kCCShaderType_ShaderTextShadow:
		   p->initWithVertexShaderByteArray(shader_text_shadow_vert, shader_text_shadow_frag);

		   p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		   p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		   p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		   
		   break;

	   case kCCShaderType_ShaderTextFade:
		   p->initWithVertexShaderByteArray(shader_text_fade_vert, shader_text_fade_frag);

		   p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		   p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		   p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

		   break;
	   case kCCShaderType_ShaderTextBorder:
		   p->initWithVertexShaderByteArray(shader_text_border_vert, shader_text_border_frag);

		   p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		   p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		   p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		   
		   break;

		case kCCShaderType_ShaderBlur:
		   p->initWithVertexShaderByteArray(shader_blur_vert, shader_blur_frag);

		   p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		   p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		   
		   break;
		 case kCCShaderType_ShaderBMFontFade:
		   p->initWithVertexShaderByteArray(shader_text_bmfont_fade_vert, shader_text_bmfont_fade_frag);

		   p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		   p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		   p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		    p->addAttribute(kCCAttributeNameTexCoord2, kCCVertexAttrib_TexCoords2);
			p->addAttribute(kCCAttributeNameTexCoord3, kCCVertexAttrib_TexCoords3);
		   break;
		 case kCCShaderType_ShaderInverseColor:
			 p->initWithVertexShaderByteArray(shader_inverse_color_vert, shader_inverse_color_frag);
			 p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
			 p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);

			 break;
        default:
            CCLOG("cocos2d: %s:%d, error shader type", __FUNCTION__, __LINE__);
            return;
    }
    
    p->link();
    p->updateUniforms();
    
    CHECK_GL_ERROR_DEBUG();
}

CCGLProgram* CCShaderCache::programForKey(const char* key)
{
    return (CCGLProgram*)m_pPrograms->objectForKey(key);
}

void CCShaderCache::addProgram(CCGLProgram* program, const char* key)
{
    m_pPrograms->setObject(program, key);
}


void CCShaderCache::addAutoReloadingProgram(const char  * name, const char  * vsh, const char  * fsh)
{
    //文件查找 后面需要统一，以及文件名加密
#if 1 //(CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    std::string fullPathVsh = LegendFindFileCpp(vsh);
    std::string fullPathFsh =LegendFindFileCpp(fsh);
#else
    std::string fullPathVsh = CCFileUtils::sharedFileUtils()->fullPathForFilename(vsh,true,true,false);
	std::string fullPathFsh = CCFileUtils::sharedFileUtils()->fullPathForFilename(fsh, true, true, false);
#endif

    CCString * vshStr = CCString::createWithContentsOfFile(fullPathVsh.c_str());
    CCString * fshStr = CCString::createWithContentsOfFile(fullPathFsh.c_str());
    ShaderSource src ;
    src.vsh = vshStr->m_sString;
    vshStr->release();
    src.fsh = fshStr->m_sString;
    fshStr->release();
    
    std::string tname = name;
    m_sourceMap[tname] = src;
    
    CCGLProgram *pg = new CCGLProgram();
    loadAutoReloadingProgram(pg,name);
    this->addProgram(pg, name);
    
}

void CCShaderCache::loadAutoReloadingProgram(CCGLProgram * pg, const char  * name)
{
    ShaderSourceMapIter it = m_sourceMap.find(name);
    if(it == m_sourceMap.end())
        return;
    
    pg->initWithVertexShaderByteArray(it->second.vsh.c_str(), it->second.fsh.c_str());
	pg->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
	pg->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
	pg->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
    pg->link();
    pg->updateUniforms();
    if(glGetError())
    {
        CCLOG("loadDefaultShader %s failed %d",name,glGetError());
    }
    
}


NS_CC_END

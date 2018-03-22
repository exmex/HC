#ifndef __CCTextFadeSH_H__
#define __CCTextFadeSH_H__

#include "CCShaderHelper.h"

NS_CC_BEGIN

//主要是配合 Shader Program使用 来提供丰富多彩的Shader

class CCGLProgram;
class CCTexture2D;

class CC_DLL CCTextFadeSH : public CCShaderHelper
{
public:

	CCTextFadeSH(CCGLProgram* _program);

	virtual ~CCTextFadeSH();

	virtual void init();
	virtual void begin();
	virtual void end();

	void setSrcTexture(CCTexture2D* _tex);
	void setFadeTexture(CCTexture2D* _tex);

protected:
	int s_src_tex;
	int s_fade_tex;

protected:
	CCTexture2D* m_SrcTex;
	CCTexture2D* m_FadeTex;
};


NS_CC_END

#endif /* __CCTextFadeSH_H__ */

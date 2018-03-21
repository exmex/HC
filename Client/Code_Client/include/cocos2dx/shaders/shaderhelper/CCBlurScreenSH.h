#ifndef __CCBLURSCREEN_H__
#define __CCBLURSCREEN_H__

#include "CCShaderHelper.h"

NS_CC_BEGIN

//主要是配合 Shader Program使用 来提供丰富多彩的Shader

class CCTexture2D;
class CCGLProgram;

class CC_DLL CCBlurScreenSH : public CCShaderHelper
{
public:

	CCBlurScreenSH(CCGLProgram* _program);

	virtual ~CCBlurScreenSH();

	virtual void init();
	virtual void begin();
	virtual void end();

	void setSubStract(float _x,float _y,float _z,float _w);
	void setBlursize(float _blur_x,float _blur_y);
	void setBlurTexture(CCTexture2D* _tex);

protected:
	int uni_blursize;
	int uni_substract;
	int s_Tex0;

protected:
	float substract_x;
	float substract_y;
	float substract_z;
	float substract_w;

	float blursize_x;
	float blursize_y;

	CCTexture2D* m_BlurTex;
};


NS_CC_END

#endif /* __CCBLURSCREEN_H__ */

#ifndef __CCTextShadowSH_H__
#define __CCTextShadowSH_H__

#include "CCShaderHelper.h"

NS_CC_BEGIN

//主要是配合 Shader Program使用 来提供丰富多彩的Shader

class CCGLProgram;

class CC_DLL CCTextShadowSH : public CCShaderHelper
{
public:

	CCTextShadowSH(CCGLProgram* _program);

	virtual ~CCTextShadowSH();

	virtual void init();
	virtual void begin();
	virtual void end();

	void setColor(float _r,float _g,float _b,float _a);
	void setOff(float _off_x,float _off_y);

protected:
	int uni_color;
	int uni_offset;

protected:
	float color_r;
	float color_g;
	float color_b;
	float color_a;

	float off_x;
	float off_y;

};


NS_CC_END

#endif /* __CCTextShadowSH_H__ */

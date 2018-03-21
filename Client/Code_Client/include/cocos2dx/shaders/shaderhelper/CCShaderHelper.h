#ifndef __CCSHADERHELPER_H__
#define __CCSHADERHELPER_H__

#include "cocoa/CCObject.h"

NS_CC_BEGIN

//主要是配合 Shader Program使用 来提供丰富多彩的Shader

class CCGLProgram;

class CC_DLL CCShaderHelper : public CCObject
{
public:

	CCShaderHelper(CCGLProgram* _program);

	virtual ~CCShaderHelper();

	virtual void init();
	virtual void begin();
	virtual void end();

protected:
	CCGLProgram* m_Program;
};


NS_CC_END

#endif /* __CCSHADERHELPER_H__ */
